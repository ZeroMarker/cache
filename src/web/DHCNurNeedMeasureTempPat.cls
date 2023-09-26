Import SQLUser

Class web.DHCNurNeedMeasureTempPat Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod getarcimname(Oew, OrdSub) As %String
{
	s ArcimDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",2)
	s ARCIMRowid=$P(ArcimDR,"||",1)
	s ARCIMSub=$P(ArcimDR,"||",2)
	s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)  ;ord name   
	q ARCIMD
}

ClassMethod GetNeedMeaserBPExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	  // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      s ^TMP("parr")=Parr
 		  s Parr=$TR(Parr,"!","^")
 	      s Ward=$p(Parr,"^")
 	      s curdate=$p(Parr,"^",2)
 	      s curdate=$ZDH(curdate,3)
 	      s sttime=$ZTH($p(Parr,"^",3))
 	      s etime=$ZTH($p(Parr,"^",4))
 	      s Ward=##class(web.DHCThreeNew).getlocward(Ward)
 	      //s arcim="A||1"
 	      s OArcim("19771||1")="",OArcim("19772||1")=""
 	      s room=""
         f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus'="A"
		   ..s Oew=$O(^OEORD(0,"Adm",RowId,""))
		   ..q:Oew=""
		   ..s arcim=""  f  s arcim=$O(OArcim(arcim)) q:arcim=""  d
		   ...s timstr="" ,phcfrCode="",ArcimName=""
		   ...b ;001
           ...s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,arcim,curdate,OrdSub)) q:(OrdSub="")  d
		   ....s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
		   ....s OrdStat=""
		   ....i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
		   ....q:OrdStat="D"
		   ....b ;002
	       ....s phcfrId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4)
	       ....i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
	       ....s timstr=..FreqTime(phcfrId,sttime,etime)
	       ....s ArcimName=..getarcimname(Oew,OrdSub)
	       ...q:timstr=""
		   ...s pinfo=##class(web.DHCThreeNew).Patinfo(RowId)
		   ...s Name=$P(pinfo,"#",2)
	       ...s Bed=$P(pinfo,"#",3)
	       ...s left=$P(pinfo,"#",6)
           ...s top=$P(pinfo,"#",7)
           ...s PatRegNo=$P(pinfo,"#",8)
           ...s Data(top,left)=RowId_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_timstr_"^"_phcfrCode_"^"_ArcimName

      	   s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s TimStr=$P(Data(r,c),"^",5), FreqCode=$P(Data(r,c),"^",6),ArcimName=$P(Data(r,c),"^",7)
	       ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^FreqCode|"_FreqCode_"^TimStr|"_TimStr_"^ArcimName|"_ArcimName
	       ..d OutPat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetNeedMeaserBPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNeedMeaserBPExecute ]
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

ClassMethod GetNeedMeaserBPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNeedMeaserBPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetNeedMeaserBP(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod gettestbp(Parr) As %String
{
	      s Parr=$TR(Parr,"!","^")
 	      s Ward=$p(Parr,"^")
 	      s curdate=$p(Parr,"^",2)
 	      s curdate=$ZDH(curdate,3)
 	      s sttime=$ZTH($p(Parr,"^",3))
 	      s etime=$ZTH($p(Parr,"^",4))
 	      s Ward=##class(web.DHCThreeNew).getlocward(Ward)
 	      s arcim="A||1"
         f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus'="A"
	       ..s timstr="" ,phcfrCode=""
		   ..s Oew=$O(^OEORD(0,"Adm",RowId,""))
		   ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,arcim,curdate,OrdSub)) q:(OrdSub="")  d
		   ...s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
		   ...s OrdStat=""
		   ...i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
		   ...q:OrdStat="D"
	       ...s phcfrId=$p($g(^OEORD(oew,"I",OrdSub,2)),"^",4)
	       ...i phcfrId'="" s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
	       ...s timstr=..FreqTime(phcfrId,sttime,etime)
	       ..q:timstr=""
		   ..s pinfo=##class(web.DHCThreeNew).Patinfo(RowId)
		   ..s Name=$P(pinfo,"#",2)
	       ..s Bed=$P(pinfo,"#",3)
	       ..s left=$P(pinfo,"#",6)
           ..s top=$P(pinfo,"#",7)
           ..s PatRegNo=$P(pinfo,"#",8)
           ..s Data(top,left)=adm_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_timstr_"^"_phcfrCode
}

