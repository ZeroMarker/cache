Import SQLUser

Class web.DHCRisResourceApptSchudleEx Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

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

// s ret=##class(web.DHCRisResourceApptSchudle).GetWeekInfo()

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

// 查询资源组信息

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
/// 备注:  全预约模式必须要有检查号
/// w ##class(web.DHCRisResourceApptSchudleEx).InsertBookedInfo(^DHCRis("Ris2012"))
ClassMethod InsertBookedInfo(Info As %String) As %String
{
	
	s ^DHCRis("Ris2012")=Info
	
	s OrderItemRowid=$p(Info,"^",1)
	s ResSchduleID=$p(Info,"^",2)
	s AppointMethod=$p(Info,"^",3)      ; 1: 手动， 2：自动
	s OherParam=$p($g(Info),"^",4)     //计费标识 HIS
	s MuitStudyNo=$p($g(Info),"^",5)
	s RegEQIndex=$p($g(Info),"^",6)
	s CheckGroupIndex=$p($g(Info),"^",7)
	s RoomIndex=$p($g(Info),"^",8)
	s EQDr=$p($g(Info),"^",9)
    s EQGroupDR=$p($g(Info),"^",10)
    s RoomDR=$p($g(Info),"^",11)
    s paadr=$p($g(Info),"^",12)
    s IndexTypeDR=$p($g(Info),"^",13)
    s InputRegDate=$p($g(Info),"^",14)
    s UserDR=$p($g(Info),"^",15)
    s GetStudyNo=$p($g(Info),"^",16) //PACS传入的检查号
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
    
    n MaxNumber,AutoNumber,UseNumber,RemainNumber,AutoUseNumber,nextStartTime,remainTime
    s bookType="1"   ; 1为按最大数预约   2为按检查时间预约
    
	
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
    /*
    s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
    */
    s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    i (remainTime'="")&&(nextStartTime'="") d
    .s bookType="2"
	
    
    Set $ZT="ERROR"	
    s Count=$l(OrderItemRowid,"@")
    
    lock +(^DHCRisTMPBook)
    k ^DHCRISTMP("STUDYNO")
    
    for i=1:1:Count 
    {
	  s Arrearage="1"
      s perOrditemRowid=$p(OrderItemRowid,"@",i)
      s StudyNo=$p($g(MuitStudyNo),"@",i)
      i GetStudyNo'="" s StudyNo=GetStudyNo
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
	  
	  //医嘱对应的就诊记录是否一致
	  i (paadr'=EpisodeID)
	  {
		 lock -(^DHCRisTMPBook)
		 s SQLCODE="-10002",ret="0"
		 q:SQLCODE
      }
      
     
	  s RecLocdr=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
	  
	  s UseInfo="",UpType="",AppDateType=""
	  s UseInfo=..IsUseUpdateNo(RecLocdr)
	  i (UseInfo'="")
	  {
		 s UpType=$p(UseInfo,"^",1)
		 s AppDateType=$p(UseInfo,"^",2)
	  }
	  
	  if (UpType="I")
	  {
		  s RoomIndex=""
		  s CheckGroupIndex=""
		  s RegEQIndex=""
	  }else
	  {
	    if ('$d(^DHCRISTMP("STUDYNO",StudyNo)))
	    {
		    s MaxParam="",MaxIndexInfo=""
		    s MaxParam=EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_RecLocdr_"^"_perOrditemRowid_"^"_InputRegDate
		    s MaxIndexInfo=##class(web.DHCRisPatRegisterDoEx).GetCurrentMaxIndex(MaxParam)
		    i MaxIndexInfo'="" d
		    .s RegEQIndex=$p(MaxIndexInfo,"^",1)
		    .s CheckGroupIndex=$p(MaxIndexInfo,"^",2)
		    .s RoomIndex=$p(MaxIndexInfo,"^",3)
		}
	
	  }
	  
	  s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(EpisodeID,"A","完全控制")
	  i (Arrearage="1")
	  { 
	     lock -(^DHCRisTMPBook)
	     s SQLCODE="-999",ret="0"
	     q:SQLCODE
	  }

	  s value=""
	  s value=RegEQIndex_"^"_CheckGroupIndex_"^"_RoomIndex_"^"_EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_AppDateType_"^"_InputRegDate
  	  
  	  s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
      s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
      s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
      s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
      s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
	  i UseNumber="" s UseNumber=0
   	  i AutoUseNumber="" s AutoUseNumber=0
   	  s stopTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
   	  s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
      s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
   	  
   	  s ExamTime=""  ;检查需要时间
   	  s updateNextStartTime="",updateRemainTime=""
   	  s endTime="",startTime=""
   	  s getStartTime="",getEndTime=""
   	  s OrderRowid=$p(perOrditemRowid,"||",1)
   	  s itemsub=$p(perOrditemRowid,"||",2)
   	  s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
   	  s ItemBookeRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
   	  s MehtodDesc=""
   	  i ItemBookeRowid'="" d
   	  .s AppointmentMethodId=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",2)
   	  .s ExamTime=$p(^DHCRBCItemBookProperty(ItemBookeRowid),"^",9)
   	  .i AppointmentMethodId'="" d
   	  ..s MehtodDesc=$p(^DHCRBCAppointMethod(AppointmentMethodId),"^",2)
   	  
      
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) s SQLCODE=-1000,ret=0 
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) lock -(^DHCRisTMPBook)
      q:(MehtodDesc="无需预约")!(MehtodDesc="不需预约")    
     
      ;按检查时间预约，但是项目检查时间为空 退出 返回-1100
      
      if ((bookType="2")&&(ExamTime="")) d
      .s SQLCODE=-1100,ret=0 
      .lock -(^DHCRisTMPBook)
      
      q:(bookType="2")&&(ExamTime="")
      
      TSTART
      s SQLCODE=100
      
      s IsCancel=""
      s IsCancel=..IsCancelBooked(perOrditemRowid)
    
      if (bookType="2")
      {
	      ;按检查开始时间 查询此scheduleId的最后一条记录
	      ;s detailDr="",lastStartTime=""
	      ;s lastStartTime=$o(^DHCRBCResSchduleDetaili("BKSTARTTIME",DRPD_ResSchdule_ID,lastStartTime),-1)
	      ;i lastStartTime'="" s detailDr=$o(^DHCRBCResSchduleDetaili("BKSTARTTIME",DRPD_ResSchdule_ID,lastStartTime,detailDr),-1)
		  ;i detailDr="" 
		  ;{
		;	  s startTime=nextStartTime
		;	  s endTime=ExamTime*60+nextStartTime
		  ;}
		  ;else   //根据最后一条记录计算开始和结束时间
		  ;{
			  ;s getStartTime=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",18)
			  ;s getEndTime=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",19)
			  s startTime=nextStartTime
			  i ( (startTime+(ExamTime*60)) < stopTime )
			  { 
			  	s endTime=ExamTime*60+nextStartTime
			  }
			  else
			  {
				  s endTime=stopTime
			  }
		  ;}
		  &sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime ) 
	    					    values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime))
		  s updateNextStartTime=endTime
		  i ((remainTime-ExamTime)>0) d
		  .s updateRemainTime=remainTime-ExamTime
		  e  d
		  .s updateRemainTime=0
      }
      else 
      {
      	i (IsCancel="Y")
      	{
	      i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)!((AppointMethod'="2")&(MaxNumber>UseNumber)))
	      {
	        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time)
	                           values (:ResSchduleID,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,'Booked',:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime) where  DRPD_OrderItem_ID=:perOrditemRowid) 
	        i (AppointMethod="2")&(AutoUseNumber<AutoNumber) s AutoUseNumber=AutoUseNumber+1            
	      } 
      	}                    
      	else
      	{
	     	i ((AppointMethod="2")&(AutoUseNumber<AutoNumber)) d
	     	.&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
	    					values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime)) 					
	     	.s AutoUseNumber=AutoUseNumber+1
	     	else  if (MaxNumber>UseNumber)  d
	      	.&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time) 
	    				    values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime))
      	}
      }
        
						
     s DHCENSInfo="",ret="0"
     /*
     i (OherParam'="HIS")
     {
	   s ^TMPOrditemRowid=perOrditemRowid
	   s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).SendHisBookedInfo(perOrditemRowid)
       s ret=$p(DHCENSInfo,"^",1)     
     }
     */
     
      
     I SQLCODE TRollback  
     I SQLCODE lock -(^DHCRisTMPBook)
	 q:SQLCODE 
	 
	 
     if ('$d(^DHCRISTMP("STUDYNO",StudyNo)))
     {
	     i ((SQLCODE=0)&(UpType="B")) d
	      .do ##class(web.DHCRisPatRegisterDoEx).UpdateIndexcls(RecLocdr,value,ResSchduleID)
	      
	   	 s UseNumber=UseNumber+1
	   	 
	   	 if ((AppointMethod="1")&(MaxNumber<UseNumber))
	   	 {
		   	 s RemainNumber="0"
		 }
	   	 else
	   	 {
	   	     s RemainNumber=MaxNumber-UseNumber
	   	 }
	   	 
	   	 if (bookType="2")
	   	 {
		   	 &sql(update DHCRBC_ResSchdule (DRPS_NextStartTime,DRPS_RemainTime )
	                          values (:updateNextStartTime,:updateRemainTime) where  DRPS_RowID=:ResSchduleID)
	   	 }
	   	 else
	   	 {
	   	 	&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
	                          values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)  
	   	 }   
     }                      
      /*i (OherParam'="HIS")
      {
        s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).UpdateHisBookedInfo(perOrditemRowid)
        s ret=$p(DHCENSInfo,"^",1) 
      } 
      */ 
      ;更新医嘱表及医嘱状态表的的数据
      s Now=$zd(+$H,8)_$zt($p($h,",",2))
      s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(perOrditemRowid,"BK",Now,"","","")
      
      ;发送预约消息到RIS4系统
      i ((StudyNo'="")&('$d(^DHCRISTMP("STUDYNO",StudyNo))))
      {            
         do ##class(web.DHCRisSendToRis4Set).SendBookedtoRIS4(StudyNo,RecLocdr)
      }
      s ^DHCRISTMP("STUDYNO",StudyNo)=StudyNo
       
      I SQLCODE TRollback  
      I SQLCODE lock -(^DHCRisTMPBook)
      I SQLCODE q 
  	  TCOMMIT
    }
    lock -(^DHCRisTMPBook)
    q SQLCODE_"^"_ret
    

ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTMPBook)
 	q SQLCODE_"^"_ret
}

