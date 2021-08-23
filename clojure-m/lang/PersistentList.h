//
// Created by Sunil KS on 21/08/21.
//

#import <Foundation/Foundation.h>
#import "ISeq.h"

//NOT PERSISTENT YET, PLACEHOLDERISH
@interface PersistentList : NSObject <ISeq>

+ (id)arrayWithArray:(NSArray *)a;

- (instancetype)initWithArray:(NSArray *)a;
@end