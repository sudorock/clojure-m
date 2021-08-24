//
// Created by Sunil KS on 23/08/21.
//

#import "PersistentVector.h"


@implementation PersistentVector {
    NSMutableArray *_val;
}

+ (instancetype):vector {
    return [[self alloc] initWithArray:[NSMutableArray array]];
}


- (id)cons:(id)o {
    return nil;
}


+ (id)vectorWithArray:(NSArray *)a {
    return [[self alloc] initWithArray:a];
}


- (instancetype)initWithArray:(NSArray *)a {
    self = [super init];
    if (self == nil) return nil;

    _val = [NSMutableArray arrayWithArray:a];
    return self;
}
@end