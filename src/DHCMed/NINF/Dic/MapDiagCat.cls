/// 名称: DHCMed.NINF.Dic.MapDiagCat
/// 描述: 感染诊断与感染诊断子分类
/// 编写者：zhufei
/// 编写日期: 2014-04-30
Class DHCMed.NINF.Dic.MapDiagCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 感染诊断
Property MDCInfDiagDr As DHCMed.NINF.Dic.InfDiagnose;

/// 感染诊断子分类
Property MDCInfDiagCatDr As DHCMed.SS.Dictionary;

Index IndexInfDiag On MDCInfDiagDr As Exact;

Index IndexDiagCat On MDCInfDiagCatDr As Exact;

Index IndexInfDiagCat On (MDCInfDiagDr As Exact, MDCInfDiagCatDr As Exact);

/// Creator：     zhufei
/// CreatDate：   2014-04-30
/// Description:  取感染诊断与感染诊断子分类
/// Table：       DHCMed.NINF.Dic.MapDiagCat
/// Input：       DHCMed.NINF.Dic.MapDiagCat.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.MapDiagCat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.MapDiagCat
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.MapDiagCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-04-30
/// Description:  更新感染诊断与感染诊断子分类
/// Table：       DHCMed.NINF.Dic.MapDiagCat
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.MapDiagCat).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.MapDiagCat).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.MapDiagCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MDCInfDiagDr=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById($p(aInput,aSeparate,2))
	Set obj.MDCInfDiagCatDr=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
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
/// CreatDate：   2014-04-30
/// Description:  删除感染诊断与感染诊断子分类
/// Table：       DHCMed.NINF.Dic.MapDiagCat
/// Input：       DHCMed.NINF.Dic.MapDiagCat.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.MapDiagCat).%DeleteId(+aId)
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
<Data name="MapDiagCatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDCInfDiagDr</Value>
</Value>
<Value name="3">
<Value>MDCInfDiagCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MapDiagCat")</DataLocation>
<DefaultData>MapDiagCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MapDiagCat")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MapDiagCat",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MapDiagCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
