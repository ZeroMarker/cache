/// 出血评估临床审核结果
/// 创建者：武加锋
/// 创建时间: 2019-12-30 14:34
Class DHCMA.VTE.CLINIC.BloodEvalHis Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

// 就诊号

Property PatientId As %String;

// 评分

Property ItemScore As %Integer;

// 量表Code

Property DicCode As %String;

// 等级名称 0低危 1高危

Property LevelType As %String;

// 条目ids

Property ItemIds As %String;

// 初始评估时间

Property EvalDate As %Date;

// 节点id

Property RiskFlag As %String;

// 临床医生审核者名称

Property EvalDocName As %String;

// 病区护士审核者名称

Property EvalNurseName As %String;

// 临床医生审核者ID ss_user表中的id

Property EvalDocId As %String;

// 病区护士审核者ID ss_user表中的id

Property EvalNurseId As %String;

// 节点时间

Property EventDate As %Date;

// 入院日期

Property AdmDate As %Date;

// 临床医生审核日期

Property EvalDocDate As %Date;

// 病区护士审核日期

Property EvalNurseDate As %Date;

Index IndexPatientId On PatientId;

Index IndexRiskFlag On RiskFlag;

Storage Default
{
<Data name="BloodEvalHisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientId</Value>
</Value>
<Value name="3">
<Value>ItemScore</Value>
</Value>
<Value name="4">
<Value>DicCode</Value>
</Value>
<Value name="5">
<Value>LevelType</Value>
</Value>
<Value name="6">
<Value>ItemIds</Value>
</Value>
<Value name="7">
<Value>EvalDate</Value>
</Value>
<Value name="8">
<Value>RiskFlag</Value>
</Value>
<Value name="9">
<Value>EvalDocName</Value>
</Value>
<Value name="10">
<Value>EvalNurseName</Value>
</Value>
<Value name="11">
<Value>EvalDocId</Value>
</Value>
<Value name="12">
<Value>EvalNurseId</Value>
</Value>
<Value name="13">
<Value>EventDate</Value>
</Value>
<Value name="14">
<Value>AdmDate</Value>
</Value>
<Value name="15">
<Value>EvalDocDate</Value>
</Value>
<Value name="16">
<Value>EvalNurseDate</Value>
</Value>
</Data>
<DataLocation>^DHCMA.VTE.CLINIC.BloodEvalHisD</DataLocation>
<DefaultData>BloodEvalHisDefaultData</DefaultData>
<IdLocation>^DHCMA.VTE.CLINIC.BloodEvalHisD</IdLocation>
<IndexLocation>^DHCMA.VTE.CLINIC.BloodEvalHisI</IndexLocation>
<StreamLocation>^DHCMA.VTE.CLINIC.BloodEvalHisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
