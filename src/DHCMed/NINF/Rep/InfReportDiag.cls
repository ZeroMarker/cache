/// 名称: DHCMed.NINF.Rep.InfReportDiag
/// 描述: 医院感染报告 疾病诊断
/// 编写者：zhufei
/// 编写日期: 2012-06-19
Class DHCMed.NINF.Rep.InfReportDiag Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildDiag ];

/// 数据来源
/// 指向临床诊断       格式:"MRDIAG:MR_Diagnos.RowID"
/// 指向电子病历首页   格式:"EPRFP:手术模板单元"
Property DataSource As %String(TRUNCATE = 1);

/// 诊断ID 指向MRC_ICDDx
Property DiagnosID As %String(TRUNCATE = 1);

/// 诊断名称
Property DiagnosDesc As %String(TRUNCATE = 1);

/// 诊断日期
Property DiagnosDate As %Date;

/// 诊断时间
Property DiagnosTime As %Time;

/// 诊断类型("NINFInfDiagnosType")
Property DiagnosType As DHCMed.SS.Dictionary;

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       DHCMed.NINF.Rep.InfReportDiag.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportDiag).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportDiag
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportDiag).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportDiag).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set CHR1=$p(aSeparate,",",1)
	Quit:(CHR1="") return
	
	Set ParRef=$p(aInput,CHR1,1)
	Set ChildSub=$p(aInput,CHR1,2)
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportDiag).%New()
		
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportDiag).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	
	Set obj.DataSource=$p(aInput,CHR1,3)
	Set obj.DiagnosID=$p(aInput,CHR1,4)
	Set obj.DiagnosDesc=$p(aInput,CHR1,5)
	Set obj.DiagnosDate=$p(aInput,CHR1,6)
	Set obj.DiagnosTime=$p(aInput,CHR1,7)
	Set obj.DiagnosType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,CHR1,8))
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  删除医院感染报告 疾病诊断
/// Table：       DHCMed.NINF.Rep.InfReportDiag
/// Input：       DHCMed.NINF.Rep.InfReportDiag.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportDiag).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportDiag).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataSource</Value>
</Value>
<Value name="3">
<Value>DiagnosID</Value>
</Value>
<Value name="4">
<Value>DiagnosDesc</Value>
</Value>
<Value name="5">
<Value>DiagnosDate</Value>
</Value>
<Value name="6">
<Value>DiagnosTime</Value>
</Value>
<Value name="7">
<Value>DiagnosType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Diag")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Diag")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Diag")</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.InfReportDiagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
