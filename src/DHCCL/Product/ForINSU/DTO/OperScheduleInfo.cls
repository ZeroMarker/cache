/// 4401 住院病案首页信息
Class DHCCL.Product.ForINSU.DTO.OperScheduleInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "OperScheduleInfo";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1	oprn_oprt_date	手术操作日期
Property operDate As %String;

/// 2	oprn_oprt_name	手术操作名称
Property operDesc As %String;

/// 3	oprn_oprt_code	手术操作代码
Property operCode As %String;

/// 4	oprn_oprt_sn	手术操作序列号
Property operSeqNo As %String;

/// 5	oprn_lv_code	手术级别代码
Property operClassCode As %String;

/// 6	oprn_lv_name	手术级别名称
Property operClassDesc As %String;

/// 7	oper_name	手术者姓名
Property surgeonDesc As %String;

/// 8	asit1_name	助手Ⅰ姓名
Property firstAssistDesc As %String;

/// 9	asit2_name	助手Ⅱ姓名
Property secondAssistDesc As %String;

/// 10	sinc_heal_lv	手术切口愈合等级
Property healLevelDesc As %String;

/// 11	sinc_heal_lv_code	手术切口愈合等级代码
Property healLevelCode As %String;

/// 12	anst_mtd_name	麻醉-方法名称
Property anaMethodDesc As %String;

/// 13	anst_mtd_code	麻醉-方法代码
Property anaMethodCode As %String;

/// 14	anst_dr_name	麻醉医师姓名
Property anesthesiologistDesc As %String;

/// 15	oprn_oper_part	手术操作部位
Property bodySiteDesc As %String;

/// 16	oprn_oper_part_code	手术操作部位代码
Property bodySiteCode As %String;

/// 17	oprn_con_time	手术持续时间
Property operDuration As %String;

/// 18	anst_lv_name	麻醉分级名称
Property asaLvDesc As %String;

/// 19	anst_lv_code	麻醉分级代码
Property asaLvCode As %String;

/// 20	oprn_patn_type	手术患者类型  1非手术患者  2急诊手术   3择期手术
Property patTypeDesc As %String;

/// 21	oprn_patn_type_code	手术患者类型代码
Property patTypeCode As %String;

/// 22	main_oprn_flag	主要手术标志
Property mainOperFlag As %String;

/// 23	anst_asa_lv_code	麻醉ASA分级代码
Property asaClassCode As %String;

/// 24	anst_asa_lv_name	麻醉ASA分级名称
Property asaClassDesc As %String;

/// 25	anst_medn_code	麻醉药物代码
Property anMedicineCode As %String;

/// 26	anst_medn_name	麻醉药物名称
Property anMedicineDesc As %String;

/// 27	anst_medn_dos	麻醉药物剂量
Property anMedicineDose As %String;

/// 28	unt	计量单位
Property anMedicineUnit As %String;

/// 29	anst_begntime	麻醉开始时间
Property anaStartDT As %String;

/// 30	anst_endtime	麻醉结束时间
Property anaEndDT As %String;

/// 31	anst_copn_code	麻醉合并症代码
Property anComplicationCode As %String;

/// 32	anst_copn_name	麻醉合并症名称
Property anComplicationName As %String;

/// 33	anst_copn_dscr	麻醉合并症描述
Property anComplicationDesc As %String;

/// 34	pacu_begntime	复苏室开始时间
Property pacuInDT As %String;

/// 35	pacu_endtime	复苏室结束时间
Property pacuOutDT As %String;

/// 36	canc_oprn_flag	取消手术标志
Property operCancelFlag As %String;

/// 37	vali_flag	有效标志
Property validateFlag As %String;

/// 38	ipt_medcas_hmpg_sn	住院病案首页流水号
Property homePageNo As %String;

/// 39	mdtrt_sn	就医流水号
Property serialNo As %String;

/// 40	oprn_oprt_begntime	手术操作开始时间
Property operBeginTime As %String;

/// 41	oprn_oprt_endtime	手术操作结束时间
Property operEndTime As %String;

}
