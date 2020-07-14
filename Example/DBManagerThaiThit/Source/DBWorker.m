
//  DBWorker.m
//  DBWorker
//  Sqlite crud

//  Created by Nguyen Anh Thai on 7/8/20.
//  Copyright © 2020 Nguyen Anh Thai. All rights reserved.

#import "DBWorker.h"

@implementation DBWorker
@synthesize strPath, arrdata,strmain;

- (id)init{
    //appdel = (AppDelegate *)[[UIApplication sharedApplication]delegate]; //app delegate method used
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *strStorePath = [arrayPath objectAtIndex:0];
    
    self.strPath = [strStorePath stringByAppendingPathComponent:@"myapp.db"];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:self.strPath]){
        NSString *local = [[NSBundle mainBundle]pathForResource:@"myapp" ofType:@"db"];
        
        [[NSFileManager defaultManager]copyItemAtPath:local toPath:self.strPath error:nil];
    }
    
    NSLog(@"%@", self.strPath);
    self.strmain = self.strPath;// strmain = địa chỉ db
    // /var/mobile/Containers/Data/Application/5CB8F413-04E3-46C5-8F9C-0277ADB99525/Documents/myapp.db
    return self;
}

- (NSMutableArray *)getUserData:(NSString *)query{
    self.arrdata = [[NSMutableArray alloc]init];
    //open
    if (sqlite3_open([self.strmain UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *connection; //the statement handle
        //prepare
        if(sqlite3_prepare_v2(database, [query UTF8String], -1, &connection, nil) == SQLITE_OK){ /* read more: http://zetcode.com/db/sqlitec/ */
                            //đatabase   Command Line         the statement handle
            //setup
            while (sqlite3_step(connection) == SQLITE_ROW) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                
                NSString *userID = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection, 0)];
                NSString *name = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection, 1)];
                NSString *phone = [[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(connection, 2)];
                
                [dict setObject:userID forKey:@"userID"];
                [dict setObject:name forKey:@"name"];
                [dict setObject:phone forKey:@"phone"];
                
                [self.arrdata addObject:dict];
            }
        }
        sqlite3_finalize(connection);
    }
    sqlite3_close(database);
    return self.arrdata;
}


- (NSMutableArray *)getAllData{
    return [self getUserData:[[NSString alloc]initWithFormat:@"select * from user"]];
}


- (NSMutableArray *)getDataWithName:(NSString *)name{
    return [self getUserData:[[NSString alloc]initWithFormat:@"select * from user where name = '%@'", name]];
}

- (NSMutableArray *)getDataWithPhone:(NSString *)phone{
    return [self getUserData:[[NSString alloc]initWithFormat:@"select * from user where phone = '%@'", phone]];
}

- (NSMutableArray *)getDataWithName:(NSString *)name Phone:(NSString *)phone{
    if(phone == nil || phone.length == 0){
        return [self getDataWithName:name];
    }
    else if(name == nil || name.length == 0){
        return [self getDataWithPhone:phone];
    }
    else{
        return [self getUserData:[[NSString alloc]initWithFormat:@"select * from user where name = '%@' and phone = '%@'", name, phone]];
    }
}

- (BOOL)saveDataWithName:(NSString *)name Phone:(NSString *)phone{
    return [self getUserData:[[NSString alloc]initWithFormat:@"insert into user(name,phone) values ('%@', '%@')", name, phone]];
}

- (BOOL)updateDataWithName:(NSString *)name PhoneUpdateTo:(NSString *)phone{
    return [self getUserData:[[NSString alloc]initWithFormat:@"update user set name = '%@', phone = '%@' where name = '%@'", name, phone, name]];
}

- (BOOL)updateDataWithPhone:(NSString *)phone NameUpdateTo:(NSString *)name{
    return [self getUserData:[[NSString alloc]initWithFormat:@"update user set name = '%@', phone = '%@' where phone = '%@'", name, phone, phone]];
}

- (BOOL)updateDataWithNewName:(NSString *)newName
                     NewPhone:(NSString *)newPhone
                       AtName:(NSString *)name
                      AtPhone:(NSString *)phone{
    return [self getUserData:[[NSString alloc]initWithFormat:@"update user set name = '%@', phone = '%@' where name = '%@' and phone = '%@'", newName, newPhone, name, phone]];
}

- (BOOL)deleteAllData{
    return [self getUserData:[[NSString alloc]initWithFormat:@"delete from user"]];
}

- (BOOL)deleteDataWithName:(NSString *)name{
    return [self getUserData:[[NSString alloc]initWithFormat:@"delete from user where name = '%@'", name]];
}

- (BOOL)deleteDataWithPhone:(NSString *)phone{
    return [self getUserData:[[NSString alloc]initWithFormat:@"delete from user where phone = '%@'", phone]];
}

- (BOOL)deleteDataWithName:(NSString *)name Phone:(NSString *)phone{
    if(phone == nil || phone.length == 0){
        return [self deleteDataWithName:name];
    }
    else if(name == nil || name.length == 0){
        return [self deleteDataWithPhone:phone];
    }
    else{
        return [self getUserData:[[NSString alloc]initWithFormat:@"delete from user where name = '%@' and phone = '%@'", name, phone]];
    }
}

- (int64_t)checkDataNotEmtry{
    return [[self getUserData:[[NSString alloc]initWithFormat:@"select * from user"]] count];
}

- (int64_t)checkExistWithName:(NSString *)name{
    return [[self getUserData:[[NSString alloc]initWithFormat:@"select * from user where name = '%@'", name]] count];
}

- (int64_t)checkExistWithPhone:(NSString *)phone{
    return [[self getUserData:[[NSString alloc]initWithFormat:@"select * from user where phone = '%@'", phone]] count];
}

- (int64_t)checkExistWithName:(NSString *)name Phone:(NSString *)phone{
    if(phone == nil || phone.length == 0){
        return [self checkExistWithName:name];
    }
    else if(name == nil || name.length == 0){
        return [self checkExistWithPhone:phone];
    }
    else{
        return [[self getUserData:[[NSString alloc]initWithFormat:@"select * from user where name = '%@' and phone = '%@'", name, phone]] count];
    }
}

@end
