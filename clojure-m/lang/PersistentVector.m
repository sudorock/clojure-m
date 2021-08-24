//
// Created by Sunil KS on 23/08/21.
//

#import "PersistentVector.h"


@implementation PersistentVector {
    NSArray *_val;
}


+ (PersistentVector *)vector {
    return [[self alloc] initWithArray:[NSArray array]];
}


- (id)cons:(id)o {
    return [PersistentVector vectorWithArray:[_val arrayByAddingObject:o]];
}


+ (id)vectorWithArray:(NSArray *)a {
    return [[self alloc] initWithArray:a];
}


- (instancetype)initWithArray:(NSArray *)a {
    self = [super init];
    if (self == nil) return nil;

    _val = [NSArray arrayWithArray:a];
    return self;
}


@end