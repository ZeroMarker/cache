Import SQLUser

Class web.DHCCRM.ReviewRemindSend Extends %RegisteredObject
{

//"0^20^^2010-02-08^^false^false^false^false^^^false"

// .w ##class(web.DHCCRM.ReviewRemindSend).GetPersonList("0","20","","2010-02-08","","false","false","false","false","","","")

ClassMethod GetPersonList(start, limit, CTLocRowID, DateFrom, DateTo, Out, InHospital, Emergency, PE, PatRegNo, PatName, SendFlag)
{
     
    s ^zl("mess")=start_"^"_limit_"^"_CTLocRowID_"^"_ DateFrom_"^"_ DateTo_"^"_Out_"^"_ InHospital_"^"_ Emergency_"^"_ PE_"^"_ PatRegNo_"^"_ PatName_"^"_ SendFlag
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.ReviewRemindSend:FindPersonInfo") 
    d rs.Execute(start,limit,CTLocRowID, DateFrom, DateTo, Out, InHospital, Emergency, PE, PatRegNo, PatName, SendFlag)
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	s PatRegNo=rs.Get("PatRegNo")
	 	s PatName=rs.Get("PatName")
	 	s PAPERTelH=rs.Get("PAPERTelH")
	 	s MobileSend=rs.Get("MobileSend")
	 	s EmailSend=rs.Get("EmailSend")
	 	s PAADMAdmDate=rs.Get("PAADMAdmDate")
	 	s CTDsec=rs.Get("CTDsec")
	 	s PAADMRowID=rs.Get("PAADMRowID")
	 	s PAADMType=rs.Get("PAADMType")
	 	s PatSex=rs.Get("PatSex")
	 	s PatAge=rs.Get("PatAge")
	 	i PatName="刘丽莉"  s PAPERTelH="13574623556"
	 	i PatName="胡测试"  s PAPERTelH="13774623556"
		i (mess'="") s mess=mess_","
		s mess=mess_"{""PatRegNo"":"_""""_PatRegNo_""""
		s mess=mess_","_"""PatName"":"_""""_PatName_""""
		s mess=mess_","_"""PAPERTelH"":"_""""_PAPERTelH_""""
	    s mess=mess_","_"""MobileSend"":"_""""_MobileSend_""""
		s mess=mess_","_"""EmailSend"":"_""""_EmailSend_""""
		s mess=mess_","_"""PAADMAdmDate"":"_""""_PAADMAdmDate_""""
		s mess=mess_","_"""CTDsec"":"_""""_CTDsec_""""
		s mess=mess_","_"""PAADMRowID"":"_""""_PAADMRowID_""""
		s mess=mess_","_"""PAADMType"":"_""""_PAADMType_""""
		s mess=mess_","_"""PatSex"":"_""""_PatSex_""""
		s mess=mess_","_"""PatAge"":"_""""_PatAge_""""
		s mess=mess_"}"
	}	 
	s ^zl("mess",1)=mess
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

//PatRegNo,PAPMIName,PAPERTelH,CTDsec,SMSSend,EmailSend

Query FindPersonInfo(start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", Out As %String = "", InHospital As %String = "", Emergency As %String = "", PE As %String = "", PatRegNo As %String = "", PatRegName As %String = "", SendFlag As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,PAPERTelH:%String,CTDsec:%String,MobileSend:%String,EmailSend:%String,PAADMAdmDate:%String,PAADMRowID:%String,PAADMType:%String,PatSex:%String,PatAge:%String")
{
}

ClassMethod FindPersonInfoExecute(ByRef qHandle As %Binary, start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", Out As %String = "", InHospital As %String = "", Emergency As %String = "", PE As %String = "", PatRegNo As %String = "", PatRegName As %String = "", SendFlag As %String = "") As %Status
{
    s ^zl("FindPersonInfo")=SendFlag
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    i DateFrom'="" s DateFrom=$zdh(DateFrom,3)
	i DateTo'="" s DateTo=$zdh(DateTo,3)
	s ResultStr="",PAPERTelH="",PAPMIName="",PAPMISex="",PAPMIAge=""
	i PatRegNo'=""  d
	.s PatRegNo=..RegNoMask(PatRegNo)
	.s PAPMIRowId=0
	.s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PatRegNo,0))
	.q:PAPMIRowId=""
	.s PAPMIDeceased=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",12)
    .q:PAPMIDeceased="Y"
	.s PAPMIName=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	.S PAPERTelH=$P($g(^PAPER(PAPMIRowId,"PER",4)),"^",21)  //移动号码
    .i PAPERTelH=""  S PAPERTelH=$P($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)  //电话
    .s PAPMISexDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)
    .i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    .s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIRowId,"ALL")),"^",6),+$h)
	.s PAPMIAge=$P(Age,"Y",1)
    .s PAADMType=0
    .f  s PAADMType=$o(^PAPERdr(PAPMIRowId,"ADM",PAADMType))   q:PAADMType=""   d
    ..s StutasStr=Out_"^"_InHospital_"^"_PE_"^"_Emergency
    ..//s ^zl("PAADMType",PAPMIRowId)=PAADMType
    ..q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    ..q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    ..q:((StutasStr["true")&&(PE="false")&&(PAADMType="H")) 
    ..q:((StutasStr["true")&&(Emergency="false")&&(PAADMType="E")) 
    ..s PAADMRowID=0
    ..f  s PAADMRowID=$o(^PAPERdr(PAPMIRowId,"ADM",PAADMType,PAADMRowID))  q:PAADMRowID=""  d
    ...s EmailSend="",SMSSend=""
    ...q:((SendFlag="true")&&($o(^DHCCRMCBS(0,"PAADM",PAADMRowID,0))="" )) 
    ...s CBSSendStatusStr=""
    ...s CBSRowId=0
    ...f  s CBSRowId=$o(^DHCCRMCBS(0,"PAADM",PAADMRowID,CBSRowId))  q:CBSRowId=""  d
    ....s CBSSendStatus=$p(^DHCCRMCBS(CBSRowId),"^",4)
    ....s CBSSendMode=$p(^DHCCRMCBS(CBSRowId),"^",5)
    ....i (CBSSendMode="SMS")&&(CBSSendStatus="S")  s SMSSend="Y"
    ....i CBSSendStatusStr=""  S CBSSendStatusStr=CBSSendStatus
    ....else  s CBSSendStatusStr=CBSSendStatusStr_"^"_CBSSendStatus
    ...q:((SendFlag="false")&&(CBSSendStatusStr["S"))
    ...q:((SendFlag="true")&&(CBSSendStatusStr'["S")) 
    ...s CTDsec=""
    ...s DepCodeDR=$p(^PAADM(PAADMRowID),"^",4)
    ...q:(CTLocRowID'="")&&(CTLocRowID'=DepCodeDR)
    ...i DepCodeDR'=""  s CTDsec=$p($g(^CTLOC(DepCodeDR)),"^",2)
    ...s PAADMAdmDate=$p(^PAADM(PAADMRowID),"^",6)
    ...q:(((DateFrom'="")&&(DateFrom>PAADMAdmDate))||((DateTo'="")&&(DateTo<PAADMAdmDate)))
    ...i PAADMAdmDate'=""  s PAADMAdmDate=$zd(PAADMAdmDate,3)
    ...d OutputRow
    
    i (PatRegNo="")&&(PatRegName="")  d
    .i DateFrom=""  s DateFrom=+$h-365
    .i DateTo=""  s DateTo=+$h
    .s Date=DateFrom-1
    .f  s Date=$o(^PAADMi("PAADM_AdmDate",Date))  q:(Date="")||(Date>DateTo)   d
    ..s PAADMRowID=0
    ..f  s PAADMRowID=$o(^PAADMi("PAADM_AdmDate",Date,PAADMRowID))  q:PAADMRowID=""  d
	...s EmailSend="",SMSSend=""
	...s PAPMIDR=$p($g(^PAADM(PAADMRowID)),"^",1)
	...q:PAPMIDR=""
	...s PAPMIDeceased=$p($g(^PAPER(PAPMIDR,"ALL")),"^",12)
    ...q:PAPMIDeceased="Y"
    ...//s ^zl("PAADMType",PAADMRowID)=($o(^DHCCRMCBS(0,"PAADM",PAADMRowID,0)))_"^"_SendFlag
	...q:((SendFlag="true")&&($o(^DHCCRMCBS(0,"PAADM",PAADMRowID,0))="" )) 
    ...s CBSSendStatusStr=""
    ...s CBSRowId=0
    ...f  s CBSRowId=$o(^DHCCRMCBS(0,"PAADM",PAADMRowID,CBSRowId))  q:CBSRowId=""  d
    ....s CBSSendStatus=$p(^DHCCRMCBS(CBSRowId),"^",4)
    ....s CBSSendMode=$p(^DHCCRMCBS(CBSRowId),"^",5)
    ....i (CBSSendMode="SMS")&&(CBSSendStatus="S")  s SMSSend="Y"
    ....i CBSSendStatusStr=""  S CBSSendStatusStr=CBSSendStatus
    ....else  s CBSSendStatusStr=CBSSendStatusStr_"^"_CBSSendStatus
    ...q:((SendFlag="false")&&(CBSSendStatusStr["S"))
    ...q:((SendFlag="true")&&(CBSSendStatusStr'["S")) 
	...S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",4)),"^",21)  //移动号码
    ...i PAPERTelH=""  S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",1)),"^",11)  //电话
    ...s PAPMISexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
    ...i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    ...s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIDR,"ALL")),"^",6),+$h)
	...s PAPMIAge=$P(Age,"Y",1)
    ...s PatRegNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
    ...s PAPMIName=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
    ...s PAADMType=$p($g(^PAADM(PAADMRowID)),"^",2)
    ...s StutasStr=Out_"^"_InHospital_"^"_PE_"^"_Emergency
    ...q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    ...q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    ...q:((StutasStr["true")&&(PE="false")&&(PAADMType="H")) 
    ...q:((StutasStr["true")&&(Emergency="false")&&(PAADMType="E")) 
    ...s CTDsec=""
    ...s DepCodeDR=$p(^PAADM(PAADMRowID),"^",4)
    ...q:(CTLocRowID'="")&&(CTLocRowID'=DepCodeDR)
    ...i DepCodeDR'=""  s CTDsec=$p($g(^CTLOC(DepCodeDR)),"^",2)
    ...s PAADMAdmDate=$zd(Date,3)
    ...d OutputRow
    
    i (PatRegNo="")&&(PatRegName'="")  d
    .s PAPMIName=$o(^PAPERi("PAPER_PatName",PatRegName),-1)
	.f  s PAPMIName=$o(^PAPERi("PAPER_PatName",PAPMIName)) q:(PAPMIName="")||(PAPMIName'[PatRegName)  d
    ..s PAPMIRowId=0
	..f  s PAPMIRowId=$o(^PAPERi("PAPER_PatName",PAPMIName,PAPMIRowId))  q:PAPMIRowId=""  d
	...s PAPMIDeceased=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",12)
    ...q:PAPMIDeceased="Y"
	...s EmailSend="",SMSSend=""
	...S PAPERTelH=$P(^PAPER(PAPMIRowId,"PER",4),"^",21)  //移动号码
    ...i PAPERTelH=""  S PAPERTelH=$P(^PAPER(PAPMIRowId,"PER",1),"^",11)  //电话
    ...s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIRowId,"ALL")),"^",6),+$h)
	...s PAPMIAge=$P(Age,"Y",1)
    ...s PAPMISexDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7)
    ...i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    ...s PatRegNo=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
    ...s PAADMType=0
    ...f  s PAADMType=$o(^PAPERdr(PAPMIRowId,"ADM",PAADMType))   q:PAADMType=""   d
    ....s StutasStr=Out_"^"_InHospital_"^"_PE_"^"_Emergency
    ....q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    ....q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    ....q:((StutasStr["true")&&(PE="false")&&(PAADMType="H")) 
    ....q:((StutasStr["true")&&(Emergency="false")&&(PAADMType="E")) 
    ....s PAADMRowID=0
    ....f  s PAADMRowID=$o(^PAPERdr(PAPMIRowId,"ADM",PAADMType,PAADMRowID))  q:PAADMRowID=""  d
    .....q:((SendFlag="true")&&($o(^DHCCRMCBS(0,"PAADM",PAADMRowID,0))="" )) 
    .....s CBSSendStatusStr=""
    .....s CBSRowId=0
    .....f  s CBSRowId=$o(^DHCCRMCBS(0,"PAADM",PAADMRowID,CBSRowId))  q:CBSRowId=""  d
    ......s CBSSendStatus=$p(^DHCCRMCBS(CBSRowId),"^",4)
    ......s CBSSendMode=$p(^DHCCRMCBS(CBSRowId),"^",5)
    ......i ((CBSSendMode="SMS")&&(CBSSendStatus="S"))  s SMSSend="Y"
    ......i CBSSendStatusStr=""  S CBSSendStatusStr=CBSSendStatus
    ......else  s CBSSendStatusStr=CBSSendStatusStr_"^"_CBSSendStatus 
    .....q:((SendFlag="false")&&(CBSSendStatusStr["S"))
    .....q:((SendFlag="true")&&(CBSSendStatusStr'["S")) 
    .....s CTDsec=""
    .....s DepCodeDR=$p(^PAADM(PAADMRowID),"^",4)
    .....q:(CTLocRowID'="")&&(CTLocRowID'=DepCodeDR)
    .....i DepCodeDR'=""  s CTDsec=$p($g(^CTLOC(DepCodeDR)),"^",2)
    .....s PAADMAdmDate=$p(^PAADM(PAADMRowID),"^",6)
    .....q:(((DateFrom'="")&&(DateFrom>PAADMAdmDate))||((DateTo'="")&&(DateTo<PAADMAdmDate)))
    .....i PAADMAdmDate'=""  s PAADMAdmDate=$zd(PAADMAdmDate,3)
    .....d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(PatRegNo,PAPMIName,PAPERTelH,CTDsec,SMSSend,EmailSend,PAADMAdmDate,PAADMRowID,PAADMType,PAPMISex,PAPMIAge)
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
	//s length=+$G(^DHCPESetting("DHCPE","RegNoLength"))
	s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
	i length=0 s length=8
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

ClassMethod SMSSend(PAADMDR, SendStatus, actiontype)
{
   
    s SendUserDR=%session.Get("LOGON.USERID")
    S SendDate=+$h,SendMode="SMS"
    s SendTime=$p($h,",",2)
    i actiontype'="SMSSend"  s SendMode="EMAIL"
	&sql(insert into DHC_CRM_CallbackSend
	     (CBS_PAADM_DR,CBS_SendDate,CBS_SendTime,CBS_SendStatus,CBS_SendMode,CBS_SendUser_DR)
	     values 
	     (:PAADMDR,:SendDate,:SendTime,:SendStatus,:SendMode,:SendUserDR)
	     )
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台插入失败!"_SQLCODE_"""}"
    q ""
}

}
