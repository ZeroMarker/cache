/// 安全组表
Class DHCMA.Util.EP.SSGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 安全组ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 安全组名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSGroup.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取安全组信息
/// w ##class(DHCMA.Util.EP.SSGroup).GetObjByOID("2!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.SSGroup
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
	
	Set obj=##class(DHCMA.Util.EP.SSGroup).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取安全组信息
/// w ##class(DHCMA.Util.EP.SSGroup).xGetByOID("2!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.SSGroup
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.SSGroupI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.SSGroup).GetObjById(ID)
	Quit return
}

/// 保存安全组信息
/// w ##class(DHCMA.Util.EP.SSGroup).xSetByOID("2!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.SSGroupSrv).SetSSGroup(aOID)
	Quit return
}

Storage Default
{
<Data name="SSGroupState">
<Value name="1">
<Value>OID</Value>
</Value>
<Value name="2">
<Value>BTDesc</Value>
</Value>
<Value name="3">
<Value>BTIsActive</Value>
</Value>
<Value name="4">
<Value>BTActDate</Value>
</Value>
<Value name="5">
<Value>BTActTime</Value>
</Value>
<Value name="6">
<Value>BTActUserID</Value>
</Value>
</Data>
<State>SSGroupState</State>
<StreamLocation>^DHCMA.Util.EP.SSGroupS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
