Import sqluser

/// 检查库存数据方面的工具类
Class web.DHCSTMHUI.Tools.ExamineData Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// 生成供应商别名
/// 2018-1-17
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).UpdateVendorAlias()	
ClassMethod UpdateVendorAlias() As %String
{
	new
	s num=0
	s vendorid=0
	s count=0
	f  s vendorid=$o(^APC("APCVM",vendorid)) q:vendorid=""  d
	.s type=$p(^APC("APCVM",vendorid),"^",9)
	.q:type'="M"
	.s code=$p(^APC("APCVM",vendorid),"^",2)
	.s name=$p(^APC("APCVM",vendorid),"^",3)
	.s Alias=code_"/"_name_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(name,4)
	.s count=count+1
	.
	.&sql(update DHC_STVendor set STV_Alias=:Alias where STV_Vendor_DR=:vendorid)
	.i SQLCODE d
	..s ^TMP("UpdateVendorAlias",$zts,count)=vendorid_"^"_name
	.e  d
	..w name_" 修改成功!" ,!
	..s num=num+1
	w "success:"_num,!
}

/// 生成厂家别名
/// 2017-12-8
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).UpdateManfAlias()	
ClassMethod UpdateManfAlias() As %String
{
	new
	s num=0
	s manfid=0
	s count=0
	f  s manfid=$o(^PHMNF(manfid)) q:manfid=""  d
	.s ManfType=""
	.&sql(select MANF_Type into :ManfType from DHC_Manf_AddionInfo where MANF_PhcManf_DR=:manfid)
	.q:ManfType'="M"
	.s name=$p(^PHMNF(manfid),"^",2)
	.s code=$p(^PHMNF(manfid),"^",1)
	.s QuanPinAlias=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(name,3,"",50)
	.s Alias=code_"/"_name_"/"_##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(name,4)_"/"_QuanPinAlias
	.s count=count+1
	.&sql(update DHC_Manf_AddionInfo set MANF_Alias=:Alias where MANF_PhcManf_DR=:manfid)
	.i SQLCODE d
	..s ^TMP("UpdateManfAliasError",$zts,count)=manfid_"^"_name
	.e  d
	..w name_" 修改成功!" ,!
	..s num=num+1
	w "success:"_num,!
}

/// 老项目上线时生产厂家是在cs系统新建，没有对应的DHC_Manf_AddionInfo,需要对应添加
/// 2016-11-09
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).InssertManfAdd()	
ClassMethod InssertManfAdd() As %String
{
	new
	s num=0
	s manfid=0
	f   s manfid=$o(^PHMNF(manfid)) q:manfid=""  d
	.q:+manfid=0
	.s manfadd=""
	.s manfadd=$o(^DHCMANF(0,"MANF",manfid,0))
	.s type=..sssCode()
	.i manfadd="" d
	..&sql(insert into DHC_Manf_AddionInfo(MANF_PhcManf_DR,MANF_Type) values(:manfid,:type))
	..s num=num+1
	..w "manfid:"_manfid,!
	.
	w "success:"_num,!
}

/// 老项目中注册证号存于DHC_ItmAddionInfo的INFO_Remark中，需要同步到DHC_ItmRemark的IR_RegCertNo中
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).SetRegCertNo()
ClassMethod SetRegCertNo() As %String
{
	new
	s num=0
	s addinfo=0
	f  s addinfo=$o(^DHCITMINFO(addinfo)) q:addinfo=""  d
	.q:+addinfo=0
	.s inci="" ,stkcat="",type="",itmremark="",regcertno=""
	.s inci=$p(^DHCITMINFO(addinfo),"^",1)
	.s stkcat=$p(^INCI(inci,2),"^",2)
	.s:stkcat'="" type=$p(^INC("SC",stkcat),"^",3)
	.q:type'=..sssCode()
	.s regcertno=$p(^DHCITMINFO(addinfo),"^",10)
	.q:regcertno=""
	.s itmremark=$o(^ITMREK("INCI",inci,0))
	.i itmremark'="" d
	..&sql(update DHC_ItmRemark set IR_RegCertNo=:regcertno where %id=:itmremark)
	.e  d
	..&sql(insert into DHC_ItmRemark(IR_INCI_DR,IR_RegCertNo) values(:inci,:regcertno))
	.s num=num+1
	.w "inci:"_inci,!
	.
	w "success:"_num,!
}

/// 没有库存项附加表的物资信息插入对应的库存项附加表
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).UpDHCItmAddionInfo()
ClassMethod UpDHCItmAddionInfo() As %String
{
	new
	S num=0
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.s addinfo="" ,stkcat="" ,type="",incidesc=""
	.q:+inci=0
	.s addinfo=$o(^DHCITMINFO(0,"INCI",inci,""))
	.q:addinfo'=""
	.s stkcat=$p(^INCI(inci,2),"^",2)
	.s:stkcat'="" type=$p(^INC("SC",stkcat),"^",3)
	.q:type'="M"
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.&sql(insert into DHC_ItmAddionInfo(INFO_INCI_DR) values(:inci))
	.i SQLCODE'=0 d
	..S ^TMP("UpDHCItmAddionInfo",inci)=incidesc
	.s num=num+1
	.w inci ,!
	.
	q num
}