/// 函数 CancelBookedInfo
/// 功能：取消预约
/// d ##class(web.DHCRisResourceApptSchudleEx).CancelBookedInfo("20017||3895")
/// d ##class(web.DHCRisResourceApptSchudleEx).CancelBookedInfo("20017||3898")
ClassMethod CancelBookedInfo(OrderItemRowid As %String)
{
	s ^ZYY=OrderItemRowid
	S $ZT="ERROR1"	
    s SQLCODE=100
    
    if ($d(^DHCRISTAUTOTEMP(OrderItemRowid)))
    {
	    s ^DHCRISTAUTOTEMP(OrderItemRowid)=""
	}
	s UpFlag=""
	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,0))
	q:DetailRowid="" 100
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	q:ResSchduleID="" 100
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	;判断是否更新预约资源数量
	s UpFlag=..IsUpResSchdule(StudyNo)
	
	;判断是否为按时间预约
	s bookType="1"
	n startTime,endTime,examTime
	s startTime=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",18)
	s endTime=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",19)
	if ( (startTime'="")&&(endTime'=""))
	{
		s examTime=..getExamTime(OrderItemRowid)
		s bookType="2"
	}
	
	
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	lock +(^DHCRisTMPBook)
	TSTART
	if ( bookType="2")
	{
		&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
		I SQLCODE d
		.TRollback
		.lock -(^DHCRisTMPBook)
    	I SQLCODE q SQLCODE
    	&sql(update DHCRBC_ResSchdule set DRPS_RemainTime=(DRPS_RemainTime+:examTime) where  DRPS_RowID=:ResSchduleID)
		I SQLCODE  d
    	.TRollback
		.lock -(^DHCRisTMPBook) 
    	I SQLCODE q SQLCODE
	}
	else
	{
		;&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
		&sql(update DHCRBC_ResSchduleDetail(DRPD_CAFlag) values ('Cancel') where DRPD_OrderItem_ID=:OrderItemRowid)
		I SQLCODE d
		.TRollback
		.lock -(^DHCRisTMPBook)
    	I SQLCODE q SQLCODE
    	if AppointMethod="2" d
    	.i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    	
    	i UseNumber>0 s UseNumber=UseNumber-1
    	s RemainNumber=MaxNumber-UseNumber
    	i UpFlag="Y" d
    	.&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                           values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)
    	I SQLCODE  d
    	.TRollback
		.lock -(^DHCRisTMPBook) 
    	I SQLCODE q SQLCODE
	}
    
    ;更新医嘱表及医嘱状态表的的数据
    ;s Now=$zd(+$H,8)_$zt($p($h,",",2))
    ;s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(OrderItemRowid,"CBK",Now,"","","")
    
    ;发送取消预约消息到RIS4系统
    do ##class(web.DHCRisSendToRis4Set).SendCanelBookedtoRIS4(OrderItemRowid)
    
  	TCOMMIT
  	lock -(^DHCRisTMPBook)
    q SQLCODE

