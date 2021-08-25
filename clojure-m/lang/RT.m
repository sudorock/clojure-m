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
    return nil;
}


@end