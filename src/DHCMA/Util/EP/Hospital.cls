/// 医院表
Class DHCMA.Util.EP.Hospital Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医院ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 组织机构代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 医疗机构名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医院别名
Property BTDesc2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医院分组
Property BTGroupDr As DHCMA.Util.BT.HospGroup;

/// 值域ID（指向DHCMA.Util.EP.Hospital.OID） 用于多个HIS字典对照
Property BTRangeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取医院信息
/// w ##class(DHCMA.Util.EP.Hospital).GetObjByOID("3!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.Hospital
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
	
	Set obj=##class(DHCMA.Util.EP.Hospital).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTDesc2     = objTmp.BTDesc2
	Set obj.BTGroupDr   = objTmp.BTGroupDr
	Set obj.BTRangeID   = objTmp.BTRangeID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取医院信息
/// w ##class(DHCMA.Util.EP.Hospital).xGetByOID("3!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.Hospital
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.HospitalI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.Hospital).GetObjById(ID)
	Quit return
}

/// 保存医院信息
/// w ##class(DHCMA.Util.EP.Hospital).xSetByOID("3!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.HospitalSrv).SetHospital(aOID)
	Quit return
}

Storage Default
{
<Data name="HospitalState">
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
<Value>BTGroupDr</Value>
</Value>
<Value name="6">
<Value>BTRangeID</Value>
</Value>
<Value name="7">
<Value>BTIsActive</Value>
</Value>
<Value name="8">
<Value>BTActDate</Value>
</Value>
<Value name="9">
<Value>BTActTime</Value>
</Value>
<Value name="10">
<Value>BTActUserID</Value>
</Value>
</Data>
<State>HospitalState</State>
<StreamLocation>^DHCMA.Util.EP.HospitalS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
