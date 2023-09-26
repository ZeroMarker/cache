Class web.DHCDocAppointmentHui Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// desc 输出界面日历
/// w ##class(web.DHCDocAppointmentHui).getcalenderHtml("",1633,"Y","DOC",11103)
ClassMethod getcalenderHtml(menthdate, rbasdr, AppMethCode, CanAddApponit, USERID) As %String
{
	;s ^lxz111=menthdate_","_rbasdr_","_AppMethCode_","_CanAddApponit_","_USERID
	;---------进行日历输出
	//传入选中得月 2018-05-01
	Set langid=..%LanguageID()
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s:menthdate="" menthdate=$ZD(+$H,3)
	s begindate=$P(menthdate,"-",1)_"-"_$P(menthdate,"-",2)_"-"_"01"
	s findmeth=+$P(menthdate,"-",2)
	s findyear=+$P(menthdate,"-",1)
	s week=$ZD($ZDH(begindate,3),10)
	s:week=0 week=7
	s NowDate=$ZD(+$H,3)
	s mothval=findyear_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","年-")_findmeth_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","月")	
	s holidaycolor="#e3f7ff" ;假日颜色
	s outmethcolor="#e2ffde" ;非本月颜色
	s nowmothcolor="#ffeedc" ;本月颜色
	s nowdatecolor="#e8edff" ;当日颜色
	s yesdatecolor="#f4f4f4" ;小于当日的无效日期
	
	;按照循环走开始日期和结束日期
	s fbdate=($ZDH(begindate,3)-week+1)
	s fedate=($ZDH(begindate,3)-week+42)
	s html="<table class='calenderTableClass'>"
	s html=html_"<tr>"
	s html=html_"<td><a class='hisui-linkbutton l-btn l-btn-small' id='upmoth' href='#' data-options='iconCls:'icon-w-arrow-up'' group=''><span class='l-btn-left l-btn-icon-left'><span class='l-btn-text'>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","上月")_"</span><span class='l-btn-icon icon-w-arrow-up'>&nbsp;</span></span></a></td>"
	s html=html_"<td><a class='hisui-linkbutton l-btn l-btn-small' id='downmoth' href='#' data-options='iconCls:'icon-w-arrow-down'' group=''><span class='l-btn-left l-btn-icon-left'><span class='l-btn-text'>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","下月")_"</span><span class='l-btn-icon icon-w-arrow-down'>&nbsp;</span></span></a></td>"
	s html=html_"<td><a class='hisui-linkbutton l-btn l-btn-small' id='nowmoth' href='#' data-options='iconCls:'icon-w-back'' group=''><span class='l-btn-left l-btn-icon-left'><span class='l-btn-text'>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","本月")_"</span><span class='l-btn-icon icon-w-back'>&nbsp;</span></span></a></td>"
	s html=html_"<td colspan=3 style=''><div id='ColorSynopsis'><span id= 'holidaycolor' style='background-color:#e3f7ff'></span><span id= 'outmethcolor' style='background-color:#e2ffde'></span>"
	s html=html_"<span id= 'nowmothcolor' style='background-color:#ffeedc'></span><span id= 'nowdatecolor' style='background-color:#e8edff'></span><span id= 'yesdatecolor' style='background-color:#f4f4f4'></span></div></td>"
	s html=html_"<td id='moth' style='font-weight:bold;height:15px;'>"_mothval_"</td>"
	s html=html_"<tr>"

	;s html=html_"<tr><td colspan=7><hr width=""630px"" color=""red""></td></tr>"
	s html=html_"<tr><td colspan=7></td></tr>"
	s html=html_ "<tr><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期一")_"</th><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期二")_"</th><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期三")_"</th>"
	s html=html_ "<th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期四")_"</th><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期五")_"</th><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期六")_"</th><th>"_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","星期日")_"</th></tr>"
	
	s Canstop=0
	s sub1=0
	for subdate=fbdate:1:fedate q:Canstop=1  d  
	.;s HoliFlag=##Class(web.DHCDocOrderCommon).IsHolidayFlag(subdate,..%ZTH("12:00"))
	.;s HoliFlag=##class(web.DHCOPRegFestivalSet).CheckDayIsFestival(subdate)
	.s HoliFlagGet=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(subdate,"","",HospID) 
	.s HoliFlag=HoliFlagGet
	.s datefdesc=""
	.s:HoliFlagGet=1 datefdesc=##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","假")
	.s:(($ZD(subdate,10)=0)||($ZD(subdate,10)=6)) HoliFlag=1
	.i (HoliFlagGet=0)&&((($ZD(subdate,10)=0)||($ZD(subdate,10)=6))) d
	..s datefdesc=##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","班")
	.if HoliFlagGet=2 d 
	..s datefdesc=##class(web.DHCBL.CT.BDPHoliday).GetHolidayDesc(subdate) 
	..;s datefdesc=##class(websys.Translation).Get("dhcdoc.appointment.hui.csp",datefdesc)
	..s datefdesc=##class(User.BDPHoliday).GetTranByDesc("BDPHDDesc",datefdesc,langid)
	.s outdatestr=$ZD(subdate,3)
	.s Year=+$P(outdatestr,"-",1)
	.s outmeth=+$P(outdatestr,"-",2)
	.s outdate=+$P(outdatestr,"-",3)
	.if sub1=0  d
	..if (outmeth>findmeth)&(Year=findyear)  s Canstop=1 q ;超出当前月处理
	..if (outmeth<findmeth)&(Year>findyear)  s Canstop=1 q ;超出当前月处理
	..s html=html_ "<tr>"
	.Q:Canstop=1
	.if (outmeth)'=(findmeth) d
	..if ((HoliFlag=1)||(HoliFlag=2)) {s color=holidaycolor}else{s color=outmethcolor}
	.else  d
	..if ((HoliFlag=1)||(HoliFlag=2)) {s color=holidaycolor}else{s color=nowmothcolor}
	.s fontcolor="#000000"
	.if (subdate<+$H) s color=yesdatecolor s fontcolor="#999999"
	.if (+$H=subdate)  d
	..s color=nowdatecolor s fontcolor="#1378b8"
	.
	.s html=html_ "<td><button id='"_subdate_"'style='background-color:"_color_"'  onclick='calendersearce("_subdate_")' ondblclick='calendersearceAppoint("_subdate_")' >"
	.s html=html_ "<div style='left:0px;top:0px;position:relative'>"
	.s html=html_ "<table class='OneCalenTable'>"
	.s html=html_ "<tr><td align='left'  style='color:"_fontcolor_";font-weight: 500;'><div id=D"_subdate_">"_outdate_"</div</td></tr>" //_##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","号")
	.s html=html_ "<tr><td style='font-weight:bold;color:#e87400'>"_..GetOneDateDis(rbasdr,subdate,AppMethCode,CanAddApponit,USERID)_"</td></tr>"
	.s html=html_ "</table>"
	.;背景层
	.if (datefdesc=##class(websys.Translation).Get("dhcdoc.appointment.hui.csp","班")) s html=html_"<div style='right:0px;top:0px;position:absolute;z-index:2;color:#8A6ED9;font-weight:bold'>"_datefdesc_"</div>" 
	.e  s html=html_"<div style='right:0px;top:0px;position:absolute;z-index:2;color:#3c763d;font-weight:bold'>"_datefdesc_"</div>" 
	.s html=html_"</div>"
	.s html=html_"</button></td>"
	.s sub1=sub1+1
	.if sub1=7  d
	..s html=html_ "</tr>"
	..s sub1=0	
	..if ((outmeth>findmeth)&(Year=findyear)) s Canstop=1 ;超出当前月处理
	..if (outmeth<findmeth)&(Year>findyear) s Canstop=1 ;超出当前月处理

	s html=html_ "</table>"
	
	s nowmoth=begindate
	
	q html_"^"_nowmoth
}

