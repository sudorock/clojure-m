//
// Created by Sunil KS on 23/08/21.
//

#import <Foundation/Foundation.h>
#import "Seqable.h"


@protocol IPersistentCollection <Seqable>
- (NSInteger *)count;

- (id <IPersistentCollection>)cons:(id)o;

- (id <IPersistentCollection>)empty;

- (BOOL)equiv:(id)o;
@end