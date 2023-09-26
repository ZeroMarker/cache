/// Creater:wangpf
/// Descriptions:专业组工作计划
/// Date:2020-07-21
Class DHCINM.Special.SpecialPlan Extends %Persistent
{

Relationship ChildSub As DHCINM.Special.SpecialPlanSub [ Cardinality = children, Inverse = Parref ];

/// 计划年份
Property PlanYear As %Integer [ SqlColumnNumber = 2, SqlFieldName = Plan_Year ];

/// 计划专业组
Property PlanGroup As CT.DHCINM.DB.MgSetCodeSub [ SqlColumnNumber = 3, SqlFieldName = Plan_Group ];

/// 计划类型 Y:年度 H:半年度 S:季度 M:月度 W:周 D:日
Property PlanType As %String(DISPLAYLIST = ",年度,半年度,季度,月度,周,日", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,H,S,M,W,D") [ SqlColumnNumber = 4, SqlFieldName = Plan_Type ];

/// 计划时间(非日期类型)
Property PlanDate As %String [ SqlColumnNumber = 5, SqlFieldName = Plan_Date ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property PlanStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 6, SqlFieldName = Plan_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 7, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = Create_Time ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 10, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 11, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 12, SqlFieldName = AuditTime ];

/// 审核意见
Property AuditOpinion As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = AuditOpinion ];

Index ToolIndex On (PlanYear, PlanGroup, PlanType, PlanDate);

Storage Default
{
<Data name="SpecialPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanYear</Value>
</Value>
<Value name="3">
<Value>PlanGroup</Value>
</Value>
<Value name="4">
<Value>PlanType</Value>
</Value>
<Value name="5">
<Value>PlanDate</Value>
</Value>
<Value name="6">
<Value>PlanStatus</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateTime</Value>
</Value>
<Value name="10">
<Value>Auditor</Value>
</Value>
<Value name="11">
<Value>AuditDate</Value>
</Value>
<Value name="12">
<Value>AuditTime</Value>
</Value>
<Value name="13">
<Value>AuditOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialPlanD</DataLocation>
<DefaultData>SpecialPlanDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialPlanD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialPlanI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
