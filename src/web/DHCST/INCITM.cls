Import sqluser

/// Descript:库存项及附加信息相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
Class web.DHCST.INCITM Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   增加库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
/// Table:INC_Itm,DHC_ItmAddionInfo
/// Input:库存项id,医嘱项rowid^代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价
/// ^价格生效日期^规格^进口标志^质量层次^处方药分类^基本药物标志^中国药典标志
/// ^临床验证用药标志^处方购药标志^质量编号^国/省别^批准文号^高值类标志^定价类型id
/// ^最高售价^存储条件^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id
/// ^招标配送商id^招标名称^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id
/// ^用药说明^基本药物标志2^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// ^高危药品标志^屏蔽库存项原因
/// Output:     
/// Return：成功:库存项rowid
/// -16:失败,医嘱项Id不能为空
/// -11:失败,库存项代码不能为空
/// -12:失败,库存项名称不能为空
/// -13:失败,基本单位不能为空
/// -14:失败,入库单位不能为空
/// -15:失败,库存分类不能为空
/// -17:失败,转移方式不能为空
/// -18:失败,是否要求批次不能为空
/// -19:失败,是否要求效期不能为空
/// -91：插入库存项失败
/// -92：插入库存项附加表失败
/// -93：插入库存项别名失败
/// -94：保存价格失败
/// -1   ;无效的库存分类
/// -3   ;无效的医嘱项
/// -4   ;无效的基本单位
/// -5   ;无效的入库单位
/// -6   ;库存项代码已经存在，不能重复
/// -7   ;库存项名称已经存在，不能重复
/// -8   ;基本单位和入库单位之间不存在转换关系
/// ##class(web.DHCST.INCITM).Save(InciId,listData,CheckArc)
ClassMethod Save(InciId As %String, listData As %String, LevelSave = "") As %Library.String
{
    n (InciId,listData,%session,LevelSave)
    q:(InciId'="")&(listData="") InciId         ;没有需要更新的内容
    ;s ^zdm("web.DHCST.INCITM.Save")=listData
    s ArcimId=$p(listData,"^",1)                ;医嘱项rowid
    q:(LevelSave="")&&(+ArcimId=0) -16
    s InciCode=$p(listData,"^",2)               ;代码
    q:InciCode="" -11
    s InciDesc=$p(listData,"^",3)               ;描述
    q:InciDesc="" -12
    s BUomId=$p(listData,"^",4)                 ;基本单位id
    q:BUomId="" -13
    s PurUomId=$p(listData,"^",5)               ;入库单位id
    q:PurUomId="" -14
    s StkCatId=$p(listData,"^",6)               ;库存分类id
    q:(LevelSave="")&&(StkCatId="") -15
    s TranFlag=$p(listData,"^",7)               ;转移方式
    q:TranFlag="" -17
    s BatFlag=$p(listData,"^",8)                ;是否要求批次
    q:BatFlag="" -18        
    s ExpireFlag=$p(listData,"^",9)             ;是否要求效期
    q:ExpireFlag="" -19
    s AliasStr=$p(listData,"^",10)              ;别名
    s NotUseFlag=$p(listData,"^",11)            ;不可用标志
    s XieHeCode=$p(listData,"^",12)             ;协和码
    s BarCode=$p(listData,"^",13)               ;条码
    s UpdateUserId=$p(listData,"^",14)          ;更新人
    s Sp=$p(listData,"^",15)
    s Rp=$p(listData,"^",16)
    s PreExeDate=$p(listData,"^",17)
    s Spec=$p(listData,"^",18)                  ;规格
    s OutPhUom=$p(listData,"^",61) 				;门诊发药单位
    s InPhUom=$p(listData,"^",62) 				;住院发药单位
    q:(LevelSave="")&&('$d(^INC("SC",StkCatId))) -1                           ;无效的库存分类
    q:(LevelSave="")&&('$d(^ARCIM(+ArcimId,$p(ArcimId,"||",2)))) -3           ;无效的医嘱项
    q:'$d(^CT("UOM",BUomId)) -4                             ;无效的基本单位            
    q:'$d(^CT("UOM",PurUomId)) -5                           ;无效的入库单位
	q:(LevelSave'="")&&('$d(^CT("UOM",OutPhUom))) -22                           ;无效的门诊发药单位
	q:(LevelSave'="")&&('$d(^CT("UOM",InPhUom))) -23                            ;无效的住院发药单位
    s TmpId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z","")) 
    q:(TmpId'="")&(TmpId'=InciId) -6                        ;库存项代码已经存在，不能重复
    s TmpId=$o(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(InciDesc),""))  
    q:(TmpId'="")&(TmpId'=InciId) -7                        ;库存项名称已经存在，不能重复         
    q:'$d(^CT("CTCF",0,"UOM",PurUomId,BUomId)) -8           ;基本单位和入库单位之间不存在转换关系     
    q:(LevelSave'="")&&(OutPhUom'=BUomId)&&('$d(^CT("CTCF",0,"UOM",OutPhUom,BUomId))) -20 
    q:(LevelSave'="")&&(InPhUom'=BUomId)&&('$d(^CT("CTCF",0,"UOM",InPhUom,BUomId))) -21  
    s TranFlag=$$ALPHAUP^SSUTIL4(TranFlag)
    s TranFlag=$s(TranFlag["TRANS":"T",TranFlag["ISSUE":"I",TranFlag["BOTH":"B",1:"")
    ;
    s BatFlag=$$ALPHAUP^SSUTIL4(BatFlag)
    s BatFlag=$s(BatFlag="REQUIRED":"R",BatFlag="OPTIONAL":"O",BatFlag="NONREQUIRED":"N",1:"")
    ;
    s ExpireFlag=$$ALPHAUP^SSUTIL4(ExpireFlag)
    s ExpireFlag=$s(ExpireFlag="REQUIRED":"R",ExpireFlag="OPTIONAL":"O",ExpireFlag="NONREQUIRED":"N",1:"")
    s UpdateDate=+$h
    s UpdateTime=$p($h,",",2)
    ;
    i InciId=""  d
    .s InciRowid=..Insert(listData)
    e  d
    .s ret=..Update(InciId,listData)
    .i ret=0  d
    ..s InciRowid=InciId 
    .e  d
    ..s InciRowid=ret
    d ..UpdArcimFromInc(InciRowid)
    q InciRowid
}

/// Descript:   增加库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
/// Table:INC_Itm,DHC_ItmAddionInfo
/// Input:医嘱项rowid^代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价
/// ^价格生效日期^规格^进口标志^质量层次^处方药分类^基本药物标志^中国药典标志
/// ^临床验证用药标志^处方购药标志^质量编号^国/省别^批准文号^高值类标志^定价类型id
/// ^最高售价^存储条件^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id
/// ^招标配送商id^招标名称^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id
/// ^用药说明^基本药物标志2^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// ^大包装单位^大包装单位系数^高危药品标志^不可用原因^医保类别;
/// Output:     
/// Return：成功:库存项rowid,
/// -91：插入库存项失败
/// -92：插入库存项附加表失败
/// -93：插入库存项别名失败
/// -94：保存价格失败
/// importFlag:导入药品数据时传1
ClassMethod Insert(listData As %String) As %Library.String
{
    n (listData,%session)
    s ArcimId=$p(listData,"^",1)                ;医嘱项rowid
    s InciCode=$p(listData,"^",2)               ;代码
    s InciDesc=$p(listData,"^",3)               ;描述
    s BUomId=$p(listData,"^",4)                 ;基本单位id
    s PurUomId=$p(listData,"^",5)               ;入库单位id
    s StkCatId=$p(listData,"^",6)               ;库存分类id
    s TranFlag=$p(listData,"^",7)               ;转移方式
    s BatFlag=$p(listData,"^",8)                ;是否要求批次 
    s ExpireFlag=$p(listData,"^",9)             ;是否要求效期
    s AliasStr=$p(listData,"^",10)              ;别名
    s NotUseFlag=$p(listData,"^",11)            ;不可用标志
    s XieHeCode=$p(listData,"^",12)             ;协和码
    s BarCode=$p(listData,"^",13)               ;条码
    s UpdateUserId=$p(listData,"^",14)          ;更新人
    s Sp=$p(listData,"^",15)
    s Rp=$p(listData,"^",16)
    s PreExeDate=$p(listData,"^",17)           ;价格生效日期
    s Spec=$p(listData,"^",18)                  ;规格
    s ImpFlag=$p(listData,"^",19)               ;进口标志
    s QualityLev=$p(listData,"^",20)            ;质量层次
    s OTC=$p(listData,"^",21)                   ;处方药分类
    s BasicDrug=$p(listData,"^",22)             ;基本药物标志
    s CodeX=$p(listData,"^",23)                 ;中国药典标志
    s TestFlag=$p(listData,"^",24)              ;临床验证用药标志
    s RecFlag=$p(listData,"^",25)               ;处方购药标志 
    s QualityNo=$p(listData,"^",26)             ;质量编号
    s ComFrom=$p(listData,"^",27)               ;国/省别
    s BatNo=$p(listData,"^",28)                 ;批准文号
    s HighPrice=$p(listData,"^",29)             ;贵重药
    s MarkTypeDr=$p(listData,"^",30)            ;定价类型id
    s MaxSp=$p(listData,"^",31)                 ;最高售价
    s StoreCon=$p(listData,"^",32)              ;存储条件
    s InHosFlag=$p(listData,"^",33)             ;本院药品目录
    s PbFlag=$p(listData,"^",34)                ;招标标志
    s PbRp=$p(listData,"^",35)                  ;招标进价
    s PbLevel=$p(listData,"^",36)               ;招标级别
    s PbVendorId=$p(listData,"^",37)            ;招标供应商id
    s PbManfId=$p(listData,"^",38)              ;招标生产商id
    s PbCarriorId=$p(listData,"^",39)           ;招标配送商id
    s PbLDr=$p(listData,"^",40)                 ;招标名称,DHC_PublicBiddingList
    s BaFlag=$p(listData,"^",41)                ;阳光采购标志
    s ExpireLen=$p(listData,"^",42)             ;效期长度
    s PrcFile=$p(listData,"^",43)               ;物价文件号
    s PrcFileDate=$p(listData,"^",44)           ;物价文件备案时间
    s SkinFlag=$p(listData,"^",45)              ;皮试标志
    s BookCatId=$p(listData,"^",46)             ;帐簿分类id
    s DrugUse=$p(listData,"^",47)               ;用药说明
    s BasicDrug2=$p(listData,"^",48)            ;基本药物标志2
    s PDrugBase1=$p(listData,"^",49)            ;省增补药物标志1
    s PDrugBase2=$p(listData,"^",50)            ;省增补药物标志2
    s StanderCode=$p(listData,"^",51)           ;药品本位码
    s InMedBasis=$p(listData,"^",52)            ;进药依据
    s PackUom=$p(listData,"^",53)               ;大包装单位
    s PackUomFac=$p(listData,"^",54)            ;大包装单位系数
    s HighRiskFlag=$p(listData,"^",55)          ;高危药品标志
    s NotUseReason=$p(listData,"^",56)          ;不可用原因
    //s InsuCat=$p(listData,"^",57)             ;医保类别 存到药学项里，wyx 2015-04-21
    s gLocId=$p(listData,"^",58)               	;科室
    s gGroupId=$p(listData,"^",59)              ;安全组
    s refRetReason=$p(listData,"^",60)          ;不可退原因
    i NotUseFlag'="Y" s NotUseReason=""  		//取消不可用后不可用原因应自动清空
    s OutPhUom=$p(listData,"^",61) 				;门诊发药单位
    s InPhUom=$p(listData,"^",62) 				;住院发药单位
    s OrdEndDate=$p(listData,"^",63) 			;医嘱截止日期
    s PhManfId=$p(listData,"^",64) 				;生产企业
    i OrdEndDate'="" s OrdEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdEndDate)
    s TranFlag=$$ALPHAUP^SSUTIL4(TranFlag)
    s TranFlag=$s(TranFlag["TRANS":"T",TranFlag["ISSUE":"I",TranFlag["BOTH":"B",1:"")
    ;
    s BatFlag=$$ALPHAUP^SSUTIL4(BatFlag)
    s BatFlag=$s(BatFlag="REQUIRED":"R",BatFlag="OPTIONAL":"O",BatFlag="NONREQUIRED":"N",1:"")
    ;
    s ExpireFlag=$$ALPHAUP^SSUTIL4(ExpireFlag)
    s ExpireFlag=$s(ExpireFlag="REQUIRED":"R",ExpireFlag="OPTIONAL":"O",ExpireFlag="NONREQUIRED":"N",1:"")
    s UpdateDate=+$h
    s UpdateTime=$p($h,",",2)
    
    s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrcFileDate)
    s SetInitStatusNotUse=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"SetInitStatusNotUse")
    i SetInitStatusNotUse="Y"  d
    .s NotUseFlag="Y"
    s AutoSetEffDateTo=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoSetArcimEffDateto")
    i (AutoSetEffDateTo="Y")&&(NotUseFlag="Y")  d
    .s:OrdEndDate="" OrdEndDate=+$h 
    
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;插入库存项主表
    &sql(
    	Insert into INC_Itm
    	(
	    	INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,
	    	INCI_CTUOM_Purch_DR,INCI_NotUseFlag,INCI_IsTrfFlag,INCI_OriginalARCIM_DR,INCI_BatchReq,
	    	INCI_ExpReq,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
	    	INCI_ReportingDays,INCI_CTUOM_OutPat_DR,INCI_CTUOM_InPat_DR,INCI_INCCA_DR
    	)
    	values
    	(
	    	:InciCode,:InciDesc,:BUomId,:StkCatId,:PurUomId,:NotUseFlag,:TranFlag,
	    	:ArcimId,:BatFlag,:ExpireFlag,:UpdateDate,:UpdateTime,:UpdateUserId,:BarCode,
	    	:XieHeCode,:OutPhUom,:InPhUom,:PbFlag
    	)
    )
    i SQLCODE'=0  d
    .trollback
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:INC_Itm",InciDesc,SQLCODE_":"_%msg)
    .s Err=-9   ;插入库存项失败
    q:Err'=0 -91
    s InciRowid=$P(%ROWID,$C(1))        ;库存项主表rowid
    ;插入库存项附加表
    &sql(Insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_ImportFlag,INFO_QualityLevel,INFO_BasicDrug,
    INFO_OTC,INFO_Codex,INFO_Test,INFO_REC,INFO_QualityNo,INFO_ComFrom,INFO_Remark,INFO_HighPrice,
    INFO_MT_DR,INFO_MaxSp,INFO_InHos_Flag,INFO_PbRp,INFO_PBL_DR,INFO_PbVendor_DR,
    INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_Spec,INFO_ISC_DR,INFO_BA_flag,INFO_PBLevel,INFO_ExpireLen,
    INFO_PrcFile,INFO_PrcFileD,INFO_SkinTest,INFO_BC_Dr,INFO_DrugUse,INFO_Drugbase2,INFO_PDrugbase1,
    INFO_PDrugbase2,INFO_StandardCode,INFO_InMedBasis,INFO_NotUseReason_Dr,
    INFO_HighRiskFlag,INFO_PackUom,INFO_PackUomFactor,INFO_RefRetReason_Dr,INFO_OrdEndDate,INFO_PHMNF_DR)
    values(:InciRowid,:ImpFlag,:QualityLev,:BasicDrug,:OTC,:CodeX,:TestFlag,:RecFlag,:QualityNo,
    :ComFrom,:BatNo,:HighPrice,:MarkTypeDr,:MaxSp,:InHosFlag,:PbRp,:PbLDr,:PbVendorId,
    :PbManfId,:PbCarriorId,:Spec,:StoreCon,:BaFlag,:PbLevel,:ExpireLen,:PrcFile,:PrcFileDate,
    :SkinFlag,:BookCatId,:DrugUse,:BasicDrug2,:PDrugBase1,:PDrugBase2,:StanderCode,:InMedBasis,
    :NotUseReason,:HighRiskFlag,:PackUom,:PackUomFac,:refRetReason,:OrdEndDate,:PhManfId))
    i SQLCODE'=0  d
    .trollback
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:",InciRowid,SQLCODE_":"_%msg)
    .s Err=-10   ;插入库存项附加表失败
    q:Err'=0 -92
    s InfoId=$P(%ROWID,$C(1))       ;库存项附加表rowid
    
    ;保存别名 
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s ListAlias=""  
    s AutoAddIAByDesc=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddIAByDesc")
    i AutoAddIAByDesc="Y"  d
    .s AliasByDesc=##class(web.DHCST.Common.AppCommon).GetCNCODE(InciDesc)
    .q:AliasByDesc=""
    .s ListAlias="^"_AliasByDesc
    .s AliasWBByDesc=##class(web.DHCST.Common.AppCommon).GetCNWBCODE(InciDesc)
    .i ListAlias'=""  d
    ..s ListAlias=ListAlias_rowDelim_"^"_AliasWBByDesc
    .e  d
    ..s ListAlias="^"_AliasWBByDesc
    s AutoAddIAByGeneric=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddIAByGeneric")
    i AutoAddIAByGeneric="Y"  d
    .s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGene(InciRowid)
    .s Generic=$p(Generic,"^",2)
    .q:Generic=""
    .s AliasByGeneric=##class(web.DHCST.Common.AppCommon).GetCNCODE(Generic)
    .q:AliasByGeneric=""
    .i ListAlias'=""  d
    ..s ListAlias=ListAlias_rowDelim_"^"_AliasByGeneric
    .e  d
    ..s ListAlias="^"_AliasByGeneric
    i ListAlias'="" s ListAlias="^"_InciDesc_rowDelim_"^"_InciCode_rowDelim_ListAlias
    i ListAlias'=""  d
    .s ret=##class(web.DHCST.INCALIAS).Save(InciRowid,ListAlias)
    .s:ret'=0 Err=-93
    i Err'="0"  trollback 
    q:Err'="0" -93      ;插入库存项别名失败
    ;插入调价记录
     
     //取公共进价规则标志 wyx 2014-04-15 //如果为批次价模式，不调价。收费项的价格会从DHCOEDispBatch - 配药批次表里取，那里的价格是从公共价格函数里取的批次调价表的价格
    s ret=##class(web.DHCST.Common.AppCommon).GetParamCommon(gGroupId,gLocId,UpdateUserId)
    s RpRule=$p(ret,"^",8)
    s GroupFlag=$p(ret,"^",7)
    i RpRule'=3 d
    .i (Sp'="")!(Rp'="")  d
    ..q:GroupFlag="2" //集团化医院标记，如果为集团化医院不插入调价记录
    ..s AppName="DHCSTADJSP"
    ..s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PrcFileDate)
    ..s WarrentInfo=PrcFile_"^"_PrcFileDate_"^"_PreExeDate
    ..s defaultDept=$p(^SSU("SSUSR",UpdateUserId),"^",4)
    ..s hospId=$p(^CTLOC(defaultDept),"^",22)
    ..s Ret=##class(web.DHCST.INAdjSalePrice).CreateAdjspFromNewitm1(InciRowid,Sp,UpdateUserId,PurUomId,Rp,AppName,hospId,WarrentInfo)
    ..s:+Ret<0 Err=-94
    i Err'=0  trollback
    q:Err'=0 -94  ;保存价格失败
    tc
	s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(InciRowid)
	s StruModeFlag=$p(StkGrpInfo,"^",7)
	i StruModeFlag'="Y" d
	.&sql(Update Arc_ItmMast set ARCIM_BillingUOM_DR=:OutPhUom where arcim_rowid=:ArcimId)
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("INC_Itm",InciRowid)
    .s JsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_ItmAddionInfo",InfoId)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("INC_Itm","User.INCItm","库存项主表信息",InciRowid,InciDesc,"A",JsonStr)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_ItmAddionInfo","User.DHCItmAddionInfo","库存项附加表信息",InfoId,InciRowid,"A",JsonStrCh)
    q InciRowid
}

/// Descript:   更新库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-27
/// Table:INC_Itm
/// Input:医嘱项rowid^代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价
/// ^价格生效日期^规格^进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^定价类型id^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// Output:     
/// Return：0：成功;
/// -91：插入库存项失败
/// -92：插入库存项附加表失败
/// -94：保存价格失败
ClassMethod Update(IncRowid As %String, listData As %String) As %Library.String
{
    n (IncRowid,listData,%session)
    s ^tmpdhy("Update")=listData
    s InciCode=$p(listData,"^",2)               ;代码
    s InciDesc=$p(listData,"^",3)               ;描述
    s BUomId=$p(listData,"^",4)                 ;基本单位id
    s PurUomId=$p(listData,"^",5)               ;入库单位id
    s StkCatId=$p(listData,"^",6)               ;库存分类id
    s TranFlag=$p(listData,"^",7)               ;转移方式
    s BatFlag=$p(listData,"^",8)                ;是否要求批次     
    s ExpireFlag=$p(listData,"^",9)             ;是否要求效期
    s NotUseFlag=$p(listData,"^",11)            ;不可用标志
    s XieHeCode=$p(listData,"^",12)             ;协和码
    s BarCode=$p(listData,"^",13)               ;条码
    s UpdateUserId=$p(listData,"^",14)          ;更新人
    s Sp=$p(listData,"^",15)
    s Rp=$p(listData,"^",16)
    s PreExeDate=$p(listData,"^",17)            ;价格生效日期
    s Spec=$p(listData,"^",18)                  ;规格
    s ImpFlag=$p(listData,"^",19)               ;进口标志
    s QualityLev=$p(listData,"^",20)            ;质量层次
    s OTC=$p(listData,"^",21)                   ;处方药分类
    s BasicDrug=$p(listData,"^",22)             ;基本药物标志
    s CodeX=$p(listData,"^",23)                 ;中国药典标志
    s TestFlag=$p(listData,"^",24)              ;临床验证用药标志
    s RecFlag=$p(listData,"^",25)               ;处方购药标志 
    s QualityNo=$p(listData,"^",26)             ;质量编号
    s ComFrom=$p(listData,"^",27)               ;国/省别
    s BatNo=$p(listData,"^",28)                 ;批准文号
    s HighPrice=$p(listData,"^",29)             ;贵重药
    //s BackUp=$p(listData,"^",30)              ;院长签字
    s MarkTypeDr=$p(listData,"^",30)            ;定价类型id
    s MaxSp=$p(listData,"^",31)                 ;最高售价
    s StoreCon=$p(listData,"^",32)              ;存储条件
    s InHosFlag=$p(listData,"^",33)             ;本院药品目录
    s PbFlag=$p(listData,"^",34)                ;招标标志
    s PbRp=$p(listData,"^",35)                  ;招标进价
    s PbLevel=$p(listData,"^",36)               ;招标级别
    s PbVendorId=$p(listData,"^",37)            ;招标供应商id
    s PbManfId=$p(listData,"^",38)              ;招标生产商id
    s PbCarriorId=$p(listData,"^",39)           ;招标配送商id
    s PbLDr=$p(listData,"^",40)                 ;招标名称,DHC_PublicBiddingList
    s BaFlag=$p(listData,"^",41)                ;阳光采购标志
    s ExpireLen=$p(listData,"^",42)             ;效期长度
    s PrcFile=$p(listData,"^",43)               ;物价文件号
    s PrcFileDate=$p(listData,"^",44)           ;物价文件备案时间
    s SkinFlag=$p(listData,"^",45)              ;皮试标志
    s BookCatId=$p(listData,"^",46)             ;帐簿分类id
    s DrugUse=$p(listData,"^",47)               ;用药说明
    s BasicDrug2=$p(listData,"^",48)            ;基本药物标志2
    s PDrugBase1=$p(listData,"^",49)            ;省增补药物标志1
    s PDrugBase2=$p(listData,"^",50)            ;省增补药物标志2
    s StanderCode=$p(listData,"^",51)           ;药品本位码
    s InMedBasis=$p(listData,"^",52)            ;进药依据
    s PackUom=$p(listData,"^",53)               ;大包装单位
    s PackUomFac=$p(listData,"^",54)            ;大包装单位系数
    s HighRiskFlag=$p(listData,"^",55)          ;高危药品标志
    s NotUseReason=$p(listData,"^",56)          ;不可用原因
    //s InsuCat=$p(listData,"^",57)             ;医保类别 存到药学项里，wyx 2015-04-21
    s gLocId=$p(listData,"^",58)               	;科室
    s gGroupId=$p(listData,"^",59)              ;安全组
  	s refRetReason=$p(listData,"^",60)          ;不可退原因
  	s OutPhUom=$p(listData,"^",61)          	;门诊发药单位
  	s InPhUom=$p(listData,"^",62)          		;住院发药单位
  	s OrdEndDate=$p(listData,"^",63)          	;医嘱截止日期
  	i OrdEndDate'="" s OrdEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(OrdEndDate)
    s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(PrcFileDate)
    s TranFlag=$$ALPHAUP^SSUTIL4(TranFlag)
    s TranFlag=$s(TranFlag["TRANS":"T",TranFlag["ISSUE":"I",TranFlag["BOTH":"B",1:"")
    ;
    s BatFlag=$$ALPHAUP^SSUTIL4(BatFlag)
    s BatFlag=$s(BatFlag="REQUIRED":"R",BatFlag="OPTIONAL":"O",BatFlag="NONREQUIRED":"N",1:"")
    ;
    s ExpireFlag=$$ALPHAUP^SSUTIL4(ExpireFlag)
    s ExpireFlag=$s(ExpireFlag="REQUIRED":"R",ExpireFlag="OPTIONAL":"O",ExpireFlag="NONREQUIRED":"N",1:"")
    s UseFlag=..CheckUsed(IncRowid)    ;库存项是否已经使用
    s OldNotUseFlag=$p(^INCI(IncRowid,2),"^",9)
    i NotUseFlag'="Y" s NotUseReason=""  //取消不可用后不可用原因应自动清空
    s OldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("INC_Itm",IncRowid)
    s AutoSetEffDateTo=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoSetArcimEffDateto")
    i (AutoSetEffDateTo="Y")&&(NotUseFlag="Y")  d
    .s:OrdEndDate="" OrdEndDate=+$h 
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;更新库存项主表
    i UseFlag=1  d    ;不更新基本单位
    .&sql(
    	Update INC_Itm set INCI_Code=:InciCode,INCI_Desc=:InciDesc,
    	INCI_INCSC_DR=:StkCatId,INCI_CTUOM_Purch_DR=:PurUomId,INCI_NotUseFlag=:NotUseFlag,
    	INCI_IsTrfFlag=:TranFlag,INCI_BatchReq=:BatFlag,INCI_ExpReq=:ExpireFlag,INCI_UpdateUser=:UpdateUserId,
    	INCI_BarCode=:BarCode,INCI_ReportingDays=:XieHeCode,INCI_CTUOM_OutPat_DR=:OutPhUom,INCI_CTUOM_InPat_DR=:InPhUom, 
    	INCI_INCCA_DR=:PbFlag
    	where INCI_Rowid=:IncRowid
     )
    e  d
    .&sql(
    	Update INC_Itm set INCI_Code=:InciCode,INCI_Desc=:InciDesc,INCI_CTUOM_DR=:BUomId,
    	INCI_INCSC_DR=:StkCatId,INCI_CTUOM_Purch_DR=:PurUomId,INCI_NotUseFlag=:NotUseFlag,
    	INCI_IsTrfFlag=:TranFlag,INCI_BatchReq=:BatFlag,INCI_ExpReq=:ExpireFlag,INCI_UpdateUser=:UpdateUserId,
    	INCI_BarCode=:BarCode,INCI_ReportingDays=:XieHeCode,INCI_CTUOM_OutPat_DR=:OutPhUom,INCI_CTUOM_InPat_DR=:InPhUom, 
    	INCI_INCCA_DR=:PbFlag
    	where INCI_Rowid=:IncRowid
     )
    i SQLCODE'=0  d
    .trollback
    .s rett=$$ErrorRecord^DHCSTERROR("Update:INC_Itm",IncRowid,SQLCODE_":"_%msg)
    .s Err=-91   ;更新库存项失败    
    q:Err'=0 -91
    ;插入库存项附加表
    s InfoId=$o(^DHCITMINFO(0,"INCI",IncRowid,0))
    i InfoId'=""  d
    .s OldJsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_ItmAddionInfo",InfoId)
    .&sql(Update DHC_ItmAddionInfo set INFO_ImportFlag=:ImpFlag,INFO_QualityLevel=:QualityLev,
    INFO_BasicDrug=:BasicDrug,INFO_OTC=:OTC,INFO_Codex=:CodeX,INFO_Test=:TestFlag,
    INFO_REC=:RecFlag,INFO_QualityNo=:QualityNo,INFO_ComFrom=:ComFrom,INFO_Remark=:BatNo,
    INFO_HighPrice=:HighPrice,INFO_MT_DR=:MarkTypeDr,INFO_MaxSp=:MaxSp,
    INFO_InHos_Flag=:InHosFlag,INFO_PbRp=:PbRp,INFO_PBL_DR=:PbLDr,INFO_PbVendor_DR=:PbVendorId,
    INFO_PbManf_DR=:PbManfId,INFO_PbCarrier_DR=:PbCarriorId,INFO_Spec=:Spec,INFO_ISC_DR=:StoreCon,
    INFO_BA_flag=:BaFlag,INFO_PBLevel=:PbLevel,INFO_ExpireLen=:ExpireLen,INFO_PrcFile=:PrcFile,
    INFO_PrcFileD=:PrcFileDate,INFO_SkinTest=:SkinFlag,INFO_BC_Dr=:BookCatId,INFO_DrugUse=:DrugUse,
    INFO_Drugbase2=:BasicDrug2,INFO_PDrugbase1=:PDrugBase1,INFO_PDrugbase2=:PDrugBase2,
    INFO_StandardCode=:StanderCode,INFO_InMedBasis=:InMedBasis, INFO_NotUseReason_Dr=:NotUseReason,
    INFO_HighRiskFlag=:HighRiskFlag,INFO_PackUom=:PackUom,
    INFO_PackUomFactor=:PackUomFac,INFO_RefRetReason_Dr=:refRetReason ,INFO_OrdEndDate=:OrdEndDate
    where info_rowid=:InfoId)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:",InfoId,SQLCODE_":"_%msg)
    ..s Err=-92   ;更新库存项附加表失败
    .
    i Err'=0 trollback
    q:Err'=0 -92
    //取公共进价规则标志 wyx 2014-04-15 //如果为批次价模式，不调价
    s ret=##class(web.DHCST.Common.AppCommon).GetParamCommon(gGroupId,gLocId,UpdateUserId)
    s RpRule=$p(ret,"^",8)
    s GroupFlag=$p(ret,"^",7)
    i UseFlag=0  d
    .q:(Sp="")&(Rp="")
    .s AppName="DHCSTADJSP"
    .s:PrcFileDate'="" PrcFileDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PrcFileDate)
    .s WarrentInfo=PrcFile_"^"_PrcFileDate_"^"_PreExeDate
    .s ret=##class(web.DHCST.INAdjSalePrice).DeleteAdjPrice(IncRowid)
    .s:ret'=0 Err=-94
    .q:ret'=0
    .i RpRule'=3 d
    ..q:GroupFlag="2" //集团化医院标记，如果为集团化医院不插入调价记录
    ..s defaultDept=$p(^SSU("SSUSR",UpdateUserId),"^",4)
    ..s hospId=$p(^CTLOC(defaultDept),"^",22)
    ..s Ret=##class(web.DHCST.INAdjSalePrice).CreateAdjspFromNewitm1(IncRowid,Sp,UpdateUserId,PurUomId,Rp,AppName,hospId,WarrentInfo)
    ..s:+Ret<0 Err=-93
    .
    i Err'=0 trollback
    q:Err'=0 -94  ;更新价格失败;
    i (NotUseFlag="Y")&(OldNotUseFlag'="Y")  d
    .s AutoSetEffDateTo=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAIN","AutoSetArcimEffDateto")
    .;设置库存项不可用时自动设置医嘱项截止日期
    .s ArcimId=$p(^INCI(IncRowid,1),"^",3)
    .i AutoSetEffDateTo="Y" d
    ..s ret=##class(web.DHCST.ARCITMMAST).UpdateEffDeteTo(ArcimId,+$h)
    ..s:ret'=0 Err=-95
    i Err'=0 trollback
    q:Err'=0 -95  ;设置医嘱项截止日期失败
    tc
    s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncRowid)
	s StruModeFlag=$p(StkGrpInfo,"^",7)
	i StruModeFlag'="Y" d
	.&sql(Update Arc_ItmMast set ARCIM_BillingUOM_DR=:OutPhUom where arcim_rowid=:ArcimId)
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("INC_Itm",IncRowid)
    .s JsonStrCh=##class(web.DHCST.Common.JsonObj).GetValue("DHC_ItmAddionInfo",InfoId)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("INC_Itm","User.INCItm","库存项主表信息",IncRowid,InciDesc,"U",JsonStr,OldJsonStr)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_ItmAddionInfo","User.DHCItmAddionInfo","库存项附加表信息",InfoId,IncRowid,"U",JsonStrCh,OldJsonStrCh)
    q 0
}

/// Descript:   判断该库存项是否存在帐目
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
/// Table:
/// Input:库存项id
/// Output:     
/// Return：0：未使用;1：使用
/// w ##class(web.DHCST.INCITM).CheckUsed("4636")
ClassMethod CheckUsed(IncRowid As %String) As %Library.String
{
    n (IncRowid)
    s Flag=0
    q:IncRowid="" 0
    i $d(^DHCINTR(0,"INCI",IncRowid))  d
    .s Flag=1
    q:Flag=1 Flag
    s Chl=$o(^INCI(IncRowid,"IL",0))
    s:Chl'="" Flag=1
    i $d(^DHCOEDISQTYi("DSPBInci",IncRowid))  d
    .s Flag=1
    q Flag
}

/// Descript:   查询库存项明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:医嘱项rowid^代码^描述^基本单位id^基本单位^入库单位id^入库单位^库存分类id^库存分类^
/// 转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人id^更新人^售价^进价
/// Return：w ##class(web.DHCST.INCITM).Select(469)
ClassMethod Select(InciId, HospitalRowid = "") As %Library.String
{
    n (InciId,HospitalRowid)
    q:InciId="" ""
    q:'$d(^INCI(InciId)) ""
    ;
    s ArcimId=$p(^INCI(InciId,1),"^",3)
    s InciCode=$p(^INCI(InciId,1),"^",1)
    s InciDesc=$p(^INCI(InciId,1),"^",2)
    s InciDesc=##class(web.DHCSTEXTCOMMON).GetValue(InciDesc)
    s BuomId=$p(^INCI(InciId,1),"^",10)
    s PurUomId=$p(^INCI(InciId,3),"^",6)
    s StkCatId=$p(^INCI(InciId,2),"^",2)
    s TransFlag=$p(^INCI(InciId,2),"^",6)
    s BatReqFlag=$p(^INCI(InciId,2),"^",10)
    s ExpReqFlag=$p(^INCI(InciId,2),"^",11)
    s AliasStr=##class(web.DHCST.INCALIAS).GetIncAlias(InciId)
    s NotUseFlag=$p(^INCI(InciId,2),"^",9)
    s XieHe=$p(^INCI(InciId,3),"^",11)
    s BarCode=$p(^INCI(InciId,3),"^",9)
    s UpdUserId=$p(^INCI(InciId,3),"^",3)
    ;
    s:BuomId'="" BuomDesc=$p($g(^CT("UOM",BuomId)),"^",2)
    s:PurUomId'="" PurUomDesc=$p($g(^CT("UOM",PurUomId)),"^",2)
    s:StkCatId'="" StkCatDesc=$p($g(^INC("SC",StkCatId)),"^",2)
    s:UpdUserId'="" UpdUserName=$p($g(^SSU("SSUSR",UpdUserId)),"^",2)
    s TransFlag=$s(TransFlag["T":"TRANS",TransFlag["I":"ISSUE",TransFlag["B":"BOTH",1:"")
    s BatReqFlag=$s(BatReqFlag="R":"REQUIRED",BatReqFlag="O":"OPTIONAL",BatReqFlag="N":"NONREQUIRED",1:"")
    s ExpReqFlag=$s(ExpReqFlag="R":"REQUIRED",ExpReqFlag="O":"OPTIONAL",ExpReqFlag="N":"NONREQUIRED",1:"")
    s Rp=##Class(web.DHCSTPRICE).GetFormatRp(InciId,+$h,PurUomId,HospitalRowid,"")	//zhouyg 20141204
    s Sp=##Class(web.DHCSTPRICE).GetFormatSp(InciId,+$h,PurUomId,HospitalRowid,"")
    s ExeDateTime=##Class(web.DHCSTPRICE).GetPriceExeDate(InciId,+$h,HospitalRowid,"")
    s ExeDate=$p(ExeDateTime,"^",1)
    //s ExeDate=$p(aspInfo,"^",3)	;调价日期
    ;Set json = ##class(Code.JsonObj).%New()
    s Data1=ArcimId_"^"_InciCode_"^"_InciDesc_"^"_BuomId_"^"_$g(BuomDesc)_"^"_PurUomId_"^"_$g(PurUomDesc) //7
    s Data2=StkCatId_"^"_$g(StkCatDesc)_"^"_TransFlag_"^"_BatReqFlag_"^"_ExpReqFlag_"^"_AliasStr_"^"_NotUseFlag //14
    s Data3=XieHe_"^"_BarCode_"^"_UpdUserId_"^"_$g(UpdUserName)_"^"_Sp_"^"_Rp
    s Data4=..GetIncAddionDetail(InciId)
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_ExeDate
    q Data
}

/// Descript:   查询库存项附加信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:DHC_ItmAddionInfo
/// Input:库存项表rowid
/// Output:     
/// Return：进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^定价类型^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^帐簿分类^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据^规格
ClassMethod GetIncAddionDetail(InciId) As %Library.String
{
    n (InciId)
    q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    ;
    s ImpFlag=$p(^DHCITMINFO(Info),"^",2)
    s QualityLevId=$p(^DHCITMINFO(Info),"^",3)
    s:QualityLevId'="" QualityLev=$p(^DHCITMQL(QualityLevId),"^",2)
    s OTC=$p(^DHCITMINFO(Info),"^",5)               ;处方药分类
    s BasicDrug=$p(^DHCITMINFO(Info),"^",4)
    s CodeX=$p(^DHCITMINFO(Info),"^",7)
    s TestFlag=$p(^DHCITMINFO(Info),"^",6)
    s RecFlag=$p(^DHCITMINFO(Info),"^",11)
    s QualityNo=$p(^DHCITMINFO(Info),"^",8)
    s ComFrom=$p(^DHCITMINFO(Info),"^",9)
    s Remark=$p(^DHCITMINFO(Info),"^",10)
    i Remark'["-" s $p(Remark,"-",2)=Remark,$p(Remark,"-",1)=""
    i $p(Remark,"-",1)="undefined" s $p(Remark,"-",1)=""
    i $p(Remark,"-",2)="undefined" s $p(Remark,"-",2)=""
    s HighPrice=$p(^DHCITMINFO(Info),"^",12)
    s Signature=$p(^DHCITMINFO(Info),"^",13)
    s MtDr=$p(^DHCITMINFO(Info),"^",15)
    s MaxSp=$p(^DHCITMINFO(Info),"^",16)
    s StoreConId=$p(^DHCITMINFO(Info),"^",28)
    s InHosFlag=$p(^DHCITMINFO(Info),"^",21)
    ;s PbFlag=$p(^DHCITMINFO(Info),"^",3)
    s PbRp=$p(^DHCITMINFO(Info),"^",22)
    s PbLevelId=$p(^DHCITMINFO(Info),"^",30)
    s:PbLevelId'="" PbLevel=$p($g(^DHCITMPBL(PbLevelId)),"^",2)
    s PbVendorId=$p(^DHCITMINFO(Info),"^",24)
    s PbManfId=$p(^DHCITMINFO(Info),"^",25)
    s PbCarrierId=$p(^DHCITMINFO(Info),"^",26)
    s PbLDr=$p(^DHCITMINFO(Info),"^",23)        ;招标名称
    s PbFlag=$p(^INCI(InciId,2),"^",7)
    //i (+PbRp'=0)!(PbLevelId'="")!(PbVendorId'="")!(PbManfId'="")!(PbCarrierId'="")!(PbLDr'="") d
    //.s PbFlag="Y"
    //e  d
    //.s PbFlag="N"
    s BaFlag=$p(^DHCITMINFO(Info),"^",29)
    s ExpireLen=$p(^DHCITMINFO(Info),"^",32)
    s PrcFile=$p(^DHCITMINFO(Info),"^",33)
    s PrcFileD=$p(^DHCITMINFO(Info),"^",34)
    s SkinFlag=$p(^DHCITMINFO(Info),"^",35)
    s BookCatId=$p(^DHCITMINFO(Info),"^",36)
    s DrugUse=$p(^DHCITMINFO(Info),"^",38)
    s BasicDrug2=$p(^DHCITMINFO(Info),"^",40)
    s PBasicDrug=$p(^DHCITMINFO(Info),"^",41)
    s PBasicDrug2=$p(^DHCITMINFO(Info),"^",42)
    s StanderCode=$p(^DHCITMINFO(Info),"^",44)
    s InMedBasis=$p(^DHCITMINFO(Info),"^",45)
    s Spec=$p(^DHCITMINFO(Info),"^",27)
    s RefReason=""
    s RefReaDr=$p(^DHCITMINFO(Info),"^",46)
    i RefReaDr'="" S RefReason=$p($g(^DHCRFRETREASON(RefReaDr)),"^",2)
    s NotUseReasonDr=$p(^DHCITMINFO(Info),"^",47)
    s:NotUseReasonDr'="" NotUseReason=$p($g(^DHCNUR(NotUseReasonDr)),"^",1)
    //s InsuCatDr=$p(^DHCITMINFO(Info),"^",49) 
    //s:+InsuCatDr'=0 InsuCat=$p(^DHCITMIC(InsuCatDr),"^",2) 存到药学项里，wyx 2015-04-21
    s HighRiskFlag=$p(^DHCITMINFO(Info),"^",50) 
    s PackUomId=$p(^DHCITMINFO(Info),"^",51) 
    s:+PackUomId'=0 PackUom=$p(^CT("UOM",PackUomId),"^",2)
    s PackUomFac=$p(^DHCITMINFO(Info),"^",52) 
    ;
    s:MtDr'="" MtDesc=$p($g(^DHCINMT(MtDr)),"^",2)
    s:PbVendorId'="" PbVendorDesc=$p($g(^APC("APCVM",PbVendorId)),"^",3)
    s:PbManfId'="" PbManfDesc=$p($g(^PHMNF(PbManfId)),"^",2)
    s:PbCarrierId'="" PbCarrierDesc=$p($g(^DHCCARR(PbCarrierId)),"^",2)
    s:PbLDr'="" PbLDesc=$p($g(^DHCPBLIST(PbLDr)),"^",2)
    s:BookCatId'="" BookCatDesc=$p($g(^DHCSTBC(BookCatId)),"^",2)
    s:PrcFileD'="" PrcFileD=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PrcFileD)
    //s:StoreConId'="" StoreCon=$p(^DHCItemSC(StoreConId),"^",2)
    ;
    s Data1=ImpFlag_"^"_$g(QualityLev)_"^"_OTC_"^"_BasicDrug_"^"_CodeX_"^"_TestFlag_"^"_RecFlag
    s Data2=QualityNo_"^"_ComFrom_"^"_Remark_"^"_HighPrice_"^"_Signature_"^"_MtDr_"^"_$g(MtDesc)
    s Data3=MaxSp_"^"_StoreConId_"^"_InHosFlag_"^"_PbFlag_"^"_PbRp_"^"_$g(PbLevel)
    s Data4=PbVendorId_"^"_$g(PbVendorDesc)_"^"_PbManfId_"^"_$g(PbManfDesc)_"^"_PbCarrierId_"^"_$g(PbCarrierDesc)
    s Data5=PbLDr_"^"_$g(PbLDesc)_"^"_BaFlag_"^"_ExpireLen_"^"_PrcFile_"^"_PrcFileD_"^"_SkinFlag
    s Data6=BookCatId_"^"_$g(BookCatDesc)_"^"_DrugUse_"^"_BasicDrug2_"^"_PBasicDrug_"^"_PBasicDrug2
    s Data7=StanderCode_"^"_InMedBasis_"^"_Spec_"^"_NotUseReasonDr_"^"_$g(NotUseReason)_"^"_""
    s Data8=""_"^"_HighRiskFlag_"^"_PackUomId_"^"_$g(PackUom)_"^"_PackUomFac
    s Data9=PbLevelId_"^"_QualityLevId_"^"_$g(RefReason)
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7_"^"_Data8_"^"_Data9
    q Data
}

/// Descript:   删除库存项相关信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:INC_Itm
/// Input:库存项rowid
/// Output:     
/// Return：0，成功
/// -1	;该库存项已使用
/// -2  ;删除库存项失败
/// -3  ;删除库存项附加信息失败
/// -4  ;删除库存项别名失败
/// -5  ;删除调价记录失败
/// -6 	;删除收费项表失败
/// -7	;删除收费项别名表失败
/// -8	;删除收费项库存项关联表失败
/// Debug:		w ##class(web.DHCST.INCITM).Delete("4595")
ClassMethod Delete(InciRowid) As %Library.String
{
    n (InciRowid,%session)
    q:InciRowid="" 0
    q:'$d(^INCI(InciRowid)) 0
    s UseFlag=..CheckUsed(InciRowid)    
    q:UseFlag=1 "-1^该药品已发生业务，不能删除！"
    s Err=0    
    &sql(SELECT INCI_Code, INCI_Desc into :InciCode,:InciDesc FROM Inc_Itm WHERE INCI_Rowid=:InciRowid)
    s JsonStr="{药品代码:"""_InciCode_""",药品名称:"""_InciDesc_"""}"
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;删除库存项
    &sql(Delete From Inc_Itm Where INCI_Rowid=:InciRowid)
    i SQLCODE'=0  d
    .trollback
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:Inc_Itm",InciRowid,SQLCODE_":"_$g(%msg))
    .s Err="-2^删除库存项失败!"                  
    q:Err'=0 Err
    ;删除附加信息
    s InfoRowid=$o(^DHCITMINFO(0,"INCI",InciRowid,0))
    i InfoRowid'=""  d
    .&sql(Delete From DHC_ItmAddionInfo Where INFO_Rowid=:InfoRowid)
    .i SQLCODE'=0  d
    ..trollback
    ..s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_ItmAddionInfo",InfoRowid,SQLCODE_":"_$g(%msg))
    ..s Err="-3^删除库存项附加信息失败!"             
    q:Err'=0 Err
    ;删除别名   ;
    s ret=##class(web.DHCST.INCALIAS).DeleteItmAlias(InciRowid)
    i ret'=0 trollback
    q:ret'=0 "-4^删除库存项别名失败!"
    s ret=##class(web.DHCST.INAdjSalePrice).DeleteAdjPrice(InciRowid)
    i ret'=0 trollback
    q:ret'=0 "-5^删除调价记录失败!"
    ;删除收费项、收费项别名、收费项库存项关联表
    s InctrId=$o(^DHCINCTARi("INCI",InciRowid,""),-1)
    i InctrId'=""  d
    .s taritem=$p(^DHCINCTAR(InctrId),"^",2)
    .&SQL(DELETE FROM DHC_TarItem WHERE TARI_RowId=:taritem)
    .i SQLCODE'=0  d
    ..trollback
    ..s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_TarItem",InfoRowid,SQLCODE_":"_$g(%msg))
    ..s Err="-6^删除收费项表失败!"
    .q:Err'=0  
    .i $d(^DHCTARAL("A",taritem)) d        
 	..&SQL(DELETE FROM DHC_TarItemAlias WHERE TIA_TARI_DR=:taritem)
 	..i SQLCODE'=0  d
    ...trollback
    ...s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_TarItemAlias",InfoRowid,SQLCODE_":"_$g(%msg))
    ...s Err="-7^删除收费项别名表失败!"
    .q:Err'=0
    .&SQL(DELETE FROM DHC_IncTarRela WHERE INCTR_RowId=:InctrId)
 	.i SQLCODE'=0  d
    ..trollback
    ..s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_IncTarRela",InfoRowid,SQLCODE_":"_$g(%msg))
    ..s Err="-8^删除收费项库存项关联表失败!"
    .q:Err'=0
    q:Err'=0 Err   
    tcommit
    s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
 	.s ret=##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("Inc_Itm","User.INCItm","库存项主表信息",InciRowid,InciCode,"D",JsonStr)
    q 0
}

/// Descript:  	获取库存项最大码
/// Creater:    wangjiabin
/// CreateDate: 2013-07-01
/// Table:INC_Itm
/// Input:库存分类rowid
/// Output:     
/// Return：
/// w ##class(web.DHCST.INCITM).GetMaxCodeByCat("8^")
ClassMethod GetMaxCodeByCat(Cat) As %Library.String
{
	n (Cat)
	q:Cat="" ""
	s itmcode=""
	s StkCat=$p(Cat,"^",1)
	s FirCode=$p(Cat,"^",2)
	i StkCat'="" d
	.&sql(select max(inci_code) into :itmcode from inc_itm where INCI_INCSC_DR=:StkCat)
	e  d
	.&sql(select max(inci_code) into :itmcode from inc_itm   Where INCI_Code %STARTSWITH %ALPHAUP :FirCode)
	q itmcode
}

/// creator:    yunhaibao
/// createdate: 2017-07-03
/// description:查询库存项query
/// input:strParams(医嘱项ID^代码^描述^别名)
/// w ##class(%ResultSet).RunQuery("web.DHCST.INCITM","QueryIncItm","^^^amxl^")
Query QueryIncItm(strParams) As websys.Query(ROWSPEC = "incRowId,incCode,incDesc,arcItmRowId,arcItmDesc,incSpec,incBUom,incPUom,incRp,incSp,incRemark,incNotUse,incStkCat,genericDesc,chemicalDesc")
{
}

ClassMethod QueryIncItmExecute(ByRef qHandle As %Binary, strParams) As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s inputArcItmId=$p(strParams,"^",1)
	s inputCode=$zcvt($p(strParams,"^",2),"U")
	s inputDesc=$zcvt($p(strParams,"^",3),"U")
	s inputAlias=$zcvt($p(strParams,"^",4),"U")
	s inputPhcCat=$p(strParams,"^",5)
	s phcCatList=##class(web.DHCST.PHCCATMAINTAIN).GetChildrenNodes(inputPhcCat)
	i inputPhcCat'="" d
	.i phcCatList'="" s phcCatList=inputPhcCat_","_phcCatList
	.e  s phcCatList=inputPhcCat
	s phcCatList=$lfs(phcCatList,",")
	i inputArcItmId'="" d
	.s incId=""
	.f  s incId=$o(^INCI(0,"ARCIM_DR",+inputArcItmId,incId)) q:incId=""  d
	..q:+incId=0
	..d getDetailData
	e  d
	.s incId=""
	.f  s incId=$o(^INCI(incId)) q:incId=""  d
	..q:+incId=0
	..s incscDr=$p(^INCI(incId,2),"^",2)
	..q:incscDr=""
	..q:$p($g(^INC("SC",incscDr)),"^",3)'="G"
	..d getDetailData
	Quit $$$OK
getDetailData
	i incId'="" d
	.s incObj=##class(User.INCItm).%OpenId(incId,0)
	.q:incObj=""
	.q:(inputAlias'="")&&(+##class(web.DHCST.INCALIAS).CheckIncAliasExist(incId,inputAlias)<0)
	.s arcItmObj=incObj.INCIARCIMDR
	.s quitFlag=""
	.q:(inputPhcCat'="")&&(arcItmObj="")
	.i arcItmObj'="" d
	..s arcItmId=arcItmObj.%Id()
	..s arcItmDesc=arcItmObj.ARCIMDesc
	..s genericId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),8)),"^",20)
	..q:genericId=""
	..s chemicalId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",3)
	..i (inputPhcCat'="")&&(genericId="") s quitFlag=1
	..i (inputPhcCat'="")&&(chemicalId="") s quitFlag=1
	..i chemicalId'="" d 
	...s phcCatId=$p($g(^DHCPHCM(chemicalId)),"^",3)
	...i (inputPhcCat'="")&&($lf(phcCatList,phcCatId)=0) s quitFlag=1
	..s genericDesc=$p($g(^PHCGE("GE",genericId)),"^",2)
	..s chemicalDesc=$p($g(^DHCPHCM(+chemicalId)),"^",2)
	.e  s (arcItmId,arcItmDesc,genericDesc,chemicalDesc)=""
	.q:quitFlag'=""
	.q:(inputArcItmId'="")&&(inputArcItmId'=arcItmId)
	.s incCode=incObj.INCICode
	.s incDesc=incObj.INCIDesc
	.q:(inputCode'="")&&($zcvt(incCode,"U")'[inputCode)
	.q:(inputDesc'="")&&($zcvt(incDesc,"U")'[inputDesc)
	.s incItmData=..Select(incId)
	./// 规格
	.s incSpec=$p(incItmData,"^",62)
	./// 基本单位
	.s incBUom=$p(incItmData,"^",5)
	./// 入库单位
	.s incPUom=$p(incItmData,"^",7)
	./// 进价
	.s incRp=$p(incItmData,"^",20)
	./// 售价
	.s incSp=$p(incItmData,"^",19)
	./// 批准文号
	.s incRemark=$p(incItmData,"^",30)
	./// 不可用
	.s incNotUse=$p(incItmData,"^",14)
	./// 库存分类
	.s incStkCat=$p(incItmData,"^",9)
	.d outputRow
	Quit $$$OK
outputRow  
	s Data=$lb(incId,incCode,incDesc,arcItmId,arcItmDesc,incSpec,incBUom,incPUom,incRp,incSp,incRemark,incNotUse,incStkCat,genericDesc,chemicalDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:    yunhaibao
/// createdate: 2017-07-04
/// description:根据库存项ID查询库存项相关信息,用于药品维护初始化显示
/// input:		strParams(库存项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.INCITM","QueryIncByIncId",858)
Query QueryIncByIncId(strParams = "") As websys.Query(ROWSPEC = "txtIncCode,txtIncDesc,cmbIncBaseUom,cmbIncPurchUom,cmbIncIsTrf,cmbBatchReq,cmbExpReq,chkNotUse,txtIncBarCode,txtSp,txtRp,dtPriceExeDate,cmbInciImport,cmbQualityLev,chkIncRec,cmbIncRemark1,txtIncRemark2,cmbMarkType,txtMaxSp,chkIncInHosp,chkIncPb,txtPbRp,cmbPbLevel,cmbPbVendor,cmbPbManf,cmbPbCarrier,chkBAFlag,txtExpLen,txtPrcFile,dtPrcFileDate,chkSkin,cmbBookCat,txtUserOrderInfo,txtIncBaseCode,txtInDrugInfo,txtIncSpec,cmbNotUseReason,cmbIncPackUom,txtPackPurFac,chkRoomTemp,chkDry,chkAirtight,chkDark,chkVentilation,chkRadiation,chkMeltSeal,chkCool,chkColdDark,chkSeal,chkRefrigeration,txtMinTemp,txtMaxTemp,txtMinHumi,txtMaxHumi,txtReportingDays,txtComeFrom,txtQualityNo,cmbPbName,cmbRefReturn,cmbTarSubCat,cmbTarInCat,cmbTarOutCat,cmbTarAcctCat,cmbTarMedCat,cmbTarAccSubCat,cmbTarNewMedCat,cmbIncOutBaseUom,cmbIncInBaseUom,cmbStkCat,dtOrdEndDate,chkHighRisk,HASBEENUSED,txtTarCode,txtTarDesc,chkHighPrice")
{
}

ClassMethod QueryIncByIncIdExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s incItmRowId=$p(strParams,"^",1)
	q:incItmRowId="" $$$OK
	s incItmData=..Select(incItmRowId)
	/// 库存项代码 
	s incCode=$p(incItmData,"^",2)
	/// 库存项描述
	s incDesc=$p(incItmData,"^",3)
	/// 基本单位
	s incBaseUom=$p(incItmData,"^",4)
	/// 入库单位
	s incPurchUom=$p(incItmData,"^",6)
	/// 库存分类
	s incStkCat=$p(incItmData,"^",8)
	/// 转移方式
	s incIsTrf=$p(incItmData,"^",10)
	/// 批次
	s batchReq=$p(incItmData,"^",11)
	/// 效期要求
	s expReq=$p(incItmData,"^",12)
	/// 不可用
	s notUse=$p(incItmData,"^",14)
	/// 协和码-15
	s reportingDays=$p(incItmData,"^",15)
	/// 条码-16
	s incBarCode=$p(incItmData,"^",16)
	/// 售价-19
	s sp=$p(incItmData,"^",19)
	s sp=##class(web.DHCST.Common.UtilCommon).AddZero(sp)
	/// 进价-20
	s rp=$p(incItmData,"^",20)
	s rp=##class(web.DHCST.Common.UtilCommon).AddZero(rp)
	/// 价格生效日期-74
	s priceExeDate=$p(incItmData,"^",74)
	/// 进口标志-21
	s inciImport=$p(incItmData,"^",21)
	/// 质量层次-72
	s qualityLev=$p(incItmData,"^",72)
	/// 处方购药-27
	s incRec=$p(incItmData,"^",27)
	/// 质量编号
	s qualityNo=$p(incItmData,"^",28)
	/// 国(省)别
	s comeFrom=$p(incItmData,"^",29)
	/// 批准文号-30
	s incRemark=$p(incItmData,"^",30)
	s incRemark1=$p(incRemark,"-",1)
	s incRemark2=$p(incRemark,"-",2)
	s highPrice=$p(incItmData,"^",31)
	/// 定价类型-33
	s markType=$p(incItmData,"^",33)
	/// 最高售价-35
	s maxSp=$p(incItmData,"^",35)
	s maxSp=##class(web.DHCST.Common.UtilCommon).AddZero(maxSp)
	/// 本院药品目录-37
	s incInHosp=$p(incItmData,"^",37)
	/// 招标标志-38
	s incPb=$p(incItmData,"^",38)	
	/// 招标进价-39
	s pbRp=$p(incItmData,"^",39)
	/// 招标级别-71
	s pbLevel=$p(incItmData,"^",71)
	/// 招标供应商-41
	s pbVendor=$p(incItmData,"^",41)
	/// 招标厂商-43
	s pbManf=$p(incItmData,"^",43)
	/// 招标配送商-45
	s pbCarrier=$p(incItmData,"^",45)
	/// 招标名称
	s pbName=$p(incItmData,"^",47)
	/// 阳光采购-49
	s BAFlag=$p(incItmData,"^",49)
	/// 效期长度-50
	s expLen=$p(incItmData,"^",50)
	s expLen=##class(web.DHCST.Common.UtilCommon).AddZero(expLen)
	/// 物价文件号-51
	s prcFile=$p(incItmData,"^",51)
	/// 物价备案日期-52
	s prcFileDate=$p(incItmData,"^",52)
	/// 皮试标志-53
	s skin=$p(incItmData,"^",53)
	/// 帐簿分类-54
	s bookCat=$p(incItmData,"^",54)
	/// 用药说明-56
	s userOrderInfo=$p(incItmData,"^",56)
	/// 本位码-60
	s incBaseCode=$p(incItmData,"^",60)
	/// 进药依据-61
	s inDrugInfo=$p(incItmData,"^",61)
	/// 规格-62
	s incSpec=$p(incItmData,"^",62)
	/// 不可用原因-63
	s notUseReason=$p(incItmData,"^",63)
	/// 高危药品标志
	s highrisk=$p(incItmData,"^",67)
	/// 大包装单位-68
	s incPackUom=$p(incItmData,"^",68)
	/// 大包装系数-70
	s packPurFac=$p(incItmData,"^",70)
	s packPurFac=##class(web.DHCST.Common.UtilCommon).AddZero(packPurFac)
	/// 贵重药-31
	s highPrice=$p(incItmData,"^",31)
	/// 不可退原因
	s dhcItmInfoId=$o(^DHCITMINFO(0,"INCI",incItmRowId,""))
	s refRetReason=$p($g(^DHCITMINFO(+dhcItmInfoId)),"^",46)
	/// 门诊发药单位
	s incOutPhUom=$p(^INCI(incItmRowId,1),"^",12)
	/// 住院发药单位
	s incInPhUom=$p(^INCI(incItmRowId,1),"^",13) 
	/// 医嘱截止日期
	s ordEndDate=$p($g(^DHCITMINFO(+dhcItmInfoId)),"^",113)
	i ordEndDate'="" s ordEndDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ordEndDate)
	/// 存储条件
	s storeData=##class(web.DHCST.ITMSTORECON).Select(incItmRowId)
	/// 常温-2
	s roomTemp=$p(storeData,"^",2)
	/// 干燥-3
	s dry=$p(storeData,"^",3)
	/// 密闭-4
	s airtight=$p(storeData,"^",4)
	/// 避光-5
	s dark=$p(storeData,"^",5)
	/// 通风-6
	s ventilation=$p(storeData,"^",6)
	/// 防辐射-7
	s radiation=$p(storeData,"^",7)
	/// 熔封-8
	s meltSeal=$p(storeData,"^",8)
	/// 阴凉-9
	s cool=$p(storeData,"^",9)
	/// 凉暗-10
	s coldDark=$p(storeData,"^",10)
	/// 密封-11
	s seal=$p(storeData,"^",11)
	/// 冷藏-12
	s refrigeration=$p(storeData,"^",12)
	/// 最低温度-13
	s minTemp=$p(storeData,"^",13)
	/// 最高温度-14
	s maxTemp=$p(storeData,"^",14)
	/// 最低湿度-15
	s minHumi=$p(storeData,"^",15)
	/// 最高湿度-16
	s maxHumi=$p(storeData,"^",16)
	/// 收费项
	s tarItmId=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(incItmRowId)
	if tarItmId'="" {
		s tarItmData=$g(^DHCTARI(tarItmId))
		/// 子分类
		s tarSubCat=$p(tarItmData,"^",4)
		/// 住院子分类
		s tarInCat=$p(tarItmData,"^",14)
		/// 门诊子分类	
		s tarOutCat=$p(tarItmData,"^",15)	
		/// 核算子分类
		s tarAcctCat=$p(tarItmData,"^",16)		
		/// 病案首页分类
		s tarMedCat=$p(tarItmData,"^",6)			
		/// 会计子分类
		s tarAccSubCat=$p(tarItmData,"^",5)
		/// 新病案首页	
		s tarNewMedCat=$p(tarItmData,"^",30) 
		/// 代码
		s tarCode=$p(tarItmData,"^",1)
		/// 名称
		s tarDesc=$p(tarItmData,"^",2)
	}else{
		s (tarSubCat,tarInCat,tarOutCat,tarAcctCat,tarMedCat,tarAccSubCat,tarNewMedCat,tarCode,tarDesc)=""
	}	
	s HASBEENUSED=..CheckUsed(incItmRowId) // 是否已发生业务,1使用
	s Data=$lb(incCode,incDesc,incBaseUom,incPurchUom,incIsTrf,batchReq,expReq,notUse,incBarCode,sp,
	rp,priceExeDate,inciImport,qualityLev,incRec,incRemark1,incRemark2,markType,maxSp,incInHosp,
	incPb,pbRp,pbLevel,pbVendor,pbManf,pbCarrier,BAFlag,expLen,prcFile,prcFileDate,skin,
	bookCat,userOrderInfo,incBaseCode,inDrugInfo,incSpec,notUseReason,incPackUom,packPurFac,roomTemp,dry,
	airtight,dark,ventilation,radiation,meltSeal,cool,coldDark,seal,refrigeration,minTemp,
	maxTemp,minHumi,maxHumi,reportingDays,comeFrom,qualityNo,pbName,refRetReason,
	tarSubCat,tarInCat,tarOutCat,tarAcctCat,tarMedCat,tarAccSubCat,tarNewMedCat,incOutPhUom,incInPhUom,incStkCat,
	ordEndDate,highrisk,HASBEENUSED,tarCode,tarDesc,highPrice
	)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-07-05
/// description:保存库存项返回错误代码的汉字描述
/// input:		errCode
/// return:     错误信息
/// w ##class(web.DHCST.INCITM).ErrCodeToDesc("-82")
ClassMethod ErrCodeToDesc(errCode = "")
{
	
	n (errCode)
	q:errCode=-16 "医嘱项Id不能为空"
	q:errCode=-11 "库存项代码不能为空"
	q:errCode=-12 "库存项名称不能为空"
	q:errCode=-13 "基本单位不能为空"
	q:errCode=-14 "入库单位不能为空"
	q:errCode=-15 "库存分类不能为空"
	q:errCode=-17 "转移方式不能为空"
	q:errCode=-18 "要求批次不能为空"
	q:errCode=-19 "要求效期不能为空"
	q:errCode=-91 "插入库存项失败"
	q:errCode=-92 "插入库存项附加表失败"
	q:errCode=-93 "插入库存项别名失败"
	q:errCode=-94 "保存价格失败"
	q:errCode=-1 "无效的库存分类"
	q:errCode=-3 "无效的医嘱项"
	q:errCode=-4 "无效的基本单位"
	q:errCode=-5 "无效的入库单位"
	q:errCode=-6 "库存项代码已经存在,不能重复"
	q:errCode=-7 "库存项描述已经存在,不能重复"
	q:errCode=-8 "基本单位和入库单位之间不存在转换关系"
	q:errCode=-20 "门诊发药单位和基本单位之间不存在转换关系"
	q:errCode=-21 "住院发药单位和基本单位之间不存在转换关系"
	q:errCode=-22 "无效的门诊发药单位"
	q:errCode=-23 "无效的住院发药单位"
	q ""
}

/// creator:    yunhaibao
/// createdate: 2017-07-06
/// description:保存收费项信息
/// input:		incItmId(库存项ID),tarItmList(收费项信息)
/// return:     错误信息858!!7^6^6^7^7^7^1
/// w ##class(web.DHCST.INCITM).SaveTarItem("858","7^6^6^7^7^7^1",1)
ClassMethod SaveTarItem(incItmId, tarItmList, userID) As %Library.String
{
	n (incItmId,tarItmList,userID,%session)
	q:incItmId="" "-1^库存项ID为空"
	q:tarItmList="" "-1^收费项信息为空"
	s inciCode=$p(^INCI(incItmId,1),"^",1)
	s inciDesc=$p(^INCI(incItmId,1),"^",2)
	s bUomId=$p(^INCI(incItmId,1),"^",10)
	s tarItmId=##class(web.DHCST.INCLINKTAR).GetTarItmIdByInc(incItmId,+$h)
	q:(tarItmId="")&&($d(^DHCTARI(0,"Desc",inciDesc))) "-1^收费项描述已存在"
	q:(tarItmId="")&&($d(^DHCTARI(0,"Code",inciCode))) "-1^收费项代码已存在"
	s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
	s scRowId=$p(tarItmList,"^",1)
	s icRowId=$p(tarItmList,"^",2)
	s ocRowId=$p(tarItmList,"^",3)
	s ecRowId=$p(tarItmList,"^",4)
	s mcRowId=$p(tarItmList,"^",5)
	s acRowId=$p(tarItmList,"^",6)
	s newMCId=$p(tarItmList,"^",7)
	s startDate=+$H-99
	s tarErr=""
	i tarItmId="" d
	.&SQL(INSERT INTO DHC_TARITEM(TARI_Code,TARI_Desc,TARI_UOM,TARI_SubCate,
		TARI_AcctCate,TARI_OutpatCate,TARI_EMCCate,TARI_MRCate,TARI_SpecialFlag,
		TARI_ActiveFlag,TARI_StartDate,TARI_InpatCate,TARI_ExternalCode) VALUES(:inciCode,:inciDesc,:bUomId,:scRowId,
		:acRowId,:ocRowId,:ecRowId,:mcRowId,'N','Y',:startDate,:icRowId,:inciDesc))
	.s tarItmId=+$g(%ROWID)
	.i SQLCODE=0  d 
	..i RecordTraceFlag="Y" d
	...s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_TARITEM",tarItmId)
	...d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_TARITEM","User.DHCTARITEM","收费项表信息",tarItmId,inciDesc,"A",JsonStr)
	.e  d 
	..s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.INCITM.SaveTarItem.Insert",incItmId,SQLCODE_":"_%msg)
	..s tarErr="插入收费项表数据失败"
	e  d 
	.&SQL(Update DHC_TARITEM set TARI_Code=:inciCode,TARI_Desc=:inciDesc,TARI_UOM=:bUomId,TARI_SubCate=:scRowId,
		TARI_AcctCate=:acRowId,TARI_OutpatCate=:ocRowId,TARI_EMCCate=:ecRowId,TARI_MRCate=:mcRowId,
		TARI_InpatCate=:icRowId,TARI_ExternalCode=:inciDesc 
		where TARI_RowId=:tarItmId
	 )
	.i SQLCODE'=0 d
	..s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.INCITM.SaveTarItem.Update",incItmId,SQLCODE_":"_%msg)
	..s tarErr="更新收费项表数据失败"
	q:tarErr'="" "-1^"_tarErr
	d ##class(web.DHCST.ARCITMMAST).UpdateTarItemBL(tarItmId,newMCId,userID) //新病案首页 
	i '$d(^DHCINCTARi("INCI",incItmId)) d
	.&SQL(INSERT INTO DHC_IncTarRela 
		(INCTR_INCI_Dr,INCTR_Tari_Dr,INCTR_Qty,INCTR_StartDate)
		values
		(:incItmId,:tarItmId,1,:startDate)
	 )
	.i SQLCODE'=0 d
	..s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.INCITM.SaveTarItem:DHC_IncTarRela",incItmId,SQLCODE_":"_%msg)
	..s tarErr="处理库存项关联收费项表数据失败"
	.s IncLTarId=+$g(%ROWID)
	.i RecordTraceFlag="Y" d
    ..s JsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("DHC_IncLinkTar",IncLTarId)
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_IncLinkTar","User.DHCIncLinkTar","库存项关联收费项表信息",IncLTarId,inciDesc,"A",JsonStr1)
	q:tarErr'="" "-1^"_tarErr
	//插入别名
	d ..AddTarItmAliasByInc(incItmId,tarItmId)
	q 1
}

/// w ##class(%ResultSet).RunQuery("web.DHCST.INCITM","QueryIncItmList","amxl")
Query QueryIncItmList(strParams) As websys.Query(ROWSPEC = "incRowId,incCode,incDesc")
{
}

ClassMethod QueryIncItmListExecute(ByRef qHandle As %Binary, strParams) As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s inputAlias=$zcvt($p(strParams,"^",1),"U")
	s incId=""
	f  s incId=$o(^INCI(incId)) q:incId=""  d
	.q:+incId=0
	.s catGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(incId)
	.q:$p(catGrpStr,"^",3)'="G"
	.s incObj=##class(User.INCItm).%OpenId(incId,0)
	.q:incObj=""
	.q:(inputAlias'="")&&(+##class(web.DHCST.INCALIAS).CheckIncAliasExist(incId,inputAlias)<0)
	.s incCode=incObj.INCICode
	.s incDesc=incObj.INCIDesc
	.s Data=$lb(incId,incCode,incDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	Quit $$$OK
}

/// w ##class(web.DHCST.INCITM).CheckManf("805")
ClassMethod CheckManf(IncRowid As %String) As %Library.String
{
    n (IncRowid)
    s ResultString=""
    s ManfId=$p(^PHCD(IncRowid,2),"^",4)
    s ManfInfo=^DHCMANF(ManfId)
 	s DrugProductExpDate=$p(ManfInfo,"^",4)   ;药物生产许可有效期
 	i ((DrugProductExpDate'="")&&(DrugProductExpDate<$p($h,",",1))) d
 	.s ResultString=-999
 	q:ResultString'="" ResultString				;药物生产许可有效期过期
 	;
 	s DrugProductExpDate=$p(ManfInfo,"^",6)   ;材料生产许可有效期
 	i ((DrugProductExpDate'="")&&(DrugProductExpDate<$p($h,",",1))) d
 	.s ResultString=-998
 	q:ResultString'="" ResultString				;材料生产许可有效SaveTarItem+49期过期
 	;
 	s ComLicDate=$p(ManfInfo,"^",9)   ;工商执照许可有效期
 	i ((ComLicDate'="")&&(ComLicDate<$p($h,",",1))) d
 	.s ResultString=-997
 	q:ResultString'="" ResultString				;工商执照许可有效期过期
 	q $$$OK
}

/// description: 更新库存项一些信息到医嘱项
/// 			 门诊发药单位->计价单位
ClassMethod UpdArcimFromInc(IncId)
{
	n (IncId)
	q:IncId="" ""
	s arcItmId=$p($g(^INCI(IncId,1)),"^",3)
	s outUomId=$p($g(^INCI(IncId,1)),"^",12)
	q:(+arcItmId=0) ""
	&SQL(UPDATE ARC_ItmMast SET ARCIM_BillingUOM_DR=:outUomId WHERE ARCIM_RowId=:arcItmId)
	q SQLCODE
}

/// description: 增加收费项别名
/// w ##class(web.DHCST.INCITM).AddTarItmAliasByInc(4610,8232)
ClassMethod AddTarItmAliasByInc(IncId, TarItmId) As %Library.String
{
	n (IncId,TarItmId,%session)
    q:IncId="" 0
    q:TarItmId="" 0
    k AddTarItmAliasByIncData
    s incAliasId=0
    f  s incAliasId=$o(^INCALIAS(0,"INCI",IncId,incAliasId)) q:incAliasId=""  d
    .s incAliasText=$p(^INCALIAS(incAliasId),"^",4)
    .q:incAliasText=""
    .s AddTarItmAliasByIncData($ZCVT(incAliasText,"U"))=""
    q:'$d(AddTarItmAliasByIncData) ""
    s tarAliasId=0
    f  s tarAliasId=$o(^DHCTARAL("A",TarItmId,tarAliasId)) q:tarAliasId=""  d
    .s tarAliasText=$p(^DHCTARAL(tarAliasId),"^",3)
    .q:tarAliasText=""
    .k AddTarItmAliasByIncData($ZCVT(tarAliasText,"U"))
    q:'$d(AddTarItmAliasByIncData)
    s tarItmDesc=$p(^DHCTARI(TarItmId),"^",2)
    s aliasText=""
    f  s aliasText=$o(AddTarItmAliasByIncData(aliasText)) q:aliasText=""  d
    .
    .&SQL(
    	INSERT INTO DHC_TarItemAlias(TIA_TARI_DR,TIA_Desc,TIA_Alias) 
    	VALUES 
     	(:TarItmId,:tarItmDesc,:aliasText)
     )
    k AddTarItmAliasByIncData
    q 0
}

}
