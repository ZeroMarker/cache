/// 名称: 药品业务表 3用药方法维护 
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2014-12-3
Class web.Entity.KB.DHCPHDiseaseUse Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHDiseaseUse";

Property PDIRowId As %String;

Property PDIInstDr As %String;

Property PDIUseDR As %String;

Property PDIExcludeFlag As %String;

/// PDI_AlertMsg  2016/10/13
Property PDIAlertMsg As %String;

}
