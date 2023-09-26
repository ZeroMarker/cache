Import sqluser

/// Descript:	入库汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
Class web.DHCSTMHUI.DHCINGdRecStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// 2021-07-31重写说明: 1.组织顺序尽量按 台帐/主表/子表/库存项 顺序进行; 2.如需添加字段,建议再各部分中扩展,避免直接追加在代码最后面;
/// Descript:	入库汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		
/// Return：	入库汇总信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINGdRecStat","QueryDetail",^tmpbin(24))
Query QueryDetail(Params As %Text) As Query(ROWSPEC = "IntrId,Type,No,Date,Qty:%Float,Rp:%Float,Sp:%Float,RpAmt:%Float,SpAmt:%Float,Ingr,VendorId,Vendor,SourceOfFund,GiftFlag,AdjCheque,Ingri,BatNo,Expire,InvNo,InvDate,ManfId,Manf,StkBin,Inclb,CertNo,CertDesc,Inci,InciCode,InciDesc,UomDesc,Spec,Model,Brand,StkGrpDesc,incscdesc,SpType,PbFlag,HVFlag,ChargeFlag,BookCatDesc,MatInsuCode,MatInsuDesc,OfficialCatDesc,ClinicCatDesc,AuditUser") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s RetFlag=PJObj.%Get("RetFlag")
	q:Loc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	//统计入库
	i RetFlag=1 d
	.s qPid=..GetImportDetail(Params)
	.i qPid'="" d OutputRow
	
	//统计退货
	i RetFlag=2 d
	.s qPid=..GetReturnDetail(Params)
	.i qPid'="" d OutputRow
	.
	//统计入库退货
	i RetFlag="" d  
	.s qPid=..GetImportDetail(Params)
	.i qPid'="" d OutputRow
	.s qPid=..GetReturnDetail(Params)
	.i qPid'="" d OutputRow
	
	Quit $$$OK

OutputRow
	s num=0
	f  s num=$o(^TMPDHCSTM(qPid,"INDETAIL",num)) q:num=""  d
	.s Data=^TMPDHCSTM(qPid,"INDETAIL",num)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	k ^TMPDHCSTM(qPid,"INDETAIL")
	q
}

