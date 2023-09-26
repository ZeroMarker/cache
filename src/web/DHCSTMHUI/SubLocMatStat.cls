Import sqluser

Class web.DHCSTMHUI.SubLocMatStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:统计发放(退回)物资信息
/// Creator:	tsr
/// CreatDate:	2019-06-29
/// Table:		dhc_intrans
/// Others: 	d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocMatStat","INDispStat",^tmpltx10091)
Query INDispStat(Params As %String) As Query(ROWSPEC = "Inci,InciCode,InciDesc,Spec,Brand,Model,QtyUom,RpAmt:%Float,ChargeFlag") [ SqlProc ]
{
}

ClassMethod INDispStatExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s pid=..GetDispStat(Params)
	
	s RpAmtTotal=0
	s Inci=0
	f  s Inci=$o(^DHCSTMTMP("INDispUserStat",pid,Inci)) q:Inci=""  d
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s BuomQty=$p(^DHCSTMTMP("INDispUserStat",pid,Inci),"^",1)
	.s RpAmt=$p(^DHCSTMTMP("INDispUserStat",pid,Inci),"^",2)
	.s RpAmtTotal=RpAmtTotal+RpAmt
	.s QtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(Inci,BuomQty)
	.s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(Inci)
	.s Model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(Inci)
	.s ChargeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetChargeFlag(Inci)
	.d OutPutRow

	k ^DHCSTMTMP("INDispUserStat",pid)
	Quit $$$OK