/// Descript:	更新dhc_incitmlcbt,cs程序切换到bs后,该表数据会有空缺,盘点时缺少数据
/// Table:		dhc_incitmlcbt
/// Input:		科室rowid
/// Output:		
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).UpdateDHCINCItmLcBt(149)
ClassMethod UpdateDHCINCItmLcBt(loc As %String) As %Library.String
{
	n (loc)
	q:loc="" ""
	s Active="Y"
	s count=0
	s num=0
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s incilCh=0
	.f  s incilCh=$o(^INCI(inci,"IL",incilCh)) q:incilCh=""  d
	..s locDr=$p($g(^INCI(inci,"IL",incilCh)),"^",1)
	..q:locDr'=loc
	..s inclbCh=0
	..f  s inclbCh=$o(^INCI(inci,"IL",incilCh,"LB",inclbCh)) q:inclbCh=""  d
	...s inclb=inci_"||"_incilCh_"||"_inclbCh
	...s dhcInclb=$o(^DHCINCLB(0,"LB",inclb,0))
	...q:dhcInclb'=""
	...s num=num+1
	...&sql(insert into DHC_IncItmLcBt(INCLB_LB_DR,INCLB_Active) values (:inclb,:Active))
	...s count=count+1
	
	w "total:"_num,!
	w "success:"_count,!
}

/// Descript:	检索库存不平的库存项(dhc_locdailytotal和inc_itmloc)
/// Table:		dhc_locdailytotal, inc_itmloc
/// Input:		科室rowid
/// Output:		
/// Call web_DHCSTMHUI_Tools.ExamineData_CheckINCITMLOC()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.ExamineData","CheckINCITMLOC","")
Query CheckINCITMLOC(loc As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "inci,inciCode,inciDesc,logQtyUom:%Float,locTotalUom:%Float,plusUom:%Float,locid,locdesc,Incil") [ SqlProc ]
{
}

ClassMethod CheckINCITMLOCExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	n (qHandle,loc,%session)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s dd=+$h
	s inci=0
	s locid=""
	f  s locid=$o(^INCI("IL_LOC",locid)) q:locid=""  d
	.q:(locid'=loc)&&(loc'="")
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.f  s inci=$o(^INCI("IL_LOC",locid,inci)) q:inci=""  d
	..s ch=0
	..f  s ch=$o(^INCI("IL_LOC",locid,inci,ch)) q:ch=""  d
	...s Incil=inci_"||"_ch
	...s logQty=$p(^INCI(inci,"IL",ch),"^",3)
	...s locTotal=##class(web.DHCSTMHUI.Common.DrugStkCommon).IL(inci,locid,dd)
	...i logQty'=locTotal d
	....s plus=logQty-locTotal
	....s inciCode=$p(^INCI(inci,1),"^",1)
	....s inciDesc=$p(^INCI(inci,1),"^",2)
	....s logQtyUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,logQty)
	....s locTotalUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,locTotal)
	....s plusUom=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyWithUom(inci,plus)
	....d OutPutUomRow
	
	Quit $$$OK
	
OutPutUomRow
	s Data=$lb(inci,inciCode,inciDesc,logQtyUom,locTotalUom,plusUom,locid,locdesc,Incil)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查dhc_locdailytotal和其子表中数据不平的数据
/// Table:		DHC_LocDailyTotal, DHC_LocBTDailyTotal
/// Input:		科室rowid
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.ExamineData","CheckLocDailyAndBT")
/// Call web_DHCSTMHUI_Tools.ExamineData_CheckLocDailyAndBT()
Query CheckLocDailyAndBT(loc As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "inciCode,inciDesc,qtyEnd:%Float,qtyBTEnd:%Float,locid,locdesc,Incil") [ SqlProc ]
{
}

ClassMethod CheckLocDailyAndBTExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	n (qHandle,loc,%session)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s inci=0
	s locid=0
	f  s locid=$o(^INCI("IL_LOC",locid)) q:locid=""  d
	.q:(loc'="")&&(locid'=loc)
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.f  s inci=$o(^DHCLOCTOT(0,"LOCITMDATE",locid,inci)) q:inci=""  d
	..s date=$o(^DHCLOCTOT(0,"LOCITMDATE",locid,inci,""),-1)
	..s rowid=$o(^DHCLOCTOT(0,"LOCITMDATE",locid,inci,date,""))
	..s qtyEnd=$p(^DHCLOCTOT(rowid),"^",4)
	..s il=$o(^INCI("IL_LOC",locid,inci,0))
	..q:il=""	;过滤垃圾数据
	..s incil=inci_"||"_il
	..s lb=0,qtyBTEnd=0
	..f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	...s inclb=incil_"||"_lb
	...s DayBTDate=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,""),-1)
	...s DayId=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,DayBTDate,""))
	...s ch=$o(^DHCBTLOCTOT(0,"INCLBDATE",inclb,DayBTDate,DayId,""))
	...s DayBTQty=$p(^DHCBTLOCTOT(DayId,"I",ch),"^",3)
	...s qtyBTEnd=qtyBTEnd+DayBTQty
	..i qtyEnd'=qtyBTEnd d
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
		
	...d OutPutCheckLoc
	
	Quit $$$OK
OutPutCheckLoc
	s Data=$lb(inciCode,inciDesc,qtyEnd,qtyBTEnd,locid,locdesc,Incil)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查inc_itmloc和其子表中数据不平的数据