ClassMethod FreqTime(frw, stim, etim) As %String
{
 //取频次时间
 // n (freq)
  q:$g(frw)="" ""  //ypz 061209
  s ftimstr=""
  s chl=0  f  s chl=$o(^PHCFR(frw,"DT",chl))  q:chl=""  d
  .s timeStr=$g(^PHCFR(frw,"DT",chl))
  .b ;001
  .s tm=$ZT(timeStr,2)
  .if (timeStr'<stim)&(timeStr'>etim) d
  ..i ftimstr="" d
  ...s ftimstr=tm
  ..e  s ftimstr=ftimstr_" - "_tm
  
  q $g(ftimstr)
}

ClassMethod gettims(factor) As %String
{
    s ret=""
    s n=""  f  s n=$O(^OTimStr("BP",factor,n)) q:n=""  d
    .s tim=$ZT(^OTimStr("BP",factor,n),2)
    .//w tim,!
    .s ret=ret_tim_","
    q ret
}

/// 根据测量次数算时间点
ClassMethod GetMeasureTime(frw, stim, etim) As %String
{
  //w ##class(web.DHCNurNeedMeasureTempPat).GetMeasureTime(95,0,86340)
  q:$g(frw)="" ""  //ypz 061209
  s ftimstr=""
  s factor=$p($g(^PHCFR(frw)),"^",2)
  q:factor=""
  
  s chl=0  f  s chl=$o(^OTimStr("BP",factor,chl))  q:chl=""  d
  .s timeStr=$g(^OTimStr("BP",factor,chl))
  .s tm=$ZT(timeStr,2)
  .if (timeStr'<stim)&(timeStr'>etim) d
  ..i ftimstr="" d
  ...s ftimstr=tm
  ..e  s ftimstr=ftimstr_" - "_tm
  
  q $g(ftimstr)
}

// d ##class(%ResultSet).RunQuery("web.DHCNurNeedMeasureTempPat","GetNeedMeaserPat","27^2012-04-13^18:00:00")

ClassMethod GetNeedMeaserPatExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      s Parr=$TR(Parr,"!","^")
 	      s ward=$p(Parr,"^")
 	      s curDate=$p(Parr,"^",2)
 	      s curTime=$p(Parr,"^",3)
 	      if curTime="24:00:00"  s curTime="23:59:59"
 	      s LocCat=..GetLocCat(ward)
	      s ward=##class(web.DHCThreeNew).getlocward(ward)
          if (ward'="")
	      {
			   s TMP=""
			   s ITM=""
			   s TYPE=""
			   s a=..getTempContidion(.ITM,.TYPE,LocCat)
			   s a=..NeedMeasureTempPats(ward,curDate,curTime,.TMP,.ITM,.TYPE)  ///求出患者类型 
			   s adm=""  f  s adm=$O(TMP("Adm",adm)) q:adm=""  d
			   .q:$G(TMP("Adm",adm))'=1
			   .s patInfo=..Patinfo1(adm)
		       .q:patInfo=""
		       .s name=$P(patInfo,"#",2)
		       .s bed=$P(patInfo,"#",3)
		       .s left=$P(patInfo,"#",6)
	           .s top=$P(patInfo,"#",7)
	           .s patRegNo=$P(patInfo,"#",8)
	           .i (top*left=0) s top="#",left=adm
	           .s Data(top,left)=adm_"^"_name_"^"_bed_"^"_patRegNo
	      	   s top="" f  s top=$O(Data(top)) q:top=""  d
	           .s left=""  f  s left=$O(Data(top,left)) q:left=""  d
	           ..s adm=$P(Data(top,left),"^",1),name=$P(Data(top,left),"^",2),bed=$P(Data(top,left),"^",3),patRegNo=$P(Data(top,left),"^",4)
	           ..s aa=##class(web.DHCThreeNew).getobjval(adm,curDate,curTime)
	           ..s Papmidr=$P(^PAADM(adm),"^",1)
	           ..S PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel(Papmidr,"")
           	   ..S EncryptLevel=$p(PatEncryptLevel,"^",1)
           	   ..S PatLevel=$p(PatEncryptLevel,"^",2) 
		       ..s aa="Adm|"_adm_"^PatName|"_name_"^BedCode|"_bed_"^RegNo|"_patRegNo_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^"_aa
		       ..d OutPat
	      }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetNeedMeaserPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNeedMeaserPatExecute ]
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

