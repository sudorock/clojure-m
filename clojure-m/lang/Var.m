//
// Created by Sunil KS on 23/08/21.
//

#import "Var.h"


@implementation Var {
    NSString *_name;
    id _root;

}

+ (id)name:(NSString *)name {
    return [[self alloc] initWithName:name];
}


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (!self) return nil;

    _name = name;
    return self;
}


- (void)bindRoot:(id)root {
    _root = root;
}

@end