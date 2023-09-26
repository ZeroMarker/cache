/// 临床路径项目大类
Class User.DHCMRCStepItemCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = SIC_RowId, SqlTableName = DHC_MRC_StepItemCategory ]
{

Relationship ChildSubCat As User.DHCMRCStepItemSubCategory [ Cardinality = children, Inverse = SISCParRef ];

Property SICCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SIC_Code ];

Property SICDesc As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SIC_Desc ];

Property SICDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SIC_DateFrom ];

Property SICDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SIC_DateTo ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SICCode</Value>
</Value>
<Value name="3">
<Value>SICDesc</Value>
</Value>
<Value name="4">
<Value>SICDateFrom</Value>
</Value>
<Value name="5">
<Value>SICDateTo</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("SIC")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("SIC")</IdLocation>
<IndexLocation>^DHCMRC("SIC",0)</IndexLocation>
<StreamLocation>^User.DHCMRCStepItemCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
