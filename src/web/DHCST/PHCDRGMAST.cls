Import sqluser

/// Descript:药学项信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCST.PHCDRGMAST Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存药学项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-17
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:药学项子表rowid,代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^类组类型^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
/// Output:		
/// Return：药学项子表rowid,成功
/// -61，代码不能为空
/// -62,名称不能为空
/// -63,剂型不能为空
/// -64,单位不能为空
/// -65,用法不能为空
/// -51   ;保存药学项主表失败
/// -52   ;插入药学项子表失败
/// -53   ;插入DDD值等信息失败
/// -66    ;无效的药学子分类
/// -67  ;无效的药学小分类
/// -68 ;无效的管制分类
/// -69 ;无效的产地
/// -70 ;无效的通用名
/// -71 ;无效的剂型
/// -72 ;无效的频次
/// -73 ;无效的用法
/// -74 ;无效的疗程
/// -75 ;无效的基本单位
/// -76			;药学项代码已经存在，不能重复
/// -77			;药学项名称已经存在，不能重复
/// -78  基本数量为空或不大于0	
ClassMethod Save(PhcdfId As %String, listData As %String) As %Library.String
{
	n (PhcdfId,listData,%session)
 	s PhcCode=$p(listData,"^",1)
 	s PhcDesc=$p(listData,"^",2)
 	s FormId=$p(listData,"^",3)
 	s BuomId=$p(listData,"^",4)
 	s InstId=$p(listData,"^",5)
 	s DuraId=$p(listData,"^",6)
 	s BQty=$p(listData,"^",7)
 	s ManfId=$p(listData,"^",8)
 	s PoisonId=$p(listData,"^",9)			;管制分类
 	s FreqId=$p(listData,"^",10)
 	s Generic=$p(listData,"^",12)
 	i Generic'="" d	// 以处方通用名剂型为准
 	.s FormId=$p($g(^PHCGE("GE",Generic,"DHC")),"^",5)
 	s PhcCatId=$p(listData,"^",13)
 	s PhcSubCatId=$p(listData,"^",14)
 	s PhcMinCatId=$p(listData,"^",15)
 	q:(PhcdfId'="")&(listData="") PhcdfId   ;没有需要更新的内容
 	;
 	;不能为空项
 	q:PhcCode="" -61
 	q:PhcDesc="" -62
 	//q:FormId="" -63
 	q:BuomId="" -64
 	//q:InstId="" -65
 	s ResultString=""
 	i PoisonId'=""  d
 	.i '$d(^PHCPO(PoisonId)) d
 	..s ResultString=-68
 	q:ResultString'="" ResultString				;无效的管制分类
 	;
 	i ManfId'=""  d
 	.i '$d(^PHMNF(ManfId)) d
 	..s ResultString=-69
 	q:ResultString'="" ResultString				;无效的产地
 	;
 	i Generic'=""  d
 	.i '$d(^PHCGE("GE",Generic)) d
 	..s ResultString=-70
 	q:ResultString'="" ResultString				;无效的通用名
 	;
 	i FormId'=""  d
 	.i '$d(^PHCF(FormId)) d
 	..s ResultString=-71
 	q:ResultString'="" ResultString				;无效的剂型

 	i FreqId'=""  d
 	.i '$d(^PHCFR(FreqId)) d
 	..s ResultString=-72
 	q:ResultString'="" ResultString				;无效的频次
	;
	i InstId'=""  d
	.i '$d(^PHCIN(InstId)) d
 	..s ResultString=-73
 	q:ResultString'="" ResultString				;无效的用法
 	;
	i DuraId'=""  d
	.i '$d(^PHCDU(DuraId)) d
 	..s ResultString=-74
 	q:ResultString'="" ResultString				;无效的疗程
 	;
 	i BuomId'=""  d
	.i '$d(^CT("UOM",BuomId)) d
 	..s ResultString=-75
 	q:ResultString'="" ResultString				;无效的基本单位
 	;
 	s TmpId=$o(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(PhcCode),"")) 
 	q:(TmpId'="")&(TmpId'=+PhcdfId) -76			;药学项代码已经存在，不能重复				
 	;
 	s TmpId=$o(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(PhcDesc),"")) 
 	q:(TmpId'="")&(TmpId'=+PhcdfId) -77			;药学项名称已经存在，不能重复		
 	q:(BQty="")||(BQty'>0) -78 //add wyx 判断基本数量，至少大于0 2014-02-21
 	
 	s WhonetCode=$p(listData,"^",31)
 	q:(WhonetCode'="")&&(..CheckWhonetInfoDHCLIS(WhonetCode)<0) -79
    s PhcSpecId=$p(listData,"^",32)
    /*	yunhaibao,20181116,无需限制
  	i PhcSpecId'=""  d
 	.s Inci=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(PhcCode)_"Z",""))
 	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s itmcatgupdesc=$p(StkGrpInfo,"^",2)
    .s:(itmcatgupdesc'["饮片")&&(itmcatgupdesc'["颗粒")&&(itmcatgupdesc'["免煎") ResultString=-80
 	*/
 	q:ResultString'="" ResultString				;非中草药没有草药备注
 	;如果界面没有维护DDD则通过WhoDDD值计算
 	s DDD=$p(listData,"^",25)					;DDD值
 	i DDD="" d
 	.s PhcCode=$p(listData,"^",1)
 	.s WhoDDD=$p(listData,"^",33) 				;PHCDFWhoDDD值
 	.s WhoDDDUom=$p(listData,"^",34) 			;PHCDFWhoDDD单位
 	.s $p(listData,"^",25)=..GetBUomDDD(PhcCode,WhoDDD,WhoDDDUom)
 	i PhcdfId=""  d
 	.s ret=..Insert(listData)
 	e  d
 	.s ret=..Update(PhcdfId,listData)
 	.i ret=0  d
 	..s ret=PhcdfId
 	.
 	q ret
}

/// Descript:	增加药学项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-16
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
/// Output:		
/// Return：药学项子表rowid
/// -51   ;保存药学项主表失败
/// -52   ;插入药学项子表失败
/// ##class(web.DHCST.PHCDRGMAST).Insert
ClassMethod Insert(listData) As %Library.String
{
	n (listData,%session)
 	q:listData="" ""
 	s PhcCode=$p(listData,"^",1)
 	s PhcDesc=$p(listData,"^",2)
 	s FormId=$p(listData,"^",3)
 	s BuomId=$p(listData,"^",4)
 	s InstId=$p(listData,"^",5)
 	s DuraId=$p(listData,"^",6)
 	s BQty=$p(listData,"^",7)
 	s ManfId=$p(listData,"^",8)
 	s PoisonId=$p(listData,"^",9)			;管制分类
 	s FreqId=$p(listData,"^",10)
 	s OfficalCode=$p(listData,"^",11)
 	s Generic=$p(listData,"^",12)
 	s PhcCatId=$p(listData,"^",13)
 	s PhcSubCatId=$p(listData,"^",14)
 	s PhcMinCatId=$p(listData,"^",15)
 	s EngName1=$p(listData,"^",16)			;英文国际非专利药名
 	s EngName2=$p(listData,"^",17)			;国际专利药名
 	s LabelName2=EngName1_"||"_EngName2
 	s GoodName=$p(listData,"^",18)
 	s FregenName=$p(listData,"^",19)		;制剂通用名
 	s FregenName2=$p(listData,"^",20)		;原料通用名
 	s IpOneDay=$p(listData,"^",21)			;住院一天量
 	s OpOneDay=$p(listData,"^",22)			;门诊一天量
 	s OpSkin=$p(listData,"^",23)			;门诊皮试用原液
 	s IpSkin=$p(listData,"^",24)			;住院皮试用原液
 	s DDD=$p(listData,"^",25)				;DDD值
 	s AntibioticFlag=$p(listData,"^",27)	;抗生素标志
 	s CriticalFlag=$p(listData,"^",28)		;危重药标志
 	s AgeLimit=$p(listData,"^",29)			;年龄限制-已停用
 	s DateFrom=+$h							;开始日期
 	s NewCatId=$p(listData,"^",30)          ;多级药学分类 add by ct
 	s WhonetCode=$p(listData,"^",31) 		;WHONET码
 	s PhcSpecId=$p(listData,"^",32) 		;草药备注
 	s WhoDDD=$p(listData,"^",33) 			;PHCDFWhoDDD值
 	s WhoDDDUom=$p(listData,"^",34) 		;PHCDFWhoDDD单位
 	s IvgttSpeed=$p(listData,"^",35) 		;滴速
 	s GranulesFact=$p(listData,"^",36) 		;颗粒单位系数
 	s ProvinceComm=$p(listData,"^",37) 		;省属基本药物
 	s PHCDFPivaCatDr=$p(listData,"^",38)	;药品配液分类
 	s HighRiskLevel=$p(listData,"^",39)		;高危级别
 	s SingleUseFlag=$p(listData,"^",40)		;单味使用标识
 	s AllergyFlag=$p(listData,"^",41)		;过敏
 	s DietTaboo=$p(listData,"^",42)			;饮食禁忌
 	s TumbleFlag=$p(listData,"^",43)		;跌倒风险
 	s DopeFlag=$p(listData,"^",44)	  		;兴奋剂
 	s BasicDrug=$p(listData,"^",45)			;国家基本药物
 	s Drugbase2=$p(listData,"^",46)			;省基本药物
 	s PDrugbase1=$p(listData,"^",47)		;市基本药物
 	s PDrugbase2=$p(listData,"^",48)		;区县基本药物
 	s OTC=$p(listData,"^",49)				;非处方标志
 	s Codex=$p(listData,"^",50)				;中国药典标志
 	s Test=$p(listData,"^",51)				;临床验证用药标志
 	s TpnFlag=$p(listData,"^",52)			;TPN标志
 	s CQZTFlag=$p(listData,"^",53)			;长期默认嘱托
 	s ONEFlag=$p(listData,"^",54)			;临时默认取药
 	s PHCSpec=$p(listData,"^",55)			;含量规格
 	s MonitorFlag=$p(listData,"^",56)		;重点监控标志
 	s OMFlag=$p(listData,"^",57)			;附加说明默认自备
 	;插入药学项主表
 	S Err=0
 	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	&sql(Insert into Phc_DrgMast(PHCD_Code,PHCD_Name,PHCD_PHCSC_DR,PHCD_PHCPO_DR,
 	PHCD_PHMNF_DR,PHCD_LabelName1,PHCD_LabelName2,PHCD_Generic_DR,PHCD_OfficialCode)
 	values(:PhcCode,:PhcDesc,:PhcSubCatId,:PoisonId,:ManfId,:GoodName,:LabelName2,
 	:Generic,:OfficalCode))
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:Phc_DrgMast",PhcDesc,SQLCODE_":"_%msg)
 	.s Err=-51   ;保存药学项主表失败
 	q:Err'=0 Err
 	s PhcdDR=$P(%ROWID,$C(1))		;药学项主表rowid
 	;
 	;插入药学项子表
 	s NameStr=FregenName_"||"_FregenName2
 	;b ;11
 	&sql(Insert into Phc_DrgForm(PHCDF_PHCD_ParRef,PHCDF_PHCF_DR,PHCDF_PHCFR_DR,PHCDF_PHCIN_DR,
 	PHCDF_PHCDU_DR,PHCDF_CTUOM_DR,PHCDF_BaseQty,PHCDF_DeductPartially,PHCDF_OfficialCode,
 	PHCDF_DateFrom) values(:PhcdDR,:FormId,:FreqId,:InstId,:DuraId,:BuomId,:BQty,:IpOneDay,:NameStr,:DateFrom))
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("PHCAdd:Phc_DrgForm",PhcDesc,SQLCODE_":"_%msg)
 	.s Err=-52   ;插入药学项子表失败
 	q:Err'=0 Err
 	s PhcdfId=$P(%ROWID,$C(1))		;药学项子表rowid

 	;插入DDD值抗生素标志等内容
    //&sql(Insert into PHC_DrgFormExt(PHCDF_PHCD_ParRef,PHCDF_DDD,PHCDF_AntibioticFlag,PHCDF_CriticalFlag,PHCDF_OPSkinTestYY,PHCDF_IPSkinTestYY,PHCDF_AgeLimit,PHCDF_PHCC_Dr,PHCDF_WHONET,PHCDF_CHPhSpecInstr,PHCDF_WHODDD,PHCDF_WHODDDUom_Dr,PHCDF_ivgttSpeed,PHCDF_GranulesFact,PHCDF_ProvinceComm)
 	 //values(:PhcdDR,:DDD,:AntibioticFlag,:CriticalFlag,:OpSkin,:IpSkin,:AgeLimit,:NewCatId,:WhonetCode,:PhcSpecId,:WhoDDD,:WhoDDDUom,:IvgttSpeed,:GranulesFact,:ProvinceComm))
 	s PhcdDrId=""
 	&sql(select PHCDF_PHCD_ParRef into :PhcdDrId from PHC_DrgFormExt where PHCDF_PHCD_ParRef=:PhcdDR)
 	i PhcdDrId'=""  d
 	.&sql(Update  PHC_DrgFormExt set PHCDF_DDD=:DDD,PHCDF_AntibioticFlag=:AntibioticFlag,PHCDF_CriticalFlag=:CriticalFlag,
 	PHCDF_OPSkinTestYY=:OpSkin,PHCDF_IPSkinTestYY=:IpSkin,PHCDF_AgeLimit=:AgeLimit,PHCDF_CalcuDose=:OpOneDay,PHCDF_PHCC_Dr=:NewCatId,
 	PHCDF_WHONET=:WhonetCode,PHCDF_CHPhSpecInstr=:PhcSpecId,PHCDF_WHODDD=:WhoDDD,PHCDF_WHODDDUom_Dr=:WhoDDDUom,PHCDF_ivgttSpeed=:IvgttSpeed,
 	PHCDF_GranulesFact=:GranulesFact,PHCDF_ProvinceComm=:ProvinceComm,PHCDF_PivaCatDr=:PHCDFPivaCatDr,
 	PHCDF_HighRisk=:HighRiskLevel,PHCDF_SingleUseFlag=:SingleUseFlag,PHCDF_Dope=:DopeFlag,PHCDF_Tumble=:TumbleFlag,
 	PHCDF_AllergyFlag=:AllergyFlag,PHCDF_DietTaboo=:DietTaboo,PHCDF_BasicDrug=:BasicDrug,PHCDF_Drugbase2=:Drugbase2,PHCDF_PDrugbase1=:PDrugbase1,
 	PHCDF_PDrugbase2=:PDrugbase2,PHCDF_OTC=:OTC,PHCDF_Codex=:Codex,PHCDF_Test=:Test,PHCDF_TpnFlag=:TpnFlag,
 	PHCDF_CQZTFlag=:CQZTFlag,PHCDF_ONEFlag=:ONEFlag,PHCDF_Spec=:PHCSpec,PHCDF_MonitorFlag=:MonitorFlag,PHCDF_OMFlag=:OMFlag
 	where PHCDF_PHCD_ParRef=:PhcdDR)
 	e  d
 	.&sql(Insert into PHC_DrgFormExt(PHCDF_PHCD_ParRef,PHCDF_DDD,PHCDF_AntibioticFlag,PHCDF_CriticalFlag,PHCDF_OPSkinTestYY,
 	PHCDF_IPSkinTestYY,PHCDF_AgeLimit,PHCDF_CalcuDose,PHCDF_PHCC_Dr,PHCDF_WHONET,PHCDF_CHPhSpecInstr,PHCDF_WHODDD,PHCDF_WHODDDUom_Dr,
 	PHCDF_ivgttSpeed,PHCDF_GranulesFact,PHCDF_ProvinceComm,PHCDF_PivaCatDr,PHCDF_HighRisk,PHCDF_SingleUseFlag,PHCDF_Dope,PHCDF_Tumble,
 	PHCDF_AllergyFlag,PHCDF_DietTaboo,PHCDF_BasicDrug,PHCDF_Drugbase2,PHCDF_PDrugbase1,PHCDF_PDrugbase2,PHCDF_OTC,PHCDF_Codex,PHCDF_Test,
 	PHCDF_TpnFlag,PHCDF_CQZTFlag,PHCDF_ONEFlag,PHCDF_Spec,PHCDF_MonitorFlag,PHCDF_OMFlag)
 	values(:PhcdDR,:DDD,:AntibioticFlag,:CriticalFlag,:OpSkin,:IpSkin,:AgeLimit,:OpOneDay,:NewCatId,:WhonetCode,:PhcSpecId,:WhoDDD,
 	:WhoDDDUom,:IvgttSpeed,:GranulesFact,:ProvinceComm,:PHCDFPivaCatDr,:HighRiskLevel,:SingleUseFlag,:DopeFlag,:TumbleFlag,
 	:AllergyFlag,:DietTaboo,:BasicDrug,:Drugbase2,:PDrugbase1,:PDrugbase2,:OTC,:Codex,:Test,:TpnFlag,:CQZTFlag,:ONEFlag,:PHCSpec,:MonitorFlag,:OMFlag
	))
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Insert:PHC_DrgFormExt",PhcDesc,SQLCODE_":"_%msg)
 	.s Err=-53   ;插入药学项扩展表失败
 	q:Err'=0 Err
 	s PhcdfeId=$P(%ROWID,$C(1))		;药学项扩展表rowid
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("PHC_DrgMast",PhcdDR)
    .s JsonStr2=##class(web.DHCST.Common.JsonObj).GetValue("PHC_DrgForm",PhcdfId)
    .s JsonStr3=##class(web.DHCST.Common.JsonObj).GetValue("PHC_DrgFormExt",PhcdfeId)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgMast","User.PHCDrgMast","药学项主表信息",PhcdDR,PhcDesc,"A",JsonStr1)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgForm","User.PHCDrgForm","药学项子表信息",PhcdfId,PhcDesc,"A",JsonStr2)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgFormExt","User.PHCDrgFormExt","药学项扩展表信息",PhcdfeId,PhcDesc,"A",JsonStr3)	
    tcommit
 	q PhcdfId   ;返回药学项子表rowid
}

/// Descript:	修改药学项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-27
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值^rowid
/// Output:		
/// Return：0,成功；错误代码
ClassMethod Update(PhcdfRowid As %String, listData As %String) As %Library.String
{
	n (PhcdfRowid,listData,%session)
 	q:listData="" 0
 	s PhcCode=$p(listData,"^",1)
 	s PhcDesc=$p(listData,"^",2)
 	s FormId=$p(listData,"^",3)
 	s BuomId=$p(listData,"^",4)
 	s InstId=$p(listData,"^",5)
 	s DuraId=$p(listData,"^",6)
 	s BQty=$p(listData,"^",7)
 	s ManfId=$p(listData,"^",8)
 	s PoisonId=$p(listData,"^",9)			;管制分类
 	s FreqId=$p(listData,"^",10)
 	s OfficalCode=$p(listData,"^",11)
 	s Generic=$p(listData,"^",12)
 	s PhcCatId=$p(listData,"^",13)
 	s PhcSubCatId=$p(listData,"^",14)
 	s PhcMinCatId=$p(listData,"^",15)
 	s EngName1=$p(listData,"^",16)			;英文国际非专利药名
 	s EngName2=$p(listData,"^",17)			;国际专利药名
 	s LabelName2=EngName1_"||"_EngName2
 	s GoodName=$p(listData,"^",18)
 	s FregenName=$p(listData,"^",19)		;制剂通用名
 	s FregenName2=$p(listData,"^",20)		;原料通用名
 	s IpOneDay=$p(listData,"^",21)			;住院一天量
 	s OpOneDay=$p(listData,"^",22)			;门诊一天量
 	s OpSkin=$p(listData,"^",23)			;门诊皮试用原液
 	s IpSkin=$p(listData,"^",24)			;住院皮试用原液
 	s DDD=$p(listData,"^",25)				;DDD值
 	s userId=$p(listData,"^",26)          	;操作人
 	s AntibioticFlag=$p(listData,"^",27)	;抗生素标志
 	s CriticalFlag=$p(listData,"^",28)		;危重药标志
 	s AgeLimit=$p(listData,"^",29)			;年龄限制
 	s NewCatId=$p(listData,"^",30)          ;多级药学分类 add by ct
    s WhonetCode=$p(listData,"^",31) 		;WHONET码
    s PhcSpecId=$p(listData,"^",32) 		;草药备注
 	s WhoDDD=$p(listData,"^",33) 			;PHCDFWhoDDD值
 	s WhoDDDUom=$p(listData,"^",34) 		;PHCDFWhoDDD单位
 	s IvgttSpeed=$p(listData,"^",35) 		;滴速
 	s GranulesFact=$p(listData,"^",36) 		;颗粒单位系数
 	s ProvinceComm=$p(listData,"^",37) 		;省属基本药物
 	s PHCDFPivaCatDr=$p(listData,"^",38)	;药品配液分类
 	s HighRiskLevel=$p(listData,"^",39)		;高危级别
 	s SingleUseFlag=$p(listData,"^",40)		;单味使用标识
 	s AllergyFlag=$p(listData,"^",41)		;过敏
 	s DietTaboo=$p(listData,"^",42)			;饮食禁忌
 	s TumbleFlag=$p(listData,"^",43)		;跌倒风险
 	s DopeFlag=$p(listData,"^",44)	  		;兴奋剂
 	s BasicDrug=$p(listData,"^",45)			;国家基本药物
 	s Drugbase2=$p(listData,"^",46)			;省基本药物
 	s PDrugbase1=$p(listData,"^",47)		;市基本药物
 	s PDrugbase2=$p(listData,"^",48)		;区县基本药物
 	s OTC=$p(listData,"^",49)				;非处方标志
 	s Codex=$p(listData,"^",50)				;中国药典标志
 	s Test=$p(listData,"^",51)				;临床验证用药标志
 	s TpnFlag=$p(listData,"^",52)			;TPN标志
	s CQZTFlag=$p(listData,"^",53)			;长期默认嘱托
	s ONEFlag=$p(listData,"^",54)			;临时默认取药
	s PHCSpec=$p(listData,"^",55)			;含量规格
	s MonitorFlag=$p(listData,"^",56)		;重点监控标志
	s OMFlag=$p(listData,"^",57)			;附加说明默认自备
 	s Date=$p($h,",",1)
 	S Time=$p($h,",",2)
  	s Err=0
 	;更新药学项主表
 	s PhcdRowid=+PhcdfRowid
 	s $p(^PHCD(PhcdRowid,3),"^",3)=userId
 	s OldJsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("Phc_DrgMast",PhcdRowid)
 	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	&sql(Update Phc_DrgMast set PHCD_Code=:PhcCode,PHCD_Name=:PhcDesc,PHCD_PHCSC_DR=:PhcSubCatId,
 	PHCD_PHCPO_DR=:PoisonId,PHCD_PHMNF_DR=:ManfId,PHCD_LabelName1=:GoodName,
 	PHCD_LabelName2=:LabelName2,PHCD_Generic_DR=:Generic,PHCD_OfficialCode=:OfficalCode,
 	PHCD_MinSubCat_DR=:PhcMinCatId,PHCD_UpdateDate=:Date,PHCD_UpdateTime=:Time
 	 Where PHCD_Rowid=:PhcdRowid)
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:Phc_DrgMast",PhcdRowid,SQLCODE_":"_%msg)
 	.s Err=-51   ;更新药学项主表失败
 	q:Err'=0 Err
 	s OldJsonStr2=##class(web.DHCST.Common.JsonObj).GetValue("Phc_DrgForm",PhcdfRowid)
 	;更新药学项子表
 	s NameStr=FregenName_"||"_FregenName2
 	&sql(Update Phc_DrgForm set PHCDF_PHCF_DR=:FormId,PHCDF_PHCFR_DR=:FreqId,PHCDF_PHCIN_DR=:InstId,
 	PHCDF_PHCDU_DR=:DuraId,PHCDF_CTUOM_DR=:BuomId,PHCDF_BaseQty=:BQty,PHCDF_DeductPartially=:IpOneDay,
 	PHCDF_OfficialCode=:NameStr where PHCDF_Rowid=:PhcdfRowid)
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:Phc_DrgForm",PhcdfRowid,SQLCODE_":"_%msg)
 	.s Err=-52   ;更新药学项子表失败
 	s OldJsonStr3=##class(web.DHCST.Common.JsonObj).GetValue("PHC_DrgFormExt",PhcdfRowid)
 	q:Err'=0 Err
 	 ;更新DDD值抗生素标志等内容
 	&sql(Update  PHC_DrgFormExt 
 		set PHCDF_DDD=:DDD,PHCDF_AntibioticFlag=:AntibioticFlag,PHCDF_CriticalFlag=:CriticalFlag,
 		PHCDF_OPSkinTestYY=:OpSkin,PHCDF_IPSkinTestYY=:IpSkin,PHCDF_AgeLimit=:AgeLimit,
 		PHCDF_CalcuDose=:OpOneDay,PHCDF_PHCC_Dr=:NewCatId,PHCDF_WHONET=:WhonetCode,
 		PHCDF_CHPhSpecInstr=:PhcSpecId,PHCDF_WHODDD=:WhoDDD,PHCDF_WHODDDUom_Dr=:WhoDDDUom,
 		PHCDF_ivgttSpeed=:IvgttSpeed,PHCDF_GranulesFact=:GranulesFact,PHCDF_ProvinceComm=:ProvinceComm,
 		PHCDF_PivaCatDr=:PHCDFPivaCatDr,PHCDF_HighRisk=:HighRiskLevel,PHCDF_SingleUseFlag=:SingleUseFlag,
 		PHCDF_Dope=:DopeFlag,PHCDF_Tumble=:TumbleFlag,PHCDF_AllergyFlag=:AllergyFlag,PHCDF_DietTaboo=:DietTaboo,
 		PHCDF_BasicDrug=:BasicDrug,PHCDF_Drugbase2=:Drugbase2,PHCDF_PDrugbase1=:PDrugbase1,
 		PHCDF_PDrugbase2=:PDrugbase2,PHCDF_OTC=:OTC,PHCDF_Codex=:Codex,PHCDF_Test=:Test,PHCDF_TpnFlag=:TpnFlag,
 		PHCDF_CQZTFlag=:CQZTFlag,PHCDF_ONEFlag=:ONEFlag,PHCDF_Spec=:PHCSpec,PHCDF_MonitorFlag=:MonitorFlag,  
 		PHCDF_OMFlag=:OMFlag
 		where PHCDF_PHCD_ParRef=:PhcdRowid)
	i SQLCODE'=0 d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Update:PHC_DrgFormExt",PhcDesc,SQLCODE_":"_%msg)
 	.s Err=-53 ;更新药学项扩展表失败
 	q:Err'=0 Err
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("Phc_DrgMast",PhcdRowid)
    .s JsonStr2=##class(web.DHCST.Common.JsonObj).GetValue("Phc_DrgForm",PhcdfRowid)
    .s JsonStr3=##class(web.DHCST.Common.JsonObj).GetValue("PHC_DrgFormExt",PhcdfRowid)
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgMast","User.PHCDrgMast","药学项主表信息",PhcdRowid,PhcDesc,"U",JsonStr1,OldJsonStr1)
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgForm","User.PHCDrgForm","药学项子表信息",PhcdfRowid,PhcDesc,"U",JsonStr2,OldJsonStr2)
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgFormExt","User.PHCDrgFormExt","药学项扩展表信息",PhcdfRowid,PhcDesc,"U",JsonStr3,OldJsonStr3)
 	tc
 	q 0
}

/// Descript:	删除药学项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-28
/// Table:
/// Input:药学项子表rowid
/// Output:		
/// Return：0，成功；
/// -51   ;删除药学项失败
ClassMethod Delete(PhcdfRowid) As %Library.String
{
	n (PhcdfRowid,%session)
	q:PhcdfRowid="" 0
	s Phcd=+PhcdfRowid
	s Chl=$p(PhcdfRowid,"||",2)
	q:'$d(^PHCD(Phcd)) 0
	s Err=0
	&sql(SELECT PHCD_Code, PHCD_Name into :PhcCode,:PhcDesc FROM PHC_DrgMast WHERE PHCD_Rowid=:Phcd)
    s JsonStr="{药品代码:"""_PhcCode_""",药品名称:"""_PhcDesc_"""}"
 	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	;删除药学项
 	&sql(Delete From PHC_DrgMast where PHCD_Rowid=:Phcd)
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("Delete:PHC_DrgMast",Phcd,SQLCODE_":"_%msg)
 	.s Err=-51   ;删除药学项失败
 	q:Err'=0 Err
 	;删除global
 	k ^PHCD(Phcd,"DF",Chl,"DHC")
  	s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgMast","User.PHCDrgMast","药学项主表信息",Phcd,PhcCode,"D",JsonStr)
	tcommit			
 	q 0
}

/// Descript:	查询药学项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-23
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:药学子表rowid
/// Output:		
/// Return：代码^描述^剂型id^剂型^基本单位id^基本单位^用法id^用法^疗程id^疗程^基本数量^产地id^产地
/// ^管制分类id^管制分类^频次id^频次^医保类别^处方通用名id^处方通用名^药学分类id^药学分类^药学子类id^药学子类^
/// 药学小类id^药学小类^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值^抗生素标志^危重药标志^附加说明默认自备
/// w ##class(web.DHCST.PHCDRGMAST).Select("858||1")
ClassMethod Select(PhcdfId) As %Library.String
{
	n (PhcdfId)
	q:PhcdfId="" ""
	s Phcd=+PhcdfId
	s Chl=$p(PhcdfId,"||",2)
	q:Phcd="" ""
	q:Chl="" ""
	q:'$d(^PHCD(Phcd,"DF",Chl)) ""
	;
	s PhcCode=$p(^PHCD(Phcd,1),"^",1)
	s PhcDesc=$p(^PHCD(Phcd,1),"^",2)
	s PhcDesc=##class(web.DHCSTEXTCOMMON).GetValue(PhcDesc)
	s FormId=$p($g(^PHCD(Phcd,"DF",Chl,1)),"^",1)
	s BuomId=$p($g(^PHCD(Phcd,"DF",Chl,2)),"^",4)
	s InstrId=$p($g(^PHCD(Phcd,"DF",Chl,1)),"^",5)
	s DuraId=$p($g(^PHCD(Phcd,"DF",Chl,1)),"^",8)
	s BQty=$p(^PHCD(Phcd,"DF",Chl,2),"^",5)
	s ManfId=$p(^PHCD(Phcd,2),"^",4)
	s PoisonId=$p(^PHCD(Phcd,1),"^",4)
	s FreqId=$p($g(^PHCD(Phcd,"DF",Chl,1)),"^",4)
	s OfficeCode=$p($g(^PHCD(Phcd,4)),"^",2)		;医保类别
	s GenericId=$p($g(^PHCD(Phcd,4)),"^",1)
	s PhcSubCatId=$p(^PHCD(Phcd,1),"^",3)
	s PhcMinCatId=$p(^PHCD(Phcd,1),"^",6)
	s LabelName2=$p(^PHCD(Phcd,2),"^",8)
	s EngName1=$p(LabelName2,"||",1)		;英文国际非专利药名
	s EngName2=$p(LabelName2,"||",2)		;英文国际专利药名
	s GoodsName=$p(^PHCD(Phcd,2),"^",7)		;商品名
	s GenName=$p(^PHCD(Phcd,"DF",Chl,3),"^",4)
	s GenName1=$p(GenName,"||",1)			;制剂通用名
	s GenName2=$p(GenName,"||",2)			;原料通用名
	s IpOneDay=$p($g(^PHCD(Phcd,"DF",Chl,2)),"^",6)		;住院按一天量计算
	s OpOneDay=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",1)	;门诊按一天量计算
	s OpSkin=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",2)		;门诊皮试用原液
	s IpSkin=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",3)		;住院皮试用原液
	s DDD=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",5)			;DDD值
	s AntibioticFlag=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",8)			;抗生素标志
	s CriticalFlag=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",9)			;危重药标志
	s AgeLimit=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",4)				;年龄限制
	s NewCatId=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",20)           ;多级药学分类
	i (NewCatId'="")&&('$d(^DHCPHCC(NewCatId))) s NewCatId=""
	s NewCatDesc=##class(web.DHCST.DHCSTPHCCATMAINTAIN).GetAllPhcCat(NewCatId,"")
	s WhonetCode=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",10) ;WHONET码
	S PhcSpecId=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",7) ;草药备注
	//add wyx 2014-12-03
	S WhoDDD=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",11)
	S WhoDDDUom=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",12)
	S IvgttSpeed=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",13)
	S GranulesFact=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",14)
	S ProvinceComm=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",15)
	s EQ=$o(^PHCD(Phcd,"DF",Chl,"EQ",0))
	i EQ'=""  d
	.s DoseQty=$p(^PHCD(Phcd,"DF",Chl,"EQ",EQ),"^",2)
	.s DoseUomId=$p(^PHCD(Phcd,"DF",Chl,"EQ",EQ),"^",1)
	.s:DoseUomId'="" DoseUomDesc=$p(^CT("UOM",DoseUomId),"^",2)
	s:FormId'="" FormDesc=$p(^PHCF(FormId),"^",2)
	s:BuomId'="" BuomDesc=$p($g(^CT("UOM",BuomId)),"^",2)
	s:InstrId'="" InstDesc=$p($g(^PHCIN(InstrId)),"^",2)
	s:DuraId'="" DuraDesc=$p($g(^PHCDU(DuraId)),"^",1)
	s:ManfId'="" ManfDesc=$p($g(^PHMNF(ManfId)),"^",2)
	s:PoisonId'="" PoisonDesc=$p($g(^PHCPO(PoisonId)),"^",2)
	s:FreqId'="" FreqDesc=$p($g(^PHCFR(FreqId)),"^",3)
	s:GenericId'="" GenericDesc=$p($g(^PHCGE("GE",GenericId)),"^",2)
	s PhcCatId=+PhcSubCatId
	//s:PhcCatId'="" PhcCatDesc=$p($g(^PHCC(PhcCatId)),"^",2)
	s Sub=$p(PhcSubCatId,"||",2)
	s:Sub="" PhcSubCatId=""
	//s:(PhcCatId'="")&(Sub'="") PhcSubCatDesc=$p($g(^PHCC(PhcCatId,"SC",Sub)),"^",2)
	s Min=$p(PhcMinCatId,"||",3)
	//s:(PhcCatId'="")&(Sub'="")&(Min'="") PhcMinCatDesc=$p($g(^PHCC(PhcCatId,"SC",Sub,"MIN",Min)),"^",2)	
	s PhcCatDesc="",PhcSubCatDesc="",PhcMinCatDesc=""
	s SpecInstr=""
	i PhcSpecId'=""  d
	.s list = ^DHCDocConfig("CNMedItemPhSpecInstr")
	.s list = $tr(list,$c(1),"-")
	.s i = 1
	.f  s id=$P(list, "^", i) q:(id="")!(SpecInstr'="")  d
	..s desc=$p(id,"-",2)
	..s id=$p(id,"-",1)
	..s i = i+1
	..q:id'=PhcSpecId
	..s SpecInstr=desc
	s WhoDDDUomDesc=""
	s:WhoDDDUom'="" WhoDDDUomDesc=$p(^CT("UOM",WhoDDDUom),"^",2)       
	s NewPhcPoisonStr=""
	s phcdmpolid=0                             //新增多级管制分类
	f  s phcdmpolid=$o(^PHCDMPOL(0,"DMPOISON",Phcd,phcdmpolid)) q:phcdmpolid=""  d
	.s phcdmpodr=$p(^PHCDMPOL(phcdmpolid),"^",2)
	.s newpoisondesc=$p(^PHCPO(phcdmpodr),"^",2)
	.i NewPhcPoisonStr="" d
	..s NewPhcPoisonStr=newpoisondesc
	.e  d
	..s NewPhcPoisonStr=NewPhcPoisonStr_";"_newpoisondesc
	s PHCDFPivaCatDr=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",24)  ;药品配液分类
	s PHCDFPivaCat=$s(PHCDFPivaCatDr'="":$p($g(^PHCPIVACAT(PHCDFPivaCatDr)),"^",2),1:"")  
	s HighRiskLevel=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",19)	;高危级别
 	s SingleUseFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",22)	;单味使用标识
 	s AllergyFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",28)		;过敏
 	s DietTaboo=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",29)		;饮食禁忌
 	s TumbleFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",26)		;跌倒风险
 	s DopeFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",27)	  	;兴奋剂 
    s BasicDrug=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",31)		;国家基本药物
 	s Drugbase2=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",32)		;省基本药物
 	s PDrugbase1=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",33)		;市基本药物
 	s PDrugbase2=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",34)		;区县基本药物
 	s OTC=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",35)				;非处方标志
 	s Codex=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",36)			;中国药典标志
 	s Test=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",37)			;临床验证用药标志
 	s TpnFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",38)			;TPN标志
 	s CQZTFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",40)		;长期默认嘱托	
 	s OneFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",41)			;临时默认取药
 	s PhcSpec=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",43)			;含量规格
 	s MonitorFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",39)		;重点监控标记 psc 2018/05/22
	s OMFlag=$p($g(^PHCD(Phcd,"DF",Chl,"DHC",2)),"^",2)			;附加说明默认自备
	s Data1=PhcCode_"^"_PhcDesc_"^"_FormId_"^"_$g(FormDesc)_"^"_BuomId_"^"_$g(BuomDesc)_"^"_InstrId //7
	s Data2=$g(InstDesc)_"^"_DuraId_"^"_$g(DuraDesc)_"^"_BQty_"^"_ManfId_"^"_$g(ManfDesc)_"^"_PoisonId //14
	s Data3=$g(PoisonDesc)_"^"_FreqId_"^"_$g(FreqDesc)_"^"_OfficeCode_"^"_GenericId_"^"_$g(GenericDesc) //20
	s Data4=PhcCatId_"^"_$g(PhcCatDesc)_"^"_PhcSubCatId_"^"_$g(PhcSubCatDesc)_"^"_PhcMinCatId_"^"_$g(PhcMinCatDesc) //26
	s Data5=EngName1_"^"_EngName2_"^"_GoodsName_"^"_GenName1_"^"_GenName2_"^"_IpOneDay_"^"_OpOneDay  //33
	s Data6=OpSkin_"^"_IpSkin_"^"_DDD_"^"_$g(DoseQty)_"^"_$g(DoseUomDesc)_"^"_AntibioticFlag_"^"_CriticalFlag_"^"_AgeLimit_"^"_NewCatDesc_"^"_NewCatId //43
	s Data7=WhonetCode_"^"_PhcSpecId_"^"_SpecInstr_"^"_WhoDDD_"^"_WhoDDDUom_"^"_WhoDDDUomDesc_"^"_IvgttSpeed_"^"_GranulesFact_"^"_ProvinceComm_"^"_NewPhcPoisonStr //53
	s Data8=PHCDFPivaCatDr_"^"_$g(PHCDFPivaCat)_"^"_HighRiskLevel_"^"_SingleUseFlag_"^"_AllergyFlag_"^"_DietTaboo_"^"_TumbleFlag_"^"_DopeFlag  //61
	s Data9=BasicDrug_"^"_Drugbase2_"^"_PDrugbase1_"^"_PDrugbase2_"^"_OTC_"^"_Codex_"^"_Test_"^"_TpnFlag //69
	s Data10=CQZTFlag_"^"_OneFlag_"^"_PhcSpec_"^"_MonitorFlag_"^"_OMFlag // 74
	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9_"^"_Data10
 	q Data
}

/// Descript:	查询等效数量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:库存项id
/// Output:
/// Return：等效数量表id^等效单位id^等效单位^等效数量^默认等效数量
ClassMethod QueryFormDoseEquiv(InciId) As %Library.String
{

	n (InciId)
	q:InciId="" ""
	q:'$d(^INCI(InciId)) ""
	Set Json = ##class(Code.JsonObj).%New()
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" ""
	q:Ver="" ""
	q:'$d(^ARCIM(Sub,Ver)) ""
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:PHCD="" ""
	q:DF="" ""
	s Num=0
	s EQ=0
	f  s EQ=$o(^PHCD(PHCD,"DF",DF,"EQ",EQ))  q:EQ=""  d
	.s DoseQty=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",2)
	.i DoseQty<1 s DoseQty=0_+DoseQty
	.s DoseUomId=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",1)
	.s:DoseUomId'="" DoseUomDesc=$p(^CT("UOM",DoseUomId),"^",2)
	.s DefaultDoseQty=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",3)
	.i DefaultDoseQty<1 s DefaultDoseQty=0_+DefaultDoseQty
	.s Data=PhcdfId_"||"_EQ_"^"_DoseUomId_"^"_$g(DoseUomDesc)_"^"_DoseQty_"^"_DefaultDoseQty
	.d Json.InsertRowData(Data)
	.s Num=Num+1
	.
	s DetailStr=Json.getJsonData("EQRowid^EQUomRowid^EQUom^EQQty^EQDefaultDose",Num)
 	k Json 
	q DetailStr
}

/// Descript:	更新等效单位信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:库存项id;
/// 等效数量id^等效单位id^等效数量^默认等效数量,等效数量id^等效单位id^等效数量^默认等效数量...
/// Output:
/// Return：0,成功;错误代码
ClassMethod SaveFormDoseEquiv(InciId, ListData, ArcItmId = "") As %Library.String
{
	n (InciId,ListData,%session,ArcItmId)
	s ArcimId=""
	i ArcItmId'="" s ArcimId=ArcItmId
	e  d
	.i (InciId'="")&&($d(^INCI(InciId))) s ArcimId=$p(^INCI(InciId,1),"^",3)
	q:ArcimId="" -1_"^请先保存医嘱项基本信息！"
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:(Sub="")||(Ver="")||('$d(^ARCIM(Sub,Ver))) -2_"^医嘱项未维护成功！" 
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:(PHCD="")||(DF="") -3_"^药学项未维护成功！" 
	s PhcDesc=$p(^PHCD(PHCD,1),"^",2)
	s Len=$l(ListData,",")
	s ErrData=""
	s ResultString=""
	f i=1:1:Len  d
	.s RowData=$p(ListData,",",i)
	.s EqId=$p(RowData,"^",1)
	.s EqUomId=$p(RowData,"^",2)
	.s EqQty=$p(RowData,"^",3)
	.s DefaultDoseQty=$p(RowData,"^",4)
	.// 判断重复
	.s chkExist=..CheckExistFormDoseEquiv(PhcdfId,EqId,EqUomId)
	.i $p(chkExist,"^",1)<0 s ErrData="-1^该等效单位已维护" q
	.i EqId'=""  d
	..&sql(SELECT EQ_CTUOM_DR->CTUOM_Desc, EQ_Qty, EQ_DefaultDose into :oldEQCTUOM,:oldEQQty,:oldEQDeDose FROM PHC_FormDoseEquiv WHERE EQ_Rowid=:EqId)
    ..s OldJsonStr="{药品名称:"""_PhcDesc_""",等效单位:"""_oldEQCTUOM_""",等效数量:"""_oldEQQty_""",缺省数量:"""_oldEQDeDose_"""}"
	..&sql(Update PHC_FormDoseEquiv Set EQ_CTUOM_DR=:EqUomId,
	  EQ_Qty=:EqQty,EQ_DefaultDose=:DefaultDoseQty Where EQ_Rowid=:EqId)
	..i SQLCODE'=0  d
	...s ErrData=ErrData_","_EqQty
	...s rett=$$ErrorRecord^DHCSTERROR("SaveFormDoseEquiv:Update",EqUomId,SQLCODE_":"_%msg)
	..e  d
	...&sql(SELECT EQ_CTUOM_DR->CTUOM_Desc, EQ_Qty, EQ_DefaultDose into :EQCTUOM,:EqQty,:DefaultDoseQty FROM PHC_FormDoseEquiv WHERE EQ_Rowid=:EqId)
	...s JsonStr="{药品名称:"""_PhcDesc_""",等效单位:"""_EQCTUOM_""",等效数量:"""_EqQty_""",缺省数量:"""_DefaultDoseQty_"""}"
	...s AppName="DHCSTCOMMON"
    ...s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ...i RecordTraceFlag="Y" d
 	....d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_FormDoseEquiv","User.PHCFormDoseEquiv","等效单位表信息",EqId,PhcDesc,"U",JsonStr,OldJsonStr)
	.e  d
	..;保存等效单位
	..&sql(INSERT INTO PHC_FormDoseEquiv(EQ_ParRef,EQ_CTUOM_DR,EQ_Qty,EQ_DefaultDose)
	 VALUES (:PhcdfId,:EqUomId,:EqQty,:DefaultDoseQty))
	..i SQLCODE'=0  d
 	...s ErrData=ErrData_","_EqQty
 	...s rett=$$ErrorRecord^DHCSTERROR("SaveFormDoseEquiv:Insert",EqUomId,SQLCODE_":"_%msg)
 	..e  d
 	...s EqId=$P(%ROWID,$C(1))
    ...&sql(SELECT EQ_CTUOM_DR->CTUOM_Desc, EQ_Qty, EQ_DefaultDose into :EQCTUOM,:EqQty,:DefaultDoseQty FROM PHC_FormDoseEquiv WHERE EQ_Rowid=:EqId)
	...s JsonStr="{药品名称:"""_PhcDesc_""",等效单位:"""_EQCTUOM_""",等效数量:"""_EqQty_""",缺省数量:"""_DefaultDoseQty_"""}"
	...s AppName="DHCSTCOMMON"
    ...s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ...i RecordTraceFlag="Y" d
    ....d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_FormDoseEquiv","User.PHCFormDoseEquiv","等效单位表信息",EqId,PhcDesc,"A",JsonStr)
 	q:ErrData'="" ErrData 
 	q 0
}

/// Descript:	删除等效数量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:等效数量表id
/// Output:
/// Return：0,成功;错误代码
/// w ##class(web.DHCST.PHCDRGMAST).DeleteFormDoseEquiv("858||1||4")
ClassMethod DeleteFormDoseEquiv(EqRowid) As %Library.String
{
	n (EqRowid,%session)
	q:EqRowid="" -1
	s PhcDesc=$p($g(^PHCD(+EqRowid,1)),"^",2)	 
	&sql(SELECT EQ_CTUOM_DR->CTUOM_Desc, EQ_Qty, EQ_DefaultDose into :EQCTUOM,:EqQty,:DefaultDoseQty FROM PHC_FormDoseEquiv WHERE EQ_Rowid=:EqRowid)
	s JsonStr="{药品名称:"""_PhcDesc_""",等效单位:"""_EQCTUOM_""",等效数量:"""_EqQty_""",缺省数量:"""_DefaultDoseQty_"""}"
	&sql(Delete From PHC_FormDoseEquiv Where EQ_Rowid=:EqRowid)
	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("DeleteFormDoseEquiv:",EqRowid,SQLCODE_":"_%msg)
 	e  d
 	.s AppName="DHCSTCOMMON"
    .s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    .i RecordTraceFlag="Y" d
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_FormDoseEquiv","User.PHCFormDoseEquiv","等效单位表信息",EqRowid,EqRowid,"D",JsonStr)
 	q SQLCODE
}

/// Descript:   查询所有的抗菌药物
/// Creater:	hulihua
/// CreateDate:	2014-09-18(九一八事变日)
/// Table:      CT_Antibiotics,DHC_Antibiotics
/// Input:
/// Output:		
/// Return：    抗菌药物WHONET码,中文名称,英文名称
/// W ##class(web.DHCST.PHCDRGMAST).GetWhonetInfo("0","85","")
ClassMethod GetWhonetInfo(Start As %String, Limit As %String, Input As %String) As %String
{
	n (Start,Limit,Input)
	s $zt="ErrorGetWhonetInfo"
	q:$d(^DHCLISBSVersion(1)) ..GetWhonetInfoDHCLIS(Start,Limit,Input) //新检验取whonet
	s end = Start+Limit
	s Input=$$ALPHAUP^SSUTIL4(Input)
	s count = 0
    s resultString = ""
    s json = ##class(Code.JsonObj).%New()
    s LabData="labdata"
    s wCode="" f  s wCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode)) q:wCode=""  d
    .s antCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode,"")) q:antCode=""
    .s antCode1=$$ALPHAUP^SSUTIL4($tr(antCode,$c(13,10),""))
    .i Input'="" Q:antCode1'[Input
    .s antName=$p(^[LabData]TTAB("ANT",antCode),"\",1) q:antName=""
    .s antName=$tr(antName,$c(13,10),"")
    .s antName=$Replace(antName,"'","-")
    .s antEName=$p(^[LabData]DHCANTIBIOTICS(antCode),"\",1)
    .s antEName=$tr(antEName,$c(13,10),"")
	.s Data=antCode_"^"_antName_"^"_antEName
	.s count = count+1
	.i (count>Start)&(count<=end) d
	..d json.InsertRowData(Data)
	s Title="AntCode^AntName^AntEName"
	if count>0 d
    .s resultString = json.getJsonData(Title,count)
    k json
    q resultString
ErrorGetWhonetInfo
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// Descript:	查询管制分类
/// Creater:	caoting
/// CreateDate:	2015-03-20
/// Table:PHC_DMPoisonLink
/// Input:库存项id
/// Output:
/// Return：管制分类id^管制分类^关联表id
ClassMethod QueryPHCPoison(InciId) As %Library.String
{

	n (InciId)
	q:InciId="" ""
	q:'$d(^INCI(InciId)) ""
	Set Json = ##class(Code.JsonObj).%New()
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" ""
	q:Ver="" ""
	q:'$d(^ARCIM(Sub,Ver)) ""
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:PHCD="" ""
	q:DF="" ""
	s Num=0
	s phcdmpolid=0
	f  s phcdmpolid=$o(^PHCDMPOL(0,"DMPOISON",PHCD,phcdmpolid)) q:phcdmpolid=""  d
	.s phcdmpodr=$p(^PHCDMPOL(phcdmpolid),"^",2)
	.s poisondesc=$p(^PHCPO(phcdmpodr),"^",2)
	.s Data=phcdmpodr_"^"_poisondesc_"^"_phcdmpolid
	.d Json.InsertRowData(Data)
	.s Num=Num+1
	.
	s DetailStr=Json.getJsonData("PoDr^PoDesc^PoLinkRowid",Num)
 	k Json 
	q DetailStr
}

/// Descript:	更新管制分类
/// Creater:	caoting
/// CreateDate:	2015-03-20
/// Table:PHC_DMPoisonLink
/// Input:库存项id;
/// 
/// Output:
/// Return：0,成功;错误代码
ClassMethod SavePHCPoison(InciId, ListData) As %Library.String
{
	n (InciId,ListData)
	q:InciId="" -1
	q:'$d(^INCI(InciId)) -1
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" -2 
	q:Ver="" -2
	q:'$d(^ARCIM(Sub,Ver)) -2
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:PHCD="" -3 
	q:DF="" -3
	;
	s Len=$l(ListData,",")
	s ErrData=""
	s ResultString=""
	f i=1:1:Len  d
	.s RowData=$p(ListData,",",i)
	.s PoRowid=$p(RowData,"^",1)
	.s PhcPoisonDr=$p(RowData,"^",2)
	.
	.i PoRowid'=""  d
	..&sql(Update PHC_DMPoisonLink Set PHCDML_PHCPO_DR=:PhcPoisonDr Where PHC_DMPOLink_RowID=:PoRowid)
	..i SQLCODE'=0  d
	...s ErrData=ErrData_","_PhcPoisonDr
	...s rett=$$ErrorRecord^DHCSTERROR("SavePhcPoisonLink:Update",PoRowid,SQLCODE_":"_%msg)
	.e  d
	..;保存
	..&sql(INSERT INTO PHC_DMPoisonLink(PHCDML_DRGMAST_DR,PHCDML_PHCPO_DR)
	 VALUES (:PHCD,:PhcPoisonDr))
	..i SQLCODE'=0  d
 	...s ErrData=PhcPoisonDr
 	...s rett=$$ErrorRecord^DHCSTERROR("SavePhcPoisonLink:Insert",PhcPoisonDr,SQLCODE_":"_%msg)
 	..
 	.
 	q:ErrData'="" ErrData 
 	q 0
}

/// Descript:	删除管制分类
/// Creater:	caoting
/// CreateDate:	2015-03-20
/// Table:PHC_DMPoisonLink
/// Input:关联表id
/// Output:
/// Return：0,成功;错误代码
ClassMethod DeletePHCPoison(PoRowid) As %Library.String
{
	n (PoRowid)
	q:PoRowid="" -1 
	;
	&sql(Delete From PHC_DMPoisonLink Where PHC_DMPOLink_RowID=:PoRowid)
	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("DeletePhcPoisonLink:",PoRowid,SQLCODE_":"_%msg)
 	.
 	q SQLCODE
}

/// Descript:	查询管制分类
/// Creater:	caoting
/// CreateDate:	2015-03-20
/// Table:PHC_DMPoisonLink
/// Input:库存项id
/// Output:
/// Return：管制分类id^管制分类id
ClassMethod GetPoisonByInci(InciId) As %Library.String
{

	n (InciId)
	q:InciId="" ""
	q:'$d(^INCI(InciId)) ""
	Set Json = ##class(Code.JsonObj).%New()
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" ""
	q:Ver="" ""
	q:'$d(^ARCIM(Sub,Ver)) ""
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	q:PHCD="" ""
	q:DF="" ""
	s Num=0
	s podrstr=""
	s phcdmpolid=0
	f  s phcdmpolid=$o(^PHCDMPOL(0,"DMPOISON",PHCD,phcdmpolid)) q:phcdmpolid=""  d
	.s phcdmpodr=$p(^PHCDMPOL(phcdmpolid),"^",2)
	.s poisondesc=$p(^PHCPO(phcdmpodr),"^",2)
	.i podrstr="" d
	..s podrstr=phcdmpodr
	.e  d
	..s podrstr=podrstr_"^"_phcdmpodr
	.s Num=Num+1
	
 	q podrstr
}

/// 原有管制分类信息导入新增关联表中
ClassMethod ImpPHCPoisonInfo() As %String
{
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:'$d(^INCI(inci,1))
	.s ArcimId=$p(^INCI(inci,1),"^",3)
	.s Sub=+ArcimId
	.s Ver=$p(ArcimId,"||",2)
	.q:Sub=""
	.q:Ver=""
	.q:'$d(^ARCIM(Sub,Ver))
	.s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	.s PHCD=+PhcdfId
	.q:(PHCD="")||(PHCD=0)
	.s PoisonId=$p(^PHCD(PHCD,1),"^",4)
	.q:PoisonId=""
	.&sql(INSERT INTO PHC_DMPoisonLink(PHCDML_DRGMAST_DR,PHCDML_PHCPO_DR)
	 VALUES (:PHCD,:PoisonId))
	 q 0
}

/// creator:yunhaibao
/// createdate:20151013
/// description:获取默认等效单位信息
/// w ##class(web.DHCST.PHCDRGMAST).GetDefaultDoseEquiv(8936)
ClassMethod GetDefaultDoseEquiv(InciId)
{
	n (InciId)
	q:InciId="" ""
	q:'$d(^INCI(InciId)) ""
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" "" 
	q:Ver="" ""
	q:'$d(^ARCIM(Sub,Ver)) ""
	s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
	s PHCD=+PhcdfId
	s DF=$p(PhcdfId,"||",2)
	s DoseQty="",DoseUomDesc=""
	s EQ=$o(^PHCD(PHCD,"DF",DF,"EQ",0))
	i EQ'=""  d
	.s DoseQty=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",2)
	.s DoseUomId=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",1)
	.s:DoseUomId'="" DoseUomDesc=$p(^CT("UOM",DoseUomId),"^",2)
	q DoseQty_"^"_DoseUomDesc
}

/// creator:yunhaibao
/// createdate:20160408
/// description:WhoDDD值+WhoDDD单位转换为基本单位对应的DDD值
/// input:药学项代码,whoDDD,whoDDD单位
ClassMethod GetBUomDDD(phcdCode, WHODDD, WHODDUomId)
{
 n (phcdCode,WHODDD,WHODDUomId)
 s phcdCode=$$ALPHAUP^SSUTIL4(phcdCode)
 q:phcdCode="" ""
 q:WHODDD="" ""
 q:WHODDUomId="" ""
 s phcdID=$o(^PHCD(0,"Code",phcdCode,""))
 s phcdSub=0,RetDDD=""
 f  s phcdSub=$o(^PHCD(phcdID,"DF",phcdSub)) q:(phcdSub="")!(RetDDD'="")  d
 .s buomID=$p(^PHCD(phcdID,"DF",phcdSub,2),"^",4)
 .q:buomID=""
 .i WHODDUomId=buomID d
 ..s RetDDD=WHODDD
 .q:RetDDD'=""
 .s bqty=+$p(^PHCD(phcdID,"DF",phcdSub,2),"^",5)
 .q:bqty=0
 .s eqSub="0"
 .f  s eqSub=$o(^PHCD(phcdID,"DF",phcdSub,"EQ",eqSub)) q:(eqSub="")!(RetDDD'="")  d
 ..s eqStr=^PHCD(phcdID,"DF",phcdSub,"EQ",eqSub)
 ..s uomID=$p(eqStr,"^",1)
 ..q:uomID=""
 ..i WHODDUomId=uomID d
 ...s eqQty=+$p(eqStr,"^",2)
 ...q:eqQty=0
 ...s RetDDD=WHODDD/eqQty*bqty
 q RetDDD
}

/// desc:	dhc-lisdata版本获取检验whonet码数据
/// others: w ##class(web.DHCST.PHCDRGMAST).GetWhonetInfoDHCLIS(1,30,"")
ClassMethod GetWhonetInfoDHCLIS(Start As %String, Limit As %String, Input As %String) As %String
{
	n (Start,Limit,Input)
	s end = Start+Limit
	s Input=$$ALPHAUP^SSUTIL4(Input)
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s LabData="dhc-lisdata"
	s wCode="" f  s wCode=$o(^[LabData]dbo.BTAntibioticsI("IndexWCode",wCode)) q:wCode=""  d
	.s AntibioticsDR=$o(^[LabData]dbo.BTAntibioticsI("IndexWCode",wCode,""))
	.i '$l(AntibioticsDR) q
	.s AntibioticsData=$g(^[LabData]dbo.BTAntibioticsD(AntibioticsDR))
	.s antCode=$lg(AntibioticsData,6)
	.s antName=$lg(AntibioticsData,3)
	.s antEName=$lg(AntibioticsData,4)
	.s Data=antCode_"^"_antName_"^"_antEName
	.s count = count+1
	.i (count>Start)&(count<=end) d
	..d json.InsertRowData(Data)
	s Title="AntCode^AntName^AntEName"
	if count>0 d
	.s resultString = json.getJsonData(Title,count)
	k json
	q resultString
}

/// desc:	dhc-lisdata版本验证检验whonet码数据
/// others: w ##class(web.DHCST.PHCDRGMAST).CheckWhonetInfoDHCLIS("AMB")
/// return:	-79 无效的whonet码
ClassMethod CheckWhonetInfoDHCLIS(InputWhoNetCode As %String) As %String
{
	n (InputWhoNetCode)
	q:InputWhoNetCode="" ""
	s WhonetFlag="",ResultString=""
	i $d(^DHCLISBSVersion(1)) d //dhc-lisdata
	.s InputWhoNetCode=" "_InputWhoNetCode  //该索引首字符为空格
	.s LabData="dhc-lisdata"
	.i '$d(^[LabData]dbo.BTAntibioticsI("IndexWCode",InputWhoNetCode)) s ResultString=-79
	e  d //labtrak
 	.s LabData="labdata"
    .s wCode="" f  s wCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode)) q:wCode=""  d
    ..s antCode=$o(^[LabData]DHCANTIBIOTICSi("WHO",wCode,"")) q:(antCode="")!(WhonetFlag'="")
    ..s ResultString=-79
    ..q:InputWhoNetCode'=antCode
 	..s ResultString="",WhonetFlag=1
 	q ResultString
}

/// creator:    yunhaibao
/// createdate: 2017-06-28
/// description:根据医嘱项ID查询药学项相关信息,用于药品维护初始化显示
/// input:		strParams(医嘱项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.PHCDRGMAST","QueryPhcByArcim","858||1")
Query QueryPhcByArcim(strParams = "") As websys.Query(ROWSPEC = "cmbPhcBaseUom,cmbPhcForm,cmbPhcInstruc,cmbPhcDuration,cmbPhcFreq,cmbOfficialType,cmbPhcPoison,cmbPhcSpec,txtPhcLabelName1,cmbPhcManf,txtWhoDDD,cmbWhoDDDUom,txtDDD,txtGranulesFact,txtIvgttSpeed,cmbHighRisk,txtPhcLabelName12,txtPhcLabelName11,chkPhcAnti,chkPhcCritical,chkProvinceComm,chkOPSkin,chkIPSkin,chkOPOneDay,chkIPOneDay,chkPhcSingleUse,chkDietTaboo,chkPhcTumble,chkDope,chkAllergy,cmbPhcPivaCat,cmbWhoNetCode,chkBaseDrug,chkProBaseDrug,chkCityBaseDrug,chkCouBaseDrug,cmbPhcOTC,chkCodeX,chkPhcTest,chkTPN,txtPhcSpec,chkMonitorFlag,chkCQZT,chkONE,cmbGeneric,chkOM")
{
}

ClassMethod QueryPhcByArcimExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmRowId=$p(strParams,"^",1)
	q:arcItmRowId="" $$$OK
	s phcdfRowId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcItmRowId)
	q:+phcdfRowId=0 $$$OK
	s phcdData=..Select(phcdfRowId)
	/// 基本单位
	s phcBaseUom=$p(phcdData,"^",5)
	/// 剂型
	s phcForm=$p(phcdData,"^",3)
	/// 用法
	s phcInstruc=$p(phcdData,"^",7)
	/// 疗程
	s phcDuration=$p(phcdData,"^",9)
	/// 频次
	s phcFreq=$p(phcdData,"^",16)
	/// 医保类别
	s officialType=$p(phcdData,"^",18)
	/// 管制分类
	s phcPoison=$p(phcdData,"^",14)
	/// 草药备注
	s phcSpecIns=$p(phcdData,"^",45)
	/// 商品名
	s phcLabelName1=$p(phcdData,"^",29)
	/// 厂商
	s phcManf=$p(phcdData,"^",12)
	/// WHODDD
	s whoDDD=$p(phcdData,"^",47)
	/// WHODDD单位
	s whoDDDUom=$p(phcdData,"^",48)
	/// DDD
	s DDD=$p(phcdData,"^",36)
	/// 颗粒单位系数
	s granulesFact=$p(phcdData,"^",51)
	/// 滴速
	s ivgttSpeed=$p(phcdData,"^",50)
	/// 高危级别
	s highRiskLevel=$p(phcdData,"^",56)
	/// 国际专利药名
	s phcLabelName12=$p(phcdData,"^",28)
	/// 英文国际非专利药名
	s phcLabelName11=$p(phcdData,"^",27)
	/// 抗菌药标志
	s phcAnti=$p(phcdData,"^",39)
	/// 危重药标志
	s phcCritical=$p(phcdData,"^",40)
	/// 省属常用药物
	s provinceComm=$p(phcdData,"^",52)
	/// 门诊皮试用原液
	s opSkin=$p(phcdData,"^",34)
	/// 住院皮试用原液
	s ipSkin=$p(phcdData,"^",35)
	///门诊按一天量计算
	s opOneDay=$p(phcdData,"^",33)
	/// 住院按一天量计算
	s ipOneDay=$p(phcdData,"^",32)
	/// 单味使用标识
	s phcSingleUse=$p(phcdData,"^",57)
	/// 饮食禁忌
	s dietTaboo=$p(phcdData,"^",59)
	/// 跌倒风险
	s phcTumble=$p(phcdData,"^",60)
	/// 兴奋剂
	s dope=$p(phcdData,"^",61)
	/// 过敏
	s allergy=$p(phcdData,"^",58)
	/// 药品配液分类
	s phcPivaCat=$p(phcdData,"^",54)
	/// WhoNet码
	s whoNetCode=$p(phcdData,"^",44)
	/// 国家基本药物
    s basicDrug=$p(phcdData,"^",62)
    /// 省基本药物
 	s proBaseDrug=$p(phcdData,"^",63)
 	/// 市基本药物
	s cityBaseDrug=$p(phcdData,"^",64)
	// 区县基本药物
	s couBaseDrug=$p(phcdData,"^",65)
	/// 非处方标志
	s phcOTC=$p(phcdData,"^",66)
 	/// 中国药典标志
 	s codeX=$p(phcdData,"^",67)
 	/// 临床验证用药标志
 	s phcTest=$p(phcdData,"^",68)
 	/// TPN标志
 	s TPN=$p(phcdData,"^",69)
 	/// 含量规格
 	s phcSpec=$p(phcdData,"^",72)
 	/// 重点监控标志
 	s MonitorFlag=$p(phcdData,"^",73)	
 	/// 长期默认嘱托
	s CQZTFlag=$p(phcdData,"^",70)	
 	/// 临时默认取药
	s ONEFlag=$p(phcdData,"^",71)	
	/// 处方通用名
	s genericId=$p(phcdData,"^",19)
	/// 附加说明默认自备
	s OMFlag=$p(phcdData,"^",74)
	s Data=$lb(
		phcBaseUom,phcForm,phcInstruc,phcDuration,phcFreq,officialType,phcPoison,phcSpecIns,
		phcLabelName1,phcManf,whoDDD,whoDDDUom,DDD,granulesFact,ivgttSpeed,highRiskLevel,
		phcLabelName12,phcLabelName11,phcAnti,phcCritical,provinceComm,opSkin,ipSkin,
		opOneDay,ipOneDay,phcSingleUse,dietTaboo,phcTumble,dope,allergy,phcPivaCat,whoNetCode,
		basicDrug,proBaseDrug,cityBaseDrug,couBaseDrug,phcOTC,codeX,phcTest,TPN,phcSpec,MonitorFlag,
		CQZTFlag,ONEFlag,genericId,OMFlag
	)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// description:根据医嘱项ID查询等效单位列表
/// input:		strParams(医嘱项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.PHCDRGMAST","QueryFormDoseEquiv","533||1")
Query QueryFormDoseEquiv(strParams = "") As websys.Query(ROWSPEC = "eqRowId,doseUomId,doseUomDesc,doseQty,doseDefQty")
{
}

ClassMethod QueryFormDoseEquivExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmRowId=$p(strParams,"^",1)
	q:arcItmRowId="" $$$OK
	s phcdfRowId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcItmRowId)
	s phcdId=+phcdfRowId
	s dfId=+$p(phcdfRowId,"||",2)
	q:((phcdId=0)||(dfId=0)) $$$OK
	s eqId=""
	f  s eqId=$o(^PHCD(phcdId,"DF",dfId,"EQ",eqId))  q:eqId=""  d
	.q:+eqId=0
	.s doseQty=$p(^PHCD(phcdId,"DF",dfId,"EQ",eqId),"^",2)
	.s doseUomId=$p(^PHCD(phcdId,"DF",dfId,"EQ",eqId),"^",1)
	.s:doseUomId'="" doseUomDesc=$p(^CT("UOM",doseUomId),"^",2)
	.s doseDefQty=$p(^PHCD(phcdId,"DF",dfId,"EQ",eqId),"^",3)
	.i (doseQty'="")&&($p(doseQty,".",1)="") s doseQty=0_doseQty
	.i (doseDefQty'="")&&($p(doseDefQty,".",1)="") s doseDefQty=0_doseDefQty
	.s Data=$lb(phcdfRowId_"||"_eqId,doseUomId,doseUomDesc,doseQty,doseDefQty)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-07-03
/// description:保存药学项返回错误代码的汉字描述
/// input:		errCode
/// return:     错误信息
/// w ##class(web.DHCST.PHCDRGMAST).ErrCodeToDesc("-72")
ClassMethod ErrCodeToDesc(errCode = "")
{
	n (errCode)
	q:errCode=-61 "代码不能为空"
	q:errCode=-62 "描述不能为空"
	q:errCode=-63 "剂型不能为空"
	q:errCode=-64 "单位不能为空"
	q:errCode=-65 "用法不能为空"
	q:errCode=-51 "保存药学主表失败"
	q:errCode=-52 "插入药学主表失败"
	q:errCode=-53 "插入药学DDD等信息失败"
	q:errCode=-68 "无效的管制分类"
	q:errCode=-69 "无效的厂商"
	q:errCode=-70 "无效的通用名"
	q:errCode=-71 "无效的剂型"
	q:errCode=-72 "无效的频次"
	q:errCode=-73 "无效的用法"
	q:errCode=-74 "无效的疗程"
	q:errCode=-75 "无效的基本单位"
	q:errCode=-76 "代码已存在"
	q:errCode=-77 "名称已存在"
	q:errCode=-78 "基本数量不为有效数字(>=0)"
	q:errCode=-79 "无效的whonet码"
	q:errCode=-80 "非草药类组不能维护草药备注"
	q ""
}

/// description: 判断等效单位重复
ClassMethod CheckExistFormDoseEquiv(PhcdfId, EqId, EqUomId)
{
	n (PhcdfId,EqId,EqUomId)
	s ret=""
	i EqId="" d
	.&SQL(SELECT * FROM PHC_FormDoseEquiv WHERE EQ_ParRef=:PhcdfId AND EQ_CTUOM_DR=:EqUomId)
	.i SQLCODE=0 s ret="-1^该等效单位已存在"
	e  d
	.&SQL(SELECT * FROM PHC_FormDoseEquiv WHERE EQ_ParRef=:PhcdfId AND EQ_CTUOM_DR=:EqUomId AND EQ_RowId!=:EqId)
	.i SQLCODE=0 s ret="-1^该等效单位已存在"
	q ret
}

}
