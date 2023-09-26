Class DHCWL.DM.Function.FunctionInterface Extends %RegisteredObject [ Abstract ]
{

//[ Abstract ]

/// 当初始化FunctionInterface的对象实例后回调BeforeWork做Eval之前的准备工作。
Method BeforeWork()
{
}

Method Eval(runtimeParams As %List) As %DataType [ Abstract ]
{
}

/// 当FunctionInterface的对象实例被销毁前回调AfterWork方法做清理工作。
Method AfterWork()
{
}

Storage Default
{
<StreamLocation>^DHCWL.DM.F349A.FunctionIntB846S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
