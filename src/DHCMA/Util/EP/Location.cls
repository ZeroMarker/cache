/// 科室表
Class DHCMA.Util.EP.Location Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 科室ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 科室代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 科室别名
Property BTDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室类型（E执行科室、W病区、O其他）
Property BTType As %String(DISPLAYLIST = ",Execute,Ward,Other", VALUELIST = ",E,W,O");

/// 所属医院ID
Property BTHospID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 值域ID（指向DHCMA.Util.EP.Location.OID） 用于多个HIS字典对照
Property BTRangeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 角色/就诊类型 OP门诊 IP住院 EP急诊 Sup医技辅助  Manage管理职能部门 Health体检
Property BTAdmType As %String(DISPLAYLIST = ",OP,IP,EP,Sup,Manage,Health", VALUELIST = ",O,I,E,S,M,H");

/// 取科室信息
/// w ##class(DHCMA.Util.EP.Location).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.Location
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
	
	Set obj=##class(DHCMA.Util.EP.Location).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTDesc2     = objTmp.BTDesc2
	Set obj.BTType      = objTmp.BTType
	Set obj.BTHospID    = objTmp.BTHospID
	Set obj.BTRangeID   = objTmp.BTRangeID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	Set obj.BTAdmType 	= objTmp.BTAdmType
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取医院信息
/// w ##class(DHCMA.Util.EP.Location).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.Location
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.LocationI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.Location).GetObjById(ID)
	Quit return
}

/// 保存科室信息
/// w ##class(DHCMA.Util.EP.Location).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.LocationSrv).SetLocation(aOID)
	Quit return
}

Storage Default
{
<Data name="LocationState">
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
<Value>BTDesc2</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
</Value>
<Value name="6">
<Value>BTHospID</Value>
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
<Value name="12">
<Value>BTAdmType</Value>
</Value>
</Data>
<State>LocationState</State>
<StreamLocation>^DHCMA.Util.EP.LocationS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
