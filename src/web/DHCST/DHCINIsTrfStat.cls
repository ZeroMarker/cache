/// Descript:出库汇总相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-12
Class web.DHCST.DHCINIsTrfStat Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// w ##class(%ResultSet).RunQuery("web.DHCST.DHCINIsTrfStat","QueryDetail","2020-07-06","2020-08-05",165,2,"3^^^^^^^^^^^^^^^^^^^^^^")
Query QueryDetail(StartDate As %String = "", EndDate As %String = "", LocId As %String, TransferFlag As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Query(ROWSPEC = "TrNo:%String,TrDate:%String,InciCode:%String,InciDesc:%String,PurUomDesc:%String,RecLocDesc:%String,Rp:%Float,Sp:%Float,BatSp:%Float,BatNo:%String,ExpireDate:%String,Manf:%String,StkBin:%String,InsuType:%String,TrQty:%Float,RpAmt:%Float,SpAmt:%Float,BatSpAmt:%Float,RecLocGrp:%String,StkCat:%String,StkGrp:%String,Type:%String,Incib:%String,TmpPbLevel:%String,spType:%String,TmpBaFlag:%String,TmpPbFlag:%String,InsuCode,InsuDesc") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", LocId As %String = "", TransferFlag As %String = "", Others As %String = "", StartTime As %String = "", EndTime As %String = "") As %Status
{
	n (qHandle,StartDate,EndDate,LocId,TransferFlag,Others,StartTime,EndTime)
	s Others=$g(Others)
	//s ^YSJTMP("QueryDetail")=$LB(StartDate,EndDate,LocId,TransferFlag,Others,StartTime,EndTime)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	;
	q:StartDate="" ""			//必选条件
	q:EndDate="" ""
	q:LocId="" ""	
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)						
	s qPid=""
	i StartTime[":" s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
    i EndTime[":" s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	//只统计转出
	i TransferFlag=1  d
	.s qPid=..GetTransferOutDetail(StartDate,EndDate,LocId,Others,StartTime, EndTime)
	.i qPid'=""  d OutputRowOut
	.
	
	i (TransferFlag=2)||(TransferFlag=3)  d  //只统计转入
	.s qPid=..GetTransferInDetail(StartDate,EndDate,LocId,Others,StartTime, EndTime,TransferFlag)
	.i qPid'=""  d OutputRowIn
	
	i TransferFlag'=1,TransferFlag'=2,TransferFlag'=3  d     //统计转出转入
	.s qPid=..GetTransferOutDetail(StartDate,EndDate,LocId,Others,StartTime, EndTime)
	.i qPid'=""  d OutputRowOut
	.s qPid=..GetTransferInDetail(StartDate,EndDate,LocId,Others,StartTime, EndTime)
	.i qPid'="" d OutputRowIn
	.
	;
	Quit $$$OK

OutputRowOut   
	s num=0
	f  s num=$o(^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num))  q:num=""  d
	.s data=^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num)
	.s TrNo=$p(data,"^",1)
	.s TrDate=$p(data,"^",2)
	.s InciCode=$p(data,"^",3)
	.s InciDesc=$p(data,"^",4)
	.s PurUomDesc=$p(data,"^",5)
	.s LocDesc=$p(data,"^",6)
	.s Rp=$p(data,"^",7)
	.s Sp=$p(data,"^",8)
	.s BatSp=$p(data,"^",9)
	.s BatNo=$p(data,"^",10)
	.s ExpireDate=$p(data,"^",11)
	.s Manf=$p(data,"^",12)
	.s StkBin=$p(data,"^",13)
	.s InsuType=$p(data,"^",14)
	.s TrQty=$p(data,"^",15)
	.s RpAmt=$p(data,"^",16)
	.s SpAmt=$p(data,"^",17)
	.s BatSpAmt=$p(data,"^",18)
	.s LocGrp=$p(data,"^",19)
	.s StkCat=$p(data,"^",20)
	.s StkGrp=$p(data,"^",21)
	.s Type=$p(data,"^",22)
	.s Incib=$p(data,"^",23)
	.s TmpPbLevel=$p(data,"^",24)
	.s spType=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s TmpPbFlag=$p(data,"^",27)
	.s InsuCode = $p(data,"^",28)
	.s InsuDesc = $p(data,"^",29)
	.s Data=$lb(TrNo,TrDate,InciCode,InciDesc,PurUomDesc,LocDesc,Rp,Sp,BatSp,BatNo,ExpireDate,Manf,StkBin,InsuType,TrQty,RpAmt,SpAmt,BatSpAmt,LocGrp,StkCat,StkGrp,Type,Incib,TmpPbLevel,spType,TmpBaFlag,TmpPbFlag,InsuCode,InsuDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	.
	k ^TMPDHCOUTSTAT(qPid,"OUTDETAIL")
	q
	
OutputRowIn   
	s num=0
	f  s num=$o(^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num))  q:num=""  d
	.s data=^TMPDHCOUTSTAT(qPid,"OUTDETAIL",num)
	.s TrNo=$p(data,"^",1)
	.s TrDate=$p(data,"^",2)
	.s InciCode=$p(data,"^",3)
	.s InciDesc=$p(data,"^",4)
	.s PurUomDesc=$p(data,"^",5)
	.s LocDesc=$p(data,"^",6)
	.s Rp=$p(data,"^",7)
	.s Sp=$p(data,"^",8)
	.s BatSp=$p(data,"^",9)
	.s BatNo=$p(data,"^",10)
	.s ExpireDate=$p(data,"^",11)
	.s Manf=$p(data,"^",12)
	.s StkBin=$p(data,"^",13)
	.s InsuType=$p(data,"^",14)
	.s TrQty=-$p(data,"^",15)   ;只统计转入的时候转入按正数显示
	.s RpAmt=-$p(data,"^",16)
	.s SpAmt=-$p(data,"^",17)
	.s BatSpAmt=-$p(data,"^",18)
	.s LocGrp=$p(data,"^",19)
	.s StkCat=$p(data,"^",20)
	.s StkGrp=$p(data,"^",21)
	.s Type=$p(data,"^",22)
	.s Incib=$p(data,"^",23)
	.s TmpPbLevel=$p(data,"^",24)
	.s spType=$p(data,"^",25)
	.s TmpBaFlag=$p(data,"^",26)
	.s TmpPbFlag=$p(data,"^",27)
	.s InsuCode = $p(data,"^",28)
	.s InsuDesc = $p(data,"^",29)
	.s Data=$lb(TrNo,TrDate,InciCode,InciDesc,PurUomDesc,LocDesc,Rp,Sp,BatSp,BatNo,ExpireDate,Manf,StkBin,InsuType,TrQty,RpAmt,SpAmt,BatSpAmt,LocGrp,StkCat,StkGrp,Type,Incib,TmpPbLevel,spType,TmpBaFlag,TmpPbFlag,InsuCode, InsuDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	.
	k ^TMPDHCOUTSTAT(qPid,"OUTDETAIL")
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

/// Descript:	查询转出明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-12
/// Table:DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^出库类型^最低售价^最高售价^最低进价^最高进价^接收科室id
/// Output:转移明细
/// Return：	
ClassMethod GetTransferOutDetail(StartDate, EndDate, LocId, Others, StartTime, EndTime) As %Library.String
{

	n (StartDate, EndDate, LocId,Others,StartTime, EndTime)
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocId="" ""
	;
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
	s OutType=$p(Others,"^",17)
	s SpFrom=$p(Others,"^",18)
	s SpTo=$p(Others,"^",19)
	s RpFrom=$p(Others,"^",20)
	s RpTo=$p(Others,"^",21)
	s RecLocId=$p(Others,"^",22)
	s PhcCatAll=$p(Others,"^",23)
	s HospId=$p(^CTLOC(LocId),"^",22)
	;
	s i=0
	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","T",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..
 	..s trTime=$p(^DHCINTR(intrid),"^",3)
 	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
    ..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s MainId=+pointer
 	..s Chl=$p(pointer,"||",2)
 	..q:'$d(^DHCINIT(MainId))
 	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
 	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
 	..q:FromLocId'=LocId   ;非统计科室
 	..
 	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;接收科室
 	..q:(RecLocId'="")&(ToLocId'=RecLocId)   ;非接收科室
 	..s:ToLocId'="" ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
 	..
 	..s inclbid=$p(^DHCINTR(intrid),"^",7)
 	..q:inclbid=""
 	..;b ;2
 	..s inciid=$p(inclbid,"||",1)
 	..q:(InciRowid'="")&(InciRowid'=inciid)			;库存项不符
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..s incicode=$p(^INCI(inciid,1),"^",1)
 	..s incidesc=$p(^INCI(inciid,1),"^",2) 
 	..s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
 	..
 	..s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
 	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	..q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
 	..s StkType=$p(tmpstkgrp,"^",3)
 	..q:StkType'=..sssCode()
 	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
 	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
 	..q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
 	..
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
 	..
 	..s manfinfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
 	..s gmanfid=$p(manfinfo,"^",1)
 	..s Manf=$p(manfinfo,"^",2)
 	..q:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 	..
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..
 	..s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
	..s ofcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId) //医保类别
 	..//s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..//q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
 	..;b ;2
 	..s VenInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclbid,date)
 	..s apcvmid=$p(VenInfo,"^",1)
 	..s VenName=$p(VenInfo,"^",2)
 	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
 	..
 	..s tmpouttype=$p(^DHCINIT(MainId),"^",20)
 	..q:(OutType'="")&(tmpouttype'=OutType)			;按出库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	..
 	..s TmpPbLevel=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevel'=PbLevel) 		;招标级别
    ..i TmpPbLevel'="" s TmpPbLevel=$p($g(^DHCITMPBL(TmpPbLevel)),"^",2) 
 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag="是"
 	..s:TmpBaFlag="N" TmpBaFlag="否"
	..s PhaCatAllDesc=""
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inciid)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	..//q:(PhcCatAll'="")&(PhaCatAlls'=PhcCatAll) //add wyx 2014-12-08 药学多级分类
 	..s TrUom=$p(^DHCINIT(MainId,"ITI",Chl),"^",7)
 	..s sp=$p(^DHCINIT(MainId,"ITI",Chl),"^",17)      ;售价
 	..s rp=$p(^DHCINIT(MainId,"ITI",Chl),"^",15)      ;进价
 	..s BatSp=$p(^DHCINIT(MainId,"ITI",Chl),"^",21)      ;批次售价
 	..s BUomId=$p(^INCI(inciid,1),"^",10)
 	..s PurUomId=$p(^INCI(inciid,3),"^",6)
 	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
 	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(TrUom,BUomId)
 	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
 	..s sp=sp/Fac1*Fac2
 	..s rp=rp/Fac1*Fac2
 	..s BatSp=BatSp/Fac1*Fac2
 	..;b ;3
 	..q:(SpFrom'="")&(sp<+SpFrom)      ;低于售价范围最小值
 	..q:(SpTo'="")&(sp>+SpTo)
 	..
 	..q:(RpFrom'="")&(rp<+RpFrom)
 	..q:(RpTo'="")&(rp>+RpTo)
 	..
 	..
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inclbid)
 	..
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&($p(TmpPoison,"^",1)'=PoisonCat)
	..
 	..s TrNo=$p(^DHCINIT(MainId),"^",1)
	..s TrQty=$p(^DHCINIT(MainId,"ITI",Chl),"^",1)
	..s TrQty=TrQty*Fac1/Fac2
	..s RpAmt=$p(^DHCINIT(MainId,"ITI",Chl),"^",16)
	..s SpAmt=$p(^DHCINIT(MainId,"ITI",Chl),"^",18)
	..s BatSpAmt=$p(^DHCINIT(MainId,"ITI",Chl),"^",22)
	..
 	..//s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(FromLocId,inciid)
 	..//s stkbin=$p(stkbin,"^",1)
 	..s incil=$p(inclbid,"||",1,2)
 	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    ..s stkbinstr=$p(stkbinret,":",2)
    ..s stkbin=stkbinstr  //货位
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..
 	..s zbbsdesc=""
 	..s TrDate=date
 	..s TrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TrDate,"ST")
 	..s ToLocGrp=##class(web.DHCST.Common.UtilCommon).GetLocGrpItm(ToLocId)
 	..s:ToLocGrp="" ToLocGrp="不详"
 	..s TrType="T"
 	..s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inciid, HospId)
 	..s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inciid, HospId)
 	..s i=i+1
 	..;b  ;3
 	..;
 	..s ^TMPDHCOUTSTAT(pid,"OUTDETAIL",i)=TrNo_"^"_TrDate_"^"_incicode_"^"_incidesc_"^"_$g(PurUomDesc)_"^"_$g(ToLocDesc)_"^"_rp_"^"_sp_"^"_BatSp_"^"_TmpBatNo_"^"_ExpireDate_"^"_Manf_"^"_stkbin_"^"_ofcode_"^"_TrQty_"^"_RpAmt_"^"_SpAmt_"^"_BatSpAmt_"^"_ToLocGrp_"^"_$g(incscdesc)_"^"_StkGrpDesc_"^"_TrType_"^"_incib_"^"_TmpPbLevel_"^"_spType_"^"_TmpBaFlag_"^"_TmpPbFlag_"^"_InsuCode_"^"_InsuDesc
 	.
 	q pid
}

