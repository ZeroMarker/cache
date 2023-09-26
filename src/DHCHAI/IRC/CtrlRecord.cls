/// 名称: DHCHAI.IRC.CtrlRecord
/// 描述: 监控结果内容及输出格式
/// 编写者：zhufei
/// 编写日期: 2017-05-04
Class DHCHAI.IRC.CtrlRecord Extends %Library.SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 就诊号
Property CCEpisodeDr As DHCHAI.DP.PAAdm;

/// 监控项目
Property CCItemDr As DHCHAI.IR.CCItmMast;

/// 监控结果
Property CCResult As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 定性结果
Property CCTextRes As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 结果单位
Property CCUnit As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生科室
Property CCActLocDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生日期
Property CCActDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生时间
Property CCActTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 发生人
Property CCActUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告（审核）日期
Property CCRepDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告（审核）时间
Property CCRepTime As %String(MAXLEN = 100, TRUNCATE = 1);

/// 报告（审核）人
Property CCRepUser As %String(MAXLEN = 100, TRUNCATE = 1);

/// 子系统代码
Property CCSCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 业务指针（处理任务重复执行，保证数据唯一性）
Property CCObjectID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 附加参数值  格式："参数1=值1,参数2=值2"
Property CCParams As %String(MAXLEN = 500, TRUNCATE = 1);

/// 关键词
Property CCKeyWord As %String(MAXLEN = 100, TRUNCATE = 1);

/// 异常标志
Property CCIsAbFlag As %String(MAXLEN = 100, TRUNCATE = 1);

/// 标本
Property CCSpecimen As %String(MAXLEN = 100, TRUNCATE = 1);

/// 细菌
Property CCBacteria As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐菌分类
Property CCMRBTpDr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗菌用药等级（3特殊使用级、2限制使用级、1非限制使用级）
Property CCAntiGrade As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术日期
Property CCOperDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口类型
Property CCIncision As %String(MAXLEN = 100, TRUNCATE = 1);

/// 抗生素名称
Property CCAntiDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 未结束标记（长期医嘱）
Property CCIsNotEnd As %String(MAXLEN = 100, TRUNCATE = 1);

/// 摘要信息
Property CCSummary As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 多耐菌分类2
Property CCMRBTp2Dr As %String(MAXLEN = 100, TRUNCATE = 1);

/// 多耐菌群   add 20230423
Property MultipleResChild As %String(MAXLEN = 100, TRUNCATE = 1);

/// Creator：     zhufei
/// CreatDate：   2017-05-04
/// Description:  取监控结果对象
/// Table：       DHCHAI.IRC.CtrlRecord
/// Input：       无
/// Return：      返回obj
/// w ##class(DHCHAI.IRC.CtrlRecord).GetObj()
ClassMethod GetObj(aEpisodeID As %String, aItmMastID As %String) As DHCHAI.IRC.CtrlRecord
{
	New (aEpisodeID,aItmMastID)
	Set return=""
	Quit:(aEpisodeID="")||(aItmMastID="") return
	
	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) return
	Set objItmMast=##class(DHCHAI.IR.CCItmMast).GetObjById(aItmMastID)
	Quit:'$IsObject(objItmMast) return
	
	Set obj=##Class(DHCHAI.IRC.CtrlRecord).%New()
	Set obj.CCEpisodeDr = objEpisode
	Set obj.CCItemDr    = objItmMast
	If obj'="" Do obj.%Close()
	Quit obj
}

Storage Default
{
<Data name="CtrlRecordState">
<Value name="1">
<Value>CCEpisodeDr</Value>
</Value>
<Value name="2">
<Value>CCItemDr</Value>
</Value>
<Value name="3">
<Value>CCResult</Value>
</Value>
<Value name="4">
<Value>CCTextRes</Value>
</Value>
<Value name="5">
<Value>CCUnit</Value>
</Value>
<Value name="6">
<Value>CCActLocDr</Value>
</Value>
<Value name="7">
<Value>CCActDate</Value>
</Value>
<Value name="8">
<Value>CCActTime</Value>
</Value>
<Value name="9">
<Value>CCActUser</Value>
</Value>
<Value name="10">
<Value>CCRepDate</Value>
</Value>
<Value name="11">
<Value>CCRepTime</Value>
</Value>
<Value name="12">
<Value>CCRepUser</Value>
</Value>
<Value name="13">
<Value>CCSCode</Value>
</Value>
<Value name="14">
<Value>CCObjectID</Value>
</Value>
<Value name="15">
<Value>CCParams</Value>
</Value>
<Value name="16">
<Value>CCContDays</Value>
</Value>
<Value name="17">
<Value>CCSpecimen</Value>
</Value>
<Value name="18">
<Value>CCBacteria</Value>
</Value>
<Value name="19">
<Value>CCKeyWord</Value>
</Value>
<Value name="20">
<Value>CCIsAbFlag</Value>
</Value>
<Value name="21">
<Value>CCMRBTpDr</Value>
</Value>
<Value name="22">
<Value>CCAntiGrade</Value>
</Value>
<Value name="23">
<Value>CCOperDate</Value>
</Value>
<Value name="24">
<Value>CCIncision</Value>
</Value>
<Value name="25">
<Value>CCAntiDesc</Value>
</Value>
<Value name="26">
<Value>CCIsNotEnd</Value>
</Value>
<Value name="27">
<Value>CCSummary</Value>
</Value>
<Value name="28">
<Value>CCMRBTp2Dr</Value>
</Value>
<Value name="29">
<Value>MultipleResChild</Value>
</Value>
</Data>
<State>CtrlRecordState</State>
<StreamLocation>^DHCHAI.IRC.CtrlRecordS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
