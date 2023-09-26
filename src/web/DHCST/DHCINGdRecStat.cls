/// Descript:入库汇总相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-08
Class web.DHCST.DHCINGdRecStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询入库明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-08
/// Table:DHC_InGdRec,DHC_InGdRecItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志
/// Output:入库明细
/// Return：	
ClassMethod GetImportDetail(StartDate, EndDate, LocId, Others, StartTime, EndTime) As %Library.String
{

	n (StartDate, EndDate, LocId, Others,StartTime,EndTime)
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocId="" ""
	s pid=..NewPid()
	s StkGrpId=$p(Others,"^",1)
	s StkCatId=$p(Others,"^",2)
	s InciRowid=$p(Others,"^",3)
	s MarkType=$p(Others,"^",4)
	s ImpFlag=$p(Others,"^",5)
	s BatNo=$p(Others,"^",6)
	s PbFlag=$p(Others,"^",7)
	s PbLevel=$p(Others,"^",8)
	s PhcCatId=$p(Others,"^",9)
	s PhcSubCatId=$p(Others,"^",10)
	s PhcMinCatId=$p(Others,"^",11)
	s ManfId=$p(Others,"^",12)
	s FormDesc=$p(Others,"^",13)
	s InsuType=$p(Others,"^",14)
	s PoisonCat=$p(Others,"^",15)
	s VendorId=$p(Others,"^",16)
	s ImpType=$p(Others,"^",17)
	s SpFrom=$p(Others,"^",18)
	s SpTo=$p(Others,"^",19)
	s RpFrom=$p(Others,"^",20)
	s RpTo=$p(Others,"^",21)
	s InvNo=$p(Others,"^",22)
	s SpFlag=$p(Others,"^",23)
	s BasicDrugFlag=$p(Others,"^",24) //基本药物标记
	s PhcCatAll=$p(Others,"^",25) //多级药学分类
	s HospId=$p(^CTLOC(LocId),"^",22)
	s i=0
	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","G",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..s trTime=$p(^DHCINTR(intrid),"^",3)
 	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
    ..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
    ..
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s dhcingr=+pointer
 	..s dhcingri=$p(pointer,"||",2)
 	..q:'$d(^DHCINGR(dhcingr))
 	..q:'$d(^DHCINGR(dhcingr,"GRI",dhcingri))
 	..;b ;1
 	..
 	..s StkType=$p(^DHCINGR(dhcingr),"^",30)
 	..q:StkType'=..sssCode()
 	..
 	..//s RecLocId=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",3)
 	..s RecLocId=$p(^DHCINGR(dhcingr),"^",13)
 	..q:RecLocId'=LocId   ;非统计科室
 	..
 	..s inclbid=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",1)
 	..q:inclbid=""
 	..
 	..s inciid=$p(inclbid,"||",1)
 	..q:(InciRowid'="")&(InciRowid'=inciid)			;库存项不符
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..s incidesc=$p(^INCI(inciid,1),"^",2) 
 	..
 	..s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
 	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	..q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
 	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
 	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
 	..q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
 	..;b ;2
 	..s incscdesc=""
 	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
 	..s spType=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionSpType(inciid)
 	..s MarkType2=""
 	..i MarkType'="" s MarkType2=$p(^DHCINMT(MarkType),"^",2)
 	..q:(MarkType2'="")&(spType'=MarkType2)			;定价类型
 	..
 	..s TmpImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImportFlag(inciid)	;进口标志
 	..q:(ImpFlag'="")&(TmpImpFlag'=ImpFlag)
 	..
 	..s StrPhcCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(inciid)
 	..s TmpPhcCatId=$p(StrPhcCat,"^",2)
 	..s TmpPhcCatDesc=$p(StrPhcCat,"^",1)
 	..q:(PhcCatId'="")&(TmpPhcCatId'=PhcCatId)				;药学大类
 	..;b ;3
 	..s StrPhcSubCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(inciid)
 	..s TmpPhcSubCatId=$p(StrPhcSubCat,"^",2)
 	..s TmpPhcSubCatDesc=$p(StrPhcSubCat,"^",1)
 	..q:(PhcSubCatId'="")&(TmpPhcSubCatId'=PhcSubCatId)			;药学子类
 	..
 	..s StrPhcMinCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(inciid)
 	..//s arcItmId=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
 	..//s genericId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),8)),"^",20)
 	..//s chemicalId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",3)
 	..//q:chemicalId=""
 	..//s TmpPhcMinCatId=$p(^DHCPHCM(chemicalId),"^",3)
 	..//s TmpPhcMinCatDesc=$p($g(^DHCPHCC(+TmpPhcMinCatId)),"^",2)
 	..s TmpPhcMinCatId=$p(StrPhcMinCat,"^",2)
 	..s TmpPhcMinCatDesc=$p(StrPhcMinCat,"^",1)
 	..q:(PhcMinCatId'="")&(TmpPhcMinCatId'=PhcMinCatId)
 	..s gmanfid=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",29)
 	..q:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 	..s manfhisid="" //..GetManfHis(gmanfid,date)    ;历史厂商ID  已不维护
 	..s Manf=""
 	..s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2) 
 	..;s Manf=manfhisid
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..;b ;4
 	..s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
	..s ofcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId) //医保类别
 	..//s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..//q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
 	..
 	..s apcvmid=$p(^DHCINGR(dhcingr),"^",3)
 	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
 	..s VenName=""
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)
 	..
 	..s tmpimpsort=$p(^DHCINGR(dhcingr),"^",23)
 	..q:(ImpType'="")&(tmpimpsort'=ImpType)			;按入库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	
 	..s TmpPbLevelDr=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevelDr'=PbLevel) 		;招标级别
 	..i TmpPbLevelDr="" s TmpPbLevel=""
 	..e  s TmpPbLevel=$p(^DHCITMPBL(TmpPbLevelDr),"^",2)
 	..;b ;5
 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag="是"
 	..s:TmpBaFlag="N" TmpBaFlag="否"
 	..s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inciid) ;通用名
	..s Gene=$p(GeneInfo,"^",2)
	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid) ;规格
	..s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid) ;剂型
	..s Form=$p(FormInfo,"^",2)
	..s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inciid) ;厂商
	..s ManfDesc=$p(ManfInfo,"^",3)
 	..s sp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",32)      ;售价
 	..s rp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",30)      ;进价
 	..s newsp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",45)
 	..s qty=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",4)
 	..s inuom=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",10)
 	..s inuomdesc=""
 	..s:inuom'="" inuomdesc=$p(^CT("UOM",inuom),"^",2)
 	..s buom=$p(^INCI(inciid,1),"^",10)
 	..s puruom=$p(^INCI(inciid,3),"^",6)
 	..s buomdesc=$p(^CT("UOM",buom),"^",2)
 	..i puruom="" s puruom=buom,puruomdesc=buomdesc
 	..e  s puruomdesc=$p(^CT("UOM",puruom),"^",2)
 	..s bfac=##class(web.DHCST.Common.UtilCommon).UOMFac(inuom,buom) ; factor 
 	..s pfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
 	..s pqty=(qty*bfac)/pfac
 	..s psp=(sp*pfac)/bfac
 	..s prp=(rp*pfac)/bfac
 	..s pnewsp=(newsp*pfac)/bfac
 	..s psp=##Class(web.DHCST.Common.AppCommon).FormatInciSp(psp,HospId,inciid,puruom)
 	..s prp=##Class(web.DHCST.Common.AppCommon).FormatInciRp(prp,HospId,inciid,puruom)
 	..q:(SpFrom'="")&(psp<+SpFrom)      ;低于售价范围最小值
 	..q:(SpTo'="")&(psp>+SpTo)
 	..
 	..q:(RpFrom'="")&(prp<+RpFrom)
 	..q:(RpTo'="")&(prp>+RpTo)
 	..
 	..q:(SpFlag="1")&(newsp=sp)	;批次售价和售价不等的checkbox勾上 090701
	..s BasicDrug="" //wyx add 2013-01-26 增加基本药物标记
	..s Info=$o(^DHCITMINFO(0,"INCI",inciid,0))
	..s BasicDrug=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(inciid)
 	..q:(BasicDrugFlag="1")&(BasicDrug'="Y")
 	..;b ;6
 	..s invno=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",27)
 	..q:(InvNo'="")&(invno'=InvNo)				;按发票号过滤 090623
 	..
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inclbid)
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&($p(TmpPoison,"^",1)'=PoisonCat)
	..s PhaCatAllDesc=""
	..s arcItmId=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
 	..s genericId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),8)),"^",20)
 	..s chemicalId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",3)
 	..q:chemicalId=""
 	..s PhaCatAlls=$p($g(^PHCGE("GE",genericId,"DHC")),"^",6)
 	..//s PhaCatAllDesc=$p($g(^DHCPHCC(+PhaCatAlls)),"^",2)
 	..s PhaCatAllDesc=$P(##class(PHA.IN.DHCPHCCat.Query).GetPHCCatAll(PhaCatAlls),"^",2)
	..//s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
	..//s PhaCatAllDesc=""
	..//s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhcdf(Phcdf)
	..//s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..//s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	..//q:(PhcCatAll'="")&(PhaCatAlls'=PhcCatAll) //add wyx 2014-12-08 药学多级分类
 	..s ingrno=$p(^DHCINGR(dhcingr),"^",1) 
	..s incicode=$p(^INCI(inciid,1),"^",1)
 	..//s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(RecLocId,inciid)
 	..//s stkbin=$p(stkbin,"^",1)
 	..s incil=$p(inclbid,"||",1,2)
 	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    ..s stkbinstr=$p(stkbinret,":",2)
    ..s stkbin=stkbinstr  //货位
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..s zbbsdesc=""
 	..s ingrdate=date 
 	..s invdate=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",34)
 	..s:invdate'="" invdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invdate,"ST")
	..s rpcosts=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",31)
 	..s spcosts=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",50) //$g(qty)*$g(sp)
 	..s pprice=+$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",35)
 	..s ppcosts=qty*pprice
 	..s pprice=(pprice*pfac)/bfac
 	..s newspcosts=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",46)
 	..//s rpcosts=$fn(rpcosts,"",2)
 	..//s ppcosts=$fn(ppcosts,"",2)
 	..//s spcosts=$fn(spcosts,"",2)
 	..//s newspcosts=$fn(newspcosts,"",2)
 	..s cpcosts=spcosts-rpcosts
 	..s newcpcosts=newspcosts-rpcosts
 	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid)
 	..s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inciid, HospId)
 	..s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inciid, HospId)
 	..s i=i+1
 	..;
 	..s ^TMPDHCINSTAT(pid,"INDETAIL",i)=ingrno_"^"_invno_"^"_##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($g(ingrdate),"ST")_"^"_incicode_"^"_incidesc_"^"_$g(puruomdesc)_"^"_pqty_"^"_prp_"^"_rpcosts_"^"_psp_"^"_spcosts_"^"_$g(VenName)_"^"_$g(TmpBatNo)_"^"_$g(ExpireDate)_"^"_$g(Manf)_"^"_$g(stkbin)_"^"_pprice_"^"_ppcosts_"^"_invdate_"^"_pnewsp_"^"_newspcosts_"^"_spType_"^"_$g(TmpPbFlag)_"^"_TmpPbLevel_"^"_$g(ofcode)_"^"_TmpBaFlag_"^"_StkGrpDesc_"^"_incscdesc_"^"_Gene_"^"_Spec_"^"_Form_"^"_ManfDesc_"^"_PhaCatAllDesc_"^"_InsuCode_"^"_InsuDesc

 	q pid
}