/// Descript:	入库汇总(入库)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	入库汇总信息(入库)
/// w ##class(web.DHCSTMHUI.DHCINGdRecStat).GetImportDetail(^tmpbin(116))
ClassMethod GetImportDetail(Params) As %Library.String
{
	n (Params)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s PLocId=PJObj.%Get("Loc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POperateType=PJObj.%Get("OperateType")	//入库类型
	s PInvNo=PJObj.%Get("InvNo")
	s PHvFlag=PJObj.%Get("HvFlag")
	
	s PSourceOfFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PFindTypeFlag=PJObj.%Get("AdjCheque")		;赠送或者调价换票
	s PUserId=PJObj.%Get("gUserId")
	s PHospId=PJObj.%Get("gHospId")
	s PScgType=PJObj.%Get("ssStkgrptype")		//类组类型 M-库管；O-财务
	//前台页面已去掉部分查询条件
	s PMarkType=PJObj.%Get("MarkType")			//定价类型
	s PImpFlag=PJObj.%Get("ImpFlag")			//进口标志
	s PBatNo=PJObj.%Get("BatNo")				//批号
	s PPbFlag=PJObj.%Get("PbFlag")				//招标标记
	s PRpFrom=PJObj.%Get("RpFrom")
	s PRpTo=PJObj.%Get("RpTo")
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	q:PLocId="" ""
	s pHospId=..sssHospId(PLocId)
	s:pHospId="" pHospId=PHospId
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s PStartTime=..TH2L(PStartTime)
	s PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s TotalScgStr=""
	s LocLength=$l(PLocId,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	
	;入库
	s i=0
	s TrType="G"
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.f Date=PStartDate:1:PEndDate d
	..s DateStr=..DL2H(Date)
	..s IntrId="" 
	..f  s IntrId=$o(^DHCINTR(0,"LOCTYPEDATE",PLocId,TrType,Date,IntrId)) q:IntrId=""  d
	...q:'$d(^DHCINTR(IntrId))
	...s IntrInfo=^DHCINTR(IntrId)
	...
	...s IntrTime=$p(IntrInfo,"^",3)
	...s Qty=$p(IntrInfo,"^",6)
	...s Inclb=$p(IntrInfo,"^",7)
	...s SpAmt=$p(IntrInfo,"^",8)
	...s Ingri=$p(IntrInfo,"^",9)		;Pointer
	...s UomId=$p(IntrInfo,"^",10)
	...s IntrNo=$p(IntrInfo,"^",13)
	...s Sp=$p(IntrInfo,"^",14)
	...s Rp=$p(IntrInfo,"^",16)
	...s RpAmt=$p(IntrInfo,"^",17)
	...s AuditUserId=$p(IntrInfo,"^",11)
	...s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
	...;台帐信息过滤
	...q:Inclb=""
	...q:(Date=PStartDate)&&(PStartTime'="")&&(IntrTime<PStartTime)
	...q:(Date=PEndDate)&&(PEndTime'="")&&(IntrTime>=PEndTime)
	...
	...
	...s Ingr=$p(Ingri,"||",1)
	...s IngriCh=$p(Ingri,"||",2)
	...q:'$d(^DHCINGR(Ingr))||'$d(^DHCINGR(Ingr,"GRI",IngriCh))
	...s IngrStr=^DHCINGR(Ingr)
	...s IngriItmStr=^DHCINGR(Ingr,"GRI",IngriCh)
	...
	...;入库主表信息过滤
	...s VendorId=$p(IngrStr,"^",3)
	...s RecLocId=$p(IngrStr,"^",13)
	...s OperateType=$p(IngrStr,"^",23)
	...s StkType=$p(IngrStr,"^",30)
	...s GiftFlag=$p(IngrStr,"^",31)
	...s AdjCheque=$p(IngrStr,"^",32)
	...s SourceOfFund=$p(IngrStr,"^",36)
	...q:StkType'=PStkType
	...q:VendorId=""
	...q:(PVendorId'="")&&(VendorId'=PVendorId)
	...q:(POperateType'="")&&(OperateType'=POperateType)		;按入库类型
	...q:(PFindTypeFlag="A")&&(AdjCheque'="Y")				;按调价换票
	...q:(PFindTypeFlag="G")&&(GiftFlag'="Y")				;按赠送
	...q:(PSourceOfFund'="")&&(SourceOfFund'=PSourceOfFund)
	...
	...;入库子表信息过滤
	...s InvNo=$p(IngriItmStr,"^",27)
	...s ManfId=$p(IngriItmStr,"^",29)
	...s InvDate=$p(IngriItmStr,"^",34)
	...q:(PManfId'="")&&(ManfId'=PManfId)
	...q:(PInvNo'="")&&(InvNo'[PInvNo)
	...s CertNo=$p(IngriItmStr,"^",42)
	...s CertInfo=##class(web.DHCSTMHUI.DHCMatRegCert).getByRegNo(CertNo)
	...s CertInfo={}.%FromJSON(CertInfo)
	...s CertDesc=CertInfo.%Get("MRCInciDesc")
	...
	...;库存项信息过滤
	...s Inci=$p(Inclb,"||",1)
	...q:(PInci'="")&&(Inci'=PInci)
	...q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	...
	...i '$d(InciInfoArray(Inci)) d
	....s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,PHospId)
	....s InciInfoArray(Inci)=InciObj
	...s InciObj=InciInfoArray(Inci)
	...
	...s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	...s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	...s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag,BookCatId=InciObj.BookCatId,BookCatDesc=InciObj.BookCatDesc
	...s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc
	...s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	...s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	...s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag
	...s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand
	...s MonitorFlag=InciObj.MonitorFlag
	...s MatInsuCode=InciObj.MatInsuCode,MatInsuDesc=InciObj.MatInsuDesc
	...s OfficialCatId=InciObj.OfficialCatId,OfficialCatDesc=InciObj.OfficialCatDesc
	...s ClinicCatId=InciObj.ClinicCatId,ClinicCatDesc=InciObj.ClinicCatDesc
	...
	...q:(PHvFlag'="")&&(HVFlag'=PHvFlag)
	...q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	...q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	...q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	...q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	...q:(PMarkType'="")&&(MarkTypeId'=PMarkType)		;定价类型
	...q:(PImpFlag'="")&&(ImpFlag'=PImpFlag)
	...q:(PPbFlag'="")&&(PbFlag'=PPbFlag)				;是否招标
	...q:(POfficial'="")&&(OfficialCatId'=POfficial)
	...q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	...
	...;其他-信息过滤
	...s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s QtyPUom=(Qty*IntrUomFac)/UomFac
	...s SpPUom=(Sp/IntrUomFac)*UomFac
	...s RpPUom=(Rp/IntrUomFac)*UomFac
	...q:(PRpFrom'="")&&(RpPUom<+PRpFrom)				;前闭后开区间
	...q:(PRpTo'="")&&(RpPUom>=+PRpTo)
	...
	...s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...q:(PBatNo'="")&&(BatchNo'=PBatNo)
	...
	...;变量取值
	...s VendorDesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(Date,VendorId)
	...s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	...s InvDate=..DL2H(InvDate)
	...s SourceOfFundDesc=$s(SourceOfFund'="":$p(^DHCSOUROFFUND(SourceOfFund),"^",2),1:"")
	...s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(RecLocId,Inci)
	...s StkBin=$p(StkBinInfo,"^",1)
	...
	...;这里建议保留字符串拼接的写法,因若使用$lb,变量取值错误时不会直接报错
	...;组织数据按 台帐/入库主表/入库子表/库存项 的方式进行
	...s DataIntr=IntrId_"^"_TrType_"^"_IntrNo_"^"_DateStr_"^"_QtyPUom_"^"_RpPUom_"^"_SpPUom_"^"_RpAmt_"^"_SpAmt
	...s DataIngr=Ingr_"^"_VendorId_"^"_VendorDesc_"^"_SourceOfFundDesc_"^"_GiftFlag_"^"_AdjCheque
	...s DataIngriCh=Ingri_"^"_BatchNo_"^"_ExpDate_"^"_InvNo_"^"_InvDate_"^"_ManfId_"^"_ManfDesc_"^"_StkBin_"^"_Inclb_"^"_CertNo_"^"_CertDesc
	...s DataInci=Inci_"^"_InciCode_"^"_InciDesc_"^"_PUomDesc_"^"_Spec_"^"_Model_"^"_Brand_"^"_StkGrpDesc_"^"_IncscDesc_"^"_MarkType_"^"_PbFlag_"^"_HVFlag_"^"_ChargeFlag_"^"_BookCatDesc_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc_"^"_ClinicCatDesc_"^"_AuditUser
	...s Data=DataIntr_"^"_DataIngr_"^"_DataIngriCh_"^"_DataInci
	...s i=i+1
	...s ^TMPDHCSTM(Pid,"INDETAIL",i)=$lfs(Data,"^")

	q Pid
}

/// Descript:	入库汇总(退货)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	入库汇总信息(退货)
/// w ##class(web.DHCSTMHUI.DHCINGdRecStat).GetReturnDetail(^tmpbin(116))
ClassMethod GetReturnDetail(Params) As %Library.String
{
	n (Params)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)

	s PLocId=PJObj.%Get("Loc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POperateType=PJObj.%Get("OperateType")	//入库类型
	s PInvNo=PJObj.%Get("InvNo")
	s PHvFlag=PJObj.%Get("HvFlag")
	
	s PSourceOfFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PFindTypeFlag=PJObj.%Get("AdjCheque")		;赠送或者调价换票
	s PUserId=PJObj.%Get("gUserId")
	s PHospId=PJObj.%Get("gHospId")
	s PScgType=PJObj.%Get("ssStkgrptype")		//类组类型 M-库管；O-财务
	//前台页面已去掉部分查询条件
	s PMarkType=PJObj.%Get("MarkType")			//定价类型
	s PImpFlag=PJObj.%Get("ImpFlag")			//进口标志
	s PBatNo=PJObj.%Get("BatNo")				//批号
	s PPbFlag=PJObj.%Get("PbFlag")				//招标标记
	s PRpFrom=PJObj.%Get("RpFrom")
	s PRpTo=PJObj.%Get("RpTo")
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	q:PLocId="" ""
	
	s pHospId=..sssHospId(PLocId)
	s:pHospId="" pHospId=PHospId
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s PStartTime=..TH2L(PStartTime)
	s PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	
	s TotalScgStr=""
	s LocLength=$l(PLocId,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	
	;退货
	s i=0
	s TrType="R"
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.f Date=PStartDate:1:PEndDate d
	..s DateStr=..DL2H(Date)
	..s IntrId="" 
	..f  s IntrId=$o(^DHCINTR(0,"LOCTYPEDATE",PLocId,TrType,Date,IntrId)) q:IntrId=""  d
	...q:'$d(^DHCINTR(IntrId))
	...s IntrInfo=^DHCINTR(IntrId)
	...
	...s IntrTime=$p(IntrInfo,"^",3)
	...s Qty=$p(IntrInfo,"^",6)
	...s Inclb=$p(IntrInfo,"^",7)
	...s SpAmt=$p(IntrInfo,"^",8)
	...s Ingrti=$p(IntrInfo,"^",9)		;Pointer
	...s UomId=$p(IntrInfo,"^",10)
	...s IntrNo=$p(IntrInfo,"^",13)
	...s Sp=$p(IntrInfo,"^",14)
	...s Rp=$p(IntrInfo,"^",16)
	...s RpAmt=$p(IntrInfo,"^",17)
	...s AuditUserId=$p(IntrInfo,"^",11)
	...s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
	...
	...;台帐信息过滤
	...q:Inclb=""
	...q:(Date=PStartDate)&&(PStartTime'="")&&(IntrTime<PStartTime)
	...q:(Date=PEndDate)&&(PEndTime'="")&&(IntrTime>=PEndTime)
	...
	...
	...s Ingrt=$p(Ingrti,"||",1)
	...s IngrtiCh=$p(Ingrti,"||",2)
	...q:'$d(^INGRT(Ingrt))||'$d(^INGRT(Ingrt,"DHCGRR",IngrtiCh))
	...s IngrtStr=^INGRT(Ingrt)
	...s IngrtiItmStr=^INGRT(Ingrt,"DHCGRR",IngrtiCh)
	...
	...;退货主表信息过滤
	...s VendorId=$p(IngrtStr,"^",2)
	...s RetLocId=$p(IngrtStr,"^",7)
	...s StkType=$p(IngrtStr,"^",16)
	...q:StkType'=PStkType
	...q:VendorId=""
	...q:(PVendorId'="")&&(VendorId'=PVendorId)
	...
	...
	...;退货子表信息过滤
	...s Ingri=$p(IngrtiItmStr,"^",1)
	...s InvNo=$p(IngrtiItmStr,"^",12)
	...s InvDate=$p(IngrtiItmStr,"^",14)
	...q:(PInvNo'="")&&(InvNo'[PInvNo)
	...
	...s (AdjCheque,OperateType,SourceOfFund,CertNo,ManfId)=""
	...s Ingr=$p(Ingri,"||",1),IngriCh=$p(Ingri,"||",2)
	...i (Ingr'="")&&(IngriCh'="") d
	....s AdjCheque=$p(^DHCINGR(Ingr),"^",11)
	....s OperateType=$p(^DHCINGR(Ingr),"^",23)
	....s SourceOfFund=$p(^DHCINGR(Ingr),"^",36)
	....s CertNo=$p(^DHCINGR(Ingr,"GRI",IngriCh),"^",42)
	....s ManfId=$p(^DHCINGR(Ingr,"GRI",IngriCh),"^",29)
	...q:(PManfId'="")&&(ManfId'=PManfId)
	...s GiftFlag=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetGiftFlagByInclb(Inclb)
	...s CertInfo=##class(web.DHCSTMHUI.DHCMatRegCert).getByRegNo(CertNo)
	...s CertInfo={}.%FromJSON(CertInfo)
	...s CertDesc=CertInfo.%Get("MRCInciDesc")
	...q:(POperateType'="")&&(OperateType'=POperateType)
	...q:(PSourceOfFund'="")&&(SourceOfFund'=PSourceOfFund)
	...q:(PFindTypeFlag="A")&&(AdjCheque'="Y")			;按调价换票
	...q:(PFindTypeFlag="G")&&(GiftFlag'="Y")			;按赠送
	...
	...;库存项信息过滤
	...s Inci=$p(Inclb,"||",1)
	...q:(PInci'="")&&(Inci'=PInci)
	...q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	...
	...i '$d(InciInfoArray(Inci)) d
	....s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,pHospId)
	....s InciInfoArray(Inci)=InciObj
	...s InciObj=InciInfoArray(Inci)
	...
	...s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	...s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	...s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag,BookCatId=InciObj.BookCatId,BookCatDesc=InciObj.BookCatDesc
	...s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc
	...s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	...s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	...s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag
	...s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand
	...s MonitorFlag=InciObj.MonitorFlag
	...s MatInsuCode=InciObj.MatInsuCode,MatInsuDesc=InciObj.MatInsuDesc
	...s OfficialCatId=InciObj.OfficialCatId,OfficialCatDesc=InciObj.OfficialCatDesc
	...s ClinicCatId=InciObj.ClinicCatId,ClinicCatDesc=InciObj.ClinicCatDesc
	...
	...q:(PHvFlag'="")&&(HVFlag'=PHvFlag)
	...q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	...q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	...q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	...q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	...q:(PMarkType'="")&&(MarkTypeId'=PMarkType)		;定价类型
	...q:(PImpFlag'="")&&(ImpFlag'=PImpFlag)
	...q:(PPbFlag'="")&&(PbFlag'=PPbFlag)				;是否招标
	...q:(POfficial'="")&&(OfficialCatId'=POfficial)
	...q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	...
	...;其他-信息过滤
	...s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s QtyPUom=(Qty*IntrUomFac)/UomFac
	...s SpPUom=(Sp/IntrUomFac)*UomFac
	...s RpPUom=(Rp/IntrUomFac)*UomFac
	...q:(PRpFrom'="")&&(RpPUom<+PRpFrom)				;前闭后开区间
	...q:(PRpTo'="")&&(RpPUom>=+PRpTo)
	...
	...s BatExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	...s BatchNo=$p(BatExp,"^",1)
	...s ExpDate=$p(BatExp,"^",2)
	...q:(PBatNo'="")&&(BatchNo'=PBatNo)
	...
	...;变量取值
	...s VendorDesc=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetDateVendor(Date,VendorId)
	...s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	...s InvDate=..DL2H(InvDate)
	...s SourceOfFundDesc=$s(SourceOfFund'="":$p(^DHCSOUROFFUND(SourceOfFund),"^",2),1:"")
	...s StkBinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(RetLocId,Inci)
	...s StkBin=$p(StkBinInfo,"^",1)
	...
	...;这里建议保留字符串拼接的写法,因若使用$lb,变量取值错误时不会直接报错
	...;组织数据按 台帐/退货主表/退货子表/库存项 的方式进行
	...s DataIntr=IntrId_"^"_TrType_"^"_IntrNo_"^"_DateStr_"^"_QtyPUom_"^"_RpPUom_"^"_SpPUom_"^"_RpAmt_"^"_SpAmt
	...s DataIngrt=Ingrt_"^"_VendorId_"^"_VendorDesc_"^"_SourceOfFundDesc_"^"_GiftFlag_"^"_AdjCheque
	...s DataIngrtiCh=Ingrti_"^"_BatchNo_"^"_ExpDate_"^"_InvNo_"^"_InvDate_"^"_ManfId_"^"_ManfDesc_"^"_StkBin_"^"_Inclb_"^"_CertNo_"^"_CertDesc
	...s DataInci=Inci_"^"_InciCode_"^"_InciDesc_"^"_PUomDesc_"^"_Spec_"^"_Model_"^"_Brand_"^"_StkGrpDesc_"^"_IncscDesc_"^"_MarkType_"^"_PbFlag_"^"_HVFlag_"^"_ChargeFlag_"^"_BookCatDesc_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc_"^"_ClinicCatDesc_"^"_AuditUser
	...s Data=DataIntr_"^"_DataIngrt_"^"_DataIngrtiCh_"^"_DataInci
	...s i=i+1
	...s ^TMPDHCSTM(Pid,"INDETAIL",i)=$lfs(Data,"^")

	q Pid
}

}
