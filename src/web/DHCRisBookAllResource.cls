Import SQLUser

Class web.DHCRisBookAllResource Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// // d ##class(%ResultSet).RunQuery("web.DHCRisBookAllResource","QuerySchduleDetail","94||4","2016-07-07","402")
Query QuerySchduleDetail(orderList As %String, StartDate As %String, locRowid As %String, resourceIdIn As %String = "") As %Query(ROWSPEC = "SchRowid:%String,TimeDesc:%String,BookedDate:%String,StartTime:%String,ResourceDesc:%String,ReUnLockBKNumber:%String,ResID:%String,View:%String,MaxNumber:%String,TimeFlag:%String,nextBookTime:%String,remailTime:%String,docName:%String,docRowid:%String")
{
}

ClassMethod QuerySchduleDetailExecute(ByRef qHandle As %Binary, orderList As %String, StartDate As %String, locRowid As %String, resourceIdIn As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    
    s ^DHCRisTemp("QuerySchduleDetail-allres")=orderList_"^"_StartDate_"^"_locRowid_"^"_resourceIdIn
    k DataBookFind
    k DataBookFindViewN
    ;s DataBookFind=""
    if (StartDate="" || orderList="")
    {
	    s qHandle=$lb(0,repid,0)
	    Quit $$$OK
    }
    s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)  ;$zdh(StartDate,"3")
	s PatType=""
	s itemGroupRowidList=""
	if ( orderList'="")
	{
		;获取检查组信息
		s itemGroupRowidList=..getItemGroupRowidList(orderList)
		s oeorditemdr=$p(orderList,"@",1)
		s oeorditemdr=$p(oeorditemdr,"$",1)
	    s OrderRowid=$p(oeorditemdr,"||",1)
	    s ItemRowid=$p(oeorditemdr,"||",2)
    
	    s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	    i paadmdr'="" s PatType=$p($g(^PAADM(paadmdr)),"^",2) 
	    s ServiceGroupId=""
    
	    s ArcItemDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",2)
	    if (ArcItemDR="")
	    {
		    s qHandle=$lb(0,repid,0)
	    	Quit $$$OK
	    }
   
	    ;s ServiceGroupId=##class(web.DHCRisCommFunctionEx).GetServiceGroup(ArcItemDR)
	   
	    ;i ServiceGroupId'="" s ServiceGroupId=$p(ServiceGroupId,"^",1)
		s ServiceGroupId=##class(web.DHCRisCommFunctionEx).GetSameServiceGroup(orderList)

	    i ServiceGroupId="" 
	    {
		    s qHandle=$lb(0,repid,0)
	   		Quit $$$OK
	    }
        ;w !,"ServiceGroupId="_ServiceGroupId
	    s RecLocdr=""
	    s locDrList=""
	    if (oeorditemdr'="") 
	    {
	        s RecLocdr=$p($g(^OEORD($p(oeorditemdr,"||",1),"I",$p(oeorditemdr,"||",2),3)),"^",6)
	       /* s LocList=##Class(web.DHCDocOrderCommon).GetArcimReclocStr(oeorditemdr,RecLocdr)
	        //注释20160707
	        
		    for LocNumber=1:1:$l(LocList,$c(2))
		    {
		        s locInfoList=$p(LocList,$c(2),LocNumber)
		        if (locInfoList'="")
		        {
			        s locDesc=$p(locInfoList,$c(1),2)
			        s locDrList=locDrList_"@"_$p(locInfoList,$c(1),1)
			        ;w !,locDrList
		        }
		    }*/
		    if (locDrList="")
		    {
			    s locDrList=RecLocdr
		    }
	    }
    

	    s SGCount=0
	    s SGCount=$l(ServiceGroupId,"^")

	    for i=1:1:SGCount
	    {
		    
	        s perServcieGroupId=""
	        s perServcieGroupId=$p(ServiceGroupId,"^",i)
	        ;w !,"perServcieGroupId="_perServcieGroupId
	        s RessourceID="" f  s RessourceID=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID)) q:(RessourceID="")  d
	        .;w !,"RessourceID="_RessourceID
	        .s locIdRes=$p($g(^RB("RES",RessourceID)),"^",1)
	        .q:(locIdRes="")
	        .q:((RecLocdr'="")&&(locIdRes'=RecLocdr))
	        .s IsAppRes=""
	        .i orderList'="" s IsAppRes=##class(web.DHCRisResApptSchudleSystem).IsUseResbyAppLoc(orderList,RessourceID)
	        .;w !,orderList_"**"_RessourceID_"**"_IsAppRes
	    	.q:(IsAppRes="N") ;按申请科室使用设备过滤
	        .;q:(locDrList'[locIdRes)
	        .;f date=StartDate:1:(StartDate+3) d:
	        .;.s stTime=0 f  s stTime=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,date,stTime)) q:stTime=""  d
	        .;..s SchRowid="" f  s SchRowid=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,date,stTime,SchRowid)) q:(SchRowid="")  d
	        .;...d ResSchduleDetail
	        .s stTime=0 f  s stTime=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,StartDate,stTime)) q:stTime=""  d
	        ..s SchRowid="" f  s SchRowid=$o(^DHCRBCResSchdulei("ServiceGroup-Res",perServcieGroupId,RessourceID,StartDate,stTime,SchRowid)) q:(SchRowid="")  d
	        ...d ResSchduleDetail
	    }
	}
	elseif (locRowid'="")
	{
		s locList=..getLocList(locRowid)
		for numOfLoc=1:1:$l(locList,"^")
		{
			s locRowid=$p(locList,"^",numOfLoc)

			s ResourceId=0 f  s ResourceId=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locRowid,StartDate,ResourceId)) q:ResourceId=""  d
			.q:((resourceIdIn'="")&&(resourceIdIn'=ResourceId))
			.s SchRowid=0 f  s SchRowid=$o(^DHCRBCResourceSchdulei("Loc-Date-Res",locRowid,StartDate,ResourceId,SchRowid)) q:SchRowid=""  d
			..d ResSchduleDetail
		}
	}
	
	d DoSort

    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

