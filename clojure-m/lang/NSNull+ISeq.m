//
// Created by Sunil KS on 24/08/21.
//

#import "NSNull+ISeq.h"


@implementation NSNull (ISeq)
- (instancetype)first {
    return self;
}


- (instancetype)next {
    return self;
}


- (id)more {
    return nil;
}


- (id)cons:(id)o {
    return nil;
}


- (NSInteger *)count {
    return 0;
}


- (instancetype)empty {
    return self;
}


- (BOOL)equiv:(id)o {
    return NO;
}


- (id)seq {
    return self;
}


@end