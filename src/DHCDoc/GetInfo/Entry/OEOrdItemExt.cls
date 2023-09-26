Class DHCDoc.GetInfo.Entry.OEOrdItemExt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 医嘱执行日期串
Property OEORIExecuteDateStr As %String(TRUNCATE = 1);

/// 资源排班记录指针 (指向RB_ApptSchedule)
Property OEORIRBASDR As %String(TRUNCATE = 1);

/// 医保类别指针 (取自INSU_TarItems)
Property OEORIInsurCatDR As %String(TRUNCATE = 1);

/// 医保类别Code
Property OEORIInsurCatCode As %String(TRUNCATE = 1);

/// 医保类别描述
Property OEORIInsurCatDesc As %String(TRUNCATE = 1);

/// 停止输液标志
Property OEORIStopDripFlag As %String(TRUNCATE = 1);

/// 停止输液日期
Property OEORIStopDripDate As %String(TRUNCATE = 1);

/// 停止输液时间
Property OEORIStopDripTime As %String(TRUNCATE = 1);

/// 停止输液操作人指针(指向SS_User)
Property OEORIStopDripUserDR As %String(TRUNCATE = 1);

/// 停止输液操作人代码
Property OEORIStopDripUserCode As %String(TRUNCATE = 1);

/// 停止输液操作人名字
Property OEORIStopDripUserDesc As %String(TRUNCATE = 1);

/// 医嘱阶段
Property OEORIStage As %String(TRUNCATE = 1);

/// 嘱托备注
Property OEORIOMProcNote As %String(TRUNCATE = 1);

/// 科研药理项目的指针 (取自DHC_DocPilotProject)
Property OEORIPEProjectDR As %String(TRUNCATE = 1);

/// 科研药理项目Code
Property OEORIPEProjectCode As %String(TRUNCATE = 1);

/// 科研药理项目描述
Property OEORIPEProjectDesc As %String(TRUNCATE = 1);

/// 营养药标志
Property OEORINutritionDrugFlag As %String(TRUNCATE = 1);

/// 星期频次的分发点
Property OEORIDispWeekTime As %String(TRUNCATE = 1);

/// 协议包装单位指针 (指向CT_Uom)
Property OEORIPackUOM As %String(TRUNCATE = 1);

/// 协议包装单位Code
Property OEORIPackUOMCode As %String(TRUNCATE = 1);

/// 协议包装单位描述
Property OEORIPackUOMDesc As %String(TRUNCATE = 1);

/// 高值材料条码
Property OEORIMaterialNo As %String(TRUNCATE = 1);

/// 医疗单元指针 (指向DHC_CTLocMedUnit)
Property OEORIMedUnitDR As %String(TRUNCATE = 1);

/// 医疗单元Code
Property OEORIMedUnitCode As %String(TRUNCATE = 1);

/// 医疗单元描述
Property OEORIMedUnitDesc As %String(TRUNCATE = 1);

/// 需要配液标志
Property OEORINeedPIVAFlag As %String(TRUNCATE = 1);

/// 留观状态标识
Property OEORIEMStayFlag As %String(TRUNCATE = 1);

/// 医嘱是”治疗/预防”  1:治疗  2:预防
Property OEORITarget As %String(TRUNCATE = 1);

/// 记账审核标识
Property OEORIPayorAduitFlag As %String(TRUNCATE = 1);

/// 预生成的处方指针 ？
Property OEORIPrePrescDR As %String(TRUNCATE = 1);

/// 本院输液次数
Property OEORILocalInfusionQty As %String(TRUNCATE = 1);

/// 所绑定的检验医嘱的检验号串,如抽血费
Property OEORILabEpisodeNoStr As %String(TRUNCATE = 1);

/// 特殊的本地化标识  1_$C(1)_1;华西第一个值为生成取药医嘱的标识
Property OEORIOtherFlags As %String(TRUNCATE = 1);

/// 打印导诊单标识
Property OEORIPrintFlag As %String(TRUNCATE = 1);

/// 需另划价标识 Y:代表将不计费，将有科室补录实际费用    Add In 北京协和
Property OEORIPriceFlag As %String(TRUNCATE = 1);

/// 已另划价标识 Y:代表已经另划价                        Add In 北京协和
Property OEORIPriceInputFlag As %String(TRUNCATE = 1);

/// 关联医嘱指针(指向MR_Diagnos)  主要用于医保适应症
Property OEORIMRDIADR As %String(TRUNCATE = 1);

/// 停医嘱原因关联指针(指向BLC_ReasonForRefund )
Property OEORIStopReasonDR As %String(TRUNCATE = 1);

/// 停医嘱原因关联Code
Property OEORIStopReasonCode As %String(TRUNCATE = 1);

/// 停医嘱原因关联描述
Property OEORIStopReasonDesc As %String(TRUNCATE = 1);

/// 周频次日期时间串
Property OEORIWeekFreqDatTimStr As %String(TRUNCATE = 1);

/// 老系统价格   其他系统数据迁移时价格
Property OEORIOldPrice As %String(TRUNCATE = 1);

/// 使用科室指针(指向CT_Loc)  下医嘱时指定检查科室去药房替病人领药
Property OEORIUseInLocDR As %String(TRUNCATE = 1);

/// 使用科室Code
Property OEORIUseInLocCode As %String(TRUNCATE = 1);

/// 使用科室Desc
Property OEORIUseInLocDesc As %String(TRUNCATE = 1);

/// 药品个人自带标识
Property OEORISelfOMFlag As %String(TRUNCATE = 1);

