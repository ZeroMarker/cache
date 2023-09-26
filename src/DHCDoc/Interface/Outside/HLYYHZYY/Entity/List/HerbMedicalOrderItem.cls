/// 饮片医嘱明细
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.HerbMedicalOrderItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 医嘱id
Property orderid As %String(TRUNCATE = 1, XMLNAME = "order_id");

/// 医嘱明细id
Property orderitemid As %String(TRUNCATE = 1, XMLNAME = "order_item_id");

/// 组号
Property groupno As %String(TRUNCATE = 1, XMLNAME = "group_no");

/// 药品ID
Property drugid As %String(TRUNCATE = 1, XMLNAME = "drug_id");

/// 药品名称
Property drugname As %String(TRUNCATE = 1, XMLNAME = "drug_name");

/// 规格
Property specification As %String(TRUNCATE = 1, XMLNAME = "specification");

/// 生产厂家名称
Property manufacturername As %String(TRUNCATE = 1, XMLNAME = "manufacturer_name");

/// 每次给药剂量
Property drugdose As %String(TRUNCATE = 1, XMLNAME = "drug_dose");

/// 给药途径
Property drugadminroutename As %String(TRUNCATE = 1, XMLNAME = "drug_admin_route_name");

/// 给药频率
Property drugusingfreq As %String(TRUNCATE = 1, XMLNAME = "drug_using_freq");

/// 发药数量
Property despensingnum As %String(TRUNCATE = 1, XMLNAME = "despensing_num");

/// 发药数量单位
Property packunit As %String(TRUNCATE = 1, XMLNAME = "pack_unit");

/// 包装规格数量
Property countunit As %String(TRUNCATE = 1, XMLNAME = "count_unit");

/// 单价
Property unitprice As %String(TRUNCATE = 1, XMLNAME = "unit_price");

/// 总价,计量单位为元
Property feetotal As %String(TRUNCATE = 1, XMLNAME = "fee_total");

/// 剂型
Property preparation As %String(TRUNCATE = 1, XMLNAME = "preparation");

/// 特殊要求
Property specialprompt As %String(TRUNCATE = 1, XMLNAME = "special_prompt");

/// 结算方式 (1:甲类,2:乙类,3:丙类)
Property medicaretype As %String(TRUNCATE = 1, XMLNAME = "medicare_type");

}
