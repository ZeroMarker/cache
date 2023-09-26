/// 名称: DHCMed.NINF.Dic.EnviHyLocItems
/// 描述: 环境卫生学监测 科室项目维护
/// 编写者：zhufei
/// 编写日期: 2014-07-01
Class DHCMed.NINF.Dic.EnviHyLocItems Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 科室(指向CT_Loc)
Property EHLILocDr As %String(TRUNCATE = 1);

/// 项目
Property EHLIItemDr As DHCMed.NINF.Dic.EnviHyItem;

/// 项目环境(指向DHCMed_NINF_Dic.EnviHyNorms) 多值#分隔
Property EHLINorms As %String(MAXLEN = 3000, TRUNCATE = 1);

/// 是否有效
Property EHLIIsActive As %Boolean;

/// 备注
Property EHLIResume As %String(TRUNCATE = 1);

Index IndexLocItem On (EHLILocDr, EHLIItemDr) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  取科室项目维护
/// Table：       DHCMed.NINF.Dic.EnviHyLocItems
/// Input：       DHCMed.NINF.Dic.EnviHyLocItems.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.EnviHyLocItems).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.EnviHyLocItems
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.EnviHyLocItems).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-07-01
/// Description:  更新科室项目维护
/// Table：       DHCMed.NINF.Dic.EnviHyLocItems
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.EnviHyLocItems).Update("^1^1^2#3#4^1^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
 
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set LocID=$p(aInput,aSeparate,2)
	Set ItemID=$p(aInput,aSeparate,3)
	Quit:(LocID="")||(ItemID="") return
	
	Set objItem=##class(DHCMed.NINF.Dic.EnviHyItem).GetObjById(ItemID)
	Quit:'$IsObject(objItem) return
	
	Set:ID="" ID=$o(^DHCMed.NINFDi("EHLI",0,"IndexLocItem"," "_LocID,ItemID,0))
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyLocItems).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.EnviHyLocItems).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.EHLILocDr=LocID
	Set obj.EHLIItemDr=objItem
	Set obj.EHLINorms=$p(aInput,aSeparate,4)  //多值#分隔
	Set obj.EHLIIsActive=+$p(aInput,aSeparate,5)
	Set obj.EHLIResume=$p(aInput,aSeparate,6)
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
/// CreatDate：   2014-07-01
/// Description:  删除科室项目维护
/// Table：       DHCMed.NINF.Dic.EnviHyLocItems
/// Input：       DHCMed.NINF.Dic.EnviHyLocItems.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.EnviHyLocItems).%DeleteId(+aId)
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
<Value>EHLILocDr</Value>
</Value>
<Value name="3">
<Value>EHLIItemDr</Value>
</Value>
<Value name="4">
<Value>EHLINorms</Value>
</Value>
<Value name="5">
<Value>EHLIIsActive</Value>
</Value>
<Value name="6">
<Value>EHLIResume</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("EHLI")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("EHLI")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("EHLI",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.EnviHyLocItemsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
