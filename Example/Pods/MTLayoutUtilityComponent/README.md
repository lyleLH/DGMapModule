# MTLayoutUtilityComponent

此组件集合了一些好用的布局工具。

## `MTMasConstraintMaker`

是一个模仿`Masonry` 的链式语法，用来简化`Masonry`使用的工具。
使用一些更易理解的函数属性来代替 `Masonry`中 `MASConstraintMaker`的属性。

### 实现介绍

#### 简介

- 函数式编程 实现 链式语法 
    - 函数赋值给变量
    - 函数做为参数传递,那么函数名字不再重要
    - 将函数赋值给变量，此函数的调用，如果通过变量来实现则加括号·`()`
    - 通过`.`语法调用函数来实现链式语法
    - 匿名函数是即时调用的

ObjC的对象的实例调用其实例方法

`id = [obj function:param]`

objc函数式调用

`id = objc.function(param)`

#### 实际例子

```ObjC
- (MTMasConstraintMaker *(^)(id))to {
    return ^MTMasConstraintMaker * (id obj) {
    MTMasConstraintMaker *emaker = [MTMasConstraintMaker new];
        emaker.maker = self;
        emaker.obj = obj;
        return emaker;
    };
}
```

#### 实例简介
- 实现 `MASConstraintMaker`的分类
- 为分类新增实例方法`to`，其返回值是一个`block`（匿名函数）
- 此匿名函数的参数任意类型对象`id`，返回值是`YKMasConstraintMaker`实例
- 在匿名函数内部可以操作将`MASConstraintMaker`实例的属性 赋值 给匿名函数将要返回的`MTMasConstraintMaker` 实例 的属性
- `make.to(self.view)` 运行完毕之后其返回值是一个`MTMasConstraintMaker`实例
- `MTMasConstraintMaker`实例的方法是我们定义的更简便易懂的方法
- `make`实例的链式调用全部都是返回自身，再交给`mas_makeConstraints:^(MASConstraintMaker *make) `回调给上层，执行约束的安装



## 使用示例

```ObjC
[self.view addSubview:self.testView];
[self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.to(self.view).centerX(0).centerY(100);
    id obj = make.to(self.view);
    make.height.equalTo(@100);
    make.width.equalTo(@100);
}];
```


## 集成

```ruby
pod 'MTLayoutUtilityComponent',:subspecs => ['MTMasConstraintMaker']
```
 
 ```ObjC
 #import <MTLayoutUtilityComponent/MTMasConstraintMaker.h>
 ```