/// Descript:	查询转入明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2012-11-12
/// Table:DHC_InTrans,DHC_InIsTrf,DHC_InIsTrfItm
/// Input:开始日期，截止日期,统计科室id,
/// 类组id^库存分类id^库存项id^定价类型^进口标志^生产批号^是否招标^
/// 招标级别^药学大类id^药学子类id^药学更小分类id^生产厂商id^剂型^医保类型^
/// 管制分类^供应商id^出库类型^最低售价^最高售价^最低进价^最高进价^接收科室id
/// Output:转移明细
/// Return：	
ClassMethod GetTransferInDetail(StartDate, EndDate, LocId, Others, StartTime, EndTime, TransferFlag = "") As %Library.String
{
	n (StartDate, EndDate, LocId,Others,StartTime, EndTime,TransferFlag)
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocId="" ""
	;
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
	s OutType=$p(Others,"^",17)
	s SpFrom=$p(Others,"^",18)
	s SpTo=$p(Others,"^",19)
	s RpFrom=$p(Others,"^",20)
	s RpTo=$p(Others,"^",21)
	s RecLocId=$p(Others,"^",22)
	s PhcCatAll=$p(Others,"^",23)
	s HospId=$p(^CTLOC(LocId),"^",22)
	s i=0
	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","K",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..
 	..s trTime=$p(^DHCINTR(intrid),"^",3)
 	..i date=StartDate q:(trTime<StartTime)&&(StartTime'="")
    ..i date=EndDate q:(trTime>EndTime)&&(EndTime'="")
 	..
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s MainId=+pointer
 	..s status=$P(^DHCINIT(MainId),"^",14)
 	..q:(TransferFlag=3)&&(status'=30)&&(status'=40)
 	..s Chl=$p(pointer,"||",2)
 	..q:'$d(^DHCINIT(MainId))
 	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
 	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
 	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;转入科室
 	..i (status=30)||(status=40) d  ///如果是拒绝接收状态，则出库科室和接收科室相反
 	...s ToLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室
 	...s FromLocId=$p(^DHCINIT(MainId),"^",6)   ;转入科室
 	..q:(RecLocId'="")&(FromLocId'=RecLocId)   ;非指定科室转入到本科室的
 	..s:FromLocId'="" FromLocDesc=$p(^CTLOC(FromLocId),"^",2)
 	..
 	..q:ToLocId'=LocId   ;非统计科室
 	..
 	..s inclbid=$p(^DHCINTR(intrid),"^",7)
 	..q:inclbid=""
 	..
 	..s inciid=$p(inclbid,"||",1)
 	..q:(InciRowid'="")&(InciRowid'=inciid)			;库存项不符
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..s incicode=$p(^INCI(inciid,1),"^",1)
 	..s incidesc=$p(^INCI(inciid,1),"^",2) 
 	..s incib=$p(^INCI(+inclbid,"IL",$p(inclbid,"||",2),"LB",$p(inclbid,"||",3)),"^",1)
 	..
 	..s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inciid)
 	..s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	..q:(StkGrpId'="")&(TmpStkGrpId'=StkGrpId)   ;类组不符
 	..s StkType=$p(tmpstkgrp,"^",3)
 	..q:StkType'=..sssCode()
 	..s StkGrpDesc=$p(tmpstkgrp,"^",2)
 	..s TmpIncCatId=$p(^INCI(inciid,2),"^",2)
 	..q:(StkCatId'="")&(StkCatId'=TmpIncCatId)		;库存分类不符
 	..
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
 	..
 	..s manfinfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
 	..s gmanfid=$p(manfinfo,"^",1)
 	..s Manf=$p(manfinfo,"^",2)
 	..q:(ManfId'="")&(gmanfid'=ManfId)						;厂商
 	..
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s TmpFormDesc=$p(FormStr,"^",2)
 	..q:(FormDesc'="")&(TmpFormDesc'=FormDesc)       ;by form
 	..
 	..s arcim=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(inciid)
	..s ofcode=##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu(arcim,"",HospId) //医保类别
 	..//s ofcode=##class(web.DHCST.Common.DrugInfoCommon).GetOfficialCode(inciid)
 	..//q:(InsuType'="")&(ofcode'=InsuType)			;by 医保类型
 	..s VenInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclbid,date)
 	..s apcvmid=$p(VenInfo,"^",1)
 	..s VenName=$p(VenInfo,"^",2)
 	..q:(VendorId'="")&(apcvmid'=VendorId)				;按供应商过滤
 	..
 	..s tmpouttype=$p(^DHCINIT(MainId),"^",20)
 	..q:(OutType'="")&(tmpouttype'=OutType)			;按出库类型过滤
 	..
 	..s TmpPbFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmPbFlag(inciid)
 	..q:(PbFlag'="")&(TmpPbFlag'=PbFlag)			;是否招标
 	..i TmpPbFlag="1" s TmpPbFlag="招标"
 	..i TmpPbFlag="0" s TmpPbFlag="非招标"
 	..
 	..s TmpPbLevel=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionPbLevel(inciid)
 	..q:(PbLevel'="")&(TmpPbLevel'=PbLevel) 		;招标级别
 	..i TmpPbLevel'="" s TmpPbLevel=$p($g(^DHCITMPBL(TmpPbLevel)),"^",2) 
 	..s TmpBaFlag=##class(web.DHCST.Common.DrugInfoCommon).GetItmAddtionBAFlag(inciid) ;备案
 	..s:TmpBaFlag="Y" TmpBaFlag="是"
 	..s:TmpBaFlag="N" TmpBaFlag="否"
 	..
	..s PhaCatAllDesc=""
	..s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(inciid)
	..s PhaCatAlls=$p(PhaCatAllstr,"^",1)
	..s PhaCatAllDesc=$p(PhaCatAllstr,"^",2)
	..s retflag=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PhcCatAll,PhaCatAlls)
	..q:(PhcCatAll'="")&(retflag=0) //add wyx 2014-12-08 药学多级分类
	..//q:(PhcCatAll'="")&(PhaCatAlls'=PhcCatAll) //add wyx 2014-12-08 药学多级分类
	..
 	..s TrUom=$p(^DHCINIT(MainId,"ITI",Chl),"^",7)
 	..s sp=$p(^DHCINIT(MainId,"ITI",Chl),"^",17)      ;售价
 	..s rp=$p(^DHCINIT(MainId,"ITI",Chl),"^",15)      ;进价
 	..s BatSp=$p(^DHCINIT(MainId,"ITI",Chl),"^",21)      ;批次售价
 	..s BUomId=$p(^INCI(inciid,1),"^",10)
 	..s PurUomId=$p(^INCI(inciid,3),"^",6)
 	..s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
 	..s Fac1=##class(web.DHCST.Common.UtilCommon).UOMFac(TrUom,BUomId)
 	..s Fac2=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
 	..s sp=sp/Fac1*Fac2
 	..s rp=rp/Fac1*Fac2
 	..s BatSp=BatSp/Fac1*Fac2
 	..
 	..q:(SpFrom'="")&(sp<+SpFrom)      ;低于售价范围最小值
 	..q:(SpTo'="")&(sp>+SpTo)
 	..
 	..q:(RpFrom'="")&(rp<+RpFrom)
 	..q:(RpTo'="")&(rp>+RpTo)
 	..
 	..
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inclbid)
 	..
 	..s TmpBatNo=$p(TmpBat,"^",1)
 	..s ExpireDate=$p(TmpBat,"^",2)
 	..q:(BatNo'="")&(TmpBatNo'=BatNo)
 	..
	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..q:(PoisonCat'="")&($p(TmpPoison,"^",1)'=PoisonCat)
	..
 	..s TrNo=$p(^DHCINIT(MainId),"^",1)
	..s TrQty=$p(^DHCINIT(MainId,"ITI",Chl),"^",1)
	..s TrQty=TrQty*Fac1/Fac2
	..s TrQty=-TrQty
	..s RpAmt=-$p(^DHCINIT(MainId,"ITI",Chl),"^",16)
	..s SpAmt=-$p(^DHCINIT(MainId,"ITI",Chl),"^",18)
	..s BatSpAmt=-$p(^DHCINIT(MainId,"ITI",Chl),"^",22)
	..
 	..//s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(FromLocId,inciid)
 	..//s stkbin=$p(stkbin,"^",1)
 	..s incil=$p(inclbid,"||",1,2)
 	..s stkbinret=##class(web.DHCST.Common.DrugInfoCommon).GetInciBinStr(incil,",","","") 
    ..s stkbinstr=$p(stkbinret,":",2)
    ..s stkbin=stkbinstr  //货位
 	..s phcge=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inciid) 
 	..s PhcgeDesc=$p(phcge,"^",2)
 	..
 	..s zbbsdesc=""
 	..s TrDate=date
 	..s TrDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(TrDate,"ST")
 	..s FromLocGrp=##class(web.DHCST.Common.UtilCommon).GetLocGrpItm(FromLocId)
 	..s:FromLocGrp="" FromLocGrp="不详"
 	..s TrType="K"
 	..s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(inciid, HospId)
 	..s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(inciid, HospId)
 	..
 	..s i=i+1
 	..;b  ;3
 	..;
 	..s ^TMPDHCOUTSTAT(pid,"OUTDETAIL",i)=TrNo_"^"_TrDate_"^"_incicode_"^"_incidesc_"^"_$g(PurUomDesc)_"^"_$g(FromLocDesc)_"^"_rp_"^"_sp_"^"_BatSp_"^"_TmpBatNo_"^"_ExpireDate_"^"_Manf_"^"_stkbin_"^"_ofcode_"^"_TrQty_"^"_RpAmt_"^"_SpAmt_"^"_BatSpAmt_"^"_FromLocGrp_"^"_$g(incscdesc)_"^"_StkGrpDesc_"^"_TrType_"^"_incib_"^"_TmpPbLevel_"^"_spType_"^"_TmpBaFlag_"^"_TmpPbFlag_"^"_InsuCode_"^"_InsuDesc
 	.
 	q pid
}

ClassMethod NewPid() As %String
{
  q $I(^DHCSTPID("OutStat"))
}

}