ERROR1	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE
}

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
/// 修改可以按科室生成排版计划 
/// sunyi 2012-1-10
/// d ##class(web.DHCRisResourceApptSchudle).CreateResApptSchulde(^TMP11)
ClassMethod CreateResApptSchulde(Info As %String) As %String
{
	s ^TMP11=Info
	s LocId=$p(Info,"^",1)
	s ResourceId=$p($g(Info),"^",2)
	s StartDate=$p(Info,"^",3)
	q:(ResourceId="") 0
    s Count=$l(ResourceId,"@")
    s ResID=ResourceId
    
	i StartDate="" d
	.s StartDate=+$h
	else  d
	.s StartDate=$zdh(StartDate,4)
	
	s EndDate=$p(Info,"^",4)
	q:EndDate="" 0  
	s EndDate=$zdh(EndDate,4)

    s SQLCODE=100
    for CurrDate=StartDate:1:EndDate d
     .for i=1:1:Count d
     ..s ResourceId=$p(ResID,"@",i)
     ..s WeekNum=$zd(CurrDate,10)
     ..i WeekNum=0 s WeekNum=7
     ..s RPRowid=0 f  s RPRowid=$o(^DHCRBCResPlani("Week-Resource",WeekNum,LocId,ResourceId,RPRowid)) q:RPRowid=""  d
     ...;s WeekNumber=$p(^DHCRBCResourcePlan(RowId),"^",7)
	 ...;s Week=..GetWeek(WeekNumber)
	 ...s ServiceGroupID=$p(^DHCRBCResourcePlan(RPRowid),"^",3)
	 ...s TimePeriodCode=$p(^DHCRBCResourcePlan(RPRowid),"^",4)  //时间段代码
	 ...s StartTime=$p(^DHCRBCResourcePlan(RPRowid),"^",5)
	 ...s EndTime=$p(^DHCRBCResourcePlan(RPRowid),"^",6)
	 ...s Max=$p(^DHCRBCResourcePlan(RPRowid),"^",8)
     ...s AutoNumber=$p(^DHCRBCResourcePlan(RPRowid),"^",9)
     ...s ChargTime=$p(^DHCRBCResourcePlan(RPRowid),"^",10)
     ...s ResSchRowid=$o(^DHCRBCResSchdulei("Resource-Date",LocId,ResourceId,CurrDate,RPRowid,0))
     ...i ResSchRowid="" d   ; 资源计划已经存在，不在产生
     ....&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:RPRowid,:ChargTime))
     ...else  d
     ....&sql(update DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ChargeTime) 
     								values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:ChargTime) where DRPS_RowID=:ResSchRowid)
     q SQLCODE
}

