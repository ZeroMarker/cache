/// 名称: DHCMed.NINF.Dic.InfPosition
/// 描述: 院感部位字典
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.InfPosition Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 代码
Property IPCode As %String(TRUNCATE = 1) [ Required ];

/// 描述
Property IPDesc As %String(TRUNCATE = 1) [ Required ];

/// 是否有效
Property IPActive As %Boolean;

/// 备注
Property IPResume As %String(TRUNCATE = 1);

Index IndexCode On IPCode As SqlUpper;

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取感染部位字典
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       DHCMed.NINF.Dic.InfPosition.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.InfPosition).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.InfPosition
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.InfPosition).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新感染部位字典
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.InfPosition).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.InfPosition).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.InfPosition).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IPCode=$p(aInput,aSeparate,2)
	Set obj.IPDesc=$p(aInput,aSeparate,3)
	Set obj.IPActive=+$p(aInput,aSeparate,4)
	Set obj.IPResume=$p(aInput,aSeparate,5)
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
/// Description:  删除感染部位字典
/// Table：       DHCMed.NINF.Dic.InfPosition
/// Input：       DHCMed.NINF.Dic.InfPosition.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.InfPosition).%DeleteId(+aId)
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
<Value>IPCode</Value>
</Value>
<Value name="3">
<Value>IPDesc</Value>
</Value>
<Value name="4">
<Value>IPActive</Value>
</Value>
<Value name="5">
<Value>IPResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("InfPos")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("InfPos")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("InfPos",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.InfPositionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
