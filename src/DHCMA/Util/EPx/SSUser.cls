/// 用户表
Class DHCMA.Util.EPx.SSUser Extends (%Persistent, User.Abstract, DHCMA.Util.EP.SSUser) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 系统指针
Property SYSDr As DHCMA.Util.BT.SYSTEM [ Required ];

/// 字典指针
Property SYSOID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 记录码 索引
Index IdxOfOID On OID [ Unique ];

/// 代码 索引
Index IdxOfCode On (SYSDr, BTCode);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取用户信息
/// Table：       DHCMA.Util.EPx.SSUser
/// Input：       aId : DHCMA.Util.EPx.SSUser.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.SSUser).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.SSUser
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.SSUser).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.SSUser).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新用户信息
/// Table：       DHCMA.Util.EPx.SSUser
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.SSUser).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID         = $p(aInputStr,aSeparete,1)
	Set OID        = $p(aInputStr,aSeparete,2)
	Set Code       = $p(aInputStr,aSeparete,3)
	Set Desc       = $p(aInputStr,aSeparete,4)
	Set Password   = $p(aInputStr,aSeparete,5)
	Set LocID      = $p(aInputStr,aSeparete,6)
	Set CareProvID = $p(aInputStr,aSeparete,7)
	Set RangeID    = $p(aInputStr,aSeparete,8)
	Set IsActive   = +$p(aInputStr,aSeparete,9)
	Set ActUserID  = $p(aInputStr,aSeparete,10)
	Quit:(OID="")||(Desc="") return
	
	Set objSYS=##class(DHCMA.Util.EPS.OIDService).GetSYSDr(OID)
	Set SYSOID=##class(DHCMA.Util.EPS.OIDService).GetSYSOID(OID)
	Quit:(objSYS="")||(SYSOID="") return
	
	Set tID=$o(^DHCMA.Util.EPx.SSUserI("IdxOfOID"," "_$zcvt(OID,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.SSUser).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.SSUser).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.OID          = OID
	Set obj.BTCode       = Code
	Set obj.BTDesc       = Desc
	Set obj.BTPassword   = Password
	Set obj.BTLocID      = LocID
	Set obj.BTCareProvID = CareProvID
	Set obj.BTRangeID    = RangeID
	Set obj.BTIsActive   = IsActive
	Set obj.BTActDate    = +$h
	Set obj.BTActTime    = $p($h,",",2)
	Set obj.BTActUserID  = ActUserID
	Set obj.SYSDr        = objSYS
	Set obj.SYSOID       = SYSOID
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
/// Description:  删除用户信息
/// Table：       DHCMA.Util.EPx.SSUser
/// Input：       aId : DHCMA.Util.EPx.SSUser.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.SSUser).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.SSUser).%DeleteId(aId)
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
<Data name="SSUserDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OID</Value>
</Value>
<Value name="3">
<Value>BTCode</Value>
</Value>
<Value name="4">
<Value>BTDesc</Value>
</Value>
<Value name="5">
<Value>BTPassword</Value>
</Value>
<Value name="6">
<Value>BTLocID</Value>
</Value>
<Value name="7">
<Value>BTCareProvID</Value>
</Value>
<Value name="8">
<Value>BTRangeID</Value>
</Value>
<Value name="9">
<Value>BTIsActive</Value>
</Value>
<Value name="10">
<Value>BTActDate</Value>
</Value>
<Value name="11">
<Value>BTActTime</Value>
</Value>
<Value name="12">
<Value>BTActUserID</Value>
</Value>
<Value name="13">
<Value>SYSDr</Value>
</Value>
<Value name="14">
<Value>SYSOID</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.SSUserD</DataLocation>
<DefaultData>SSUserDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.SSUserD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.SSUserI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.SSUserS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
