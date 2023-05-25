//
//  DBHelper.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/04.
//

/*
import Foundation

import SQLite3

class DBHelper {
    static let shared = DBHelper()
    
    var db: OpaquePointer?
    let databaseName = "mydb.sqlite"
    
    init() {
        self.db = createDB()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func createDB() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        do {
            let dbPath: String = try FileManager.default.url(for: .documentDirectory,
                                                             in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false).appendingPathComponent(databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK {
                print("디비가 잘 생성되었고 그 패스는 : \(dbPath)")
                return db
            }
        } catch {
            print("db create 중 에러발생: \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: - create table
    
    func createTable() {
        let query = """
CREATE TABLE IF NOT EXISTS myTable(
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT NOT NULL
date TEXT NOT NULL
duration INTEGER NOT NULL
context TEXT NOT NULL
forderName TEXT NOT NULL);
"""
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("creating table has been successfully done.db: \(String(describing: self.db))")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating table: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
            
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - insert data
    func insertData(title: String) {
        let insertQuery = "insert into myTable (id, title) values (?,?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 6, title, -1, nil)
        } else {
            print("sqlite binding failure")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("sqlite insertiong success")
        } else {
            print("sqlite step failure")
        }
    }
    
    // MARK: - read data
    
    func readData() -> [Item] {
        let query: String = "select *from myTable"
        var statement: OpaquePointer? = nil
        var result: [Item] = []
        
        if sqlite3_prepare(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let errorMessage = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(errorMessage)")
            return result
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            
            let title = String(cString: sqlite3_column_text(statement, 1))
            let
            result.append(Item(folderName: "", id: Int(id), title: String(title)))
            
        }
        sqlite3_finalize(statement)
        
        return result
    }
    
    // MARK: - update data
    
    func updateData(id: Int, title: String) {
        var statement: OpaquePointer?
        
        let queryString = "UPDATEmyTable SET title='\(title)' WHERE id==\(id)"
        
        // 쿼리 준비
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        // 쿼리 실행
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        print("update has been sucessfully done")
    }
    
    // MARK: - delete data
    
    func deleteTable(tableName: String) {
        let queryString = "DROP TABLE\(tableName)"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        print("drop table has been seccessfully done")
    }
    
    private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error preparing update: \(errorMessage)")
        return
    }
}
*/

//import Foundation
//
//import SQLite
//
//class DBHelper {
//    do {
//        let db = try Connetion("path/to/db.sqlite3")
//
//        let items = Table("items")
//        let id = Expression<Int64>("id")
//        let title = Expression<String>("title")
//        let tag = Expression<String>("tag")
//        let date = Expression<String>("date")
//        let duration = Expression<Int64>("duration")
//     }
//}
