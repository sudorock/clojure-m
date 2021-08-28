//
// Created by Sunil KS on 20/08/21.
//

#import <Foundation/Foundation.h>
#import "ISeq.h"


@protocol IFn
- (id)invoke:(id)arg1;

- (id)applyTo:(id <ISeq>)arglist;

@end