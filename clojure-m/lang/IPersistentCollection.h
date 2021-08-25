//
// Created by Sunil KS on 23/08/21.
//

#import <Foundation/Foundation.h>
#import "Seqable.h"


@protocol IPersistentCollection <Seqable>
- (NSUInteger)count;

- (id <IPersistentCollection>)cons:(id)o;

- (id <IPersistentCollection>)empty;

- (BOOL)equiv:(id)o;
@end