/// Table:		inc_itmloc, inc_itmlcbt
/// Input:		科室rowid
/// Output:		
/// Call web_DHCSTMHUI_Tools.ExamineData_CheckINCItmLocAndBT()
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.ExamineData","CheckINCItmLocAndBT","163")
Query CheckINCItmLocAndBT(loc As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "inciCode,inciDesc,incilQty:%Float,inclbQtySum:%Float,locid,locdesc,Incil") [ SqlProc ]
{
}

ClassMethod CheckINCItmLocAndBTExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	n (qHandle,loc,%session)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s inci=0
	s locid=0
	f  s locid=$o(^INCI("IL_LOC",locid)) q:locid=""  d
	.q:(loc'="")&&(locid'=loc)
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.f  s inci=$o(^INCI("IL_LOC",locid,inci)) q:inci=""  d
	..s incsc=$p(^INCI(inci,2),"^",2)
	..q:incsc=""
	..s incscType=$p(^INC("SC",incsc),"^",3)
	..q:incscType'=..sssCode()
	..s ch=$o(^INCI("IL_LOC",locid,inci,""))
	..s incil=inci_"||"_ch
	..s incilQty=$p(^INCI(inci,"IL",ch),"^",3)
	..s inclbQtySum=0
	..s lb=""
	..f  s lb=$o(^INCI(inci,"IL",ch,"LB",lb)) q:lb=""  d
	...s lbQty=$p(^INCI(inci,"IL",ch,"LB",lb),"^",2)
	...s inclbQtySum=inclbQtySum+lbQty
	..i +incilQty'=+inclbQtySum d
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...d OutPutCheckINCItm
	Quit $$$OK
OutPutCheckINCItm
	s Data=$lb(inciCode,inciDesc,incilQty,inclbQtySum,locid,locdesc,Incil)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	检查inc_itmlcbt和dhc_locbtdailytotal数据不平的数据
/// Table:		inc_itmlcbt, dhc_locbtdailytotal
/// Input:		科室rowid
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.ExamineData","CheckLocBTAndDailyBT","163")
/// Call web_DHCSTMHUI_Tools.ExamineData_CheckLocBTAndDailyBT()
Query CheckLocBTAndDailyBT(loc As %String = "") As web.DHCSTMHUI.Query(ROWSPEC = "inclb,lbQty:%Float,dailyBTQty:%Float,locid,locdesc,Incil") [ SqlProc ]
{
}

ClassMethod CheckLocBTAndDailyBTExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	n (qHandle,loc,%session)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s inci=0
	s locid=0
	f  s locid=$o(^INCI("IL_LOC",locid)) q:locid=""  d
	.q:(locid'=loc)&&(loc'="")
	.s locdesc=$p(^CTLOC(locid),"^",2)
	.f  s inci=$o(^INCI("IL_LOC",locid,inci)) q:inci=""  d
	..s incsc=$p(^INCI(inci,2),"^",2)
	..q:incsc=""
	..s incscType=$p(^INC("SC",incsc),"^",3)
	..q:incscType'=..sssCode()
	..s ch=$o(^INCI("IL_LOC",locid,inci,""))
	..s incil=inci_"||"_ch
	..s incilQty=$p(^INCI(inci,"IL",ch),"^",3)
	..s lb=""
	..f  s lb=$o(^INCI(inci,"IL",ch,"LB",lb)) q:lb=""  d
	...s inclb=incil_"||"_lb
	...s lbQty=$p(^INCI(inci,"IL",ch,"LB",lb),"^",2)
	...s dailyBTQty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(inclb,+$h)
	...i +lbQty'=+dailyBTQty d
	
	....d OutPutCheckLocBT
	Quit $$$OK
OutPutCheckLocBT
	s Data=$lb(inclb,lbQty,dailyBTQty,locid,locdesc,Incil)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	处理cs切换到bs后的intr_rp,intr_rpamount信息, 避免月报数据错误
/// Table:		dhc_intrans
/// Input:		科室rowid
/// Output:		
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).HandleTransInfo(153,"2015-01-01")
ClassMethod HandleTransInfo(loc, sd) As %String
{
	n (loc,sd)
	q:loc="" ""
	i sd["-" s sd=$zdh(sd,3)
	q:sd="" ""
	s count=0
	s trTypeStr="G^T^K^R^A^D"			;处理台帐类型
	s trTypeLen=$l(trTypeStr,"^")
	f i=1:1:trTypeLen d
	.s trType=$p(trTypeStr,"^",i)
	.s trDate=sd
	.f  s trDate=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trType,trDate)) q:trDate=""  d
	..s trRowId=""
	..f  s trRowId=$o(^DHCINTR(0,"LOCTYPEDATE",loc,trType,trDate,trRowId)) q:trRowId=""  d
	...s trInfo=^DHCINTR(trRowId)
	...s trQty=$p(trInfo,"^",6)
	...s inclb=$p(trInfo,"^",7)
	...s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(+inclb)
	...s stkType=$p(scgInfo,"^",3)
	...q:stkType'=..sssCode()			;过滤非材料数据
	...s trUom=$p(trInfo,"^",10)
	...s trRp=$p(trInfo,"^",16)
	...s trRpAmt=$p(trInfo,"^",17)
	...q:(trRp'="")||(trRpAmt'="")		;已有数据的不处理
	...s inclbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetClbRp(inclb,trUom,"","")
	...s rpAmt=inclbRp*trQty
	...s count=count+1
	...&sql(update dhc_intrans set INTR_Rp=:inclbRp,INTR_RpAmount=:rpAmt where %id=:trRowId)
	...i SQLCODE d
	....s ^DHCSTTMP("HandleTransInfoError",$zts,count)=SQLCODE
	...e  d
	....s ^DHCSTTMP("HandleTransInfo",+$h,trType)=$g(^DHCSTTMP("HandleTransInfo",+$h,trType))_","_trRowId
}

