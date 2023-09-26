Class User.DHCPENetSetsItemType Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ProcedureBlock ]
{

Parameter ClassName = "User.DHCPENetSetsItemType";

/// 套餐表
Relationship NSITParRef As User.DHCPENetOrdSets [ Cardinality = parent, Inverse = NOSItemTypeChild ];

/// 项目分类ID
Property NSITItemTypeID As User.DHCPENetItemType [ Required, SqlFieldName = NSIT_ItemTypeID ];

/// 序号
Property NSITSort As %Integer [ Required, SqlFieldName = NSIT_Sort ];

/// 套餐包含项目
Relationship NSITItemChild As User.DHCPENetSetsItem [ Cardinality = children, Inverse = NSIParRef ];

Index SortIndex On NSITSort As AlphaUp;

Index TypeIndex On NSITItemTypeID As AlphaUp;

Storage Default
{
<Data name="DHCPENetSetsItemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NSITItemTypeID</Value>
</Value>
<Value name="3">
<Value>NSITSort</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("NOSItemTypeChild")</DataLocation>
<DefaultData>DHCPENetSetsItemTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetOrdSetsC("NOSItemTypeChild")</IdLocation>
<IndexLocation>^User.DHCPENetSetsItemTypeI</IndexLocation>
<StreamLocation>^User.DHCPENetSetsItemTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
