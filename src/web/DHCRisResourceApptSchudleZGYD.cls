Import SQLUser

/// 资源计划
Class web.DHCRisResourceApptSchudleZGYD Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//查询资源组信息

/// 函数：QueryResourceWeekPlan
/// 功能：查询资源的星期计划
Query QueryResourceWeekPlan(LocId As %String, ResourceId As %String) As %Query(ROWSPEC = "TWEEK:%String,TServiceGroup:%String,TTimeDesc:%String,TStartTime:%String,TEndTime:%String,TMax:%String,TAutoNumber:%String,TRowid:%String,TWeekNum:%String,TSerivceGourpId:%String,TTimePeriodCode:%String,TChargTime:%String")
{
}

ClassMethod QueryResourceWeekPlanExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ResourceId="" s qHandle=$lb(0,repid,0)
	Quit:ResourceId="" $$$OK
	
	i LocId="" s qHandle=$lb(0,repid,0)
	Quit:LocId="" $$$OK
	
	s ^TMPQ=LocId_"^"_ResourceId
	
	Set RowId=0	f  s RowId=$o(^DHCRBCResourcePlani("LocId",LocId,ResourceId,RowId)) q:RowId=""  d
	.s (TimeDesc,ServiceGroup)=""
	.s WeekNumber=$p(^DHCRBCResourcePlan(RowId),"^",7)
	.s Week=..GetWeek(WeekNumber)
	.s ServiceGroupID=$p(^DHCRBCResourcePlan(RowId),"^",3)
	.i ServiceGroupID'="" d
	..s ServiceGroup=$p(^RBC("SG",ServiceGroupID),"^",2)
	.s TimePeriodCode=$p(^DHCRBCResourcePlan(RowId),"^",4)  //时间段代码
	.i TimePeriodCode'="" d
	..s TimeDesc=..GetTimePeriodDesc(TimePeriodCode)
	.s StartTime=$p(^DHCRBCResourcePlan(RowId),"^",5)
	.s StartTime=$zt(StartTime)
	.s EndTime=$p(^DHCRBCResourcePlan(RowId),"^",6)
	.s EndTime=$zt(EndTime)
	.s Max=$p(^DHCRBCResourcePlan(RowId),"^",8)
    .s AutoNumber=$p(^DHCRBCResourcePlan(RowId),"^",9)
    .s ChargeTime=$p(^DHCRBCResourcePlan(RowId),"^",10)
    .i ChargeTime'="" s ChargeTime=$zt(ChargeTime)

    .Do OutRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(Week,ServiceGroup,TimeDesc,StartTime,EndTime,Max,AutoNumber,RowId,WeekNumber,ServiceGroupID,TimePeriodCode,ChargeTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceWeekPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceWeekPlanExecute ]
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

ClassMethod QueryResourceWeekPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceWeekPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：QueryTimePeriod
/// 功能：查询时间段
/// 
Query QueryTimePeriod() As %Query(ROWSPEC = "Code:%String,Desc:%String,RowId:%String")
{
}

ClassMethod QueryTimePeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	Set RowId=0	f  s RowId=$o(^DHCRBCTimePeriodSet(RowId)) q:RowId=""  d
	.s Code=$p(^DHCRBCTimePeriodSet(RowId),"^",1)
	.s Desc=$p(^DHCRBCTimePeriodSet(RowId),"^",2)
    .Do OutRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow1
	set Data=$lb(Code,Desc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryTimePeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTimePeriodExecute ]
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

ClassMethod QueryTimePeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTimePeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：QueryWeek
/// 功能：查询星期
/// 作者： gongping
/// 日期： 2011-08-04 
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryWeek")
Query QueryWeek() As %Query(ROWSPEC = "Name:%String,Sequence:%String,RowId:%String")
{
}

ClassMethod QueryWeekExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// CT_DayOfWeek
	Set RowId=0	f  s RowId=$o(^CT("DOW",1,RowId)) q:RowId=""  d
	.s Name=$p(^CT("DOW",1,RowId),"^",1)
	.s Sequence=$p(^CT("DOW",1,RowId),"^",2)
	.s Checked=$p(^CT("DOW",1,RowId),"^",3)
	.;i Checked="Y"  d
    .Do OutRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow2
	set Data=$lb(Name,Sequence,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWeekExecute ]
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

ClassMethod QueryWeekClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWeekExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：QueryServiceGroup
/// 功能：查询服务组
/// 作者： gongping
/// 日期： 2011-08-04 
Query QueryServiceGroup() As %Query(ROWSPEC = "Code:%String,Name:%String,RowId:%String")
{
}