/// 安贞专用(之前没有dhc_locdailytotal记录)
/// Descript:	将inc_itmloc库存信息, 同步到dhc_locdailytotal
/// Table:		dhc_locdailytotal
/// Input:		科室rowid(为空则处理全院)
/// Output:		
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).MakeUpDailyStk(301)
ClassMethod MakeUpDailyStk(Loc = "")
{
	n (Loc)
	s successCnt=0,cnt=0
	s inci=0
	f  s inci=$o(^INCI(inci)) q:inci=""  d
	.q:+inci=0
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.s stkType=$p(scgInfo,"^",3)
	.q:stkType'=..sssCode()			;过滤非材料数据
	.s il=0
	.f  s il=$o(^INCI(inci,"IL",il)) q:il=""  d
	..s locDr=$p($g(^INCI(inci,"IL",il)),"^",1)
	..q:(Loc'="")&&($g(locDr)'=Loc)
	..s cnt=cnt+1
	..s incil=inci_"||"_il
	..s ret=..MakeUpIncilDailyStk(incil)
	..i ret<0 d
	...s ^TMP("DHCSTM","LocItmStk",$j,incil)=ret
	..e  d
	...s successCnt=successCnt+1
	
	q cnt_","_successCnt
}

/// 安贞专用(之前没有dhc_locdailytotal记录)
/// Descript:	将inc_itmloc库存信息, 同步到dhc_locdailytotal
/// Table:		dhc_locdailytotal
/// Input:		incil
/// Output:		
/// w ##class(web.DHCSTMHUI.Tools.ExamineData).MakeUpIncilDailyStk("3888||1")
ClassMethod MakeUpIncilDailyStk(incil)
{
	n (incil)
	q:(incil="") -1
	s inci=$p(incil,"||",1),il=$p(incil,"||",2)
	q:il="" -1
	
	s $ZT="IncilError"
	s loc=$p(^INCI(inci,"IL",il),"^",1)
	s date=+$h
	s LogQty=$p(^INCI(inci,"IL",il),"^",3)
	ts
	s DayId=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,date,0))
	i DayId="" d
	.&sql(insert into dhc_locdailytotal (Day_Itm_DR,Day_Loc_DR,Day_QtyBeg,Day_QtyEnd,Day_Date) values (:inci,:loc,:LogQty,:LogQty,:date))
	.i SQLCODE s ret=$$IncilError(1)
	.e  s DayId=$p(%ROWID,$c(1))
	e  d
	.s $p(^DHCLOCTOT(DayId),"^",4)=LogQty
	
	i DayId="" tro  q -11
	
	s lb=0,Err=0
	f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:(lb="")!(Err'=0)  d
	.s lbQty=$p(^(lb),"^",2)
	.s inclb=incil_"||"_lb
	.s Chl=$o(^DHCBTLOCTOT(0,"LocBtDate",loc,inclb,date,DayId,0))	;;
	.i Chl="" d
	..s BTCh=+$o(^DHCBTLOCTOT(DayId,"I",""),-1)+1
	..&sql(insert into dhc_locbtdailytotal (DayBT_ParRef,DayBT_Bat_DR,DayBT_QtyBeg,DayBT_QtyEnd,DayBT_Childsub,DayBT_Date,DayBT_Loc_DR) values (:DayId,:inclb,:lbQty,:lbQty,:BTCh,:date,:loc))
	..i SQLCODE d
	...s ret=$$IncilError(2)
	...s Err=-1
	..e  s DayBT=$p(%ROWID,$c(1))
	.e  d
	..s $p(^DHCBTLOCTOT(DayId,"I",Chl),"^",3)=lbQty
	
	i Err'=0 tro  q -12
	tc
	
	q 0
	
IncilError(n)
	tro
	i n=1 d
	.s ^TMP("DHCSTM","LocDaily",$j,incil)=SQLCODE
	i n=2 d
	.s ^TMP("DHCSTM","LocBTDaily",$j,inclb)=SQLCODE
}

/// w ##class(web.DHCSTMHUI.Tools.ExamineData).CalLocInDaily()
ClassMethod CalLocInDaily()
{
	s loc=0
	s cnt=0
	f  s loc=$o(^DHCLOCTOT(0,"LOCITMDATE",loc)) q:loc=""  d
	.s cnt=cnt+1
	
	q cnt
}

