Class web.DHCNurseRecordComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通用取用户的类别:医生还是护士,NURSE/DOCTOR
/// 护士返回0 非护士返回相关提示，
/// lwd
ClassMethod GetUserTypeTran(userId As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm). GetUserTypeTran ("4337")
	q:userId="" "操作用户有误1！"
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" "操作用户有误2！"
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4) ;CTPCP_CarPrvTp_DR
	q:ctcptId="" "操作用户有误3！"
      s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4) ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" "操作用户有误4！"
	i ctcptInternalType'="NURSE" Q "非护士不可操作转科、换床和分配主管医生!"
	q 0
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod SumInAmount(Adm) As %String
{
 //w ##class(web.DHCNurseRecordComm).SumInAmount()
  // s admdate=$p(^PAADM(Adm),"^",6)
  //  s admtime=$p(^PAADM(Adm),"^",7)
   	 s sumtime=$ZTH("7:00")  //24小时
     s nodtime=$ZTH("17:00") //小结
     //首条
     s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
   	 if par="" q
     s rw=""  s rw=$O(^Nur.DHCNurIntensiveCareRecD(par,rw)) 
     if rw="" q
     if rw'=""  
     {
        s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
        s cdate=$listget(arr,9),ctime=$listget(arr,10)
        s stdate=cdate
        s stdatetime=..GetAbsTime(cdate_","_ctime)
        s dattime1=..GetAbsTime(cdate_","_sumtime)
        s dattime2=..GetAbsTime(cdate_","_nodtime)
        s day=1
        if stdatetime<dattime1
        {  //比7还早
	       //s st1=stdatetime,ent1=dattime1
	       //s tm(day,1)=cdate_","_ctime_"^"_cdate_","_firsttime
	      // s tm(day,2)=cdate_","_ctime_"^"_cdate_","_sectime
	       s tm(day,1)=$ZD(cdate,3)_","_$ZT(ctime)_"^"_$ZD(cdate,3)_","_$ZT(sumtime)
	       s tm(day,2)=$ZD(cdate,3)_","_$ZT(sumtime)_"^"_$ZD(cdate,3)_","_$ZT(nodtime)

	    }
	    if stdatetime>dattime1
	    {
		  // s st1=stdatetime, ent1=dattime2
		   s tm(day,1)=$ZD(cdate,3)_","_$ZT(ctime)_"^"_$ZD(cdate,3)_","_$ZT(nodtime)
		}
	 }
	 //最后一条
	 s rw=""  s rw=$O(^Nur.DHCNurIntensiveCareRecD(par,rw),-1) 
     s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
     s cdate=$listget(arr,9),ctime=$listget(arr,10)
     s endate=cdate
     b
     if endate=stdate q ""
     f date=stdate:1:endate
     {
	    if date=stdate continue
	    if date=endate continue
	    s day=day+1
	    s sdate=date-1
	    s edate=date
	   // s tm(day,1)=stdate_","_stime_"^"_endate_","_etime
	   // s tm(day,2)=stdate_","_stime_"^"_endate_","_stime
	    s tm(day,1)=$ZD(sdate,3)_","_$ZT(sumtime)_"^"_$ZD(edate,3)_","_$ZT(sumtime)
	    s tm(day,2)=$ZD(edate,3)_","_$ZT(sumtime)_"^"_$ZD(edate,3)_","_$ZT(nodtime)
	 }
    // s endatetime=..GetAbsTime(cdate_","_ctime)
     if ctime<sumtime
     {
	    s day=day+1
	    s sdate=endate-1
	    s edate=endate
	    s tm(day,1)=$ZD(sdate,3)_","_$ZT(sumtime)_"^"_$ZD(edate,3)_","_$ZT(sumtime)
	 }
   if ctime>sumtime
     {
	    s day=day+1
	    s sdate=endate-1
	    s edate=endate
	    b //d
	    //s tm(day,1)=stdate_","_stime_"^"_endate_","_etime
	   // s tm(day,2)=stdate_","_stime_"^"_endate_","_stime
	    s tm(day,1)=$ZD(sdate,3)_","_$ZT(sumtime)_"^"_$ZD(edate,3)_","_$ZT(sumtime)
	    s tm(day,2)=$ZD(edate,3)_","_$ZT(sumtime)_"^"_$ZD(edate,3)_","_$ZT(nodtime)

	 }
	 b

 q ""
}

ClassMethod GeInOutAmount(Adm, stdate, stime, endate, entime) As %String
{
	//s Adm=$P(parr,"^",1)
 	s stdate=$ZDH(stdate,3)
 	s eddate=$ZDH(endate,3)
 	s StTime=$ZTH(stime)
 	s EndTime=$ZTH(entime)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s dep=parr
 	 s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
     s sumIn=0,sumOut=0,Emric=0,medin=0
	 f date=stdate:1:eddate
 	 {
        s rw="" f  s rw=$O(^Nur.DHCNurIntensiveCareRecI("CareDat",date,par,rw)) q:rw=""  d
        .s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
        .s cdate=$listget(arr,9),ctime=$listget(arr,10)
        .s cdatetime=..GetAbsTime(cdate_","_ctime)
        .s inouDr=$listget(arr,45)
        .q:inouDr'=""
        .q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		.s InDruggeryAmount=$listget(arr,18)
		.s medin=medin+InDruggeryAmount
		.s InQtAmount=$listget(arr,20)
		.s sumIn=sumIn+InDruggeryAmount+InQtAmount
		.s Emiction=$listget(arr,14) //尿量
		.s Emric=Emric+Emiction
		.s OutQtAmount=$listget(arr,30)  //其他出量
		.s sumOut=sumOut+Emiction+OutQtAmount
	}
    q sumIn_"^"_sumOut_"^"_medin_"^"_Emric
}

