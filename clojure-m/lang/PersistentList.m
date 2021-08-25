//
// Created by Sunil KS on 21/08/21.
//

#import "PersistentList.h"


@implementation PersistentList {
    NSArray *_val;
}


+ (id)arrayWithArray:(NSArray *)a {
    return [[self alloc] initWithArray:a];
}


- (instancetype)initWithArray:(NSArray *)a {
    self = [super init];
    if (self == nil) return nil;

    _val = [NSArray arrayWithArray:a];

    return self;
}


- (id)first {
    id first = [_val firstObject];

    if (first == nil) return [NSNull null];

    return [_val firstObject];
}


- (id <ISeq>)next {
    NSUInteger c = [_val count] - 1;

    if (c == 0) return (id <ISeq>) [NSNull null];

    return [PersistentList arrayWithArray:[_val subarrayWithRange:NSMakeRange(1, c)]];
}


- (id <ISeq>)more {
    return nil;
}


- (id <ISeq>)cons:(id)o {
    return nil;
}


- (NSUInteger)count {
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