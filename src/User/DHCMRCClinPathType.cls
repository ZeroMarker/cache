/// 临床路径类型
Class User.DHCMRCClinPathType Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CLPT_RowId, SqlTableName = DHC_MRC_ClinPathType ]
{

/// Code
Property CLPTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLPT_Code ];

/// Description
Property CLPTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLPT_Desc ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLPTCode</Value>
</Value>
<Value name="3">
<Value>CLPTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("CLPT")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("CLPT")</IdLocation>
<IndexLocation>^DHCMRC("CLPT")(0)</IndexLocation>
<SqlRowIdName>CLPT_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
