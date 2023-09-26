/// 医护人员表
Class DHCMA.Util.EP.CareProv Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 人员ID（格式：字典ID!!系统ID）
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 工号
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医护类型
Property BTType As %String(DISPLAYLIST = ",Doctor,Nurse", VALUELIST = ",D,N");

/// 值域ID（指向DHCMA.Util.EP.CareProv.OID） 用于多个HIS字典对照
Property BTRangeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取医护人员信息
/// w ##class(DHCMA.Util.EP.CareProv).GetObjByOID("100!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.CareProv
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	//OID有效性检查，缺系统指针自动补齐
	Set aOID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aOID)
	
	Set objTmp=..xGetByOID(aOID)
	If '$IsObject(objTmp){
		Set flg=..xSetByOID(aOID)
		Quit:(+flg)<1 return
		Set objTmp=..xGetByOID(aOID)
	}
	Quit:'$IsObject(objTmp) return
	
	Set obj=##class(DHCMA.Util.EP.CareProv).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTType      = objTmp.BTType
	Set obj.BTRangeID   = objTmp.BTRangeID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取医护人员信息
/// w ##class(DHCMA.Util.EP.CareProv).xGetByOID("2!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.CareProv
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.CareProvI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.CareProv).GetObjById(ID)
	Quit return
}

/// 保存医护人员信息
/// w ##class(DHCMA.Util.EP.CareProv).xSetByOID("2!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.CareProvSrv).SetCareProv(aOID)
	Quit return
}

Storage Default
{
<Data name="CareProvState">
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
<Value>BTType</Value>
</Value>
<Value name="5">
<Value>BTRangeID</Value>
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
<State>CareProvState</State>
<StreamLocation>^DHCMA.Util.EP.CareProvS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