/// Descript:	查询退货明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-08
/// Table:DHC_InGdRet,DHC_InGRtItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志
/// Output:入库明细
/// Return：	
ClassMethod GetReturnDetail(StartDate, EndDate, LocId, Others, StartTime, EndTime) As %Library.String
{
	n (StartDate, EndDate, LocId, Others,StartTime,EndTime)
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocId="" ""
	s pid=..NewPid()
	s StkGrpId=$p(Others,"^",1)
	s StkCatId=$p(Others,"^",2)
	s InciRowid=$p(Others,"^",3)
	s MarkType=$p(Others,"^",4)
	s ImpFlag=$p(Others,"^",5)
	s BatNo=$p(Others,"^",6)
	s PbFlag=$p(Others,"^",7)
	s PbLevel=$p(Others,"^",8)
	s PhcCatId=$p(Others,"^",9)
	s PhcSubCatId=$p(Others,"^",10)
	s PhcMinCatId=$p(Others,"^",11)
	s ManfId=$p(Others,"^",12)
	s FormDesc=$p(Others,"^",13)
	s InsuType=$p(Others,"^",14)
	s PoisonCat=$p(Others,"^",15)
	s VendorId=$p(Others,"^",16)
	s ImpType=$p(Others,"^",17)
	s SpFrom=$p(Others,"^",18)
	s SpTo=$p(Others,"^",19)
	s RpFrom=$p(Others,"^",20)
	s RpTo=$p(Others,"^",21)
	s InvNo=$p(Others,"^",22)
	s SpFlag=$p(Others,"^",23)
	s BasicDrugFlag=$p(Others,"^",24)
	s PhcCatAll=$p(Others,"^",25)
	s HospId=$p(^CTLOC(LocId),"^",22)
	;
	s i=0
 	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","R",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..s trTime=$p(^DHCINTR(intrid),"^",3)
 	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
    ..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s ingrtid=$p(pointer,"||",1)
 	..s retch=$p(pointer,"||",2)
 	..q:'$d(^INGRT(ingrtid))
 	..q:'$d(^INGRT(ingrtid,"DHCGRR",retch))
 	..s StkType=$p(^INGRT(ingrtid),"^",16)
 	..q:StkType'=..sssCode()
 	..s retstr=^INGRT(ingrtid)
 	..s retistr=^INGRT(ingrtid,"DHCGRR",retch)
 	..s ingriid=$p(retistr,"^",1) ;
 	..s dhcingri=ingriid
 	..s dhcingrich=$p(dhcingri,"||",2)
 	..s dhcingri=$p(dhcingri,"||",1)
 	..
 	..q:dhcingri=""
 	..q:dhcingrich=""
 	..
 	..s retcom=$p(retstr,"^",6)
 	..q:retcom'="Y"
 	..
 	..s RetLocId=$p(retstr,"^",7)
 	..q:(LocId'="")&(RetLocId'=LocId)
 	..
 	..s inclbid=$p(^DHCINTR(intrid),"^",7)
 	..q:inclbid=""
 	..
 	..s inciid=$p(inclbid,"||",1)
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..q:(InciRowid'="")&(inciid'=InciRowid)
 	..s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
 	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	..q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
 	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
 	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
 	..q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
 	..
 	..s incscdesc=""
 	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
 	..s spType=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionSpType(inciid)
 	..s MarkType2=""
 	..i MarkType'="" s MarkType2=$p(^DHCINMT(MarkType),"^",2)
 	..q:(MarkType2'="")&(spType'=MarkType2)			;定价类型
 	..
 	..s TmpImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImportFlag(inciid)
 	..q:(ImpFlag'="")&(TmpImpFlag'=ImpFlag)
 	..
 	..s StrPhcCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(inciid)
 	..s TmpPhcCatId=$p(StrPhcCat,"^",2)
 	..s TmpPhcCatDesc=$p(StrPhcCat,"^",1)
 	..q:(PhcCatId'="")&(TmpPhcCatId'=PhcCatId)				;药学大类
 	..
 	..s StrPhcSubCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(inciid)
 	..s TmpPhcSubCatId=$p(StrPhcSubCat,"^",2)
 	..s TmpPhcSubCatDesc=$p(StrPhcSubCat,"^",1)
 	..q:(PhcSubCatId'="")&(TmpPhcSubCatId'=PhcSubCatId)			;药学子类
 	..
 	..s StrPhcMinCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(inciid)
 	..s TmpPhcMinCatId=$p(StrPhcMinCat,"^",2)
 	..s TmpPhcMinCatDesc=$p(StrPhcMinCat,"^",1)
 	..q:(PhcMinCatId'="")&(TmpPhcMinCatId'=PhcMinCatId)
 	..s gmanfid=$p(^DHCINGR(dhcingri,"GRI",dhcingrich),"^",29)
 	..q:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 	..s Manf=""
 	..s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2) 
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
	..s ofcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId) //医保类别
 	..//s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..//q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
	..s apcvmid=$p(^INGRT(ingrtid),"^",2)
	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
	..s VenName=""
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)
 	..s tmpimpsort=$p(^DHCINGR(dhcingri),"^",23)
 	..q:(ImpType'="")&(tmpimpsort'=ImpType)			;按入库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	..
 	..s TmpPbLevelDr=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevelDr'=PbLevel) 		;招标级别
 	..i TmpPbLevelDr="" s TmpPbLevel=""
 	..e  s TmpPbLevel=$p(^DHCITMPBL(TmpPbLevelDr),"^",2)

 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag="是"
 	..s:TmpBaFlag="N" TmpBaFlag="否"
 	..s GeneInfo =##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inciid) ;通用名
	..s Gene=$p(GeneInfo,"^",2)
	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid) ;规格
	..s FormInfo=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid) ;剂型
	..s Form=$p(FormInfo,"^",2)
	..s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inciid) ;厂商
	..s ManfDesc=$p(ManfInfo,"^",3)
 	..s retqty=$p(retistr,"^",2)
 	..s retuom=$p(retistr,"^",3)
 	..s retsp=+$p(retistr,"^",8)    ;售价
 	..s retrp=+$p(retistr,"^",7)    ;进价
 	..s retpp=+$p(retistr,"^",10)
 	..s buom=+$p(^INCI(inciid,1),"^",10)
 	..s puruom=$p(^INCI(inciid,3),"^",6)
 	..s:$g(puruom)="" puruom=buom 
 	..s puruomdesc=$p(^CT("UOM",puruom),"^",2)
 	..s bfac=##class(web.DHCST.Common.UtilCommon).UOMFac(retuom,buom) ; factor 
 	..s pfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
 	..s pretqty=(retqty*bfac)/pfac
 	..s pretsp=(retsp*pfac)/bfac
 	..s pretrp=(retrp*pfac)/bfac
 	..s pretpp=(retpp*pfac)/bfac
 	..s pretsp=##Class(web.DHCST.Common.AppCommon).FormatInciSp(pretsp,HospId,inciid,puruom)
 	..s pretrp=##Class(web.DHCST.Common.AppCommon).FormatInciRp(pretrp,HospId,inciid,puruom)
 	..
 	..q:(SpFrom'="")&(pretsp<+SpFrom)      ;低于售价范围最小值
 	..q:(SpTo'="")&(pretsp>+SpTo)
 	..
 	..q:(RpFrom'="")&(pretrp<+RpFrom)
 	..q:(RpTo'="")&(pretrp>+RpTo)
 	..
 	..s invno=$p(retistr,"^",12)
 	..q:(InvNo'="")&(invno'=InvNo)				;按发票号过滤 090623
 	..
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inclbid)
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&($p(TmpPoison,"^",1)'=PoisonCat)
    ..s Info=$o(^DHCITMINFO(0,"INCI",inciid,0))
 	..s BasicDrug=##class(web.DHCST.Common.DrugInfoCommon).GetCountryBasicFlag(inciid)
 	..q:(BasicDrugFlag="1")&(BasicDrug'="Y")
 	..s PhaCatAllDesc=""
	..s arcItmId=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
 	..s genericId=$p($g(^ARCIM(+arcItmId,$p(arcItmId,"||",2),8)),"^",20)
 	..s chemicalId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",3)
 	..q:chemicalId=""
 	..s PhaCatAlls=$p($g(^PHCGE("GE",genericId,"DHC")),"^",6)
 	..//s PhaCatAllDesc=$p($g(^DHCPHCC(+PhaCatAlls)),"^",2)
 	..s PhaCatAllDesc=$P(##class(PHA.IN.DHCPHCCat.Query).GetPHCCatAll(PhaCatAlls),"^",2)
	..//s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
	..//s PhaCatAllDesc=""
	..//s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAllByPhcdf(Phcdf)
	..//s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..//s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	..//q:(PhcCatAll'="")&(PhaCatAlls'=PhcCatAll) //add wyx 2014-12-08 药学多级分类
 	..//s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(RetLocId,inciid)
 	..//s stkbin=$p(stkbin,"^",1)
 	..s incil=$p(inclbid,"||",1,2)
 	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    ..s stkbinstr=$p(stkbinret,":",2)
    ..s stkbin=stkbinstr  //货位
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..
	..s retno=$p(retstr,"^",1)
 	..s tmpno=retno
 	..s retdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(date,"ST") ;$p(retstr,"^",3)
 	..s retinvno=$p(retistr,"^",12)
 	..s retinvdate=$p(retistr,"^",14)
 	..i retinvdate'="" s retinvdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(retinvdate,"ST")
 	..e  s retinvdate=""
 	..s incicode=$p(^INCI(inciid,1),"^",1)
 	..s incidesc=$p(^INCI(inciid,1),"^",2)
 	..s zbbsdesc=""
 	..
 	..s retuom=$p(^CT("UOM",retuom),"^",2)
 	..
 	..s retrpamt=$p(retistr,"^",4)
 	..s retspamt=$p(retistr,"^",9)
 	..s retppamt=+$p(retistr,"^",11)
 	..s retbatsp=+$p(retistr,"^",15)
 	..s pretbatsp=(retbatsp*pfac)/bfac
 	..s retbatspamt=+$p(retistr,"^",16)
 	..s retqty=-retqty,retrpamt=-retrpamt,retspamt=-retspamt,retbatspamt=-retbatspamt
 	..s pretqty=-pretqty
 	..s cpcosts=retspamt-retrpamt
 	..s batcpcosts=retbatspamt-retrpamt
 	..s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inciid, HospId)
 	..s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inciid, HospId)
 	..s i=i+1
 	..s ^TMPDHCINSTAT(pid,"INDETAIL",i)=retno_"^"_retinvno_"^"_retdate_"^"_incicode_"^"_incidesc_"^"_puruomdesc_"^"_pretqty_"^"_pretrp_"^"_retrpamt_"^"_pretsp_"^"_retspamt_"^"_$g(VenName)_"^"_$g(TmpBatNo)_"^"_$g(ExpireDate)_"^"_$g(Manf)_"^"_$g(stkbin)_"^"_$g(pretpp)_"^"_$g(retppamt)_"^"_retinvdate_"^"_pretbatsp_"^"_retbatspamt_"^"_spType_"^"_$g(TmpPbFlag)_"^"_TmpPbLevel_"^"_$g(ofcode)_"^"_TmpBaFlag_"^"_StkGrpDesc_"^"_incscdesc_"^"_Gene_"^"_Spec_"^"_Form_"^"_ManfDesc_"^"_PhaCatAllDesc_"^"_InsuCode_"^"_InsuDesc
 	.
	q pid
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("ImportStat"))
}

Query QueryDetail(StartDate As %String = "", EndDate As %String = "", LocId As %String = "", RetFlag As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "No:%String,InvNo:%String,Date:%String,InciCode:%String,InciDesc:%String,UomDesc:%String,Qty:%Float,Rp:%String,RpAmt:%Double,Sp:%String,SpAmt:%Double,Vendor:%String,BatNo:%String,Expire:%String,Manf:%String,StkBin:%String,InvDate:%String,SpType:%String,PbFlag:%String,PbLevel:%String,OfficeCode:%String,Type:%String,StkGrpDesc:%String,incscdesc:%String,TmpBaFlag:%String,Gene:%String,Spec:%String,Form:%String,ManfDesc:%String,MinCatDesc:%String,InvoCount:%Integer,RecInvCount:%Integer,FmtRA:%String,FmtSA:%String,InsuCode,InsuDesc") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.DHCINGdRecStat","QueryDetail","2021-12-13","2022-01-12","187","1","3^^^^^^^^^^^^^^^^^^^^^^0^0^","","")
ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", RetFlag As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,RetFlag,Others,StartTime,EndTime)
	tro
	s ^zxdd("query")=$LB(StartDate,EndDate,LocId,RetFlag,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	

	
	k ^TMP("INVNO")
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""
	s HospId=$P(^CTLOC(LocId),"^",22)
	
	
	S FmtRA = ##Class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","FmtRA","^^^"_HospId)
	S FmtSA = ##Class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON","FmtSA","^^^"_HospId)
	i FmtRA = "" s FmtRA = "0.00"
	i FmtSA = "" s FmtSA = "0.00"
	
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	//s ^zxdd("query2")=StartTime_","_EndTime
	//统计入库
	s qPid=..GetImportDetail(StartDate,EndDate,LocId,Others,StartTime,EndTime)
	i qPid'="" d
	.d OutputRowImp
	.//s ^zxdd("query2")=StartDate_","_EndDate_","_LocId_","_RetFlag_","_Others_","_StartTime_","_EndTime
	s qPid=""
	i RetFlag=1  d
	.//统计退货
	.s qPid=..GetReturnDetail(StartDate,EndDate,LocId,Others,StartTime,EndTime) 
	i qPid'="" d
	.d OutputRowRet
	.
	;
	Quit $$$OK

OutputRowImp   
	s num=0
	f  s num=$o(^TMPDHCINSTAT(qPid,"INDETAIL",num))  q:num=""  d
	.s data=^TMPDHCINSTAT(qPid,"INDETAIL",num)
	.s IngrNo=$p(data,"^",1)
	.s InvNo=$p(data,"^",2)
	.s IngrDate=$p(data,"^",3)
	.s InciCode=$p(data,"^",4)
	.s InciDesc=$p(data,"^",5)
	.s RecUomDesc=$p(data,"^",6)
	.s RecQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s StkGrpDesc=$p(data,"^",27)
	.s incscdesc=$p(data,"^",28)
	.s Gene=$p(data,"^",29)
	.s Spec=$p(data,"^",30)
	.s Form=$p(data,"^",31)
	.s ManfDesc=$p(data,"^",32)
	.s MinCatDesc=$p(data,"^",33)
	.s InsuCode = $p(data,"^",34)
	.s InsuDesc = $p(data,"^",35)
	.s Type="G"
	.i InvNo="" d
	..s invocount=0
	..s recinvcount=0
	.e  d
	..i $d(^TMP("INVNO",InvNo)) s invocount=0
	..e  d
	...s ^TMP("INVNO",InvNo)=""
	...s invocount=1
	..s recinvcount=1
	.s Data=$lb(IngrNo,InvNo,IngrDate,InciCode,InciDesc,RecUomDesc,RecQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type,StkGrpDesc,incscdesc,TmpBaFlag,Gene,Spec,Form,ManfDesc,MinCatDesc,invocount,recinvcount,FmtRA,FmtSA,InsuCode,InsuDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	.
	k ^TMPDHCINSTAT(qPid,"INDETAIL")
	q
	
OutputRowRet   
	s num=0
	f  s num=$o(^TMPDHCINSTAT(qPid,"INDETAIL",num))  q:num=""  d
	.s data=^TMPDHCINSTAT(qPid,"INDETAIL",num)
	.s RetNo=$p(data,"^",1)
	.s InvNo=$p(data,"^",2)
	.s IngdDate=$p(data,"^",3)
	.s InciCode=$p(data,"^",4)
	.s InciDesc=$p(data,"^",5)
	.s RetUomDesc=$p(data,"^",6)
	.s RetQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s StkGrpDesc=$p(data,"^",27)
	.s incscdesc=$p(data,"^",28)
	.s Gene=$p(data,"^",29)
	.s Spec=$p(data,"^",30)
	.s Form=$p(data,"^",31)
	.s ManfDesc=$p(data,"^",32)
	.s MinCatDesc=$p(data,"^",33)
	.s InsuCode = $p(data,"^",34)
	.s InsuDesc = $p(data,"^",35)
	.s Type="R"
	.i InvNo="" d
	..s invocount=0
	..s recinvcount=0
	.e  d
	..i $d(^TMP("INVNO",InvNo)) s invocount=0
	..e  d
	...s ^TMP("INVNO",InvNo)=""
	...s invocount=1
	..s recinvcount=1
	.s Data=$lb(RetNo,InvNo,IngdDate,InciCode,InciDesc,RetUomDesc,RetQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type,StkGrpDesc,incscdesc,TmpBaFlag,Gene,Spec,Form,ManfDesc,MinCatDesc,invocount,recinvcount,FmtRA,FmtSA, InsuCode, InsuDesc)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	.
	k ^TMPDHCINSTAT(qPid,"INDETAIL")
	q
}

ClassMethod QueryDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" { 
	Set AtEnd=1
	Set Row=""
	}
	Else      { 
	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询入库明细
/// Author:zhangdongmei
/// Date:2012-11-30
/// Argu:
///   StartDate - 开始日期
///   EndDate-截止日期
///   LocId-科室
///   Others-类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志^是否按审核日期统计
/// Return:入库单号^发票号^制单日期^库存项代码^库存项名称^单位^入库数量^
/// 进价^进价金额^售价^售价金额^供应商名称^批号^效期^产地^货位^发票日期^
/// 定价类型^招标标志^招标级别^医保类型^状态^审核日期
///  Json数据串
///  w ##class(web.DHCST.DHCINGdRecStat).jsQueryRecDetail(0,30,"","","2018-06-17","2018-06-17","320","3^^^^^^^^^^^^^^^^^^^^^^0^N^^")
ClassMethod jsQueryRecDetail(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StartDate As %String, EndDate As %String, LocId As %String, Others As %String) As %String
{
	n (Start,Limit,Sort,Dir,StartDate,EndDate,LocId,Others)
	s ^zdm("jsQueryRecDetail",1)=Start_","_Limit_","_Sort_","_Dir_","_StartDate_","_EndDate_","_LocId_","_Others
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocId="" ""
	s StkGrpId=$p(Others,"^",1)
	s StkCatId=$p(Others,"^",2)
	s InciRowid=$p(Others,"^",3)
	s MarkType=$p(Others,"^",4)
	s ImpFlag=$p(Others,"^",5)
	s BatNo=$p(Others,"^",6)
	s PbFlag=$p(Others,"^",7)
	s PbLevel=$p(Others,"^",8)
	s PhcCatId=$p(Others,"^",9)
	s PhcSubCatId=$p(Others,"^",10)
	s PhcMinCatId=$p(Others,"^",11)
	s ManfId=$p(Others,"^",12)
	s FormDesc=$p(Others,"^",13)
	s InsuType=$p(Others,"^",14)
	s PoisonCat=$p(Others,"^",15)
	s VendorId=$p(Others,"^",16)
	s ImpType=$p(Others,"^",17)
	s SpFrom=$p(Others,"^",18)
	s SpTo=$p(Others,"^",19)
	s RpFrom=$p(Others,"^",20)
	s RpTo=$p(Others,"^",21)
	s InvNo=$p(Others,"^",22)
	s SpFlag=$p(Others,"^",23)
	s DateFlag=$p(Others,"^",24)   ;"Y":按审核日期查找，否则按制单日期查找
    s ImpNO=$p(Others,"^",25) //入库单号
    s PhcCatAll=$p(Others,"^",26) //多级药学分类
    s HospId=$p(^CTLOC(LocId),"^",22)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s sql="select INGRI_INGR_ParRef->ingr_no as IngrNo,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_apcvm_dr as VendorId,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_apcvm_dr->apcvm_name as Vendor,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_date as IngrDate,"
	s sql=sql_"INGRI_INGR_ParRef->ingr_createdate as IngrCreateDate,"
	s sql=sql_"ingri_rowid as Rowid,"
	s sql=sql_"initm_INCI_DR as Incid,initm_INCI_DR->inci_desc as InciDesc,"
	s sql=sql_"INGRI_INGR_ParRef->INGR_Loc_Dr as grlocdr "
 	s sql=sql_"from dhc_ingdrecitm where "
	i DateFlag="Y"  d
 	.s sql=sql_"(ingri_ingr_parref->ingr_date between "_StartDate_" and "_EndDate_")"
 	e  d
 	.s sql=sql_"(ingri_ingr_parref->ingr_createdate between "_StartDate_" and "_EndDate_")"
	s:Sort="" Sort="InciDesc"
	i (Sort="") || ('$f("IngrNo,Vendor,IngrDate,IngrCreateDate,InciDesc",Sort))  d
	.s Sort="InciDesc"
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:(Dir'="ASC")&(Dir'="DESC") Dir="ASC"
	s sql=sql_" order by "_Sort_" "_Dir
	s json = ##class(Code.JsonObj).%New()
	//s ^zdm("jsQueryRecDetail",2)=sql
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q ""
	s count = 0
	s resultString = ""
	s json = ##class(Code.JsonObj).%New()
	s end=Start+Limit
	s totalqty=0
    s totalrpamt=0
    s totalspamt=0
    s endflag="1"
	While(result.Next())
	{
		s IngrNo = result.Data("IngrNo")
		//CONTINUE:(ImpNO'="")&&(IngrNo [ ImpNO)
		i ImpNO'="" continue:IngrNo'[ImpNO
		s VendorRowid=result.Data("VendorId")
		s Vendor = result.Data("Vendor")
		s IngrDate=result.Data("IngrDate")
		s:IngrDate'="" IngrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(IngrDate,"ST")
		s IngrCreateDate=result.Data("IngrCreateDate")
		s:IngrCreateDate'="" IngrCreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(IngrCreateDate,"ST")
		s Ingri = result.Data("Rowid")
		s Incid=result.Data("Incid")
		s InciDesc = result.Data("InciDesc")
		s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Incid) ;规格		
		s grlocdr=result.Data("grlocdr")
        CONTINUE:(grlocdr'=LocId)
		s Dhcingr=+Ingri
 		s Dhcingri=$p(Ingri,"||",2)
 		CONTINUE:'$d(^DHCINGR(Dhcingr))
 		CONTINUE:'$d(^DHCINGR(Dhcingr,"GRI",Dhcingri))
 		s Inclb=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",1)
 		CONTINUE:(InciRowid'="")&(InciRowid'=Incid)			;库存项不符
 		CONTINUE:'$d(^INCI(Incid,1))
 		CONTINUE:'$d(^INCI(Incid,2))
 		CONTINUE:'$d(^INCI(Incid,3))
 		s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Incid)
 		s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 		CONTINUE:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
 		s StkGrpDesc=$p(tmpstkgrp,"^",2)
 		s TmpIncCatId=$p(^INCI(Incid,2),"^",2)
 		CONTINUE:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
 		s incscdesc=""
 		s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
 		s spType=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionSpType(Incid)
 		s MarkType2=""
 		i MarkType'="" s MarkType2=$p(^DHCINMT(MarkType),"^",2)
 		CONTINUE:(MarkType2'="")&(spType'=MarkType2)			;定价类型
 		s TmpImpFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmImportFlag(Incid)
 		CONTINUE:(ImpFlag'="")&(TmpImpFlag'=ImpFlag)
 		s StrPhcCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcCat(Incid)
 		s TmpPhcCatId=$p(StrPhcCat,"^",2)
 		s TmpPhcCatDesc=$p(StrPhcCat,"^",1)
 		CONTINUE:(PhcCatId'="")&(TmpPhcCatId'=PhcCatId)				;药学大类
 		s StrPhcSubCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcSubCat(Incid)
 		s TmpPhcSubCatId=$p(StrPhcSubCat,"^",2)
 		s TmpPhcSubCatDesc=$p(StrPhcSubCat,"^",1)
 		CONTINUE:(PhcSubCatId'="")&(TmpPhcSubCatId'=PhcSubCatId)			;药学子类
 		s StrPhcMinCat=##class(web.DHCST.Common.DrugInfoCommon).GetPhcMinCat(Incid)
 		s TmpPhcMinCatId=$p(StrPhcMinCat,"^",2)
 		s TmpPhcMinCatDesc=$p(StrPhcMinCat,"^",1)
 		CONTINUE:(PhcMinCatId'="")&(TmpPhcMinCatId'=PhcMinCatId)
 		s gmanfid=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",29)
 		CONTINUE:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 		s Manf=""
 		s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2) 
 		s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Incid)
 		s TmpFormDesc=$p(FormStr,"^",2)
 		CONTINUE:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 		s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(Incid)
 		s ofcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId)
 		//s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(Incid)
 		//CONTINUE:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
 		CONTINUE:(VendorId'="")&(VendorRowid'=VendorId)				;按供应商过滤
 		s tmpimpsort=$p(^DHCINGR(Dhcingr),"^",23)
 		CONTINUE:(ImpType'="")&(tmpimpsort'=ImpType)			;按入库类型过滤
 		s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(Incid)
 		CONTINUE:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 		i TmpPbFlag="1" s TmpPbFlag="招标"
 		i TmpPbFlag="0" s TmpPbFlag="非招标"
 		s TmpPbLevelDr=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(Incid)
 		CONTINUE:(PbLevel'="")&(TmpPbLevelDr'=PbLevel) 		;招标级别
 		i TmpPbLevelDr="" s TmpPbLevel=""
 		e  s TmpPbLevel=$p(^DHCITMPBL(TmpPbLevelDr),"^",2)
 		s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(Incid) ;备案
 		s:TmpBaFlag="Y" TmpBaFlag=1
 		s:TmpBaFlag="N" TmpBaFlag=0
 		s PhaCatAllDesc=""
	    s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(Incid)
	    s PhaCatAlls=$p(PhaCatAllstr,"^",1)
        s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	    s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	    CONTINUE:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
 		s sp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",32)      ;售价
 		s rp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",30)      ;进价
 		s newsp=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",45)
 		s qty=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",4)
 		s inuom=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",10)
 		s inuomdesc=""
 		s:inuom'="" inuomdesc=$p(^CT("UOM",inuom),"^",2)
 		s buom=$p(^INCI(Incid,1),"^",10)
 		s puruom=$p(^INCI(Incid,3),"^",6)
 		s buomdesc=$p(^CT("UOM",buom),"^",2)
 		i puruom="" s puruom=buom,puruomdesc=buomdesc
 		e  s puruomdesc=$p(^CT("UOM",puruom),"^",2)
 		s bfac=##class(web.DHCST.Common.UtilCommon).UOMFac(inuom,buom) ; factor 
 		s pfac=##class(web.DHCST.Common.UtilCommon).UOMFac(puruom,buom)
 		s pqty=(qty*bfac)/pfac
 		s psp=(sp*pfac)/bfac
 		s prp=(rp*pfac)/bfac
 		s pnewsp=(newsp*pfac)/bfac
 		CONTINUE:(SpFrom'="")&(psp<+SpFrom)      ;低于售价范围最小值
 		CONTINUE:(SpTo'="")&(psp>+SpTo)
 		CONTINUE:(RpFrom'="")&(prp<+RpFrom)
 		CONTINUE:(RpTo'="")&(prp>+RpTo)
 		CONTINUE:(SpFlag="1")&(newsp=sp)	;批次售价和售价不等的checkbox勾上 090701
 		s invno=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",27)
 		CONTINUE:(InvNo'="")&(invno'=InvNo)				;按发票号过滤 090623
 		s ExpireDate=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",9)
 		s:ExpireDate'="" ExpireDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpireDate,"ST")
 		s TmpBatNo=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",13)
 		CONTINUE:(BatNo'="")&(TmpBatNo'=BatNo)
		s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(Incid)
		s TmpPoisonId=$p(TmpPoison,"^",1)
		CONTINUE:(PoisonCat'="")&(TmpPoisonId'=PoisonCat)
		s incicode=$p(^INCI(Incid,1),"^",1)
 		//s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(LocId,Incid)
 		//s stkbin=$p(stkbin,"^",1)
 		//取新科室货位表过滤货位 add wyx 2013-11-21 //改为取新的科室货位表DHCIncItmLocBin（可多货位）
        s stkbinstr=""
        s incilsub=""
        s incilsub=$o(^INCI("IL_LOC",LocId,Incid,""))
        i incilsub'="" d 
        .s incil=Incid_"||"_incilsub
        .s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
        .s stkbinstr=$p(stkbinret,":",2)
 		s stkbin=stkbinstr
 		;
 		s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGenericByInci(Incid) 
 		s PhcgeDesc=$p(phcge,"^",2)
 		s zbbsdesc=""
 		s invdate=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",34)
 		s:invdate'="" invdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invdate,"ST")
		s rpcosts=+$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",31)
 		s spcosts=+$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",50) //$g(qty)*$g(sp)
 		s pprice=+$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",35)
 		s ppcosts=qty*pprice
 		s pprice=(pprice*pfac)/bfac
 		s newspcosts=$p(^DHCINGR(Dhcingr,"GRI",Dhcingri),"^",46)
 		//s rpcosts=$fn(rpcosts,"",2) //yunhaibao20160602,直接取业务金额,不允许这样约
 		//s ppcosts=$fn(ppcosts,"",2)
 		//s spcosts=$fn(spcosts,"",2)
 		//s newspcosts=$fn(newspcosts,"",2)
 		s cpcosts=spcosts-rpcosts
 		s newcpcosts=newspcosts-rpcosts
 		i +Inclb'=0  d
 		.s Status="已审核"
 		e  d
 		.s Status="未审核"
 		;
		s Data1=IngrNo_"^"_invno_"^"_IngrCreateDate_"^"_incicode_"^"_InciDesc_"^"_$g(puruomdesc)_"^"_..AddZero(pqty)
		s Data2=..AddZero(prp)_"^"_..AddZero(rpcosts)_"^"_..AddZero(psp)_"^"_..AddZero(spcosts)_"^"_Vendor_"^"_TmpBatNo_"^"_ExpireDate_"^"_$g(Manf)
		s Data3=stkbin_"^"_invdate_"^"_spType_"^"_TmpPbFlag_"^"_TmpPbLevel_"^"_ofcode_"^"_Status_"^"_IngrDate_"^"_Spec 
		s Data=Data1_"^"_Data2_"^"_Data3
		s count = count+1	
		CONTINUE:count<(Start+1)
		CONTINUE:count>end	
		s totalqty=totalqty+pqty
		s totalrpamt=totalrpamt+rpcosts
		s totalspamt=totalspamt+spcosts
		d json.InsertRowData(Data)
		
		i count=end d
		.s endflag="0"
		.s Data1="合计:"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_totalqty
		.s Data2=""_"^"_..AddZero(totalrpamt)_"^"_""_"^"_..AddZero(totalspamt)_"^"_""_"^"_""_"^"_""_"^"_""
		.s Data3=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"" 
		.s Data=Data1_"^"_Data2_"^"_Data3
		.d json.InsertRowData(Data)
	}
    i endflag="1" d
	.s Data1="合计:"_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_totalqty
	.s Data2=""_"^"_totalrpamt_"^"_""_"^"_totalspamt_"^"_""_"^"_""_"^"_""_"^"_""
	.s Data3=""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"" 
	.s Data=Data1_"^"_Data2_"^"_Data3
	.d json.InsertRowData(Data)
	s count=count+1
 	s Title1="IngrNo^InvNo^IngrCreateDate^InciCode^InciDesc^PurUom^Qty^Rp^RpAmt^Sp^SpAmt^Vendor"
 	s Title2="BatNo^ExpDate^Manf^StkBin^InvDate^SpType^PbFlag^PbLevel^InsuType^Status^IngrDate^Spec"
 	s Title=Title1_"^"_Title2
 	s resultString = json.getJsonData(Title,count)
 	k json
 	q resultString
}

ClassMethod GetManfHis(gmanfid, date) As %String
{
	q:gmanfid="" ""
	s manfhisname=$p(^PHMNF(gmanfid),"^",2)
	s stdate=""
    f  s stdate=$o(^DHCMANFH(0,"SDManf",gmanfid,stdate)) q:stdate=""  d
    .s hisid=""
    .f  s hisid=$o(^DHCMANFH(0,"SDManf",gmanfid,stdate,hisid)) q:hisid=""  d
    ..s manfstdate=$p(^DHCMANFH(hisid),"^",2)
    ..s manfenddate=$p(^DHCMANFH(hisid),"^",3) 
    ..i (manfstdate<=date)&&(date<=manfenddate) d
    ...s manfhisname=$p(^DHCMANFH(hisid),"^",5)
    q manfhisname
}

/// 补零 2020-02-11 yangsj  没考虑负数
ClassMethod AddZero(num)
{
	s tmpNum=num
	q:tmpNum'=num num
	q:$P(num,".",1)'="" num
	q "0"_num
}

}
