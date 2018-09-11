//
//  LessonService.swift
//  Keystone Park
//
//  Created by Jason Sanchez on 9/11/18.
//  Copyright © 2018 Jason Sanchez. All rights reserved.
//

import Foundation
import CoreData

enum LessonType: String {
    case ski
    case snowboard
}

typealias StudentHandler = (Bool, [Student]) -> ()

class LessonService {
    private let moc: NSManagedObjectContext
    private var students = [Student]()
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    // MARK: - Public
    
    // READ
    func getAllStudents() -> [Student]? {
        let sortByLesson = NSSortDescriptor(key: "lesson.type", ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        let sortDescriptors = [sortByLesson, sortByName]
        
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        request.sortDescriptors = sortDescriptors
        
        do {
            students = try moc.fetch(request)
            return students
        }
        catch let error as NSError {
            print("Error fetching students: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    // CREATE
    
    func addStudent(name: String, for type: LessonType, completion: StudentHandler) {
        let student = Student(context: moc)
        student.name = name
        
        if let lesson = lessonExists(type) {
            register(student, for: lesson)
            students.append(student)
            
            completion(true, students)
        }
        
        save()
    }
    
    // UPDATE
    
    func update(currentStudent student: Student, withName name: String, forLesson lesson: String) {
        // Check if student current lesson == new lesson type
        if student.lesson?.type?.caseInsensitiveCompare(lesson) == .orderedSame {
            let lesson = student.lesson
            let studentsList = Array(lesson?.students?.mutableCopy() as! NSMutableSet) as! [Student]
            
            if let index = studentsList.index(where: { $0 == student }) {
                studentsList[index].name = name
                lesson?.students = NSSet(array: studentsList)
            }
        }
        else {
            if let lesson = lessonExists(LessonType(rawValue: lesson)!) {
                lesson.removeFromStudents(student)
                
                student.name = name
                register(student, for: lesson)
            }
        }
        
        save()
    }
    
    // MARK: - Private
    
    private func lessonExists(_ type: LessonType) -> Lesson? {
        let request: NSFetchRequest<Lesson> = Lesson.fetchRequest()
        request.predicate = NSPredicate(format: "type = %@", type.rawValue)
        
        var lesson: Lesson?
        
        do {
            let result = try moc.fetch(request)
            lesson = result.isEmpty ? addNew(lesson: type) : result.first
        } catch let error as NSError {
            print("Error getting lesson: \(error.localizedDescription)")
        }
        
        return lesson
    }
    
    private func addNew(lesson type: LessonType) -> Lesson {
        let lesson = Lesson(context: moc)
        lesson.type = type.rawValue
        
        return lesson
        
    }
    
    private func register(_ student: Student, for lesson: Lesson) {
        student.lesson = lesson
    }
    
    private func save() {
        do {
            try moc.save()
        }
        catch let error as NSError {
            print("Save failed: \(error.localizedDescription)")
        }
    }
}