ClassMethod GetIntensiveCareRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="31855^2010-07-02^0:00^2010-07-08^0:00"
 	s Adm=$P(parr,"^",1)
 	s stdate=$ZDH($P(parr,"^",2),3)
 	s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s EndTime=$ZTH($P(parr,"^",5))
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s dep=parr
 	 s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
 	     b  //dd

    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	 f date=eddate:-1:stdate
 	 {
        s tim="" f  s tim=$O(^Nur.DHCNurIntensiveCareRecI("CareDatTim",date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurIntensiveCareRecI("CareDatTim",date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
        ..s cdate=$listget(arr,9),ctime=$listget(arr,10)
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..b //ll
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..s Temperature=$listget(arr,39)
		..s HeartRate=$listget(arr,16)
		..s Breath=$listget(arr,8)
		..s HPressure=$listget(arr,15)
		..s LPressure=$listget(arr,21)
		..s SPO2=$listget(arr,36)
		..s Mind=$listget(arr,25)
		..s LPupilScale=$listget(arr,23)
		..s RPupilScale=$listget(arr,32)
		..s LPupilEcho=$listget(arr,22)
		..s RPupilEcho=$listget(arr,31)
		..s AbsorbPhlegm=$listget(arr,3)
		..s Atomization=$listget(arr,6)
		..s AbsorbOMth=$listget(arr,2)
		..s AbsorbRate=$listget(arr,4)
		..s Wound=$listget(arr,42)
		..s SetTubeName=$listget(arr,37)
		..s TubeTend=$listget(arr,41)
		..s TractName=$listget(arr,40)
		..s CurePump=$listget(arr,12)
		..s InDruggery=$listget(arr,17)
		..s InDruggeryAmount=$listget(arr,18)
		..s InQt=$listget(arr,19)
		..s InQtAmount=$listget(arr,20)
		..s Emiction=$listget(arr,14)
		..s OutQt=$listget(arr,29) //其他出量名
		..s OutQtAmount=$listget(arr,30)  //其他出量
		..s MornNurse=$listget(arr,26)  //晨间护理
		..s NightNurse=$listget(arr,27)  //晚间护理
		..s NurseDirect=$listget(arr,28) //护理指导
		..s SkinNurse=$listget(arr,38)  //皮肤护理
		..s SkinHealth=$listget(arr,44)
		..s BodyPos=$listget(arr,7) //体位
		..s DrainageNur=$listget(arr,13)  //排泄护理
		..s MRestrict=$listget(arr,24)  //约束
		..s InformDoc=$listget(arr,43)  //通知医生
		..s CaseMeasure=$listget(arr,11) //
		..s CareDate=cdate,CareTime=ctime
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb( CareDate,CareTime,Temperature, HeartRate, Breath, HPressure, LPressure, SPO2, Mind, LPupilScale, RPupilScale, LPupilEcho, RPupilEcho,AbsorbPhlegm, Atomization, AbsorbOMth,AbsorbRate, Wound, SetTubeName, TubeTend, TractName, CurePump, InDruggery, InDruggeryAmount, InQt,InQtAmount, Emiction, OutQt, OutQtAmount, MornNurse,  NightNurse,  NurseDirect,  SkinNurse,SkinHealth,  BodyPos, DrainageNur,   MRestrict,  InformDoc,CaseMeasure,rw,par)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetIntensiveCareRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIntensiveCareRecExecute ]
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

ClassMethod GetIntensiveCareRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIntensiveCareRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetIntensiveCareRec(parr As %String) As %Query(ROWSPEC = "CareDate,CareTime,Temperature, HeartRate, Breath, HPressure, LPressure, SPO2, Mind, LPupilScale, RPupilScale, LPupilEcho, RPupilEcho,AbsorbPhlegm, Atomization, AbsorbOMth,AbsorbRate, Wound, SetTubeName, TubeTend, TractName, CurePump, InDruggery, InDruggeryAmount, InQt,InQtAmount, Emiction, OutQt, OutQtAmount, MornNurse,  NightNurse,  NurseDirect,  SkinNurse,SkinHealth,  BodyPos, DrainageNur,   MRestrict,  InformDoc,CaseMeasure,rw,par")
{
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
  //s a=##class(web.DHCNurseRecordComm).GetQueryData()
   //s QueryName="web.DHCNurseRecordComm:GetCareRec"
  // s parrm="parr$338155^2010-07-12^0:00^2010-07-18^18:00"
  // s funname="addLab"
     s ^objcyf123(QueryName)=parrm_"^"_funname
   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  b
  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_"'"_$ZCVT(rset.GetData(col),"O","JS")_"',"
        }

   s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>

      
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

ClassMethod GetPrnIntCareRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="338155^2010-07-02^0:00^2010-07-18^0:00"
   // s ^tmp("nn")=parr
 	s Adm=$P(parr,"!",1)
 	s stdate=$ZDH($P(parr,"!",2),3)
 	if $P(parr,"!",4)'="" s eddate=$ZDH($P(parr,"!",4),3)
 	e  s eddate=$P($H,",")
 	s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))

 	s rw=""  s rw=$O(^Nur.DHCNurIntensiveCareRecD(par,rw)) 
     if rw'=""  
     {
        s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
        s fdate=$listget(arr,9),ftime=$listget(arr,10)
    }
    s fdatetim=..GetAbsTime(fdate_","_ftime)
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	//s stdate=cdate
 	//s eddate=$P($H,",",1)
 	//s dep=parr
 	     b  //dd

 	 f date=stdate:1:eddate
 	 {
        s tim="" f  s tim=$O(^Nur.DHCNurIntensiveCareRecI("CareDatTim",date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurIntensiveCareRecI("CareDatTim",date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurIntensiveCareRecD(par,rw)
        ..s cdate=$listget(arr,9),ctime=$listget(arr,10)
        ..
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
        ..s user=$listget(arr,35)
        ..if user'="" s user=$p(^SSU("SSUSR",user),"^",2)
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..s Temperature=$listget(arr,39)
		..s HeartRate=$listget(arr,16)
		..s Breath=$listget(arr,8)
		..s HPressure=$listget(arr,15)
		..s LPressure=$listget(arr,21)
		..s SPO2=$listget(arr,36)
		..s Mind=$listget(arr,25)
		..s LPupilScale=$listget(arr,23)
		..s RPupilScale=$listget(arr,32)
		..s LPupilEcho=$listget(arr,22)
		..s RPupilEcho=$listget(arr,31)
		..s AbsorbPhlegm=$listget(arr,3)
		..s Atomization=$listget(arr,6)
		..s AbsorbOMth=$listget(arr,2)  //obj5159581  st867895
		..s AbsorbRate=$listget(arr,4)
		..s Wound=$listget(arr,42)
		..s SetTubeName=$listget(arr,37)
		..s TubeTend=$listget(arr,41)
		..s TractName=$listget(arr,40)
		..s CurePump=$listget(arr,12)
		..s InDruggery=$listget(arr,17)
		..s InDruggeryAmount=$listget(arr,18)
		..s InQt=$listget(arr,19)
		..s InQtAmount=$listget(arr,20)
		..s Emiction=$listget(arr,14)
		..s OutQt=$listget(arr,29) //其他出量名
		..s OutQtAmount=$listget(arr,30)  //其他出量
		..s MornNurse=$listget(arr,26)  //晨间护理
		..s NightNurse=$listget(arr,27)  //晚间护理
		..s NurseDirect=$listget(arr,28) //护理指导
		..s SkinNurse=$listget(arr,38)  //皮肤护理
		..s SkinHealth=$listget(arr,44)
		..s BodyPos=$listget(arr,7) //体位
		..s DrainageNur=$listget(arr,13)  //排泄护理
		..s MRestrict=$listget(arr,24)  //约束
		..s InformDoc=$listget(arr,43)  //通知医生
		..s CaseMeasure=$listget(arr,11) //
		..s CareDate=cdate,CareTime=ctime
		..s nurse=""
		..if MornNurse'="" s nurse="晨间护理:"_MornNurse
		..if NightNurse'="" s nurse=nurse_" 晚间护理:"_NightNurse
		..if NurseDirect'="" s nurse=nurse_" 护理指导:"_NurseDirect
		..if CaseMeasure'="" s nurse=nurse_" "_CaseMeasure
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb( CareDate_"/"_CareTime,Temperature, HeartRate, Breath, HPressure_"/"_LPressure, SPO2, Mind, LPupilScale_"/"_RPupilScale, LPupilEcho_"/"_RPupilEcho,AbsorbPhlegm_"/"_Atomization, AbsorbOMth,AbsorbRate, Wound, SetTubeName, TubeTend, TractName, CurePump, InDruggery_"/"_InDruggeryAmount, InQt_"/"_InQtAmount, Emiction, OutQt_"/"_OutQtAmount, MornNurse,  NightNurse,  NurseDirect,  SkinNurse_"/"_SkinHealth,  BodyPos, DrainageNur,   MRestrict,  InformDoc,nurse,user)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPrnIntCareRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrnIntCareRecExecute ]
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

ClassMethod GetPrnIntCareRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrnIntCareRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPrnIntCareRec(parr As %String) As %Query(ROWSPEC = "CareDateTim,Temperature, HeartRate, Breath,Pressure, SPO2, Mind, PupilScale, PupilEcho,AbsorbPhlegm, AbsorbOMth,AbsorbRate, Wound, SetTubeName, TubeTend, TractName, CurePump, InDruggery, InQt, Emiction, OutQt, MornNurse,  NightNurse,  NurseDirect,  SkinNurse,  BodyPos, DrainageNur,   MRestrict,  InformDoc,CaseMeasure,User")
{
}

ClassMethod getprnset(typ, adm, funname) As %String
{
   //s a=##class(web.DHCNurseRecordComm).getprnset("DHCNUR2",338155,"dd")
   s Typ=$ZConvert(typ,"U")
   s rw=""  s rw=$O(^Nur.DHCNursePrintRecI("AdmTyp"," "_adm," "_Typ,rw))
   if rw="" q ""
   s a=##class(Nur.DHCNursePrintRec).%OpenId(rw)
   s pos=a.RecPosition
   s pag=a.RecPageNo
   s date=$ZD(a.CareDate,3)
   s tim=$ZT(a.CareTime,2)
   if a.eDate'="" s edate=$ZD(a.eDate,3)
   e  s edate=""
   if a.eTime'=""  s etim=$ZT(a.eTime,2)
   e  s etim=""
   
   b //3e3
   s adm=a.Adm
   s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
   S patname=$P(patinf,"^",5)
   s bedcode=$P(patinf,"^",6)
   s data=$P(patname,"@",2)_"^"_$P(bedcode,"@",2)_"^"_pag_"^"_pos_"^"_date_"^"_tim_"^"_edate_"^"_etim_"^"_typ_"^"_rw_"^"_adm
   s data="'"_$ZCVT(data,"O","JS")_"'"
   s rtnval=funname_"("_data_")"
   b
  &javascript<#(rtnval)#>

   q 0
}

ClassMethod GetCareRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   // s parr="31855^2010-07-02^0:00^2010-07-08^0:00"
 	s Adm=$P(parr,"^",1)
 	s stdate=$ZDH($P(parr,"^",2),3)
 	s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s EndTime=$ZTH($P(parr,"^",5))
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s dep=parr
 	 s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
 	     b  //dd

    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	 f date=eddate:-1:stdate
 	 {
        s tim="" f  s tim=$O(^Nur.DHCNurSurgeryNurseRecI("CareDatTim",date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurSurgeryNurseRecI("CareDatTim",date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurSurgeryNurseRecD(par,rw)
        ..s cdate=$listget(arr,4),ctime=$listget(arr,6)
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..b //ll
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..s Temperature=$listget(arr,16)
		..s HeartRate=$listget(arr,8)
		..s Breath=$listget(arr,3)
		..s HPressure=$listget(arr,7)
		..s LPressure=$listget(arr,9)
		..s SPO2=$listget(arr,14)
		..s Wound=$listget(arr,21)
		..s SetTubeName=$listget(arr,15)
		..s TubeTend=$listget(arr,20)
		..s TractName=$listget(arr,19)
		..s TractStatus=$listget(arr,18)
		..s TractAmount=$listget(arr,17)
		..s NurQt=$listget(arr,10)
		..s CaseMeasure=$listget(arr,5) //
		..s CareDate=cdate,CareTime=ctime
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb( CareDate,CareTime,Temperature, HeartRate, Breath, HPressure, LPressure, SPO2,  Wound, SetTubeName, TubeTend, TractName, TractStatus, TractAmount, NurQt ,CaseMeasure,rw,par)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecExecute ]
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

ClassMethod GetCareRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRec(parr As %String) As %Query(ROWSPEC = "CareDate,CareTime,Temperature, HeartRate, Breath, HPressure, LPressure, SPO2, Wound, SetTubeName, TubeTend, TractName, TractStatus, TractAmount, NurQt,CaseMeasure,rw,par")
{
}

/// 科室空白栏标题变更记录
/// 2010-09-14
ClassMethod GetLocLableExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetLocLable","1")
 	s dep=$P(parr,"^",1)
 	
	s MoudleCode="" f  s MoudleCode=$O(^Nur.DHCNurChangeLableRecI("LableLoc",MoudleCode)) q:MoudleCode=""  d
 	.s MoudleId=$O(^NurEmr.NurEmrSubI("KCode",MoudleCode,""))
 	.q:MoudleId=""
 	.s MoudleName=$List(^NurEmr.NurEmrSubD(MoudleId),4)
 	.s LocDr="" f  s LocDr=$O(^Nur.DHCNurChangeLableRecI("LableLoc",MoudleCode,LocDr)) q:LocDr=""  d
 	..s LocId=$TR(LocDr," ","")
 	..q:LocId'=dep	//必须选择科室,默认登陆科室
 	..s LableLoc=$P(^CTLOC(LocId),"^",2)
 	..b //000
 	..s rw="" f  s rw=$O(^Nur.DHCNurChangeLableRecI("LableLoc",MoudleCode,LocDr,rw)) q:rw=""  d
	...s arr=^Nur.DHCNurChangeLableRecD(rw)
	...s LableId=$List(arr,4)
	...s LableDesc=$List(arr,3)
	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(LableLoc,MoudleName,LableId,LableDesc,rw,$TR(MoudleCode," ",""),LocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocLableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocLableExecute ]
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

ClassMethod GetLocLableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocLableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetLocLable(parr As %String) As %Query(ROWSPEC = "LableLoc,MoudleName,LableId,LableDesc,rw,MoudleCode,LocId")
{
}

/// 取护理模版的代码与名称
/// 2010-09-14
ClassMethod GetModel(funname As %String) As %String
{
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s ItmDesc=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.s ItmCode=$TR(SubKCode," ","")
	.q:($E(ItmCode,1,6)'="DHCNUR")!($L(ItmCode)>10)
 	.s rtnval=funname_"('"_$ZCVT($g(ItmCode),"O","JS")_"','"_$ZCVT($g(ItmDesc),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// 取护理模版对应的空白栏
/// 2010-09-14
ClassMethod GetMoldelBlank(MoldelCode, funname As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetMoldelBlank("DHCNUR6","")
	//空白栏列	

	s ret=##class(Nur.DHCNurseRecSet).getSet(MoldelCode)
	s BlankLable=$P(ret,"^",6)
		s ^ojbcyf419=MoldelCode_"^"_funname
	s LableStr=""
	f ii=1:1:$L(BlankLable,"&") d
	.s BlankLableProperty=$P(BlankLable,"&",ii)
	.q:BlankLableProperty=""
	.s BlankLableName="其他"_ii
	.s rtnval=funname_"('"_$ZCVT($g(BlankLableProperty),"O","JS")_"','"_$ZCVT($g(BlankLableName),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// 按病人显示标题变更记录
/// 2010-09-14
ClassMethod GetChangeLableRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="316213^2010-09-14^00:00^2010-09-21^00:00^^"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetChangeLableRec","")
 	s Adm=$P(parr,"^",1)
 	i Adm="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdate=$ZDH($P(parr,"^",2),3)
 	s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s EndTime=$ZTH($P(parr,"^",5))
	s stdatetime=..GetAbsTime(stdate_","_StTime)
	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s DateFlag=$P(parr,"^",6)
 	s MoudleKey=$P(parr,"^",7)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
 	if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
 	
	s model="" f  s model=$O(^Nur.DHCNurChangeLableRecI("Lable",model)) q:model=""  d
	.s tmpmodel=$TR(model," ","")
	.q:(MoudleKey'="")&(MoudleKey'=tmpmodel)
	.s carerecord="" f  s carerecord=$O(^Nur.DHCNurChangeLableRecI("Lable",model,carerecord)) q:carerecord=""  d
	..s rw="" f  s rw=$O(^Nur.DHCNurChangeLableRecI("Lable",model,carerecord,rw)) q:rw=""  d
	...s arr=^Nur.DHCNurChangeLableRecD(rw)
	...s EpisodeID=$List(arr,2)
	...q:(EpisodeID'=Adm)
	...s LableId=$List(arr,4)
	...s LableDesc=$List(arr,3)
	...s MoudleCode=$List(arr,5)
	...s MoudleId=$O(^NurEmr.NurEmrSubI("KCode"," "_MoudleCode,""))
	...i MoudleId'="" s MoudleName=$List(^NurEmr.NurEmrSubD(MoudleId),4)
	...e  s MoudleName=""
	...s NurRecId=$List(arr,6)
	...q:NurRecId=""
	...s aa=$G(^Nur.DHCNurseRecSubD($P(NurRecId,"||",1),$P(NurRecId,"||",2)))
	...s CareDate=$listget(aa,3),CareTime=$listget(aa,4)
 	...i CareDate'="" s CareDate=$ZD(CareDate,3)
	...i CareTime'="" s CareTime=$ZT(CareTime)
	...s RecDate=$List(arr,7),RecTime=$List(arr,8)
	...s recdatetime=..GetAbsTime(RecDate_","_RecTime)
	...q:(DateFlag="Y")&((recdatetime>endatetime)!(recdatetime<stdatetime))
	...i RecDate'="" s RecDate=$ZD(RecDate,3)
	...i RecTime'="" s RecTime=$ZT(RecTime)
	...s UserId=$List(arr,9)
	...i UserId'="" s RecUser=$p($g(^SSU("SSUSR",UserId)),"^",2)
	...e  s RecUser=""
	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(LableId,LableDesc,MoudleName,CareDate,CareTime,RecUser,RecDate,RecTime,NurRecId,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetChangeLableRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeLableRecExecute ]
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

ClassMethod GetChangeLableRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeLableRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetChangeLableRec(parr As %String) As %Query(ROWSPEC = "LableId,LableDesc,MoudleName,CareDate,CareTime,RecUser,RecDate,RecTime,NurRecId,rw")
{
}

/// 诊断记录
/// 2010-09-14
ClassMethod GetCopyDiagnosExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^obj99=parr
    //s parr="316213^2010-09-14^00:00^2010-09-15^00:00^"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetCopyDiagnos",^obj99)
 	s Adm=$P(parr,"^",1)
 	i Adm="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s stdatetime=""
 	s endatetime=""
 	i $P(parr,"^",2)'="" d
 	.//s stdate=$ZDH($P(parr,"^",2),3)
 	.s stdate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"^",2))
 	i $P(parr,"^",4)'="" d
 	.//s eddate=$ZDH($P(parr,"^",4),3)
 	.s eddate=##class(websys.Conversions).DateHtmlToLogical($P(parr,"^",4))
 	i $P(parr,"^",3)'="" s StTime=$ZTH($P(parr,"^",3))
 	i $P(parr,"^",5)'="" s EndTime=$ZTH($P(parr,"^",5))
	i $G(stdate)'="",$G(StTime)'="" s stdatetime=..GetAbsTime(stdate_","_StTime)
	i $G(eddate)'="",$G(EndTime)'="" s endatetime=..GetAbsTime(eddate_","_EndTime)

	s rw="" f  s rw=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_Adm,rw)) q:rw=""  d
	.s arr=^Nur.DHCNurCopyDiagnosD(rw)
	.s DiagNos=$List(arr,2)
	.s RecUserId=$List(arr,6)
	.i RecUserId'="" s RecUser=$p($g(^SSU("SSUSR",RecUserId)),"^",2)
	.e  s RecUser=""
	.//b //000
	.s RecDate=$List(arr,4)
	.i RecDate'="" D
	..//s RecDate=$ZD(RecDate,3)
	..//S RecDate=##class(websys.Conversions).DateLogicalToHtml(RecDate)
	.s RecTime=$List(arr,5)
	.i RecTime'="" s RecTime=$ZT(RecTime)
	.//b ;33
	.i $g(RecDate)'="",$g(RecTime)'="" s sttdt=..GetAbsTime(RecDate_","_$zth(RecTime,3))
	.b ;9
	.q:($g(sttdt)'="")&&((sttdt<stdatetime)!(sttdt>endatetime))
	.S RecDate=##class(websys.Conversions).DateLogicalToHtml(RecDate)
	.s RecTime=$P(RecTime,":",1,2)
	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowtyp
	set Data=$lb(DiagNos,RecUser,RecDate,RecTime,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCopyDiagnosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeLableRecExecute ]
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

ClassMethod GetCopyDiagnosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeLableRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCopyDiagnos(parr As %String) As %Query(ROWSPEC = "DiagNos,RecUser,RecDate,RecTime,rw")
{
}

/// 通用护理记录查询
/// 2010-09-16
ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TMP("parr")=parr

    //s parr="316213^2010-09-21^00:00^2010-09-22^00:00^DHCNUR6"
 	//d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetCareRecComm","")
 	s Adm=$P(parr,"^",1)
 	s stdate=$P(parr,"^",2)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",4)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	//s stdate=$ZDH($P(parr,"^",2),3)
 	//s eddate=$ZDH($P(parr,"^",4),3)
 	s StTime=$ZTH($P(parr,"^",3))
 	s EndTime=$ZTH($P(parr,"^",5))
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	s RecTyp=$P(parr,"^",6)
 	s RecTyp=$ZConvert(RecTyp,"U")
 	s IfCancelRec=$P(parr,"^",7)
 	//s dep=parr
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
	//分项统计对应列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	
	f date=eddate:-1:stdate
	{
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim),-1) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw),-1) q:rw=""  d
        ..s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
        ..s cdate=$listget(arr,3),ctime=$listget(arr,4)
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..b //ll
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
        ..b //hh
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime,2)
		..s a1="Item1",@a1=$listget(arr,7),b1="Item1"
		..s a2="Item2",@a2=$listget(arr,18),b2="Item2"
		..s a3="Item3",@a3=$listget(arr,29),b3="Item3"
		..s a4="Item4",@a4=$listget(arr,40),b4="Item4"
		..s a5="Item5",@a5=$listget(arr,51),b5="Item5"
		..s a6="Item6",@a6=$listget(arr,53),b6="Item6"
		..s a7="Item7",@a7=$listget(arr,54),b7="Item7"
		..s a8="Item8",@a8=$listget(arr,55),b8="Item8"
		..s a9="Item9",@a9=$listget(arr,56),b9="Item9"
		..s a10="Item10",@a10=$listget(arr,8),b10="Item10"
		..s a11="Item11",@a11=$listget(arr,9),b11="Item11"
		..s a12="Item12",@a12=$listget(arr,10),b12="Item12"
		..s a13="Item13",@a13=$listget(arr,11),b13="Item13"
		..s a14="Item14",@a14=$listget(arr,12),b14="Item14"
		..s a15="Item15",@a15=$listget(arr,13),b15="Item15"
		..s a16="Item16",@a16=$listget(arr,14),b16="Item16"
		..s a17="Item17",@a17=$listget(arr,15),b17="Item17"
		..s a18="Item18",@a18=$listget(arr,16),b18="Item18"
		..s a19="Item19",@a19=$listget(arr,17),b19="Item19"
		..s a20="Item20",@a20=$listget(arr,19),b20="Item20"
		..s a21="Item21",@a21=$listget(arr,20),b21="Item21"
		..s a22="Item22",@a22=$listget(arr,21),b22="Item22"
		..s a23="Item23",@a23=$listget(arr,22),b23="Item23"
		..s a24="Item24",@a24=$listget(arr,23),b24="Item24"
		..s a25="Item25",@a25=$listget(arr,24),b25="Item25"
		..s a26="Item26",@a26=$listget(arr,25),b26="Item26"
		..s a27="Item27",@a27=$listget(arr,26),b27="Item27"
		..s a28="Item28",@a28=$listget(arr,27),b28="Item28"
		..s a29="Item29",@a29=$listget(arr,28),b29="Item29"
		..s a30="Item30",@a30=$listget(arr,30),b30="Item30"
		..s a31="Item31",@a31=$listget(arr,31),b31="Item31"
		..s a32="Item32",@a32=$listget(arr,32),b32="Item32"
		..s a33="Item33",@a33=$listget(arr,33),b33="Item33"
		..s a34="Item34",@a34=$listget(arr,34),b34="Item34"
		..s a35="Item35",@a35=$listget(arr,35),b35="Item35"
		..s a36="Item36",@a36=$listget(arr,36),b36="Item36"
		..s a37="Item37",@a37=$listget(arr,37),b37="Item37"
		..s a38="Item38",@a38=$listget(arr,38),b38="Item38"
		..s a39="Item39",@a39=$listget(arr,39),b39="Item39"
		..s a40="Item40",@a40=$listget(arr,41),b40="Item40"
		..s a41="Item41",@a41=$listget(arr,42),b41="Item41"
		..s a42="Item42",@a42=$listget(arr,43),b42="Item42"
		..s a43="Item43",@a43=$listget(arr,44),b43="Item43"
		..s a44="Item44",@a44=$listget(arr,45),b44="Item44"
		..s a45="Item45",@a45=$listget(arr,46),b45="Item45"
		..s a46="Item46",@a46=$listget(arr,47),b46="Item46"
		..s a47="Item47",@a47=$listget(arr,48),b47="Item47"
		..s a48="Item48",@a48=$listget(arr,49),b48="Item48"
		..s a49="Item49",@a49=$listget(arr,50),b49="Item49"
		..s a50="Item50",@a50=$listget(arr,52),b50="Item50"
		..s CaseMeasure=$listget(arr,5)
		..s CareDate=cdate,CareTime=ctime
		..s recuserId=$listget(arr,59)
		..i recuserId'="" s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s User=""
		..s recaudituserId=$listget(arr,64)
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s User=User_" "_AuditUser
		..s reccanceluserId=$listget(arr,67)
		..q:(IfCancelRec="true")&(reccanceluserId="")
		..q:(IfCancelRec'="true")&(reccanceluserId'="")
		..i reccanceluserId'="" d
		...s CancelUser=$p($g(^SSU("SSUSR",reccanceluserId)),"^",2)
		...s reccanceldate=$listget(arr,65)
		...i reccanceldate'="" s reccanceldate=$ZD(reccanceldate,3)
		...s reccanceltime=$listget(arr,66)
		...i reccanceltime'="" s reccanceltime=$ZT(reccanceltime)
		...s User=User_" 作废记录:"_CancelUser_" "_reccanceldate_" "_reccanceltime
		..s InOutDr=$listget(arr,6)
		..//不显示出入液量分项
		..//i InOutDr'="" d
		..//.s @PartInNameProperty="入量液分项="
		..//.s @PartInAmountProperty=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^I")
		..//.s @PartOutNameProperty="出量液分项="
		..//.s @PartOutAmountProperty=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^O")
		..s Item1=@b1,Item2=@b2,Item3=@b3,Item4=@b4,Item5=@b5,Item6=@b6,Item7=@b7,Item8=@b8,Item9=@b9,Item10=@b10
		..s Item11=@b11,Item12=@b12,Item13=@b13,Item14=@b14,Item15=@b15,Item16=@b16,Item17=@b17,Item18=@b18,Item19=@b19,Item20=@b20
		..s Item21=@b21,Item22=@b22,Item23=@b23,Item24=@b24,Item25=@b25,Item26=@b26,Item27=@b27,Item28=@b28,Item29=@b29,Item30=@b30
		..s Item31=@b31,Item32=@b32,Item33=@b33,Item34=@b34,Item35=@b35,Item36=@b36,Item37=@b37,Item38=@b38,Item39=@b39,Item40=@b40
		..s Item41=@b41,Item42=@b42,Item43=@b43,Item44=@b44,Item45=@b45,Item46=@b46,Item47=@b47,Item48=@b48,Item49=@b49,Item50=@b50
		..d OutRowtyp
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(CareDate,CareTime,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50,CaseMeasure,User,rw,par)
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

Query GetCareRecComm(parr As %String) As %Query(ROWSPEC = "CareDate,CareTime,Item1,Item2,Item3,Item4,Item5,Item6,Item7,Item8,Item9,Item10,Item11,Item12,Item13,Item14,Item15,Item16,Item17,Item18,Item19,Item20,Item21,Item22,Item23,Item24,Item25,Item26,Item27,Item28,Item29,Item30,Item31,Item32,Item33,Item34,Item35,Item36,Item37,Item38,Item39,Item40,Item41,Item42,Item43,Item44,Item45,Item46,Item47,Item48,Item49,Item50,CaseMeasure,User,rw,par")
{
}

/// 通用护理记录出入量统计
/// 统计时记尾不记头,第一条统计可记头也记尾
/// 2010-09-16
ClassMethod GetInOutAmountComm(Adm, stdate, stime, endate, entime, RecTyp) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetInOutAmountComm("64","2012-02-01","00:00","2012-02-02","00:00","DHCNURXH1")
	q:(Adm="")!(RecTyp="") ""
	s stdate=$ZDH(stdate,3)
	s eddate=$ZDH(endate,3)
	s StTime=$ZTH(stime)
	s EndTime=$ZTH(entime)
	s stdatetime=..GetAbsTime(stdate_","_StTime)
	s endatetime=..GetAbsTime(eddate_","_EndTime)
	//s dep=parr
	//出入总量对应列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	b
	s SumInProperty=$P(ret,"^",1)
	s InNameProperty=$P(SumInProperty,"&",1)
	s InAmountProperty=$P(SumInProperty,"&",2)
	s SumOutProperty=$P(ret,"^",2)
	s OutNameProperty=$P(SumOutProperty,"&",1)
	s OutAmountProperty=$P(SumOutProperty,"&",2)
	////////////qse add
	////////////
	s InCountCols=$P(ret,"^",10)
 	s OuCountCols=$P(ret,"^",11)
    s TmPropertyIn="",TmPropertyOu=""
    d ..getpropInOu(InCountCols,.TmPropertyIn)
    d ..getpropInOu(OuCountCols,.TmPropertyOu)
    //////////////////////////
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	i par="" q ""
	s sumIn=0,sumOut=0,statendtime=""
	s FirstRecorddatetime=..GetFirstRecordDT(Adm,RecTyp,par) //遍历病人护理记录找到时间最早的记录
	k InPartSum,OutPartSum
	for date=stdate:1:eddate
	{
		s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDat"," "_RecTyp,date,par,rw)) q:rw=""  d
		.s arr=^Nur.DHCNurseRecSubD(par,rw)
		.s cdate=$listget(arr,3),ctime=$listget(arr,4)
		.s cdatetime=..GetAbsTime(cdate_","_ctime)
		.//s inouDr=$listget(arr,14)
		.s a=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_rw)
		.s inouDr=a.InOutDr 
		.q:inouDr'=""
		.//作废护理记录不打印
		.s reccanceluserId=$listget(arr,67)
		.q:reccanceluserId'=""
		.//q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		.q:((cdatetime>endatetime)!((cdatetime<=stdatetime)&&(cdatetime'=FirstRecorddatetime))!((cdatetime<stdatetime)&&(cdatetime=FirstRecorddatetime)))
		.i InNameProperty'="" s InName=$ZOBJPROPERTY(a,InNameProperty)
		.e  s InName=""
		.i InAmountProperty'="" s InAmount=$ZOBJPROPERTY(a,InAmountProperty)
		.e  s InAmount=""
		.i InName'="" s InPartSum(InName)=+$G(InPartSum(InName))+InAmount
		.s sumIn=sumIn+InAmount
		.b
		.i OutNameProperty'="" s OutName=$ZOBJPROPERTY(a,OutNameProperty)
		.e  s OutName=""
		.i OutAmountProperty'="" s OutAmount=$ZOBJPROPERTY(a,OutAmountProperty)
		.e  s OutAmount=""
		.i OutName'="" s OutPartSum(OutName)=+$G(OutPartSum(OutName))+OutAmount
		.s sumOut=sumOut+OutAmount
		.s p="" f  s p=$O(TmPropertyIn(p)) q:p=""  d
		..s val=$ZOBJPROPERTY(a,p)
		..s TmPropertyIn(p)=$G(TmPropertyIn(p))+val
		.s p="" f  s p=$O(TmPropertyOu(p)) q:p=""  d
		..s val=$ZOBJPROPERTY(a,p)
		..s TmPropertyOu(p)=$G(TmPropertyOu(p))+val
		.////qse add 11 05 04
		.s statendtime=cdatetime
	}
	s InPart="",OutPart=""
	s itm="" f  s itm=$O(InPartSum(itm)) q:itm=""  d
	.s InPart=InPart_itm_":"_InPartSum(itm)_"ml;"
	s itm="" f  s itm=$O(OutPartSum(itm)) q:itm=""  d
	.s OutPart=OutPart_itm_":"_OutPartSum(itm)_"ml;"
	//显示时间段与时间,若结束时间为0:00取最后一条记录的时间
	//Item1显示8:15-16:00,Item2显示7小时45分出入水量
	s StatHr=(endatetime-stdatetime)\3600
	s StatMin=(endatetime-stdatetime)#3600\60
	//s StatHours=StatHr_"小时"_StatMin_"分出入液量统计"
	s StatHours=$S(StatHr>0:StatHr_"小时",1:"")_$S(StatMin>0:StatMin_"分",1:"")_"出入液量统计"
	s StatTime=$ZT(StTime,2)_"----"_$ZT(EndTime,2)
	q sumIn_"^"_sumOut_"^"_InPart_"^"_OutPart_"^"_StatTime_"^"_StatHours
}

ClassMethod GetInOutAmountComm1(Adm, stdate, stime, endate, entime, RecTyp) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetInOutAmountComm1("340810","2010-10-19","00:00","2010-10-20","00:00","DHCNUR21")
	q:(Adm="")!(RecTyp="") ""
	i stime=""  s stime="0:00"
	i entime="" s entime="0:00"
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s eddate=##class(websys.Conversions).DateHtmlToLogical(endate)
	s StTime=$ZTH(stime)
	s EndTime=$ZTH(entime)
	s stdatetime=..GetAbsTime(stdate_","_StTime)
	s endatetime=..GetAbsTime(eddate_","_EndTime)
	s RecTyp=$ZConvert(RecTyp,"U")

	//s dep=parr
	//出入总量对应列
	//	q SumIn_"^"_SumOut_"^"_PartIn_"^"_PartOut_"^"_Pressure_"^"_BlankLable_"^"_CaseMeasure_"^"_DisplaySumIn_"^"_DisplaySumOut_"^"_InCountCols_"^"_OuCountCols_"^"_OrdItm

	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	
	s SumInProperty=$P(ret,"^",1)
	s SumOutProperty=$P(ret,"^",2)
	s PartIn=$P(ret,"^",3)
	s PartOut=$P(ret,"^",4)
	s DisplaySumIn=$P(ret,"^",8)
	s DisplaySumOut=$P(ret,"^",9)

	s InNameProperty=$P(SumInProperty,"&",1)
	s InAmountProperty=$P(SumInProperty,"&",2)
	
	s OutNameProperty=$P(SumOutProperty,"&",1)
	s OutAmountProperty=$P(SumOutProperty,"&",2)

	s PInDspName=$P(PartIn,"&",1)
	s PInDspVal=$P(PartIn,"&",2)
	s PInDspName=$tr(PInDspName,"!","|")

	s POutDspName=$P(PartOut,"&",1)
	s POutDspVal=$P(PartOut,"&",2)
	s POutDspName=$tr(POutDspName,"!","|")

	s InCountCols=$P(ret,"^",10)
	s OuCountCols=$P(ret,"^",11)

	s InDspName=$P(DisplaySumIn,"&",1)
	s InDspVal=$P(DisplaySumIn,"&",2)
	s InDspName=$tr(InDspName,"!","|")
	
	s OutDspName=$P(DisplaySumOut,"&",1)
	s OutDspVal=$P(DisplaySumOut,"&",2)
	s OutDspName=$tr(OutDspName,"!","|")


    s TmPropertyIn="",TmPropertyOu=""
    d ..getpropInOu(InCountCols,.TmPropertyIn)
    d ..getpropInOu(OuCountCols,.TmPropertyOu)
    //////////////////////////
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
	i par="" q ""
	s sumIn=0,sumOut=0,statendtime=""
	s FirstRecorddatetime=..GetFirstRecordDT(Adm,RecTyp,par) //遍历病人护理记录找到时间最早的记录
	k InPartSum,OutPartSum
	for date=stdate:1:eddate
	{
		s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDat"," "_RecTyp,date,par,rw)) q:rw=""  d
		.s arr=^Nur.DHCNurseRecSubD(par,rw)
		.s cdate=$listget(arr,3),ctime=$listget(arr,4)
		.s cdatetime=..GetAbsTime(cdate_","_ctime)
		.//s inouDr=$listget(arr,14)
		.s a=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_rw)
		.s inouDr=a.InOutDr 
		.q:inouDr'=""
		.//作废护理记录不打印
		.s reccanceluserId=$listget(arr,67)
		.q:reccanceluserId'=""
		.//q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		.q:((cdatetime>endatetime)!((cdatetime<=stdatetime)&&(cdatetime'=FirstRecorddatetime))!((cdatetime<stdatetime)&&(cdatetime=FirstRecorddatetime)))
		.i InNameProperty'="" s InName=$ZOBJPROPERTY(a,InNameProperty)
		.e  s InName=""
		.i InAmountProperty'="" s InAmount=$ZOBJPROPERTY(a,InAmountProperty)
		.e  s InAmount=""
		.i InName'="" s InPartSum(InName)=+$G(InPartSum(InName))+InAmount
		.i OutNameProperty'="" s OutName=$ZOBJPROPERTY(a,OutNameProperty)
		.e  s OutName=""
		.i OutAmountProperty'="" s OutAmount=$ZOBJPROPERTY(a,OutAmountProperty)
		.e  s OutAmount=""
		.i OutName'="" s OutPartSum(OutName)=+$G(OutPartSum(OutName))+OutAmount
		.s p="" f  s p=$O(TmPropertyIn(p)) q:p=""  d
		..s val=$ZOBJPROPERTY(a,p)
		..s TmPropertyIn(p)=$G(TmPropertyIn(p))+val
		.s p="" f  s p=$O(TmPropertyOu(p)) q:p=""  d
		..s val=$ZOBJPROPERTY(a,p)
		..s TmPropertyOu(p)=$G(TmPropertyOu(p))+val
		.////qse add 11 05 04
		.s statendtime=cdatetime
	}
	s InStr="",OutStr=""
	s p="" f  s p=$O(TmPropertyIn(p)) q:p=""  d
	.s sumIn=sumIn+TmPropertyIn(p)
	.s InStr=InStr_p_"|"_TmPropertyIn(p)_"^"
	
	s p="" f  s p=$O(TmPropertyOu(p)) q:p=""  d
	.s sumOut=sumOut+TmPropertyOu(p)
	.s OutStr=OutStr_p_"|"_TmPropertyOu(p)_"^"
	
	s InPart="",OutPart=""
	s itm="" f  s itm=$O(InPartSum(itm)) q:itm=""  d
	.s InPart=InPart_itm_":"_InPartSum(itm)_"ml;"
	s itm="" f  s itm=$O(OutPartSum(itm)) q:itm=""  d
	.s OutPart=OutPart_itm_":"_OutPartSum(itm)_"ml;"
	//显示时间段与时间,若结束时间为0:00取最后一条记录的时间
	//Item1显示8:15-16:00,Item2显示7小时45分出入水量
	s StatHr=(endatetime-stdatetime)\3600
	s StatMin=(endatetime-stdatetime)#3600\60
	//s StatHours=StatHr_"小时"_StatMin_"分出入液量统计"
	s StatHours=$S(StatHr>0:StatHr_"小时",1:"")_$S(StatMin>0:StatMin_"分",1:"")_"出入液量统计"
	s StatTime=$ZT(StTime,2)_"----"_$ZT(EndTime,2)
	s r1= InDspName_"^"_InDspVal_"|"_sumIn
	s r2=OutDspName_"^"_OutDspVal_"|"_sumOut
	s r3=PInDspName_"^"_PInDspVal_"|"_InPart
	s r4=POutDspName_"^"_POutDspVal_"|"_OutPart
	s r5="CaseMeasure|"_StatTime_" "_StatHours
	s ret=r1_"^"_r2_"^"_r3_"^"_r4_"^"_r5_"^"_InStr_"^"_OutStr
	q ret
}

ClassMethod getpropInOu(itmstr, tm)
{
   s l=$L(itmstr,"&")
   f i=1:1:l
   {
      if $P(itmstr,"&",i)="" continue
      s tm($P(itmstr,"&",i))=""
   }
}

// d ##class(web.DHCNurseRecordComm).GetNurseRecSet('addrec')

/// 护理记录单配置
/// 2010-09-20
ClassMethod GetNurseRecSet(funname As %String) As %String
{
	s SubKCode=""
	
 	f{
 	    s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode))
 	    q:SubKCode=""
 	    s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
 	  
 	    b
        if ItmId="" continue
        s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
        
	    s RecTyp=$TR(SubKCode," ","")
	    if ($E(RecTyp,1,6)'="DHCNUR")  continue //!($L(RecTyp)>10)
	    s ret=##class(Nur.DHCNurseRecSet).getSet1(RecTyp)
	    //if RecTyp="DHCNURXH1"  s ^objcyf24=ret
	    //s ^objcyf2=^objcyf2_"*"_SubKCode_"%"_ItmId_"%"_RecName_"%"_ret
	    if ret="" continue
	    b //...
 	    s coldata=""
	       s l=$L(ret,"^")
	       s colret="{"
	       for i=1:1:l
	       {
		     s vv=$P(ret,"^",i)
		     if vv="" continue
		     s na=$P(vv,"|",1)
		     s nv=$P(vv,"|",2)
		     s colret=colret_na_":'"_nv_"',"
		    // s tm(na)=nv
		   }
		  if colret="" continue
          s colret=$e(colret,0,$l(colret)-1)
          s colret=colret_"}"
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>
 	}
}

/// 护理记录单配置
/// 2010-09-20
ClassMethod GetNurseRecSet1(funname As %String) As %String
{
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.s RecTyp=$TR(SubKCode," ","")
	.q:($E(RecTyp,1,6)'="DHCNUR")  //!($L(RecTyp)>10)
	.s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	.s SumIn=$P(ret,"^",1)
	.s SumOut=$P(ret,"^",2)
	.s PartIn=$P(ret,"^",3)
	.s PartOut=$P(ret,"^",4)
	.s Pressure=$P(ret,"^",5)
	.s BlankLable=$P(ret,"^",6)
	.s CaseMeasure=$P(ret,"^",7)
	.s DisplaySumIn=$P(ret,"^",8)
	.s DisplaySumOut=$P(ret,"^",9)
	.s InCountCols=$P(ret,"^",10)
 	.s OuCountCols=$P(ret,"^",11)
 	.s OrdItm=$P(ret,"^",12)
 	.s rtnval=funname_"('"_$ZCVT($g(RecTyp),"O","JS")_"','"_$ZCVT($g(RecName),"O","JS")_"','"_$ZCVT($g(SumIn),"O","JS")_"','"_$ZCVT($g(SumOut),"O","JS")_"','"_$ZCVT($g(PartIn),"O","JS")_"','"_$ZCVT($g(PartOut),"O","JS")_"','"_$ZCVT($g(Pressure),"O","JS")_"','"_$ZCVT($g(BlankLable),"O","JS")_"','"_$ZCVT($g(CaseMeasure),"O","JS")_"','"_$ZCVT($g(DisplaySumIn),"O","JS")_"','"_$ZCVT($g(DisplaySumOut),"O","JS")_"','"_$ZCVT($g(InCountCols),"O","JS")_"','"_$ZCVT($g(OuCountCols),"O","JS")_"','"_$ZCVT($g(OrdItm),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// 科室列表
/// 2010-09-28
ClassMethod GetDep(LocId As %String, funname As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDep("","")
	if LocId'="" 
	{
		s LocDesc=$P(^CTLOC(LocId),"^",2)
		q:LocDesc=""
		s rtnval=funname_"('"_$ZCVT($g(LocDesc),"O","JS")_"','"_$ZCVT($g(LocId),"O","JS")_"');"
		&javascript<#(rtnval)#>	
	}
	else
	{
		s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
		.s LocDesc=$P(^CTLOC(rw),"^",2)
		.q:LocDesc=""
		.s rtnval=funname_"('"_$ZCVT($g(LocDesc),"O","JS")_"','"_$ZCVT($g(rw),"O","JS")_"');"
		.&javascript<#(rtnval)#>
	}
	q 0
}

// d ##class(web.DHCNurseRecordComm).ifexist("9000")

ClassMethod ifexist(LocId As %String) As %String
{
	s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	q DepModelStr
}

/// 护理记录单配置
/// 2010-09-28
ClassMethod GetDepModelSet(LocId As %String, funname As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDepModelSet("211","")
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr) d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelKey)=ModelName_"^"_ModelSort
    s DepModelStr=$G(^DHCNurDepModelSet("9000"))
	f ii=1:1:$L(DepModelStr) d
	.s DepModel=$P(DepModelStr,"^",ii)
	.q:DepModel=""
	.s ModelKey=$P(DepModel,"|",1)
	.s ModelName=$P(DepModel,"|",2)
	.s ModelSort=$P(DepModel,"|",3)
	.s QYDepModel(ModelKey)=ModelName_"^"_ModelSort
	s SubKCode="" f  s SubKCode=$O(^NurEmr.NurEmrSubI("KCode",SubKCode)) q:SubKCode=""  d
	.s ItmId=$O(^NurEmr.NurEmrSubI("KCode",SubKCode,""))
	.q:ItmId=""
	.s RecName=$List(^NurEmr.NurEmrSubD(ItmId),4)
	.s RecTyp=$TR(SubKCode," ","")
	.q:($E(RecTyp,1,6)'="DHCNUR")

	.//q:(($L(RecTyp)>15)&(RecTyp'="DHCNURCHANGELABLERECLOC")&(RecTyp'="DHCNURCOPYDIAGNOS"))
	.s ModelName="",ModelSort="",IfShow=0
	.i $D(DepModel(RecTyp)) d
	..s ModelName=$P(DepModel(RecTyp),"^",1)
	..s ModelSort=$P(DepModel(RecTyp),"^",2)
	..s IfShow=1
	.q:('$D(QYDepModel(RecTyp)))&&(LocId'="9000")
	
 	.s rtnval=funname_"('"_$ZCVT($g(RecTyp),"O","JS")_"','"_$ZCVT($g(RecName),"O","JS")_"','"_$ZCVT($g(IfShow),"O","JS")_"','"_$ZCVT($g(ModelSort),"O","JS")_"','"_$ZCVT($g(ModelName),"O","JS")_"');"
 	.&javascript<#(rtnval)#>
 	q 0
}

/// 保存科室所显示的模版
/// 	^DHCNurDepModelSet
/// 2010-09-28
ClassMethod SaveDepModel(LocId As %String, parr As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).SaveDepModel("1","DHCNUR1|外科模版|1^DHCNUR2|内科模版|2")
	q:LocId="" "请先选择科室!"
	s ^DHCNurDepModelSet(LocId)=parr
	q 0
}

/// 护理记录单配置,显示用
/// 2010-09-28
ClassMethod GetDepModel(LocId As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetDepModel("1")
	s ^ool=LocId
	i LocId'="" d
	.s DepModelStr=$G(^DHCNurDepModelSet(LocId))
	.f ii=1:1:$L(DepModelStr,"^") d
	..s DepModel=$P(DepModelStr,"^",ii)
	..q:DepModel=""
	..s ModelKey=$P(DepModel,"|",1)
	..s ModelName=$P(DepModel,"|",2)
	..s ModelSort=$P(DepModel,"|",3)
	..s DepModel(ModelSort)=ModelKey_"|"_ModelName

	s ret=""
	s sort="" f  s sort=$O(DepModel(sort)) q:sort=""  d
	.s ret=ret_DepModel(sort)_"^"
 	q ret
}

/// 通用护理记录单出入量分项提示框显示
/// 2010-10-14
ClassMethod GetSubInOut(parr) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetSubInOut("10^173")
	s par=$P(parr,"^",1)
	s rw=$P(parr,"^",2)
	q:(par="")!(rw="") ""
	s str="",PartInAmount="",PartOutAmount=""
	s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
	s InOutDr=$listget(arr,6)
	i InOutDr'="" d
	.s PartInAmount=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^I")
	.s PartOutAmount=##class(Nur.DHCNurPatSumInOutSub).GetSubInOutt(InOutDr_"^O")
 	q "入液量分项@"_PartInAmount_"@出液量分项@"_PartOutAmount
}

/// 通用取用户的类别:医生还是护士,NURSE/DOCTOR
/// 2010-10-19
ClassMethod GetUserType(userId As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).GetUserType("4337")
	q:userId="" ""
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	q:ctpcpId="" ""
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" ""
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	q:ctcptInternalType="" ""
	q ctcptInternalType
}

