/// OE Order Item Extension For DHCC ,Created By zhouzq 2012.02.21
Class User.OEOrdItemExt Extends %Persistent [ SqlRowIdName = OEORI_RowId, SqlTableName = OE_OrdItemExt, StorageStrategy = SQLStorage ]
{

Relationship ChildOEOrdExec As OEOrdExecExt [ Cardinality = children, Inverse = OEOREOEORIParRef ];

Index RowIDBasedIDKeyIndex On (OEORIOEORDParRef, OEORIChildsub) [ IdKey, PrimaryKey, Unique ];

/// Des Ref to OEORD
Property OEORIOEORDParRef As OEOrder [ Required, SqlFieldName = OEORI_OEORD_ParRef ];

/// OEORI Child Sub (New Key)
Property OEORIChildsub As %Numeric(SCALE = 0) [ SqlColumnNumber = 2, SqlFieldName = OEORI_Childsub ];

/// 按前台选择日期产生执行记录的日期串
Property OEORIExecuteDateStr As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OEORI_ExecuteDateStr ];

/// 资源排班记录指针
Property OEORIRBASDR As RBApptSchedule [ SqlColumnNumber = 4, SqlFieldName = OEORI_RBAS_DR ];

/// 医保类别指针医保适应症代码(医保组)
Property OEORIInsurCatDR As %String [ SqlColumnNumber = 5, SqlFieldName = OEORI_InsurCat_DR ];

/// 停止输液标志
Property OEORIStopDripFlag As %Boolean [ SqlColumnNumber = 6, SqlFieldName = OEORI_StopDripFlag ];

/// 停止输液日期
Property OEORIStopDripDate As %Date [ SqlColumnNumber = 7, SqlFieldName = OEORI_StopDripDate ];

/// 停止输液时间
Property OEORIStopDripTime As %Time [ SqlColumnNumber = 8, SqlFieldName = OEORI_StopDripTime ];

/// 停止输液时间
Property OEORIStopDripUserDR As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = OEORI_StopDripUser_DR ];

/// 医嘱阶段
Property OEORIStage As %String(DISPLAYLIST = ",术前,术中,术后,产中", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",SQ,SZ,SH,CZ") [ SqlColumnNumber = 10, SqlFieldName = OEORI_Stage ];

/// 嘱托备注
Property OEORIOMProcNote As %String [ SqlColumnNumber = 11, SqlFieldName = OEORI_OMProcNote ];

/// 科研药理项目的指针
Property OEORIPEProjectDR As %String [ SqlColumnNumber = 12, SqlFieldName = OEORI_PEProject_DR ];

/// 营养药标志
Property OEORINutritionDrugFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = OEORI_NutritionDrugFlag ];

/// 星期频次的分发点
Property OEORIDispWeekTime As %String [ SqlColumnNumber = 13, SqlFieldName = OEORI_DispWeekTime ];

/// 协议包装单位                       
Property OEORIPackUOM As User.CTUOM [ SqlColumnNumber = 15, SqlFieldName = OEORI_PackUOM_DR ];

/// 高值材料条码
Property OEORIMaterialNo As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = OEORI_MaterialNo ];

/// 医疗单元
Property OEORIMedUnitDR As User.DHCCTLocMedUnit [ SqlColumnNumber = 17, SqlFieldName = OEORI_MedUnit_DR ];

/// 需要配液标志
Property OEORINeedPIVAFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = OEORI_NeedPIVAFlag ];

/// 留观状态标识
Property OEORIEMStayFlag As %Boolean [ SqlColumnNumber = 19, SqlFieldName = OEORI_EMStayFlag ];

/// 医嘱是”治疗/预防”  1:治疗  2:预防
Property OEORITarget As %String [ SqlColumnNumber = 20, SqlFieldName = OEORI_Target ];

/// 记账审核标识
Property OEORIPayorAduitFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = OEORI_PayorAduitFlag ];

/// 预生成的处方指针 ？
Property OEORIPrePrescDR As %String [ SqlColumnNumber = 22, SqlFieldName = OEORI_PrePresc_DR ];

/// 本院输液次数
Property OEORILocalInfusionQty As %String [ SqlColumnNumber = 23, SqlFieldName = OEORI_LocalInfusionQty ];

