/// 名称 : DHCMed.EPD.NCPSample
/// 描述 : 实验室检测
Class DHCMed.EPD.NCPSample Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMed.EPD.NCPInvestigation [ Cardinality = parent, Inverse = ChildSample ];

/// 样本类型("NCPSampleType")  //咽拭子、鼻拭子 痰液
Property InvLabType As DHCMed.SS.Dictionary;

/// 检测结果  （阳性、阴性、待测）
Property InvLabResult As DHCMed.SS.Dictionary;

/// 采样日期
Property InvLabDate As %Date;

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  取实验室检测
/// Table：       DHCMed.EPD.NCPSample
/// Input：       Id : DHCMed.EPD.NCPSample.ID
/// Return：      返回Object
/// w ##class(DHCMed.EPD.NCPSample).GetObjById("")
ClassMethod GetObjById(aID As %String) As DHCMed.EPD.NCPSample
{
	New (aID)
	Quit:'##class(DHCMed.EPD.NCPSample).%ExistsId(aID) ""
	Set obj=##class(DHCMed.EPD.NCPSample).%OpenId(aID)
	Do:$IsObject(obj) obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  更新实验室检测
/// Table：       DHCMed.EPD.NCPSample
/// Input：       InputStr ：
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.EPD.NCPSample).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set Parref=$p(aInputStr,aSeparate,1)
	Set ChildSub=$p(aInputStr,aSeparate,2)
	Set TypeID=$p(aInputStr,aSeparate,3)
	Set ResultID=$p(aInputStr,aSeparate,4)
	Set Date=$p(aInputStr,aSeparate,5)
	Quit:(Parref="")||(TypeID="")||(ResultID="")||(Date="") return
	
	Set objParref=##class(DHCMed.EPD.NCPInvestigation).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objType=##class(DHCMed.SS.Dictionary).GetObjById(TypeID)
	Quit:'$IsObject(objType) return
	Set objResult=##class(DHCMed.SS.Dictionary).GetObjById(ResultID)
	Quit:'$IsObject(objResult) return
	
	Set:Date'="" Date=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(Date)	
	If (ChildSub="") {
		Set obj=##class(DHCMed.EPD.NCPSample).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.NCPSample).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.InvLabType=objType
	Set obj.InvLabResult=objResult
	Set obj.InvLabDate=Date
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-02-10
/// Description:  删除实验室检测
/// Table：       DHCMed.EPD.NCPSample
/// Input：       Id : DHCMed.EPD.NCPSample.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCMed.EPD.NCPSample).DeleteById("")
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set return=0
	Quit:(aID="") return
	Set sc=##class(DHCMed.EPD.NCPSample).%DeleteId(aID)
	If $System.Status.IsError(sc) {
		Do $System.OBJ.DisplayError(sc)
		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

Storage Default
{
<Data name="NCPSampleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InvLabType</Value>
</Value>
<Value name="3">
<Value>InvLabResult</Value>
</Value>
<Value name="4">
<Value>InvLabDate</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("SA")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("SA")</IdLocation>
<IndexLocation>^DHCMed.EPD.NCPSampleI("RSA")</IndexLocation>
<StreamLocation>^DHCMed.EPD.NCPSampleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
