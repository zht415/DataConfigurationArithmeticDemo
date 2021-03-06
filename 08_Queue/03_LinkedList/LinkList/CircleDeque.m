//
//  CircleDeque.m
//  03_LinkedList
//
//  Created by chenshuang on 2019/5/14.
//  Copyright © 2019年 wenwen. All rights reserved.
//

#import "CircleDeque.h"

static int kDefaultCapacity = 10;   // 默认元素个数

@implementation CircleDeque {
    int _front;
    int _size;
    NSMutableArray *_elements;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _elements = [NSMutableArray array];
        for (int i = 0; i < kDefaultCapacity; i++) {
            [_elements addObject:@(-1)];
        }
    }
    return self;
}

/// 元素的数量
- (int)size {
    return _size;
}

/// 是否为空
- (BOOL)isEmpty {
    return _size == 0;
}

/// 清空
- (void)clear {
    [_elements removeAllObjects];
    _front = 0;
    _size = 0;
}

/// 从后面入队
- (void)enQueueRear:(id)element {
    [self ensureCapacity:_size + 1];
    
    int index = [self getIndex:_size];
    _elements[index] = element;
    _size++;
}

/// 从后面出队
- (id)deQueueRear {
    int rearIndex = [self getIndex:_size - 1];
    id rearElement = _elements[rearIndex];
    _elements[rearIndex] = @(-1);    // 头节点位置置空
    _size--;
    return rearElement;
}

/// 从头部入队
- (void)enQueueFront:(id)element {
    [self ensureCapacity:_size + 1];
    
    _front = [self getIndex:-1];
    _elements[_front] = element;
    _size++;
}

/// 从头部出队
- (id)deQueueFront {
    id frontElement = _elements[_front];
    _elements[_front] = @(-1);    // 头节点位置置空
    _front = [self getIndex:1];
    _size--;
    return frontElement;
}

/// 获取队列的头元素
- (id)front {
    return _elements[_front];
}

/// 获取队列的尾元素
- (id)rear {
    int index = [self getIndex:_size - 1];
    return _elements[index];
}

- (NSString *)description {
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:[NSString stringWithFormat:@"capcacity = %lu,",(unsigned long)_elements.count]];
    [strM appendString:[NSString stringWithFormat:@"size = %d,",_size]];
    [strM appendString:[NSString stringWithFormat:@"front = %d,",_front]];
    [strM appendString:@"\n ["];
    
    for (int i = 0; i < _elements.count; i++) {
        if (i != 0) {
            [strM appendString:@","];
        }
        [strM appendFormat:@"%@",_elements[i]];
    }
    [strM appendString:@"]"];
    return strM.copy;
}

#pragma mark - private

/// 获取真正插入位置的索引
- (int)getIndex:(int)index {
    // 因为一直在循环,所以需要取模
    index += _front;    // 先加上头位置索引
    if (index < 0) {
        return index + _elements.count;
    }
    
    // 返回正确插入位置索引
    return index - (index >= _elements.count ? _elements.count : 0);
}

/** 保证要有capacity的容量 */
- (void)ensureCapacity:(int)capacity {
    NSInteger oldCapactity = _elements.count;
    if (oldCapactity >= capacity) {
        return;
    }
    
    // 新容量为旧容量的1.5倍
    int newCapacity = oldCapactity + oldCapactity * 0.5;
    NSMutableArray *newElements = [NSMutableArray array];
    for (int i = 0; i < newCapacity; i++) {
        [newElements addObject:@(-1)];
    }
    // 恢复旧值
    for (int i = 0; i < _size; i++) {
        newElements[i] = _elements[i];
    }
    _elements = newElements;
    
    // 重置front
    _front = 0;
}


@end
