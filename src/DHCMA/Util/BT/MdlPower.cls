/// 模块操作权限表
Class DHCMA.Util.BT.MdlPower Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 指向安全组（指向DHCMA.Util.BT.SSGroup.OID）
Property BTGroupID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 系统模块定义
Property BTMdlDefDr As DHCMA.Util.BT.MdlDef;

/// 系统模块角色
Property BTMdlRoleDr As DHCMA.Util.BT.MdlRole [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.BT.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 模块+安全组 索引
Index IdxOfMdlGrp On (BTMdlDefDr, BTGroupID);

/// 模块角色+安全组 索引
Index IdxOfMdlRoleGrp On (BTMdlRoleDr, BTGroupID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取模块操作权限信息
/// Table：       DHCMA.Util.BT.MdlPower
/// Input：       aId : DHCMA.Util.BT.MdlPower.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.MdlPower).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.MdlPower
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.MdlPower).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.MdlPower).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新模块操作权限信息
/// Table：       DHCMA.Util.BT.MdlPower
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.MdlPower).Update("2!!1^1||1^1^^^1!!1","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID            = $p(aInputStr,aSeparete,1)
	Set SSGroupID     = $p(aInputStr,aSeparete,2)
	Set MdlRoleDr     = $p(aInputStr,aSeparete,3)
	Set IsActive      = +$p(aInputStr,aSeparete,4)
	Set ActDate       = $p(aInputStr,aSeparete,5)
	Set ActTime       = $p(aInputStr,aSeparete,6)
	Set ActUserID     = $p(aInputStr,aSeparete,7)
	Quit:(SSGroupID="")||(MdlRoleDr="") return
	
	Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set objMdlRole=##class(DHCMA.Util.BT.MdlRole).GetObjById(MdlRoleDr)
	Quit:'$IsObject(objMdlRole) return
	Set objMdlDef=objMdlRole.Parref
	
	Set:ID="" ID=$o(^DHCMA.Util.BT.MdlPowerI("IdxOfMdlRoleGrp",MdlRoleDr," "_SSGroupID,0))
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.MdlPower).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.MdlPower).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTGroupID     = SSGroupID
	Set obj.BTMdlDefDr    = objMdlDef
	Set obj.BTMdlRoleDr   = objMdlRole
	Set obj.BTIsActive    = IsActive
	Set obj.BTActDate     = ActDate
	Set obj.BTActTime     = ActTime
	Set obj.BTActUserID   = ActUserID
	
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

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  删除模块操作权限信息
/// Table：       DHCMA.Util.BT.MdlPower
/// Input：       aId : DHCMA.Util.BT.MdlPower.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.MdlPower).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.BT.MdlPower).%DeleteId(aId)
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
<Data name="MdlPowerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTGroupID</Value>
</Value>
<Value name="3">
<Value>BTMdlDefDr</Value>
</Value>
<Value name="4">
<Value>BTMdlRoleDr</Value>
</Value>
<Value name="5">
<Value>BTIsActive</Value>
</Value>
<Value name="6">
<Value>BTActDate</Value>
</Value>
<Value name="7">
<Value>BTActTime</Value>
</Value>
<Value name="8">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.MdlPowerD</DataLocation>
<DefaultData>MdlPowerDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.MdlPowerD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.MdlPowerI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.MdlPowerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
