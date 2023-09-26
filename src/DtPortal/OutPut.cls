Class DtPortal.OutPut Extends (%RegisteredObject, %Populate, %XML.Adaptor) [ Inheritance = right, ProcedureBlock ]
{

/// 返回操作状态代码
/// 1：成功  <1：失败
Property status As %Integer;

/// 错误消息描述
/// 当status<1时，设置返回错误消息描述
/// 当status=1时，设置为空
Property errMSG As %String;

///  返回数据，可以存放任意Object类型 //update by chengpeng 改为String类型,某些版本不支持
Property data As %String;

/// add by wuqk 2016-10-11
/// 解决Cache 2016以上版本对象类型强制约束问题
Method dataSet(Arg As %String) As %Status [ ServerOnly = 1 ]
{
	Set i%data = Arg
	/*
	if $IsObject(Arg){
		Set i%data = Arg
	}
	else{
		Set i%data = ##class(%Library.ListOfObjects).%New(Arg)
		//d $System.OBJ.Dump(i%data)
	}
	*/
	Quit $$$OK
}

// %ListOfObjects  %Library.CacheObject

Storage Default
{
<Data name="OutPutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>data</Value>
</Value>
<Value name="3">
<Value>errMSG</Value>
</Value>
<Value name="4">
<Value>status</Value>
</Value>
</Data>
<DataLocation>^DtPortal.OutPutD</DataLocation>
<DefaultData>OutPutDefaultData</DefaultData>
<IdLocation>^DtPortal.OutPutD</IdLocation>
<IndexLocation>^DtPortal.OutPutI</IndexLocation>
<StreamLocation>^DtPortal.OutPutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
