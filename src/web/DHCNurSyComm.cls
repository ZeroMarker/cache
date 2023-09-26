Include Nur.DateFormat

Class web.DHCNurSyComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Description: 取病人基本信息
/// Table：
/// Input：loc:科室ID,seatid:座位ID,stat:占用状态(Y/N)
/// Return：姓名：^科室：
ClassMethod getpat(loc, seatid, stat) As %String
{
  //s a=##class(web.DHCNurSyComm).getpat(1007,5,"Y")
      s id=""  s id=$O(^User.DHCNurSyPatRecI("seat"," "_loc," "_seatid," "_stat,id),-1)
      b //
      if id'=""
      {
	      b
	    s a=^User.DHCNurSyPatRecD(id)
	    s episod=$listget(a,3)
	    s seat=$listget(^User.DHCNurSySeatD(seatid),3)
	    s patinfo=..Patinfo(episod)
	    q patinfo_"^"_seat
	  }
	  q ""
}

ClassMethod getPatSeat(episodeId)
{
	s des=""
	s id="" f  s id=$o(^User.DHCNurSyPatRecI("epiPatSeat",episodeId,id)) q:id=""  d
	.;s object=##class(User.DHCNurSyPatRec).%OpenId(id)
	.s status=object.SyPatStatus
	.q:status="N"
	.s seatId=object.SySeatDr
	.q:seatId=""
	.s object=##class(User.DHCNurSySeat).%OpenId(seatId)
    .s des=object.SySeatDes
    q des
}

ClassMethod Patinfo(Adm As %String) As %String
{
	//	n (Adm)
		  // s CurrentBedDR=$P(^PAADM(Adm),"^",73)
	      // q:CurrentBedDR="" ""
	       q:Adm'=+Adm ""
	       s Papmidr=$P($g(^PAADM(Adm)),"^",1)
	       s ctlocdr=$P($g(^PAADM(Adm)),"^",4)
	       s AdmDate=$ZD($P(^PAADM(Adm),"^",6),3)_" "_$ZT($P(^PAADM(Adm),"^",7))
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       i ctlocdr'="" s locdes=$P($g(^CTLOC(ctlocdr)),"^",2)
	       e  s locdes=""
           s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
           s age=##class(web.DHCCLCom).CalAge(birth,+$h)
           //s ret=Adm_"^姓名:"_Name_"^科室:"_$G(locdes)_"^"_AdmDate_"^"_RegNo_"^"_age      
           s ret=Name_"^"_$G(locdes)_"^"_Adm    
           q ret
}

ClassMethod ClearPatSeat(adm, loc, user) As %String
{
 //##class(web.DHCNurSyComm).ClearPatSeat()
           s id=""  f  s id=$O(^User.DHCNurSyPatRecI("patseat"," "_loc," "_adm,id)) q:id=""  d
           .s stat=$listget(^User.DHCNurSyPatRecD(id),9)
           .q:stat="N"
           .if (stat="Y") d
           ..s a=##class(User.DHCNurSyPatRec).%OpenId(id)
           ..s a.SyPatStatus="N"
           ..s a.SyLeavDate=$P($H,",",1)
	       ..s a.SyLeavTime=$P($H,",",2)
	       ..s a.SyUpdateUser=user
           ..d a.%Save()
           ..d a.%Close()
           ..
           q 0
}

ClassMethod SetSatus(patid, episodeid, seatid, loc, user) As %String
{
       s parr="^"_loc_"^"_patid_"^"_episodeid_"^"_seatid_"^Y"
       s a=##class(User.DHCNurSyPatRec).save(parr)
       q 0
}

ClassMethod ClearSeat(loc, seatid, stat, user) As %String
{
   //置空
      s ^T(1)=$lb(loc, seatid, stat,user)
      s id=""  s id=$O(^User.DHCNurSyPatRecI("seat"," "_loc," "_seatid," "_stat,id))
      if id'=""
      {
	    s a=##class(User.DHCNurSyPatRec).%OpenId(id)
        s a.SyPatStatus="N"
        s a.SyLeavDate=$P($H,",",1)
	    s a.SyLeavTime=$P($H,",",2)
	    s a.SyUpdateUser=user
        d a.%Save()
	  }
	  //取消安排时,同时把座位标志置为Y
	  s ret=..UpdateSeatFlag(seatid,"Y")
	  q:ret'=0 "更新座位标志出错"
     q 0
}

