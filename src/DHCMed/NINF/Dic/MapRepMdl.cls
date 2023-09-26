/// 名称: DHCMed.NINF.Dic.MapRepMdl
/// 描述: 报告分类与模块对照
/// 编写者：zhufei
/// 编写日期: 2012-07-04
Class DHCMed.NINF.Dic.MapRepMdl Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 报告分类("NINFReportCateg")
Property RepCat As DHCMed.SS.Dictionary;

/// 目标性监测 报告科室 指向 CT_Loc
Property RepLoc As %String;

/// 医院感染 报告类型("NINFInfReportType")
Property RepType As DHCMed.SS.Dictionary;

/// 模块列表[UC,PICC,VAP,NICU等]
Property ModuleList As %String;

Index IndexCategLoc On (RepCat As Exact, RepLoc As Exact);

Index IndexCategType On (RepCat As Exact, RepType As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  取报告分类与模块对照
/// Table：       DHCMed.NINF.Dic.MapRepMdl
/// Input：       DHCMed.NINF.Dic.MapRepMdl.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.MapRepMdl).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.MapRepMdl
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.MapRepMdl).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-07-04
/// Description:  更新报告分类与模块对照
/// Table：       DHCMed.NINF.Dic.MapRepMdl
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.MapRepMdl).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.MapRepMdl).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.MapRepMdl).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.RepCat=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,2))
	Set obj.RepLoc=$p(aInput,aSeparate,3)
	Set obj.RepType=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,4))
	Set obj.ModuleList=$p(aInput,aSeparate,5)
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
/// CreatDate：   2012-07-04
/// Description:  删除报告分类与模块对照
/// Table：       DHCMed.NINF.Dic.MapRepMdl
/// Input：       DHCMed.NINF.Dic.MapRepMdl.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.MapRepMdl).%DeleteId(+aId)
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
<Value>RepCat</Value>
</Value>
<Value name="3">
<Value>RepLoc</Value>
</Value>
<Value name="4">
<Value>RepType</Value>
</Value>
<Value name="5">
<Value>ModuleList</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MapRepMdl")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MapRepMdl")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MapRepMdl",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MapRepMdlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
