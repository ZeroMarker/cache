/// 临床路径规则
Class User.DHCMRCClinPathWaysRule Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWR_RowId, SqlTableName = DHC_MRC_ClinPathWaysRule ]
{

/// Ref  DHC_MRC_ClinPathWays
Relationship CPWRParRef As User.DHCMRCClinPathWays [ Cardinality = parent, Inverse = ChildRule ];

/// 激活标志
Property CPWRActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CPWR_ActiveFlag ];

/// 规则表达式
Property CPWRExpression As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPWR_Expression ];

/// 表达式描述
Property CPWRDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CPWR_Desc ];

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWRDesc</Value>
</Value>
<Value name="3">
<Value>CPWRActiveFlag</Value>
</Value>
<Value name="4">
<Value>CPWRExpression</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("RULE")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("RULE")</IdLocation>
<IndexLocation>{%%PARENT}("RULE")(0)</IndexLocation>
<SqlChildSub>CPWR_Childsub</SqlChildSub>
<SqlRowIdName>CPWR_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRCClinPathWaysRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