OutPutRow
	s Data=$lb(Inci,InciCode,InciDesc,Spec,Brand,Model,QtyUom,RpAmt,ChargeFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetDispStat(Params As %String) As %String
{
	n (Params)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	s ChargeFlag=PJObj.%Get("ChargeFlag")
	s IncludeRet=PJObj.%Get("IncludeRet")
	s ExcludeAlloted=PJObj.%Get("ExcludeAlloted")
	s pHospId=PJObj.%Get("gHospId")
	;q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()
	s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",StkType,"",StkGrp,pHospId)
	
	s pid=..NewPid()
	k ^DHCSTMTMP("INDispUserStat",pid)
	s type(1)="C"
	s:IncludeRet="Y" type(2)="L"

	f i=1:1:$o(type(""),-1)   d
	.s trType=type(i)
	.f d=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$O(^DHCINTR(0,"TypeDate",trType,d,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...q:inclb=""
	...s inci=+inclb,IL=$p(inclb,"||",2)
	...s LocID=$p(^INCI(inci,"IL",IL),"^",1)
	...q:(DispLoc'="")&(DispLoc'=LocID)
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...q:(trType="C")&&(ExcludeAlloted=1)&&($d(^DHCSLGA(0,"INDSI",pointer)))	//根据参数过滤掉已经生成分配单的明细
	...s recUser="",recLug="",toLoc=""
	...i trType="C" d
	....s toLoc=$p(^DHCINDS(+pointer),"^",22)		//发放单接收科室
	....s dispMode=$p(^DHCINDS(+pointer),"^",18)
	....i dispMode=1 d
	.....s recUser=$p(^DHCINDS(+pointer),"^",19)
	....e  d
	.....s recLug=$p(^DHCINDS(+pointer),"^",20)
	...e  i trType="L" d
	....s toLoc=$p(^DHCINDSR(+pointer),"^",13)		//退回单制单科室
	....s recUser=$p(^DHCINDSR(+pointer),"^",4)
	...q:(UserList'="")&&(UserList'=recUser)
	...q:(GrpList'="")&&(GrpList'=recLug)
	...q:(ReqLoc'="")&&(toLoc'=ReqLoc)
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s uom=$p(^DHCINTR(intr),"^",10)
	...s rpAmt=$p(^DHCINTR(intr),"^",17)
	...i Inci'="" q:inci'=Inci
	...s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s scg=$p(scgInfo,"^",5)
	...q:(SCG'="")&&(("^"_SCG_"^")'[("^"_scg_"^"))
	...s stkcat=$p(^INCI(inci,2),"^",2)
	...q:(StkCat'="")&&(StkCat'=stkcat)
	...s buom=$P($G(^INCI(inci,1)),"^",10)
	...s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	...s qty=-qty,rpAmt=-rpAmt
	...s buomQty=qty*uomFac
	...i '$d(^DHCSTMTMP("INDispUserStat",pid,inci)) d
	....s ^DHCSTMTMP("INDispUserStat",pid,inci)=buomQty_"^"_rpAmt
	...e  d
	....s $p(^DHCSTMTMP("INDispUserStat",pid,inci),"^",1)=$p(^DHCSTMTMP("INDispUserStat",pid,inci),"^",1)+buomQty
	....s $p(^DHCSTMTMP("INDispUserStat",pid,inci),"^",2)=$p(^DHCSTMTMP("INDispUserStat",pid,inci),"^",2)+rpAmt
	q pid
}

/// Description:统计发放(退回)物资明细信息
/// Creator:	tsr
/// CreatDate:	2019-06-29
/// Table:		
/// Others:		d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocMatStat","INDispDetailStat",^tmpltx10111)
Query INDispDetailStat(Params As %Text) As Query(ROWSPEC = "RowId,Type,InciCode,InciDesc,Spec,Manf,BatchNo,ExpDate,Qty:%Float,UomDesc,Rp:%Float,RpAmt:%Float,DispDate,DispTime,Receiver,IndsNo,DsrqNo,DsrqDate,VendorDesc,stkCatId,stkCatDesc,toLoc,toLocCode,toLocDesc,sp:%Float,spAmt:%Float") [ SqlProc ]
{
}

ClassMethod INDispDetailStatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	s ChargeFlag=PJObj.%Get("ChargeFlag")
	s IncludeRet=PJObj.%Get("IncludeRet")
	s ExcludeAlloted=PJObj.%Get("ExcludeAlloted")
	s pHospId=PJObj.%Get("gHospId")
	;q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()
	s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",StkType,"",StkGrp,pHospId)

	s type(1)="C"
	s:IncludeRet="Y" type(2)="L"

	f i=1:1:$o(type(""),-1)   d
	.s trType=type(i)
	.f d=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$O(^DHCINTR(0,"TypeDate",trType,d,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s inci=+inclb,IL=$p(inclb,"||",2)
	...s LocID=$p(^INCI(inci,"IL",IL),"^",1)
	...q:(DispLoc'="")&(DispLoc'=LocID)
	...q:(Inci'="")&&(inci'=Inci)
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...q:(trType="C")&&(ExcludeAlloted=1)&&($d(^DHCSLGA(0,"INDSI",pointer)))	//根据参数过滤已经生成分配单的部分
	...s dispDate=$p(^DHCINTR(intr),"^",2)
	...s dispDate=..DL2H(dispDate)
	...s dispTime=$p(^DHCINTR(intr),"^",3)
	...s dispTime=..TL2H(dispTime)
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s uom=$p(^DHCINTR(intr),"^",10)
	...s uomDesc=$p($G(^CT("UOM",uom)),"^",2)
	...s rp=$p(^DHCINTR(intr),"^",16)
	...s rpAmt=$p(^DHCINTR(intr),"^",17)
	...s buom=$P($G(^INCI(inci,1)),"^",10)
	...s buomDesc=$p($G(^CT("UOM",buom)),"^",2)
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	...s manf=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetManfInfoByInclb(inclb)
	...s manf=$p(manf,"^",2)
	...s VendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
	...s VendorDesc=$p(VendorInfo,"^",2)
	...s sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inclb,d,uom)
	...s spAmt=sp*qty
	...s batNo="",expDate=""
	...&sql(select inclb_incib_dr->incib_no,inclb_incib_dr->incib_expdate into :batNo,:expDate from inc_itmlcbt where inclb_rowid=:inclb)
	...s:expDate'="" expDate=..DL2H(expDate)
	...s (indsNo,scg,dispMode,lug,user,receiver,dsrqNo,dsrqDate,toLoc,toLocCode,toLocDesc)=""
	...i trType="C" d
	....s inds=+pointer
	....&sql(select inds_no,inds_scg_dr,inds_dispmode,inds_dispuserGrp_dr,inds_dispuser_dr,
			decode(inds_dispmode,'0',inds_dispuserGrp_dr->lug_groupdesc,inds_dispuser_dr->ssusr_name) receiver,inds_rq_dr->dsrq_no,inds_rq_dr->dsrq_date,INDS_TOLOC_DR
		into :indsNo,:scg,:dispMode,:lug,:user,
			:receiver,:dsrqNo,:dsrqDate,:toLoc
		From dhc_indisp where inds_rowid=:inds)
	...e  i trType="L" d
	....&sql(select DSRI_DSR_ParRef->DSR_No,DSRI_DSR_ParRef->DSR_SCG_DR,DSRI_DSR_ParRef->DSR_SSUSR_DR,DSRI_DSR_ParRef->DSR_SSUSR_DR->SSUSR_Name,DSRI_DSI_DR->INDSI_RQI_DR->DSRQI_DSRQ_ParRef->DSRQ_No,
			DSRI_DSR_ParRef->DSR_CTLOC_DR
		into :indsNo,:scg,:user,:receiver,:dsrqNo,
			:toLoc
		From dhc_indispretitm where %id=:pointer)
	...q:(UserList'="")&&((UserList'=user)||(lug'=""))
	...q:(GrpList'="")&&(GrpList'=lug)
	...q:(ReqLoc'="")&&(toLoc'=ReqLoc)
	...i toLoc'=""  d
	....s toLocCode=$p(^CTLOC(toLoc),"^",1)
	....s toLocDesc=$p(^CTLOC(toLoc),"^",2)
	...s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...s scg=$p(scgInfo,"^",5)
	...q:(SCG'="")&&(("^"_SCG_"^")'[("^"_scg_"^"))
	...s stkCatInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncsc(inci)
	...s stkCatId=$p(stkCatInfo,"^",1)
	...s stkCatDesc=$p(stkCatInfo,"^",3)
	...i dsrqDate'="" s dsrqDate=..DL2H(dsrqDate)
	...s qty=-qty,rpAmt=-rpAmt,spAmt=-spAmt
	...d OutPutItmRow

	Quit $$$OK
OutPutItmRow
	s Data=$lb(pointer,trType,inciCode,inciDesc,spec,manf,batNo,expDate,qty,uomDesc,rp,rpAmt,dispDate,dispTime,receiver,indsNo,dsrqNo,dsrqDate,VendorDesc,stkCatId,stkCatDesc,toLoc,toLocCode,toLocDesc,sp,spAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:统计一段时间的个人支出和公共支出
/// Creator:	tsr
/// CreatDate:	2019-06-29
/// Table:		
/// Others:		d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocMatStat","SubLocDispAllotStat",^tmpltx10093)
Query SubLocDispAllotStat(Params As %Text) As Query(ROWSPEC = "RowId,Type,Lug,LugCode,LugDesc,UserId,UserInitial,UserName,RpAmt:%Float,ToLoc,ToLocDesc") [ SqlProc ]
{
}

ClassMethod SubLocDispAllotStatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	s ChargeFlag=PJObj.%Get("ChargeFlag")
	s IncludeRet=PJObj.%Get("IncludeRet")
	s ExcludeAlloted=PJObj.%Get("ExcludeAlloted")
	;q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkType=..sssCode()

	s type(1)="C"
	s:IncludeRet="Y" type(2)="L"
	k AllotLUGArr		//用来记录分配信息里的专业组

	s DAtype="Allot"
	f Date=StartDate:1:EndDate d
	.s slga=""
	.f  s slga=$o(^DHCSLGA(0,"ALLOTMON",Date,slga)) q:slga=""  d
	..s auditFlag=$p(^DHCSLGA(slga),"^",11)
	..q:auditFlag'="Y"
	..s slgaLoc=$p(^DHCSLGA(slga),"^",5)
	..q:(DispLoc'="")&&(slgaLoc'=DispLoc)
	..s Lug=$p(^DHCSLGA(slga),"^",6)
	..q:(GrpList'="")&&(GrpList'=LUG)
	..s toLoc=$p(^DHCLUG(Lug),"^",5)
	..q:(ReqLoc'="")&&(toLoc'=ReqLoc)			;根据接收科室过滤
	..s toLocDesc=$p(^CTLOC(toLoc),"^",2)
	..s stkType=$p(^DHCSLGA(slga),"^",13)
	..q:stkType'=StkType
	..s AllotLUGArr(Lug)=""
	..s slgasCh=""
	..f  s slgasCh=$o(^DHCSLGA(slga,"S",slgasCh)) q:slgasCh=""  d
	...s user=$p(^DHCSLGA(slga,"S",slgasCh),"^",1)
	...s rpAmt=$p(^DHCSLGA(slga,"S",slgasCh),"^",3)
	...s spAmt=$p(^DHCSLGA(slga,"S",slgasCh),"^",4)
	...q:(UserList'="")&&(UserList'=user)
	...s LugCode=$p(^DHCLUG(Lug),"^",1)
	...s LugDesc=$p(^DHCLUG(Lug),"^",2)
	...s userInitial=$p(^SSU("SSUSR",user),"^",1)
	...s userName=$p(^SSU("SSUSR",user),"^",2)
	...d OutPutDetail

	s DAtype="Disp"
	f i=1:1:$o(type(""),-1)   d
	.s trType=type(i)
	.f d=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$O(^DHCINTR(0,"TypeDate",trType,d,intr)) q:intr=""  d
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s rpAmt=$p(^DHCINTR(intr),"^",17)
	...s rpAmt=-rpAmt
	...s (dispMode,loc,user,skType,toLoc)=""
	...i trType="C" d
	....s dispMode=$p(^DHCINDS(+pointer),"^",18)
	....s loc=$p(^DHCINDS(+pointer),"^",9)
	....s user=$p(^DHCINDS(+pointer),"^",19)
	....s stkType=$p(^DHCINDS(+pointer),"^",16)
	....s toLoc=$p(^DHCINDS(+pointer),"^",22)		//发放单接收科室
	...e  i trType="L" d
	....s user=$p(^DHCINDSR(+pointer),"^",4)
	....s loc=$p(^DHCINDSR(+pointer),"^",13)
	....s stkType=$p(^DHCINDSR(+pointer),"^",11)
	....s toLoc=$p(^DHCINDSR(+pointer),"^",13)		//退回单制单科室
	...q:stkType'=StkType
	...q:user=""
	...q:(trType="C")&&(dispMode=0)		//根据过滤专业组发放单
	...q:(DispLoc'="")&&(DispLoc'=loc)
	...q:(ReqLoc'="")&&(toLoc'=ReqLoc)	//根据接收科室过滤
	...q:(UserList'="")&&(user'=UserList)
	...s Lug=$$GetUserGroup(user,toLoc,EndDate)
	...q:(GrpList'="")&&(Lug'="")&&(GrpList'=Lug)
	...s LugCode="",LugDesc=""
	...s:Lug'="" LugCode=$p(^DHCLUG(Lug),"^",1)
	...s:Lug'="" LugDesc=$p(^DHCLUG(Lug),"^",2)
	...s userInitial=$p(^SSU("SSUSR",user),"^",1)
	...s userName=$p(^SSU("SSUSR",user),"^",2)
	...s toLocDesc=$p(^CTLOC(toLoc),"^",2)
	...d OutPutDetail

	q $$$OK
OutPutDetail
	s Data=$lb(pointer,DAtype,Lug,LugCode,LugDesc,user,userInitial,userName,rpAmt,toLoc,toLocDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q

///获取User的有效专业组
GetUserGroup(UserId,LocId,EndDate)
	n (AllotLUGArr,UserId,LocId,EndDate)
	s Ret=""
	s Lug=""
	f  s Lug=$o(^DHCLUG(0,"USER",UserId,Lug)) q:(Lug="")||(Ret'="")  d
	.q:'$d(AllotLUGArr(Lug))			//过滤不在分配信息里的专业组
	.s LugDateTo=$p(^DHCLUG(Lug),"^",4)
	.s LugLoc=$p(^DHCLUG(Lug),"^",5)
	.q:LugLoc'=LocId
	.q:(LugDateTo'="")&&(LugDateTo<EndDate)
	.s Ch=$o(^DHCLUG(0,"USER",UserId,Lug,0)) q:Ch=""
	.s DateTo=$p(^DHCLUG(Lug,"I",Ch),"^",3)
	.q:(DateTo'="")&&(DateTo<EndDate)
	.s Ret=Lug
	q Ret
}

/// Description:统计一段时间内科室发放量和个人医嘱开出的量
/// ps: 		长嘱方面索引不好用,暂从30天前开出的医嘱开始统计
/// Creator:	wangjiabin
/// CreateDate:	2016-02-24
/// Table:		dhc_intrans,oe_orditem,dhc_oedispensing等
/// Others:		d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.SubLocMatStat","SubLocDispAndOeori")
Query SubLocDispAndOeori(Params As %Text) As Query(ROWSPEC = "DOType,inci,inciCode,inciDesc,spec,qtyBUom:%Float,qtyPUom:%Float,PUomDesc,UserId,UserName") [ SqlProc ]
{
}

ClassMethod SubLocDispAndOeoriExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s ^tsr("SubLocDispAndOeori")=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s DispLoc=PJObj.%Get("DispLoc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s StkGrp=PJObj.%Get("StkGrp")
	s StkCat=PJObj.%Get("StkCat")
	s Inci=PJObj.%Get("Inci")
	s ReqLoc=PJObj.%Get("ReqLoc")
	s GrpList=PJObj.%Get("GrpList")
	s UserList=PJObj.%Get("UserList")
	s IncludeRet=PJObj.%Get("IncludeRet")
	;q:DispLoc="" $$$OK
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	
	//统计发放部分(包含退回),不统计专业组部分
	s DOType="Disp"
	s type(1)="C"
	s:IncludeRet="Y" type(2)="L"
	f i=1:1:$o(type(""),-1)   d
	.s trType=type(i)
	.f d=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$O(^DHCINTR(0,"TypeDate",trType,d,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s inci=+inclb,IL=$p(inclb,"||",2)
	...s LocID=$p(^INCI(inci,"IL",IL),"^",1)
	...q:(DispLoc'="")&(DispLoc'=LocID)
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s dispMode=""
	...i trType="C" d
	....s dispMode=$p(^DHCINDS(+pointer),"^",18)
	...q:(trType="C")&&(dispMode=0)		;过滤发放给专业组的单据
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s qty=-qty						;取台帐负数
	...s uom=$p(^DHCINTR(intr),"^",10)
	...s uomDesc=$p($G(^CT("UOM",uom)),"^",2)
	...s rp=$p(^DHCINTR(intr),"^",16)
	...s rpAmt=$p(^DHCINTR(intr),"^",17)
	...s buom=$P($G(^INCI(inci,1)),"^",10)
	...s puom=$p($G(^INCI(inci,3)),"^",6)
	...s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	...s PUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,buom)
	...s qtyBUom=qty*UomFac
	...s qtyPUom=qtyBUom/PUomFac
	...s PUomDesc=$p(^CT("UOM",puom),"^",2)
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
	...s (UserId,UserName)=""
	...i trType="C" d
	....s inds=+pointer
	....&sql(select inds_dispuser_dr,inds_dispuser_dr->ssusr_name
		into :UserId,:UserName From dhc_indisp where inds_rowid=:inds)
	...e  i trType="L" d
	....&sql(select DSRI_DSR_ParRef->DSR_SSUSR_DR,DSRI_DSR_ParRef->DSR_SSUSR_DR->SSUSR_Name
		into :UserId,:UserName From dhc_indispretitm where %id=:pointer)
	...q:(UserList'="")&&(UserId'=UserList)
	...d OutPutDispOeori
	
	;统计医嘱内消耗量
	s DOType="Oeori"
	s Pid=..NewPid()
	i DispLoc'=""  d
	.s sqlStr="SELECT SSUSR_RowId AS UserId FROM SS_User where SSUSR_DefaultDept_DR="_DispLoc
	.s sqlStr1="select othll_parref as UserId From SS_UserOtherLogonLoc where othll_ctloc_dr="_DispLoc
	e  d
	.s sqlStr="SELECT SSUSR_RowId AS UserId FROM SS_User"
	.s sqlStr1="select othll_parref as UserId From SS_UserOtherLogonLoc"
	s sqlStr=sqlStr_" union "_sqlStr1 
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s UserId=result.Data("UserId")
		continue:(UserList'="")&&(UserId'=UserList)
		s UserName=$p(^SSU("SSUSR",UserId),"^",2)
		d ..GetOEOrdItemInfo(StartDate,EndDate,UserId,Pid)
		continue:'$d(^DHCSTMTMP("GetOEOrdItemInfo",Pid))
		s GlobalSub=""
		f  s GlobalSub=$o(^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)) q:GlobalSub=""  d
		.s inci=$p(GlobalSub,"^",2)
		.s qty=^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)
		.s buom=$P($G(^INCI(inci,1)),"^",10)
		.s puom=$p($G(^INCI(inci,3)),"^",6)
		.s PUomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,buom)
		.s qtyBUom=qty
		.s qtyPUom=qtyBUom/PUomFac
		.s PUomDesc=$p(^CT("UOM",puom),"^",2)
		.s inciCode=$p(^INCI(inci,1),"^",1)
		.s inciDesc=$p(^INCI(inci,1),"^",2)
		.s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		.d OutPutDispOeori
		k ^DHCSTMTMP("GetOEOrdItemInfo",Pid)
	}
	q $$$OK
OutPutDispOeori
	s Data=$lb(DOType,inci,inciCode,inciDesc,spec,qtyBUom,qtyPUom,PUomDesc,UserId,UserName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询某段时间内的发放量
/// Creator:	wangjiabin
/// CreateDate:	2013-12-17
/// Table:		dhc_intrans等
/// Input:		loc,inci,开始日期,结束日期,
/// 			includeRet(包含退货标志:1包含,0不包含)
/// Output:		
/// Return：	科室发放数量(基本单位)
ClassMethod GetDispQty(loc, INCI, sd, ed, includeRet) As %String
{
	n (loc,INCI,sd,ed,includeRet)
	
	q:loc="" 0
	q:INCI="" 0
	s:sd["-" sd=$zdh(sd,3)
	s:ed["-" ed=$zdh(ed,3)
	s:sd["/" sd=$zdh(sd,4)
	s:ed["/" ed=$zdh(ed,4)
	q:sd>ed 0
	
	s dispQtySum=0
	s types="C"
	s:includeRet=1 types="CL"
	s typesLen=$l(types)
	f i=1:1:typesLen  d
	.s trType=$e(types,i)
	.s trDate=sd-1
	.f  s trDate=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trType,trDate)) q:(trDate>ed)!(trDate="")  d
	..s intr=0
	..f  s intr=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trType,trDate,intr)) q:intr=""  d
	...s pointer=$p(^DHCINTR(intr),"^",9)
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s uom=$p(^DHCINTR(intr),"^",10)
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s inci=+inclb
	...q:INCI'=inci
	...s buom=$P($G(^INCI(inci,1)),"^",10)
	...s uomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	...s dispQty=qty*uomFac
	...s dispQtySum=dispQtySum+dispQty
	...
	...
	
	s dispQtySum=-dispQtySum
	
	q dispQtySum
}

/// Description:	查询某时间段内某人的专业组分配金额
/// Creator:		wangjiabin
/// CreateDate:		2014-02-25
/// Table:			DHC_SubLocGrpAllot,DHC_SubLocGrpAllotItm,DHC_SubLocGrpAllotScale
/// Input:			sd^ed^包含退回标志(0:否,1:是)^loc^userID^专业组^inci^scg^stkcat^专业组科室,
/// 				ExcludeAlloted(排除已经分配部分  1:排除, 其他:不排除)
/// Output:
/// Return：		
ClassMethod AllotStat(strPar As %String) As %String
{
	n (strPar)
	s StartDate=$p(strPar,"^",1)
	s EndDate=$p(strPar,"^",2)
	s IncludeRet=$p(strPar,"^",3)
	s SubLoc=$p(strPar,"^",4)
	s User=$p(strPar,"^",5)
	s LUG=$p(strPar,"^",6)
	s INCI=$p(strPar,"^",7)
	s SCG=$p(strPar,"^",8)
	s StkCat=$p(strPar,"^",9)
	s ToLoc=$p(strPar,"^",10)
	q:StartDate="" ""
	q:EndDate="" ""
	q:User="" ""
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s sumRpAmt=0,sumSpAmt=0
	f Date=StartDate:1:EndDate d
	.s slga=""
	.f  s slga=$o(^DHCSLGA(0,"ALLOTMON",Date,slga)) q:slga=""  d
	..s auditFlag=$p(^DHCSLGA(slga),"^",11)
	..q:auditFlag'="Y"
	..s ch=$o(^DHCSLGA(0,"USER",User,slga,""))
	..q:ch=""
	..s slgaLoc=$p(^DHCSLGA(slga),"^",5)
	..q:(SubLoc'="")&&(slgaLoc'=SubLoc)
	..s slgaLug=$p(^DHCSLGA(slga),"^",6)
	..q:(LUG'="")&&(slgaLug'=LUG)
	..s LugLoc=$p(^DHCLUG(slgaLug),"^",5)
	..q:(ToLoc'="")&&(LugLoc'=ToLoc)
	..s stkType=$p(^DHCSLGA(slga),"^",13)
	..q:stkType'=..sssCode()
	..
	..;s slgasRpAmt=+$p(^DHCSLGA(slga,"S",ch),"^",3)
	..;s slgasSpAmt=+$p(^DHCSLGA(slga,"S",ch),"^",4)
	..s slgaAmt=..GetSlgaAmt(slga,User,INCI,StkCat,SCG)
	..s slgasRpAmt=+$p(slgaAmt,"^",1)
	..s slgasSpAmt=+$p(slgaAmt,"^",2)
	..s sumRpAmt=sumRpAmt+slgasRpAmt
	..s sumSpAmt=sumSpAmt+slgasSpAmt
	..
	q sumRpAmt_"^"_sumSpAmt
}

/// Description:	返回某分配单中某人对应的金额
/// Creator:		wangjiabin
/// CreateDate:		2014-02-25
/// Table:			DHC_SubLocGrpAllotItm,DHC_SubLocGrpAllotScale
/// Input:			分配单rowid,userid,inci,库存分类,类组
/// Output:			分配进价金额^分配售价金额
/// Return:
ClassMethod GetSlgaAmt(slga, User, INCI, StkCat, SCG) As %String
{
	n (slga,User,INCI,StkCat,SCG)
	q:slga="" ""
	q:User="" ""
	s SCG=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",SCG)
	
	s scaleCh=$o(^DHCSLGA(0,"USER",User,slga,""))
	q:scaleCh="" ""
	s Scale=$p(^DHCSLGA(slga,"S",scaleCh),"^",2)
	s sumScale=""
	&sql(select sum(nvl(SLGAS_ScaleValue,0)) into :sumScale from DHC_SubLocGrpAllotScale where SLGAS_SLGA_Parref=:slga)
	q:+sumScale=0 ""
	s sumRpAmt=0,sumSpAmt=0
	s ch=""
	f  s ch=$o(^DHCSLGA(slga,"I",ch)) q:ch=""  d
	.s inci=$p(^DHCSLGA(slga,"I",ch),"^",1)
	.q:(INCI'="")&&(INCI'=inci)
	.s incsc=$p(^INCI(inci,2),"^",2)
	.q:(StkCat'="")&&(StkCat'=incsc)
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s scg=$p(scgInfo,"^",5)
	.q:(SCG'="")&&(("^"_SCG_"^")'[("^"_scg_"^"))
	.s RpAmt=$p(^DHCSLGA(slga,"I",ch),"^",4)
	.s SpAmt=$p(^DHCSLGA(slga,"I",ch),"^",5)
	.s sumRpAmt=sumRpAmt+RpAmt
	.s sumSpAmt=sumSpAmt+SpAmt
	.
	s sumRpAmt=sumRpAmt*Scale/sumScale
	s sumRpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatRpAmt(sumRpAmt,"")
	s sumSpAmt=sumSpAmt*Scale/sumScale
	s sumSpAmt=##class(web.DHCSTMHUI.Common.AppCommon).FormatSpAmt(sumSpAmt,"")
	q sumRpAmt_"^"_sumSpAmt
}

/// Description:统计医嘱消耗,计入临时global(上面的query--SubLocDispAndOeori用到)
/// Creator:	wangjiabin
/// CreateDate:	2016-02-24
/// Table:		oe_orditem,dhc_oedispensing等
/// Input:		开始日期,截止日期,人员id,Pid
/// Output:
/// Return：
ClassMethod GetOEOrdItemInfo(SD As %String, ED As %String, User As %String, Pid) [ Private ]
{
	n (SD,ED,User,Pid)
	s SSUSRCareProv=$p(^SSU("SSUSR",User),"^",14)
	q:SSUSRCareProv="" ""
	
	k ^DHCSTMTMP("GetOEOrdItemInfo",Pid)
	s OrdStDt=SD-30		;考虑到长嘱的情况,统计30天之前开的医嘱
	f  s OrdStDt=$o(^OEORDi(0,"DocStDate",SSUSRCareProv,OrdStDt)) q:(OrdStDt="")||(OrdStDt>ED)  d
	.s Oeord=0 f  s Oeord=$o(^OEORDi(0,"DocStDate",SSUSRCareProv,OrdStDt,Oeord)) q:Oeord=""  d
	..s Ch=0 f  s Ch=$o(^OEORDi(0,"DocStDate",SSUSRCareProv,OrdStDt,Oeord,Ch)) q:Ch=""  d
	...;这里应该判断医嘱状态
	...s Oeori=Oeord_"||"_Ch
	...
	...s Arcim=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	...s Inci=$o(^INCI(0,"ARCIM_DR",$p(Arcim,"||",1),0))
	...q:Inci=""
	...s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	...s ScgType=$p(ScgInfo,"^",3)
	...q:ScgType'=..sssCode()
	...s Priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	...q:'$d(^OECPR(Priority))
	...s PriorCode=$p(^OECPR(Priority),"^",1)
	...q:(PriorCode'="S")&&(OrdStDt<SD)		;早于SD,且不是长嘱的,过滤
	...
	...s GlobalSub=User_"^"_Inci
	...i PriorCode'="S" d
	....s DspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,0))
	....q:DspId=""
	....s DspQty=$p(^DHCOEDISQTY(DspId),"^",5)
	....
	....i $d(^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)) d
	.....s ^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)=^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)+DspQty
	....e  d
	.....s ^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)=DspQty
	...e  d
	....;长期医嘱
	....s ExecDate=SD
	....f  s ExecDate=$o(^OEORDi(0,"OrdItem",Oeord,Ch,ExecDate)) q:(ExecDate="")||(ExecDate>ED)  d
	.....s Sub=0
	.....f  s Sub=$o(^OEORDi(0,"OrdItem",Oeord,Ch,ExecDate,Sub)) q:Sub=""  d
	......s Oeore=Oeori_"||"_Sub
	......s DspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,0))
	......q:DspId=""
	......s DspQty=$p(^DHCOEDISQTY(DspId),"^",5)
	......i $d(^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)) d
	.......s ^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)=^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)+DspQty
	......e  d
	.......s ^DHCSTMTMP("GetOEOrdItemInfo",Pid,GlobalSub)=DspQty
	
	q
}

}
