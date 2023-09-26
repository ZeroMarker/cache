/// Creater:wangpf
/// Descriptions:工作计划【弃用】
/// Date:2020-07-06
Class DHCINM.HB.MgPlanPoint Extends %Persistent
{

/// 计划病区
Property PlanWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Plan_Ward ];

/// 计划类型 Y:年度 H:半年度 S:季度 M:月度
Property PlanType As %String(DISPLAYLIST = ",年度,半年度,季度,月度", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,H,S,M") [ SqlColumnNumber = 3, SqlFieldName = Plan_Type ];

/// 计划时间(非日期类型)
Property PlanDate As %String [ SqlColumnNumber = 4, SqlFieldName = Plan_Date ];

/// 计划内容
Property PlanContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Plan_Content ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property PlanStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 6, SqlFieldName = Plan_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 7, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 8, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 9, SqlFieldName = Create_Time ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 10, SqlFieldName = Submit_Date ];

/// 提交时间
Property SubmitTime As %Time [ SqlColumnNumber = 11, SqlFieldName = Submit_Time ];

Index Ward On (PlanType, PlanWard);

Index WardDate On (PlanType, PlanWard, PlanDate);

Storage Default
{
<Data name="MgPlanPointDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanWard</Value>
</Value>
<Value name="3">
<Value>PlanType</Value>
</Value>
<Value name="4">
<Value>PlanDate</Value>
</Value>
<Value name="5">
<Value>PlanContent</Value>
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
<Value>SubmitDate</Value>
</Value>
<Value name="11">
<Value>SubmitTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPlanPointD</DataLocation>
<DefaultData>MgPlanPointDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPlanPointD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPlanPointI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPlanPointS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
