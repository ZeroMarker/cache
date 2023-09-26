/// 名称: DHCHAI.IR.INFLabSen
/// 描述: 医院感染 病原学检验 药敏试验
/// 编写者：chenjb
/// 编写日期: 2017-02-20
Class DHCHAI.IR.INFLabSen Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 抗生素指针
Property IRAntiDicDr As DHCHAI.DP.LabAntibiotic;

/// 抗生素
Property IRAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 药敏结果("NINFInfSenTestRst")
Property IRDrugSenDr As DHCHAI.BT.Dictionary;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验 病原体 药敏试验
/// Table：       DHCHAI.IR.INFLabSen
/// Input：       DHCHAI.IR.INFLabSen.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.INFLabSen).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCHAI.IR.INFLabSen
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCHAI.IR.INFLabSen).%New()
	If obj'="" Do obj.%Close()
	
	Set AntiDicDr=$p(aInput,aSeparate,1)
	Set AntiDesc =$p(aInput,aSeparate,2)
	Set DrugSenDr=$p(aInput,aSeparate,3)
	Quit:(AntiDesc="")||(DrugSenDr="")||(AntiDicDr="") return
	
	Set objAnti = ##class(DHCHAI.DP.LabAntibiotic).GetObjById(AntiDicDr)
	Set objDrugSen = ##class(DHCHAI.BT.Dictionary).GetObjById(DrugSenDr)
	Quit:'$IsObject(objAnti) return
	Quit:'$IsObject(objDrugSen) return
	
	Set obj.IRAntiDicDr= objAnti
	Set obj.IRAntiDesc = AntiDesc
	Set obj.IRDrugSenDr= objDrugSen
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="INFLabSenState">
<Value name="1">
<Value>IRAntiDicDr</Value>
</Value>
<Value name="2">
<Value>IRAntiDesc</Value>
</Value>
<Value name="3">
<Value>IRDrugSenDr</Value>
</Value>
</Data>
<State>INFLabSenState</State>
<StreamLocation>^DHCHAI.IR.INFLabSenS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
