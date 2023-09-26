/// 数据项字典设置表
Class DHCWMR.MQ.ItemDic Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 首页数据项
Property IDItemsDr As DHCWMR.MQ.DataItems;

/// 检索类名
Property IDQryClassName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 检索Qry名
Property IDQryMethodName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示代码
Property IDDisCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 显示描述
Property IDDisDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// Qry入参
Property IDArgs As %String(MAXLEN = 100, TRUNCATE = 1);

/// 选中后加载值
Property IDChooseValue As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否自动加载全部数据
Property IsLoadAll As %Boolean;

/// 是否有效
Property IsActive As %Boolean;

Index IndexItemsDr On IDItemsDr [ Unique ];

/// Creator：     liyi
/// CreatDate：   2016-04-14
/// Description:  取数据项字典表
/// Table：       DHCWMR.MQ.ItemDic
/// Input：       ID : DHCWMR.MQ.DataItems.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.ItemDic).GetObjByItem(524)
ClassMethod GetObjByItem(aItemID As %String) As DHCWMR.MQ.ItemDic
{
	New (aItemID)
	Set return=""
	Quit:aItemID="" return
	Quit:'$d(^DHCWMR.MQ.ItemDicI("IndexItemsDr",aItemID)) return
	
	Set ID= $o(^DHCWMR.MQ.ItemDicI("IndexItemsDr",aItemID,""))
	Quit:ID="" return
	
	Set obj=..GetObjById(ID)
	Set return=obj
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-14
/// Description:  取数据项字典表
/// Table：       DHCWMR.MQ.ItemDic
/// Input：       ID : DHCWMR.MQ.ItemDic.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.ItemDic).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.ItemDic
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.ItemDic).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.ItemDic).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-14
/// Description:  更新数据项字典表
/// Table：       DHCWMR.MQ.ItemDic
/// Input：       InputStr ：字典设置内容
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.ItemDic).Update("","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	
	Set ID				= $p(aInputStr,aSeparate,1)
	Set ItemID			= $p(aInputStr,aSeparate,2)
	Set QryClassName	= $p(aInputStr,aSeparate,3)
	Set QryMethodName	= $p(aInputStr,aSeparate,4)
	Set DisCode			= $p(aInputStr,aSeparate,5)
	Set DisDesc			= $p(aInputStr,aSeparate,6)
	Set Args			= $p(aInputStr,aSeparate,7)
	Set ChooseValue		= $p(aInputStr,aSeparate,8)
	Set LoadAll			= $p(aInputStr,aSeparate,9)
	Set IsActive		= $p(aInputStr,aSeparate,10)
	Quit:(ItemID="")||(QryClassName="")||(QryMethodName="")||(DisCode="")||(DisDesc="")||(LoadAll="")||(IsActive="")||(ChooseValue="") return
	
	Set objItem = ##class(DHCWMR.MQ.DataItems).GetObjById(ItemID)
	Quit:'$isobject(objItem) return
	
	If $d(^DHCWMR.MQ.ItemDicI("IndexItemsDr",ItemID)){
		Set ID= $o(^DHCWMR.MQ.ItemDicI("IndexItemsDr",ItemID,""))
	}
	
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.ItemDic).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.ItemDic).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.IDItemsDr		=objItem
	Set obj.IDQryClassName	=QryClassName
	Set obj.IDQryMethodName	=QryMethodName
	Set obj.IDDisCode		=DisCode
	Set obj.IDDisDesc		=DisDesc
	Set obj.IDArgs			=Args
	Set obj.IDChooseValue	=ChooseValue
	Set obj.IsLoadAll		=LoadAll
	Set obj.IsActive		=IsActive
	
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1_"^"_sc
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-14
/// Description:  删除数据项字典表
/// Table：       DHCWMR.MQ.ItemDic
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.ItemDic).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.ItemDic).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDItemsDr</Value>
</Value>
<Value name="3">
<Value>IDQryClassName</Value>
</Value>
<Value name="4">
<Value>IDQryMethodName</Value>
</Value>
<Value name="5">
<Value>IDDisCode</Value>
</Value>
<Value name="6">
<Value>IDDisDesc</Value>
</Value>
<Value name="7">
<Value>IDArgs</Value>
</Value>
<Value name="8">
<Value>IDChooseValue</Value>
</Value>
<Value name="9">
<Value>IsLoadAll</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MQ.ItemDicD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCWMR.MQ.ItemDicD</IdLocation>
<IndexLocation>^DHCWMR.MQ.ItemDicI</IndexLocation>
<StreamLocation>^DHCWMR.MQ.ItemDicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