/// 函数：QueryPatientBookedItem
/// 功能：查询病人的预约记录
/// 参数：paadm.rowid,制定日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudleEx","QueryPatientBookedItem","76056")
Query QueryPatientBookedItem(EpsodeId As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,StartTime:%String,ItemDesc:%String,LocDesc:%String,Resource:%String,PatientName:%String,PatientId:%String,OrdItemRowid:%String,Memo:%String")
{
}

ClassMethod QueryPatientBookedItemExecute(ByRef qHandle As %Binary, EpsodeId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	i EpsodeId="" s qHandle=$lb(0,repid,0)
	Quit:EpsodeId="" $$$OK
    s ^TMP=EpsodeId
 	
 	/*
	s OrdItemRowid=0 f  s OrdItemRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid)) q:OrdItemRowid=""  d
    .s OrderRowid=$p(OrdItemRowid,"||",1)
	.s ItemRowid=$p(OrdItemRowid,"||",2)
	.s ItemStatDR="",ItemStatusCode="",Memo=""
	.s ItemStatDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	.q:(ItemStatusCode="D")
	.s ResDetailRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid,0)) 
	.s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrdItemRowid,0))
	.q:RegRowid'="" 
	.s Falg=""
	.i ResDetailRowid'="" s Falg=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",7)
	.i ((ResDetailRowid'="")&(Falg'="Cancel")) d
	..s IsMemo="",Memo=""
    ..s IsMemo=##class(web.DHCRisCommFunctionEx).ExistMemo(OrdItemRowid)
    ..i IsMemo="Y" s Memo="注意事项浏览" 
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
	...s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)  ;$zd(Date,3)
	...s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	...s TimeDesc=""
	...i TimeDescCode'="" d
	...s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	...s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	...s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	...s BooketTime=$zt(StartTime)
	...s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	...s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
    ...s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    ...s Name="",strOrderName=""
    ...s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	...s ArcItemId=$p( ^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	...s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	...s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	...s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2)  
    ...Do OutRow4
    */
    s OrdItemRowid=0 
    for
    {
	    s OrdItemRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid)) 
	    q:OrdItemRowid="" 
	    s OrderRowid=$p(OrdItemRowid,"||",1)
		s ItemRowid=$p(OrdItemRowid,"||",2)
		
		s arcimid=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
		if (arcimid="")
		{
			continue
		}
		s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
		if (ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
		{
			continue
		}
		s bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OrdItemRowid)
		for iBody=1:1:$L(bodydrList,"^")
		{
			s (strOrderName,bodypart,bodypartRowid,bodypartDesc,orderStatusInfo,ItemStatusCode,RegRowid,BookedRowid)=""
			s bodypart=$p($g(bodydrList),"^",iBody)
			s bodypartRowid=$p($g(bodypart),":",1) 
			s bodypartDesc=$p($g(bodypart),":",2)
			s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
			if bodypartDesc'=""  s strOrderName=strOrderName_" ("_bodypartDesc_")"
			s orderStatusInfo=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(OrdItemRowid,bodypartRowid)
			s ItemStatusCode=$p($g(orderStatusInfo),"^",1)
			;w !,ItemStatusCode
			if ((ItemStatusCode="U")||(ItemStatusCode="D")||(ItemStatusCode="C"))
			{
				;非执行和核实状态退出,进入下次循环
				continue
			}
		
		
			s RegRowid=##class(web.DHCRisResApptSchudleSystem).getRegRowid(OrdItemRowid_"^"_bodypartRowid )
			if (RegRowid'="")
			{
				continue			
			}
			s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(OrdItemRowid_"^"_bodypartRowid)
			if (BookedRowid'="")
			{
				s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",BookedRowid),"^",2)
				i ResSchduleID'=""
				{
					s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
					s ResourceDesc=""
					i ResouceId'="" d
					.s EqId=$p(^RB("RES",ResouceId),"^",3)
					.s CareProvId=$p(^RB("RES",ResouceId),"^",2)
					.i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
					.i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
					s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
					s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)  ;$zd(Date,3)
					s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
					s TimeDesc=""
					i TimeDescCode'="" d
					.s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
					.s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
					s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
					s BooketTime=$zt(StartTime)
					s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
					s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
				    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
				    s Name=""
				    s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
					s LocId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,3)),"^",6) ;$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
					s LocDesc="" 
					i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2)  
				    Do OutRow4
				}
			}
			
		}	
    
    
    }
    
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow4
	set Data=$lb(BookedDate,TimeDesc,BooketTime,strOrderName,LocDesc,ResourceDesc,Name,RegNo,$g(OrdItemRowid)_"$"_$g(bodypartRowid),$g(Memo))
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
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudleEx","QueryResApptSchdule","66425||788","83","","")
/// Flag标示 是否从主工作列表查询资源   1为从主工作列表查询最近的资源  0为点击查询按钮查询选择日期的资源
Query QueryResApptSchdule(OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,remainTime:%String,nextTime:%String")
{
}

ClassMethod QueryResApptSchduleExecute(ByRef qHandle As %Binary, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TMP=OrditemRowid_"^"_LocId_"^"_ResourceId_"^"_BookDate_"^"_Flag
 	k ^DHCRISSCHDULE("RISOLD")
 	i BookDate="" s BookDate=+$h
 	s AppSet="N"
    
     //.s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
	 //	...s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
	 //	...Q:(BookDate=+$h)&&($p($h,",",2)>EndTime)*/    ;不显示当前时间大于预约的结束时间 
	 
 	if (OrditemRowid'="")  
 	{
	 	s ResSchduleID=..GetSchduleID(OrditemRowid)
	 	i ResSchduleID'="" d
	 	.s IsBooked="Y"
	 	.s ^DHCRISSCHDULE("RISOLD",ResSchduleID)=""
	 	.Do OutRow5
	  	s OrderRowid=$p(OrditemRowid,"||",1)
	 	s ItemRowid=$p(OrditemRowid,"||",2)
	 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	 	s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
 
	 	if (ServcieGroupId'="") 
	 	{
		 	if (Flag="1")
		 	{
			 	s stDate=+$h
			 	s endDate=stDate+60
			 	s hasRes=0
			 	for dateFind=stDate:1:endDate
			 	{
				 	q:(hasRes=1)
				 	s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,dateFind,BookTime)) q:BookTime=""  d
	 				.q:(hasRes=1)
	 				.s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,dateFind,BookTime,ResSchduleID)) q:ResSchduleID=""  d
	 				..q:(hasRes=1)
	 				..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 				..Q:(dateFind=+$h)&&($p($h,",",2)>EndTime)
	 				..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
	 				..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
	 				..q:(GetResource="")
			 	    ..s BK=""
			 	    ..s BK=##class(web.DHCRisBookParam).GetAppResParam(OrditemRowid,GetResource)
			 	    ..q:(BK="N")
	 				..q:(ResourceId'="")&(GetResource'=ResourceId)
	 				..q:($d(^DHCRISSCHDULE("RISOLD",ResSchduleID)))
	 				..;w !,GetLocId_"^"_LocId
	 				..q:GetLocId'=LocId
	 				..s IsBooked=""
	  				..s bFindBookeInfo=1
	  				..s maxNumberFind=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)
	  				..s remianTimeFind=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
	  				..q:((maxNumberFind'="")&(maxNumberFind<=0))
	  				..q:((remianTimeFind'="")&(remianTimeFind<=0))
	  				..s hasRes=1
	 				..Do OutRow5 
			 	}
			 	
		 	} 
		 	else
		 	{
			 	 ; 查询服务组的资源计划	
			 	 ;s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",ServcieGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d
			 	 s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
			 	 .s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
			 	 ..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
			 	 ..Q:(BookDate=+$h)&&($p($h,",",2)>EndTime)
			 	 ..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
			 	 ..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
			 	 ..q:(GetResource="")
			 	 ..s BK=""
			 	 ..s BK=##class(web.DHCRisBookParam).GetAppResParam(OrditemRowid,GetResource)
			 	 ..q:(BK="N")
			 	 ..q:(ResourceId'="")&(GetResource'=ResourceId)
			 	 ..q:($d(^DHCRISSCHDULE("RISOLD",ResSchduleID)))
			 	 ..;w !,GetLocId_"^"_LocId
			 	 ..q:GetLocId'=LocId
			 	 ..s IsBooked=""
			  	 ..s bFindBookeInfo=1
			 	 ..Do OutRow5
		 	}
	 	}
	   
	 	
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
	 q:(((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate))&($g(IsBooked)="")
	 ;q:((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate)
	 s EndTime=$zt(EndTime)
	 s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	 ;q:(MaxNumber="0")
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)
	 s NextTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
	 i NextTime'=""  s NextTime=$zt(NextTime)
	 s RemainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime,NextTime)
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

// 得到预约打印模板

// sunyi 2011-09-15

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
/// w ##class(web.DHCRisResourceApptSchudleEx).GetBookedPrintInfo("20017||3887")
ClassMethod GetBookedPrintInfo(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") "0"
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,Name,strOrderName,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid,PinYin,PInfo,strDOB,strAge,SexDesc)=""
	s (MedicareNo,Memo,wardname,bedname,AppLocName,TMRowid,UserDR,UserCode,OpDate,OpTime)=""
	
	s SvrFlag=##class(web.DHCRisCommFunctionEx).NoBookedSvrGroup(OrditemRowid)
	q:(SvrFlag="Y") ""
	
	s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
	s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)

	i (paadmdr'="")
	{
	   s PInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	   i PInfo'="" d
	   .s RegNo=$p($g(PInfo),"^",1)
	   .s Name=$p($g(PInfo),"^",2)
	   .s strDOB=$p($g(PInfo),"^",3)
	   .s strAge=$p($g(PInfo),"^",4)
	   .s SexDesc=$p($g(PInfo),"^",5)
	   .s wardname=$p($g(PInfo),"^",10)
	   .s bedname=$p($g(PInfo),"^",11)
	   .s MedicareNo=$p($g(PInfo),"^",33)
	   .s PinYin=$p($g(PInfo),"^",38)
	   .s AppLocName=$p($g(PInfo),"^",8)
	}
   
    if (ArcItemId'="")
    {
	  s (MRowid,TMRowid)="" 
	  
	  s MRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemId,0))
	  i MRowid'="" d
	  .s TMRowid=$p($g(^DHCRBApp("Memo",MRowid)),"^",4)
	  .i TMRowid'="" d
	  ..s Memo=$p($g(^DHCRBCApp("Memo-Template",TMRowid)),"^",3)
	  .i Memo="" d
	  ..s Memo=$p($g(^DHCRBApp("Memo",MRowid)),"^",2)
	  
	}
	
	s strOrderName=##class(web.DHCRisApplicationBill).GetAppItemName(OrditemRowid)
	
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	i (ResDetailRowid'="")
	{
	   s UserDR=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",15)
	   i UserDR'="" s UserCode=$p($g(^SSU("SSUSR",UserDR)),"^",1)
	   
	   s OpDate=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",16)
	   i OpDate'="" s OpDate=$zd(OpDate,3)
	   s OpTime=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",17)
	   i OpTime'="" s OpTime=$zt(OpTime)
	   
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	   .s ResourceDesc=""
	   .i ResouceId'="" d
	   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	   ..i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	   ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	   ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
	   ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=$zd(Date,3)
	   .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
	   .i StartTime'="" s BooketTime=$zt(StartTime)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	   .s Info="" 
	   .s Info=RegNo_"^"_Name_"^"_strOrderName_"^"_BookedDate_"^"_BooketTime_"^"_LocDesc_"^"_LocAddress_"^"_ResourceDesc_"^"_EqAdress_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_MedicareNo_"^"_PinYin_"^"_wardname_"^"_bedname_"^"_AppLocName_"^"_Memo_"^"_UserCode_"^"_OpDate_"^"_OpTime
	   
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

/// 在转预约操作时给外勤发消息
/// sunyi 2012-03-06 
ClassMethod SendBKMessage(BookInfo As %String, ModInfo As %String) As %String
{
   s MBookedDate=$p(ModInfo,"^",1)	
   s MBookedTime=$p(ModInfo,"^",2)
   
   s Count=$l(BookInfo,"@")
   for i=1:1:Count 
   {
	  s (OrditemRowid,PatName,OrderName,BookedDate,BookedTime,USERID,pssdmdr)=""
	  s (RegNo,Wardname,AdmLoc,Info,AdmInfo)=""
	  
	  s perBookInfo=$p(BookInfo,"@",i)
	  i perBookInfo'="" d
	  .s OrditemRowid=$p($g(perBookInfo),"^",1)
	  .s OrderRowid=$p(OrditemRowid,"||",1)
	  .i OrderRowid'="" d 
	  ..s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1) 
	  ..i paadmdr'="" d
	  ...s AdmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	  ...s RegNo=$p($g(AdmInfo),"^",1)
	  ...s Wardname=$p($g(AdmInfo),"^",10)
	  ...s AdmLoc=$p($g(AdmInfo),"^",40)
	  .s PatName=$p($g(perBookInfo),"^",2)
	  .s OrderName=$p($g(perBookInfo),"^",3)
	  .s BookedDate=$p($g(perBookInfo),"^",4)
	  .s BookedTime=$p($g(perBookInfo),"^",5)
	  .;s USERID=$p(perBookInfo,"^",5)
	  .i OrditemRowid'="" d
	  ..s GroupID="0"  f  s GroupID=$o(^DHCRisOrdPrinted(OrditemRowid,GroupID)) q:GroupID=""  d
	  ...s USERID="0"  f  s USERID=$o(^SSU("SSUSR",0,"Group",GroupID,USERID)) q:USERID=""  d
	  ....s Info="就诊科室:"_AdmLoc_","_"病区:"_Wardname_","_"患者:"_PatName_","_"ID:"_RegNo_","_OrderName_"检查"_","_"由"_BookedDate_"日"_BookedTime_"改为"_MBookedDate_"日"_MBookedTime
	  ....s ret=##class(web.SSMessage).InsertMessageToUser(Info,USERID)
	  ...s ^DHCRisOrdPrinted(OrditemRowid,GroupID)=""
   }
   q 0
}

/// 协和预约人数
/// do ##class(web.DHCRisResourceApptSchudle).SetBookedNumber("2","1")
ClassMethod SetBookedNumber(ResSchduleID As %String, PaadmID As %String) As %String
{
	q:(PaadmID="")
	q:(ResSchduleID="")
	
	s j=$p($h,",",2)
	
	i (($g(^DHCRISBKINDEX(ResSchduleID))="" )!($g(^DHCRISBKINDEX(ResSchduleID))=0))
	{
		s ^DHCRISBKINDEX(ResSchduleID)=1
	}
	else
	{
		s num=0,SameFlag=""
		s Paadmdr="" f  s Paadmdr=$o(^DHCRISBOOKEDTEMP(ResSchduleID,Paadmdr)) q:Paadmdr=""  d
		.i (Paadmdr'=PaadmID) d
		..s num=num+1
		.e  d
		..s SameFlag="Y"
		i ((num>=1)&(SameFlag'="Y")) d
		.s ^DHCRISBKINDEX(ResSchduleID)=^DHCRISBKINDEX(ResSchduleID)+1	 
	}
	
	s ^DHCRISBOOKEDTEMP(ResSchduleID,PaadmID,j)=""
	
	q 0
}

/// do ##class(web.DHCRisResourceApptSchudle).DeleteBookedNumber("2","1")
ClassMethod DeleteBookedNumber(ResSchduleID As %String, PaadmID As %String) As %String
{
	s num=0 ,j=0
	s Paadmdr="" f  s Paadmdr=$o(^DHCRISBOOKEDTEMP(ResSchduleID,Paadmdr)) q:Paadmdr=""  d
	.s JRowid="" f  s JRowid=$o(^DHCRISBOOKEDTEMP(ResSchduleID,Paadmdr,JRowid)) q:JRowid=""  d
	..i (Paadmdr=PaadmID) d
	...s num=num+1
	...s j=JRowid
	i (num>=1)
	{
	   k ^DHCRISBOOKEDTEMP(ResSchduleID,PaadmID,j)	
	}
	
	i (num=1)
	{
		i ($g(^DHCRISBKINDEX(ResSchduleID))>0) d
	    .s ^DHCRISBKINDEX(ResSchduleID)=^DHCRISBKINDEX(ResSchduleID)-1
	}
	
	q 0
}

/// 函数：QueryResApptSchdule
/// 功能：查询设备的预约资源明细
/// 参数：CT_Loc.Rowid,RB_Resouce.Rowid,开始日期,结束日期
/// 作者：sunyi
/// 日期: 2011-08-05
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResSchduleDetail","83","","62720","62728")
Query QueryResSchduleDetail(LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String")
{
}

ClassMethod QueryResSchduleDetailExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TEMP=LocId_"^"_ResourceId_"^"_StartDate_"^"_EndDate
 	
 	i StartDate="" s StartDate=+$h
 	i EndDate="" s EndDate=+$h
 	
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

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime)
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

/// 判断医嘱是否已取消预约
/// sunyi 2013-04-22
/// w ##class(web.DHCRisResourceApptSchudleEx).IsCancelBooked("18349||5")
ClassMethod IsCancelBooked(perOrditemRowid) As %String
{
	s Cancel="N"
	s DRowid=""
	s DRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,DRowid))
	i DRowid'="" d
	.s Flag=""
	.s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",7)
	.i Flag="Cancel" s Cancel="Y"
	q Cancel
}

/// 返回预约资源ID
/// sunyi 2013-04-22
/// w ##class(web.DHCRisResourceApptSchudleEx).GetSchduleID("20017||3881")
ClassMethod GetSchduleID(perOrditemRowid) As %String
{
	s (DRowid,SchduleID)=""
	s DRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,DRowid))
	i DRowid'="" d
	.s Flags=""
	.s Flags=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",7)
	.i Flags'="Cancel" d
	..s SchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",2)
	q SchduleID
}

/// 返回更新类型 B-预约  I-登记
/// w ##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo("83")
ClassMethod IsUseUpdateNo(LocDR As %String) As %String
{
	s (Rowid,OpertionCode,OpertionDR,AppDateType,Info)=""
	q:(LocDR="") ""
	s Rowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocDR,Rowid))
	i Rowid'="" d
	.s OpertionDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",4)
	.i OpertionDR'="" s OpertionCode=$p($g(^DHCRBCStatus("PatientStatus",OpertionDR)),"^",1) 
	.s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",3)
	.s Info=OpertionCode_"^"_AppDateType
	q Info
}

/// 取消预约函数注释 sunyi 
/// 对于多预约医嘱转预约函数
/// sunyi 2012-12-09
ClassMethod DeleteBookInfo(Oeorditemdr) As %String
{
	Set $ZT="DERROR"
	s Count=$l(Oeorditemdr,"@")
	for i=1:1:Count 
    {
	    s perOrditemRowid=$p(Oeorditemdr,"@",i)
	    s OrderRowid=$p(perOrditemRowid,"||",1)
	    s itemsub=$p(perOrditemRowid,"||",2)
	    s approwid=""
	   	i $g(^OEORD(OrderRowid,"I",itemsub,6))'="" s approwid=$p(^OEORD(OrderRowid,"I",itemsub,6),"^",5)
	   	;q:$g(approwid)="" "" 
	   	;q:approwid=$C(0) "" 
	   	
	   	if (approwid'="")&&(approwid'=$c(0))
	   	{ 
		    TSTART
		   	&sql(update OE_OrdItem set OEORI_APPT_DR="" where OEORI_RowId=:perOrditemRowid)
		   	I SQLCODE TRollBack 
		    q:SQLCODE_"^"_"-1"  
		   
		   
		    s resrowid=$p(approwid,"||",1)
		   	s apptsch=$p(approwid,"||",2)
		   	s aptchildsub=$p(approwid,"||",3)
		    s Soltchild=0 f  s Soltchild=$o(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild)) q:Soltchild=""  d
		    .s apptschdr=$p(^RBAS(resrowid,apptsch,"APPT",aptchildsub,"SLOT",Soltchild),"^",2)
		    .s resrowid1=$p(apptschdr,"||",1)
		   	.s apptsch1=$p(apptschdr,"||",2)
		    .s BookedNums=$p(^RBAS(resrowid1,apptsch1),"^",11)
		   	.i BookedNums'="" s BookedNums=BookedNums-1
		   	.i BookedNums="0" s BookedNums=""
		   	.&sql(update RB_ApptSchedule set AS_BookedSlots=:BookedNums where AS_RowId=:apptschdr)
		   	
		   	;I SQLCODE TRollBack  Quit SQLCODE
		   	&sql(delete from RB_ApptFollowOnSlots where RBFOS_ParRef=:approwid)
		    I SQLCODE TRollback  
            q:SQLCODE_"^"_"-1"
		   
		   	&sql(delete from RB_Appointment where APPT_RowId=:approwid)
		   	I SQLCODE TRollBack  
		    q:SQLCODE_"^"_"-1"
		    
		    TCOMMIT
		 }
		 else 
	   	 {
		   	s SQLCODE=..CancelBookedInfo(perOrditemRowid)
	     }
		    
		 s DHCENSInfo="",ret="0"
		 ;s DHCENSInfo=##class(DHCENS.BC.BS.WebBCService).CancelHisBookedInfo(perOrditemRowid)
		 ;s ret=$p(DHCENSInfo,"^",1) 	    
		    
    }  
   	q SQLCODE_"^"_ret
   	
DERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	q SQLCODE_"^"_ret
}