/// Descript:	部分项目,因代码版本问题,出库单回滚错误后,留下子表数据
/// 			造成占用数据,还查询不到占用单据.
/// 			根据这个方法检索出initi,然后调用##class(web.DHCSTMHUI.DHCINIsTrfItm).Delete方法处理
/// Table:		dhc_inistrfitm
/// Input:		
/// Output:		
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckIniti()
ClassMethod CheckIniti()
{
	new
	s cnt=0
	s init=0
	f  s init=$o(^DHCINIT(init)) q:init=""  d
	.i $d(^DHCINIT(init))=10 d
	..s ch=0
	..f  s ch=$o(^DHCINIT(init,"ITI",ch)) q:ch=""  d
	...s qty=$p(^(ch),"^",1)
	...s inclb=$p(^(ch),"^",3)
	...s uom=$p(^(ch),"^",7)
	...s buom=$p(^INCI(+inclb,1),"^",10)
	...s uomfac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,buom)
	...s qty = qty*uomfac
	...s incicode=$p(^INCI(+inclb,1),"^",1)
	...s initi=init_"||"_ch
	...w initi,?15,incicode,?45,qty,?55,inclb,!
}

/// Descript:	检索材料入库单,核实入库单上的价格信息是否能对应dhc_incitmbat上的BRp
/// 					入库审核生成批次的地方,可能会发生此bug
/// Creator:	wangjiabin
/// CreateDate:	2016-09-23
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckIngrRp()
ClassMethod CheckIngrRp() As %String
{
	new
	&sql(declare CheckIngrCursor cursor for
		select %id,INGRI_CTUOM_DR,initm_realprice,INGRI_INCIB_DR from dhc_ingdrecitm
		where ingri_ingr_parref->ingr_stktype='M' and ingri_inclb_dr is not null)
	&sql(open CheckIngrCursor)
	f  &sql(fetch CheckIngrCursor into :ingri,:uom,:rp,:incib) q:SQLCODE  d
	.s inci=$p(incib,"||",1)
	.q:inci=""
	.s BUomId=$p(^INCI(inci,1),"^",10)
	.s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uom,BUomId)
	.s BRp=rp/UomFac
	.s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcIncib=""
	.s IncibBRp=$p(^DHCINCIB(dhcIncib),"^",3)
	.i IncibBRp'=BRp w ingri,!
	.
	&sql(close CheckIngrCursor)
}

/// Descript:	项目上线前(清数据后),检查一些表内的数据残留情况
/// 			有其他表需要核实的,请及时补充
/// Creator:	wangjiabin
/// CreateDate:	2017-05-10
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckGloablAfterClear()
ClassMethod CheckGloablAfterClear()
{
	new
	
	/*
	dhc_inpo,dhc_inrequest,dhc_inreqitm等其他附属表检查.
	dhc_manf_addioninfo, dhc_stvendor
	dhc_incitmlcbt,dhc_incitmbat,dhc_incitmloc
	*/
	;i $d(^DHCINPO)		w "dhc_inpo",!
	&sql(SELECT %id FROM dhc_inpo WHERE PO_INPO_DR->inpo_no IS null)
	i SQLCODE=0 w "dhc_inpo",! 
	
	;i $d(^DHCINRQ)		w "dhc_inrequest",!
	&sql(SELECT %id FROM dhc_inrequest WHERE INRQ_INRQ_DR->inrq_no IS NULL)
	i SQLCODE=0 w "dhc_inrequest",!
	
	;i $d(^DHCINRQI)		w "dhc_inreqitm",!
	&sql(SELECT %id FROM dhc_inreqitm WHERE INRQI_INRQI_DR->inrqi_childsub IS NULL)
	i SQLCODE=0 w "dhc_inreqitm",!
	
	;i $d(^DHCMANF)		w "dhc_manf_addioninfo",!
	&sql(SELECT %id FROM dhc_manf_addioninfo WHERE MANF_PhcManf_DR->phmnf_code IS NULL)
	i SQLCODE=0 w "dhc_manf_addioninfo",!
	
	;i $d(^DHCSTV)		w "dhc_stvendor",!
	&sql(SELECT %id FROM DHC_STVendor WHERE STV_Vendor_DR->apcvm_code IS NULL)
	i SQLCODE=0 w "dhc_stvendor",!
	
	;i $d(^DHCINCLB)		w "dhc_incitmlcbt",!
	&sql(SELECT %id FROM dhc_incitmlcbt WHERE INCLB_LB_DR->inclb_childsub IS NULL)
	i SQLCODE=0 w "dhc_incitmlcbt",!
	
	;i $d(^DHCINCIB)		w "dhc_incitmbat",!
	&sql(SELECT %id FROM dhc_incitmbat WHERE INCIB_INCIB_Dr->incib_childsub IS NULL)
	i SQLCODE=0 w "dhc_incitmbat",!
	
	;i $d(^DHCINCIL)		w "dhc_incitmloc",!
	&sql(SELECT %id FROM dhc_incitmloc WHERE INCIL_INCIL_DR->incil_childsub IS NULL)
	i SQLCODE=0 w "dhc_incitmloc",!
	
	
	/*
	DHC_PlanAudit
	DHC_PlanStatus
	DHC_StkMonStatIn -月报附加表(进价)
		DHC_INASP_Detail -调价生效记录表
		IN_AdjPriceBatch -批次调价表
		APC_VendCat -供应商分类表
	  DHC_Carrier -配送商
	DHC_HVMat_ItmCheckList -物资对照信息表
	DHC_HVMat_LocCheckList -科室对照信息表
	DHC_VendorInv -供应商发票组合主表
	DHC_HVMAT_OrdItm -高值医嘱提取表
	APC_VendorAddionInfo
	*/
	
	i $d(^DHCPA)		w "DHC_PlanAudit",!
	i $d(^DHCPS)		w "DHC_PlanStatus",!
	i $d(^SMSTATIM)		w "DHC_StkMonStatIn",!
	i $d(^DHCINASPD)	w "DHC_INASP_Detail",!
	i $d(^APC("APCVC")) w "APC_VendCat",!
	i $d(^DHCCARR)		w "DHC_Carrier",!
	i $d(^DHCHVMIL)		w "DHC_HVMat_ItmCheckList",!
	i $d(^DHCHVMLL)		w "DHC_HVMat_LocCheckList",!
	i $d(^DHCVendorInv)	w "DHC_VendorInv",!
	i $d(^DHCHVMORI)	w "DHC_HVMAT_OrdItm",!
	i $d(^APCVENDORINFO) w "APC_VendorAddionInfo",!
	i $d(^DHCILT) 		w "DHC_InciLinkTar",!
	i $d(^DHCSTVH)   w "DHC_STVendor_History",!
}

