/// 描述:数据引用属性表
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.BindField Extends %Persistent
{

Property Description As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property FieldType As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property QueryID As %String(TRUNCATE = 1);

// 关联字典ID

Property DicID As %String(TRUNCATE = 1);

/// 返回值类型：Dict / Mono/ Mult
Property ValueType As %String(TRUNCATE = 1);

Storage Default
{
<Data name="BindFieldDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>FieldName</Value>
</Value>
<Value name="4">
<Value>FieldType</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>QueryID</Value>
</Value>
<Value name="7">
<Value>DicID</Value>
</Value>
<Value name="8">
<Value>ValueType</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.BindFieldD</DataLocation>
<DefaultData>BindFieldDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.BindFieldD</IdLocation>
<IndexLocation>^CT.BSP.GBP.BindFieldI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.BindFieldS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
