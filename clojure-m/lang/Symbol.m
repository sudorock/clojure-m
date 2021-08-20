//
// Created by Sunil KS on 20/08/21.
//

#import "Symbol.h"


@implementation Symbol

+ (id)intern:(NSString *)name {
    return [[self alloc] initWithName:name];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    self.name = name;
    return self;
}
@end