/// 所绑定的检验医嘱的检验号串,如抽血费
Property OEORILabEpisodeNoStr As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = OEORI_LabEpisodeNoStr ];

/// 特殊的本地化标识  1_$C(1)_1;华西第一个值为生成取药医嘱的标识
Property OEORIOtherFlags As %String [ SqlColumnNumber = 25, SqlFieldName = OEORI_OtherFlags ];

/// 打印导诊单标识
Property OEORIPrintFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = OEORI_PrintFlag ];

/// 需另划价标识 Y:代表将不计费，将有科室补录实际费用    Add In 北京协和
Property OEORIPriceFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = OEORI_PriceFlag ];

/// 已另划价标识 Y:代表已经另划价                        Add In 北京协和
Property OEORIPriceInputFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 28, SqlFieldName = OEORI_PriceInputFlag ];

/// 关联医嘱  主要用于医保适应症
Property OEORIMRDIADR As User.MRDiagnos [ SqlColumnNumber = 29, SqlFieldName = OEORI_MRDIA_DR ];

/// 停医嘱原因关联
Property OEORIStopReasonDR As User.BLCReasonForRefund [ SqlColumnNumber = 30, SqlFieldName = OEORI_StopReason_DR ];

/// 周频次日期时间串
Property OEORIWeekFreqDatTimStr As %String [ SqlColumnNumber = 31, SqlFieldName = OEORI_WeekFreqDatTimStr ];

/// 检查已补录标识
/// Property OEORIExamAppendFlag As %String (DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N")[ SqlColumnNumber = 32, SqlFieldName = OEORI_ExamAppendFlag ];
/// 老系统价格   其他系统数据迁移时价格
Property OEORIOldPrice As %String [ SqlColumnNumber = 33, SqlFieldName = OEORI_OldPrice ];

/// 使用科室  下医嘱时指定检查科室去药房替病人领药
Property OEORIUseInLocDR As User.CTLoc [ SqlColumnNumber = 34, SqlFieldName = OEORI_UseInLoc_DR ];

/// 药品个人自带标识
Property OEORISelfOMFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 35, SqlFieldName = OEORI_SelfOMFlag ];

/// 门诊退费审核标志
Property OEORIRefundAuditFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = OEORI_RefundAuditStatus ];

/// 门诊退费审核用户
Property OEORIRefundAuditUserDR As User.SSUser [ SqlColumnNumber = 48, SqlFieldName = OEORI_RefundAuditUser_DR ];

/// 门诊退费审核日期
Property OEORIRefundAuditDate As %Date [ SqlColumnNumber = 49, SqlFieldName = OEORI_RefundAuditDate ];

/// 门诊退费审核时间
Property OEORIRefundAuditTime As %Time [ SqlColumnNumber = 50, SqlFieldName = OEORI_RefundAuditTime ];

/// 门诊退费审核原因 
Property OEORIRefundReason As User.DHCINVOPRefReason [ SqlColumnNumber = 51, SqlFieldName = OEORI_RefundReason ];

/// 门诊退费审核科室	
Property OEORIRefundAuditLocDR As User.CTLoc [ SqlColumnNumber = 52, SqlFieldName = OEORI_RefundAuditLoc_DR ];

/// 接收第三方报告状态
/// Property OEORILISReportDR As %String [ SqlColumnNumber = 53, SqlFieldName = OEORI_LISReport_DR ];
/// 门诊科室审核标志  此标志用来决定后续是否能计费
Property OEORIDoctorConfirmFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 54, SqlFieldName = OEORI_DoctorConfirmFlag ];

/// 门诊科室审核日期
Property OEORIDoctorConfirmDate As %Date [ SqlColumnNumber = 55, SqlFieldName = OEORI_DoctorConfirmDate ];

/// 门诊科室审核时间
Property OEORIDoctorConfirmTime As %Time [ SqlColumnNumber = 56, SqlFieldName = OEORI_DoctorConfirmTime ];

/// 门诊科室审核人
Property OEORIDoctorConfirmUserDR As User.SSUser [ SqlColumnNumber = 57, SqlFieldName = OEORI_DoctorConfirmUser_DR ];

/// 门诊记帐转自费标识
Property OEORIChargeToOwnFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 58, SqlFieldName = OEORI_ChargeToOwnFlag ];

