/// 基础字典项目大类
Class User.DHCMRCBaseDicCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = BDC_RowId, SqlTableName = DHC_MRC_BaseDicCategory ]
{

Relationship ChildSubCat As User.DHCMRCBaseDicSubCategory [ Cardinality = children, Inverse = BDSCParRef ];

Property BDCCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BDC_Code ];

Property BDCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BDC_Desc ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDCCode</Value>
</Value>
<Value name="3">
<Value>BDCDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("BDC")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("BDC")</IdLocation>
<IndexLocation>^DHCMRC("BDC",0)</IndexLocation>
<StreamLocation>^User.DHCMRCBaseDicCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
