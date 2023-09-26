Import SQLUser

/// 资源计划
Class web.DHCRisResourceApptSchudle Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResourceWeekPlan",83,918)

/// 函数：QueryResourceWeekPlan
/// 功能：查询资源的星期计划
/// 修改: sunyi 2015-04-22 增加返回列"不允许住院病人预约"
Query QueryResourceWeekPlan(LocId As %String, ResourceId As %String, FindNotAvail As %String = "") As %Query(ROWSPEC = "TWEEK:%String,TServiceGroup:%String,TTimeDesc:%String,TStartTime:%String,TEndTime:%String,TMax:%String,TAutoNumber:%String,TRowid:%String,TWeekNum:%String,TSerivceGourpId:%String,TTimePeriodCode:%String,TChargTime:%String,TUseLock:%String,TAvailTime:%String,TNotAllowIPBook:%String,TAvailPatType:%String,TAvailPatTypeCode:%String,NotAvailable:%String")
{
}

ClassMethod QueryResourceWeekPlanExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, FindNotAvail As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i ResourceId="" s qHandle=$lb(0,repid,0)
	Quit:ResourceId="" $$$OK
	
	i LocId="" s qHandle=$lb(0,repid,0)
	Quit:LocId="" $$$OK
	
	s ^DHCRisTemp("QueryResourceWeekPlan")=LocId_"^"_ResourceId_"^"_FindNotAvail
	//^DHCRBCResPlani("LocSTime",loc,res,week,st)
    s WeekNumber=""
    for 
    {
	    s WeekNumber=$o(^DHCRBCResPlani("LocSTime",LocId,ResourceId,WeekNumber))
	    q:(WeekNumber="")
	    s stTime=""
	    for
	    {
		    s stTime=$o(^DHCRBCResPlani("LocSTime",LocId,ResourceId,WeekNumber,stTime))
		    q:(stTime="")
		    //Set RowId=0	f  s RowId=$o(^DHCRBCResourcePlani("LocId",LocId,ResourceId,RowId)) q:RowId=""  d
		    Set RowId=0	f  s RowId=$o(^DHCRBCResPlani("LocSTime",LocId,ResourceId,WeekNumber,stTime,RowId)) q:RowId=""  d
			.s (TimeDesc,ServiceGroup)=""
			.s WeekNumber=$p(^DHCRBCResourcePlan(RowId),"^",7)
			.s Week=..GetWeek(WeekNumber)
			.s ServiceGroupID=$p(^DHCRBCResourcePlan(RowId),"^",3)
			.i ServiceGroupID'="" d
			..s ServiceGroup=$p($g(^RBC("SG",ServiceGroupID)),"^",2)
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
		    .s UseLock=""
		    .s UseLock=$p($g(^DHCRBCResourcePlan(RowId)),"^",11)
		    .s availTime=""
		    .s availTime=$p($g(^DHCRBCResourcePlan(RowId)),"^",12)
		    .s NotAllowIPBook=$p($g(^DHCRBCResourcePlan(RowId)),"^",13)
		    .i NotAllowIPBook="" s NotAllowIPBook="N"
		    .;w !,availTime
		    .s (availPatType,availPatTypeCode)=""
		    .s availPatTypeCode=$p($g(^DHCRBCResourcePlan(RowId)),"^",14)
		    .s availPatType=..changePatTypeCode(availPatTypeCode)
		    .s NotAvailable=$p($g(^DHCRBCResourcePlan(RowId)),"^",15)
		 	.q:((NotAvailable="Y")&&(FindNotAvail'="Y"))
		    .Do OutRow
	    }
	
    }
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(Week,ServiceGroup,TimeDesc,StartTime,EndTime,Max,AutoNumber,RowId,WeekNumber,ServiceGroupID,TimePeriodCode,ChargeTime,UseLock,availTime,NotAllowIPBook,availPatType,availPatTypeCode,NotAvailable)
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
	.s Code=$p($g(^DHCRBCTimePeriodSet(RowId)),"^",1)
	.s Desc=$p($g(^DHCRBCTimePeriodSet(RowId)),"^",2)
	.q:($p(^DHCRBCTimePeriodSet(RowId),"^",6)="Y")
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
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryServiceGroup")
Query QueryServiceGroup() As %Query(ROWSPEC = "Code:%String,Name:%String,RowId:%String")
{
}

ClassMethod QueryServiceGroupExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	// RBC_ServiceGroup
 	s Today=+$h
	Set RowId=0	f  s RowId=$o(^RBC("SG",RowId)) q:RowId=""  d
	.s Code=$p(^RBC("SG",RowId),"^",1)
	.s Name=$p(^RBC("SG",RowId),"^",2)
	.s DateTo=$p(^RBC("SG",RowId),"^",7)
	.s ResStarDate=$p(^RBC("SG",RowId),"^",6)
	.q:(Today<ResStarDate)
	.s ResEndDate=$p(^RBC("SG",RowId),"^",7)
	.q:((ResEndDate'=""))
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
/// w ##class(web.DHCRisResourceApptSchudle).InsertResoucePlan(^DHCRisTemp("InsertResoucePlan"))
ClassMethod InsertResoucePlan(Info As %String) As %String
{
	s ^mictmp=Info
	s ^DHCRisTemp("InsertResoucePlan")=Info
	s LocId=$p(Info,"^",1)
	s ResourceId=$p(Info,"^",2)
	q:(ResourceId="") "1111^0"
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
    s UseLock=$p(Info,"^",11)
    s availTime=$p(Info,"^",12)
    s NotAllowIPBook=$p(Info,"^",13)
    s availPatTypeCode=$p(Info,"^",14)
    s notAvail=$p(Info,"^",15)
    s rowid=""
    &sql(insert into DHCRBC_ResPlan (DRP_LOCID,DRP_RESOURCEID,DRP_WEEK,DRP_ServiceGroupID,DRP_Desc,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime,DRP_UseLock,DRP_AvailTime,DRP_NotAllowIPBooked,DRP_AvailPatType,DRP_NotAvailable)
         values ( :LocId,:ResourceId,:WeekNum,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:BookMaxNumber,:AutoNumber,:ChargTime,:UseLock,:availTime,:NotAllowIPBook,:availPatTypeCode,:notAvail))
    s rowid=$p(%ROWID,$c(1))
    
    q SQLCODE_"^"_rowid
}

/// 函数:InsertBookedInfo
/// 功能:插入病人的预约信息
/// 作者:sunyi 
/// 日期:2015-01-06 
/// s ret=##class(web.DHCRisResourceApptSchudle).InsertBookedInfo(^DHCRis("Ris2015"))
ClassMethod InsertBookedInfo(Info As %String) As %String
{
	s ^DHCRis("Ris2015")=Info
	
	s OrderItemRowid=$p(Info,"^",1)
	s ResSchduleID=$p(Info,"^",2)
	s AppointMethod=$p(Info,"^",3)      ; 1: 手动， 2：自动
	s OherParam=$p($g(Info),"^",4)     //计费标识 HIS
    s InLocDR=$p($g(Info),"^",5)
    s paadr=$p($g(Info),"^",6)
    s InputRegDate=$p($g(Info),"^",7)
    s UserDR=$p($g(Info),"^",8)
    s GetStudyNo=$p($g(Info),"^",9) //PACS传入的检查号
    s bookTimeIn=$p($g(Info),"^",10)
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	i bookTimeIn'="" d
	.s bookTime=$zth(bookTimeIn,2)
	
	i InputRegDate="" d
	.s bookDateGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	.s InputRegDate=$zd(bookDateGet,3)
	;s bookDateGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	;s InputRegDate=$zd(bookDateGet,3)
    
    n MaxNumber,AutoNumber,UseNumber,RemainNumber,AutoUseNumber,nextStartTime,remainTime
    s RegEQIndex="",CheckGroupIndex="",RoomIndex="",IsUpBookNo="",IndexTypeDR=""
    s bookType="1"   ; 1为按最大数预约   2为按检查时间预约
    
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
   
    s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    i (remainTime'="")&&(nextStartTime'="") d
    .s bookType="2"
	
    
    Set $ZT="ERROR"	
    s Count=$l(OrderItemRowid,"@")
    
     //判断是否有已经预约的记录 wangfeng 
    s ret=..hasBookOrder(OrderItemRowid)
    q:(ret="Y") "-11112"
    //先判断是不是同一个病人的医嘱
	s isSamePat=##class(web.DHCRisRegisterPatientDoEx).isSamePatient(OrderItemRowid)
	q:(isSamePat="N") "-11111"

    
    lock +(^DHCRisTMPReg)
    k ^DHCRISTMP("STUDYNO")
    
    //TSTART
    //判断此时间点已经有预约,
    s detailDr=""
    if (bookTimeIn'="")
    {
    	s detailDr=$o(^DHCRBCResSchduleDetaili("BKSTARTTIME",ResSchduleID,bookTime,detailDr))
    }
    if ( detailDr'="")
    {
	    lock -(^DHCRisTMPReg)
		s SQLCODE="-10055",ret="0"
		q
    }
    
    s EqInfo="",EQDr="",EQGroupDR="",RoomDR="",GroupDesc=""
    i ResSchduleID'="" d
    .s EqInfo=..GetResources(ResSchduleID)
    .;w !,"EqInfo="_EqInfo
    .s EQDr=$p($g(EqInfo),"^",1)
    .s EQGroupDR=$p($g(EqInfo),"^",3)
    .s RoomDR=$p($g(EqInfo),"^",2)
    .s GroupDesc=""
    .i EQGroupDR'="" s GroupDesc=$p($g(^RBC("GRP",EQGroupDR)),"^",2)
    .s MuitStudyNo=..GetMutiStudyNo(OrderItemRowid,GroupDesc,InLocDR,InputRegDate,EQGroupDR)
    .;w !,"MuitStudyNo="_MuitStudyNo
    s ^DHCRisTemp("InsertBookInfo",$p(MuitStudyNo,"@",1),+$h,$p($h,",",2))=OrderItemRowid_"****"_MuitStudyNo
    for Ni=1:1:Count 
    {
	  s Arrearage="1"
      s perOrditemRowid=$p(OrderItemRowid,"@",Ni)
      s StudyNo=$p($g(MuitStudyNo),"@",Ni)
      i GetStudyNo'="" s StudyNo=GetStudyNo
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
	  
	   /*
	   //wf 20150920
	  s arcimid=$p($g(^OEORD(OrdRowid,"I",itemsub,1)),"^",2)
      if ((arcimid="10450||1")||(arcimid="4249||1"))
      {
	     continue 
      }*/
	  
	  /*
	  //医嘱对应的就诊记录是否一致
	  i (paadr'=EpisodeID)
	  {
		 lock -(^DHCRisTMPReg)
		 s SQLCODE="-10002",ret="0"
		 q:SQLCODE
      }
      */
      s BKS=""
	  s RecLocdr=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
	  i RecLocdr'="" s BKS=..GetSaveBKFlag(RecLocdr)
	  s UseInfo="",UpType="",AppDateType=""
	  s UseInfo=##class(web.DHCRisResourceApptSchudleEx).IsUseUpdateNo(RecLocdr)
	  i (UseInfo'="")
	  {
		 s UpType=$p(UseInfo,"^",1)
		 s AppDateType=$p(UseInfo,"^",2)
	  }
	 
	  if ('$d(^DHCRISTMP("STUDYNO",StudyNo)))
	  {
		   s MaxParam="",MaxIndexInfo=""
		   s MaxParam=EQDr_"^"_EQGroupDR_"^"_RoomDR_"^"_RecLocdr_"^"_perOrditemRowid_"^"_ResSchduleID_"^"_InputRegDate_"^"_BKS
		   
		   s MaxIndexInfo=..GetCurrentBookMaxIndex(MaxParam)
		   s ^DHCRisTemp("insertbookinfo","getNo",StudyNo,+$h,$p($h,",",2))=MaxIndexInfo_"@@@"_MaxParam
		   ;w !,"MaxIndexInfo="_MaxIndexInfo
		   i MaxIndexInfo'="" d
		   .s RegEQIndex=$p($g(MaxIndexInfo),"^",1)
		   .s CheckGroupIndex=$p($g(MaxIndexInfo),"^",2)
		   .s RoomIndex=$p($g(MaxIndexInfo),"^",3)
		   .s IsUpBookNo=$p($g(MaxIndexInfo),"^",4)
		   .s IndexTypeDR=$p($g(MaxIndexInfo),"^",5)
	  }

	  s Arrearage=##Class(web.UDHCJFARREARSMANAGE).CheckArrearsLevel(EpisodeID,"A","完全控制")
	  i (Arrearage="1")
	  { 
	     lock -(^DHCRisTMPReg)
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
   	  ;wangfeng  服务台预约判断手动预约数
   	  i AutoNumber="" s AutoNumber=0
   	  s ManualNumber=MaxNumber-AutoNumber
   	  s ManulaUseNumber=UseNumber-AutoUseNumber
   	  
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
      i ((MehtodDesc="无需预约")!(MehtodDesc="不需预约")) lock -(^DHCRisTMPReg)
      q:(MehtodDesc="无需预约")!(MehtodDesc="不需预约")    
     
      ;按检查时间预约，但是项目检查时间为空 退出 返回-1100
      
      if ((bookType="2")&&(ExamTime="")) d
      .s SQLCODE=-1100,ret=0 
      .lock -(^DHCRisTMPReg)
      
      q:(bookType="2")&&(ExamTime="")
      
      TSTART
      s SQLCODE=100
      ;判断自动预约数量已满退出避免多占资源 
      i ('$d(^DHCRISTMP("STUDYNO",StudyNo))&(AutoUseNumber'=0)&(AutoUseNumber=AutoNumber)&(AppointMethod="2")) lock -(^DHCRisTMPReg) s ret="0"
      q:('$d(^DHCRISTMP("STUDYNO",StudyNo))&(AutoUseNumber'=0)&(AutoUseNumber=AutoNumber)&(AppointMethod="2"))
      s IsCancel=""
      s IsCancel=##class(web.DHCRisResourceApptSchudleEx).IsCancelBooked(perOrditemRowid)
     
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
	      i ((AppointMethod="2")&(AutoUseNumber<=AutoNumber)!((AppointMethod'="2")&(MaxNumber>UseNumber)))
	      {
		       s startTime=nextStartTime
			  i ( (startTime+(ExamTime*60)) < stopTime )
			  { 
			  	s endTime=ExamTime*60+nextStartTime
			  }
			  else
			  {
				  s endTime=stopTime
			  }
	        &sql(update DHCRBC_ResSchduleDetail (DRPD_ResSchdule_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex,DRPD_RoomIndex,DRPD_CAFlag,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime)
	                           values (:ResSchduleID,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,'Booked',:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime) where  DRPD_OrderItem_ID=:perOrditemRowid) 
	        i (AppointMethod="2")&(AutoUseNumber<AutoNumber)&(('$d(^DHCRISTMP("STUDYNO",StudyNo))))  s AutoUseNumber=AutoUseNumber+1            
	       s updateNextStartTime=endTime
		   i ((remainTime-ExamTime)>0) d
		   .s updateRemainTime=remainTime-ExamTime
		   e  d
		   .s updateRemainTime=0
	      } 
      	}                    
      	else
      	{
	      	  s startTime=nextStartTime
			  i ( (startTime+(ExamTime*60)) < stopTime )
			  { 
			  	s endTime=ExamTime*60+nextStartTime
			  }
			  else
			  {
				  s endTime=stopTime
			  }
	     	i ((AppointMethod="2")&(AutoUseNumber<=AutoNumber)) d
	     	.&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime) 
	    					values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime)) 
	        .if ('$d(^DHCRISTMP("STUDYNO",StudyNo))) s AutoUseNumber=AutoUseNumber+1
	        s updateNextStartTime=endTime
		    i ((remainTime-ExamTime)>0) d
		    .s updateRemainTime=remainTime-ExamTime
		    e  d
		    .s updateRemainTime=0		
	     	
	     	else  if ((ManualNumber>ManulaUseNumber)||($d(^DHCRISTMP("STUDYNO",StudyNo))))  d  //(MaxNumber>UseNumber)||($d(^DHCRISTMP("STUDYNO",StudyNo)))
	      	.&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,DRPD_CheckGroupIndex
	                          ,DRPD_RoomIndex,DRPD_EQ_DR,DRPD_EQGroup_DR,DRPD_Room_DR,DRPD_IndexType_DR,DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime) 
	    				    values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime))
      	 	s updateNextStartTime=endTime
		    i ((remainTime-ExamTime)>0) d
		    .s updateRemainTime=remainTime-ExamTime
		    e  d
		    .s updateRemainTime=0	
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
     I SQLCODE lock -(^DHCRisTMPReg)
	 q:SQLCODE 
	 
	 
     if ('$d(^DHCRISTMP("STUDYNO",StudyNo)))
     {
	     i (SQLCODE=0)&(IsUpBookNo="Y") d
	     .do ##class(web.DHCRisResourceApptSchudle).UpdateBookedIndexcls(RecLocdr,value,ResSchduleID)
	      
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
      i (StudyNo'="")                               //&('$d(^DHCRISTMP("STUDYNO",StudyNo))))
      {            
         do ##class(web.DHCRisSendToRis4Set).SendBookedtoRIS4(StudyNo,RecLocdr)
         //s num=$g(^dhcrisisip(StudyNo))
         //s ^dhcrisisip(StudyNo)=$i(num)
         //d ##class(RISService.InvokeRISService).InsertStudyInfoPACS(StudyNo,"B")
      }
      
      s ^DHCRISTMP("STUDYNO",StudyNo)=StudyNo
       
      I SQLCODE TRollback  
      I SQLCODE lock -(^DHCRisTMPReg)
      I SQLCODE q 
  	  TCOMMIT
    }
    
    lock -(^DHCRisTMPReg)
    q $g(SQLCODE)_"^"_$g(ret)
    
  /*
   ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^TempDHCRis("insertbookinfo")=ErrorMsg
 	TROLLBACK
 	lock -(^DHCRisTMPReg)
 	q $g(SQLCODE)_"^"_$g(ret)
 	*/
}

/// 函数 CancelBookedInfo
/// 功能：取消预约
/// d ##class(web.DHCRisResourceApptSchudle).CancelBookedInfo("20017||3895")
ClassMethod CancelBookedInfo(OrderItemRowid As %String)
{
	s ^ZYY=OrderItemRowid
	S $ZT="ERROR1"	
    s SQLCODE=100
    
    if ($d(^DHCRISTAUTOTEMP(OrderItemRowid)))
    {
	    s ^DHCRISTAUTOTEMP(OrderItemRowid)=""
	}
	s UpFlag="",RecLocdr="",IsSaveBookedIndex=""
	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,0))
	q:DetailRowid="" 100
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	q:ResSchduleID="" 100
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	s StudyNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	;判断是否更新预约资源数量
	s UpFlag=..IsUpSchdule(StudyNo)
	
	s RecLocdr=$p(^OEORD($p(OrderItemRowid,"||",1),"I",$p(OrderItemRowid,"||",2),3),"^",6)
	i RecLocdr'="" s IsSaveBookedIndex=..GetSaveBKFlag(RecLocdr)
	
	s GetCanelInfo="",ClIndex="",CParamCode="",CTypeRowid=""
	i IsSaveBookedIndex="Y" d
	.s GetCanelInfo=..GetCancelBookSaveNoParam(DetailRowid,RecLocdr)
	.s ClIndex=$p($g(GetCanelInfo),"^",1)
	.s CParamCode=$p($g(GetCanelInfo),"^",2)
	.s CTypeRowid=$p($g(GetCanelInfo),"^",3)
	
	
	;判断是否为按时间预约
	s bookType="1"
	n startTime,endTime,examTime
	s startTime=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",18)
	s endTime=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",19)
	if ( (startTime'="")&&(endTime'=""))
	{
		s examTime=##class(web.DHCRisResourceApptSchudleEx).getExamTime(OrderItemRowid)
		s bookType="2"
	}
	
	
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	lock +(^DHCRisTMPReg)
	TSTART
	if ( bookType="2")
	{
		&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
		I SQLCODE d
		.TRollback
		.lock -(^DHCRisTMPReg)
    	I SQLCODE q SQLCODE
    	&sql(update DHCRBC_ResSchdule set DRPS_RemainTime=(DRPS_RemainTime+:examTime) where  DRPS_RowID=:ResSchduleID)
		I SQLCODE  d
    	.TRollback
		.lock -(^DHCRisTMPReg) 
    	I SQLCODE q SQLCODE
	}
	else
	{
		&sql(delete from DHCRBC_ResSchduleDetail where DRPD_OrderItem_ID=:OrderItemRowid)
		;w !,"SQLCODE1="_SQLCODE
		;&sql(update DHCRBC_ResSchduleDetail(DRPD_CAFlag) values ('Cancel') where DRPD_OrderItem_ID=:OrderItemRowid)
		I SQLCODE d
		.TRollback
		.lock -(^DHCRisTMPReg)
    	I SQLCODE q SQLCODE
    	if AppointMethod="2" d
    	.i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    	
    	i UseNumber>0 s UseNumber=UseNumber-1
    	s RemainNumber=MaxNumber-UseNumber
    	i UpFlag="Y" d
    	.&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                           values (:AutoUseNumber,:RemainNumber,:UseNumber) where  DRPS_RowID=:ResSchduleID)
        .;w !,"SQLCODE2="_SQLCODE                   
        .i (SQLCODE=0)&(IsSaveBookedIndex="Y") d
        ..;w !,"SQLCODE="_SQLCODE
        ..do ..AddEqCancelIndex(ResSchduleID,ClIndex,CParamCode,CTypeRowid)
    	I SQLCODE  d
    	.TRollback
		.lock -(^DHCRisTMPReg) 
    	I SQLCODE q SQLCODE
	}
    
    ;更新医嘱表及医嘱状态表的的数据
    ;s Now=$zd(+$H,8)_$zt($p($h,",",2))
    ;s SQLCODE=##class(RISService.TrakRISService).ORMO01XX(OrderItemRowid,"CBK",Now,"","","")
    
    ;发送取消预约消息到RIS4系统
    do ##class(web.DHCRisSendToRis4Set).SendCanelBookedtoRIS4(OrderItemRowid)
    
  	TCOMMIT
  	lock -(^DHCRisTMPReg)
    q SQLCODE

ERROR1	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	lock -(^DHCRisTMPReg)
 	TROLLBACK
 	
 	q SQLCODE
}

/// 函数： UpdateResoucePlan
/// 功能： 更新资源计划
ClassMethod UpdateResoucePlan(Info As %String)
{
    s ^DHCRisTemp("UpdateResoucePlan")=Info
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
    s UseLock=$p($g(Info),"^",12)
    s availTime=$p($g(Info),"^",13)
    s NotAllowIPBook=$p($g(Info),"^",14)
    s availPatTypeCode=$p(Info,"^",15)
    s notAvail=$p(Info,"^",16)
        
    &sql(update DHCRBC_ResPlan (DRP_LOCID,DRP_RESOURCEID,DRP_WEEK,DRP_ServiceGroupID,DRP_Desc,DRP_StartTime,DRP_EndTime,DRP_Max,DRP_AutoNumber,DRP_ChargeTime,DRP_UseLock,DRP_AvailTime,DRP_NotAllowIPBooked,DRP_AvailPatType,DRP_NotAvailable)
         values (:LocId,:ResourceId,:WeekNumber,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:BookMaxNumber,:AutoNumber,:ChargeTime,:UseLock,:availTime,:NotAllowIPBook,:availPatTypeCode,:notAvail) where DRP_RowID=:Rowid)
    q SQLCODE
}

/// 函数：UpdateDateResApptSchudle
/// 功能：更新生成后的资源计划的数量
ClassMethod UpdateDateResApptSchudle(Info As %String) As %String
{
	
	s ^DHCRisTemp("UpdateDateResApptSchudle")=Info
	s ResSchRowid=$p(Info,"^",1)
	s Max=$p(Info,"^",2)
	s AutoNumber=$p(Info,"^",3)
	s RemainTime=$p(Info,"^",4)
	s availPatTypeCode=$p(Info,"^",5)
	s notAvailable=$p(Info,"^",6)
	
	s MaxNumber=Max
    ;s setAutoNumber=$p(^DHCRBCResourceSchdule(ResSchRowid),"^",8)
    s useNumber=$p(^DHCRBCResourceSchdule(ResSchRowid),"^",9)
    i useNumber="" s useNumber=0
    i Max<useNumber s MaxNumber=useNumber
    s remainNumber=MaxNumber-useNumber
	
	&sql(update DHCRBC_ResSchdule (DRPS_MaxNumber,DRPS_AutoNumber,DRPS_RemainTime,DRPS_AvailPatType,DRPS_RemainNumber,DRPS_NotAvailable) 
     								values(:MaxNumber,:AutoNumber,:RemainTime,:availPatTypeCode,:remainNumber,:notAvailable) where DRPS_RowID=:ResSchRowid)

	
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
	.s Desc=$p($g(^DHCRBCTimePeriodSet(Rowid)),"^",2)
	q Desc
}

// sunyi 注视_BAK

/*ClassMethod CreateResApptSchulde(Info As %String) As %String
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
}*/
/// 生成资源的排版计划
/// 修改可以按科室生成排版计划 
/// sunyi 2012-1-10
/// d ##class(web.DHCRisResourceApptSchudle).CreateResApptSchulde("402^5802^05/10/2016^05/10/2016")
ClassMethod CreateResApptSchulde(Info As %String) As %String
{
	s ^TempDHCRisWf("CreateResApptSchulde")=Info
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
    /*
    for CurrDate=StartDate:1:EndDate d
     .for i=1:1:Count d
     ..s ResourceId=$p(ResID,"@",i)
     ..s WeekNum=$zd(CurrDate,10)
     ..i WeekNum=0 s WeekNum=7
     ..s RPRowid=0 f  s RPRowid=$o(^DHCRBCResPlani("Week-Resource",WeekNum,LocId,ResourceId,RPRowid)) q:RPRowid=""  d
     ...;s WeekNumber=$p(^DHCRBCResourcePlan(RowId),"^",7)
	 ...;s Week=..GetWeek(WeekNumber)
	 ...s NextStartTime="",RemainTime="",availPatTypeCode=""
	 ...s ServiceGroupID=$p(^DHCRBCResourcePlan(RPRowid),"^",3)
	 ...s TimePeriodCode=$p(^DHCRBCResourcePlan(RPRowid),"^",4)  //时间段代码
	 ...s StartTime=$p(^DHCRBCResourcePlan(RPRowid),"^",5)
	 ...s EndTime=$p(^DHCRBCResourcePlan(RPRowid),"^",6)
	 ...s Max=$p(^DHCRBCResourcePlan(RPRowid),"^",8)
     ...s AutoNumber=$p(^DHCRBCResourcePlan(RPRowid),"^",9)
     ...s ChargTime=$p(^DHCRBCResourcePlan(RPRowid),"^",10)
     ...s AvailTime=$p(^DHCRBCResourcePlan(RPRowid),"^",12)
     ...s availPatTypeCode=$p($g(^DHCRBCResourcePlan(RPRowid)),"^",14)
     ...q:($p($g(^DHCRBCResourcePlan(RPRowid)),"^",15)="Y")
     ...i locScheType=2 d
     ....s NextStartTime=StartTime
     ....s Max=""
     ....s AutoNumber=""
     ....s RemainTime=(EndTime-StartTime)/60
     ....if (AvailTime<RemainTime) d
     .....s RemainTime=AvailTime
     ...s ResSchRowid=$o(^DHCRBCResSchdulei("Resource-Date",LocId,ResourceId,CurrDate,RPRowid,0))
     ...i ResSchRowid="" d   ; 资源计划已经存在，不在插入
     ....i locScheType="2" d
     .....&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType ) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,null,null,:RPRowid,:ChargTime,:NextStartTime,:RemainTime,:availPatTypeCode))
     ....else  d
     .....&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ResPlan_ID, DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType ) 
     							values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:RPRowid,:ChargTime,null,null,:availPatTypeCode))
     ...else  d
     ....i locScheType="2" d
     .....s getRemainTime=""
     .....&sql(select DRPS_RemainTime into :getRemainTime from DHCRBC_ResSchdule where DRPS_RowID=:ResSchRowid)
     .....if ((getRemainTime'="")&(getRemainTime<RemainTime)) d
     ......s RemainTime=getRemainTime
     .....&sql(update DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType) 
     								values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,null,null,:ChargTime,:NextStartTime,:RemainTime,:availPatTypeCode) where DRPS_RowID=:ResSchRowid)
     ....e  d
     .....&sql(update DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_Desc,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber,DRPS_ChargeTime,DRPS_NextStartTime ,DRPS_RemainTime,DRPS_AvailPatType) 
     								values(:CurrDate,:LocId,:ResourceId,:ServiceGroupID,:TimePeriodCode,:StartTime,:EndTime,:Max,:AutoNumber,:ChargTime,null,null,:availPatTypeCode) where DRPS_RowID=:ResSchRowid)
     */
     
     
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

/// w ##class(web.DHCRisResourceApptSchudle).getNumByDateTimeRes("5802",+$h,"32400","36000")
/// 根据日期\时间和资源,查询医生排班获取检查数量
ClassMethod getNumByDateTimeRes(ResourceId, CurrDate, StartTime, EndTime) As %String
{
	/*
	s num=0
	q:((ResourceId="" )||(CurrDate="") ||(StartTime="")||( EndTime="" )) num
	s equipmentRowid=$p(^RB("RES",ResourceId),"^",3)
	q:(equipmentRowid="") num
	s equipmentCode=$p(^RBC("EQ",equipmentRowid),"^",1)
	q:(equipmentCode="") num
	s postid=""
	&sql(select ID into:postid from  DHCMGCS.MgCSPostCode  WHERE  Post_Code=:equipmentCode)
	q:(postid="") num
	
	s docRowid=""
	s argid="" f  s argid=$O(^DHCMGCS.MgCSArrangeI("PostDate",postid,CurrDate,argid))  q:argid=""  d
	.q:(docRowid'="")
	.s perId=$listget(^DHCMGCS.MgCSArrangeD(argid),5)
	.s TimeID=$listget(^DHCMGCS.MgCSArrangeD(argid),3)
	.s (PostStTime,PostEndTime)=""
    .&sql(select Post_StTime ,Post_EndTime into PostStTime,PostEndTime from  DHCMGCS.MgCSPostPeriod  WHERE  ID=:TimeID)
	.;w !,PostStTime_"^"_PostEndTime
	.if ((StartTime>=PostStTime) && (EndTime<=PostEndTime)) d
	..s userInit=$listget(^DHCMGCS.MgCSPersonsD(perId),3)
	..;w !,userInit
	..q:(userInit="")
	..s docRowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(userInit,"U"),0))
    
    ;w !,docRowid
    q:(docRowid="") num
    s docCapRowid=$o(^DHCRBDocExamCapSeti("userRowid",docRowid,""))
    q:(docCapRowid="") num
    s maxNumberHour=$p(^DHCRBDocExamCapSet(docCapRowid),"^",3)
	q maxNumberHour
	*/
	q ""
}

/// 函数：QueryPatientBookedItem
/// 功能：查询病人的预约记录
/// 参数：paadm.rowid,制定日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryPatientBookedItem","76056")
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
	....i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	...s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	...s BookedDate=$zd(Date,3)
	...s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	...s TimeDesc=""
	...i TimeDescCode'="" d
	...s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	...if TimeDescRowid'="" d
	....s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
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

/*Query QueryResApptSchdule(OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,RemainTime:%String")
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
	 s ResourceDesc="",RemainTime=""
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
	 ;q:(MaxNumber="0")
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)
	 s RemainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime)
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
}*/
/// 函数：QueryResApptSchdule
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResApptSchdule","66425||788","83","","")
/// 函数：QueryResApptSchdule
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：gongping 
/// 日期: 2011-08-05
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResApptSchdule","66425||788","83","","")
/// Flag标示 是否从主工作列表查询资源   1为从主工作列表查询最近的资源  0为点击查询按钮查询选择日期的资源
Query QueryResApptSchdule(OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String, ServiceGroupID As %String, arcItemMastDr As %String = "", EndDate As %String, showNotAvial As %String = "") As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,remainTime:%String,nextTime:%String,TAvailPatType:%String,TAvailPatTypeCode:%String,ManuRemainNumber:%String,ManualNumber:%String,NotAvailable:%String")
{
}

ClassMethod QueryResApptSchduleExecute(ByRef qHandle As %Binary, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String, ServiceGroupID As %String, arcItemMastDr As %String, EndDate As %String, showNotAvial As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^DHCRisTemp("QueryResApptSchdule")=OrditemRowid_"^"_LocId_"^"_ResourceId_"^"_BookDate_"^"_Flag_"^"_ServiceGroupID_"^"_arcItemMastDr_"^"_EndDate
 	k ^DHCRISSCHDULE("RISOLD")
 	s BookDate=##Class(websys.Conversions).DateHtmlToLogical(BookDate)
 	s EndDate=##Class(websys.Conversions).DateHtmlToLogical(EndDate)
 	if ((BookDate="") || (BookDate="ERROR!")) s BookDate=+$h
 	s AppSet="N"
 	s PatType=""
    s StartDate=BookDate
 	if ((EndDate="") || (EndDate="ERROR!")) s EndDate=BookDate
 	
     //.s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
	 //	...s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
	 //	...Q:(BookDate=+$h)&&($p($h,",",2)>EndTime)*/    ;不显示当前时间大于预约的结束时间 
	 
 	if (OrditemRowid'="")  
 	{
	 	s availPatType=""
	 	s ResSchduleID=..GetSchduleID(OrditemRowid)
	 	i ResSchduleID'="" d
	 	.s IsBooked="Y"
	 	.s ^DHCRISSCHDULE("RISOLD",ResSchduleID)=""
	 	.Do OutRow5
	  	s OrderRowid=$p(OrditemRowid,"||",1)
	 	s ItemRowid=$p(OrditemRowid,"||",2)
	 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	 	s SGCount=0
	 	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
        i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2)  
	 	;s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
        ;if (ServcieGroupId'="")
	 	if (ServiceGroupID'="") 
	 	{
			s SGCount=$l(ServiceGroupID,",")
			for Numi=1:1:SGCount 
			{
				;b ;00
				s perServcieGroupId=""
				s perServcieGroupId=$p(ServiceGroupID,",",Numi)
			 	if (Flag="1")
			 	{
				 	s stDate=+$h
				 	s endDate=stDate+60
				 	s hasRes=0
				 	for dateFind=stDate:1:endDate
				 	{
					 	q:(hasRes=1)
					 	s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime)) q:BookTime=""  d
		 				.q:(hasRes=1)
		 				.s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime,ResSchduleID)) q:ResSchduleID=""  d
		 				..q:(hasRes=1)
		 				..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
		 				..Q:(dateFind=+$h)&&($p($h,",",2)>EndTime)
		 				..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
		 				..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
		 				..q:(GetResource="")
				 	    ..s BK=""
				 	    ..;b  ;2
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
		  				..s availPatType=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",19)
		  				..q:((availPatType'="")&&(availPatType'[PatType))
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
				 	 ;w !,perServcieGroupId
				 	 s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
				 	 .s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
				 	 ..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
				 	 ..Q:(BookDate=+$h)&&($p($h,",",2)>EndTime)
				 	 ..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
				 	 ..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
				 	 ..q:(GetResource="")
				 	 ..s availPatType=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",19)
		  			 ..q:((availPatType'="")&&(availPatType'[PatType))
				 	 ..s BK=""
				 	 ..s BK=##class(web.DHCRisBookParam).GetAppResParam(OrditemRowid,GetResource)
				 	 ..q:(BK="N")
				 	 ..q:(ResourceId'="")&(GetResource'=ResourceId)
				 	 ..q:($d(^DHCRISSCHDULE("RISOLD",ResSchduleID)))
				 	 ..q:GetLocId'=LocId
				 	 ..s IsBooked=""
				  	 ..s bFindBookeInfo=1
				 	 ..Do OutRow5
				 	 
			 	}
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
	  if (arcItemMastDr'="")
	  {
		  s serviceGroupInfo=##class(web.DHCRisCommFunctionEx).GetServiceGroup(arcItemMastDr)
		  s serviceGroupList=$p($g(serviceGroupInfo),"^",1)
	   	  for i=1:1:$l(serviceGroupList,",")
	   	  {
		   	  s serviceGroupId=$p(serviceGroupList,",",i)
		   	  s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",serviceGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d 
		   	  .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
		   	  .s resouceLocId=$p(^RB("RES",ResouceId),"^",1)
		   	  .q:(resouceLocId'=LocId)
		   	  .d OutRow5
	   	  }
	  }
	  else
	  {
		 for BookDate=StartDate:1:EndDate
		 {
		  i ResourceId="" d
		  .s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId)) q:ResourceId=""  d
		  ..s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
		  ...d OutRow5
		  else  d
		  .s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
	  	  ..d OutRow5 
		 }
	  }
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutRow5

     
     s ResPlanId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",12)
     q:(ResPlanId="")
     s NotAllowIPBooked=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",13)
     q:(PatType'="")&(PatType="I")&(NotAllowIPBooked="Y")
     s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	 s ResourceDesc=""
	 i ResouceId'="" d
	 .s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	 .s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	 .i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	 .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	 s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	 s BookedDate=##Class(websys.Conversions).DateLogicalToHtml(Date) ;$zd(Date,3)
	 s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	 s TimeDesc=""
	 i TimeDescCode'="" d
	 .s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	 .i TimeDescRowid'="" d
	 ..s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
	 
	 s ServiceGroupId=""
	 s ServiceGroupId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",4)
	 s ServiceGroupDesc=""
	 i ServiceGroupId'="" d
	 .s ServiceGroupDesc=$p(^RBC("SG",ServiceGroupId),"^",2) 
	 s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	 s StartTime=$zt(StartTime)
	 s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 s CurrentTime=$p($h,",",2)
	 s CurrentDate=+$h
	 q:(((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate))&($g(IsBooked)="")
	 ;wf 判断不可用，退出
     s notAvailable=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",23)
     q:((notAvailable="Y")&&(showNotAvial'="Y"))
     ;q:(notAvailable="Y")
	 ;q:((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate)
	 s EndTime=$zt(EndTime)
	 s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	 ;q:(MaxNumber="0")
	 s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)  ;自动预约数
	 s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9)  ;总的预约使用数量
	 s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) ; 总的剩余数
	 i RemainNumber="" s RemainNumber=MaxNumber
	 //q:(RemainNumber<="0")
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 i AutoNumber=""  s AutoNumber=0
	 i AutoUseNumber="" s AutoUseNumber=0
   	 s ManualNumber=MaxNumber-AutoNumber    //服务台可预约数
   	 s ManulaUseNumber=UseNumber-AutoUseNumber
   	 s ManuRemainNumber=ManualNumber-ManulaUseNumber    //服务台预约剩余数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)
	 s NextTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
	 i NextTime'=""  s NextTime=$zt(NextTime)
	 s RemainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
     s (availPatType,availPatTypeCode)=""
     s availPatTypeCode=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",19)
     s availPatType=..changePatTypeCode(availPatTypeCode)
     s NotAvailable=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",23)
     ;b  ;111

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime,NextTime,availPatType,availPatTypeCode,ManuRemainNumber,ManualNumber,NotAvailable)
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

/// w ##class(web.DHCRisResourceApptSchudle).GetLocBookedPrintTemplate("83")
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
/// w ##class(web.DHCRisResourceApptSchudle).GetBookedPrintInfo("20017||3893@20017||3895")
ClassMethod GetBookedPrintInfo(OrditemRowid As %String) As %String
{
	q:(OrditemRowid="") ""
	s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,Name,strOrderName,LocId,LocDesc,ResDetailRowid)=""
	s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid,PinYin,PInfo,strDOB,strAge,SexDesc)=""
	s (MedicareNo,gMemo,wardname,bedname,AppLocName,TMRowid,FistOrditemRowid,IPNO,MainDiagose,PatientNow)=""
	s (SameTmplate)=""
	s (callNo)=""
	
	s FistOrditemRowid=$p(OrditemRowid,"@",1)
	s OrderRowid=$p(FistOrditemRowid,"||",1)
	s ItemRowid=$p(FistOrditemRowid,"||",2)
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
	   .s IPNO=$P($g(PInfo),"^",9)
	   .s wardname=$p($g(PInfo),"^",10)
	   .s bedname=$p($g(PInfo),"^",11)
	   .s MedicareNo=$p($g(PInfo),"^",33)
	   .s PinYin=$p($g(PInfo),"^",38)
	   .s AppLocName=$p($g(PInfo),"^",39)
	   s MainDiagose=##class(web.DHCRisCommFunctionEx).GetDiagnose(paadmdr)
	   s PatientNow=##class(web.DHCRisApplicationBill).GetCurrentStatus(paadmdr)
	}
    
    s Docdr="",AppDocName=""
    s Docdr=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",11) ;下医嘱医生
    i Docdr'="" s AppDocName=$p(^CTPCP(Docdr,1),"^",2)
    ;b //01
   ; s gMemo=..GetAttionInfo(OrditemRowid)
   
    s gMemo=..GetMemo(OrditemRowid)
    /*if (ArcItemId'="")
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
	*/
	//s strOrderName=##class(web.DHCRisApplicationBill).GetGlobal(OrditemRowid)
	s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	s Info=""
	s lenOforder=$l(OrditemRowid,"@")
	s isBookInfo="N"
	for j=1:1:lenOforder
	{
		;w !,Info
		;q:(Info'="")
		q:(isBookInfo="Y")
		s getOrditemRowid=$p(OrditemRowid,"@",j)
		;w !,getOrditemRowid
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,getOrditemRowid,0)) 
	i (ResDetailRowid'="")
	{
		s BooketTime=""
		s eqIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",8)
		s checkgroupIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",9)
		s roomIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",10)
		i eqIndex'="" s callNo=eqIndex
		i checkgroupIndex'=""  s callNo=checkgroupIndex
		i roomIndex'="" s callNo=roomIndex
		s StartTime=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",18)
	    i StartTime'="" s BooketTime=$zt(StartTime)
		;i callNo'="" d 
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	   .s ResourceDesc=""
	   .i ResouceId'="" d
	   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	   ..i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	   ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	   ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
	   ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=$zd(Date,3)
	   .if BooketTime="" d
	   ..s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
	   ..i StartTime'="" s BooketTime=$zt(StartTime)
	   .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	   .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
	   .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
	   .s Info="" 
	   .s Info=RegNo_"^"_Name_"^"_strOrderName_"^"_BookedDate_"^"_BooketTime_"^"_LocDesc_"^"_LocAddress_"^"_ResourceDesc_"^"_EqAdress_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_MedicareNo_"^"_PinYin_"^"_wardname_"^"_bedname_"^"_AppLocName_"^"_gMemo_"^"_AppDocName_"^"_MainDiagose_"^"_PatientNow_"^"_IPNO_"^"_callNo
	   .s isBookInfo="Y"
	}
	}
	if (Info="")
	{
		s Info=RegNo_"^"_Name_"^"_strOrderName_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_MedicareNo_"^"_PinYin_"^"_wardname_"^"_bedname_"^"_AppLocName_"^"_gMemo_"^"_AppDocName_"^"_MainDiagose_"^"_PatientNow_"^"_IPNO_"^"_""
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
/// /// w ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResSchduleDetail","83","","62720","62728")
Query QueryResSchduleDetail(LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,RemainTime:%String,nextStartTime:%String,TDetail:%String")
{
}

ClassMethod QueryResSchduleDetailExecute(ByRef qHandle As %Binary, LocId As %String, ResourceId As %String, StartDate As %String, EndDate As %String, nextStartTime As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TEMP=LocId_"^"_ResourceId_"^"_StartDate_"^"_EndDate
 	
 	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
    s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
   
 	if ((StartDate="") || (StartDate="ERROR!"))  s StartDate=+$h
 	if ((EndDate="") || (EndDate="ERROR!"))  s EndDate=+$h
 	
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
	 .s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	 .s CareProvId=$p(^RB("RES",ResouceId),"^",2)
	 .i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	 .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	 s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	 s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date) ;$zd(Date,3)
	 s TimeDescCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
	 s TimeDesc=""
	 s ServiceGroupId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",4)
	 s ServiceGroupDesc=""
	 i ServiceGroupId'="" d
	 .s ServiceGroupDesc=$p(^RBC("SG",ServiceGroupId),"^",2) 
	 s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	 s StartTime=$zt(StartTime)
	 s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	 if (TimeDescCode="")
    {
	    s TimeDesc=StartTime_"-"_$zt(EndTime,2)
    }
    else
    {
	    s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	    if (TimeDescRowid'="")
	    {
    		s TimeDesc=$p($g(^DHCRBCTimePeriodSet(TimeDescRowid)),"^",2)
	    }
    }
	 s CurrentTime=$p($h,",",2)
	 s CurrentDate=+$h
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
    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime,nextStrStartTime,"明细")
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

/// 功能 同一病人，不同医嘱预约时间是否冲突
/// liuyang 20130515
/// 修改人:孙毅
/// w ##class(web.DHCRisResourceApptSchudle).BookedConflict("20019","4870")
ClassMethod BookedConflict(EpsodeId As %String, gReSchudleRowid As %String) As %String
{
	s ^ts=EpsodeId_"^"_gReSchudleRowid
 	n (EpsodeId,gReSchudleRowid)
 	
 	Quit:EpsodeId="" 
 	s Info="",BCfg="",IsConflict="N",ret=""
 	s Info=##class(web.DHCRisCodeTableAdd).GetSystemParam()
 	s BCfg=$p(Info,"^",7)
 	q:(BCfg="N")!(BCfg="") ret
 	
	
	s gResouceId=$p(^DHCRBCResourceSchdule(gReSchudleRowid),"^",1)
	s gDate=$p(^DHCRBCResourceSchdule(gReSchudleRowid),"^",2)
	s gTime=$p(^DHCRBCResourceSchdule(gReSchudleRowid),"^",5)

	s OrdItemRowid=0 f  s OrdItemRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid)) q:OrdItemRowid=""  d
	.s ResDetailRowid=$o(^DHCRBCResSchduleDetaili("EpsodeID",EpsodeId,OrdItemRowid,0)) 
	.s RegRowid=$o(^DHCPACRegInfoi("OEORI",OrdItemRowid,0))
	.q:RegRowid'=""
	.i ResDetailRowid'="" d
	..s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",2)
	..i ResSchduleID'="" d
	...s ResouceId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",1)
	...s ResourceDesc=""
	...i ResouceId'="" d
	....s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	....s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	....i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	....i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	...s Date=""
	...s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	...s BookedDate=$zd(Date,3)
	...s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
	...s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
	...s TimeDescCode=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",3)
	...s TimeDesc=""
	...i TimeDescCode'="" d
	....s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	....i TimeDescRowid'="" d
	.....s TimeDesc=$p($g(^DHCRBCTimePeriodSet(TimeDescRowid)),"^",2)
	...e  d
	....s TimeDesc=$zt(StartTime,2)_"-"_$zt(EndTime,2)
	...s BooketTime=$zt(StartTime)
	...s OrderRowid=$p(OrdItemRowid,"||",1)
	...s ItemRowid=$p(OrdItemRowid,"||",2)
	...s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1) 
	...i paadmdr'="" s papatmasmdr=$p($g(^PAADM(paadmdr)),"^",1)
    ...i papatmasmdr'="" d
    ....s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
    ....s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
	...s ArcItemId=$p( ^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	...s strOrderName=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),1),"^",2)
	...s LocId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",11)
	...s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2)
	...q:(gResouceId=ResouceId)
	...i ((gResouceId'="")&(gResouceId'=ResouceId)&(gDate=Date)&(gTime=StartTime))  s IsConflict="Y"
	...s ret=""
	...s ret=BookedDate_"^"_TimeDesc_"^"_BooketTime_"^"_strOrderName_"^"_LocDesc_"^"_ResourceDesc_"^"_Name_"^"_RegNo
	...i IsConflict="Y" BREAK:ret
	
    q ret
}

/// 函数：QueryResEndDate
/// 功能：查询资源的星期计划截止日期
/// w ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResEndDate","83")
Query QueryResEndDate(LocId As %String) As %Query(ROWSPEC = "Resource:%String,EndDate:%String")
{
}

ClassMethod QueryResEndDateExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	i LocId="" s qHandle=$lb(0,repid,0)
	Quit:LocId="" $$$OK
	
   s Date="",Rowid=""
   s ResID=0 f  s ResID=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResID)) q:(ResID="")  d  
   .s Date="",Rowid=""
   .s Date=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResID,Date),-1)
   .q:(Date="")
   .s Rowid=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResID,Date,Rowid))
   .i Rowid'="" d
   ..s EndDate=$p($g(^DHCRBCResourceSchdule(Rowid)),"^",2)
   ..i EndDate'="" s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate) ;$zd(EndDate,3)
   ..s Resource="",CareProvId="",EqId=""
   ..i ResID'="" d
   ...s EqId=$p($g(^RB("RES",ResID)),"^",3)
   ...s CareProvId=$p($g(^RB("RES",ResID)),"^",2)
   ...i EqId'="" s Resource=$p($g(^RBC("EQ",EqId)),"^",2)
   ...i CareProvId'="" s Resource=$p(^CTPCP(CareProvId,1),"^",2)
   ...Do OutRowEndDate
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRowEndDate
	set Data=$lb(Resource,EndDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResEndDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResEndDateExecute ]
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

