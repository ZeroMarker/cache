/// 国家医保编码取值配置表Entity
/// 基础数据平台-李可凡
/// 2021-11-08
/// sqldbx select: CF_BDP_BD.INSUConfig
Class web.Entity.BDP.INSUConfig Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.Entity.BDP.INSUConfig";

/// RowId
Property ID As %String;

/// 医院
Property HospitalDR As %String;

/// 取值配置表
Property ConfigTable As %String;

/// 取值配置
Property ConfigValue As %String;

}
