Import sqluser

/// Creator： 王刚
/// CreatDate： 2008.10.6
/// Description:： 收据查询
/// Table： dhc_sfreceipt
Class web.UDHCJFRcptReturn Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query FindSFReceipt(startDate, endDate, type As %String) As %Query(ROWSPEC = "Tgrdate,Tgrtime,Tstno:%String,Tendno:%String,Tcurno:%String,Tuseflag:%String,Tgruser:%String,Ttitle:%String,TrctpLoc:%String,TconfirmFlag:%String,TconfirmDate,TconfirmTime,TreturnFlag:%String,TreturnDate,TreturnTime,Trowid:%String")
{
}

ClassMethod FindSFReceiptExecute(ByRef qHandle As %Binary, startDate, endDate, type As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s startDate=##class(websys.Conversions).DateHtmlToLogical(startDate)
    s endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    s type=$g(type)
    s rcptRowid=0
    ;s startDate=$zdh(startDate,3),endDate=$zdh(endDate,3)
    f rcptLqDate=startDate:1:endDate d
    .f  s rcptRowid=$o(^DHCSFRECEIPT(0,"Date",rcptLqDate,rcptRowid)) q:rcptRowid=""  d
    ..s useflag="",Tuseflag="",trctpLoc="",TrctpLoc=""
    ..i type'="" d  q:$p(^DHCSFRECEIPT(rcptRowid),"^",15)'=type
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",1)'="" d  
    ...s Tgrdate=$p(^DHCSFRECEIPT(rcptRowid),"^",1)
    ...s Tgrdate=##class(websys.Conversions).DateLogicalToHtml(Tgrdate)
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",2)'="" d  
    ...s Tgrtime=$p(^DHCSFRECEIPT(rcptRowid),"^",2)
    ...s Tgrtime=##class(websys.Conversions).TimeLogicalToHtml(Tgrtime,1)
    ..s Tstno=$p(^DHCSFRECEIPT(rcptRowid),"^",3)
    ..s Tendno=$p(^DHCSFRECEIPT(rcptRowid),"^",4)
    ..s Tcurno=$p(^DHCSFRECEIPT(rcptRowid),"^",5)
    ..s useflag=$p(^DHCSFRECEIPT(rcptRowid),"^",7)
    ..i useflag="1" s Tuseflag="可用"
	..i useflag="2" s Tuseflag="已发完"
	..i useflag="" s Tuseflag="待用"
    ..s TgruserRowId=$p(^DHCSFRECEIPT(rcptRowid),"^",8)
    ..s Tgruser=$p(^SSU("SSUSR",TgruserRowId),"^",2)
    ..s Ttitle=$p(^DHCSFRECEIPT(rcptRowid),"^",9)
    ..s trctpLoc=$p(^DHCSFRECEIPT(rcptRowid),"^",15)
    ..i trctpLoc="I"  d  s TrctpLoc="住院"
    ..i trctpLoc="O"  d  s TrctpLoc="门诊"
    ..s TconfirmFlag=$p(^DHCSFRECEIPT(rcptRowid),"^",16)
    ..s TconfirmDate="",TconfirmTime=""
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",17)'="" d  
    ...s TconfirmDate=$p(^DHCSFRECEIPT(rcptRowid),"^",17)
    ...s TconfirmDate=##class(websys.Conversions).DateLogicalToHtml(TconfirmDate)
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",18)'="" d  
    ...s TconfirmTime=$p(^DHCSFRECEIPT(rcptRowid),"^",18)
    ...s TconfirmTime=##class(websys.Conversions).TimeLogicalToHtml(TconfirmTime,1)
    ..s TreturnFlag=$p(^DHCSFRECEIPT(rcptRowid),"^",19)
    ..s TreturnDate="",TreturnTime=""
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",20)'="" d  
    ...s TreturnDate=$p(^DHCSFRECEIPT(rcptRowid),"^",20)
    ...s TreturnDate=##class(websys.Conversions).DateLogicalToHtml(TreturnDate)
    ..i $p(^DHCSFRECEIPT(rcptRowid),"^",21)'="" d  
    ...s TreturnTime=$p(^DHCSFRECEIPT(rcptRowid),"^",21)
    ...s TreturnTime=##class(websys.Conversions).TimeLogicalToHtml(TreturnTime,1)
    ..s Trowid=rcptRowid
    ..Do Output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(Tgrdate,Tgrtime,Tstno,Tendno,Tcurno,Tuseflag,Tgruser,Ttitle,TrctpLoc,TconfirmFlag,TconfirmDate,TconfirmTime,TreturnFlag,TreturnDate,TreturnTime,Trowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
	Quit $$$OK
}

ClassMethod FindSFReceiptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSFReceiptExecute ]
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
	Quit $$$OK
}

