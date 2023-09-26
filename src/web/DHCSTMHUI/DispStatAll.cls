Import sqluser

/// 发药相关统计
/// LiangQiang 
/// 2013-12-03
Class web.DHCSTMHUI.DispStatAll Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	物资消耗统计
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_intrans
/// Input:		排序，查询条件
/// Return：	物资消耗统计
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DispStatAll","GetDispStatData",^tmpqsx("GetDispStatData"))
Query GetDispStatData(Params As %Text) As Query(ROWSPEC = "incicode,incidesc,qty:%Float,rp:%Float,sp:%Float,rpamt:%Float,spamt:%Float,docloc,ward,puomqty:%Float,packuomqty,buomdesc,puomdesc,stkcatdesc,patientNo,patientName,docloccode,wardCode,recLocCode,recLocDesc,VendorId,VendorDesc,HVFlag") [ SqlProc ]
{
}

ClassMethod GetDispStatDataExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	q:Params="" $$$OK
	
	s ret=..DispStatAll(Params)
	s pid=$p(ret,"^",1)
	s cnt=$p(ret,"^",2)
	
	s h=""
	f  s h=$o(^TMPDHCSTM("DispStatAll",pid,h)) q:h=""  d
	.s data=^TMPDHCSTM("DispStatAll",pid,h)
	.s incicode=$p(data,"^",1)
	.s incidesc=$p(data,"^",2)
	.s qty=$p(data,"^",3)
	.s rp=$p(data,"^",4)
	.s sp=$p(data,"^",5)
	.s rpamt=$p(data,"^",6)
	.s spamt=$p(data,"^",7)
	.s docloc=$p(data,"^",8)
	.i $f(docloc,"-") s docloc=$p(docloc,"-",2)
	.s ward=$p(data,"^",9)
	.s packfac=$p(data,"^",10)
	.s inci=$p(data,"^",11)
	.s puomqty=$fn(qty/packfac,"",2)
	.s packuomqty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,qty)
	.s buomdesc=$p(data,"^",12)
	.s puomdesc=$p(data,"^",13)
	.s stkcatdesc=$p(data,"^",14)
	.s patientNo=$p(data,"^",15)
	.s patientName=$p(data,"^",16)
	.s docloccode=$p(data,"^",17)
	.s wardCode=$p(data,"^",18)
	.s recLocCode=$p(data,"^",19)
	.s recLocDesc=$p(data,"^",20)
	.s VendorId=$p(data,"^",21)
	.s VendorDesc=$p(data,"^",22)
	.s HVFlag=$p(data,"^",23)
	.d OutRowItm
	k ^TMPDHCSTM("DispStatAll",pid)
	
	Quit $$$OK
