Import sqluser

/// Creator：      hwq
/// CreatDate：    2011-08-08
/// Description:   审核人员统计工作量
/// d ##class(%ResultSet).RunQuery("web.INSUAudUserReport","AuditReport","63612","63614","张忠丽")
Class web.INSUAudUserReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query AuditReport(StartDate, EndDate, UserName, HOSPID = "") As %Query(ROWSPEC = "UserDesc,Num,TotalAmount,TUserDr,MoreThanThreeDays,Job")
{
}

ClassMethod AuditReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditReportExecute ]
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

ClassMethod AuditReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditReportExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.INSUAudUserReport","FindUser","","114",2)
ClassMethod FindUserExecute(ByRef qHandle As %Binary, UserName As %String = "", GROUPID As %String = "", HOSPID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s UserName = "_"_UserName_"_"
 	s ^TMPGuo("guo")=UserName_","_GROUPID_","_HOSPID
    //i $g(UserName)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s UserName=$g(UserName)
    set OutUserDr=""
    i UserName=""  d
    .s UserDr=""
    .f  s UserDr=$o(^SSU("SSUSR",0,"Group",GROUPID,UserDr))  q:UserDr=""   d
    ..s chkFlag = ##class(web.DHCBILLINSUCloudCommon).CheckDataSession("SS_User",UserDr,HOSPID,"","Y")
    ..q:chkFlag'="Y"
    ..s username=$p(^SSU("SSUSR",UserDr),"^",2)    
	..s usercode=$p(^SSU("SSUSR",UserDr),"^",1) 
	..s OutUserDr=UserDr
	..Do OutputRow2
	.s UserRowid=0
	.f  s UserRowid=$o(^SSU("SSUSR",UserRowid))  q:UserRowid=""  d
	..s chkFlag = ##class(web.DHCBILLINSUCloudCommon).CheckDataSession("SS_User",UserRowid,HOSPID,"","Y")
    ..q:chkFlag'="Y"
 	..s OTHLLChildsub=0
 	..f  s OTHLLChildsub=$o(^SSU("SSUSR",UserRowid,"OTHLL",OTHLLChildsub))   q:OTHLLChildsub=""   d
 	...s OTHLLStr=$g(^SSU("SSUSR",UserRowid,"OTHLL",OTHLLChildsub))  
 	...s GROUPDr=$p(OTHLLStr,"^",2)
 	...q:GROUPDr'=GROUPID
    ...s username=$p(^SSU("SSUSR",UserRowid),"^",2)    
	...s usercode=$p(^SSU("SSUSR",UserRowid),"^",1) 
	...s OutUserDr=UserRowid
	...Do OutputRow2
    e  d
    .s UserDr=""
    .s UserName=$$ALPHAUP^SSUTIL4(UserName)
	.f  s UserDr=$o(^SSU("SSUSR",0,"SSUSR_Name",UserName,UserDr))  q:UserDr=""   d
	..s chkFlag = ##class(web.DHCBILLINSUCloudCommon).CheckDataSession("SS_User",UserDr,HOSPID,"","Y")
    ..q:chkFlag'="Y"
	..s username=$p(^SSU("SSUSR",UserDr),"^",2)    
	..s usercode=$p(^SSU("SSUSR",UserDr),"^",1) 
	..s OutUserDr=UserDr 
    ..Do OutputRow2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(username,usercode,OutUserDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query FindUser(UserName As %String = "", GROUPID As %String = "", HOSPID As %String = "") As %Query(ROWSPEC = "username:%String:姓名,usercode:%String:工号,UserDr:%String:收费员ROWID")
{
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
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

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
/// d ##class(%ResultSet).RunQuery("web.INSUAudUserReport","AuditRepDetails","62301","62311","3878")
ClassMethod AuditRepDetailsExecute(ByRef qHandle As %Binary, StartDate, EndDate, UserDr) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	;s ^HH("reportdetail")=StartDate_"^"_EndDate_"^"_UserDr
	i $g(UserDr)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s INAUDRowid=""
	s TabConfirmDate="",TabInsuStrAuditDate="",TabInsuEndAuditDate=""
	;f  s INAUDRowid=$o(^DHCINAUD("0","UserDr",UserDr,INAUDRowid))   q:INAUDRowid=""  d
	s k=0
	s AdmDr=""
	f  s AdmDr=$o(^CacheTemp("AuditReport",UserDr,AdmDr))  q:AdmDr=""   d
	.s INAUDRowid=""
	.s TotalAmount=0
	.s BillDr=""
	.f  s BillDr=$o(^DHCPB(0,"ADM",AdmDr,BillDr))   q:BillDr=""   d
	..s Amount=$p(^DHCPB(BillDr),"^",8)
	..s TotalAmount=TotalAmount+Amount
	.s TabAllAmount=TotalAmount
	.;f  s INAUDRowid=$o(^DHCINAUD("0","AdmDr",AdmDr,INAUDRowid))  q:INAUDRowid=""  d
	.;.s Amount=$p($g(^DHCINAUD(INAUDRowid)),"^",10)
	.;.s TotalAmount=TotalAmount+Amount 
	.;s TabAllAmount=TotalAmount
	.s INAUDRowid=$p(^CacheTemp("AuditReport",UserDr,AdmDr),"^",2)
	.s INAUDInfo=$g(^DHCINAUD(INAUDRowid))
	.;s AdmDr=$p(INAUDInfo,"^",1)
	.s Date=$p(INAUDInfo,"^",14)
	
	.;w StartDate_"^"_EndDate_"^"_Date,!
	.;q:(Date<StartDate)!(Date>EndDate)
	.s AuditFlag=$p(INAUDInfo,"^",16)
	
	.;add by zhangdongliang at 2015-03-04
	.s InsuEndAuditDate=""
	.s:AuditFlag="完成" InsuEndAuditDate=$p(INAUDInfo,"^",14)
	.s:InsuEndAuditDate="" InsuEndAuditDate=+$h
	.s AdmDischdDate=$p(^PAADM(AdmDr),"^",17)
	.;s:AdmDischdDate="" AdmDischdDate=+$h
	.;w InsuEndAuditDate_"=="_AdmDischdDate,!
	.s days=0
	.f day=AdmDischdDate:1:InsuEndAuditDate  d
	..i $d(^DHCANCAPPDATE(day)) d
	...s day1=$zd(day,10)
    ...i (day1=0)!(day1=6) d
	....s days=days+1
	..e     d
	...s day1=$zd(day,10)
    ...i (day1'=0)&(day1'=6) d
	....s days=days+1
	.;end
	
	.;add by zhangdongliang at 2015-01-09 for 增加 住院处审核完成时间   医保办完成审核时间 
	.s INAUDPBDr=$p(INAUDInfo,"^",2)
	.s TabConfirmDate=""
	.;w "INAUDPBDr="_INAUDPBDr,!
	.s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",INAUDPBDr,""))     ; 住院处审核时间
    .i confdr'="" d
    ..s confflag=$p(^DHCIPBillPatFeeConfirm(confdr),"^",9)
    ..i confflag="C"  d
    ...s ConfirmDate=$p(^DHCIPBillPatFeeConfirm(confdr),"^",6)
    ...s:ConfirmDate'="" ConfirmDate=$zd(ConfirmDate,3)
    ...s ConfirmTime=$p(^DHCIPBillPatFeeConfirm(confdr),"^",7)
    ...s:ConfirmTime'="" ConfirmTime=$zt(ConfirmTime)
    ...s TabConfirmDate=ConfirmDate_"  "_ConfirmTime
    ...;w "TabConfirmDate="_TabConfirmDate,!
    
    
    





    .;add by zhangdongliang at 2015-03-04
	.s daysYBSFC=0
	.f day=$zdh(ConfirmDate,3):1:InsuEndAuditDate d
	..i $d(^DHCANCAPPDATE(day)) d
	...s day1=$zd(day,10)
    ...i (day1=0)!(day1=6) d
	....s daysYBSFC=daysYBSFC+1
	..e     d
	...s day1=$zd(day,10)
    ...i (day1'=0)&(day1'=6) d
	....s daysYBSFC=daysYBSFC+1
	.;end
	
	.s daysSFCLY=0
	.f day=AdmDischdDate:1:$zdh(ConfirmDate,3)  d
	..i $d(^DHCANCAPPDATE(day)) d
	...s day1=$zd(day,10)
    ...i (day1=0)!(day1=6) d
	....s daysSFCLY=daysSFCLY+1
	..e     d
	...s day1=$zd(day,10)
    ...i (day1'=0)&(day1'=6) d
	....s daysSFCLY=daysSFCLY+1
    
    

     
    .s TempTabAuditFlag=$p(INAUDInfo,"^",16)
    .;w "TempTabAuditFlag="_TempTabAuditFlag,!
	.s:TempTabAuditFlag'="" TabAuditFlag=TempTabAuditFlag
    .s TabAuditDate=$p(INAUDInfo,"^",14)
	.s TabAuditTime=$p(INAUDInfo,"^",15)
	.s:TabAuditDate'="" TabAuditDate=$zd(TabAuditDate,3)
	.s:TabAuditTime'="" TabAuditTime=$zt(TabAuditTime)
	.;w "TabAuditDate="_TabAuditDate,!
	.s:TabAuditFlag="开始审核" TabInsuStrAuditDate=TabAuditDate_" "_TabAuditTime    ;加一列医保办开始审核时间 
	.s:TabAuditFlag="完成" TabInsuEndAuditDate=TabAuditDate_" "_TabAuditTime
	.;w "TabInsuEndAuditDate="_TabInsuEndAuditDate,!
	.;end
	
	.;w AdmDr_"^"_AuditFlag,!
	.;s AuditInfo=$p(INAUDInfo,"^",11)
	.;q:AuditInfo="1" ;明细信息退出，统计人头主信息
	.s AdmInfo=$g(^PAADM(AdmDr))
	.s PaPmiDr=$p(AdmInfo,"^",1)
	.s PatName=$p(^PAPER(PaPmiDr,"ALL"),"^",1)  ;姓名
	.s PatNo=$p(^PAPER(PaPmiDr,"PAT",1),"^",1)	;登记号
	.s MrNo=$p($g(^PAPER(PaPmiDr,"PAT",1)),"^",22)	;病案号
	.s DepCodeDR=$p(AdmInfo,"^",4)
	.s DepName=$p(^CTLOC(DepCodeDR),"^",2)  ;科室名称
	.s DepName=$p(DepName,"-",2)
	.;s MRADMDR=$p($g(^PAADM(AdmDr)),"^",61)
	.s AdmReasonDr=$P($g(^PAADM(AdmDr,1)),"^",7)
	.q:AdmReasonDr=""
	.s TabPatType=$P($G(^PAC("ADMREA",AdmReasonDr)),"^",2)			;病人类型
	.s TabDiagDesc=$$GetDiagnosInfoByAdmDr^DHCINSUFacadeBJ(AdmDr)	;诊断
	.s DiagDesc=$p(TabDiagDesc,"!",1)
	.s DiagDesc=$p(TabDiagDesc,"^",3)
	.s InDate=$zd($p(AdmInfo,"^",6),3)
	.s DischgDate=$p(AdmInfo,"^",17)
	.s:DischgDate'="" DischgDate=$zd(DischgDate,3)  ;离院时间
	.;w InDate_"^"_DischgDate,!
	.;s TabAllAmount=""
	.;s OEORDDr=""
	.;f  s OEORDDr=$o(^OEORD(0,"Adm",AdmDr,OEORDDr)) q:OEORDDr=""  d
	.;.s OEORIDr=""
	.;.f  s OEORIDr=$o(^OEORD(OEORDDr,"I",OEORIDr)) q:OEORIDr=""  d
	.;..s OEORIRowId=OEORDDr_"||"_OEORIDr
	.;..s TabOEORIRowId=OEORIRowId	
	.;..s OEORIPhQtyOrd=##Class(web.DHCCLCom).GetOrderBaseQty(OEORIRowId)		
	.;..s TabOEORIPhQty=OEORIPhQtyOrd										;11医嘱数量
	.;..s ItmMastDR=$p($g(^OEORD(OEORDDr,"I",OEORIDr,1)),"^",2)				
	.;..i ItmMastDR="" d
	.;...s PrescPrice=""
	.;..e  d
	.;...;s PrescPrice=$p(##Class(web.DHCDocOrderEntry).GetOrderPrice
	.;...s PrescPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ItmMastDR,+$h,"","","",""),"^",1)	
	.;...;s TabPrescPrice=$fn(TabPrescPrice,"",2)								;10医嘱单位价格	
	.;...s Amount=$fn(PrescPrice*OEORIPhQtyOrd,"",2)				;12医嘱总价 
    .;...;w ItmMastDR_"^"_TabOEORIPhQty_"^"_Amount,!
    .;...s TabAllAmount=TabAllAmount+Amount			;总额
    .;w TabAllAmount,!
    .s k=k+1
    .s ^CacheTemp("AuditReport1",UserDr,k)=PatNo_"^"_PatName_"^"_DepName_"^"_DiagDesc_"^"_InDate_"^"_DischgDate_"^"_TabAllAmount_"^"_MrNo_"^"_TabConfirmDate_"^"_TabInsuEndAuditDate_"^"_days_"^"_daysYBSFC_"^"_daysSFCLY  //用于导出统计明细
    .Do OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(PatNo,PatName,DepName,AdmReason,DiagDesc,InDate,DischgDate,TabAllAmount,MrNo,TabConfirmDate,TabInsuEndAuditDate,days,daysYBSFC,daysSFCLY)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}
*/
Query AuditRepDetails(StartDate, EndDate, UserDr, Job) As %Query(ROWSPEC = "PatNo,PatName,DepName,AdmReason,DiagDesc,InDate,DischgDate,TabAllAmount,MrNo,TabConfirmDate,TabInsuEndAuditDate,days,daysYBSFC,daysSFCLY")
{
}

ClassMethod AuditRepDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AuditRepDetailsExecute ]
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

