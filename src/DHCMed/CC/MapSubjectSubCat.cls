/// 名称: DHCMed.CC.MapSubjectSubCat
/// 描述: 监控主题配置与监控项目子类映射
/// 编写者：liuyh
/// 编写日期: 2013-02-25
Class DHCMed.CC.MapSubjectSubCat Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 监控主题项目
Property MPSubjectConfigDr As DHCMed.CC.SubjectConfig;

/// 监控项目子类
Property MPItemSubCatDr As DHCMed.CC.ItemSubCat;

Index IndexConfig On MPSubjectConfigDr;

Index IndexSubCat On MPItemSubCatDr;

Index IndexConfigCat On (MPSubjectConfigDr, MPItemSubCatDr) [ Unique ];

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  监控主题配置与监控项目子类映射
/// Table：       DHCMed.CC.MapSubjectSubCat
/// Input：       DHCMed.CC.MapSubjectSubCat.ID
/// Return：      返回obj
/// w ##class(DHCMed.CC.MapSubjectSubCat).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.CC.MapSubjectSubCat
{
	New (aId)
	Set obj=##Class(DHCMed.CC.MapSubjectSubCat).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  更新监控主题配置与监控项目子类映射
/// Table：       DHCMed.CC.MapSubjectSubCat
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.CC.MapSubjectSubCat).Update()
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set MPSubjectConfigDr=$p(aInput,aSeparate,2)
	Set MPItemSubCatDr=$p(aInput,aSeparate,3)
	Quit:(MPSubjectConfigDr="")||(MPItemSubCatDr="") return
	
	Set:ID="" ID=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",MPSubjectConfigDr,MPItemSubCatDr,0))
	
	If (ID="") {
		Set obj=##class(DHCMed.CC.MapSubjectSubCat).%New()
	} Else {
		Set obj=##class(DHCMed.CC.MapSubjectSubCat).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.MPSubjectConfigDr=##class(DHCMed.CC.SubjectConfig).GetObjById(MPSubjectConfigDr)
	Set obj.MPItemSubCatDr=##class(DHCMed.CC.ItemSubCat).GetObjById(MPItemSubCatDr)
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

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  删除监控主题配置与监控项目子类映射
/// Table：       DHCMed.CC.MapSubjectSubCat
/// Input：       DHCMed.CC.MapSubjectSubCat.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.CC.MapSubjectSubCat).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2013-02-25
/// Description:  删除监控主题配置与监控项目子类映射
/// Table：       DHCMed.CC.MapSubjectSubCat
/// Input：       DHCMed.CC.MapSubjectSubCat.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteMapConfigItem(ConfigID, ItemDicID) As %String
{
	New (ConfigID,ItemDicID)
	Set return=0
	Quit:(ConfigID="")||(ItemDicID="") return
	Quit:'$d(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemDicID)) return
	Set aId=$o(^DHCMed.CC.MapSubjectSubCatI("IndexConfigCat",ConfigID,ItemDicID,0))
	
	Set sc = ##class(DHCMed.CC.MapSubjectSubCat).%DeleteId(+aId)
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
<Data name="MapSubjectSubCatDefaultData">
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
<Value>MPSubjectConfigDr</Value>
</Value>
<Value name="5">
<Value>MPItemSubCatDr</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CC.MapSubjectSubCatD</DataLocation>
<DefaultData>MapSubjectSubCatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CC.MapSubjectSubCatD</IdLocation>
<IndexLocation>^DHCMed.CC.MapSubjectSubCatI</IndexLocation>
<StreamLocation>^DHCMed.CC.MapSubjectSubCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