ClassMethod FindSFReceiptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSFReceiptExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      王刚
/// CreatDate：    2008.10.6
/// Description:： 收据审核
/// Table：        dhc_sfreceipt
ClassMethod getConfirmRcpt(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
   s upDate=$p($h,",",1)
   s upTime=$p($h,",",2)
   s upFlage="Y"
   &sql(update dhc_sfreceipt set rcpt_confirmflag=:upFlage,rcpt_confirmdate=:upDate,rcpt_confirmtime=:upTime where rcpt_rowid=:rowid)
   w SQLCODE
   q SQLCODE
}

/// Creator：      王刚 UpdateUser:yyx 2009-09-24 修改程序中的bug
/// CreatDate：    2008.10.6
/// Description:： 收据退回
/// Table：        dhc_sfreceipt,dhc_sfbuy
ClassMethod getReturnRcpt(itmjs As %Library.String = "", itmjsex As %Library.String = "", confirmFlag, rowid, tstno, tendno, tcurno, tgruser, ttitle, trctpLoc, HospDr)
{
   s upDate=$p($h,",",1)
   s upTime=$p($h,",",2)
   s upFlage="Y"
   i trctpLoc="住院" d  s trctType="I"
   i trctpLoc="门诊" d  s trctType="O"
   s tgruser=$g(tgruser)
   s user=""
   TSTART
   &sql(select ssusr_rowid into:user from ss_user where  ssusr_name=:tgruser)
   &sql(update dhc_sfreceipt set rcpt_useflag='2',rcpt_returnflag=:upFlage,rcpt_returndate=:upDate,rcpt_returntime=:upTime where rcpt_rowid=:rowid)
   i SQLCODE Trollback
   q:SQLCODE SQLCODE
   s RcptRowid="",UseNum=0,UnUseNum=0
   f  s RcptRowid=$o(^DHCSFRECEIPT(0,"LQUser",user,RcptRowid)) q:((RcptRowid="")!(UnUseNum'=0)!(UseNum'=0))  d
   .s RcptFinalFlag=$p(^DHCSFRECEIPT(RcptRowid),"^",7)
   .q:RcptFinalFlag="2"
   .i RcptFinalFlag="" s UnUseNum=UnUseNum+1,UnUseRowid=RcptRowid
   .i RcptFinalFlag="1" s UserNum=UseNum+1
   b
   s RetVal=0
   i UnUseNum'=0 d
   .&sql(update dhc_sfreceipt set rcpt_useflag='1' where rcpt_rowid=:UnUseRowid)
   .s RetVal=SQLCODE
   i RetVal'=0 Trollback
   q:RetVal'=0 -1
   s Count=..rcptcw(trctType, user)
   i Count>0 s UserFlag=""
   e  s UserFlag="1"
   &sql(insert into SQLUSER.Dhc_sfbuy(buy_date,buy_time,buy_startno,buy_endno,buy_loc,buy_currentno,buy_useflag,buy_gruser,buy_title,buy_comment1,buy_comment2,buy_hospital) 
   values(:upDate,:upTime,:tstno,:tendno,:trctType,:tcurno,:UserFlag,:user,:ttitle,'Return',:rowid,:HospDr))
   i SQLCODE Trollback
   q:SQLCODE SQLCODE
   TCOMMIT
   q SQLCODE
}

ClassMethod rcptcw(type, userid) As %Integer
{
	k P1
	;&sql(select count(*) into :count from dhc_sfbuy where buy_useflag='1' and buy_loc=:type)
	set myUserHospitalID=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(userid)
	s buyrowid="0",count=0
	f  s buyrowid=$o(^DHCSFBUY(buyrowid)) q:buyrowid=""  d
	.s useflag=$p(^DHCSFBUY(buyrowid),"^",9)
	.q:useflag'="1"
	.s loc=$p(^DHCSFBUY(buyrowid),"^",7)
	.q:(type'=loc)
	.s AddUser=$p(^DHCSFBUY(buyrowid),"^",6)
	.s AddUserHosp=##Class(web.UDHCHospitalGroup).GetHospitalIDByUserID(AddUser)
	.q:myUserHospitalID'=AddUserHosp
	.s count=count+1
	s P1=count
	q count
}

}