/// 门诊记帐转自费操作员
Property OEORIChargeToOwnUserDR As User.SSUser [ SqlColumnNumber = 59, SqlFieldName = OEORI_ChargeToOwnUser_DR ];

/// 门诊记帐转自费日期
Property OEORIChargeToOwnDate As %Date [ SqlColumnNumber = 60, SqlFieldName = OEORI_ChargeToOwnDate ];

/// 门诊科室审核时间
Property OEORIChargeToOwnTime As %Time [ SqlColumnNumber = 61, SqlFieldName = OEORI_ChargeToOwnTime ];

/// 停止医嘱处理护士
Property OEORIDisconUserDR As User.SSUser [ SqlColumnNumber = 62, SqlFieldName = OEORI_DisconUser_DR ];

/// 停止医嘱处理日期
Property OEORIDisconDate As %Date [ SqlColumnNumber = 63, SqlFieldName = OEORI_DisconDate ];

/// 停止医嘱处理时间
Property OEORIDisconTime As %Time [ SqlColumnNumber = 64, SqlFieldName = OEORI_DisconTime ];

/// 医嘱处理护士
Property OEORISeeUserDR As User.SSUser [ SqlColumnNumber = 65, SqlFieldName = OEORI_SeeUser_DR ];

/// 医嘱处理日期
Property OEORISeeDate As %Date [ SqlColumnNumber = 66, SqlFieldName = OEORI_SeeDate ];

/// 医嘱处理时间
Property OEORISeeTime As %Time [ SqlColumnNumber = 67, SqlFieldName = OEORI_SeeTime ];

/// 门急诊疗程超限原因
Property OEORIExceedReasonDR As User.DHCDocExceedReason [ SqlColumnNumber = 68, SqlFieldName = OEORI_ExceedReason_DR ];

/// 医嘱处理类型
Property OEORISeeType As %String(DISPLAYLIST = ",Untreated,Accept,Refuse,Finish", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",U,A,R,F") [ InitialExpression = "U", SqlColumnNumber = 69, SqlFieldName = OEORI_SeeType ];

/// 医嘱处理备注
Property OEORISeeRemark As %String [ SqlColumnNumber = 70, SqlFieldName = OEORI_SeeRemark ];

/// 实习医嘱审核日期
Property OEORIPracticeConfirmDate As %Date [ SqlColumnNumber = 71, SqlFieldName = OEORI_PracticeConfirmDate ];

/// 实习医嘱审核日期
Property OEORIPracticeConfirmTime As %Time [ SqlColumnNumber = 72, SqlFieldName = OEORI_PracticeConfirmTime ];

/// 实习医嘱审核人
Property OEORIPracticeConfirmUserDR As %String [ SqlColumnNumber = 73, SqlFieldName = OEORI_PracticeConfirmUser_DR ];

/// 药品外购标识
Property OEORIOutsourcingFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 74, SqlFieldName = OEORI_OutsourcingFlag ];

/// 部位@部位!体位!处理方法
Property OEORIBodyPart As %String(COLLATION = "Exact", MAXLEN = 30000) [ SqlColumnNumber = 75, SqlFieldName = OEORI_BodyPart ];

/// 物资收费项id
Property OEORITarCatRowId As %String [ SqlColumnNumber = 76, SqlFieldName = OEORI_TarCatRowId ];

/// 第三方插入标志
Property OEORIExtOrgCode As %String [ SqlColumnNumber = 77, SqlFieldName = OEORI_ExtOrgCode ];

/*
	按用法:Instr:IS
	按医嘱项:Item:IT
	按医嘱子类:ItemCat:IC
	皮试:Skin:SK
	容器:Container:CT
	标本:Specimen:SP
	采血费:BloodFee:BF
	自备药长期自动插入取药医嘱:OMSTAutoInsertONE:OMIO
	治疗申请:CureApp:CA
	虚拟长期自动插入取药医嘱:VirtualLongIAutoInsertONE:VLIO
	草药处方剂型绑定材料:CMPrescTypeAdddMaterial:CMPTAM
	草药处方剂型关联费用:CMPrescTypeAddOtherFee:CMPTAOF
	草药自动绑定长期医嘱:CMPrescTypeAddLong:CMPTAL
	草药自动绑定煎药费:CMCookModeAddOrd:CMCMAO
	草药自动绑定加工费:CMPrescTypeCookModeAdd:CMPTCMA
	病区绑定费用:WardBind:WB
	检查检验部位绑定医嘱:ReportPartBind:RPB
	住院每日床位费、诊察费:DailyBedFee:DBFee
	挂号预开医嘱:RegPreOrd:RPO
	挂号产生医嘱:RegTakeOrd:RTO
	##Class(web.DHCDocQryOEOrder).GetBindSourceDesc()
	*/