/// 更新护理记录关联的诊断
/// 2010-11-23
ClassMethod UpdateDiagnos(par As %String, rw As %String, DiagnosDr As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).UpdateDiagnos(17,259,46)
	q:(par="")!(rw="")!(DiagnosDr="") ""
	s Id=par_"||"_rw
	s a=##class(Nur.DHCNurseRecSub).%OpenId(Id)
	s a.DiagnosDr=DiagnosDr
	d a.%Save()
	q 0
}

/// 遍历护理记录找到记录时间最早的记录(认为是首条记录)
/// 2010-11-26
ClassMethod GetFirstRecordDT(adm As %String, RecTyp As %String, par As %String) As %String
{
	s stdate=$P(^PAADM(adm),"^",6) 
	s eddate=$P($H,",",1)
	s FristRecorddatetime=""
	for date=stdate:1:eddate
	{
		s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDat"," "_RecTyp,date,par,rw)) q:rw=""  d
		.s arr=^Nur.DHCNurseRecSubD(par,rw)
		.s cdate=$listget(arr,3),ctime=$listget(arr,4)
		.s cdatetime=..GetAbsTime(cdate_","_ctime)
		.i FristRecorddatetime="" s FristRecorddatetime=cdatetime
		.e  d
		..i cdatetime<FristRecorddatetime s FristRecorddatetime=cdatetime
	}
	q FristRecorddatetime
}