ClassMethod QueryResEndDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResEndDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 返回预约资源ID
/// sunyi 2013-04-22
/// w ##class(web.DHCRisResourceApptSchudle).GetSchduleID("20017||3881")
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

/// 按检查号生成规则判断产生一个或多个检查号
/// 默认没有配置生成规则,按医嘱号生成一个检查号
/// w ##class(web.DHCRisResourceApptSchudle).GetMutiStudyNo("20017||3895@20017||3898","","83","2014-10-17","3")
ClassMethod GetMutiStudyNo(InOrditmGroup As %String, GroupDesc As %String = "", GetLocDR As %String, SelectDate As %String, GroupDR As %String) As %String
{
	s MutiCount=0
	s MutiCount=$l(InOrditmGroup,"@")
	s MutiStudyNoGroup=""
	s IsExit="N",LastStudyNo=""

	for l=1:1:MutiCount 
    {
	   s StudyInfo="",gIsUpdate="",perOrditemID=""
	   s perOrditemID=$p(InOrditmGroup,"@",l)
	   s StudyInfo=##class(web.DHCRisPatRegisterDoEx).GetStudyNo(perOrditemID,GroupDesc,GetLocDR,SelectDate)
	   
	   i StudyInfo'="" d
	   .s InStudyNo=$p($g(StudyInfo),"^",1)_$p($g(StudyInfo),"^",2)
	   .s StudyNumber=$p($g(StudyInfo),"^",2)
       .s IsUpdate=$p($g(StudyInfo),"^",3)
	  
	   i IsExit="Y" s InStudyNo=LastStudyNo
	   s IsMore=""
	   s IsMore=##class(web.DHCRisCodeTableSet).IsCreateMoreStudyNo(GetLocDR,perOrditemID,GroupDesc)
	   
	   //多条医嘱产生多个检查号
	   i (IsMore="Y")&(IsUpdate="1") d
	   .s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	   e  d
	   .i (IsExit="N") d
	   ..s LastStudyNo=InStudyNo  s IsExit="Y"
	   ..s Upret=##class(web.DHCRisPatRegisterDoEx).updatenumber(GetLocDR,GroupDR,StudyNumber,SelectDate)
	  
	   i MutiStudyNoGroup="" d
	   .s MutiStudyNoGroup=InStudyNo
	   e  d
	   .s MutiStudyNoGroup=MutiStudyNoGroup_"@"_InStudyNo
	   
    }
    q MutiStudyNoGroup
}