/// w ##class(web.DHCRisResourceApptSchudleEx).GetBookedResult("236683||10")
ClassMethod GetBookedResult(OrditemRowid) As %String
{
	s (Info,StudyNo,EqDR,EQGroupDR,RoomDR,EQDesc,EQGroupDesc)=""
	s (EqIndex,GroupIndex,RoomIndex,IndexTypeDR,IndexTypeDesc)=""
	s (RoomDesc,Flag)=""
	
	q:(OrditemRowid="") Info
	
	s DRowid=""
	s DRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,DRowid))
	i DRowid'="" s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",7)
	i ((Flag'="Cancel")&(DRowid'="")) d
	.s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",6)
	.s EqIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",8)
	.s GroupIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",9)
	.s RoomIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",10)
	.s EqDR=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",11)
	.s EQGroupDR=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",12)
	.s RoomDR=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",13)
	.i EqDR'="" s EQDesc=$p($g(^RBC("EQ",EqDR)),"^",2)
	.i EQGroupDR'="" s EQGroupDesc=$p(^RBC("GRP",EQGroupDR),"^",2)
	.i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
	.s IndexTypeDR=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",14)
	.i IndexTypeDR'="" s IndexTypeDesc=$p($g(^DHCRBCIndexType(IndexTypeDR)),"^",2)
	.s Info=StudyNo_"^"_EqDR_"^"_EQGroupDR_"^"_RoomDR_"^"_EQDesc_"^"_EQGroupDesc_"^"_RoomDesc_"^"_EqIndex_"^"_GroupIndex_"^"_RoomIndex_"^"_IndexTypeDesc
	
	q Info
}

