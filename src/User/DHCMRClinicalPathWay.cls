/// 患者入径出径记录
Class User.DHCMRClinicalPathWay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = CPW_RowId, SqlTableName = DHC_MR_ClinicalPathWay ]
{

/// 执行记录
Relationship ChildImpl As User.DHCMRClinicalPathWayImpl [ Cardinality = children, Inverse = CPWEParRef ];

/// 执行记录
Relationship ChildSyndrome As User.DHCMRClinicalPathWaySyndrome [ Cardinality = children, Inverse = CPWSParRef ];

/// （作废）新执行记录
Relationship ChildImplNew As User.DHCMRClinicalPathWayImplNew [ Cardinality = children, Inverse = CPWENParRef ];

/// 病情变异记录
Relationship ChildVar As User.DHCMRClinicalPathWayVariance [ Cardinality = children, Inverse = CPWVParRef ];

/// 评估记录
Relationship ChildRst As User.DHCMRClinicalPathWayResult [ Cardinality = children, Inverse = CPWRParRef ];

/// 时间、步骤调整记录
Relationship ChildEst As User.DHCMRClinicalPathWayEstimate [ Cardinality = children, Inverse = CPWEParRef ];

/// 签名记录
Relationship ChildSign As User.DHCMRClinicalPathWaySign [ Cardinality = children, Inverse = CPWSParRef ];

/// 入径人
/// Table:CTCareProv
Property CPWInDoctorDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CPW_InDoctor_DR ];

/// 入径日期
Property CPWInDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CPW_InDate ];

/// 入径时间
Property CPWInTime As %Time [ SqlColumnNumber = 7, SqlFieldName = CPW_InTime ];

/// 出径人
/// Table:CTCareProv
Property CPWOutDoctorDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CPW_OutDoctor_DR ];

/// 出径日期
Property CPWOutDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CPW_OutDate ];

/// 出径时间
Property CPWOutTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CPW_OutTime ];

/// 更新日期
Property CPWUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = CPW_Date ];

/// 更新时间
Property CPWUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = CPW_Time ];

/// 更新人
/// Table:SSUser
Property CPWUpdateUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CPW_UpdateUser_DR ];

/// Ref MR_Adm
/// Table:MRAdm
Property CPWMRADMDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CPW_MRADAM_DR ];

/// 临床路径
Property CPWPathwayDR As DHCMRCClinPathWays [ SqlColumnNumber = 3, SqlFieldName = CPW_Pathway_DR ];

/// 临床路径步骤
Property CPWPathwayEpStepDR As DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 4, SqlFieldName = CPW_PathwayEpStep_DR ];

/// 状态 I:入径,O:出径,C:完成
Property CPWStatus As %String(DISPLAYLIST = ",IN,OUT,CLOSE", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",I,O,C") [ SqlColumnNumber = 5, SqlFieldName = CPW_Status_DR ];

/// 并发症列表
Property CPWCompList As list Of %String [ SqlColumnNumber = 17, SqlFieldName = CPW_CompList ];

/// 出径原因
Property CPWOutReasonDR As User.DHCMRCVarianceReason [ SqlColumnNumber = 12, SqlFieldName = CPW_VarianceReason_DR ];

/// 入径科室 Table:CT_Loc
Property CPWInLoc As %String(TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CPW_InLoc ];

/// 入径病区 Table:CT_Loc
Property CPWInWard As %String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = CPW_InWard ];

/// 备注
Property CPWComments As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CPW_Comments ];

/// 就诊号建 索引
Index IndexMRAdm On CPWMRADMDR As SqlString;

/// 入径日期、入径时间 索引
Index IndexInDate On (CPWInDate As Exact, CPWInTime As Exact);

/// 出径日期、出径时间 索引
Index IndexOutDate On (CPWOutDate As Exact, CPWOutTime As Exact);

/// 临床路径、入径日期、入径时间 索引
Index IndexPathWayInDate On (CPWPathwayDR As Exact, CPWInDate As Exact, CPWInTime As Exact);

/// 状态、入径日期、入径时间 索引
Index IndexStatusInDate On (CPWStatus As SqlString, CPWInDate As Exact, CPWInTime As Exact);

/// 临床路径、出径日期、出径时间 索引
Index IndexPathWayOutDate On (CPWPathwayDR As Exact, CPWOutDate As Exact, CPWOutTime As Exact);

/// 状态、出径日期、出径时间 索引
Index IndexStatusOutDate On (CPWStatus As SqlString, CPWOutDate As Exact, CPWOutTime As Exact);

/// 出径原因、出径日期、出径时间 索引
Index IndexOutReasonOutDate On (CPWOutReasonDR As Exact, CPWOutDate As Exact, CPWOutTime As Exact);

/// Creator：     zhufei
/// CreatDate：   2015-05-27
/// Description:  根据ID取路径医嘱
/// Table：       User.DHCMRClinicalPathWay
/// Input：       Id : User.DHCMRClinicalPathWay.ID
/// Return：      返回Object
/// w ##class(User.DHCMRClinicalPathWay).GetObjById(1)
ClassMethod GetObjById(aId As %String) As User.DHCMRClinicalPathWay
{
	new (aId)
	quit:'##class(User.DHCMRClinicalPathWay).%ExistsId(aId) ""
	set obj=##Class(User.DHCMRClinicalPathWay).%OpenId(aId)
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
<Value>CPWMRADMDR</Value>
</Value>
<Value name="3">
<Value>CPWPathwayDR</Value>
</Value>
<Value name="4">
<Value>CPWPathwayEpStepDR</Value>
</Value>
<Value name="5">
<Value>CPWStatus</Value>
</Value>
<Value name="6">
<Value>CPWInDate</Value>
</Value>
<Value name="7">
<Value>CPWInTime</Value>
</Value>
<Value name="8">
<Value>CPWInDoctorDR</Value>
</Value>
<Value name="9">
<Value>CPWOutDate</Value>
</Value>
<Value name="10">
<Value>CPWOutTime</Value>
</Value>
<Value name="11">
<Value>CPWOutDoctorDR</Value>
</Value>
<Value name="12">
<Value>CPWOutReasonDR</Value>
</Value>
<Value name="13">
<Value>CPWComments</Value>
</Value>
<Value name="14">
<Value>CPWUpdateDate</Value>
</Value>
<Value name="15">
<Value>CPWUpdateTime</Value>
</Value>
<Value name="16">
<Value>CPWUpdateUserDR</Value>
</Value>
<Value name="17">
<Value>CPWCompList</Value>
</Value>
<Value name="18">
<Value>CPWInLoc</Value>
</Value>
<Value name="19">
<Value>CPWInWard</Value>
</Value>
</Data>
<DataLocation>^DHCMR("CPW")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMR("CPW")</IdLocation>
<IndexLocation>^DHCMRi("CPW",0)</IndexLocation>
<SqlRowIdName>CPW_RowId</SqlRowIdName>
<StreamLocation>^User.DHCMRClinicalPathWayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
