#import <Foundation/Foundation.h>
#import "LispReader.h"
#import "Compiler.h"

int main() {
//    char *source = "  (false 1.25 2 sunil 3 (9 10 false 5.))      ";
    char *source = "  9      ";

    NSObject *k = [LispReader read:source];

    id s = [Compiler eval:k];
    return 0;
}