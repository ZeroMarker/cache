/// 检验医嘱表
Class DHCMA.Util.EP.TestSet Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检验医嘱ID
Property OID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检验医嘱代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验医嘱名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 医嘱代码
Property BTCode2 As %String(MAXLEN = 500, TRUNCATE = 1);

/// 医嘱名称
Property BTDesc2 As %String(MAXLEN = 500, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取检验医嘱信息
/// w ##class(DHCMA.Util.EP.TestSet).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.TestSet
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
	
	Set obj=##class(DHCMA.Util.EP.TestSet).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTCode2     = objTmp.BTCode2
	Set obj.BTDesc2     = objTmp.BTDesc2
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取检验医嘱信息
/// w ##class(DHCMA.Util.EP.TestSet).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.TestSet
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.TestSetI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.TestSet).GetObjById(ID)
	Quit return
}

/// 保存检验医嘱信息
/// w ##class(DHCMA.Util.EP.TestSet).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.TestSetSrv).SetTestSet(aOID)
	Quit return
}

Storage Default
{
<Data name="TestSetState">
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
<Value>BTCode2</Value>
</Value>
<Value name="5">
<Value>BTDesc2</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserID</Value>
</Value>
</Data>
<State>TestSetState</State>
<StreamLocation>^DHCMA.Util.EP.TestSetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
