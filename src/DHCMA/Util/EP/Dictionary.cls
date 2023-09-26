/// 基础字典表
Class DHCMA.Util.EP.Dictionary Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 基础字典ID（格式：字典ID!!系统ID）
Property OID As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 字典类型
Property BTTypeDr As DHCMA.Util.BT.DicType;

/// 值域ID（指向DHCMA.Util.EP.Dictionary.OID） 用于多个HIS字典对照
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
/// w ##class(DHCMA.Util.EP.Dictionary).GetObjByOID("HISCTSex","2!!1")
ClassMethod GetObjByOID(aTypeCode As %String, aOID As %String) As DHCMA.Util.EP.Dictionary
{
	New (aTypeCode, aOID)
	Set return=""
	Quit:(aTypeCode="")||(aOID="") return
	
	//有效性检查，是否定义的HIS字典代码
	Set objType=##class(DHCMA.Util.BT.DicType).GetObjByCode(aTypeCode)
	Quit:'$IsObject(objType) return
	Quit:'$IsObject(objType.BTProductDr) return
	Set ProCode=objType.BTProductDr.ProCode
	Quit:ProCode'="HIS" return
	Set TypeDr=objType.%Id()
	
	//OID有效性检查，缺系统指针自动补齐
	Set aOID=##class(DHCMA.Util.EPS.OIDService).GetValidOID(aOID)
	
	Set objTmp=..xGetByOID(TypeDr,aOID)
	If '$IsObject(objTmp){
		Set flg=..xSetByOID(TypeDr,aOID)
		Quit:(+flg)<1 return
		Set objTmp=..xGetByOID(TypeDr,aOID)
	}
	Quit:'$IsObject(objTmp) return
	
	Set obj=##class(DHCMA.Util.EP.Dictionary).%New()
	Set obj.OID         = objTmp.OID
	Set obj.BTCode      = objTmp.BTCode
	Set obj.BTDesc      = objTmp.BTDesc
	Set obj.BTTypeDr    = objTmp.BTTypeDr
	Set obj.BTRangeID   = objTmp.BTRangeID
	Set obj.BTIsActive  = objTmp.BTIsActive
	Set obj.BTActDate   = objTmp.BTActDate
	Set obj.BTActTime   = objTmp.BTActTime
	Set obj.BTActUserID = objTmp.BTActUserID
	If obj'="" Do obj.%Close()
	Quit obj
}

/// 取医护人员信息
/// w ##class(DHCMA.Util.EP.Dictionary).xGetByOID(1,"2!!1")
ClassMethod xGetByOID(aTypeDr As %String, aOID As %String) As DHCMA.Util.EPx.Dictionary
{
	New (aTypeDr, aOID)
	Set return=""
	Quit:(aTypeDr="")||(aOID="") return
	
	Set ID=$o(^DHCMA.Util.EPx.DictionaryI("IdxOfTypeDrOID",aTypeDr," "_$zcvt(aOID,"U"),0))
	Quit:ID="" return
	Set return=##class(DHCMA.Util.EPx.Dictionary).GetObjById(ID)
	Quit return
}

/// 保存医护人员信息
/// w ##class(DHCMA.Util.EP.Dictionary).xSetByOID(1,"2!!1")
ClassMethod xSetByOID(aTypeDr As %String, aOID As %String) As %String
{
	New (aTypeDr,aOID)
	Set return=##Class(DHCMA.Util.EPy.DictionarySrv).SetDictionary(aTypeDr,aOID)
	Quit return
}

Storage Default
{
<Data name="DictionaryState">
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
<Value>BTTypeDr</Value>
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
<State>DictionaryState</State>
<StreamLocation>^DHCMA.Util.EP.DictionaryS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
