/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
/Users/yangmizhao/.rvm/scripts/rvm:29: operation not permitted: ps
#import <Foundation/Foundation.h>

@interface TraceToken : NSObject
@property (nonatomic, copy) NSString *name;
+ (instancetype)temporaryTokenNamed:(NSString *)name;
@end

@implementation TraceToken
+ (instancetype)temporaryTokenNamed:(NSString *)name {
    TraceToken *token = [[self alloc] init];
    token.name = name;
    return token;
}
- (void)dealloc {
    NSLog(@"dealloc: %@", self.name);
}
@end

static NSUInteger ProcessRows(NSUInteger rowCount, NSUInteger batchSize) {
    __block NSUInteger checksum = 0;
    for (NSUInteger start = 0; start < rowCount; start += batchSize) {
        @autoreleasepool {
            NSUInteger end = MIN(start + batchSize, rowCount);
            for (NSUInteger index = start; index < end; index++) {
                NSString *row = [NSString stringWithFormat:@"order-%06lu,%.2f",
                                 (unsigned long)index, (double)index / 10.0];
                NSArray<NSString *> *columns = [row componentsSeparatedByString:@","];
                checksum += columns.firstObject.length + columns.lastObject.length;
            }
        }
    }
    return checksum;
}

static BOOL Assert(BOOL condition, NSString *label) {
    NSLog(@"%@ %@", condition ? @"PASS" : @"FAIL", label);
    return condition;
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        __weak TraceToken *weakToken = nil;
        @autoreleasepool {
            TraceToken *token = [TraceToken temporaryTokenNamed:@"inner-scope"];
            weakToken = token;
            NSLog(@"inside pool: %@", weakToken.name);
        }

        BOOL ok = Assert(weakToken == nil,
                         @"temporary token was released when the inner pool drained");

        NSUInteger checksum = ProcessRows(10000, 250);
        ok &= Assert(checksum == 178900,
                     @"10,000 generated rows were processed in bounded batches");

        NSLog(@"%@ (checksum: %lu)", ok ? @"All checks passed." : @"Checks failed.",
              (unsigned long)checksum);
        return ok ? 0 : 1;
    }
}
