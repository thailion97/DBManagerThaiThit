//
//  DBWorker.h
//  DBWorker
//  Sqlite crud

//  Created by Nguyen Anh Thai on 7/8/20.
//  Copyright © 2020 Nguyen Anh Thai. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AppDelegate.h"
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBWorker : NSObject
{
    //AppDelegate *appdel;
    sqlite3 *database;
}

@property (strong, nonatomic) NSString *strPath;
@property (strong,nonatomic) NSMutableArray *arrdata;
@property (strong, nonatomic) NSString *strmain;


- (NSMutableArray *)getUserData:(NSString *)query;

- (NSMutableArray *)getAllData;
- (NSMutableArray *)getDataWithName:(NSString *)name;
- (NSMutableArray *)getDataWithPhone:(NSString *)phone;
- (NSMutableArray *)getDataWithName:(NSString *)name
                              Phone:(NSString *)phone;

- (BOOL)saveDataWithName:(NSString *)name Phone:(NSString *)phone;

- (BOOL)updateDataWithName:(NSString *)name
             PhoneUpdateTo:(NSString *)phone;
- (BOOL)updateDataWithPhone:(NSString *)name
               NameUpdateTo:(NSString *)phone;
- (BOOL)updateDataWithNewName:(NSString *)newName
                     NewPhone:(NSString *)newPhone
                       AtName:(NSString *)name
                      AtPhone:(NSString *)phone;

- (BOOL)deleteAllData;
- (BOOL)deleteDataWithName:(NSString *)name;
- (BOOL)deleteDataWithPhone:(NSString *)phone;
- (BOOL)deleteDataWithName:(NSString *)name
                     Phone:(NSString *)phone;


- (int64_t)checkDataNotEmtry;

- (int64_t)checkExistWithName:(NSString *)name;
- (int64_t)checkExistWithPhone:(NSString *)phone;
- (int64_t)checkExistWithName:(NSString *)name
                        Phone:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END