ClassMethod QueryServiceGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// RBC_ServiceGroup
	Set RowId=0	f  s RowId=$o(^RBC("SG",RowId)) q:RowId=""  d
	.s Code=$p(^RBC("SG",RowId),"^",1)
	.s Name=$p(^RBC("SG",RowId),"^",2)
	.s DateTo=$p(^RBC("SG",RowId),"^",7)
	.i (DateTo="")!(DateTo>+$h)  d
    ..Do OutRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow3
	set Data=$lb(Code,Name,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryServiceGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
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

ClassMethod QueryServiceGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryServiceGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取星期的信息
ClassMethod GetWeekInfo() As %String
{
	
	
	s ret=""
	s rset=##class(%ResultSet).%New("web.DHCRisResourceApptSchudle:QueryWeek")
	do rset.Execute()
	while(rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(1)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(1)
	}	
	d rset.Close()
	q ret
}

/// 获取时间段信息
ClassMethod GetTimePeriodInfo() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisResourceApptSchudle:QueryTimePeriod")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 获取服务组信息
ClassMethod GetServiceGroupInfo() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisResourceApptSchudle:QueryServiceGroup")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

ClassMethod GetResourceInfo(LocId As %String) As %String
{
	q:LocId="" ""
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QueryResource")
	s ret=""
	do rset.Execute(LocId)
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(1)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(1)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// 函数： InsertResoucePlan
/// 功能： 插入资源计划
/// s ret=##class(web.DHCRisResourceApptSchudle).InsertResoucePlan(^TMP)
ClassMethod InsertResoucePlan(Info As %String) As %String
{
	s LocId=$p(Info,"^",1)
	s ResourceId=$p(Info,"^",2)
	s WeekNum=$p(Info,"^",3)
	s ServiceGroupID=$p(Info,"^",4)
	s TimePeriodCode=$p(Info,"^",5)    ;//时间段代码
	s StartTime=$p(Info,"^",6)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(Info,"^",7)
	s EndTime=$zth(EndTime,3)
	s BookMaxNumber=$p(Info,"^",8)
    s AutoNumber=$p(Info,"^",9)
    s ChargTime=$p(Info,"^",10)
    s ChargTime=$zth(ChargTime,3)

    
    s rowid=""
    &sql(insert into DHCRBC_ResPlan (DRP_LOCID,DRP_RESOURCEID,DRP_WEEK,DRP_ServiceGroupID,DRP_Desc,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime)
         values ( :LocId,:ResourceId,:WeekNum,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:BookMaxNumber,:AutoNumber,:ChargTime))
    s rowid=$p(%ROWID,$c(1))
    
    q SQLCODE_"^"_rowid
}

/// 函数： InsertBookedInfo
/// 功能： 插入病人的预约信息
/// s ret=do ##class(web.DHCRisResourceApptSchudle).InsertBookedInfo(^ttt)
ClassMethod InsertBookedInfo(Info As %String) As %String
{
	s ^ttt=Info
	lock +(^DHCRisBookedTMPReg)
	k ^DHCRISTMP("INDERTBOOKED")
	s OrderItemRowid=$p(Info,"^",1)
	s ResSchduleID=$p(Info,"^",2)
	s AppointMethod=$p(Info,"^",3)      ; 1: 手动， 2：自动
	s OherParam=$p($g(Info),"^",4)     //计费标识 HIS
	
	s GetOrderItemRowid=$p(OrderItemRowid,"@",1)
	s BookedIndex="",getIndexInfo="",Bk=""
	s getIndexInfo=..GetCurentBookedIndex(ResSchduleID)
	
	//w !,"getIndexInfo="_getIndexInfo
	i getIndexInfo'="" d
	.s BookedIndex=$p(getIndexInfo,"^",1)
	.s Bk=$p(getIndexInfo,"^",2)
    
    Set $ZT="ERROR"	
   
    s Count=$l(OrderItemRowid,"@")
    
    for i=1:1:Count 
    {
      s perOrditemRowid=$p(OrderItemRowid,"@",i)
      s OrdRowid=$p(perOrditemRowid,"||",1)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1) 
  	  s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
      s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
      s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
      s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
      s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
	  
	  i UseNumber="" s UseNumber=0
   	  i AutoUseNumber="" s AutoUseNumber=0
   	  
   	  s OrderRowid=$p(perOrditemRowid,"||",1)
   	  s itemsub=$p(perOrditemRowid,"||",2)
   	  s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
   	  s ItemBookeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
   	  s MehtodDesc=""
   	  i ItemBookeRowid'="" d
   	  .s AppointmentMethodId=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",2)
   	  .i AppointmentMethodId'="" d
   	  ..s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
      
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) lock -(^DHCRisBookedTMPReg)
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) s SQLCODE=-1000,ret=0
      q:(MehtodDesc="无需预约")!(MehtodDesc="不需预约")    
      
      TSTART
      s SQLCODE=100
    
      i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)) d
     .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_EqBooked_Index) 
    								values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:BookedIndex))
     .;w SQLCODE 								
     .s AutoUseNumber=AutoUseNumber+1
      else  if (MaxNumber>UseNumber)  d
      .;w !,"1"
     .&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_EqBooked_Index) 
    								values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:BookedIndex))
     s DHCENSInfo="",ret="0"
     /*i (OherParam'="HIS")
     {
	   s ^TMPOrditemRowid=perOrditemRowid
	   s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).SendHisBookedInfo(perOrditemRowid)
       s ret=$p(DHCENSInfo,"^",1)     
     }*/
     
      
     I SQLCODE TRollback 
     I SQLCODE lock -(^DHCRisBookedTMPReg)   
	 q:SQLCODE 

   	 s UseNumber=UseNumber+1
   	 s RemainNumber=MaxNumber-UseNumber
   	 i ('$d(^DHCRISTMP("INDERTBOOKED",GetOrderItemRowid))&(Bk="Y")) d
   	 .;w !,"GetOrderItemRowid="_GetOrderItemRowid
   	 .&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                           values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)
     .s ^DHCRISTMP("INDERTBOOKED",GetOrderItemRowid)=""  
     .do ..UpdateBookedIndex(ResSchduleID,BookedIndex)                    
      /*i (OherParam'="HIS")
      {
        s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).UpdateHisBookedInfo(perOrditemRowid)
        s ret=$p(DHCENSInfo,"^",1) 
      } 
      */                        
      
      I SQLCODE TRollback  
      I SQLCODE lock -(^DHCRisBookedTMPReg) 
      I SQLCODE q 
  	  TCOMMIT
    }
    
    lock -(^DHCRisBookedTMPReg) 
    q SQLCODE_"^"_ret
    

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	I SQLCODE lock -(^DHCRisBookedTMPReg) 
 	q SQLCODE_"^"_ret
}

