Class User.DHCMRClinicalPathWayVariance Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWV_RowId, SqlTableName = DHC_MR_ClinicalPathWayVariance ]
{

Relationship CPWVParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildVar, SqlFieldName = CPWV_ParRef ];

/// 对应阶段
Property CPWVEpisodeDR As DHCMRCClinPathWaysEp [ SqlColumnNumber = 3, SqlFieldName = CPWV_Episode_DR ];

/// 变异类型  
Property CPWVCategoryDR As User.DHCMRCVarianceCategory [ SqlColumnNumber = 4, SqlFieldName = CPWV_Category_DR ];

/// 变异原因
Property CPWVReasonDR As DHCMRCVarianceReason [ SqlColumnNumber = 5, SqlFieldName = CPWV_Reason_DR ];

/// 变异备注
Property CPWVNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CPWV_Note ];

/// 保存日期
Property CPWVDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWV_Date ];

/// 保存时间
Property CPWVTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CPWV_Time ];

/// 保存人
/// Table:SSUser
Property CPWVUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWV_User_DR ];

/// 确认医生
/// Table:CTCareProv
Property CPWVDoctorDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPWV_Doctor_DR ];

/// 步骤
Property CPWVEpStepDR As User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 11, SqlFieldName = CPWV_EpStep_DR ];

/// 撤销标记
Property CPWVUpdoFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CPWV_UpdoFlag ];

/// 撤销日期
Property CPWVUpdoDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CPWV_UpdoDate ];

/// 撤销时间
Property CPWVUpdoTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CPWV_UpdoTime ];

/// 撤销人
/// Table:SSUser
Property CPWVUpdoUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CPWV_UpdoUser_DR ];

/// 附加值（标记对应医嘱或其他）
Property CPWVExtraValues As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CPWV_ExtraValues ];

/// 新实施记录
Property CPWVImplNewDR As User.DHCMRClinicalPathWayImplNew [ SqlColumnNumber = 17, SqlFieldName = CPWV_ImplNew_DR ];

/// 根据阶段步骤建索引
Index IndexEpStep On (CPWVParRef As Exact, CPWVEpStepDR As Exact);

/// Creator：     zhufei
/// CreatDate：   2010-05-16
/// Description:  根据ID取临床路径记录
/// Table：       User.DHCMRClinicalPathWayVariance
/// Input：       ID:    User.DHCMRClinicalPathWayVariance.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(User.DHCMRClinicalPathWayVariance).GetObjById(1)
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayVariance
{
	New (argId)
	Set return=##Class(User.DHCMRClinicalPathWayVariance).%OpenId(argId)
	Do:return'="" return.%Close()
	Quit return
}

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWVEpisodeDR</Value>
</Value>
<Value name="3">
<Value>CPWVCategoryDR</Value>
</Value>
<Value name="4">
<Value>CPWVReasonDR</Value>
</Value>
<Value name="5">
<Value>CPWVNote</Value>
</Value>
<Value name="6">
<Value>CPWVDate</Value>
</Value>
<Value name="7">
<Value>CPWVTime</Value>
</Value>
<Value name="8">
<Value>CPWVUserDR</Value>
</Value>
<Value name="9">
<Value>CPWVDoctorDR</Value>
</Value>
<Value name="10">
<Value>CPWVEpStepDR</Value>
</Value>
<Value name="11">
<Value>CPWVUpdoFlag</Value>
</Value>
<Value name="12">
<Value>CPWVUpdoDate</Value>
</Value>
<Value name="13">
<Value>CPWVUpdoTime</Value>
</Value>
<Value name="14">
<Value>CPWVUpdoUserDR</Value>
</Value>
<Value name="15">
<Value>CPWVExtraValues</Value>
</Value>
<Value name="16">
<Value>CPWVImplNewDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("VAR")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("VAR")</IdLocation>
<IndexLocation>^DHCMRi(0,"VAR")</IndexLocation>
<SqlChildSub>CPWV_Childsub</SqlChildSub>
<SqlRowIdName>CPWV_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicaA74S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
