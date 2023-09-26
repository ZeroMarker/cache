/// Creator: 杨继鸿
/// CreatDate:2022-03-22
/// Description：CDSS演示评测系统-识别词触发任务集NLP识别表
/// Table： WDT.CDSS.TriggNLPIdentify
Class web.CDSSEntity.Demo.TriggNLPIdentify Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TriggNLPIdentify";

Property RowId As %String;

/// 识别词触发任务集详情表DR
Property TasksDetailDR As %String;

/// 数据类型：入院记录，出院记录，检查报告（暂时做这几类） 
Property DocumentType As %String;

/// 识别内容表的ID
Property DemoDataDR As %String;

/// 识别信息
Property IdentifyInfo As %String;

/// NLP识别结果
Property NLPRecognition As %String(MAXLEN = "");

/// 识别来源:主诉/现病史
Property NLPSource As %String;

/// 问题类型：识别错误/未识别
Property ProblemType As %String;

/// 标记内容
Property TagContent As %String;

/// 操作人员
Property OperatorUser As %String;

/// 操作时间
Property OperationTime As %String;

/// 是否导出 0-否 1-是
Property IsOutput As %String;

/// 是否解决 0-否 1-是
Property IsSolve As %String;

}
