/// 名称: DHCHAI.BT.UserGroup
/// 描述: 角色菜单维护
/// 编写者：chenjb
/// 编写日期: 2021-11-09
Class DHCHAI.BT.UserMenu Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 角色
Property BTUserGroupDr As DHCHAI.BT.UserGroup;

/// 功能菜单
Property BTSysMenuDr As DHCHAI.BT.SysMenu;

Index IndexBTUserGroupDr On BTUserGroupDr;

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  根据ID取维护信息
/// Table：       
/// Input：       aId : 
/// Return：      返回obj
/// w ##class(DHCHAI.BT.UserMenu).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.UserMenu
{
	New (aId)
	Quit:'##class(DHCHAI.BT.UserMenu).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.UserMenu).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  更新维护信息
/// Table：       DHCHAI.BT.UserMenu
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.UserMenu).Update("^1^1","^")
/// w ##class(DHCHAI.BT.UserMenu).Update("^1^2","^")
/// w ##class(DHCHAI.BT.UserMenu).Update("^1^3","^")
/// w ##class(DHCHAI.BT.UserMenu).Update("^1^4","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID         = $p(aInputStr,aSeparete,1)
	Set BTUserGroupDr = $p(aInputStr,aSeparete,2)
	Set BTSysMenuDr   = $p(aInputStr,aSeparete,3)
	
	Quit:(BTUserGroupDr="")||(BTSysMenuDr="") return
		
	If ID="" {
		Set obj=##class(DHCHAI.BT.UserMenu).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.UserMenu).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set objUserGroup =##class(DHCHAI.BT.UserGroup).GetObjById(BTUserGroupDr) 
	Quit:'$IsObject(objUserGroup) return
	Set objSysMenu =##class(DHCHAI.BT.SysMenu).GetObjById(BTSysMenuDr) 
	Quit:'$IsObject(objSysMenu) return
	
	//角色菜单唯一
	Set tID ="",xID =""
	For {
		Set xID = $o(^DHCHAI.BT.UserMenuI("IndexBTUserGroupDr",BTUserGroupDr,xID))
		Quit:(xID="")||(tID'="")
		
		Set xObj = ##class(DHCHAI.BT.UserMenu).GetObjById(xID)
		Set MenuObj = xObj.BTSysMenuDr
		Continue:'$IsObject(MenuObj)
		Continue:((+BTSysMenuDr)'=MenuObj.%Id())
		Set tID =xID
	}
	Quit:(tID'="")&(ID'=tID) -2
	
	Set obj.BTUserGroupDr     = objUserGroup
	Set obj.BTSysMenuDr    = objSysMenu
	
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2021-09-17
/// Description:  删除维护信息
/// Table：       DHCHAI.BT.UserMenu
/// Input：       aId : DHCHAI.BT.UserMenu.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.UserMenu).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.UserMenu).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="UserMenuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTUserGroupDr</Value>
</Value>
<Value name="3">
<Value>BTSysMenuDr</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.UserMenuD</DataLocation>
<DefaultData>UserMenuDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.UserMenuD</IdLocation>
<IndexLocation>^DHCHAI.BT.UserMenuI</IndexLocation>
<StreamLocation>^DHCHAI.BT.UserMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
