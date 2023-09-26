/// Creater:wangpf
/// Descriptions:计划总结
/// Date:2020-07-08
Class DHCINM.HB.MgPlanConclusion Extends %Persistent
{

/// 总结病区
Property ConcWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Conc_Ward ];

/// 总结类型 Y:年度 H:半年度 S:季度 M:月度
Property ConcType As %String(DISPLAYLIST = ",年度,半年度,季度,月度", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",Y,H,S,M") [ SqlColumnNumber = 3, SqlFieldName = Conc_Type ];

/// 总结时间(非日期类型)
Property ConcDate As %String [ SqlColumnNumber = 4, SqlFieldName = Conc_Date ];

/// 总结内容
Property ConcContent As %String(MAXLEN = 10000) [ SqlColumnNumber = 5, SqlFieldName = Conc_Content ];

/// 状态 N:保存 Y:提交 A:审核 B:驳回
Property ConcStatus As %String(DISPLAYLIST = ",保存,提交,审核,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,A,B") [ SqlColumnNumber = 6, SqlFieldName = Conc_Status ];

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

/// 总结内容
Property ConcContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 12, SqlFieldName = Conc_ContentExt ];

Index Type On ConcType;

Index Ward On (ConcType, ConcWard);

Index WardDate On (ConcType, ConcWard, ConcDate);

Storage Default
{
<Data name="MgPlanConclusionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConcWard</Value>
</Value>
<Value name="3">
<Value>ConcType</Value>
</Value>
<Value name="4">
<Value>ConcDate</Value>
</Value>
<Value name="5">
<Value>ConcContent</Value>
</Value>
<Value name="6">
<Value>ConcStatus</Value>
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
<Value name="12">
<Value>ConcContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPlanConclusionD</DataLocation>
<DefaultData>MgPlanConclusionDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPlanConclusionD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPlanConclusionI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPlanConclusionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
