Import SQLUser

Class web.DHCRisStaticsReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 222;

Query StaticsByYearMonth(StDate As %String, EndDate As %String, LocID As %String, QueryType As %String) As %Query(ROWSPEC = "TTime:%String,TDevice1Count:%Integer,TDevice1Fee:%Integer,TDevice2Count:%Integer,TDevice2Fee:%Integer,TDevice3Count:%Integer,TDevice3Fee:%Integer,TDevice4Count:%Integer,TDevice4Fee:%Integer,TDevice5Count:%Integer,TDevice5Fee:%Integer,TDevice6Count:%Integer,TDevice6Fee:%Integer")
{
}

ClassMethod StaticsByYearMonthExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, QueryType As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TMP("RIS",33)=StDate_"^"_EndDate_"^"_LocID_"^"_QueryType
 
  	if StDate="" s StDate=+$h
    if EndDate="" s EndDate=+$h
    if LocID="" s LocID=%session.Data("LOGON.CTLOCID")
    
    if QueryType="2"  
    {
	    s return=..StaticsByMonth(StDate,EndDate,LocID)
	}
    else
    {
	    s return=..QueryByDate(StDate,EndDate,LocID)
	    
    }
    Quit $$$OK
}

ClassMethod StaticsByYearMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StaticsByYearMonthExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StaticsByYearMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StaticsByYearMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByDate(StDate As %String, EndDate As %String, LocID As %String) As %String
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 
  	if StDate="" s StDate=+$h
    if EndDate="" s EndDate=+$h
    if LocID="" s LocID=%session.Data("LOGON.CTLOCID")
    s ^DHCRISLocEQList(LocID)=0 
    k ^tmpRISStaStudyNo
    d ..KillGlobal(StDate,EndDate,LocID)
    Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s EQDR=$p(^RB("RES",RowId),"^",3)
	.s DateActiveTo=$p(^RB("RES",RowId),"^",23)
	.q:DateActiveTo'=""      //设置结束日期的设备不进行统计
	.i EQDR'="" d
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	..s TotalEQNums(LocID,EQDR)=0
	..s TotalEQInCome(LocID,EQDR)=0
	..f rptdate=StDate:1:EndDate d 
	...s ^DHCRISLocEQList(LocID,EQDR)=ResDesc
	...s ^DHCRISLocEQList(LocID)=^DHCRISLocEQList(LocID)+1
	...s ^DHCRISDayStatics(LocID,EQDR,rptdate,1)=0  //收入
	...s ^DHCRISDayStatics(LocID,EQDR,rptdate,2)=0  //检查人数

    f rptdate=StDate:1:EndDate d 
	.;Set RowId=0 f  s RowId=$o(^DHCRBStudyi("ReportDate",rptdate,RowId)) q:RowId=""  d
	.Set RegRowid=0	f  s RegRowid=$o(^DHCPACRegInfoi("RegDate",rptdate,RegRowid)) q:RegRowid=""  d
	..s StudyNo=$p($g(^DHCPACRegInfo(RegRowid)),"^",2)
	..s reglocdr=$p($g(^DHCPACRegInfo(RegRowid)),"^",13)
	..s paadmdr=$p($g(^DHCPACRegInfo(RegRowid)),"^",10)
	..q:reglocdr'=LocID
	..s EQDR=$p(^DHCPACRegInfo(RegRowid),"^",14)
	..q:EQDR=""
    ..s InCome=$g(^DHCRISDayStatics(LocID,EQDR,rptdate,1))
    ..s PNums=$g(^DHCRISDayStatics(LocID,EQDR,rptdate,2))
    ..;按检查号统计，已经统计过的检查号不在统计
    ..i $g(^tmpRISStaStudyNo(EQDR,StudyNo))="" d
    ...s ^tmpRISStaStudyNo(EQDR,StudyNo)=1
    ...s PNums=PNums+1
    ..s OeordDR=$p(^DHCPACRegInfo(RegRowid),"^",11) 
	..q:((OeordDR="")!(OeordDR=$c(0)))
	..s Ordrowid=$p(OeordDR,"||",1)
	..s OrdItemrowid=$p(OeordDR,"||",2)
	..s SttDate=$p(^OEORD(Ordrowid,"I",OrdItemrowid,3),"^",7)  
	..s arcimid=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",2)
	..s price=##class(web.DHCRisCommFunction).GetItemPrice(OeordDR)
	..;s priceinfo=##class(web.UDHCJFPRICE).GetOrderPrice("", "", arcimid, SttDate, "", "", "", "")
	..;s price=$p(priceinfo,"^",1)
	..s Num=$p(^OEORD(Ordrowid,"I",OrdItemrowid,1),"^",12)
	..s perTotalPrice=price*Num
    ..s InCome=InCome+perTotalPrice
    ..s ^DHCRISDayStatics(LocID,EQDR,rptdate,1)=InCome
    ..s ^DHCRISDayStatics(LocID,EQDR,rptdate,2)=PNums
 
    do OutputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1    
    s ind=1
    s TotalEQNums=0,TotalEQInCome=0,Data="",Data1=""
    s EQInfoHead=""
    s EQDR=0 f  s EQDR=$o(^DHCRISLocEQList(LocID,EQDR)) q:EQDR=""  d
    .i EQInfoHead="" d
    ..s EQInfoHead=$lb("",^DHCRISLocEQList(LocID,EQDR))
    .else  d 
    ..s EQInfoHead=EQInfoHead_$lb("",^DHCRISLocEQList(LocID,EQDR))
   
    s ^CacheTemp(repid,1)=$lb("")_EQInfoHead
    s ind=2
    f rptdate=StDate:1:EndDate d 
    .s Data="",Data1=""
    .s EQDR=0 f  s EQDR=$o(^DHCRISLocEQList(LocID,EQDR)) q:EQDR=""  d
    ..s InCome=$g(^DHCRISDayStatics(LocID,EQDR,rptdate,1))
    ..s Num=$g(^DHCRISDayStatics(LocID,EQDR,rptdate,2))   
    ..s EQInfo=$lb(Num,InCome)
    ..i Data="" d 
    ...s Data=EQInfo
    ..else  d
    ...s Data=Data_EQInfo
    ..;进行合计 
    ..s TotalEQInCome(LocID,EQDR)=$g(TotalEQInCome(LocID,EQDR))+$g(^DHCRISDayStatics(LocID,EQDR,rptdate,1))
    ..s TotalEQNums(LocID,EQDR)=$g(TotalEQNums(LocID,EQDR))+$g(^DHCRISDayStatics(LocID,EQDR,rptdate,2))
    ..s Month=$p($zd(rptdate,3),"-",2)
    ..s year=$p($zd(rptdate,3),"-",1)
    ..s strMonth=year_"-"_Month
    ..;按月累计 
    ..i $g(^DHCRISMonthStatics(LocID,EQDR,strMonth,1))=""  s ^DHCRISMonthStatics(LocID,EQDR,strMonth,1)=0 
    ..s ^DHCRISMonthStatics(LocID,EQDR,strMonth,1)=$g(^DHCRISMonthStatics(LocID,EQDR,strMonth,1))+$g(^DHCRISDayStatics(LocID,EQDR,rptdate,1))
    ..i $g(^DHCRISMonthStatics(LocID,EQDR,strMonth,2))=""  s ^DHCRISMonthStatics(LocID,EQDR,strMonth,2)=0
    ..s ^DHCRISMonthStatics(LocID,EQDR,strMonth,2)=$g(^DHCRISMonthStatics(LocID,EQDR,strMonth,2))+$g(^DHCRISDayStatics(LocID,EQDR,rptdate,2))
    ..s TotalEQInfo=$lb($g(TotalEQNums(LocID,EQDR)),$g(TotalEQInCome(LocID,EQDR)))
    ..i Data1="" d
    ...s Data1=TotalEQInfo
    ..else  d
    ...s Data1=Data1_TotalEQInfo
    .s Data=$lb($zd(rptdate,3))_Data
     
    .Set ^CacheTemp(repid,ind)=Data
    .Set ^CacheTemp(repid,ind+1)=$lb("合计")_Data1
    .Set ind=ind+1
	quit
}

