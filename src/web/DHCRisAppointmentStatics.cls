Import SQLUser

Class web.DHCRisAppointmentStatics Extends %RegisteredObject
{

/// 函数： QueryWardAppointmentInfo
/// 查询病区预约信息
/// 作者： gongping
/// 日期： 2015-01-05
Query QueryWardAppointmentInfo(WardId As %String, StartDate As %String, EndDate As %String, ckItemName As %String) As %Query(ROWSPEC = "WardName:%String,BedNo:%String,RegNo:%String,Name:%String,SexDesc:%String,DOB:%String,strOrderName:%String,strDate:%String,strTime:%String,AppointDate:%String,AppointTime:%String,strRegDate:%String,strRegTime:%String,GetRptDate:%String,GetRptTime:%String,AverageTime:%String")
{
}

ClassMethod QueryWardAppointmentInfoExecute(ByRef qHandle As %Binary, WardId As %String, StartDate As %String, EndDate As %String, ckItemName As %String) As %Status
{

  Set repid=$I(^CacheTemp)
  If $g(ind)="" Set ind=1
  
   if WardId="" Set qHandle=$lb(0,repid,0)
 Quit:WardId="" $$$OK 
  
 if (ckItemName="on")
 { 
  k ^TMPArcimTime
  s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s Gettype=$p(^CTLOC(LocId),"^",13)
 .q:Gettype'="E"
 .q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId))
 .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId)) q:ResourceId=""  d
 ..f date=StartDate:1:EndDate  d
 ...q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date))
 ...s AppId=0 f  s AppId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date,AppId)) q:AppId=""  d
 ....s AppDrowid=0  f  s AppDrowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,AppId,AppDrowid)) q:AppDrowid=""  d
 .....s EpsoideId=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",3) 
 .....s CurrentWardId=$p(^PAADM(EpsoideId),"^",70)
 .....q:CurrentWardId'=WardId
 .....s (WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)=""
 .....s WardName=$p(^PAWARD(CurrentWardId),"^",2)
 .....s CurrentBedNoID=$p(^PAADM(EpsoideId),"^",73)
 .....s BedNo=""
 .....i CurrentBedNoID'=""  d 
 ......s wardrowid=$p(CurrentBedNoID,"||",1)
 ......s bedchildsub=$p(CurrentBedNoID,"||",2)
 ......i $g(bedchildsub)'="" s BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
 .....s papatmasmdr=$p(^PAADM(EpsoideId),"^",1)
 .....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
 .....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
 .....s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
 .....i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)       
 .....s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
 .....s OrditemRowid=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",1) 
 .....s OrderRowid=$p(OrditemRowid,"||",1)
 .....s itemsub=$p(OrditemRowid,"||",2) 
 .....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
 .....s strDate=$zd(Date1,3)
 .....s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
 .....s strTime=$zt(Time1,1)
 .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
 .....s iAppointDate=$p(^DHCRBCResourceSchdule(AppId),"^",2)      ;预约日期
 .....i iAppointDate'="" s AppointDate=$zd(iAppointDate,3)
 .....s iAppointTime=$p(^DHCRBCResourceSchdule(AppId),"^",5) ;预约时间
 .....i iAppointTime'=""  s AppointTime=$zt(iAppointTime,3) 
 .....s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrditemRowid,0))
 .....i RegRowid'="" d
 ......s RegDate=$p(^DHCPACRegInfo(RegRowid),"^",8)
 ......i RegDate'="" s strRegDate=$zd(RegDate,3)
 ......s RegTime=$p(^DHCPACRegInfo(RegRowid),"^",9)
 ......i RegTime'="" s strRegTime=$zt(RegTime,1)
 ......s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
 ......s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
 ......i Rptrowid'="" d 
 .......s iRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 .......i iRptDate'="" s GetRptDate=$zd(iRptDate,3)
 .......s iRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 .......i iRptTime'="" s GetRptTime=$zt(iRptTime,3) 
 .......s AverageTime=..CalTimeLenght(Date1,Time1,iRptDate,iRptTime)
 .......i $g(^TMPArcimTime(arcimid))="" d
 ........s ^TMPArcimTime(arcimid)=AverageTime_"^"_1
 .......else  d
 ........s GetAverageTime=$p(^TMPArcimTime(arcimid),"^",1)
 ........s GetNum=$p(^TMPArcimTime(arcimid),"^",2)
 ........s GetNum=GetNum+1
 ........s GetAverageTime=(GetAverageTime+AverageTime)/GetNum
 ........s ^TMPArcimTime(arcimid)=GetAverageTime_"^"_GetNum
 
   Do OutRow1
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
OutRow1
    s ArcimRowid=0  f  s ArcimRowid=$o(^TMPArcimTime(ArcimRowid)) q:ArcimRowid=""  d
    .s strOrderName=$p(^ARCIM($p(ArcimRowid,"||",1),$p(ArcimRowid,"||",2),1),"^",2) 
    .s GetAverageTime=$p(^TMPArcimTime(ArcimRowid),"^",1) 
	.set Data=$lb(WardName,"","","","","",strOrderName,"","","","","","","","",GetAverageTime)
  	.Set ^CacheTemp(repid,ind)=Data
  	.Set ind=ind+1
	quit
 }
 else
 {
 

 
 s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s Gettype=$p(^CTLOC(LocId),"^",13)
 .q:Gettype'="E"
 .q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId))
 .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId)) q:ResourceId=""  d
 ..f date=StartDate:1:EndDate  d
 ...q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date))
 ...s AppId=0 f  s AppId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date,AppId)) q:AppId=""  d
 ....s AppDrowid=0  f  s AppDrowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,AppId,AppDrowid)) q:AppDrowid=""  d
 .....s EpsoideId=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",3) 
 .....s CurrentWardId=$p(^PAADM(EpsoideId),"^",70)
 .....q:CurrentWardId'=WardId
 .....s (WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)=""
 .....s WardName=$p(^PAWARD(CurrentWardId),"^",2)
 .....s CurrentBedNoID=$p(^PAADM(EpsoideId),"^",73)
 .....s BedNo=""
 .....i CurrentBedNoID'=""  d 
 ......s wardrowid=$p(CurrentBedNoID,"||",1)
 ......s bedchildsub=$p(CurrentBedNoID,"||",2)
 ......i $g(bedchildsub)'="" s BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
 .....s papatmasmdr=$p(^PAADM(EpsoideId),"^",1)
 .....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
 .....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
 .....s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
 .....i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)       
 .....s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
 .....s OrditemRowid=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",1) 
 .....s OrderRowid=$p(OrditemRowid,"||",1)
 .....s itemsub=$p(OrditemRowid,"||",2) 
 .....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
 .....s strDate=$zd(Date1,3)
 .....s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
 .....s strTime=$zt(Time1,1)
 .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
 .....s iAppointDate=$p(^DHCRBCResourceSchdule(AppId),"^",2)      ;预约日期
 .....i iAppointDate'="" s AppointDate=$zd(iAppointDate,3)
 .....s iAppointTime=$p(^DHCRBCResourceSchdule(AppId),"^",5) ;预约时间
 .....i iAppointTime'=""  s AppointTime=$zt(iAppointTime,3) 
 .....s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrditemRowid,0))
 .....i RegRowid'="" d
 ......s RegDate=$p(^DHCPACRegInfo(RegRowid),"^",8)
 ......i RegDate'="" s strRegDate=$zd(RegDate,3)
 ......s RegTime=$p(^DHCPACRegInfo(RegRowid),"^",9)
 ......i RegTime'="" s strRegTime=$zt(RegTime,1)
 ......s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
 ......s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
 ......i Rptrowid'="" d 
 .......s iRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 .......i iRptDate'="" s GetRptDate=$zd(iRptDate,3)
 .......s iRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 .......i iRptTime'="" s GetRptTime=$zt(iRptTime,3) 
 .......s AverageTime=..CalTimeLenght(Date1,Time1,iRptDate,iRptTime)   
 .....Do OutRow
 
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
OutRow
	set Data=$lb(WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
 }
}

