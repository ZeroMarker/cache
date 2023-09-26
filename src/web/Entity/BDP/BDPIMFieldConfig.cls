/// 表字段维护实体类
/// Creaor：谷雪萍
Class web.Entity.BDP.BDPIMFieldConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.BDPIMFieldConfig";

Property ParRef As %String;

/// 表字段rowId
Property FieldRowId As %String;

/// 字段中文描述
Property IMFCFieldDesc As %String;

/// 表字段名称
Property IMFCFieldName As %String;

/// 字段类型
Property IMFCFieldType As %String;

/// 通过Code找ID 只有DR类型的使用
Property IMFCCodeToID As %String;

/// 关联表 2016/9/28新加字段
Property IMFCConTable As %String;

/// 继承标识 2016/10/14新加字段
Property IMFCInheritFlag As %String;

/// 是否唯一 2016/11/21新加字段
Property IMFCUnique As %String;

/// 是否必填项 2016/11/21新加字段
Property IMFCRequired As %String;

/// 是否导入 2016/11/21新加字段
Property IMFCImport As %String;

/// 顺序字段 2017/3/23新加字段
Property IMFCOrder As %String;

/// 导出--通过ID找代码或者描述 只有DR类型的使用  2021-02-19
Property EXFCIDToCode As %String;

/// 导出--如何取字段（Global）
Property EXFCGetField As %String;

/// 是否导出
Property IMFCExport As %String;

/// 导出-字段类型
Property EXFCFieldType As %String;

}
