Import SQLUser

Class web.UDHCJFDepositAcount Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 397;

ClassMethod FindWardPatDepositAountExecute(ByRef qHandle As %Binary, stdate, sttime, enddate, endtime, job) As %Status
{
	Set repid=$I(^CacheTemp)
    s job=$g(job)
    i (stdate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i job="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    //输出病区的预交金明细帐
    s alljfsum=0,alldfsum=0     ;本次的累计借方，贷方金额
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastjfsum=0,lastdfsum=0,lastremain=0
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"YJACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s (prtflag,patinfo,rcptno,jd,shdate,shtime,username,medicare)=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..s nextwardid=$o(^TMP("ZYJF","YJACOUNT",job,wardid))
    ..s firstward=$o(^TMP("ZYJF","YJACOUNT",job,wardid),-1)
    ..i ((nextwardid="")||($d(^PAWARD(nextwardid))=0))&&(firstward="")  s ward="上期结转"
    ..d OutputRow
    .s jfsum=0,dfsum=0     ;本次的借方，贷方金额
    .s date=""
    .f  s date=$o(^TMP("ZYJF","YJACOUNT",job,wardid,date)) q:date=""  d
    ..s dayyjfsum=0,daydfsum=0
    ..s num="",times=0
    ..f  s num=$o(^TMP("ZYJF","YJACOUNT",job,wardid,date,num)) q:num=""  d
    ...s yjinfo=^TMP("ZYJF","YJACOUNT",job,wardid,date,num)
    ...s times=times+1
    ...s prtdate=$p(yjinfo,"^",2)
    ...s prtdatemonth=$p(prtdate,"-",2)
    ...s prtdateday=$p(prtdate,"-",3)
    ...s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ...s:+times>1 prtdate=""
    ...s prtflag=$p(yjinfo,"^",3)
    ...s papname=$p(yjinfo,"^",4)
    ...s medicare=$p(yjinfo,"^",5)
    ...;s patinfo=prtflag_" "_papname_" "_medicare
    ...s patinfo=prtflag_" "_papname    
    ...s rcptno=$p(yjinfo,"^",6)
    ...s jfamount=$p(yjinfo,"^",7),jfsum=jfsum+jfamount,alljfsum=alljfsum+jfamount
    ...s dfamount=$p(yjinfo,"^",8),dfsum=dfsum+dfamount,alldfsum=alldfsum+dfamount
    ...s username=$p(yjinfo,"^",9)
    ...s cardno=$p(yjinfo,"^",10)
    ...s jd="",remain=""
    ...i flag="Y" d
    ....s ward=$p(warddesc,"-",2),flag="N"
    ...e  s ward=""
    ...d OutputRow
    .;病区的本期余额
    .;s ward="本日合计",jfamount=lastjfsum+jfsum,dfamount=lastdfsum+dfsum,remain=$zabs(lastremain+dfsum-jfsum)
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+dfsum-jfsum)
    .i remain<0 s jd="借"
    .e  s jd="贷"
    .;s ^TMP("ZYJF","YJACOUNTSAVE",job,wardid)=jfamount_"^"_dfamount_"^"_remain_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime  //预交金帐结算时的病区借方，贷方，余额
    .;q:(jfamount=0)&(dfamount=0)&(remain=0)
    .s (prtdate,prtflag,patinfo,rcptno,shdate,shtime,username,medicare)=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRow
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"YJACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"YJACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username,medicare)=""
    .;q:(jfamount=0)&(dfamount=0)&(remain=0)
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRow
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username,medicare)=""
    .;q:(jfamount=0)&(dfamount=0)&(remain=0)
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRow
    ;K ^TMP("ZYJF","YJACOUNT",job)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
	set Data=$lb($g(ward),$g(prtdate),$g(patinfo),$g(rcptno),$g(jfamount),$g(dfamount),$g(jd),$g(remain),$g(job),$g(shdate),$g(shtime),$g(username),$g(cardno),$g(medicare))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardPatDepositAountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPatDepositAountExecute ]
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

ClassMethod FindWardPatDepositAountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPatDepositAountExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardPatDepositAount(stdate, sttime, enddate, endtime, job) As %Query(ROWSPEC = "Tward:%String,Tprtdate:%String,Tpatinfo:%String,Trcptno:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String,Tjob:%String,Tshdate:%String,Tshtime:%String,Tuser,Tcomment,Tmedicare:%String")
{
}

