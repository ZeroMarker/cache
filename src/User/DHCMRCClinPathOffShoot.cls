/// 临床路径分支路径
Class User.DHCMRCClinPathOffShoot Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CLPOS_RowId, SqlTableName = DHC_MRC_ClinPathOffShoot ]
{

/// 代码
Property CLPOSCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CLPOS_Code ];

/// 描述
Property CLPOSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CLPOS_Desc ];

/// 表单指针
Property CLPOSFormDR As User.DHCMRCClinPathWays [ SqlColumnNumber = 4, SqlFieldName = CLPOS_Form_DR ];

/// 步骤列表
Property CLPOSStepList As list Of User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 5, SqlFieldName = CLPOS_StepList ];

/// 临床路径通用名
Property CLPOSGenericDR As User.DHCMRCClinPathGeneric [ SqlColumnNumber = 6, SqlFieldName = CLPOS_Generic_DR ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLPOSCode</Value>
</Value>
<Value name="3">
<Value>CLPOSDesc</Value>
</Value>
<Value name="4">
<Value>CLPOSFormDR</Value>
</Value>
<Value name="5">
<Value>CLPOSStepList</Value>
</Value>
<Value name="6">
<Value>CLPOSGenericDR</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("CLPOS")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMRC("CLPOS")</IdLocation>
<IndexLocation>^DHCMRC("CLPOS")(0)</IndexLocation>
<SqlRowIdName>CLPOS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathOffShootS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