/// 函数 CancelBookedInfo
/// 功能：取消预约
/// 20017||3899@20017||3900 ---77006||1
/// w ##class(web.DHCRisResourceApptSchudleZGYD).CancelBookedInfo("77006||1")
ClassMethod CancelBookedInfo(OrderItemRowid As %String)
{
	S $ZT="ERROR1"	
    s SQLCODE=100
    s IsUpdate=""
    
	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,0))
	q:DetailRowid="" 100
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	q:ResSchduleID="" 100
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	s BookedIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",20)
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
   
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	s IsUpdate=..IsUpdateSchudle(OrderItemRowid)

	TSTART
	&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
	I SQLCODE TRollback  
    I SQLCODE q SQLCODE
    if AppointMethod="2" d
    .i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    i UseNumber>0 s UseNumber=UseNumber-1
    s RemainNumber=MaxNumber-UseNumber
    i IsUpdate="Y" d
    .&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                          values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)                   
    I SQLCODE TRollback  
    I SQLCODE q SQLCODE
    
    i (SQLCODE=0)&(IsUpdate="Y") d
    .do ..AddEqCancelIndex(ResSchduleID,BookedIndex)
  	TCOMMIT
    q SQLCODE

ERROR1	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE
}

/*ClassMethod CancelBookedInfo(OrderItemRowid As %String)
{
	S $ZT="ERROR1"	
    s SQLCODE=100
    
	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,0))
	q:DetailRowid="" 100
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	q:ResSchduleID="" 100
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	TSTART
	&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
	I SQLCODE TRollback  
    I SQLCODE q SQLCODE
    if AppointMethod="2" d
    .i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    .i (AutoUseNumber>0)&(UseNumber>0) d
    ..s UseNumber=UseNumber-1
    ..s RemainNumber=MaxNumber-UseNumber
    
    if AppointMethod="1" d
    .i UseNumber>0 s UseNumber=UseNumber-1
    .s RemainNumber=MaxNumber-UseNumber
    
    &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                           values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)
    I SQLCODE TRollback  
    I SQLCODE q SQLCODE
  	TCOMMIT
    q SQLCODE

ERROR1	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE
}*/
/// 函数 CancelBookedInfo
/// 功能：取消预约
/// d ##class(web.DHCRisResourceApptSchudle).CancelBookedInfo()
/// 函数： UpdateResoucePlan
/// 功能： 更新资源计划
ClassMethod UpdateResoucePlan(Info As %String)
{

	s LocId=$p(Info,"^",1)
	s ResourceId=$p(Info,"^",2)
	s WeekNumber=$p(Info,"^",3)
	s ServiceGroupID=$p(Info,"^",4)
	s TimePeriodCode=$p(Info,"^",5)

	s StartTime=$p(Info,"^",6)
	s StartTime=$zth(StartTime,3)
	s EndTime=$p(Info,"^",7)
	s EndTime=$zth(EndTime,3)

	s BookMaxNumber=$p(Info,"^",8)
    s AutoNumber=$p(Info,"^",9)
    s Rowid=$p(Info,"^",10)
    s ChargeTime=$p(Info,"^",11)
    i ChargeTime'="" d
    .s ChargeTime=$zth(ChargeTime,3)

        
    &sql(update DHCRBC_ResPlan (DRP_LOCID,DRP_RESOURCEID,DRP_WEEK,DRP_ServiceGroupID,DRP_Desc,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime)
         values (:LocId,:ResourceId,:WeekNumber,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:BookMaxNumber,:AutoNumber,:ChargeTime) where DRP_RowID=:Rowid)
    q SQLCODE
}

