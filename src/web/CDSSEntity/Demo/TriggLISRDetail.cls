Class web.CDSSEntity.Demo.TriggLISRDetail Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ SqlRowIdName = "", SqlTableName = "" ]
{

Parameter PersistentClassName = "web.CDSSEntity.Demo.TriggLISRDetail";

Property RowId As %String;

/// 指向患者
Property PatDR As %String;

/// 检验医嘱
Property LabItem As %String;

/// 检验项目
Property LabItemDetail As %String;

/// 检验结果
Property LabResult As %String(MAXLEN = "");

/// 单位
Property Unit As %String;

/// 参考范围
Property RefRange As %String;

/// 异常结果显示
Property AbnormalResult As %String;

/// 病历原文
Property OriginalContent As %String(MAXLEN = "");

}
