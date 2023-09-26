Import SQLUser

Class web.DHCCRM.LisResultSend Extends %Persistent
{

//d ##calss(web.DHCCRM.LisResultSend).GetCTLocList("","")

ClassMethod GetCTLocList(start, limit, CTLocDesc)
{
   
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.LisResultSend:SearchCTLoc")
	d rs.Execute(CTLocDesc)
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s RowId=rs.Get("CTLOC_RowId")
	 	s Code=rs.Get("CTLOC_Code")
	 	s Desc=rs.Get("CTLOC_Desc")
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""CTLocRowID"":"_""""_RowId_""""
		s mess=mess_","_"""CTLocCode"":"_""""_Code_""""
		s mess=mess_","_"""CTLocName"":"_""""_Desc_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

//d ##class(%ResultSet).RunQuery("web.DHCCRM.LisResultSend","SearchCTLoc")

/*
Query SearchCTLoc(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
	select CTLOC_Code, CTLOC_Desc, CTLOC_RowId
	from CT_loc where CTLOC_Desc %STARTSWITH :Desc
}*/

//d ##class(%ResultSet).RunQuery("web.DHCCRM.LisResultSend","SearchCTLoc","tx")

Query SearchCTLoc(Desc As %String = "") As %Query(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
}

ClassMethod SearchCTLocExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i Desc'=""  s Desc=$ZCVT(Desc,"U")
	s CTRowID=0
	f  s CTRowID=$o(^CTLOC(CTRowID))  q:CTRowID=""  d
	.s CTLOCDesc=$p($g(^CTLOC(CTRowID)),"^",2)
	.s CTLOCDesc=$ZCVT(CTLOCDesc,"U")
	.s CTLOCDesc=..Replace(CTLOCDesc, $C(13), "")
	.s CTLOCDesc=..Replace(CTLOCDesc, $C(9), "")
	.s CTLOCDesc=..Replace(CTLOCDesc, $C(10), "")
	.s CTLOCCode=$p($g(^CTLOC(CTRowID)),"^",1)
	.s CTLOCCode=..Replace(CTLOCCode, $C(13), "")
	.s CTLOCCode=..Replace(CTLOCCode, $C(9), "")
	.s CTLOCCode=..Replace(CTLOCCode, $C(10), "")
	.q:(Desc'="")&&(CTLOCDesc'[Desc)
    .d OutputRow

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(CTLOCCode,CTLOCDesc,CTRowID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCTLocExecute ]
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

ClassMethod SearchCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// .w ##class(web.DHCCRM.LisResultSend).GetPersonList("","","","2010-02-14","2010-03-14","","","")

ClassMethod GetPersonList(start, limit, CTLocRowID, DateFrom, DateTo, SendFlag, PatRegNo, PatName, Out, InHospital, PE)
{
     //                 "^     ^         ^2010-02-28         ^^false"
   // s ^zl("FindList",1)=start_"^"_limit_"^"_CTLocRowID_"^"_DateFrom_"^"_DateTo_"^"_SendFlag_"^"_PatRegNo_"^"_PatName
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.LisResultSend:GetLisResult") 
    d rs.Execute(start,limit,CTLocRowID,DateFrom,DateTo,SendFlag,PatRegNo,PatName,Out,InHospital,PE)
 	s count=0
 	s mess=""
 	s topnum=start+limit
 	
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s RegNo=rs.Get("PatRegNo")
	 	s Name=rs.Get("PatName")
	 	s ARCItemDesc=rs.Get("ARCItemDesc")
	 	s MobileSend=rs.Get("MobileSend")
	 	s EmailSend=rs.Get("EmailSend")
	 	s OEORItemID=rs.Get("OEORItemID")
	 	s MobilePhone=rs.Get("MobilePhone")
	 	s PAPMISex=rs.Get("PAPMISex")
	 	s PAPMIAge=rs.Get("PAPMIAge")
	 	s CTDsec=rs.Get("CTDsec")
	 	i Name="体检测试"  s MobilePhone="13574623556"
	 	i Name="测试"  s MobilePhone="13774623556"
		i (mess'="") s mess=mess_","
		s mess=mess_"{""PatRegNo"":"_""""_RegNo_""""
		s mess=mess_","_"""PatName"":"_""""_Name_""""
		s mess=mess_","_"""ARCItemDesc"":"_""""_ARCItemDesc_""""
	    s mess=mess_","_"""MobileSend"":"_""""_MobileSend_""""
		s mess=mess_","_"""EmailSend"":"_""""_EmailSend_""""
		s mess=mess_","_"""OEORItemID"":"_""""_OEORItemID_""""
		s mess=mess_","_"""MobilePhone"":"_""""_MobilePhone_""""
		s mess=mess_","_"""PAPMISex"":"_""""_PAPMISex_""""
		s mess=mess_","_"""PAPMIAge"":"_""""_PAPMIAge_""""
		s mess=mess_","_"""CTDsec"":"_""""_CTDsec_""""
		s mess=mess_"}"
	}	 
	
    //w !,"count:"_count
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

Query GetLisResult(start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", SendFlag As %String = "", PatRegNo As %String = "", PatName As %String = "", Out As %String = "", InHospital As %String = "", PE As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,ARCItemDesc:%String,MobileSend:%String,EmailSend:%String,OEORItemID:%String,MobilePhone:%String,PAPMISex:%String,PAPMIAge:%String,CTDsec:%String")
{
}

ClassMethod GetLisResultExecute(ByRef qHandle As %Binary, start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", SendFlag As %String = "", PatRegNo As %String = "", PatName As %String = "", Out As %String = "", InHospital As %String = "", PE As %String = "") As %Status
{
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s namespaceLab=^DHCCRMSetting("NAMESPACE","LABDATA")
	s ResultStr="",MobilePhone="",Name="",RegNo="",ARCIMDesc=""
	i DateFrom'=""  s DateFrom=$zdh(DateFrom,3)
	else  s DateFrom=+$h-365
	i DateTo'="" s DateTo=$zdh(DateTo,3)
	else  s DateTo=+$h
	s Date=DateFrom-1
	f  s Date=$o(^[namespaceLab]TEPIi("AUTHORISED",Date))  q:(Date="")||(Date>DateTo)  d
	.s VisitNumber=0
	.f  s VisitNumber=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber))  q:VisitNumber=""  d
	..//w !,VisitNumber
	..s TestSetDR=0
	..f  s TestSetDR=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber,TestSetDR))  q:TestSetDR=""  d
	...s Counter=0
	...f  s Counter=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber,TestSetDR,Counter))  q:Counter=""  d
    ....s MobileSend="",EmailSend=""
    ....s OEORDRowId=0
    ....f  s OEORDRowId=$o(^OEORD(0,"EpisNo",VisitNumber,OEORDRowId))  q:OEORDRowId=""  d
    .....s PAADM=$p($G(^OEORD(OEORDRowId)),"^",1)
    .....q:PAADM=""
    .....S PAADMType=$P($G(^PAADM(PAADM)),"^",2)
    .....s StutasStr=Out_"^"_InHospital_"^"_PE
    .....q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    .....q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    .....q:((StutasStr["true")&&(PE="false")&&(PAADMType="H"))  
    .....s DepLoc=$P($G(^PAADM(PAADM)),"^",4)
    .....q:(CTLocRowID'="")&&(DepLoc'=CTLocRowID)
    .....i DepLoc'=""  s CTDsec=$p($g(^CTLOC(DepLoc)),"^",2)
    .....s PAPMIDR=$P($G(^PAADM(PAADM)),"^",1) // PAADM_PAPMI_D//R
    .....q:PAPMIDR=""
    .....s PAPMIDeceased=$p(^PAPER(PAPMIDR,"ALL"),"^",12)
    .....q:PAPMIDeceased="Y"
    .....s Name=""
    .....s Name=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
    .....q:(PatName'="")&&(Name'[PatName)
    .....s RegNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
    .....s RegNo=+RegNo
    .....q:(PatRegNo'="")&&(PatRegNo'=RegNo)
    .....S MobilePhone=$P(^PAPER(PAPMIDR,"PER",4),"^",21)  //移动号码
    .....i MobilePhone=""  S MobilePhone=$P(^PAPER(PAPMIDR,"PER",1),"^",11)  //电话
    .....s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIDR,"ALL")),"^",6),+$h)
	.....s PAPMIAge=$P(Age,"Y",1)
    .....s PAPMISexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
    .....i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    .....s OEORIChildsub=0
    .....s OEORIChildsub=$o(^OEORDi(0,"LabTS",OEORDRowId,VisitNumber_"||"_TestSetDR_"||"_Counter,0))
    .....q:OEORIChildsub=""
    .....s OEORItemID=OEORDRowId_"||"_OEORIChildsub
    .....q:((SendFlag="true")&&($o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,0))="" )) 
    .....s LRSSendStatusStr=""
    .....s LRSRowId=0
    .....f  s LRSRowId=$o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,LRSRowId))  q:LRSRowId=""  d
    ......s LRSSendStatus=$p(^DHCCRMLRS(LRSRowId),"^",4)
    ......s LRSSendMode=$p(^DHCCRMLRS(LRSRowId),"^",5)
    ......i (LRSSendMode="SMS")&&(LRSSendStatus="S")  s MobileSend="Y"
    ......i LRSSendStatusStr=""  S LRSSendStatusStr=LRSSendStatus
    ......else  s LRSSendStatusStr=LRSSendStatusStr_"^"_LRSSendStatus
    .....q:((SendFlag="false")&&(LRSSendStatusStr["S"))
    .....q:((SendFlag="true")&&(LRSSendStatusStr'["S"))
    .....s ItmMastDR=""
    .....s ItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .....q:ItmMastDR=""
    .....s ARCIMSubscript=$P(ItmMastDR,"||",1)
	.....s ARCIMVersion=$P(ItmMastDR,"||",2)
	.....s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
	.....S ^DHCCRM("LisResultSend",OEORItemID)=VisitNumber_"||"_TestSetDR_"||"_Counter_"$"_PAPMIDR  //_"$"_PAADM
    .....d OutputRow1

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(RegNo,Name,ARCIMDesc,MobileSend,EmailSend,OEORItemID,MobilePhone,PAPMISex,PAPMIAge,CTDsec)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetLisResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLisResultExecute ]
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

ClassMethod GetLisResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLisResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod trans(tc, ret)
{
   s itmtype=$p($g(^TTAB("TC",tc)),"\",3)
   //b //1
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=..CheckResDecimal(ret,decimal)
   .s ret=temres_$c(1)_temres
   .//b //2
   .;标准备注
   e  i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   .;血型
   e  i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   .;bug
   e  i itmtype="V" d
   .i $l(ret),$d(^TTAB("BUG",ret)) d
   ..s preres=$p(^TTAB("BUG",ret),"\",1)
   ..s ret=ret_$c(1)_preres
   e  d
   .s ret=ret_$c(1)_ret
   q ret
}

ClassMethod CheckResDecimal(res, dec)
{
	//n (res,dec)
	s res=$g(res),dec=+$g(dec)
	s ret=""
	i res="" q ret
	i dec="" q ret
	s flag=""
	i ($e(res)="<")!($e(res)=">") s flag=$e(res),res=$tr(res,"<>")
	s res=+res
	s ret=$fn(res,"",dec)
	q flag_ret
}

//d ##class(web.DHCCRM.LisResultSend).GetNormalStr("M1072","M")

ClassMethod GetNormalStr(CTTCCode, sex)
{
    q:CTTCCode="" ""
    s NormalRange=""
    //S Version=^DHCPESetting("DHCPE","TrakVerison")
   // s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    S Version=$g(^DHCCRMSetting("DHCCRM","TrakVerison"))
    s namespaceLab=$g(^DHCCRMSetting("NAMESPACE","LABDATA"))
    s CurSpace=$ZNSpace
    Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	ZN namespaceLab
	If ((ResultFormat="X")!(ResultFormat="S")) Do
	.Set CTTCTCode=""
	.Set NormalStr=""
	.For  Set CTTCTCode=$o(^TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:(CTTCTCode="")!(NormalStr'="")  Do
	..//Quit:($p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",22)'=sex)
	..Set IsNormal=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	..Set Format=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	..If IsNormal="N" Set NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
	..If Format="Y" Set NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
	.If NormalStr="" Do
	..If Version="MedTrak" Do
	...Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","")
	..Else  Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","","","","")
	..Set NormalStr=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
	If $e(ResultFormat,1)="N" Do
	.If Version="MedTrak" Do
	..Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","")
	.Else  Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","","","","")
	.Set NormalRange=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
	ZN CurSpace
	q NormalRange
}

//S1069  43.0(0.0-10.0) 2.09(1.50-2.50)

//d ##class(web.DHCCRM.LisResultSend).GetNormalFlag("2.09","S1126","1.50-2.50")

ClassMethod GetNormalFlag(Result, CTTCCode, NormalStr)
{
   
    q:CTTCCode="" ""
    S Normal=0
    //S Version=^DHCPESetting("DHCPE","TrakVerison")
    //s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    S Version=$g(^DHCCRMSetting("DHCCRM","TrakVerison"))
    s namespaceLab=$g(^DHCCRMSetting("NAMESPACE","LABDATA"))
    s CurSpace=$ZNSpace
    Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	If ResultFormat="X" Do
	.If NormalStr=Result Set Normal=1
	.If $o(^TTAB("TC",CTTCCode,4,""))'="" Do
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (Result>=Min)&&(Result<=Max) Set Normal=1
	.if (Result)="-" Set Normal=1
	If $e(ResultFormat,1)="N" Do
	.i NormalStr["<" d
	..s NormalStr=$p(NormalStr,"<",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(Result<=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(Result<NormalStr) Normal=1
	.e  i NormalStr[">" d
	..s NormalStr=$p(NormalStr,">",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(Result>=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(Result>NormalStr) Normal=1
	.e  d
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (Result>=Min)&&(Result<=Max) Set Normal=1
	If ResultFormat="S" Do
	.Set CTTCTCode=""
	.Set ResultDesc=""
	.Set NotNormal=""
	.For  Set CTTCTCode=$o(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:((CTTCTCode="")||(Normal=1))  Do
	..Set NotNormal=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	..Set Format=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	..Set ResultDesc=^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode,1)
	..If (ResultDesc=Result)&(NotNormal="A") Set Normal=0
	..If ((ResultDesc=Result)&(NotNormal'="A")) Set Normal=1
  q Normal
}

ClassMethod SMSSend(OEORDItemID, SendStatus, actiontype)
{
    s SendUserDR=%session.Get("LOGON.USERID")
    S SendDate=+$h,SendMode="SMS"
    s SendTime=$p($h,",",2)
    i actiontype'="SMSSend"  s SendMode="EMAIL"
	&sql(insert into DHC_CRM_LabResultSend
	     (LRS_OEORI_DR,LRS_SendDate,LRS_SendTime,LRS_SendStatus,LRS_SendMode,LRS_SendUser_DR)
	     values 
	     (:OEORDItemID,:SendDate,:SendTime,:SendStatus,:SendMode,:SendUserDR)
	     )
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台插入失败!"_SQLCODE_"""}"
    q ""
}

//133||101

//d ##class(web.DHCCRM.LisResultSend).GetResultList("133||101")

ClassMethod GetResultList(OEORDITEM)
{
   
	s ^zl("2010",2)=OEORDITEM 
	s rs=##class(%ResultSet).%New("web.DHCCRM.LisResultSend:SearchResultList")
	d rs.Execute(OEORDITEM)
 	s count=0
 	s mess=""
	while (rs.Next())
 	{
	 	s count=count+1
	 	
	 	s ResultStr=rs.Get("ResultStr")
	 	s ARCIMDesc=rs.Get("ARCIMDesc")
	 	s mySex=rs.Get("mySex")
	 	s Name=rs.Get("Name")  //:%String,mySex:%String,Name:%String
	 	s OEORDItem=rs.Get("OEORDItem")
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ResultStr"":"_""""_ResultStr_""""
        s mess=mess_","_"""ARCIMDesc"":"_""""_ARCIMDesc_""""
		s mess=mess_","_"""mySex"":"_""""_mySex_""""
	    s mess=mess_","_"""Name"":"_""""_Name_""""
		s mess=mess_","_"""OEORDItem"":"_""""_OEORDItem_""""
		s mess=mess_"}"

	}	 
 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	s ^zl("GetResultList",1)=mess
 	q mess
}

//d ##class(%ResultSet).RunQuery("web.DHCCRM.LisResultSend","SearchCTLoc","tx")

Query SearchResultList(OEORDItem As %String = "") As %Query(ROWSPEC = "ResultStr:%String,ARCIMDesc:%String,mySex:%String,Name:%String,OEORDItem:%String")
{
}

ClassMethod SearchResultListExecute(ByRef qHandle As %Binary, OEORDItem As %String = "") As %Status
{
   
    q:OEORDItem="" ""
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PAPERTelH="",AllSendFlag="N"
	s HospitalName=$g(^DHCCRMSetting("DHCCRM","HospitalName"))  
    s namespaceLab=$g(^DHCCRMSetting("NAMESPACE","LABDATA"))
    //s ^zl("2010",4)=HospitalName_"^"_ namespaceLab_"^"_$g(^DHCCRM("LisResultSend",OEORDItem)) 
	s Str=$g(^DHCCRM("LisResultSend",OEORDItem))     //=VisitNumber_"||"_TestSetDR_"||"_Counter
	// s ^zl("2010",5)=Str 
	s ItmMastDR=""
    s ItmMastDR=$p($g(^OEORD($p(OEORDItem,"||",1),"I",$p(OEORDItem,"||",2),1)),"^",2)
    q:ItmMastDR=""
    //s ^zl("2010","5-1")=ItmMastDR
    S AERowID=$o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ItmMastDR,0))
    i AERowID'=""  s AllSendFlag=$p($G(^DHCCRMARCIMEx(AERowID)),"^",3)  //判断是否全发
    s ARCIMSubscript=$P(ItmMastDR,"||",1)
	s ARCIMVersion=$P(ItmMastDR,"||",2)
	s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
	s PAPMIDR=$p(Str,"$",2)
    //s ^zl("2010","5-2")=PAPMIDR
	q:PAPMIDR="" ""
	s Name=""
    s Name=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	s PAPMISexDR=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
    S PAPMISex="" , mySex="M"
    i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    i PAPMISex="女"  s mySex="F"
    S PAPERTelH=$P(^PAPER(PAPMIDR,"PER",4),"^",21)  //移动号码
    i PAPERTelH=""  S PAPERTelH=$P(^PAPER(PAPMIDR,"PER",1),"^",11)  //电话
	s LabData=$p(Str,"$",1)
	s VisitNumber=$p(LabData,"||",1)
	s TestSetDR=$p(LabData,"||",2)
	s Counter=$p(LabData,"||",3)
	s ResultStr="",CTTCDesc="",Units="",labResult="",NormalStr=""
    s TestCodeDR=0
    f  s TestCodeDR=$o(^TEPI(VisitNumber,1,TestSetDR, Counter,"DATA",TestCodeDR))  q:TestCodeDR=""  d
    .s CTTCDesc=$p(^TTAB("TC",TestCodeDR),"\",1)
    .s Units=$p(^TTAB("TC",TestCodeDR),"\",2)
    .s TestData=$p(^TEPI(VisitNumber,1,TestSetDR, Counter,"DATA",TestCodeDR),"\",1)
    .s labResult=$p(..trans(TestCodeDR,TestData),$c(1),2)
    .s NormalStr=..GetNormalStr(TestCodeDR,mySex)
    .s IsNormal=..GetNormalFlag(labResult,TestCodeDR,NormalStr)
    .If $g(labResult)'="" Do
	..s CurSpace=$ZNSpace
	..zn namespaceLab
	..//125129^K0010^A型Rh阳性^61062
	..//d TestItmRes^CHDhcLabReport("125129","K0010","A型Rh阳性","61062")
	..s LabResultStr=$$TestItmRes^CHDhcLabReport(VisitNumber,TestCodeDR,labResult,61062)
	..zn CurSpace
	..Set flag=$p(LabResultStr,$c(2),11)
	..If (flag'="")&(flag'="N") Set IsNormal="0"
	.Q:(AllSendFlag'="Y")&&(IsNormal=1)    //当设置为不是全发 则正常退出
	.i NormalStr'="" s labResult=CTTCDesc_":"_labResult_"("_NormalStr_")"
	.else  s labResult=CTTCDesc_":"_labResult
    .i ResultStr=""  s ResultStr=labResult
    .else  s ResultStr=ResultStr_"   "_labResult
    s ResultStr=ResultStr_"   "_HospitalName
    d Output

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Output
	set Data=$lb(ResultStr,ARCIMDesc,mySex,Name,OEORDItem)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchResultListExecute ]
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

ClassMethod SearchResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Replace(Strings, Str, Rep) As %String
{
	q $TR(Strings, Str, Rep)
}

Storage Default
{
<Data name="LisResultSendDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.LisResultSendD</DataLocation>
<DefaultData>LisResultSendDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCRM.LisResultSendD</IdLocation>
<IndexLocation>^web.DHCCRM.LisResultSendI</IndexLocation>
<StreamLocation>^web.DHCCRM.LisResultSendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
