/// 名称: DHCMed.NINF.Rep.AimReportOPRAnti
/// 描述: 目标性监测报告 手术相关抗生素使用
/// 编写者：zhufei
/// 编写日期: 2012-06-07
Class DHCMed.NINF.Rep.AimReportOPRAnti Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 用药 指向 OE_OrdItem
Property OEOrdItem As %String(TRUNCATE = 1);

/// 用药 指向 ARC_ItmMast
Property ArcimID As %String(TRUNCATE = 1);

/// 用药数量
Property DrugQty As %String(TRUNCATE = 1);

/// 基本单位
Property DrugUom As %String(TRUNCATE = 1);

/// 用药天数
Property DrugDays As %String(TRUNCATE = 1);

/// w ##Class(DHCMed.NINF.Rep.AimReportOPRAnti).GetObj("","^")
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.AimReportOPRAnti
{
	New (aInput,aSeparate)
	Set return=""
	
	Set OEItemID=$p(aInput,aSeparate,1)
	If OEItemID'="" {
		Set ArcimID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1)),"^",2)
	} Else {
		Set ArcimID=$p(aInput,aSeparate,2)
	}
	Quit:ArcimID="" return
	
	Set DrugQty=$p(aInput,aSeparate,3)
	Set:DrugQty'="" DrugQty=+DrugQty
	Set DrugUom=$p(aInput,aSeparate,4)
	Set DrugDays=$p(aInput,aSeparate,5)
	Set:DrugDays'="" DrugDays=+DrugDays
	
	Set obj=##Class(DHCMed.NINF.Rep.AimReportOPRAnti).%New()
	If obj'="" Do obj.%Close()
	Set obj.OEOrdItem=OEItemID
	Set obj.ArcimID=ArcimID
	Set obj.DrugQty=DrugQty
	Set obj.DrugUom=DrugUom
	Set obj.DrugDays=DrugDays
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="AimReportOPRAntiState">
<Value name="1">
<Value>OEOrdItem</Value>
</Value>
<Value name="2">
<Value>ArcimID</Value>
</Value>
<Value name="3">
<Value>DrugQty</Value>
</Value>
<Value name="4">
<Value>DrugUom</Value>
</Value>
<Value name="5">
<Value>DrugDays</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCMed.NINF</IdLocation>
<IndexLocation>^DHCMed.NINF</IndexLocation>
<State>AimReportOPRAntiState</State>
<StreamLocation>^DHCMed.NINF493.AimReportOPR650S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