ResSchduleDetail

    s View=""
    s TimeFlag=""
    s RessourceID=$p(^DHCRBCResourceSchdule(SchRowid),"^",1)
    ;w !,RessourceID
    q:(RessourceID="")
    s UseResID="",LocResID="",TimeDesc="",ResourceDesc="",EqId="",CareProvId="",GetLocId=""
    s MaxNumber=""
    s GetLocId=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",11) 

    s EqId=$p($g(^RB("RES",RessourceID)),"^",3)
    ;w !,EqId
    q:(EqId="")
    s CareProvId=$p(^RB("RES",RessourceID),"^",2)
    i EqId'="" s ResourceDesc=$p(^RBC("EQ",EqId),"^",2)
    i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2) 

    s StartTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",5)
    i StartTime<$zth("12:00:00",1) d
    .s TimeFlag="AM"
    e  d
    .s TimeFlag="PM"
    s Date=$p(^DHCRBCResourceSchdule(SchRowid),"^",2)
    s EndTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",6)
    
    s TimeDescCode=$p(^DHCRBCResourceSchdule(SchRowid),"^",3)
    ;q:(TimeDescCode="")
    if (TimeDescCode="")
    {
	    s TimeDescRowid=""
	    s TimeDesc=$zt(StartTime,2)_"-"_$zt(EndTime,2)
    }
    else
    {
	    s TimeDescRowid=$o(^DHCRBCTimePeriodSeti("Code",TimeDescCode,0))
	    s TimeDesc=$p(^DHCRBCTimePeriodSet(TimeDescRowid),"^",2)
    }
    s CurrentTime=$p($h,",",2)
    s CurrentDate=+$h
    i ((Date=CurrentDate)&(EndTime<CurrentTime))!(Date<CurrentDate) s View="N"
    s StartTimeShow=$zt(StartTime)
    s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)  ;$zd(Date,3)
    s availPatType=$p(^DHCRBCResourceSchdule(SchRowid),"^",19)
    ;w !,"availPatType="_availPatType
    q:((availPatType'="")&&(availPatType'[PatType)&&(PatType'=""))
    ;wf 判断不可用，退出
    s notAvailable=$p(^DHCRBCResourceSchdule(SchRowid),"^",23)
    q:(notAvailable="Y")
    
    s MaxNumber=$p(^DHCRBCResourceSchdule(SchRowid),"^",7)
    ;w !,"MaxNumber="_MaxNumber
    q:(MaxNumber<=0)
    s RemainUnLockBookNumber=""
    s RemainUnLockBookNumber=$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",10) ;$p($g(^DHCRBCResourceSchdule(SchRowid)),"^",16) ;预占资源剩余
    ;w !,"RemainUnLockBookNumber="_RemainUnLockBookNumber_"--"
    i RemainUnLockBookNumber="" s RemainUnLockBookNumber=MaxNumber
    i RemainUnLockBookNumber<0 s RemainUnLockBookNumber=0
    i RemainUnLockBookNumber=0 s View="N"
    s nextBookTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",17)
    i nextBookTime="" s nextBookTime=StartTime
    i nextBookTime>=EndTime s View="N"
    s nextBookTimeShow=$zt(nextBookTime,2)
    s remailTime=$p(^DHCRBCResourceSchdule(SchRowid),"^",18)
    
    ;判断超声医生能力
    /*
    s docInfoList=..getDocByDateTimeRes(RessourceID,Date,StartTime,EndTime)
    s docRowid=$p(docInfoList,"^",1)
    s docName=$p(docInfoList,"^",2)
    
    s isExamByDoc=..canExamByDoc(docRowid,itemGroupRowidList)
    q:(isExamByDoc="N")
    */
    
    s useRadio=$fn((MaxNumber-RemainUnLockBookNumber)/MaxNumber,"",3)*1000
    //CurrentRatio=$fn(UseNumber/MaxNumber,"",3)
    set Data=$lb(SchRowid,TimeDesc,BookedDate,StartTimeShow,ResourceDesc,RemainUnLockBookNumber,RessourceID,View,MaxNumber,TimeFlag,nextBookTimeShow,remailTime,docName,docRowid)
    
    
    if (View="N")
    {
	    s DataBookFindViewN(##class(websys.Conversions).DateHtmlToLogical(BookedDate),StartTime,useRadio,SchRowid)=Data
    }
    else
    {
    	s DataBookFind(##class(websys.Conversions).DateHtmlToLogical(BookedDate),StartTime,useRadio,SchRowid)=Data
    }
    
    
    quit
    
    
DoSort
	//s hasData="N"
	s dateSort="" f  s dateSort=$o(DataBookFind(dateSort)) q:(dateSort="")  d
	.s time="" f  s time=$o(DataBookFind(dateSort,time)) q:(time="")  d
	..s radio="" f  s radio=$o(DataBookFind(dateSort,time,radio)) q:(radio="")  d
	...s rowid="" f  s rowid=$o(DataBookFind(dateSort,time,radio,rowid)) q:(rowid="")  d
	....Set ^CacheTemp(repid,ind)=DataBookFind(dateSort,time,radio,rowid)
 	....Set ind=ind+1 
 	
 	s dateSort="" f  s dateSort=$o(DataBookFindViewN(dateSort)) q:(dateSort="")  d
 	.s time="" f  s time=$o(DataBookFindViewN(dateSort,time)) q:(time="")  d
	..s radio="" f  s radio=$o(DataBookFindViewN(dateSort,time,radio)) q:(radio="")  d
	...s rowid="" f  s rowid=$o(DataBookFindViewN(dateSort,time,radio,rowid)) q:(rowid="")  d
	....Set ^CacheTemp(repid,ind)=DataBookFindViewN(dateSort,time,radio,rowid)
 	....Set ind=ind+1 
	
	quit
}

ClassMethod QuerySchduleDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySchduleDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    //
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {             // fetch row
        Set Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod QuerySchduleDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySchduleDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DHCRisBookAllResource).getItemGroupRowidList("19376||1@19376||2")

// 获取医嘱串所在的检查组

ClassMethod getItemGroupRowidList(orderList As %String) As %String
{
    
	s groupList=""
	for numList=1:1:$l(orderList,"@")
	{
		s orderRowid1=$p(orderList,"@",numList)
		s orderRowid1=$p(orderRowid1,"$",1)
		if (orderRowid1="")
		{
			continue
		}
		s arcItmMastRowid1=$p($g(^OEORD($p(orderRowid1,"||",1),"I",$p(orderRowid1,"||",2),1)),"^",2)
		s examItemRowid=$o(^DHCRBExamItemi("arcItem",arcItmMastRowid1,""))
		if (examItemRowid="")
		{
			continue
		}
		s itemGroupRowid=$p(^DHCRBExamItem(examItemRowid),"^",4)
		if (itemGroupRowid'="")
		{
			
			if (groupList="")
			{
				s groupList=itemGroupRowid
			}
			else
			{
				if ( ..isExistInGroup(groupList,itemGroupRowid)=0)
				{
					s groupList=groupList_"^"_itemGroupRowid
				}
			}
		}
	}
	q groupList
}

/// w ##class(web.DHCRisBookAllResource).getDocByDateTimeRes("5802",+$h,"32400","36000")
/// 根据日期\时间和资源,查询医生排班
ClassMethod getDocByDateTimeRes(ResourceId, CurrDate, StartTime, EndTime) As %String
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
	
	s (docRowid,docName)=""
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
	..s docName=$p(^SSU("SSUSR",docRowid),"^",2)
    
    q docRowid_"^"_docName
    */
    q "^"
}

// 医生是否可以做这些检查组的检查

// w ##class(web.DHCRisBookAllResource).canExamByDoc("195","7^6")

ClassMethod canExamByDoc(docRowid, itemGroupRowidList) As %String
{
	s ret="Y"
	q:((docRowid="")||(itemGroupRowidList="")) ret
	s docCapSetRowid=$o(^DHCRBDocExamCapSeti("userRowid",docRowid,""))
	q:(docCapSetRowid="") ret
	s canExamList=""
	s capSetCat="" f  s capSetCat=$o(^DHCRBDocExamCapSetCati("indexDocCapSet",docCapSetRowid,capSetCat)) q:(capSetCat="")  d
	.s canExamCat=$p(^DHCRBDocExamCapSetCat(capSetCat),"^",2)
	.s canExamList=canExamList_"^"_canExamCat
	;w !,canExamList,!
	for numCanExam=1:1:$l(itemGroupRowidList,"^")
	{
		q:(ret="N")
		s itemGroup=$p(itemGroupRowidList,"^",numCanExam)
		if (..isExistInGroup(canExamList,itemGroup)=0 )
		{
			s ret="N"
		}
	}
	
	q ret
}

ClassMethod getLocList(locRowid As %String) As %String
{
	s locListRet=""
	s locCTList="390^391^392^393^396^400^544"
	s locMRList="388^389"
	s locPFList="394"
	
	if (..isExistInGroup(locCTList,locRowid))
	{
		s locListRet=locCTList
	}
	elseif (..isExistInGroup(locMRList,locRowid))
	{
		s locListRet=locMRList
	}
	elseif (..isExistInGroup(locPFList,locRowid))
	{
		s locListRet=locPFList
	}
	else
	{
		s locListRet=locRowid
	}
	
	q locListRet
}

/// 作者：wangfeng
/// 日期：20160905
/// w ##class(web.DHCRisBookAllResource).isExistInGroup()
ClassMethod isExistInGroup(group As %String, itemIn As %String) As %String
{
	s isExist=0
	s lenOfGroup=$l(group,"^")
	for k=1:1:lenOfGroup
	{
		s item=$p(group,"^",k)
		if ( item'="")
		{
			if ( item=itemIn)
			{
				s isExist=1
			}
		}
	}
	q isExist
}

/// modify wf 20160730 改为传入医嘱串，医嘱信息拼接
/// w ##class(web.DHCRisBookAllResource).getOrderInfo("378||6$8022@393||3$8022")
ClassMethod getOrderInfo(orderList As %String) As %String
{
	s ^TempDHCRis("getOrderInfo")=orderList
	s ret=""
	s orderItmRowid=$p(orderList,"@",1)
	s orderItmRowid=$p(orderItmRowid,"$",1)
	s bodyListIn=$p(orderItmRowid,"$",2)
	s bodyOne=$p(bodyListIn,",",1)
	q:(orderItmRowid="") ret
	s orderRowid=$p(orderItmRowid,"||",1)
	s itemSub=$p(orderItmRowid,"||",2)
	s admRowid=$p(^OEORD(orderRowid),"^",1)
	q:(admRowid="") ret
	s (RegNo,Name,DOB,strDOB,strAge,SexDr,SexDesc,arcimid,strOrderName,RecLocdr,RecLocDesc,ResSchduleID)=""
	//病人基本信息
	s papatmasmdr=$p(^PAADM(admRowid),"^",1)
      
    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)      
    s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)   
    s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)       
	i DOB="" d
	.s strDOB=""
	.s strAge=""
	e  d
	.;s strDOB=$ZD(DOB,3)
	.;s strToday=$ZD(+$h,3)
	.;s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
	.s strDOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
    .s strAge= ##class(web.DHCBillInterface).GetPapmiAge(papatmasmdr,admRowid) 

    s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
    i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
    //医嘱信息 多条医嘱拼在一起
    s orderDescList=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(orderList)
    /*s lenOfOrder=$l(orderList,"@")
    for numOfOrder=1:1:lenOfOrder
    {
	    s orderitemDr=$p(orderList,"@",numOfOrder)
	    if (orderitemDr'="")
	    {
		    
		    s arcimid=$p(^OEORD($p(orderitemDr,"||",1),"I",$p(orderitemDr,"||",2),1),"^",2)
			s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
			s orderBodyInfo=##class(web.DHCRisCommFunctionEx).GetOrderDesc(orderitemDr)
			if (orderBodyInfo="")
			{
				s orderBodyInfo=strOrderName
			}
			if (orderDescList="")
			{
				s orderDescList=orderBodyInfo
			}
			else
			{
				s orderDescList=orderDescList_"; "_orderBodyInfo
			}
			
	    }
    }
    */
	//s arcimid=$p(^OEORD(orderRowid,"I",itemSub,1),"^",2)
	//s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) 
	s RecLocdr=$p(^OEORD(orderRowid,"I",itemSub,3),"^",6)
	if RecLocdr'="" d
	.s RecLocDesc=$p(^CTLOC(RecLocdr),"^",2)
	.i $f(RecLocDesc,"-")>0 d
	..s RecLocDesc=$p(RecLocDesc,"-",2)
	//预约信息
	s (timeDesc,ResourceDesc,BookedDate,BooketSTime,BooketETime)=""
	s ResDetailRowid=""
	;s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderItmRowid,0)) 
	s ResDetailRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(orderItmRowid_"^"_bodyOne)
	b //01
	i (ResDetailRowid'="")
	{
	   
	   s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	   i ResSchduleID'="" d
	   .s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
	   .i ResouceId'="" d
	   ..s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	   ..s CareProvId=$p($g(^RB("RES",ResouceId)),"^",2)
	   ..i EqId'="" s ResourceDesc=$p($g(^RBC("EQ",EqId)),"^",2)
	   ..i CareProvId'="" s ResourceDesc=$p(^CTPCP(CareProvId,1),"^",2)
	   .s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	   .i Date'="" s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)   ;$zd(Date,3)
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
	   //.s ret=ResourceDesc_"^"_BookedDate_"^"_timeDesc_"^"_callNo
	}
	s Meno=##class(web.DHCRisResourceApptSchudle).GetAppBillMemo(orderItmRowid)
	//s BodyList=##Class(web.DHCRisWorkBenchDoEx).GetBodyList(orderItmRowid)
	s ApplicationBill=##Class(web.DHCAPPInterface).GetExaReqDesDet(orderItmRowid)
	;s ApplicationBill=$replace(ApplicationBill,"^","\r\n")
	s PatientNow="现病史："_$p($g(ApplicationBill),"^",2)
	s MainDiagose="体征："_$p($g(ApplicationBill),"^",3)
	s ret=RegNo_"^"_Name_"^"_SexDesc_"^"_strAge_"^"_orderDescList_"^"_ResourceDesc_"^"_BookedDate_"^"_timeDesc_"^"_ResSchduleID_"^"_RecLocdr_"^"_RecLocDesc_"^"_Meno_"^"_""_"^"_PatientNow_"^"_MainDiagose
	q ret
}

// w ##class(web.DHCRisBookAllResource).getOrderStatus()

// 获取预约和登记状态

ClassMethod getOrderStatus(orderList As %String) As %String
{
	s ^DHCRisTemp("getOrderStatus")=orderList
	s status=""
	q:(orderList="") status
	
	s isReg=##class(web.DHCRisRegisterPatientDoEx).hasRegisterItem(orderList)
	if (isReg="Y")
	{
		s status="R"
	}
	else
	{
		s isBook=##class(web.DHCRisResourceApptSchudle).hasBookOrder(orderList)
		if (isBook="Y")
		{
			s status="B"
		}
	}
		
	q status
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisBookAllResource","QueryResource","83")
Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1

	s locList=..getLocList(LocID)
	for numOfLoc=1:1:$l(locList,"^")
	{
		s LocID=$p(locList,"^",numOfLoc)
		Set RowId="" f  s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId) ) q:RowId=""  d
		.s CTCPDR=$p(^RB("RES",RowId),"^",2)
		.i CTCPDR'="" d
		..s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
		.else  d
		..s EQDR=$p(^RB("RES",RowId),"^",3)
		..s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
		.s scdrowid=$o(^RBAS(RowId,0))
		.;w !,scdrowid
		.i (CTCPDR ="") d    ;有排版计划
	    ..Do OutputResRow
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

OutputResRow
	set Data=$lb($g(ResDesc),RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	;Set ^CacheTemp(repid,1)=$lb("所有","")
 	
 	Set ind=ind+1
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
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

ClassMethod QueryResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 功能：获得科室医护人员的信息
/// 参数：Locrowid:科室ROWID
/// 返回：医护人员信息 
/// d ##class(%ResultSet).RunQuery("web.DHCRisBookAllResource","QueryDoc","402") 
Query QueryDoc(Locrowid As %String) As %Query(ROWSPEC = "DocRowid:%String,DocCode:%String,DocDesc:%String")
{
}

ClassMethod QueryDocExecute(ByRef qHandle As %Binary, Locrowid As %String) As %Status
{
	s ^DHCRisTemp("QueryDoc")=Locrowid
	Set repid=$I(^CacheTemp)
	;i $g(^DHCRisGetNameSet)="" s ^DHCRisGetNameSet="ID"
	s ind=1
	
	s resrowid=0 f  s resrowid=$o(^RB("RES",0,"CTLOC",Locrowid,resrowid)) q:(resrowid="")  d
	.s ResInfo=^RB("RES",resrowid)
	.s CareProvrowid=$p(ResInfo,"^",2)
	.q:(CareProvrowid="")
	.s ssuserRowid=$o(^SSU("SSUSR",0,"CTPCP",CareProvrowid,0))
	.q:(ssuserRowid="")
	.s userDesc=$p(^SSU("SSUSR",ssuserRowid),"^",2)
	.s userCode=$p(^SSU("SSUSR",ssuserRowid),"^",1)
	.Do OutQueryDoc 
	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutQueryDoc
	set Data=$lb(ssuserRowid,userCode,userDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDocExecute ]
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

ClassMethod QueryDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
