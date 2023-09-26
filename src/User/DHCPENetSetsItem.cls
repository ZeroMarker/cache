Class User.DHCPENetSetsItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Parameter ClassName = "User.DHCPENetSetsItem";

/// 套餐项目分类
Relationship NSIParRef As User.DHCPENetSetsItemType [ Cardinality = parent, Inverse = NSITItemChild ];

/// 项目描述
Property NSIItemDesc As %String(MAXLEN = 100) [ Required, SqlFieldName = NSI_ItemDesc ];

/// 序号
Property NSISort As %Integer [ SqlFieldName = NSI_Sort ];

/// 项目明细
Relationship NSIDetailChild As User.DHCPENetSetsItemDetail [ Cardinality = children, Inverse = NSIDParRef ];

Index SortIndex On NSISort As AlphaUp;

Index DescIndex On NSIItemDesc As AlphaUp;

Storage Default
{
<Data name="DHCPENetSetsItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NSIItemDesc</Value>
</Value>
<Value name="3">
<Value>NSISort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NSITItemChild")</DataLocation>
<DefaultData>DHCPENetSetsItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetSetsItemTypeC("NSITItemChild")</IdLocation>
<IndexLocation>^User.DHCPENetSetsItemI</IndexLocation>
<StreamLocation>^User.DHCPENetSetsItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
