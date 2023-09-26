/// Creater:dhh
/// Descriptions:新技术申报审批
/// Date:2020-07-28
Class DHCINM.SM.NewTecApply Extends %Persistent
{

/// 项目名称
Property TecName As %String [ SqlColumnNumber = 2, SqlFieldName = Tec_Name ];

/// 引进日期
Property TecInDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Tec_InDate ];

/// 项目首创单位
Property TecUnit As %String [ SqlColumnNumber = 4, SqlFieldName = Tec_Unit ];

/// 首创日期
Property TecUnDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Tec_UnDate ];

/// 负责人信息
Property TecLead As list Of %String [ SqlColumnNumber = 6, SqlFieldName = Tec_Lead ];

/// 研制人员信息
Property TecPart As list Of %String [ SqlColumnNumber = 7, SqlFieldName = Tec_Part ];

/// 病区
Property TecWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 8, SqlFieldName = Tec_tWard ];

/// 应用基本情况
Property TecSituation As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = Tec_Situation ];

/// 应用意义
Property TecMean As %String(MAXLEN = 1000) [ SqlColumnNumber = 10, SqlFieldName = Tec_Mean ];

/// 社会效益
Property TecBenefit As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Tec_Benefit ];

/// 新技术操作规范
Property TecStandard As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = Tec_Standard ];

/// 科室技术力量
Property TecResources As %String(MAXLEN = 1000) [ SqlColumnNumber = 13, SqlFieldName = Tec_Resources ];

/// 风险处理预案
Property TecPlan As %String(MAXLEN = 1000) [ SqlColumnNumber = 14, SqlFieldName = Tec_Plan ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property TecStatus As %String [ SqlColumnNumber = 15, SqlFieldName = Tec_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 16, SqlFieldName = Reason ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 17, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 18, SqlFieldName = Create_Date ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 19, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 20, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 21, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 22, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="NewTecApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TecName</Value>
</Value>
<Value name="3">
<Value>TecInDate</Value>
</Value>
<Value name="4">
<Value>TecUnit</Value>
</Value>
<Value name="5">
<Value>TecUnDate</Value>
</Value>
<Value name="6">
<Value>TecLead</Value>
</Value>
<Value name="7">
<Value>TecPart</Value>
</Value>
<Value name="8">
<Value>TecWard</Value>
</Value>
<Value name="9">
<Value>TecSituation</Value>
</Value>
<Value name="10">
<Value>TecMean</Value>
</Value>
<Value name="11">
<Value>TecBenefit</Value>
</Value>
<Value name="12">
<Value>TecStandard</Value>
</Value>
<Value name="13">
<Value>TecResources</Value>
</Value>
<Value name="14">
<Value>TecPlan</Value>
</Value>
<Value name="15">
<Value>TecStatus</Value>
</Value>
<Value name="16">
<Value>Reason</Value>
</Value>
<Value name="17">
<Value>Creator</Value>
</Value>
<Value name="18">
<Value>CreateDate</Value>
</Value>
<Value name="19">
<Value>Auditor</Value>
</Value>
<Value name="20">
<Value>AuditDate</Value>
</Value>
<Value name="21">
<Value>AuditTime</Value>
</Value>
<Value name="22">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.NewTecApplyD</DataLocation>
<DefaultData>NewTecApplyDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.NewTecApplyD</IdLocation>
<IndexLocation>^DHCINM.SM.NewTecApplyI</IndexLocation>
<StreamLocation>^DHCINM.SM.NewTecApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
