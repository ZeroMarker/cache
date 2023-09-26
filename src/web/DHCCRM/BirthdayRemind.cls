Import SQLUser

Class web.DHCCRM.BirthdayRemind Extends %RegisteredObject
{

//w ##class(web.DHCCRM.BirthdayRemind).GetPersonList("0","20","2010-05-01","","")

ClassMethod GetPersonList(start, limit, DateFrom, SendFlag)
{
    //DHCMRBase 病案首页表
    s ^zl("B",2)=DateFrom_"^"_start_"^"_limit_"^"_SendFlag
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.BirthdayRemind:FindPersonInfo") 
    d rs.Execute(start,limit,DateFrom,SendFlag)
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	//q:count>10
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	s PatRegNo=rs.Get("PatRegNo")
	 	s PatName=rs.Get("PatName")
	 	s PatTelH=rs.Get("PatTelH")
	 	s PatSex=rs.Get("PatSex")
	 	s PatAge=rs.Get("PatAge")
	 	s PatDob=rs.Get("PatDob")
	 	s Deceased=rs.Get("Deceased")
	 	s PAPMIRowId=rs.Get("PAPMIRowId")
	 	s MobileSend=rs.Get("MobileSend")
	 	i PatName="张小妹"  s PatTelH="13576478990"
		i (mess'="") s mess=mess_","
		s mess=mess_"{""PatRegNo"":"_""""_PatRegNo_""""
		s mess=mess_","_"""PatName"":"_""""_PatName_""""
		s mess=mess_","_"""PatTelH"":"_""""_PatTelH_""""
	    s mess=mess_","_"""PatSex"":"_""""_PatSex_""""
		s mess=mess_","_"""PatAge"":"_""""_PatAge_""""
		s mess=mess_","_"""PatDob"":"_""""_PatDob_""""
		s mess=mess_","_"""PAPMIRowId"":"_""""_PAPMIRowId_""""
		s mess=mess_","_"""Deceased"":"_""""_Deceased_""""
		s mess=mess_","_"""MobileSend"":"_""""_MobileSend_""""
		s mess=mess_"}"
	}	 
	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 

 	q mess
}

//如果勾上已发送，则用后台表里存的发送年份 跟当前年份比较 不相等就退出

//后台表需要字段 年份字段、发送者、发送日期、Paperson ID、发送方式、发送状态

//PatRegNo,PAPMIName,PAPERTelH,CTDsec,SMSSend,EmailSend

Query FindPersonInfo(start As %String = "", limit As %String = "", DateFrom As %String = "", SendFlag As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,PatTelH:%String,PatSex:%String,PatAge:%String,PatDob:%String,Deceased:%String,PAPMIRowId:%String,MobileSend:%String")
{
}

ClassMethod FindPersonInfoExecute(ByRef qHandle As %Binary, start As %String = "", limit As %String = "", DateFrom As %String = "", SendFlag As %String = "") As %Status
{
   // s ^zl("B",3)=DateFrom_"^"_DateTo_"^"_start_"^"_limit_"^"_SendFlag
    if (DateFrom=""){
	 	s DateFrom = $ZDATE($H) //获取当前日期  10/09/2015
	 	s month = $p(DateFrom,"/",1)
	 	s date = $p(DateFrom,"/",2)
	 	s year = $p(DateFrom,"/",3)
	 	s DateFrom = year_"-"_month_"-"_date
	 	s DateFrom=$zdh(DateFrom,3)
	 }else{
		s DateFrom=$zdh(DateFrom,3)  //转换成数值 
	 }
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s YearLength=150,EYear=$p($zd(+$h,3),"-",1)
	s SYear=EYear-YearLength
	;i DateFrom=""&&DateTo=""  s DateFrom=DateTo=+$h
	;i DateTo=""  s DateTo=DateFrom
    //s DateFrom=$zdh(DateFrom,3)  //转换成数值
    ;s DateFromBegin=$p($zd(DateFrom,3),"-",2,3)  //取月日
    ;s DateTo=$zdh(DateTo,3)
    ;s DateToEnd=$p($zd(DateTo,3),"-",1) //取年
    ;s DateFrom=DateToEnd_"-"_DateFromBegin  //使开始日期的年与结束日期的年相同
    ;s DateFrom=$zdh(DateFrom,3)
	s PatRegNo="",PatName="",PatTelH="",PatSex="",PatAge="",PatDob=""
	
	for Year=SYear:1:EYear  //从一百年前到今年
  {
     
   // for Date=DateFrom:1:DateTo  //选中的开始日期到结束日期
     
    //{  
       s DateNum=$ZD(DateFrom,3)
       s DateStr=$P(DateNum,"-",2,3)  //获取月日
       s CurrentDate=Year_"-"_DateStr
       S PatDob=CurrentDate
       //s ^zl("B",3,CurrentDate)=CurrentDate
       s CurrentDate=$zdh(CurrentDate,3)
       
       s PAPMIRowId=0
       for{ 
      
       s PAPMIRowId=$o(^PAPERi("DOB2",CurrentDate,PAPMIRowId))
       q:PAPMIRowId=""
     
      
  
      if ((SendFlag="true")&&($o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,0))="" ))
      {continue}
      
       if (SendFlag="true")&&(($o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,0))'="")&&(+$h-($o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,0)))>335))
       {continue}
       s SendStatusStr="",MobileSend=""
       S SendDate=0
       f  s SendDate=$o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,SendDate))  q:SendDate=""  d
       .q:+$h-SendDate>335
       .s SendTime=0
       .f  s SendTime=$o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,SendDate,SendTime))  q:SendTime=""  d
       ..s BSRowId=0
       ..f  s BSRowId=$o(^DHCCRMBS(0,"PAPMI",PAPMIRowId,SendDate,SendTime,BSRowId))  q:BSRowId=""  d
       ...s BSSendStatus=$p(^DHCCRMBS(BSRowId),"^",4)
       ...s BSSSendMode=$p(^DHCCRMBS(BSRowId),"^",5)
       ...i (BSSSendMode="SMS")&&(BSSendStatus="S")  s MobileSend="Y"
       ...i SendStatusStr=""  S SendStatusStr=BSSendStatus
       ...else  s SendStatusStr=SendStatusStr_"^"_BSSendStatus
       if ((SendFlag="false")&&(SendStatusStr["S")){continue}
       if ((SendFlag="true")&&(SendStatusStr'["S")) {continue}
       s Deceased=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",12) 
	   s PatRegNo=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	   s PatName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	   S PatTelH=$P($g(^PAPER(PAPMIRowId,"PER",4)),"^",21)  //移动号码
       i PatTelH=""  S PatTelH=$P($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)  //电话
       s SexDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)
       i SexDR'=""  S PatSex=$P($g(^CT("SEX",SexDR)),"^",2)
       s PatAge=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIRowId,"ALL")),"^",6),+$h)
	   s PatAge=$P(PatAge,"Y",1)
	   d OutputRow
	   }
	    //}

}
	
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(PatRegNo,PatName,PatTelH,PatSex,PatAge,PatDob,Deceased,PAPMIRowId,MobileSend)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindPersonInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonInfoExecute ]
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

