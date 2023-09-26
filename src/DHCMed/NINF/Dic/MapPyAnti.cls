/// 名称: DHCMed.NINF.Dic.MapPyAnti
/// 描述: 病原体与抗生素映射
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.MapPyAnti Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 病原体
Property MPAPyDr As DHCMed.NINF.Dic.Pathogeny;

/// 抗生素
Property MPAAntiDr As DHCMed.NINF.Dic.Antibiotics;

Index IndexPy On MPAPyDr As Exact;

Index IndexAnti On MPAAntiDr As Exact;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取病原体与抗生素映射
/// Table：       DHCMed.NINF.Dic.MapPyAnti
/// Input：       DHCMed.NINF.Dic.MapPyAnti.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.MapPyAnti).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.MapPyAnti
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.MapPyAnti).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新病原体与抗生素映射
/// Table：       DHCMed.NINF.Dic.MapPyAnti
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.MapPyAnti).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.MapPyAnti).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.MapPyAnti).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MPAPyDr=##class(DHCMed.NINF.Dic.Pathogeny).GetObjById($p(aInput,aSeparate,2))
	Set obj.MPAAntiDr=##class(DHCMed.NINF.Dic.Antibiotics).GetObjById($p(aInput,aSeparate,3))
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
/// Description:  删除病原体与抗生素映射
/// Table：       DHCMed.NINF.Dic.MapPyAnti
/// Input：       DHCMed.NINF.Dic.MapPyAnti.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.MapPyAnti).%DeleteId(+aId)
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
<Value>MPAPyDr</Value>
</Value>
<Value name="3">
<Value>MPAAntiDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MapPyAntiI")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MapPyAntiI")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MapPyAntiI",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MapPyAntiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