/// w ##class(web.DHCRisResourceApptSchudleEx).SetSelResources("4119")
ClassMethod SetSelResources(SchudleRowid As %String)
{
	 s (ResourceId,ResDesc,CTCPDR,EQDR,ResDesc,RoomDR,GroupDescDR,RoomDesc,Info)=""
	 s (RoomDesc)=""
	 s ^tts=SchudleRowid
	 i SchudleRowid'="" d
     .s ResourceId=$p($g(^DHCRBCResourceSchdule(SchudleRowid)),"^",1)
     .s ResDesc=""
 	 .s CTCPDR=$p($g(^RB("RES",ResourceId)),"^",2)
     .s CTCPDR=$p(CTCPDR,$c(0))
     .i CTCPDR'="" d
     ..s ResDesc=$p($g(^CTPCP(CTCPDR,1)),"^",2)
     .else  d
     ..s EQDR=$p($g(^RB("RES",ResourceId)),"^",3)
     ..s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
     ..s RoomDR=$o(^DHCRBC("EQDR-ROOM",EQDR,""))
     ..i RoomDR'="" s RoomDesc=$p($g(^DHCRBC("Room",RoomDR)),"^",2)
     ..s GroupDescDR=$p($g(^RBC("EQ",EQDR)),"^",3)
     ..i GroupDescDR'="" s GroupDesc=$p($g(^RBC("GRP",GroupDescDR)),"^",2)
     .s Info=$g(EQDR)_"^"_$g(RoomDR)_"^"_$g(GroupDescDR)_"^"_$g(ResDesc)_"^"_$g(RoomDesc)_"^"_$g(GroupDesc)
    
    q Info
}

ClassMethod IsBooked(perOrditemRowid) As %String
{
	s (DRowid,Flag,IsBook)=""
	q:(perOrditemRowid="") IsBook
	s DRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,DRowid))
	i DRowid'=""  s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",DRowid)),"^",7)
	i ((DRowid'="")&(Flag'="Cancel")) d
	.s IsBook="Y"
	q IsBook
}

/// w ##class(web.DHCRisResourceApptSchudleEx).IsCreateStudyNo("83")
ClassMethod IsCreateStudyNo(LocDR As %String) As %String
{
	s Rowid="",OperationDR="",Operation=""
	s Rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDR,Rowid))
	i Rowid'="" d
	.s OperationDR=$p(^DHCPACRegInfoCR("CreateRule",0,Rowid),"^",7)
	.i OperationDR'="" s Operation=$p($g(^DHCRBCStatus("PatientStatus",OperationDR)),"^",1)
	q Operation
}

