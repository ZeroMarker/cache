Import sqluser

/// 辅助库存转移(根据请求科室的库存上下限)
Class web.DHCSTMHUI.DHCINIsTrfAuxByLim Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	取根据请求科室的库存上下限自动生成的出库数据串
/// Creator:	wangjiabin
/// CreateDate:	2018-07-17
/// Input:		Params({FrLoc:库房,ToLoc:接收科室,ScgId:类组,IntFac:取整比例)
/// Output:  
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCINIsTrfAuxByLim","RecLocItmForTransfer","{""FrLoc"":""392"",""gUserId"":""4642"",""gLocId"":""392"",""gGroupId"":""264"",""gHospId"":""2"",""ScgId"":""1"",""ToLoc"":""6"",""IntFac"":""""}")
Query RecLocItmForTransfer(Params As %String) As Query(ROWSPEC = "InciId,InciCode,InciDesc,UomId,UomDesc,Qty:%Float,ManfDesc,BatchNo,ExpDate,StkQty:%Float,Inclb,Sp:%Float,StkbinDesc,DirtyQty:%Float,AvaQty:%Float,CurQty:%Float,RepQty:%Float,LevelQty:%Float,MaxQty:%Float,MinQty:%Float,BUomId,UomFac:%Float")
{
}

ClassMethod RecLocItmForTransferExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	
	s FrLoc=PJObj.%Get("FrLoc")
	s ToLoc=PJObj.%Get("ToLoc")
	s IntFac=PJObj.%Get("IntFac")
	s ScgId=PJObj.%Get("ScgId")
	
	S HospID=$P(^CTLOC(ToLoc),"^",22)

	s Inci=""
	f  s Inci=$O(^INCI("IL_LOC",ToLoc,Inci)) q:Inci=""  d
	.s batNo="",expDate="",stkQty=0,INCLB="",manf="",sp="",sbDesc=""
	.s chfrloc="",btrqty=0,btransqty=0,datanum=0,batTraQty=0,ResQty=0,AvaQty=0
	.
	.s obj=##class(User.INCItm).%OpenId(Inci,0)
	.s notUseFlag=obj.INCINotUseFlag
	.q:notUseFlag="Y"
	.s StkGrpInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(StkGrpInfo,"^",3)
	.s Scg=$p(StkGrpInfo,"^",5)
	.q:ScgType'=..sssCode()
	.q:(ScgId'="")&(("^"_ScgId_"^")'[("^"_Scg_"^"))
	.
	.s IL=$O(^INCI("IL_LOC",ToLoc,Inci,"")) q:IL=""
	.
	.s maxQty=$p(^INCI(Inci,"IL",IL),"^",7)
	.s minQty=$p(^INCI(Inci,"IL",IL),"^",4)
	.q:maxQty=""
	.q:minQty=""
	.s repqty=$p(^INCI(Inci,"IL",IL),"^",6)		;标准库存
	.q:+repqty'>0
	.s levelQty=minQty+(maxQty-minQty)/2		//参照标准数(上限和下限的中间值)
	.
	.s curqty=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(Inci,ToLoc,+$h)
	.q:curqty>levelQty
	.
	.s btrqty=+repqty-curqty
	.q:btrqty'>0
	.s code=obj.INCICode
	.s desc=obj.INCIDesc
	.s uom=obj.INCICTUOMDR.%Id()
	.
	.s uomdesc=obj.INCICTUOMDR.CTUOMDesc
	.
	.s pUom=obj.INCICTUOMPurchDR.%Id()
	.s pUomDesc=obj.INCICTUOMPurchDR.CTUOMDesc
	.s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(pUom,uom)
	.
	.s trqty=+btrqty/fac	; puruom qty
	.s chfrloc=$O(^INCI("IL_LOC",FrLoc,Inci,"")) q:chfrloc=""
	.
	.s incsb=$p(^INCI(Inci,"IL",chfrloc),"^",2)
	.i incsb'="" s sbDesc=$p($G(^INC("SB",incsb)),"^",2)
	.
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(Inci)
	.s manf=$p(ManfInfo,"^",3)
	.
	.i IntFac'="" d
	..s trqty=..GetFinalQty(Inci,ToLoc,trqty,IntFac)
	..s btrqty=trqty*fac
	.q:(IntFac'="")&(+trqty<1)
	.q:(IntFac="")&(+trqty'>0)
	.
	.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s curqty=curqty/fac    ;请求方库存
	.s repqty=repqty/fac
	.s levelQty=levelQty/fac
	.s maxQty=maxQty/fac
	.s minQty=minQty/fac
	.s pid=##class(web.DHCSTMHUI.DHCINIsTrfItm).GetInclbForTransfer(FrLoc,Inci,btrqty)
	.s sub=""
	.s:pid'="" sub=$o(^TMPGETINCLB(pid,""))
	.i sub'="" d
	..s chl=""
	..f  s chl=$o(^TMPGETINCLB(pid,chl)) q:chl=""  d
	...s data=^TMPGETINCLB(pid,chl)
	...s batNo=$p(data,"^",1)
	...s expDate=$p(data,"^",3)
	...s stkQty=$p(data,"^",2)
	...s INCLB=$p(data,"^",4)
	...s ResQty=$p(data,"^",5)
	...s AvaQty=$p(data,"^",6)
	...s batTraQty=$p(data,"^",7)
	...s stkQty=stkQty/fac
	...s ResQty=ResQty/fac
	...s AvaQty=AvaQty/fac
	...s batTraQty=batTraQty/fac
	...;s batTraQty=$fn(batTraQty,"",2)
	...s manf=$p(##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(INCLB),"^",2)
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(INCLB,+$h,pUom,HospID)
	...d OutPutRow
	..k ^TMPGETINCLB(pid)
	;.e  d
	;..;这个输出有问题吧?Inclb为空,前台无法保存 rem:2018-07-18
	;..d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(Inci,code,desc,pUom,pUomDesc,
		batTraQty,manf,batNo,expDate,stkQty,
		INCLB,sp,sbDesc,ResQty,AvaQty,
		curqty,repqty,levelQty,maxQty,minQty,
		uom,fac)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetFinalQty(inci As %String, ToLoc As %String, trqty As %String, intfac As %String) As %String
{
	n (inci,ToLoc,trqty,intfac)
	; the uom of trqty is "purch" uom
	s repfac=+intfac ;补货标准比例 
	s replev=..RepLev(inci,ToLoc)  ; purch uom  补货标准
	q:+replev<1 trqty  ;标准库存-现有库存
	s int=trqty\replev  ;M (标准库存-现有库存)/补货标准 并取整
	s mod=trqty#replev  ;R ((标准库存-现有库存)#补货标准)/补货标准
	i (mod/replev)<repfac s modint=0
	i (mod/replev)'<repfac s modint=1
	q (int+modint)*replev
}

/// 取补货标准
/// Date:2012-07-19
/// Argu:
///  inci - 库存项rowid
///  locdr - 科室rowid
/// Return:
///  补货标准数 
ClassMethod RepLev(inci, locdr)
{
	n (inci,locdr)
	q:inci="" ""
	q:locdr="" ""
	s ch=$o(^INCI("IL_LOC",locdr,inci,"")) q:ch="" ""
	s INCIL=inci_"||"_ch
	s Incilid=$o(^DHCINCIL(0,"INCIL",INCIL,""))  ;DHC_IncItmLoc 科室库存附加表ID
	s replev=""
	s:Incilid'="" replev=$p(^DHCINCIL(Incilid),"^",22) 
	;s replev=$p(^INCI(inci,"IL",ch),"^",5)  ;INC_ItmLoc  INCIL_RepLev
	q replev
}

}