/// 获取inclb对应的可用高值条码数量
/// 批次数量和条码数量不一致的, write出来
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckLocBarcodes(153)
ClassMethod CheckLocBarcodes(LocId As %String) As %Library.String
{
	n (LocId)
	q:LocId="" ""
	s count=0,NotEqualCount=0
	s inci=0
	f  s inci=$o(^INCI("IL_LOC",LocId,inci)) q:inci=""  d
	.s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	.q:HVFlag'="Y"
	.s InciCode=$p(^INCI(inci,1),"^",1)
	.s InciDesc=$p(^INCI(inci,1),"^",2)
	.s il=0
	.f  s il=$o(^INCI("IL_LOC",LocId,inci,il)) q:il=""  d
	..s incil=inci_"||"_il
	..s lb=0
	..f  s lb=$o(^INCI(inci,"IL",il,"LB",lb)) q:lb=""  d
	...s Incib=$p(^(lb),"^",1)
	...s lbQty=$p(^(lb),"^",2)
	...s inclb=incil_"||"_lb
	...s lbBarcodeQty=..GetEnableQty(inclb)
	...s count=count+1
	...
	...i +lbQty'=lbBarcodeQty d
	....s NotEqualCount=NotEqualCount+1
	....w inclb,?15,Incib,?40,lbQty,?45,lbBarcodeQty,?50,!
	
	w !,count_","_NotEqualCount
}

/// w ##class(web.DHCSTMHUI.Tools.ExamineData).GetEnableQty("8749||2||10")
/// 获取inclb对应的可用高值条码数量
ClassMethod GetEnableQty(INCLB As %String) As %Library.String
{
	n (INCLB)
	q:INCLB="" 0
	s inci=+INCLB,il=$p(INCLB,"||",2),lb=$p(INCLB,"||",3)
	q:lb="" 0
	s INCIL=$p(INCLB,"||",1,2)		;参数传入incil或inclb,要处理一下
	s count=0
	s dhcit=0
	f  s dhcit=$o(^DHCIT(0,"INCI",inci,dhcit)) q:dhcit=""  d
	.
	.s inclb=$p(^DHCIT(dhcit),"^",12)
	.q:(inclb'=INCLB)
	.
	.s status=$p(^DHCIT(dhcit),"^",5)
	.
	.s lastAudit=""
	.i (status="Return")||(status="InScrap")||(status="InAdj") d
	..s lastCh=+$o(^DHCITD(dhcit,"I",""),-1)
	..i +lastCh>0 d
	...s lastChInfo=##class(web.DHCSTMHUI.DHCItmTrack).IsDetailAudit(dhcit_"||"_lastCh)
	...s lastAudit=$p(lastChInfo,"^",1)
	.q:((status="Return")||(status="InScrap")||(status="InAdj"))&&(lastAudit="Y")
	.;q:status'="Enable"
	.q:(status="")||(status="Used")
	.s count=count+1
	
	q count
}

/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckHVIntr("858||2||13")
ClassMethod CheckHVIntr(Inclb) As %String
{
	n (Inclb)
	q:Inclb="" -1
	s Date=0
	f  s Date=$o(^DHCINTR(0,"INCLB",Inclb,Date)) q:Date=""  d
	.s Intr=0
	.f  s Intr=$o(^DHCINTR(0,"INCLB",Inclb,Date,Intr)) q:Intr=""  d
	..s IntrType=$p(^DHCINTR(Intr),"^",1)
	..s IntrPointer=$p(^DHCINTR(Intr),"^",9)
	..s IntrQty=$p(^DHCINTR(Intr),"^",6)
	..s DHCIT=$o(^DHCITD(0,"Type",IntrType,"Pointer",IntrPointer,0))
	..i (DHCIT="")||(IntrQty'=1) w "'"_Intr_"',",!
}

/// Descript:	项目升级后，月报类型处理
/// CreateDate:	2020-03-14
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).UpdateStkMonStkType()
ClassMethod UpdateStkMonStkType() As %String
{
	new
	s Count=0
	s SM=0
	f  s SM=$o(^DHCSM(SM)) q:SM=""  d
	.s StkType=$p(^DHCSM(SM),"^",27)
	.q:StkType'=""
	.
	.q:'$d(^DHCSM(SM,"R"))
	.
	.s Ch=$o(^DHCSM(SM,"R",0))
	.q:Ch=""
	.s Inci=$p(^DHCSM(SM,"R",Ch),"^",3)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'=..sssCode()
	.s Obj=##class(User.DHCStkMon).%OpenId(SM)
	.s Obj.DHCSMStkType=..sssCode()
	.s Sc=Obj.%Save()
	.q:$$$ISERR(Sc)
	.s Count=Count+1
	.w SM_","
	
	w !,"共处理月报份数:"_Count
}

/// 根据dhc_locdailytotal数据同步库存--清除global后有inc_itmloc的库存数据遗留(^INCI global)
/// ^INCI(***,"IL"), ^INCI(***,"IB")
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).SynStkQty()
ClassMethod SynStkQty()
{
	new
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",5)
	.q:StkType'="M"		;是否过滤耗材的
	.
	.s IL=0
	.f  s IL=$o(^INCI(Inci,"IL",IL)) q:IL=""  d
	..s Incil=Inci_"||"_IL
	..s Ret=##class(web.DHCSTMHUI.LocItmStk).SynIncilStkQty(Incil)
}

