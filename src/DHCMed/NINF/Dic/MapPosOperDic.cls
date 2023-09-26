/// 名称: DHCMed.NINF.Dic.MapPosOperDic
/// 描述: 感染部位与侵害性操作
/// 编写者：LiuYH
/// 编写日期: 2012-12-21
Class DHCMed.NINF.Dic.MapPosOperDic Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 感染部位
Property MPDInfPosDr As DHCMed.NINF.Dic.InfPosition;

/// 感染侵害性操作
Property MPDInfOper As DHCMed.SS.Dictionary;

Index IndexInfPos On MPDInfPosDr As Exact;

Index IndexInfOper On MPDInfOper As Exact;

Index IndexPosOper On (MPDInfPosDr As Exact, MPDInfOper As Exact);

/// Creator：     LiuYH
/// CreatDate：   2012-12-21
/// Description:  取感染部位与侵害性操作
/// Table：       DHCMed.NINF.Dic.MapPosOperDic
/// Input：       DHCMed.NINF.Dic.MapPosOperDic.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.MapPosOperDic).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.MapPosOperDic
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.MapPosOperDic).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     LiuYH
/// CreatDate：   2012-12-21
/// Description:  更新感染部位与侵害性操作
/// Table：       DHCMed.NINF.Dic.MapPosOperDic
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.MapPosOperDic).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.MapPosOperDic).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.MapPosOperDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MPDInfPosDr=##class(DHCMed.NINF.Dic.InfPosition).GetObjById($p(aInput,aSeparate,2))
	Set obj.MPDInfOper=##class(DHCMed.SS.Dictionary).GetObjById($p(aInput,aSeparate,3))
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

/// Creator：     LiuYH
/// CreatDate：   2012-12-21
/// Description:  删除感染部位与侵害性操作
/// Table：       DHCMed.NINF.Dic.MapPosOperDic
/// Input：       DHCMed.NINF.Dic.MapPosOperDic.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.MapPosOperDic).%DeleteId(+aId)
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
<Data name="MapPosOperDicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MPDInfPosDr</Value>
</Value>
<Value name="3">
<Value>MPDInfDiaDr</Value>
</Value>
<Value name="4">
<Value>MPDInfOper</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("MapPosOpr")</DataLocation>
<DefaultData>MapPosOperDicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("MapPosOpr")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("MapPosOpr",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.MapPosOperDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
