/// 名称: DHCMA.Util.BT.AreaIODictionary
/// 描述: 省市县乡字典接口数据
/// 编写者：pylian
/// 编写日期: 2021-01-15
Class DHCMA.Util.BT.AreaIODictionary Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 数据来源
Property BTSource As %String(TRUNCATE = 1);

/// 主代码
/// 可以当做唯一标示使用
Property BTIDCode As %String(TRUNCATE = 1);

/// 字典代码
Property BTCode As %String(TRUNCATE = 1);

/// 描述
Property BTDesc As %String(MAXLEN = 200, TRUNCATE = 1);

/// 是否有效
Property BTIsActive As %Boolean;

/// 数据来源
Index IndexSource On BTSource;

/// 代码索引
Index IndexCode On BTCode;

/// 描述索引
Index IndexSrcDesc On (BTSource, BTDesc);

/// 主代码索引
Index IndexSrcIDCode On (BTSource, BTIDCode) [ Unique ];

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  取接口字典
/// Table：       DHCMA.Util.BT.AreaIODictionary
/// Input：       DHCMA.Util.BT.AreaIODictionary.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.AreaIODictionary).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.AreaIODictionary
{
	New (aId)
	Set obj=##Class(DHCMA.Util.BT.AreaIODictionary).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  更新接口字典
/// Table：       DHCMA.Util.BT.AreaIODictionary
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMA.Util.BT.AreaIODictionary).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set Source=$p(aInput,aSeparate,2)
	Set IDCode=$p(aInput,aSeparate,3)
	Set IsActive =$p(aInput,aSeparate,6)
	Set:IsActive="" IsActive=1
	Set ID=$o(^CF.MA.Util.BT.AreaIODictionaryI("IndexSrcIDCode"," "_Source," "_$zcvt(IDCode,"U"),""))
	
	If (ID="") {
		Set obj=##class(DHCMA.Util.BT.AreaIODictionary).%New()
	} Else {
		Set obj=##class(DHCMA.Util.BT.AreaIODictionary).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTSource=Source
	Set obj.BTIDCode=IDCode
	Set obj.BTCode=$p(aInput,aSeparate,4)
	Set obj.BTDesc=$p(aInput,aSeparate,5)
	Set obj.BTIsActive=IsActive
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

/// Creator：     pylian
/// CreatDate：   2021-01-15
/// Description:  删除接口字典
/// Table：       DHCMA.Util.BT.AreaIODictionary
/// Input：       DHCMA.Util.BT.AreaIODictionary.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMA.Util.BT.AreaIODictionary).%DeleteId(+aId)
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
<Value>BTSource</Value>
</Value>
<Value name="3">
<Value>BTIDCode</Value>
</Value>
<Value name="4">
<Value>BTCode</Value>
</Value>
<Value name="5">
<Value>BTDesc</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^CF.MA.Util.BT.AreaIODictionaryD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.MA.Util.BT.AreaIODictionaryD</IdLocation>
<IndexLocation>^CF.MA.Util.BT.AreaIODictionaryI</IndexLocation>
<StreamLocation>^CF.MA.Util.BT.AreaIODictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
