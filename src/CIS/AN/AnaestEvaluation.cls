/// 麻醉效果评价
Class CIS.AN.AnaestEvaluation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaestEvaluation ]
{

/// 手术计划
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 全麻诱导
Property GeneralAnInduction As %String [ SqlColumnNumber = 3 ];

/// 全麻维持
Property GeneralAnMaintain As %String [ SqlColumnNumber = 4 ];

/// 全麻结束
Property GeneralAnEnding As %String [ SqlColumnNumber = 5 ];

/// 椎管内麻醉
Property IntraspinalAn As %String [ SqlColumnNumber = 6 ];

/// 神经阻滞
Property NerveBlock As %String [ SqlColumnNumber = 7 ];

/// 并发症
Property Complication As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

/// 评价人
Property EvaluateUser As %String [ SqlColumnNumber = 9 ];

/// 评价日期
Property EvaluateDate As %Date [ SqlColumnNumber = 10 ];

/// 评价时间
Property EvaluateTime As %Time [ SqlColumnNumber = 11 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Storage Default
{
<Data name="AnaestEvaluationDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>GeneralAnInduction</Value>
</Value>
<Value name="3">
<Value>GeneralAnMaintain</Value>
</Value>
<Value name="4">
<Value>GeneralAnEnding</Value>
</Value>
<Value name="5">
<Value>IntraspinalAn</Value>
</Value>
<Value name="6">
<Value>NerveBlock</Value>
</Value>
<Value name="7">
<Value>Complication</Value>
</Value>
<Value name="8">
<Value>EvaluateUser</Value>
</Value>
<Value name="9">
<Value>EvaluateDate</Value>
</Value>
<Value name="10">
<Value>EvaluateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaestEvaluationD</DataLocation>
<DefaultData>AnaestEvaluationDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaestEvaluationD</IdLocation>
<IndexLocation>^CIS.AN.AnaestEvaluationI</IndexLocation>
<StreamLocation>^CIS.AN.AnaestEvaluationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
