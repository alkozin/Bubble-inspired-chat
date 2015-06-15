//
//  NSObject+Observers.m
//

#import "NSObject+Utils.h"

@implementation NSObject (Observers)

- (void)addObserverForNewValueOf:(NSString *)keyPath
{
    [self addObserver:self forNewValueOf:keyPath];
}

- (void)addObserver:(id)object forNewValueOf:(NSString*)keyPath
{
    [self addObserver:object forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverFor:(NSString *)keyPath
{
    [self removeObserver:self for:keyPath];
}

- (void)removeObserver:(id)object for:(NSString*)keyPath
{
    [self removeObserver:object forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSString *selectorString = [NSString stringWithFormat:@"%@Changed", keyPath];
    NSString *selectorStringWithArg = [selectorString stringByAppendingString:@":"];

    SEL selectorWithArg = NSSelectorFromString(selectorStringWithArg);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:selectorWithArg]) {
        [self performSelector:selectorWithArg withObject:change];
    } else {
        SEL selector = NSSelectorFromString(selectorString);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector];
        }
    }
#pragma clang diagnostic pop
}

@end
