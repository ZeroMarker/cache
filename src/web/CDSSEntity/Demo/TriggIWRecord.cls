/// Creator:杨继鸿
/// CreatDate:2022-03-21
/// Description：CDSS演示评测系统-识别词触发测评记录表
/// Table： WDT.CDSS.TriggIWRecord
Class web.CDSSEntity.Demo.TriggIWRecord Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Property RowId As %String;

/// 识别词触发任务集详情表DR
Property TasksDetailDR As %String;

/// 识别词id
Property IdentifyWordsDR As %String;

/// 识别词名称
Property WordsDesc As %String;

/// 识别词类型
Property WordsType As %String;

/// 触发识别词的患者信息表
Property PTableNameStr As %String(MAXLEN = "");

/// 触发识别词的患者信息表字段
Property PFiledNameStr As %String(MAXLEN = "");

/// 触发识别词的患者信息表项目名称字段值
Property PFiledValueStr As %String(MAXLEN = "");

/// 问题分类
Property ProblemType As %String;

/// 问题描述
Property ProblemDesc As %String;

/// 操作人员
Property OperatorUser As %String;

/// 操作时间
Property OperationTime As %String;

Parameter PersistentClassName = "web.CDSSEntity.Demo.TriggIWRecord";

}
