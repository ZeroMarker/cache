Class web.DHCNurRecPrint Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 获取病人所有科室

ClassMethod gettranloc(funname As %String, adm) As %String
{
	//w ##class(web.DHCNurRecPrint).gettranloc("","2573670")
	q:(adm="")
	s ret=""
	s lastlocDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s locDr=$p(^PAADM(adm,"TRANS",childSub),"^",6)
	.q:locDr=""
	.q:lastlocDr=locDr
	 .s c=$P(^CTLOC(locDr),"^",2)
	 .q:c=""
	 .;s c=$P(c,"-",2)
	 .s rtnval=funname_"('"_$ZCVT($g(locDr),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
	 .&javascript<#(rtnval)#>
 	.//w !,b
	 q 0
}

// 获取病人转科记录：病区

ClassMethod gettranward(funname As %String, adm) As %String
{
	//w ##class(web.DHCNurRecPrint).gettranward("","2573670")
	q:(adm="")
	s ret=""
	s lastlocDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	.q:lastlocDr=wardDr
	.s lastlocDr=wardDr
	 .s c=$P(^PAWARD(wardDr),"^",5)
	 .s desc=$P(^CTLOC(c),"^",2)
	 .q:c=""
	 .;s c=$P(c,"-",2)
	 .s rtnval=funname_"('"_$ZCVT($g(c),"O","JS")_"','"_$ZCVT($g(desc),"O","JS")_"');"
	 .&javascript<#(rtnval)#>
 	.//w !,b
	 q 0
}

// w ##class(web.DHCNurRecPrint).SaveChange(54192||1191598^54192||1191597,10,)

ClassMethod SaveChange(id, loc, bed, nurseloc) As %String
{
	//s ^rowlco=id_"*"_loc_"*"_bed
  	q:id="" ""
  	s l=$l(id,"^")
  	for i=1:1:l d
  	
	  	.s ids=$p(id,"^",i)
	  	.q:ids="" 
	    .s a=##class(Nur.DHCNurseRecSub).%OpenId(ids)
	    .i loc'="" s a.RecLoc=loc
	    .s a.RecBed=bed
	    .i nurseloc'="" s a.RecNurseLoc=nurseloc
	    .d a.%Save()
  	
	q 0
}

// 获取某条记录绑定的科室床号

ClassMethod getlocbed(id) As %String
{
	//s ^rowlco=id_"*"_loc_"*"_bed
  	q:id="" ""
  	s ret=""
	    s a=##class(Nur.DHCNurseRecSub).%OpenId(id)
	    s loc=a.RecLoc
	    i loc'="" s locdesc=$p(^CTLOC(loc),"^",2)
	    s bed=a.RecBed
	    s nurseloc=a.RecNurseLoc
	    i nurseloc=""  d
	    .s par=$p(id,"|")
	    .s b=##class(Nur.DHCNurseRecParent).%OpenId(par)
	    .s adm=b.Adm
	    .q:adm=""
	    .s date=a.CareDate
	    .s time=a.CareTime
	    .s dt=..GetAbsTime(date_","_time)
	    .s nurseloc=..getpatlocbydatetime(adm,dt)
	    s ret=loc_"^"_bed_"^"_nurseloc
	 
	q ret
}

// 获取病人所有床号

ClassMethod gettranbed(funname As %String, adm) As %String
{
	//w ##class(web.DHCNurRecPrint).gettranbed("add","7890406")
	q:(adm="")
	s ret=""
	s lastbeddr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:childSub=""  d
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.s beddr=$p(^PAADM(adm,"TRANS",childSub),"^",8)
	.s bedward=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.S pacwarddesc=""
	.I bedward'="" s pacwarddesc=$p(^PAWARD(bedward),"^",1)
	.s warddr=$p(beddr,"||",1)
	.s bedsub=$p(beddr,"||",2)
	.q:beddr=""
	.q:lastbeddr=beddr
	.s a=$p($g(^PAWARD(warddr,"BED",bedsub)),"^",1)
	.q:a=""
	.//s b=pacwarddesc_","_a
	.;s c=$P(c,"-",2)
	.s rtnval=funname_"('"_$ZCVT($g(a),"O","JS")_"','"_$ZCVT($g(a),"O","JS")_"');"
	.&javascript<#(rtnval)#>
 	.//w !,b
	 q 0
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

// 根据护理记录日期时间判定当时病人所在的病房id

// w ##class(web.DHCNurRecPrint).getpatlocbydatetime("7720090","2014-10-08","09:03")

ClassMethod getpatlocbydatetime(adm, datetime) As %String
{
	s ret=""
	//s date=$zdh(date,3)
	//s time=$zth(time,3)
	//s datetime=..GetAbsTime(date_","_time)
	s lastWardDr=""
	s childSub=0
	f  s childSub=$o(^PAADM(adm,"TRANS",childSub)) q:(childSub="")!(ret'="")  d
	.s wardDr=$p(^PAADM(adm,"TRANS",childSub),"^",9)
	.q:wardDr=""
	.q:ret'=""
	.s startDate=$p(^PAADM(adm,"TRANS",childSub),"^",1)
	.s startTime=$p(^PAADM(adm,"TRANS",childSub),"^",2)
	.s endDate=$p(^PAADM(adm,"TRANS",childSub),"^",3)
	.s endTime=$p(^PAADM(adm,"TRANS",childSub),"^",4)
	.i endDate=""  s endDate=+$h
	.i endTime=""  s endTime=$p($h,",",2)
	.s stdt=..GetAbsTime(startDate_","_startTime) //开始时间
	.s eddt=..GetAbsTime(endDate_","_endTime)     //结束时间
	.i (datetime<=eddt)&(datetime>stdt) d
	..s ret=$p(^PAWARD(wardDr),"^",5)
	q ret
}

ClassMethod GetNurloc(loc As %String) As %String
{
	//s a=##class(Nur.DHCNurCopyDiagnos).GetNurDiagnos("1")
	s ^TMPTY("GetNurloc")=loc
	s locdesc=""
	i loc'="" s locdesc=$p($g(^CTLOC(loc)),"^",2)
	i locdesc["-" s locdesc=$P(locdesc,"-",2)
	q locdesc
}

// 获取关联的第一个病人科室

ClassMethod GetFirstNulRecloc(parr As %String) As %String
{
	//s a=##class(Nur.DHCNurCopyDiagnos).GetNurDiagnos("1")
	s ^TMPTY("GetFirstNulRecloc")=parr
	s Adm=$p(parr,"!")
	s RecTyp=$p(parr,"!",2)
	s RecTyp=$ZConvert(RecTyp,"U")
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	s loc=""
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(loc'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(loc'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(loc'="")  d
    ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
    ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
    ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
    ...s id=par_"||"_rw
    ...s a=##class(Nur.DHCNurseRecSub).%OpenId(id)
    ...s reccanceluserId=a.RecCancelUser
	...q:reccanceluserId'=""
	...i a.RecLoc'="" s loc=a.RecLoc
	q loc
}

// 获取关联的第一个护士科室

ClassMethod GetFirstNulRecNurseloc(parr As %String) As %String
{
	   //s a=##class(Nur.DHCNurCopyDiagnos).GetNurDiagnos("1")
	   s ^TMPTY("GetFirstNulRecNurseloc")=parr
	   s Adm=$p(parr,"!")
	   s RecTyp=$p(parr,"!",2)
	   s RecTyp=$ZConvert(RecTyp,"U")
	   s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	   s loc=""
	   s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(loc'="")  d
       .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(loc'="")  d
       ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(loc'="")  d
       ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
       ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
       ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
       ...s id=par_"||"_rw
       ...s a=##class(Nur.DHCNurseRecSub).%OpenId(id)
       ...s reccanceluserId=a.RecCancelUser
	   ...q:reccanceluserId'=""
	   ...i a.RecNurseLoc'="" s loc=a.RecNurseLoc
	   ...i loc=""  d  //续打及图片转科
       ....s loc=..getpatlocbydatetime(Adm,fdatetim)
       ...b ;2
	   q loc
}

ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="337862!2011-01-07!11:15!!!DHCNUR6"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurRecPrint","GetCareRecComm",^objcyfff)
 	
 	s ^objcyfff=parr
 	i parr["&" s parr=$tr(parr,"&",":")
 	i parr["$" s parr=$tr(parr,"$",":")
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")
    s flag="" //续打
	s ll=$l(parr,"!") //续打
	i (ll=8) d  //续打
	.s flag=$P(parr,"!",8) //续打
	i RecTyp="DHCNURANHUI22GRID" s RecTyp="DHCNURANHUI22"
	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		b ;3
		//"0^0^"_stdate_"^"_stim_"^^"
		if arr=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	   
		s stdate=$P(arr,"^",3)
		s StTime=$P(arr,"^",4)
	    
	}
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	
	i StTime[":" s StTime=$ZTH(StTime,3)
 	if $P(parr,"!",2)'="" d
 	.s stdate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"!",2))
 	
 	if $P(parr,"!",4)'="" d
 	.s eddate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"!",4))
 	e  s eddate=$P($H,",")
 	if $P(parr,"!",3)'="" s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s endatetime=endatetime+3600
 	//s RecTyp=$P(parr,"!",6)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s fdatetim=""
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
    ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
    ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
    ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
	//血压及显示到病情变化列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	//s Pressure=$P(ret,"^",5)
	s CaseMeasureItem=$P(ret,"^",7)
    s PrnItm=$P(ret,"^",5)
    
    s qflag="" //1 不退出循环 //续打
	s prnflag="" //是否打印 //续打
    i flag'="" d   //续打
    .s id=""
    .s id=$o(^Nur.DHCNurRecPrintStPosI("Rowid"," "_flag,""))
    .i id'="" d
    ..s a=##class(Nur.DHCNurRecPrintStPos).%OpenId(id)
    ..s prnflag=a.Prnflag
    b ;3
    
      //生成图片用
      s firstid=""     
      s PictureAll=""
      i parr["$" d
      .s itm=$p(parr,"$",2)
      .s emrcode=$p(itm,"*",1)
      .s PictureAll=$p(itm,"*",2)
      .s emrcode=$zcvt(emrcode,"U")
      .s firstid=##class(Nur.DHCNurMakePictureHistory).getfirstid(Adm,emrcode)
      s prediagnosis=""
	f date=stdate:1:eddate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s rowid=par_"||"_rw
        ..i (firstid'="")&(rowid=firstid) d   //生成图片
        ...s firstid=""                       //生成图片
        ..q:(firstid'="")&(PictureAll'="Y")   //生成图片
        ..s rowid=par_"||"_rw //续打
        ..i rowid=flag d //续打
        ...s qflag=1 //续打
        ..q:(flag'="")&&((qflag="")||((rowid=flag)&&(prnflag="1")))  //续打
        ..s tmp=""
        ..s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..//作废护理记录不打印
		..s reccanceluserId=tmp("RecCancelUser")
		..q:reccanceluserId'=""
		..s CaseMeasure=tmp("CaseMeasure")
		..s CareDate=cdate,CareTime=ctime
		..s tmp("CareDateTim")=CareDate_"/"_CareTime
		..s CareDate=$P(CareDate,"-")_"-"_$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
		..s CareTime=$P(CareTime,":",1)_":"_$P(CareTime,":",2)
		..s tmp("CareDate")=CareDate,tmp("CareTime")=CareTime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s recaudituserId=tmp("RecAuditUser")
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s tmp("User")=tmp("User")_" "_AuditUser
		..//s DiagnosDr=tmp("DiagnosDr")
		..for nn=1:1:$l(PrnItm,"/") d
		...s itm=$P(PrnItm,"/",nn)
		...q:itm=""
		...s tmp($P(itm,"&"))=..getitmdata(itm,.tmp)
		..s tmp("CaseMeasure")=..getcasedata(CaseMeasureItem,.tmp)_tmp("CaseMeasure")
		..s tmp("par")=par //续打
        ..s tmp("rw")=rw  //续打
        ..i $g(tmp("RecNurseLoc"))=""  d  //续打及图片转科
        ...s tmp("RecNurseLoc")=..getpatlocbydatetime(Adm,cdatetime)  //$p(^SSU("SSUSR",recuserId),"^",4)
        ..i $g(tmp("RecWard"))=""  d
        ...s tmp("RecWard")=..getpatlocbydatetime(Adm,cdatetime)
        ..i RecTyp="DHCNURANHUI4" d
        ...i (tmp("Item8")'="")!(tmp("Item9")'="") s tmp("Item8")=tmp("Item8")_"/"_tmp("Item9")
        ...i (tmp("Item10")'="")!(tmp("Item11")'="") s tmp("Item10")=tmp("Item10")_"/"_tmp("Item11")
        ...i (tmp("Item12")'="")!(tmp("Item13")'="") s tmp("Item12")=tmp("Item12")_"/"_tmp("Item13")
        ...i (tmp("Item21")'="")!(tmp("Item22")'="") s tmp("Item21")=tmp("Item21")_"/"_tmp("Item22")
        ...i (tmp("Item23")'="")!(tmp("Item24")'="") s tmp("Item23")=tmp("Item23")_"/"_tmp("Item24")
        ...i (tmp("Item26")'="")!(tmp("Item27")'="") s tmp("Item26")=tmp("Item26")_"/"_tmp("Item27")
        ..i RecTyp="DHCNURANHUI27" d
        ...s tmp("Item4")=tmp("Item4")_"/"_tmp("Item5")
        ..i RecTyp="DHCNURXH_CRLNEW" d
        ...i tmp("Item1")["____"  d
        ....s tmp("CareDate")=""
        ....s tmp("CareTime")=""
        ...s iflag=$o(^Nur.DHCNurseRecSubI("OeoreId"," "_par_"||"_rw,par,""))
        ...i iflag'=""  d  //如果该条医嘱有小结过
        ....s subid=par_"||"_iflag
        ....s bsub=##class(Nur.DHCNurseRecSub).%OpenId(subid)
        ....i bsub.RecCancelUser="" d  //并且小结记录未作废则不打印日期和时间
        .....s tmp("CareDate")=""
        .....s tmp("CareTime")=""
        ..s CareDate2=tmp("CareDate")
        ..b //99
        ..s CareDate=##class(websys.Conversions).DateHtmlToLogical(CareDate2)
		..s CareDate3=##class(websys.Conversions).DateLogicalToHtml(CareDate) 
		..s tmp("CareDate")=CareDate3
		..b //100
		..//护理计划特殊显示
		..i RecTyp="DHCNURBG_NFYYHLJH"  d	
		...s diagnosis=tmp("Item2")
		...i diagnosis=prediagnosis&&(prediagnosis'="") s tmp("Item2")=""
		...e  s prediagnosis=tmp("Item2")	
		...i tmp("Item49")'=""&&(tmp("Item7")="") s tmp("Item7")=tmp("Item49")
		...i tmp("Item48")'=""&&(tmp("Item3")="") s tmp("Item3")=tmp("Item48")
		...i tmp("Item3")'="" s tmp("Item3")=$e(tmp("Item3"),6,10)	
		..//end
		..s aa=..getRet(.tmp)
		..d OutRowtyp
 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommExecute ]
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

ClassMethod GetCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecComm(parr1 As %String) As %Query(ROWSPEC = "aa")
{
}

// 根据日期选择打印

ClassMethod GetCareRecCommSExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="337862!2011-01-07!11:15!!!DHCNUR6"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurRecPrint","GetCareRecCommS","1192312!2013-03-05!00&00!2013-03-06!00&00!DHCNURXH_FKSS2!")
 	s ^objcyf99=parr
 	s parr=$tr(parr,"&",":")
 	s ^objcyf999=parr
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")

	b
	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		//"0^0^"_stdate_"^"_stim_"^^"
		//s stdate=$P(arr,"^",3)
		//s StTime=$P(arr,"^",4)
	}
	s stdate=$ZDH(stdate,3)
	s StTime=$ZTH(StTime,3)
 	if $P(parr,"!",2)'="" s stdate=$ZDH($P(parr,"!",2),3)
 	if $P(parr,"!",4)'="" s eddate=$ZDH($P(parr,"!",4),3)
 	e  s eddate=$P($H,",")
 	if $P(parr,"!",3)'="" s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s RecTyp=$P(parr,"!",6)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s fdatetim=""
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
    ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
    ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
    ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
	//血压及显示到病情变化列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	//s Pressure=$P(ret,"^",5)
	s CaseMeasureItem=$P(ret,"^",7)
    s PrnItm=$P(ret,"^",5)
    b 
	f date=stdate:1:eddate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s tmp=""
        ..s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..//作废护理记录不打印
		..s reccanceluserId=tmp("RecCancelUser")
		..q:reccanceluserId'=""
		..s CaseMeasure=tmp("CaseMeasure")
		..s CareDate=cdate,CareTime=ctime
		..s tmp("CareDateTim")=CareDate_"/"_CareTime
		..s CareDate=$P(CareDate,"-")_"-"_$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
		..s CareTime=$P(CareTime,":",1)_":"_$P(CareTime,":",2)
		..s tmp("CareDate")=CareDate,tmp("CareTime")=CareTime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s recaudituserId=tmp("RecAuditUser")
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s tmp("User")=tmp("User")_" "_AuditUser
		..//s DiagnosDr=tmp("DiagnosDr")
		..for nn=1:1:$l(PrnItm,"/") d
		...s itm=$P(PrnItm,"/",nn)
		...q:itm=""
		...s tmp($P(itm,"&"))=..getitmdata(itm,.tmp)
		..s tmp("CaseMeasure")=..getcasedata(CaseMeasureItem,.tmp)_tmp("CaseMeasure")
		..s aa=..getRet(.tmp)
		..d OutRowtyp
 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommSExecute ]
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

ClassMethod GetCareRecCommSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecCommS(parr1 As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getRet(tmp) As %String
{
	s k=""
	s ret=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
 q ret
}

ClassMethod getcasedata(itm, tmp) As %String
{
   s ret=""
   for i=1:1:$L(itm,"&")
   {
      s cc=$P(itm,"&",i)
      if cc=""  continue
      s code=$P(cc,"!")
      s titl=$P(cc,"!",2)
      
      s ret=ret_titl_":"_tmp(code)_" "
   }
   q ret
}

ClassMethod getitmdata(itm, tmp) As %String
{
   s ret=""
   for i=1:1:$L(itm,"&")
   {
      s code=$P(itm,"&",i)
      if code=""  continue
      i ret="" s ret=tmp(code)
      e  s ret=ret_"/"_tmp(code)
      
   }
   q ret
}

}
