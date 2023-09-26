Import sqluser

/// Descript:库存项及附加信息相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
Class web.DHCSTMHUI.INCITM Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
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
ClassMethod Save(InciId As %String, listData As %String, ArcimId As %String, InciCode, Hosp = "") As RtnObj
{
	n (InciId,listData,ArcimId,InciCode,Hosp,%session)
	s paramStr=..sssParamStr()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(listData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj

	s gLoc=PJObj.%Get("gLocId") 
	s InciDesc=PJObj.%Get("InciDesc")
	s BUomId=PJObj.%Get("BUom")
	s PurUomId=PJObj.%Get("PUom")
	s StkCatId=PJObj.%Get("StkCat")
	s BatFlag=PJObj.%Get("BatchNoReq")					;是否要求批次 
	s ExpireFlag=PJObj.%Get("ExpDateReq")				;是否要求效期
	s AliasStr=PJObj.%Get("AliasStr")					;别名
	s NotUseFlag=PJObj.%Get("NotUseFlag")				;不可用标志
	s:NotUseFlag="" NotUseFlag="N"
	s XieHeCode=PJObj.%Get("XieHeCode")					;协和码
	s BarCode=PJObj.%Get("BarCode")						;条码
	s UpdateUserId=PJObj.%Get("gUserId")				;更新人
	s Sp=+PJObj.%Get("SpPUom")
	s Rp=+PJObj.%Get("RpPUom")
	s SupplyLocField=PJObj.%Get("SupplyLoc")			;供应仓库
	s Remarks=PJObj.%Get("Remarks")
	s PreExeDate=PJObj.%Get("PreExeDate")
	s Spec=PJObj.%Get("Spec")							;规格
	s ImpFlag=PJObj.%Get("ImpFlag")						;进口标志
	s QualityLev=PJObj.%Get("QualityLev")				;质量层次
	s OTC=PJObj.%Get("OTC")								;处方药分类
	s BasicDrug=PJObj.%Get("BasicDrug")					;基本药物标志
	s CodeX=PJObj.%Get("CodeX")							;中国药典标志
	s TestFlag=PJObj.%Get("TestFlag")					;临床验证用药标志
	s RecFlag=PJObj.%Get("RecFlag")						;处方购药标志 
	s QualityNo=PJObj.%Get("QualityNo")					;质量编号
	s ComFrom=PJObj.%Get("ComFrom")						;国/省别
	s HighPrice=PJObj.%Get("HighPrice")					;高值类标志
	s MarkTypeDr=PJObj.%Get("MarkType")					;定价类型id
	s MaxSp=PJObj.%Get("MaxSp")							;最高售价
	s InHosFlag=PJObj.%Get("InHosFlag")					;本院药品目录
	s PbFlag=PJObj.%Get("PbFlag")						;招标标志
	s PbRp=PJObj.%Get("PbRp")							;招标进价
	s PbLevel=PJObj.%Get("PbLevel")						;招标级别
	s PbNo=PJObj.%Get("PbNo")							;中标编号
	s PbVendorId=PJObj.%Get("PbVendor")					;招标供应商id
	s PbManfId=PJObj.%Get("Manf")						;招标生产商id
	s PbCarriorId=PJObj.%Get("PbCarrier")				;招标配送商id
	s PbLDr=PJObj.%Get("Pb")							;招标名称,DHC_PublicBiddingList
	s BaFlag=PJObj.%Get("BaFlag")						;阳光采购标志
	s ExpireLen=PJObj.%Get("ExpireLen")					;效期长度
	s PrcFile=PJObj.%Get("PrcFile")						;物价文件号
	s PrcFileDate=PJObj.%Get("PrcDate")					;物价文件备案时间
	s SkinFlag=PJObj.%Get("SkinFlag")					;皮试标志
	s BookCatId=PJObj.%Get("BookCat")					;帐簿分类id
	s DrugUse=PJObj.%Get("DrugUse")						;用药说明
	s BasicDrug2=PJObj.%Get("BasicDrug2")				;基本药物标志2
	s PDrugBase1=PJObj.%Get("PDrugBase1")				;省增补药物标志1
	s PDrugBase2=PJObj.%Get("PDrugBase2")				;省增补药物标志2
	s StanderCode=PJObj.%Get("StanderCode")				;药品本位码
	s InMedBasis=PJObj.%Get("InMedBasis")				;进药依据
	s PackUom=PJObj.%Get("PackUom")						;大包装单位
	s PackUomFac=PJObj.%Get("PackUomFac")				;大包装单位系数
	s HighRiskFlag=PJObj.%Get("HighRiskFlag")			;高危药品标志
	s NotUseReason=PJObj.%Get("NotUseReason")			;不可用原因
	s InsuCat=PJObj.%Get("InsuCat")						;医保类别
	s Brand=PJObj.%Get("Brand")							;品牌
	s Model=PJObj.%Get("Model")							;型号
	s ChargeFlag=PJObj.%Get("ChargeFlag")				;收费标志
	s Abbrev=PJObj.%Get("Abbrev")						;简称
	s Supervision=PJObj.%Get("Supervision")				;监管级别
	s ImplantationMat=PJObj.%Get("ImplantationMat")		;植入标志
	s reqType=PJObj.%Get("ReqType")						;物资请领类型
	s noLocReq=PJObj.%Get("NoLocReq")					;禁止请领类型
	s INFOSterile=PJObj.%Get("SterileDateLen")			;灭菌时间
	s INFOZeroStk=PJObj.%Get("ZeroStk")					;零库存标志
	s INFOMedEqptCat=PJObj.%Get("MedEqptCat")			;器械分类
	s INFOPackCharge=PJObj.%Get("PackCharge")			;打包收费
	s BidDate=PJObj.%Get("PbDate")
	s BidDate=..DH2L(BidDate)
	s Origin=PJObj.%Get("Origin")
	s FirstReqDept=PJObj.%Get("FirstReqLoc")
	s SCategoryId=PJObj.%Get("SterileCat")
	s MatQualitydesc=PJObj.%Get("Quality")
	s CentralPurFlag=PJObj.%Get("CentralPurFlag")		;集中采购
	s TemPurchase=PJObj.%Get("TemPurchase")				;临采
	s SpeFlag=PJObj.%Get("SpeFlag")						;阳光采购

	s UseFlag=..CheckUsed(InciId)						;库存项是否已经使用
	s OldNotUseFlag=""
	s NIRowId=PJObj.%Get("NIRowId")
	s Matflag=PJObj.%Get("MatFlag")						;计量标识
	s Application=PJObj.%Get("Application")				;用途
	s MaterinalFunction=PJObj.%Get("MaterinalFunction")	;功能
	s Official=PJObj.%Get("Official")
	s ClinicCat=PJObj.%Get("ClinicCat")
	s SpecialCat=PJObj.%Get("SpecialCat")
	s MonitorFlag=PJObj.%Get("MonitorFlag")
	s InciEndDate=PJObj.%Get("InciEndDate")
	s:InciEndDate'="" InciEndDate=..DH2L(InciEndDate)
	s BatchCodeFlag=PJObj.%Get("BatchCodeFlag")
	
	s RegNoId=PJObj.%Get("RegNoId")
	s RegCertNo=PJObj.%Get("RegCertNo")					;注册证号
	s IRRegCertExpDate=PJObj.%Get("RegCertExpDate")		;注册证日期
	i IRRegCertExpDate'="" d
	.s IRRegCertExpDate=..DH2L(IRRegCertExpDate)
	s RegCertItmDesc=PJObj.%Get("RegItmDesc")
	s RegCertDateOfIssue=PJObj.%Get("RegCertDate")		;注册证发证日期
	s RegCertDateOfIssue=..DH2L(RegCertDateOfIssue)
	s RegCertExpDateExtended=PJObj.%Get("RegCertExpDateExtended")  ;注册证延长效期标志
	s RegValidLong=PJObj.%Get("RegValidLong")			;注册证效期长期标记
	
	s MatInsuCode=PJObj.%Get("MatInsuCode")				;国家医保编码
	s MatInsuDesc=PJObj.%Get("MatInsuDesc")				;国家医保名称
	s ExpireCheckLen=PJObj.%Get("ExpireCheckLen")		;效期验证长度
	s PurCode=PJObj.%Get("PurCode")						;阳光采购编码
	s EquAssCode=PJObj.%Get("EquAssCode")				;装备协会编码
	s HOOKNetPrice=PJObj.%Get("HOOKNetPrice")			;挂网价格
	s OTC=PJObj.%Get("OTC")								;挂网id
	s SunPurType=PJObj.%Get("SunPurType")				;阳光采购类型
	s PackUomM=PJObj.%Get("PackUomM")					;中包装单位
	s PackUomMFac=PJObj.%Get("PackUomMFac")				;中包装单位系数
	s HosCategoryFlag=PJObj.%Get("HosCategoryFlag")		;人工器官标志
	s ProtectionFlag=PJObj.%Get("ProtectionFlag")		;防护标志
	s EpidemicFlag=PJObj.%Get("EpidemicFlag")			;防疫标志
	s BeChoseFlag=PJObj.%Get("BeChoseFlag")				;是否中选标志
	s SterileFlag=PJObj.%Get("SterileFlag")				;是否无菌标志
	s NeedSterFlag=PJObj.%Get("NeedSterFlag")			;使用前是否需灭菌标志
	s ForbidDispFlag=PJObj.%Get("ForbidDispFlag")		;禁止发放消耗标志
	s RecMaxQty=PJObj.%Get("RecMaxQty")					;临采入库最大量
	;带量采购
	s PurNo=PJObj.%Get("PurNo")
	s UpdateDate=+$h
	s UpdateTime=$p($h,",",2)
	s:PrcFileDate'="" PrcFileDate=..DH2L(PrcFileDate)
	
	i InciCode="" q RtnObj.Err(-1,"","库存项代码不能为空!","",0)
	i InciDesc="" q RtnObj.Err(-1,"","库存项名称不能为空!","",0)
	i BUomId="" q RtnObj.Err(-1,"","基本单位不能为空!","",0)
	i PurUomId="" q RtnObj.Err(-1,"","入库单位不能为空!","",0)
	i StkCatId="" q RtnObj.Err(-1,"","库存分类不能为空!","",0)
	i '$d(^INC("SC",StkCatId)) q RtnObj.Err(-1,"","无效的库存分类!","",0) 
	i '$d(^CT("UOM",BUomId)) q RtnObj.Err(-1,"","无效的基本单位!","",0)
	i '$d(^CT("UOM",PurUomId)) q RtnObj.Err(-1,"","无效的入库单位!","",0)
	s codeOnlyFlag=##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("CodeOnly")
	i codeOnlyFlag="Y" d
	.s TmpId=$o(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z",""))
	e  d
	.s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",InciCode,"INC_Itm",Hosp,InciId) 
	
	i (TmpId'="")&(TmpId'=InciId) q RtnObj.Err(-1,"","库存项代码已经存在，不能重复!","",0)
	i (PurUomId'=BUomId)&&'$d(^CT("CTCF",0,"UOM",PurUomId,BUomId)) q RtnObj.Err(-1,"","基本单位和入库单位之间不存在转换关系!","",0)     
	s TmpId=..CheckBarCode(BarCode)
	i (TmpId'="")&(TmpId'=InciId) q RtnObj.Err(-1,"","条码重复维护!","",0)
	s memoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s Remarks=$LFS(Remarks,memoDelim) //将备注串( $c(3)分隔 )转换为list
	
	i NIRowId'="" d
	.;这里是否重新获取RegCertNo
	
	i InciId="" d
	.s IncObj=##class(User.INCItm).%New()
	.s OldJsonStr=""
	e  d
	.s IncObj=##class(User.INCItm).%OpenId(InciId,0)
	.d IncObj.%Reload()
	.s OldNotUseFlag=IncObj.INCINotUseFlag
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_Itm",InciId)
	s IncObj.INCICode=InciCode
	s IncObj.INCIDesc=InciDesc
	i UseFlag'="Y" d IncObj.INCICTUOMDRSetObjectId(BUomId)
	d IncObj.INCIINCSCDRSetObjectId(StkCatId)
	d IncObj.INCICTUOMPurchDRSetObjectId(PurUomId)
	s IncObj.INCINotUseFlag=NotUseFlag
	d IncObj.INCIOriginalARCIMDRSetObjectId(ArcimId)
	s IncObj.INCIIsTrfFlag="B"
	s IncObj.INCIBatchReq=BatFlag
	s IncObj.INCIExpReq=ExpireFlag
	s IncObj.INCIUpdateDate=UpdateDate
	s IncObj.INCIUpdateTime=UpdateTime
	d IncObj.INCIUpdateUserSetObjectId(UpdateUserId)
	s IncObj.INCIBarCode=BarCode
	s IncObj.INCIReportingDays=XieHeCode
	d IncObj.INCICTLOCDRSetObjectId(SupplyLocField)
	d IncObj.INCISterCatDRSetObjectId(SCategoryId)
	d IncObj.INCIRemarks.Clear()
	d IncObj.INCIRemarks.InsertList(Remarks)
	s Sc=IncObj.%Save()
	i $$$ISERR(Sc) d
	.d RtnObj.Err(-2,"",$ClassName()_"插入库存项失败:"_InciCode_","_InciDesc_","_BUomId_","_StkCatId_","_PurUomId_","_NotUseFlag_","_ArcimId)
	q:RtnObj.success'=0 RtnObj
	s InciId=IncObj.%Id()
	
	
	;获取注册证Id
	s RegCertId=$s(RegCertNo'="":$o(^DHCMRCT(0,"NO",RegCertNo,""),-1),1:"")
	i (RegCertNo'="")&&(RegCertId="") d
	.s regTitle="MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc^MRCValidExtend"
	.s regData=RegCertNo_"^"_RegCertDateOfIssue_"^"_IRRegCertExpDate_"^"_RegCertItmDesc_"^"_RegCertExpDateExtended
	.s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	.s paramstr=InciId_"^"_PbManfId_"^"_Hosp
	.s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(regObj,paramstr)
	.q:RtnObj.success<0
	.s RegCertId=RtnObj.rowid
	e  i (RegCertNo'="")&&(RegCertId'="") d
	.s regTitle="MRCNo^InciId^PbManfId^Hosp"
	.s regData=RegCertNo_"^"_InciId_"^"_PbManfId_"^"_Hosp
	.s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	.s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).saveItmRegRelations(regObj)
	.q:RtnObj.success<0
	q:RtnObj.success'=0 RtnObj
	
	s AddInci=$o(^DHCITMINFO(0,"INCI",InciId,0))
	i AddInci=""  d
	.s AddIncObj=##class(User.DHCItmAddionInfo).%New()
	.d AddIncObj.INFOINCIDRSetObjectId(InciId)
	.s OldJsonStrCh=""
	e  d
	.s AddIncObj=##class(User.DHCItmAddionInfo).%OpenId(AddInci)
	.d AddIncObj.%Reload()
	.s OldJsonStrCh=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmAddionInfo",AddInci)
	s AddIncObj.INFOImportFlag=ImpFlag
	d AddIncObj.INFOQualityLevelSetObjectId(QualityLev)
	;s AddIncObj.INFOBasicDrug=BasicDrug
	;s AddIncObj.INFOOTC=OTC
	s AddIncObj.INFOCodex=CodeX
	s AddIncObj.INFOTest=TestFlag
	s AddIncObj.INFOREC=RecFlag
	s AddIncObj.INFOQualityNo=QualityNo
	s AddIncObj.INFOComFrom=ComFrom
	s AddIncObj.INFOHighPrice=HighPrice
	d AddIncObj.INFOMTDRSetObjectId(MarkTypeDr)
	s AddIncObj.INFOMaxSp=MaxSp
	s AddIncObj.INFOInHosFlag=InHosFlag
	s AddIncObj.INFOPbRp=PbRp
	d AddIncObj.INFOPBLDRSetObjectId(PbLDr)
	d AddIncObj.INFOPbVendorDRSetObjectId(PbVendorId)
	d AddIncObj.INFOPbManfDRSetObjectId(PbManfId)
	d AddIncObj.INFOPbCarrierDRSetObjectId(PbCarriorId)
	s AddIncObj.INFOSpec=Spec
	s AddIncObj.INFOBAflag=BaFlag
	d AddIncObj.INFOPBLevelSetObjectId(PbLevel)
	s AddIncObj.INFOExpireLen=ExpireLen
	s AddIncObj.INFOPrcFile=PrcFile
	s AddIncObj.INFOPrcFileD=PrcFileDate
	s AddIncObj.INFOSkinTest=SkinFlag
	d AddIncObj.INFOBCDrSetObjectId(BookCatId)
	s AddIncObj.INFODrugUse=DrugUse
	s AddIncObj.INFODrugbase2=BasicDrug2
	s AddIncObj.INFOPDrugbase1=PDrugBase1
	s AddIncObj.INFOPDrugbase2=PDrugBase2
	s AddIncObj.INFOStandardCode=StanderCode
	s AddIncObj.INFOInMedBasis=InMedBasis
	d AddIncObj.INFONotUseReasonDrSetObjectId(NotUseReason)
	d AddIncObj.INFOInsuCatDRSetObjectId(InsuCat)
	s AddIncObj.INFOHighRiskFlag=HighRiskFlag
	s AddIncObj.INFOPackUom=PackUom
	s AddIncObj.INFOPackUomFactor=PackUomFac
	s AddIncObj.INFOBrand=Brand
	s AddIncObj.INFOModel=Model
	s AddIncObj.INFOChargeFlag=ChargeFlag
	s AddIncObj.INFOAbbrev=Abbrev
	s AddIncObj.INFOSupervision=Supervision
	s AddIncObj.INFOImplantationMat=ImplantationMat
	s AddIncObj.INFOReqModeLimited=reqType
	s AddIncObj.INFONoLocReq=noLocReq
	s AddIncObj.INFOSterileDateLen=INFOSterile
	s AddIncObj.INFOZeroStk=INFOZeroStk
	s AddIncObj.INFOMedEqptCatDR=INFOMedEqptCat
	s AddIncObj.INFOPackCharge=INFOPackCharge
	s AddIncObj.INFOBidDate=BidDate
	d AddIncObj.INFOFirstReqDeptSetObjectId(FirstReqDept)
	d AddIncObj.INFOOriginSetObjectId(Origin)
	s AddIncObj.INFOMatQuality=MatQualitydesc
	d AddIncObj.INFOCreateUserSetObjectId(UpdateUserId)
	s AddIncObj.INFOMetring=Matflag
	s AddIncObj.INFOApplication=Application
	s AddIncObj.INFOFunction=MaterinalFunction
	s AddIncObj.INFOMatCatOfficialDR=Official
	s AddIncObj.INFOMatCatClinicalDR=ClinicCat
	s AddIncObj.INFOMatCatSpecialDR=SpecialCat
	s AddIncObj.INFOMatRegCertDR=RegCertId
	s AddIncObj.INFOMonitorFlag=MonitorFlag
	s AddIncObj.INFOEndDate=InciEndDate
	s AddIncObj.INFOBatchCodeFlag=BatchCodeFlag
	s AddIncObj.INFOCentralPurFlag=CentralPurFlag
	s AddIncObj.INFOTemPurchase=TemPurchase
	s AddIncObj.INFOSpeFlag=SpeFlag
	s AddIncObj.INFOPbFlag=PbFlag
	s AddIncObj.INFOInsuMatCode=MatInsuCode
	s AddIncObj.INFOExpireCheckLen=ExpireCheckLen
	s AddIncObj.INFOInsuMatDesc=MatInsuDesc
	s AddIncObj.INFOPurPlanCode=PurCode
	s AddIncObj.INFOEquAssCode=EquAssCode
	s AddIncObj.INFOHOOKNet=HOOKNetPrice
	s AddIncObj.INFOPackUomM=PackUomM
	s AddIncObj.INFOPackUomFactorM=PackUomMFac
	s AddIncObj.INFOHosCategory=HosCategoryFlag
	s AddIncObj.INFOProtectionFlag=ProtectionFlag
	s AddIncObj.INFOEpidemicProtectionFlag=EpidemicFlag
	s AddIncObj.INFOTpnFlag=BeChoseFlag
	s AddIncObj.INFOSterileFlag=SterileFlag
	s AddIncObj.INFOSterilizationFlag=NeedSterFlag
	s AddIncObj.INFODistribFlag=ForbidDispFlag
	s AddIncObj.INFOPbNo=PbNo
	s AddIncObj.INFOOTC=OTC
	s AddIncObj.INFOPurWithQtyType=SunPurType
	s AddIncObj.INFORecMaxQty=RecMaxQty
	s Sc=AddIncObj.%Save()
	i $$$ISERR(Sc) d
	.s Sc=$tr($System.Status.GetErrorText(Sc),$c(13,10,0,9))
	.d RtnObj.Err(-3,"","插入库存项附加表失败:"_$ClassName()_","_Sc)
	q:RtnObj.success'=0 RtnObj
	s InfoId=AddIncObj.%Id()       ;库存项附加表rowid
	
	;带量采购信息关联
	s RtnObj=##class(web.DHCSTMHUI.PurchaseInfo).SaveRelation(InciId,PurNo)
	q:RtnObj.success'=0 RtnObj
	
	;保存别名
	s ListAlias=..GetAliasDataStr(InciCode,InciDesc,XieHeCode,RegCertItmDesc)
	s RtnObj=##class(web.DHCSTMHUI.INCALIAS).Save(InciId,ListAlias)
	q:RtnObj.success'=0 RtnObj
	
	s:OldNotUseFlag="" OldNotUseFlag="N"
	s:NotUseFlag="" NotUseFlag="N"
	i (ArcimId'="")&(OldNotUseFlag'=NotUseFlag) d
	.;设置库存项不可用时自动设置医嘱项截止日期
	.s AutoSetEffDateTo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoSetArcimEffDateto",paramStr)
	.i AutoSetEffDateTo="Y" d
	..s RtnObj=##class(web.DHCSTMHUI.ARCITMMAST).UpdateEffDeteTo(ArcimId,OldNotUseFlag)
	.q:RtnObj.success'=0
	.;设置库存项不可用时自动设置医嘱项不可用
	.s AutoSetArcimNotUse=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoSetArcimNotUse",paramStr)
	.i AutoSetArcimNotUse="Y" d
	..s RtnObj=##class(web.DHCSTMHUI.ARCITMMAST).UpdateArcitmNotUse(InciId,ArcimId)
	q:RtnObj.success'=0 RtnObj
	
	;同步<医保医用耗材分类>信息到计费项
	i ((MatInsuCode'="")||(MatInsuDesc'="")) d
	.s RtnObj=##class(web.DHCSTMHUI.ARCITMMAST).HandleTARIInsu(InciId,Hosp)
	q:RtnObj.success<0 RtnObj
	
	i NIRowId'="" d
	.&sql(UPDATE DHC_NewItm SET NI_InciDR=:InciId WHERE NI_RowId=:NIRowId)
	
	i OldJsonStr="" d
	.s RtnObj=##class(Log).SaveLog("INC_Itm","User.INCItm","库存项主表信息(物资)",InciId,InciDesc,"A")
	e  d
	.s RtnObj=##class(Log).SaveLog("INC_Itm","User.INCItm","库存项主表信息(物资)",InciId,InciDesc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	
	i OldJsonStrCh="" d
	.s RtnObj=##class(Log).SaveLog("DHC_ItmAddionInfo","User.DHCItmAddionInfo","库存项附加表信息(物资)",InfoId,InciDesc,"A")
	e  d
	.s RtnObj=##class(Log).SaveLog("DHC_ItmAddionInfo","User.DHCItmAddionInfo","库存项附加表信息(物资)",InfoId,InciDesc,"U","",OldJsonStrCh)
	q:RtnObj.success'=0 RtnObj
	
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveInciHOSP(InciId,Hosp)
	i ret'=0 d RtnObj.Err(-5,"","关联医院库存项失败"_ret)
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// 检验某条码是否已经维护
/// Author:zhangxiao
/// Date:2014-04-18
/// Argu:
/// 	BarCode 条码
/// Return:
///  rowid -存在
///  "" - 不存在
/// w ##class(web.DHCSTMHUI.INCITM).CheckBarCode("")
ClassMethod CheckBarCode(BarCode As %String) As %String
{
	n (BarCode)
	s rowid=""
	q:BarCode="" rowid
	&sql(select INCI_RowId into :rowid from INC_Itm where INCI_BarCode=:BarCode )
	q rowid
}

/// Descript:   判断该库存项是否存在帐目
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
/// Table:
/// Input:库存项id
/// Output:     
/// Return：0：未使用;1：使用
ClassMethod CheckUsed(IncRowid As %String) As %Library.String
{
	n (IncRowid)
	s Flag=0
	q:IncRowid="" 0
	i $d(^DHCINTR(0,"INCI",IncRowid))  d
	.s Flag=1
	q:Flag=1 Flag
	i $d(^DHCINGR(0,"INCI",IncRowid))  d
	.s Flag=1
	q:Flag=1 Flag
	s Chl=$o(^INCI(IncRowid,"IL",0))
	s:Chl'="" Flag=1
	q Flag
}

/// Descript:   查询库存项明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:医嘱项rowid^代码^描述^基本单位id^基本单位^入库单位id^入库单位^库存分类id^库存分类^
/// 转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人id^更新人^售价^进价^供应仓库^备注
/// w ##class(web.DHCSTMHUI.INCITM).Select(995,"")
ClassMethod Select(InciId, HospId, RtnObj) As %Library.String
{
	n (InciId,HospId,RtnObj)
	i InciId="" q RtnObj.Err(-1,"","库存项ID不能为空!","",0)
	i '$d(^INCI(InciId)) q RtnObj.Err(-1,"","库存项不不存在内容!","",0)
	s ArcimId=$p(^INCI(InciId,1),"^",3)
	s InciCode=$p(^INCI(InciId,1),"^",1)
	s InciDesc=$p(^INCI(InciId,1),"^",2)
	s BUomId=$p(^INCI(InciId,1),"^",10)
	s PurUomId=$p(^INCI(InciId,3),"^",6)
	s StkCatId=$p(^INCI(InciId,2),"^",2)
	s CtlocDr=$p(^INCI(InciId,2),"^",1)
	s Remarks=""
	i $d(^INCI(InciId,"REM",1))  d
	.s Remarks=^INCI(InciId,"REM",1)
	s TransFlag=$p(^INCI(InciId,2),"^",6)
	s BatReqFlag=$p(^INCI(InciId,2),"^",10)
	s ExpReqFlag=$p(^INCI(InciId,2),"^",11)
	s AliasStr=""
	s AliasStr=##class(web.DHCSTMHUI.INCALIAS).GetIncAlias(InciId)
	s NotUseFlag=$p(^INCI(InciId,2),"^",9)
	s XieHe=$p(^INCI(InciId,3),"^",11)
	s BarCode=$p(^INCI(InciId,3),"^",9)
	s UpdUserId=$p(^INCI(InciId,3),"^",3)
	s (BuomDesc,PurUomDesc,StkCatDesc,UpdUserName,CtlocDesc)=""
	s:BUomId'="" BuomDesc=$p($G(^CT("UOM",BUomId)),"^",2)
	s:PurUomId'="" PurUomDesc=$p($G(^CT("UOM",PurUomId)),"^",2)
	s:StkCatId'="" StkCatDesc=$p($G(^INC("SC",StkCatId)),"^",2)
	s:UpdUserId'="" UpdUserName=$p($g(^SSU("SSUSR",UpdUserId)),"^",2)
	s:CtlocDr'="" CtlocDesc=$p($G(^CTLOC(CtlocDr)),"^",2)
	s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,HospId)
	s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,HospId)
	s ifexitbatadjpricestr=##class(web.DHCSTMHUI.Common.PriceCommon).IfExitBatAdjprice(InciId,HospId)  ;判断库存项是否存在批次信息
	s ifexitbatadjprice=$p(ifexitbatadjpricestr,"^",1)
	s batflag=$p(ifexitbatadjpricestr,"^",2)  ;批次售价标志
	s incibid=$p(ifexitbatadjpricestr,"^",3)  ;库存项最后一个批次id
	if (batflag=1) d
	.if (ifexitbatadjprice'="Y")  d   ;无批次信息则取调价表中价格信息
	..s aspInfo=..GetINCPrice(InciId,+$h,PurUomId,"")
	..s Rp=$p(aspInfo,"^",1)
	..s Sp=$p(aspInfo,"^",2)
	.e  d
	..s aspInfo=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceByIncib(incibid,"","",HospId,"")		//最后一个批次的批次售价
	e  d
	.s aspInfo=..GetINCPrice(InciId,+$h,PurUomId,"")
	s ExeDate=$p(aspInfo,"^",3) ;调价日期
	
	s StkCatId=$p(^INCI(InciId,2),"^",2)
	s StkGrpType=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetParSCG(StkCatId)
	s StkGrpDesc=""
	s:StkGrpType'="" StkGrpDesc=$p($G(^DHCSCG(StkGrpType)),"^",2)
	
	s SCategoryId=$p(^INCI(InciId,2),"^",14)
	s SCategorydesc=""
	&sql(select scat_desc into :SCategorydesc from INC_SterileCategory where scat_rowid=:SCategoryId)
	s MatQualitydesc="",MatFlag=""
	&sql(select INFO_MatQuality,INFO_Metring into :MatQualitydesc,:MatFlag from DHC_ItmAddionInfo where INFO_INCI_DR=:InciId)
	s UseFlag=..CheckUsed(InciId)    ;库存项是否已经使用
	s BUom=..sssComboStr(BUomId,BuomDesc)
	s PUom=..sssComboStr(PurUomId,PurUomDesc)
	s StkCat=..sssComboStr(StkCatId,StkCatDesc)
	s UpdUser=..sssComboStr(UpdUserId,UpdUserName)
	s SupLoc=..sssComboStr(CtlocDr,CtlocDesc)
	s StkGrp=StkGrpType  //..sssComboStr(StkGrpType,StkGrpDesc)
	s SCategory=..sssComboStr(SCategoryId,SCategorydesc)
	s ContractObj=##class(web.DHCSTMHUI.DHCConTrackManager).GetContByInci(InciId)
	s ContractNo=ContractObj.ContractNo
	s ConStartDate=ContractObj.ConStartDate
	s ConEndDate=ContractObj.ConEndDate
	s ConAuditFlag=ContractObj.ConAuditFlag
	;阳光采购
	s sunpurparamStr="^^^"_HospId
	s SunPurPlanParam=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTCOMMONM","SunPurPlan",sunpurparamStr)
	s SunPurPlanInfo=""
	if SunPurPlanParam="四川省"  d
	.s SunPurPlanInfo=##class(web.DHCSTMHUI.ServiceForSCYGCG).GetSubCode(InciId)
	s GoodId=$p(SunPurPlanInfo,"^",3)
	s SpecMId=""
	s tmpSunPurPlanInfo=$replace(SunPurPlanInfo,"^",",")
	;阳光采购
	s Data=InciId_"^"_InciCode_"^"_InciDesc_"^"_BUom_"^"_PUom
		_"^"_StkGrp_"^"_TransFlag_"^"_BatReqFlag_"^"_ExpReqFlag_"^"_AliasStr_"^"_NotUseFlag
		_"^"_XieHe_"^"_BarCode_"^"_UpdUser_"^"_Sp_"^"_Rp_"^"_SupLoc_"^"_Remarks
		_"^"_ExeDate_"^"_StkCat_"^"_SCategory_"^"_MatQualitydesc
		_"^"_UseFlag_"^"_MatFlag_"^"_ContractNo_"^"_ConStartDate_"^"_ConEndDate_"^"_ConAuditFlag_"^"_GoodId_"^"_SpecMId_"^"_tmpSunPurPlanInfo
	s Title="Inci^InciCode^InciDesc^BUom^PUom"
		_"^StkGrp^TransFlag^BatchNoReq^ExpDateReq^AliasStr^NotUseFlag"
		_"^XieHeCode^BarCode^UpdUser^SpPUom^RpPUom^SupplyLoc^Remarks"
		_"^PreExeDate^StkCat^SterileCat^Quality"
		_"^UseFlag^MatFlag^ContractNo^ConStartDate^ConEndDate^ConAuditFlag^GoodId^SpecMId^SunPurPlanInfo"
	
	s DataAdd=..GetIncAddionDetail(InciId,HospId,.TitleAdd)
	i DataAdd'="" d
	.s Data=Data_"^"_DataAdd
	.s Title=Title_"^"_TitleAdd
	
	s PurData=##class(web.DHCSTMHUI.PurchaseInfo).GetData(InciId,.PurTitle)
	i PurData'="" d
	.s Data=Data_"^"_PurData
	.s Title=Title_"^"_PurTitle
	
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
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
/// 
/// w ##class(web.DHCSTMHUI.INCITM).GetIncAddionDetail(7192)
ClassMethod GetIncAddionDetail(InciId, HospId, TitleAdd) As %Library.String
{
	n (InciId,HospId,TitleAdd)
	q:InciId="" ""
	s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
	i Info="" q ""
	
	s InfoData=$g(^DHCITMINFO(Info))
	s ImpFlag=$p(InfoData,"^",2)
	s QualityLevId=$p(InfoData,"^",3)
	s BasicDrug=$p(InfoData,"^",4)
	s OTC=$p(InfoData,"^",5)
	s TestFlag=$p(InfoData,"^",6)
	s CodeX=$p(InfoData,"^",7)
	s QualityNo=$p(InfoData,"^",8)
	s ComFrom=$p(InfoData,"^",9)
	s RecFlag=$p(InfoData,"^",11)
	s HighPrice=$p(InfoData,"^",12)
	s Signature=$p(InfoData,"^",13)
	s MtDr=$p(InfoData,"^",15)
	s MaxSp=$p(InfoData,"^",16)
	s InHosFlag=$p(InfoData,"^",21)
	s PbRp=$p(InfoData,"^",22)
	s PbLDr=$p(InfoData,"^",23)
	s PbCarrierId=$p(InfoData,"^",26)
	s Spec=$p(InfoData,"^",27)
	s StoreConId=$p(InfoData,"^",28)
	s BaFlag=$p(InfoData,"^",29)
	s PbLevelId=$p(InfoData,"^",30)
	s ExpireLen=$p(InfoData,"^",32)
	s PrcFile=$p(InfoData,"^",33)
	s PrcFileD=$p(InfoData,"^",34)
	s SkinFlag=$p(InfoData,"^",35)
	s BookCatId=$p(InfoData,"^",36)
	s DrugUse=$p(InfoData,"^",38)
	s BasicDrug2=$p(InfoData,"^",40)
	s PBasicDrug=$p(InfoData,"^",41)
	s PBasicDrug2=$p(InfoData,"^",42)
	s StanderCode=$p(InfoData,"^",44)
	s InMedBasis=$p(InfoData,"^",45)
	s NotUseReasonDr=$p(InfoData,"^",47)
	s InsuCatDr=$p(InfoData,"^",49) 
	s HighRiskFlag=$p(InfoData,"^",50) 
	s PackUomId=$p(InfoData,"^",51)
	s PackUomFac=$p(InfoData,"^",52)
	s chargeFlag=$p(InfoData,"^",57)
	s Brand=$p(InfoData,"^",58)
	s Model=$p(InfoData,"^",59)
	s Abbrev=$p(InfoData,"^",60)
	s Supervision=$p(InfoData,"^",61)
	s ImplantationMat=$p(InfoData,"^",62)
	s ReqModeLimited=$p(InfoData,"^",73)
	s NoLocReq=$p(InfoData,"^",74)
	s SpeFlag=$p(InfoData,"^",76)
	s INFOSterile=$p(InfoData,"^",79)
	s INFOMedEqptCat=$p(InfoData,"^",80)
	s INFOZeroStk=$p(InfoData,"^",81)
	s INFOPackCharge=$p(InfoData,"^",85)
	s MonitorFlag=$p(InfoData,"^",93)
	s BidDate=$p(InfoData,"^",98)
	s FirstReqDept=$p(InfoData,"^",99)
	s Origin=$p(InfoData,"^",100)
	s Official=$p(InfoData,"^",107)
	s ClinicCatId=$p(InfoData,"^",108)
	s SpecialCatId=$p(InfoData,"^",109)
	s InciEndDate=$p(InfoData,"^",31)
	s PurCode=$p(InfoData,"^",56)
	s HOOKNetPrice=$p(InfoData,"^",43)
	s HosCategoryFlag=$p(InfoData,"^",87)
	s BeChoseFlag=$p(InfoData,"^",39)
	s ForbidDispFlag=$p(InfoData,"^",55)
	s PackUomMId=$p(InfoData,"^",88)
	s PackUomMFac=$p(InfoData,"^",89)
	s PbNo=$p(InfoData,"^",63)
	s OTC=$p(InfoData,"^",5)
	s RecMaxQty=$p(InfoData,"^",121)
	
	s InfoData1=$g(^DHCITMINFO(Info,1))
	s CentralPurFlag=$p(InfoData1,"^",9)
	s TemPurchase=$p(InfoData1,"^",17)
	s RegNoId=$p(InfoData1,"^",18)
	s INFORiskCategory=$p(InfoData1,"^",19)
	s INFOConsumableLevel=$p(InfoData1,"^",20)
	s INFOApplication=$p(InfoData1,"^",21)
	s INFOFunction=$p(InfoData1,"^",22)
	s BatchCodeFlag=$p(InfoData1,"^",23)
	;s MatInsuCode=$p(InfoData1,"^",39)
	s ExpireCheckLen=$p(InfoData1,"^",45)
	s EquAssCode=$p(InfoData1,"^",37)
	s ProtectionFlag=$p(InfoData1,"^",34)
	s EpidemicFlag=$p(InfoData1,"^",35)
	s SterileFlag=$p(InfoData1,"^",41)
	s NeedSterFlag=$p(InfoData1,"^",42)
	s SunPurType=$p(InfoData1,"^",49)
	
	s MtDesc=$s(MtDr'="":$p($g(^DHCINMT(MtDr)),"^",2),1:"")
	s PbCarrierDesc=$s(PbCarrierId'="":$p($g(^DHCCARR(PbCarrierId)),"^",2),1:"")
	s PbLDesc=$s(PbLDr'="":$p($g(^DHCPBLIST(PbLDr)),"^",2),1:"")
	s BookCatDesc=$s(BookCatId'="":$p($g(^DHCSTBC(BookCatId)),"^",2),1:"")
	s:PrcFileD'="" PrcFileD=..DL2H(PrcFileD)
	s QualityLev=$s(QualityLevId'="":$p($g(^DHCITMQL(QualityLevId)),"^",2),1:"")
	s PbLevel=$s(PbLevelId'="":$p($g(^DHCITMPBL(PbLevelId)),"^",2),1:"")
	s NotUseReason=$s(NotUseReasonDr'="":$p($g(^DHCNUR(NotUseReasonDr)),"^",1),1:"")
	s InsuCat=$s(+InsuCatDr'=0:$p($g(^DHCITMIC(InsuCatDr)),"^",2),1:"")
	s PackUom=$s(+PackUomId'=0:$p($g(^CT("UOM",PackUomId)),"^",2),1:"")
	i BidDate'="" s BidDate=..DL2H(BidDate)
	s FirstReqDeptDesc=$s(FirstReqDept'="":$p($g(^CTLOC(FirstReqDept)),"^",2),1:"")
	s OriginName=$s(Origin'="":$p($g(^DHCSTORI(Origin)),"^",2),1:"")
	s OfficialName=$s(Official'="":$p($g(^DHCMCO(Official)),"^",2),1:"")
	s ClinicCatName=$s(ClinicCatId'="":$p($g(^DHCMCC(ClinicCatId)),"^",2),1:"")
	s SpecialCatName=$s(SpecialCatId'="":$p($g(^DHCMCS(SpecialCatId)),"^",2),1:"")
	s:InciEndDate'="" InciEndDate=..DL2H(InciEndDate)
	s PackUomMDesc=$s(+PackUomMId'=0:$p($g(^CT("UOM",PackUomMId)),"^",2),1:"")
	
	s StoreCond=##class(web.DHCSTMHUI.ITMSTORECON).GetStoreCond(InciId)
	s PbFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetItmPbFlag(InciId)
	s PbVendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(InciId)
	s PbVendorId=$p(PbVendorInfo,"^",1)
	s PbVendorDesc=$p(PbVendorInfo,"^",2)
	s PbManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(InciId)
	s PbManfId=$p(PbManfInfo,"^",1)
	s PbManfDesc=$p(PbManfInfo,"^",2)
	s (RegCertNo,IRRegCertExpDate,RegItmDesc,RegDateOfIssue,RegValidLong,RegExpExtended,Full,RegSpecNum)=""
	s CertStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
	i CertStr'="" d
	.s RegCertNo=$p(CertStr,"^",1)
	.s IRRegCertExpDate=$p(CertStr,"^",2)
	.s RegItmDesc=$p(CertStr,"^",3)
	.s RegDateOfIssue=$p(CertStr,"^",22)
	.s RegValidLong=$p(CertStr,"^",7)
	.s RegExpExtended=$p(CertStr,"^",6)
	.s Full=$p(CertStr,"^",4)
	.s RegSpecNum=$p(CertStr,"^",20)
	
	s MatInsuInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetMatInsuInfo(InciId,HospId)
	s MatInsuCode=$p(MatInsuInfo,"^",1)
	s MatInsuDesc=$p(MatInsuInfo,"^",2)
	s MatClassInsuInfo=##class(web.DHCSTMHUI.InsuMatCode).GetInsuMatInfo(MatInsuCode)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(MatClassInsuInfo)
	s MatInsuClass1=PJObj.%Get("MatInsuClass1")
	s MatInsuClass2=PJObj.%Get("MatInsuClass2")
	s MatInsuClass3=PJObj.%Get("MatInsuClass3")
	s MatInsuGeneric=PJObj.%Get("MatInsuGeneric")
	s MatInsuQuality=PJObj.%Get("MatInsuQuality")
	s MatInsuSpec=PJObj.%Get("MatInsuSpec")
	s MatInsuManfName=PJObj.%Get("MatInsuManfName")
	
	s Official=..sssComboStr(Official,OfficialName)
	s ClinicCat=..sssComboStr(ClinicCatId,ClinicCatName)
	s SpecialCat=..sssComboStr(SpecialCatId,SpecialCatName)
	s QualityLev=..sssComboStr(QualityLevId,QualityLev)
	S PbVendor=..sssComboStr(PbVendorId,PbVendorDesc)
	s PbManf=..sssComboStr(PbManfId,PbManfDesc)
	s PbCarrier=..sssComboStr(PbCarrierId,PbCarrierDesc)
	s BookCat=..sssComboStr(BookCatId,BookCatDesc)
	s NotUseReason=..sssComboStr(NotUseReasonDr,NotUseReason)
	s Origin=..sssComboStr(Origin,OriginName)
	s FirstReqDept=..sssComboStr(FirstReqDept,FirstReqDeptDesc)
	s PackUom=..sssComboStr(PackUomId,PackUom)
	s Pb=..sssComboStr(PbLDr,PbLDesc)
	s Mt=..sssComboStr(MtDr,MtDesc)
	s PbLevel=..sssComboStr(PbLevelId,PbLevel)
	s PackUomM=..sssComboStr(PackUomMId,PackUomMDesc)
	
	s SunPurType="["_SunPurType_"]"	//多选

	s Data=ImpFlag_"^"_QualityLev_"^"_OTC_"^"_BasicDrug_"^"_CodeX_"^"_TestFlag_"^"_RecFlag
		_"^"_QualityNo_"^"_ComFrom_"^"_RegCertNo_"^"_HighPrice_"^"_Signature_"^"_Mt
		_"^"_MaxSp_"^"_StoreConId_"^"_InHosFlag_"^"_PbFlag_"^"_PbRp_"^"_Pb
		_"^"_PbVendor_"^"_PbManf_"^"_PbCarrier
		_"^"_PbLevel_"^"_BaFlag_"^"_ExpireLen_"^"_PrcFile_"^"_PrcFileD_"^"_SkinFlag
		_"^"_BookCat_"^"_DrugUse_"^"_BasicDrug2_"^"_PBasicDrug_"^"_PBasicDrug2
		_"^"_StanderCode_"^"_InMedBasis_"^"_Spec_"^"_NotUseReason_"^"_InsuCatDr
		_"^"_InsuCat_"^"_HighRiskFlag_"^"_PackUom_"^"_PackUomFac
		_"^"_PbLevelId_"^"_Brand_"^"_Model_"^"_chargeFlag_"^"_Abbrev_"^"_Supervision
		_"^"_ImplantationMat_"^"_ReqModeLimited_"^"_NoLocReq_"^"_INFOSterile_"^"_INFOZeroStk_"^"_INFOMedEqptCat_"^"_IRRegCertExpDate_"^"_INFOPackCharge
		_"^"_RegItmDesc_"^"_RegDateOfIssue_"^"_RegExpExtended_"^"_Full_"^"_RegSpecNum_"^"_BidDate_"^"_FirstReqDept_"^"_Origin_"^"_StoreCond_"^"_RegNoId
		_"^"_INFORiskCategory_"^"_INFOConsumableLevel_"^"_INFOApplication_"^"_INFOFunction_"^"_Official_"^"_RegValidLong_"^"_MonitorFlag_"^"_InciEndDate_"^"_BatchCodeFlag
		_"^"_CentralPurFlag_"^"_TemPurchase_"^"_MonitorFlag_"^"_SpeFlag
		_"^"_MatInsuCode_"^"_MatInsuClass1_"^"_MatInsuClass2_"^"_MatInsuClass3_"^"_MatInsuGeneric_"^"_MatInsuQuality_"^"_MatInsuSpec_"^"_MatInsuManfName
		_"^"_ExpireCheckLen_"^"_ClinicCat_"^"_SpecialCat_"^"_MatInsuDesc_"^"_PurCode_"^"_EquAssCode
		_"^"_HOOKNetPrice_"^"_HosCategoryFlag_"^"_ProtectionFlag_"^"_EpidemicFlag_"^"_BeChoseFlag_"^"_SterileFlag
		_"^"_NeedSterFlag_"^"_ForbidDispFlag_"^"_PackUomM_"^"_PackUomMFac_"^"_PbNo_"^"_OTC_"^"_SunPurType_"^"_RecMaxQty
	s TitleAdd="ImpFlag^QualityLev^OTC^BasicDrug^CodeX^TestFlag^RecFlag"
		_"^QualityNo^ComFrom^RegCertNo^HighPrice^Signature^MarkType"
		_"^MaxSp^StoreConId^InHosFlag^PbFlag^PbRp^Pb"
		_"^PbVendor^Manf^PbCarrier"
		_"^PbLevel^BaFlag^ExpireLen^PrcFile^PrcDate^SkinFlag"
		_"^BookCat^DrugUse^BasicDrug2^PBasicDrug^PBasicDrug2"
		_"^StanderCode^InMedBasis^Spec^NotUseReason^InsuCatDr"
		_"^InsuCat^HighRiskFlag^PackUom^PackUomFac"
		_"^PbLevelId^Brand^Model^ChargeFlag^Abbrev^Supervision"
		_"^ImplantationMat^ReqType^NoLocReq^SterileDateLen^ZeroStk^INFOMedEqptCat^RegCertExpDate^PackCharge"
		_"^RegItmDesc^RegCertDate^RegCertExpDateExtended^RegCertName^RegSpecNum^PbDate^FirstReqLoc^Origin^StoreCond^RegNoId"
		_"^RiskCategory^ConsumableLevel^Application^MaterinalFunction^Official^RegValidLong^MonitorFlag^InciEndDate^BatchCodeFlag"
		_"^CentralPurFlag^TemPurchase^MonitorFlag^SpeFlag"
		_"^MatInsuCode^MatInsuClass1^MatInsuClass2^MatInsuClass3^MatInsuGeneric^MatInsuQuality^MatInsuSpec^MatInsuManfName"
		_"^ExpireCheckLen^ClinicCat^SpecialCat^MatInsuDesc^PurCode^EquAssCode"
		_"^HOOKNetPrice^HosCategoryFlag^ProtectionFlag^EpidemicFlag^BeChoseFlag^SterileFlag"
		_"^NeedSterFlag^ForbidDispFlag^PackUomM^PackUomMFac^PbNo^OTC^SunPurType^RecMaxQty"
	q Data
}

/// Descript:   删除库存项相关信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:INC_Itm
/// Input:库存项rowid
/// Output:     
/// Return：0，成功
/// -2  ;删除库存项失败
/// -3  ;删除库存项附加信息失败
/// -4  ;删除库存项别名失败
/// -5  ;删除调价记录失败
ClassMethod Delete(InciRowid) As %Library.String
{
	n (InciRowid,%session)
	s RtnObj=##class(RtnObj).%New()
	s paramStr=..sssParamStr()
	q:InciRowid="" 0
	q:'$d(^INCI(InciRowid)) 0
	s Err=0
	tstart
	s $ZT=..sssError()                        ;增加错误处理
	s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("INC_Itm",InciRowid)    
	;删除库存项
	&sql(Delete From Inc_Itm Where INCI_Rowid=:InciRowid)
	i SQLCODE'=0  d
	.trollback
	.s Err=-2                   ;删除库存项失败
	q:Err'=0 Err
	;
	;删除附加信息
	s InfoRowid=$o(^DHCITMINFO(0,"INCI",InciRowid,0))
	s OldJsonStrCh=""
	i InfoRowid'=""  d
	.s OldJsonStrCh=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_ItmAddionInfo",InfoRowid) 
	.&sql(Delete From DHC_ItmAddionInfo Where INFO_Rowid=:InfoRowid)
	.i SQLCODE'=0  d
	..trollback
	..s Err=-3              ;删除库存项附加信息失败
	q:Err'=0 Err
	;删除别名   ;
	s ret=##class(web.DHCSTMHUI.INCALIAS).DeleteItmAlias(InciRowid)
	i ret'=0 trollback
	q:ret'=0 -4     ;删除库存项别名失败
	s ret=##class(web.DHCSTMHUI.INAdjSalePrice).DeleteAdjPrice(InciRowid)
	i ret'=0 trollback
	q:ret'=0 -5         ;删除调价记录失败
	s RtnObj=##class(Log).SaveLog("INC_Itm","User.INCItm","库存项主表信息",InciRowid,"","D",OldJsonStr)
	i RtnObj.success'=0 s ret=-6
	i ret'=0 tro  q ret
	s RtnObj=##class(Log).SaveLog("DHC_ItmAddionInfo","User.DHCItmAddionInfo","库存项附加表信息",InfoRowid,InciRowid,"D",OldJsonStrCh)
	i RtnObj.success'=0 s ret=-7
	i ret'=0 tro  q ret
	
	tcommit
	q 0
}

/// Descript:   获取库存项最大码
/// Creater:    wangjiabin
/// CreateDate: 2013-07-01
/// Table:INC_Itm
/// Input:库存分类rowid
/// Output:     
/// Return：up xuchao2014-2-10
/// w ##class(web.DHCSTMHUI.INCITM).GetMaxCode("{StkCat:"""",FirCode:""AABBD""}")
ClassMethod GetMaxCode(Params) As %Library.String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	s Code=""
	s StkCat=PJObj.%Get("StkCat")
	s FirCode=PJObj.%Get("FirCode")
	s Type=PJObj.%Get("MaxCodeType")   	;Cat FirCode
	i (Type="Cat")&&(StkCat="") d RtnObj.Err(-1,"","库存分类不能为空!","",0)
	i (Type="FirCode")&&(FirCode="") d RtnObj.Err(-1,"","前缀不能为空!","",0)  
	q:RtnObj.success'=0 RtnObj.Json() 
	i Type="Cat" d
	.&sql(select max(inci_code) into :Code from inc_itm where INCI_INCSC_DR=:StkCat)
	e  d
	.s FirCode=$$ALPHAUP^SSUTIL4(FirCode)
	.s FirL=$LENGTH(FirCode)
	.s itmcodeLF=""
	.&sql(select max($LENGTH(inci_code)) into :itmcodeLF from inc_itm Where %ALPHAUP INCI_Code %MATCHES :FirCode_'[0-9]*')
	.i itmcodeLF="" d RtnObj.Err(-21,"","此前缀无对应物资代码","",0) q
	.s padL=itmcodeLF-FirL
	.&sql(select LPAD(max(TO_NUMBER($EXTRACT(inci_code,(:FirL+1),:itmcodeLF))),:padL,'0') into :itmcode from inc_itm Where %ALPHAUP INCI_Code %MATCHES :FirCode_'[0-9]*')
	.s Code=FirCode_itmcode

	i Code="" d RtnObj.Err(-1,"","未成功获取最大码!","",0)
	q:RtnObj.success'=0 RtnObj.Json() 
	s RtnObj.rowid=Code
	q RtnObj.Json()
}

/// 直接修改调价记录
ClassMethod UpdInasp(inasp As %String, puom As %String, buom As %String, Rp As %String, Sp As %String, preExeDate As %String) As %String
{
	n (inasp,puom,buom,Rp,Sp,preExeDate)
	s RtnObj=##class(RtnObj).%New()
	s Rp=+Rp
	s Sp=+Sp
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,buom)
	s resultRp=Rp/fac
	s resultSp=Sp/fac
	i preExeDate'="" s preExeDate=..DH2L(preExeDate)
	&sql(update in_adjsaleprice set inasp_ctuom_dr=:puom,inasp_resultsp=:resultSp,inasp_ctuom_price=:Sp,
	 inasp_ctuom_rp=:Rp,inasp_resultrp=:resultRp,inasp_preexedate=:preExeDate
	 where inasp_rowid=:inasp)
	q:SQLCODE'=0 RtnObj.Err(-1,"","更新价格失败!") 
	i preExeDate'>+$H d
	.s RtnObj=##class(web.DHCSTMHUI.INAdjSalePrice).Exe(inasp)   //自动生效
	q RtnObj
}

/// 坚持是否存在相同代码或相同的名称-规格的库存项
/// Author:zhwh
/// Date:2016-02-26
/// Arguments:
///   inciCode:代码,inciDesc:名称,spec:规格
/// Return:
///   0 : 没有重复,-1:代码重复,-2:名称-规格重复
ClassMethod ItmCheck(inciCode As %String, inciDesc As %String, spec As %String) As %String
{
	n (inciCode,inciDesc,spec)
	&sql(select inci_rowid into :rowid from inc_itm where inci_code=:inciCode)
	q:'SQLCODE -1
	&sql(select info_inci_dr into :rowid from dhc_itmaddioninfo where info_inci_dr->inci_desc=:inciDesc
	and info_spec=:spec)
	q:'SQLCODE -2
	q 0
}

/// Descript:   设置确认标记(用于确认是否需要维护医嘱项)
/// Creator:    wangjiabin
/// CreateDate: 2017-01-09
/// Table:
/// Input:		inci,user
/// Output:		"":成功, 非空:错误信息
/// w ##class(web.DHCSTMHUI.INCITM).SetAckSpFlag("1398","Y","6423")
ClassMethod SetAckSpFlag(InciId As %String, AckFlag As %String, UserId As %String) As %String
{
	n (InciId,AckFlag,UserId)
	s RtnObj=##class(RtnObj).%New()
	i InciId="" d RtnObj.Err(-1,"","参数错误!")
	i RtnObj.success'=0  q RtnObj.Json()
	s arcim=$p(^INCI(InciId,1),"^",3)
	i arcim'="" d RtnObj.Err(-1,"","已维护医嘱项,不可修改!","",0)
	i RtnObj.success'=0  q RtnObj.Json()
	s OldAckFlag=""
	&sql(select INFO_AckSp_Flag into :OldAckFlag from DHC_ItmAddionInfo where INFO_INCI_DR=:InciId)
	i (AckFlag="Y")&&(OldAckFlag="Y") d RtnObj.Err(-1,"","已维护,不可修改!","",0)
	i RtnObj.success'=0  q RtnObj.Json()
	s info=$o(^DHCITMINFO(0,"INCI",InciId,""))
	i info'="" d
	.s obj=##class(User.DHCItmAddionInfo).%OpenId(info)
	e  d
	.s obj=##class(User.DHCItmAddionInfo).%New()
	.d obj.INFOINCIDRSetObjectId(InciId)
	s obj.INFOAckSpFlag=AckFlag
	d obj.INFOAckSpSSUSRDRSetObjectId(UserId)
	s obj.INFOAckSpDate=+$h
	s obj.INFOAckSpTime=$p($h,",",2)
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-1,"","维护失败!")
	i RtnObj.success'=0  q RtnObj.Json()
	q RtnObj.Json()
}

/// Descript:	根据库存项ID、日期、单位及医院取得最近的调价记录
/// Creator:	wangjiabin
/// CreateDate:	2017-01-12
/// Input:		inciid,stdate,uom,HospID
/// Output:		Return
/// Return：	rp^sp^INASP_ExecuteDate(未生效时为INASP_PreExeDate)
/// w ##class(web.DHCSTMHUI.INCITM).GetINCPrice(1519,+$h,17,"")
ClassMethod GetINCPrice(inciid, stdate, uom, HospID = "")
{
	n (inciid,stdate,uom,HospID)
	Q:inciid="" ""
	Q:'$D(^INCI(inciid)) ""
	s rp=0,rp=0,exeDate=""
	S adjrow=""
	;s excudate=stdate+1
	I HospID="" D
	.s excudate=$o(^INASP(0,"INCI",inciid,""),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)
	E  D
	.s excudate=$o(^INASP(0,"HOSPI",HospID,inciid,""),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"HOSPI",HospID,inciid,excudate,""),-1)

	i adjrow="" d
	.s excudate=$o(^INASP(0,"INCI",inciid,""),-1)
	.Q:excudate=""
	.s adjrow=$o(^INASP(0,"INCI",inciid,excudate,""),-1)

	Q:adjrow="" ""
	s sp=+$p(^INASP(adjrow),"^",7)
	s rp=+$p(^INASP(adjrow),"^",16)
	s adjuom=$p(^INASP(adjrow),"^",10)
	s ctuomSp=+$p(^INASP(adjrow),"^",11)
	s ctuomRp=+$p(^INASP(adjrow),"^",14)
	s status=$p(^INASP(adjrow),"^",9)
	s exeDate=$p(^INASP(adjrow),"^",2)				;生效日期
	s:exeDate="" exeDate=$p(^INASP(adjrow),"^",17)	;未生效的,取计划生效日期
	s:exeDate'="" exeDate=..DL2H(exeDate)

	s buom=$p(^INCI(inciid,1),"^",10) ;base uom
	i uom="" s uom=buom ;base uom
	i uom=adjuom  d
	.s sp=ctuomSp
	.s rp=ctuomRp
	e  d
	.s factor=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	.s sp=sp*factor
	.s rp=rp*factor
	i uom=buom d
	.s sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(sp,HospID,2)
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,2)
	e  d
	.s sp=##class(web.DHCSTMHUI.Common.AppCommon).FormatSp(sp,HospID,1)
	.s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,1)

	q rp_"^"_sp_"^"_exeDate_"^"_status_"^"_adjrow
}

/// Description: 根据代码名称等库存项信息获取别名串 
/// Author :zhwh
/// Date :2017-05-17
/// Arguments:
///   InciCode:代码
///   InciDesc:名称
///   XieHeCode:协和码
/// Return:
///     别名串(行分隔符)
ClassMethod GetAliasDataStr(InciCode As %String, InciDesc As %String, XieHeCode As %String, RegItmDesc As %String = "") As %String
{
	n (InciCode,InciDesc,XieHeCode,RegItmDesc)
	s AppName=##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName")
	s paramStr=..sssParamStr()
	;保存别名 
	s rowDelim=","
	s ListAlias=""  
	s AutoAddIAByDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAddIAByDesc",paramStr)
	i AutoAddIAByDesc="Y"  d
	.s AliasByDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc)
	.q:AliasByDesc=""
	.s ListAlias=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasByDesc,"Alias")
	s AutoAddIAByCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAddIAByCode",paramStr)
	i AutoAddIAByCode="Y"  d
	.s AliasByCode=InciCode
	.q:AliasByCode=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_rowDelim_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasByCode,"Alias")
	.e  d
	..s ListAlias=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasByCode,"Alias")
	.
	s AutoAddIAWB=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAddIncAliasWB",paramStr) 
	i AutoAddIAWB="Y"  d
	.s AliasWB=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(InciDesc,6) //五笔码
	.q:AliasWB=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_rowDelim_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasWB,"Alias")
	.e  d
	..s ListAlias=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasWB,"Alias")
	.
	s AutoAddIAXieHe=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAddIncAliasXieHe",paramStr) 
	i AutoAddIAXieHe="Y"  d
	.s XieHeCode=$G(XieHeCode)
	.q:XieHeCode=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_rowDelim_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(XieHeCode,"Alias")
	.e  d
	..s ListAlias=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(XieHeCode,"Alias")
	
	s AutoAddIARegItmDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"AutoAddIARegItmDesc",paramStr) 
	i AutoAddIARegItmDesc="Y"  d
	.q:RegItmDesc=""
	.s AliasByRegItmDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(RegItmDesc)
	.q:AliasByRegItmDesc=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_rowDelim_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasByRegItmDesc,"Alias")
	.e  d
	..s ListAlias=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(AliasByRegItmDesc,"Alias")
	
	q "["_ListAlias_"]"
}

/// 判断是否开医嘱(不考虑医嘱状态等)
/// Created by zhwh
/// Date:2017-09-07
/// Arguments
///    inci - 库存项rowid
/// Return 
///    1 - 已存在医嘱
///    0 - 未存在医嘱
/// w ##class(web.DHCSTMHUI.INCITM).OrdItmExists()
ClassMethod OrdItmExists(inci As %String) As %String
{
	n (inci)
	q:inci="" 0
	s arcim=""
	&sql(select inci_arcim_dr into :arcim from inc_itm where inci_rowid=:inci)
	q:SQLCODE 0
	q:arcim="" 0 
	s oeori=""
	&sql(select top 1 oeori_rowid into :oeori from oe_orditem where oeori_itmmast_dr=:arcim)
	q:SQLCODE 0
	q:oeori="" 0
	q 1
}

/// 判断是否存在未使用高值条码
/// w ##class(web.DHCSTMHUI.INCITM).IfExistEnableLabel(4440)
/// Y-存在  N-不存在
ClassMethod IfExistEnableLabel(Inci As %String) As %String
{
	n (Inci)
	q:(Inci="") "N"
	
	//s HighFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	//s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(Inci)
	//q:HighFlag'="Y" "N"
	//q:TableFlag="Y" "N"
	
	s Flag="N"
	s dhcit=""
	f  s dhcit=$o(^DHCIT(0,"INCI",Inci,dhcit),-1) q:(dhcit="")||(Flag="Y")  d
	.s status=$p(^DHCIT(dhcit),"^",5)
	.q:(status'="Enable")
	.s Incib=$p(^DHCIT(dhcit),"^",7)
	.s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	.i OriginalStatus'="NotUnique" d
	..s Flag="Y"
	.e  d
	..s il=""
	..f  s il=$o(^INCI("LB_IB",Incib,Inci,il)) q:(il="")||(Flag="Y")  d
	...s lb=""
	...f  s lb=$o(^INCI("LB_IB",Incib,Inci,il,lb)) q:(lb="")||(Flag="Y")  d
	....s phyqty=+$p(^INCI(Inci,"IL",il,"LB",lb),"^",2)
	....s:phyqty>0 Flag="Y"
	.
	
	q Flag
}

}
