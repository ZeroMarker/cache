/// 名称:检验结果辅助诊断
/// 描述: 实体类
/// 编写者：基础数据平台组-高姗姗
/// 编写日期: 2017-3-23
Class web.Entity.KB.DHCPHLibResultDiag Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHLibResultDiag";

Property PLRDRowId As %String;

Property PLRDInstDr As %String;

Property PLRDNormal As %String;

Property PLRDHigh As %String;

Property PLRDLow As %String;

Property PLRDNegative As %String;

Property PLRDPositive As %String;

Property PLRDOther As %String;

Property PHINSTText As %String;

//主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

}