/// 作废护理记录/查询,打印,统计均不显示作废
/// 2010-12-30
ClassMethod CancelRecord(par As %String, rw As %String, userId As %String, usergroup As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).CancelRecord(17,259)
	
	q:(par="")!(rw="")!(userId="") "没有选中护理记录或登陆用户为空!"
	s Id=par_"||"_rw
	
	q:rw="undefined" "还未保存，不能作废"
	s a=##class(Nur.DHCNurseRecSub).%OpenId(Id)
	if a.RecCancelUser'="" q "该护理记录已经作废!"
	s recuserId=a.RecUser
	i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	e  s recuser=""
	if (usergroup'["护士长")&(userId'=recuserId) q "对不起您无权作废,请联系护士长或"_recuser
	s a.RecCancelUser=userId
	s a.RecCancelDate=+$H
	s a.RecCancelTime=$P($H,",",2)
	d a.%Save()
	q 0
}

ClassMethod CancelMoudRecord(par As %String, userId As %String, usergroup As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).CancelRecord(17,259)
	q:(par="")!(userId="") "没有选中护理记录或登陆用户为空!"
	s Id=par
	s a=##class(Nur.DHCMoudData).%OpenId(Id)
	if a.Status'="" q "该记录已经作废!"
	s a.Status="C"
	s a.RecCancelUser=userId
	s a.RecCancelDate=+$H
	s a.RecCancelTime=$P($H,",",2)
    d a.%Save()
	q 0
	s recuserId=a.RecUser
	i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	e  s recuser=""
	if (usergroup'["护士长")&(userId'=recuserId) q "对不起您无权作废,请联系护士长或"_recuser
}