/// 核实dirty>0的批次, 占用数量是否正常
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckDirtyQty()
ClassMethod CheckDirtyQty()
{
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s ScgType=$p(ScgInfo,"^",3)
	.q:ScgType'="M"
	.s BUomId=$p(^INCI(Inci,1),"^",10)
	.s incicode=$p(^INCI(Inci,1),"^",1)
	.s incidesc=$p(^INCI(Inci,1),"^",2)
	.s IL=0
	.f  s IL=$o(^INCI(Inci,"IL",IL)) q:IL=""  d
	..s Incil=Inci_"||"_IL
	..s LB=0
	..f  s LB=$o(^INCI(Inci,"IL",IL,"LB",LB)) q:LB=""  d
	...s Inclb=Incil_"||"_LB
	...s DirtyQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	...q:DirtyQty'>0
	...
	...s InclbDirtyQty=0
	...s init=""
	...f  s init=$o(^DHCINIT(0,"INCLB",Inclb,init)) q:init=""  d
	....s stat=$p($g(^DHCINIT(init)),"^",14)
	....q:(stat=21)!(stat=31)!(stat=99)
	....s trno=$p($g(^DHCINIT(init)),"^",1)
	....s trdate=$p($g(^DHCINIT(init)),"^",2)
	....s trdate=..DL2H(trdate)
	....s chl=""
	....f  s chl=$o(^DHCINIT(0,"INCLB",Inclb,init,chl))  q:chl=""  d
	.....s tmpinci=+Inclb
	.....s rowid=init_"||"_chl
	.....s qty=$p(^DHCINIT(init,"ITI",chl),"^",1)
	.....s uomdr=$p(^DHCINIT(init,"ITI",chl),"^",7)
	.....s UomFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(uomdr,BUomId)
	.....s qtyBUom=qty*UomFac
	.....s InclbDirtyQty=InclbDirtyQty+qtyBUom
	...i InclbDirtyQty'=DirtyQty w Inclb_$c(9)_InclbDirtyQty_$c(9)_DirtyQty,!
}

