//
// Created by Sunil KS on 24/08/21.
//

#import <Foundation/Foundation.h>
#import "Indexed.h"


@protocol IPersistentVector <Indexed>
- (id)cons:(id)o;
@end