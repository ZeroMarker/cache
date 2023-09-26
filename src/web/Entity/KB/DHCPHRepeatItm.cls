/// 名称: 重复用药
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2017-3-15
Class web.Entity.KB.DHCPHRepeatItm Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHRepeatItm";

Property PHRIRowId As %String;

Property PHRIInstDr As %String;

Property PHRIProDr As %String;

Property PHRIRuleDr As %String;

Property PHRIManage As %String;

Property PHINSTMode As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

// 描述

Property PHINSTText As %String;

// 商品名描述

Property PHDALDrgDrs As %String;

}
