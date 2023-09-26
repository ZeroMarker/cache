/// 描述:      变量目录表
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.VariablesCategory Extends %Persistent
{

/// 目录名称
Property Name As %String;

/// 目录类型
Property Type As %String;

/// 父节点
Property ParentID As %Integer;

/// 目录顺序
Property Sequence As %Integer;

/// 是否有效
Property IsValid As %String;

Storage Default
{
<Data name="VariablesCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ResChildCount</Value>
</Value>
<Value name="5">
<Value>InternalID</Value>
</Value>
<Value name="6">
<Value>ParentID</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.VariablesCategoryD</DataLocation>
<DefaultData>VariablesCategoryDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.VariablesCategoryD</IdLocation>
<IndexLocation>^CT.BSP.GBP.VariablesCategoryI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.VariablesCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
