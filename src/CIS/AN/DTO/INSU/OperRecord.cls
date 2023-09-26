/// 4701  电子病历上传  手术记录
Class CIS.AN.DTO.INSU.OperRecord Extends (CIS.AN.DTO.Abstract.Model, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLTYPE = "Model";

Parameter XMLNAME = "OperRecord";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1	oprn_appy_id	手术申请单号
Property applyId As %String;

/// 2	oprn_seq	手术序列号
Property operSeqNo As %String;

/// 3	blotype_abo	ABO血型代码
Property bloodType As %String;

/// 4	oprn_time	手术日期
Property operDate As %String;

/// 5	oprn_type_code	手术分类代码
Property operTypeCode As %String;

/// 6	oprn_type_name	手术分类名称
Property operTypeDesc As %String;

/// 7	bfpn_diag_code	术前诊断代码
Property preDiagCode As %String;

/// 8	bfpn_oprn_diag_name	术前诊断名称
Property preDiagDesc As %String;

/// 9	bfpn_inhosp_ifet	术前是否发生院内感染
Property infect As %String;

/// 10	afpn_diag_code	术后诊断代码
Property diagCode As %String;

/// 11	afpn_diag_name	术后诊断名称
Property diagDesc As %String;

/// 12	sinc_heal_lv_code	手术切口愈合等级代码
Property healLevelCode As %String;

/// 13	sinc_heal_lv	手术切口愈合等级
Property healLevelDesc As %String;

/// 14	back_oprn	是否重返手术（明确定义）
Property reentryOperation As %String;

/// 15	selv	是否择期
Property selv As %String;

/// 16	prev_abtl_medn	是否预防使用抗菌药物
Property isUseAntibiotics As %String;

/// 17	abtl_medn_days	预防使用抗菌药物天数
Property useAntibioticsDays As %String;

/// 18	oprn_oprt_code	手术操作代码
Property operCode As %String;

/// 19	oprn_oprt_name	手术操作名称
Property operDesc As %String;

/// 20	oprn_lv_code	手术级别代码
Property operClassCode As %String;

/// 21	oprn_lv_name	手术级别名称
Property operClassDesc As %String;

/// 22	anst_mtd_code	麻醉-方法代码
Property anaMethodCode As %String;

/// 23	anst_mtd_name	麻醉-方法名称
Property anaMethodDesc As %String;

/// 24	anst_lv_code	麻醉分级代码
Property ASACode As %String;

/// 25	anst_lv_name	麻醉分级名称
Property ASADesc As %String;

/// 26	exe_anst_dept_code	麻醉执行科室代码
Property anDeptCode As %String;

/// 27	exe_anst_dept_name	麻醉执行科室名称
Property anDeptDesc As %String;

/// 28	anst_efft	麻醉效果
Property anestEffect As %String;

/// 29	oprn_begntime	手术开始时间
Property operStartDT As %String;

/// 30	oprn_endtime	手术结束时间
Property operEndDT As %String;

/// 31	oprn_asps	是否无菌手术
Property isAsepsis As %String;

/// 32	oprn_asps_ifet	无菌手术是否感染
Property isAsepsisInfect As %String;

/// 33	afpn_info	手术后情况
Property postOperInfo As %String;

/// 34	oprn_merg	是否手术合并症
Property ifHasComplication As %String;

/// 35	oprn_conc	是否手术并发症
Property ifHasSyndrome As %String;

/// 36	oprn_anst_dept_code	手术执行科室代码
Property operDeptCode As %String;

/// 37	oprn_anst_dept_name	手术执行科室名称
Property operDeptDesc As %String;

/// 38	palg_dise	病理检查
Property pathology As %String;

/// 39	oth_med_dspo	其他医学处置
Property otherMedicalDisposal As %String;

/// 40	out_std_oprn_time	是否超出标准手术时间
Property outStandOperTime As %String;

/// 41	oprn_oper_name	手术者姓名
Property surgeonDesc As %String;

/// 42	oprn_asit_name1	助手I姓名
Property firstAsstDesc As %String;

/// 43	oprn_asit_name2	助手Ⅱ姓名
Property secondAsstDesc As %String;

/// 44	anst_dr_name	麻醉医师姓名
Property anesthesiologistDesc As %String;

/// 45	anst_asa_lv_code	麻醉ASA分级代码
Property ASAClassCode As %String;

/// 46	anst_asa_lv_name	麻醉ASA分级名称
Property ASAClassDesc As %String;

/// 47	anst_medn_code	麻醉药物代码
Property anaDrugCode As %String;

/// 48	anst_medn_name	麻醉药物名称
Property anaDrugDesc As %String;

/// 49	anst_medn_dos	麻醉药物剂量
Property anaDrugDose As %String;

/// 50	anst_dosunt	计量单位
Property anaDrugUnit As %String;

/// 51	anst_begntime	麻醉开始时间
Property theatreInDT As %String;

/// 52	anst_endtime	麻醉结束时间
Property theatreOutDT As %String;

/// 53	anst_merg_symp_code	麻醉合并症代码
Property complicationCode As %String;

/// 54	anst_merg_symp	麻醉合并症名称
Property complicationName As %String;

/// 55	anst_merg_symp_dscr	麻醉合并症描述
Property complicationDesc As %String;

/// 56	pacu_begntime	入复苏室时间
Property pacuInDT As %String;

/// 57	pacu_endtime	出复苏室时间
Property pacuOutDT As %String;

/// 58	oprn_selv	是否择期手术
Property operSelv As %String;

/// 59	canc_oprn	是否择取消手术
Property isCanceledOper As %String;

/// 60	vali_flag	有效标志
Property validateFlag As %String;

}
