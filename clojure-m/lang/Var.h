//
// Created by Sunil KS on 23/08/21.
//

#import <Foundation/Foundation.h>


@interface Var : NSObject
+ (id)name:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

- (void)bindRoot:(id)root;
@end