/// ///////////////////////////////////////////////////////增加预约流水号///////////////////////////
/// //////////////////////////////////////////////////////2015-01-06////////////////////////////////
/// 函数名称：GetCurentLocBKIndex
/// 功能：获得科室当前的预约序号
/// 输入参数：空
/// 返回：
/// 作者：SUNYI
/// 日期：2007-03-05
/// 按天生成
/// ////////////////////////////////////////////////////////
ClassMethod GetCurentLocBKIndex(LocDr, Today, SaveNoFlag) As %String
{
	s IsUp="Y"
	s TypeCode="LocIndex"
	q:LocDr="" ""
	
	i Today="" s Today=+$h	
	s CurrentIndex=""
	
	i SaveNoFlag="Y" s CurrentIndex=..DelEqCancelIndex(Today,LocDr,TypeCode,"")
	i (CurrentIndex="")
	{
	   i $g(^DHCRisLocBookIndex(Today,LocDr))="" s ^DHCRisLocBookIndex(Today,LocDr)=0
	   s CurrentIndex=^DHCRisLocBookIndex(Today,LocDr)+1
	}else
	{
	   s IsUp="N"
	}
	q CurrentIndex_"^"_IsUp
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateIndex
/// 功能：//更新当前的预约流水号
/// 输入参数：LocDr：科室ROWID, Index：序号
/// 返回：
/// 作者：SUNYI
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateLocBKIndex(LocDr, Index, Today) As %String
{
  n (LocDr, Index,Today)
  q:LocDr="" 100
  i Today="" s Today=+$h	
  s ^DHCRisLocBookIndex(Today,LocDr)=Index
  q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetRoomBKIndex
/// 功能：获得房间当前的预约序号
/// 输入参数：空
/// 返回：
/// 日期：2007-03-05
/// 作者：SUNYI 
/// 按天生成
/// ////////////////////////////////////////////////////////
ClassMethod GetRoomBKIndex(RoomDR, Today, SaveNoFlag) As %String
{
	//n (RoomDR,Today)
	s IsUp="Y"
	s TypeCode="RoomIndex"
	q:RoomDR="" ""
	
	s CurrentIndex=""
	
    i Today="" s Today=+$h	
    i SaveNoFlag="Y" s CurrentIndex=..DelEqCancelIndex(Today,RoomDR,TypeCode,"")
    i (CurrentIndex="")
    {
	   i $g(^DHCRisBookRoomIndex(Today,RoomDR))="" s ^DHCRisBookRoomIndex(Today,RoomDR)=0
	   s CurrentIndex=^DHCRisBookRoomIndex(Today,RoomDR)+1
    }else
    {
	   s IsUp="N"
	}
	q CurrentIndex_"^"_IsUp
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateRoomBKIndex
/// 功能：//更新房间的预约流水号
/// 输入参数：RoomDR：科室ROWID, Index：序号
/// 返回：
/// 作者：SUNYI
/// 日期：2007-03-05
/// ////////////////////////////////////////////////////////
ClassMethod UpdateRoomBKIndex(RoomDR, Index, Today) As %String
{
  n (RoomDR, Index,Today)
  q:RoomDR="" 100
  i Today="" s Today=+$h	
  s ^DHCRisBookRoomIndex(Today,RoomDR)=Index
  q 0
}

/// 得当前到资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod GetGroupBKIndex(CheckGroupDr, Today, SaveNoFlag) As %String
{
    //n (CheckGroupDr,Today)
    s IsUp="Y"
	s TypeCode="GroupIndex"
    q:CheckGroupDr="" ""
	
	s CheckGroupIndex=""
    i Today="" s Today=+$h	
    i SaveNoFlag="Y" s CheckGroupIndex=..DelEqCancelIndex(Today,CheckGroupDr,TypeCode,"")
    i (CheckGroupIndex="")
    {
	    i $g(^DHCRisBookGroupIndex(Today,CheckGroupDr))="" s ^DHCRisBookGroupIndex(Today,CheckGroupDr)=0
	    s CheckGroupIndex=^DHCRisBookGroupIndex(Today,CheckGroupDr)+1
    }else
    {
	    s IsUp="N"
	}
	q CheckGroupIndex_"^"_IsUp
}

/// 跟新资源组的流水号---地坛流水号
/// sunyi 2009-3-17
ClassMethod UpdateGroupBKIndex(CheckGroupDr, Index, Today) As %String
{
    n (CheckGroupDr,Index,Today)
    q:CheckGroupDr="" 100
    
	i Today="" s Today=+$h	
	s ^DHCRisBookGroupIndex(Today,CheckGroupDr)=Index
	q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetIndexbySchduleID
/// 功能：根据预约资源获得科室当前预约序号
/// 输入参数：CT_LocID  ResSchduleID
/// 返回：
/// 作者：孙毅
/// 日期：2013-04-022
/// ////////////////////////////////////////////////////////
ClassMethod GetIndexbySchduleID(LocDr, ResSchduleID, Today, SaveNoFlag) As %String
{
	//n (LocDr,ResSchduleID,Today)
	s IsUp="Y"
	s TypeCode="ResLocIndex"
	q:LocDr="" ""
	q:ResSchduleID="" ""
	s CurrentIndex=""
	
	i Today="" s Today=+$h	
	i SaveNoFlag="Y" s CurrentIndex=..DelEqCancelIndex(Today,LocDr,TypeCode,ResSchduleID)
	i (CurrentIndex="")
	{
	   i $g(^DHCRisResLocBKIndex(Today,LocDr,ResSchduleID))="" s ^DHCRisResLocBKIndex(Today,LocDr,ResSchduleID)=0
	   s CurrentIndex=^DHCRisResLocBKIndex(Today,LocDr,ResSchduleID)+1
	}else
	{
	   s IsUp="N"
	}
	q CurrentIndex_"^"_IsUp
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateIndex
/// 功能：//更新当前的预约序号
/// 输入参数：LocDr：科室ROWID, Index：序号,ResSchduleID预约资源记录ID
/// 返回：
/// 作者：sunyi
/// 日期：2013-04-22
/// ////////////////////////////////////////////////////////
ClassMethod UpdateIndexbySchduleID(LocDr, Index, ResSchduleID, Today) As %String
{
  n (LocDr,Index,ResSchduleID,Today)
  q:LocDr="" 100
  q:ResSchduleID="" 100
  i Today="" s Today=+$h	
  s ^DHCRisResLocBKIndex(Today,LocDr,ResSchduleID)=Index
  q 0
}

/// //////////////////////////////////////////////////////
/// 函数名称：GetRoomIndexbySchduleID
/// 功能：获得房间当前的预约序号
/// 输入参数：空
/// 返回：
/// 日期：2013-04-22
/// 作者：龚平
/// ////////////////////////////////////////////////////////
ClassMethod GetRoomIndexbySchduleID(RoomDR, ResSchduleID, Today, SaveNoFlag) As %String
{
	//n (RoomDR,ResSchduleID,Today)
	s IsUp="Y"
	s TypeCode="ResRoomIndex"
	q:RoomDR="" ""
	q:ResSchduleID="" ""
	s CurrentIndex=""
	i Today="" s Today=+$h	
	i SaveNoFlag="Y" s CurrentIndex=..DelEqCancelIndex(Today,RoomDR,TypeCode,ResSchduleID)
	i (CurrentIndex="")
	{
	  i $g(^DHCRisResBookRoomIndex(Today,RoomDR,ResSchduleID))="" s ^DHCRisResBookRoomIndex(Today,RoomDR,ResSchduleID)=0
	  s CurrentIndex=^DHCRisResBookRoomIndex(Today,RoomDR,ResSchduleID)+1
	}else
	{
	  s IsUp="N"	
	}
	q CurrentIndex_"^"_IsUp
}

/// //////////////////////////////////////////////////////
/// 函数名称：UpdateRoomIndexbySchduleID
/// 功能：//根据预约记录更新房间的预约序号
/// 输入参数：RoomDR：科室ROWID, Index：序号,ResSchduleID 预约资源记录ID
/// 返回：
/// 作者：孙毅
/// 日期：2013-04-22
/// ////////////////////////////////////////////////////////
ClassMethod UpdateRoomIndexbySchduleID(RoomDR, Index, ResSchduleID, Today) As %String
{
  n (RoomDR, Index,ResSchduleID,Today)
  q:RoomDR="" 100
  q:ResSchduleID="" 100
  i Today="" s Today=+$h	
  s ^DHCRisResBookRoomIndex(Today,RoomDR,ResSchduleID)=Index
  q 0
}

/// 根据预约资源记录得当前到资源组的预约序号
/// sunyi 2013-04-22
ClassMethod GetGroupIndexbySchduleID(CheckGroupDr, ResSchduleID, Today, SaveNoFlag) As %String
{
    //n (CheckGroupDr,ResSchduleID,Today)
    s IsUp="Y"
	s TypeCode="ResGroupIndex"
    q:CheckGroupDr="" ""
    q:ResSchduleID="" ""
    s CheckGroupIndex=""
   
	i Today="" s Today=+$h	
	i SaveNoFlag="Y" s CheckGroupIndex=..DelEqCancelIndex(Today,CheckGroupDr,TypeCode,ResSchduleID)
	
	i (CheckGroupIndex="")
	{
	   i $g(^DHCRisResBookGroupIndex(Today,CheckGroupDr,ResSchduleID))="" s ^DHCRisResBookGroupIndex(Today,CheckGroupDr,ResSchduleID)=0
	   s CheckGroupIndex=^DHCRisResBookGroupIndex(Today,CheckGroupDr,ResSchduleID)+1
	}else
	{
		s IsUp="N"
	}
	
	q CheckGroupIndex_"^"_IsUp
}

/// 根据预约资源记录更新资源组的预约序号
/// sunyi2013-04-22
ClassMethod UpGroupIndexbySchduleID(CheckGroupDr, Index, ResSchduleID, Today) As %String
{
    n (CheckGroupDr,Index,ResSchduleID,Today)
    q:ResSchduleID="" 100
    q:CheckGroupDr="" 100
	i Today="" s Today=+$h	
	s ^DHCRisResBookGroupIndex(Today,CheckGroupDr,ResSchduleID)=Index
	q 0
}

ClassMethod GetCurrentBookMaxIndex(Param As %String) As %String
{
	s (val,GrourpIndex,RoomIndex,EQIndex,Infos)=""
	s (NoRuleCode,IndexNo,IsUpdate,BkNoTypeDR)=""
 
	s val=..GetBookedIndexcls(Param) 
	q:(val="") ""
	
	s NoRuleCode=$p($g(val),"^",2)
	s IndexNo=$p($g(val),"^",1)
	s BkNoTypeDR=$p($g(val),"^",5)
	s IsUpdate=$p($g(val),"^",6)
	
	if (NoRuleCode="L")
	{ 
	   s EQIndex=IndexNo
    }
	elseif(NoRuleCode="Z")
	{
		s GrourpIndex=IndexNo
	}
	elseif (NoRuleCode="R")
	{
	   s RoomIndex=IndexNo
	}
	
	s Infos=EQIndex_"^"_GrourpIndex_"^"_RoomIndex_"^"_IsUpdate_"^"_BkNoTypeDR
	q Infos
}

/// 根据科室配置来更新对应的流水号
/// do ##class(web.DHCRisPatRegisterDoEx).UpdateBookedIndexcls("83","1^^^4^3^^1","4153")
ClassMethod UpdateBookedIndexcls(LocDR, Info, ResSchduleID As %String = "")
{
	s ^ttss=LocDR_"&"_Info_"&"_ResSchduleID
	q:(LocDR="")
	s Rowid=""
	s RegEQIndex=$p($g(Info),"^",1)
	s CheckGroupIndex=$p($g(Info),"^",2)
	s RoomIndex=$p($g(Info),"^",3)
	s EQDr=$p($g(Info),"^",4)
	s EQGroupDR=$p($g(Info),"^",5)
	s RoomDR=$p($g(Info),"^",6)
	s AppDateType=$p($g(Info),"^",7)
	s SelBKDate=$p($g(Info),"^",8)
	i SelBKDate'="" d
	.s SelBKDate=$zdh(SelBKDate,"3")
	
	i AppDateType="" s AppDateType="0"
	
	s Rowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocDR,Rowid))

	i (Rowid'="")
	{
		s OpertionDR="",NoRuleCode="L"
	    s NoRuleDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",2)
	    
	    ;s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",Rowid)),"^",3)
	    i NoRuleDR'="" s NoRuleCode=$p($g(^DHCRBCApp("USE-METHOD",NoRuleDR)),"^",1)
	   
        i (AppDateType="0") //天
        {
	       
	        if (NoRuleCode="L")
	        {
		       ;b //Up0-L
		       d ..UpdateLocBKIndex(LocDR, RegEQIndex,SelBKDate)
		      
		    }
		    elseif (NoRuleCode="Z")
		    {
			   ;b //Up0-Z
			   d ..UpdateGroupBKIndex(EQGroupDR, CheckGroupIndex,SelBKDate)
			}
			elseif(NoRuleCode="R")
			{
				;b //Up0-R
			    d ..UpdateRoomBKIndex(RoomDR, RoomIndex,SelBKDate)
			}
	    }
	    elseif (AppDateType="1") //时间段
	    {   
		    if (NoRuleCode="L")
	        {
		        ;b //Up1-L
		        d ..UpdateIndexbySchduleID(LocDR,RegEQIndex,ResSchduleID,SelBKDate)
		    }
		    elseif(NoRuleCode="Z")
		    {
			     ;b //Up1-Z
			     d ..UpGroupIndexbySchduleID(EQGroupDR,CheckGroupIndex,ResSchduleID,SelBKDate)
			}
			elseif(NoRuleCode="R")
			{
				;b //Up1-R
			 	 d ..UpdateRoomIndexbySchduleID(RoomDR,RoomIndex,ResSchduleID,SelBKDate)
			}
		}
	         
	}
}

/// 根据科室配置来更新对应的流水号
/// w ##class(web.DHCRisResourceApptSchudlle).GetBookedIndexcls(^t)
ClassMethod GetBookedIndexcls(ParamInfo As %String) As %String
{
	s ^TempL=ParamInfo
	
	s EQDr=$p($g(ParamInfo),"^",1)
	s EQGroupDR=$p($g(ParamInfo),"^",2)
	s RoomDR=$p($g(ParamInfo),"^",3)
	s LocDR=$p($g(ParamInfo),"^",4)
	s oeorditemrowid=$p($g(ParamInfo),"^",5)
	s ResSchduleRowid=$p($g(ParamInfo),"^",6)
	s SelBookDate=$p($g(ParamInfo),"^",7)
	i SelBookDate'="" d
	.s SelBookDate=$zdh(SelBookDate,"3")
	s IsSaveBookNo=$p($g(ParamInfo),"^",8)
	
	s IsBooked="N",AppDateType="",IndexInfo="",IndexParam=""
	s NoRuleCode="",NoRuleDR="",NoRuleCode="",Rowid="",TypeDesc="",TypeRowid=""
	s IndexInfo="",IsUpdateNo="",Index="",IsUpNumber=""
	s BookNumberRowid=""
    
	i (oeorditemrowid'="") 
	{
	    s BookNumberRowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocDR,BookNumberRowid))
	    i (BookNumberRowid'="")
	    {   
			s NoRuleCode=""
		    s NoRuleDR=$p($g(^DHCRBSerialNumber("SerialCreateRule",BookNumberRowid)),"^",2)
		    i NoRuleDR'="" s NoRuleCode=$p($g(^DHCRBCApp("USE-METHOD",NoRuleDR)),"^",1) 
		    s AppDateType=$p($g(^DHCRBSerialNumber("SerialCreateRule",BookNumberRowid)),"^",3)
		    ;w !,"AppDateType"_AppDateType
	    }


	    i (AppDateType="0")
	    {
		    if (NoRuleCode="L")
	        {
		       
		       s IndexParam=..GetCurentLocBKIndex(LocDR,SelBookDate,IsSaveBookNo)		  
		       s IndexInfo=..GetIndexTypeInfo("LD")
		    }
		    elseif (NoRuleCode="Z")
		    {
			   s IndexParam=..GetGroupBKIndex(EQGroupDR,SelBookDate,IsSaveBookNo)
			   s IndexInfo=..GetIndexTypeInfo("ZD")
			}
			elseif(NoRuleCode="R")
			{
			   s IndexParam=..GetRoomBKIndex(RoomDR,SelBookDate,IsSaveBookNo)
			   s IndexInfo=..GetIndexTypeInfo("RD")
			}
		}
		elseif(AppDateType="1")
		{
			if (NoRuleCode="L")
	        {
		       ;b //GetIndex1-L
		       s IndexParam=..GetIndexbySchduleID(LocDR,ResSchduleRowid,SelBookDate,IsSaveBookNo)
		       s IndexInfo=..GetIndexTypeInfo("LT")
		    }
		    elseif(NoRuleCode="Z")
		    {
			   ;b //GetIndex1-Z
			   s IndexParam=..GetGroupIndexbySchduleID(EQGroupDR,ResSchduleRowid,SelBookDate,IsSaveBookNo)
			   s IndexInfo=..GetIndexTypeInfo("ZT") 
			}
			elseif(NoRuleCode="R")
			{
				;b //GetIndex1-R
			 	s IndexParam=..GetRoomIndexbySchduleID(RoomDR,ResSchduleRowid,SelBookDate,IsSaveBookNo)
			 	s IndexInfo=..GetIndexTypeInfo("RT")
			}
		}
		
	}
	
	i (IndexInfo'="")
	{
		s TypeDesc=$p(IndexInfo,"^",2)
		s TypeRowid=$p(IndexInfo,"^",1)
	}
	
	i IndexParam'="" d
	.s Index=$p($g(IndexParam),"^",1)
	.s IsUpNumber=$p($g(IndexParam),"^",2)
	
	s IndexInfo=Index_"^"_NoRuleCode_"^"_TypeDesc_"^"_AppDateType_"^"_TypeRowid_"^"_IsUpNumber
	
	q IndexInfo
}

/// w ##class(web.DHCRisPatRegisterDoEx).GetIndexTypeInfo("LD")
ClassMethod GetIndexTypeInfo(Code As %String) As %String
{
	s Rowid="",Desc="",Info=""
	
	i Code'="" d
	.s Rowid=$o(^DHCRBCIndexTypei("Code",Code,Rowid))
	.i Rowid'="" d
	..s Desc=$p($g(^DHCRBCIndexType(Rowid)),"^",2)
	..s Info=Rowid_"^"_Desc
	
	q Info
}

/// ///////////////////////////////////////////////////////////////////////////////////////////////
/// do ##class(web.DHCRisResourceApptSchudle).GetSaveBKFlag("83")
ClassMethod GetSaveBKFlag(LocRowid As %String) As %String
{
	s IsSave="N"
	s DNCRowid=""
	s DNCRowid=$o(^DHCRBSerialNumberi("RecLoc-Number",LocRowid,DNCRowid))
	i DNCRowid'="" s IsSave=$p($g(^DHCRBSerialNumber("SerialCreateRule",DNCRowid)),"^",5)
	q IsSave
}

/// 取消预约时回收流水号
/// 函数:AddEqCancelIndex
/// 入参:ResSchduleID,Index,LocDR,TypeDR
/// 说明:TypeDR分为三类 科室ID,诊室ID,资源组ID
/// 作者:sunyi
ClassMethod AddEqCancelIndex(ResSchduleID, gIndex, IndexRuleCode As %String = "LD", TypeDR) As %String
{
   //n (ResSchduleID,gIndex,LocDR,TypeDR)
   s Day=""
   q:ResSchduleID="" ""
   q:gIndex="" ""
   q:IndexRuleCode="" ""
   q:TypeDR="" ""
   
   s Day=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)

   if (IndexRuleCode="LD")
   {       //b //0001
		   i ('$d(^DHCRisBookLocCancel(Day,TypeDR)))
		   {
		      s ^DHCRisBookLocCancel(Day,TypeDR)=gIndex
		   }else
		   {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookLocCancel(Day,TypeDR)="" s ^DHCRisBookLocCancel(Day,TypeDR)=gIndex
			 .e  d
			 ..s ^DHCRisBookLocCancel(Day,TypeDR)=$g(^DHCRisBookLocCancel(Day,TypeDR))_"@"_gIndex
		   }
   }elseif(IndexRuleCode="ZD")
   {
	       //b ///002
	       i ('$d(^DHCRisBookGroupCancel(Day,TypeDR)))
	       {
		      s ^DHCRisBookGroupCancel(Day,TypeDR)=gIndex
	       }else
	       {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookGroupCancel(Day,TypeDR)="" s ^DHCRisBookGroupCancel(Day,TypeDR)=gIndex
			 .e  d
			 ..s ^DHCRisBookGroupCancel(Day,TypeDR)=$g(^DHCRisBookGroupCancel(Day,TypeDR))_"@"_gIndex
	       }
   }elseif(IndexRuleCode="RD")
   {
	       //b //003
	       i ('$d(^DHCRisBookRoomCancel(Day,TypeDR)))
	       {
		      s ^DHCRisBookRoomCancel(Day,TypeDR)=gIndex
	       }else
	       {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookRoomCancel(Day,TypeDR)="" s ^DHCRisBookRoomCancel(Day,TypeDR)=gIndex
			 .e  d
			 ..s ^DHCRisBookRoomCancel(Day,TypeDR)=$g(^DHCRisBookRoomCancel(Day,TypeDR))_"@"_gIndex
	       }
   }elseif(IndexRuleCode="LT")
   {
	       i ('$d(^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID)))
	       {
		      s ^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID)=gIndex
	       }else
	       {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID)="" s ^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID)=gIndex
			 .e  d
			 ..s ^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID)=$g(^DHCRisBookTimeLocCancel(Day,TypeDR,ResSchduleID))_"@"_gIndex
	       }
   }elseif(IndexRuleCode="ZT")
   {
	       i ('$d(^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID)))
	       {
		      s ^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID)=gIndex
	       }else
	       {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID)="" s ^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID)=gIndex
			 .e  d
			 ..s ^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID)=$g(^DHCRisBookTimeGroupCancel(Day,TypeDR,ResSchduleID))_"@"_gIndex
	       }
   }elseif(IndexRuleCode="RT")
   {
	       i ('$d(^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID)))
	       {
		      s ^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID)=gIndex
	       }else
	       {
			 s Finds=""
			 s Finds=..FindIndex(Day,TypeDR,gIndex,IndexRuleCode,ResSchduleID)
			 i Finds="N" d
			 .i ^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID)="" s ^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID)=gIndex
			 .e  d
			 ..s ^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID)=$g(^DHCRisBookTimeRoomCancel(Day,TypeDR,ResSchduleID))_"@"_gIndex
	       }
   }
   ;b //XXXXXX
   q 0
}

