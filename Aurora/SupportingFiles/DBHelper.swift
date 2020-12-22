

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
        musicTable()
        tagsTable()
        compositionTable()
        soundTable()
        downloadTable()
    }
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print(fileURL)
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS favourite(Id INTEGER PRIMARY KEY, songId TEXT, updateStatus TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            } else
            {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func musicTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS musicDetail(Id INTEGER, _createdDate TEXT, _id TEXT, _owner TEXT, _updatedDate TEXT, largeImageURL TEXT, musicDescription TEXT, musicDescription2 TEXT, musicID TEXT PRIMARY KEY, musicLive TEXT, musicName TEXT, musicNew TEXT, musicPremium TEXT, smallImageURL TEXT, tag TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            }
            else
            {
                print("table could not be created.")
            }
        }
        else
        {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func tagsTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS tags(Id INTEGER, createdDate TEXT, tagId TEXT, owner TEXT, _updatedDate TEXT, tagDescription TEXT, tagLive TEXT, tagName TEXT PRIMARY KEY, tagOrder TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            } else {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func compositionTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS composition(Id INTEGER PRIMARY KEY, createdDate TEXT, compositionId TEXT, owner TEXT, _updatedDate TEXT, instrumentAudioURL TEXT, instrumentDisplayOrder TEXT, instrumentLive TEXT, instrumentName TEXT, instrumentVolumeDefault TEXT, musicID TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            }
            else
            {
                print("table could not be created.")
            }
        }
        else
        {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func downloadTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS download(Id INTEGER, musicID TEXT PRIMARY KEY, musicName TEXT, size TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            }
            else
            {
                print("table could not be created.")
            }
        }
        else
        {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func soundTable()
    {
        let createTableString = "CREATE TABLE IF NOT EXISTS sound(Id INTEGER PRIMARY KEY, createdDate TEXT, soundId TEXT, owner TEXT, _updatedDate TEXT, soundAudioURL TEXT, soundDisplayOrder TEXT, soundLive TEXT, soundName TEXT, soundVolumeDefault TEXT, musicID TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("table created.")
            }
            else
            {
                print("table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertMusicDetail(createdDate: String, id: String, owner: String, updatedDate: String, largeImage: String, musicDescription: String, musicDescription2: String, musicID: String, musicLive: String, musicName: String, musicNew: String, musicPremium: String, smallImageURL: String, tag: String)
    {
        let insertStatementString = "INSERT INTO musicDetail(_createdDate, _id, _owner, _updatedDate, largeImageURL, musicDescription, musicDescription2, musicID, musicLive, musicName, musicNew, musicPremium, smallImageURL, tag) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (createdDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (owner as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (updatedDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (largeImage as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (musicDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (musicDescription2 as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (musicID as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (musicLive as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (musicName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 11, (musicNew as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 12, (musicPremium as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 13, (smallImageURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 14, (tag as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertComposition(createdDate: String, id: String, owner: String, updatedDate: String, instrumentAudioURL: String, instrumentDisplayOrder: String, instrumentLive: String, instrumentName: String, instrumentVolumeDefault: String, musicId: String)
    {
        let insertStatementString = "INSERT INTO composition(createdDate, compositionId, owner, _updatedDate, instrumentAudioURL, instrumentDisplayOrder, instrumentLive, instrumentName, instrumentVolumeDefault, musicID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (createdDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (owner as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (updatedDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (instrumentAudioURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (instrumentDisplayOrder as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (instrumentLive as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (instrumentName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (instrumentVolumeDefault as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (musicId as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertDownload(musicId: String, musicName: String, size: String)
    {
        let insertStatementString = "INSERT INTO download(musicID, musicName, size) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (musicId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (musicName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (musicName as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertSound(createdDate: String, id: String, owner: String, updatedDate: String, soundAudioURL: String, soundDisplayOrder: String, soundLive: String, soundName: String, soundVolumeDefault: String, musicID : String)
    {
        let insertStatementString = "INSERT INTO sound(createdDate, soundId, owner, _updatedDate, soundAudioURL, soundDisplayOrder, soundLive, soundName, soundVolumeDefault, musicID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (createdDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (owner as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (updatedDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (soundAudioURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (soundDisplayOrder as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (soundLive as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (soundName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (soundVolumeDefault as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 10, (musicID as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insert(songId:String, updateStatus:String)
    {
        let insertStatementString = "INSERT INTO favourite(songId, updateStatus) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (songId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (updateStatus as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertTag(createdDate: String, tagId: String, owner: String, updateDate: String, tagDescription: String, tagLive: String, tagName: String, tagOrder: String)
    {
        let insertStatementString = "INSERT INTO tags(createdDate, tagId, owner, _updatedDate, tagDescription, tagLive, tagName, tagOrder) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (createdDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (tagId as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (owner as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (updateDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (tagDescription as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (tagLive as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (tagName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (tagOrder as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
   
    func read() -> [favourite] {
        let queryStatementString = "SELECT * FROM favourite;"
        var queryStatement: OpaquePointer? = nil
        var psns : [favourite] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let musicId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let updateStatus = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                psns.append(favourite(id: Int(id), musicId: musicId, updateStatus: updateStatus))
                print("Query Result OF favourite:")
            }
        }
        else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func getMusicDetail(selectedTag : String) -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM musicDetail;"
        var queryStatement: OpaquePointer? = nil
        let musicDetilArray : NSMutableArray = []
        let newArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let createdDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let songId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let owner = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let updatedDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let largeImage = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let musicDescription = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let musicDescription2 = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let musicID = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let musicLive = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let musicName = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let musicNew = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                let musicPremium = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))
                let smallImageURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 13)))
                let allTag = String(describing: String(cString: sqlite3_column_text(queryStatement, 14)))
                
                var parameterDict : NSDictionary = [:]
                parameterDict = ["_createdDate": createdDate, "_id": songId, "_owner": owner, "_updatedDate": updatedDate, "largeImageURL": largeImage, "musicDescription":musicDescription, "musicDescription2": musicDescription2, "musicID": musicID, "musicLive": musicLive, "musicName": musicName, "musicNew": musicNew, "musicPremium": musicPremium, "smallImageURL": smallImageURL, "tag": allTag]
                
                if selectedTag == "All"
                {
                    if parameterDict.object(forKey: "musicNew") as? String == "1"
                    {
                      musicDetilArray.add(parameterDict)
                    }
                    else
                    {
                       newArray.add(parameterDict)
                    }
                }
                else
                {
                    let allTag = parameterDict.object(forKey: "tag") as? String
                    if (allTag?.contains(selectedTag))!
                    {
                        if parameterDict.object(forKey: "musicNew") as? String == "1"
                        {
                           musicDetilArray.add(parameterDict)
                        }
                        else
                        {
                           newArray.add(parameterDict)
                        }
                    }
                }
                print("Query Result OF favourite:")
            }
             for i in 0..<newArray.count
             {
                let tempDict = newArray.object(at: i) as? NSDictionary
                musicDetilArray.add(tempDict!)
             }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return musicDetilArray
    }
    
    func getCompositionbyMusicId(Id: String) -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM composition WHERE musicID = '\(Id)';"
        var queryStatement: OpaquePointer? = nil
        let compositionArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let createdDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let compositionId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let owner = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let updatedDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let instrumentAudioURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let instrumentDisplay = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let instrumentLive = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let instrumentName = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let instrumentVolumeDefault = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let musicId = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                var parameterDict : NSDictionary = [:]
                parameterDict = ["_createdDate": createdDate, "_id": compositionId, "_owner": owner, "_updatedDate": updatedDate, "instrumentAudioURL": instrumentAudioURL, "instrumentDisplayOrder": instrumentDisplay, "instrumentLive": instrumentLive, "instrumentName": instrumentName, "instrumentVolumeDefault": instrumentVolumeDefault, "musicID": musicId]
                compositionArray.add(parameterDict)
                print("Query Result OF favourite:")
            }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return compositionArray
    }
    
    func getSoundbyMusicId(Id: String) -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM sound WHERE musicID = '\(Id)';"
        var queryStatement: OpaquePointer? = nil
        let compositionArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let createdDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let soundId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let owner = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let updatedDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let soundAudioURL = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let soundDisplayOrder = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let soundLive = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let soundName = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                let soundVolumeDefault = String(describing: String(cString: sqlite3_column_text(queryStatement, 9)))
                let musicId = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                var parameterDict : NSDictionary = [:]
                parameterDict = ["_createdDate": createdDate, "_id": soundId, "_owner": owner, "_updatedDate": updatedDate, "soundAudioURL": soundAudioURL, "soundDisplayOrder": soundDisplayOrder, "soundLive": soundLive, "soundName": soundName, "instrumentVolumeDefault": soundVolumeDefault, "musicID": musicId]
                compositionArray.add(parameterDict)
                print("Query Result OF Sound:")
            }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return compositionArray
    }
    
    func getdownload() -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM download;"
        var queryStatement: OpaquePointer? = nil
        let downloadArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let musicId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let musicName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let size = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                var parameterDict : NSDictionary = [:]
                parameterDict = ["musicID": musicId, "musicName": musicName, "size": size]
                downloadArray.add(parameterDict)
                print("Query Result OF favourite:")
            }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return downloadArray
    }
    
    func getdownloadbyId(Id: String) -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM download WHERE musicID = '\(Id);"
        var queryStatement: OpaquePointer? = nil
        let downloadArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let musicId = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let musicName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let size = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                var parameterDict : NSDictionary = [:]
                parameterDict = ["musicID": musicId, "musicName": musicName, "size": size]
                downloadArray.add(parameterDict)
                print("Query Result OF favourite:")
            }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return downloadArray
    }
    
    func getTagfromLocal() -> NSMutableArray
    {
        let queryStatementString = "SELECT * FROM tags;"
        var queryStatement: OpaquePointer? = nil
        let tagArray : NSMutableArray = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let createdDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let tagId = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let owner = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let updatedDate = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let tagDescription = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let tagLive = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let tagName = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                let tagOrder = String(describing: String(cString: sqlite3_column_text(queryStatement, 8)))
                
                var parameterDict : NSDictionary = [:]
                parameterDict = ["_createdDate": createdDate, "_id": tagId, "_owner": owner, "_updatedDate": updatedDate, "tagDescription": tagDescription, "tagLive": tagLive, "tagName": tagName, "tagOrder": tagOrder]
               
                tagArray.add(parameterDict)
                
                
                print("Query Result OF favourite:")
            }
        } else
        {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return tagArray
    }
    
    func deleteByID(id:String)
    {
        let deleteStatementStirng = "DELETE FROM favourite WHERE songId = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
          //  sqlite3_bind_int(deleteStatement, 1, Int32(id))
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteDownloadbyID(id:String)
    {
        let deleteStatementStirng = "DELETE FROM download WHERE musicID = '\(id)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            //  sqlite3_bind_int(deleteStatement, 1, Int32(id))
            // sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deletedMusic(id:String)
    {
        let deleteStatementStirng = "DELETE FROM musicDetail WHERE musicID = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            //  sqlite3_bind_int(deleteStatement, 1, Int32(id))
            sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteComposition(Id: String, name: String)
    {
        let deleteStatementStirng = "DELETE FROM composition WHERE musicID = '\(Id)' AND instrumentName = '\(name)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            //  sqlite3_bind_int(deleteStatement, 1, Int32(id))
           // sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func deleteSound(Id: String, name: String)
    {
        let deleteStatementStirng = "DELETE FROM sound WHERE musicID = '\(Id)' AND soundName = '\(name)';"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            //  sqlite3_bind_int(deleteStatement, 1, Int32(id))
            // sqlite3_bind_text(deleteStatement, 1, (id as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
   // "INSERT INTO composition(createdDate, compositionId, owner, _updatedDate, instrumentAudioURL, instrumentDisplayOrder, instrumentLive, instrumentName, instrumentVolumeDefault, musicID)
    
    func updateByID(createdDate:String, compositionId:String, owner:String, _updatedDate: String, instrumentAudioURL: String, instrumentDisplayOrder: String, instrumentLive: String, instrumentName: String, instrumentVolumeDefault: String, musicID: String) {
        let updateStatementString = "UPDATE composition SET createdDate = '\(createdDate)' , compositionId = '\(compositionId)' , owner = '\(owner)' , _updatedDate = '\(_updatedDate)' , instrumentAudioURL = '\(instrumentAudioURL)' , instrumentDisplayOrder = '\(instrumentDisplayOrder)' , instrumentLive = '\(instrumentLive)' , instrumentName = '\(instrumentName)' , instrumentVolumeDefault = '\(instrumentVolumeDefault)' , musicID = '\(musicID)' WHERE musicID = '\(musicID)' AND instrumentName = '\(instrumentName)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
          //  sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func updateSoundByID(createdDate:String, SooundId:String, owner:String, _updatedDate: String, soundAudioURL: String, soundDisplayOrder: String, soundLive: String, SoundName: String, instrumetVolumeDefault: String, musicID: String) {
        let updateStatementString = "UPDATE sound SET createdDate = '\(createdDate)' , soundId = '\(SooundId)' , owner = '\(owner)' , _updatedDate = '\(_updatedDate)' , soundAudioURL = '\(soundAudioURL)' , soundDisplayOrder = '\(soundDisplayOrder)' , soundLive = '\(soundLive)' , soundName = '\(SoundName)' , soundVolumeDefault = '\(instrumetVolumeDefault)' , musicID = '\(musicID)' WHERE musicID = '\(musicID)' AND soundName = '\(SoundName)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            //  sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func updateDownloadByID(musicId: String, musicName: String, size: String)
    {
        let updateStatementString = "UPDATE download SET musicID = '\(musicId)' , musicName = '\(musicName)' , size = '\(size)' WHERE musicID = '\(musicId)';"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            //  sqlite3_bind_int(updateStatement, 1, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
   
    
  
}
