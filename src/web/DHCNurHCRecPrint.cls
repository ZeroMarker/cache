Class web.DHCNurHCRecPrint Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 获取当前记录绑定的表头id

ClassMethod getrowhead(rowid As %String) As %String
{
	//s a=##class(Nur.DHCNurCopyDiagnos).GetNurDiagnos("1")
	q:rowid="" ""
	s head=""
	s a=##class(Nur.DHCNurseRecSub).%OpenId(rowid)
	s head=a.HeadDR
	q head
}

// 表头变更新打印

ClassMethod GetCareRecCommAllExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="337862!2011-01-07!11:15!!!DHCNUR6"
	s ^TMP("parr")=parr
 	//d ##class(%ResultSet).RunQuery("web.DHCNurHCRecPrint","GetCareRecCommAll",^TMP("parr"))
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")
 	s HeadDR=$P(parr,"!",7)
    s flag=""              //续打 
	s ll=$l(parr,"!")      //续打
	i (ll=8) d             //续打
	.s flag=$P(parr,"!",8) //续打
	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		if arr=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK  
		s stdate=$P(arr,"^",3)
		s StTime=$P(arr,"^",4)
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
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
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
    //s ^TMP("dhr")=HeadDR
    
     //续打用
      s qflag=""    //1 不退出循环   //续打
      s prnflag=""  //是否打印       //续打
      i flag'="" d  //续打
      .s id=""
      .s id=$o(^Nur.DHCNurRecPrintStPosI("Rowid"," "_flag,""))
      .i id'="" d
      ..s a=##class(Nur.DHCNurRecPrintStPos).%OpenId(id)
      ..s prnflag=a.Prnflag
     
       //表头记录及生成图片
      s headstr="" 
      s dd=""  f  s dd=$O(^Nur.DHCNurRecHeadChangeRecI("TypHeadDatTim"," DHCNURHEADCHANGE"," "_RecTyp,dd)) q:dd=""  d
      .s tt=""  f  s tt=$O(^Nur.DHCNurRecHeadChangeRecI("TypHeadDatTim"," DHCNURHEADCHANGE"," "_RecTyp,dd,tt)) q:tt=""  d
      ..s drw=""  f  s drw=$O(^Nur.DHCNurRecHeadChangeRecI("TypHeadDatTim"," DHCNURHEADCHANGE"," "_RecTyp,dd,tt,par,drw)) q:drw=""  d
      ...s headstr=headstr_"^"_par_"_"_drw
      b ;4444
      s btlen=$l(headstr,"^")
      s firstbtid="" //开始打印的表头id
      s firstprintid="" //开始打印的数据rowid
      s qbtflag=""
      s qrowflag=""
      f hseq=1:1:btlen
     {
	  s itmhead=$p(headstr,"^",hseq)
	  s id1="" f  s id1=$o(^Nur.DHCNurMakePictureHistoryI("AdmCodeHeadPage"," "_Adm," "_RecTyp," "_itmhead,id1),-1) q:(id1="")||(firstbtid'="")  d
      .s rw1="" f  s rw1=$o(^Nur.DHCNurMakePictureHistoryI("AdmCodeHeadPage"," "_Adm," "_RecTyp," "_itmhead,id1,rw1),-1) q:(rw1="")||(firstbtid'="")  d
      ..s rowids1=$tr(rw1," ","")
      ..s obj1=##class(Nur.DHCNurMakePictureHistory).%OpenId(rowids1)
      ..s startflag=obj1.StartFlag
      ..i startflag="Y"  d
      ...s firstbtid=itmhead
      ...s qbtflag="Y"
      ...s firstprintid=obj1.FirstId
      ...s qrowflag=obj1.FirstId
      
     }
     b ;344
    f hseq=1:1:btlen
    {
	  s itmhead=$p(headstr,"^",hseq)
	  i (firstbtid=itmhead) s qbtflag=""
	  i qbtflag'=""  continue //如果在起始表头前面的表头退出
	  b ;000
	  f date=stdate:1:eddate
	  {
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_itmhead,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_itmhead,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s rowid=par_"||"_rw
        ..i (firstprintid'="")&(rowid=firstprintid) d   //生成图片
        ...s qrowflag=""                       //生成图片
        ..q:(qrowflag'="")                     //生成图片
        ..i rowid=flag d                      //续打
        ...s qflag=1                          //续打
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
		..s CareDate=$P(CareDate,"-",1)_"-"_$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
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
		..i $g(tmp("RecNurseLoc"))=""  d      //转科，根据绑定科室换页，如果某条记录没绑定则取该转移记录中的科室
        ...s tmp("RecNurseLoc")=..getpatlocbydatetime(Adm,cdatetime)    //根据转移记录查询该条记录病人所在的科室id 
        ..s tmp("par")=par //续打及图片
        ..s tmp("rw")=rw   //续打及图片
        ..s tmp("HeadDR")=itmhead //生成图片及打印计算
	 	..s aa=..getRet(.tmp)
		..d OutRowtyp
      }
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommAllExecute ]
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

ClassMethod GetCareRecCommAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecCommAll(parr1 As %String) As %Query(ROWSPEC = "aa") [ SqlProc ]
{
}

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

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="337862!2011-01-07!11:15!!!DHCNUR6"
	s ^TMP("parr")=parr
 	//d ##class(%ResultSet).RunQuery("web.DHCNurRecPrint","GetCareRecComm","")
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")
 	s HeadDR=$P(parr,"!",7)
    
	b
	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		//"0^0^"_stdate_"^"_stim_"^^"
		s stdate=$P(arr,"^",3)
		s StTime=$P(arr,"^",4)
	}
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s StTime=$ZTH(StTime,3)
 	if $P(parr,"!",2)'="" s stdate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"!",2))
 	if $P(parr,"!",4)'="" s eddate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"!",4))
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
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
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
    //s ^TMP("dhr")=HeadDR
	f date=stdate:1:eddate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s tmp=""
        ..
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
		..s CareDate=$P(CareDate,"-",1)_"-"_$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
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
		..s tmp("par")=par //续打
        ..s tmp("rw")=rw  //续打
        ..i $g(tmp("RecNurseLoc"))=""  d  //续打及图片转科
        ...s tmp("RecNurseLoc")=..getpatlocbydatetime(Adm,cdatetime)  //$p(^SSU("SSUSR",recuserId),"^",4)
        ..i $g(tmp("RecWard"))=""  d
        ...s tmp("RecWard")=..getpatlocbydatetime(Adm,cdatetime)
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

Query GetCareRecComm(parr1 As %String) As %Query(ROWSPEC = "aa") [ SqlProc ]
{
}

ClassMethod GetCareRecCommSExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^objcyf990=parr
	//s parr="337862!2011-01-07!11:15!!!DHCNUR6"
	s ^TMP("parr")=parr
	s parr=$tr(parr,"&",":")
 	//d ##class(%ResultSet).RunQuery("web.DHCNurHCRecPrint","GetCareRecComm","1280896!!!!!DHCNURXH1!88594_27")
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
	s RecTyp=$ZConvert(RecTyp,"U")
 	s HeadDR=$P(parr,"!",7)
    
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
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
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
    b ;00
    //s ^TMP("dhr")=HeadDR
	f date=stdate:1:eddate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypHeadDatTim"," "_RecTyp," "_HeadDR,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s tmp=""
        ..
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
		..s CareDate=$P(CareDate,"-",1)_"-"_$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
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
		..b ;01
		..s tmp("CaseMeasure")=..getcasedata(CaseMeasureItem,.tmp)_tmp("CaseMeasure")
		..b ;02
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

// 选择日期打印

Query GetCareRecCommS(parr1 As %String) As %Query(ROWSPEC = "aa") [ SqlProc ]
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
      s ret=ret_tmp(code)_"/"
   }
   q ret
}

}
