#import <Foundation/Foundation.h>
#import "LispReader.h"

int main() {
    char *source = "  (false 1.25 2 sunil 3 (9 10 false 5.))      ";

    NSObject *k = [LispReader read:source];

    return 0;
}