/// w ##class(web.DHCRisResourceApptSchudle).FindIndex("","","1")
ClassMethod FindIndex(InDay, InTypeDR, getIndex, InRuleCode, InResSchduleID As %String = "") As %String
{
	s F="N",FindCount=0,getInfo="",perFindNo=""
	
    if (InRuleCode="LD")
    {
        i $g(^DHCRisBookLocCancel(InDay,InTypeDR))'="" d
        .s getInfo=$g(^DHCRisBookLocCancel(InDay,InTypeDR))
    }
    elseif (InRuleCode="ZD")
    {
	    i $g(^DHCRisBookGroupCancel(InDay,InTypeDR))'="" d
        .s getInfo=$g(^DHCRisBookGroupCancel(InDay,InTypeDR))
	}
	elseif(InRuleCode="RD")
	{
        i $g(^DHCRisBookRoomCancel(InDay,InTypeDR))'="" d
        .s getInfo=$g(^DHCRisBookRoomCancel(InDay,InTypeDR))
	}elseif (InRuleCode="LT")
    {
        i $g(^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID))'="" d
        .s getInfo=$g(^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID))
    }
    elseif(InRuleCode="ZT")
    {
	    i $g(^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID))'="" d
        .s getInfo=$g(^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID))
	}
	elseif(InRuleCode="RT")
	{
	    i $g(^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID))'="" d
        .s getInfo=$g(^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID))
	}
	
    s FindCount=$l(getInfo,"@")
	for k=1:1:FindCount
	{
		s perFindNo=$p(getInfo,"@",k)
		i perFindNo=getIndex s F="Y"
		q:(F="Y")
	}
	
	q F
}

/// 获取取消预约队列序号并删除使用的序号
ClassMethod DelEqCancelIndex(InDay, InTypeDR, Code, InResSchduleID As %String = "") As %String
{
	 s DelEqInfo="",FistCancelIndex="",CancelCount=0
	 s CacnelNoInfo=""
	 ;b //DelEqCancelIndex-1
	  if (Code="LocIndex")
	  {
		  i $d(^DHCRisBookLocCancel(InDay,InTypeDR)) d
		  .s CacnelNoInfo=$g(^DHCRisBookLocCancel(InDay,InTypeDR)) 
		  .;b //DelEqCancelIndex-2
		  
	  }elseif(Code="RoomIndex")
	  {
           i $d(^DHCRisBookRoomCancel(InDay,InTypeDR)) d
		   .s CacnelNoInfo=$g(^DHCRisBookRoomCancel(InDay,InTypeDR))
		  
	  }elseif(Code="GroupIndex")
	  {
		   i $d(^DHCRisBookGroupCancel(InDay,InTypeDR)) d
		   .s CacnelNoInfo=$g(^DHCRisBookGroupCancel(InDay,InTypeDR))
		  
	  }elseif(Code="ResLocIndex")
	  {
		   i $d(^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID)) d
		   .s CacnelNoInfo=$g(^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID))
		  
	  }elseif(Code="ResRoomIndex")
	  {
		   i $d(^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID)) d
		   .s CacnelNoInfo=$g(^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID))
		  
	  }elseif(Code="ResGroupIndex")
	  {
		   i $d(^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID)) d
		   .s CacnelNoInfo=$g(^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID))
	  }
	  
	  s CancelCount=$l($g(CacnelNoInfo),"@")
	  for j=1:1:CancelCount
	  {
			i (j=1)
			{
			   s FistCancelIndex=$p($g(CacnelNoInfo),"@",j)
			}else
			{
			   i DelEqInfo="" s DelEqInfo=$p($g(CacnelNoInfo),"@",j)
			   e  d
			   .s DelEqInfo=DelEqInfo_"@"_$p($g(CacnelNoInfo),"@",j)
			} 
	  }
		
	  if (Code="LocIndex")
	  {
		 i $d(^DHCRisBookLocCancel(InDay,InTypeDR)) d
		 .s ^DHCRisBookLocCancel(InDay,InTypeDR)=DelEqInfo
		    
	  }elseif(Code="RoomIndex")
	  {
         i $d(^DHCRisBookRoomCancel(InDay,InTypeDR)) d
		 .s ^DHCRisBookRoomCancel(InDay,InTypeDR)=DelEqInfo
	  }elseif(Code="GroupIndex")
	  {
		 i $d(^DHCRisBookGroupCancel(InDay,InTypeDR)) d
		 .s ^DHCRisBookGroupCancel(InDay,InTypeDR)=DelEqInfo 
	  }elseif(Code="ResLocIndex")
	  {
		  i $d(^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID)) d
		  .s ^DHCRisBookTimeLocCancel(InDay,InTypeDR,InResSchduleID)=DelEqInfo
	  }elseif(Code="ResRoomIndex")
	  {
		  i $d(^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID)) d
		  .s ^DHCRisBookTimeRoomCancel(InDay,InTypeDR,InResSchduleID)=DelEqInfo
	  }elseif(Code="ResGroupIndex")
	  {
		  i $d(^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID)) d
		  .s ^DHCRisBookTimeGroupCancel(InDay,InTypeDR,InResSchduleID)=DelEqInfo
	  }
		
	 
	 q FistCancelIndex
}

/// w ##class(web.DHCRisResourceApptSchudle).GetResources("4119")
ClassMethod GetResources(SchudleRowid As %String)
{
	 s (ResourceId,ResDesc,CTCPDR,EQDR,ResDesc,RoomDR,GroupDescDR,RoomDesc,GetResInfo)=""
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
     .s GetResInfo=$g(EQDR)_"^"_$g(RoomDR)_"^"_$g(GroupDescDR)_"^"_$g(ResDesc)_"^"_$g(RoomDesc)_"^"_$g(GroupDesc)
    
    q GetResInfo
}

/// w ##class(web.DHCRisResourceApptSchudle).IsUpSchdule("CS20141017-020")
/// 
ClassMethod IsUpSchdule(inBookNo As %String) As %String
{
	s IsUp="N"
	q:(inBookNo="") "Y"
	
	s Count=0
	s Rowid="" f  s Rowid=$o(^DHCRBCResSchduleDetaili("StudyNo",inBookNo,Rowid)) q:(Rowid="")  d
	.s num=0
	.&sql(select count(*) into :num from DHCRBC_SchduleDetailBody WHERE SchduleDetailRowid=:Rowid)
	.;b //0001
	.if num=0 d
	..s Count=Count+1
	.e  d
	..s Count=Count+num
	;b //001
	i Count=1 s IsUp="Y"
	q IsUp
}

ClassMethod GetCancelBookSaveNoParam(InDetailRowid, InLocRowid) As %String
{
	s CancelIndex="",ParamCode="",ParamTypeRowid=""
	s IndexTypeDR=""
	s IndexTypeDR=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",14)
	i IndexTypeDR'="" s ParamCode=$p(^DHCRBCIndexType(IndexTypeDR),"^",1)
	
	if ((ParamCode="LD")!(ParamCode="LT"))
	{
		s CancelIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",8)
		s ParamTypeRowid=InLocRowid
		
	}elseif((ParamCode="ZD")!(ParamCode="ZT"))
	{
		s CancelIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",9)
		s ParamTypeRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",12)
		
	}elseif((ParamCode="RD")!(ParamCode="RT"))
	{
		s CancelIndex=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",10)
		s ParamTypeRowid=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",13)
	}
	
	q CancelIndex_"^"_ParamCode_"^"_ParamTypeRowid
}

/// 函数:GetCheckItemGroup
/// 功能:根据医嘱ID对相同检查号医嘱分组
/// 入参:OEItemID@OEItemID@...
/// 出参:OEItemID@OEItemID@^OEItemID@...
/// 作者:sunyi 2015-01-09
/// w ##class(web.DHCRisResourceApptSchudle).GetCheckItemGroup("20017||3893@20017||3877@20017||3895")
ClassMethod GetCheckItemGroup(SplitArray) As %String
{
    s Count=$l(SplitArray,"@")
   
    s Info=""
  
    f i=1:1:Count 
    {
	   s perOEItemRowid=""
	   s perStudyNo="",perDetailRowid=""
	   s perOEItemRowid=$p(SplitArray,"@",i)
	   i perOEItemRowid'="" d
	   .s perDetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOEItemRowid,perDetailRowid))
	   .q:(perDetailRowid="")
	   .s perStudyNo=$p(^DHCRBCResSchduleDetail("Detail",perDetailRowid),"^",6)
	   .q:(perStudyNo="")
	   .i $g(Samestudyno(perStudyNo))="" d
	   ..s Samestudyno(perStudyNo)=perOEItemRowid
	   .e  d
	   ..s Samestudyno(perStudyNo)=Samestudyno(perStudyNo)_"@"_perOEItemRowid
	   
	}

	s Rowid=0 f  s Rowid=$o(Samestudyno(Rowid)) q:(Rowid="")  d
	.i Info="" d
	..s Info=Samestudyno(Rowid)
	.e  d
	..s Info=Info_"^"_Samestudyno(Rowid)
	
	k Samestudyno
	
	q Info
}

/*ClassMethod GetAttionInfo(OEItmRowidGroup As %String) As %String
{
    s Counts=$l(OEItmRowidGroup,"@")
   
    s AttInfo=""
  
    f i=1:1:Counts
    {
	     s perItmRowid="",perOrderRowid="",peritemsub="",perOrderName=""
	     s perMemo=""
	     s perItmRowid=$p(OEItmRowidGroup,"@",i)
	     s perOrderRowid=$p(perItmRowid,"||",1)
	     s peritemsub=$p(perItmRowid,"||",2)
	     s arcimid=$p($g(^OEORD(perOrderRowid,"I",peritemsub,1)),"^",2)
	     i arcimid'="" d
	     .s perOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)   
	     .s perMemo=..GetMemo(perItmRowid)
	     .s perOrderName="检查项目:"_perOrderName_$c(13,10)_perMemo
	     .i $g(SameArcItmID(arcimid))="" d
	     ..s SameArcItmID(arcimid)=perOrderName
	     .e  d
	     ..s SameArcItmID(arcimid)=SameArcItmID(arcimid)_"@"_perOrderName
	     
	} 
	
	s ArcItemRowid=0 f  s ArcItemRowid=$o(SameArcItmID(ArcItemRowid)) q:(ArcItemRowid="")  d
	.i AttInfo="" d
	..s AttInfo=SameArcItmID(ArcItemRowid)
	.e  d
	..s AttInfo=AttInfo_$c(13,10)_SameArcItmID(ArcItemRowid)
	
	k SameArcItmID
	
	q AttInfo
}*/
/// FindType -1,2,3-注意事项,禁忌症,适应症
/// AppCode   C"判断校验",Q"查询"
/// w ##class(web.DHCRisResourceApptSchudle).RequestKnowledgeInfo("Q","104! !149||97","","1") 
/// w ##class(web.DHCRisResourceApptSchudle).RequestKnowledgeInfo("C","104! !149||97","600^6^29","1")
ClassMethod RequestKnowledgeInfo(AppCode As %String, Input As %String, UserInfo As %String = "", FindType As %String) As %String
{
	//w !, "AppCode="_AppCode_";"_"Input="_Input_";"_"UserInfo="_UserInfo
	//w !,""
	s ^DHCRIS("RequestKnowledgeInfo") = "AppCode="_AppCode_";"_"Input="_Input_";"_"UserInfo="_UserInfo
	s Input = ..Replace(Input," ","")
	s Input = ..Replace(Input,"$c(2)",$c(2))
	b //Input
	///##class(websys.Conversions).IsValidMethodName("web.DHCEventLog","EventLog")
	s Findvalue=0
	s Findvalue=##class(websys.Conversions).IsValidMethodName("web.DHCSTPHCMPASS","CheckLibPha")
	q:(Findvalue=0) ""
	
	do ##class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,AppCode,Input,UserInfo)
	b //RetStr
	//w !,"RetStr="_RetStr
	//w !,""
	//w !,""
	q:(RetStr="") ""
	s KnowledgeMemo=""
	s QueryFind=0,HISMemo=""
    s RetStrCount=0
    
	s RetStrCount=$l(RetStr,"^")	
	q:(RetStrCount=0) HISMemo
	i (AppCode="Q")
	{
		s KnowledgeMemo=$p(RetStr,"^",3,RetStrCount)
		;w !,"KnowledgeMemo="_KnowledgeMemo
		q:(KnowledgeMemo="") ""  
	
		i FindType="1" s FindDesc="注意事项"
		i FindType="2" s FindDesc="禁忌"
		i FindType="3" s FindDesc="适应"
	
		s KnowledgeCounts=$l(KnowledgeMemo,"!")
		f j=1:1:KnowledgeCounts d
		.q:(QueryFind=1)
		.s perKnowledgeInfo=$p(KnowledgeMemo,"!",j)
		.;w !,"perKnowledgeInfo="_j_"次"_perKnowledgeInfo
		.i perKnowledgeInfo'="" d
		..s Catalog="",HISMemo=""
		..s Catalog=$p(perKnowledgeInfo,"@",1)
		..i Catalog[FindDesc d
		...s QueryFind=1 
		...s HISMemo=$p(perKnowledgeInfo,"@",2)
		...s HISMemo=..Replace(HISMemo,"^",$C(13,10))
	}else
	{
		s (Verification,Control)=""	
		s Verification=$p(RetStr,"^",1)
		s Control=$p(RetStr,"^",2)
		s KnowledgeMemo=$p(RetStr,"^",3,RetStrCount)
		s KnowledgeMemo=..Replace(KnowledgeMemo,"^",$C(13,10))
		s HISMemo=Verification_"^"_Control_"^"_KnowledgeMemo
		;s HISMemo="0"_"^"_"0"_"^"_KnowledgeMemo
	}	
	s HISMemo=..Replace(HISMemo,$c(13),$c(13,10,10))
	s HISMemo=..Replace(HISMemo,"/n",$c(13,10))
    s HISMemo=..Replace(HISMemo,"/*",$c(13,10))
    s HISMemo=..Replace(HISMemo,"/$",":")
    s HISMemo=..Replace(HISMemo,$c(2),$c(13,10))
	q HISMemo
}

ClassMethod GetFormatInfo(InOEOrdItemID) As %String
{
	q:(InOEOrdItemID="")
	s PaadmRowid="",FormatInfo=""
	s PaadmRowid=$p(^OEORD($p($p(InOEOrdItemID,"@",1),"||",1)),"^",1)
	s InOEOrdItemID=..Replace(InOEOrdItemID,"@",$C(2))
	s FormatInfo=PaadmRowid_"!!"_InOEOrdItemID
	
	q FormatInfo
}

// w ##class(web.DHCRisResourceApptSchudle).GetEmptyTEST("285||5")

/*ClassMethod GetEmptyTEST(OrditemRowid) As %String
{
	 s Empty="N"
	 q:(OrditemRowid="") Empty
	 s OrderRowid=$p(OrditemRowid,"||",1)
     s ItemRowid=$p(OrditemRowid,"||",2)
   
     s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
     
     s ItemBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,0))
	 i ItemBPRowid'="" s Empty=$p($g(^DHCRBCItemBookProperty(ItemBPRowid)),"^",4)
	 
	q Empty
}*/
/// w ##class(web.DHCRisResourceApptSchudle).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	   
	   return Replace(Strings,Str,Rep)
}

/// w ##class(web.DHCRisResourceApptSchudle).GetAttionInfo(^DHCRisTmp("GetAttionInfo"))
ClassMethod GetAttionInfo(OEItmRowidGroup As %String) As %String
{
	s AttInfo=""
    s Counts=$l(OEItmRowidGroup,"@")
    q:(OEItmRowidGroup="") AttInfo
    s ^DHCRisTmp("GetAttionInfo") = OEItmRowidGroup
    s SystemRowid="",UseHisKnowledge=""
    s SystemRowid=$o(^DHCRBC("SystemParam",SystemRowid))
    i SystemRowid'="" s UseHisKnowledge=$p($g(^DHCRBC("SystemParam",SystemRowid)),"^",19)
    i (UseHisKnowledge="Y")
    {
	     s InputInfo=..GetFormatInfo(OEItmRowidGroup)
		 s AttInfo=##class(web.DHCRisResourceApptSchudle).RequestKnowledgeInfo("Q",InputInfo,"","1") 
		 //s AttInfo= ..Replace(AttInfo,"/n",$c(13,10))
		 //s AttInfo= ..Replace(AttInfo,"/*",$c(13,10))   
	}else
	{
		 f Ni=1:1:Counts
		 {
			 s perItmRowid="",MTID=""
			 s perItmRowid=$p(OEItmRowidGroup,"@",Ni)
	         s perOrderRowid=$p(perItmRowid,"||",1)
	         s peritemsub=$p(perItmRowid,"||",2)
	         s arcimid=$p($g(^OEORD(perOrderRowid,"I",peritemsub,1)),"^",2)
			 i arcimid'="" d
		     .s perOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)  
		     .s rowid=$o(^DHCRBAppi("Goal-orditem",arcimid,0)) 
		     .s price=##class(web.DHCRisCommFunction).GetItemPrice(perItmRowid) 
		     .s perMemo=..GetMemo(perItmRowid)
		     .;w !,"perMemo="_perMemo
		     .;s perOrderName="检查项目:"_perOrderName_$c(13,10)_perMemo
		     .s MRID=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
		     .i MRID'="" d
		     ..s MTID=$p($g(^DHCRBApp("Memo",MRID)),"^",4)
	         .i MTID="" s MTID=0
		     .i $g(SameMTemplate(MTID))="" d
		     ..;s SameMTemplate(MTID)=perOrderName_","_price_"元"_$c(13,10)_"        "
		     ..s SameMTemplate(MTID)="@"_perOrderName_","_price_"元"
		     .e  d
		     ..;s SameMTemplate(MTID)=SameMTemplate(MTID)_","_perOrderName_","_price_"元"_$c(13,10)_"        "
		     ..s SameMTemplate(MTID)=SameMTemplate(MTID)_"@"_perOrderName_","_price_"元"
		     .s SameMemo(MTID)=perMemo
		     .s TotalPrice=##class(web.DHCRisApplicationBill).GetTotalPrice(OEItmRowidGroup)
		 }
		 
		 s MTRowid="" f  s MTRowid=$o(SameMTemplate(MTRowid)) q:(MTRowid="")  d
		 .;w !,SameMTemplate(MTRowid)
		 .i AttInfo="" d
		 ..s OEItmRowidGroupLen=$l(OEItmRowidGroup,"@")
		 ..i OEItmRowidGroupLen>1  d
		 ...s AttInfo="检查项目:"_SameMTemplate(MTRowid)_","_"注意事项:"_SameMemo(MTRowid)
		 ..e   d
		 ...s AttInfo="检查项目:"_SameMTemplate(MTRowid)_"@总计"_TotalPrice_","_"注意事项:"_SameMemo(MTRowid)
		 .e  d
		 ..s AttInfo=AttInfo_SameMTemplate(MTRowid)_"@注意事项:"_SameMemo(MTRowid)_"@总计"_TotalPrice
	     
		 /*
		 .i AttInfo="" d
		 ..s AttInfo="检查项目:"_SameMTemplate(MTRowid)_",总计"_TotalPrice_$c(13,10)_"        ,注意事项:"_SameMemo(MTRowid)
		 .e  d
		 ..s AttInfo=AttInfo_$c(13,10)_"          检查项目:"_SameMTemplate(MTRowid)_"        ,注意事项:"_SameMemo(MTRowid)_",总计"_TotalPrice_$c(13,10)
	     */
		 
		 k SameMTemplate
		 k SameMemo
		
	}

	q AttInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryCanUseRes","66425||788")
Query QueryCanUseRes(OrditemRowid As %String) As %Query(ROWSPEC = "BookedDate:%String,SurAutoNumber:%String")
{
}

