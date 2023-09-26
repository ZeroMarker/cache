/// 名称: 药品业务表 5用量用法
/// 编写者:基础数据平台组-高姗姗
/// 编写日期: 2014-12-4
Class web.Entity.KB.DHCPHUsageDosage Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.KB.DHCPHUsageDosage";

Property PHUSDORowId As %String;

Property PHUSDOInstDr As %String;

Property PHUSDOOneDayTimeMin As %String;

Property PHUSDOOneDayTimeMax As %String;

Property PHUSDOOnceQtyMin As %String;

Property PHUSDOOnceQtyMax As %String;

Property PHUSDOOnceQtyUomDr As %String;

Property PHUSDOOneDayQtyMin As %String;

Property PHUSDOOneDayQtyMax As %String;

Property PHUSDOOneDayQtyUomDr As %String;

Property PHUSDOOnceMaxQty As %String;

Property PHUSDOOnceMaxQtyUomDr As %String;

Property PHUSDOOneDayMaxQty As %String;

Property PHUSDOOneDayMaxQtyUomDr As %String;

Property PHUSDOFristTimeQtyMin As %String;

Property PHUSDOFristTimeQtyMax As %String;

Property PHUSDOFristTimeQtyUomDr As %String;

Property PHUSDODurationQtyMin As %String;

Property PHUSDODurationQtyMax As %String;

Property PHUSDODurationQtyUomDr As %String;

Property PHUSDOSpaceQtyMin As %String;

Property PHUSDOSpaceQtyMax As %String;

Property PHUSDOSpaceQtyUomDr As %String;

Property PHUSDOWeightMin As %String;

Property PHUSDOWeightMax As %String;

Property PHUSDOBodyAreaMin As %String;

Property PHUSDOBodyAreaMax As %String;

Property PHUSDODurationDayMin As %String;

Property PHUSDODurationDayMax As %String;

Property PHUSDOWeightKg As %String;

Property PHINSTMode As %String;

Property PHDISLDisea As %String;

Property PHEINInstruc As %String;

Property PDAAge As %String;

Property PDAMinVal As %String;

Property PDAMaxVal As %String;

Property PDAUomDr As %String;

Property PHINSTSex As %String;

Property PHINSTDocUseTips As %String;

Property PHINSTNurseUseTips As %String;

Property PHINSTTypeDr As %String;

Property PHINSTOrderNum As %String;

Property PHINSTGenDr As %String;

Property PHINSTPointerDr As %String;

Property PHINSTPointerType As %String;

Property PHINSTLibDr As %String;

Property PHINSTActiveFlag As %String;

Property PHINSTSysFlag As %String;

Property SpecialPopu As %String;

Property LABILabDr As %String;

Property LABIMinVal As %String;

Property LABIMaxVal As %String;

Property LABIUomDr As %String;

Property LABIRelation As %String;

Property PHINSTText As %String;

// 病症描述（可以多个）2018-11-06

Property PHDDDiseaDrs As %String;

// 特殊人群描述（可以多个）2018-11-06

Property SPEPISpecDrs As %String;

// 疗程

Property PHUSDOPeriod As %String;

}
