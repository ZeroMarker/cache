/// 导出配置表字段维护实体类
/// Creaor：谷雪萍
Class web.Entity.BDP.BDPEXFieldConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPEXFieldConfig";

Property ParRef As %String;

/// 表字段rowId
Property FieldRowId As %String;

/// 字段中文描述
Property EXFCFieldDesc As %String;

/// 表字段名称
Property EXFCFieldName As %String;

/// 字段类型
Property EXFCFieldType As %String;

/// 通过ID找Code 只有DR类型的使用
Property EXFCIDToCode As %String;

/// 如何取字段（Global）
Property EXFCGetField As %String;

/// 通过ID找Code字段名 只有DR类型的使用
Property EXFCIDToCodeName As %String;

/// 是否导出 2022-1-21 add
Property EXFCExport As %String;

/// 顺序字段 2022-1-21add
Property EXFCOrder As %Float;

}
