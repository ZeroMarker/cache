/// 名称: DHCMed.NINF.Rep.InfReportInfPosOpr
/// 描述: 医院感染报告 与感染相关的侵袭性操作
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportInfPosOpr Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 侵入性操作("NINFInfInvasiveOper")
Property InvasiveOper As DHCMed.SS.Dictionary;

/// 开始日期
Property StartDate As %Date;

/// 开始时间
Property StartTime As %Time;

/// 结束日期
Property EndDate As %Date;

/// 结束时间
Property EndTime As %Time;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 与感染相关的侵袭性操作
/// Table：       DHCMed.NINF.Rep.InfReportInfPosOpr
/// Input：       DHCMed.NINF.Rep.InfReportInfPosOpr.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportInfPosOpr).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.InfReportInfPosOpr
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportInfPosOpr).%New()
	If obj'="" Do obj.%Close()
	
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,1))
	Quit:'$IsObject(objDic) return
	
	Set obj.InvasiveOper=objDic
	Set obj.StartDate=$p(aInput,aSeparate,2)
	Set obj.StartTime=$p(aInput,aSeparate,3)
	Set obj.EndDate=$p(aInput,aSeparate,4)
	Set obj.EndTime=$p(aInput,aSeparate,5)
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="InfReportInfPosOprState">
<Value name="1">
<Value>InvasiveOper</Value>
</Value>
<Value name="2">
<Value>StartDate</Value>
</Value>
<Value name="3">
<Value>StartTime</Value>
</Value>
<Value name="4">
<Value>EndDate</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCMed.NINF</IdLocation>
<IndexLocation>^DHCMed.NINF</IndexLocation>
<State>InfReportInfPosOprState</State>
<StreamLocation>^DHCMed.NINF493.InfReportOPR650S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