/// 函数：UpdateDateResApptSchudle
/// 功能：更新生成后的资源计划的数量
ClassMethod UpdateDateResApptSchudle(Info As %String) As %String
{
	s ResSchRowid=$p(Info,"^",1)
	s Max=$p(Info,"^",2)
	s AutoNumber=$p(Info,"^",3)
	
	&sql(update DHCRBC_ResSchdule (DRPS_MaxNumber,DRPS_AutoNumber) 
     								values(:Max,:AutoNumber) where DRPS_RowID=:ResSchRowid)

	q SQLCODE
}

/// 函数： DeleteResoucePlan
/// 功能： 删除资源计划
ClassMethod DeleteResoucePlan(Rowid As %String)
{
	s SQLCODE=100
	s SchudleId=$o(^DHCRBCResSchdulei("ResPlan",Rowid,0))
	if SchudleId="" d  
    .&sql(delete from DHCRBC_ResPlan  where DRP_RowID=:Rowid)
    q SQLCODE
}

/// 函数：GetWeek
/// 功能：获取星期的描述
ClassMethod GetWeek(WeekNumber As %String) As %String
{
	 s Name="",Sequence=""
	 Set RowId1=0	f  s RowId1=$o(^CT("DOW",1,RowId1)) q:(RowId1="")!(WeekNumber=Sequence)  d
	.s Sequence=$p(^CT("DOW",1,RowId1),"^",2)
	.i WeekNumber=Sequence d
	..s Name=$p(^CT("DOW",1,RowId1),"^",1)
    q Name
}

/// 函数：GetTimePeriodDesc
/// 功能：根据代码获取时间段的详细描述
ClassMethod GetTimePeriodDesc(Code As %String) As %String
{
	s Desc=""
	q:Code="" ""
	s Rowid=$o(^DHCRBCTimePeriodSeti("Code",Code,0))
	i Rowid'="" d
	.s Desc=$p(^DHCRBCTimePeriodSet(Rowid),"^",2)
	q Desc
}

/// 生成资源的排版计划
/// d ##class(web.DHCRisResourceApptSchudle).CreateResApptSchulde(^TMP11)
ClassMethod CreateResApptSchulde(Info As %String) As %String
{
	s LocId=$p(Info,"^",1)
	s ResourceId=$p(Info,"^",2)
	s StartDate=$p(Info,"^",3)

	i StartDate="" d
	.s StartDate=+$h
	else  d
	.s StartDate=$zdh(StartDate,4)
	
	s EndDate=$p(Info,"^",4)
	q:EndDate="" 0  
	s EndDate=$zdh(EndDate,4)

    s SQLCODE=100
    for CurrDate=StartDate:1:EndDate d
     .s WeekNum=$zd(CurrDate,10)
     .i WeekNum=0 s WeekNum=7
     .s RPRowid=0 f  s RPRowid=$o(^DHCRBCResPlani("Week-Resource",WeekNum,LocId,ResourceId,RPRowid)) q:RPRowid=""  d
     ..;s WeekNumber=$p(^DHCRBCResourcePlan(RowId),"^",7)
	 ..;s Week=..GetWeek(WeekNumber)
	 ..s ServiceGroupID=$p(^DHCRBCResourcePlan(RPRowid),"^",3)
	 ..s TimePeriodCode=$p(^DHCRBCResourcePlan(RPRowid),"^",4)  //时间段代码
	 ..s StartTime=$p(^DHCRBCResourcePlan(RPRowid),"^",5)
	 ..s EndTime=$p(^DHCRBCResourcePlan(RPRowid),"^",6)
	 ..s Max=$p(^DHCRBCResourcePlan(RPRowid),"^",8)
     ..s AutoNumber=$p(^DHCRBCResourcePlan(RPRowid),"^",9)
     ..s ChargTime=$p(^DHCRBCResourcePlan(RPRowid),"^",10)
     
     ..s ResSchRowid=$o(^DHCRBCResSchdulei("Resource-Date",LocId,ResourceId,CurrDate,RPRowid,0))
     ..i ResSchRowid="" d   ; 资源计划已经存在，不在产生
     ...&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:RPRowid,:ChargTime))
     ..else  d
     ...&sql(update DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ChargeTime) 
     								values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:ChargTime) where DRPS_RowID=:ResSchRowid)
     q SQLCODE
}

