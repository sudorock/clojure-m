//
// Created by Sunil KS on 20/08/21.
//

#import "Symbol.h"


@implementation Symbol {
    NSString *_name;
}

+ (id)intern:(NSString *)name {
    return [[self alloc] initWithName:name];
}


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    _name = name;
    return self;
}


- (NSString *)getName {
    return _name;
}

@end