/// 功能 同一病人，不同医嘱预约时间是否冲突
/// liuyang 20130515
/// 修改人:孙毅
/// w ##class(web.DHCRisResourceApptSchudleEx).BookedConflictEx("20019","4870")
/// 生成资源的排版计划
/// 修改可以按科室生成排版计划 
/// sunyi 2012-1-10
/// d ##class(web.DHCRisResourceApptSchudle).CreateResApptSchulde("402^5802^05/10/2016^05/10/2016")
ClassMethod CreateResApptSchuldeX(Info As %String) As %String
{
	s ^TMPpAN("Create")=Info
	s LocId=$p(Info,"^",1)
	s ResourceId=$p($g(Info),"^",2)
	s StartDate=$p(Info,"^",3)
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	q:(ResourceId="") 0
    s Count=$l(ResourceId,"@")
    s ResID=ResourceId
    
    if ((StartDate="") || (StartDate="ERROR!"))  s StartDate=+$h
	
	s EndDate=$p(Info,"^",4)
	q:EndDate="" 0  	
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	
	;预约方式  1[最大数预约]  2[检查时间预约]
	s locParamDr="",locScheType=1
	s locParamDr=$o(^DHCRBC("Loc",LocId,locParamDr))
	if locParamDr'="" d
	.s locScheType=$p($g(^DHCRBC("LocParam",locParamDr)),"^",23)

    s SQLCODE=100
   
     
     
     for CurrDate=StartDate:1:EndDate 
     {
     	for i=1:1:Count
     	{
     		s ResourceId=$p(ResID,"@",i)
     		s WeekNum=$zd(CurrDate,10)
     		i WeekNum=0 s WeekNum=7
     		s allNum=0
     		s stTime=""
     		for
     		{
	     		s stTime=$o(^DHCRBCResPlani("LocSTime",LocId,ResourceId,WeekNum,stTime) )
	     		q:(stTime="")
	     		s resPlanRowid=0
	     		for
	     		{
		     		s resPlanRowid=$o(^DHCRBCResPlani("LocSTime",LocId,ResourceId,WeekNum,stTime,resPlanRowid) )
		     		q:(resPlanRowid="")
		     		
		     		s NextStartTime="",RemainTime="",availPatTypeCode=""
	 				s ServiceGroupID=$p(^DHCRBCResourcePlan(resPlanRowid),"^",3)
	 				s TimePeriodCode=$p(^DHCRBCResourcePlan(resPlanRowid),"^",4)  //时间段代码
	 				s StartTime=$p(^DHCRBCResourcePlan(resPlanRowid),"^",5)
	 				s EndTime=$p(^DHCRBCResourcePlan(resPlanRowid),"^",6)
	 				s Max=$p(^DHCRBCResourcePlan(resPlanRowid),"^",8)
     				s AutoNumber=$p(^DHCRBCResourcePlan(resPlanRowid),"^",9)
     				;超声科判断医生排班,计算最大数量
     				;s NumberOfHour=..getNumByDateTimeRes(ResourceId,CurrDate,StartTime,EndTime)
     				;b //01
     				;if ((LocId="402")||(LocId="3458")) d
     				;.s Max=$fn((EndTime-StartTime)/3600*NumberOfHour,"",0)
     				;.s AutoNumber=Max
     				;b //02
     				continue:(Max=0)
     				s ChargTime=$p(^DHCRBCResourcePlan(resPlanRowid),"^",10)
     				s AvailTime=+$p(^DHCRBCResourcePlan(resPlanRowid),"^",12)
     				s availPatTypeCode=$p($g(^DHCRBCResourcePlan(resPlanRowid)),"^",14)
     				continue:($p($g(^DHCRBCResourcePlan(resPlanRowid)),"^",15)="Y")
     				b //04
     				s NextStartTime=StartTime
     				s RemainTime=(EndTime-StartTime)/60
     				if (AvailTime'=0) d  //设置了可用时间就不使用全部时间
     				.s RemainTime=AvailTime
					s RangeOfQueueNum=(allNum+1)_"-"_(allNum+Max)
					
					s ResSchRowid=$o(^DHCRBCResSchdulei("Resource-Date",LocId,ResourceId,CurrDate,resPlanRowid,0))
     				b //03
     				i ResSchRowid=""    ; 资源计划不存在插入
     				{
	     				if (locScheType=2)
	     				{
		     				&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType,DRPS_RangeOfQueueNumber ) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:resPlanRowid,:ChargTime,:NextStartTime,:RemainTime,:availPatTypeCode,:RangeOfQueueNum))
	     				}
	     				else
	     				{
		     				&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_AvailPatType,DRPS_RangeOfQueueNumber ) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:resPlanRowid,:ChargTime,:NextStartTime,:availPatTypeCode,:RangeOfQueueNum))
	     				}
     				}
     				else
     				{
	     				//&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType,DRPS_RangeOfQueueNumber ) 
     					//		values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:resPlanRowid,:ChargTime,:NextStartTime,:RemainTime,:availPatTypeCode,:RangeOfQueueNum))
	     				
     				}
	     			s allNum=allNum+Max
	     		}
     		}
     		
     
     	}
     }
     q SQLCODE
}

/// 20019^4909 --20019^4901
ClassMethod BookedConflictEx(EpsodeId As %String, gReSchudleRowid As %String) As %String
{
	s ^t("RIS-TEST")=EpsodeId_"^"_gReSchudleRowid
 	n (EpsodeId,gReSchudleRowid)
 	
 	Quit:EpsodeId="" 
 	s Info="",BCfg="",IsConflict="N",ret=""
 	s Info=##class(web.DHCRisCodeTableAdd).GetSystemParam()
 	s BCfg=$p(Info,"^",7)
 	q:(BCfg="N")!(BCfg="") ret
 	
	
	s gResouceId=$p(^DHCRBCResourceSchdule(gReSchudleRowid),"^",1)
	s gDate=$p(^DHCRBCResourceSchdule(gReSchudleRowid),"^",2)
	s gTime=$p($g(^DHCRBCResourceSchdule(gReSchudleRowid)),"^",5)
	s gServiceGroupId=$p($g(^DHCRBCResourceSchdule(gReSchudleRowid)),"^",4)

	s OrdItemRowid=0 f  s OrdItemRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid)) q:OrdItemRowid=""  d
	.s ResDetailRowid=""  f  s ResDetailRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid,ResDetailRowid))  q:ResDetailRowid=""  d
	..s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrdItemRowid,0))
	..q:RegRowid'=""
	..i ResDetailRowid'="" d
	...s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",2)
	...s Flag=""
	...s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",7)
	...q:(Flag="Cancel")
	...i ResSchduleID'="" d
	....s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
	....s ResourceDesc=""
	....i ResouceId'="" d
	.....s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	.....s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	.....i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
	.....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	....s GetServiceGroupId=""
	....s GetServiceGroupId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",4)
	....s Date=""
	....s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	....s BookedDate=$zd(Date,3)
	....s TimeDescCode=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",3)
	....s TimeDesc=""
	....i TimeDescCode'="" d
	.....s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	.....s TimeDesc=$p($g(^DHCRBCTimePeriodSet(TimeDescRowid)),"^",2)
	....s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
	....s BooketTime=$zt(StartTime)
	....s OrderRowid=$p(OrdItemRowid,"||",1)
	....s ItemRowid=$p(OrdItemRowid,"||",2)
	....s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1) 
	....i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
    ....i papatmasmdr'="" d
    .....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    .....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	....s ArcItemId=$p( ^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	....s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	....s LocId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",11)
	....s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2)
	....q:(gResouceId=ResouceId)&(gReSchudleRowid=ResSchduleID)
	....i ((gResouceId'="")&(gResouceId'=ResouceId)&(gDate=Date)&(gTime=StartTime)&(gServiceGroupId'=GetServiceGroupId))  s IsConflict="Y"
	....s ret=""
	....s ret=BookedDate_"^"_TimeDesc_"^"_BooketTime_"^"_strOrderName_"^"_LocDesc_"^"_ResourceDesc_"^"_Name_"^"_RegNo
	....i IsConflict="Y" BREAK:ret
	
    q ret
}

/// 对于预约是产生检查号,登记是不产生故需要从预约表取到生成的检查号
/// sunyi 2013-07-26
/// w ##class(web.DHCRisResourceApptSchudleEx).RequestStudyNo("20017||3883@20017||3885")
ClassMethod RequestStudyNo(OrditemRowid As %String) As %String
{
	 s count=$l(OrditemRowid,"@")
	 s Info=""
     for i=1:1:count d
     .s perOrditemRowid=$p(OrditemRowid,"@",i)
     .s Rowid="" f  s Rowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,Rowid)) q:(Rowid="")  d
     ..s (StudyNo,CAFlag)=""
     ..s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",6)
     ..s CAFlag=$p($g(^DHCRBCResSchduleDetail("Detail",Rowid)),"^",7)
     ..q:(CAFlag="Cancel")
     ..i Info="" s Info=StudyNo
     ..e  d
     ...s Info=Info_"@"_StudyNo
     
     q Info
}