ClassMethod FindWardDepositAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	 //输出病区的预交金总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
   
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","YJACOUNTSAVE")   //上期余额
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s prtdate=year
    s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    d OutputRowWard
    s date=""
    f  s date=$o(^TMP("ZYJF","WardYJAcount",job,date)) q:date=""  d
    .s wardid=""
    .f  s wardid=$o(^TMP("ZYJF","WardYJAcount",job,date,wardid)) q:wardid=""  d
    ..s jd=""
    ..s warddesc=$p($p(^PAWARD(wardid),"^",2),"-",2)
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s daydfsum=+$g(^TMP("ZYJF","WardYJAcount",job,date,wardid,"收"))
    ..s alldfsum=alldfsum+daydfsum
    ..s ward="收"_warddesc_"预交金",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowWard
    ..s dayjfsum=+$g(^TMP("ZYJF","WardYJAcount",job,date,wardid,"退"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s ward="退"_warddesc_"预交金",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowWard
    ;s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    s ward="本日合计",jfamount=alljfsum,dfamount=alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    i remain<0 s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowWard
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","YJACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","YJACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWard
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWard
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWard
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardDepositAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardDepositAcctExecute ]
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

ClassMethod FindWardDepositAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardDepositAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardDepositAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FindAllDepositAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	//预交金总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    //输出病区的预交金总帐
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","YJACOUNTSAVE")
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s prtdate=year
    s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    d OutputRowAll
    s date=""
    f  s date=$o(^TMP("ZYJF","AllYJAcount",job,date)) q:date=""  d
    .s jd=""
    .s prtdate=$zd(date,3)
    .s prtdatemonth=$p(prtdate,"-",2)
    .s prtdateday=$p(prtdate,"-",3)
    .s prtdate=prtdatemonth_"月"_prtdateday_"日"
    .s daydfsum=+$g(^TMP("ZYJF","AllYJAcount",job,date,"转入"))
    .s alldfsum=alldfsum+daydfsum
    .s ward="转入预交金",jfamount="",dfamount=daydfsum,remain=""
    .d OutputRowAll
    .s dayjfsum=+$g(^TMP("ZYJF","AllYJAcount",job,date,"转出"))
    .s alljfsum=alljfsum+dayjfsum
    .s ward="转出预交金",jfamount=dayjfsum,dfamount="",remain=""
    .d OutputRowAll
    ;s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    s ward="本日合计",jfamount=alljfsum,dfamount=alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    i remain<0 s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowAll
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","YJACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","YJACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowAll
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowAll
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAll
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAllDepositAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllDepositAcctExecute ]
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

ClassMethod FindAllDepositAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllDepositAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAllDepositAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FindWardPatFeeAcountExecute(ByRef qHandle As %Binary, stdate, sttime, enddate, endtime, job) As %Status
{
	Set repid=$I(^CacheTemp)
    s job=$g(job)
    i (stdate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i job="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    //输出费用明细帐
    s alljfsum=0,alldfsum=0     ;本次的累计借方，贷方金额
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"FEEACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s (prtflag,patinfo,rcptno,jd,shdate,shtime,username,papno)=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..s nextwardid=$o(^TMP("ZYJF","FEEACOUNT",job,wardid))
    ..s firstward=$o(^TMP("ZYJF","FEEACOUNT",job,wardid),-1)
    ..i ((nextwardid="")||($d(^PAWARD(nextwardid))=0))&&(firstward="") s ward="上期结转",flag="N"
    ..d OutputRowFee
    .s jfsum=0,dfsum=0
    .s date=""
    .f  s date=$o(^TMP("ZYJF","FEEACOUNT",job,wardid,date)) q:date=""  d
    ..s num=""
    ..s times=0
    ..f  s num=$o(^TMP("ZYJF","FEEACOUNT",job,wardid,date,num)) q:num=""  d
    ...s tmpstr=^TMP("ZYJF","FEEACOUNT",job,wardid,date,num)
    ...s jd=""
    ...s times=times+1
    ...s prtdate=$p(tmpstr,"^",1)
    ...s papno=$p(tmpstr,"^",2)
    ...s papname=$p(tmpstr,"^",3)
    ...s jfamount=$p(tmpstr,"^",4),jfsum=jfsum+jfamount,alljfsum=alljfsum+jfamount
    ...s dfamount=$p(tmpstr,"^",5),dfsum=dfsum+dfamount,alldfsum=alldfsum+dfamount
    ...;s patinfo=papname_" "_papno
    ...s patinfo=papname
    ...s prtdate=$zd(prtdate,3)
    ...s prtdatemonth=$p(prtdate,"-",2)
    ...s prtdateday=$p(prtdate,"-",3)
    ...s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ...s:+times>1 prtdate=""
    ...s remain=""
    ...i flag="Y" d
    ....s ward=warddesc,flag="N"
    ...e  s ward=""
    ...d OutputRowFee
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+jfsum-dfsum)
    .i remain'<0 s jd="借"
    .e  s jd="贷"
    .s prtdate="",patinfo="",papno=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowFee
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"FEEACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"FEEACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s prtdate="",patinfo="",remain="",jd="",papno=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowFee    
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s prtdate="",patinfo="",remain="",jd="",papno=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowFee    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFee
	s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
	i remain'=""  s remain=$j(remain,3,2)
	set Data=$lb(ward,prtdate,patinfo,jfamount,dfamount,remain,job,jd,papno)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardPatFeeAcountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPatFeeAcountExecute ]
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

