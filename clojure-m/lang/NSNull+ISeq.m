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


@end