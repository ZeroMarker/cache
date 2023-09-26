/// Creater:wangpf
/// Descriptions:专业组规划
/// Date:2020-07-21
Class DHCINM.Special.SpecialLayout Extends %Persistent
{

/// 专业组
Property LayoutGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 2, SqlFieldName = Layout_Group ];

/// 规划期限
Property LayoutYear As %String [ SqlColumnNumber = 3, SqlFieldName = Layout_Year ];

/// 开始日期
Property LayoutStDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Layout_StDate ];

/// 结束日期
Property LayoutEndDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Layout_EndDate ];

/// 规划内容
Property LayoutContent As %String(MAXLEN = 100000) [ SqlColumnNumber = 6, SqlFieldName = Layout_Content ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property LayoutStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 7, SqlFieldName = Layout_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 8, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 11, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 12, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 13, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = AuditOpinion ];

/// 规划内容
Property LayoutContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 15, SqlFieldName = Layout_ContentExt ];

Index ToolIndex On (LayoutStDate, LayoutGroup, LayoutStatus);

Storage Default
{
<Data name="SpecialLayoutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LayoutGroup</Value>
</Value>
<Value name="3">
<Value>LayoutYear</Value>
</Value>
<Value name="4">
<Value>LayoutStDate</Value>
</Value>
<Value name="5">
<Value>LayoutEndDate</Value>
</Value>
<Value name="6">
<Value>LayoutContent</Value>
</Value>
<Value name="7">
<Value>LayoutStatus</Value>
</Value>
<Value name="8">
<Value>Creator</Value>
</Value>
<Value name="9">
<Value>CreateDate</Value>
</Value>
<Value name="10">
<Value>CreateTime</Value>
</Value>
<Value name="11">
<Value>Auditor</Value>
</Value>
<Value name="12">
<Value>AuditDate</Value>
</Value>
<Value name="13">
<Value>AuditTime</Value>
</Value>
<Value name="14">
<Value>AuditOpinion</Value>
</Value>
<Value name="15">
<Value>LayoutContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialLayoutD</DataLocation>
<DefaultData>SpecialLayoutDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialLayoutD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialLayoutI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialLayoutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
