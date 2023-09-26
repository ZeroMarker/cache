/// 名称: 医嘱项实体类 
/// 编写者：基础数据平台组-陈莹
/// 编写日期: 2013-9-2
Class web.Entity.CT.ARCItmMast Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.ARCItmMast";

/// RowId号
Property ARCIMRowId As %String;

/// 代码
Property ARCIMCode As %String;

/// 描述
Property ARCIMDesc As %String;

/// 药物
Property ARCIMPHCDFDR As %String;

/// 医嘱缩写
Property ARCIMAbbrev As %String;

/// 账单子组
Property ARCIMBillSubDR As %String;

/// 起始日期  
Property ARCIMEffDate As %Date;

/// 有效时间
Property ARCIMEffTime As %Time;

/// 单位 ---暂时没用
/// Property ARCIMUOMDR As %String;
/// 医嘱子分类
Property ARCIMItemCatDR As %String;

///  结束日期
Property ARCIMEffDateTo As %Date;

/// Current Version Flag
Property ARCIMCurVerFlg As %String;

/// 默认优先级
Property ARCIMDefPriorityDR As %String;

/// 计帐单位
Property ARCIMBillingUOMDR As %String;

/// 独立医嘱
Property ARCIMOrderOnItsOwn As %String;

/// 无库存医嘱
Property ARCIMAllowOrderWOStockCheck As %String;

/// 服务资源组
Property ARCIMServiceGroupDR As %String;

/// 服务/材料
Property ARCIMServMaterial As %String;

/// 加急医嘱
Property ARCIMSensitive As %String;

/// Charge Posting Flag
Property ARCIMChgPostFlg As %String;

/// 修改人  
Property ARCIMUpdateUser As %String;

/// 修改日期  
Property ARCIMUpdateDate As %String;

/// 修改时间    
Property ARCIMUpdateTime As %String;

/// 收费规定
Property ARCIMDerFeeRulesDR As %String;

///  ARCIMText1
Property ARCIMText1 As %String;

/// ARCIMText2  
Property ARCIMText2 As %String;

/// ARCIMText3  
Property ARCIMText3 As %String;

/// ARCIMText4    
Property ARCIMText4 As %String;

/// ARCIMText5
Property ARCIMText5 As %String;

Property ARCIMSensitiveOrder As %String;

Property ARCIMOEMessage As %String;

Property ARCIMChgOrderPerHour As %String;

Property ARCIMDeceasedPatientsOnly As %String;

Property ARCIMDisplayCumulative As %String;

Property ARCIMUseODBCforWord As %String;

Property ARCIMRestrictEM As %String;

Property ARCIMRestrictIP As %String;

Property ARCIMRestrictOP As %String;

Property ARCIMRestrictHP As %String;

Property ARCIMPatientOrderFile1 As %String;

Property ARCIMPatientOrderFile2 As %String;

Property ARCIMPatientOrderFile3 As %String;

/// 单次最大剂量 20170829
Property ARCIMMaxCumDose As %String;

/// 每天最大剂量 20170829
Property ARCIMMaxQtyPerDay As %String;

/// 最大量 20170829
Property ARCIMMaxQty As %String;

/// 限制使用天数 20190122
Property ARCIMNoOfCumDays As %String;

/// 默认加急 20190530
Property ARCIMDefSensitive As %String;

/// 允许录入频次 20201124
Property ARCIMAllowInputFreq As %String;

/// 是否扫码计费 20221220
Property ARCIMScanCodeBilling As %String;

}
