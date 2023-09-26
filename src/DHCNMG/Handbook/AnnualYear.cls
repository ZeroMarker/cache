/// Creater:lwz
/// Descriptions:年度计划
/// Date:2018-08-22
Class DHCNMG.Handbook.AnnualYear Extends %Persistent [ SqlTableName = AnnualYear ]
{

/// 创建人
Property Creater As %String [ SqlColumnNumber = 2, SqlFieldName = Creater ];

/// 年度计划
Property AnnualPlan As %String(MAXLEN = 10000) [ SqlColumnNumber = 3, SqlFieldName = AnnualPlan ];

/// 年度
Property Year As %String [ SqlColumnNumber = 4, SqlFieldName = Year ];

/// 状态【保存N 提交Y 审核S 驳回B】	
Property Status As %String [ SqlColumnNumber = 5, SqlFieldName = Status ];

/// 提交日期	
Property SubmitDate As %Date [ SqlColumnNumber = 6, SqlFieldName = SubmitDate ];

/// 提交时间	
Property SubmitTime As %Time [ SqlColumnNumber = 7, SqlFieldName = SubmitTime ];

/// 审核日期	
Property CheckDate As %Date [ SqlColumnNumber = 8, SqlFieldName = CheckDate ];

/// 审核时间	
Property CheckTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CheckTime ];

/// 驳回日期	
Property RejectDate As %Date [ SqlColumnNumber = 10, SqlFieldName = RejectDate ];

/// 驳回时间	
Property RejectTime As %Time [ SqlColumnNumber = 11, SqlFieldName = RejectTime ];

/// 创建日期	
Property CreatDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 12, SqlFieldName = CreatDate ];

/// 创建时间	
Property CreatTime As %Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 13, SqlFieldName = CreatTime ];

/// 驳回原因	
Property RejectOpinion As %String [ SqlColumnNumber = 14, SqlFieldName = RejectOpinion ];

/// 驳回人 
Property Rejector As %String [ SqlColumnNumber = 15, SqlFieldName = Rejector ];

/// 审核意见	
Property CheckOpinion As %String [ SqlColumnNumber = 16, SqlFieldName = CheckOpinion ];

/// 审核人	
Property Checker As %String [ SqlColumnNumber = 17, SqlFieldName = Checker ];

Index YearStatus On (Status, Year);

Index CreatTime On CreatTime;

Storage Default
{
<Data name="AnnualYearDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Creater</Value>
</Value>
<Value name="3">
<Value>AnnualPlan</Value>
</Value>
<Value name="4">
<Value>Year</Value>
</Value>
<Value name="5">
<Value>Status</Value>
</Value>
<Value name="6">
<Value>SubmitDate</Value>
</Value>
<Value name="7">
<Value>SubmitTime</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckTime</Value>
</Value>
<Value name="10">
<Value>RejectDate</Value>
</Value>
<Value name="11">
<Value>RejectTime</Value>
</Value>
<Value name="12">
<Value>RejectReason</Value>
</Value>
<Value name="13">
<Value>Rejector</Value>
</Value>
<Value name="14">
<Value>CreatDate</Value>
</Value>
<Value name="15">
<Value>CreatTime</Value>
</Value>
<Value name="16">
<Value>Title</Value>
</Value>
<Value name="17">
<Value>CheckOpinion</Value>
</Value>
<Value name="18">
<Value>Checker</Value>
</Value>
<Value name="19">
<Value>RejectOpinion</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Handbook.AnnualYearD</DataLocation>
<DefaultData>AnnualYearDefaultData</DefaultData>
<IdLocation>^DHCNMG.Handbook.AnnualYearD</IdLocation>
<IndexLocation>^DHCNMG.Handbook.AnnualYearI</IndexLocation>
<StreamLocation>^DHCNMG.Handbook.AnnualYearS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
