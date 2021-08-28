//
// Created by Sunil KS on 21/08/21.
//

#import "RT.h"
#import "ISeq.h"


@implementation Bool
+ (instancetype)T {
    static Bool *T;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        T = [[self alloc] init];
    });

    return T;
};


+ (instancetype)F {
    static Bool *F;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        F = [[self alloc] init];
    });

    return F;
};
@end


@implementation RT
+ (id <ISeq>)seq:(id)coll {
    return coll;
}


+ (id)second:(id)x {
    return [[x next] first];
}


+ (id)third:(id)x {
    return [[[x next] next] first];
}


+ (id)first:(id)x {
    if ([x respondsToSelector:@selector(first)]) return [x first];
    return nil;
}


+ (id)next:(id)x {
    if ([x respondsToSelector:@selector(next)]) return [x next];
    return nil;
}


@end