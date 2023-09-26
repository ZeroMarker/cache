/// 名称: DHCMed.NINF.Dic.MapPosDia
/// 描述: 感染部位与感染诊断映射
/// 编写者：zhufei
/// 编写日期: 2012-05-25
Class DHCMed.NINF.Dic.MapPosDia Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 感染部位
Property MPDInfPosDr As DHCMed.NINF.Dic.InfPosition;

/// 感染诊断
Property MPDInfDiaDr As DHCMed.NINF.Dic.InfDiagnose;

Index IndexInfPos On MPDInfPosDr As Exact;

Index IndexInfDia On MPDInfDiaDr As Exact;

Index IndexPosDiag On (MPDInfPosDr As Exact, MPDInfDiaDr As Exact);

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  取感染部位与感染诊断映射
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       DHCMed.NINF.Dic.MapPosDia.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.MapPosDia).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.MapPosDia
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.MapPosDia).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2012-05-25
/// Description:  更新感染部位与感染诊断映射
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.MapPosDia).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.MapPosDia).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.MapPosDia).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MPDInfPosDr=##class(DHCMed.NINF.Dic.InfPosition).GetObjById($p(aInput,aSeparate,2))
	Set obj.MPDInfDiaDr=##class(DHCMed.NINF.Dic.InfDiagnose).GetObjById($p(aInput,aSeparate,3))
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
/// Description:  删除感染部位与感染诊断映射
/// Table：       DHCMed.NINF.Dic.MapPosDia
/// Input：       DHCMed.NINF.Dic.MapPosDia.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.MapPosDia).%DeleteId(+aId)
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
<Value>MPDInfPosDr</Value>
</Value>
<Value name="3">
<Value>MPDInfDiaDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MapPosDia")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MapPosDia")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MapPosDia",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MapPosDiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