ClassMethod GetLocSeatExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s loc=parr
 	if loc="" 	Quit $$$OK
    s id="" f  s id=$O(^User.DHCNurSySeatI("loc"," "_loc,id)) q:id=""  d
    .s a=^User.DHCNurSySeatD(id)
    .s des=$listget(a,1)
    .s code=$listget(a,1)
    .s seatsize=$listget(a,1)
    .s seatpoint=$listget(a,1)
 	.d OutRowtyp
 	//s parr="2009-011-18^2009-12-18"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(code,des,seatsize,seatpoint,id,loc)
 	Set ^CacheTemp1(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ifnum(rw) As %String
{
 //s a=##class(web.DHCMGArrangeComm).ifnum()
	s flag="0"
    f num=1:1:$l(rw) d
    .q:flag="1"
 	.s a=$E(rw,num,num)
 	.if (($ZC(a)'<48)&($ZC(a)'>57)) d
 	..s flag="0"
 	.e  d
 	..s flag="1" 
  q flag
}

ClassMethod GetLocSeatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocSeatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp1(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp1(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocSeatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocSeatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp1(repid)
 	Quit $$$OK
}

Query GetLocSeat(parr As %String) As %Query(ROWSPEC = "code,des,seatsize,seatpoint,id,loc")
{
}

ClassMethod getConloc(funname As %String) As %String
{
 s ctlocIdList=##class(web.DHCCLCom).GetLocIdByLocListCode("CONDEPT")
 f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.;q:'$d(^CTLOC(ctlocId))
	       .s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)

 .s rtnval=funname_"('"_$ZCVT($g(ctlocId),"O","JS")_"','"_$ZCVT($g(ctlocDesc),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 q 0
}

ClassMethod getloc(funname As %String) As %String
{
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .s dateFrom=$P(^CTLOC(rw),"^",24)
 .s dateTo=$P(^CTLOC(rw),"^",25)
 .s h=+$h
 .q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 .q:c=""
 .;s c=$P(c,"-",2)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

ClassMethod getlocForSearEdit(funname As %String) As %String
{
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .s deptypeid=""
 .s deptypeid=$o(^PAC("ADMLOC",0,"AdmType","O",rw,deptypeid))
 .i deptypeid="" s deptypeid=$o(^PAC("ADMLOC",0,"AdmType","E",rw,deptypeid))
 .q:deptypeid=""
 .;s deptype=$p(^CTLOC(rw),"^",13)
 .;q:((deptype'="E")!(deptype'="E"))
 .s dateFrom=$P(^CTLOC(rw),"^",24)
 .s dateTo=$P(^CTLOC(rw),"^",25)
 .s h=+$h
 .q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 .q:c=""
 .;s c=$P(c,"-",2)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

ClassMethod GetSeatCode(loc, funname) As %String
{
  //web.DHCNurSyComm.GetSeatCode
    q:loc="" 0
	s id="" f  s id=$O(^User.DHCNurSySeatI("loc"," "_loc,id)) q:id=""  d
    .s a=^User.DHCNurSySeatD(id)
    .s des=$listget(a,4)
    .s code=$listget(a,3)
    .s locdes=$P(^CTLOC(loc),"^",2)
    .s seatsize=$listget(a,6)
    .s seatpoint=$listget(a,5)
    .s flag=$listget(a,7)
    .s rtnval=funname_"('"_$ZCVT($g(locdes),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(code),"O","JS")_"','"_$ZCVT($g(seatsize),"O","JS")_"','"_$ZCVT($g(seatpoint),"O","JS")_"','"_$ZCVT($g(loc),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(flag),"O","JS")_"');"
    .&javascript<#(rtnval)#>
 q 0
}

ClassMethod GetSeatMap(loc, funname) As %String
{
  //web.DHCNurSyComm.GetSeatCode
   if loc=""  q 0
	s id="" f  s id=$O(^User.DHCNurSySeatI("loc"," "_loc,id)) q:id=""  d
    .s a=^User.DHCNurSySeatD(id)
    .s des=$listget(a,4)
    .s code=$listget(a,3)
    .s locdes=$P(^CTLOC(loc),"^",2)
    .s seatsize=$listget(a,6)
    .if seatsize=""
    .s flag=$listget(a,7)
    .//q:flag="N"			//些标志暂使用为是否占座
    .s w=$P(seatsize,",",1)
    .s h=$P(seatsize,",",2)
    .if w="" s w=30		//默认宽度
    .if h="" s h=50		//默认高度
    .s seatpoint=$listget(a,5)
    .s x=$P(seatpoint,",",1),y=$P(seatpoint,",",2)
    .if x="" s x=10
    .if y="" s y=10
    .s border=""
    .s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(w),"O","JS")_"','"_$ZCVT($g(h),"O","JS")_"','"_$ZCVT($g(x),"O","JS")_"','"_$ZCVT($g(y),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(border),"O","JS")_"');"
    .&javascript<#(rtnval)#>
 q 0
}

/// Description: 取座位信息
/// Table：
/// Input：loc:科室ID,funname:对应JS函数
/// Return：id:座位图ID,des:座位,w:宽度,h:高度,x:X坐标,y:Y坐标,des:座位描述,border:边框,patinfo:病人信息,code:座位代码
ClassMethod GetSeatRoomMap(loc, funname) As %String
{
  //web.DHCNurSyComm.GetSeatCode
	s id="" f  s id=$O(^User.DHCNurSySeatI("loc"," "_loc,id)) q:id=""  d
    .s a=^User.DHCNurSySeatD(id)
    .s flag=$listget(a,7)
    .//q:flag="N"			//些标志暂使用为是否占座
    .s des=$listget(a,4)
    .s code=$listget(a,3)
    .s locdes=$P(^CTLOC(loc),"^",2)
    .s seatsize=$listget(a,6)
    .s w=$P(seatsize,",",1)
    .s h=$P(seatsize,",",2)
    .if w="" s w=30	//默认宽度
    .if h="" s h=50	//默认高度
    .i des["+" d
    ..s w=50		//加座
    ..s h=30
    .s seatpoint=$listget(a,5)
    .s x=$P(seatpoint,",",1),y=$P(seatpoint,",",2)
    .if x="" s x=10
    .if y="" s y=10
    .s border="background-color:#51AFEF"     //#7EC0EE
    .//s patinfo=..gethtml(..getpat(loc,id,"Y"))		//暂不在座位上加超链接
    .s patinfo=..getpat(loc,id,"Y")
    .;s patFirstDate=..get
    .// zzz 20160603 增加页面病人信息显示
    .s patName=$p(patinfo,"^",1)
    .s admLoc=$p(patinfo,"^",2)
    .s:admLoc["-" admLoc=$p(admLoc,"-",2)
    .s seatdate=$p(patinfo,"^",8)
    .s seattime=$p(patinfo,"^",9)
    .s seatdatetime=""
	.s:seatdate'="" seatdatetime=$p($zd(seatdate,3),"-",2,3)_" "_$zt(seattime,2)
    .i patinfo="" d
    ..s des=des_"   <img src='../images/uiimages/lgsdz.png'/> "
    ..s patinfo="<p align='left'><font size='2' color='white'>"_des_"</font></p>"
    ..s border="background-color:#2FBE6C" 
    .e  d
    ..s des=des_"   <img src='../images/uiimages/lgsdz.png'/> "
    ..s patinfo="<p align='left'><font size='2' color='white'>"_des_"</font></p>"
    ..s patinfo=patinfo_"<p align='left'><font size='2' color='white'>"_patName_"</font></p>"
    ..s patinfo=patinfo_"<p align='left'><font size='1' color='white'>"_admLoc_"</font></p>"
    ..s patinfo=patinfo_"<p align='left'><font size='1' color='white'>"_seatdatetime_"</font></p>"
    .i flag="N" s border="background-color:#FFFF37"		//占座显示黄色
    .s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(w),"O","JS")_"','"_$ZCVT($g(h),"O","JS")_"','"_$ZCVT($g(x),"O","JS")_"','"_$ZCVT($g(y),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(border),"O","JS")_"','"_$ZCVT($g(patinfo),"O","JS")_"','"_$ZCVT($g(code),"O","JS")_"');"
    .&javascript<#(rtnval)#>

    
    /*
    .i patinfo="" d
    ..s patinfo="<p align='center'><font size='5'>"_des_"</font></p>"
    ..s border="background-color:#CCFFCC" 
    .e  d
    ..s patinfo="<p align='center'><font size='5'>"_des_"</font></p>"
    .i flag="N" s border="background-color:#FFFF37"		//占座显示黄色
    .s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(w),"O","JS")_"','"_$ZCVT($g(h),"O","JS")_"','"_$ZCVT($g(x),"O","JS")_"','"_$ZCVT($g(y),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"','"_$ZCVT($g(border),"O","JS")_"','"_$ZCVT($g(patinfo),"O","JS")_"','"_$ZCVT($g(code),"O","JS")_"');"
    .&javascript<#(rtnval)#>
    */
 q 0
}

ClassMethod gethtml(pat) As %String
{
	s l=$l(pat,"^")
	if pat="" q ""
	s ret=""
	//只取病人姓名,l=1
	f i=1:1:1
	{
		;s ret=ret_"<h1>"_$P(pat,"^",i)_"</h1>"
		i i=1 d
		.;s ret="<h1><a href='#' onClick=window.open('dhcnuropexec.csp?EpisodeID="_$P(pat,"^",3)_"&SeatNo="_$P(pat,"^",4)_"','_blank','top=0,left=0,width=1020,height=700')><font size='4'>"_$P(pat,"^",4)_"</font></a></h1>"
		.s ret="<p align='center'><a href='#' onClick=window.open('dhcnuropexec.csp?EpisodeID="_$P(pat,"^",3)_"&SeatNo="_$P(pat,"^",4)_"','_blank','scrollbar=yes,resizable=yes,top=0,left=0,width=1020,height=700')><font size='5'>"_$P(pat,"^",4)_"</font></a></p>"
		e  d
		.s ret=ret_"<p>"_$P(pat,"^",i)_"</p>"

	}
	q ret
}

ClassMethod getseatinfo(id) As %String
{
    s a=^User.DHCNurSySeatD(id)
    s des=$listget(a,4)
    s code=$listget(a,3)
    s seatsize=$listget(a,6)
    s seatpoint=$listget(a,5)
    s flag=$listget(a,7)
    q des_"^"_code_"^"_seatsize_"^"_seatpoint_"^"_flag
}

/// 通过登记号找病人就诊ID
ClassMethod GetCurrAdm1(RegNo) As %String
{
  	//n (RegNo)
  	q:RegNo="" ""
  	s nvar=""
	s ln=$L(RegNo)
	s le=9-ln
	s $P(nvar,"0",le)=RegNo
	s papmi=""
	s CurrAdm=0
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",nvar,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..;s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus'="A"
	..s Typ=$p(^PAADM(Adm),"^",2)
	..q:Typ'="I"
	..if Adm>CurrAdm  s CurrAdm=Adm
	.
	if CurrAdm=0 s CurrAdm=""
	q CurrAdm
}

/// 通过卡号或登记号取病人就诊ID
ClassMethod GetCurrAdm(patCardNo As %String = "", regNo As %String = "", hospId As %String = "", ctloc As %String = "") As %String
{
	//w ##class(web.DHCNurSyComm).GetCurrAdm("000000000023")
	s CurrAdm=""
	q:(patCardNo="")&(regNo="") CurrAdm
	if (patCardNo'=""){
		s ind=$O(^DHCCARDi("CF",0,"CardNo",patCardNo,""),-1)
		q:ind="" CurrAdm
		q:'$d(^DHCCARD("CF",ind)) CurrAdm
		q:$p($g(^DHCCARD("CF",ind)),"^",10)'="N" CurrAdm
		s patientId=$p($g(^DHCCARD("CF",ind)),"^",4)
		q:patientId="" CurrAdm
		s regNo=$p($g(^PAPER(patientId,"PAT",1)),"^",2)
		s patName=$p($g(^PAPER(patientId,"ALL")),"^",1)
		s CurrAdm=..getCurrentEpisodeId(patientId)
		q:CurrAdm="" ""
		s VisitStatus=$P(^PAADM(CurrAdm),"^",20)
		q:VisitStatus="C" ""
		s CurrHosp = ""
		i CurrAdm'="" d
		.s PAADMDepCodeDR = $p($g(^PAADM(CurrAdm)),"^",4)
		.S CurrHosp = $p($g(^CTLOC(PAADMDepCodeDR)),"^",22)
		q:CurrHosp'=hospId ""
		s id = ""
		f  s id=$O(^User.DHCNurSyPatRecI("sypatid"," "_ctloc," "_$tr(patCardNo,"")," Y",id)) q:id=""  d
		.s nurSyPatRec=##class(User.DHCNurSyPatRec).%OpenId(id)
		.s CurrAdm = nurSyPatRec.SyPatEpisode
		q:CurrAdm'="" CurrAdm_"^"_regNo_"^"_patName_"^"_patCardNo
		q CurrAdm
	}
	else {
		if (regNo'=""){
			s patConfig=##class(web.DHCCLCom).GetPatConfig()
			s regNoLong=$p(patConfig,"^")
			s nvar=""
			s ln=$L(regNo)
			s le=regNoLong+1-ln
			q:le<=0 ""
			s $P(nvar,"0",le)=regNo
			s nvar=$$ALPHAUP^SSUTIL4(nvar)
			s patientId=""
			s patientId=$O(^PAPERi("PAPMI_PatNo",nvar,patientId),-1)
			q:patientId="" CurrAdm
			s patName=$P($G(^PAPER(patientId,"ALL")),"^",1)
			s CurrAdm=..getCurrentEpisodeId(patientId)
			q:CurrAdm="" ""
			s VisitStatus=$P(^PAADM(CurrAdm),"^",20)
			q:VisitStatus="C" ""
			s cardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",patientId,""),-1)
			;q:cardDr="" CurrAdm
			i cardDr'="" s patCardNo=$P($G(^DHCCARD("CF",cardDr)),"^",2)
			S CurrHosp = ""
			i CurrAdm'="" d
			.s PAADMDepCodeDR = $p($G(^PAADM(CurrAdm)),"^",4)
			.S CurrHosp = $p($G(^CTLOC(PAADMDepCodeDR)),"^",22)
			q:CurrHosp'=hospId ""
			b ;4
			s id = ""
			f  s id=$O(^User.DHCNurSyPatRecI("sypatid"," "_ctloc," "_$tr(patCardNo,"")," Y",id)) q:id=""  d
			.s nurSyPatRec=##class(User.DHCNurSyPatRec).%OpenId(id)
			.s CurrAdm = nurSyPatRec.SyPatEpisode
			.b ;3
			q:CurrAdm'="" CurrAdm_"^"_regNo_"^"_patName_"^"_patCardNo
			q CurrAdm
		}	
	}
}

ClassMethod getCurrentEpisodeId(patientId)
{
	s episodeId=""
	s adm="" f  s adm=$O(^PAPERdr(patientId,"ADM","O",adm),-1) q:(adm="")!(episodeId'="")  d
	.s admDate=$P(^PAADM(adm),"^",6)
	.b
	.q:admDate>+$h
	.s episodeId=adm
	i episodeId="" d
	.s adm=""
	.f  s adm=$O(^PAPERdr(patientId,"ADM","E",adm),-1) q:(adm="")!(episodeId'="")  d
	..b
	..s admDate=$P(^PAADM(adm),"^",6)
	..q:admDate>+$h
	..s episodeId=adm
	q episodeId
}

/// Description:通过科室ID与座位ID取病人基本信息
/// Table：
/// Input：LocID:科室ID,SeatID:座位ID
/// Return：病人就诊ID^病人姓名^卡号^座位号
ClassMethod GetPatBySeatID(LocID As %String = "", SeatID As %String = "") As %String
{
	//w ##class(web.DHCNurSyComm).GetPatBySeatID("63",10)
	q:(LocID="")!(SeatID="") ""
    s EpisodID="",PatName="",cardno="",seat="",regNo="",updateDateTime=""
    s id=""  s id=$O(^User.DHCNurSyPatRecI("seat"," "_LocID," "_SeatID," Y",id),-1)
    if id'=""
    {
	    s a=^User.DHCNurSyPatRecD(id)
	    s EpisodID=$listget(a,3)
	    q:EpisodID'=+EpisodID
	    s patid="" s patid=$O(^User.DHCNurSyPatRecI("patseat"," "_LocID," "_EpisodID,patid))
	    i patid'="" d
	    .s b=^User.DHCNurSyPatRecD(patid)
	    .s updateDate=$listget(b,6)
	    .s updateTime=$listget(b,7)
	    ;s updateDate=$listget(a,6)
	    ;s updateTime=$listget(a,7)
	    i updateDate'="",updateTime'="" s updateDateTime=$$$zd(updateDate,3)_" "_$zt(updateTime)
	    
	    s Papmidr=$P($g(^PAADM(EpisodID)),"^",1)
	    s PatName=$P($g(^PAPER(Papmidr,"ALL")),"^",1)
	    s regNo=$p($g(^PAPER(Papmidr,"PAT",1)),"^",2)
	    s cardno=$listget(a,4)
	}
	s seat=$listget(^User.DHCNurSySeatD(SeatID),3)
	s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodID)
	Set EncryptLevel=$p(PatEncryptLevel,"^",1)  
    Set PatLevel=$p(PatEncryptLevel,"^",2) 
	q EpisodID_"^"_PatName_"^"_cardno_"^"_seat_"^"_regNo_"^"_EncryptLevel_"^"_PatLevel_"^"_updateDateTime
}

/// Creater: wangxinlei
/// Description:通过科室ID取座位号与病人基本信息
/// Table：DHCNurSySeat,DHCNurSyPatRec,
/// Input：LocID:科室ID,SeatID:座位ID
/// Return：座位号^病人姓名^卡号^就诊ID
Query GetSYPat(CTLocID As %String, ifSYCall As %String = "") As %Query(ROWSPEC = "SeatNo:%String,PatName:%String,CardNo:%String,EpisodeID:%String,IfExecOrd:%String,EncryptLevel:%String,PatLevel:%String,QueueNo:%String")
{
}

ClassMethod GetSYPatExecute(ByRef qHandle As %Binary, CTLocID As %String, ifSYCall As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i CTLocID="" s CTLocID=$G(%session.Data("LOGON.CTLOCID"))
 	k ^mtemp($J)
    s SeatNo="",PatName="",CardNo="",EpisodeID=""
    s SeatID="" f  s SeatID=$O(^User.DHCNurSySeatI("loc"," "_CTLocID,SeatID)) q:SeatID=""  d
    .s a=^User.DHCNurSySeatD(SeatID)
    .s flag=$listget(a,7)
    .q:flag="N"
    .s SeatNo=$listget(a,4)
    .s id=""  s id=$O(^User.DHCNurSyPatRecI("seat"," "_CTLocID," "_SeatID," Y",id),-1)
    .i id'="" d
	..s a=^User.DHCNurSyPatRecD(id)
	..s EpisodeID=$listget(a,3)
	..q:EpisodeID'=+EpisodeID
	..s Papmidr=$P($g(^PAADM(EpisodeID)),"^",1)
	..i Papmidr'="" s PatName=$P(^PAPER(Papmidr,"ALL"),"^",1)
	..e  s PatName=""
	..s CardNo=$listget(a,4)
	..s UpdateDate=$listget(a,6)
	..s UpdateTime=$listget(a,7)
	..s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
 	..s EncryptLevel=$p(PatEncryptLevel,"^",1)  
    ..s PatLevel=$p(PatEncryptLevel,"^",2) 
    ..s EpisodeIDO=$O(^PAPERdr(Papmidr,"ADM","O",""),-1)
	..s:EpisodeIDO="" EpisodeIDO=0
	..s EpisodeIDE=$O(^PAPERdr(Papmidr,"ADM","E",""),-1) //add by linyuxu
	..s:EpisodeIDE="" EpisodeIDE=0
	..s CurrAdm=""
	..i EpisodeIDO>EpisodeIDE s CurrAdm=EpisodeIDO
	..e  s CurrAdm=EpisodeIDE
    ..s QueueNo=""
    ..s QueueId=$o(^User.DHCNurTreatQueueI("AdmDateLoc"," "_CurrAdm,+$h," "_CTLocID,""),-1)
    ..i QueueId'="" d
    ...s QueueObj=##class(User.DHCNurTreatQueue).%OpenId(QueueId)
    ...s QueueNo=QueueObj.TreatQueNo
    ..s ^mtemp($J,UpdateDate,UpdateTime)=SeatNo_"^"_PatName_"^"_CardNo_"^"_EpisodeID_"^"_EncryptLevel_"^"_PatLevel_"^"_QueueNo

	s UpdateDate=""  f  s UpdateDate=$O(^mtemp($J,UpdateDate),-1) q:UpdateDate=""  d
	.s UpdateTime="" f  s UpdateTime=$O(^mtemp($J,UpdateDate,UpdateTime),-1)  q:UpdateTime=""  d
	..s SeatNo=$p(^mtemp($J,UpdateDate,UpdateTime),"^",1)
	..s PatName=$p(^mtemp($J,UpdateDate,UpdateTime),"^",2)	
	..s CardNo=$p(^mtemp($J,UpdateDate,UpdateTime),"^",3)   
	..s EpisodeID=$p(^mtemp($J,UpdateDate,UpdateTime),"^",4)
	..s IfExecOrd=..GetPatSYOrder(EpisodeID)
	..i IfExecOrd="" s IfExecOrd="N"
	..e  s IfExecOrd="Y"
	..s EncryptLevel=$p(^mtemp($J,UpdateDate,UpdateTime),"^",5)   
    ..s PatLevel=$p(^mtemp($J,UpdateDate,UpdateTime),"^",6)   
    ..s QueueNo=$p(^mtemp($J,UpdateDate,UpdateTime),"^",7)  
	..Do OutwardRow
	k ^mtemp($J) 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(SeatNo,PatName,CardNo,EpisodeID,IfExecOrd,EncryptLevel,PatLevel,QueueNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSYPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSYPatExecute ]
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

ClassMethod GetSYPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSYPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creater: 	wangxinlei
/// Description:判断病人医嘱是否已执行(输液单)
/// Table：		OE_Order,OE_OrdItem,OE_OrdExec
/// Input：		EpisodeID:病人ID
/// Return：	执行过医嘱返回Y,否则返回N
ClassMethod GetPatSYOrder(EpisodeID As %String = "") As %String
{
	//w ##class(web.DHCNurSyComm).GetPatSYOrder("185")
	q:EpisodeID="" ""
	s ret=""
	s wardId="",gap="",locId="",admType="OE",exeFlag=1,queryTypeCode="Default",tempId=$j,HospitalRowId=0
	s startDate=+$H
	s endDate=+$H
	s regNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
	s rset=##class(%ResultSet).%New("web.DHCNurCom:FindOrditem")
	do rset.Execute(wardId,regNo,tempId,startDate,endDate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId)
	while (rset.Next()) {
		i ret=""  s ret=rset.GetData(9)
		e  s ret=ret_","_rset.GetData(9)
	}	
	d rset.Close()
	q ret
}

/// Creater:wangxinlei
/// Description: 取所有座位
/// Table：
/// Input：loc:科室ID,funname:对应JS函数
/// Return：id:座位图ID,des:座位
ClassMethod GetSeatList(loc, funname) As %String
{
  	//web.DHCNurSyComm.GetSeatCode("174","")
	s id="" f  s id=$O(^User.DHCNurSySeatI("loc"," "_loc,id)) q:id=""  d
    .s a=^User.DHCNurSySeatD(id)
    .s flag=$listget(a,7)
    .q:flag="N"
    .s des=$listget(a,4)
    .s seatpatid=$O(^User.DHCNurSyPatRecI("seat"," "_loc," "_id," Y",0))
    .q:seatpatid'=""
    .;s seatid=..GetPatBySeatID(loc,id)
    .;q:seatid'=""
    .s rtnval=funname_"('"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"');"
    .&javascript<#(rtnval)#>
 q 0
}

/// 更新座位标志
ClassMethod UpdateSeatFlag(seatid, seatfalg = "Y")
{
	q:seatid="" 0
	q:"YN"'[seatfalg 0
	s a=^User.DHCNurSySeatD(seatid)
    s flag=$listget(a,7)
    q:flag=seatfalg 0
	&sql(update SQLUser.DHCNurSySeat set SySeatFlag=:seatfalg where ID=:seatid)
	q SQLCODE
}

/// 更新座位坐标
ClassMethod UpdateData(begin, end, x, y)
{
	s location=x_","_y
	f i=begin:-1:end
	{
		//&sql(update DHCNurSySeat set SySeatLocation=:x where SyLoc=174 and SySeatCode=:i)
		//s x=x+30
		//s $p(location,",",1)=x
	}
}

/// Creater: I
/// Description:通过科室ID取急诊留观病人基本信息
/// Input：LocID:科室ID,SeatID:座位ID
/// Return：座位号^病人姓名^卡号^就诊ID
/// Test:d ##class(%ResultSet).RunQuery("web.DHCNurSyComm","FindJZLGPat",159)
Query FindJZLGPat(CTLocID As %String, ifSYCall As %String = "") As %Query(ROWSPEC = "patRegNo:%String,patName:%String,bedCode:%String,EpisodeID:%String,sex:%String")
{
}

ClassMethod FindJZLGPatExecute(ByRef qHandle As %Binary, ctlocDr As %String, ifSYCall As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ctlocDr="" s ctlocDr=$G(%session.Data("LOGON.CTLOCID"))
	q:ctlocDr="" ""
	s groupSort=""
	s WardID=$o(^PAWARD(0,"WARD_LocationDR",ctlocDr,""))
	q:WardID="" ""
	s curRoomId="" f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s groupCode=""
	..i groupSort="true" d findGroupCode
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
 	..q:bedCode=""
 	..i (bedCode'["婴儿")&&(+bedCode'=0) s bedCode=+bedCode
 	..s motherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
 	..i motherAdm'="" d 
 	...s motherBedSub=$p($g(^PAADM(motherAdm)),"^",73)
 	...i motherBedSub=""
 	...s motherCurWardId=$P(motherBedSub,"||",1)
	...s motherCurBedSub=$P(motherBedSub,"||",2)
	...i (motherCurWardId="")!(motherCurBedSub="") d
	....d saveInfo
	...e  d 
	....s motherBedCode=$p($g(^PAWARD(motherCurWardId,"BED",motherCurBedSub)),"^",1)
	....i (motherBedCode'["婴儿")&&(+motherBedCode'=0) s motherBedCode=+motherBedCode
	....d saveChildInfo
    ..e  d saveInfo
    
    
     //等候区
	s x=10000000
    s y=10000000
    s waitNums=1
    s groupCode="Waiting"
    s group(groupCode)="等候区"

	s wardAdmid=0 f  s wardAdmid=$o(^PAWARDA(WardID,"WADM",wardAdmid)) q:wardAdmid=""  d
	.s EpisodeID=$p(^PAWARDA(WardID,"WADM",wardAdmid),"^",1)
	.s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:(pavisit="D")
    .s admType=$p(^PAADM(EpisodeID),"^",2)
	.q:admType'="I"
	.s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	.s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	.s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	.s bedCode="等候区"_waitNums
	.s waitNums=waitNums+1
	.s sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
    .d saveInfo
    .s y=y+1
    
    s group("BedSort")="床位"
	;W "["
	s groupNum=0
	s sortGroupCode="" f  s sortGroupCode=$o(tmpBedSort(sortGroupCode)) q:sortGroupCode=""  d
	.;i groupNum=0 s dot="" 
	.;e  s dot=","
	.;w dot_"{text:'"_group(sortGroupCode)_"',checked:false,children:["
	.s groupNum=groupNum+1
	.s num=0
	.s sortMotherbedCode="" f  s sortMotherbedCode=$o(tmpBedSort(sortGroupCode,sortMotherbedCode)) q:sortMotherbedCode=""  d
	..s patRegNo=$P(tmpBedSort(sortGroupCode,sortMotherbedCode),"^",1)
	..s patName=$P(tmpBedSort(sortGroupCode,sortMotherbedCode),"^",2)
	..s bedCode=$P(tmpBedSort(sortGroupCode,sortMotherbedCode),"^",3)
	..s EpisodeID=$P(tmpBedSort(sortGroupCode,sortMotherbedCode),"^",4)
	..s sex=$P(tmpBedSort(sortGroupCode,sortMotherbedCode),"^",5)
	..;s sex=$s(sex="男":"man",sex="女":"woman",1:"man")
	..s sortBedCode=""
	..Do OutwardRow
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(patRegNo,patName,bedCode,EpisodeID,sex)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
saveInfo
	i groupCode'="" s tmpBedSort(groupCode,bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID_"^"_sex
	e  s tmpBedSort("BedSort",bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID_"^"_sex
	q
saveChildInfo
	i groupCode'="" s tmpBedSort(groupCode,motherBedCode,bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID_"^"_sex
	e  s tmpBedSort("BedSort",motherBedCode,bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID_"^"_sex
	q
findGroupCode
	s groupBedDr=$o(^DHCWardProGroupBed(0,"PacBedDr",bedSub,0))
	q:groupBedDr=""
	s groupDr=$p(^DHCWardProGroupBed(groupBedDr),"^",1)
	q:groupDr=""
	s active=$p(^DHCWardProGroup(groupDr),"^",3)
	q:active'="Y"
	s groupCode=$p(^DHCWardProGroup(groupDr),"^",1)
	s groupDesc=$p(^DHCWardProGroup(groupDr),"^",2)
	s group(groupCode)=groupDesc
	q
}

ClassMethod FindJZLGPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSYPatExecute ]
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

ClassMethod FindJZLGPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSYPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