ClassMethod QueryCanUseResExecute(ByRef qHandle As %Binary, OrditemRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	k ^DHCRISFINDBKCANUSERESDATE
 	s AppSet="N"
 	s PatType=""
    q:(OrditemRowid="")
    s ^DHCRisTemp("QueryCanUseRes")=OrditemRowid
     s OrditemRowidIn=OrditemRowid
    s OrditemRowid=$p(OrditemRowid,"@",1)
    
    s isEmpty="N"
    s isAutoBook="Y"   ;非自动预约项目无法查出资源
   for kkk=1:1:$l($g(OrditemRowidIn),"@")
   {
	  q:(isEmpty="Y")
      s orderItemIsbook=$p($g(OrditemRowidIn),"@",kkk)
      if (orderItemIsbook="")
      {
	      continue
      }
      s arcItemDr=$p(^OEORD($p(orderItemIsbook,"||",1),"I",$p(orderItemIsbook,"||",2),1),"^",2)
      if ( arcItemDr="")
      {
	      continue
      }
      s itembookPropertydr=""
      s itembookPropertydr=$o(^DHCRBCItemBookProperTypei(arcItemDr,itembookPropertydr))
      if (itembookPropertydr="")
      {
	      continue
      }
      s AppointMethodId=$p(^DHCRBCItemBookProperty(itembookPropertydr),"^",2) 
      
   	  i AppointMethodId'=""
   	  { 
   	  	s AppMethod=$p(^DHCRBCAppointMethod(AppointMethodId),"^",2) 
   	  	
   	  	if (AppMethod'="自动预约")
   	  	{
	   	  	s isAutoBook="N"
   	  	}
   	  }
   	  else
   	  {
	   	  s isAutoBook="N"
   	  }
      //b //02
      if ( $p($g(^DHCRBCItemBookProperty(itembookPropertydr)),"^",4)="Y")
      {
	      s isEmpty="Y"
      }
   }
    //b //01
    s OrderRowid=$p(OrditemRowid,"||",1)
	s ItemRowid=$p(OrditemRowid,"||",2)
    s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
    i ((ArcItemId="")||(isAutoBook="N")) s qHandle=$lb(0,repid,0)
	Quit:((ArcItemId="")||(isAutoBook="N")) $$$OK
	
    s LocId=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
	s SGCount=0
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
    i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2)  
    s ServiceGroupID=""
	s ServiceGroupID=$p(##class(web.DHCRisCommFunctionEx).GetServiceGroup(ArcItemId),"^",1)
	if (ServiceGroupID'="")
	{
		 s SGCount=$l(ServiceGroupID,",")
		 for i=1:1:SGCount
		 {
		    s perServcieGroupId=""
			s perServcieGroupId=$p(ServiceGroupID,",",i)
			s stDate=+$h
		    s endDate=stDate+6
		    s hasRes=0
		    for dateFind=stDate:1:endDate
		    {
			    s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime)) q:BookTime=""  d
 				.s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime,ResSchduleID)) q:ResSchduleID=""  d
 				..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
 				..Q:(dateFind=+$h)&&($p($h,",",2)>EndTime)
 				..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
 				..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
 				..q:(GetResource="")
		 	    ..s BK=""
		 	    ..s BK=##class(web.DHCRisBookParam).GetAppResParam(OrditemRowid,GetResource)
		 	    ..q:(BK="N")
 				..q:GetLocId'=LocId
  				..s maxNumberFind=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)
  				..s remianTimeFind=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
  				..q:((maxNumberFind'="")&(maxNumberFind<=0))
  				..q:((remianTimeFind'="")&(remianTimeFind<=0))
 				..Do OutRowCanUseRes
			}
		 }
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutRowCanUseRes
 
   
    s ResPlanId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",12)
    q:(ResPlanId="")
    s NotAllowIPBooked=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",13)
    q:(PatType'="")&(PatType="I")&(NotAllowIPBooked="Y")  
    s AvailPatType=""
    s AvailPatType=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",14)
    q:(AvailPatType'="")&(AvailPatType'[PatType) ;新增病人类型可使用资源段判断
	s Date=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	s BookedDate=$zd(Date,3)
	
	s StartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
	s StartTime=$zt(StartTime)
	s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
	q:((isEmpty="Y")&&(EndTime>43200))   ;空腹必须预约到上午
        i EndTime'="" s EndTime1=$zt(EndTime)
	s BookedDate=BookedDate_" "_StartTime_"-"_EndTime1
        q:($d(^DHCRISFINDBKCANUSERESDATE(OrditemRowid,BookedDate)))
///////////////////////////////////////////////////////修改------------------------------------------------------------------------------
	s EndTime1=$zt(EndTime)
	s TimeDesc=StartTime_"-"_EndTime1
	s BookedDate=$zd(Date,3)_"^"_TimeDesc
	q:($d(^DHCRISFINDBKCANUSERESDATE(OrditemRowid,BookedDate)))
    /*s Empty=..GetEmptyTEST(OrditemRowid)
	if ((Empty="Y")&(StartTime<"43200")&(EndTime<="43200"))
    {
		 
		 s EndTime=$zt(EndTime)
		 s BookedDate=$zd(Date,3)_"^"_StartTime_"-"_EndTime
	}elseIF (Empty="N")
	{
	  s StartTime=$zt(StartTime)
	  s EndTime1=$zt(EndTime)		
	  s BookedDate=$zd(Date,3)_"^"_StartTime_"-"_EndTime1
      ;q:($d(^DHCRISFINDBKCANUSERESDATE(OrditemRowid,BookedDate)))  ;每天的重复时间段截取
	}
	q:($d(^DHCRISFINDBKCANUSERESDATE(OrditemRowid,BookedDate)))*/
/////////////////////////////////////////////////////////////////修改---------------------------------------------------------------------------------
	s CurrentTime=$p($h,",",2)
	s CurrentDate=+$h
	q:(((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate))
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7)   ;最大的预约数
	s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)   ; 自动预约分配的数量
	q:(AutoNumber="0")
	q:(MaxNumber="0")
	s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)  ;自动预约使用数量
	q:(AutoNumber-AutoUseNumber="0")
	s SurAutoNumber=""
	i AutoUseNumber="" s AutoUseNumber="0"
	s SurAutoNumber=AutoNumber-AutoUseNumber    //自动预约剩余数
	s ^DHCRISFINDBKCANUSERESDATE(OrditemRowid,BookedDate)=""
	
    set Data=$lb(BookedDate,SurAutoNumber)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryCanUseResFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCanUseResExecute ]
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

ClassMethod QueryCanUseResClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCanUseResExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisResourceApptSchudle).GetRemainNumber("2228")
ClassMethod GetRemainNumber(ResSchduleID) As %String
{
	q:ResSchduleID=""
	s RemainNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",10) ; 总的剩余数
	s MaxNumber=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",7)   ;最大的预约数
	i RemainNumber="" s RemainNumber=MaxNumber
	q RemainNumber
}

/// 2015-07-01 add
ClassMethod changePatTypeCode(codeList As %String) As %String
{
	s patTypeList=""
	q:(codeList="") patTypeList
	s len=$l(codeList,";")
	f i=1:1:len
	{	
		
		s patCode=$p(codeList,";",i)
		s patType=""
		if (patCode="I")
		{
			s patType="住院"
		}
		elseif (patCode="O")
		{
			s patType="门诊"
		}
		elseif (patCode="E")
		{
			s patType="急诊"
		}
		elseif (patCode="H")
		{
			s patType="体检"
		}
		if (patType'="")
		{
			if patTypeList=""
			{
				s patTypeList=patType
			}
			else
			{
				s patTypeList=patTypeList_";"_patType
			}
		}
	}
	
	q patTypeList
}

Query QueryPatType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPatTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("I","住院")
 	Set ^CacheTemp(repid,2)=$lb("O","门诊")
 	Set ^CacheTemp(repid,3)=$lb("E","急诊")
 	Set ^CacheTemp(repid,4)=$lb("H","体检")
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPatTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAgeUnitExecute ]
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

ClassMethod QueryPatTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAgeUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisResourceApptSchudle).GetEmptyTEST("285||5")
ClassMethod GetEmptyTEST(OrditemRowid) As %String
{
 s Empty="N"
 q:(OrditemRowid="") Empty
 s Count=$l(OrditemRowid,"@")
	for Ei=1:1:Count 
    { 
	    s OrditemRowid1=$p(OrditemRowid,"@",Ei)
 
     s OrderRowid=$p(OrditemRowid1,"||",1)
     s ItemRowid=$p(OrditemRowid1,"||",2)
   
     s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
     
     s ItemBPRowid=$o(^DHCRBCItemBookProperTypei(ArcItemId,0))
     
 i ItemBPRowid'="" s Empty=$p($g(^DHCRBCItemBookProperty(ItemBPRowid)),"^",4)  
 i Empty="Y"  q:(Empty="Y") 
 
    }
 
 q Empty
}

/// 函数：QueryResApptSchduleyy
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：lei
/// 日期: 2015-09-19
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResApptSchduleyy","66425||788","83","","")
/// 函数：QueryResApptSchduleyy
/// 功能：查询设备的预约资源
/// 参数：oeorditem.Rowid,CT_Loc.Rowid,RB_Resouce.Rowid,日期
/// 作者：lei 
/// 日期: 2015-09-19
/// /// d ##class(%ResultSet).RunQuery("web.DHCRisResourceApptSchudle","QueryResApptSchduleyy","66425||788","83","","")
/// Flag标示 是否从主工作列表查询资源   1为从主工作列表查询最近的资源  0为点击查询按钮查询选择日期的资源
Query QueryResApptSchduleyy(OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String, ServiceGroupID As %String, IsViewFlag As %String = "") As %Query(ROWSPEC = "BookedDate:%String,TimeDesc:%String,ServiceGroupDesc:%String,StartTime:%String,EndTime:%String,Resource:%String,MaxNumber:%String,UseNumber:%String,RemainNumber:%String,AutoNumber:%String,AutoUseNumber:%String,Rowid:%String,ChargeTime:%String,remainTime:%String,nextTime:%String,TAvailPatType:%String,TAvailPatTypeCode:%String")
{
}

ClassMethod QueryResApptSchduleyyExecute(ByRef qHandle As %Binary, OrditemRowid As %String, LocId As %String, ResourceId As %String, BookDate As %String, Flag As %String, ServiceGroupID As %String, IsViewFlag As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	s ^TMP0831=OrditemRowid_"^"_LocId_"^"_ResourceId_"^"_BookDate_"^"_Flag_"^"_ServiceGroupID_"^"_IsViewFlag
 	k ^DHCRISSCHDULE("RISOLD")
 	i BookDate="" s BookDate=+$h
 	s AppSet="N"
 	s PatType=""
    
     //.s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
	 //	...s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",ServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
	 //	...Q:(BookDate=+$h)&&($p($h,",",2)>EndTime)*/    ;不显示当前时间大于预约的结束时间 
	 
 	if (OrditemRowid'="")  
 	{
	 	s ResSchduleID=..GetSchduleID(OrditemRowid)
	 	i ResSchduleID'="" d
	 	.s IsBooked="Y" 
	 	.s ^DHCRISSCHDULE("RISOLD",ResSchduleID)=""
	 	.Do OutRow6
	  	s OrderRowid=$p(OrditemRowid,"||",1)
	 	s ItemRowid=$p(OrditemRowid,"||",2)
	 	s ArcItemId=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	 	s SGCount=0
	 	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
        i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2)  
	 	;s ServcieGroupId=$p(^ARCIM($p(ArcItemId,"||",1),$p(ArcItemId,"||",2),8),"^",7)
        ;if (ServcieGroupId'="")
	 	if (ServiceGroupID'="") 
	 	{
			s SGCount=$l(ServiceGroupID,",")
			for Numi=1:1:SGCount 
			{
				;b ;00
				s perServcieGroupId=""
				s perServcieGroupId=$p(ServiceGroupID,",",Numi)
			 	if (Flag="1")
			 	{
				 	s stDate=+$h
				 	s endDate=stDate+60
				 	s hasRes=0
				 	for dateFind=stDate:1:endDate
				 	{
					 	q:(hasRes=1)
					 	s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime)) q:BookTime=""  d
		 				.q:(hasRes=1)
		 				.s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,dateFind,BookTime,ResSchduleID)) q:ResSchduleID=""  d
		 				..q:(hasRes=1)
		 				..s EndTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
		 				..Q:(dateFind=+$h)&&($p($h,",",2)>EndTime)
		 				..s GetLocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11) 
		 				..s GetResource=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)  
		 				..q:(GetResource="")
				 	    ..s BK=""
				 	    ..b  ;2
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
		 				..Do OutRow6 
				 	}
				 	
			 	} 
			 	else
			 	{
				 	 ; 查询服务组的资源计划	
				 	 ;s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResSchdulei("SericeGroup",ServcieGroupId,BookDate,ResSchduleID)) q:ResSchduleID=""  d
				 	 ;w !,perServcieGroupId
				 	 s BookTime="" f  s BookTime=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,BookDate,BookTime)) q:BookTime=""  d
				 	 .s ResSchduleID="" f  s ResSchduleID=$o(^DHCRBCResSchdulei("Service-Time",perServcieGroupId,BookDate,BookTime,ResSchduleID)) q:ResSchduleID=""  d
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
				 	 ..q:GetLocId'=LocId
				 	 ..s IsBooked=""
				  	 ..s bFindBookeInfo=1
				 	 ..Do OutRow6
				 	 
			 	}
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
	  ...d OutRow6
	  else  d
	  .s ResSchduleID=0 f  s ResSchduleID=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,BookDate,ResourceId,ResSchduleID)) q:ResSchduleID=""  d
  	  ..d OutRow6
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

	
OutRow6

     
     s ResPlanId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",12)
     q:(ResPlanId="")
     s NotAllowIPBooked=$p($g(^DHCRBCResourcePlan(ResPlanId)),"^",13)
     q:(PatType'="")&(PatType="I")&(NotAllowIPBooked="Y")
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
	 .i TimeDescRowid'="" d
	 ..s TimeDesc=$p($g(^DHCRBCTimePeriodSet(TimeDescRowid)),"^",2)
	 
	 s ServiceGroupId=""
	 s ServiceGroupId=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",4)
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
	 q:(RemainNumber=0)&(IsViewFlag=1)
	 s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13) ; 自动使用数
	 s ChargeTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",14)
	 s ChargeTime=$zt(ChargeTime)
	 s NextTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
	 i NextTime'=""  s NextTime=$zt(NextTime)
	 s RemainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
     s (availPatType,availPatTypeCode)=""
     s availPatTypeCode=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",19)
     s availPatType=..changePatTypeCode(availPatTypeCode)
     b  ;111

    set Data=$lb(BookedDate,TimeDesc,ServiceGroupDesc,StartTime,EndTime,ResourceDesc,MaxNumber,UseNumber,RemainNumber,AutoNumber,AutoUseNumber,ResSchduleID,ChargeTime,RemainTime,NextTime,availPatType,availPatTypeCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryResApptSchduleyyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResApptSchduleyyExecute ]
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

ClassMethod QueryResApptSchduleyyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResApptSchduleyyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisResourceApptSchudle).releaseResource("223")
ClassMethod releaseResource(LocId As %String) As %String
{
    //^DHCRBCResourceSchdulei("Loc-Date-Res",{DRPS_LocID},{DRPS_Date},{DRPS_RessourceID},{DRPS_RowID}) 
    ;s LocId="223"
    s startDate=+$h+1
    s endDate=startDate+7
    for date=startDate:1:endDate
    {
	    ;w !,"date="_date
    	s resourceId="" f  s resourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,date,resourceId)) q:(resourceId="")  d
    	.s drpsRowid="" f  s drpsRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,date,resourceId,drpsRowid)) q:(drpsRowid="")  d
    	..s detailRowid="" f  s detailRowid=$o(^DHCRBCResSchduleDetaili("SchudleId" ,drpsRowid,detailRowid)) q:(detailRowid="")  d
    	...s oeOrderRowid=$p(^DHCRBCResSchduleDetail("Detail",detailRowid),"^",1)
    	...;w !,oeOrderRowid
    	...q:(oeOrderRowid="")
    	...s ItemStatusCode=""
    	...s OrderRowid=$p(oeOrderRowid,"||",1)
    	...s itemsub=$p(oeOrderRowid,"||",2)
    	...s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
		...i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
		...i ((ItemStatusCode="C" )||(ItemStatusCode="U" )||(ItemStatusCode="C" )) d
		....;w !,ItemStatusCode_"***"_oeOrderRowid
		....d ..CancelBookedInfo(oeOrderRowid)
    	...s regRowid="" 
    	...s regRowid=$o(^DHCPACRegInfoi("OEORI",oeOrderRowid,regRowid))
    	...i regRowid'="" d
    	....;w !,regRowid_"&&&"_oeOrderRowid
    	....d ..CancelBookedInfo(oeOrderRowid)
    }
    
    q "0"
}

/// w ##class(web.DHCRisResourceApptSchudle).changeNum("223")
ClassMethod changeNum(LocId As %String) As %String
{
    //^DHCRBCResourceSchdulei("Loc-Date-Res",{DRPS_LocID},{DRPS_Date},{DRPS_RessourceID},{DRPS_RowID}) 
    ;s LocId="223"
    s startDate=+$h+1
    s endDate=startDate+7
    for date=startDate:1:endDate
    {
	    ;w !,"date="_date
    	s resourceId="" f  s resourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,date,resourceId)) q:(resourceId="")  d
    	.s drpsRowid="" f  s drpsRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",LocId,date,resourceId,drpsRowid)) q:(drpsRowid="")  d
    	..s (autoUseNumber,handleUseNumber)=0
    	..&sql(select count(distinct DRPD_StudyNo) into :autoUseNumber from dhcrbc_resschduledetail where DRPD_ResSchdule_ID=:drpsRowid and DRPD_AppointMethod='2')
    	..&sql(select count(distinct DRPD_StudyNo) into :handleUseNumber from dhcrbc_resschduledetail where DRPD_ResSchdule_ID=:drpsRowid and DRPD_AppointMethod='1')
    	..s MaxNumber=""
    	..s MaxNumber=$p(^DHCRBCResourceSchdule(drpsRowid),"^",7)
    	..s setAutoNumber=$p(^DHCRBCResourceSchdule(drpsRowid),"^",8)
    	..i autoUseNumber="" s autoUseNumber=0
    	..i handleUseNumber="" s handleUseNumbers=0
    	..i setAutoNumber="" s setAutoNumber=0
    	..;w !,MaxNumber_"**"_setAutoNumber_"**"
    	..;w !,"@@"_autoUseNumber_"**"_(autoUseNumber+handleUseNumber)_"**"_(MaxNumber-autoUseNumber-handleUseNumber) 
    	..s useNumber=autoUseNumber+handleUseNumber
    	..s remainNumber=MaxNumber-autoUseNumber-handleUseNumber
    	..i remainNumber<0 s remainNumber=0
    	..;w !,"@@"_useNumber_"**"_remainNumber_"**"_autoUseNumber
    	..&sql(update  dhcrbc_resschdule(DRPS_UseNumber,DRPS_RemainNumber,DRPS_AutoUseNumber) values(:useNumber,:remainNumber,:autoUseNumber) where DRPS_RowID=:drpsRowid)
    }
    
    q "0"
}

/// w ##class(web.DHCRisResourceApptSchudle).dealSameStudyNo()
ClassMethod dealSameStudyNo() As %String
{
	
  s sqlStr="select DRPD_StudyNo,count (distinct DRPD_EpsoideID) as Num1 from dhcrbc_resschduledetail group by DRPD_StudyNo having count (distinct DRPD_EpsoideID)>1"
	        	       
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(sqlStr)
  d result.Execute()
	
  s count=0
  
  While(result.Next()){  
	s studyNo = result.Data("DRPD_StudyNo")
	if (studyNo'="")
	{
		;s reginfoDr=""
		;s reginfoDr=$o(^DHCPACRegInfoi("StudyNo",studyNo,reginfoDr) )
		;if (reginfoDr="")
		;{
			;^DHCPACRegInfoi("OEORI",{RAR_OEORI_DR},{RAR_Rowid})
			s episode="",episodeGet=""
			s startAdd=1
			s studNoGet="",studyNoModi=""
			s oeOrdDrGet=""
			s detailDr=""  f  s detailDr=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNo,detailDr)) q:(detailDr="")  d
			.s episodeGet=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",3)
			.s studNoGet=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",6)
			.s oeOrdDrGet=$p(^DHCRBCResSchduleDetail("Detail",detailDr),"^",1)
			.s reginfoDr=""
		    .s reginfoDr=$o(^DHCPACRegInfoi("OEORI",oeOrdDrGet,reginfoDr) ) 
		    .q:(reginfoDr'="")
			.i ($d(studyNoAdd(episodeGet))=1) d
			..s studyNoModi=studNoGet_"M"_studyNoAdd(episodeGet)
			.e  d
			..s studyNoModi=studNoGet_"M"_startAdd
			..s studyNoAdd(episodeGet)=startAdd
			..s startAdd=startAdd+1
			.w !,detailDr_"^"_studNoGet_"^"_studyNoModi
			.s ^DHCRisTemp("changeStudyNo",detailDr)=studNoGet_"^"_studyNoModi
			.&sql(update dhcrbc_resschduledetail set DRPD_StudyNo=:studyNoModi where DRPD_RowID=:detailDr)
			k studyNoAdd
		;}
	}
   }

  d result.Close()
}

/// w ##class(web.DHCRisResourceApptSchudle).releaseResourceByStudyNo("")
ClassMethod releaseResourceByStudyNo(studyNo As %String) As %String
{
	q:(studyNo="") ""
    s resDetailDr="" f  s resDetailDr=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNo,resDetailDr)) q:(resDetailDr="")  d
    .s schDuleId=$p(^DHCRBCResSchduleDetail("Detail",resDetailDr),"^",2)
    .s oeOrderRowid=$p(^DHCRBCResSchduleDetail("Detail",resDetailDr),"^",1)
	.q:(schDuleId="")
	.s resDate=$p(^DHCRBCResourceSchdule(schDuleId),"^",2)
	.;b //01
	.if (resDate>+$h)  d
	..;b //02
    ..d ..CancelBookedInfo(oeOrderRowid)
    ..s ^DHCRisTemp("releaseResource",studyNo,oeOrderRowid,+$h,$p($h,",",2))=schDuleId
    q "0"
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookInfo("2521699||9@2521699||10@2521699||11")
ClassMethod getBookInfo(orderList As %String) As %String
{
	s ret=""
	q:(orderList="") ""
	for i=1:1:$l(orderList,"@")
	{
		q:(ret'="")
		s orderDr=$p(orderList,"@",i)
		if (orderDr="")
		{
			continue
		}
		s ResDetailRowid=""
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderDr,0)) 
		i (ResDetailRowid'="")
		{
		   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
		   i ResSchduleID'="" d
		   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
		   .i Date'="" s BookedDate=$zd(Date,3)
		   .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
		   .i StartTime'="" s BooketSTime=$zt(StartTime)
		   .s endTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
		   .i endTime'="" s BooketETime=$zt(endTime)
		   .s ret=BookedDate_"^"_BooketSTime_"-"_BooketETime
		}
	}

    q ret
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookInfoForRegAppoint("2521699||9@2521699||10@2521699||11")
ClassMethod getBookInfoForRegAppoint(orderList As %String) As %String
{
	s ret=""
	q:(orderList="") ""
	s callNo=""
	for i=1:1:$l(orderList,"@")
	{
		q:(ret'="")
		s orderDr=$p(orderList,"@",i)
		if (orderDr="")
		{
			continue
		}
		s ResDetailRowid=""
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderDr,0)) 
		i (ResDetailRowid'="")
		{
			s timeDesc=""
			s eqIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",8)
			s checkgroupIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",9)
			s roomIndex=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",10)
			i eqIndex'="" s callNo=eqIndex
			i checkgroupIndex'=""  s callNo=checkgroupIndex
			i roomIndex'="" s callNo=roomIndex
		   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
		   i ResSchduleID'="" d
		   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
		   .s ResourceDesc=""
		   .i ResouceId'="" d
		   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
		   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
		   ..i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
		   ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
		   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
		   .i Date'="" s BookedDate=$zd(Date,3)
		   .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
		   .i StartTime'="" s BooketSTime=$zt(StartTime)
		   .s endTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
		   .i endTime'="" s BooketETime=$zt(endTime)
		   .s timeCode=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",3)
		   .i timeCode'="" d
		   ..s timeId=$o(^DHCRBCTimePeriodSeti("Code",timeCode,0))
		   ..i timeId'="" d
		   ...s timeDesc=$p(^DHCRBCTimePeriodSet(timeId),"^",2)
		   .i timeDesc="" d
		   ..s timeDesc=BooketSTime_"-"_BooketETime
		   .s ret=ResourceDesc_"^"_BookedDate_"^"_timeDesc_"^"_callNo
		}
	}

    q ret
}

/// w ##class(web.DHCRisResourceApptSchudle).hasBookOrder("")
ClassMethod hasBookOrder(orderList1 As %String) As %String
{
	s hasBook="N"
	q:(orderList1="") hasBook
	for orderNumber=1:1:$l(orderList1,"@")
	{
		q:(hasBook="Y")
		s orderBody=$p(orderList1,"@",orderNumber)
		s orderDr=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)
		if (orderDr="")
		{
			continue
		}
		s ResDetailRowid=""
		for 
		{
			s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderDr,ResDetailRowid)) 
			q:(ResDetailRowid="")
			
		   if (bodyList'="")
		   {
			   for i=1:1:$l(bodyList,",")
			   {
				   s bodyRowid=$p(bodyList,",",i)
				   if (bodyRowid'="")
				   {
					   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid,bodyRowid,0))
					   if (detailBodyRowid'="")
					   {
						   s hasBook="Y"
					   }
				   }
			   }
		   }
		   else
		   {
		   	s hasBook="Y"
		   }
			
		}
	}

    q hasBook
}

