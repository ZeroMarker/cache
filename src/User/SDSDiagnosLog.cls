/// Creator:高姗姗
/// CreatDate:2019-07-22
/// Description：结构化诊断日志表
/// Table：User.SDSDiagnosLog
Class User.SDSDiagnosLog Extends (%Persistent, User.Abstract) [ SqlTableName = SDS_DiagnosLog ]
{

/// 更新人
Property SDSUpdateUserDR As %String [ Required, SqlColumnNumber = 2, SqlFieldName = SDS_UpdateUser_DR ];

/// 更新日期
Property SDSUpdateDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = SDS_UpdateDate ];

/// 更新时间
Property SDSUpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 4, SqlFieldName = SDS_UpdateTime ];

/// 操作类型
Property SDSOperateType As %String(DISPLAYLIST = ",Add,Read,Update,Delete,Ref", VALUELIST = ",A,R,U,D,R") [ Required, SqlColumnNumber = 5, SqlFieldName = SDS_OperateType ];

/// 修正前的原始数据
Property SDSOldValue As %String(MAXLEN = "") [ SqlColumnNumber = 6, SqlFieldName = SDS_OldValue ];

/// 新增、修正的数据
Property SDSNewValue As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = SDS_NewValue ];

/// 更新科室
Property SDSUpdateLocDR As %String [ Required, SqlColumnNumber = 8, SqlFieldName = SDS_UpdateLoc_DR ];

/// 就诊指向
Property SDSAdmDR As SDSAdm [ Required, SqlColumnNumber = 9, SqlFieldName = SDS_Adm_DR ];

/// 操作用户的Ip地址
Property SDSIpAddress As %String(MAXLEN = "") [ SqlColumnNumber = 10, SqlFieldName = SDS_IpAddress ];

/// 诊断RowId
Property SDSReference As SDSDiagnos [ Required, SqlColumnNumber = 11, SqlFieldName = SDS_Reference ];

/// 诊断引用场景指向
Property SDSSceneDR As MKBTerm [ SqlColumnNumber = 12, SqlFieldName = SDS_Scene_DR ];

/// 诊断ID的索引
Index RefIndex On SDSReference As Exact;

/// 操作类型的索引
Index OperateTypeIndex On (SDSOperateType As Exact, SDSReference As Exact);

/// 本次就诊操作类型的索引
Index AdmTypeIndex On (SDSOperateType As Exact, SDSAdmDR, SDSReference As Exact);

/// 更新人的索引
Index UpdateUserIndex On (SDSOperateType As Exact, SDSUpdateUserDR, SDSReference As Exact);

/// 更新科室的索引
Index UpdateLocIndex On (SDSOperateType As Exact, SDSUpdateLocDR, SDSReference As Exact);

Storage Default
{
<Data name="SDSDiagnosLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SDSUpdateUserDR</Value>
</Value>
<Value name="3">
<Value>SDSUpdateDate</Value>
</Value>
<Value name="4">
<Value>SDSUpdateTime</Value>
</Value>
<Value name="5">
<Value>SDSOperateType</Value>
</Value>
<Value name="6">
<Value>SDSOldValue</Value>
</Value>
<Value name="7">
<Value>SDSNewValue</Value>
</Value>
<Value name="8">
<Value>SDSUpdateLocDR</Value>
</Value>
<Value name="9">
<Value>SDSAdmDR</Value>
</Value>
<Value name="10">
<Value>SDSIpAddress</Value>
</Value>
<Value name="11">
<Value>SDSReference</Value>
</Value>
<Value name="12">
<Value>SDSSceneDR</Value>
</Value>
</Data>
<DataLocation>^User.SDSDiagnosLogD</DataLocation>
<DefaultData>SDSDiagnosLogDefaultData</DefaultData>
<IdLocation>^User.SDSDiagnosLogD</IdLocation>
<IndexLocation>^User.SDSDiagnosLogI</IndexLocation>
<StreamLocation>^User.SDSDiagnosLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
