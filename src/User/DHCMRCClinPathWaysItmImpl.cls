/// 临床路径项目
Class User.DHCMRCClinPathWaysItmImpl Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWSII_RowId, SqlTableName = DHC_MRC_ClinPathWaysItmImpl ]
{

Relationship CPWSIIParRef As User.DHCMRCClinPathWaysEpStepItem [ Cardinality = parent, Inverse = ChildItmImpl, SqlFieldName = CPWSII_ParRef ];

/// 关联类型
Property CPWSIIType As %String(DISPLAYLIST = ",ARCIM,EPRIM", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",A,E") [ SqlColumnNumber = 3, SqlFieldName = CPWSII_Type ];

/// 关联项目
Property CPWSIIValue As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPWSII_Value ];

/// 说明
Property CPWSIINote As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CPWSII_Note ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWSIIType</Value>
</Value>
<Value name="3">
<Value>CPWSIIValue</Value>
</Value>
<Value name="4">
<Value>CPWSIINote</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IMPL")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("IMPL")</IdLocation>
<IndexLocation>^DHCMRCi("CPW",0,"IMPL")</IndexLocation>
<SqlChildSub>CPWSII_Childsub</SqlChildSub>
<SqlRowIdName>CPWSII_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPa924S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