/// 医嘱绑定来源 
Property OEORIBindSource As %String(DISPLAYLIST = ",Instr,Item,ItemCat,Skin,Container,Specimen,BloodFee,OMSTAutoInsertONE,CureApp,VirtualLongIAutoInsertONE,CMPrescTypeAdddMaterial,CMPrescTypeAddOtherFee,CMPrescTypeAddLong,CMCookModeAddOrd,CMPrescTypeCookModeAdd,WardBind,ReportPartBind,DailyBedFee,RegPreOrd,RegTakeOrd", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",IS,IT,IC,SK,CT,SP,BF,OMIO,CA,VLIO,CMPTAM,CMPTAOF,CMPTAL,CMCMAO,CMPTCMA,WB,RPB,DBFee,RPO,RTO") [ SqlColumnNumber = 78, SqlFieldName = OEORI_BindSource ];

/// 检查申请单关联
Property OEORIAppReportDR As User.DHCAppRepArc [ SqlColumnNumber = 79, SqlFieldName = OEORI_AppReport_DR ];

/// 门诊药品可使用天数(由录入时计算得到),一般是医保上的限制需要
Property OEORIUsableDays As %String [ SqlColumnNumber = 80, SqlFieldName = OEORI_UsableDays ];

/// 知识库监测日志ID
Property OEORIMonitorLogId As %String [ SqlColumnNumber = 81, SqlFieldName = OEORI_MonitorLogId ];

/// 不计费标志 Y 为不计费; 计费账单金额为0的标识
Property OEORIUnBillFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 82, SqlFieldName = OEORI_UnBillFlag ];

/// 手术打包关联
Property OEORIInsuPackDR As User.OEInsuPackOrder [ SqlColumnNumber = 83, SqlFieldName = OEORI_InsuPack_DR ];

/// 临床路径类型
Property OEORICPWType As %String [ SqlColumnNumber = 84, SqlFieldName = OEORI_CPWType ];

/// 临床路径ID
Property OEORICPWLinkID As %String [ SqlColumnNumber = 85, SqlFieldName = OEORI_CPWLinkID ];

/// 实习医嘱停止审核日期
Property OEORIPracticeConfirmStopDate As %Date [ SqlColumnNumber = 86, SqlFieldName = OEORI_PracticeConfirmStopDate ];

/// 实习医嘱停止审核日期
Property OEORIPracticeConfirmStopTime As %Time [ SqlColumnNumber = 87, SqlFieldName = OEORI_PracticeConfirmStopTime ];

/// 实习医嘱停止审核人
Property OEORIPracticeConfirmStopUserDR As %String [ SqlColumnNumber = 88, SqlFieldName = OEORI_PracticeConfirmStopUser_DR ];

/// 实习医嘱停止审核状态
Property OEORIPracticeConfirmStopStatus As OECOrderStatus [ SqlColumnNumber = 89, SqlFieldName = OEORI_PracticeConfirmStopStatus ];

/// 实习医嘱停止人(具体哪个实习医师发起的停止操作)
Property OEORIPracticeStopUserDR As %String [ SqlColumnNumber = 90, SqlFieldName = OEORI_PracticeStopUser_DR ];

/// 临时护嘱绑定的长期医嘱id/所辅助的治疗医嘱  OrderServiceOrdDR
Property OEORIServiceOrdDR As OEOrdItem [ SqlColumnNumber = 91, SqlFieldName = OEORI_ServiceOrd_DR ];

/// 周频次(医生选择的周频次对应的使用周信息)
Property OEORIFreqWeek As %String [ SqlColumnNumber = 92, SqlFieldName = OEORI_FreqWeek ];

/// 中草药组合数
Property OEORIINCIPackComb As %String [ SqlColumnNumber = 93, SqlFieldName = OEORI_INCIPackComb ];

/// 虚拟长期标记
Property OEORIVirtualtLong As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 94, SqlFieldName = OEORI_VirtualtLong ];

