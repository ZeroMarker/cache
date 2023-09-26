Class web.Entity.BDP.BDPExtExecItem Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPExtExecItem";

Property BDEFBDETParRef As %String;

/// RowId
Property BDEFRowId As %String;

/// 代码
Property BDEFCode As %String;

/// 描述
Property BDEFName As %String;

/// 如果为真，则在HTML时标明此表单元素为只读,Yes/No:  Y/N
Property BDEFReadOnly As %String;

/// 值为 false 时将效验输入字符个数大于0,  Yes/No:   Y/N
Property BDEFAllowBlank As %String;

/// 是否隐藏,  Yes/No:   Y/N
Property BDEFHidden As %String;

/// false则不可编辑，默认为 true ,  Yes/No:   Y/N
Property BDEFEditable As %String;

/// 悬浮提示信息
Property BDEFToolTip As %String;

/// 定义显示提示信息的类型，有qtip和title两种方式，默认是qtip
Property BDEFToolTipType As %String;

/// 按钮类型：可以是submit, reset or button  默认是 button
Property BDEFType As %String;

/// 是否自动显示，默认false  ,  Yes/No:   Y/N
Property BDEFAutoShow As %String;

/// 图标
Property BDEFIconCls As %String;

/// 函数
Property BDEFHandler As %String;

/// 输入框类型
Property BDEFXType As %String;

/// 字段校验时调用的自定义函数 
Property BDEFValidator As %String;

/// 如果指定了, 则会动态生成一个以指定名称命名的隐藏域用来存放值数据(默认为)；    真正提交时此combo的name，这个一定要是hiddenName不是name，不然提交的数据为文本框中内容  ..如果ComboBox读取本地数据则将值设为'local'
Property BDEFHiddenName As %String;

/// 一个用以在效验时使用的 JavaScript 正则表达式对象(默认为 null)。如果启用此项，则此正则表达式将在所有基础效验成功之后被执行，执行此正则表达式时传递的参数为该字段的值。如果效验失败，则根据regexText的设置将字段标记为无效。
Property BDEFRegex As %String;

/// 当{@link #regex}被设置且效验失败时显示的错误文本
Property BDEFRegexText As %String;

Property BDEFValueGet As %String;

Property BDEFValueSet As %String;

}
