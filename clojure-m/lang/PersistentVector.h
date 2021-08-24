//
// Created by Sunil KS on 23/08/21.
//

#import <Foundation/Foundation.h>
#import "IPersistentVector.h"


@interface PersistentVector : NSObject <IPersistentVector>

+ (PersistentVector *)vector;

- (id)cons:(id)o;

@end