ClassMethod QueryWardAppointmentInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardAppointmentInfoExecute ]
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

ClassMethod QueryWardAppointmentInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardAppointmentInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数： QueryAppointTypeNumber
/// 查询病区预约类型数
/// 作者： gongping
/// 日期： 2015-01-05
Query QueryAppointTypeNumber(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "WardName:%String,AutoNumber:%String,ManulNumber:%String,Total:%String")
{
}

ClassMethod QueryAppointTypeNumberExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{

  Set repid=$I(^CacheTemp)
  If $g(ind)="" Set ind=1
 
  k ^TMPWardInfo
  s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s Gettype=$p(^CTLOC(LocId),"^",13)
 .q:Gettype'="E"
 .q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId))
 .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId)) q:ResourceId=""  d
 ..f date=StartDate:1:EndDate  d
 ...q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date))
 ...s AppId=0 f  s AppId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date,AppId)) q:AppId=""  d
 ....s AppDrowid=0  f  s AppDrowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,AppId,AppDrowid)) q:AppDrowid=""  d
 .....s EpsoideId=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",3) 
 .....s CurrentWardId=$p(^PAADM(EpsoideId),"^",70)
 .....q:(CurrentWardId="")
 .....s (WardName,strOrderName,AutoNumber,ManualNumber,TotalNumber)=""
 .....s WardName=$p(^PAWARD(CurrentWardId),"^",2)
 .....s OrditemRowid=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",1) 
 .....s OrderRowid=$p(OrditemRowid,"||",1)
 .....s itemsub=$p(OrditemRowid,"||",2) 
 .....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .....s ItemBookProperTypeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
 .....s AppointMethodRowid=$p(^DHCRBCItemBookProperty(ItemBookProperTypeRowid),"^",2)
 .....s AutoNumber=$p($g(^TMPWardInfo(CurrentWardId)),"^",1)
 .....s ManuNumber=$p($g(^TMPWardInfo(CurrentWardId)),"^",2)
 .....s TotalNumber=$p($g(^TMPWardInfo(CurrentWardId)),"^",3)
 .....i AutoNumber="" s AutoNumber=0
 .....i ManuNumber="" s ManuNumber=0
 .....i TotalNumber="" s TotalNumber=0
 .....s AppMothodDesc=$p(^DHCRBCAppointMethod(AppointMethodRowid),"^",2)
 .....i AppMothodDesc="自动预约"  d
 ......s AutoNumber=AutoNumber+1
 .....else  d
 ......s ManuNumber=ManuNumber+1
 .....s TotalNumber=AutoNumber+ManuNumber
 .....s ^TMPWardInfo(CurrentWardId)=AutoNumber_"^"_ManuNumber_"^"_TotalNumber
 Do OutRow2
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
   
