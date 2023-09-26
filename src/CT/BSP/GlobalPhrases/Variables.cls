/// 描述:      变量表
/// 编写者：yejian
/// 编写日期: 2019-12-2
Class CT.BSP.GlobalPhrases.Variables Extends %Persistent
{

/// 数据元类型
Property ElemType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 父节点
Property ParentID As %Integer;

/// 名称
Property Name As %String(MAXLEN = 50, TRUNCATE = 1);

/// 说明
Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

/// 数据绑定
Property DataBind As %String(MAXLEN = 500, TRUNCATE = 1);

/// 顺序
Property Sequence As %Integer;

Storage Default
{
<Data name="VariablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ElemType</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Text</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>EPRBindCode</Value>
</Value>
<Value name="8">
<Value>DataBaseBindCode</Value>
</Value>
<Value name="9">
<Value>InternalID</Value>
</Value>
<Value name="10">
<Value>Synch</Value>
</Value>
<Value name="11">
<Value>AllowNull</Value>
</Value>
<Value name="12">
<Value>ValidateMsg</Value>
</Value>
<Value name="13">
<Value>Name</Value>
</Value>
<Value name="14">
<Value>DatBind</Value>
</Value>
<Value name="15">
<Value>ParentID</Value>
</Value>
<Value name="16">
<Value>DataBind</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^CT.BSP.GBP.VariablesD</DataLocation>
<DefaultData>VariablesDefaultData</DefaultData>
<IdLocation>^CT.BSP.GBP.VariablesD</IdLocation>
<IndexLocation>^CT.BSP.GBP.VariablesI</IndexLocation>
<StreamLocation>^CT.BSP.GBP.VariablesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
