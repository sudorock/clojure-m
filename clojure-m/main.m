#import <Foundation/Foundation.h>
#import "LispReader.h"
#import "Compiler.h"
#import "PersistentList.h"


int main() {
//    char *source = "  (false 1.25 2 sunil 3 (9 10 false 5.))      ";
    char *source = "  (false 1 3)      ";

    NSObject *k = [LispReader read:source];

    id s = [Compiler eval:k];

//   PersistentList *l = [PersistentList arrayWithArray:@[@1, @2, @3]];
//   PersistentList *l2 = [l next];
//   PersistentList *l3 = [l2 next];
//   PersistentList *l4 = [l3 next];
//
//   id k = [l3 first];
//   id n = [l4 first];
//   id z = [n first];
//   id a = [z first];


    return 0;
}