/// 门诊医嘱所在费用套餐编号(计费用，审核医嘱时更新, 订购类套餐使用),对应User.OEOrdExecExt表中的OEOREPkgOrderNo
Property OEORIPkgOrderNo As %String [ SqlColumnNumber = 95, SqlFieldName = OEORI_PkgOrderNo ];

/// 录入医嘱时按登录科室取接收科室标志
Property OEORIOpenForAllHosp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 96, SqlFieldName = OEORI_OpenForAllHosp ];

/// 同频次不同剂量对应的剂量串
Property OEORIDoseQtyStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 97, SqlFieldName = OEORI_DoseQtyStr ];

/// 护士批量补录医嘱标识
Property OEORINurseBatchAdd As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 98, SqlFieldName = OEORI_NurseBatchAdd ];

/// (费用套餐功能,计费用，收费匹配时更新, 优惠券套餐使用),优惠券号
Property OEORIPkgSerino As %String [ SqlColumnNumber = 99, SqlFieldName = OEORI_PkgSerino ];

/// (费用套餐功能,计费用，收费匹配时更新, 优惠券套餐使用),套餐产品明细指针
Property OEORIPkgProDDr As %String [ SqlColumnNumber = 100, SqlFieldName = OEORI_PkgProDDr ];

/// 被全排斥停止的医嘱，记录全排斥医嘱的ID
Property OEORIByStopAllLongOrdDR As OEOrdItem [ SqlColumnNumber = 101, SqlFieldName = OEORI_ByStopAllLongOrd_DR ];

/// iMedical应急方案医嘱导入标识
Property OEORIImportByContingences As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 102, SqlFieldName = OEORI_ImportByContingences ];

/// 按照指定的批次插入医嘱，目前仅应用于iMedical应急方案中的批次价模式
Property OEORIDspBatch As %String [ SqlColumnNumber = 103, SqlFieldName = OEORI_DspBatch ];

/// 按照指定的库存项插入医嘱，目前仅应用于iMedical应急方案中的批次价模式
/// 与OEORI_INCIPackComb作用类似，直接影响打包表中库存项相关字段
Property OEORIImportINCI As %String [ SqlColumnNumber = 104, SqlFieldName = OEORI_ImportINCI ];

/// 记录会诊子表id，用于后续区分执行科室
Property OEORIEmConsultItm As User.DHCEmConsultItm [ SqlColumnNumber = 105, SqlFieldName = OEORI_EmConsultItm ];

/// 记录医保特病、慢病编码
Property OEORIChronicDiagCode As %String [ SqlColumnNumber = 106, SqlFieldName = OEORI_ChronicDiagCode ];

/// 记录预住院医嘱，病人是预住院状态时医生开的医嘱
Property OEORIPreInPatFlag As %String [ SqlColumnNumber = 107, SqlFieldName = OEORI_PreInPatFlag ];

/// 不规则频次分发时间列表(LogicalTime|LogicalTime|...)
Property OEORIFreqFreeTimeStr As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 108, SqlFieldName = OEORI_FreqFreeTimeStr ];

/// 护士补录医嘱关联主医嘱分发时间(LogicalTime|LogicalTime|...)
Property OEORINurseExecLinkFreqDispTimeStr As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 109, SqlFieldName = OEORI_NurseExecLinkFreqDispTimeStr ];

/// 实习医嘱停止/作废/撤销日期
Property OEORIPracticeStopDate As %Date [ SqlColumnNumber = 110, SqlFieldName = OEORI_PracticeStopDate ];

/// 实习医嘱停止/作废/撤销时间
Property OEORIPracticeStopTime As %Time [ SqlColumnNumber = 111, SqlFieldName = OEORI_PracticeStopTime ];

/// 实习医嘱作废/撤销原因ID
Property OEORIPracticeStopReasonDR As OECOrderStatus [ SqlColumnNumber = 112, SqlFieldName = OEORI_PracticeStopReason_DR ];

/// 实习医嘱作废/撤销原因描述
Property OEORIPracticeStopReasonComtent As %String [ SqlColumnNumber = 113, SqlFieldName = OEORI_PracticeStopReasonComtent ];

/// 保存治疗申请关联的ID信息
Property OEORIDHCAADr As %String [ SqlColumnNumber = 114, SqlFieldName = OEORI_DHCAADr ];

