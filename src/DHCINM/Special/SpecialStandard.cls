/// Creater:wangpf
/// Descriptions:规范参与情况
/// Date:2020-07-22
Class DHCINM.Special.SpecialStandard Extends %Persistent
{

/// 类型 G:规范 D:指引 F:表单 S:标准 L:流程 O:其他
Property StandardType As %String(DISPLAYLIST = ",规范,指引,表单,标准,流程,其他", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",G,D,F,S,L,O") [ SqlColumnNumber = 2, SqlFieldName = Standard_Type ];

/// 子类型 C:制定 U:修订
Property StandardTypeSub As %String(DISPLAYLIST = ",制定,修订", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",C,U") [ SqlColumnNumber = 3, SqlFieldName = Standard_TypeSub ];

/// 专业组
Property StandardGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 4, SqlFieldName = Standard_Group ];

/// 名称
Property StandardDesc As %String [ SqlColumnNumber = 5, SqlFieldName = Standard_Desc ];

/// 参与人
Property StandardParticipant As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Standard_Participant ];

/// 文件
Property StandardFile As %String [ SqlColumnNumber = 7, SqlFieldName = Standard_File ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property StandardStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 8, SqlFieldName = Standard_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 9, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 11, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 12, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 13, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 14, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = AuditOpinion ];

Index ToolIndex On (CreateDate, StandardGroup, StandardType, StandardTypeSub, StandardStatus);

Storage Default
{
<Data name="SpecialStandardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StandardType</Value>
</Value>
<Value name="3">
<Value>StandardTypeSub</Value>
</Value>
<Value name="4">
<Value>StandardGroup</Value>
</Value>
<Value name="5">
<Value>StandardDesc</Value>
</Value>
<Value name="6">
<Value>StandardParticipant</Value>
</Value>
<Value name="7">
<Value>StandardFile</Value>
</Value>
<Value name="8">
<Value>StandardStatus</Value>
</Value>
<Value name="9">
<Value>Creator</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>Auditor</Value>
</Value>
<Value name="13">
<Value>AuditDate</Value>
</Value>
<Value name="14">
<Value>AuditTime</Value>
</Value>
<Value name="15">
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialStandardD</DataLocation>
<DefaultData>SpecialStandardDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialStandardD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialStandardI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialStandardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
