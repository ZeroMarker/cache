/// 名称: DHCMed.NINF.Rep.InfReportCheck
/// 描述: 医院感染报告 报告评价
/// 编写者：liuyuhui
/// 编写日期: 2013-12-01
Class DHCMed.NINF.Rep.InfReportCheck Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ParRef As DHCMed.NINF.Rep.InfReport [ Cardinality = parent, Inverse = ChildCheck ];

/// 基本信息
Property CBaseInfo As %String(TRUNCATE = 1);

/// 诊断信息
Property CDiagInfo As %String(TRUNCATE = 1);

/// 手术信息
Property COperInfo As %String(TRUNCATE = 1);

/// 检验信息
Property CLabInfo As %String(TRUNCATE = 1);

/// 抗菌药物信息
Property CAntiInfo As %String(TRUNCATE = 1);

/// 备注信息
Property CResume As %String(TRUNCATE = 1);

Index IndexParRef On ParRef [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  取医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportCheck
/// Input：       DHCMed.NINF.Rep.InfReportCheck.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.InfReportCheck).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.InfReportCheck
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.InfReportCheck).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-06-21
/// Description:  更新医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportCheck
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportCheck).Update("103^^1^2^3^4^5^6^7^8","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set ParRef=$p(aInput,aSeparate,1)
	Set objParRef=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ParRef)
	Quit:'$IsObject(objParRef) return
	Set ChildSub=$p(aInput,aSeparate,2)
	Set:(ChildSub="")&&($d(^DHCMed.NINFi("InfRep",0,"Check","IndexParRef",ParRef))) ChildSub=$o(^DHCMed.NINFi("InfRep",0,"Check","IndexParRef",ParRef,""))
	If (ChildSub="") {
		Set obj=##class(DHCMed.NINF.Rep.InfReportCheck).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.InfReportCheck).%OpenId(ParRef_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	Set obj.ParRef=objParRef
	Set obj.CBaseInfo=$p(aInput,aSeparate,3)
	Set obj.CDiagInfo=$p(aInput,aSeparate,4)
	Set obj.COperInfo=$p(aInput,aSeparate,5)
	Set obj.CLabInfo=$p(aInput,aSeparate,6)
	Set obj.CAntiInfo=$p(aInput,aSeparate,7)
	Set obj.CResume=$p(aInput,aSeparate,8)
	
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
/// Description:  删除医院感染报告 手术信息
/// Table：       DHCMed.NINF.Rep.InfReportCheck
/// Input：       DHCMed.NINF.Rep.InfReportCheck.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.InfReportCheck).DeleteById()
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.InfReportCheck).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// w ##Class(DHCMed.NINF.Rep.InfReportCheck).GetCheckInfo(103)
ClassMethod GetCheckInfo(ParRef As %String) As %String
{
	New (ParRef)
	
	Set return=""
	Quit:'$d(^DHCMed.NINFi("InfRep",0,"Check","IndexParRef",ParRef)) return
	
	Set CheckSub=$o(^DHCMed.NINFi("InfRep",0,"Check","IndexParRef",ParRef,""))
	Quit:CheckSub="" return
	
	Set obj=##class(DHCMed.NINF.Rep.InfReportCheck).GetObjById(ParRef_"||"_CheckSub)
	Quit:'$IsObject(obj) return
	
	Set return=obj.CBaseInfo_"^"_obj.CDiagInfo_"^"_obj.COperInfo_"^"_obj.CLabInfo_"^"_obj.CAntiInfo_"^"_obj.CResume
	
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CAntiInfo</Value>
</Value>
<Value name="3">
<Value>CBaseInfo</Value>
</Value>
<Value name="4">
<Value>CDiagInfo</Value>
</Value>
<Value name="5">
<Value>CLabInfo</Value>
</Value>
<Value name="6">
<Value>COperInfo</Value>
</Value>
<Value name="7">
<Value>CResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Check")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("Check")</IdLocation>
<IndexLocation>^DHCMed.NINFi("InfRep",0,"Check")</IndexLocation>
<StreamLocation>^DHCMed.N.InfReportCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
