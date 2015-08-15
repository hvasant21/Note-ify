//
//  FilesEntity.h
//  Note-ify
//
//  Created by Harini Vasanthakumar on 15/08/15.
//  Copyright (c) 2015 Sample. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FilesEntity : NSManagedObject

@property (nonatomic, retain) NSString * fileRevision;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * remotePath;
@property (nonatomic) int32_t syncStatus;
@property (nonatomic, retain) NSString * title;

@end
