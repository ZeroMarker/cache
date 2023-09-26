Class User.DHCPENetSetsItemDetail Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Parameter ClassName = "User.DHCPENetSetsItemDetail";

/// 套餐项目表
Relationship NSIDParRef As User.DHCPENetSetsItem [ Cardinality = parent, Inverse = NSIDetailChild ];

/// 描述
Property NSIDDesc As %String(MAXLEN = 300) [ Required, SqlFieldName = NSID_Desc ];

/// 检查目的
Property NSIDIntent As %String(MAXLEN = 300) [ SqlFieldName = NSID_Intent ];

/// 序号
Property NSIDSort As %Integer [ SqlFieldName = NSID_Sort ];

Index SortIndex On NSIDSort As AlphaUp;

Index DescIndex On NSIDDesc As AlphaUp;

Storage Default
{
<Data name="DHCPENetSetsItemDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NSIDDesc</Value>
</Value>
<Value name="3">
<Value>NSIDSort</Value>
</Value>
<Value name="4">
<Value>NSIDIntent</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NSIDetailChild")</DataLocation>
<DefaultData>DHCPENetSetsItemDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetSetsItemC("NSIDetailChild")</IdLocation>
<IndexLocation>^User.DHCPENetSetsItemDetailI</IndexLocation>
<StreamLocation>^User.DHCPENetSetsItemDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
