Import sqluser

/// Descript:入库汇总
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-13
Class web.DHCST.InStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询入库明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-13
/// Table:DHC_InGdRec,DHC_InGdRecItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志
/// Output:入库明细
/// Return：	
ClassMethod GetImportDetail(StartDate, EndDate, LocId, Others) As %Library.String
{

	n (StartDate, EndDate, LocId, Others)
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
	s i=0
	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","G",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s dhcingr=+pointer
 	..s dhcingri=$p(pointer,"||",2)
 	..q:'$d(^DHCINGR(dhcingr))
 	..q:'$d(^DHCINGR(dhcingr,"GRI",dhcingri))
 	..
 	..s RecLocId=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",3)
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
 	..
 	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
 	..s spType=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionSpType(inciid)
 	..q:(MarkType'="")&(spType'=MarkType)			;定价类型
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
 	..s gmanfid=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",29)
 	..q:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 	..s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2) 
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..
 	..s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
 	..
 	..s apcvmid=$p(^DHCINGR(dhcingr),"^",3)
 	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)
 	..
 	..s tmpimpsort=$p(^DHCINGR(dhcingr),"^",23)
 	..q:(ImpType'="")&(tmpimpsort'=ImpType)			;按入库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	..
 	..s TmpPbLevel=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevel'=PbLevel) 		;招标级别
 	..
 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag=1
 	..s:TmpBaFlag="N" TmpBaFlag=0
 	..s sp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",32)      ;售价
 	..s rp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",30)      ;进价
 	..s newsp=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",45)
 	..s qty=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",4)
 	..s inuom=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",10)
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
 	..q:(SpFrom'="")&(psp<+SpFrom)      ;低于售价范围最小值
 	..q:(SpTo'="")&(psp>+SpTo)
 	..
 	..q:(RpFrom'="")&(prp<+RpFrom)
 	..q:(RpTo'="")&(prp>+RpTo)
 	..
 	..q:(SpFlag="1")&(newsp=sp)	;批次售价和售价不等的checkbox勾上 090701
 	..
 	..s invno=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",27)
 	..q:(InvNo'="")&(invno'=InvNo)				;按发票号过滤 090623
 	..
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inciid)
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&(TmpPoison'=PoisonCat)
	..
 	..s ingrno=$p(^DHCINGR(dhcingr),"^",1) 
	..s incicode=$p(^INCI(inciid,1),"^",1)
 	..s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(RecLocId,inciid)
 	..
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..s zbbsdesc=""
 	..s ingrdate=date 
 	..s invdate=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",34)
 	..s:invdate'="" invdate=$zd(invdate,3)
	..s rpcosts=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",31)
 	..s spcosts=$g(qty)*$g(sp)
 	..s pprice=+$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",35)
 	..s ppcosts=qty*pprice
 	..s pprice=(pprice*pfac)/bfac
 	..s newspcosts=$p(^DHCINGR(dhcingr,"GRI",dhcingri),"^",46)
 	..s rpcosts=$fn(rpcosts,"",2)
 	..s ppcosts=$fn(ppcosts,"",2)
 	..s spcosts=$fn(spcosts,"",2)
 	..s newspcosts=$fn(newspcosts,"",2)
 	..s cpcosts=spcosts-rpcosts
 	..s newcpcosts=newspcosts-rpcosts
 	..
 	..s i=i+1
 	..;b  ;3
 	..;
 	..s ^TMPDHCINSTAT(pid,"INDETAIL",i)=ingrno_"^"_invno_"^"_$zd($g(ingrdate),3)_"^"_incicode_"^"_incidesc_"^"_$g(puruomdesc)_"^"_pqty_"^"_prp_"^"_rpcosts_"^"_psp_"^"_spcosts_"^"_$g(VenName)_"^"_$g(TmpBatNo)_"^"_$g(ExpireDate)_"^"_$g(Manf)_"^"_$g(stkbin)_"^"_pprice_"^"_ppcosts_"^"_invdate_"^"_pnewsp_"^"_newspcosts_"^"_spType_"^"_$g(TmpPbFlag)_"^"_PbLevel_"^"_$g(ofcode)_"^"_TmpBaFlag
 	.
 	q pid
}

/// Descript:	查询退货明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-16
/// Table:DHC_InGdRet,DHC_InGRtItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^入库类型^最低售价^最高售价^最低进价^最高进价^发票号
/// ^批次售价不等于售价标志
/// Output:入库明细
/// Return：	
ClassMethod GetReturnDetail(StartDate, EndDate, LocId, Others) As %Library.String
{
	n (StartDate, EndDate, LocId, Others)
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
	;
	s i=0
 	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","R",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s ingrtid=$p(pointer,"||",1)
 	..s retch=$p(pointer,"||",2)
 	..q:'$d(^INGRT(ingrtid))
 	..q:'$d(^INGRT(ingrtid,"DHCGRR",retch))
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
 	..s:TmpIncCatId'="" incscdesc=$p(^INC("SC",TmpIncCatId),"^",2)
 	..s spType=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionSpType(inciid)
 	..q:(MarkType'="")&(spType'=MarkType)			;定价类型
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
 	..s:gmanfid'="" Manf=$p(^PHMNF(gmanfid),"^",2) 
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..
 	..s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
	..s apcvmid=$p(^INGRT(ingrtid),"^",2)
	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
 	..s:apcvmid'="" VenName=$p(^APC("APCVM",apcvmid),"^",3)
 	..s tmpimpsort=$p(^DHCINGR(dhcingri),"^",23)
 	..q:(ImpType'="")&(tmpimpsort'=ImpType)			;按入库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	..
 	..s TmpPbLevel=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevel'=PbLevel) 		;招标级别
 	..
 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag=1
 	..s:TmpBaFlag="N" TmpBaFlag=0
 	..
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
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inciid)
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&(TmpPoison'=PoisonCat)
	..
 	..s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(RetLocId,inciid)
 	..
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..
	..s retno=$p(retstr,"^",1)
 	..s tmpno=retno
 	..s retdate=$zd(date,3) ;$p(retstr,"^",3)
 	..s retinvno=$p(retistr,"^",12)
 	..s retinvdate=$p(retistr,"^",14)
 	..i retinvdate'="" s retinvdate=$zd(retinvdate,3)
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
 	..
 	..s i=i+1
 	..s ^TMPDHCINSTAT(pid,"INDETAIL",i)=retno_"^"_retinvno_"^"_retdate_"^"_incicode_"^"_incidesc_"^"_puruomdesc_"^"_pretqty_"^"_pretrp_"^"_retrpamt_"^"_pretsp_"^"_retspamt_"^"_$g(VenName)_"^"_$g(TmpBatNo)_"^"_$g(ExpireDate)_"^"_$g(Manf)_"^"_$g(stkbin)_"^"_$g(pretpp)_"^"_$g(retppamt)_"^"_retinvdate_"^"_pretbatsp_"^"_retbatspamt_"^"_spType_"^"_$g(TmpPbFlag)_"^"_TmpPbLevel_"^"_$g(ofcode)_"^"_TmpBaFlag
 	.
	q pid
}

ClassMethod NewPid() As %String
{
  q $I(^CHSSPID("ImportStat"))
}

Query QueryDetail(StartDate As %String, EndDate As %String, LocId As %String, RetFlag As %String, Others As %String) As %Query(ROWSPEC = "No:%String,InvNo:%String,Date:%String,InciCode:%String,InciDesc:%String,UomDesc:%String,Qty:%Float,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,Vendor:%String,BatNo:%String,Expire:%String,Manf:%String,StkBin:%String,InvDate:%String,SpType:%String,PbFlag:%String,PbLevel:%String,OfficeCode:%String,Type:%String")
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocId As %String, RetFlag As %String, Others As %String) As %Status
{
	n (qHandle,StartDate,EndDate,LocId,RetFlag,Others)
	//s ^zdm("QueryDetail")=StartDate_","_EndDate_","_LocId_","_RetFlag_","_Others
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	;
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""							
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	s qPid=""
	//统计入库
	s qPid=..GetImportDetail(StartDate,EndDate,LocId,Others)
	i qPid'="" d
	.d OutputRowImp
	.
	s qPid=""
	i RetFlag=1  d
	.//统计退货
	.s qPid=..GetReturnDetail(StartDate,EndDate,LocId,Others) 
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
	.i $f(InciDesc,"-") d
	..s InciDesc=$p(InciDesc,"-",2)
	.s RecUomDesc=$p(data,"^",6)
	.s RecQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.i $f(Vendor,"-") d
	..s Vendor=$p(Vendor,"-",2)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.i $f(Manf,"-") d
	..s Manf=$p(Manf,"-",2)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s Type="G"
	.s Data=$lb(IngrNo,InvNo,IngrDate,InciCode,InciDesc,RecUomDesc,RecQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type)
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
	.i $f(InciDesc,"-") d
	..s InciDesc=$p(InciDesc,"-",2)
	.s RetUomDesc=$p(data,"^",6)
	.s RetQty=$p(data,"^",7)
	.s Rp=$p(data,"^",8)
	.s RpAmt=$p(data,"^",9)
	.s Sp=$p(data,"^",10)
	.s SpAmt=$p(data,"^",11)
	.s Vendor=$p(data,"^",12)
	.i $f(Vendor,"-") d
	..s Vendor=$p(Vendor,"-",2)
	.s BatNo=$p(data,"^",13)
	.s Expire=$p(data,"^",14)
	.s Manf=$p(data,"^",15)
	.i $f(Manf,"-") d
	..s Manf=$p(Manf,"-",2)
	.s StkBin=$p(data,"^",16)
	.s InvDate=$p(data,"^",19)
	.s SpType=$p(data,"^",22)
	.s PbFlag=$p(data,"^",23)
	.s PbLevel=$p(data,"^",24)
	.s OfficeCode=$p(data,"^",25)
	.s Type="R"
	.s Data=$lb(RetNo,InvNo,IngdDate,InciCode,InciDesc,RetUomDesc,RetQty,Rp,RpAmt,Sp,SpAmt,Vendor,BatNo,Expire,Manf,StkBin,InvDate,SpType,PbFlag,PbLevel,OfficeCode,Type)
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

}