ClassMethod StaticsByMonth(StDate As %String, EndDate As %String, LocID As %String) As %String
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s PrestrMonth="",Data="",Data1=""
    k ^tmpRisMonth
    f rptdate=StDate:1:EndDate d 
    .s Month=$p($zd(rptdate,3),"-",2)
    .s Year=$p($zd(rptdate,3),"-",1)
    .s strMonth=Year_"-"_Month
    .s ^tmpRisMonth(strMonth)=strMonth
    
    s ind=1
    s TotalEQNums=0,TotalEQInCome=0,Data="",Data1=""
    s EQInfoHead=""
    s EQDR=0 f  s EQDR=$o(^DHCRISLocEQList(LocID,EQDR)) q:EQDR=""  d
    .i EQInfoHead="" d
    ..s EQInfoHead=$lb("",^DHCRISLocEQList(LocID,EQDR))
    .else  d 
    ..s EQInfoHead=EQInfoHead_$lb("",^DHCRISLocEQList(LocID,EQDR))
    s ^CacheTemp(repid,1)=$lb("")_EQInfoHead
 
    s ind=2
    s strMonth="" f  s strMonth=$o(^tmpRisMonth(strMonth)) q:strMonth=""  d
    .;w !,"strMoth"_^tmpRisMonth(strMonth)
    .s Data="",Data1=""
    .s EQDR=0 f  s EQDR=$o(^DHCRISLocEQList(LocID,EQDR)) q:EQDR=""  d
    ..s InCome=$g(^DHCRISMonthStatics(LocID,EQDR,strMonth,1))
    ..s Num=$g(^DHCRISMonthStatics(LocID,EQDR,strMonth,2))  
    ..s EQInfo=$lb(InCome,Num)
    ..i Data="" d 
    ...s Data=EQInfo
    ..else  d
    ...s Data=Data_EQInfo
    ..;进行合计 
    ..i $g(TotalEQNums(LocID,EQDR))="" s TotalEQNums(LocID,EQDR)=0
    ..i $g(TotalEQInCome(LocID,EQDR))="" s TotalEQInCome(LocID,EQDR)=0
    ..s TotalEQNums(LocID,EQDR)=TotalEQNums(LocID,EQDR)+^DHCRISMonthStatics(LocID,EQDR,strMonth,1)
    ..s TotalEQInCome(LocID,EQDR)=TotalEQInCome(LocID,EQDR)+^DHCRISMonthStatics(LocID,EQDR,strMonth,2)
    ..s TotalEQInfo=$lb(TotalEQNums(LocID,EQDR),TotalEQInCome(LocID,EQDR))
    ..i Data1="" d
    ...s Data1=TotalEQInfo
    ..else  d
    ...s Data1=Data1_TotalEQInfo
    .s Data=$lb(strMonth)_Data
    .do OutputRow2
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    S ^CacheTemp(repid,ind)=Data
    S ^CacheTemp(repid,ind+1)=$lb("合计")_Data1
    S ind=ind+1
	quit
}

ClassMethod GetEQNameByEQ(LocID As %String) As %String
{
	s EQDesc=""
	Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s EQDR=$p(^RB("RES",RowId),"^",3)
	.i EQDR'="" d
	..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
    ..s EQDesc=EQDesc_"^"_ResDesc
    q EQDesc
}

ClassMethod KillGlobal(StDate As %String, EndDate As %String, LocID As %String) As %String
{

    Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
	.s EQDR=$p(^RB("RES",RowId),"^",3)
	.s DateActiveTo=$p(^RB("RES",RowId),"^",23)
	.q:DateActiveTo'=""      //设置结束日期的设备不进行统计
	.i EQDR'="" d
	..f rptdate=StDate:1:EndDate d 
    ...k ^DHCRISDayStatics(LocID,EQDR,rptdate)
    ...s Month=$p($zd(rptdate,3),"-",2)
    ...s year=$p($zd(rptdate,3),"-",1)
    ...s strMonth=year_"-"_Month
    ...k ^DHCRISMonthStatics(LocID,EQDR,strMonth)
}

}