ClassMethod FindWardPatFeeAcountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPatFeeAcountExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardPatFeeAcount(stdate, sttime, enddate, endtime, job) As %Query(ROWSPEC = "Tward:%String,Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tremain:%String,Tjob:%String,Tjd:%String,Tpapno:%String")
{
}

ClassMethod FindWardFeeAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	 //输出病区的应收医药费总帐
	 ;;d ##class(%ResultSet).RunQuery("web.UDHCJFDepositAcount","FindWardFeeAcct","")
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","FEEACOUNTSAVE")   //上期余额
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s prtdate=year
    s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    d OutputRowWard
    s date=""
    f  s date=$o(^TMP("ZYJF","WardFEEAcount",job,date)) q:date=""  d
    .s wardid=""
    .f  s wardid=$o(^TMP("ZYJF","WardFEEAcount",job,date,wardid)) q:wardid=""  d
    ..s jd=""
    ..s warddesc=$p($p(^PAWARD(wardid),"^",2),"-",2)
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s dayjfsum=+$g(^TMP("ZYJF","WardFEEAcount",job,date,wardid,"借"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s ward=warddesc_"应收医药费",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowWardFee
    ..s daydfsum=+$g(^TMP("ZYJF","WardFEEAcount",job,date,wardid,"贷"))
    ..s alldfsum=alldfsum+daydfsum
    ..s ward=warddesc_"结算医药费",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowWardFee
    
    ;s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    s ward="本日合计",jfamount=alljfsum,dfamount=alldfsum,remain=$zabs(lastremain+alljfsum-alldfsum)
    i remain'<0 s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowWardFee
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","FEEACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","FEEACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWardFee
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWardFee
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWardFee
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardFeeAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardFeeAcctExecute ]
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

ClassMethod FindWardFeeAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardFeeAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardFeeAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FindAllFeeAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	//应收医院费总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","FEEACOUNTSAVE")
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s prtdate=year
    s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    d OutputRowAllFee
    s date=""
    f  s date=$o(^TMP("ZYJF","AllFEEAcount",job,date)) q:date=""  d
    .s jd=""
    .s prtdate=$zd(date,3)
    .s prtdatemonth=$p(prtdate,"-",2)
    .s prtdateday=$p(prtdate,"-",3)
    .s prtdate=prtdatemonth_"月"_prtdateday_"日"
    .s dayjfsum=+$g(^TMP("ZYJF","AllFEEAcount",job,date,"借合计"))
    .s alljfsum=alljfsum+dayjfsum
    .s ward="应收医药费",jfamount=dayjfsum,dfamount="",remain=""
    .d OutputRowAllFee
    .s daydfsum=+$g(^TMP("ZYJF","AllFEEAcount",job,date,"贷合计"))
    .s alldfsum=alldfsum+daydfsum
    .s ward="结算医药费",jfamount="",dfamount=daydfsum,remain=""
    .d OutputRowAllFee
    
    ;s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    s ward="本日合计",jfamount=alljfsum,dfamount=alldfsum,remain=$zabs(lastremain+alljfsum-alldfsum)
    i remain'<0 s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowAllFee
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","FEEACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","FEEACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowAllFee
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowAllFee
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAllFee
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAllFeeAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllFeeAcctExecute ]
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