/// 医嘱流水号，可用于对接第三方审方等系统，该号码在添加医嘱ID至行上时生成
Property OEORISerialNum As %String [ SqlColumnNumber = 115, SqlFieldName = OEORI_SerialNum ];

/// 护士确认费用 确认人
Property OEORIConFirmFeeUser As %String [ SqlColumnNumber = 116, SqlFieldName = OEORI_ConFirmFeeUser ];

/// 护士确认费用 日期
Property OEORIConFirmFeeDate As %Date [ SqlColumnNumber = 117, SqlFieldName = OEORI_ConFirmFeeDate ];

/// 护士确认费用 时间
Property OEORIConFirmFeeTime As %Time [ SqlColumnNumber = 118, SqlFieldName = OEORI_ConFirmFeeTime ];

/// 护士打印标记
Property OEORINurPrinted As %String [ SqlColumnNumber = 119, SqlFieldName = OEORI_NurPrinted ];

/// 护士打印日期
Property OEORINurPrintDate As %Date [ SqlColumnNumber = 120, SqlFieldName = OEORI_NurPrintDate ];

/// 护士打印时间
Property OEORINurPrintTime As %Time [ SqlColumnNumber = 121, SqlFieldName = OEORI_NurPrintTime ];

/// 护士打印人
Property OEORINurPrintUserDR As User.SSUser [ SqlColumnNumber = 122, SqlFieldName = OEORI_NurPrintUser_DR ];

/// 医嘱绑定来源,费用医嘱所关联的医嘱OEORISerialNum信息串,@分割
Property OEORIBindSourceSerialNumStr As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 123, SqlFieldName = OEORI_BindSourceSerialNumStr ];

/// 医保控费申请ID
Property OEORIInsuApplyDR As %String [ SqlColumnNumber = 124, SqlFieldName = OEORI_InsuApplyDR ];

/// 持续型医嘱项类型，用于标识CPR或其他医嘱类型-中山三院
Property OEORISustainOrdType As %String [ SqlColumnNumber = 125, SqlFieldName = OEORI_SustainOrdType ];

/// 记录持续型医嘱项	($H-$H)；-中山三院
Property OEORISustainOrdTimeInfo As list Of %String [ SqlColumnNumber = 126, SqlFieldName = OEORI_SustainOrdTimeInfo ];

/// 插入医嘱时的就诊状态:B 费用调整
Property OEORIAdmStatus As %String [ SqlColumnNumber = 127, SqlFieldName = OEORI_AdmStatus ];

/// 合理用药审方信息
Property OEORIDHCHLYYInfo As %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 128, SqlFieldName = OEORI_DHCHLYYInfo ];

/// 审核医生(用于记录非医生插入的医嘱，后期视医院情况，看是否需要审核界面)(综合查询组使用)
Property OEORIAuditDocDR As User.CTCareProv [ SqlColumnNumber = 129, SqlFieldName = OEORI_AuditDocDR ];

/// 审核科室
Property OEORIAuditLocDR As User.CTLoc [ SqlColumnNumber = 130, SqlFieldName = OEORI_AuditLocDR ];

/// 审核日期
Property OEORIAuditDate As %Date [ SqlColumnNumber = 131, SqlFieldName = OEORI_AuditDate ];

/// 审核时间
Property OEORIAuditTime As %Time [ SqlColumnNumber = 132, SqlFieldName = OEORI_AuditTime ];

/// 转科类型(转科、转病区)
Property OEORITransType As %String(DISPLAYLIST = ",TransLoc,TransWard", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",TL,TW") [ SqlColumnNumber = 133, SqlFieldName = OEORI_TransType ];

/// 转科已用标志(护士站使用)
Property OEORITransUseFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 134, SqlFieldName = OEORI_TransUseFlag ];

