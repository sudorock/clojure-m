//
// Created by Sunil KS on 25/08/21.
//

#import <Foundation/Foundation.h>
#import "Counted.h"


@protocol Indexed <Counted>
- (id)nth:(NSUInteger)i;
@end