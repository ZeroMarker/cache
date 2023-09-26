/// 护理计划项目触发完成因素码表
Class User.DHCNurPlanFactors Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = F_RowId, SqlTableName = DHC_NurPlan_Factors ]
{

Property FCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = F_Code ];

Property FDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = F_Desc ];

Property FTyp As %String [ Required, SqlColumnNumber = 4, SqlFieldName = F_Typ ];

Property FNote As %String [ SqlColumnNumber = 5, SqlFieldName = F_Note ];

Property FEmrCode As %String [ SqlColumnNumber = 6, SqlFieldName = F_EmrCode ];

/// 接口函数
Property FFunction As %String [ SqlColumnNumber = 7, SqlFieldName = F_Function ];

/// 参数
Property FParameter As %String [ SqlColumnNumber = 8, SqlFieldName = F_Parameter ];

/// 函数类型
Property FFuncType As %String [ SqlColumnNumber = 9, SqlFieldName = F_FuncType ];

Property FDateFrom As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = F_DateFrom ];

Property FDateTo As %Date [ SqlColumnNumber = 11, SqlFieldName = F_DateTo ];

Index Code On FCode;

Index Desc On FDesc;

Index Typ On FTyp;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FCode</Value>
</Value>
<Value name="3">
<Value>FDesc</Value>
</Value>
<Value name="4">
<Value>FTyp</Value>
</Value>
<Value name="5">
<Value>FNote</Value>
</Value>
<Value name="6">
<Value>FEmrCode</Value>
</Value>
<Value name="7">
<Value>FFunction</Value>
</Value>
<Value name="8">
<Value>FParameter</Value>
</Value>
<Value name="9">
<Value>FFuncType</Value>
</Value>
<Value name="10">
<Value>FDateFrom</Value>
</Value>
<Value name="11">
<Value>FDateTo</Value>
</Value>
</Data>
<DataLocation>^DHCNurPlan("Factors")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCNurPlan("Factors")</IdLocation>
<IndexLocation>^DHCNurPlani("Factors",0)</IndexLocation>
<StreamLocation>^User.DHCNurPlanFactorsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
