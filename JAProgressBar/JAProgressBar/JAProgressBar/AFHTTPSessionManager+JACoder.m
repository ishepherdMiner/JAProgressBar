//
//  AFHTTPSessionManager+JACoder.m
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "AFHTTPSessionManager+JACoder.h"
#import "JAProgressUIWebView.h"
#import <objc/message.h>

@implementation AFHTTPSessionManager (JACoder)

+ (void)load {
    Method originalMethod = class_getInstanceMethod(self, @selector(URLSession:dataTask:didReceiveData:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(ja_URLSession:dataTask:didReceiveData:));
    BOOL didAddMethod =
    class_addMethod(self,
                    @selector(URLSession:dataTask:didReceiveData:),
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            @selector(ja_URLSession:dataTask:didReceiveData:),
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)ja_URLSession:(NSURLSession *)session
             dataTask:(NSURLSessionDataTask *)dataTask
       didReceiveData:(NSData *)data {
    
    [self ja_URLSession:session dataTask:dataTask didReceiveData:data];
    
    // ...
    if (dataTask.response.expectedContentLength != -1 && self.isLock == false) {
//        NSLog(@"data = %ld",data.length);
//        NSLog(@"dataTask = %lld",dataTask.response.expectedContentLength);
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveResponseNotification object:dataTask];
        
        self.lock = true;
        
    }else {
        
//        NSLog(@"data = %ld",data.length);
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFJAReceiveDataNotification object:data];
    }
}

- (BOOL)isLock {
    return (BOOL)[objc_getAssociatedObject(self, @selector(isLock)) doubleValue];
}

- (void)setLock:(BOOL)lock {
    objc_setAssociatedObject(self, @selector(setLock:), @(lock), OBJC_ASSOCIATION_ASSIGN);
}

@end
