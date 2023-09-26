/// 临床路径评估记录
Class User.DHCMRClinicalPathWayEstimate Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPWE_RowId, SqlTableName = DHC_MR_ClinicalPathWayEstimate ]
{

Relationship CPWEParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildEst ];

/// 开始步骤
Property CPWEEpStepDR As User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 3, SqlFieldName = CPWE_EpStep_DR ];

/// 开始日期
Property CPWEStartDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CPWE_StartDate ];

/// 开始时间
Property CPWEStartTime As %Time [ SqlColumnNumber = 5, SqlFieldName = CPWE_StartTime ];

/// 步骤时间
Property CPWETimes As list Of User.DHCMRClinicalPathWayEstTimes [ SqlColumnNumber = 6, SqlFieldName = CPWE_Times ];

/// 保存日期
Property CPWEDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWE_Date ];

/// 保存时间
Property CPWETime As %Time [ SqlColumnNumber = 8, SqlFieldName = CPWE_Time ];

/// 保存人  Ref User.SSUser
/// Table:SS_User
Property CPWEUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWE_User_DR ];

/// Creator：     zhufei
/// CreatDate：   2011-04-18
/// Description:  根据ID取评估记录
/// Table：       User.DHCMRClinicalPathWayEstimate
/// Input：       ID:    User.DHCMRClinicalPathWayEstimate.Id
///               separete: 指定的分隔符
/// Return：      返回object
/// w ##class(User.DHCMRClinicalPathWayEstimate).GetObjById("1||1")
ClassMethod GetObjById(argId As %String) As User.DHCMRClinicalPathWayEstimate
{
	New (argId)
	Quit:$p(argId,"||",1)="" ""
	Quit:$p(argId,"||",2)="" ""
	Set return=##Class(User.DHCMRClinicalPathWayEstimate).%OpenId(argId)
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
<Value>CPWEEpStepDR</Value>
</Value>
<Value name="3">
<Value>CPWEStartDate</Value>
</Value>
<Value name="4">
<Value>CPWEStartTime</Value>
</Value>
<Value name="5">
<Value>CPWETimes</Value>
</Value>
<Value name="6">
<Value>CPWEDate</Value>
</Value>
<Value name="7">
<Value>CPWETime</Value>
</Value>
<Value name="8">
<Value>CPWEUserDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("EST")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("EST")</IdLocation>
<IndexLocation>^DHCMRi(0,"EST")</IndexLocation>
<SqlChildSub>CPWE_Childsub</SqlChildSub>
<SqlRowIdName>CPWE_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicaA87S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