/// 获取某天的日历内容
/// w ##class(web.DHCDocAppointmentHui).GetOneDateDis(1,64876,"DOC","Y",6)
/// 2018-08-01,1,DOC,Y,6"
ClassMethod GetOneDateDis(rbasdr, onedate, AppMethCode, CanAddApponit, USERID) As %String
{

	s style="font-size:10px"
	
	;只有在预约周期内的才可以查询资源
	s fromfate=..%SysDate()
	s enddate=..%SysDate()
	s AppDaysLimit=##class(web.DHCOPRegConfig).GetSpecConfigNode("AppDaysLimit")
	s:AppDaysLimit="" AppDaysLimit=60
	s enddate=(enddate+AppDaysLimit)
	Set langid=..%LanguageID()
	;小于当前日期的查询本人预约记录
	s canfind="N"
	if (((onedate>=fromfate)&&(onedate<=enddate))||(onedate<fromfate)) d
	.s canfind="Y"
	
	k ListMesag
	if ((rbasdr'="")&(onedate'="")&(canfind="Y"))  d
	.s sessstarttime=""
	.f  s sessstarttime=$O(^RBAS(rbasdr,0,"DateSTime",onedate,sessstarttime)) q:sessstarttime=""  d
	..s childsub=0
	..f  s childsub=$O(^RBAS(rbasdr,0,"DateSTime",onedate,sessstarttime,childsub)) q:childsub=""  d
	...s asdate=$p($g(^RBAS(rbasdr,childsub)),"^",1)
 	...s ASStopRegNoFlag=$P($G(^RBAS(+rbasdr,childsub,"DHC")),"^",27) //停正号
 	...q:(ASStopRegNoFlag="Y")&&(asdate>+$h)
	...s sttime=$p($g(^RBAS(rbasdr,childsub)),"^",4)
	...s endtime=$p($g(^RBAS(rbasdr,childsub)),"^",5)
	...s trrowid=$P($G(^RBAS(+rbasdr,childsub,"DHC")),"^",17)
	...s trdesc=""
	...s:trrowid'="" trdesc=$P($G(^DHCTimeRange(trrowid)),"^",2)
	...Q:trdesc=""
	...s trdesc=##class(User.DHCTimeRange).GetTranByDesc("TRDesc",trdesc,langid)
	...s statudr=$P($G(^RBAS(rbasdr,childsub,"DHC")),"^",10)
	...s (statu,statudesc)=""
	...s:statudr'="" statu=$P($G(^DHCRBCASStatus(statudr)),"^",1)
	...s:statudr'="" statudesc=$P($G(^DHCRBCASStatus(statudr)),"^",2)
	...Q:(statu="S")||(statu="TR")||(statu="PS")||(statu="AUD")
	...;默认是不找不规则出诊记录的
	...s ASIrregularFlag=$p($g(^RBAS(rbasdr,childsub)),"^",13)
	...Q:ASIrregularFlag="A"
	...s asqueno=$P(^RBAS(rbasdr,childsub,"DHC"),"^",4)
	...s NormalQueueNoStr=$P(asqueno,$C(1),1)
	...s AddQueueNoStr=$P(asqueno,$C(1),2)
	...s AddMesage=$$GetAddSeqMesage() ;获取加号信息
	...s NormalMesage=$$getNormalMesage() ;获取正号预约信息
	...s AppMesage=$$FindUserApp() ;获取预约数量
	...if (onedate<+$H)  d
	....s:AppMesage'="" ListMesag(trdesc,rbasdr_"||"_childsub)=trdesc_"^"_AppMesage_"^"_"N"
	...else  if onedate=..%SysDate()  d
	....s:AddMesage'="" ListMesag(trdesc,rbasdr_"||"_childsub)="+"_trdesc_"^"_AddMesage_"^"_"Y"
	...else  d
	....s:NormalMesage'="" ListMesag(trdesc,rbasdr_"||"_childsub)=trdesc_"^"_NormalMesage_"^"_"Y"
	
	s nummes=0
	s rtnmesage=""
	s listsub1=0
	f  s listsub1=$O(ListMesag(listsub1)) Q:listsub1=""  d
	.s listsub2=0
	.f  s listsub2=$O(ListMesag(listsub1,listsub2)) Q:listsub2=""  d
	..s rbschdel=listsub2
	..s trdesc=$P($G(ListMesag(listsub1,listsub2)),"^",1)
	..s mesage=$P($G(ListMesag(listsub1,listsub2)),"^",2)
	..s canApp=$P($G(ListMesag(listsub1,listsub2)),"^",3)
	..s onemesage=trdesc_":"_mesage
	..s rtnmesage=rtnmesage_"<div id="_"T"_onedate_" rbasdr="_rbschdel_" canApp="_canApp_" style='"_style_"'>"_onemesage_"</div>"
	..s nummes=nummes+1
	
	if nummes<3  d
	.f imes=1:1:(3-nummes) d
	..s rtnmesage=rtnmesage_"<div>&nbsp</div>"
	
	q rtnmesage
FindUserApp()	
	;返回自己预约的记录
	s FinAPP=0
	s ApptChild=0
	for  s ApptChild=$O(^RBAS(rbasdr,childsub,"APPT",ApptChild)) q:ApptChild=""  d
	.s ApptData=$g(^RBAS(rbasdr,childsub,"APPT",ApptChild))
	.s TransUserDR=$P(ApptData,"^",11)
	.Q:(TransUserDR'=USERID)&&(USERID'="") //只查询医生自己预约的号
	.s ApptPapmiDr=$p(ApptData,"^",2)
	.;不显示非诊间预约和诊间加号的
	.s MethodDR=$P(ApptData,"^",12)
	.s MethodDesc="",MethodCode=""
	.i MethodDR'="" s MethodDesc=$P(^RBC("APTM",MethodDR),"^",2),MethodCode=$P(^RBC("APTM",MethodDR),"^",1)
	.;Q:(("^"_AppMethCode_"^")'[("^"_MethodCode_"^"))
	.i ApptPapmiDr'="" s PAPERName= $p($g(^PAPER(ApptPapmiDr,"ALL")),"^",1)
	.s ApptStatus=$p(ApptData,"^",3)
	.Q:(ApptStatus'="I")&&(ApptStatus'="A")&&(ApptStatus'="J")
	.s FinAPP=FinAPP+1	
	Q:FinAPP=0 ""
	q FinAPP
getNormalMesage()
	;正号串中预约情况 返回 总数-已用-剩余
	/*for QueNoIndex=1:1:$l(NormalQueueNoStr,",") {
 		s SingleQueueNoStr=$P(NormalQueueNoStr,",",QueNoIndex)
 		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
 		s QueueNo=$P(SingleQueueNoStr,":",1)
 		s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
 		s QueueNoInAppFlag=+..CheckQueueNoInApp(rbasdr_"||"_childsub,QueueNo,AppMethCode)
 		continue:QueueNoInAppFlag'=1
 		s AllAppNum=AllAppNum+1
 		if (QueueNoStatus=0){
		 	s CanDo=CanDo+1
		}else{
	 		s ArriveCount=ArriveCount+1
	 	}
	}
	Q:AllAppNum=0 ""
	q AllAppNum_"-"_ArriveCount_"-"_CanDo*/
	s APPMethodRowId=""
	if AppMethCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",AppMethCode,0))
	else  s APPMethodRowId=$O(^RBC("APTM",0,"Code","DOC",0))
	b ;
	s AppMethodInfo=..GetOneAppMethodNumber(rbasdr_"||"_childsub,APPMethodRowId)
	s AllAppNum=$p(AppMethodInfo,"-",1)
	Q:AllAppNum=0 ""
	Q AppMethodInfo
GetAddSeqMesage()
	;获取加号的信息 返回：总数-已用-未用
	Q:CanAddApponit="N" ""	
	s NUMA=0
	i AddQueueNoStr'="" s NUMA=$l(AddQueueNoStr,",")
	s AddUser=0
	s AddCanDo=0
	s AddQueueNoStream=##class(%Stream.GlobalCharacter).%New()
	d AddQueueNoStream.Write(AddQueueNoStr)
	s OneQueueNoStr=""
	While 'AddQueueNoStream.AtEnd {
		s One=AddQueueNoStream.Read(1)
		i One'="," {
			s OneQueueNoStr=OneQueueNoStr_One
			continue
		}
		s SingleQueueNoStr=OneQueueNoStr
		s OneQueueNoStr=""
	 	;s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
				s AddCanDo=AddCanDo+1
		 }
		else{
				s AddUser=AddUser+1
		}
	}
	Q:NUMA=0 ""
	q NUMA_"-"_AddUser_"-"_AddCanDo
}

/// 获取可预约其他科室号别
/// d ##class(%ResultSet).RunQuery("web.DHCDocAppointmentHui","FindDocMarkStrOther","11103","1","10")
Query FindDocMarkStrOther(UserID As %String = "", LocID As %String = "", LogOnLoc As %String = "", MarkCodeName As %String = "") As %Query(ROWSPEC = "markdesc:%String,resrowid:%String")
{
}

