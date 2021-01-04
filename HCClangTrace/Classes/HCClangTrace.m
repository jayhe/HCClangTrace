//
//  HCClangTrace.m
//  RuntimeLearning
//
//  Created by 贺超 on 2020/4/24.
//  Copyright © 2020 hechao. All rights reserved.
//

#import "HCClangTrace.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

@implementation HCClangTrace

// The guards are [start, stop).
// This function will be called at least once per DSO and may be called
// more than once with the same values of start/stop.
void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
    static uint64_t N;  // Counter for the guards.
    if (start == stop || *start) return;  // Initialize only once.
    printf("INIT: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++)
        *x = ++N;  // Guards should start from 1.
}

//原子队列
static  OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;
//定义符号结构体
typedef struct {
    void *pc;
    void *next;
} SymbolNode;

// This callback is inserted by the compiler as a module constructor
// into every DSO. 'start' and 'stop' correspond to the
// beginning and end of the section with the guards for the entire
// binary (executable or DSO). The callback will be called at least
// once per DSO and may be called multiple times with the same parameters.
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    if (!*guard) return; // Duplicate the guard check.
    // If you set *guard to 0 this code will not be called again for this edge.
    // Now you can get the PC and do whatever you want:
    //   store it somewhere or symbolize it and print right away.
    // The values of `*guard` are as you set them in
    // __sanitizer_cov_trace_pc_guard_init and so you can make them consecutive
    // and use them to dereference an array or a bit vector.
    void *PC = __builtin_return_address(0);
    SymbolNode *node = malloc(sizeof(SymbolNode));
    *node = (SymbolNode){PC, NULL};
    //进入
    OSAtomicEnqueue(&symbolList, node, offsetof(SymbolNode, next));
    /*
    printf("fname:%s \nfbase:%p \nsname:%s \nsaddr:%p\n",
           info.dli_fname,
           info.dli_fbase,
           info.dli_sname,
           info.dli_saddr);
     */
    *guard = 0;
}

+ (void)generateOrderFile {
    NSMutableArray <NSString *> *symbolNames = [NSMutableArray array];
    while (YES) {
        SymbolNode * node = OSAtomicDequeue(&symbolList, offsetof(SymbolNode, next));
        if (node == NULL) {
            break;
        }
        Dl_info info;
        dladdr(node->pc, &info);
        NSString *name = @(info.dli_sname);
        // 判断是不是oc方法，是的话直接加入符号数组
        BOOL isInstanceMethod = [name hasPrefix:@"-["];
        BOOL isClassMethod = [name hasPrefix:@"+["];
        BOOL isObjc = isInstanceMethod || isClassMethod;
        /* 非oc方法，一般会加上一个'_'，这是由于UNIX下的C语言规定全局的变量和函数经过编译后会在符号前加下划线从而减少多种语言目标文件之间的符号冲突的概率；可以通过编译选项'-fleading-underscore'开启、'-fno-leading-underscore'来关闭
         */
        NSString * symbolName = isObjc ? name: [@"_" stringByAppendingString:name];
        [symbolNames addObject:symbolName];
    }
    // 取反:将先调用的函数放到前面
    NSEnumerator * emt = [symbolNames reverseObjectEnumerator];
    // 去重：由于一个函数可能执行多次，__sanitizer_cov_trace_pc_guard会执行多次，就加了重复的了，所以去重一下
    NSMutableArray<NSString *> *funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    NSString *name;
    while (name = [emt nextObject]) {
        if (![funcs containsObject:name]) {
            [funcs addObject:name];
        }
    }
    // 由于trace了所有执行的函数，这里我们就把本函数移除掉
    [funcs removeObject:[NSString stringWithFormat:@"%s",__FUNCTION__]];
    // 写order文件
    NSString *funcStr = [funcs componentsJoinedByString:@"\n"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"trace.order"];
    NSData *fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
#if DEBUG
    NSLog(@"%@",funcStr);
#endif
}

#pragma mark - Util

+ (BOOL)isObjcMethodBySymbolName:(NSString *)symbolName {
    //BOOL isInstanceMethod = [symbolName containsString:@"-["];
    //BOOL isClassMethod = [symbolName containsString:@"+["];
    BOOL isInstanceMethod = [symbolName hasPrefix:@"-["];
    BOOL isClassMethod = [symbolName hasPrefix:@"+["];
    
    return isInstanceMethod || isClassMethod;
}

@end