ClassMethod FindAllFeeAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllFeeAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAllFeeAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod getprtnum(flag, job)
{
	s num=$o(^TMP("ZYJF",flag,job,""),-1)
	q num
}

ClassMethod getshdate(arrcp)
{
    k P1
	s shdate="",shtime=""
	s arpbl=$p(^ARRCP(arrcp,"RAL",1),"^",18)
	i arpbl'="" d
	.s invrowid=$o(^DHCINVPRTZY(0,"AR",arpbl,""))
	.i invrowid'="" d
	..s shdate=$zd($p(^DHCINVPRTZY(invrowid),"^",2),3)
	..s shtime=$zt($p(^DHCINVPRTZY(invrowid),"^",3),1)
	s P1=shdate_"^"_shtime
	q P1
}

ClassMethod FindWardPatQFDetailExecute(ByRef qHandle As %Binary, stdate, sttime, enddate, endtime, job) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFDepositAcount","FindWardPatQFDetail","61101","58315","61171","58315","4380")
	;病区病人欠费明细账
	Set repid=$I(^CacheTemp)
    s job=$g(job),stdate=$g(stdate)
    i job="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    i stdate="" Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s sttime=0,endtime="86399"
	s ind=1
	s alljfsum=0,alldfsum=0     ;本次的累计借方，贷方金额
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"QFACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s (prtflag,patinfo,rcptno,jd,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowQFDeal
    .s jfsum=0,dfsum=0     ;本次的借方，贷方金额
    .s date=""		
	.f  s date=$o(^TMP("ZYJF","QFACOUNT",job,wardid,date))  q:(date="")  d
	..s dayyjfsum=0,daydfsum=0
    ..s num=""
    ..f  s num=$o(^TMP("ZYJF","QFACOUNT",job,wardid,date,"欠费",num))  q:(num="")  d
    ...s qfinfo=^TMP("ZYJF","QFACOUNT",job,wardid,date,"欠费",num)
    ...s jd=""
    ...s prtdate=$p(qfinfo,"^",2)
    ...s prtdatemonth=$p(prtdate,"-",2)
    ...s prtdateday=$p(prtdate,"-",3)
    ...s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ...s prtflag=$p(qfinfo,"^",3)
    ...s papname=$p(qfinfo,"^",4)
    ...s medicare=$p(qfinfo,"^",5)
    ...s patinfo=prtflag_"  "_papname_" "_medicare
    ...s rcptno=$p(qfinfo,"^",6)
    ...s jfamount=$p(qfinfo,"^",7),jfsum=jfsum+jfamount,alljfsum=alljfsum+jfamount
    ...s dfamount=""
    ...s username=$p(qfinfo,"^",9)
    ...s cardno=$p(qfinfo,"^",10)
    ...s jd="",remain=""
    ...i flag="Y" d
    ....s ward=warddesc,flag="N"
    ...e  s ward=""
    ...d OutputRowQFDeal 
	..s num=""
    ..f  s num=$o(^TMP("ZYJF","QFACOUNT",job,wardid,date,"收回",num))  q:(num="")  d
    ...s qfinfo=^TMP("ZYJF","QFACOUNT",job,wardid,date,"收回",num)
    ...s prtdate=$p(qfinfo,"^",2)
    ...s prtdatemonth=$p(prtdate,"-",2)
    ...s prtdateday=$p(prtdate,"-",3)
    ...s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ...s prtflag=$p(qfinfo,"^",3)
    ...s papname=$p(qfinfo,"^",4)
    ...s medicare=$p(qfinfo,"^",5)
    ...s patinfo=prtflag_"欠费"_"  "_papname_" "_medicare
    ...s rcptno=$p(qfinfo,"^",6)
    ...s jfamount=""
    ...s dfamount=$p(qfinfo,"^",8),dfsum=dfsum+dfamount,alldfsum=alldfsum+dfamount
    ...s username=$p(qfinfo,"^",9)
    ...s cardno=$p(qfinfo,"^",10)
    ...s jd="",remain=""
    ...i flag="Y" d
    ....s ward=warddesc,flag="N"
    ...e  s ward=""
    ...d OutputRowQFDeal
	.;病区的本期余额
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+jfsum-dfsum)
    .i remain'<0 s jd="借"
    .e  s jd="贷"
    .s ^TMP("ZYJF","QFACOUNTSAVE",job,wardid)=jfamount_"^"_dfamount_"^"_remain_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime  //预交金帐结算时的病区借方，贷方，余额
    .s (prtdate,prtflag,patinfo,rcptno,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowQFDeal
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"QFACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"QFACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,remain,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowQFDeal
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,remain,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowQFDeal
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutputRowQFDeal
	i (jfamount'="")!(jfamount=0.00)  s jfamount=$j(jfamount,3,2)
	i (dfamount'="")!(dfamount=0.00)  s dfamount=$j(dfamount,3,2)
	i (remain'="")!(remain=0.00)  s remain=$j(remain,3,2)
	set Data=$lb($g(prtdate),$g(patinfo),$g(rcptno),jfamount,dfamount,$g(jd),remain,$g(job),$g(ward))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardPatQFDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPatQFDetailExecute ]
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

ClassMethod FindWardPatQFDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPatQFDetailExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardPatQFDetail(stdate, sttime, enddate, endtime, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Trcptno:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String,Tjob:%String,Twarddesc:%String")
{
}

ClassMethod FindAllQFAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	//欠费总帐
	;d ##class(%ResultSet).RunQuery("web.UDHCJFDepositAcount","FindAllQFAcct","61101","4380")
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","QFACOUNTSAVE")
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s prtdate=year
    s (prtflag,patinfo,rcptno,shdate,shtime,username,jd)=""
    d OutputRowQFAll
    s date=""
    f  s date=$o(^TMP("ZYJF","AllQFAcount",job,date)) q:date=""  d
    .s jd=""
    .s prtdate=$zd(date,3)
    .s prtdatemonth=$p(prtdate,"-",2)
    .s prtdateday=$p(prtdate,"-",3)
    .s prtdate=prtdatemonth_"月"_prtdateday_"日"
    .s daydfsum=+$g(^TMP("ZYJF","AllQFAcount",job,date,"收回"))
    .s alldfsum=alldfsum+daydfsum
    .s ward="收回",jfamount="",dfamount=daydfsum,remain=""
    .d OutputRowQFAll
    .s dayjfsum=+$g(^TMP("ZYJF","AllQFAcount",job,date,"欠费"))
    .s alljfsum=alljfsum+dayjfsum
    .s ward="欠费",jfamount=dayjfsum,dfamount="",remain=""
    .d OutputRowQFAll
    ;s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    s ward="本日合计",jfamount=alljfsum,dfamount=alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    i remain'<0 s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowQFAll
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","QFACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","QFACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowQFAll
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowQFAll
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowQFAll
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindAllQFAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllQFAcctExecute ]
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

ClassMethod FindAllQFAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllQFAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAllQFAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FindWardQFAcctExecute(ByRef qHandle As %Binary, stdate, job) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.UDHCJFDepositAcount","FindWardQFAcct","61101","4380")
	 //输出病区的欠费总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,"","QFACOUNTSAVE")   //上期余额
    s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    s lastjd=""
    s curryear=$zd(stdate,3)
    s year=$p(curryear,"-",1)
    s year=year_"年"
    s ward="上期结转",jfamount=lastjfsum,dfamount=lastdfsum,jd=lastjd,remain=lastremain,prtdate=year
    s (prtflag,patinfo,rcptno,shdate,shtime,username)=""
    d OutputRowWardQF
    s date=""
    f  s date=$o(^TMP("ZYJF","WardQFAcount",job,date)) q:date=""  d
    .s wardid=""
    .f  s wardid=$o(^TMP("ZYJF","WardQFAcount",job,date,wardid)) q:wardid=""  d
    ..s jd=""
    ..s warddesc=$p($p(^PAWARD(wardid),"^",2),"-",2)
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s daydfsum=+$g(^TMP("ZYJF","WardQFAcount",job,date,wardid,"收回"))
    ..s alldfsum=alldfsum+daydfsum
    ..s ward=warddesc_"收回欠费",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowWardQF
    ..s dayjfsum=+$g(^TMP("ZYJF","WardQFAcount",job,date,wardid,"欠费"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s ward=warddesc_"欠费",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowWardQF
    s ward="本日合计",jfamount=lastjfsum+alljfsum,dfamount=lastdfsum+alldfsum,remain=$zabs(lastremain+alldfsum-alljfsum)
    i remain'<0  s jd="借"
    e  s jd="贷"
    s prtdate=""
    d OutputRowWardQF
    s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","QFACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,"","QFACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    s ward="本月合计",jfamount=monthjfsum+alljfsum,dfamount=monthdfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWardQF
    s ward="本年累计",jfamount=yearjfsum+alljfsum,dfamount=yeardfsum+alldfsum
    s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    d OutputRowWardQF
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWardQF
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(rcptno),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardQFAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardQFAcctExecute ]
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

ClassMethod FindWardQFAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardQFAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardQFAcct(stdate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Trcptno:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FindWardDescExecute(ByRef qHandle As %Binary, Warddesc) As %Status
{
	Set repid=$I(^CacheTemp)
    ;i (Warddesc="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    s ind=1
    ;s WardDesc=""
    ;s WardDesc=Warddesc
    s Warddesc=$g(Warddesc)
    i $f(Warddesc,"-")'=0  d
    .s Warddesc=$p(Warddesc,"-",2)
    s Warddesc="病区: "_Warddesc
    d OutputRowward
    ;K ^TMP("ZYJF","YJACOUNT",job)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowward
	set Data=$lb(Warddesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardDescExecute ]
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

ClassMethod FindWardDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardDescExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindWardDesc(Warddesc) As %Query(ROWSPEC = "TWardDesc:%String")
{
}

ClassMethod FWardDayDepositAcctExecute(ByRef qHandle As %Binary, stdate, enddate, job) As %Status
{
	 //输出病区的预交金总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastjfsum=0,lastdfsum=0,lastremain=0
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"YJACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRowDWardDay
    .s jfsum=0,dfsum=0     ;本次的借方，贷方金额
    .s date=""
    .f  s date=$o(^TMP("ZYJF","WardDayYJAcount",job,wardid,date)) q:(date="")  d
    ..s jd=""
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s daydfsum=+$g(^TMP("ZYJF","WardDayYJAcount",job,wardid,date,"收"))
    ..s alldfsum=alldfsum+daydfsum
    ..s dfsum=dfsum+daydfsum
    ..s ward="收"_warddesc_"预交金",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowDWardDay
    ..s dayjfsum=+$g(^TMP("ZYJF","WardDayYJAcount",job,wardid,date,"退"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s jfsum=jfsum+dayjfsum
    ..s ward="退"_warddesc_"预交金",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowDWardDay
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+dfsum-jfsum)
    .i remain<0 s jd="借"
    .e  s jd="贷"
    .s prtdate=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRowDWardDay
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"YJACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"YJACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRowDWardDay
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","YJACOUNT",job,wardid))'=0  d
    ..d OutputRowDWardDay   
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowDWardDay
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FWardDayDepositAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FWardDayDepositAcctExecute ]
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

ClassMethod FWardDayDepositAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FWardDayDepositAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FWardDayDepositAcct(stdate, enddate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FWardDayFeeAcctExecute(ByRef qHandle As %Binary, stdate, enddate, job) As %Status
{
	 //输出病区的预交金总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastjfsum=0,lastdfsum=0,lastremain=0
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"FEEACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowWFeeDay
    .s jfsum=0,dfsum=0     ;本次的借方，贷方金额
    .s date=""
    .f  s date=$o(^TMP("ZYJF","WardDayFEEAcount",job,wardid,date)) q:(date="")  d
    ..s jd=""
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s dayjfsum=+$g(^TMP("ZYJF","WardDayFEEAcount",job,wardid,date,"借"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s jfsum=jfsum+dayjfsum
    ..s ward=warddesc_"应收医药费",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowWFeeDay
    ..s daydfsum=+$g(^TMP("ZYJF","WardDayFEEAcount",job,wardid,date,"贷"))
    ..s alldfsum=alldfsum+daydfsum
    ..s dfsum=dfsum+daydfsum
    ..s ward=warddesc_"结算医药费",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowWFeeDay
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+jfsum-dfsum)
    .i remain'<0 s jd="借"
    .e  s jd="贷"
    .s prtdate=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowWFeeDay
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"FEEACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"FEEACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowWFeeDay
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","FEEACOUNT",job,wardid))'=0  d
    ..d OutputRowWFeeDay   
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWFeeDay
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FWardDayFeeAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FWardDayFeeAcctExecute ]
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

ClassMethod FWardDayFeeAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FWardDayFeeAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FWardDayFeeAcct(stdate, enddate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

ClassMethod FWardDayQFAcctExecute(ByRef qHandle As %Binary, stdate, enddate, job) As %Status
{
	 //输出病区的预交金总帐
	Set repid=$I(^CacheTemp)
    s alldfsum=0,alljfsum=0
    s ind=1
	s sttime=0,endtime="86399"
    s wardid="0"
    f  s wardid=$o(^PAWARD(wardid))  q:(wardid="BED_BedType_DR")  d
    .s flag="Y"
    .s warddesc=$p(^PAWARD(wardid),"^",2)
    .i $f(warddesc,"-")'=0  d
    ..s warddesc=$p(warddesc,"-",2)
    .s lastjfsum=0,lastdfsum=0,lastremain=0
    .s lastinfo=##class(web.UDHCJFAcountCommon).getlastremain(stdate,wardid,"QFACOUNTSAVE")    //病区的上期余额
    .s lastjfsum=$p(lastinfo,"^",1),lastdfsum=$p(lastinfo,"^",2),lastremain=$p(lastinfo,"^",3)
    .s ward=warddesc_"上期结转",jfamount=lastjfsum,dfamount=lastdfsum,remain=lastremain
    .s curryear=$zd(stdate,3)
    .s year=$p(curryear,"-",1)
    .s year=year_"年"
    .s prtdate=year
    .s (prtflag,patinfo,rcptno,jd,shdate,shtime,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowWQFDay
    .s jfsum=0,dfsum=0     ;本次的借方，贷方金额
    .s date=""
    .f  s date=$o(^TMP("ZYJF","WardDayQFAcount",job,wardid,date)) q:(date="")  d
    ..s jd=""
    ..s prtdate=$zd(date,3)
    ..s prtdatemonth=$p(prtdate,"-",2)
    ..s prtdateday=$p(prtdate,"-",3)
    ..s prtdate=prtdatemonth_"月"_prtdateday_"日"
    ..s dayjfsum=+$g(^TMP("ZYJF","WardDayQFAcount",job,wardid,date,"欠费"))
    ..s alljfsum=alljfsum+dayjfsum
    ..s jfsum=jfsum+dayjfsum
    ..s ward=warddesc_"欠费",jfamount=dayjfsum,dfamount="",remain=""
    ..d OutputRowWQFDay
    ..s daydfsum=+$g(^TMP("ZYJF","WardDayQFAcount",job,wardid,date,"收回"))
    ..s alldfsum=alldfsum+daydfsum
    ..s dfsum=dfsum+daydfsum
    ..s ward=warddesc_"收回欠费",jfamount="",dfamount=daydfsum,remain=""
    ..d OutputRowWQFDay
    .s ward="本日合计",jfamount=jfsum,dfamount=dfsum,remain=$zabs(lastremain+jfsum-dfsum)
    .i remain'<0 s jd="借"
    .e  s jd="贷"
    .s prtdate=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowWQFDay
    .s monthsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"QFACOUNTSAVE","M"),monthjfsum=$p(monthsum,"^",1),monthdfsum=$p(monthsum,"^",2)  //本月累计
    .s yearsum=##class(web.UDHCJFAcountCommon).getyearmonthsum(stdate,wardid,"QFACOUNTSAVE","Y"),yearjfsum=$p(yearsum,"^",1),yeardfsum=$p(yearsum,"^",2)       //本年累计
    .;病区的本月合计
    .s ward="本月合计",jfamount=monthjfsum+jfsum,dfamount=monthdfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowWQFDay
    .s ward="本年累计",jfamount=yearjfsum+jfsum,dfamount=yeardfsum+dfsum
    .s (prtdate,prtflag,patinfo,rcptno,jd,shdate,shtime,remain,username)=""
    .i $d(^TMP("ZYJF","QFACOUNT",job,wardid))'=0  d
    ..d OutputRowWQFDay   
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowWQFDay
    s jfamount=$j(jfamount,3,2),dfamount=$j(dfamount,3,2)
    s patinfo=ward
	set Data=$lb($g(prtdate),$g(patinfo),$g(jfamount),$g(dfamount),$g(jd),$g(remain))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FWardDayQFAcctFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FWardDayQFAcctExecute ]
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

ClassMethod FWardDayQFAcctClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FWardDayQFAcctExecute ]
{
   
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FWardDayQFAcct(stdate, enddate, job) As %Query(ROWSPEC = "Tprtdate:%String,Tpatinfo:%String,Tjfamt:%String,Tdfamt:%String,Tjd:%String,Tremain:%String")
{
}

}
