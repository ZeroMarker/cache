/// 医嘱项表
Class DHCMA.Util.EP.OrdMast Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医嘱ID
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 医嘱代码
Property BTCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 医嘱名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 医嘱分类（大类.子类）
Property BTCatDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 医嘱类型（R药品、L检验、X检查、N其他）
Property BTType As %String(MAXLEN = 3, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取医嘱项信息
/// w ##class(DHCMA.Util.EP.OrdMast).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.OrdMast
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
	
	Set obj=##class(DHCMA.Util.EP.OrdMast).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTCatDesc   = objTmp.BTCatDesc
	Set obj.BTType      = objTmp.BTType
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取医嘱项信息
/// w ##class(DHCMA.Util.EP.OrdMast).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.OrdMast
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.OrdMastI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.OrdMast).GetObjById(ID)
	Quit return
}

/// 保存医嘱项信息
/// w ##class(DHCMA.Util.EP.OrdMast).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.OrdMastSrv).SetOrdMast(aOID)
	Quit return
}

Storage Default
{
<Data name="OrdMastState">
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
<Value>BTCatDesc</Value>
</Value>
<Value name="5">
<Value>BTType</Value>
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
<State>OrdMastState</State>
<StreamLocation>^DHCMA.Util.EP.OrdMastS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
