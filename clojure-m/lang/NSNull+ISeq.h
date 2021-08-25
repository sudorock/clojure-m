//
// Created by Sunil KS on 24/08/21.
//

#import <Foundation/Foundation.h>
#import "ISeq.h"


@interface NSNull (ISeq) <ISeq>
- (instancetype)first;

- (instancetype)next;
@end