/// 门诊退费审核标志
Property OEORIRefundAuditFlag As %String(TRUNCATE = 1);

/// 门诊退费审核用户指针(指向SS_User)
Property OEORIRefundAuditUserDR As %String(TRUNCATE = 1);

/// 门诊退费审核用户Code
Property OEORIRefundAuditUserCode As %String(TRUNCATE = 1);

/// 门诊退费审核用户描述
Property OEORIRefundAuditUserDesc As %String(TRUNCATE = 1);

/// 门诊退费审核日期
Property OEORIRefundAuditDate As %String(TRUNCATE = 1);

/// 门诊退费审核时间
Property OEORIRefundAuditTime As %String(TRUNCATE = 1);

/// 门诊退费审核原因指针(指向DHC_INVOPRefReason)
Property OEORIRefundReason As %String(TRUNCATE = 1);

/// 门诊退费审核原因Code
Property OEORIRefundReasonCode As %String(TRUNCATE = 1);

/// 门诊退费审核原因描述
Property OEORIRefundReasonDesc As %String(TRUNCATE = 1);

/// 门诊退费审核科室指针(指向CT_Loc)
Property OEORIRefundAuditLocDR As %String(TRUNCATE = 1);

/// 门诊退费审核科室Code
Property OEORIRefundAuditLocCode As %String(TRUNCATE = 1);

/// 门诊退费审核科室描述
Property OEORIRefundAuditLocDesc As %String(TRUNCATE = 1);

/// 门诊科室审核标志  此标志用来决定后续是否能计费
Property OEORIDoctorConfirmFlag As %String(TRUNCATE = 1);

/// 门诊科室审核日期
Property OEORIDoctorConfirmDate As %String(TRUNCATE = 1);

/// 门诊科室审核时间
Property OEORIDoctorConfirmTime As %String(TRUNCATE = 1);

/// 门诊科室审核人指针(指向SS_User)
Property OEORIDoctorConfirmUserDR As %String(TRUNCATE = 1);

/// 门诊科室审核人Code
Property OEORIDoctorConfirmUserCode As %String(TRUNCATE = 1);

/// 门诊科室审核人描述
Property OEORIDoctorConfirmUserDesc As %String(TRUNCATE = 1);

/// 门诊记帐转自费标识
Property OEORIChargeToOwnFlag As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员指针(指针SS_User)
Property OEORIChargeToOwnUserDR As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员Code
Property OEORIChargeToOwnUserCode As %String(TRUNCATE = 1);

/// 门诊记帐转自费操作员描述
Property OEORIChargeToOwnUserDesc As %String(TRUNCATE = 1);

/// 门诊记帐转自费日期
Property OEORIChargeToOwnDate As %String(TRUNCATE = 1);

/// 门诊记帐转自费时间
Property OEORIChargeToOwnTime As %String(TRUNCATE = 1);

/// 停止医嘱处理护士指针(指向SS_User)
Property OEORIDisconUserDR As %String(TRUNCATE = 1);

/// 停止医嘱处理护士Code
Property OEORIDisconUserCode As %String(TRUNCATE = 1);

/// 停止医嘱处理护士描述
Property OEORIDisconUserDesc As %String(TRUNCATE = 1);

/// 停止医嘱处理日期
Property OEORIDisconDate As %String(TRUNCATE = 1);

/// 停止医嘱处理时间
Property OEORIDisconTime As %String(TRUNCATE = 1);

/// 医嘱处理护士指针(指向SS_User)
Property OEORISeeUserDR As %String(TRUNCATE = 1);

/// 医嘱处理护士Code
Property OEORISeeUserCode As %String(TRUNCATE = 1);

/// 医嘱处理护士描述
Property OEORISeeUserDesc As %String(TRUNCATE = 1);

/// 医嘱处理日期
Property OEORISeeDate As %String(TRUNCATE = 1);

/// 医嘱处理时间
Property OEORISeeTime As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因指针(指向DHC_DocExceedReason)
Property OEORIExceedReasonDR As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因Code
Property OEORIExceedReasonCode As %String(TRUNCATE = 1);

/// 门急诊疗程超限原因描述
Property OEORIExceedReasonDesc As %String(TRUNCATE = 1);

/// 医嘱处理类型
Property OEORISeeType As %String(TRUNCATE = 1);

/// 医嘱处理备注
Property OEORISeeRemark As %String(TRUNCATE = 1);

/// 实习医嘱审核日期
Property OEORIPracticeConfirmDate As %String(TRUNCATE = 1);

/// 实习医嘱审核时间
Property OEORIPracticeConfirmTime As %String(TRUNCATE = 1);

/// 实习医嘱审核人指针(指向SS_User)
Property OEORIPracticeConfirmUserDR As %String(TRUNCATE = 1);

/// 实习医嘱审核人Code
Property OEORIPracticeConfirmUserCode As %String(TRUNCATE = 1);

/// 实习医嘱审核人名称
Property OEORIPracticeConfirmUserDesc As %String(TRUNCATE = 1);

/// 药品外购标识
Property OEORIOutsourcingFlag As %String(TRUNCATE = 1);

/// 部位@部位!体位!处理方法
Property OEORIBodyPart As %String(TRUNCATE = 1);

/// 物资收费项id (取自)
Property OEORITarCatRowId As %String(TRUNCATE = 1);

/// 物资收费项Code
Property OEORITarCatCode As %String(TRUNCATE = 1);

/// 物资收费项描述
Property OEORITarCatDesc As %String(TRUNCATE = 1);

/// 第三方插入标志
Property OEORIExtOrgCode As %String(TRUNCATE = 1);

}