/// 函数：QueryPatientBookedItem
/// 功能：查询病人的预约记录
/// 参数：paadm.rowid,制定日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryPatientBookedItem","66531")
Query QueryPatientBookedItem(EpsodeId As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,StartTime:%String,ItemDesc:%String,LocDesc:%String,Resource:%String,PatientName:%String,PatientId:%String")
{
}

ClassMethod QueryPatientBookedItemExecute(ByRef qHandle As %Binary, EpsodeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	i EpsodeId="" s qHandle=$lb(0,repid,0)
	Quit:EpsodeId="" $$$OK
    s ^TMP=EpsodeId
 	
	s OrdItemRowid=0 f  s OrdItemRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid)) q:OrdItemRowid=""  d
	.s ResDetailRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid,0)) 
	.s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrdItemRowid,0))
	.q:RegRowid'="" 
	.i ResDetailRowid'="" d
	..s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	..i ResSchduleID'="" d
	...s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	...s ResourceDesc=""
	...i ResouceId'="" d
	....s EqId=$p(^RB("RES",ResouceId),"^",3)
	....s CareProvId=$p(^RB("RES",ResouceId),"^",2)
	....i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	...s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	...s BookedDate=$zd(Date,3)
	...s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	...s TimeDesc=""
	...i TimeDescCode'="" d
	...s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	...s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	...s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	...s BooketTime=$zt(StartTime)
	...s OrderRowid=$p(OrdItemRowid,"||",1)
	...s ItemRowid=$p(OrdItemRowid,"||",2)
	...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	...s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
    ...s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    ...s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	...s ArcItemId=$p( ^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	...s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	...s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	...s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2)  

    ...Do OutRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow4
	set Data=$lb(BookedDate,TimeDesc,BooketTime,strOrderName,LocDesc,ResourceDesc,Name,RegNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPatientBookedItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatientBookedItemExecute ]
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