ClassMethod AuditRepDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AuditRepDetailsExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDateNum(UserDr As %String, Job As %String) As %String
{
	n (UserDr,Job)
	q:UserDr="" 0
	s Num=""
	f  s Num=$o(^CacheTemp("AuditReport1",Job,UserDr,Num))  q:Num=""   d
	.s Num1=Num
	q Num1
}

ClassMethod GetData(UserDr As %String, Num As %String, Job As %String) As %String
{
	n (UserDr,Num,Job)
	q:UserDr="" ""
	s Str=^CacheTemp("AuditReport1",Job,UserDr,Num)
	q Str
}

ClassMethod GetUserDate(UserDr As %String, Job As %String) As %String
{
	n (UserDr,Job)
	q:UserDr="" ""
	s Str=""
	s Str=^CacheTemp("AuditReport1",Job,UserDr)
	q Str
}

ClassMethod AuditReportExecute(ByRef qHandle As %Binary, StartDate, EndDate, UserName, HOSPID = "") As %Status
{
	s ^HH("AuditReport")=StartDate_"^"_EndDate_"^"_UserName_"^"_HOSPID
	set StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	set:HOSPID="" HOSPID=%session.Data("LOGON.HOSPID") 
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	k ^CacheTemp("AuditReport",$j)
 	k ^CacheTemp("AuditReport1",$j)
  	i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s i=0
	f Date=StartDate:1:EndDate  d 
	.s INAUDRowid=""
	.f  s INAUDRowid=$o(^DHCINAUD("0","Date",Date,INAUDRowid))  q:INAUDRowid=""  d
	..s INAUDInfo=$g(^DHCINAUD(INAUDRowid))
	..s AdmDr=$p(INAUDInfo,"^",1)
	..s tHospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+ DingSH 20200612
	..q:tHospDr'=HOSPID
	..s PBDr=$p(INAUDInfo,"^",2)
	..s AuditInfo=$p(INAUDInfo,"^",11)
	..s Amount=$p(INAUDInfo,"^",10)
	..s UserDr=$p(INAUDInfo,"^",12)
	..q:UserDr=""
	..s usrname=$p(INAUDInfo,"^",13)
	..q:(UserName'="")&&(usrname'=UserName)
	..s AuditFlag=$p(INAUDInfo,"^",16)
	..q:AuditInfo="1" ;明细信息退出，统计人头主信息
	..s AuditFlag=$p(INAUDInfo,"^",16)
	..q:AuditFlag'="完成"
	..s i=i+1
	..s ^CacheTemp("AuditReport",$j,UserDr,i)=usrname_"^"_INAUDRowid_"^"_AdmDr_"^"_PBDr		;_"^"_$zd(Date,3)
	b
	s TUserDr="",InsuEndAuditDate=""
	f  s TUserDr=$o(^CacheTemp("AuditReport",$j,TUserDr))  q:TUserDr=""  d
	.s MoreThanThreeDays=0
	.s Num=0
	.s TotalAmount=0
	.s tempcount=""
	.f  s tempcount=$o(^CacheTemp("AuditReport",$j,TUserDr,tempcount))  q:tempcount=""   d
	..s UserDesc=$p(^CacheTemp("AuditReport",$j,TUserDr,tempcount),"^",1)
	..s INAUDDr=$p(^CacheTemp("AuditReport",$j,TUserDr,tempcount),"^",2)
	..s AdmDr=$p(^CacheTemp("AuditReport",$j,TUserDr,tempcount),"^",3)
	..s PBDr=$p(^CacheTemp("AuditReport",$j,TUserDr,tempcount),"^",4)
	..s Amount=0
	..s INAUDInfo=$g(^DHCINAUD(INAUDDr))
	..s AuditInfo=$p(INAUDInfo,"^",11)
	..s AuditFlag=$p(INAUDInfo,"^",16)
	..q:AuditInfo'="0"
	..q:AuditFlag'="完成"
	..s InsuEndAuditDate=""
	..s:AuditFlag="完成" InsuEndAuditDate=$p(INAUDInfo,"^",14)
	..s Num=Num+1
	..s:InsuEndAuditDate="" InsuEndAuditDate=+$h
	..s AdmDischdDate=$p($g(^PAADM(AdmDr)),"^",17)
	..s:AdmDischdDate="" AdmDischdDate=+$h
	..;w InsuEndAuditDate_"=="_AdmDischdDate,!

	..s days=0
	..f day=AdmDischdDate:1:InsuEndAuditDate  d
	...i $d(^DHCANCAPPDATE(day)) d
	....s day1=$zd(day,10)			;星期几
	....i (day1=0)!(day1=6) d
	.....s days=days+1
	...e  d
	....s day1=$zd(day,10)
	....i (day1'=0)&(day1'=6) d
	.....s days=days+1
	..b
	..;add by zhangdongliang at 2015-04-01 for 日期差的天数>3,不算当天，所以此处-1
	..s:days>1 days=days-1
	..s:days>3 MoreThanThreeDays=MoreThanThreeDays+1
	..s:+PBDr'=0 Amount=$p($g(^DHCPB(PBDr)),"^",8)	;zhan 20170317
	..s TotalAmount=TotalAmount+Amount
	..s usrname=$p(^CacheTemp("AuditReport",$j,TUserDr,tempcount),"^",1)
	
	
	.s ^CacheTemp("AuditReport1",$j,TUserDr)=usrname_"^"_Num_"^"_TotalAmount_"^"_MoreThanThreeDays  //用于导出汇总 
	.Do OutputRow

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(UserDesc,Num,TotalAmount,TUserDr,MoreThanThreeDays,$j)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.INSUAudUserReport","AuditRepDetails","63612","63614","3191","12779810")
ClassMethod AuditRepDetailsExecute(ByRef qHandle As %Binary, StartDate, EndDate, UserDr, Job) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind3=1
    i StartDate="" s StartDate=+$H
	i EndDate="" s EndDate=+$H
	s ^HH("reportdetail")=StartDate_"^"_EndDate_"^"_UserDr_"^"_Job
	i $g(UserDr)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s INAUDRowid=""
	s TabConfirmDate="",TabInsuStrAuditDate="",TabInsuEndAuditDate=""
	s k=0
	s tempid=""
	f  s tempid=$o(^CacheTemp("AuditReport",Job,UserDr,tempid))  q:tempid=""   d
	.s UserDesc=$p(^CacheTemp("AuditReport",Job,UserDr,tempid),"^",1)
	.s INAUDRowid=$p(^CacheTemp("AuditReport",Job,UserDr,tempid),"^",2)
	.s AdmDr=$p(^CacheTemp("AuditReport",Job,UserDr,tempid),"^",3)
	.s PBDr=$p(^CacheTemp("AuditReport",Job,UserDr,tempid),"^",4)
	.s TotalAmount=0,Amount=0
	.s:+PBDr'=0 Amount=$p($g(^DHCPB(PBDr)),"^",8)
	.s TotalAmount=TotalAmount+Amount
	.s TabAllAmount=TotalAmount
	.s INAUDInfo=$g(^DHCINAUD(INAUDRowid))
	.s AdmDr=$p(INAUDInfo,"^",1)
	.s Date=$p(INAUDInfo,"^",14)
	
	.;w StartDate_"^"_EndDate_"^"_Date,!
	.;q:(Date<StartDate)!(Date>EndDate)
	.s AuditFlag=$p(INAUDInfo,"^",16)
	
	.;add by zhangdongliang at 2015-03-04
	.s InsuEndAuditDate=""
	.s:AuditFlag="完成" InsuEndAuditDate=$p(INAUDInfo,"^",14)
	.s:InsuEndAuditDate="" InsuEndAuditDate=+$h
	.s DischgDate=$P(##class(web.DHCINSUPortUse).GetDischargeDateTime(AdmDr),"^",1) ;DingSH 2016-04-09
	.s AdmDischdDate=DischgDate
	.;s:AdmDischdDate="" AdmDischdDate=+$h
	.;w InsuEndAuditDate_"=="_AdmDischdDate,!
	.s days=0
	.f day=AdmDischdDate:1:InsuEndAuditDate  d
	..i $d(^DHCANCAPPDATE(day)) d
	...s day1=$zd(day,10)
    ...i (day1=0)!(day1=6) d
	....s days=days+1
	..e     d
	...s day1=$zd(day,10)
    ...i (day1'=0)&(day1'=6) d
	....s days=days+1
	.;end
	.i AdmDischdDate>InsuEndAuditDate s days=InsuEndAuditDate-AdmDischdDate
	.;add by zhangdongliang at 2015-04-01 for 日期差的天数，所以此处-1. 当日，和第二天都算作一天工作量。
	.s:days>1 days=days-1
	.s:days=0 days="1"
	.s:days<0 days="提前"_(0-days-1)_"天,注意：可能存在未审核项目" ;DingSH 2016-04-09
	
	.;add by zhangdongliang at 2015-01-09 for 增加 住院处审核完成时间   医保办完成审核时间 
	.;s INAUDPBDr=$p(INAUDInfo,"^",2)
	.s TabConfirmDate="",ConfirmDate=""
	.;;w "INAUDPBDr="_INAUDPBDr,!
	.;s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",INAUDPBDr,""))     ; 住院处审核时间
    .;i confdr'="" d
    .;.s confflag=$p(^DHCIPBillPatFeeConfirm(confdr),"^",9)
    .;.i confflag="C"  d
    .;..s ConfirmDate=$p(^DHCIPBillPatFeeConfirm(confdr),"^",6)
    .;..s:ConfirmDate'="" ConfirmDate=$zd(ConfirmDate,3)
    .;..s ConfirmTime=$p(^DHCIPBillPatFeeConfirm(confdr),"^",7)
    .;..s:ConfirmTime'="" ConfirmTime=$zt(ConfirmTime)
    .;..s TabConfirmDate=ConfirmDate_"  "_ConfirmTime
    .;..;w "TabConfirmDate="_TabConfirmDate,!
    
   
    .;add by zhangdongliang at 2015-03-04
	.s daysYBSFC=0
	.;f day=$zdh(ConfirmDate,3):1:InsuEndAuditDate d
	.;.i $d(^DHCANCAPPDATE(day)) d
	.;..s day1=$zd(day,10)
    .;..i (day1=0)!(day1=6) d
	.;...s daysYBSFC=daysYBSFC+1
	.;.e     d
	.;..s day1=$zd(day,10)
    .;..i (day1'=0)&(day1'=6) d
	.;...s daysYBSFC=daysYBSFC+1
	.;;end
	.;;add by zhangdongliang at 2015-04-01 for 日期差的天数，所以此处-1. 当日，和第二天都算作一天工作量。
	.;s:daysYBSFC>1 daysYBSFC=daysYBSFC-1
	.;s:daysYBSFC=0 daysYBSFC="1"
	
	.s daysSFCLY=0
	.;f day=AdmDischdDate:1:$zdh(ConfirmDate,3)  d
	.;.i $d(^DHCANCAPPDATE(day)) d
	.;..s day1=$zd(day,10)
    .;..i (day1=0)!(day1=6) d
	.;...s daysSFCLY=daysSFCLY+1
	.;.e     d
	.;..s day1=$zd(day,10)
    .;..i (day1'=0)&(day1'=6) d
	.;...s daysSFCLY=daysSFCLY+1
    .;;add by zhangdongliang at 2015-04-01 for 日期差的天数，所以此处-1. 当日，和第二天都算作一天工作量。
	.;s:daysSFCLY>1 daysSFCLY=daysSFCLY-1
	.;s:daysSFCLY=0 daysSFCLY="1"
    

     
    .s TempTabAuditFlag=$p(INAUDInfo,"^",16)
    .;w "TempTabAuditFlag="_TempTabAuditFlag,!
	.s:TempTabAuditFlag'="" TabAuditFlag=TempTabAuditFlag
    .s TabAuditDate=$p(INAUDInfo,"^",14)
	.s TabAuditTime=$p(INAUDInfo,"^",15)
	.s:TabAuditDate'="" TabAuditDate=##class(websys.Conversions).DateLogicalToHtml(TabAuditDate)
	.s:TabAuditTime'="" TabAuditTime=$zt(TabAuditTime)
	.;w "TabAuditDate="_TabAuditDate,!
	.s:TabAuditFlag="开始审核" TabInsuStrAuditDate=TabAuditDate_" "_TabAuditTime    ;加一列医保办开始审核时间 
	.s:TabAuditFlag="完成" TabInsuEndAuditDate=TabAuditDate_" "_TabAuditTime
	.;w "TabInsuEndAuditDate="_TabInsuEndAuditDate,!
	.;end
	
	.;w AdmDr_"^"_AuditFlag,!
	.;s AuditInfo=$p(INAUDInfo,"^",11)
	.;q:AuditInfo="1" ;明细信息退出，统计人头主信息
	.s AdmInfo=$g(^PAADM(AdmDr))
	.s PaPmiDr=$p(AdmInfo,"^",1)
	.q:PaPmiDr=""
	.s PatName=$p(^PAPER(PaPmiDr,"ALL"),"^",1)  ;姓名
	.s PatNo=$p(^PAPER(PaPmiDr,"PAT",1),"^",1)	;登记号
	.;s MrNo=$p($g(^PAPER(PaPmiDr,"PAT",1)),"^",22)	;病案号
	.;s MrNo=##class(web.DHCWMRService).IGetMrNoByPatientID(PaPmiDr) ;DingSH 2016-04-09
	.s MrNo=##class(web.DHCINSUPortUse).IGetMrNoByEpisodeID(AdmDr,"","") ;Modify DingSH 20200512
	.s DepCodeDR=$p(AdmInfo,"^",4)
	.s DepName=$p(^CTLOC(DepCodeDR),"^",2)  ;科室名称
	.s:$l(DepName,"-")>1 DepName=$p(DepName,"-",2)
	.;s MRADMDR=$p($g(^PAADM(AdmDr)),"^",61)
	.s AdmReasonDr=$P($g(^PAADM(AdmDr,1)),"^",7)
	.q:AdmReasonDr=""
	.s TabPatType=$P($G(^PAC("ADMREA",AdmReasonDr)),"^",2)			;病人类型
	.;-st DingSH 2016-04-09
	.;s TabDiagDesc=$$GetDiagnosInfoByAdmDr^DHCINSUFacadeBJ(AdmDr)	;诊断
	.;s DiagDesc=$p(TabDiagDesc,"!",1)
	.;s DiagDesc=$p(TabDiagDesc,"^",3)
	.s PatDiagAll=##class(web.DHCINSUPortUse).GetPatAllDiagsByADM(AdmDr,"")	;DingSH 20160409
	.//s PatDiagAll="" 
	.s Cnt=$l(PatDiagAll,"$")
	.f i=1:1:Cnt  d
	..s tmpDiagDesc=""
    ..s tmpDiagDesc=$P($P(PatDiagAll,"$",i),"^",14)_$P($P(PatDiagAll,"$",i),"^",4)_$P($P(PatDiagAll,"$",i),"^",5)
    ..s:tmpDiagDesc="" tmpDiagDesc=$P($P(PatDiagAll,"$",i),"^",14)_$P($P(PatDiagAll,"$",i),"^",5) ;对非标准诊断判断
    ..i i=1 d 
    ...s DiagDesc=tmpDiagDesc 
    ..e  d 
    ...s DiagDesc=DiagDesc_" , "_tmpDiagDesc
	.;s InDate=$zd($p(AdmInfo,"^",6),3)
	.s InDate=$zd($P(##class(web.DHCINSUPortUse).GetAdminDateTime(AdmDr),"^",1),3)
	.;s DischgDate=$p(AdmInfo,"^",17)
	.s:DischgDate'="" DischgDate=$zd(DischgDate,3)  ;离院时间
    .s k=k+1
    
    .;add by zhangdongliang at 2015-10-14 for 标准版测试数据有问题，此处增加友好提示
    .i DischgDate="" s days="未做出院登记"
    .i +PBDr=0 d
    ..s TabAllAmount="PBDr="_PBDr_"不存在"
    .e  d
    ..i $d(^DHCPB(PBDr))=0 s TabAllAmount="PBDr="_PBDr_"不存在"
    .s ^CacheTemp("AuditReport1",Job,UserDr,k)=PatNo_"^"_PatName_"^"_DepName_"^"_DiagDesc_"^"_InDate_"^"_DischgDate_"^"_TabAllAmount_"^"_MrNo_"^"_TabConfirmDate_"^"_TabInsuEndAuditDate_"^"_days_"^"_daysYBSFC_"^"_daysSFCLY  //用于导出统计明细
    .Do OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	i InDate'="" d
	.s tmpInDate=$zdh(InDate,3)
	.s InDate=##class(websys.Conversions).DateLogicalToHtml(tmpInDate)
	i DischgDate'="" d
	.s tmpDischgDate=$zdh(DischgDate,3)
	.s DischgDate=##class(websys.Conversions).DateLogicalToHtml(tmpDischgDate)
	set Data=$lb(PatNo,PatName,DepName,AdmReason,DiagDesc,InDate,DischgDate,TabAllAmount,MrNo,TabConfirmDate,TabInsuEndAuditDate,days,daysYBSFC,daysSFCLY)
 	Set ^CacheTemp(repid,ind3)=Data
 	Set ind3=ind3+1
	quit
}

}
