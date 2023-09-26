/// 名称: DHCMed.NINF.Rep.InfReportLabPy
/// 描述: 医院感染报告 病原学检验 病原体
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportLabPy Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 病原体ID DHCMed.NINF.Dic.Pathogeny
Property PathogenyID As %String(TRUNCATE = 1);

/// 病原体
Property PathogenyDesc As %String(TRUNCATE = 1);

/// 药敏实验
Property DrugSenTest As list Of DHCMed.NINF.Rep.InfReportLabPyAnti;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 病原学检验 病原体
/// Table：       DHCMed.NINF.Rep.InfReportLabPy
/// Input：       DHCMed.NINF.Rep.InfReportLabPy.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportLabPy).GetObj()
ClassMethod GetObj(aInput As %String, aSeparate As %String) As DHCMed.NINF.Rep.InfReportLabPy
{
	New (aInput,aSeparate)
	Set return=""
	
	Set CHR1=$p(aSeparate,",",1)
	Set CHR2=$p(aSeparate,",",2)
	Set CHR3=$p(aSeparate,",",3)
	Quit:(CHR1="")||(CHR2="")||(CHR3="") return
	
	Set obj=##Class(DHCMed.NINF.Rep.InfReportLabPy).%New()
	If obj'="" Do obj.%Close()
	
	Set PathogenyID=$p(aInput,CHR1,1)
	Set PathogenyDesc=$p(aInput,CHR1,2)
	Quit:PathogenyDesc="" return
	
	Set obj.PathogenyID=PathogenyID
	Set obj.PathogenyDesc=PathogenyDesc
	
	Set SenTests=$p(aInput,CHR1,3)
	Set SenTestLB=""
	For ind=1:1:$length(SenTests,CHR2) {
		Set SenTest=$p(SenTests,CHR2,ind)
		Continue:SenTest=""
		Continue:($listfind(SenTestLB,SenTest)>0)
		Set SenTestLB=SenTestLB_$lb(SenTest)
		Set objSenTest=##class(DHCMed.NINF.Rep.InfReportLabPyAnti).GetObj(SenTest,CHR3)
		Continue:'$IsObject(objSenTest)
		Do obj.DrugSenTest.Insert(objSenTest)
	}
	Set return=obj
	
	Quit return
}

Storage Default
{
<Data name="InfReportLabPyState">
<Value name="1">
<Value>PathogenyID</Value>
</Value>
<Value name="2">
<Value>PathogenyDesc</Value>
</Value>
<Value name="3">
<Value>DrugSenTest</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Py")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Py")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"LabPy")</IndexLocation>
<State>InfReportLabPyState</State>
<StreamLocation>^DHCMed.NINF493.InfReportLabPyS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
