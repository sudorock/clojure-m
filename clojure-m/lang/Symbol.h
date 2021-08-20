//
// Created by Sunil KS on 20/08/21.
//

#import <Foundation/Foundation.h>

@interface Symbol : NSObject
@property NSString *name;

+ (id)intern:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;
@end