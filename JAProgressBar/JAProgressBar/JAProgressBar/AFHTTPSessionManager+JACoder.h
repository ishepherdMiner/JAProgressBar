//
//  AFHTTPSessionManager+JACoder.h
//  Summary
//
//  Created by Jason on 08/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionManager (JACoder)

@property (nonatomic,assign,getter=isLock) BOOL lock;

@end

NS_ASSUME_NONNULL_END