ClassMethod FindPersonInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RegNoMask(RegNo)
{
	s length=+$G(^DHCPESetting("DHCPE","RegNoLength"))
	i length=0 s length=8
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

ClassMethod SMSSend(PAPMIRowId, SendStatus, actiontype)
{
    s ^zl("SMSSend")=PAPMIRowId_"^"_SendStatus
    s SendUserDR=%session.Get("LOGON.USERID")
    S SendDate=+$h,SendMode="SMS"
    s SendTime=$p($h,",",2)
    i actiontype'="SMSSend"  s SendMode="EMAIL"
 
	&sql(insert into DHC_CRM_BirthSend
	     (BS_PAPMI_DR,BS_SendDate,BS_SendTime,BS_SendStatus,BS_SendMode,BS_SendUser_DR)
	     values 
	     (:PAPMIRowId,:SendDate,:SendTime,:SendStatus,:SendMode,:SendUserDR)
	     )
	   
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台插入失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod CompareBirthday(Dob, SDate, EDate)
{
 s DobStr=""
 i Dob=""  q 0
 s Dob=$ZD(Dob,3)
 s DobStr=$P(Dob,"-",2,3)
 s Flag=0
 f Date=SDate:1:EDate
 {
 s DateStr=$ZD(Date,3)
 s DateStr=$P(DateStr,"-",2,3)
 i DateStr=DobStr s Flag=1
 //w !,DobStr_"!"_DateStr
 q:Flag=1
}
 q Flag
}

}