OutRowItm
	set Data=$lb(incicode,incidesc,qty,rp,sp,
		rpamt,spamt,docloc,ward,puomqty,
		packuomqty,buomdesc,puomdesc,stkcatdesc,patientNo,
		patientName,docloccode,wardCode,recLocCode,recLocDesc,
		VendorId,VendorDesc,HVFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 实时统计发药消耗量
/// w ##class(web.DHCSTMHUI.DispStatAll).DispStatAll("2014-06-11^2014-06-11^^^1")
ClassMethod DispStatAll(Params As %Text) As %String
{
	n (Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s stdate=PJObj.%Get("StartDate")
	s endate=PJObj.%Get("EndDate")
	s phalocdr=PJObj.%Get("PhaLoc")
	s parinci=PJObj.%Get("Inci")
	s parincdesc=PJObj.%Get("InciDesc")
	s hvFlag=PJObj.%Get("HvFlag")
	s pStartTime=PJObj.%Get("StartTime")
	s pEndTime=PJObj.%Get("EndTime")
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("CTHosp")
	s:stdate'="" stdate=..DH2L(stdate)
	s:endate'="" endate=..DH2L(endate)
	s pStartTime=..TH2L(pStartTime)
	s pEndTime=..TH2L(pEndTime)
	s:pStartTime="86399" pStartTime=""
	s:pEndTime="86399" pEndTime=""
	q:stdate="" 0
	q:endate="" 0
	s typestr="P^F^Y^H^PM^FM^YM^HM^MP^MF^MY^MH^MDP^MDY"
	s pid=..NewPid()
	k ^TMPDHCSTM("DispStatAll",pid)
	
	s HospID=$S(phalocdr'="":$p(^CTLOC(phalocdr),"^",22),1:"")
	s n=0
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:endate d
	..s intr=0
	..f  s intr = $o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s IntrTime=$p(^DHCINTR(intr),"^",3)
	...q:(date=stdate)&&(pStartTime'="")&&(IntrTime<pStartTime)
	...q:(date=endate)&&(pEndTime'="")&&(IntrTime>=pEndTime)
	...s inci=+inclb,IL=$p(inclb,"||",2)
	...s incicode=$p(^INCI(inci,1),"^",1)
	...s incidesc=$p(^INCI(inci,1),"^",2)
	...q:(parincdesc'="")&(incidesc'[parincdesc)
	...
	...s LocID=$p(^INCI(inci,"IL",IL),"^",1)
	...q:(phalocdr'="")&(phalocdr'=LocID)
	...s HospID=$p($G(^CTLOC(LocID)),"^",22)
	...q:(pHospId'="")&&(pHospId'=HospID)
	...q:(parinci'="")&(parinci'=inci)
	...
	...s stkcat=$p(^INCI(inci,2),"^",2)
	...s Mtype=""
	...s:stkcat'="" Mtype=$p(^INC("SC",stkcat),"^",3)
	...q:Mtype'=..sssCode()
	...s:stkcat'="" stkcatdesc=$p(^INC("SC",stkcat),"^",2)
	...s highvalueFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	...q:(hvFlag'="")&(hvFlag'=highvalueFlag)
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s baseuom=$p(^INCI(inci,1),"^",10)
	...s puomdr=$p(^INCI(inci,3),"^",6)
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s uom=$p(^DHCINTR(intr),"^",10)
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,date,puomdr,HospID)
	...s rpamt=$p(^DHCINTR(intr),"^",17)
	...s spamt=$p(^DHCINTR(intr),"^",8)
	...s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,baseuom) 
	...s qty=qty*fac
	...s packfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puomdr,baseuom)
	...s rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,puomdr,HospID)
	...s rp=##class(web.DHCSTMHUI.Common.AppCommon).FormatRp(rp,HospID,1)
	...
	...s doclocdr=..GetTransDocLoc(intr)
	...s (docloccode,docloc)=""
	...i doclocdr'="" d
	....s docloccode=$p($g(^CTLOC(doclocdr)),"^",1)
	....s docloc=$p($g(^CTLOC(doclocdr)),"^",2)  //医生科室
	...
	...s patientstr=..GetTransPatient(intr)
	...s patientNo=$p(patientstr,"^",1)
	...s patientName=$p(patientstr,"^",2)
	...
	...s warddr=..GetTransWardDr(intr) //病区
	...s (wardCode,ward)=""
	...i warddr'="" d
	....s wardCode=$p($g(^CTLOC(warddr)),"^",1)
	....s ward=$p($g(^CTLOC(warddr)),"^",2)
	...
	...s baseuom=$p(^CT("UOM",baseuom),"^",2)
	...s puruom=$p(^CT("UOM",puomdr),"^",2)
	...
	...s recLocCode=$p(^CTLOC(LocID),"^",1)
	...s recLocDesc=$p(^CTLOC(LocID),"^",2)
	...
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
	...s VendorId=$p(VendorInfo,"^",1)
	...s VendorDesc=$p(VendorInfo,"^",2)
	...
	...s n=n+1
	...s data=incicode_"^"_incidesc_"^"_qty_"^"_rp_"^"_sp_"^"_rpamt_"^"_spamt_"^"_docloc_"^"_ward_"^"_packfac_"^"_inci_"^"_baseuom_"^"_puruom_"^"_stkcatdesc_"^"_patientNo_"^"_patientName_"^"_docloccode_"^"_wardCode_"^"_recLocCode_"^"_recLocDesc_"^"_VendorId_"^"_VendorDesc_"^"_highvalueFlag
	...s ^TMPDHCSTM("DispStatAll",pid,n)=data

	q pid_"^"_n
}

/// 取台帐业务中的医生科室
/// w ##class(web.DHCSTMHUI.DispStatAll).GetTransDocLoc(34545)
ClassMethod GetTransDocLoc(intr) As %String
{
	n (intr)
	s orditm=..GetTransOrdItem(intr)
	q:orditm="" ""
	s ord=$p(orditm,"||",1)
	s chl=$p(orditm,"||",2)
	s doclocdr=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	q doclocdr
}

/// 获取台帐中的医嘱ID
/// w ##class(web.DHCSTMHUI.DispStatAll).GetTransOrdItem(34545)
ClassMethod GetTransOrdItem(intr) As %String
{
	n (intr)
	s orditm=""
	s type=$p(^DHCINTR(intr),"^",1)
	s pointer=$p(^DHCINTR(intr),"^",9) 
	i type="MDP" d
	.s InMatDispItm=$p(pointer,"||",1,2)
	.s orditm=$lg(^User.DHCInMatDispD(+InMatDispItm,"ChildDHCInMatDispItm",$p(InMatDispItm,"||",2)),4)
	i type="MDY" d
	.s InMatRetItmId=$p(pointer,"||",1,2)
	.s orditm=$lg(^User.DHCInMatRetD(+InMatRetItmId,"ChildDHCInMatRetItm",$p(InMatRetItmId,"||",2)),4)
	i orditm="" d
	.s orditm=pointer
	q orditm
}

/// 取台帐业务中的病区科室
ClassMethod GetTransWardDr(intr) As %String
{
	n (intr)
	s wardlocdr=""
	s pointer=$p(^DHCINTR(intr),"^",9)
	q:pointer="" ""
	s inclb=$p(^DHCINTR(intr),"^",7)
	s type=$p(^DHCINTR(intr),"^",1)
	s ord=$p(pointer,"||",1)
	s itm=$p(pointer,"||",2)
	s oeori=ord_"||"_itm
	
	i (type="P")||(type="Y")||(type="MP")||(type="MY") d
	.s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,0))
	.q:dsp=""
	.s wardlocdr=$p(^DHCOEDISQTY(dsp),"^",22)

	i (type="F")||(type="H")||(type="MF")||(type="MH") d
	.S wardlocdr=$P($G(^OEORD(ord,"I",itm,7)),"^",2)

	q wardlocdr
}

/// 取患者信息
/// 2015-1-23
/// wfg
/// w ##class(web.DHCSTMHUI.DispStatAll).GetTransDocLoc(34545)
ClassMethod GetTransPatient(intr As %String) As %String
{
	n (intr)
	s Oeori=..GetTransOrdItem(intr)
	q:Oeori="" "不详"
	s Ord=$p(Oeori,"||",1)
	s Chl=$p(Oeori,"||",2)
	s adm=$p(^OEORD(Ord),"^",1)
	s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
	s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
	s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
	s sex="",admloc=""
	i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",1)
	s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
	q pano_"^"_name
}

}