ClassMethod GetNeedMeaserPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNeedMeaserPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query GetNeedMeaserPat(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod NeedMeasureTempPats(Ward, curDate, curTime, TMP, ITM, TYPE) As %String
{
  	       s room="" 
  	       s curDate=$ZDH(curDate,3)
  	       s curTime=$zth(curTime)
	       f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s adm=""  f  s adm=$O(^PAADMi("CurrWard",Ward,room,adm)) q:adm=""  d
	       ..s VistStatus=$P(^PAADM(adm),"^",20)
	       ..q:VistStatus'="A" 
	       ..s a=..ifPatNeedMeasure(adm,curDate,curTime, .TMP, .ITM,.TYPE)
	q 0
}

ClassMethod ifPatNeedMeasure(adm, curDate, curTime, TMP, ITM, TYPE) As %String
{
	 //ITM(times,code)=time_"|"_tval_"|"_tempcode_"|"_method 
	s i=""

	s searchOrdFlag=0
	s searchEventFlag=0
	s temp=..getnormalflag(adm,curDate,"#Item1#")  //获取前三天体温数据
	s maxTemp=+temp
	f 
	{
		s i=$o(ITM(i),-1)
		q:i=""
		s code=""
		f 
		{
			i $g(TMP("Adm",adm))=1 q
			s code=$o(ITM(i,code))
			s ret=0
			q:code=""
			s times=$p(ITM(i,code),"@",1)
			s tempCondition=$p(ITM(i,code),"@",2)
			s type=$p(ITM(i,code),"@",3)
			i type="ORD"
			{
				i searchOrdFlag'=1
				{
					s ret=..searchOrd(adm,.TYPE,curDate)
					s searchOrdFlag=1
				}
				if $g(TYPE(type,code,adm))=""  continue  //不等于1表示不存在该医嘱
			}
			if (type="EVENT")
			{
					i searchEventFlag'=1
					{ 
						s ret=..searchEvent(adm,.TYPE,curDate)
						s searchEventFlag=1
					}
					if $g(TYPE(type,code,adm))=""  continue //不等于1表示不存在该事件
			}
			if (type="TEMP")
			{
				s ret=..ifTempInCondition(maxTemp,tempCondition)  //不属于医嘱和事件的情况判断体温
				if ret'=1 continue
			}
			s ret=0
			i type="ORD" s ret=..ifTimeInCondition(curTime,times,TYPE(type,code,adm))
			e  s ret=..ifTimeInCondition(curTime,times)
			i ret=1 s TMP("Adm",adm)=1
		}
	}
	q ""
}

ClassMethod searchEvent(adm As %String, TYPE, curdate As %String) As %String
{
	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",adm,rw)) q:rw=""  d
	.s date=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s TypeDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.s TypeCode=$P($g(^DHCQTRECTYP("typ",TypeDr)),"^",1)    //code
	.s stDate=date,edDate=date+3
	.s code="" f  s code=$o(TYPE("EVENT",code)) q:code=""  d
	..q:$p(TYPE("EVENT",code),"@",1)'[("#"_TypeCode_"#")
	..q:((curdate<stDate)||(curdate>edDate))
	..s TYPE("EVENT",code,adm)=1
   q ""
}

ClassMethod searchOrd(adm As %String, TYPE, curdate As %String) As %String
{
	s oeordId=""
	s oeordId=$O(^OEORD(0,"Adm",adm,""))
	q:oeordId="" ""
	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",oeordId,curdate,ordSttTime)) q:ordSttTime=""  d
	.s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"Date",oeordId,curdate,ordSttTime,oeoriSub)) q:oeoriSub=""  d
	..s oeoreSub=0 f  s oeoreSub=$o(^OEORDi(0,"Date",oeordId,curdate,ordSttTime,oeoriSub,oeoreSub)) q:oeoreSub=""  d
	...s ordStatCode=""
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub_"||"_oeoreSub) //医嘱状态
	...q:(ordStatCode="D")||(ordStatCode="U")||(ordStatCode="C")
	...s execStatusCode=""
	...s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
	...i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)  
	...q:($g(execStatusCode)="D")||($g(execStatusCode)="R")||($g(execStatusCode)="C")
	...s arcimDr=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
	...q:arcimDr=""
	...s arcimCode=$p(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1),"^",1)
	...q:arcimCode
	...s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	...i phcfrId'="" d
	....s phcfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	...s code="" f  s code=$o(TYPE("ORD",code)) q:code=""  d
	....q:$p(TYPE("ORD",code),"@",1)'[("#"_arcimCode_"#")
	....s TYPE("ORD",code,adm)=$g(phcfactor)
	q ""
}

