//
// Created by Sunil KS on 21/08/21.
//

#import "List.h"


@implementation List {
    NSMutableArray *_val;
}


+ (id)arrayWithArray:(NSArray *)a {
    return [[self alloc] initWithArray:a];
}


- (instancetype)initWithArray:(NSArray *)a {
    self = [super init];
    if (self == nil) return nil;

    _val = [NSMutableArray arrayWithArray:a];
    return self;
}

@end