Import sqluser

/// Descript:	出库汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
Class web.DHCSTMHUI.DHCINIsTrfStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	出库汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	出库汇总信息
/// LocId可多选传入(逗号隔开)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfStat","QueryDetail",^zx("Params"))
Query QueryDetail(Params As %Text) As Query(ROWSPEC = "Intrid,Type,TrDate,TrNo,MainId:%Float,AuditUser,LocCode,RecLocDesc,RecLocGrp,LocGrpItm,Initi,Chl:%Float,RpAmt:%Float,SpAmt:%Float,BatSpAmt:%Float,TrQty:%Float,Rp:%Float,Sp:%Float,BatSp:%Float,Inci,InciCode,InciDesc,UomDesc,HVFlag,ChargeFlag,BookCatCode,BookCatDesc,StkCat,incsccode,StkGrp,spType,ImpFlag,TmpPbFlag,PbLevelDesc,Spec,Model,Brand,LastVendorDesc,MonitorFlag,MatInsuCode,MatInsuDesc,OfficialCatDesc,ClinicCatDesc,Stkbin,Inclb,Incib,vendor,VenName,ManfId,Manf,BatNo,ExpireDate,SourceOfFundDesc,SterilizedBat,GiftFlag,ReqName,ReqItmRemark,InrqiType,reqNo") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	;tro
	;s ^zx("Params")=Params
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s Loc=PJObj.%Get("PhaLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s TransferFlag=PJObj.%Get("TransferFlag")
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	
	s qPid=""
	//只统计转出
	i TransferFlag=1  d
	.s qPid=..GetTransferOutDetail(Params)
	.i qPid'=""  d OutputRow
	.
	//只统计转入
	i TransferFlag=2  d  
	.s qPid=..GetTransferInDetail(Params)
	.i qPid'=""  d OutputRow
	.
	//只统计高值转入补录
	i TransferFlag=3  d  
	.s qPid=..GetHVTransferInDetail(Params)
	.i qPid'=""  d OutputRow
	.
	//统计转出转入
	i TransferFlag="0"  d     
	.s qPid=..GetTransferOutDetail(Params)
	.i qPid'=""  d OutputRow
	.s qPid=..GetTransferInDetail(Params)
	.i qPid'="" d OutputRow
	.
	Quit $$$OK

OutputRow
	s num=0
	f  s num=$o(^TMPDHCSTM(qPid,"OUTDETAIL",num)) q:num=""  d
	.s Data=^TMPDHCSTM(qPid,"OUTDETAIL",num)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	k ^TMPDHCSTM(qPid,"OUTDETAIL")
	q
}

