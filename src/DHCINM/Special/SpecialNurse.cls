/// Creater:wangpf
/// Descriptions:专科护士
/// Date:2020-07-20
Class DHCINM.Special.SpecialNurse Extends %Persistent
{

/// 人员
Property SpecialPer As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Special_Per ];

/// 专科证书
Property SpecialType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Special_Type ];

/// 认证单位
Property SpecialAuth As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 4, SqlFieldName = Special_Auth ];

/// 认证日期
Property SpecialAuthDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Special_AuthDate ];

/// 证书附件
Property SpecialCertificate As %String(MAXLEN = 10000) [ SqlColumnNumber = 6, SqlFieldName = Special_Certificate ];

/// 状态 Y:提交 A:审核 B:驳回
Property SpecialStatus As %String(DISPLAYLIST = ",提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,A,B") [ SqlColumnNumber = 7, SqlFieldName = Special_Status ];

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

/// 专科护士
Property SpecialNurType As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 15, SqlFieldName = Special_NurType ];

Index Person On SpecialPer;

Index AuthDate On (SpecialPer, SpecialStatus, SpecialAuthDate);

Storage Default
{
<Data name="SpecialNurseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecialPer</Value>
</Value>
<Value name="3">
<Value>SpecialType</Value>
</Value>
<Value name="4">
<Value>SpecialAuth</Value>
</Value>
<Value name="5">
<Value>SpecialAuthDate</Value>
</Value>
<Value name="6">
<Value>SpecialCertificate</Value>
</Value>
<Value name="7">
<Value>SpecialStatus</Value>
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
<Value>SpecialNurType</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialNurseD</DataLocation>
<DefaultData>SpecialNurseDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialNurseD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialNurseI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialNurseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
