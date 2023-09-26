/// Creater:dhh
/// Descriptions:科研立项备案
/// Date:2020-07-24
Class DHCINM.SM.RegScience Extends %Persistent
{

/// 申请日期
Property RegSciAppDate As %Date [ SqlColumnNumber = 2, SqlFieldName = RegSci_AppDate ];

/// 立项日期
Property RegSciItemDate As %Date [ SqlColumnNumber = 3, SqlFieldName = RegSci_ItemDate ];

/// 类别
Property RegSciType As %String [ SqlColumnNumber = 4, SqlFieldName = RegSci_Type ];

/// 项目名称
Property RegSciName As %String [ SqlColumnNumber = 5, SqlFieldName = RegSci_Name ];

/// 负责人
Property RegSciLead As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = RegSci_Lead ];

/// 参与人
Property RegSciPart As list Of %String [ SqlColumnNumber = 7, SqlFieldName = RegSci_Part ];

/// 完成情况
Property RegSciSituation As %String [ SqlColumnNumber = 8, SqlFieldName = RegSci_Situation ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property RegSciStatus As %String [ SqlColumnNumber = 9, SqlFieldName = RegSci_Status ];

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
<Data name="RegScienceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RegSciAppDate</Value>
</Value>
<Value name="3">
<Value>RegSciItemDate</Value>
</Value>
<Value name="4">
<Value>RegSciType</Value>
</Value>
<Value name="5">
<Value>RegSciName</Value>
</Value>
<Value name="6">
<Value>RegSciLead</Value>
</Value>
<Value name="7">
<Value>RegSciPart</Value>
</Value>
<Value name="8">
<Value>RegSciSituation</Value>
</Value>
<Value name="9">
<Value>RegSciStatus</Value>
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
<DataLocation>^DHCINM.SM.RegScienceD</DataLocation>
<DefaultData>RegScienceDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.RegScienceD</IdLocation>
<IndexLocation>^DHCINM.SM.RegScienceI</IndexLocation>
<StreamLocation>^DHCINM.SM.RegScienceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
