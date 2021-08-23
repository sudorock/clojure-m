//
// Created by Sunil KS on 21/08/21.
//

#import "PersistentList.h"


@implementation PersistentList {
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


- (id)first {
    return [_val firstObject];
}


- (id <ISeq>)next {
    return nil;
}


- (id <ISeq>)more {
    return nil;
}


- (id <ISeq>)cons:(id)o {
    return nil;
}


- (NSInteger *)count {
    return 0;
}


- (id <IPersistentCollection>)empty {
    return nil;
}


- (BOOL)equiv:(id)o {
    return NO;
}


- (id)seq {
    return nil;
}


@end