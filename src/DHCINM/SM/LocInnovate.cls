/// Creater:dhh
/// Descriptions:科室创新备案
/// Date:2020-07-24
Class DHCINM.SM.LocInnovate Extends %Persistent
{

/// 创新类型
Property LocInnType As %String [ SqlColumnNumber = 2, SqlFieldName = LocInn_Type ];

/// 创新主题
Property LocInnTheme As %String [ SqlColumnNumber = 3, SqlFieldName = LocInn_Theme ];

/// 创新科室
Property LocInnWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = LocInn_Ward ];

/// 是否本专科
Property LocInnSpec As %String [ SqlColumnNumber = 5, SqlFieldName = LocInn_Spec ];

/// 负责人
Property LocInnLead As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = LocInn_Lead ];

/// 参与人
Property LocInnPart As list Of %String [ SqlColumnNumber = 7, SqlFieldName = LocInn_Part ];

/// 背景
Property LocInnBackGround As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = LocInn_BackGround ];

/// 创新优点
Property LocInnAdvantage As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = LocInn_Advantage ];

/// 创新方法
Property LocInnMethod As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = LocInn_Method ];

/// 应用效果
Property LocInnEffect As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = LocInn_Effect ];

/// 创新前图片
Property LocInnBfPic As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = LocInn_BfPic ];

/// 创新后图片
Property LocInnAfPic As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = LocInn_AfPic ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property LocInnStatus As %String [ SqlColumnNumber = 14, SqlFieldName = LocInn_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 15, SqlFieldName = Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 16, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 17, SqlFieldName = Create_Date ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 18, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 19, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 20, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 21, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="LocInnovateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocInnType</Value>
</Value>
<Value name="3">
<Value>LocInnTheme</Value>
</Value>
<Value name="4">
<Value>LocInnWard</Value>
</Value>
<Value name="5">
<Value>LocInnSpec</Value>
</Value>
<Value name="6">
<Value>LocInnLead</Value>
</Value>
<Value name="7">
<Value>LocInnPart</Value>
</Value>
<Value name="8">
<Value>LocInnBackGround</Value>
</Value>
<Value name="9">
<Value>LocInnAdvantage</Value>
</Value>
<Value name="10">
<Value>LocInnMethod</Value>
</Value>
<Value name="11">
<Value>LocInnEffect</Value>
</Value>
<Value name="12">
<Value>LocInnBfPic</Value>
</Value>
<Value name="13">
<Value>LocInnAfPic</Value>
</Value>
<Value name="14">
<Value>LocInnStatus</Value>
</Value>
<Value name="15">
<Value>Reason</Value>
</Value>
<Value name="16">
<Value>Creator</Value>
</Value>
<Value name="17">
<Value>CreateDate</Value>
</Value>
<Value name="18">
<Value>Auditor</Value>
</Value>
<Value name="19">
<Value>AuditDate</Value>
</Value>
<Value name="20">
<Value>AuditTime</Value>
</Value>
<Value name="21">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.LocInnovateD</DataLocation>
<DefaultData>LocInnovateDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.LocInnovateD</IdLocation>
<IndexLocation>^DHCINM.SM.LocInnovateI</IndexLocation>
<StreamLocation>^DHCINM.SM.LocInnovateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
