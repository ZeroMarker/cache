/// 用户表
Class DHCMA.Util.EP.SSUser Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 用户ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 用户代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 用户密码（暂时不用）
Property BTPassword As %String(MAXLEN = 100, TRUNCATE = 1);

/// 用户科室
Property BTLocID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 指向医护人员
Property BTCareProvID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值域ID（指向DHCMA.Util.EP.SSUser.OID） 用于多个HIS字典对照
Property BTRangeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取用户信息
/// w ##class(DHCMA.Util.EP.SSUser).GetObjByOID("2!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.SSUser
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set objTmp=..xGetByOID(aOID)
	If '$IsObject(objTmp){
		Set flg=..xSetByOID(aOID)
		Quit:(+flg)<1 return
		Set objTmp=..xGetByOID(aOID)
	}
	Quit:'$IsObject(objTmp) return
	
	Set obj=##class(DHCMA.Util.EP.SSUser).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTPassword  = objTmp.BTPassword
	Set obj.BTLocID     = objTmp.BTLocID
	Set obj.BTCareProvID= objTmp.BTCareProvID
	Set obj.BTRangeID   = objTmp.BTRangeID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取用户信息
/// w ##class(DHCMA.Util.EP.SSUser).xGetByOID("2!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.SSUser
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.SSUserI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.SSUser).GetObjById(ID)
	Quit return
}

/// 保存用户信息
/// w ##class(DHCMA.Util.EP.SSUser).xSetByOID("2!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.SSUserSrv).SetSSUser(aOID)
	Quit return
}

Storage Default
{
<Data name="SSUserState">
<Value name="1">
<Value>OID</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTPassword</Value>
</Value>
<Value name="5">
<Value>BTLocID</Value>
</Value>
<Value name="6">
<Value>BTCareProvID</Value>
</Value>
<Value name="7">
<Value>BTRangeID</Value>
</Value>
<Value name="8">
<Value>BTIsActive</Value>
</Value>
<Value name="9">
<Value>BTActDate</Value>
</Value>
<Value name="10">
<Value>BTActTime</Value>
</Value>
<Value name="11">
<Value>BTActUserID</Value>
</Value>
</Data>
<State>SSUserState</State>
<StreamLocation>^DHCMA.Util.EP.SSUserS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
