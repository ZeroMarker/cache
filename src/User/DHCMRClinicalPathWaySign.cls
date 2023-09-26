/// 临床路径签名记录
Class User.DHCMRClinicalPathWaySign Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = CPWS_RowId, SqlTableName = DHC_MR_ClinicalPathWaySign ]
{

Relationship CPWSParRef As User.DHCMRClinicalPathWay [ Cardinality = parent, Inverse = ChildSign ];

/// 步骤
Property CPWSEpStepDR As User.DHCMRCClinPathWaysEpStep [ SqlColumnNumber = 3, SqlFieldName = CPWS_EpStep_DR ];

/// 医生签名  Ref User.CTCareProv
/// Table:CT_CareProv
Property CPWSDoctorDR As %String [ SqlColumnNumber = 4, SqlFieldName = CPWS_Doctor_DR ];

/// 护士签名  Ref User.CTCareProv
/// Table:CT_CareProv
Property CPWSNurseDR As %String [ SqlColumnNumber = 5, SqlFieldName = CPWS_Nurse_DR ];

/// 激活标志
Property CPWSActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CPWS_Active ];

/// 保存日期
Property CPWSDate As %Date [ SqlColumnNumber = 7, SqlFieldName = CPWS_Date ];

/// 保存时间
Property CPWSTime As %Time [ SqlColumnNumber = 8, SqlFieldName = CPWS_Time ];

/// 保存人  Ref User.SSUser
/// Table:SS_User
Property CPWSUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CPWS_User_DR ];

/// 撤销日期
Property CPWSUpdoDate As %Date [ SqlColumnNumber = 10, SqlFieldName = CPWS_UpdoDate ];

/// 撤销时间
Property CPWSUpdoTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CPWS_UpdoTime ];

/// 撤销人  Ref User.SSUser
/// Table:SS_User
Property CPWSUpdoUserDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CPWS_UpdoUser_DR ];

/// 新实施记录
Property CPWSImplNewDR As User.DHCMRClinicalPathWayImplNew [ SqlColumnNumber = 13, SqlFieldName = CPWS_ImplNew_DR ];

/// 根据阶段步骤建索引
Index IndexEpStep On (CPWSParRef As Exact, CPWSEpStepDR As Exact);

Storage Default
{
<Data name="DataMaster">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPWSEpStepDR</Value>
</Value>
<Value name="3">
<Value>CPWSDoctorDR</Value>
</Value>
<Value name="4">
<Value>CPWSNurseDR</Value>
</Value>
<Value name="5">
<Value>CPWSActive</Value>
</Value>
<Value name="6">
<Value>CPWSDate</Value>
</Value>
<Value name="7">
<Value>CPWSTime</Value>
</Value>
<Value name="8">
<Value>CPWSUserDR</Value>
</Value>
<Value name="9">
<Value>CPWSUpdoDate</Value>
</Value>
<Value name="10">
<Value>CPWSUpdoTime</Value>
</Value>
<Value name="11">
<Value>CPWSUpdoUserDR</Value>
</Value>
<Value name="12">
<Value>CPWSImplNewDR</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SIGN")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("SIGN")</IdLocation>
<IndexLocation>^DHCMRi(0,"SIGN")</IndexLocation>
<StreamLocation>^User.DHCMRClinicalPathWaySignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