/// w ##class(web.DHCRisResourceApptSchudleEx).InitAutoBookedData("5037","58460||1782","63042")
ClassMethod InitAutoBookedData(SchudleRowid As %String, oeorditemrowid, SelectDate As %String = "", InStudyNo As %String = "") As %String
{
	s (Infos,ResourcesInfo,GetEQDR,GetRoomDR,GroupDescDR,GetResDesc,GetRoomDesc,GroupDesc)=""
	s (IndexclsInfo,GetLocDR,Param,GetIndex,GetNoRuleCode,GetTypeDesc,GetAppDateType,GetTypeRowid)=""
	s (Index,GroupIndex,RoomIndex,paadmdr,IsCStudyNo,IsCIndex,StudyNo)=""
	s (StudyInfo,IsUpdate,StudyNumber)=""
	
	q:(SchudleRowid="") Infos
	q:(oeorditemrowid="") Infos
	
	i SelectDate="" s SelectDate=+$h
	s SelectDate=$zd(SelectDate,"3")
	
	s ResourcesInfo=..SetSelResources(SchudleRowid)
	i ResourcesInfo'="" d
	.s GetEQDR=$p($g(ResourcesInfo),"^",1)
	.s GetRoomDR=$p($g(ResourcesInfo),"^",2)
	.s GroupDescDR=$p($g(ResourcesInfo),"^",3)
	.s GetResDesc=$p($g(ResourcesInfo),"^",4)
	.s GetRoomDesc=$p($g(ResourcesInfo),"^",5)
	.s GroupDesc=$p($g(ResourcesInfo),"^",6)
	.s GetLocDR=$p(^OEORD($p(oeorditemrowid,"||",1),"I",$p(oeorditemrowid,"||",2),3),"^",6)
	.s paadmdr=$p(^OEORD($p(oeorditemrowid,"||",1)),"^",1)
	.s Param=GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_GetLocDR_"^"_oeorditemrowid_"^"_SchudleRowid
	.s IsCIndex=..IsUseUpdateNo(GetLocDR)
	.i IsCIndex'="" s IsCIndex=$p(IsCIndex,"^",1)
	.s IsCStudyNo=..IsCreateStudyNo(GetLocDR)
	.i InStudyNo="" d
	..i IsCIndex="B" d
	...s IndexclsInfo=##class(web.DHCRisPatRegisterDoEx).GetIndexcls(Param)
	...i IndexclsInfo'="" d
	....s GetIndex=$p(IndexclsInfo,"^",1)
	....s GetNoRuleCode=$p(IndexclsInfo,"^",2)
	....s GetTypeDesc=$p(IndexclsInfo,"^",3)
	....s GetAppDateType=$p(IndexclsInfo,"^",4)
	....s GetTypeRowid=$p(IndexclsInfo,"^",5)
	....i GetNoRuleCode="L" s Index=GetIndex
	....i GetNoRuleCode="Z" s GroupIndex=GetIndex
	....i GetNoRuleCode="R" s RoomIndex=GetIndex
	..;i ((IsCStudyNo="B")!(IsCStudyNo="")) d
	..s StudyInfo=##class(web.DHCRisPatRegisterDoEx).GetStudyNo(oeorditemrowid,GroupDesc,GetLocDR,SelectDate)
	..i StudyInfo'="" d
	...s StudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	...s StudyNumber=$p($g(StudyInfo),"^",2)
	...s IsUpdate=$p($g(StudyInfo),"^",3)
	.e  d
	..s StudyNo=InStudyNo
	.s Infos=StudyNo_"^"_Index_"^"_GroupIndex_"^"_RoomIndex_"^"_GetEQDR_"^"_GroupDescDR_"^"_GetRoomDR_"^"_paadmdr_"^"_GetTypeRowid_"^"_SelectDate_"^"_StudyNumber_"^"_IsUpdate
	q Infos
}

/// w ##class(web.DHCRisResourceApptSchudleEx).RequestBookInfo("152||19")
ClassMethod RequestBookInfo(oeorditemdr As %String) As %String
{
	s BookedRowid="",Flag="",AppointDate="",AppointstTime=""
	s Info="",SchRowid=""
	q:(oeorditemdr="") "^"
	
	s BookedRowid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	i BookedRowid'="" d
    .s Flag=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",7)
	.q:(Flag="Cancel")
	.s SchRowid=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",2)
	.q:(SchRowid="")
    .s AppointDate=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
	.s GetAppointDate=$zd(AppointDate,3)
	.s AppointstTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
	.if ( $p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)'="" ) d
	..s AppointstTime=$p($g(^DHCRBCResSchduleDetail("Detail",BookedRowid)),"^",18)
	.s GetAppointstTime=$zt(AppointstTime,1)
	.s Info=GetAppointDate_"^"_GetAppointstTime
	e  d
	.s ExtRowid=""
	.s ExtRowid=$o(^DHCRBCExternalBookInfoi("OrdItemID",oeorditemdr,ExtRowid))
	.i ExtRowid'="" d
	..s GetAppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
    ..s GetAppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	..s Info=GetAppointDate_"^"_GetAppointstTime
	q Info
}

/// w ##class(web.DHCRisResourceApptSchudleEx).getExamTime("152||19")
ClassMethod getExamTime(oeorditemdr As %String) As %String
{
	q:(oeorditemdr="") ""
	s arcItmMastDr=$p(^OEORD($p(oeorditemdr,"||",1),"I",$p(oeorditemdr,"||",2),1),"^",2)
	q:(arcItmMastDr="") ""
	s itemBookProDr=""
	s itemBookProDr=$o(^DHCRBCItemBookProperTypei(arcItmMastDr,itemBookProDr))
	q:(itemBookProDr="") ""
	s time=$p(^DHCRBCItemBookProperty(itemBookProDr),"^",9)
	q time
}

/// w ##class(web.DHCRisResourceApptSchudleEx).IsUpResSchdule("CS20141017-020")
ClassMethod IsUpResSchdule(InStudyNo As %String) As %String
{
	s IsUp="N"
	q:(InStudyNo="") "Y"
	
	s Count=0
	s Rowid="" f  s Rowid=$o(^DHCRBCResSchduleDetaili("StudyNo",InStudyNo,Rowid)) q:(Rowid="")  d
	.s Count=Count+1
	.;w !,"Count="_Count
	
	i Count=1 s IsUp="Y"
	q IsUp
}

}
