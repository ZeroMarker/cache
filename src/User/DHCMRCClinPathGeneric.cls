/// 临床路径通用名/病种
Class User.DHCMRCClinPathGeneric Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CLPG_RowId, SqlTableName = DHC_MRC_ClinPathGeneric ]
{

/// 代码
Property CLPGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLPG_Code ];

/// 描述
Property CLPGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLPG_Desc ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLPGCode</Value>
</Value>
<Value name="3">
<Value>CLPGDesc</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("CLPG")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("CLPG")</IdLocation>
<IndexLocation>^DHCMRC("CLPG")(0)</IndexLocation>
<SqlRowIdName>CLPG_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathGenericS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