ClassMethod ifTempInCondition(maxTemp As %String, tempCondition As %String) As %String
{
	s flag=0
    if ($f(tempCondition,">")'=0)
    {
	    s temp=$P(tempCondition,">",2)
	    if maxTemp>temp s flag=1
	}
   if ($f(tempCondition,"<")'=0)
    {
	  s temp=$P(tempCondition,"<",2)  
	  if maxTemp<temp  s flag=1
	}
	if ($f(tempCondition,"-")'=0)
    {
	   s minTemp=$P(tempCondition,"-")
	   s Temp=$P(tempCondition,"-",2)
	   if (maxTemp'>Temp)&(maxTemp'<minTemp) s flag=1
	}
	q flag
}

ClassMethod ifTimeInCondition(curTime As %String, times As %String = "", num As %String = "") As %String
{
   s ret=0
   i (times="")&&(num="") q ret
   i times="" s times=..getTimes(num)
   i times="" q ret
   s length=$l(times,",")
   s stTime=curTime-7200
   s edTime=curTime+7200
   f i=1:1:length
   {
     s time=$P(times,",",i)
     s time=$tr(time," ","")
     if time="" continue
     s time=$ZTH(time)
     i (time>stTime)&(time<edTime) s ret=1
   }
   q ret
}

ClassMethod getTimes(num = "")
{
	i num=1 q "12:00"
	i num=2	q "10:00,14:00"
	i num=3 q "10:00,14:00,18:00"
	i num=4 q "06:00,10:00,14:00,18:00"
	i num=5 q "06:00,10:00,14:00,18:00,22:00"
	q ""
}

ClassMethod getTempContidion(ITM, TYPE, typ) As %String
{
	//s itemcode=$ZConvert(typ,"U")
    ///s a=##class(web.DHCNurNeedMeasureTempPat).getTempContidion(a)
	//s rw=^Nur.DHCNurTempContidionD(rw)
	
    s rw=""  f  s rw=$O(^Nur.DHCNurTempContidionI("OM"," "_typ,rw)) q:rw=""  d
    .s a=##class(Nur.DHCNurTempContidion).%OpenId(rw)
    .s code=a.ConName   //配置code
    .s times=a.ConTimes   //时间点
    .i +times=0 s times=""
    .s tempContidion=a.ConValues   //条件
    .s otherStr=a.ConTempCode  //事件串或者医嘱项ID串
    .s method=a.ConFunction	//调用函数
    .s type=a.ConPriority //改用优先级存类型
    .s num=$l(times,",")
    .i code'="" D
    ..s ITM(num,code)=times_"@"_tempContidion_"@"_type
    ..i type'="" s TYPE(type,code)=otherStr
    
   q 0
}

ClassMethod getnormalflag(Adm, date, tempcodes) As %String
{
  ///s a=##class(web.DHCNurNeedMeasureTempPat).getnormalflag(
    //b ///325017
    s StDate=date-3
    s EndDate=date
    s MaxTemp=0
    s MaxDate=0
    s lastTemp=""
    s lastDate=""
    s lowtmp="N"  //低温不升
    s Mradm=$P(^PAADM(Adm),"^",61) 
    f Date=StDate:1:EndDate
	{
		s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr)) q:ItmDr=""  d
		.q:'$D(^MRC("OBITM",ItmDr))
		.s code=$P(^MRC("OBITM",ItmDr),"^",1)
		.s itmcode="#"_code_"#"
		.q:tempcodes'[itmcode
	    .s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",Date,ItmDr,chl)) q:chl=""  d
		..s Value=$P(^MR(Mradm,"OBS",chl),"^",2)
		..s OBSD=$P(^MR(Mradm,"OBS",chl),"^",3)
		..s OBST=$P(^MR(Mradm,"OBS",chl),"^",4)
		..s Desc=$P(^MR(Mradm,"OBS",chl),"^",6)
		..if Value'>35 s lowtmp="Y"
		..if MaxTemp<Value  s MaxTemp=Value,MaxDate=OBSD_"^"_OBST  //最高值
		..s lastTemp=Value,lastDate=OBSD_"^"_OBST  //最后一次值
	}
	q MaxTemp_"^"_MaxDate_"|"_lastTemp_"^"_lastDate_"|"_lowtmp
}

ClassMethod Patinfo(Adm As %String) As %String
{
		//n (Adm)
		   s bedchl=""
		   s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       .s CurrentBedDR=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       .q:CurrentBedDR=""
	       .s bedchl=$P(CurrentBedDR,"||",2)
	       .s Ward=$P(CurrentBedDR,"||",1)
	       .s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       q:bedchl="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s AdmDate=$ZD($P(^PAADM(Adm),"^",6),3)_" "_$ZT($P(^PAADM(Adm),"^",7))
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"
           s birth=$p($g(^PAPER(Papmidr,"ALL")),"^",6)
           s age=##class(web.DHCCLCom).CalAge(birth,+$h)
	       //s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_bedchl_"#"_$G(RegNo)
         q adm(Bed)
}

ClassMethod GetNeedMeaserBP1Execute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	  // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
          s ^objlgl14=Parr
 		  s Parr=$TR(Parr,"!","^")
 	      s Ward=$p(Parr,"^")
 	      s curdate=$p(Parr,"^",2)
 	      s curdate=$ZDH(curdate,3)
 	      s sttime=$ZTH($p(Parr,"^",3))
 	      s etime=$ZTH($p(Parr,"^",4))
 	      s Ward=##class(web.DHCThreeNew).getlocward(Ward)
 	      s room=""
          f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus'="A"
		   ..s Oew=$O(^OEORD(0,"Adm",RowId,""))
		   ..q:Oew=""
		   ..s timstr="" ,phcfrCode="",ArcimName="",phcfrstr="",phcfactor=""
		   
		   ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",curdate,Oew,OrdSub)) q:(OrdSub="")  d
		   ...s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
		   ...s OrdStat=""
		   ...i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
		   ...q:OrdStat="D"
		   ...s ArcimName=..getarcimname(Oew,OrdSub)
		   ...s phcfrId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4)
	       ...i phcfrId'="" d
	       ....s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
	       ....s phcfactor=$p($g(^PHCFR(phcfrId)),"^",2)
	       
	       ...s flag=0
		   ...i (ArcimName["测血压")||(ArcimName["测生命体征") d
		   ....s flag=1
		   ....s phcfrstr=phcfrCode
	       ....s timstr=..GetMeasureTime(phcfrId,sttime,etime)
	      
	       ...q:flag=0
		   ...s pinfo=##class(web.DHCThreeNew).Patinfo(RowId)
		   ...s Name=$P(pinfo,"#",2)
	       ...s Bed=$P(pinfo,"#",3)
	       ...s left=$P(pinfo,"#",6)
           ...s top=$P(pinfo,"#",7)
           ...s PatRegNo=$P(pinfo,"#",8)
           ...b ;001
           ...s Data(top,left)=RowId_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_timstr_"^"_phcfrstr_"^"_ArcimName_"^"_phcfactor


      	   s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s TimStr=$P(Data(r,c),"^",5), FreqCode=$P(Data(r,c),"^",6),ArcimName=$P(Data(r,c),"^",7),phcfactor=$P(Data(r,c),"^",8)
	       ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^FreqCode|"_FreqCode_"^TimStr|"_TimStr_"^ArcimName|"_ArcimName_"^phcfactor|"_phcfactor
	       ..d OutPat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetNeedMeaserBP1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNeedMeaserBP1Execute ]
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

ClassMethod GetNeedMeaserBP1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNeedMeaserBP1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(%ResultSet).RunQuery("web.DHCNurNeedMeasureTempPat","GetNeedMeaserBP","111^2011-12-15^00:01^12:00")

Query GetNeedMeaserBP1(Parr As %String) As %Query(ROWSPEC = "aa") [ SqlProc ]
{
}

/// 判断某科室是内科还是外科,内科室返回M,外科返回O
ClassMethod GetLocCat(LocId)
{
	  
	  s flag=0
	  s LocCat="O"
	  s LLId="" f  s LLId=$o(^CT("LL",LLId)) q:(LLId="")||(flag=1)  d
	  .s chl=$o(^CT("LL",LLId,"LOC",0,"Loc",LocId,"")) 
	  .q:chl=""
	  .s LocCatDesc=$p($g(^CT("LL",LLId)),"^",2)
	  .i LocCatDesc["内科" s LocCat="M"
	  .i LocCatDesc["外科" s LocCat="O"
	  .s flag=1
	  q $G(LocCat)
}

ClassMethod Patinfo1(Adm As %String) As %String
{
		  // n (Adm)
		   s CurrentBedDR=""
		   s VisitStatus=""
		   s VisitStatus=$P(^PAADM(Adm),"^",20)
		   i VisitStatus="D" d  //出院病人取转床最后一条记录的床号
           .s chl="" f  s chl=$o(^PAADM(Adm,"TRANS",chl)) q:chl=""  d
	       ..s CurrentBedDRTMP=$p(^PAADM(Adm,"TRANS",chl),"^",8)
	       ..i CurrentBedDRTMP'="" s CurrentBedDR=CurrentBedDRTMP
           i VisitStatus="A" s CurrentBedDR=$P(^PAADM(Adm),"^",73)   //在院病人取PA_adm表里的记录,因为存在在等待区未入床的情况所以不能取转床最后一条记录
	       q:CurrentBedDR="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s bedchl=$P(CurrentBedDR,"||",2)
	       s Ward=$P(CurrentBedDR,"||",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"

	       s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_pstop_"#"_psleft_"#"_RegNo
         q adm(Bed)
}

// d ##class(%ResultSet).RunQuery("web.DHCNurNeedMeasureTempPat","GetNeedMeaserBP3","27^2014-12-04^0:00^23:59^2")

ClassMethod GetNeedMeaserBP3Execute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
      // n (Ward,RegNo)
          Set repid=$I(^CacheTemp)
          s ind=1
          //s ^objlgl14=Parr
          s Parr=$TR(Parr,"!","^")
          s Ward=$p(Parr,"^")
          s curdate=$p(Parr,"^",2)
          s curdate=$ZDH(curdate,3)
          s sttime=$ZTH($p(Parr,"^",3))
          s etime=$ZTH($p(Parr,"^",4))
          s typ=$p(Parr,"^",5)
          i typ="" s typ=2
          s Ward=##class(web.DHCThreeNew).getlocward(Ward)
          s room=""
          f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
           .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
           ..;s PatFlag=##class(web.DHCNurComNew).isNewEpisode(RowId)
           ..;q:PatFlag'=1 ;老系统病人退出
           ..;b ;01
           ..s VistStatus=$P(^PAADM(RowId),"^",20)
           ..q:VistStatus'="A"
           ..s Oew=$O(^OEORD(0,"Adm",RowId,""))
           ..q:Oew=""
           ..s timstr="" ,phcfrCode="",ArcimName="",phcfrstr="",phcfactor=""
           ..s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",Oew,curdate,ordSttTime)) q:(ordSttTime="")  d
           ...q:(ordSttTime<sttime)!(ordSttTime>etime)
           ...s OrdSub=0  f  s OrdSub=$o(^OEORDi(0,"Date",Oew,curdate,ordSttTime,OrdSub)) q:(OrdSub="")  d
           ....s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
           ....s OrdStat=""
           ....i (Oew=417)&(OrdSub=25) b ;031
           ....i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
           ....q:OrdStat="D"
           ....;b ;01
           ....s ArcimName=..getarcimname(Oew,OrdSub)
           ....s phcfrId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4)
           ....q:phcfrId=""
           ....i phcfrId'="" d
           .....s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
           .....s phcfactor=$p($g(^PHCFR(phcfrId)),"^",2)
           ....s flag=0
           ....i (Oew=417)&(OrdSub=25) b ;033
           ....i (ArcimName["测血压")!(ArcimName["测生命体征")!(ArcimName["血压监测") d
           .....b ;04
           .....s flag=1
           .....s phcfrstr=phcfrCode
           .....s timstr=..GetMeasureTime2(phcfrId,sttime,etime,OrdStat,Oew_"||"_OrdSub,typ)
           .....;b ;02
           ....q:flag=0
           ....q:(typ=3)&&(timstr'="not") ///d
           ....s pinfo=##class(web.DHCThreeNew).Patinfo1(RowId)
           ....s Name=$P(pinfo,"#",2)
           ....s Bed=$P(pinfo,"#",3)
           ....s left=$P(pinfo,"#",9)
           ....s top=$P(pinfo,"#",8)
           ....s PatRegNo=$P(pinfo,"#",7)
           ....q:Bed=""
           ....s Data(top,left)=RowId_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_timstr_"^"_phcfrstr_"^"_ArcimName_"^"_phcfactor
       
          b ;03
          if typ="3"
          {
	       s n=1
           s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s TimStr=$P(Data(r,c),"^",5), FreqCode=$P(Data(r,c),"^",6),ArcimName=$P(Data(r,c),"^",7),phcfactor=$P(Data(r,c),"^",8)
           ..s tim=""
           ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^FreqCode|"_FreqCode_"^TimStr|"_tim_"^ArcimName|"_ArcimName_"^phcfactor|"_phcfactor
           ..d OutPat3

	      }else
	      {
           s n=1
           s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s TimStr=$P(Data(r,c),"^",5), FreqCode=$P(Data(r,c),"^",6),ArcimName=$P(Data(r,c),"^",7),phcfactor=$P(Data(r,c),"^",8)
           ..s l=$L(TimStr,"-")
           ..f i=1:1:l d
           ...s tim=$P(TimStr,"-",i)
           ...if tim'="" d
           ....s tmp(tim,n)="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^FreqCode|"_FreqCode_"^TimStr|"_tim_"^ArcimName|"_ArcimName_"^phcfactor|"_phcfactor
           ....s n=n+1 //s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^FreqCode|"_FreqCode_"^TimStr|"_tim_"^ArcimName|"_ArcimName_"^phcfactor|"_phcfactor
           ....//d OutPat
           s tim="" f  s tim=$O(tmp(tim),-1) q:tim=""  d
           .s bed=""  f  s bed=$O(tmp(tim,bed)) q:bed=""  d
           ..s aa=tmp(tim,bed)
           ..d OutPat3
	      }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPat3
    set Data=$lb(aa)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetNeedMeaserBP3Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNeedMeaserBP3Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod GetNeedMeaserBP3Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNeedMeaserBP3Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(%ResultSet).RunQuery("web.DHCNurNeedMeasureTempPat","GetNeedMeaserBP","111^2011-12-15^00:01^12:00")

Query GetNeedMeaserBP3(Parr As %String) As %Query(ROWSPEC = "aa") [ SqlProc ]
{
}

/// 根据测量次数算时间点
ClassMethod GetMeasureTime2(frw, stim, etim, Stat, RowID, typ = "2") As %String
{
  //w ##class(web.DHCNurNeedMeasureTempPat).GetMeasureTime(95,0,86340)
  q:$g(frw)="" ""  //ypz 061209
  ;i frw=149 b ;02
  s ftimstr=""
  s factor=$p($g(^PHCFR(frw)),"^",2)
  q:factor="" ""
  ;b ;04
  q:(factor>2)&(typ="2") ""
  q:(factor'>2)&(typ="3") ""
  if (factor>2)&(Stat="D") q ""
  if factor>2 q "not"
  ;b ;05
  s chl=0  f  s chl=$o(^OTimStr("BP",factor,chl))  q:chl=""  d
  .;b ;06
  .s timeStr=$g(^OTimStr("BP",factor,chl))
  .s tm=$ZT(timeStr,2)
  .if (timeStr'<stim)&(timeStr'>etim) d
  ..i ftimstr="" d
  ...s ftimstr=tm
  ..e  s ftimstr=ftimstr_" - "_tm
  ;b ;07
  s eflag="false"
  if (Stat="D")
  {
     s ord=$P(RowID,"||"),ordSub=$P(RowID,"||",2)
     s echl="0"  f  s echl=$O(^OEORD(ord,"I",ordSub,"X",echl)) q:echl=""  d
     .s eflag=##class(Nur.Android.Common).getexeflag(RowID_"||"_echl)
     .s eflag(echl)=eflag
      s ret=""
      s i=1
      s chl=""  f  s chl=$O(eflag(chl)) q:chl=""  d
      .if (eflag(chl)="true") d
      ..if (ret="") s ret=$P(ftimstr,"-",i)
      ..e  s ret=ret_"-"_$P(ftimstr,"-",i)
      .s i=i+1
      s ftimstr=ret 
  }
  q $g(ftimstr)
}

// d ##class(%ResultSet).RunQuery("web.DHCThreeNew","MeaserWeightHeightPats","197^272^2017-08-18^14:00:00^^^Y")

/// 需测身高体重查询
/// d ##class(%ResultSet).RunQuery("web.DHCNurNeedMeasureTempPat","MeaserWeightHeightPats","44^2017-09-05^14:00:00^N")
ClassMethod MeaserWeightHeightPatsExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	    // n (Ward,RegNo)
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      //s ^tempSC(8181)=Parr
 	      s Ward=$p(Parr,"^")
 	      s StrDate=$p(Parr,"^",2)
 	      s StrTime=$p(Parr,"^",3)
 	      s BabyFlag=$p(Parr,"^",4)
 	      //s Ward=##class(web.DHCThreeNew).getlocward(Ward) 	     
	      if (Ward'="")
	      {
	       s room="" 
	       f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus="D"
	       ..s pinfo=##class(web.DHCThreeNew).Patinfo(RowId)
	       ..q:pinfo=""
     	   ..s Name=$P(pinfo,"#",2)          
           ..s left=$P(pinfo,"#",5)
           ..s top=$P(pinfo,"#",6)
           ..s Adm=RowId
           ..s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ..q:(MotherAdm="")&(BabyFlag="1")
    	   ..q:(MotherAdm'="")&(BabyFlag'="1")
    	   ..s BedDr=$p($g(^PAADM(Adm)),"^",73) ;$P(pinfo,"#",3)    	   
	       ..q:BedDr=""
    	   ..s bedchl=$P(BedDr,"||",2)
	       ..s WardDr=$P(BedDr,"||",1)
	       ..s Bed=$P($g(^PAWARD(WardDr,"BED",bedchl)),"^",1)
           ..s PatRegNo=$P(pinfo,"#",7)
           ..s EncryptLevel=$P(pinfo,"#",8)
           ..s PatLevel=$P(pinfo,"#",9)
           ..s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo_"^"_EncryptLevel_"^"_PatLevel
       	   ..//s ^DataQ(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	      
      	   s r="" f  s r=$O(Data(r)) q:r=""  d
           .s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ..s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ..s EncryptLevel=$P(Data(r,c),"^",5),PatLevel=$P(Data(r,c),"^",6)
           ..s AdmDateVal=+($P(^PAADM(Adm),"^",6))
           ..s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDateVal)
           ..s curDate=##class(websys.Conversions).DateHtmlToLogical(StrDate)
           ..s dishDate=+##class(web.DHCDischargeHistory).GetDischargeDateTime(Adm)
           ..q:((dishDate'=0)&&(curDate>dishDate))
           ..s condition = (((curDate-AdmDateVal)+1)#7)
           ..q:condition'=1
           ..s aa=##class(web.DHCThreeNew).getobjval(Adm,StrDate,StrTime)
	       ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^EncryptLevel|"_EncryptLevel_"^PatLevel|"_PatLevel_"^AdmDate|"_AdmDate_"^"_aa
           ..d OutPat

	      }	        
		  
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	
findAdmTransWard(PAAdm,WardID)
	s find=0
	s child=0 f {
		s child=$O(^PAADM(PAAdm,"TRANS",child))
		Q:child=""
		s TransWardID=$P(^PAADM(PAAdm,"TRANS",child),"^",9)
		if TransWardID=WardID {
			s find=1
			Quit
		}
	}
	Q find
}

ClassMethod MeaserWeightHeightPatsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MeaserWeightHeightPatsExecute ]
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

ClassMethod MeaserWeightHeightPatsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MeaserWeightHeightPatsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query MeaserWeightHeightPats(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

}