// w ##class(web.DHCNurseRecordComm).NotCancelMoudRecord(17,259)

ClassMethod NotCancelMoudRecord(par As %String, userId As %String, usergroup As %String) As %String
{
    q:(par="")!(userId="") "没有选中护理记录或登陆用户为空!"
    s id=par
    s a=##class(Nur.DHCMoudData).%OpenId(id)
    if a.Status'="" q "该记录已经作废!"
    s a.Status=""
    s a.RecCancelUser=""
    s a.RecCancelDate=""
    s a.RecCancelTime=""
    d a.%Save()
    q 0
}

/// 评估单列表Query
ClassMethod MoudDatabyAdmExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s parr=$replace(parr,"!","^")
    s EmrCode=$P(parr,"^",1)
    s code=$ZConvert(EmrCode,"U")
    s EpisodeId=$P(parr,"^",2)
    s Loc=$P(parr,"^",3)
    s IfCncelRec=$p(parr,"^",6)
    s patinfostr=""
    i EpisodeId'="" s patinfostr=##class(web.DHCMGNurComm).GetPatInfo(EpisodeId)
        
    s ii=0        
    s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,p)) q:p=""  d
    .s a=##class(Nur.DHCMoudData).%OpenId(p)
    .s sta=a.Status
    .q:(IfCncelRec="false")&(sta="C")
    .q:(IfCncelRec="true")&(sta'="C")
    .s ret=##class(Nur.DHCMoudData).getVal(p)
    .if p="RecAuditUser"  d
    ..s ret=$P(^SSU("SSUSR",ret),"^")
    .s ii=ii+1
    .s ret=ret_"^par|"_p_"^Seqno|"_ii_"^"_patinfostr
    .d outtyp2
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
outtyp2
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod MoudDatabyAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDatabyAdmExecute ]
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

Query MoudDatabyAdm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDatabyAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDatabyAdmExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetQueryData1(QueryName As %String, parrm As %String, funname As %String) As %String
{
  //s a=##class(web.DHCThreeNew).GetQueryData()
   //s QueryName="web.DHCTHREEEX.GetTimePoint"
   //s parrm=""
   //s funname="AddRec"

   //s ^TT("a")=QueryName
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     if itm="" continue
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
 
  if pp="" s sc=rset.Execute()
  else  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
	   i (i=0){
        For col = 1:1:columns {
         s head(col)=rset.GetColumnName(col)
        }
       }
       s coldata=""
       s rd="["
       s colret="{"
       For col = 1:1:columns {
	       s aa=rset.GetData(col)

		   s colret=colret_head(col)_":'"_aa_"',"
        }
        s colret=$e(colret,0,$l(colret)-1)
	    s colret=colret_"}"
        b //
        s coldata="'"_$ZCVT(colret,"O","JS")_"'"
  // s rd=$e(rd,0,$l(rd)-1)_"]"
  // s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
  &javascript<#(rtnval)#>
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

ClassMethod GetCurDate()
{
	q $zd(+$h,3)
}

ClassMethod GetCurTime()
{
	q $zt($p($h,",",2),2)
}

}