/// 检查dhc_itmremark中的数据, 是否都在dhc_matregcert中创建
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckCertAndItmRemark()
ClassMethod CheckCertAndItmRemark()
{
	new
	s Count=0
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'=..sssCode()
	.s IR=$o(^ITMREK("INCI",Inci,0))
	.q:IR=""
	.s RegNo=$p(^ITMREK(IR),"^",11)
	.q:RegNo=""
	.q:(RegNo["无")||(RegNo["非")||($l(RegNo)<6)
	.q:$d(^DHCMRCT(0,"NO",RegNo))		;存在
	.
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.w Inci_","_InciCode_","_InciDesc_","_RegNo,!
	.s Count=Count+1
	
	w !,!,"共"_Count_"个",!
}

/// 检查dhc_itmremark中存在数据, 但在库存项中未建立关联的数据
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).CheckCertAndItmRemark2()
ClassMethod CheckCertAndItmRemark2()
{
	new
	s Count=0
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'=..sssCode()
	.s IR=$o(^ITMREK("INCI",Inci,0))
	.q:IR=""
	.s RegNo=$p(^ITMREK(IR),"^",11)
	.q:RegNo=""
	.q:(RegNo["无")||(RegNo["非")||($l(RegNo)<6)
	.s RegCertId=$o(^DHCMRCT(0,"NO",RegNo,""))
	.
	.s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	.s InfoCertId=$s(Info'="":$p($g(^DHCITMINFO(Info,1)),"^",18),1:"")
	.q:(InfoCertId'="")
	.
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.w Inci_","_InciCode_","_InciDesc_","_RegNo,!
	.s Count=Count+1
	
	w !,!,"ItmRemark表中的信息, 在库存项附加表内有缺失, 共"_Count_"个",!
}

/// 批量处理dhc_itmremark中的注册证数据,将其转换到DHC_MatRegCert,并建立库存项关联
/// d ##class(web.DHCSTMHUI.Tools.ExamineData).HandleCertInItmRemark()
ClassMethod HandleCertInItmRemark()
{
	new
	s Count=0,SuccCnt=0
	
	s Inci=0
	f  s Inci=$o(^INCI(Inci)) q:Inci=""  d
	.q:+Inci'>0
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkType=$p(ScgInfo,"^",3)
	.q:StkType'=..sssCode()
	.s IR=$o(^ITMREK("INCI",Inci,0))
	.q:IR=""
	.s RegNo=$p(^ITMREK(IR),"^",11)
	.q:RegNo=""
	.q:(RegNo["无")||(RegNo["非")||($l(RegNo)<6)			;过滤一些特殊值: 如"无","非医疗器械"
	.
	.s RegCertDateOfIssue=$p(^ITMREK(IR),"^",24)
	.s IRRegCertExpDate=$p(^ITMREK(IR),"^",12)
	.s RegCertItmDesc=$p(^ITMREK(IR),"^",16)
	.
	.
	.s Info=$o(^DHCITMINFO(0,"INCI",Inci,0))
	.s InfoCertId=$s(Info'="":$p($g(^DHCITMINFO(Info,1)),"^",18),1:"")
	.q:(InfoCertId'="")
	.
	.s ManfInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbManf(Inci)
	.s PbManfId=$p(ManfInfo,"^",1)
	.s Count=Count+1
	.
	.ts
	.s RegCertId=$o(^DHCMRCT(0,"NO",RegNo,""))
	.s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	.i RegCertId="" d
	..;新建DHC_MatRegCert数据
	..s regTitle="MRCNo^MRCApprovalDate^MRCValidUntil^MRCInciDesc"
	..s regData=RegNo_"^"_RegCertDateOfIssue_"^"_IRRegCertExpDate_"^"_RegCertItmDesc
	..s regObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(regData,regTitle)
	..s paramstr=Inci_"^"_PbManfId
	..s RtnObj=##class(web.DHCSTMHUI.DHCMatRegCert).save(regObj,paramstr)
	..q:RtnObj.success<0
	..s RegCertId=RtnObj.rowid
	.i RtnObj.success<0 tro  q
	.
	.s InfoObj=##class(User.DHCItmAddionInfo).%OpenId(Info)
	.s InfoObj.INFOMatRegCertDR=RegCertId
	.s Sc=InfoObj.%Save()
	.i $$$ISERR(Sc) tro  q
	.
	.tc
	.s SuccCnt=SuccCnt+1
	
	w !,!,"ItmRemark表中的信息, 在库存项附加表内有缺失, 共"_Count_"个,处理"_SuccCnt_"个",!
}

/// Descript:检查高值医嘱(减库存不成功的部分)
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.Tools.ExamineData","CheckHVOrd","2021-05-01","2021-08-31")
/// Call web_DHCSTMHUI_Tools.ExamineData_CheckHVOrd("2021-05-01","2021-08-31")
/// 
Query CheckHVOrd(StartDate, EndDate, RecLocId = "") As websys.Query(ROWSPEC = "Oeori,BarCode")
{
}

ClassMethod CheckHVOrdExecute(ByRef qHandle As %Binary, StartDate, EndDate, RecLocId = "") As %Status
{
	n (qHandle,StartDate,EndDate,RecLocId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	
	f Date=StartDate:1:EndDate d
	.s Oeord=0
	.f  s Oeord=$o(^OEORDi(0,"ItemDate",Date,Oeord)) q:Oeord=""  d
	..q:'$d(^OEORD(Oeord))
	..s PaAdm=$p(^OEORD(Oeord),"^",1)
	..s Ch=0
	..f  s Ch=$o(^OEORDi(0,"ItemDate",Date,Oeord,Ch)) q:Ch=""  d
	...q:'$d(^OEORD(Oeord,"I",Ch))
	...s Oeori=Oeord_"||"_Ch
	...q:'$d(^OEORD(Oeord,"I",Ch,"DHC"))
	...s BarCode=$p(^OEORD(Oeord,"I",Ch,"DHC"),"^",14)
	...q:BarCode=""
	...;s:BarCode["*" BarCode=$p(BarCode,"*",2)
	...;q:$d(^DHCHVMORI(0,"BARCODE",BarCode))	;有dhc_hvmat_orditm的,过滤
	...q:$d(^DHCHVMORI(0,"OEORI",Oeori))
	...
	...s ostat=$p(^OEORD(Oeord,"I",Ch,1),"^",13)	;医嘱状态id
	...s oeflag=$p(^OEC("OSTAT",ostat),"^",1)
	...q:(oeflag="C")||(oeflag="U")||(oeflag="D")	;撤销,作废,停止 的医嘱不再处理
	...
	...s RecLoc=$p(^OEORD(Oeord,"I",Ch,3),"^",6)
	...q:(RecLocId'="")&&(RecLocId'=RecLoc)			;医嘱接收科室
	...s RecLocDesc=$p(^CTLOC(RecLoc),"^",2)
	...
	...;q:$d(^DHCITD(0,"Type","F","Pointer",Oeori))
	...;q:$d(^DHCITD(0,"Type","P","Pointer",Oeori))
	...
	...s AdmType=$p($g(^PAADM(PaAdm)),"^",2)
	...;q:AdmType'="O"	;仅显示门诊
	...
	...s Billed=$p(^OEORD(Oeord,"I",Ch,3),"^",5)
	...q:Billed'="P"	;仅显示已计费
	...d OutPutRow
	Quit $$$OK
OutPutRow
	s Data=$lb(Oeori,BarCode)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