OutRow2
     s WardRowid=0  f  s WardRowid=$o(^TMPWardInfo(WardRowid)) q:WardRowid=""  d
     .s WardName=$p($g(^PAWARD(WardRowid)),"^",2)     
     .s AutoNumber=$p($g(^TMPWardInfo(WardRowid)),"^",1) 
     .s ManulNumber=$p($g(^TMPWardInfo(WardRowid)),"^",2) 
     .s TotalNumber=$p($g(^TMPWardInfo(WardRowid)),"^",2) 
	 .set Data=$lb(WardName,AutoNumber,ManulNumber,TotalNumber)
  	 .Set ^CacheTemp(repid,ind)=Data
  	 .Set ind=ind+1
      quit
}

ClassMethod QueryAppointTypeNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppointTypeNumberExecute ]
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

ClassMethod QueryAppointTypeNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppointTypeNumberExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// CalTimeLenght计算两个时间的差
/// s ret=##classMethod(web.DHCRisAppointmentStatics).(
ClassMethod CalTimeLenght(StartDate As %String, StartTime As %String, EndDate As %String, EndTime As %String) As %String
{
	
	s DiffDateTime=((EndDate*24*60*60+EndTime)-(StartDate*24*60*60+StartTime))/60/60
	q DiffDateTime
}