/// w ##class(web.DHCRisResourceApptSchudle).IsExitBookStudyNo("CS20151012-017")
ClassMethod IsExitBookStudyNo(CreateStudyNo As %String)
{
	s IsCreate="N"
	q:(CreateStudyNo="") IsCreate
	s DRowid=""
	s DRowid=$o(^DHCRBCResSchduleDetaili("StudyNo",CreateStudyNo,DRowid))
	i DRowid'="" s IsCreate="Y"
	q IsCreate
}

/// 删除生成的资源排班
/// w ##class(web.DHCRisResourceApptSchudle).deleteResApptSchulde(^DHCRisTemp("deleteResApptSchulde"))
ClassMethod deleteResApptSchulde(Info As %String) As %String
{
	s ^DHCRisTemp("deleteResApptSchulde")=Info
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

	
	s ret=""
	//^DHCRBCResSchduleDetaili("SchudleId" ,{DRPD_ResSchdule_ID},{DRPD_RowID})
	//^DHCRBCResourceSchdulei("LocId-Res-Date",{DRPS_LocID},{DRPS_RessourceID},{DRPS_Date},{DRPS_RowID})
    for i=1:1:Count d
    .s ResourceId=$p(ResID,"@",i)
    .;w !,ResourceId
    .q:(ResourceId="")
    .s ResourceDesc=""
    .s EqId=$p($g(^RB("RES",ResourceId)),"^",3)
    .s CareProvId=$p($g(^RB("RES",ResourceId)),"^",2)
    .i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
    .i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
    .for CurrDate=StartDate:1:EndDate d
    ..;w !,CurrDate
    ..s ResSchRowid=""  f  s ResSchRowid=$o(^DHCRBCResourceSchdulei("LocId-Res-Date",LocId,ResourceId,CurrDate,ResSchRowid)) q:(ResSchRowid="")  d
    ...;w !,ResSchRowid
    ...s detailId=""
    ...s detailId=$o(^DHCRBCResSchduleDetaili("SchudleId" ,ResSchRowid,""))
    ...s patientIdInHNSY=$o(^DHCRBCBookInfoExternali(ResSchRowid,""))
    ...i ((detailId="") && (patientIdInHNSY="")) d
    ....&sql(delete from DHCRBC_ResSchdule where DRPS_RowID= :ResSchRowid)
    ...e  d
    ....s (BooketSTime,BooketETime)=""
    ....s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchRowid)),"^",5) 
    ....i StartTime'="" s BooketSTime=$zt(StartTime)
    ....s endTime=$p($g(^DHCRBCResourceSchdule(ResSchRowid)),"^",6) 
    ....i endTime'="" s BooketETime=$zt(endTime)
    ....s ret=ret_"^"_ResourceDesc_"("_$zd(CurrDate,3)_" "_BooketSTime_"-"_BooketETime_")已使用，无法删除"
    /*
    ...i detailId'=""  d
    ....s (BooketSTime,BooketETime)=""
    ....s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchRowid)),"^",5) 
    ....i StartTime'="" s BooketSTime=$zt(StartTime)
    ....s endTime=$p($g(^DHCRBCResourceSchdule(ResSchRowid)),"^",6) 
    ....i endTime'="" s BooketETime=$zt(endTime)
    ....s ret=ret_"^"_ResourceDesc_"("_$zd(CurrDate,3)_" "_BooketSTime_"-"_BooketETime_")已使用，无法删除"
    ...e  d
    ....&sql(delete from DHCRBC_ResSchdule where DRPS_RowID= :ResSchRowid)
    ....;s ret="delete from DHCRBC_ResSchdule where DRPS_RowID="_ResSchRowid
    */
    q ret
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookDetailRowid("")
ClassMethod getBookDetailRowid(orderRowid As %String) As %String
{
	q:(orderRowid="") ""
	s ResDetailRowid=""
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderRowid,0)) 
	q ResDetailRowid
}

// w ##class(web.DHCRisResourceApptSchudle).GetPlanPermission("83","167")

ClassMethod GetPlanPermission(LocID As %String, UserID As %String) As %String
{
	s Logo="N"
	i (LocID'="")&&(UserID'="") d
	.;w "LocID="_LocID
	.s DRRURowID="" f  s DRRURowID=$o(^User.DHCRBCResourceUseI("DRRULocRowidIndex"," "_LocID,DRRURowID))  q:(DRRURowID="")  d
	..;w "DRRURowID="_DRRURowID
	..;b //2
    ..s (DRRUUserRowid,DRRULocRowid)=""
    ..s DRRUUserRowid=$lg(^User.DHCRBCResourceUseD(DRRURowID),2)
    ..;w "DRRUUserRowid="_DRRUUserRowid
    ..s DRRULocRowid=$lg(^User.DHCRBCResourceUseD(DRRURowID),3)
    ..;w "DRRULocRowid="_DRRULocRowid
    ..i (LocID=DRRULocRowid)&&(UserID=DRRUUserRowid) s Logo="Y"
    q Logo
}

// w ##class(web.DHCRisResourceApptSchudle).GetPerssionLoc("","911")

