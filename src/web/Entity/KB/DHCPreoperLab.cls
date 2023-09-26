/// 名称:手术项目编辑器 -术前检验 
/// 描述: 实体类
/// 编写者：基础数据平台组-丁亚男
/// 编写日期: 2019-11-21
Class web.Entity.KB.DHCPreoperLab Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPreoperLab";

Property PHDDInstDr As %String;

// 说明

Property PHINSTText As %String;

// 主索引表必填项

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTLibDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

// 作用模式

Property PHINSTMode As %String;

// 术前检验

Property LABILabDr As %String;

// 是否为报告状态

Property LABIRepActiveFlag As %String;

// 术前检查/术前检验的code

Property OPERInstLabelCode As %String;

// 年龄

Property PDAAgeDr As %String;

// 年龄最大值

Property PDAMaxVal As %String;

// 年龄最小值

Property PDAMinVal As %String;

// 年龄单位

Property PDAUomDr As %String;

}
