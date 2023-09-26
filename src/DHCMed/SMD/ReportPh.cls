/// 住院用药/康复用药
Class DHCMed.SMD.ReportPh Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医嘱号
Property RPOEItemID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 药物ID
Property RPDrugDr As DHCMed.SMD.PsychDrug;

/// 药物名称
Property RPDrugName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 频次ID
Property RPInstrucDr As DHCMed.SS.Dictionary;

/// 频次
Property RPInstruc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 剂量
Property RPDoseQty As %String(MAXLEN = 100, TRUNCATE = 1);

/// 剂量单位ID
Property RPDoseUnitDr As DHCMed.SS.Dictionary;

/// 剂量单位
Property RPDoseUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否长效药
Property RPIsLongTerm As %Boolean;

/// 规格
Property RPDrugSpec As %String;

/// 非长效药物晨间服用剂量
Property RPUsageMorn As %String;

/// 非长效药物午间服用剂量
Property RPUsageNoon As %String;

/// 非长效药物晚间服用剂量
Property RPUsageEven As %String;

/// Creator：     zhouruimeng
/// CreatDate：   2015-01-14
/// Description:  取药品基本信息定义
/// Table：       DHCMed.SMD.ReportPat
/// Input：       DHCMed.SMD.ReportPat.ID
/// Return：      返回obj
/// w ##class(DHCMed.SMD.ReportPh).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.SMD.ReportPh
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.SMD.ReportPh).%New()
	If obj'="" Do obj.%Close()
	
	Set obj.RPOEItemID=$p(aInput,aSeparate,1)
	Set obj.RPDrugName=$p(aInput,aSeparate,2)
	Set obj.RPInstruc=$p(aInput,aSeparate,3)
	Set obj.RPDoseQty=$p(aInput,aSeparate,4)
	Set obj.RPDoseUnit=$p(aInput,aSeparate,5)
	
	Set DrugDr=$p(aInput,aSeparate,6)
	Set obj.RPDrugDr=##class(DHCMed.SMD.PsychDrug).GetObjById(DrugDr)
	Set InstrucDr=$p(aInput,aSeparate,7)
	Set obj.RPInstrucDr=##class(DHCMed.SS.Dictionary).GetObjById(InstrucDr)
	Set DoseUnitDr=$p(aInput,aSeparate,8)
	Set obj.RPDoseUnitDr=##class(DHCMed.SS.Dictionary).GetObjById(DoseUnitDr)
	//2019-12-04     ***
	Set obj.RPIsLongTerm=$p(aInput,aSeparate,9)
	Set obj.RPDrugSpec	=$p(aInput,aSeparate,10)
	Set obj.RPUsageMorn =$p(aInput,aSeparate,11)
	Set obj.RPUsageNoon =$p(aInput,aSeparate,12)
	Set obj.RPUsageEven =$p(aInput,aSeparate,13)
	Set return=obj
	Quit return
}

Storage Default
{
<Data name="ReportPhState">
<Value name="1">
<Value>RPOEItemID</Value>
</Value>
<Value name="2">
<Value>RPDrugName</Value>
</Value>
<Value name="3">
<Value>RPInstruc</Value>
</Value>
<Value name="4">
<Value>RPDoseQty</Value>
</Value>
<Value name="5">
<Value>RPDoseUnit</Value>
</Value>
<Value name="6">
<Value>RPDrugDr</Value>
</Value>
<Value name="7">
<Value>RPInstrucDr</Value>
</Value>
<Value name="8">
<Value>RPDoseUnitDr</Value>
</Value>
<Value name="9">
<Value>RPIsLongTerm</Value>
</Value>
<Value name="10">
<Value>RPDrugSpec</Value>
</Value>
<Value name="11">
<Value>RPUsageMorn</Value>
</Value>
<Value name="12">
<Value>RPUsageNoon</Value>
</Value>
<Value name="13">
<Value>RPUsageEven</Value>
</Value>
</Data>
<State>ReportPhState</State>
<StreamLocation>^DHCMed.SMD.ReportPhS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
