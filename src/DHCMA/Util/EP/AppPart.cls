/// 检查部位表
Class DHCMA.Util.EP.AppPart Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检查部位ID
Property OID As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检查部位代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检查部位名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 父节点（检查部位）
Property BTLastOID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取检查部位信息
/// w ##class(DHCMA.Util.EP.AppPart).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.AppPart
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
	
	Set obj=##class(DHCMA.Util.EP.AppPart).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTLastOID   = objTmp.BTLastOID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取检查部位信息
/// w ##class(DHCMA.Util.EP.AppPart).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EP.AppPart
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EP.AppPartI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EP.AppPart).GetObjById(ID)
	Quit return
}

/// 保存检查部位信息
/// w ##class(DHCMA.Util.EP.AppPart).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.AppPartSrv).SetAppPart(aOID)
	Quit return
}

Storage Default
{
<Data name="AppPartState">
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
<Value>BTLastOID</Value>
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
<State>AppPartState</State>
<StreamLocation>^DHCMA.Util.EP.AppPartS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
