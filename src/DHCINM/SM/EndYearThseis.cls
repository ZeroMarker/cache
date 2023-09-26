/// Creater:dhh
/// Descriptions:年底上交论文备案
/// Date:2020-07-23
Class DHCINM.SM.EndYearThseis Extends %Persistent
{

/// 护士
Property EytNurse As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Eyt_Nurse ];

/// 层级
Property EytLevel As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Eyt_Level ];

/// 职称
Property EytHire As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 4, SqlFieldName = Eyt_Hire ];

/// 所属病区
Property EytWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 5, SqlFieldName = Eyt_Ward ];

/// 论文题目
Property EytTitle As %String [ SqlColumnNumber = 6, SqlFieldName = Eyt_Title ];

/// 论文类型
Property EytType As %String [ SqlColumnNumber = 7, SqlFieldName = Eyt_Type ];

/// 附件
Property EytFile As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = Eyt_File ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property EytStatus As %String [ SqlColumnNumber = 9, SqlFieldName = Eyt_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 10, SqlFieldName = Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 11, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = Create_Date ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 13, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 14, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 15, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 16, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="EndYearThseisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EytNurse</Value>
</Value>
<Value name="3">
<Value>EytLevel</Value>
</Value>
<Value name="4">
<Value>EytHire</Value>
</Value>
<Value name="5">
<Value>EytWard</Value>
</Value>
<Value name="6">
<Value>EytTitle</Value>
</Value>
<Value name="7">
<Value>EytType</Value>
</Value>
<Value name="8">
<Value>EytFile</Value>
</Value>
<Value name="9">
<Value>EytStatus</Value>
</Value>
<Value name="10">
<Value>Reason</Value>
</Value>
<Value name="11">
<Value>Creator</Value>
</Value>
<Value name="12">
<Value>CreateDate</Value>
</Value>
<Value name="13">
<Value>Auditor</Value>
</Value>
<Value name="14">
<Value>AuditDate</Value>
</Value>
<Value name="15">
<Value>AuditTime</Value>
</Value>
<Value name="16">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.EndYearThseisD</DataLocation>
<DefaultData>EndYearThseisDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.EndYearThseisD</IdLocation>
<IndexLocation>^DHCINM.SM.EndYearThseisI</IndexLocation>
<StreamLocation>^DHCINM.SM.EndYearThseisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
