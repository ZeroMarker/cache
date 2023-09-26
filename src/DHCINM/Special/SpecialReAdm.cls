/// Creater:wangpf
/// Descriptions:专科护士再认证
/// Date:2020-07-24
Class DHCINM.Special.SpecialReAdm Extends %Persistent
{

/// 人员
Property AdmPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Adm_Per ];

/// 成绩
Property AdmScore As list Of %String [ SqlColumnNumber = 3, SqlFieldName = Adm_Score ];

/// 是否通过
Property AdmPass As list Of %String [ SqlColumnNumber = 4, SqlFieldName = Adm_Pass ];

/// 状态 N:保存 A:审核 B:撤销审核
Property AdmStatus As %String(DISPLAYLIST = ",保存,审核,撤销审核", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,A,B") [ SqlColumnNumber = 5, SqlFieldName = Adm_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 6, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 7, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 8, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 9, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 11, SqlFieldName = AuditTime ];

Index Per On (AdmPer, AdmStatus);

Index Audit On (AdmPer, AdmStatus, AuditDate);

Storage Default
{
<Data name="SpecialReAdmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmPer</Value>
</Value>
<Value name="3">
<Value>AdmScore</Value>
</Value>
<Value name="4">
<Value>AdmPass</Value>
</Value>
<Value name="5">
<Value>AdmStatus</Value>
</Value>
<Value name="6">
<Value>Creator</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>Auditor</Value>
</Value>
<Value name="10">
<Value>AuditDate</Value>
</Value>
<Value name="11">
<Value>AuditTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialReAdmD</DataLocation>
<DefaultData>SpecialReAdmDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialReAdmD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialReAdmI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialReAdmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
