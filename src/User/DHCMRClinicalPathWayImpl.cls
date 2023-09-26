/// 临床路径实施记录
Class User.DHCMRClinicalPathWayImpl Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWE_RowId, SqlTableName = DHC_MR_ClinicalPathWayImpl ]
{

Relationship CPWEParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildImpl ];

/// 执行步骤
Property CPWEStepDR As DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 16, SqlFieldName = CPWE_Step_DR ];

/// 执行项目
Property CPWEStepItemDR As DHCMRCClinPathWaysEpStepItem [ SqlColumnNumber = 3, SqlFieldName = CPWE_StepItem_DR ];

/// 实施日期
Property CPWEImplementDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWE_ImplementDate ];

/// 实施时间
Property CPWEImplementTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CPWE_ImplementTime ];

/// 对应医嘱记录 指向OE_OrdItem
Property CPWEOEORIDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CPWE_OEORI_DR ];

/// 对应诊疗记录 指向???
Property CPWEDIAGDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CPWE_DIAG_DR ];

/// 对应护理记录 指向???
Property CPWENURSEDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CPWE_NURSE_DR ];

/// 对应医生 指向CT_CareProv
Property CPWEDoctorDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPWE_Doctor_DR ];

/// 保存日期
Property CPWEDate As %Date [ SqlColumnNumber = 5, SqlFieldName = CPWE_Date ];

/// 保存时间
Property CPWETime As %Time [ SqlColumnNumber = 6, SqlFieldName = CPWE_Time ];

/// 保存人 指向SS_User
Property CPWEUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWE_User_DR ];

/// 撤销日期
Property CPWEUpdoDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CPWE_UpdoDate ];

/// 撤销时间
Property CPWEUpdoTime As %Time [ SqlColumnNumber = 13, SqlFieldName = CPWE_UpdoTime ];

/// 撤销人 指向SS_User
Property CPWEUpdoUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CPWE_UpdoUser_DR ];

/// 是否有效
Property CPWEActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = CPWE_Active ];

/// 操作意见
Property CPWEProcNote As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CPWE_ProcNote ];

/// （作废）新实施记录
Property CPWEImplNewDR As User.DHCMRClinicalPathWayImplNew [ SqlColumnNumber = 17, SqlFieldName = CPWE_ImplNew_DR ];

/// （作废）根据项目建索引
Index IndexStepItem On (CPWEParRef As Exact, CPWEStepItemDR As Exact);

/// （作废）根据步骤建索引
Index IndexStepDR On (CPWEParRef As Exact, CPWEStepDR As Exact);

/// 根据步骤+项目建索引
Index IndexStepItemNew On (CPWEParRef As Exact, CPWEStepDR As Exact, CPWEStepItemDR As Exact);

/// 根据医嘱记录建索引
Index IndexStepOEORIDr On (CPWEParRef As Exact, CPWEStepDR As Exact, CPWEOEORIDR As Exact);

/// 根据诊疗记录建索引
Index IndexStepDIAGDr On (CPWEParRef As Exact, CPWEStepDR As Exact, CPWEDIAGDR As Exact);

/// 根据护理记录建索引
Index IndexStepNURSEDr On (CPWEParRef As Exact, CPWEStepDR As Exact, CPWENURSEDR As Exact);

/// Creator：     zhufei
/// CreatDate：   2015-06-30
/// Description:  根据ID取路径医嘱
/// Table：       User.DHCMRClinicalPathWayImpl
/// Input：       Id : User.DHCMRClinicalPathWayImpl.ID
/// Return：      返回Object
/// w ##class(User.DHCMRClinicalPathWayImpl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRClinicalPathWayImpl
{
	new (aId)
	quit:'##class(User.DHCMRClinicalPathWayImpl).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRClinicalPathWayImpl).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWEOEORIDR</Value>
</Value>
<Value name="3">
<Value>CPWEStepItemDR</Value>
</Value>
<Value name="4">
<Value>CPWEDate</Value>
</Value>
<Value name="5">
<Value>CPWETime</Value>
</Value>
<Value name="6">
<Value>CPWEUserDR</Value>
</Value>
<Value name="7">
<Value>CPWEImplementDate</Value>
</Value>
<Value name="8">
<Value>CPWEImplementTime</Value>
</Value>
<Value name="9">
<Value>CPWEDoctorDR</Value>
</Value>
<Value name="10">
<Value>CPWEActive</Value>
</Value>
<Value name="11">
<Value>CPWEUpdoDate</Value>
</Value>
<Value name="12">
<Value>CPWEUpdoTime</Value>
</Value>
<Value name="13">
<Value>CPWEUpdoUserDR</Value>
</Value>
<Value name="14">
<Value>CPWEProcNote</Value>
</Value>
<Value name="15">
<Value>CPWEStepDR</Value>
</Value>
<Value name="16">
<Value>CPWEImplNewDR</Value>
</Value>
<Value name="17">
<Value>CPWEDIAGDR</Value>
</Value>
<Value name="18">
<Value>CPWENURSEDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("IMPL")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("IMPL")</IdLocation>
<IndexLocation>^DHCMRi(0,"IMPL")</IndexLocation>
<SqlChildSub>CPWE_Childsub</SqlChildSub>
<SqlRowIdName>CPWE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicalPathWayImplS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
