//
//  SRMockWaitBlockOperation.m
//  SignalR.Client.ObjC
//
//  Created by Alex Billingsley on 3/15/16.
//  Copyright © 2016 DyKnow LLC. All rights reserved.
//

#import "SRMockWaitBlockOperation.h"
#import <OCMock/OCMock.h>
#import "SRBlockOperation.h"

@implementation SRMockWaitBlockOperation
- (instancetype)initWithBlockOperationClass:(Class)operationClass; {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    _afterWait = nil;
    _mock = [OCMockObject niceMockForClass:operationClass];
    [[[[_mock stub] andReturn: _mock ] andDo:^(NSInvocation *invocation) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        __unsafe_unretained void (^successCallback)() = nil;
        [invocation getArgument: &successCallback atIndex: 2];
        strongSelf.afterWait = successCallback;
        [strongSelf stopMocking];
    }] blockOperationWithBlock: [OCMArg any]];
    
    return self;
}
- (instancetype)initWithWaitTime:(int)expectedWait {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    __weak __typeof(&*self)weakSelf = self;
    _afterWait = nil;
    _mock = [OCMockObject niceMockForClass:[NSBlockOperation class]];
    [[[[_mock stub] andReturn: _mock ] andDo:^(NSInvocation *invocation) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        __unsafe_unretained void (^successCallback)() = nil;
        [invocation getArgument: &successCallback atIndex: 2];
        strongSelf.afterWait = successCallback;
        [strongSelf stopMocking];
    }] blockOperationWithBlock: [OCMArg any]];
    [[[_mock stub] andDo:^(NSInvocation *invocation) {
        __strong __typeof(&*weakSelf)strongSelf = weakSelf;
        double delay = 0;
        [invocation getArgument: &delay atIndex:4];
        strongSelf.waitTime = delay;
    }] performSelector:@selector(start) withObject:nil afterDelay: expectedWait];
    return self;
}

- (void)stopMocking {
    [_mock stopMocking];
}

- (void)dealloc {
    [self stopMocking];
}

@end