ClassMethod FindDocMarkStrOtherExecute(ByRef qHandle As %Binary, UserID As %String = "", LocID As %String = "", LogOnLoc As %String = "", MarkCodeName As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s Ret=""
 	k templist
	k FindDocMarkStrNew
	Set langid=..%LanguageID()
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserID)
	if LocID'=""  d
	.s ResRowId=0
	.f  s ResRowId=$o(^RB("RES",0,"CTLOC",LocID,ResRowId)) quit:ResRowId=""  d
	..s MarkID=$p($g(^RB("RES",ResRowId)),"^",2)
	..Q:MarkID=""
	..s Ctloc=$p($g(^RB("RES",ResRowId)),"^",1)
	..s ScheSt=$p(^RB("RES",ResRowId),"^",6)
	..Q:ScheSt'="Y"
	..s DateActiveFrom=$P(^RB("RES",ResRowId),"^",22)
    ..Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
    ..s DateActiveTo=$P(^RB("RES",ResRowId),"^",23)
    ..Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	..Q:$D(FindDocMarkStrNew(MarkID))
	..s MarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
	..Q:$D(FindDocMarkStrNew(MarkID))
	..;s myRowID=$o(^User.DHCDocRegDocAppointI("RDAPPLocResIndex",LogOnLoc,ResRowId,0))
	..;Q:((LogOnLoc'="")&&(myRowID=""))
	..s UserCanDoRet=##class(web.DHCDocRegDocAppiont).GetAppCanDoRBAS(LogOnLoc,ResRowId,DoctorID)
	..Q:(LogOnLoc'="")&&(UserCanDoRet="")
	..Q:##class(DHCDoc.Util.Base).CheckCTCareName("CT_CareProv",MarkID,MarkCodeName)'="1"
	..s FindDocMarkStrNew(MarkID)=""
	..Set MarkDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",MarkDesc,langid)
	..s templist(MarkDesc,ResRowId)=MarkDesc

	s sub=0
	f  s sub=$O(templist(sub)) Q:sub=""  d
	.s sub1=0
	.f  s sub1=$O(templist(sub,sub1)) Q:sub1=""  d
	..s markdesc=$G(templist(sub,sub1))
	..s resrowid=sub1
	..Do OutputRowFindDocMarkStrOther
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDocMarkStrOther
	set Data=$lb(markdesc,resrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDocMarkStrOtherFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocMarkStrOtherExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDocMarkStrOtherClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocMarkStrOtherExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// desc 获取医生号别对照数据
/// Input 用户登录UserID,用户登录科室ID
/// 返回:RB_Resource ID,号别描述
/// d ##class(%ResultSet).RunQuery("web.DHCDocAppointmentHui","FindDocMarkStr","13068","42")
Query FindDocMarkStr(userid As %String, locid As %String) As %Query(ROWSPEC = "markdesc:%String,resrowid:%String,MarkShowDesc:%String")
{
}

ClassMethod FindDocMarkStrExecute(ByRef qHandle As %Binary, userid As %String, locid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set langid=..%LanguageID()
 	k templist
 	if ((userid'="")&&(locid'="")) d
	.s docdr=$P(^SSU("SSUSR",userid),"^",14)
	.Q:docdr="" 
	.s findout="N"
	.s dhcmarkdr=0 
	.f  s dhcmarkdr=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",docdr,dhcmarkdr))  Q:dhcmarkdr=""  d
	..s findflag=0
	..s id=""
	..f  s id=$O(^User.DHCMarkDocI("MarkdDocMarkIndex",docdr,dhcmarkdr,id)) Q:(id="")||(findflag=1)  d
	...s markdepdr=$list(^User.DHCMarkDocD(id),4)
	...i markdepdr=locid s findflag=1
	..Q:findflag=0
	..s resrowid=$O(^RB("RES",0,"CTPCP",dhcmarkdr,locid,0))
	..Q:resrowid=""
	..s scheflag=$p(^RB("RES",resrowid),"^",6)
	..Q:scheflag'="Y"
	..s markdesc=$p($g(^CTPCP(dhcmarkdr,1)),"^",2)
	..Q:markdesc=""
	..Set markdesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",markdesc,langid)
	..s MarkShowDesc=$p($g(^CTPCP(dhcmarkdr,1)),"^",2)
	..s templist(markdesc,resrowid)=markdesc_$C(1)_MarkShowDesc
	..s findout="Y"
	.if findout="N"  d
	..;未找到符合条件得输出自己
	..s resrowid=$O(^RB("RES",0,"CTPCP",docdr,locid,0))
	..Q:resrowid=""
	..s markdesc=$p($g(^CTPCP(docdr,1)),"^",2)
	..Q:markdesc=""
	..Set markdesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",markdesc,langid)
	..s MarkShowDesc=$p($g(^CTPCP(docdr,1)),"^",2)
	..s templist(markdesc,resrowid)=markdesc_$C(1)_MarkShowDesc
	b ;
	s sub=0
	f  s sub=$O(templist(sub)) Q:sub=""  d
	.s sub1=0
	.f  s sub1=$O(templist(sub,sub1)) Q:sub1=""  d
	..s markdesc=$P(templist(sub,sub1),$C(1),1)
	..s MarkShowDesc=$P(templist(sub,sub1),$C(1),2)
	..s resrowid=sub1
	..Do OutputRowFindDocMarkStr
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDocMarkStr
	set Data=$lb(markdesc,resrowid,MarkShowDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDocMarkStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDocMarkStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDocMarkStrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取资源情况
/// d ##class(%ResultSet).RunQuery("web.DHCDocAppointmentHui","FindApptSchedule","1||103^1||154","DOC")
/// 
Query FindApptSchedule(ApptSchedule As %String, AppointMethCode As %String, PAPMIID As %String = "") As %Query(ROWSPEC = "RBScheduleDr:%String,AppDate:%String,week:%String,timerangedesc:%String,markdesc:%String,sesstype:%String,AllNum:%String,UserNum:%String,CanUseNum:%String,totalnum:%String,addnum:%String,booknum:%String,roomdesc:%String,SessionClinicGroupDesc:%String,AddFlag:%String,price:%String,SelectFlag:%String")
{
}

ClassMethod FindApptScheduleExecute(ByRef qHandle As %Binary, ApptSchedule As %String, AppointMethCode As %String, PAPMIID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	;s ^lxz123=ApptSchedule_","_AppointMethCode_","_PAPMIID
 	Set langid=..%LanguageID()
 	s sysDateFormat=##class(websys.Conversions).DateFormat()
 	s lenrbas=$L(ApptSchedule,"^")
 	for irbas=1:1:lenrbas  d
 	.s onerbas=$P(ApptSchedule,"^",irbas)
 	.Q:onerbas=""
 	.s rbasdr=+onerbas s childsub=+$P(onerbas,"||",2)
 	.Q:childsub=0
 	.Q:'$D(^RB("RES",rbasdr))
 	.s asdate=$p($g(^RBAS(rbasdr,childsub)),"^",1)
 	.s ASStopRegNoFlag=$P($G(^RBAS(+rbasdr,childsub,"DHC")),"^",27) //停正号
 	.q:(ASStopRegNoFlag="Y")&&(asdate>+$h)
	.s sttime=$p($g(^RBAS(rbasdr,childsub)),"^",4)
	.s endtime=$p($g(^RBAS(rbasdr,childsub)),"^",5)
	.s trrowid=$P($G(^RBAS(+rbasdr,childsub,"DHC")),"^",17)
	.s trdesc=""
	.s:trrowid'="" trdesc=$P($G(^DHCTimeRange(trrowid)),"^",2)
	.Q:trdesc=""
	.s trdesc=##class(User.DHCTimeRange).GetTranByDesc("TRDesc",trdesc,langid)
	.s statudr=$P($G(^RBAS(rbasdr,childsub,"DHC")),"^",10)
	.s (statu,statudesc)=""
	.s:statudr'="" statu=$P($G(^DHCRBCASStatus(statudr)),"^",1)
	.s:statudr'="" statudesc=$P($G(^DHCRBCASStatus(statudr)),"^",2)
	.Q:(statu="S")||(statu="TR")||(statu="PS")
	.;默认是不找不规则出诊记录的
	.s ASIrregularFlag=$p($g(^RBAS(rbasdr,childsub)),"^",13)
	.Q:ASIrregularFlag="A"
	.s asqueno=$P(^RBAS(rbasdr,childsub,"DHC"),"^",4)
	.s NormalQueueNoStr=$P(asqueno,$C(1),1)
	.s AddQueueNoStr=$P(asqueno,$C(1),2)
	.s AddMesage=$$GetAddSeqMesage1() ;获取加号信息
	.s NormalMesage=$$getNormalMesage1() ;获取正号预约信息
	.if (asdate=..%SysDate()) s mesgaestr=AddMesage s AddFlag="Y"
	.else  s mesgaestr=NormalMesage s AddFlag="N"
	.s locdr=$P($G(^RB("RES",rbasdr)),"^",1)
	.s locdesc=""
	.s:locdr'="" locdesc=$P($G(^CTLOC(locdr)),"^",2) ;科室
	.s locdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locdesc,langid)
	.s markdesc=""
	.s markdr=$P(^RB("RES",rbasdr),"^",2)
	.s:markdr'="" markdesc=$P($G(^CTPCP(markdr,1)),"^",2) ;号别
	.s markdesc =##class(User.SSUser).GetTranByDesc("SSUSRName",markdesc,langid)
	.s sesstypedr=$P($G(^RBAS(rbasdr,childsub,"DHC")),"^",6) ;出诊级别
	.s sesstype=""
	.i sesstypedr'="" s sesstype=$P($G(^RBC("SESS",sesstypedr)),"^",2)
	.s sesstype =##class(User.RBCSessionType).GetTranByDesc("SESSDesc",sesstype,langid)
	.s totalnum=$p(^RBAS(rbasdr,childsub),"^",8) ;正号限额
	.i ASStopRegNoFlag="Y" s totalnum=0
	.s addnum=$p(^RBAS(rbasdr,childsub,"DHC"),"^",3) ;加号限额
	.s booknum=+$P(NormalMesage,"-",1) ;预约限额
	.s week=..ConvertDateToWeek(asdate) ;星期
	.s week=##class(websys.Translation).Get("dhcdoc.appointment.app.hui.csp",week)
	.s roomdr=$p($G(^RBAS(rbasdr,childsub,"DHC")),"^",5) ;诊室
	.s roomdesc=""
	.s:roomdr'="" roomdesc=$p(^CTLOC(roomdr),"^",2)
	.s roomdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",roomdesc,langid)
	.s timerangedesc=""
	.s timrangedr=$P($G(^RBAS(rbasdr,childsub,"DHC")),"^",17) ;时段
	.s:timrangedr'="" timerangedesc=$P(^DHCTimeRange(timrangedr),"^",2)
	.s timerangedesc=##class(User.DHCTimeRange).GetTranByDesc("TRDesc",timerangedesc,langid)
	.//s SessionClinicGroupDr=$P($G(^RBAS(rbasdr,childsub,"DHC")),"^",7) ;专业组
	.//s SessionClinicGroupDesc=""
	.//i SessionClinicGroupDr'="" s SessionClinicGroupDesc=$P($G(^RBC("CLGRP",SessionClinicGroupDr)),"^",2)
	.s SessionClinicGroupDesc=""
	.s ClinicGroupStr=##class(web.DHCApptScheduleNew).GetClinicGroupDrStr(rbasdr_"||"_childsub)
	.s:ClinicGroupStr'="" SessionClinicGroupDesc=$p(ClinicGroupStr,"^",2)
	.;替诊医师
	.s TRDoc=""
	.s TRRBASRowId=$P(^RBAS(rbasdr,childsub,"DHC"),"^",12)
	.i (TRRBASRowId'="") d
	..i $d(^RB("RES",+TRRBASRowId)) d
	...s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
	...s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	.i PAPMIID'="" d
	..s PatCatDr=$p(^PAPER(PAPMIID,"PER",1),"^",10)
	..s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	.e  s AdmReason=""
	.;s price=##class(web.DHCOPAdmReg).GetScheduleFee(rbasdr_"||"_childsub,AdmReason,+$H,"1||1||1||1||0",PAPMIID)
	.s RtnMes=##class(web.DHCOPAdmReg).GetMarkRegFee(rbasdr_"||"_childsub,AdmReason,PAPMIID)
	.s RegFee=$P(RtnMes,"^",12)
	.s CheckFee=$P(RtnMes,"^",14)
	.s ReCheckFee=$P(RtnMes,"^",15)
	.s HoliFee=$P(RtnMes,"^",16)
	.s AppFee=$P(RtnMes,"^",18)
	.s OtherFee=$P(RtnMes,"^",20)
	.s ReAdmFeeFlag=##class(web.DHCOPAdmReg).GetReAdmFeeFlag(PAPMIID,rbasdr_"||"_childsub)
	.i ReAdmFeeFlag=1 s price=RegFee+ReCheckFee+HoliFee+AppFee+OtherFee
	.e  s price=RegFee+CheckFee+HoliFee+AppFee+OtherFee
	.s AppDate=$ZD(asdate,sysDateFormat)
	.s AllNum=$P(mesgaestr,"-",1) ;总数
	.s UserNum=$P(mesgaestr,"-",2) ;已用
	.s CanUseNum=$P(mesgaestr,"-",3) ;可用
	.s StopRegNoFlag=$P($G(^RBAS(+rbasdr,childsub,"DHC")),"^",27)
	.if StopRegNoFlag="Y" s CanUseNum=0
	.s SelectFlag=0
	.s SessTime=..%SysTime()
	.if timrangedr'="" d
	..s StartTime=$P(^DHCTimeRange(timrangedr),"^",3)
	..s EndTime=$P(^DHCTimeRange(timrangedr),"^",4)
	..if ((SessTime>=StartTime)&&(SessTime<=EndTime)) s SelectFlag=1
	.s RBScheduleDr=rbasdr_"||"_childsub
	.Do OutputRowApptSchedule
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApptSchedule
	set Data=$lb(RBScheduleDr,AppDate,week,timerangedesc,markdesc,sesstype,AllNum,UserNum,CanUseNum,totalnum,addnum,booknum,roomdesc,SessionClinicGroupDesc,AddFlag,price,SelectFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
	
getNormalMesage1()
	;正号串中预约情况 返回 总数-已用-剩余
	/*s AllAppNum=0
	s ArriveCount=0,CanDo=0
	s APPMethodRowId=""
	if AppointMethCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",AppointMethCode,0))
	else  s APPMethodRowId=$O(^RBC("APTM",0,"Code","DOC",0))
	for i=1:1:$l(NormalQueueNoStr,",") {
		 		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		 		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		 		s QueueNo=$P(SingleQueueNoStr,":",1)
		 		s QueueNoMethodRowId=$P(SingleQueueNoStr,":",3)
		 		;s QueueNoInAppFlag=+##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(rbasdr_"||"_childsub,QueueNo,APPMethodRowId) //+..CheckQueueNoInApp(rbasdr_"||"_childsub,QueueNo,AppointMethCode)
		 		s QueueNoInAppFlag=+..CheckQueueNoInApp(rbasdr_"||"_childsub,QueueNo,AppointMethCode)
		 		continue:QueueNoInAppFlag'=1
		 		s AllAppNum=AllAppNum+1
		 		if ((QueueNoStatus=0)||'##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus)){
				 	s CanDo=CanDo+1
				}else{
			 		s ArriveCount=ArriveCount+1
			 	}
			 	
	}
	Q:AllAppNum=0 ""
	q AllAppNum_"-"_ArriveCount_"-"_CanDo*/
	s APPMethodRowId=""
	if AppointMethCode'="" s APPMethodRowId=$O(^RBC("APTM",0,"Code",AppointMethCode,0))
	else  s APPMethodRowId=$O(^RBC("APTM",0,"Code","DOC",0))
	b ;333
	q ..GetOneAppMethodNumber(rbasdr_"||"_childsub,APPMethodRowId)
GetAddSeqMesage1()
	;获取加号的信息 返回：总数-已用-未用
	s NUMA=0
	i AddQueueNoStr'="" s NUMA=$l(AddQueueNoStr,",")
	s AddUser=0
	s AddCanDo=0
	/*for i=1:1:$l(AddQueueNoStr,",") {
			 s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
			 s QueueNoStatus=$P(SingleQueueNoStr,":",2)
			 s QueueNo=$P(SingleQueueNoStr,":",1)
			 ;未取号和已退号的可用
			 i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
					s AddCanDo=AddCanDo+1
			 }
			else{
					s AddUser=AddUser+1
			}
	}*/
	b ;33
	s AddQueueNoStream=##class(%Stream.GlobalCharacter).%New()
	d AddQueueNoStream.Write(AddQueueNoStr)
	s OneQueueNoStr=""
	While 'AddQueueNoStream.AtEnd {
		s One=AddQueueNoStream.Read(1)
		i One'="," {
			s OneQueueNoStr=OneQueueNoStr_One
			continue
		}
		s SingleQueueNoStr=OneQueueNoStr
		s OneQueueNoStr=""
	 	;s SingleQueueNoStr=$P(AddQueueNoStr,",",i)
	 	s QueueNoStatus=$P(SingleQueueNoStr,":",2)
	 	s QueueNo=$P(SingleQueueNoStr,":",1)
	 	i ((QueueNoStatus=0)||('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))){
				s AddCanDo=AddCanDo+1
		 }
		else{
				s AddUser=AddUser+1
		}
	}
	b ;44
	Q:NUMA=0 ""
	q NUMA_"-"_AddUser_"-"_AddCanDo
}

/// 得到某个预约方式 总数(最大预约数)-已用数-可用数
/// w ##class(web.DHCDocAppointmentHui).GetOneAppMethodNumber("1||49",20)
ClassMethod GetOneAppMethodNumber(RBASId As %String, AppMethodID As %String = "")
{

	s ResRowId=$P(RBASId,"||",1)
	s Childsub=$P(RBASId,"||",2)
	s TotalNumber=0
	s UseNumer=0
	s AvailNumber=0
	s ASLoad=$p(^RBAS(ResRowId,Childsub),"^",8)
	s TotalNumber=$p(^RBAS(ResRowId,Childsub),"^",2)
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	s NoLimitLoadFlag=$P($G(^RBAS(ResRowId,Childsub,"DHC")),"^",31) //便捷排班
	if NoLimitLoadFlag="Y"{
		s TotalNumber=ASLoad
		s RegisterNum=##class(web.DHCRBApptSchedule).GetRegisterNum(RBASId)
		s RegedCount=$p(RegisterNum,"^",5)
		s AppedCount=$p(RegisterNum,"^",6)
		s UseNumer=RegedCount+AppedCount
		s AvailNumber=##class(web.DHCRBAppointment).GetAvailableNumIfNoLimitLoad(RBASId, "APP", "","")	
		s rtn=TotalNumber_"-"_UseNumer_"-"_AvailNumber
		q rtn
	}
	
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	s len=$l(NormalQueueNoStr,",")
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
		Q:ASQSub=""  
		s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
		s ASQQueueArry(ASMethodID)=1
	}
	;先计算总体还剩多少可以挂的号,为保留号留足号源，
	s MethodUsedQty=0,MastLeftQty=0
	f i=1:1:len{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s QueueNo=$P(SingleQueueNoStr,":",1)
		s QueueStatus=$P(SingleQueueNoStr,":",2)
		s MethodID=$P(SingleQueueNoStr,":",3)
		if ((MethodID=AppMethodID)&&("123"[QueueStatus)) {
			s MethodUsedQty=MethodUsedQty+1
			s ASMethodID=""
			for{
				s ASMethodID=$O(ASQQueueArry(ASMethodID))
				q:ASMethodID=""
				if ((ASMethodID=AppMethodID)&&("123"[QueueStatus)) {
					s ASQQueueArry(ASMethodID,1)=(+$G(ASQQueueArry(ASMethodID,1)))+1
				}
			}
			if ('$d(ASQQueueArry(AppMethodID,1))) s ASQQueueArry(AppMethodID,1)=1
		}
		if QueueStatus=0 s MastLeftQty=MastLeftQty+1
	}
	s UseNumer=+$G(ASQQueueArry(AppMethodID,1))
	s AppQty=$p(^RBAS(ResRowId,Childsub),"^",2)
	s TotalNumber=AppQty
	;算总的能最大预约数，保留号数和其他预约数
	s (AppReserveQty,OtherReservSum,SubMastLeftQty)=0
	s SumAppMaxQty=$l(NormalQueueNoStr,",")
	s ASQSub=0 for{
		s ASQSub=$O(^RBAS(ResRowId,Childsub,"AQ",ASQSub))
		Q:ASQSub=""  
		s ASMethodID=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",1)
		continue:ASMethodID=""
		if (ASMethodID=AppMethodID) {
			s TotalNumber=+$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",7)
			s AppReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
		}else{
			s ReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)
			s OtherReservSum=OtherReservSum+ReserveQty
		}
		s OneReserveQty=$P(^RBAS(ResRowId,Childsub,"AQ",ASQSub),"^",2)-$G(ASQQueueArry(ASMethodID,1))
		if OneReserveQty<0 s OneReserveQty=0
		s SubMastLeftQty=SubMastLeftQty+OneReserveQty
		
	}
	s AvailNumber=MastLeftQty
	if (AvailNumber>TotalNumber) s AvailNumber=TotalNumber-UseNumer
	if AvailNumber<0 s AvailNumber=0
	if (MastLeftQty<=SubMastLeftQty){
		s AvailNumber=0
	}
	s APPMethodCode=$P(^RBC("APTM",AppMethodID),"^",1)
	s TotalNumber=##class(web.DHCRBAppointment).GetAppSeqNo(RBASId,APPMethodCode,"")
	s AvailNumber=##class(web.DHCRBAppointment).GetAvailableNum(RBASId,"APP",APPMethodCode,"","","")
	s rtn=TotalNumber_"-"_UseNumer_"-"_AvailNumber
	q rtn
}

ClassMethod FindApptScheduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindApptScheduleExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindApptScheduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindApptScheduleExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ConvertDateToWeek(DateNum As %String) As %String
{
	if DateNum'="" {
		s Week=$ZD(DateNum,10)
		if Week=1 Q "周一"
		if Week=2 Q "周二"
		if Week=3 Q "周三"
		if Week=4 Q "周四"
		if Week=5 Q "周五"
		if Week=6 Q "周六"
		if Week=0 Q "周日"
	} 
	Q ""
}

/// 根据患者登记号、患者ID获取患者信息
/// 返回如下:
/// 患者ID -1 登记号-2 姓名-3 性别-4 年龄-5 出生日期-6 联系电话-7 地址-8 
/// 门诊病历号-9 住院病历号-10 患者类型-11 医保号-12 身份证号-13 证件类型-14 证件号码-15 违约数-16 
ClassMethod getPatMesageByPatNo(PatNo As %String, PatDr As %String = "") As %String
{
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s sysDateFormat=##class(websys.Conversions).DateFormat()
	Set langid=..%LanguageID()
	s:PatNo'="" PatDr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(PatNo,"U"),""))
	q:PatDr="" ""
	s name=$p(^PAPER(PatDr,"ALL"),"^",1) ;姓名
	s sexdr=$p(^PAPER(PatDr,"ALL"),"^",7) ;性别
	s Sex=""
	s:sexdr'="" Sex=$p(^CT("SEX",sexdr),"^",2) ;
	s Sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",Sex,langid)
	s DOB=+$p(^PAPER(PatDr,"ALL"),"^",6) ;出生日期
	s:DOB'=0 DOB=$ZD(DOB,sysDateFormat)
	s Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatDr,"",HospID)
	s phone=$P($G(^PAPER(PatDr,"PER",1)),"^",11) ;电话
	s address=$p($G(^PAPER(PatDr,"PER",4)),"^",18) ;地址
	s OPMRN=##class(web.DHCDocOrderCommon).GetMrNo("",PatDr,"O",$g(%session.Data("LOGON.HOSPID"))) ;门诊病案号
	s IPMRN=##class(web.DHCDocOrderCommon).GetMrNo("",PatDr,"I",$g(%session.Data("LOGON.HOSPID"))) ;住院病案号
	s patybcode=$p($g(^PAPER(PatDr,"PAT",3)),"^",12) ;医保号
	s patcatdesc=""
	s patcatdr=$p(^PAPER(PatDr,"PER",1),"^",10)
	s:patcatdr'="" patcatdesc=$p($g(^CT("SS",patcatdr)),"^",2) ;患者类型
	s papmidvnum=$P($G(^PAPER(PatDr,"ALL")),"^",9 )  ;身份证
	s creadtypedr=$p($g(^PAPER(PatDr,"PAT",3)),"^",7) ;证件类型
	s creadtype=""
	s:creadtypedr'="" creadtype=$p($g(^PAC("CARD",creadtypedr)),"^",2)
	Set creadtype= ##class(User.DHCCardTypeDef).GetTranByDesc("CTDDesc",creadtype,langid)
	s creadnum=$p($g(^PAPER(PatDr,"PAT",3)),"^",6) ;证件号码
	s AppBreakCount=##class(web.DHCRBAppointment).GetAppBreakCount(PatDr) ;违约数
	s patnum=$p(^PAPER(PatDr,"PAT",1),"^",2) ;登记号
	;死亡标志
	s IsDeceased=##Class(web.PAPerson).CheckDeceased(PatDr)
	s rtn=PatDr_"^"_patnum_"^"_name_"^"_Sex_"^"_Age_"^"_DOB_"^"_phone_"^"_address_"^"_OPMRN_"^"_IPMRN
	s rtn=rtn_"^"_patcatdesc_"^"_patybcode_"^"_papmidvnum_"^"_creadtype_"^"_creadnum_"^"_AppBreakCount_"^"_IsDeceased
	q rtn
}

/// w ##class(web.DHCDocAppointmentHui).GetTimeRangeStrApp("1||35","DOC")
ClassMethod GetTimeRangeStrApp(ASRowid As %String, AppMedthod As %String, MaxWeight As %String = "") As %String
{
	Q:ASRowid="" ""
	Set ResRowId=+ASRowid
	Set Childsub=$P(ASRowid,"||",2)
	s ASQueueNo=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	k listseq
	for i=1:1:$l(NormalQueueNoStr,",") 
	{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		s QueueNo=+$P(SingleQueueNoStr,":",1)
		i QueueNo=0 {continue}
		if ('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus)){s QueueNoStatus=0} //退号可用
		s listseq(QueueNo)=QueueNoStatus
		
	}
	s disabledcolor="red"
	s candocolor="blue"
	
	s RegNumStr=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",24) ;分时段号
	s RangStr=$P(^RBAS(ResRowId,Childsub,"DHC"),"^",25) ;分时段时段
	s NumLen=5 ;每行模块数量
	if (+MaxWeight'=0){
		s NumLen=MaxWeight\98
	}
	s numl=0
	s find="N"
	s html="<table>"
	for i=1:1:$L(RegNumStr,",")  d
	.Set RegNums=$p(RegNumStr,",",i)
	.Q:RegNums=""
	.Set StartNum=$p(RegNums,"-",1)
	.Set EndNum=$p(RegNums,"-",2)
	.s TimeRange=$P(RangStr,",",i)
	.for j=StartNum:1:EndNum  d
	..;控制字体颜色
	..s statu=+$G(listseq(j))
	..if statu=0 s class="timerangediv"
	..else  s class="timerangediv-disabled"
	..s rtnstr=..CheckQueueNoInApp(ASRowid,j,AppMedthod)
	..s QueueNoInAppFlag=+rtnstr
	..Q:QueueNoInAppFlag'=1
	..s AppMethID=$P(rtnstr,"^",2)
	..s GetMethCode=""
	..s:AppMethID'="" GetMethCode=$P($G(^RBC("APTM",AppMethID)),"^",1)
	..s find="Y"
	..s numl=numl+1
	..if numl=1  d
	...s html=html_"<tr>"
	..s html=html_"<td>"
	..s html=html_"<a href='#'><div title='' id="_"SEQ"_j_" onclick='selectseqnum("_j_","_statu_")' timrange="_TimeRange_" methcode="_GetMethCode_" class='"_class_"' style='padding: 0px; width: 98px; height: 60px;' data-options='closable:true,collapsible:true,minimizable:true,maximizable:true'>"
	..s html=html_"<div style='font-size:25px;;text-align:center;'>"_j_"</div>"
	..s html=html_"<div style='font-size:15px;text-align:left;text-align:center'>"_TimeRange_"</div>"
	..s html=html_"</div></a>"
	..s html=html_"</td>"
	..if numl=NumLen  d
	...s html=html_"</tr>"
	...s numl=0
	if numl>0  d
	.s html=html_"</tr>"
	s html=html_"</table>"
	Q:find'="Y" "" 
	Quit html
}

/// 获取剩余号最多的预约方式
ClassMethod GetAppointMethCode(ASRowId As %Library.String = "", AppMethCodeStr As %String) As %String
{
	;只有一种预约方式那么返回一种
	s appmethl=$L(AppMethCodeStr,"^")
	s findmeth=""
	s findnum=0
	f im=1:1:appmethl  d
	.s onemethcode=$P(AppMethCodeStr,"^",im)
	.Q:onemethcode=""
	.s findmeth=onemethcode
	.s findnum=findnum+1
	q:findnum=1 findmeth
	s findlastmeth=findmeth
	
	;查看存在剩余号的预约方式
	s findmeth=""
	s ASQueueNo=$P(^RBAS(+ASRowId,$P(ASRowId,"||",2),"DHC"),"^",4)
	s NormalQueueNoStr=$P(ASQueueNo,$C(1),1)
	for i=1:1:$l(NormalQueueNoStr,",")
	{
		s SingleQueueNoStr=$P(NormalQueueNoStr,",",i)
		s QueueNoStatus=$P(SingleQueueNoStr,":",2)
		s QueueNo=+$P(SingleQueueNoStr,":",1)
		i QueueNo=0 {continue}
		s InAppstr=..CheckQueueNoInApp(ASRowId,QueueNo,AppMethCodeStr)
		s inflag=+InAppstr
		continue:inflag'=1
		s inMethdr=$P(InAppstr,"^",2)
		s methcode=""
		s:inMethdr'="" methcode=$P($G(^RBC("APTM",inMethdr)),"^",1)
		continue:methcode=""
		if (('##class(web.DHCRBAppointment).GetReturnAllowRegFlag(QueueNoStatus))||(QueueNoStatus=0)){
			s findmeth=methcode
		}
		q:findmeth'=""
	}
	s:findmeth="" findmeth=findlastmeth
	q findmeth
}

/// 查看号是否在预约范围内
ClassMethod CheckQueueNoInApp(RBASId, QueueNo, AppMethCode)
{
	/*s findFlag=0,findMethodDR=""
	Q:(+QueueNo=0)||(RBASId="") findFlag_"^"_findMethodDR
	s APPMethodRowId="" 
	s:AppMethCode'="" APPMethodRowId=$O(^RBC("APTM",0,"Code",AppMethCode,0))
	Q ##class(web.DHCRBApptScheduleAppQty).CheckQueueNoInApp(RBASId,QueueNo,APPMethodRowId)*/
	
	;查看号是否在预约范围内
	s findFlag=0,findMethodDR=""
	Q:(+QueueNo=0)||(RBASId="") findFlag_"^"_findMethodDR
	s QueueNo=+QueueNo
	s ResRowId=$P(RBASId,"||",1)
	s ASChild=$P(RBASId,"||",2)
	s Child=0  
	f  s Child=$O(^RBAS(ResRowId,ASChild,"AQ",Child)) Q:(Child="")||(findFlag=1)  d
	.s APPData=$G(^RBAS(ResRowId,ASChild,"AQ",Child))
	.s APPMethodDR=$P(APPData,"^",1)
	.Q:APPMethodDR=""
	.s APPQty=$P(APPData,"^",2)
	.s AppStartNum=$P(APPData,"^",3)
	.s MethCodeGet=$P($G(^RBC("APTM",APPMethodDR)),"^",1)
	.q:(("^"_AppMethCode_"^")'[("^"_MethCodeGet_"^"))
	.i (QueueNo'<AppStartNum)&&(QueueNo'>(AppStartNum+APPQty-1)) d
	..s findFlag=1,findMethodDR=APPMethodDR
	Q findFlag_"^"_findMethodDR
}

/// 检测是否可以取消预约
/// w ##class(web.DHCDocAppointmentHui).CheckBeforeCancel("1||1666||1",6)
ClassMethod CheckBeforeCancel(AppID, LogonUser) As %String
{
	Q:AppID="" "缺少预约ID不能取消"
	s ApptData=$g(^RBAS(+AppID,$P(AppID,"||",2),"APPT",$P(AppID,"||",3)))
	s ASDate=$p($g(^RBAS(+AppID,$P(AppID,"||",2))),"^",1)
	s TransUserDR=$P(ApptData,"^",11)
	s logonDoc=$p($g(^SSU("SSUSR",LogonUser)),"^",14)
	s Docdr=$p(^RB("RES",+AppID),"^",2)
	Q:((LogonUser'=TransUserDR)&&(logonDoc'=Docdr)) "非本人增加预约记录或本人预约记录不能取消"
	s MethodDR=$P(ApptData,"^",12)
	s MethodCode=""
	i MethodDR'="" s MethodCode=$P($g(^RBC("APTM",MethodDR)),"^",1)
	s TransDate=$P(ApptData,"^",8)
	s StatusCode=$P(ApptData,"^",3)
	q:(StatusCode="X") "记录已经取消,请刷新界面!"
	s StatusDesc=$case(StatusCode,"A":"已取号","X":"已取消","J":"违约","I":"已预约",:"其他")
	q:(StatusCode'="I") "记录当前状态为【"_StatusDesc_"】,不能取消!"
	Q:ASDate<+$H "记录已过期,不能取消!"
	q ""
}

/// 日期返回为系统定义日期格式
ClassMethod DateToHtml(date) As %String
{
	Q:+date=0 date
	s sysDateFormat=##class(websys.Conversions).DateFormat()
	s date=$ZD(date,sysDateFormat)
	q date
}

/// 开始日期、截止日期、查询科室、查询患者ID、资源ID、登录科室ID、登录用户ID、预约方式Code、是否查询加号(Y)、是否查询其他医师预约记录(Y)
/// d ##class(%ResultSet).RunQuery("web.DHCDocAppointmentHui","GetApptList","2018-09-03","2018-09-03","","",1,7,6,"DOC","","Y")
Query GetApptList(StartDay As %String, EndDay As %String, Locdr As %String, PatientID As %String, RBResID As %String, LogonLocId As %String, LogOnUser As %String, MethCodeStr As %String, PatName As %String, CanAddApponit As %String, OterdocAppoint As %String) As %Query(ROWSPEC = "RowId:%String,AppDate:%String,AppTime:%String,DepDesc:%String,DocDesc:%String,PatientID:%String,PatientNo:%String,PatientName:%String,AppPatientSex:%String,AppPatientAge:%String,StatusCode:%String,StatusDesc:%String,MethodDesc:%String,QueueNo:%String,Sum:%String,RBASStatusDesc:%String,TRDoc:%String,RBASStatusReason:%String,TransDate:%String,TransTime:%String,TransUserName:%String,StatusChangeDate:%String,StatusChangeTime:%String,StatusChangeUserName:%String,SystemSession:%String,RBASStatusCode:%String,AppIntervalTime:%String,Remark:%String,LineNum:%String,TPoliticalLevel:%String,TSecretLevel:%String,TPhone:%String,TTimeRange:%String")
{
}

ClassMethod GetApptListExecute(ByRef qHandle As %Binary, StartDay As %String, EndDay As %String, Locdr As %String, PatientID As %String, RBResID As %String, LogonLocId As %String, LogOnUser As %String, MethCodeStr As %String, PatName As %String, CanAddApponit As %String, OterdocAppoint As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^lxz1123=StartDay_","_EndDay_","_Locdr_","_PatientID_","_RBResID_","_LogonLocId_","_LogOnUser_","_MethCodeStr_","_PatName_","_CanAddApponit_","_OterdocAppoint
 	s StartDay=..%ZDH(StartDay)
    s EndDay=..%ZDH(EndDay)
    s LogonHospId=%session.Data("LOGON.HOSPID")
	s CommonPatientID=##class(web.DHCOPAdmReg).GetCommonPatientID("",LogonHospId)
    Set langid=..%LanguageID()
	;按照起止日期來查询
    f fdate=StartDay:1:EndDay  d
    .;选择了资源按照选择的资源查询
    .if RBResID'=""  d
    ..s timecomp=""
    ..f  s timecomp=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp)) Q:timecomp=""  d
    ...s childsub=0
    ...f  s childsub=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp,childsub)) Q:childsub=""  d
    ....s appchild=0
    ....f  s appchild=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp,childsub,appchild)) Q:appchild=""  d
    .....s appid=RBResID_"||"_childsub_"||"_appchild
  	.....s cando=$$CanDiaPlay(appid)
  	.....Q:cando'=1
    .....d GetAppMesage(appid,langid)
    .else  if Locdr'=""  d
    ..;按照科室查询所有资源
    ..s RBResID=0
    ..f  s RBResID=$O(^RB("RES",0,"CTLOC",Locdr,RBResID)) Q:RBResID=""  d
    ...s timecomp=""
    ...f  s timecomp=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp)) Q:timecomp=""  d
    ....s childsub=0
    ....f  s childsub=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp,childsub)) Q:childsub=""  d
    .....s appchild=0
    .....f  s appchild=$O(^RBAS("APPT_Date",RBResID,fdate,timecomp,childsub,appchild)) Q:appchild=""  d
    ......s appid=RBResID_"||"_childsub_"||"_appchild
  	......s cando=$$CanDiaPlay(appid)
  	......Q:cando'=1
    ......d GetAppMesage(appid,langid)
    .else  if LogOnUser'=""  d
    ..;没有选择科室、资源得情况下查询自己名下预约数据
    ..s RBResID=0
	..f  s RBResID=$O(^RBAS("TransUser",LogOnUser,fdate,RBResID)) q:RBResID=""  d
	...s childsub=0
	...f  s childsub=$O(^RBAS("TransUser",LogOnUser,fdate,RBResID,childsub)) q:childsub=""  d
	....s appchild=0
	....f  s appchild=$O(^RBAS("TransUser",LogOnUser,fdate,RBResID,childsub,appchild)) q:appchild=""  d
	.....s appid=RBResID_"||"_childsub_"||"_appchild
	.....s cando=$$CanDiaPlay(appid)
	.....Q:cando'=1
	.....d GetAppMesage(appid,langid)
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
CanDiaPlay(appid)
	s DepRowId=$P(^RB("RES",+appid),"^",1)
	s HospId=$p(^CTLOC(DepRowId),"^",22)
	Q:(HospId'=LogonHospId) 0
	s statu=$P($g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3))),"^",3)
    Q:(statu'="I")&(statu'="A")&(statu'="J") 0
    s apppatid=$P($g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3))),"^",2)
    Q:((PatientID'=apppatid)&&(PatientID'="")) 0
    ;患者姓名不为空患者ID为空按照患者姓名查询
    s patname=""
    s:apppatid'="" patname=$p(^PAPER(apppatid,"ALL"),"^",1) ;
    i (("^"_CommonPatientID_"^")[("^"_apppatid_"^")){
    	s patname=$P($G(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3),"DHC")),"^",1)
    }
    Q:((PatName'="")&(PatientID=""))&(patname'[PatName) 0
    
    ;按照预约人判断
    s tranduserdr=$P($g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3))),"^",11)
    Q:(tranduserdr'=LogOnUser)&(OterdocAppoint'="Y") 0
    
    ;如果是本人预约得不走下边的预约权限判断
    Q:(tranduserdr=LogOnUser) 1
    
    
    s QueueNo=$P($g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3))),"^",5)
    s MethID=$P($g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3))),"^",12)
    
    ;按照预约方式权限配置來限制查看记录 查看预约权限范畴内的额号
    s MethodCode=""
	i MethID'="" s MethodCode=$P($g(^RBC("APTM",MethID)),"^",1)
	if (MethodCode'="DOCADD"){
		if (MethCodeStr'=""){
			if (("^"_MethCodeStr_"^")'[("^"_MethodCode_"^")){
				s rtn=+..CheckQueueNoInApp($P(appid,"||",1,2), QueueNo,MethCodeStr)
				if (rtn=0){
					q 0
				}
			}
		}
	}
	
	Q:(CanAddApponit'="Y")&(MethodCode="DOCADD") 0 ;存在诊间加号得权限才能查看加号记录
	q 1
 
GetAppMesage(appid,langid)
	s sysDateFormat=##class(websys.Conversions).DateFormat()
	s ApptData=$g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3)))
	s dhcappdate=$G(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3),"DHC"))
	s StatusCode=$p(ApptData,"^",3)
	s QueueNo=$P(ApptData,"^",5)
	s ASDate=$p($g(^RBAS(+appid,$P(appid,"||",2))),"^",1)
	if (StatusCode="I")&&(ASDate=..%SysDate())&&(QueueNo'["+") {
		s AppReturnTime=0
		s TRRowId=$P($G(^RBAS(+appid,$P(appid,"||",2),"DHC")),"^",17)
		if TRRowId'="" {
			s AppReturnTime=$p($g(^DHCTimeRange(TRRowId)),"^",5)
		}
		Set AppTimeRangeReturnTime=##class(web.DHCOPAdmReg).GetAppReturnTimeBySeqNo($p(appid,"||",1,2),QueueNo)
		if (AppTimeRangeReturnTime'="") s AppReturnTime=AppTimeRangeReturnTime
		if (..%SysTime()>AppReturnTime) {
			s StatusCode="J"
		}
	}
	s DepRowId=$P(^RB("RES",+appid),"^",1)
	s DocRowId=$P(^RB("RES",+appid),"^",2)
	s DepDesc=$p($g(^CTLOC(DepRowId)),"^",2)
	s DepDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DepDesc,langid)
	s DepDesc=..FormatDesc(DepDesc)
	s DocDesc=$P($g(^CTPCP(DocRowId,1)),"^",2)
	Set DocDesc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DocDesc,langid)
	s AppPatientID=$P(ApptData,"^",2)
	;初始化患者信息
	s AppPatientName="",AppPatientNo="",AppPatientSex="",AppPatientAge="",PatCatDr=""
	s Telphone="",creadno=""
	s AppPatientSex=$p(^CT("SEX",$p(^PAPER(AppPatientID,"ALL"),"^",7)),"^",2)
	s AppPatientSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",AppPatientSex,langid)
	s AppPatientAge=+$p(^PAPER(AppPatientID,"ALL"),"^",6)
	s AppPatientAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",AppPatientID,"",LogonHospId)
	//##class(web.PAPerson).calculateAgeUnitsShow(AppPatientID)
	S AppPatientNo=$p(^PAPER(AppPatientID,"PAT",1),"^",1)
	;有卡预约和无卡预约获取的预约信息
	//if ((AppPatientID'="")&&($D(^PAPER(AppPatientID)))) d
	if (("^"_CommonPatientID_"^")'[("^"_apppatid_"^")) d
	.s PatCatDr=$p(^PAPER(AppPatientID,"PER",1),"^",10)
	.s AppPatientName=$p(^PAPER(AppPatientID,"ALL"),"^",1)
	
	.s Telphone=$p(^PAPER(AppPatientID,"PER",1),"^",11)
	.s creadno=$P($G(^PAPER(AppPatientID,"ALL")),"^",9 )  ;身份证 证件类型
    .if creadno=""  d
 	..s creadno=$p($g(^PAPER(AppPatientID,"PAT",3)),"^",6)
 	else  d
	.s AppPatientName=$P(dhcappdate,"^",1) ;无卡患者姓名
	.s Telphone=$P(dhcappdate,"^",5) ;电话
	.s creadno=$P(dhcappdate,"^",8) ;证件信息
	
	s EmployeeFunction="",SecretLevel=""
	s PatEncryptLevel="" ;##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(AppPatientID,.ErrMsg)
	i PatEncryptLevel'="" {
		s EmployeeFunction=$p(PatEncryptLevel,"^",2)
		s SecretLevel=$p(PatEncryptLevel,"^",1)
	}
	s StatusDesc=""
	s StatusDesc=$case(StatusCode,"I":"已预约","A":"已取号","X":"已取消","J":"违约",:"其他")
	s AdmRowId=$P(ApptData,"^",4)
	s StatusDesc=##class(websys.Translation).Get("dhcdoc.appointment.hui.csp",StatusDesc)
	s ApptTypeRowId=$P(ApptData,"^",1)
	s ApptTypeCode=""
	i ApptTypeRowId'="" s ApptTypeCode=$P(^RBC("AT",ApptTypeRowId),"^",1)
	;办理预约日期,预约时间,预约办理人
	s TransDate=$P(ApptData,"^",8)
	i TransDate'="" s TransDate=$ZD(TransDate,sysDateFormat)
	s TransTime=$P(ApptData,"^",9)
	i TransTime'="" s TransTime=..%ZT(TransTime)
	s TransUserDR=$P(ApptData,"^",11)
	s TransUserName="",TransUserGroupRowId=""
	i TransUserDR'="" d
	.s TransUserName=$p($g(^SSU("SSUSR",TransUserDR)),"^",2)
	.s TransUserName =##class(User.SSUser).GetTranByDesc("SSUSRName",TransUserName,langid)
	.s TransUserGroupRowId=$P(^SSU("SSUSR",TransUserDR),"^",5)
	s MethodDR=$P(ApptData,"^",12)
	s MethodDesc=""
	i MethodDR'="" s MethodDesc=$P($g(^RBC("APTM",MethodDR)),"^",2)
	Set MethodDesc= ##class(User.RBCAppointMethod).GetTranByDesc("APTMDesc",MethodDesc,langid)
	s AdmType=$P(ApptData,"^",13)
	;
	;办理取号日期/取消日期,时间
	s StatusChangeDate=$P(ApptData,"^",63)
	i StatusChangeDate'="" s StatusChangeDate=$ZD(StatusChangeDate,sysDateFormat)
	s StatusChangeTime=$P(ApptData,"^",64)
	i StatusChangeTime'="" s StatusChangeTime=..%ZT(StatusChangeTime)
	s StatusChangeUserDR=$P(ApptData,"^",65)
	s StatusChangeUserName=""
	i StatusChangeUserDR'="" s StatusChangeUserName=$p($g(^SSU("SSUSR",StatusChangeUserDR)),"^",2)
	s StatusChangeUserName =##class(User.SSUser).GetTranByDesc("SSUSRName",StatusChangeUserName,langid)
	;接口流水号
	s SystemSession=$P(ApptData,"^",69)
	s RBASStatusDesc="",RBASStatusReason=""
 	if $d(^RBAS(+appid,$P(appid,"||",2))) d
    .s RBASStatusDr=$P(^RBAS(+appid,$P(appid,"||",2),"DHC"),"^",10)
 	.s RBASStatusCode=$P(^DHCRBCASStatus(RBASStatusDr),"^",1)
 	.s RBASStatusDesc=$P(^DHCRBCASStatus(RBASStatusDr),"^",2)
 	.s RBASStatusDesc =##class(User.DHCRBCASStatus).GetTranByDesc("ASSDesc",RBASStatusDesc,langid)
 	.s RBASStatusReasonDr=$P(^RBAS(+appid,$P(appid,"||",2),"DHC"),"^",11)
 	.i RBASStatusReasonDr'="" s RBASStatusReason=$P(^RBC("NA",RBASStatusReasonDr),"^",2)
	
	s StartTime=$P($G(^RBAS(+appid,$P(appid,"||",2))),"^",4)
	s TRRowId=$P($G(^RBAS(+appid,$P(appid,"||",2),"DHC")),"^",17)
	;s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	i TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	e  s TRDesc="其他"
	s TRDesc=##class(User.DHCTimeRange).GetTranByDesc("TRDesc",TRDesc,langid)
	s DocDesc=DocDesc_"("_TRDesc_")"
 	;被替诊的挂号记录才能显示对应的替诊排班记录
 	s TRRBASRowId="",TRDoc=""
 	i (RBASStatusCode="TR") d
 	.s TRRBASRowId=$P(^RBAS(+appid,$P(appid,"||",2),"DHC"),"^",12)
 	.i (TRRBASRowId'="") d
	..s TRDocRowId= $P($G(^RB("RES",+TRRBASRowId)),"^",2)
 	..s TRDoc=$p($g(^CTPCP(TRDocRowId,1)),"^",2)
	s RBASRowId=$P(appid,"||",1,2)
	s FeeStr="||||||1"
	s NeedAppFee=##class(web.DHCRBAppointment).NeedAppFee(appid)
	s FeeStr="1||1||0||0"
	i NeedAppFee="1" s FeeStr="1||1||0||1"
	
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	
	s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	s InvoiceId="",ConRowId="",PBRowId="",RegfeeRowId=""
	i AdmRowId'="" s RegfeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmRowId,""))
	s RegFee=0,CheckFee=0,HoliFee=0,AppFee=0,ReCheckFee=0,OtherFee=0,MRFee=0
	i RegfeeRowId'="" {
		s InvoiceId=$lg(^User.DHCRegistrationFeeD(RegfeeRowId),11)
		i InvoiceId'=""	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceId,0))
		i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
		if PBRowId'="" {
			s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
			.s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
			.Q:ArcimId=""
			.s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,LogonHospId)
			.s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
			.i type="App" s AppFee=AppFee+BillSum
			.e  i type="Reg" s RegFee=RegFee+BillSum
			.e  i type="Check" s CheckFee=CheckFee+BillSum
			.e  i type="Holi" s HoliFee=HoliFee+BillSum
			.e  i type="ReCheck" s ReCheckFee=ReCheckFee+BillSum
			.e  i type="MR" s MRFee=MRFee+BillSum
			.e  i type="Other" s OtherFee=OtherFee+BillSum
		}	
		s Sum=AppFee+RegFee+CheckFee+HoliFee+ReCheckFee+OtherFee+MRFee
	}else {
		s DocResValue=##class(web.DHCOPAdmReg).GetMarkRegFee(RBASRowId,AdmReason,AppPatientID,"","")
		s RegFee=$p(DocResValue,"^",12)
		s CheckFee=$p(DocResValue,"^",14)
		s HoliFee=$p(DocResValue,"^",16)
		s AppFee=$p(DocResValue,"^",18)
		s ReCheckFee=$p(DocResValue,"^",15)
		s OtherFee=$p(DocResValue,"^",20)
		
		s ReAdmFlag=##class(web.DHCOPAdmReg).GetReAdmFeeFlag(AppPatientID,RBASRowId)
		if ReAdmFlag="1",ReCheckFee'=0 s CheckFee=ReCheckFee
		s Sum=HoliFee+CheckFee+RegFee+AppFee+OtherFee
	}
	s Sum=$fn(Sum,"",2)
	s AppIntervalTime="" ;##class(web.DHCRBAppointment).GetAppIntervalTime(APPTRowId)
	s Remark=$g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3),"REM",1))
	;lxz 获取分时段建议就诊时段
	s TTimeRange=##class(web.DHCOPAdmReg).GetAdmTimeBySeqNo(RBASRowId,QueueNo)
	s RowId=appid
	s AppDateHTML=$ZD(ASDate,sysDateFormat)
	
	
	s Data=$lb(RowId,AppDateHTML,AppTime,DepDesc,DocDesc,AppPatientID,AppPatientNo,AppPatientName,AppPatientSex,AppPatientAge,StatusCode,StatusDesc,MethodDesc,QueueNo,Sum,RBASStatusDesc,TRDoc,RBASStatusReason,TransDate,TransTime,TransUserName,StatusChangeDate,StatusChangeTime,StatusChangeUserName,SystemSession,RBASStatusCode,AppIntervalTime,Remark,ind,EmployeeFunction,SecretLevel,Telphone,TTimeRange)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	q      
	