/// Descript:	出库汇总(转出)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	出库汇总信息(转出)	
ClassMethod GetTransferOutDetail(Params) As %Library.String
{
	n (Params)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s PLocId=PJObj.%Get("PhaLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POutType=PJObj.%Get("OperateOutType")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PHvFlag=PJObj.%Get("HvFlag")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PSourceFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PScgType=PJObj.%Get("ssStkgrptype")	;类组类型 M-库管；O-财务
	s PTransRange=PJObj.%Get("TransRange")		;科室范围(0:全部,1:科室组内,2:科室组外)
	s PLocGroup=PJObj.%Get("LocGroup")				;科室组
	s PLocGroupDesc=""
	s:PLocGroup'="" PLocGroupDesc=$p(^DHCSLG(PLocGroup),"^",2)
	s PUserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s PCreateUserId=PJObj.%Get("CreateUserId")
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PGiftFlag=PJObj.%Get("GiftFlag")
	//前台页面已去掉部分查询条件
	s PMarkType=PJObj.%Get("INFOMT")
	s PImpFlag=PJObj.%Get("INFOImportFlag")
	s PBatNo=PJObj.%Get("BatNo")
	s PPbFlag=PJObj.%Get("PublicBidding")
	s PPbLevel=PJObj.%Get("INFOPBLevel")
	s PSpFrom=PJObj.%Get("MinSp")
	s PSpTo=PJObj.%Get("MaxSp")
	s PRpFrom=PJObj.%Get("MinRp")
	s PRpTo=PJObj.%Get("MaxRp")
	s PInclb=PJObj.%Get("Inclb")
	s PStockLocFlag=PJObj.%Get("StockLocFlag")	//供给科室库房标记
	i PLocId'="" s PStockLocFlag=""
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	
	s PHospId=..sssHospId(+PLocId)
	s:PHospId="" PHospId=HospId
	s TotalScgStr=""
	s LocLength=$l(PLocId,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.q:LocId=""
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	s LocGrpItems=..GetLocGrpItems(+PLocId)
	s PLocGrpItems="^"_LocGrpItems_"^"
	k InitiInciInfo,InitiInclbInfo,InitiFromLocInfo,InitToLocInfo	//"数组",记录库存项相关数据
	s i=0
	s TrType="T"
	s trLocId=""
	f  s trLocId=$o(^DHCINTR(0,"LOCTYPEDATE",trLocId)) q:trLocId=""  d
	.q:(PLocId'="")&&((","_PLocId_",")'[(","_trLocId_","))
	.f Date=PStartDate:1:PEndDate d
	..s IntrDate=..DL2H(Date)
	..s IntrId="" 
	..f  s IntrId=$o(^DHCINTR(0,"LOCTYPEDATE",trLocId,TrType,Date,IntrId)) q:IntrId=""  d
	...q:'$d(^DHCINTR(IntrId))
	...s IntrInfo=^DHCINTR(IntrId)
	...;台账信息
	...s IntrTime=$p(IntrInfo,"^",3)
	...s Inclb=$p(IntrInfo,"^",7)
	...s Initi=$p(IntrInfo,"^",9)		;Pointer
	...s IntrNo=$p(IntrInfo,"^",13)
	...s AuditUserId=$p(IntrInfo,"^",11)
	...s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
	...;台账信息过滤
	...q:Inclb=""
	...q:(PInclb'="")&&(PInclb'=Inclb)
	...q:(Date=PStartDate)&&(PStartTime'="")&&(IntrTime<PStartTime)
	...q:(Date=PEndDate)&&(PEndTime'="")&&(IntrTime>=PEndTime)
	...
	...
	...s Init=+Initi
	...s InitiCh=$p(Initi,"||",2)
	...q:'$d(^DHCINIT(Init))||'$d(^DHCINIT(Init,"ITI",InitiCh))
	...s InitStr=^DHCINIT(Init)
	...s InitiItmStr=^DHCINIT(Init,"ITI",InitiCh)
	...;库存转移主表信息
	...s FromLocId=$p(InitStr,"^",5)   ;出库科室
	...s ToLocId=$p(InitStr,"^",6)   ;接收科室
	...s CreateUserId=$p(InitStr,"^",8)   ;制单人
	...s StkType=$p(InitStr,"^",24)
	...s OutType=$p(InitStr,"^",20)
	...;库存转移主表信息过滤
	...q:FromLocId=""
	...q:(PRecLocId'="")&(ToLocId'=PRecLocId)   ;非接收科室
	...q:(PCreateUserId'="")&&(CreateUserId'=PCreateUserId)
	...q:StkType'=PStkType
	...q:(POutType'="")&(OutType'=POutType)		;按出库类型过滤
	...;库存转移子表信息
	...s Reqi=$p(InitiItmStr,"^",2)
	...s UomId=$p(InitiItmStr,"^",7)
	...s Sp=$p(InitiItmStr,"^",17)		;售价
	...s Rp=$p(InitiItmStr,"^",15)		;进价
	...s BatSp=$p(InitiItmStr,"^",21)		;批次售价
	...s Qty=$p(InitiItmStr,"^",1)
	...s RpAmt=$p(InitiItmStr,"^",16)
	...s SpAmt=$p(InitiItmStr,"^",18)
	...s BatSpAmt=$p(InitiItmStr,"^",22)
	...
	...s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	...s Inci=$p(Inclb,"||",1)
	...q:(PInci'="")&(PInci'=Inci)			;库存项不符
	...q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	...;库存项信息	
	...i '$d(InciInfoArray(Inci)) d
	....s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,PHospId)
	....s InciInfoArray(Inci)=InciObj
	...s InciObj=InciInfoArray(Inci)
	...s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	...s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	...s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag
	...s BookCatId=InciObj.BookCatId,BookCatCode=InciObj.BookCatCode,BookCatDesc=InciObj.BookCatDesc
	...s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc,IncscCode=InciObj.IncscCode
	...s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	...s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	...s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag,PbLevel=InciObj.PbLevel,PbLevelDesc=InciObj.PbLevelDesc
	...s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand,LastVendorDesc=InciObj.LastVendorDesc
	...s MonitorFlag=InciObj.MonitorFlag
	...s MatInsuCode=InciObj.MatInsuCode,MatInsuDesc=InciObj.MatInsuDesc
	...s OfficialCatId=InciObj.OfficialCatId,OfficialCatDesc=InciObj.OfficialCatDesc
	...s ClinicCatId=InciObj.ClinicCatId,ClinicCatDesc=InciObj.ClinicCatDesc 
	...
	...;库存项信息过滤
	...q:ScgId=""
	...q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	...q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	...q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	...q:(PHvFlag'="")&&(HVFlag'=PHvFlag)
	...q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	...q:(PMarkType'="")&&(MarkTypeId'=PMarkType)		;定价类型
	...q:(PImpFlag'="")&&(ImpFlag'=PImpFlag)
	...q:(PPbFlag'="")&&(PbFlag'=PPbFlag)
	...q:(PPbLevel'="")&&(PbLevel'=PPbLevel)				;是否招标
	...q:(POfficial'="")&&(OfficialCatId'=POfficial)
	...q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	...;批次信息
	...i '$d(InclbInfoArray(Inclb)) d
	....s InclbObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetInclbObj(Inclb,Date)
	....s InclbInfoArray(Inclb)=InclbObj
	...s InclbObj=InclbInfoArray(Inclb)
	...s VenId=InclbObj.VenId,VenName=InclbObj.VenName
	...s ManfId=InclbObj.ManfId,ManfName=InclbObj.ManfName
	...s BatNo=InclbObj.BatNo,ExpireDate=InclbObj.ExpireDate
	...s SourceOfFundId=InclbObj.SourceOfFundId,SourceOfFundDesc=InclbObj.SourceOfFundDesc
	...s SterilizedBat=InclbObj.SterilizedBat,GiftFlag=InclbObj.GiftFlag
	...;批次信息过滤
	...q:(PVendorId'="")&(VenId'=PVendorId)				;按供应商过滤
	...q:(PManfId'="")&(ManfId'=PManfId)					;生产厂家
	...q:(PBatNo'="")&(BatNo'=PBatNo)
	...q:(PSourceFund'="")&&(SourceOfFundId'=PSourceFund)
	...q:(PGiftFlag'="")&&(GiftFlag'=PGiftFlag)
	...
	...
	...;价格信息过滤
	...s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s RealTrQty=0
	...s QtyPUom=(Qty*IntrUomFac)/UomFac
	...s SpPUom=(Sp/IntrUomFac)*UomFac
	...s RpPUom=(Rp/IntrUomFac)*UomFac
	...s BatSpPUom=(BatSp/IntrUomFac)*UomFac
	...s QtyBUom=Qty*IntrUomFac
	...s SpBUom=Sp/IntrUomFac
	...s RpBUom=Rp/IntrUomFac
	...s BatSpBUom=BatSp/IntrUomFac
	...s SetStatBUom=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","SetStatBUom","^"_+PLocId)
	...i SetStatBUom="Y" d
	...s UomDesc=BUomDesc
	...s Rp=RpBUom
	...s Sp=SpBUom
	...s BatSp=BatSpBUom
	...s TrQty=QtyBUom
	...e  d
	....s UomDesc=PUomDesc
	....s Rp=RpPUom
	....s Sp=SpPUom
	....s BatSp=BatSpPUom
	....s TrQty=QtyPUom
	...q:(PRpFrom'="")&&(Rp<+PRpFrom)				;前闭后开区间
	...q:(PRpTo'="")&&(Rp>=+PRpTo)
	...q:(PSpFrom'="")&&(Sp<+PSpFrom)				;前闭后开区间
	...q:(PSpTo'="")&&(Sp>=+PSpTo)
	...;出库科室信息过滤
	...i '$d(FrLocInfoArray(FromLocId)) d
	....s FrLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(FromLocId)
	....s FrLocInfoArray(FromLocId)=FrLocInfoObj
	...s FrLocInfoObj=FrLocInfoArray(FromLocId)
	...s IfStockLoc=FrLocInfoObj.IfStockLocFlag
	...q:(PStockLocFlag'="")&&(IfStockLoc'=PStockLocFlag)
	...;接收科室信息过滤
	...i '$d(ToLocInfoArray(ToLocId)) d
	....s ToLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(ToLocId,PLocGrpItems)
	....s ToLocInfoArray(ToLocId)=ToLocInfoObj
	...s ToLocInfoObj=ToLocInfoArray(ToLocId)
	...s ToLocCode=ToLocInfoObj.LocCode,ToLocDesc=ToLocInfoObj.LocDesc
	...s ToLocGrp=ToLocInfoObj.LocGrp,ToLocGrpItm=ToLocInfoObj.LocGrpItm,InLocGrpItems=ToLocInfoObj.InLocGrpItemsFalg
	...q:(PLocGroupDesc'="")&&(ToLocGrpItm'=PLocGroupDesc)	;科室组过滤
	...q:(PTransRange=1)&&(InLocGrpItems="N")		;过滤组外部分
	...q:(PTransRange=2)&&(InLocGrpItems="Y")		;过滤组内部分
	...	
	...;其他变量取值
	...s StkbinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(FromLocId,Inci)
	...s Stkbin=$p(StkbinInfo,"^",1)
	...s ReqUserId=0,(ReqName,ReqNo,InrqiType,ReqItmRemark)=""
	...i Reqi'="" d
	....s ReqUserId=$p(^INRQ(+Reqi),"^",4)
	....s ReqNo=$p(^INRQ(+Reqi),"^",1)
	....s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
	....q:DhcInrqi=""
	....s InrqiType=$p(^DHCINRQI(DhcInrqi),"^",7)
	....s ReqItmRemark=$p(^DHCINRQI(DhcInrqi),"^",2)
	...s:+ReqUserId>0 ReqName=$p(^SSU("SSUSR",ReqUserId),"^",2)
	...;组织数据按 台帐/库存转移主表/库存转移子表/库存项/批次/其他 的方式进行
	...s DataIntr=IntrId_"^"_TrType_"^"_IntrDate_"^"_IntrNo
	...s DataInit=Init_"^"_AuditUser_"^"_ToLocCode_"^"_ToLocDesc_"^"_ToLocGrp_"^"_ToLocGrpItm
	...s DataIniti=Initi_"^"_InitiCh_"^"_RpAmt_"^"_SpAmt_"^"_BatSpAmt_"^"_TrQty_"^"_Rp_"^"_Sp_"^"_BatSp
	...s DataInci=Inci_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_HVFlag_"^"_ChargeFlag_"^"_BookCatCode_"^"_BookCatDesc_"^"_IncscDesc_"^"_IncscCode_"^"_StkGrpDesc_"^"_MarkType_"^"_ImpFlag_"^"_PbFlag_"^"_PbLevelDesc_"^"_Spec_"^"_Model_"^"_Brand_"^"_LastVendorDesc_"^"_MonitorFlag_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc_"^"_ClinicCatDesc_"^"_Stkbin
	...s DataInclb=Inclb_"^"_Incib_"^"_VenId_"^"_VenName_"^"_ManfId_"^"_ManfName_"^"_BatNo_"^"_ExpireDate_"^"_SourceOfFundDesc_"^"_SterilizedBat_"^"_GiftFlag
	...s DataOther=ReqName_"^"_ReqItmRemark_"^"_InrqiType_"^"_ReqNo
	...s Data=DataIntr_"^"_DataInit_"^"_DataIniti_"^"_DataInci_"^"_DataInclb_"^"_DataOther
	...s i=i+1
	...s ^TMPDHCSTM(Pid,"OUTDETAIL",i)=$lfs(Data,"^")
	q Pid
}

/// Descript:	出库汇总(转入)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	出库汇总信息(转入)	
ClassMethod GetTransferInDetail(Params) As %Library.String
{
	n (Params)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s PLocId=PJObj.%Get("PhaLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POutType=PJObj.%Get("OperateOutType")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PHvFlag=PJObj.%Get("HvFlag")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PSourceFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PScgType=PJObj.%Get("ssStkgrptype")	;类组类型 M-库管；O-财务
	s PTransRange=PJObj.%Get("TransRange")		;科室范围(0:全部,1:科室组内,2:科室组外)
	s PLocGroup=PJObj.%Get("LocGroup")				;科室组
	s PLocGroupDesc=""
	s:PLocGroup'="" PLocGroupDesc=$p(^DHCSLG(PLocGroup),"^",2)
	s PUserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s PCreateUserId=PJObj.%Get("CreateUserId")
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PGiftFlag=PJObj.%Get("GiftFlag")
	//前台页面已去掉部分查询条件
	s PMarkType=PJObj.%Get("INFOMT")
	s PImpFlag=PJObj.%Get("INFOImportFlag")
	s PBatNo=PJObj.%Get("BatNo")
	s PPbFlag=PJObj.%Get("PublicBidding")
	s PPbLevel=PJObj.%Get("INFOPBLevel")
	s PSpFrom=PJObj.%Get("MinSp")
	s PSpTo=PJObj.%Get("MaxSp")
	s PRpFrom=PJObj.%Get("MinRp")
	s PRpTo=PJObj.%Get("MaxRp")
	s PInclb=PJObj.%Get("Inclb")
	s PStockLocFlag=PJObj.%Get("StockLocFlag")	//供给科室库房标记
	i PLocId'="" s PStockLocFlag=""
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	
	s PHospId=..sssHospId(+PLocId)
	s:PHospId="" PHospId=HospId
	s TotalScgStr=""
	s LocLength=$l(PLocId,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.q:LocId=""
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	s LocGrpItems=..GetLocGrpItems(+PLocId)
	s PLocGrpItems="^"_LocGrpItems_"^"
	k InitiInciInfo,InitiInclbInfo,InitiFromLocInfo,InitToLocInfo	//"数组",记录库存项相关数据
	s i=0
	s TrType="K"
	s trLocId=""
	f  s trLocId=$o(^DHCINTR(0,"LOCTYPEDATE",trLocId)) q:trLocId=""  d
	.q:(PLocId'="")&&((","_PLocId_",")'[(","_trLocId_","))
	.f Date=PStartDate:1:PEndDate d
	..s IntrDate=..DL2H(Date)
	..s IntrId="" 
	..f  s IntrId=$o(^DHCINTR(0,"LOCTYPEDATE",trLocId,TrType,Date,IntrId)) q:IntrId=""  d
	...q:'$d(^DHCINTR(IntrId))
	...s IntrInfo=^DHCINTR(IntrId)
	...;台账信息
	...s IntrTime=$p(IntrInfo,"^",3)
	...s Inclb=$p(IntrInfo,"^",7)
	...s Initi=$p(IntrInfo,"^",9)		;Pointer
	...s IntrNo=$p(IntrInfo,"^",13)
	...s AuditUserId=$p(IntrInfo,"^",11)
	...s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
	...;台账信息过滤
	...q:Inclb=""
	...q:(PInclb'="")&&(PInclb'=Inclb)
	...q:(Date=PStartDate)&&(PStartTime'="")&&(IntrTime<PStartTime)
	...q:(Date=PEndDate)&&(PEndTime'="")&&(IntrTime>=PEndTime)
	...
	...
	...s Init=+Initi
	...s InitiCh=$p(Initi,"||",2)
	...q:'$d(^DHCINIT(Init))||'$d(^DHCINIT(Init,"ITI",InitiCh))
	...s InitStr=^DHCINIT(Init)
	...s InitiItmStr=^DHCINIT(Init,"ITI",InitiCh)
	...;库存转移主表信息
	...s FromLocId=$p(InitStr,"^",5)   ;出库科室
	...s ToLocId=$p(InitStr,"^",6)   ;接收科室
	...s CreateUserId=$p(InitStr,"^",8)   ;制单人
	...s StkType=$p(InitStr,"^",24)
	...s OutType=$p(InitStr,"^",20)
	...;库存转移主表信息过滤
	...q:ToLocId=""
	...q:(PRecLocId'="")&(FromLocId'=PRecLocId)   ;非接收科室
	...q:(PCreateUserId'="")&&(CreateUserId'=PCreateUserId)
	...q:StkType'=PStkType
	...q:(POutType'="")&(OutType'=POutType)		;按出库类型过滤
	...;库存转移子表信息
	...s Reqi=$p(InitiItmStr,"^",2)
	...s UomId=$p(InitiItmStr,"^",7)
	...s Sp=$p(InitiItmStr,"^",17)		;售价
	...s Rp=$p(InitiItmStr,"^",15)		;进价
	...s BatSp=$p(InitiItmStr,"^",21)		;批次售价
	...s Qty=$p(InitiItmStr,"^",1)
	...s RpAmt=-$p(InitiItmStr,"^",16)
	...s SpAmt=-$p(InitiItmStr,"^",18)
	...s BatSpAmt=-$p(InitiItmStr,"^",22)
	...
	...s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	...s Inci=$p(Inclb,"||",1)
	...q:(PInci'="")&(PInci'=Inci)			;库存项不符
	...q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	...;库存项信息	
	...i '$d(InciInfoArray(Inci)) d
	....s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,PHospId)
	....s InciInfoArray(Inci)=InciObj
	...s InciObj=InciInfoArray(Inci)
	...s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	...s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	...s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag
	...s BookCatId=InciObj.BookCatId,BookCatCode=InciObj.BookCatCode,BookCatDesc=InciObj.BookCatDesc
	...s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc,IncscCode=InciObj.IncscCode
	...s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	...s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	...s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag,PbLevel=InciObj.PbLevel,PbLevelDesc=InciObj.PbLevelDesc
	...s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand,LastVendorDesc=InciObj.LastVendorDesc
	...s MonitorFlag=InciObj.MonitorFlag
	...s MatInsuCode=InciObj.MatInsuCode,MatInsuDesc=InciObj.MatInsuDesc
	...s OfficialCatId=InciObj.OfficialCatId,OfficialCatDesc=InciObj.OfficialCatDesc
	...s ClinicCatId=InciObj.ClinicCatId,ClinicCatDesc=InciObj.ClinicCatDesc 
	...
	...;库存项信息过滤
	...q:ScgId=""
	...q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	...q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	...q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	...q:(PHvFlag'="")&&(HVFlag'=PHvFlag)
	...q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	...q:(PMarkType'="")&&(MarkTypeId'=PMarkType)		;定价类型
	...q:(PImpFlag'="")&&(ImpFlag'=PImpFlag)
	...q:(PPbFlag'="")&&(PbFlag'=PPbFlag)
	...q:(PPbLevel'="")&&(PbLevel'=PPbLevel)				;是否招标
	...q:(POfficial'="")&&(OfficialCatId'=POfficial)
	...q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	...;批次信息
	...i '$d(InclbInfoArray(Inclb)) d
	....s InclbObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetInclbObj(Inclb,Date)
	....s InclbInfoArray(Inclb)=InclbObj
	...s InclbObj=InclbInfoArray(Inclb)
	...s VenId=InclbObj.VenId,VenName=InclbObj.VenName
	...s ManfId=InclbObj.ManfId,ManfName=InclbObj.ManfName
	...s BatNo=InclbObj.BatNo,ExpireDate=InclbObj.ExpireDate
	...s SourceOfFundId=InclbObj.SourceOfFundId,SourceOfFundDesc=InclbObj.SourceOfFundDesc
	...s SterilizedBat=InclbObj.SterilizedBat,GiftFlag=InclbObj.GiftFlag
	...;批次信息过滤
	...q:(PVendorId'="")&(VenId'=PVendorId)				;按供应商过滤
	...q:(PManfId'="")&(ManfId'=PManfId)					;生产厂家
	...q:(PBatNo'="")&(BatNo'=PBatNo)
	...q:(PSourceFund'="")&&(SourceOfFundId'=PSourceFund)
	...q:(PGiftFlag'="")&&(GiftFlag'=PGiftFlag)
	...
	...
	...;价格信息过滤
	...s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	...s RealTrQty=0
	...s QtyPUom=(Qty*IntrUomFac)/UomFac
	...s SpPUom=(Sp/IntrUomFac)*UomFac
	...s RpPUom=(Rp/IntrUomFac)*UomFac
	...s BatSpPUom=(BatSp/IntrUomFac)*UomFac
	...s QtyBUom=Qty*IntrUomFac
	...s SpBUom=Sp/IntrUomFac
	...s RpBUom=Rp/IntrUomFac
	...s BatSpBUom=BatSp/IntrUomFac
	...s SetStatBUom=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","SetStatBUom","^"_+PLocId)
	...i SetStatBUom="Y" d
	....s UomDesc=BUomDesc
	....s Rp=RpBUom
	....s Sp=SpBUom
	....s BatSp=BatSpBUom
	....s TrQty=QtyBUom
	...e  d
	....s UomDesc=PUomDesc
	....s Rp=RpPUom
	....s Sp=SpPUom
	....s BatSp=BatSpPUom
	....s TrQty=QtyPUom
	...s TrQty=-TrQty
	...q:(PRpFrom'="")&&(Rp<+PRpFrom)				;前闭后开区间
	...q:(PRpTo'="")&&(Rp>=+PRpTo)
	...q:(PSpFrom'="")&&(Sp<+PSpFrom)				;前闭后开区间
	...q:(PSpTo'="")&&(Sp>=+PSpTo)
	...;接收科室信息过滤
	...i '$d(ToLocInfoArray(ToLocId)) d
	....s ToLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(ToLocId)
	....s ToLocInfoArray(ToLocId)=ToLocInfoObj
	...s ToLocInfoObj=ToLocInfoArray(ToLocId)
	...s IfStockLoc=ToLocInfoObj.IfStockLocFlag
	...q:(PStockLocFlag'="")&&(IfStockLoc'=PStockLocFlag)
	...;转出科室信息过滤
	...i '$d(FrLocInfoArray(FromLocId)) d
	....s FrLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(FromLocId,PLocGrpItems)
	....s FrLocInfoArray(FromLocId)=FrLocInfoObj
	...s FrLocInfoObj=FrLocInfoArray(FromLocId)
	...s FromLocCode=FrLocInfoObj.LocCode,FromLocDesc=FrLocInfoObj.LocDesc
	...s FromLocGrp=FrLocInfoObj.LocGrp,FromLocGrpItm=FrLocInfoObj.LocGrpItm,InLocGrpItems=FrLocInfoObj.InLocGrpItemsFalg
	...q:(PLocGroupDesc'="")&&(FromLocGrpItm'=PLocGroupDesc)	;科室组过滤
	...q:(PTransRange=1)&&(InLocGrpItems="N")		;过滤组外部分
	...q:(PTransRange=2)&&(InLocGrpItems="Y")		;过滤组内部分
	...	
	...;其他变量取值
	...s StkbinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ToLocId,Inci)
	...s Stkbin=$p(StkbinInfo,"^",1)
	...s ReqUserId=0,(ReqName,ReqNo,InrqiType,ReqItmRemark)=""
	...i Reqi'="" d
	....s ReqUserId=$p(^INRQ(+Reqi),"^",4)
	....s ReqNo=$p(^INRQ(+Reqi),"^",1)
	....s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
	....q:DhcInrqi=""
	....s InrqiType=$p(^DHCINRQI(DhcInrqi),"^",7)
	....s ReqItmRemark=$p(^DHCINRQI(DhcInrqi),"^",2)
	...s:+ReqUserId>0 ReqName=$p(^SSU("SSUSR",ReqUserId),"^",2)
	...;组织数据按 台帐/库存转移主表/库存转移子表/库存项/批次/其他 的方式进行
	...s DataIntr=IntrId_"^"_TrType_"^"_IntrDate_"^"_IntrNo
	...s DataInit=Init_"^"_AuditUser_"^"_FromLocCode_"^"_FromLocDesc_"^"_FromLocGrp_"^"_FromLocGrpItm
	...s DataIniti=Initi_"^"_InitiCh_"^"_RpAmt_"^"_SpAmt_"^"_BatSpAmt_"^"_TrQty_"^"_Rp_"^"_Sp_"^"_BatSp
	...s DataInci=Inci_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_HVFlag_"^"_ChargeFlag_"^"_BookCatCode_"^"_BookCatDesc_"^"_IncscDesc_"^"_IncscCode_"^"_StkGrpDesc_"^"_MarkType_"^"_ImpFlag_"^"_PbFlag_"^"_PbLevelDesc_"^"_Spec_"^"_Model_"^"_Brand_"^"_LastVendorDesc_"^"_MonitorFlag_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc_"^"_ClinicCatDesc_"^"_Stkbin
	...s DataInclb=Inclb_"^"_Incib_"^"_VenId_"^"_VenName_"^"_ManfId_"^"_ManfName_"^"_BatNo_"^"_ExpireDate_"^"_SourceOfFundDesc_"^"_SterilizedBat_"^"_GiftFlag
	...s DataOther=ReqName_"^"_ReqItmRemark_"^"_InrqiType_"^"_ReqNo
	...s Data=DataIntr_"^"_DataInit_"^"_DataIniti_"^"_DataInci_"^"_DataInclb_"^"_DataOther
	...s i=i+1
	...s ^TMPDHCSTM(Pid,"OUTDETAIL",i)=$lfs(Data,"^")
	q Pid
}

/// Descript:	高值转入补录(临床科室使用)
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	高值转入补录
ClassMethod GetHVTransferInDetail(Params) As %Library.String
{
	n (Params)
	s Pid=..NewPid()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	
	s PLocId=PJObj.%Get("PhaLoc")
	s PStartDate=PJObj.%Get("StartDate")
	s PEndDate=PJObj.%Get("EndDate")
	s PStkGrpId=PJObj.%Get("ScgStk")
	s PStkCatId=PJObj.%Get("StkCat")
	s PInci=PJObj.%Get("Inci")
	s PManfId=PJObj.%Get("Manf")
	s PVendorId=PJObj.%Get("Vendor")
	s POutType=PJObj.%Get("OperateOutType")
	s PRecLocId=PJObj.%Get("RecLoc")
	s PHvFlag=PJObj.%Get("HvFlag")
	s PStartTime=PJObj.%Get("StartTime")
	s PEndTime=PJObj.%Get("EndTime")
	s PInciDesc=PJObj.%Get("InciDesc")
	s PSourceFund=PJObj.%Get("SourceOfFund")
	s PChargeFlag=PJObj.%Get("ChargeFlag")
	s PScgType=PJObj.%Get("ssStkgrptype")	;类组类型 M-库管；O-财务
	s PTransRange=PJObj.%Get("TransRange")		;科室范围(0:全部,1:科室组内,2:科室组外)
	s PLocGroup=PJObj.%Get("LocGroup")				;科室组
	s PLocGroupDesc=""
	s:PLocGroup'="" PLocGroupDesc=$p(^DHCSLG(PLocGroup),"^",2)
	s PUserId=PJObj.%Get("gUserId")
	s HospId=PJObj.%Get("gHospId")
	s PCreateUserId=PJObj.%Get("CreateUserId")
	s:PStartDate'="" PStartDate=..DH2L(PStartDate)
	s:PEndDate'="" PEndDate=..DH2L(PEndDate)
	s:PStartTime'="" PStartTime=..TH2L(PStartTime)
	s:PEndTime'="" PEndTime=..TH2L(PEndTime)
	s:PStartTime="86399" PStartTime=""
	s:PEndTime="86399" PEndTime=""
	s PGiftFlag=PJObj.%Get("GiftFlag")
	//前台页面已去掉部分查询条件
	s PMarkType=PJObj.%Get("INFOMT")
	s PImpFlag=PJObj.%Get("INFOImportFlag")
	s PBatNo=PJObj.%Get("BatNo")
	s PPbFlag=PJObj.%Get("PublicBidding")
	s PPbLevel=PJObj.%Get("INFOPBLevel")
	s PSpFrom=PJObj.%Get("MinSp")
	s PSpTo=PJObj.%Get("MaxSp")
	s PRpFrom=PJObj.%Get("MinRp")
	s PRpTo=PJObj.%Get("MaxRp")
	s PInclb=PJObj.%Get("Inclb")
	s PStockLocFlag=PJObj.%Get("StockLocFlag")	//供给科室库房标记
	i PLocId'="" s PStockLocFlag=""
	s POfficial=PJObj.%Get("Official")
	s PClinicalCat=PJObj.%Get("ClinicalCat")
	
	s PHospId=..sssHospId(+PLocId)
	s:PHospId="" PHospId=HospId
	s TotalScgStr=""
	s LocLength=$l(PLocId,",")
	f i=1:1:LocLength d
	.s LocId=$p(PLocId,",",i)
	.q:LocId=""
	.s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(PUserId,PScgType,LocId,PStkGrpId,"")
	.s TotalScgStr=TotalScgStr_"^"_ScgStr
	s PStkGrpId=TotalScgStr
	s PStkType=..sssCode()
	s LocGrpItems=..GetLocGrpItems(+PLocId)
	s PLocGrpItems="^"_LocGrpItems_"^"
	k InitiInciInfo,InitiInclbInfo,InitiFromLocInfo,InitToLocInfo	//"数组",记录库存项相关数据
	s i=0
	s TrType="T"
	f Date=PStartDate:1:PEndDate d
	.s IntrDate=..DL2H(Date)
	.s IntrId="" 
	.f  s IntrId=$o(^DHCINTR(0,"TypeDate",TrType,Date,IntrId)) q:IntrId=""  d
	..q:'$d(^DHCINTR(IntrId))
	..s IntrInfo=^DHCINTR(IntrId)
	..;台账信息
	..s IntrTime=$p(IntrInfo,"^",3)
	..s Inclb=$p(IntrInfo,"^",7)
	..s Initi=$p(IntrInfo,"^",9)		;Pointer
	..s IntrNo=$p(IntrInfo,"^",13)
	..s AuditUserId=$p(IntrInfo,"^",11)
	..s AuditUser=$s(AuditUserId'="":$p(^SSU("SSUSR",AuditUserId),"^",2),1:"")
	..;台账信息过滤
	..q:Inclb=""
	..q:(PInclb'="")&&(PInclb'=Inclb)
	..q:(Date=PStartDate)&&(PStartTime'="")&&(IntrTime<PStartTime)
	..q:(Date=PEndDate)&&(PEndTime'="")&&(IntrTime>=PEndTime)
	..
	..
	..s Init=+Initi
	..s InitiCh=$p(Initi,"||",2)
	..q:'$d(^DHCINIT(Init))||'$d(^DHCINIT(Init,"ITI",InitiCh))
	..s dhcitda=$o(^DHCITD(0,"IATypePointer","ST",pointer,""))	//根据补录记录过滤
	..q:+dhcitda'>0
	..s DHCLocRowID=$o(^DHCLOC(0,"LOC",FromLocId,""))      ;过滤虚库
	..s MainLoc=$s(DHCLocRowID'="":$p(^DHCLOC(DHCLocRowID),"^",6),1:"")
	..q:MainLoc'=""
	..s InitStr=^DHCINIT(Init)
	..s InitiItmStr=^DHCINIT(Init,"ITI",InitiCh)
	..;库存转移主表信息
	..s FromLocId=$p(InitStr,"^",5)   ;出库科室
	..s ToLocId=$p(InitStr,"^",6)   ;接收科室
	..s CreateUserId=$p(InitStr,"^",8)   ;制单人
	..s StkType=$p(InitStr,"^",24)
	..s OutType=$p(InitStr,"^",20)
	..;库存转移主表信息过滤
	..q:ToLocId=""
	..q:(PLocId'="")&&((","_PLocId_",")'[(","_ToLocId_","))
	..q:(PRecLocId'="")&(ToLocId'=PRecLocId)   ;非接收科室
	..q:(PCreateUserId'="")&&(CreateUserId'=PCreateUserId)
	..q:StkType'=PStkType
	..q:(POutType'="")&(OutType'=POutType)		;按出库类型过滤
	..;库存转移子表信息
	..s Reqi=$p(InitiItmStr,"^",2)
	..s UomId=$p(InitiItmStr,"^",7)
	..s Sp=$p(InitiItmStr,"^",17)		;售价
	..s Rp=$p(InitiItmStr,"^",15)		;进价
	..s BatSp=$p(InitiItmStr,"^",21)		;批次售价
	..s Qty=$p(InitiItmStr,"^",1)
	..s RpAmt=-$p(InitiItmStr,"^",16)
	..s SpAmt=-$p(InitiItmStr,"^",18)
	..s BatSpAmt=-$p(InitiItmStr,"^",22)
	..
	..s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	..s Inci=$p(Inclb,"||",1)
	..q:(PInci'="")&(PInci'=Inci)			;库存项不符
	..q:'$d(^INCI(Inci,1))||'$d(^INCI(Inci,2))||'$d(^INCI(Inci,3))
	..;库存项信息	
	..i '$d(InciInfoArray(Inci)) d
	...s InciObj=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetInciObj(Inci,PScgType,PHospId)
	...s InciInfoArray(Inci)=InciObj
	..s InciObj=InciInfoArray(Inci)
	..s InciCode=InciObj.InciCode,InciDesc=InciObj.InciDesc
	..s BUomId=InciObj.BUomId,PUomId=InciObj.PUomId,UomFac=InciObj.UomFac,BUomDesc=InciObj.BUomDesc,PUomDesc=InciObj.PUomDesc
	..s HVFlag=InciObj.HVFlag,ChargeFlag=InciObj.ChargeFlag
	..s BookCatId=InciObj.BookCatId,BookCatCode=InciObj.BookCatCode,BookCatDesc=InciObj.BookCatDesc
	..s IncscId=InciObj.IncscId,IncscDesc=InciObj.IncscDesc,IncscCode=InciObj.IncscCode
	..s ScgId=InciObj.ScgId,StkGrpDesc=InciObj.StkGrpDesc
	..s MarkTypeId=InciObj.MarkTypeId,MarkType=InciObj.MarkType
	..s ImpFlag=InciObj.ImpFlag,PbFlag=InciObj.PbFlag,PbLevel=InciObj.PbLevel,PbLevelDesc=InciObj.PbLevelDesc
	..s Spec=InciObj.Spec,Model=InciObj.Model,Brand=InciObj.Brand,LastVendorDesc=InciObj.LastVendorDesc
	..s MonitorFlag=InciObj.MonitorFlag
	..s MatInsuCode=InciObj.MatInsuCode,MatInsuDesc=InciObj.MatInsuDesc
	..s OfficialCatId=InciObj.OfficialCatId,OfficialCatDesc=InciObj.OfficialCatDesc
	..s ClinicCatId=InciObj.ClinicCatId,ClinicCatDesc=InciObj.ClinicCatDesc 
	..
	..;库存项信息过滤
	..q:ScgId=""
	..q:HVFlag'="Y"
	..q:(PInciDesc'="")&&(InciDesc'[PInciDesc)
	..q:(PStkGrpId'="")&&(("^"_PStkGrpId_"^")'[("^"_ScgId_"^"))
	..q:(PStkCatId'="")&&((","_PStkCatId_",")'[(","_IncscId_","))
	..q:(PChargeFlag'="")&&(ChargeFlag'=PChargeFlag)
	..q:(PMarkType'="")&&(MarkTypeId'=PMarkType)		;定价类型
	..q:(PImpFlag'="")&&(ImpFlag'=PImpFlag)
	..q:(PPbFlag'="")&&(PbFlag'=PPbFlag)
	..q:(PPbLevel'="")&&(PbLevel'=PPbLevel)				;是否招标
	..q:(POfficial'="")&&(OfficialCatId'=POfficial)
	..q:(PClinicalCat'="")&&(ClinicCatId'=PClinicalCat)
	..;批次信息
	..i '$d(InclbInfoArray(Inclb)) d
	...s InclbObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetInclbObj(Inclb,Date)
	...s InclbInfoArray(Inclb)=InclbObj
	..s InclbObj=InclbInfoArray(Inclb)
	..s VenId=InclbObj.VenId,VenName=InclbObj.VenName
	..s ManfId=InclbObj.ManfId,ManfName=InclbObj.ManfName
	..s BatNo=InclbObj.BatNo,ExpireDate=InclbObj.ExpireDate
	..s SourceOfFundId=InclbObj.SourceOfFundId,SourceOfFundDesc=InclbObj.SourceOfFundDesc
	..s SterilizedBat=InclbObj.SterilizedBat,GiftFlag=InclbObj.GiftFlag
	..;批次信息过滤
	..q:(PVendorId'="")&(VenId'=PVendorId)				;按供应商过滤
	..q:(PManfId'="")&(ManfId'=PManfId)					;生产厂家
	..q:(PBatNo'="")&(BatNo'=PBatNo)
	..q:(PSourceFund'="")&&(SourceOfFundId'=PSourceFund)
	..q:(PGiftFlag'="")&&(GiftFlag'=PGiftFlag)
	..
	..
	..;价格信息过滤
	..s IntrUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
	..s RealTrQty=0
	..s QtyPUom=(Qty*IntrUomFac)/UomFac
	..s SpPUom=(Sp/IntrUomFac)*UomFac
	..s RpPUom=(Rp/IntrUomFac)*UomFac
	..s BatSpPUom=(BatSp/IntrUomFac)*UomFac
	..s QtyBUom=Qty*IntrUomFac
	..s SpBUom=Sp/IntrUomFac
	..s RpBUom=Rp/IntrUomFac
	..s BatSpBUom=BatSp/IntrUomFac
	..s SetStatBUom=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTTRANSFERM","SetStatBUom","^"_+PLocId)
	..i SetStatBUom="Y" d
	...s UomDesc=BUomDesc
	...s Rp=RpBUom
	...s Sp=SpBUom
	...s BatSp=BatSpBUom
	...s TrQty=QtyBUom
	..e  d
	...s UomDesc=PUomDesc
	...s Rp=RpPUom
	...s Sp=SpPUom
	...s BatSp=BatSpPUom
	...s TrQty=QtyPUom
	..s TrQty=-TrQty
	..q:(PRpFrom'="")&&(Rp<+PRpFrom)				;前闭后开区间
	..q:(PRpTo'="")&&(Rp>=+PRpTo)
	..q:(PSpFrom'="")&&(Sp<+PSpFrom)				;前闭后开区间
	..q:(PSpTo'="")&&(Sp>=+PSpTo)
	..;接收科室信息过滤
	..i '$d(ToLocInfoArray(ToLocId)) d
	...s ToLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(ToLocId)
	...s ToLocInfoArray(ToLocId)=ToLocInfoObj
	..s ToLocInfoObj=ToLocInfoArray(ToLocId)
	..s IfStockLoc=ToLocInfoObj.IfStockLocFlag
	..q:(PStockLocFlag'="")&&(IfStockLoc'=PStockLocFlag)
	..;转出科室信息过滤
	..i '$d(FrLocInfoArray(FromLocId)) d
	...s FrLocInfoObj=##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj(FromLocId,PLocGrpItems)
	...s FrLocInfoArray(FromLocId)=FrLocInfoObj
	..s FrLocInfoObj=FrLocInfoArray(FromLocId)
	..s FromLocCode=FrLocInfoObj.LocCode,FromLocDesc=FrLocInfoObj.LocDesc
	..s FromLocGrp=FrLocInfoObj.LocGrp,FromLocGrpItm=FrLocInfoObj.LocGrpItm,InLocGrpItems=FrLocInfoObj.InLocGrpItemsFalg
	..q:(PLocGroupDesc'="")&&(FromLocGrpItm'=PLocGroupDesc)	;科室组过滤
	..q:(PTransRange=1)&&(InLocGrpItems="N")		;过滤组外部分
	..q:(PTransRange=2)&&(InLocGrpItems="Y")		;过滤组内部分
	..	
	..;其他变量取值
	..s StkbinInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetStkBin(ToLocId,Inci)
	..s Stkbin=$p(StkbinInfo,"^",1)
	..s ReqUserId=0,(ReqName,ReqNo,InrqiType,ReqItmRemark)=""
	..i Reqi'="" d
	...s ReqUserId=$p(^INRQ(+Reqi),"^",4)
	...s ReqNo=$p(^INRQ(+Reqi),"^",1)
	...s DhcInrqi=$o(^DHCINRQI(0,"INRQI",Reqi,""))
	...q:DhcInrqi=""
	...s InrqiType=$p(^DHCINRQI(DhcInrqi),"^",7)
	...s ReqItmRemark=$p(^DHCINRQI(DhcInrqi),"^",2)
	..s:+ReqUserId>0 ReqName=$p(^SSU("SSUSR",ReqUserId),"^",2)
	..;组织数据按 台帐/库存转移主表/库存转移子表/库存项/批次/其他 的方式进行
	..s DataIntr=IntrId_"^"_TrType_"^"_IntrDate_"^"_IntrNo
	..s DataInit=Init_"^"_AuditUser_"^"_FromLocCode_"^"_FromLocDesc_"^"_FromLocGrp_"^"_FromLocGrpItm
	..s DataIniti=Initi_"^"_InitiCh_"^"_RpAmt_"^"_SpAmt_"^"_BatSpAmt_"^"_TrQty_"^"_Rp_"^"_Sp_"^"_BatSp
	..s DataInci=Inci_"^"_InciCode_"^"_InciDesc_"^"_UomDesc_"^"_HVFlag_"^"_ChargeFlag_"^"_BookCatCode_"^"_BookCatDesc_"^"_IncscDesc_"^"_IncscCode_"^"_StkGrpDesc_"^"_MarkType_"^"_ImpFlag_"^"_PbFlag_"^"_PbLevelDesc_"^"_Spec_"^"_Model_"^"_Brand_"^"_LastVendorDesc_"^"_MonitorFlag_"^"_MatInsuCode_"^"_MatInsuDesc_"^"_OfficialCatDesc_"^"_ClinicCatDesc_"^"_Stkbin
	..s DataInclb=Inclb_"^"_Incib_"^"_VenId_"^"_VenName_"^"_ManfId_"^"_ManfName_"^"_BatNo_"^"_ExpireDate_"^"_SourceOfFundDesc_"^"_SterilizedBat_"^"_GiftFlag
	..s DataOther=ReqName_"^"_ReqItmRemark_"^"_InrqiType_"^"_ReqNo
	..s Data=DataIntr_"^"_DataInit_"^"_DataIniti_"^"_DataInci_"^"_DataInclb_"^"_DataOther
	..s i=i+1
	..s ^TMPDHCSTM(Pid,"OUTDETAIL",i)=$lfs(Data,"^")
	q Pid
}

/// Descript: 统计某个科室某时间断内某个材料的转出数量(排除库房,入库单位)
/// Creater: lihui
/// CreateDate: 2017-05-23
/// Table: DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// InPut: 开始日期,截止日期,接收科室,库存项id,开始时间,结束时间   ;^DHCLOC({DHCLoc_RowID})
/// Return: 转出数量
/// w ##class(web.DHCSTMHUI.DHCINIsTrfStat).GetInciTrfOutQty("64426","64426",1,9448,"","")
ClassMethod GetInciTrfOutQty(StartDate As %String, EndDate As %String, LocId As %String, Inci As %String, StartTime As %String = "", EndTime As %String = "") As %Library.String
{
	n (StartDate,EndDate,LocId,Inci,StartTime,EndTime)
	q:StartDate="" 0
	q:EndDate="" 0
	q:LocId="" 0
	q:Inci="" 0
	s TrType="T",TrfOutQtyAll="",ToLocType=""
	f date=StartDate:1:EndDate d
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s trTime=$p(^DHCINTR(intrid),"^",3)
	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
	..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
	..q:FromLocId=""
	..q:(FromLocId'=LocId)   ;过滤统计科室不是作为出库科室
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'=..sssCode()
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;接收科室
	..s DhcLocid=$o(^DHCLOC(0,"LOC",ToLocId,""))
	..s:DhcLocid'="" ToLocType=$p(^DHCLOC(DhcLocid),"^",5)
	..q:ToLocType="A"  ;排除接收科室类型为器械材料的库房(科室拓展信息维护中维护)
	..s inclbid=$p(^DHCINTR(intrid),"^",7)   ;科室批次id
	..q:inclbid=""
	..s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	..s inciid=$p(inclbid,"||",1)
	..q:(Inci'=inciid)			;库存项不符
	..s BUomId=$p(^INCI(inciid,1),"^",10)  ;基本单位
	..s PurUomId=$p(^INCI(inciid,3),"^",6) ;入库单位
	..s TrfitmInfo=^DHCINIT(MainId,"ITI",Chl)
	..s TrUom=$p(TrfitmInfo,"^",7)     ;转移单位
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	..s TrfOutQty=$p(TrfitmInfo,"^",1)
	..s TrfOutQty=TrfOutQty*Fac1/Fac2
	..if TrfOutQtyAll="" d
	...s TrfOutQtyAll=TrfOutQty
	..e  d
	...s TrfOutQtyAll=TrfOutQtyAll+TrfOutQty  ;转出总数量
	..
	.
	q TrfOutQtyAll
}

/// Descript: 统计某个科室某时间断内某个材料的转入数量(排除库房,入库单位)
/// Creater: lihui
/// CreateDate: 2017-05-23
/// Table: DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// InPut: 开始日期,截止日期,接收科室,库存项id,开始时间,结束时间
/// Return: 转入数量
/// w ##class(web.DHCSTMHUI.DHCINIsTrfStat).GetInciTrfInQty("64426","64426",1,9448,"","")
ClassMethod GetInciTrfInQty(StartDate As %String, EndDate As %String, LocId As %String, Inci As %String, StartTime As %String = "", EndTime As %String = "") As %Library.String
{
	n (StartDate,EndDate,LocId,Inci,StartTime,EndTime)
	q:StartDate="" 0
	q:EndDate="" 0
	q:LocId="" 0
	q:Inci="" 0
	s TrType="K",TrfInQtyAll="",FromLocType=""
	f date=StartDate:1:EndDate d
	.s intrid=""
	.f  s intrid=$o(^DHCINTR(0,"TypeDate",TrType,date,intrid)) q:intrid=""  d
	..q:'$d(^DHCINTR(intrid))
	..s trTime=$p(^DHCINTR(intrid),"^",3)
	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
	..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
	..s pointer=$p(^DHCINTR(intrid),"^",9)
	..s MainId=+pointer
	..s Chl=$p(pointer,"||",2)
	..q:'$d(^DHCINIT(MainId))
	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
	..q:FromLocId=""
	..s DhcLocid=$o(^DHCLOC(0,"LOC",FromLocId,""))
	..s:DhcLocid'="" FromLocType=$p(^DHCLOC(DhcLocid),"^",5)
	..q:FromLocType="A"  ;排除接收科室类型为器械材料的库房(科室拓展信息维护中维护)
	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;接收科室
	..q:(ToLocId'=LocId)   ;过滤统计科室不是作为接收科室
	..s StkType=$p(^DHCINIT(MainId),"^",24)
	..q:StkType'=..sssCode()
	..s inclbid=$p(^DHCINTR(intrid),"^",7)   ;科室批次id
	..q:inclbid=""
	..s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
	..s inciid=$p(inclbid,"||",1)
	..q:(Inci'=inciid)			;库存项不符
	..s BUomId=$p(^INCI(inciid,1),"^",10)  ;基本单位
	..s PurUomId=$p(^INCI(inciid,3),"^",6) ;入库单位
	..s TrfitmInfo=^DHCINIT(MainId,"ITI",Chl)
	..s TrUom=$p(TrfitmInfo,"^",7)     ;转移单位
	..s Fac2=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	..s Fac1=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(TrUom,BUomId)
	..s TrfInQty=$p(TrfitmInfo,"^",1)
	..s TrfInQty=TrfInQty*Fac1/Fac2
	..if TrfInQtyAll="" d
	...s TrfInQtyAll=TrfInQty
	..e  d
	...s TrfInQtyAll=TrfInQtyAll+TrfInQty   ;转入总数量
	..
	.
	q TrfInQtyAll
}

/// 2015-05-27
/// 取科室组内所有科室,^隔开
/// w ##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocGrpItems(111)
ClassMethod GetLocGrpItems(LocId) As %String
{
	n (LocId)
	q:LocId="" ""
	s result=LocId
	s dhcLoc=$o(^DHCLOC(0,"LOC",LocId,""))
	i dhcLoc'="" d
	.s SLG=$p(^DHCLOC(dhcLoc),"^",3)
	.q:SLG=""
	.&sql(declare SlgIdCursor Cursor for
		select dhcloc_ctloc_dr from dhcst_ctloc where dhcloc_slg_dr=:SLG)
	.&sql(open SlgIdCursor)
	.f  &sql(fetch SlgIdCursor into :SlgLocId) q:SQLCODE  d
	..q:SlgLocId=LocId		;不再处理
	..s result=result_"^"_SlgLocId
	.&sql(close SlgIdCursor)
	
	q result
}

/// 获取批次信息(object)
ClassMethod GetInclbObj(Inclb, Date) As %String
{
	n (Inclb, Date)

	s Obj={}
	q:(Inclb="") Obj
	s VenInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(Inclb,Date)
	s VenId=$p(VenInfo,"^",1)
	s VenName=$p(VenInfo,"^",2)
	s ManfInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(Inclb)
	s ManfId=$p(ManfInfo,"^",1)
	s ManfName=$p(ManfInfo,"^",2)
	s BatInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	s BatNo=$p(BatInfo,"^",1)
	s ExpireDate=$p(BatInfo,"^",2)
	s SourceOfFundInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSourceOfFundInfoByInclb(Inclb)
	s SourceOfFundId=$p(SourceOfFundInfo,"^",1)
	s SourceOfFundDesc=$p(SourceOfFundInfo,"^",2)
	s SterilizedBat=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSterilizedBatByInclb(Inclb)
	s GiftFlag=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetGiftFlagByInclb(Inclb)
	s Obj.VenId=VenId			;供应商RowID
	s Obj.VenName=VenName		;供应商描述
	s Obj.ManfId=ManfId			;生产厂家RowID
	s Obj.ManfName=ManfName		;生产厂家描述
	s Obj.BatNo=BatNo			;批号
	s Obj.ExpireDate=ExpireDate	;效期
	s Obj.SourceOfFundId=SourceOfFundId		;资金来源RowID
	s Obj.SourceOfFundDesc=SourceOfFundDesc	;资金来源描述
	s Obj.SterilizedBat=SterilizedBat		;灭菌批号
	s Obj.GiftFlag=GiftFlag		;捐赠标志
	
	q Obj
}

/// w ##class(web.DHCSTMHUI.DHCINIsTrfStat).GetLocInfoObj()
ClassMethod GetLocInfoObj(LocId, LocGrpItems = "") As %String
{
	n (LocId,LocGrpItems)

	s Obj={}
	q:(LocId="") Obj
	s LocDesc=$p(^CTLOC(LocId),"^",2)
	s LocCode=$p(^CTLOC(LocId),"^",1)
	s LocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(LocDesc)
	s IfStockLocFlag=##class(web.DHCSTMHUI.Common.UtilCommon).IfStockLoc(LocId)
	s LocGrp=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocItmGrp(LocId)
	s:LocGrp="" LocGrp="不详"
	s LocGrpItm=##class(web.DHCSTMHUI.Common.UtilCommon).GetLocGrpItm(LocId)
	s:LocGrpItm="" LocGrpItm="不详"
	s InLocGrpItemsFalg="N"
	s:LocGrpItems'="" InLocGrpItemsFalg=$s(LocGrpItems[("^"_LocId_"^"):"Y",1:"N")
	s Obj.LocCode=LocCode
	s Obj.LocDesc=LocDesc
	s Obj.IfStockLocFlag=IfStockLocFlag	;是否库房标志
	s Obj.LocGrp=LocGrp					;科室项目组
	s Obj.LocGrpItm=LocGrpItm			;科室组名称
	s Obj.LocGrpItems=LocGrpItems
	s Obj.InLocGrpItemsFalg=InLocGrpItemsFalg
	q Obj
}

}
