/// 名称: DHCMed.NINF.Rep.EnviMapLocItm
/// 描述: 环境卫生学科室与检测项目映射
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Rep.EnviMapLocItm Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检测科室
Property EMLILocDr As %String(TRUNCATE = 1);

/// 检测项目
Property EMLIItemDr As DHCMed.SS.Dictionary;

Index IndexLoc On EMLILocDr As Exact;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取环境卫生学科室与检测项目映射
/// Table：       DHCMed.NINF.Rep.EnviMapLocItm
/// Input：       DHCMed.NINF.Rep.EnviMapLocItm.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Rep.EnviMapLocItm).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Rep.EnviMapLocItm
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Rep.EnviMapLocItm).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新环境卫生学科室与检测项目映射
/// Table：       DHCMed.NINF.Rep.EnviMapLocItm
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Rep.EnviMapLocItm).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Rep.EnviMapLocItm).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Rep.EnviMapLocItm).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EMLILocDr=$p(aInput,aSeparate,2)
	Set obj.EMLIItemDr=##class(DHCMed.SS.Dictionary).%OpenId($p(aInput,aSeparate,3))
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
/// CreatDate：   2012-05-25
/// Description:  删除环境卫生学科室与检测项目映射
/// Table：       DHCMed.NINF.Rep.EnviMapLocItm
/// Input：       DHCMed.NINF.Rep.EnviMapLocItm.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Rep.EnviMapLocItm).%DeleteId(+aId)
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
<Data name="ZEnviMapLocItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMLIItemDr</Value>
</Value>
<Value name="3">
<Value>EMLILocDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Rep.EnviMapLocItmD</DataLocation>
<DefaultData>ZEnviMapLocItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Rep.EnviMapLocItmD</IdLocation>
<IndexLocation>^DHCMed.NINF.Rep.EnviMapLocItmI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Rep.EnviMapLocItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
