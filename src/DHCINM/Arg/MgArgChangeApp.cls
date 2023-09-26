/// Creater:wangpf
/// Descriptions:改班申请表
/// Date:2020-06-29
Class DHCINM.Arg.MgArgChangeApp Extends %Persistent
{

/// 改班病区
Property ChangeWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Change_Ward ];

/// 改班人(创建人)
Property ChangeNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 3, SqlFieldName = Change_Nurse ];

/// 改班来源
Property ChangeSource As DHCINM.Arg.MgArrangeSub [ SqlColumnNumber = 4, SqlFieldName = Change_Source ];

/// 改班来源日期
Property ChangeSourceDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Change_SourceDate ];

/// 改班原班次
Property ChangeFromPost As CF.DHCINM.DB.MgArgWardPost [ SqlColumnNumber = 6, SqlFieldName = Change_FromPost ];

/// 改班期望班次
Property ChangeToPost As CF.DHCINM.DB.MgArgWardPost [ SqlColumnNumber = 7, SqlFieldName = Change_ToPost ];

/// 状态 B:驳回 Y:提交 A:审核
Property ChangeStatus As %String(DISPLAYLIST = ",驳回,提交,审核", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",B,Y,A") [ SqlColumnNumber = 8, SqlFieldName = Change_Status ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 9, SqlFieldName = CreateDate ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 10, SqlFieldName = CreateTime ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 11, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 12, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 13, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = AuditOpinion ];

Index Status On ChangeStatus;

Storage Default
{
<Data name="MgArgChangeAppDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ChangeWard</Value>
</Value>
<Value name="3">
<Value>ChangeNurse</Value>
</Value>
<Value name="4">
<Value>ChangeSource</Value>
</Value>
<Value name="5">
<Value>ChangeSourceDate</Value>
</Value>
<Value name="6">
<Value>ChangeFromPost</Value>
</Value>
<Value name="7">
<Value>ChangeToPost</Value>
</Value>
<Value name="8">
<Value>ChangeStatus</Value>
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
</Data>
<DataLocation>^DHCINM.Arg.MgArgChangeAppD</DataLocation>
<DefaultData>MgArgChangeAppDefaultData</DefaultData>
<IdLocation>^DHCINM.Arg.MgArgChangeAppD</IdLocation>
<IndexLocation>^DHCINM.Arg.MgArgChangeAppI</IndexLocation>
<StreamLocation>^DHCINM.Arg.MgArgChangeAppS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
