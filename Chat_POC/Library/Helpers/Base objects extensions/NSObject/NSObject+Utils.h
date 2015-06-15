//
//  NSObject+Utils.h
//  Test
//
//  Created by Alexander Kozin on 5/2/12.
//  Copyright (c) 2012 Siberian.pro. All rights reserved.
//

@import UIKit;

#define mSetVariableInRange(variable, min, max) if (variable<min){variable=min;}else{if (variable>max){variable=max;}}

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread])\
{\
block();\
}\
else\
{\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_sync(block)\
dispatch_sync(dispatch_get_main_queue(), block);

#define dispatch_main_async(block)\
dispatch_async(dispatch_get_main_queue(), block);

#define LOC(key) NSLocalizedString(key, nil)

#define mFEqual(a,b)                                (fabsf((a) - (b)) < FLT_EPSILON)
#define mFEqualzero(a)                              (fabsf(a) < FLT_EPSILON)
#define mFabsLess(a,b)                              (fabsf(a)<fabs(b))
#define mFabsMore(a,b)                              (fabsf(a)>fabs(b))

#define mEqual(a,b)                                 (fabs((a) - (b)) < DBL_EPSILON)
#define mEqualzero(a)                               (fabs(a) < DBL_EPSILON)
#define mAbsLess(a,b)                               (fabs(a)<fabs(b))
#define mAbsMore(a,b)                               (fabs(a)>fabs(b))

#if !DEBUG && !TARGET_IPHONE_SIMULATOR
#define NSLog(FORMAT, ...)
#else
#define NSLog(FORMAT, ...)                          printf("%s %s\n", __PRETTY_FUNCTION__, \
                                                    [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#endif

#define NSAssertShouldOverride                      NSAssert(NO, @"Subclasses should override this method");
#define NSAssertShouldOverrideReturnNil             NSAssert(NO, @"Subclasses should override this method");\
                                                    return nil;

#define NSAssertUndefinedValue(propertyName, value) NSAssert(NO, @"%@ should be defined, unhandled value: %@", propertyName, value)

#define GCD_AFTER(seconds, block) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), block);

#define GCD_ONCE(block)\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, block);

#define CLLocationCoordinate2DEqual(c1, c2)         mEqual(c1.latitude, c2.latitude) && \
                                                        mEqual(c1.longitude, c2.longitude)

@interface NSObject (Utils)

/**
 *  Creates controller from objec
 *
 *  @return Owner object created from xib
 */
+ (id)controllerFromXib;

/**
 *  Returns object created from xib with same name as class
 *
 *  @return New object
 */
+ (id)objectFromXib;

/**
 *  Returns object created from xib with same name as class
 *
 *  @param owner Owner of object's relations
 *
 *  @return New object
 */
+ (id)objectFromXibWithOwner:(id)owner;

@end

@interface NSObject (Notifications)

- (void)addMemoryWarningObserver;
- (void)applicationDidReceiveMemoryWarning:(NSNotification*)n;

- (void)removeNotificationObservers;

- (void)postNotification:(NSString*)name;
- (void)postNotification:(NSString*)name withInfo:(NSDictionary*)info;

- (void)addNotificationObserver:(NSString*)name usingBlock:(void (^)(NSNotification *note))block;

- (void)addKeyboardWillShowNotificationObserver:(void (^)(CGFloat height))block;
- (void)addKeyboardWillHideObserver:(void (^)(void))block;

@end

@interface NSObject (Observers)

- (void)addObserverForNewValueOf:(NSString*)keyPath;
- (void)addObserver:(id)object forNewValueOf:(NSString*)keyPath;
- (void)removeObserverFor:(NSString*)keyPath;
- (void)removeObserver:(id)object for:(NSString*)keyPath;

@end