ClassMethod GetPerssionLoc(LocID As %String, UserID As %String) As %String
{
	s Logo="N",DRRULocRowid="",locDesc="",Info=""
	i (UserID'="") d
	.s DRRURowID="" f  s DRRURowID=$o(^User.DHCRBCResourceUseI("DRRUUserRowidIndex"," "_UserID,DRRURowID))  q:(DRRURowID="")  d
    ..s (DRRUUserRowid,DRRULocRowid)=""
    ..;w !,"DRRURowID="_DRRURowID
    ..s DRRUUserRowid=$lg(^User.DHCRBCResourceUseD(DRRURowID),2)
    ..;w "DRRUUserRowid="_DRRUUserRowid
    ..s DRRULocRowid=$lg(^User.DHCRBCResourceUseD(DRRURowID),3)
    ..s locDesc=$P(^CTLOC(DRRULocRowid),"^",2)
    ..s Info=Info_$C(2)_locDesc_$C(1)_DRRULocRowid_$C(1)_"0"
    q Info
}

/// 功能:预约可用
/// 作者:wf
/// 日期:20160801
/// w ##class(web.DHCRisResourceApptSchudle).Book(^TempDHCRis("Book"))
ClassMethod Book(Info As %String) As %String
{
	s ^TempDHCRis("Book")=Info
	
	s OrderItemRowid=$p(Info,"^",1)    //医嘱串，可能会有部位
	s ResSchduleID=$p(Info,"^",2)      //资源计划rowid
	s AppointMethod=$p(Info,"^",3)     //1: 手动， 2：自动 可能会有其他标志 
	s OherParam=$p($g(Info),"^",4)     //暂时不用
    s InLocDR=$p($g(Info),"^",5)       //科室rowid 可以后台取出
    s paadr=$p($g(Info),"^",6)         //就诊，暂时不用
    s InputRegDate="" //$p($g(Info),"^",7)  //日期，应该不用，可以从资源计划取出
    s UserDR=$p($g(Info),"^",8)        //操作人
    s GetStudyNo=$p($g(Info),"^",9)    //检查号 ，不需要
    s bookTimeIn=$p($g(Info),"^",10)   //时间点（适用于时间点预约，选座模式）
    s examTime=$p($g(Info),"^",11)     //检查时间(分钟)
    
    s examTime=""
    s bookTime=""     ;预约时间点
    
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	
	
	i bookTimeIn'="" d
	.s bookTime=$zth(bookTimeIn,2)
	
	;不可用退出
	s notAvailable=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",23)
    q:(notAvailable="Y") "-800"
    
	s bookDateGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	s InputRegDate=$zd(bookDateGet,3)
    
    n MaxNumber,AutoNumber,UseNumber,RemainNumber,AutoUseNumber,nextStartTime,remainTime
    s RegEQIndex="",CheckGroupIndex="",RoomIndex="",IsUpBookNo="",IndexTypeDR=""
    
    //s bookType="1"   ; 1为按最大数预约   2为按检查时间预约
    
	s DHCRisSystemInfo=##class(web.DHCRisCommFunction).GetSystemParam()
    s DHCRisVersion=$p($g(DHCRisSystemInfo),"^",15)
   
    s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    //i (remainTime'="")&&(nextStartTime'="") d
    //.s bookType="2"
	s bookType=##class(web.DHCRisCodeTableAdd).GetBKUseFlagbyLoc(InLocDR)
    
    Set $ZT="ERROR"	
    
    s Count=$l(OrderItemRowid,"@")
    
    //判断是否有已经预约的记录 wangfeng 
    s ret=..hasBookOrder(OrderItemRowid)
    q:(ret="Y") "-11112"
    
    //先判断是不是同一个病人的医嘱
	s isSamePat=##class(web.DHCRisRegisterPatientDoEx).isSamePatient(OrderItemRowid)
	q:(isSamePat="N") "-11111"

    
    lock +(^DHCRisTMPReg)
    
    //k ^DHCRISTMP("STUDYNO")
    
    //TSTART
    //判断此时间点已经有预约,
    s detailDr=""
    if (bookTimeIn'="")
    {
    	s detailDr=$o(^DHCRBCResSchduleDetaili("BKSTARTTIME",ResSchduleID,bookTime,detailDr))
    }
    if ( detailDr'="")
    {
	    lock -(^DHCRisTMPReg)
		s SQLCODE="-10055",ret="0"
		q
    }
    
   
    //获取流水号
    //s MaxIndexInfo=..GetCurrentBookMaxIndex(MaxParam)
    
    //判断资源数
    s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
	i UseNumber="" s UseNumber=0
    i AutoUseNumber="" s AutoUseNumber=0
   	;wangfeng  服务台预约判断手动预约数
   	i AutoNumber="" s AutoNumber=0
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
   	s ManualNumber=MaxNumber-AutoNumber
   	s ManulaUseNumber=UseNumber-AutoUseNumber
   	  
   	s startTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
   	s stopTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
   	
   	if (((bookDateGet=+$h) && ($p($h,",",2)>stopTime))||(bookDateGet<+$h))
   	{
	   	lock -(^DHCRisTMPReg) 
		q "-400"  
	}
	
   	s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
   	if (nextStartTime="")
   	{
	   	s nextStartTime=startTime
	}
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    if (remainTime="")
    {
	    s remainTime=(stopTime-startTime)/60
    }
    
    ;预约已满，不允许预约
    if (AppointMethod="2")   //自动预约
    {
	    if ((AutoUseNumber>=AutoNumber)||RemainNumber<=0)
	    {
		    lock -(^DHCRisTMPReg) 
		    q "-100"  
	    }
    }
    else
    {
	    if (RemainNumber<=0)
	    {
		   lock -(^DHCRisTMPReg) 
		   q "-300" 
	    }
    }
    
    
    
    s bookNo=..GetBookNo(OrderItemRowid,InLocDR,InputRegDate)
    if (examTime="")
    {
	    s examTime=+(..getExamTime(OrderItemRowid))
    }
    
    if (bookTime'="")
    {
	    s examTime=0
    }
    
    
    
    s updateNextStartTime="",updateRemainTime="",updateOccupyOfTimeRelease=""
   	s examEndTime="",examStartTime=""
   	s getStartTime="",getEndTime=""
   	
   	if ( (bookType=2) && (examTime=0))  //按最大数预约，检查时间不能为空
   	{
	    lock -(^DHCRisTMPReg) 
		q "-500" 
   	}
    if ((bookType=2) &&(examTime'=0))
    {
	    s bookTimeInfo=..getBookTimeInfo(examTime,ResSchduleID)
	    /*if (remainTime=0)
	    {
		    lock -(^DHCRisTMPReg) 
		    q "-200" 
	    }
	    */
	    
	    if (bookTimeInfo'="")
	    { 
	    	if ( $p($g(bookTimeInfo),"^",1)="N")
	    	{
		    	lock -(^DHCRisTMPReg) 
				q "-200" 
	    	}
	    	s examStartTime=$p($g(bookTimeInfo),"^",2)
	    	s examEndTime=$p($g(bookTimeInfo),"^",3)
	    	s updateNextStartTime=$p($g(bookTimeInfo),"^",4)
	    	s updateOccupyOfTimeRelease=$p($g(bookTimeInfo),"^",5)
	    }
    }
    else
    {
	    if (bookTime'="")
	    {
		    s examStartTime=bookTime
		    s examEndTime=bookTime
	    }
	    else
	    {
	    	s examStartTime=startTime
	    	s examEndTime=stopTime
	    }
	    s updateNextStartTime=startTime
	    s updateOccupyOfTimeRelease=""
	    
    }
    
    s retList=..getNextNumber(ResSchduleID)
    s nextNum=$p(retList,"^",1)
    s updateUseNoList=$p(retList,"^",2)

    b //02
    
    TSTART
    s SQLCODE=100
    
    //插入预约表
    for Ni=1:1:Count 
    {
      s perOrditemRowid=$p(OrderItemRowid,"@",Ni)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)
	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
   	  
	  &sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,DRPD_EQ_Index,
	                   	                      DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime) 
	         values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:bookNo,:nextNum,:UserDR,:OperateDate,:OperateTime,:examStartTime,:examEndTime)) 
	    	//values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime)) 
      s detailRowid=$p(%ROWID,$c(1))
      if (bodyList'="")
      {
	      s bodyLength=$l(bodyList,",")
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      if (bodyRowid'="")
		      {
			      s BodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",1)
			      &sql(insert into DHCRBC_SchduleDetailBody (SchduleDetailRowid,BodyRowid,BodyCode)values(:detailRowid,:bodyRowid,:BodyCode))
		      }
	      }
      }
	  q:SQLCODE 
    }  
			
    if (SQLCODE)
    {
		TRollback
		lock -(^DHCRisTMPReg)
		q SQLCODE
    }

    
    //更新资源计划表
    s (updateRemainTime,updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
    
    
     s updateUseNumber= UseNumber+1
   	 s updateRemainNumber=RemainNumber-1	
   	 if (AppointMethod="2")  //自动预约
   	 {
   	     s updateAutoUseNumber=AutoUseNumber+1
   	 }
   	 else
   	 {
	   	 s updateAutoUseNumber=AutoUseNumber
   	 }
   	 
     b //02
   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam)
                          values (:updateAutoUseNumber,:updateRemainNumber,:updateUseNumber,:updateNextStartTime,:updateRemainTime,:updateUseNoList,:updateOccupyOfTimeRelease) where  DRPS_RowID=:ResSchduleID)  
 
     b //03
     if (SQLCODE)
     {
		TRollback
		lock -(^DHCRisTMPReg)
		q SQLCODE
     }  
     b  //1
     
     
     TCOMMIT  
     lock -(^DHCRisTMPReg)
                
      
      s ret=##class(RISService.InvokeRISService).InsertStudyInfoPACS(bookNo,"B")
 	  s ^DHCRisTemp("bookToRis4")=bookNo_"^"_"B"_"^"_ret
   	
   	//
   
   	//调用接口
   	//状态接口 	
   	if ($g(UserDR)'="")
   	{
	   	s userName=$p($g(^SSU("SSUSR",UserDR)),"^",2)
	   	//2019/09/25修复Ens_Status、Ens_Statuslog表中“ES_OperatorID”字段值错误的问题
	   	s userId = $p($g(^SSU("SSUSR",UserDR)),"^",1)
   	}
   	//##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus("59||35","222",bookNo,"BK",$g(UserDR),$g(userName))
   	s Count=$l(OrderItemRowid,"@")
   	b //0001
    for num=1:1:Count 
    {
	  
      s perOrditemRowid=$p(OrderItemRowid,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyCodeList=""
	      s bodyLength=$l(bodyList,",")
	      s bodyDescList=""
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      
		      if (bodyRowid'="")
		      {
			      s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			      if bodyDescList= "" s bodyDescList=bodyDesc
			      else  s bodyDescList=bodyDescList_"@@"_bodyDesc
			     
		      }
			  
	      }
	      ///定位
	      s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,bodyDescList,bookNo,"BK",$g(userId),$g(userName))
		  s ^TempDHCRis("postStatus",perOrditemRowid,bodyDescList,$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"BK"_"^"_$g(userId)_"^"_$g(userName)_"^"_$g(ret)
	    
      }
      else
      {

      	  s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(perOrditemRowid,"",bookNo,"BK",$g(userId),$g(userName))
	      s ^TempDHCRis("postStatus",perOrditemRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"BK"_"^"_$g(userId)_"^"_$g(userName)_"^"_$g(ret)
      	
      }
    }
    
    b //000002
    
    /*
   	//ris4.0接口
 	s insertObj=##class(RISService.BookPlatformClass.InsertStudyInfo).%New()
 	s insertObj.StudyNo=bookNo
 	s insertObj.BookOrArrive="Book"
 	
 	s Count=$l(OrderItemRowid,"@")
    for num=1:1:Count 
    {
	    s itemObj=##class(RISService.BookPlatformClass.Item).%New()
	    
      s perOrditemRowid=$p(OrderItemRowid,"@",num)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      
      if (bodyList'="")
      {
	      s bodyCodeList=""
	      s bodyLength=$l(bodyList,",")
	      for bodyNum=1:1:bodyLength
	      {
		      s bodyRowid=$p(bodyList,",",bodyNum)
		      if (bodyRowid'="")
		      {
			      s BodyCode=$p($g(^DHCAPPART(bodyRowid)),"^",1)
			      s rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(perOrditemRowid_"^"_bodyRowid)
			      if bodyCodeList="" s bodyCodeList=BodyCode
			      e  s bodyCodeList=bodyCodeList_"^"_BodyCode
		      }
	      }
	      
	      s itemObj.BodyCodeList=bodyCodeList
			s itemObj.OEORowid=perOrditemRowid
			s itemObj.Rowid=rowid
			d insertObj.Items.Insert(itemObj)
      }
      else
      {

      		s rowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(perOrditemRowid_"^")
	      s itemObj.BodyCodeList=""
	      s itemObj.OEORowid=perOrditemRowid
	      s itemObj.Rowid=rowid
	      d insertObj.Items.Insert(itemObj)
      	
      }
      //s OrdRowid=$p(perOrditemRowid,"||",1)
      //s itemsub=$p(perOrditemRowid,"||",2)
	  //s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
    }
    
    s info=##Class(RISService.BookPlatformInterface).WriteXmlToStream(insertObj,"")
    s ret=##Class(RISService.BookPlatformInterface).InsertStudyInfoPACS(info)
    s ^DHCRisTemp("sendbookToRis",bookNo,$zd(+$h,3),$zt($p($h,",",2),1))=info_"^"_ret
    
    */
    
    q $g(SQLCODE)
    
    
  
ERROR	
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^TempDHCRis("book")=ErrorMsg
	b //02
 	TROLLBACK
 	lock -(^DHCRisTMPReg)
 	q $g(SQLCODE)_"^"_$g(ret)
}

// 根据资源计划表rowid,获取序号和插入后更新的已使用序号列表

ClassMethod getNextNumber(ResSchduleID)
{
	s ^TempDHCRisWf("getNextNumber")=ResSchduleID
	s numRet=""
	s updateUse=""
	q:(ResSchduleID="") numRet
	s rangeOfNum=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",20)
	s userNumberList=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",21)
	q:($l(rangeOfNum,"-")'=2) numRet
	s step=0
	for i=$p(rangeOfNum,"-",1):1:$p(rangeOfNum,"-",2)
	{
		q:(numRet'="")
		s step=step+1
		s numGet=$p(userNumberList,",",step)	
		if (numGet=i)
		{
			if (updateUse="")
			{
				s updateUse=i
			}
			else
			{
				s updateUse=updateUse_","_i
			}
			continue
		}
		else
		{
			s numRet=i
			if (updateUse="")
			{
				s updateUse=i
			}
			else
			{
				s updateUse=updateUse_","_i
			}
		}
	}
	//从step开始把userNumberList赋值给updateUse
	//从step开始把userNumberList赋值给updateUse
	if (numRet'="")
	{
		for iii=step:1:$l(userNumberList,",")
		{
			s userNumberGet=$p(userNumberList,",",iii)
			if (userNumberGet'="")
			{
				if (updateUse="")
				{
					s updateUse=$p(userNumberList,",",iii)
				}
				else
				{
					s updateUse=updateUse_","_$p(userNumberList,",",iii)
				}
			}
		}
	
	}
	q numRet_"^"_updateUse
}

/// 根据检查时间和资源计划rowid，获取预约开始时间、结束时间和
///   需要更新的资源计划内容(剩余时间,下次开始时间以及释放的时间)
ClassMethod getBookTimeInfo(examTime, ResSchduleID) As %String
{
	s examTimeGet=+examTime
	q:(examTimeGet=0) ""
	s hasTimeSchdule="N"
	
	s startTimeGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
   	s stopTimeGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
   	s nextStartTimeGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
   	s remainTimeGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
   	s occupyTimeOfReleaseGet=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",22)
   	
   	if (nextStartTimeGet="")
   	{
	   	s nextStartTimeGet=startTimeGet
	}
    
    if (remainTimeGet="")
    {
	    s remainTimeGet=(stopTimeGet-startTimeGet)/60
    }
    
    s (examSTime,examETime,updateNextSTime,updateOccupyTime)=""
    
    if (occupyTimeOfReleaseGet'="")
    {
	    //先获取释放的时间
	    s numOfAvail=""
	    for numOfTimeSpan=1:1:$l(occupyTimeOfReleaseGet,";")
	    {
		    q:(numOfAvail'="")
		    s timeSpan=$p(occupyTimeOfReleaseGet,";",numOfTimeSpan)
		    s stTime=$p(timeSpan,",",1)
		    s eTime=$p(timeSpan,",",2)
		    if ((eTime-stTime)>=(examTimeGet*60))
		    {
			    //可以预约
			    s hasTimeSchdule="Y"
			    s examSTime=stTime
			    s examETime=stTime+(examTimeGet*60)
			    s numOfAvail=numOfTimeSpan
			    s updateNextSTime=nextStartTimeGet
		    }
		    elseif( (eTime-stTime)>=((examTimeGet-5)*60) )
		    {
			    //可以预约
			    s hasTimeSchdule="Y"
			    s examSTime=stTime
			    s examETime=eTime
			    s numOfAvail=numOfTimeSpan
			    s updateNextSTime=nextStartTimeGet
		    }
	    }
	    
	    //根据是否有可用的释放时间，得到更新的可用释放时间
	    for numOfTimeSpan=1:1:$l(occupyTimeOfReleaseGet,";")
	    {
		    s timeSpan=$p(occupyTimeOfReleaseGet,";",numOfTimeSpan)
		    s stTime=$p(timeSpan,",",1)
		    s eTime=$p(timeSpan,",",2)
		    if (numOfTimeSpan=numOfAvail)
		    {
			    if ( eTime>examETime)
			    {
				    s timeSpanUpdate=examETime_","_eTime
			    }
			    else
			    {
				    s timeSpanUpdate=""
			    }
		    }
		    else
		    {
			    s timeSpanUpdate=stTime_","_eTime
		    }
		    if (timeSpanUpdate'="")
		    {
			    if (updateOccupyTime'="")
			    {
				    s updateOccupyTime=updateOccupyTime_";"_timeSpanUpdate
				}
				else
				{
					s updateOccupyTime=timeSpanUpdate
				}
		    }   
	    }
    }
    //
    if ( hasTimeSchdule'="Y")
    {
	    if ( (stopTimeGet-nextStartTimeGet) >= (examTimeGet*60))
	    {
		    s examSTime=nextStartTimeGet
			s examETime=nextStartTimeGet+(examTimeGet*60)
			s updateNextSTime=nextStartTimeGet+(examTimeGet*60)
		    s hasTimeSchdule="Y"
	    }
	    elseif ((stopTimeGet-nextStartTimeGet) >= ((examTimeGet-5)*60))
	    {
		    s examSTime=nextStartTimeGet
			s examETime=stopTimeGet
			s updateNextSTime=stopTimeGet
			s hasTimeSchdule="Y"
	    } 
    }
    
    q hasTimeSchdule_"^"_examSTime_"^"_examETime_"^"_updateNextSTime_"^"_updateOccupyTime
}

/// BookInpatient
/// 功能:住院病人预约占位
/// 作者:wf
/// 日期:20160813
/// w ##class(web.DHCRisResourceApptSchudle).BookInpatient("")
ClassMethod BookInpatient(Info As %String) As %String
{
	s ^TempDHCRis("BookInpatient")=Info
	
	Set $ZT="ERRORBookIN"	
	s ResSchduleID=$p(Info,"^",1)      //资源计划rowid
	s examTime=+$p(Info,"^",2)         //检查时间
    s UserDR=$p($g(Info),"^",3)        //操作人
    s inpatientNo=$p($g(Info),"^",4)
    s inpatientName=$p($g(Info),"^",5)
    
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	b //001
	lock +(^DHCRisTMPReg) 
	b //002
	s bookDate=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",2)
	s resourceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	s locId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
	
	;判断住院病人是否当天在此科室有预约
	;s conflict="N"
	s exterResId=""
	s (retInfo,ResourceDescExt)=""
	
	s exteralBookID=$o(^DHCRBCBookInfoExternali("IndexPat",locId,bookDate,inpatientNo,0))
	if (exteralBookID'="")
	{
		s stTimeExt=$p(^DHCRBCBookInfoExternal(exteralBookID),"^",7)
		s eTimeExt=$p(^DHCRBCBookInfoExternal(exteralBookID),"^",8)
		s exterResId=$p(^DHCRBCBookInfoExternal(exteralBookID),"^",2)
		s EqIdExt=$p($g(^RB("RES",exterResId)),"^",3)
	    if (EqIdExt'="")
	    {
		    s ResourceDescExt=$p(^RBC("EQ",EqIdExt),"^",2)
	    }
		s retInfo="已预约到 "_ResourceDescExt_" ("_$zd(bookDate,3)_" "_$zt(stTimeExt,2)_"--"_$zt(eTimeExt,2)_")"
	    
	    lock -(^DHCRisTMPReg) 
		q "-20000^"_retInfo
	}
	 
	
	
		
	
	
   	s startTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
   	s stopTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6) 
    s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)

   	if (nextStartTime="")
   	{
	   	s nextStartTime=startTime
	}
    s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    if (remainTime="")
    {
	    s remainTime=(stopTime-startTime)/60
    }
    
	
    //判断资源数
    s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    
    i UseNumber="" s UseNumber=0
   	
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
    
    

	if ((bookDate=+$h) && ($p($h,",",2)>stopTime))
   	{
	   	lock -(^DHCRisTMPReg) 
		q "-400"  
	}
	
    ;预约已满，不允许预约
    if (RemainNumber<=0)
    {
	   lock -(^DHCRisTMPReg) 
	   q "-300" 
    }
    
    ;预约时间
    s updateNextStartTime="",updateRemainTime="",updateOccupyOfTimeRelease=""
   	s examEndTime="",examStartTime=""
   	s getStartTime="",getEndTime=""
   	
    if (examTime'=0)
    {
	    s bookTimeInfo=##class(web.DHCRisResourceApptSchudle).getBookTimeInfo(examTime,ResSchduleID)
	    
	    
	    if (bookTimeInfo'="")
	    { 
	    	if ( $p($g(bookTimeInfo),"^",1)="N")
	    	{
		    	lock -(^DHCRisTMPReg) 
				q "-200" 
	    	}
	    	s examStartTime=$p($g(bookTimeInfo),"^",2)
	    	s examEndTime=$p($g(bookTimeInfo),"^",3)
	    	s updateNextStartTime=$p($g(bookTimeInfo),"^",4)
	    	s updateOccupyOfTimeRelease=$p($g(bookTimeInfo),"^",5)
	    }
    }
    else
    {
	    s examStartTime=startTime
	    s examEndTime=stopTime
	    s updateNextStartTime=startTime
	    s updateOccupyOfTimeRelease=""
	    
    }
    
	s retList=..getNextNumber(ResSchduleID)
    s nextNum=$p(retList,"^",1)
    s updateUseNoList=$p(retList,"^",2)
    
    &sql(insert into DHCRBC_BookInfoExternal(bookDate,bookNum,endTime,locID,patientID,patientName,resSchduleID,resourceDesc,resourceID,startTime)
   	                                       values(:bookDate,:nextNum,:examEndTime,:locId,:inpatientNo,:inpatientName,:ResSchduleID,"",:resourceId,:examStartTime))
    
    //更新资源计划表
    /*
    s (updateNextStartTime,updateRemainTime,updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
    s updateNextStartTime=nextStartTime+(examTime*60)
    i ((remainTime-examTime)>0) 
    {
    	s updateRemainTime=remainTime-examTime
    }
     else 
     {
     	s updateRemainTime=0
     }
     */
     
     s (updateUseNumber,updateRemainNumber)=""
     
     s updateUseNumber= UseNumber+1
   	 s updateRemainNumber=RemainNumber-1
   	 
   	 	
   	 
     b //01
   	// &sql(update DHCRBC_ResSchdule (DRPS_RemainNumber,DRPS_UseNumber,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber)
     //                     values (:updateRemainNumber,:updateUseNumber,:updateNextStartTime,:updateRemainTime,:updateUseNoList) where  DRPS_RowID=:ResSchduleID)  
     &sql(update DHCRBC_ResSchdule (DRPS_RemainNumber,DRPS_UseNumber,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam)
                          values (:updateRemainNumber,:updateUseNumber,:updateNextStartTime,:updateRemainTime,:updateUseNoList,:updateOccupyOfTimeRelease) where  DRPS_RowID=:ResSchduleID)  
 
     
     //需要记录一下住院占位记录
      
    lock -(^DHCRisTMPReg) 
    q $g(SQLCODE)
  
ERRORBookIN  

	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^TempDHCRis("book")=ErrorMsg
	b //02
 	lock -(^DHCRisTMPReg)
 	q $g(SQLCODE)
}

// wf  20160802 生成预约号，传入医嘱串，生成一个预约号

ClassMethod GetBookNo(orditmrowid, LocDr, bookDate) As %String
{
	s ^TempDHCRis("GetBookNo")=orditmrowid_"^"_LocDr_"^"_bookDate
	s rowid="",BookNo=""
	
	//暂时没有预约号生成规则
	//s rowid=$o(^DHCPACRegInfoCRi("LocCreateNo",0,LocDr,rowid))
	if (rowid'="") 
	{
		/*
		s Prefix=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",2)
		s Number=$p($g(^DHCPACRegInfoCR("CreateRule",0,rowid)),"^",4)
		if (Number="t")!(Number="T") 
		{
			
			s currentdate=$zd(+$h,8)
			
			if $g(^DHCRisStudyNoDate(LocDr,currentdate))=""  s ^DHCRisStudyNoDate(LocDr,currentdate)=0
			s Number=$g(^DHCRisStudyNoDate(LocDr,currentdate))
			s Number=Number+1
			
			s Prefix=Prefix_currentdate
			;判断是否已经使用，找到一个未使用的检查号
			
			s isFind="N"
			
			while(isFind'="Y")
			{
				s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
				s studyNoFind=Prefix_"-"_Number
				s detailDrFind=""
				s regInfoDrFind=""
				//s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",studyNoFind,detailDrFind))
				s regInfoDrFind=$o(^DHCPACRegInfoi("StudyNo",studyNoFind,regInfoDrFind))
				if (regInfoDrFind="")
				{
					s isFind="Y"
				}
				else
				{
					s Number=Number+1
				}
			}
			
		}
		else 
		{
			s Number=Number+1
			//这种需要更新表 暂时不可用这种方式
		}
		
		s StudyNo=Prefix_"-"_Number
		*/
	}
	else
	{
		//找默认的预约号 医嘱Rowid 
		s orderBodyList=$p(orditmrowid,"@",1)
		s orderItemRowid=$p(orderBodyList,"$",1)
		s orderRowid=$p(orderItemRowid,"||",1)
		s itemSub=$p(orderItemRowid,"||",2)
		s Prefix="B"_orderRowid
		s Number=1
		s isFind="N"
			
		while(isFind'="Y")
		{
			s Number=##class(web.DHCRisPatRegisterDoEx).Out3Number(Number)
			s BookNoFind=Prefix_"-"_Number
			
			s detailDrFind=""
			s detailDrFind=$o(^DHCRBCResSchduleDetaili("StudyNo",BookNoFind,detailDrFind))
			if (detailDrFind="")
			{
				s isFind="Y"
			}
			else
			{
				s Number=Number+1
			}
		}
		
		s BookNo=Prefix_"-"_Number
		
	}
   
	q BookNo
}

/// w ##class(web.DHCRisResourceApptSchudle).getExamTime("1294||37$2625,2622")
ClassMethod getExamTime(orderItemList As %String) As %String
{
	s AllTime=""
	for numOfOrder=1:1:$l(orderItemList,"@")
	{
		s orderBodyList=$p(orderItemList,"@",numOfOrder)
		s orderItemRowid=$p(orderBodyList,"$",1)
		s bodyList=$p(orderBodyList,"$",2)
		if (orderItemRowid'="")
		{
			s arcItemDr=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
			if (bodyList'="")
			{
				for i=1:1:$l(bodyList,",")
				{
					
					s bodyRowid=$p(bodyList,",",i)
					if (bodyRowid'="")
					{
						s bookParamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcItemDr,bodyRowid,""))
						if (bookParamRowid'="")
						{
							s itemTime=+$lg(^User.DHCRBCBookParamD(bookParamRowid),7)
							s AllTime=AllTime+itemTime
						}
					}
					
				}
			}
			else
			{
				s itemBookPropertyRowid=$o(DHCRBCItemBookProperTypei(arcItemDr,0))
				if (itemBookPropertyRowid'="")
				{
					s itemTime=+$p(^DHCRBCItemBookProperty(itemBookPropertyRowid),"^",9)
					s AllTime=AllTime+itemTime
				}
			}
		}
		
	}
	
	q AllTime
}

/// 函数 CancelBook
/// 功能：取消预约
/// w ##class(web.DHCRisResourceApptSchudle).CancelBook("")
ClassMethod CancelBook(OrderBodyList As %String, userRowid As %String = "", ipIn As %String = "", source As %String = "") As %String
{
	///修复bug
	s ^TempDHCRis("cancelBook") = OrderBodyList
	
	if ($g(userRowid)'="")
   	{
	   	s userName=$p($g(^SSU("SSUSR",userRowid)),"^",2)
	   	//2019/09/25修复Ens_Status、Ens_Statuslog表中“ES_OperatorID”字段值错误的问题
	   	s userId = $p($g(^SSU("SSUSR",userRowid)),"^",1)
   	}
   	
	s retCan=""
    for numOfCan=1:1:$l(OrderBodyList,"@")
    {
	    s orderBody=$p(OrderBodyList,"@",numOfCan)
	    s orderRowid=$p(orderBody,"$",1)
	    s bodyList=$p(orderBody,"$",2)
	    if (orderRowid'="")
	    {
		   	if (bodyList="")
		   	{
			   	//取消没有部位的
			   	s retCan=..CancelBookByOrderbody(orderRowid,"",userRowid,source)
			   	b //13
			   	///ris4.0调用取消预约方法不调用接口 wf 20191021
			   	if (source'="RIS4")
			   	{
			   		s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(orderRowid,"","","CBK",$g(userId),$g(userName))
	      			s ^TempDHCRis("postStatus",orderRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=""_"^"_"CBK"_"^"_$g(userId)_"^"_$g(userName)_"^"_$g(ret)
			   	}
			}
		   	else
		   	{
			   	s bodyDescList=""
			   	for i=1:1:$l(bodyList,",")
			   	{
				   	s bodyRowid=$p(bodyList,",",i)
				   	
				   	if (bodyRowid'="")
				   	{
					   	//按部位取消
					   	s retCan=..CancelBookByOrderbody(orderRowid,bodyRowid,userRowid,source)
					   	s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
			      		if bodyDescList= "" s bodyDescList=bodyDesc
			      		else  s bodyDescList=bodyDescList_"@@"_bodyDesc
				   	}
			   	}
			   	///ris4.0调用取消预约方法不调用接口 wf 20191021
			   	if (source'="RIS4")
			   	{
			   		s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(orderRowid,bodyDescList,"","CBK",$g(userId),$g(userName))
		  			s ^TempDHCRis("postStatus",orderRowid,bodyDescList,$zd(+$h,3),$zt($p($h,",",2),1))=""_"^"_"CBK"_"^"_$g(userId)_"^"_$g(userName)_"^"_$g(ret)
			   	}
		   	}
	    }
    }
    q retCan
}

/// 函数 CancelBook
/// 功能：取消预约
/// d ##class(web.DHCRisResourceApptSchudle).CancelBook("")
ClassMethod CancelBookByOrderbody(OrderItemRowid As %String, bodyRowid As %String, userRowid As %String = "", cancelSource As %String = "") As %String
{
 
	s $ZT="ERRORCancelBook"	
	
    s SQLCODE=200  
    
	s UpFlag="",RecLocdr="",IsSaveBookedIndex=""
	s (detailBodyRowid,DetailRowid)=""
	s (updateUseSeqNoList,updateOccupyTimeOfRelease)=""

	;增加按部位判断，是否预约
	if (bodyRowid'="")
	{
		s rowid=""
		for 
		{
			s rowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,rowid))
			q:(rowid="")
			q:(DetailRowid'="")
			s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",rowid,bodyRowid,0))
			if (detailBodyRowid'="")
			{
				;s detailBodyRowid=bodyRowid
				s DetailRowid=rowid
			}
		}
		
	}
	else
	{
		s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrderItemRowid,0))
	}
	
	;q:((bodyRowid'="")&(detailBodyRowid="")) SQLCODE
	;q:(DetailRowid="") SQLCODE
	//判断是不是外部预约
	if (DetailRowid="")
	{
		s extBookRowid=##class(web.DHCRisWorkBenchDoEx).HasExternalBK(OrderItemRowid,bodyRowid)
		if (extBookRowid'="")
		{
			s bookNoExt=$p(^DHCRBCExternalBookInfo(extBookRowid),"^",12)
			if (bookNoExt'="")
			{
				&sql(DELETE FROM DHCRBC_ExternalBookInfo WHERE DEB_RowID=:extBookRowid)
				///ris4.0调用取消预约方法不调用接口 wf 20191021
			   	if (cancelSource'="RIS4")
			   	{
					do ##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNoExt,OrderItemRowid,bodyRowid,"Y")
			   	}
			}
			
		}
		q SQLCODE
	}
	
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	q:ResSchduleID="" SQLCODE
	
	lock +(^DHCRisTMPReg)
	TSTART
	
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	s bookNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	
	s bookStartTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	s bookEndTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",19)
	
	
	
	
	s bookSeqNo=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",8) 
	s useSeqNoList=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",21) 
	if (bookSeqNo'="")
	{
		s updateUseSeqNoList=..deleteFromList(useSeqNoList,bookSeqNo)
	}
	
	;判断是否更新预约资源数量
	s UpFlag=..IsUpSchdule(bookNo)
	

	s RecLocdr=$p(^OEORD($p(OrderItemRowid,"||",1),"I",$p(OrderItemRowid,"||",2),3),"^",6)
	;i RecLocdr'="" s IsSaveBookedIndex=..GetSaveBKFlag(RecLocdr)
		
	
	s MaxNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",13)
    s startTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",5)
    s endTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",6)
    
    s OccupyTimeOfRelease=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",22)
    
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	if ( (bookStartTime'=startTime)||(bookEndTime'=endTime))
	{
		if (OccupyTimeOfRelease="")
		{
			s updateOccupyTimeOfRelease=bookStartTime_","_bookEndTime
		}
		else
		{
			s updateOccupyTimeOfRelease=OccupyTimeOfRelease_";"_bookStartTime_","_bookEndTime
		}
	}
	
	b //12
	
	//删除预约表
	if (bodyRowid'="")
	{

		&sql(delete from  DHCRBC_SchduleDetailBody WHERE SchduleDetailRowid=:DetailRowid and BodyRowid=:bodyRowid)
		s numOfBodyDetail=0
		&sql(select count(*) into :numOfBodyDetail from DHCRBC_SchduleDetailBody WHERE SchduleDetailRowid=:DetailRowid)

		if (numOfBodyDetail=0)
		{
			&sql(delete from DHCRBC_ResSchduleDetail WHERE DRPD_RowID=:DetailRowid)
		}
	}
	else
	{

		&sql(delete from DHCRBC_ResSchduleDetail WHERE DRPD_RowID=:DetailRowid)
	}
	

	//更新预约计划表
	if (AppointMethod="2")  d  //自动预约方式
    .i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    i UseNumber>0 s UseNumber=UseNumber-1
    s RemainNumber=MaxNumber-UseNumber	
    
    i UpFlag="Y" d
    .&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam)
                           values (:AutoUseNumber,:RemainNumber,:UseNumber,:updateUseSeqNoList,:updateOccupyTimeOfRelease) where  DRPS_RowID=:ResSchduleID)
	
	b //11
	I SQLCODE d
	.TRollback
	.lock -(^DHCRisTMPReg)
	I SQLCODE q SQLCODE
	
    TCOMMIT
    lock -(^DHCRisTMPReg)
    ;发送取消预约消息到RIS4系统   
    //do ##class(web.DHCRisSendToRis4Set).SendCanelBookedtoRIS4(OrderItemRowid)
    /*	
    //定位1 
    if ($g(userRowid)'="")
   	{
	   	s userName=$p($g(^SSU("SSUSR",userRowid)),"^",2)
   	}
   	
   	
   	s ^TempDHCRis("postStatus",OrderItemRowid,"in",$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"CBK"_"^"_$g(userRowid)_"^"_$g(userName)_"^"_$g(bodyRowid)
	
	s bodyDesc=""
	if (bodyRowid'="")
	{
		s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",2)
	}
		      
	s ret=##Class(RISService.EnsInterface.StatusReport.Interface).PostStatus(OrderItemRowid,bodyDesc,"","CBK",$g(userRowid),$g(userName))
	
	if (bodyDesc'="")
	{
		s ^TempDHCRis("postStatus",OrderItemRowid,bodyDesc,$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"CBK"_"^"_$g(userRowid)_"^"_$g(userName)_"^"_$g(ret)
	}
	else
	{
		s ^TempDHCRis("postStatus",OrderItemRowid,"nobody",$zd(+$h,3),$zt($p($h,",",2),1))=bookNo_"^"_"CBK"_"^"_$g(userRowid)_"^"_$g(userName)_"^"_$g(ret)
	}	      
	*///定位   
	
	///ris4.0调用取消预约方法不调用接口 wf 20191021
	if (cancelSource'="RIS4")
	{ 
    	do ##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartPACS(bookNo,OrderItemRowid,bodyRowid,"Y")
	}
	
    q SQLCODE

ERRORCancelBook
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	b //01
	lock -(^DHCRisTMPReg)
 	TROLLBACK
 	
 	q SQLCODE
}

ClassMethod deleteFromList(group As %String, itemIn As %String) As %String
{
	s ret=""
	s lenOfGroup=$l(group,",")
	for k=1:1:lenOfGroup
	{
		s item=$p(group,",",k)
		if ( item'="")
		{
			if ( item=itemIn)
			{
				continue
			}
			else
			{
				if ( ret="")
				{
					s ret=item
				}
				else
				{
					s ret=ret_","_item
				}
			}
		}
	}
	q ret
}

/// w ##class(web.DHCRisResourceApptSchudle).GetBookedPrintData("62||10@62||9")
/// 函数:GetBookedPrintData
/// wf 获取预约打印信息 20160813
ClassMethod GetBookedPrintData(orderbodyList As %String) As %String
{

	s ^TempDHCRisWf("GetBookedPrintData")=orderbodyList
    q:(orderbodyList="") ""
    s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,LocId,LocDesc,ResDetailRowid)=""
    s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid)=""
    s (MemoTMRowid,RecLocdr,RecLocDesc,UserID,UserCode,UserDesc,Memo,indexbook,strDate,strTime,EQAddress)=""
    s Info=""
    
    //获取预约明细表rowid
    s ResDetailRowid=..getBookDetailID(orderbodyList)
    //b 
    q:(ResDetailRowid="") Info
    
    
    /*
    //根据医嘱项和部位获取memo
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
    */
    
    
    s orderBody=$p(orderbodyList,"@",1)
    s OrditemRowid=$p(orderBody,"$",1)
    s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
    s Pasmatdr=$p(^PAADM(paadmdr),"^",1)
    s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)


    s RecLocdr=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
    if RecLocdr'="" d
    .s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
    .i $f(RecLocDesc,"-")>0 d
    ..s RecLocDesc=$p(RecLocDesc,"-",2)
    s Date1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",9)  ;医嘱日期 OEORI_Date
    ;w !,"Date1="_Date1
    s strDate=$zd(Date1,3)
    s Time1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",17) ;医嘱的开始时间
    s strTime=$zt(Time1,1)
    ;s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
    i (ResDetailRowid'="")
    {  
       s UserID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",15)
       i UserID'="" d
       .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
       .s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
       s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
       ;s BookNumber=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",9)
       i ResSchduleID'="" d
       .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       .s ResourceDesc="",ResourceCode=""
       .i ResouceId'="" d
       ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
       ..i EqId'="" d
       ...s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       ...s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
       ...s EQAddress=##class(web.DHCRisResourceApptSchudle).GetEQAddress(EqId)
       ..i CareProvId'="" d
       ...s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
       ...s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
       ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
       ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
       .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       .i Date'="" s BookedDate=$zd(Date,3)
       .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       .i StartTime'="" s BooketTime=$zt(StartTime)
       .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
       .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
       .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
       .s indexbook=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",10)
       .;i $g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))'=""  s indexbook=$g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))
       .i indexbook=$c(0) s indexbook=""
       .i (indexbook'="")&&(StartTime>43200)  s indexbook="下午"_indexbook_"号"
       .i (indexbook'="")&&(StartTime<43200)  s indexbook="上午"_indexbook_"号"
       .s Info="" 
       .s Info=ResSchduleID_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_BooketTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_$g(Memo)_"^"_indexbook_"^"_strDate_"^"_strTime_"^"_EQAddress
       
    }
    
    q $g(Info)
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookDetailID("")
ClassMethod getBookDetailID(orderList1 As %String) As %String
{
	s detialRowid=""
	q:(orderList1="") hasBook
	for orderNumber=1:1:$l(orderList1,"@")
	{
		q:(detialRowid'="")
		s orderBody=$p(orderList1,"@",orderNumber)
		s orderDr=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)
		if (orderDr="")
		{
			continue
		}
		s ResDetailRowid1=""
		for 
		{
			s ResDetailRowid1=$o(^DHCRBCResSchduleDetaili(0,orderDr,ResDetailRowid1)) 
			q:(ResDetailRowid1="")
			
		   if (bodyList'="")
		   {
			   for i=1:1:$l(bodyList,",")
			   {
				   s bodyRowid=$p(bodyList,",",i)
				   if (bodyRowid'="")
				   {
					   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid1,bodyRowid,0))
					   if (detailBodyRowid'="")
					   {
						   s detialRowid=ResDetailRowid1
					   }
				   }
			   }
		   }
		   else
		   {
		   		s detialRowid=ResDetailRowid1
		   }
			
		}
	}

    q detialRowid
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookDetailInfo("")
ClassMethod getBookDetailInfo(orderRowid As %String, bodyDr As %String) As %String
{
	s info=""
	
	q:(orderRowid="") info
	s detialRowid=""
	s ResDetailRowid1=""
	for 
	{
	   s ResDetailRowid1=$o(^DHCRBCResSchduleDetaili(0,orderRowid,ResDetailRowid1)) 
	   q:(ResDetailRowid1="")
		
	   if (bodyDr'="")
	   {	  
		   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid1,bodyDr,0))
		   if (detailBodyRowid'="")
		   {
			   s detialRowid=ResDetailRowid1
		   }  
	   }
	   else
	   {
	   		s detialRowid=ResDetailRowid1
	   }
		
	}
	
	if (detialRowid'="")
	{
		s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",detialRowid),"^",2)
       i (ResSchduleID'="")
       {
       		s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       		s ResourceDesc="",ResourceCode=""
       		i ResouceId'="" d
       		.s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       		.s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
       		.i EqId'="" d
       		..s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       		..s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
       		.i CareProvId'="" d
       		..s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
       		..s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
       
       		s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       		i Date'="" s BookedDate=##class(web.DHCRisCommFunction).changeDateToString(Date)  ;$zd(Date,3)
       		s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       		i StartTime'="" s BooketTime=$zt(StartTime)
       		s info=ResSchduleID_"^"_ResourceDesc_"^"_BookedDate_"^"_BooketTime
       }
	}

    q info
}

/// w ##class(web.DHCRisResourceApptSchudle).getBookDetailInfoFromlist("")
ClassMethod getBookDetailInfoFromlist(orderbodyList As %String) As %String
{
	s ^TempDHCRis("getBookDetailInfoFromlist")=orderbodyList
	s info=""
	
	q:(orderbodyList="") info
	s detialRowid=..getBookDetailID(orderbodyList)
	
	
	if (detialRowid'="")
	{
		s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",detialRowid),"^",2)
       i (ResSchduleID'="")
       {
       		s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       		s ResourceDesc="",ResourceCode=""
       		i ResouceId'="" d
       		.s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       		.s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
       		.i EqId'="" d
       		..s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       		..s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
       		.i CareProvId'="" d
       		..s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
       		..s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
       
       		s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       		i Date'="" s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)   ;$zd(Date,3)
       		s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       		i StartTime'="" s BooketTime=$zt(StartTime)
       		s info=ResSchduleID_"^"_ResourceDesc_"^"_BookedDate_"^"_BooketTime
       }
	}

    q info
}

/// w ##class(web.DHCRisResourceApptSchudle).GetMemo("")
/// 获取注意事项  入参为医嘱部位串   医嘱$部位,部位@医嘱
ClassMethod GetMemo(orderList1 As %String) As %String
{
	s ^TempDHCRisWF("GetMemo")=orderList1
	s Memo=""
	k memoRowidList
	
	q:(orderList1="") Memo
	for orderNumber=1:1:$l(orderList1,"@")
	{
		;b //02
		s orderBody=$p(orderList1,"@",orderNumber)
		s orderDr=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)
		if (orderDr="")
		{
			continue
		}
		s arcimid=$p($g(^OEORD($p(orderDr,"||",1),"I",$p(orderDr,"||",2),1)),"^",2)
	   if (bodyList'="")
	   {
		   s isBodyMemo="N"
		   for i=1:1:$l(bodyList,",")
		   {
			   s bodyRowid=$p(bodyList,",",i)
			   if (bodyRowid="")
			   {
				   continue
			   }
			   s memoRowid=$o(^DHCRBAppi("Memo-ItmBody",arcimid,bodyRowid,0))
			   if (memoRowid'="")
			   {
				   s memoTmplRowid=$p(^DHCRBApp("Memo",memoRowid),"^",4)
				   if (memoTmplRowid'="")
				   {
					   s isBodyMemo="Y"
					   s memoRowidList(memoTmplRowid)=$g(memoRowidList(memoTmplRowid))_"@"_arcimid
				   }
			   }
		   }
		   ;b 
		   if (isBodyMemo="N")
		   {
			   s memoRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
			   b //01
			   if (memoRowid'="")
			   {
				   s memoTmplRowid=$p(^DHCRBApp("Memo",memoRowid),"^",4)
				   if (memoTmplRowid'="")
				   {
					   s memoRowidList(memoTmplRowid)=$g(memoRowidList(memoTmplRowid))_"@"_arcimid
				   }
			   } 
		   }
	   }
	   else
	   {
		   ;b //03
	   		s memoRowid=$o(^DHCRBAppi("Memo-ItMast",arcimid,0))
		   if (memoRowid'="")
		   {
			   s memoTmplRowid=$p(^DHCRBApp("Memo",memoRowid),"^",4)
			   if (memoTmplRowid'="")
			   {
				   s memoRowidList(memoTmplRowid)=$g(memoRowidList(memoTmplRowid))_"@"_arcimid
			   }
		   } 
	   }
		
	}
	;b //04
	;s numCompare=0
	s rowid=""
	for 
	{
		s rowid=$o(memoRowidList(rowid))
		q:(rowid="")
		s memoDesc=$p($g(^DHCRBCApp("Memo-Template",rowid)),"^",3)
		;s memoCode=$p($g(^DHCRBCApp("Memo-Template",rowid)),"^",1)
		;s codeNum=$e(memoCode,$l(memoCode)-1,$l(memoCode))
		;b //05
		;if (codeNum>numCompare)
		;{
		if Memo=""
		{
			s Memo=memoDesc
		}
		else
		{
			s Memo=Memo_$c(13,10)_memoDesc
		}
		;	s numCompare=codeNum
		;}
	}
    q Memo
}

/// 根据设备的id获取设备的物理地址
/// 潘
/// w ##class(web.DHCRisResourceApptSchudle).GetEQAddress("")
ClassMethod GetEQAddress(EQID As %String) As %String
{
	q:(EQID="") ""
	s DEARowID=""
	s DEARowID=$o(^DHCRBCEquipmentAddressi(EQID,DEARowID))
	if (DEARowID'="")
	{
		s Address=$p(^DHCRBCEquipmentAddress(DEARowID),"^",2)
	}
	q $g(Address)
}

/// 取东软住院病人信息
/// w ##class(web.DHCRisResourceApptSchudle).getHisPatInfoSY("0001618143")
ClassMethod getHisPatInfoSY(inPatNo As %String) As %String
{
	q:(inPatNo="") ""
	s patName=""
	
	s sqlStr="SELECT * FROM SYHIS.FIN_IPR_INMAININFO WHERE PATIENTNO='"_inPatNo_"'"	       
	  s result=##class(%Library.ResultSet).%New()
	  d result.Prepare(sqlStr)
	  d result.Execute()
	
	  s count=0
  
	  While(result.Next()){  
		s patName = result.Data("NAME")
	   }

	  d result.Close()
	  
	  //&sql(SELECT Name into :patName FROM SYHIS.FIN_IPR_INMAININFO WHERE PATIENTNO=:inPatNo)
	  q patName
}

/// w ##class(web.DHCRisResourceApptSchudle).GetBookedPrintByloc("1689||3@1689||2")
/// 函数:GetBookedPrintData
/// wf 获取预约打印信息 20160813
ClassMethod GetBookedPrintByloc(orderbodyList As %String) As %String
{

	s ^TempDHCRisWf("GetBookedPrintData")=orderbodyList
    q:(orderbodyList="") ""
    s (OrderRowid,ItemRowid,ArcItemId,paadmdr,papatmasmdr,RegNo,LocId,LocDesc,ResDetailRowid)=""
    s (ResSchduleID,Date,BookedDate,StartTime,BooketTime,EqAdress,RoomRowid)=""
    s (MemoTMRowid,RecLocdr,RecLocDesc,UserID,UserCode,UserDesc,Memo,indexbook,strDate,strTime,EQAddress)=""
    s Info=""
    s ordName=""
    //获取预约明细表rowid
    s ResDetailRowid=..getBookDetailID(orderbodyList)
    //b 
    q:(ResDetailRowid="") Info
    
    
    /*
    //根据医嘱项和部位获取memo
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
    */
    
    
    s orderBody=$p(orderbodyList,"@",1)
    s OrditemRowid=$p(orderBody,"$",1)
    s BodyIDList=$p(orderBody,"$",2)
    s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    s paadmdr=$p(^OEORD(OrderRowid),"^",1) 
	
    s PaadmInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(paadmdr)
	
	s ordName1=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(orderbodyList)
	s ordName=$EXTRACT(ordName1,1,10)_$c(13,10)_$e(ordName1,11,30)
	;s ordName=$e(ordName1,11,20)
	//b 
	i PaadmInfo'="" d
	.s GetRegNo=$p(PaadmInfo,"^",1)
	.s GetMedicareNo=$p(PaadmInfo,"^",33)
	.s GetName=$p(PaadmInfo,"^",2)
	.s GetSex=$p(PaadmInfo,"^",5)
	.s GetAge=$p(PaadmInfo,"^",4)
	.s Getbedno=$p(PaadmInfo,"^",11)
	.s Getwardname=$p(PaadmInfo,"^",10)
	.s arcimid=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",2)
	.s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
	.s GetMemo=##class(web.DHCRisResourceApptSchudle).GetMemo(orderbodyList)
    .i arcimid'="" s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
    .s GetAppDoc=$p(PaadmInfo,"^",18)
    .;s GetAppLoc=$p(PaadmInfo,"^",39)
    .i AppLocDR'="" d
    ..s GetAppLoc=$p(^CTLOC(AppLocDR),"^",2)
    ..i $f(GetAppLoc,"-")>0 d
    ...s GetAppLoc=$p(GetAppLoc,"-",2)
    .e  d
    ..s GetAppLoc=$p(PaadmInfo,"^",39)
    .s CardNo=$p(PaadmInfo,"^",35)
    .s Info1=GetRegNo_"^"_GetMedicareNo_"^"_GetName_"^"_GetSex_"^"_GetAge_"^"_Getbedno
    .s Info2=Info1_"^"_Getwardname_"^"_strOrderName_"^"_GetAppDoc_"^"_GetAppLoc
    .s Info3=Info2_"^"_GetMemo   //_"^"_PatientNow_"^"_purpose_"^"_MainDiagose
    
    s Pasmatdr=$p(^PAADM(paadmdr),"^",1)
    s ArcItemId=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)


    s RecLocdr=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
    if RecLocdr'="" d
    .s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
    .i $f(RecLocDesc,"-")>0 d
    ..s RecLocDesc=$p(RecLocDesc,"-",2)
    s Date1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",9)  ;医嘱日期 OEORI_Date
    ;w !,"Date1="_Date1
    s strDate= ##class(websys.Conversions).DateLogicalToHtml(Date1) ;$zd(Date1,3)
    s Time1=$p(^OEORD(OrderRowid,"I",ItemRowid,1),"^",17) ;医嘱的开始时间
    s strTime=$zt(Time1,1)
    ;s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
    i (ResDetailRowid'="")
    {  
       s UserID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",15)
       i UserID'="" d
       .s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
       .s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
       s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
       ;s BookNumber=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",9)
       i ResSchduleID'="" d
       .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
       .s ResourceDesc="",ResourceCode=""
       .i ResouceId'="" d
       ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
       ..i EqId'="" d
       ...s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
       ...s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
       ...s EQAddress=##class(web.DHCRisResourceApptSchudle).GetEQAddress(EqId)
       ..i CareProvId'="" d
       ...s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
       ...s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
       ..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
       ..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)
       .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       .i Date'="" s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)  ;$zd(Date,3)
       .s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       .i StartTime'="" s BooketTime=$zt(StartTime,2)
       .s EndTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
       .i EndTime'="" s BookEndTime=$zt(EndTime,2)
       .s LocId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",11)
       .s LocDesc="" i LocId'="" s LocDesc=$p(^CTLOC(LocId),"^",2) 
       .s LocAddress="" i LocId'="" s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
       .s bookDetailSTime=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",18)
       .s bookDetailETime=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",19)
       .i bookDetailSTime'="" s BooketTime=$zt(bookDetailSTime,2)
       .i bookDetailETime'="" s BookEndTime=$zt(bookDetailETime,2)
       .s indexbook=$p($g(^DHCRBCResSchduleDetail("Detail",ResDetailRowid)),"^",8)
       .i indexbook'=""  s indexbook=indexbook_"号"
       .;w !,ResDetailRowid_"^"_indexbook
       .;i $g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))'=""  s indexbook=$g(^DHCRisBookIndex(Pasmatdr,RoomRowid,BookedDate,StartTime))
       .;i (indexbook'="")&&(StartTime>43200)  s indexbook="下午"_indexbook_"号"
       .;i (indexbook'="")&&(StartTime<43200)  s indexbook="上午"_indexbook_"号"
       .s Info="" 
       .s Info=ResSchduleID_"^"_$g(ResourceCode)_"^"_$g(ResourceDesc)_"^"_BookedDate_"^"_BooketTime_"^"_BookEndTime_"^"_RecLocDesc_"^"_UserCode_"^"_UserDesc_"^"_indexbook_"^"_strDate_"^"_strTime_"^"_EQAddress_"^"_Info3_"^"_ordName_"^"_CardNo
       
    }
    
    q $g(Info)
}

/// 获取小条打印格式
/// input:医嘱名称+部位ID
/// w ##Class(web.DHCRisResourceApptSchudle).GetSmartPrint("1535||16$2623")
ClassMethod GetSmartPrint(orderbodyList As %String) As %String
{
	/*s ordName=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(orderbodyList)
	s strOrderName=$EXTRACT(ordName,1,20)_$c(13,10)_" "_$e(ordName,21,$l(ordName))
	s Memo=##class(web.DHCRisResourceApptSchudle).GetMemo(orderbodyList)
	s Memo=..replaceString(Memo,$c(13),"")
	s Memo=..replaceString(Memo,$c(10),"")
	//w !,Memo
	s num=$fn($l(Memo)/20,"",0)
	;w !,"num="_num
	if num=0 
	{
		s GetMemo=Memo
	}
	else
	{
		s GetMemo=$e(Memo,1,20)
		for i=1:1:num
		{
			//s GetMemo=$EXTRACT(Memo,1,20)_$c(13,10)_$e(Memo,21,41)_$c(13,10)_$e(Memo,42,62)_$c(13,10)_$e(Memo,63,83)
			//w !,i_"**"_num
			if (i=num)
			{
				s GetMemo=GetMemo_$c(13,10)_$e(Memo,i*20+1,$l(Memo))
			}
			else
			{  
				s GetMemo=GetMemo_$c(13,10)_$e(Memo,i*20+1,(i+1)*20)
			}
		}
	}
	//w !,GetMemo
	s Info=strOrderName_"^"_GetMemo
	q Info
	*/
	s ordName=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(orderbodyList)
	s strOrderName=$EXTRACT(ordName,1,20)_$c(13,10)_" "_$e(ordName,21,$l(ordName))
	s Memo=##class(web.DHCRisResourceApptSchudle).GetMemo(orderbodyList)
	
	
	/*s Memo=..replaceString(Memo,$c(13),"")
	
	s Memo=..replaceString(Memo,$c(10),"")

	s num=$fn($l(Memo)/50,"",0)
	
	if num=0 
	{
		s GetMemo=Memo
	}
	else
	{
		s GetMemo=$e(Memo,1,50)
	
		for i=1:1:num
		{
			
			if (i=num)
			{
				
				s GetMemo=GetMemo_$c(13,10)_"          "_$e($g(Memo),i*50+1,$l(Memo))
			}
			else
			{
			     
				s GetMemo=GetMemo_$c(13,10)_"          "_$e($g(Memo),i*50+1,(i+1)*50)
				;w !,"GetMemo="_GetMemo
				
			}
		}
	}
	*/
	;w !,GetMemo
	s Info=ordName_"^"_Memo
	q Info
}

/// 获取A5打印格式
/// input:医嘱名称+部位ID
/// w ##Class(web.DHCRisResourceApptSchudle).GetBigPrint("1535||16$2623")
ClassMethod GetBigPrint(orderbodyList As %String) As %String
{
	s ordName=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(orderbodyList)
	s strOrderName=$EXTRACT(ordName,1,20)_$c(13,10)_" "_$e(ordName,21,$l(ordName))
	s Memo=##class(web.DHCRisResourceApptSchudle).GetMemo(orderbodyList)
	/*s Memo=..replaceString(Memo,$c(13),"")
	
	s Memo=..replaceString(Memo,$c(10),"")

	s num=$fn($l(Memo)/50,"",0)
	
	if num=0 
	{
		s GetMemo=Memo
	}
	else
	{
		s GetMemo=$e(Memo,1,50)
	
		for i=1:1:num
		{
			
			if (i=num)
			{
				
				s GetMemo=GetMemo_$c(13,10)_"          "_$e($g(Memo),i*50+1,$l(Memo))
			}
			else
			{
			     
				s GetMemo=GetMemo_$c(13,10)_"          "_$e($g(Memo),i*50+1,(i+1)*50)
				;w !,"GetMemo="_GetMemo
				
			}
		}
	}
	*/
	;w !,GetMemo
	;s Info=ordName_"^"_GetMemo
	s Info=ordName_"^"_Memo
	q Info
}

ClassMethod replaceString(Str, OldStr, NewStr)
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

/// w ##class(web.DHCRisResourceApptSchudle).isBookFromDoc("")
/// 是否可以诊间预约
/// w ##class(web.DHCRisResourceApptSchudle).isBookFromDoc("")
/// 是否可以诊间预约
ClassMethod isBookFromDoc(orderBodyListIn As %String) As %String
{
	//w ##class(web.DHCRisCommFunctionEx).GetServiceGroup("4488||1","2405")
	s ^TempDHCRisWf("isBookFromDoc")=orderBodyListIn
	s isBook="Y"
	q:(orderBodyListIn="") isBook
	s getLastRowid=""
	for lenOfList=1:1:$l(orderBodyListIn,"@")
	{
		q:(isBook="N")
		s orderBodyList=$p(orderBodyListIn,"@",lenOfList)
		if (orderBodyList'="")
		{
			
			s orderRowid=$p(orderBodyList,"$",1)
			s arcimid=$p($g(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1)),"^",2)
			s recLocDr=$p($g(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),3)),"^",6)
			
			//394 普放
			s bodyList=$p(orderBodyList,"$",2)
			if (bodyList'="")   //有部位
			{
				for lenOfBody=1:1:$l(bodyList,",")
				{
					q:(isBook="N")
					s bodyRowid=$p(bodyList,",",lenOfBody)
					if (bodyRowid'="")
					{
						s appointMethodInfo=##class(web.DHCRisCommFunctionEx).GetBookParam(arcimid,bodyRowid)
						if ( $p(appointMethodInfo,"^",1)'=3)
						{
							s isBook="N"
						}
						if (recLocDr="394") 
						{
							s lastRowid=$p($g(^DHCAPPART(bodyRowid)),"^",3)
							if (getLastRowid="")
							{
								s getLastRowid=lastRowid
							}
							else
							{
								if (getLastRowid'=lastRowid)
								{
									s isBook="N"   //DR属于不同部位，不能诊间预约
								}
							}
						}
						elseif(recLocDr="388")
						{
							if ( $p(appointMethodInfo,"^",1)'=3)
							{
								s isBook="N"
							}
						}
						else
						{
							s serviceList=##class(web.DHCRisCommFunctionEx).GetServiceGroup(arcimid,bodyRowid)
						
							s serviceGroupDesc=$p(serviceList,"^",2)
							
							if (serviceGroupDesc["增强")
							{
								s isBook="N"   //包含增强检查，不允许诊间预约
							}
						}
						
					}
				}
			}
			else    //没有部位暂不处理
			{
				s appointMethodInfo=##class(web.DHCRisCommFunctionEx).GetBookParam(arcimid,"")
				if ( $p(appointMethodInfo,"^",1)'=3)
				{
					s isBook="N"
				}
			}	
		}
	}
	
	q isBook
}

/// w ##class(web.DHCRisResourceApptSchudle).GetBookInfoInpatient("")
/// 获取住院病人预约数据
ClassMethod GetBookInfoInpatient(patientID As %String, ResSchduleID As %String) As %String
{
	s ^TempDHCRisWf("GetBookInfoInpatient")=patientID_"^"_ResSchduleID
	s ret=""
	q:((patientID="")||(ResSchduleID="")) ret
	s bookinfoExternalId=$o(^DHCRBCBookInfoExternali("ResSchedule",ResSchduleID,patientID,0))
	q:(bookinfoExternalId="") ret
	
	s (bookDate,bookStime,bookEtime,bookNum,patName)=""
	
	s bookDate=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",6)
	if bookDate'="" s bookDate=$zd(bookDate,3)
	s bookStime=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",7)
	if bookStime'="" s bookStime=$zt(bookStime,2)
	s bookEtime=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",8)
	if bookEtime'="" s bookEtime=$zt(bookEtime,2)
	s bookNum=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",9)
	i bookNum'="" s bookNum=bookNum_"号"
	s patName=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",5)
	
	s (ResourceDesc,ResourceCode,ResouceId,EQAddress)=""
	s ResouceId=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",2)
    i ResouceId'=""
    {
	    s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	    //s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	    if (EqId'="")
	    {
		    s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
		    s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
		    s EQAddress=##class(web.DHCRisResourceApptSchudle).GetEQAddress(EqId)
	    }
	    /*
	    else
	    {
		    i (CareProvId'="")
		    {
				s ResourceDesc=$p($g(^CTPCP(CareProvId,1)),"^",2)
				s ResourceCode=$p($g(^CTPCP(CareProvId,1)),"^",1)
		    }
	    }*/
    }
       
    //..i EqId'="" s RoomRowid=$o(^DHCRBC("EQDR-ROOM",EqId,0))
    //..i RoomRowid'="" s EqAdress=$p($g(^DHCRBC("Room",RoomRowid)),"^",2)

    s (LocDesc,LocId,LocAddress)=""
    s LocId=$p(^DHCRBCBookInfoExternal(bookinfoExternalId),"^",10)
    i (LocId'="")
    {
		s LocDesc=$p(^CTLOC(LocId),"^",2) 
        s LocAddress=$g(^CTLOC(LocId,"ADDR",1))
    }
       
   	s ret=patientID_"^"_patName_"^"_bookDate_"^"_bookStime_"^"_bookEtime_"^"_bookNum_"^"_ResourceDesc_"^"_EQAddress_"^"_LocDesc_"^"_LocAddress
       
    q ret
}

// 住院病人预约占位时，是否需要输入检查时间(核磁需要检查时间)

ClassMethod isNeedOrderTime(resSchduleId As %String) As %String
{
	s ret="N"
	q:(resSchduleId="") ret
	s locId=$p(^DHCRBCResourceSchdule(resSchduleId),"^",11)
	if ((locId="388")||(locId="389"))
	{
		s ret="Y"
	}
	q ret
}

/// w ##class(web.DHCRisResourceApptSchudle).GetMemo("")
/// 获取注意事项  入参为医嘱部位串   医嘱$部位,部位@医嘱
ClassMethod GetAppBillMemo(orderList1 As %String) As %String
{
	s ^TempDHCRisWF("GetAppBillMemo")=orderList1
	s Memo=""
	k memoRowidList
	
	
	q:(orderList1="") Memo
	for orderNumber=1:1:$l(orderList1,"@")
	{
		s orderBody=$p(orderList1,"@",orderNumber)
		s orderDr=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)
		if (orderDr="")
		{
			continue
		}
		s recLocRowid=$p(^OEORD($p(orderDr,"||",1),"I",$p(orderDr,"||",2),3),"^",6)
		s hospitalRowid=$p(^CTLOC(recLocRowid),"^",22)
		s arcimid=$p($g(^OEORD($p(orderDr,"||",1),"I",$p(orderDr,"||",2),1)),"^",2)
		s ArcNoID=""
		F  s ArcNoID=$o(^DHCAPARCNO(0,"ARC",arcimid,ArcNoID)) Q:ArcNoID=""  D
		.s ItemTempID=$p(^DHCAPARCNO(ArcNoID),"^",2)         /// 注意事项ID
		.s ItemTemp=$p(^DHCAPITMTE(ItemTempID),"^",2)        /// 注意事项
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",3)'="Y"            /// 不可用退出
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",4)'=hospitalRowid  /// 登录医院判断
		.;s CH=""
		.;F  s CH=$o(^DHCAPITMTE(ItemTempID,"D",CH)) Q:CH=""  D
		.;.s TempText=$p(^DHCAPITMTE(ItemTempID,"D",CH),"^",1)
		.s CH=$o(^DHCAPITMTE(ItemTempID,"D",""))
		.q:(CH="")
		.s memoText=$p($g(^DHCAPITMTE(ItemTempID,"D",CH)),"^",1)
		.i Memo="" d
		..s Memo=memoText
		.e  d
		..s Memo=Memo_"<br>"_memoText
	}
	
	;s Memo=..Replace(Memo,"<br>","\r\n")
	
    q Memo
}

Storage Default
{
<Data name="DHCRisResourceApptSchudleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCRisResourceApptSchudleD</DataLocation>
<DefaultData>DHCRisResourceApptSchudleDefaultData</DefaultData>
<IdLocation>^web.DHCRisResourceApptSchudleD</IdLocation>
<IndexLocation>^web.DHCRisResourceApptSchudleI</IndexLocation>
<StreamLocation>^web.DHCRisResourceApptSchudleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
