//
// Created by Sunil KS on 21/08/21.
//

#import <Foundation/Foundation.h>


@protocol ISeq;


@interface Bool : NSObject
+ (instancetype)T;

+ (instancetype)F;
@end


@interface RT : NSObject

+(id <ISeq>)seq:(id)coll;
@end