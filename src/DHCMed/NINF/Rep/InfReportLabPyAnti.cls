/// 名称: DHCMed.NINF.Rep.InfReportLabPyAnti
/// 描述: 医院感染报告 病原学检验 病原体 药敏试验
/// 编写者：zhufei
/// 编写日期: 2012-06-20
Class DHCMed.NINF.Rep.InfReportLabPyAnti Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 抗生素ID DHCMed.NINF.Dic.Antibiotics
Property AntibioticsID As %String(TRUNCATE = 1);

/// 抗生素
Property AntibioticsDesc As %String(TRUNCATE = 1);

/// 药敏结果("NINFInfSenTestRst")
Property SenTestRst As DHCMed.SS.Dictionary;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验 病原体 药敏试验
/// Table：       DHCMed.NINF.Rep.InfReportLabPyAnti
/// Input：       DHCMed.NINF.Rep.InfReportLabPyAnti.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportLabPyAnti).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.InfReportLabPyAnti
{
	New (aInput,aSeparate)
	Set return=""
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportLabPyAnti).%New()
	If obj'="" Do obj.%Close()
	
	Set AntibioticsID=$p(aInput,aSeparate,1)
	Set AntibioticsDesc=$p(aInput,aSeparate,2)
	Quit:AntibioticsDesc="" return
	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
	
	Set obj.AntibioticsID=AntibioticsID
	Set obj.AntibioticsDesc=AntibioticsDesc
	Set obj.SenTestRst=objDic
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="InfReportLabPyAntiState">
<Value name="1">
<Value>AntibioticsID</Value>
</Value>
<Value name="2">
<Value>AntibioticsDesc</Value>
</Value>
<Value name="3">
<Value>DrugSenTest</Value>
</Value>
<Value name="4">
<Value>DrugSenTestRst</Value>
</Value>
<Value name="5">
<Value>SenTestRst</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF493.InfReportLab6FDD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCMed.NINF493.InfReportLab6FDD</IdLocation>
<IndexLocation>^DHCMed.NINF493.InfReportLab6FDI</IndexLocation>
<State>InfReportLabPyAntiState</State>
<StreamLocation>^DHCMed.NINF493.InfReportLab6FDS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
