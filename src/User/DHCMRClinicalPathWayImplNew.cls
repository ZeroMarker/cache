/// 临床路径新实施记录
Class User.DHCMRClinicalPathWayImplNew Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWEN_RowId, SqlTableName = DHC_MR_ClinicalPathWayImplNew ]
{

/// 主表 DHC_MR_ClinicalPathWay
Relationship CPWENParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildImplNew ];

/// 步骤ID
Property CPWENEpStepDR As User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 3, SqlFieldName = CPWEN_EpStep_DR ];

/// 步骤操作人
Property CPWENDoctor As %String [ SqlColumnNumber = 4, SqlFieldName = CPWEN_Doctor ];

/// 就诊号
Property CPWENPaadm As %String [ SqlColumnNumber = 5, SqlFieldName = CPWEN_Paadm ];

/// 开始日期
Property CPWENStepStrDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CPWEN_StepStrDate ];

/// 开始时间
Property CPWENStepStrTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CPWEN_StepStrTime ];

/// 撤销人
Property CPWENUpdoDoc As %String [ SqlColumnNumber = 8, SqlFieldName = CPWEN_UpdoDoc ];

/// 撤销日期
Property CPWENUpdoDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CPWEN_UpdoDate ];

/// 撤销时间
Property CPWENUpdoTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CPWEN_UpdoTime ];

/// 步骤状态
Property CPWENActive As %String [ SqlColumnNumber = 11, SqlFieldName = CPWEN_Active ];

/// Paadm_RowID 索引
Index IndexPaadm On CPWENPaadm As Exact;

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWENEpStepDR</Value>
</Value>
<Value name="3">
<Value>CPWENDoctor</Value>
</Value>
<Value name="4">
<Value>CPWENPaadm</Value>
</Value>
<Value name="5">
<Value>CPWENStepStrDate</Value>
</Value>
<Value name="6">
<Value>CPWENStepStrTime</Value>
</Value>
<Value name="7">
<Value>CPWENUpdoUser</Value>
</Value>
<Value name="8">
<Value>CPWENStepUpdoDate</Value>
</Value>
<Value name="9">
<Value>CPWENStepUpdoTime</Value>
</Value>
<Value name="10">
<Value>CPWENActive</Value>
</Value>
<Value name="11">
<Value>CPWENUpdoDoc</Value>
</Value>
<Value name="12">
<Value>CPWENUpdoDate</Value>
</Value>
<Value name="13">
<Value>CPWENUpdoTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IMPLNEW")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("IMPLNEW")</IdLocation>
<IndexLocation>^DHCMRi(0,"IMPLNEW")</IndexLocation>
<SqlChildSub>CPWEN_Childsub</SqlChildSub>
<SqlRowIdName>CPWEN_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicalPathWayImplNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
