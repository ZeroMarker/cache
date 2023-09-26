/// 处方明细信息
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.OptPrescriptionItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 处方明细编号
Property recipeitemid As %String(TRUNCATE = 1, XMLNAME = "recipe_item_id");

/// 处方id
Property recipeid As %String(TRUNCATE = 1, XMLNAME = "recipe_id");

/// 组号
Property groupno As %String(TRUNCATE = 1, XMLNAME = "group_no");

/// 药品ID
Property drugid As %String(TRUNCATE = 1, XMLNAME = "drug_id");

/// 药品名称
Property drugname As %String(TRUNCATE = 1, XMLNAME = "drug_name");

/// 规格
Property specification As %String(TRUNCATE = 1, XMLNAME = "specification");

/// 厂家名称
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

/// 给药时机
Property drugusingtimepoint As %String(TRUNCATE = 1, XMLNAME = "drug_using_time_point");

/// 给药目的
Property drugusingaim As %String(TRUNCATE = 1, XMLNAME = "drug_using_aim");

/// 给药部位
Property drugusingarea As %String(TRUNCATE = 1, XMLNAME = "drug_using_area");

/// 疗程
Property duration As %String(TRUNCATE = 1, XMLNAME = "duration");

/// 剂型
Property preparation As %String(TRUNCATE = 1, XMLNAME = "preparation");

/// 特殊要求
Property specialprompt As %String(TRUNCATE = 1, XMLNAME = "special_prompt");

/// 皮试标志 (1:皮试,0:非皮试	只能填入"1|0")
Property skintestflag As %String(TRUNCATE = 1, XMLNAME = "skin_test_flag");

/// 皮试结果
Property skintestresult As %String(TRUNCATE = 1, XMLNAME = "skin_test_result");

/// 是否退药标志 (1:是,0:否	只能填入"1|0")
Property drugreturnflag As %String(TRUNCATE = 1, XMLNAME = "drug_return_flag");

/// 门诊静配标志 (1:是,0:否	只能填入"1|0")
Property ouvasflag As %String(TRUNCATE = 1, XMLNAME = "ouvas_flag");

/// 紧急标志 (1:是,0:否	只能填入"1|0")
Property urgentflag As %String(TRUNCATE = 1, XMLNAME = "urgent_flag");

/// 给药速度,需同时传入数字和单位,单位为小时或滴/分钟
Property infusionspeed As %String(TRUNCATE = 1, XMLNAME = "infusion_speed");

/// 结算方式
Property medicaretype As %String(TRUNCATE = 1, XMLNAME = "medicare_type");

/// 药品窗口
Property dispensingwindow As %String(TRUNCATE = 1, XMLNAME = "dispensing_window");

/// 商品货架号
Property drugstorearea As %String(TRUNCATE = 1, XMLNAME = "drug_store_area");

/// 开始使用时间
Property starttime As %String(TRUNCATE = 1, XMLNAME = "start_time");

/// 停止使用时间
Property endtime As %String(TRUNCATE = 1, XMLNAME = "end_time");

}