ClassMethod QueryPatientBookedItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatientBookedItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数：QueryResApptSchdule
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResApptSchdule","66425||788","83","","")
Query QueryResApptSchdule(OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String")
{
}

ClassMethod QueryResApptSchduleExecute(ByRef qHandle As %Binary, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TMP=OrditemRowid_"^"_LocId_"^"_ResourceId_"^"_BookDate
 	
 	i BookDate="" s BookDate=+$h
 
 	if (OrditemRowid'="")  
 	{
	  	s OrderRowid=$p(OrditemRowid,"||",1)
	 	s ItemRowid=$p(OrditemRowid,"||",2)
	 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	 	s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
	 	i ServcieGroupId'="" d
	 	.; 查询服务组的资源计划
	 	.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",ServcieGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d
	 	..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
                ..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	 	..q:(GetResource="")
	 	..s BK=""
	 	..s BK=##class(web.DHCRisBookParam).GetAppResParam(OrditemRowid,GetResource)
	 	..q:(BK="N")
	 	..q:(ResourceId'="")&(GetResource'=ResourceId)
	 	..;w !,GetLocId_"^"_LocId
	 	..q:GetLocId'=LocId
	  	..s bFindBookeInfo=1
	 	..Do OutRow5
	 ;查询没有设置服务组的所有资源的预约计划,没有设置服务组的所有的医嘱都可以预约此设备
	 .;s GetResourceId=0 f  s GetResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,GetResourceId)) q:GetResourceId=""  d
	 .;q:(ResourceId'="")&(ResourceId'=GetResourceId)
	 .;s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,GetResourceId,ResSchduleID)) q:ResSchduleID=""  d
	 .;.s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
     .;.d OutRow5 
 	}
 	else 
 	{
	  i LocId="" s qHandle=$lb(0,repid,0)
	  Quit:LocId="" $$$OK
	  i ResourceId="" d
	  .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
	  ..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
	  ...d OutRow5
	  else  d
	  .s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
  	  ..d OutRow5 
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow5
     s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	 s ResourceDesc=""
	 i ResouceId'="" d
	 .s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	 .s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	 .i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	 .i CareProvId'="" s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
	 s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	 s BookedDate=$zd(Date,3)
	 s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	 s TimeDesc=""
	 i TimeDescCode'="" d
	 .s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	 .s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	 
	 s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
	 s ServiceGroupDesc=""
	 i ServiceGroupId'="" d
	 .s ServiceGroupDesc=$p(^RBC("SG",ServiceGroupId),"^",2) 
	 s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	 s StartTime=$zt(StartTime)
	 s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 s CurrentTime=$p($h,",",2)
	 s CurrentDate=+$h
	 q:((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate)
	 s EndTime=$zt(EndTime)
	 s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResApptSchduleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResApptSchduleExecute ]
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

ClassMethod QueryResApptSchduleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResApptSchduleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocBookedPrintTemplate(LocDR As %String) As %String
{
  s PrintName=""
  if LocDR'="" d 
  .s locprowid=$o(^DHCRBC("Loc",LocDR,0)) 
  .i locprowid'="" d
  ..s PrintName=$p(^DHCRBC("LocParam",locprowid),"^",10)
  q PrintName
}

/// 根据医嘱号得到补打预约单信息
/// sunyi 2011-09-15  55918||1712
/// w ##class(web.DHCRisResourceApptSchudle).GetBookedPrintInfo("55918||1712")
ClassMethod GetBookedPrintInfo(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") "0"
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,Name,strOrderName,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime)=""
	
	s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	i (paadmdr'="")
	{
	   s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	}
	
	i (papatmasmdr'="")
	{
	   s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	   s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	}
	
	s ArcItemId=$p( ^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	i (ArcItemId'="") 
	{
	   s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	}
	
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	i (ResDetailRowid'="")
	{
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=$zd(Date,3)
	   .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
	   .i StartTime'="" s BooketTime=$zt(StartTime)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	   .s Info="" 
	   .s Info=RegNo_"^"_Name_"^"_strOrderName_"^"_BookedDate_"^"_BooketTime_"^"_LocDesc_"^"_LocAddress
	   
	}
	
	q Info
}

/// 根据医嘱的接收科室获取位置
/// sunyi 2011-09-15
/// w ##class(web.DHCRisResourceApptSchudle).GetLocAddress("83")
ClassMethod GetLocAddress(LocId As %String) As %String
{
	s LocAddress=""
	i LocId'="" d
	.s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	q LocAddress
}

/// w ##class(web.DHCRisResourceApptSchudleZGYD).IsUpdateSchudle("20017||3899")
ClassMethod IsUpdateSchudle(OrderItemRowid As %String) As %String
{
	s Flag="N"
	q:(OrderItemRowid="") Flag
	s OrderRowid="",ItemRowid="",paadmdr=""
	s num=0
	s OrderRowid=$p(OrderItemRowid,"||",1)
	s ItemRowid=$p(OrderItemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	;w !,"paadmdr="_paadmdr
	q:(paadmdr="") Flag
	s ResDetailRowid="",SchudleRowid=""
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",paadmdr,OrderItemRowid,ResDetailRowid))
	i ResDetailRowid'="" s SchudleRowid=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",2)
	q:(SchudleRowid="") Flag
	;w !,"SchudleRowid="_SchudleRowid
	s ResDetailRowid="" f  s ResDetailRowid=$o( ^DHCRBCResSchduleDetaili("SchudleId",SchudleRowid,ResDetailRowid)) q:ResDetailRowid=""  d
	.s GetOrditemID=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",1)
	.;w !,"GetOrditemID="_GetOrditemID
	.s GetPaadmdr=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",3)
	.q:(GetPaadmdr'="")&(GetPaadmdr'=paadmdr)
	.s num=num+1
	
    i num<=1 s Flag="Y"
    q Flag
}

/// 根据医嘱查找项目对应服务组是否相同 Y-是 N-否
/// sunyi 2012-01-16
/// w ##class(web.DHCRisResourceApptSchudle).SameServiceGroup("47411||3172@47411||3173")
ClassMethod SameServiceGroup(OrditemRowid) As %String
{
	s Count=$l(OrditemRowid,"@")
	s SGroupRowid=""
	
	for i=1:1:Count 
    {
	    s arcimid="",IsAllow="Y",CurrentRowid=""
	    
	    s perOrditemRowid=$p(OrditemRowid,"@",i)
	    s OrderRowid=$p(perOrditemRowid,"||",1)
	    s itemsub=$p(perOrditemRowid,"||",2)
	    s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	    i arcimid'=""
	    {
		   s SubscriptID=$p(arcimid,"||",1)
		   s VersionID=$p(arcimid,"||",2)
		   s CurrentRowid=$p($g(^ARCIM(SubscriptID,VersionID,8)),"^",7)
		 
		   i (SGroupRowid'="")&(SGroupRowid'=CurrentRowid)
		   {
			   s IsAllow="N"
		   }
		   s SGroupRowid=CurrentRowid
		}
    }
    q IsAllow
}

/// 函数：QueryResApptSchdule
/// 功能：查询设备的预约资源明细
/// 参数：CT_Loc.Rowid,RB_Resouce.Rowid,开始日期,结束日期
/// 作者：sunyi
/// 日期: 2011-08-05
/// /// w ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResSchduleDetail","83","","62720","62728")
Query QueryResSchduleDetail(LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,RemainTime:%String,nextStartTime:%String")
{
}

ClassMethod QueryResSchduleDetailExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String, nextStartTime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TEMP=LocId_"^"_ResourceId_"^"_StartDate_"^"_EndDate
 	
 	i StartDate="" s StartDate=+$h
 	i EndDate="" s EndDate=+$h
 	
 	s bookUserType="1"
 	s locParamDr=""
 	i LocId'="" d
 	.s locParamDr=$o(^DHCRBC("Loc",LocId,locParamDr))
 	.i locParamDr'="" d
 	..s bookUserType=$P($g(^DHCRBC("LocParam",locParamDr)),"^",23)
 	
	i LocId="" s qHandle=$lb(0,repid,0)
	Quit:LocId="" $$$OK
	
	for BookDate=StartDate:1:EndDate
	{
		i ResourceId="" d
		.s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
		..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
		...d ResSchduleDetail
		else  d
		.s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
		..d ResSchduleDetail 
	}
 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

ResSchduleDetail
     s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	 s ResourceDesc=""
	 i ResouceId'="" d
	 .s EqId=$p(^RB("RES",ResouceId),"^",3)
	 .s CareProvId=$p(^RB("RES",ResouceId),"^",2)
	 .i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	 .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	 s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	 s BookedDate=$zd(Date,3)
	 s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	 s TimeDesc=""
	 i TimeDescCode'="" d
	 .s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	 .s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	 
	 s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
	 s ServiceGroupDesc=""
	 i ServiceGroupId'="" d
	 .s ServiceGroupDesc=$p(^RBC("SG",ServiceGroupId),"^",2) 
	 s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	 s StartTime=$zt(StartTime)
	 s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 s CurrentTime=$p($h,",",2)
	 s CurrentDate=+$h
	 q:((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate)
	 s EndTime=$zt(EndTime)
	 s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	 ;q:(MaxNumber="0")
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)
	 s RemainTime="",nextStrStartTime=""
	 if ( bookUserType="2") d
	 .;b //02
	 .s RemainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
	 .s nextStrStartTime=$zt($p(^DHCRBCResourceSchdule(ResSchduleID),"^",17))
	 .s UseNumber=0
	 .s detailDr="" f  s detailDr=$o(^DHCRBCResSchduleDetaili("SchudleId" ,ResSchduleID,detailDr)) q:(detailDr="")  d
	 ..;b //01
	 ..s UseNumber=UseNumber+1
	 ..;w !,UseNumber,!
    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime,nextStrStartTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResSchduleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResSchduleDetailExecute ]
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

ClassMethod QueryResSchduleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResSchduleDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 函数名称:GetCurentBookedIndex
/// 入参:预约资源排班记录ID
/// 返回值:BookedCurrentIndex_"^"_IsUp
/// w ##class(web.DHCRisResourceApptSchudle).GetCurentBookedIndex("8988")
/// 作者:sunyi 2014-11-23
ClassMethod GetCurentBookedIndex(ResSchduleID As %String) As %String
{
   n (ResSchduleID)
   s BookedCurrentIndex="",Day="",EqId=""
   s IsUp="Y"
   q:ResSchduleID="" ""
   s Day=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
   s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
   i ResouceId'="" s EqId=$p(^RB("RES",ResouceId),"^",3)
   i ((EqId'="")&(Day'=""))
   {
	  s BookedCurrentIndex=..DelEqCancelIndex(Day,EqId)
	  //w !,"BookedCurrentIndex="_BookedCurrentIndex
	  if (BookedCurrentIndex="")
	  {
	    i $g(^DHCRisBookedIndex(Day,EqId))="" s ^DHCRisBookedIndex(Day,EqId)=0
	    s BookedCurrentIndex=$g(^DHCRisBookedIndex(Day,EqId))+1
	  }else
	  {
		 s IsUp="N"
	  }
   }
   
   q BookedCurrentIndex_"^"_IsUp
}

ClassMethod UpdateBookedIndex(ResSchduleID, Index) As %String
{
   n (ResSchduleID,Index)
   s Day="",EqId=""
   q:ResSchduleID="" ""
   q:Index=""
   s Day=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
   s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
   i ResouceId'="" s EqId=$p(^RB("RES",ResouceId),"^",3)
   i ((EqId'="")&(Day'=""))
   {
	 s ^DHCRisBookedIndex(Day,EqId)=Index
	 ;w !,"^DHCRisBookedIndex(Day,EqId)="_$g(^DHCRisBookedIndex(Day,EqId))
   }
   
   q 0
}

ClassMethod AddEqCancelIndex(ResSchduleID, Index) As %String
{
   n (ResSchduleID,Index)
   s Day="",EqId=""
   q:ResSchduleID="" ""
   q:Index="" ""
   s Day=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)

   s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
   i ResouceId'="" s EqId=$p(^RB("RES",ResouceId),"^",3)
   i ((EqId'="")&(Day'=""))
   {
	 i '$d(^DHCRisBookedEqCancel(Day,EqId))
	 {
		 s ^DHCRisBookedEqCancel(Day,EqId)=Index
	 }else
	 {
		 s Finds=""
		 s Finds=..FindIndex(Day,EqId,Index)
		 i Finds="N" d
		 .s ^DHCRisBookedEqCancel(Day,EqId)=$g(^DHCRisBookedEqCancel(Day,EqId))_"@"_Index
	 }
   }
   
   q 0
}

ClassMethod DelEqCancelIndex(Day, EqId) As %String
{
	 s Info="",FistCancelIndex="",CancelCount=0
	 s CacnelNoInfo=""
	 
	 i $d(^DHCRisBookedEqCancel(Day,EqId))
	 {
		 s CacnelNoInfo=$g(^DHCRisBookedEqCancel(Day,EqId))
		 s CancelCount=$l($g(CacnelNoInfo),"@")
		 for j=1:1:CancelCount
		 {
			i (j=1)
			{
			   s FistCancelIndex=$p($g(CacnelNoInfo),"@",j)
			}else
			{
			   i Info="" s Info=$p($g(CacnelNoInfo),"@",j)
			   e  d
			   .s Info=Info_"@"_$p($g(CacnelNoInfo),"@",j)
			} 
		 }
		 s ^DHCRisBookedEqCancel(Day,EqId)=Info
	 }
	 
	 q FistCancelIndex
}

/// w ##class(web.DHCRisResourceApptSchudleZGYD).FindIndex("","","1")
ClassMethod FindIndex(Day, EqId, Index) As %String
{
	s F="N",FindCount=0,getInfo="",perFindNo=""
	i $g(^DHCRisBookedEqCancel(Day,EqId))'="" d
	.s getInfo=$g(^DHCRisBookedEqCancel(Day,EqId))
	.s FindCount=$l(getInfo,"@")

	for k=1:1:FindCount
	{
		s perFindNo=$p(getInfo,"@",k)
		i perFindNo=Index s F="Y"
		q:(F="Y")
	}
	
	q F
}

/// w ##class(web.DHCRisResourceApptSchudleZGYD).Test()
ClassMethod Test() As %String
{
	 s CancelCount=5
	 s Info="1@3@2@5@6"
	 s gInfo=""
		 for j=1:1:CancelCount
		 {
			i (j=1)
			{
			   s FistCancelIndex=$p($g(Info),"@",j)
			   w !,"FistCancelIndex="_FistCancelIndex
			}else
			{
			   i gInfo="" s gInfo=$p($g(Info),"@",j)
			   e  d
			   .s gInfo=gInfo_"@"_$p($g(Info),"@",j)
			}
			
			 
		 }
		 w !,"gInfo="_gInfo
		 
		 q "-----"
}

}
