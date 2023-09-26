/// Creater:wangpf
/// Descriptions:课题专案
/// Date:2020-07-23
Class DHCINM.Special.SpecialCase Extends %Persistent
{

/// 病区
Property CaseWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Case_Ward ];

/// 参与人
Property CaseNurse As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Case_Nurse ];

/// 类型 K:课题 Z:专案
Property CaseType As %String(DISPLAYLIST = ",课题,专案", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",K,Z") [ SqlColumnNumber = 4, SqlFieldName = Case_Type ];

/// 参与形式 P:参与 H:主持 C:负责 Z:组织 O:其他
Property CaseParType As %String(DISPLAYLIST = ",参与,主持,负责,组织,其他", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",P,H,C,Z,O") [ SqlColumnNumber = 5, SqlFieldName = Case_ParType ];

/// 级别 H:护理部 L:科室 W:病区
Property CaseLevel As %String(DISPLAYLIST = ",护理部,科室,病区", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",H,L,W") [ SqlColumnNumber = 6, SqlFieldName = Case_Level ];

/// 开始日期
Property CaseStDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Case_StDate ];

/// 结束日期
Property CaseEndDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Case_EndDate ];

/// 主题
Property CaseTopic As %String [ SqlColumnNumber = 9, SqlFieldName = Case_Topic ];

/// 所做工作
Property CaseWork As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Case_Work ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property CaseStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 11, SqlFieldName = Case_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 12, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 13, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 14, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 15, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = AuditOpinion ];

Index ToolIndex On (CaseStDate, CaseWard, CaseLevel, CaseType, CaseParType, CaseStatus);

Storage Default
{
<Data name="SpecialCaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CaseWard</Value>
</Value>
<Value name="3">
<Value>CaseNurse</Value>
</Value>
<Value name="4">
<Value>CaseType</Value>
</Value>
<Value name="5">
<Value>CaseParType</Value>
</Value>
<Value name="6">
<Value>CaseLevel</Value>
</Value>
<Value name="7">
<Value>CaseStDate</Value>
</Value>
<Value name="8">
<Value>CaseEndDate</Value>
</Value>
<Value name="9">
<Value>CaseTopic</Value>
</Value>
<Value name="10">
<Value>CaseWork</Value>
</Value>
<Value name="11">
<Value>CaseStatus</Value>
</Value>
<Value name="12">
<Value>Creator</Value>
</Value>
<Value name="13">
<Value>CreateDate</Value>
</Value>
<Value name="14">
<Value>CreateTime</Value>
</Value>
<Value name="15">
<Value>Auditor</Value>
</Value>
<Value name="16">
<Value>AuditDate</Value>
</Value>
<Value name="17">
<Value>AuditTime</Value>
</Value>
<Value name="18">
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialCaseD</DataLocation>
<DefaultData>SpecialCaseDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialCaseD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialCaseI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialCaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
