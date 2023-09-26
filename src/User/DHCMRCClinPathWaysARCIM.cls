Class User.DHCMRCClinPathWaysARCIM Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医嘱项 指向ARCItmMast
Property ITMARCIMDR As %String(TRUNCATE = 1);

/// 数量
Property ITMQty As %Float;

/// 频次 指向PHCFreq
Property ITMFreqDR As %String(TRUNCATE = 1);

/// 疗程 指向PHCDuration
Property ITMDuratDR As %String(TRUNCATE = 1);

/// 用法 指向PHCInstruc
Property ITMInstrucDR As %String(TRUNCATE = 1);

/// 单次剂量
Property ITMDoseQty As %Float;

/// 单位 指向CTUOM
Property ITMUOMDR As %String(TRUNCATE = 1);

/// 默认标志(首选医嘱)
Property ITMDefault As %String(TRUNCATE = 1);

/// 医嘱备注
Property ITMResume As %String(TRUNCATE = 1);

/// 是否有效
Property ITMIsActive As %String(DISPLAYLIST = ",Yes,No", MINLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// (作废)关联号 update by zf 20150525
Property ITMLinkNo As %Float;

/// (作废)序号 update by zf 20150525
Property ITMNo As %Float;

/// (作废)医嘱类型 update by zf 20150525
/// Table:OEC_Priority
Property ITMPriority As %String(TRUNCATE = 1);

/// (作废)是否主项目 update by zf 20150525
Property ITMIsMain As %String(TRUNCATE = 1);

/// (作废)医嘱套编号 update by zf 20150525
Property ITMGroupNo As %Float;

/// 修改人
Property ITMUpdateUser As %String(TRUNCATE = 1);

/// 修改日期
Property ITMUpdateDate As %String(TRUNCATE = 1);

/// 修改时间
Property ITMUpdateTime As %String(TRUNCATE = 1);

/// 复制/替换医嘱号
Property ITMUpdateNo As %String(TRUNCATE = 1);

/// w ##Class(User.DHCMRCClinPathWaysARCIM).GetObj()
ClassMethod GetObj(aInputStr As %String) As User.DHCMRCClinPathWaysARCIM
{
	New (aInputStr)
	Set return=""
	Quit:aInputStr="" return
	Set obj=##Class(User.DHCMRCClinPathWaysARCIM).%New()
	Set obj.ITMARCIMDR     = $p(aInputStr,"^",1)
	Set obj.ITMQty         = $p(aInputStr,"^",2)
	Set obj.ITMFreqDR      = $p(aInputStr,"^",3)
	Set obj.ITMDuratDR     = $p(aInputStr,"^",4)
	Set obj.ITMInstrucDR   = $p(aInputStr,"^",5)
	Set obj.ITMUOMDR       = $p(aInputStr,"^",6)
	Set obj.ITMDoseQty     = $p(aInputStr,"^",7)
	Set obj.ITMResume      = $p(aInputStr,"^",8)
	Set obj.ITMDefault     = $p(aInputStr,"^",9)
	Set obj.ITMIsActive    = $p(aInputStr,"^",10)
	Set obj.ITMUpdateUser  = $p(aInputStr,"^",11)
	Set obj.ITMUpdateDate  = $p(aInputStr,"^",12)
	Set obj.ITMUpdateTime  = $p(aInputStr,"^",13)
	Set obj.ITMUpdateNo    = $p(aInputStr,"^",14)
	Quit obj
}

Storage Default
{
<Data name="DHCMRCClinPathWaysARCIMState">
<Subscript>"User.DHCMRCClinPathWaysARCIM"</Subscript>
<Value name="1">
<Value>ITMARCIMDR</Value>
</Value>
<Value name="2">
<Value>ITMDefault</Value>
</Value>
<Value name="3">
<Value>ITMDoseQty</Value>
</Value>
<Value name="4">
<Value>ITMDuratDR</Value>
</Value>
<Value name="5">
<Value>ITMFreqDR</Value>
</Value>
<Value name="6">
<Value>ITMInstrucDR</Value>
</Value>
<Value name="7">
<Value>ITMLinkNo</Value>
</Value>
<Value name="8">
<Value>ITMNo</Value>
</Value>
<Value name="9">
<Value>ITMQty</Value>
</Value>
<Value name="10">
<Value>ITMUOMDR</Value>
</Value>
<Value name="11">
<Value>ITMIsMain</Value>
</Value>
<Value name="12">
<Value>ITMPriority</Value>
</Value>
<Value name="13">
<Value>ITMGroupNo</Value>
</Value>
<Value name="14">
<Value>ITMResume</Value>
</Value>
<Value name="15">
<Value>ITMIsActive</Value>
</Value>
<Value name="16">
<Value>ITMUpdateDate</Value>
</Value>
<Value name="17">
<Value>ITMUpdateNo</Value>
</Value>
<Value name="18">
<Value>ITMUpdateTime</Value>
</Value>
<Value name="19">
<Value>ITMUpdateUser</Value>
</Value>
</Data>
<DataLocation>^DHCMRC("ARCIM")</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^DHCMRC("ARCIM")</IdLocation>
<IndexLocation>^DHCMRC("ARCIM")(0)</IndexLocation>
<State>DHCMRCClinPathWaysARCIMState</State>
<StreamLocation>^User.DHCMRCClinPathWaysARCIMS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
