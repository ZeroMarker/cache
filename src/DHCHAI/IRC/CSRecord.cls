/// 名称: DHCHAI.IRC.CSRecord
/// 描述: 疑似病例筛查内容及输出格式
/// 编写者：zhufei
/// 编写日期: 2017-08-10
Class DHCHAI.IRC.CSRecord Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 筛查项目
Property CSItmScreenDr As DHCHAI.IR.CCItmScreen;

/// 筛查项目文本（只有检出菌有值）
Property CSItmScreenTxt As %String(MAXLEN = 500, TRUNCATE = 1);

/// 结果显示文本
Property CSResultNote As %String(MAXLEN = 500, TRUNCATE = 1);

/// 结果日期
Property CSResultDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果数量
Property CSResultCnt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果开始日期
Property CSRstFromDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果截止日期
Property CSRstToDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 结果状态(0触发疑似指标、1触发组合条件) 
Property CSRstStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// 疑似诊断关键词信息
Property CSInfSuKeys As %String(MAXLEN = 100, TRUNCATE = 1);

/// (新增)疑似诊断（部位）ID
Property CSInfSuPosDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// (新增)推荐感染日期
Property CSInfSuDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// (新增)标本名称（多值#分隔）
Property CSSpecimen As %String(MAXLEN = 500, TRUNCATE = 1);

/// (新增)多耐分类名称（多值#分隔）
Property CSMRBType As %String(MAXLEN = 500, TRUNCATE = 1);

/// (新增)规则ID（多值#分隔）
Property CSInfSuRuleDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 是否有效
Property CSIsActive As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)操作状态(0未操作、1确诊、2排除)   ///需用到
Property CSOprStatus As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)操作开始日期
Property CSOprFromDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)操作截止日期
Property CSOprToDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)感染诊断记录指针
Property CSInfDiagnosDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)感染诊断ID
Property CSInfPosDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)感染诊断名称
Property CSInfPosDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)检查阳性症状或体征标志
Property CSIsCheckSx As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)检查发热标志
Property CSIsCheckFe As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)是否检查常规检验异常
Property CSIsCheckTSAb As %String(MAXLEN = 100, TRUNCATE = 1);

/// (作废)筛查日期列表
Property CSSuInfDates As %ListOfDataTypes;

/// (作废)是否入院48小时内项目
Property CSIsI48Hour As %String(MAXLEN = 100, TRUNCATE = 1);

/// (新增)筛查明细（用于病毒支原体检测结果明细显示）
Property CSDetails As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2017-08-10
/// Description:  取疑似病例筛查结果对象
/// Table：       DHCHAI.IRC.CSRecord
/// Input：       无
/// Return：      返回obj
/// w ##class(DHCHAI.IRC.CSRecord).GetObj()
ClassMethod GetObj(aItmScreenID As %String) As DHCHAI.IRC.CSRecord
{
	New (aItmScreenID)
	Set return=""
	Quit:(aItmScreenID="") return
	
	Set objItmScreen=##class(DHCHAI.IR.CCItmScreen).GetObjById(aItmScreenID)
	Quit:'$IsObject(objItmScreen) return
	
	Set obj=##Class(DHCHAI.IRC.CSRecord).%New()
	Set obj.CSItmScreenDr = objItmScreen
	Set obj.CSIsActive    = 1  //有效标志
	Set obj.CSIsCheckSx   = 1  //检查阳性症状或体征标志
	Set obj.CSIsCheckFe   = 1  //检查发热标志
	Set obj.CSIsCheckTSAb = 0  //是否检查常规异常
	Set obj.CSIsI48Hour   = 0  //是否入院48小时内项目
	Set obj.CSRstStatus   = 0  //结果状态(0触发疑似指标、1触发组合条件、2作废|感染诊断)
	Set obj.CSOprStatus   = 0  //操作状态(0未操作、1确诊、2排除)
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="CSRecordState">
<Value name="1">
<Value>CSItmScreenDr</Value>
</Value>
<Value name="2">
<Value>CSItmScreenTxt</Value>
</Value>
<Value name="3">
<Value>CSResultNote</Value>
</Value>
<Value name="4">
<Value>CSResultDate</Value>
</Value>
<Value name="5">
<Value>CSResultCnt</Value>
</Value>
<Value name="6">
<Value>CSRstFromDate</Value>
</Value>
<Value name="7">
<Value>CSRstToDate</Value>
</Value>
<Value name="8">
<Value>CSRstStatus</Value>
</Value>
<Value name="9">
<Value>CSOprStatus</Value>
</Value>
<Value name="10">
<Value>CSInfSuKeys</Value>
</Value>
<Value name="11">
<Value>CSInfDiagnosDr</Value>
</Value>
<Value name="12">
<Value>CSInfPosDr</Value>
</Value>
<Value name="13">
<Value>CSInfPosDesc</Value>
</Value>
<Value name="14">
<Value>CSIsCheckSx</Value>
</Value>
<Value name="15">
<Value>CSIsActive</Value>
</Value>
<Value name="16">
<Value>CSSuInfDates</Value>
</Value>
<Value name="17">
<Value>CSIsCheckFe</Value>
</Value>
<Value name="18">
<Value>CSIsI48Hour</Value>
</Value>
<Value name="19">
<Value>CSIsCheckTSAb</Value>
</Value>
<Value name="20">
<Value>CSOprFromDate</Value>
</Value>
<Value name="21">
<Value>CSOprToDate</Value>
</Value>
<Value name="22">
<Value>CSInfSuPosDr</Value>
</Value>
<Value name="23">
<Value>CSInfSuDate</Value>
</Value>
<Value name="24">
<Value>CSSpecimen</Value>
</Value>
<Value name="25">
<Value>CSMRBType</Value>
</Value>
<Value name="26">
<Value>CSInfSuRuleDr</Value>
</Value>
<Value name="27">
<Value>CSDetails</Value>
</Value>
</Data>
<State>CSRecordState</State>
<StreamLocation>^DHCHAI.IRC.CSRecordS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