/*
///函数：QueryItemDetail
///功能：查询病区检查项目时间
ClassMethod QueryItemDetail(WardId As %String, StartDate As %String, EndDate As %String) As %Integer
{
 // Set repid=$I(^CacheTemp)
 // If $g(ind)="" Set ind=1

 if WardId="" Set qHandle=$lb(0,repid,0)
 Quit:WardId="" $$$OK 
 
 s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s Gettype=$p(^CTLOC(LocId),"^",13)
 .q:Gettype'="E"
 .q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId))
 .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId)) q:ResourceId=""  d
 ..f date=StartDate:1:EndDate  d
 ...q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date))
 ...s AppId=0 f  s AppId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date,AppId)) q:AppId=""  d
 ....s AppDrowid=0  f  s AppDrowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,AppId,AppDrowid)) q:AppDrowid=""  d
 .....s EpsoideId=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",3) 
 .....s CurrentWardId=$p(^PAADM(EpsoideId),"^",70)
 .....q:CurrentWardId'=WardId
 .....s (WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)=""
 .....s WardName=$p(^PAWARD(CurrentWardId),"^",2)
 .....s CurrentBedNoID=$p(^PAADM(EpsoideId),"^",73)
 .....s BedNo=""
 .....i CurrentBedNoID'=""  d 
 ......s wardrowid=$p(CurrentBedNoID,"||",1)
 ......s bedchildsub=$p(CurrentBedNoID,"||",2)
 ......i $g(bedchildsub)'="" s BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
 .....s papatmasmdr=$p(^PAADM(EpsoideId),"^",1)
 .....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
 .....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
 .....s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
 .....i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)       
 .....s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
 .....s OrditemRowid=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",1) 
 .....s OrderRowid=$p(OrditemRowid,"||",1)
 .....s itemsub=$p(OrditemRowid,"||",2) 
 .....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
 .....s strDate=$zd(Date1,3)
 .....s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
 .....s strTime=$zt(Time1,1)
 .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
 .....s iAppointDate=$p(^DHCRBCResourceSchdule(AppId),"^",2)      ;预约日期
 .....i iAppointDate'="" s AppointDate=$zd(iAppointDate,3)
 .....s iAppointTime=$p(^DHCRBCResourceSchdule(AppId),"^",5) ;预约时间
 .....i iAppointTime'=""  s AppointTime=$zt(iAppointTime,3) 
 .....s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrditemRowid,0))
 .....i RegRowid'="" d
 ......s RegDate=$p(^DHCPACRegInfo(RegRowid),"^",8)
 ......i RegDate'="" s strRegDate=$zd(RegDate,3)
 ......s RegTime=$p(^DHCPACRegInfo(RegRowid),"^",9)
 ......i RegTime'="" s strRegTime=$zt(RegTime,1)
 ......s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
 ......s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
 ......i Rptrowid'="" d 
 .......s iRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 .......i iRptDate'="" s GetRptDate=$zd(iRptDate,3)
 .......s iRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 .......i iRptTime'="" s GetRptTime=$zt(iRptTime,3) 
 .......s AverageTime=..CalTimeLenght(iAppointDate, iAppointTime,iRptDate,iRptTime)   
 .....Do OutRow
 
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
OutRow
	set Data=$lb(WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}

///函数：QueryItemDetail
///功能：查询病区检查项目完成时间
ClassMethod QueryItemTotal(WardId As %String, StartDate As %String, EndDate As %String)
{
 s LocId=0 f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
 .s Gettype=$p(^CTLOC(LocId),"^",13)
 .q:Gettype'="E"
 .q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId))
 .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId)) q:ResourceId=""  d
 ..f date=StartDate:1:EndDate  d
 ...s ^TMP1=WardId_"^"_StartDate_"^"_EndDate_"^"_ckItemName_"^"_LocId_"^"_ResourceId
 ...q:'$d(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date))
 ...s AppId=0 f  s AppId=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,date,AppId)) q:AppId=""  d
 ....s AppDrowid=0  f  s AppDrowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,AppId,AppDrowid)) q:AppDrowid=""  d
 .....s EpsoideId=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",3) 
 .....s CurrentWardId=$p(^PAADM(EpsoideId),"^",70)
 .....q:CurrentWardId'=WardId
 .....s (WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)=""
 .....s WardName=$p(^PAWARD(CurrentWardId),"^",2)
 .....s CurrentBedNoID=$p(^PAADM(EpsoideId),"^",73)
 .....s BedNo=""
 .....i CurrentBedNoID'=""  d 
 ......s wardrowid=$p(CurrentBedNoID,"||",1)
 ......s bedchildsub=$p(CurrentBedNoID,"||",2)
 ......i $g(bedchildsub)'="" s BedNo=$p($g(^PAWARD(wardrowid,"BED",bedchildsub)),"^",1)
 .....s papatmasmdr=$p(^PAADM(EpsoideId),"^",1)
 .....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
 .....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1) 
 .....s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
 .....i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)       
 .....s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
 .....s OrditemRowid=$p(^DHCRBCResSchduleDetail("Detail",AppDrowid),"^",1) 
 .....s OrderRowid=$p(OrditemRowid,"||",1)
 .....s itemsub=$p(OrditemRowid,"||",2) 
 .....s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
 .....s Date1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",9)  ;医嘱日期 OEORI_Date
 .....s strDate=$zd(Date1,3)
 .....s Time1=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",17) ;医嘱的开始时间
 .....s strTime=$zt(Time1,1)
 .....s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
 .....s iAppointDate=$p(^DHCRBCResourceSchdule(AppId),"^",2)      ;预约日期
 .....i iAppointDate'="" s AppointDate=$zd(iAppointDate,3)
 .....s iAppointTime=$p(^DHCRBCResourceSchdule(AppId),"^",5) ;预约时间
 .....i iAppointTime'=""  s AppointTime=$zt(iAppointTime,3) 
 .....s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrditemRowid,0))
 .....i RegRowid'="" d
 ......s RegDate=$p(^DHCPACRegInfo(RegRowid),"^",8)
 ......i RegDate'="" s strRegDate=$zd(RegDate,3)
 ......s RegTime=$p(^DHCPACRegInfo(RegRowid),"^",9)
 ......i RegTime'="" s strRegTime=$zt(RegTime,1)
 ......s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
 ......s Rptrowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
 ......i Rptrowid'="" d 
 .......s iRptDate=$p(^DHCRBStudy("Report",Rptrowid),"^",9)
 .......i iRptDate'="" s GetRptDate=$zd(iRptDate,3)
 .......s iRptTime=$p(^DHCRBStudy("Report",Rptrowid),"^",10)
 .......i iRptTime'="" s GetRptTime=$zt(iRptTime,3) 
 .......s AverageTime=..CalTimeLenght(iAppointDate, iAppointTime,iRptDate,iRptTime)   
 .....Do OutRow1
 
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
   
OutRow1
	set Data=$lb(WardName,BedNo,RegNo,Name,SexDesc,DOB,strOrderName,strDate,strTime,AppointDate,AppointTime,strRegDate,strRegTime,GetRptDate,GetRptTime,AverageTime)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	quit
}
*/
}
