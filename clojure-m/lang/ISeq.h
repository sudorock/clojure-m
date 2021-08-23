//
// Created by Sunil KS on 23/08/21.
//

#import <Foundation/Foundation.h>
#import "IPersistentCollection.h"


@protocol ISeq <IPersistentCollection>
- (id)first;

- (id <ISeq>)next;

- (id <ISeq>)more;

- (id <ISeq>)cons:(id)o;
@end