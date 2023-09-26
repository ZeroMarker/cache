/// 描述:数据引用查询表
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.BindQuery Extends %Persistent
{

Property ClassName As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryName As %String(TRUNCATE = 1);

Property SingleResult As %String(TRUNCATE = 1);

// 1:为术语集需要的处方数据

Property Mark As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BindQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>QueryName</Value>
</Value>
<Value name="6">
<Value>SingleResult</Value>
</Value>
<Value name="7">
<Value>Mark</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.BindQueryD</DataLocation>
<DefaultData>BindQueryDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.BindQueryD</IdLocation>
<IndexLocation>^CT.BSP.GBP.BindQueryI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.BindQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