OutputRow
	set Data=$lb(StCode,StDesc,StSexDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetApptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApptListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApptListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FormatDesc(Desc As %String)
{
	s Desc1=$P(Desc,"-",2)
	if Desc1'="" s Desc=Desc1
	Q Desc
}

/// 可以查询的预约科室  --查询预约科室
Query CanFindLoc(desc As %String, LogOnLoc As %String, LogOnUser As %String) As %Query(ROWSPEC = "CTDesc:%String:科室,CTRowId:%String")
{
}

ClassMethod CanFindLocExecute(ByRef qHandle As %Binary, desc As %String, LogOnLoc As %String, LogOnUser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s templist(LogOnLoc)=""
	Set rset=##class(%ResultSet).%New("web.DHCBL.Doctor.AppointOral.GetOtherLocList")
	do rset.Execute("",LogOnUser,LogOnLoc)
	While (rset.Next()) {
		s ctlocid=rset.GetData(2)
		continue:ctlocid=""
		s templist(ctlocid)=""
	}
	d rset.Close()
	Set langid=..%LanguageID()
	s locdr=0
	f  s locdr=$O(templist(locdr)) Q:locdr=""  d
	.Q:((##class(web.DHCOPAdmReg).CheckLocDesc(locdr,desc)'=1)&&(desc'=""))
	.s locdesc=$P($G(^CTLOC(locdr)),"^",2)
	.s locdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",locdesc,langid)
	.s:locdesc["-" locdesc=$P(locdesc,"-",2)
	.Do OutputRowCanFindLoc
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCanFindLoc
	set Data=$lb(locdesc,locdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CanFindLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CanFindLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CanFindLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CanFindLocExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocAppointmentHui","CanFindRBAS",2,6,7) 
Query CanFindRBAS(locdr As %String, logonuser As %String, logonloc As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

ClassMethod CanFindRBASExecute(ByRef qHandle As %Binary, locdr As %String, logonuser As %String, logonloc As %String) As %Status
{
	
	s ^lxz123=locdr_","_logonuser_","_logonloc
	Set repid=$I(^CacheTemp)
 	s ind=1
 	k templistcanfind
 	Set rset=##class(%ResultSet).%New("web.DHCDocAppointmentHui.FindDocMarkStr")
	do rset.Execute(logonuser,locdr)
	While (rset.Next()) {
		s rowid=rset.GetData(2)
		continue:rowid=""
		s templistcanfind(rowid)=rset.GetData(1)
	}
	d rset.Close()
	
	Set rset=##class(%ResultSet).%New("web.DHCDocAppointmentHui.FindDocMarkStrOther")
	do rset.Execute(logonuser,locdr,logonloc)
	While (rset.Next()) {
		s rowid=rset.GetData(2)
		continue:rowid=""
		s templistcanfind(rowid)=rset.GetData(1)
	}
	d rset.Close()
 	
    s rowid=0
    f  s rowid=$O(templistcanfind(rowid)) Q:rowid=""  d
    .s desc=$G(templistcanfind(rowid))
    .Do OutputRowCanFindRBAS
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCanFindRBAS
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CanFindRBASFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CanFindRBASExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CanFindRBASClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CanFindRBASExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 判断是否是节假日
ClassMethod IsHolidayDate(CurrDate) As %String
{
	s IsHolidayflag=0
	s IsHoliday=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(..%ZD(CurrDate),"","") 
	i (IsHoliday=1)||(IsHoliday=2) s IsHolidayflag=1
	q IsHolidayflag
}

/// 获取预约方式
Query GetMethTypeDesc(userid As %String, locid As %String, MethCodeStr As %String) As %Query(ROWSPEC = "MethodCode:%String,MethodDesc:%String,MethDr:%String")
{
}

ClassMethod GetMethTypeDescExecute(ByRef qHandle As %Binary, userid As %String, locid As %String, MethCodeStr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set langid=..%LanguageID()
 	if MethCodeStr'=""  d
 	.s lengthMeth=$L(MethCodeStr,"^")
 	.for imeth=1:1:lengthMeth  d
 	..s methCode=$P(MethCodeStr,"^",imeth)
 	..Q:methCode=""
 	..s methCode=$ZCVT(methCode,"U")
 	..s MethDr=+$O(^RBC("APTM",0,"Code",methCode,0))
 	..Q:MethDr=0
 	..s MethodCode=$P($g(^RBC("APTM",MethDr)),"^",1)
 	..s MethodDesc=$P($g(^RBC("APTM",MethDr)),"^",2)
 	..s FromDate=$P($g(^RBC("APTM",MethDr)),"^",4)
 	..s ToDate=$P($g(^RBC("APTM",MethDr)),"^",5)
	..Q:((FromDate>+$H)&(FromDate'=""))
	..Q:((ToDate<+$H)&&(ToDate'=""))
	..Set MethodDesc= ##class(User.RBCAppointMethod).GetTranByDesc("APTMDesc",MethodDesc,langid)
    ..Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(MethodCode,MethodDesc,MethDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMethTypeDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMethTypeDescExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMethTypeDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMethTypeDescExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取科室描述
ClassMethod GetCtLocDescByID(ctlocdr) As %String
{
	s logonlocdesc=""
	s:ctlocdr'="" logonlocdesc=$P($G(^CTLOC(ctlocdr)),"^",2)
	s:logonlocdesc["-" logonlocdesc=$P(logonlocdesc,"-",2)
	q logonlocdesc
}

/// 获取预约记录的预约状态
ClassMethod GetAppStatuCode(appid) As %String
{
	Q:+appid=0 ""
	s ApptData=$g(^RBAS(+appid,$P(appid,"||",2),"APPT",$P(appid,"||",3)))
	s ASDate=$p($g(^RBAS(+appid,$P(appid,"||",2))),"^",1)
	s StatusCode=$P(ApptData,"^",3)
	q StatusCode
}

ClassMethod GetPatientNo(PatientID) As %String
{
	s PatNo=""
	s:PatientID'="" PatNo=$p($G(^PAPER(PatientID,"PAT",1)),"^",2)
	q PatNo
}

Storage Default
{
<Data name="DHCDocAppointmentHuiDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCDocAppointmentHuiD</DataLocation>
<DefaultData>DHCDocAppointmentHuiDefaultData</DefaultData>
<IdLocation>^web.DHCDocAppointmentHuiD</IdLocation>
<IndexLocation>^web.DHCDocAppointmentHuiI</IndexLocation>
<StreamLocation>^web.DHCDocAppointmentHuiS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
