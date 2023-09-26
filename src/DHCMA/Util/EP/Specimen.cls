/// 送检标本表
Class DHCMA.Util.EP.Specimen Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 标本ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 标本代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 标本名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取标本信息
/// w ##class(DHCMA.Util.EP.Specimen).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.Specimen
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
	
	Set obj=##class(DHCMA.Util.EP.Specimen).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取标本信息
/// w ##class(DHCMA.Util.EP.Specimen).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.Specimen
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.SpecimenI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.Specimen).GetObjById(ID)
	Quit return
}

/// 保存标本信息
/// w ##class(DHCMA.Util.EP.Specimen).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.SpecimenSrv).SetSpecimen(aOID)
	Quit return
}

Storage Default
{
<Data name="SpecimenState">
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
<Value>BTIsActive</Value>
</Value>
<Value name="5">
<Value>BTActDate</Value>
</Value>
<Value name="6">
<Value>BTActTime</Value>
</Value>
<Value name="7">
<Value>BTActUserID</Value>
</Value>
</Data>
<State>SpecimenState</State>
<StreamLocation>^DHCMA.Util.EP.SpecimenS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