/// 医保控费审核ID
Property OEORIInsuRulesID As %Time [ SqlColumnNumber = 135, SqlFieldName = OEORI_InsuRulesID ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Index - CPW">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"CPW"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_CPWType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_CPWLinkID}</Expression>
</Subscript>
<Subscript name="6">
<Expression> {OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORINurseBatchAdd">
<Condition>{OEORI_NurseBatchAdd}="Y"</Condition>
<ConditionFields>OEORI_NurseBatchAdd</ConditionFields>
<Global>^OEORDi</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NurseBatchAdd"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_NurseBatchAdd}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOEORIPkgSerino">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PkgSerino"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_PkgSerino}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeeType">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SeeType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SeeType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSeeTypeDateTime">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SeeTypeDateTime"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SeeDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_SeeTime}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_SeeType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSerialNum">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IndexSerialNum"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_SerialNum}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceOrd">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SERORD"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_ServiceOrd_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTransType">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TransType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_OEORD_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORI_TransType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORI_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="OEORI_AdmStatus">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>78</Piece>
</Data>
<Data name="OEORI_AppReport_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>42</Piece>
</Data>
<Data name="OEORI_AuditDate">
<Delimiter>"^"</Delimiter>
<Node>"AUDIT"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_AuditDocDR">
<Delimiter>"^"</Delimiter>
<Node>"AUDIT"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_AuditLocDR">
<Delimiter>"^"</Delimiter>
<Node>"AUDIT"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_AuditTime">
<Delimiter>"^"</Delimiter>
<Node>"AUDIT"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_BindSource">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>41</Piece>
</Data>
<Data name="OEORI_BindSourceSerialNumStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>76</Piece>
</Data>
<Data name="OEORI_BodyPart">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>38</Piece>
</Data>
<Data name="OEORI_ByStopAllLongOrd_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>61</Piece>
</Data>
<Data name="OEORI_CPWLinkID">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>48</Piece>
</Data>
<Data name="OEORI_CPWType">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>47</Piece>
</Data>
<Data name="OEORI_ChargeToOwnDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_ChargeToOwnFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_ChargeToOwnTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_ChargeToOwnUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_ChronicDiagCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>66</Piece>
</Data>
<Data name="OEORI_ConFirmFeeDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_ConFirmFeeTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_ConFirmFeeUser">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_DHCAADr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>74</Piece>
</Data>
<Data name="OEORI_DHCHLYYInfo">
<Node>"HLYY"</Node>
</Data>
<Data name="OEORI_DisconDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_DisconTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_DisconUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_DispWeekTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>11</Piece>
</Data>
<Data name="OEORI_DoctorConfirmDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_DoctorConfirmFlag">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_DoctorConfirmTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_DoctorConfirmUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_DoseQtyStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>59</Piece>
</Data>
<Data name="OEORI_DspBatch">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>63</Piece>
</Data>
<Data name="OEORI_EMStayFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_EmConsultItm">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>65</Piece>
</Data>
<Data name="OEORI_ExceedReason_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>33</Piece>
</Data>
<Data name="OEORI_ExecuteDateStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_ExtOrgCode">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>40</Piece>
</Data>
<Data name="OEORI_FreqFreeTimeStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>68</Piece>
</Data>
<Data name="OEORI_FreqWeek">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>55</Piece>
</Data>
<Data name="OEORI_INCIPackComb">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>56</Piece>
</Data>
<Data name="OEORI_ImportByContingences">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>62</Piece>
</Data>
<Data name="OEORI_ImportINCI">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>64</Piece>
</Data>
<Data name="OEORI_InsuApplyDR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>77</Piece>
</Data>
<Data name="OEORI_InsuPack_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>46</Piece>
</Data>
<Data name="OEORI_InsuRulesID">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_InsurCat_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_LabEpisodeNoStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>22</Piece>
</Data>
<Data name="OEORI_LocalInfusionQty">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>21</Piece>
</Data>
<Data name="OEORI_MRDIA_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>27</Piece>
</Data>
<Data name="OEORI_MaterialNo">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_MedUnit_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_MonitorLogId">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>44</Piece>
</Data>
<Data name="OEORI_NeedPIVAFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_NurPrintDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_NurPrintTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>14</Piece>
</Data>
<Data name="OEORI_NurPrintUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_NurPrinted">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_NurseBatchAdd">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>60</Piece>
</Data>
<Data name="OEORI_NurseExecLinkFreqDispTimeStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>69</Piece>
</Data>
<Data name="OEORI_NutritionDrugFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>12</Piece>
</Data>
<Data name="OEORI_OMProcNote">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>9</Piece>
</Data>
<Data name="OEORI_OldPrice">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>30</Piece>
</Data>
<Data name="OEORI_OpenForAllHosp">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>58</Piece>
</Data>
<Data name="OEORI_OtherFlags">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>23</Piece>
</Data>
<Data name="OEORI_OutsourcingFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>37</Piece>
</Data>
<Data name="OEORI_PEProject_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>10</Piece>
</Data>
<Data name="OEORI_PackUOM_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>13</Piece>
</Data>
<Data name="OEORI_PayorAduitFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>19</Piece>
</Data>
<Data name="OEORI_PkgOrderNo">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>15</Piece>
</Data>
<Data name="OEORI_PkgProDDr">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_PkgSerino">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_PracticeConfirmDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>34</Piece>
</Data>
<Data name="OEORI_PracticeConfirmStopDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>49</Piece>
</Data>
<Data name="OEORI_PracticeConfirmStopStatus">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>51</Piece>
</Data>
<Data name="OEORI_PracticeConfirmStopTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>50</Piece>
</Data>
<Data name="OEORI_PracticeConfirmStopUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>52</Piece>
</Data>
<Data name="OEORI_PracticeConfirmTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>35</Piece>
</Data>
<Data name="OEORI_PracticeConfirmUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>36</Piece>
</Data>
<Data name="OEORI_PracticeStopDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>70</Piece>
</Data>
<Data name="OEORI_PracticeStopReasonComtent">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>73</Piece>
</Data>
<Data name="OEORI_PracticeStopReason_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>72</Piece>
</Data>
<Data name="OEORI_PracticeStopTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>71</Piece>
</Data>
<Data name="OEORI_PracticeStopUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>53</Piece>
</Data>
<Data name="OEORI_PreInPatFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>67</Piece>
</Data>
<Data name="OEORI_PrePresc_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>20</Piece>
</Data>
<Data name="OEORI_PriceFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>25</Piece>
</Data>
<Data name="OEORI_PriceInputFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>26</Piece>
</Data>
<Data name="OEORI_PrintFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>24</Piece>
</Data>
<Data name="OEORI_RBAS_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_RefundAuditDate">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>3</Piece>
</Data>
<Data name="OEORI_RefundAuditLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_RefundAuditStatus">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>1</Piece>
</Data>
<Data name="OEORI_RefundAuditTime">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_RefundAuditUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>2</Piece>
</Data>
<Data name="OEORI_RefundReason">
<Delimiter>"^"</Delimiter>
<Node>"BILL"</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_SeeDate">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_SeeRemark">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_SeeTime">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_SeeType">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_SeeUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_SelfOMFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>32</Piece>
</Data>
<Data name="OEORI_SerialNum">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>75</Piece>
</Data>
<Data name="OEORI_ServiceOrd_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>54</Piece>
</Data>
<Data name="OEORI_Stage">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>8</Piece>
</Data>
<Data name="OEORI_StopDripDate">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>5</Piece>
</Data>
<Data name="OEORI_StopDripFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>4</Piece>
</Data>
<Data name="OEORI_StopDripTime">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>6</Piece>
</Data>
<Data name="OEORI_StopDripUser_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>7</Piece>
</Data>
<Data name="OEORI_StopReason_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>28</Piece>
</Data>
<Data name="OEORI_SustainOrdTimeInfo">
<Node>"SOrdInfo"</Node>
</Data>
<Data name="OEORI_SustainOrdType">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>16</Piece>
</Data>
<Data name="OEORI_TarCatRowId">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>39</Piece>
</Data>
<Data name="OEORI_Target">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_TransType">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>17</Piece>
</Data>
<Data name="OEORI_TransUseFlag">
<Delimiter>"^"</Delimiter>
<Node>"NUR"</Node>
<Piece>18</Piece>
</Data>
<Data name="OEORI_UnBillFlag">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>45</Piece>
</Data>
<Data name="OEORI_UsableDays">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>43</Piece>
</Data>
<Data name="OEORI_UseInLoc_DR">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>31</Piece>
</Data>
<Data name="OEORI_VirtualtLong">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>57</Piece>
</Data>
<Data name="OEORI_WeekFreqDatTimStr">
<Delimiter>"^"</Delimiter>
<Node>"DHC"</Node>
<Piece>29</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEORI_OEORD_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEORI_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OEORI_OEORD_ParRef}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORI_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdItemExtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
