/// 评估时间
Class User.DHCMRClinicalPathWayEstTimes Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 步骤
Property EstEpStepDR As User.DHCMRCClinPathWaysEpStep;

/// 时间（分）
Property EstTime As %Float;

/// 并发症列表
Property CPWCompStepList As list Of %String;

Storage Default
{
<Data name="DHCMRClinicalPathWayEstTimesState">
<Value name="1">
<Value>EstEpStepDR</Value>
</Value>
<Value name="2">
<Value>EstTime</Value>
</Value>
<Value name="3">
<Value>CPWCompStepList</Value>
</Value>
</Data>
<State>DHCMRClinicalPathWayEstTimesState</State>
<StreamLocation>^User.DHCMRClinicaA79S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
