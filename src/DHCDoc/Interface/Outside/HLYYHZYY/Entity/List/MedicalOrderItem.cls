/// 药物医嘱明细
Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.List.MedicalOrderItem Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 医嘱id
Property orderid As %String(TRUNCATE = 1, XMLNAME = "order_id");

/// 医嘱时间 yyyy-mm-dd hh24:mi:ss
Property ordertime As %String(TRUNCATE = 1, XMLNAME = "order_time");

/// 医嘱科室id
Property orderdeptid As %String(TRUNCATE = 1, XMLNAME = "order_dept_id");

/// 医嘱科室名称
Property orderdeptname As %String(TRUNCATE = 1, XMLNAME = "order_dept_name");

/// 医嘱医疗组名称
Property docgroup As %String(TRUNCATE = 1, XMLNAME = "doc_group");

/// 医嘱医生工号
Property orderdocid As %String(TRUNCATE = 1, XMLNAME = "order_doc_id");

/// 医嘱医生姓名
Property orderdocname As %String(TRUNCATE = 1, XMLNAME = "order_doc_name");

/// 医嘱医生职称  (见标版CT_CarPrvTp表Code)
Property orderdoctitle As %String(TRUNCATE = 1, XMLNAME = "order_doc_title");

/// 医嘱类型 (1:长期医嘱,2:临时医嘱,3:出院带药,9:其他)
Property ordertype As %String(TRUNCATE = 1, XMLNAME = "order_type");

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

/// 医嘱生效时间 yyyy-mm-dd hh24:mi:ss
Property ordervalidtime As %String(TRUNCATE = 1, XMLNAME = "order_valid_time");

/// 医嘱失效时间 yyyy-mm-dd hh24:mi:ss
Property orderinvalidtime As %String(TRUNCATE = 1, XMLNAME = "order_invalid_time");

/// 给药时机
Property drugusingtimepoint As %String(TRUNCATE = 1, XMLNAME = "drug_using_time_point");

/// 给药目的
Property drugusingaim As %String(TRUNCATE = 1, XMLNAME = "drug_using_aim");

/// 给药部位
Property drugusingarea As %String(TRUNCATE = 1, XMLNAME = "drug_using_area");

/// 复核时间
Property checktime As %String(TRUNCATE = 1, XMLNAME = "check_time");

/// 复核护士工号
Property checknurseid As %String(TRUNCATE = 1, XMLNAME = "check_nurse_id");

/// 复核护士姓名
Property checknursename As %String(TRUNCATE = 1, XMLNAME = "check_nurse_name");

/// 疗程
Property duration As %String(TRUNCATE = 1, XMLNAME = "duration");

/// 剂型
Property preparation As %String(TRUNCATE = 1, XMLNAME = "preparation");

/// 医嘱停止标志 (1:是,0:否	只能填入"1|0")
Property stopflag As %String(TRUNCATE = 1, XMLNAME = "stop_flag");

/// 是否退药标志 (1:是,0:否	只能填入"1|0")
Property drugreturnflag As %String(TRUNCATE = 1, XMLNAME = "drug_return_flag");

/// 紧急标志 (1:是,0:否	只能填入"1|0")
Property urgentflag As %String(TRUNCATE = 1, XMLNAME = "urgent_flag");

/// 住院静配标志 (1:是,0:否	只能填入"1|0")
Property pivasflag As %String(TRUNCATE = 1, XMLNAME = "pivas_flag");

/// 皮试标志 (1:皮试,0:非皮试 只能填入"1|0")
Property skintestflag As %String(TRUNCATE = 1, XMLNAME = "skin_test_flag");

/// 皮试结果
Property skintestresult As %String(TRUNCATE = 1, XMLNAME = "skin_test_result");

/// 特殊返回标志,常用于补药医嘱 (1:是,0:否	只能填入"1|0")
Property specialreturnflag As %String(TRUNCATE = 1, XMLNAME = "special_return_flag");

/// 特殊要求
Property specialprompt As %String(TRUNCATE = 1, XMLNAME = "special_prompt");

/// 给药速度,需同时传入数字和单位,单位为小时或滴/分钟
Property infusionspeed As %String(TRUNCATE = 1, XMLNAME = "infusion_speed");

/// 结算方式 (1:甲类,2:乙类,3:丙类)
Property medicaretype As %String(TRUNCATE = 1, XMLNAME = "medicare_type");

/// 是否草药方 (1:是,0:否	只能填入"1|0")
Property isherb As %String(TRUNCATE = 1, XMLNAME = "is_herb");

}
