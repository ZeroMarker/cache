/// 检验项目表
Class DHCMA.Util.EP.TestCode Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 检验项目ID
Property OID As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 检验项目代码
Property BTCode As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 检验项目名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 结果类型
Property BTRstFormat As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常标志（L,H,N集合）
Property BTAbFlagS As %String(MAXLEN = 100, TRUNCATE = 1);

/// 临床意义
Property BTClDiagnos As %String(MAXLEN = 100, TRUNCATE = 1);

/// 正常参考值
Property BTRefRanges As %String(MAXLEN = 100, TRUNCATE = 1);

/// 缩写码
Property BTWCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 有效标志
Property BTIsActive As %Boolean;

/// 日期
Property BTActDate As %Date;

/// 时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 取检验项目信息
/// w ##class(DHCMA.Util.EP.TestCode).GetObjByOID("11!!1")
ClassMethod GetObjByOID(aOID As %String) As DHCMA.Util.EP.TestCode
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
	
	Set obj=##class(DHCMA.Util.EP.TestCode).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTRstFormat = objTmp.BTRstFormat
	Set obj.BTAbFlagS   = objTmp.BTAbFlagS
	Set obj.BTClDiagnos = objTmp.BTClDiagnos
	Set obj.BTRefRanges = objTmp.BTRefRanges
	Set obj.BTWCode     = objTmp.BTWCode
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取检验项目信息
/// w ##class(DHCMA.Util.EP.TestCode).xGetByOID("11!!1")
ClassMethod xGetByOID(aOID As %String) As DHCMA.Util.EPx.TestCode
{
	New (aOID)
	Set return=""
	Quit:(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.TestCodeI("IdxOfOID"," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.TestCode).GetObjById(ID)
	Quit return
}

/// 保存检验项目信息
/// w ##class(DHCMA.Util.EP.TestCode).xSetByOID("11!!1")
ClassMethod xSetByOID(aOID As %String) As %String
{
	New (aOID)
	Set return=##Class(DHCMA.Util.EPy.TestCodeSrv).SetTestCode(aOID)
	Quit return
}

Storage Default
{
<Data name="TestCodeState">
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
<Value>BTRstFormat</Value>
</Value>
<Value name="5">
<Value>BTAbFlagS</Value>
</Value>
<Value name="6">
<Value>BTClDiagnos</Value>
</Value>
<Value name="7">
<Value>BTRefRanges</Value>
</Value>
<Value name="8">
<Value>BTWCode</Value>
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
</Data>
<State>TestCodeState</State>
<StreamLocation>^DHCMA.Util.EP.TestCodeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
