Import SQLUser

/// 名称: DHCRisPlatBook
/// 描述: 所有关于预约操作的方法
/// 编写者：wf
/// 编写日期: 2017.6.20
Class web.DHCRisPlatBook Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 功能:服务台预约
/// 作者:wf
/// 日期:20170620
/// w ##class(web.DHCRisPlatBook).Book(^TempDHCRis("Book"))
ClassMethod Book(Info As %String) As %String
{
	n (Info)
	s ^DHCRisPlatTemp("Book")=Info
	
	Set $ZT="BookError"	
	s orderlist=$p(Info,"^",1)    //医嘱串，可能会有部位
	s resSchduleID=$p(Info,"^",2)      //资源计划rowid
	//s appointMethod=$p(Info,"^",3)     //1: 手动， 2：自动 可能会有其他标志 
    s userRowid=$p($g(Info),"^",3)     //操作人
    s examDoc=$p($g(Info),"^",4)
    
    s appointMethod=1
    
    ;不可用退出
	s notAvailable=$p($g(^DHCRBCResourceSchdule(resSchduleID)),"^",23)
    q:(notAvailable="Y") "-800"
    
    //截止缴费时间
    s stopTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",14) 
    s bookDate=$p(^DHCRBCResourceSchdule(resSchduleID),"^",2)
    // 当天预约，不能超过截止缴费时间
    //if (((bookDate=+$h) && ($p($h,",",2)>stopTime))||(bookDate<+$h))
    if (bookDate<+$h)
   	{
		q "-400"  
	}
	
	//加锁和事务
	lock +(^DHCRisTempBook)
	TSTART
	
	s bookRet=""
	for i=1:1:$l(orderlist,"@")
	{
		s orderRowid=$p(orderlist,"@",i)
		if (orderRowid="")
		{
			continue
		}
		//判断是否有已经预约的记录
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderRowid,""))
	    if (ResDetailRowid'="")
	    {
		    continue
	    }
	    //判断是否登记
	    s regRowid=$o(^DHCPACRegInfoi("OEORI",orderRowid,""))
	    if (regRowid'="")
	    {
		    continue
	    }
		s bookRet=..InsertBookData(orderRowid,resSchduleID,appointMethod,userRowid,examDoc)
		//一个不成功就退出
		if (bookRet'="SUCCESS")
		{
			quit
		}
		
	}
	
	lock -(^DHCRisTempBook)
 	if (bookRet'="SUCCESS")
 	{ 	
		TRollBack
		q bookRet
 	}
 	
 	TCommit
	q bookRet
 
BookError  
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTempBook)
 	s ^DHCRisPlatError("book",orderlist)=$g(Info)_"****"_ErrorMsg
 	q "ERROR^"_ErrorMsg
}

/// 功能:插入预约数据
/// 作者:wf
/// 日期:20170620
/// w ##class(web.DHCRisPlatBook).InsertBookData(^TempDHCRis("Book"))
/// 此方法不能单独使用，具体使用时需要在外层方法中增加锁和错误处理以及事务处理
/// 能否预约，不在此方法判断
ClassMethod InsertBookData(orderList As %String, resSchduleID As %String, appointMethod As %String, operateDoc As %String, examDoc As %String) As %String
{
	n (orderList,resSchduleID,appointMethod,operateDoc,examDoc)
	
	s ^DHCRisPlatTemp("InsertBookData")=$lb(orderList,resSchduleID,appointMethod,operateDoc)
	
	//appointMethod  1: 手动， 2：自动 
    
    s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	
	;不可用退出
	;s notAvailable=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",23)
    ;q:(notAvailable="Y") "-800"
    
	s bookDateGet=$p(^DHCRBCResourceSchdule(resSchduleID),"^",2)
	s bookDate=$zd(bookDateGet,3)
	s bookResource=$p(^DHCRBCResourceSchdule(resSchduleID),"^",1)
    
    //
    s resourceLoc=$p(^RB("RES",bookResource),"^",1)
    
    //s bookType="1"   ; 1为按最大数预约   2为按检查时间预约
    ;s nextStartTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",17)
    ;s remainTime=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",18)
    

	s bookType=1 ;##class(web.DHCRisCodeTableAdd).GetBKUseFlagbyLoc(InLocDR)
    
    s Count=$l(orderList,"@")
    
    //资源数
    s MaxNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",8)
    
    s UseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",10) 
    
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",13)
	i UseNumber="" s UseNumber=0
    i AutoUseNumber="" s AutoUseNumber=0
   	i AutoNumber="" s AutoNumber=0
   	//剩余数为空，则剩余数为全部可预约数
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
    
   	//s ManualNumber=MaxNumber-AutoNumber
   	//s ManulaUseNumber=UseNumber-AutoUseNumber
   	  
   	s startTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",5)
   	s stopTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",6) 
   	
   	s orderBody=$p(orderList,"@",1)
    s orderItemRowid=$p(orderBody,"$",1)
    s locRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),3)),"^",6)
    s bookNo=..GetBookNo(orderItemRowid,locRowid,bookDate)
    
   
    /*
    s retList=..getNextNumber(resSchduleID)
    s nextNum=$p(retList,"^",1)
    s updateUseNoList=$p(retList,"^",2)
	*/
    
    //TSTART
    //s SQLCODE=100
    
    //插入预约表
    for Ni=1:1:Count 
    {
      s perOrditemRowid=$p(orderList,"@",Ni)
      s bodyList=$p(perOrditemRowid,"$",2)
      s perOrditemRowid=$p(perOrditemRowid,"$",1)
      s OrdRowid=$p(perOrditemRowid,"||",1)
      s itemsub=$p(perOrditemRowid,"||",2)

	  s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
	  s reclocRowid=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
	  if (reclocRowid'=resourceLoc)
	  {
		  s changeLocRet=##class(DHCDoc.Interface.Inside.Service).UpdateOEORI(perOrditemRowid,operateDoc,resourceLoc_"^")
		  s ^DHCRisPlatTemp("changeRecLoc",perOrditemRowid)=changeLocRet_"****"_reclocRowid
	  }
	  //d ##class(DHCDoc.Interface.Inside.Service).UpdateOEORI(OEORIRowId,UserId,NewInfo)
   	  
   	  //DRPD_EQ_Index,
	  &sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,
	                   	                      DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime,DRPD_BookDate,DRPD_BookResourceId,DRPD_ExamDoc) 
	         values (:resSchduleID,:perOrditemRowid,:EpisodeID,:appointMethod,:bookNo,:operateDoc,:OperateDate,:OperateTime,:startTime,:stopTime,:bookDateGet,:bookResource,:examDoc)) 
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
	  
	  s ret=##class(web.DHCENS.EnsHISService).DHCHisInterface(perOrditemRowid,"SENDPATORDLISTTORIS")
	   s ^DHCRisTemp("SENDPATORDLISTTORIS",perOrditemRowid)=ret
	   
	  if ( '$d(^DHCRisBookFirst(perOrditemRowid)))
	  {
		  s ^DHCRisBookFirst(perOrditemRowid)=bookDateGet_"^"_startTime_"^"_resSchduleID
	  }
	  
	  //记录日志 wf 20161026	  
      s paPatMasRowidLog=$p($g(^PAADM(EpisodeID)),"^",1)
      s RegNoLog=$p($g(^PAPER(paPatMasRowidLog,"PAT",1)),"^",1)
      s bookSTimeLog=$zt(startTime)
      s bookETimeLog=$zt(stopTime)
      s contentLog=resSchduleID_"$"_appointMethod_"$"_bookResource_"$"_bookDate_"$"_bookSTimeLog_"$"_bookETimeLog_"$"_$g(bodyList)
      /*if (ApptUser'="") 
      {
	      s apptUserDr=$o(^SSU("SSUSR",0,"SSUSR_Name",$zcvt(ApptUser,"U"),""))
      }*/
      d ##class(web.DHCRisPlatCommonBusiness).SaveOperationLog($g(operateDoc),RegNoLog,perOrditemRowid,"Book",contentLog,locRowid,"")  
	  
    }  
			
    if ($g(SQLCODE))
    {
		q $g(SQLCODE)
    }

    //更新资源计划表
    s (updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
    
    
     s updateUseNumber= UseNumber+1
   	 s updateRemainNumber=RemainNumber-1	
   	 if (appointMethod="2")  //自动预约
   	 {
   	     s updateAutoUseNumber=AutoUseNumber+1
   	 }
   	 else
   	 {
	   	 s updateAutoUseNumber=AutoUseNumber
   	 }
   	 
	 //,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam
   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                          values (:updateAutoUseNumber,:updateRemainNumber,:updateUseNumber) where  DRPS_RowID=:resSchduleID)  
 

     if ($g(SQLCODE))
     {
		q $g(SQLCODE)
     }

    //TCOMMIT  

    //s ret=##class(RISService.InvokeRISService).InsertStudyInfoCacheWS(bookNo,"B")   
 	//s ^DHCRisTemp("bookToRis4",$g(bookNo))=bookNo_"^"_"B"_"^"_ret
   
    q "SUCCESS"
}

// wf  生成预约号，传入医嘱串，生成一个预约号

ClassMethod GetBookNo(orditmrowid, LocDr, bookDate) As %String
{
	n (orditmrowid, LocDr, bookDate)
	s ^DHCRisPlatTemp("GetBookNo")=orditmrowid_"^"_LocDr_"^"_bookDate
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
			s Number=##class(web.DHCRisPlatCommon).Out3Number(Number)
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

// 根据资源计划表rowid,获取序号和插入后更新的已使用序号列表

ClassMethod getNextNumber(ResSchduleID)
{
	s ^DHCRisPlatTemp("getNextNumber")=ResSchduleID
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

/// 功能:服务台转预约
/// 作者:wf
/// 日期:20170623
/// w ##class(web.DHCRisPlatBook).ModifyBook(^DHCRisPlatTemp("ModifyBook"))
ClassMethod ModifyBook(Info As %String, reason As %String) As %String
{
	n (Info,reason)
	s ^DHCRisPlatTemp("ModifyBook")=$lb(Info,reason)
	
	Set $ZT="ModifyBookError"	
	s orderlist=$p(Info,"^",1)    //医嘱串，可能会有部位
	s resSchduleID=$p(Info,"^",2)      //资源计划rowid
	//s appointMethod=$p(Info,"^",3)     //1: 手动， 2：自动 可能会有其他标志 
    s userRowid=$p($g(Info),"^",3)     //操作人
    s examDoc=$p($g(Info),"^",4)
    
    s appointMethod=1
    
    ;不可用退出
	s notAvailable=$p($g(^DHCRBCResourceSchdule(resSchduleID)),"^",23)
    q:(notAvailable="Y") "-800"
    
    //截止缴费时间
    s stopTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",14) 
    s bookDate=$p(^DHCRBCResourceSchdule(resSchduleID),"^",2)
    // 当天预约，不能超过截止缴费时间
    //if (((bookDate=+$h) && ($p($h,",",2)>stopTime))||(bookDate<+$h))
    if (bookDate<+$h)
   	{
		q "-400"  
	}
	
	//加锁和事务
	lock +(^DHCRisTempBook)
	TSTART
	
	s bookRet=""
	s deleteBookRet=""
	for i=1:1:$l(orderlist,"@")
	{
		s orderRowid=$p(orderlist,"@",i)
		if (orderRowid="")
		{
			continue
		}
		/*
		s deleteBookRet=..deleteBookData(orderRowid,userRowid,reason)
		if (deleteBookRet'="SUCCESS")
		{
			quit
		}
		*/
		
		s bookRet=..modifyBookData(orderRowid,resSchduleID,appointMethod,userRowid,reason,examDoc)
		//一个不成功就退出
		if (bookRet'="SUCCESS")
		{
			quit
		}
		
	}
	
	lock -(^DHCRisTempBook)
 	if (bookRet'="SUCCESS")
 	{ 	
		TRollBack
		q bookRet
 	}
 	TCommit
	q "SUCCESS"
 
ModifyBookError  
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTempBook)
 	s ^DHCRisPlatError("ModifyBook",orderlist)=$g(Info)_"****"_ErrorMsg
 	q "ERROR^"_ErrorMsg
}

/// 取消预约方法
/// 作者:wf
/// 日期:20170623
/// w ##class(web.DHCRisPlatBook).InsertBookData(^TempDHCRis("Book"))
/// 此方法不能单独使用，具体使用时需要在外层方法中增加锁和错误处理以及事务处理
/// 是否取消预约，不在此方法判断
ClassMethod deleteBookData(orderItemRowid As %String, operateDoc As %String, reason As %String, operateSource As %String = "") As %String
{
	n (operateDoc,orderItemRowid,reason,operateSource)
	
	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderItemRowid,0))
	
	if (DetailRowid="")
	{
		q "SUCCESS"
	}
	
	s resSchduleRowid=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
	
	s AppointMethod=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
	s bookNo=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)
	
	s bookStartTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
	s bookEndTime=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",19)
	s bookDate=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",23)
	s bookRes=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",24)

	/*
	s bookSeqNo=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",8) 
	s useSeqNoList=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",21) 
	if (bookSeqNo'="")
	{
		s updateUseSeqNoList=..deleteFromList(useSeqNoList,bookSeqNo)
	}
	*/
	
	;是否更新预约资源数量(多条医嘱预约占一个资源的情况，需全部都取消后才能更新资源数量)
	s UpFlag=..IsUpSchdule(bookNo)

	s RecLocdr=$p(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),3),"^",6)
	
	;是否是晚加班乳腺检查
      s arcItemRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
	  if (arcItemRowid'="")
	  {
		s arcItemCode=$p(^ARCIM($p(arcItemRowid,"||",1),$p(arcItemRowid,"||",2),1),"^",1)
		if ((arcItemCode="DCSK000073")||(arcItemCode="DCSK000075")||(arcItemCode="DCSK000076"))
		{
			s bookEvening="Y"
		}
	  }

	s MaxNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",8)
    s UseNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",13)
    s startTime=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",5)
    s endTime=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",6)
    
    
    i UseNumber="" s UseNumber=0
   	i AutoUseNumber="" s AutoUseNumber=0
	
	&sql(delete from DHCRBC_ResSchduleDetail WHERE DRPD_RowID=:DetailRowid)
	
	if (SQLCODE)
    {
		q SQLCODE
    }
    
    if (($g(bookEvening)="Y") &&(bookStartTime>$zth("16:00:00",1)))
  	{		   		
	   	s ^DHCRisBookEveningLimit(bookDate)=^DHCRisBookEveningLimit(bookDate)-1 		
  	}
	//更新预约计划表
	if (UpFlag="Y" )
	{
		//使用数-1
		i UseNumber>0 s updateUserNumber=UseNumber-1
		//自动使用数-1
		if ( AppointMethod="2")
		{
			if (AutoUseNumber>0)
			{
				s updateAutoUseNumber=AutoUseNumber-1
			}
		}
		s updateRemainNumber=RemainNumber+1
		&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                           values (:updateAutoUseNumber,:updateRemainNumber,:updateUserNumber) where  DRPS_RowID=:resSchduleRowid)
	
		if (SQLCODE)
	    {
			q SQLCODE
	    }
	}
	
	/*
	if (AppointMethod="2")  d  //自动预约方式
    .i AutoUseNumber>0 s AutoUseNumber=AutoUseNumber-1
    i UseNumber>0 s UseNumber=UseNumber-1
    s RemainNumber=MaxNumber-UseNumber	
    */

    
    ;发送取消预约消息到RIS4系统
    ;do ##class(web.DHCRisSendToRis4Set).SendCanelBookedtoRIS4(OrderItemRowid)
    ;s ret=##Class(RISService.InvokeRISService).CancelRegisterByOEOridCacheWS(orderItemRowid)
    ;s ^DHCRisPlatTemp("cancelBook",orderItemRowid)=ret
    s statusanduser="CBK^"_operateDoc
	s ret=##Class(RISService.InvokeRISService).CancelRegisterByOEOridAndBodyPartCacheWS(bookNo,orderItemRowid,"","Y",statusanduser)
	s ^DHCRisPlatTemp("cancelBook",orderItemRowid)=ret
    
    
    //记录日志 wf 20161026
	s EpisodeID=$p(^OEORD($p(orderItemRowid,"||",1)),"^",1)
	s paPatMasRowidLog=$p($g(^PAADM(EpisodeID)),"^",1)
	s RegNoLog=$p($g(^PAPER(paPatMasRowidLog,"PAT",1)),"^",1)
	
	s contentLog=DetailRowid_"$"_resSchduleRowid_"$"_AppointMethod_"$"_bookRes_"$"_$zd(bookDate,3)_"$"_$zt(bookStartTime)_"$"_$zt(bookEndTime)
	//
	d ##class(web.DHCRisPlatCommonBusiness).SaveOperationLog($g(operateDoc),RegNoLog,orderItemRowid,"CancelBook",contentLog,RecLocdr,"",$g(reason),operateSource)

	q "SUCCESS"
}

/// w ##class(web.DHCRisPlatBook).IsUpSchdule("CS20141017-020")
ClassMethod IsUpSchdule(inBookNo As %String) As %String
{
	n (inBookNo)
	s IsUp="N"
	q:(inBookNo="") "Y"
	
	s Count=0
	s Rowid="" f  s Rowid=$o(^DHCRBCResSchduleDetaili("StudyNo",inBookNo,Rowid)) q:(Rowid="")  d
	.s num=0
	.&sql(select count(*) into :num from DHCRBC_SchduleDetailBody WHERE SchduleDetailRowid=:Rowid)
	.if num=0 d
	..s Count=Count+1
	.e  d
	..s Count=Count+num
	i Count=1 s IsUp="Y"
	q IsUp
}

/// 转预约方法
/// 作者:wf
/// 日期:20170626
/// w ##class(web.DHCRisPlatBook).modifyBookData(^TempDHCRis("Book"))
/// 此方法不能单独使用，具体使用时需要在外层方法中增加锁和错误处理以及事务处理
/// orderList As %String,  operateDoc As %String
ClassMethod modifyBookData(orderList As %String, resSchduleID As %String, appointMethod As %String, operateDoc As %String, reason As %String, examDoc As %String = "") As %String
{
	n (orderList,resSchduleID,reason,appointMethod,operateDoc,reason,examDoc)
	s ^DHCRisPlatTemp("modifyBookData")=$lb(orderList,resSchduleID,reason,appointMethod,operateDoc)
	
	
	s OperateDate=+$h
	s OperateTime=$p($h,",",2)
	
    
	s bookDateGet=$p(^DHCRBCResourceSchdule(resSchduleID),"^",2)
	s bookDate=$zd(bookDateGet,3)
	s bookResource=$p(^DHCRBCResourceSchdule(resSchduleID),"^",1)
	
	s resourceLoc=$p(^RB("RES",bookResource),"^",1)
   
    //1 为最大数预约
	s bookType=1 ;##class(web.DHCRisCodeTableAdd).GetBKUseFlagbyLoc(InLocDR)
    
    s Count=$l(orderList,"@")
    
    //资源数
    s MaxNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",7) 
    s AutoNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",8)
    
    s UseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",10) 
    
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",13)
	i UseNumber="" s UseNumber=0
    i AutoUseNumber="" s AutoUseNumber=0
   	i AutoNumber="" s AutoNumber=0
   	//剩余数为空，则剩余数为全部可预约数
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
      
   	s startTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",5)
   	s stopTime=$p(^DHCRBCResourceSchdule(resSchduleID),"^",6) 
   	
    s orderItemRowid=$p(orderList,"@",1)
    s locRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),3)),"^",6)
    s bookNo=..GetBookNo(orderItemRowid,locRowid,bookDate)
    

    //转预约
    for Ni=1:1:Count 
    {
		s perOrditemRowid=$p(orderList,"@",Ni)
		
		s bodyList=$p(perOrditemRowid,"$",2)
		s perOrditemRowid=$p(perOrditemRowid,"$",1)
		
		s OrdRowid=$p(perOrditemRowid,"||",1)
		s itemsub=$p(perOrditemRowid,"||",2)
		s EpisodeID=$p(^OEORD(OrdRowid),"^",1)
		
		;是否是晚加班乳腺检查
      	s arcItemRowid=$p($g(^OEORD(OrdRowid,"I",itemsub,1)),"^",2)
	  	if (arcItemRowid'="")
	  	{
			s arcItemCode=$p(^ARCIM($p(arcItemRowid,"||",1),$p(arcItemRowid,"||",2),1),"^",1)
			if ((arcItemCode="DCSK000073")||(arcItemCode="DCSK000075")||(arcItemCode="DCSK000076"))
			{
				s bookEvening="Y"
			}
	  	}
		
		s reclocRowid=$p($g(^OEORD(OrdRowid,"I",itemsub,3)),"^",6)
		if (reclocRowid'=resourceLoc)
		{
		  s changeLocRet=##class(DHCDoc.Interface.Inside.Service).UpdateOEORI(perOrditemRowid,operateDoc,resourceLoc_"^")
		  s ^DHCRisPlatTemp("changeRecLocModiy",perOrditemRowid)=changeLocRet_"****"_resourceLoc
		}
   	  
   	  	//删除原预约表
   	  	s DetailRowid=$o(^DHCRBCResSchduleDetaili(0,perOrditemRowid,0))
	
		if (DetailRowid'="")
		{
			
			s resSchduleRowidDel=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)

			s AppointMethodDel=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",4) ; 2:自动预约
			s bookNoDel=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",6)

			s bookStartTimeDelNum=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",18)
			s bookStartTimeDel=$zt(bookStartTimeDelNum)
			s bookEndTimeDel=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",19)
			s bookEndTimeDel=$zt(bookEndTimeDel)
			s bookDateDelNum=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",23)
			s bookDateDel=$zd(bookDateDelNum,3)
			s bookResDel=$p($g(^DHCRBCResSchduleDetail("Detail",DetailRowid)),"^",24)


			;释放资源
			;是否更新预约资源数量(多条医嘱预约占一个资源的情况，需全部都取消后才能更新资源数量)
			s UpFlag=..IsUpSchdule(bookNoDel)

			s RecLocDel=$p(^OEORD(OrdRowid,"I",itemsub,3),"^",6)

			s MaxNumberDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",7) 
			s AutoNumberDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",8)
			s UseNumberDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",9) 
			s RemainNumberDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",10) 
			s AutoUseNumberDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",13)
			s startTimeDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",5)
			s endTimeDel=$p(^DHCRBCResourceSchdule(resSchduleRowidDel),"^",6)


			i UseNumberDel="" s UseNumberDel=0
			i AutoUseNumberDel="" s AutoUseNumberDel=0

			&sql(delete from DHCRBC_ResSchduleDetail WHERE DRPD_RowID=:DetailRowid)

			q:SQLCODE 
			
			if (($g(bookEvening)="Y") &&(bookStartTimeDelNum>$zth("16:00:00",1)))
		  	{		   		
			   	s ^DHCRisBookEveningLimit(bookDateDelNum)=^DHCRisBookEveningLimit(bookDateDelNum)-1 		
		  	}

			//更新预约计划表
			if (UpFlag="Y" )
			{
				s (updateRemainNumberDel,updateUserNumberDel,updateAutoUseNumberDel)=""
				//使用数-1
				i UseNumberDel>0 s updateUserNumberDel=UseNumberDel-1
				//自动使用数-1
				if ( AppointMethodDel="2")
				{
					if (AutoUseNumberDel>0)
					{
						s updateAutoUseNumberDel=AutoUseNumberDel-1
					}
				}
				s updateRemainNumberDel=RemainNumberDel+1
				&sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
				                   values (:updateAutoUseNumberDel,:updateRemainNumberDel,:updateUserNumberDel) where  DRPS_RowID=:resSchduleRowidDel)
	
				q:SQLCODE 
			}
		
		}
	
		&sql(insert into  DHCRBC_ResSchduleDetail(DRPD_ResSchdule_ID,DRPD_OrderItem_ID,DRPD_EpsoideID,DRPD_AppointMethod,DRPD_StudyNo,
		               	                      DRPD_AppointUser_DR,DRPD_Operate_Date,DRPD_Operate_Time,DRPD_StartTime,DRPD_EndTime,DRPD_BookDate,DRPD_BookResourceId,DRPD_ExamDoc) 
		     values (:resSchduleID,:perOrditemRowid,:EpisodeID,:appointMethod,:bookNo,:operateDoc,:OperateDate,:OperateTime,:startTime,:stopTime,:bookDateGet,:bookResource,:examDoc)) 
			//values (:ResSchduleID,:perOrditemRowid,:EpisodeID,:AppointMethod,:StudyNo,:RegEQIndex,:CheckGroupIndex,:RoomIndex,:EQDr,:EQGroupDR,:RoomDR,:IndexTypeDR,:UserDR,:OperateDate,:OperateTime,:nextStartTime,:endTime)) 
		

		q:SQLCODE 
		
		if (($g(bookEvening)="Y") &&(startTime>$zth("16:00:00",1)))
	  	{
	   		if ($d(^DHCRisBookEveningLimit(bookDateGet)) )
	   		{
		   		s ^DHCRisBookEveningLimit(bookDateGet)=^DHCRisBookEveningLimit(bookDateGet)+1
	   		}
	   		else
	   		{
		   		s ^DHCRisBookEveningLimit(bookDateGet)=1
	   		}
	  	}
		//记录日志 wf 20161026	  
		s paPatMasRowidLog=$p($g(^PAADM(EpisodeID)),"^",1)
		s RegNoLog=$p($g(^PAPER(paPatMasRowidLog,"PAT",1)),"^",1)
		s bookSTimeLog=$zt(startTime)
		s bookETimeLog=$zt(stopTime)
		
		s contentLog=resSchduleID_"$"_appointMethod_"$"_bookResource_"$"_bookDate_"$"_bookSTimeLog_"$"_bookETimeLog_"#"_resSchduleRowidDel_"$"_DetailRowid_"$"_AppointMethodDel_"$"_bookNoDel_"$"_bookDateDel_"$"_bookStartTimeDel_"$"_bookEndTimeDel_"$"_bookResDel
		/*if (ApptUser'="") 
		{
		  s apptUserDr=$o(^SSU("SSUSR",0,"SSUSR_Name",$zcvt(ApptUser,"U"),""))
		}*/
		d ##class(web.DHCRisPlatCommonBusiness).SaveOperationLog($g(operateDoc),RegNoLog,perOrditemRowid,"ModifyBook",contentLog,locRowid,"",reason)
	  
    }
    
			
    if ($g(SQLCODE))
    {
		q $g(SQLCODE)
    }

    //更新资源计划表
    s (updateUseNumber,updateRemainNumber,updateAutoUseNumber)=""
    
    ;再次获取数量   20170921
    s UseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",9) 
    s RemainNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",10) 
    s AutoUseNumber=$p(^DHCRBCResourceSchdule(resSchduleID),"^",13)
    
    i UseNumber="" s UseNumber=0
    i AutoUseNumber="" s AutoUseNumber=0
   	i AutoNumber="" s AutoNumber=0
   	//剩余数为空，则剩余数为全部可预约数
   	if (RemainNumber="")
    {
	    s RemainNumber=MaxNumber
    }
    
    s updateUseNumber= UseNumber+1
   	s updateRemainNumber=RemainNumber-1	
   	 if (appointMethod="2")  //自动预约
   	 {
   	     s updateAutoUseNumber=AutoUseNumber+1
   	 }
   	 else
   	 {
	   	 s updateAutoUseNumber=AutoUseNumber
   	 }
   	 
	 //,DRPS_NextStartTime,DRPS_RemainTime,DRPS_UseQueueNumber,DRPS_OccupyTimeOfOneExam
   	 &sql(update DHCRBC_ResSchdule (DRPS_AutoUseNumber,DRPS_RemainNumber,DRPS_UseNumber)
                          values (:updateAutoUseNumber,:updateRemainNumber,:updateUseNumber) where  DRPS_RowID=:resSchduleID)  
 

     if ($g(SQLCODE))
     {
		q $g(SQLCODE)
     }

    //TCOMMIT  

    s ret=##class(RISService.InvokeRISService).InsertStudyInfoCacheWS(bookNo,"B")   
 	s ^DHCRisTemp("bookToRis4",$g(bookNo))=bookNo_"^"_"B"_"^"_ret
   
    q "SUCCESS"
}

/// 功能:服务台取消预约
/// 作者:wf
/// 日期:20170620
/// w ##class(web.DHCRisPlatBook).CancelBook(^TempDHCRis("Book"))
ClassMethod CancelBook(orderlist As %String, operatDoc As %String, reason As %String) As %String
{
	n (orderlist,operatDoc,reason)
	s ^DHCRisPlatTemp("CancelBook")=$lb(orderlist,operatDoc,reason)
	
	Set $ZT="CancelBookError"	

	
	//加锁和事务
	lock +(^DHCRisTempBook)
	TSTART
	
	s cancelRet=""
	for i=1:1:$l(orderlist,"@")
	{
		s orderRowid=$p(orderlist,"@",i)
		if (orderRowid="")
		{
			continue
		}
		//判断是否登记
	    s regRowid=$o(^DHCPACRegInfoi("OEORI",orderRowid,""))
	    if (regRowid'="")
	    {
		    continue
	    }
		s cancelRet=..deleteBookData(orderRowid,operatDoc,reason)
		//一个不成功就退出
		if (cancelRet'="SUCCESS")
		{
			quit
		}
		
	}
	
	lock -(^DHCRisTempBook)
 	if (cancelRet'="SUCCESS")
 	{ 	
		TRollBack
		q cancelRet
 	}
 	
 	TCommit
	q "SUCCESS"
 
CancelBookError  
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTempBook)
 	s ^DHCRisPlatError("CancelBook",orderlist)=$g(Info)_"****"_ErrorMsg
 	q "ERROR^"_ErrorMsg
}

/// 函数：AutoBooked 
/// 功能：自动预约，返回预约日期、时间以及注意事项 
/// 参数： StartDate 开始预约日期 （数字） , StartTime 开始预约时间（数字）,OherParam: 是否发送消息标记（不等于HIS,则发送消息）
/// 返回：(BookType^flag^资源Code^资源描述^预约日期^预约时间^预约日期时间的描述$预约地点$检查地点^检查须知^划价地点^设备地点) 
///                 flag-0:自动预约失败，1 自动预约成功   
/// BookType: 1 自动预约  ,2 服务台预约 ,3 无需预约
/// w ##class(web.DHCRisPlatBook).AutoBook("293||86",+$h,$p($h,",",2),"")
ClassMethod AutoBook(OrderItemRowid As %String, StartDate As %Integer, StartTime As %Integer, OherParam As %String = "") As %String
{
	n (OrderItemRowid,StartDate,StartTime,OherParam)
	
	s ^DHCRisPlatTemp("AutoBook")=$lb(OrderItemRowid,StartDate,StartTime,OherParam)
	
	//s retInfo=..GetSendInfoToCharge(OrderItemRowid)
	//q retInfo
	
	s orderRowid=$p(OrderItemRowid,"||",1)
	s itemSubRowid=$p(OrderItemRowid,"||",2)
	
	;判断计费状态
	s billed=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",5)
	//w !,billed
	/*
	if ($g(billed)'="P")
	{
		s retInfo=..GetSendInfoToCharge(OrderItemRowid)
		q retInfo
	}
	*/
	
	s recLocRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",6)
	
	//不是超声的调用 原来的 autobook函数
	//d ##class(web.DHCRisScheduleConditon).AutoBooked()
	

	
	//查找本次就诊的所有超声检查
	/*
	s numOfOrderList=0
	s orderList=""
	s admRowid=$p(^OEORD(orderRowid),"^",1)
	s orderRowidFind="" f  s orderRowidFind=$o(^OEORD(0,"Adm",admRowid,orderRowidFind)) q:(orderRowidFind="")  d
	.s itemSubFind=0 f  s itemSubFind=$o(^OEORD(orderRowidFind,"I",itemSubFind)) q:(itemSubFind="")  d
	..s orderItemRowidFind=orderRowidFind_"||"_itemSubFind
	..s recLocFind=$p($g(^OEORD(orderRowidFind,"I",itemSubFind,3)),"^",6)
	..q:(recLocFind'=recLocRowid)   ;不同科室的退出
	..s ItemMastDr=$p($g(^OEORD(orderRowidFind,"I",itemSubFind,1)),"^",2)
    ..q:(ItemMastDr="")
    ..s ServerMaterial=$p($g(^ARCIM($p(ItemMastDr,"||",1),$p(ItemMastDr,"||",2),7)),"^",6)
    ..q:(ServerMaterial'="Service")&(ServerMaterial'="S")
    ..;过滤掉执行、停止和未激活的医嘱  
    ..s ItemStatDR=$p(^OEORD(orderRowidFind,"I",itemSubFind,1),"^",13)
    ..i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ..q:((ItemStatusCode="D")||(ItemStatusCode="I"))
    ..;取价格
    ..s price=##class(web.DHCRisPlatCommonBusiness).GetItemPrice(orderRowidFind,itemSubFind)
    ..if OrderItemRowid=orderItemRowidFind d
    ...s priceOrderIn=price
    ..s numOfOrderList=numOfOrderList+1
    ..i $d(orderList(price)) d
    ...s orderList(price)=orderList(price)_"@"_orderItemRowidFind
    ..e  d
    ...s orderList(price)=orderItemRowidFind
    */
    
	//获取部位列表
	s bodyInfo=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OrderItemRowid)
	
	s bodyList=""
	s numOfBody=$L(bodyInfo,"^")
	for j=1:1:numOfBody
	{
		s bodypart=$p($g(bodyInfo),"^",j)
		s bodyRowid=$p($g(bodypart),":",1)
		if (bodyRowid'="")
		{
			if bodyList=""
			{
				s bodyList=bodyRowid
			}
			else
			{
				s bodyList=bodyList_","_bodyRowid
			}
		}
	}
	
	if (bodyList'="")
	{
		s orderBodyList=OrderItemRowid_"$"_bodyList
	}
	else
	{
		s orderBodyList=OrderItemRowid 
	}
	
	Set $ZT="autoBookError"
	//加锁和事务
	lock +(^DHCRisTempBook)
	
	
	//已经预约直接返回
	s hasBook=##class(web.DHCRisPlatCommonBusiness).hasBookOrder(orderBodyList)
	b //hasBook
	if ($p(hasBook,"^",1)="Y")
	{
		s bookDetailRowid=$p(hasBook,"^",2)
		if (bookDetailRowid'="")
		{
			lock -(^DHCRisTempBook)
			s retInfo=..GetSendInfoToCharge(orderBodyList)
			q retInfo
		}
	}
	
	TSTART
	
	
	//获取最近的资源
	b //03
	s resSchduleRowidCanUse=..GetCurrentBookRes(orderBodyList,StartDate,StartTime)
	b //04
	if (resSchduleRowidCanUse'="")
	{
		s bookRet=..InsertBookData(orderBodyList,resSchduleRowidCanUse,"2","")
		//q:(bookRet'="SUCCESS")
	}

	
			
	lock -(^DHCRisTempBook)
	if ($g(bookRet)'="SUCCESS")
	{
		TRollBack
		
	}
	else
	{
		TCommit
	}
	
	//获取返回参数
	s retInfo=..GetSendInfoToCharge(orderBodyList)
	q retInfo


autoBookError
	b //06
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK
 	lock -(^DHCRisTempBook)
 	s ^DHCRisPlatError("autobook",OrderItemRowid)=ErrorMsg

	q ""
}

ClassMethod GetSendInfoToCharge(orderBodyList As %String) As %String
{
	n (orderBodyList)
	Set $ZT="getSendInfo"
	s orderItemRowid=$p(orderBodyList,"$",1)
	s orderRowid=$p(orderItemRowid,"||",1)
	s itemSubRowid=$p(orderItemRowid,"||",2)
	s ItemMastRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",2)
	s recLocRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",6)
	
	//其他必要信息
	s (locAddress,bookAddress,feeAddress)=""
	i recLocRowid'="" d 
	.s recLocName=$p(^CTLOC(recLocRowid),"^",2)
	.i $l(recLocName,"-")>1 s recLocName=$p(recLocName,"-",2)
	.s addressInfo=..GetAddress(recLocRowid)
	.i addressInfo'="" d
	..s locAddress=$p(addressInfo,"^",1)       ; 科室的物理位置
	..s bookAddress=$p(addressInfo,"^",2)    ;预约位置
	..s feeAddress=$p(addressInfo,"^",3)       ;划价位置
	
	//是否是超声
	s isCs=""
	
	s AppMemo=##class(web.DHCRisPlatCommonBusiness).GetAppMemo(ItemMastRowid)  ;N-提示到服务台打须知 
	b //01
	
	s retInfo=""
	//判断是否预约
	//s bookDetailRowid=##class(web.DHCRisPlatCommonBusiness).GetBookDetailRowid(orderRowid,itemSubRowid)
	s hasBook=##class(web.DHCRisPlatCommonBusiness).hasBookOrder(orderBodyList)
	if ($p(hasBook,"^",1)="Y")
	{
		s bookDetailRowid=$p(hasBook,"^",2)
		if (bookDetailRowid'="")
		{
			s resScheduleID=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",2)
	       	i (resScheduleID'="")
	       	{
	       		s ResouceId=$p(^DHCRBCResourceSchdule(resScheduleID),"^",1)
	       		s ResourceDesc="",ResourceCode=""
	       		i ResouceId'="" d
	       		.s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
	       		.i EqId'="" d
	       		..s resourceDesc=$p(^RBC("EQ",EqId),"^",2) 
	       		..s resourceCode=$p($g(^RBC("EQ",EqId)),"^",1)
	       		..;s equipmentAddressId=$o(^DHCRBCEquipmentAddressi(EqId,""))
	       		..;i equipmentAddressId'="" d
	       		..;.s equipmentAddress=$p(^DHCRBCEquipmentAddress(equipmentAddressId),"^",2)

	       
	       		s scheduleDate=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",23)  //$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",2)
	       		i scheduleDate'="" s bookDate=$zd(scheduleDate,3)
	       		s scheduleSTime=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",18)  //$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",5)
	       		s scheduleETime=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",19) 
	       		if (scheduleSTime<43200)
	       		{
		       		s strSchduleSTime=$zt(scheduleSTime,2)
		       		s strSchduleTime="上午"_" "_$zt(scheduleSTime,2)_"-"_$zt(scheduleETime,2)
	       		}
	       		else
	       		{
		       		s strSchduleSTime=$zt(scheduleSTime,2)
		       		s strSchduleTime="下午"_" "_$zt(scheduleSTime,2)_"-"_$zt(scheduleETime,2)
	       		}

	       		s eqLocation=##class(web.DHCRisPlatCommonBusiness).GetEqAddress(ResouceId)
	 
	       		
	       		//BookedNote
	       		i (scheduleDate=+$h)
	       		{
		       		s BookedNote="请您今天"_strSchduleSTime_",到"_recLocName_"等候报到"_"."_"$"_bookAddress_"$"_locAddress_bookAddress
	       		}
	       		else
	       		{
		       		s BookedNote="请您"_bookDate_" "_strSchduleSTime_",到"_recLocName_"等候报到"_"."_"$"_bookAddress_"$"_locAddress_bookAddress
	       		}
				
	       		s retInfo="1^1^"_resourceCode_"^"_resourceDesc_"^"_bookDate_"^"_$g(strSchduleTime)_"^"_$g(BookedNote)_"^"_$g(AppMemo)_"^"_$g(feeAddress)_"^"_eqLocation_"^"_isCs
	       	}
	       	
	       	
		}
	}
	else
	{
		//s retInfo="1^0^^^^^请您到"_recLocName_"预约"_"。$"_bookAddress_" $"_locAddress_"^"_AppMemo_"^"_feeAddress_"^^Y"
		
		if ( recLocRowid = "317")
		{
			s retInfo="1^0^^^^^请咨询国际部门诊护士站"_"$"_bookAddress_" $"_locAddress_"^"_AppMemo_"^"_feeAddress_"^^"_isCs
		}
		else
		{
			b 
			s retInfo="1^0^^^^^请您到"_locAddress_"("_bookAddress_")"_"预约"_"。$"_bookAddress_" $"_locAddress_"^"_AppMemo_"^"_feeAddress_"^^"_isCs
			b //02
		}
	}
	
	s ^DHCRisPlatTemp("autobookret",orderItemRowid)=retInfo
	q retInfo
getSendInfo
	b //error  GetSendInfoToCharge
	Set ErrorMsg=$ZE
	s ^DHCRisPlatError("getSendInfo",orderItemRowid)=ErrorMsg
	q ""
}

ClassMethod GetCurrentBookRes(orderBodyList As %String, startDate As %Integer, bookTime As %Integer, excludeBookDate As %String = "") As %String
{
	n (orderBodyList,excludeBookDate,startDate,bookTime)
	
	
	;判断是否是自动预约项目 、空腹
	s isAutoBook=##class(web.DHCRisPlatCommonBusiness).isAutoBook(orderBodyList)
 	q:(isAutoBook'="Y") ""
	
	//s itmMastRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
	//s itemBookPropertyRowid=$o(^DHCRBCItemBookProperTypei(itmMastRowid,0))
	//s appointMethodID=$p(^DHCRBCItemBookProperty(itemBookPropertyRowid),"^",2)
   	//i appointMethodID'="" s appointMethodDesc=$p(^DHCRBCAppointMethod(appointMethodID),"^",2)

	;是否憋尿
	s orderItemRowid=$p(orderBodyList,"$",1)
	s isHold=""

   	
   	//s isEmpty=$p(^DHCRBCItemBookProperty(itemBookPropertyRowid),"^",4)
   	s isEmpty=##class(web.DHCRisResApptSchudleSystem).needEmpty(orderBodyList)

   	s recLocRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),3)),"^",6)
   	;获取服务组
   	//s getServiceGroup=##class(web.DHCRisPlatCommonBusiness).GetServiceGroup(itmMastRowid)
   	//s serviceGroupList=$p(getServiceGroup,"^",1)
   	s serviceGroupList=##class(web.DHCRisPlatCommonBusiness).GetSameServiceGroup(orderBodyList)
   	//for k=1:1:$l(serviceGroupList,",")
   	b //05
   	s currentDate=+$h
   	s currentTime=$p($h,",",2)
   	
   	//根据最大可预约日期预约
	s endDate=+$h+14
   	
   
 
   	s useResSchdule=""
   	for date=startDate:1:endDate
   	{
	   	q:(useResSchdule'="")
	   	if (date<+$h)
	   	{
		   	continue
	   	}
	   	
	   	s startTime="" 
	   	s earlyTime=""
	   	for
	   	{
		   	s startTime=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",date,startTime))
		   	q:(startTime="")
			//q:(useResSchdule'="")
			//空腹的只能上午
			if ((isEmpty="Y")&&(startTime>43200))
			{
				continue
			}

			s radio=1
			
	   		for k=1:1:$l(serviceGroupList,"^")
		   	{
			   	s serviceGroup=$p(serviceGroupList,"^",k)
			   	if (serviceGroup="")
			   	{
				   	continue
			   	}
		   		s resRowid=""
		   		for
		   		{
			   		s resRowid=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",date,startTime,serviceGroup,resRowid))
			   		q:(resRowid="")
			   		
			   		//申请科室过滤
			   		/*
			   		s isCanUseByAppLoc=..IsUseResbyAppLoc(orderItemRowid,resRowid)
			   		if ( isCanUseByAppLoc="N" )
			   		{
				   		continue
			   		}
			   		*/
			   		s resSchduleRowid=""
			   		for
			   		{
				   		s resSchduleRowid=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",date,startTime,serviceGroup,resRowid,resSchduleRowid)) 
				   		q:(resSchduleRowid="")
				   		
				   		b //122
				   		s resourceFind=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",1)
				   		s resourceInLoc=$p(^RB("RES",resourceFind),"^",1)
				   		if (recLocRowid'=resourceInLoc)
				   		{
					   		continue
				   		}
				   		
				   		
				   		s chargeTime=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",14)
				   		s endTime=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",6)
				   		
				   		s autoNum=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",8)
				   		s maxNum=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",7)
				   		s remainNum=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",10)
				   		s useNum=+$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",9)
				   		s auotUserNumber=$p(^DHCRBCResourceSchdule(resSchduleRowid),"^",13)
				   		if remainNum="" s remainNum=maxNum

				   		if (maxNum<=0)
				   		{
					   		continue
				   		}
				   		
				   		if (autoNum<=0)
				   		{
					   		continue
				   		}
				   		
				   		//当天超过收费时间，继续
				   		if ((date=+$h)&&($p($h,",",2)>chargeTime))
				   		{
					   		continue
				   		}
				   		
				   		s currentRadio=$fn(useNum/maxNum,"",3)

			   			if ((currentRadio<radio)&&((earlyTime=startTime)||(earlyTime="")))
			   			{
				   			b //001
				   			s useResSchdule=resSchduleRowid
				   			s radio=currentRadio
				   			s earlyTime=startTime
			   			}
			   			
			   		
			   		}  //end resSchduleRowid			   		
		   		} // end resRowid
		   	} // end servicegroup		   
	   	} // end time
   	} // end date
   	
   	q useResSchdule
}

// do ##class(web.DHCRisPlatBook).GetAddress("632")

ClassMethod GetAddress(LocDR As %String) As %String
{
	n (LocDR)
	q:(LocDR="") ""
	
	s (Location ,AppLocation,InputFee,Rowid)=""
	s (Info)=""
	
	s Rowid=$o(^DHCRBCLocationi("Rec-LocDR",LocDR,0))
	i Rowid'="" d
	.s Location=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",2)
    .s AppLocation=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",3)
    .s InputFee=$p($g(^DHCRBCLocation("LOCATION",Rowid)),"^",4)
    .s Info=Location_"^"_AppLocation_"^"_InputFee
    
    q Info
}

/// ////////////////////////////////////////////////////////////////////////
/// w ##class(web.DHCRisPlatBook).GetBookedPrint("19885920||502")
ClassMethod GetBookedPrint(OrditemRowid As %String) As %String
{
	s (RegNo,Name,GetAppLoc,RecLoc,RecLocAdress,BookedDate,BooketTime,BookEndTime,EQDR,ordName,GetMemo,ResDesc,MedicareNo,bedName,wardDesc,EQAddress)=""
	s OrderRowid=$p(OrditemRowid,"||",1)
    s ItemRowid=$p(OrditemRowid,"||",2)
    s AppLocDR=$p($g(^OEORD(OrderRowid,"I",ItemRowid,1)),"^",3)
    i AppLocDR'="" d
    .s GetAppLoc=$p(^CTLOC(AppLocDR),"^",2)
    .i $f(GetAppLoc,"-")>0 d
    ..s GetAppLoc=$p(GetAppLoc,"-",2)
    s pri=##class(web.DHCRisPlatCommonBusiness).GetItemPrice(OrderRowid,ItemRowid)
    s price=$fn(pri,"",2)
    ;s ordName1=##class(web.DHCRisCommFunctionEx).getOrderItemDesc(OrditemRowid)
    s ordName1=##class(web.DHCRisPlatCommonBusiness).GetAppItemName(OrditemRowid)
	s ordName=$EXTRACT(ordName1,1,10)_$c(13,10)_$e(ordName1,11,30)
	s paadmdr=$p($g(^OEORD(OrderRowid)),"^",1)
	i (paadmdr'="")
	{
		s InLocdr=$p(^PAADM(paadmdr),"^",4)
		i $g(InLocdr)'="" d
        .s InLocName=$p(^CTLOC(InLocdr),"^",2)
        .i $f(InLocName,"-")>0 d
        ..s InLocName=$p(InLocName,"-",2)
        
	    s patienttype=$p(^PAADM(paadmdr),"^",2)
	    if (patienttype="I")
		{
		s ipRoomDr=$p($g(^PAADM(paadmdr)),"^",69)
		i ipRoomDr'="" s ipRoomDesc=$p($g(^PAROOM(ipRoomDr)),"^",2)
		s wardRowid=$p($g(^PAADM(paadmdr)),"^",70)
		i (wardRowid'="")
		{
			s wardDesc=$p($g(^PAWARD(wardRowid)),"^",2)
			if $f(wardDesc,"-")>0
			{
				s GetAppLoc=$p(wardDesc,"-",2)
			}
		}
		s bedRowid=$p($g(^PAADM(paadmdr)),"^",73)
		if (bedRowid'="")
		{
			s wardRowid=$p(bedRowid,"||",1)
			s bedChildSub=$p(bedRowid,"||",2)
			i bedChildSub'="" s bedName=$p($g(^PAWARD(wardRowid,"BED",bedChildSub)),"^",1)			
		}
		}
	    s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
	    i (papatmasmdr'="")
	    {
		    s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
		    s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
		    s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(paadmdr,patienttype,.ErrMsg)
		    s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)       
			i DOB="" d
			.s strDOB=""
			.s strAge=""
			e  d
			.s strDOB=$ZD(DOB,3)
			.s strToday=$ZD(+$h,3)
			.s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
			s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
    		i SexDr'="" s SexDesc=$p(^CT("SEX",SexDr),"^",2)
	    }
        
	}
	
	if ((OrderRowid'="")&(ItemRowid'=""))
	{
		s RecLocdr=$p(^OEORD(OrderRowid,"I",ItemRowid,3),"^",6)
		if RecLocdr'="" d
		.s RecLoc=$p(^CTLOC(RecLocdr),"^",2)
		.s ReclocID=$O(^DHCRBCLocationi("Rec-LocDR",RecLocdr,0))
		.s RecLocAdress=$p(^DHCRBCLocation("LOCATION",ReclocID),"^",2)
		.s LocName=$p(^DHCRBCLocation("LOCATION",ReclocID),"^",3)
		.i $f(RecLoc,"-")>0 d
		..s RecLoc=$p(RecLoc,"-",2)
	}
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,OrditemRowid,0)) 
	s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
	s resID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",24)
	s EQDR=$p($g(^RB("RES",resID)),"^",3)
	s ResDesc=$p($g(^RBC("EQ",EQDR)),"^",2)
	;w !,"ResDesc="_ResDesc
	s EQAddress=##class(web.DHCRisResourceApptSchudle).GetEQADD(resID)
	;w !,"ResSchduleID="_EQAddress
	s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
    i Date'="" s BookedDate=$zd(Date,3)
    s YEAR=$P(BookedDate,"-",1)
    s Mouth=$P(BookedDate,"-",2)
    s DAY=$P(BookedDate,"-",3)
    S BookDay=YEAR_"年"_Mouth_"月"_DAY_"日"
    s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
    i StartTime'="" d 
    .i StartTime<43200 d 
	..s BooketTime="上午"_$zt(StartTime,2)
	.e  d 			
	..s BooketTime="下午"_$zt(StartTime,2)	
    s EndTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
    i EndTime'="" s BookEndTime=$zt(EndTime,2)
	s Memo=##class(web.DHCRisResourceApptSchudle).GetMemo(OrditemRowid)
	s Memo=..replaceString(Memo,$c(13),"")
	s Memo=..replaceString(Memo,$c(10),"")
	s num=$fn($l(Memo)/12,"",0)
	if num=0 
	{
		s GetMemo=Memo
	}
	else
	{
		s GetMemo=$e(Memo,1,12)
		for i=1:1:num
		{
			if (i=num)
			{
				s GetMemo=GetMemo_$c(13,10)_$e(Memo,i*12+1,$l(Memo))
			}
			else
			{  
				s GetMemo=GetMemo_$c(13,10)_$e(Memo,i*12+1,(i+1)*12)
			}
		}
	}
	s Info=RegNo_"^"_Name_"^"_MedicareNo_"^"_GetAppLoc_"^"_RecLoc_"^"_RecLocAdress_"^"_BookDay_"^"_BooketTime_"^"_BookEndTime_"^"_ordName_"^"_GetMemo_"^"_bedName_"^"_LocName_"^"_price_"^"_EQAddress_"^"_ResDesc_"^"_$g(patienttype)_"^"_$g(strAge)_"^"_$g(SexDesc)
	
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

/// 函数名称:IsUseResbyAppLoc
/// 功能:申请科室使用设备设置
/// 输入参数:OEorditem , RessourceID
/// 作者: wf
/// d ##class(web.DHCRisPlatBook).IsUseResbyAppLoc("3||108","1381")
ClassMethod IsUseResbyAppLoc(OEorditem As %String, RessourceDR As %String) As %String
{
	n (OEorditem,RessourceDR)
	s ^DHCRisTemp("IsUseResbyAppLoc")=OEorditem_"^"_RessourceDR
	s canUse="Y"
	q:((OEorditem="") || (RessourceDR="")) canUse
	
	//查询医嘱接收科室和申请科室
	s (recLocGet,appLocGet)=""
	for len1=1:1:$l(OEorditem,"@")
	{
		s orderbodyGet=$p(OEorditem,"@",len1)
		s orderRowidGet=$p(orderbodyGet,"$",1)
		if (orderRowidGet'="")
		{
			s appLoc1=$p(^OEORD($p(orderRowidGet,"||",1),"I",$p(orderRowidGet,"||",2),1),"^",3)
			s recLoc1=$p(^OEORD($p(orderRowidGet,"||",1),"I",$p(orderRowidGet,"||",2),3),"^",6)
			if (appLocGet'="")
			{
				if ( ##class(web.DHCRisPlatCommon).isExistInGroup(appLocGet,appLoc1)=0)
				{
					s appLocGet=appLocGet_"^"_appLoc1
				}
			}
			else
			{
				s appLocGet=appLoc1
			}				
		}
	    
	}
	
	s numOfRes=""
	&sql(select count(*) into :numOfRes from DHCRBC_ResourceInAppLoc where DRIL_Resource_DR=:RessourceDR )
	//设备没有配置申请科室，所有科室均可以检查
	q:(numOfRes=0) canUse 
	
	for numOfAppLoc=1:1:$l(appLocGet,"^")
	{
		q:(canUse="N")
		s appLocDr=$p(appLocGet,"^",numOfAppLoc)
		if ( appLocDr'="" )
		{
			s ResAppRowid=$o(^DHCRBCResourceInAppLoci("APPLOC",appLocDr,RessourceDR,0))
    		i ResAppRowid="" s canUse="N"
		}
	}
	
	q canUse
}

/// d ##class(%ResultSet).RunQuery("web.DHCRisPlatBook","QueryExternalAddItem")
Query QueryExternalAddItem() As %Query(ROWSPEC = "ItemDesc:%String,ItemRowid:%String,QueueDesc:%String,QueueCode:%String")
{
}

ClassMethod QueryExternalAddItemExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	s ind=1
	
	s externalAddItemRowid=""
	for
	{
		s externalAddItemRowid=$o(^DHCRISExternalAddItem(externalAddItemRowid))
		q:(externalAddItemRowid="")
		s arcItemCode=$p(^DHCRISExternalAddItem(externalAddItemRowid),"^",1)
		s arcItemRowid=$p(^DHCRISExternalAddItem(externalAddItemRowid),"^",2)
		s bookQueueCode=$p(^DHCRISExternalAddItem(externalAddItemRowid),"^",3)
		s bookQueueRowid=$p(^DHCRISExternalAddItem(externalAddItemRowid),"^",4)
		s bookQueueDesc=$p(^DHCRISBookQueue(bookQueueRowid),"^",1)
		s arcItemDesc=$p(^ARCIM($p(arcItemRowid,"||",1),$p(arcItemRowid,"||",2),1),"^",2)
		do OutExternalAddItem
	}
	
    
    

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutExternalAddItem
    //"ordId:%String,bDate:%String,res:%String,bTime:%String,sTime:%String,eTime:%String,name:%String,sex:%String,age:%String,ordDesc:%String,patNo:%String,status:%String,opUser:%String,opDate:%String"
  	set Data=$lb(arcItemDesc,arcItemRowid,bookQueueDesc,bookQueueCode)
  	Set ^CacheTemp(repid,ind)=Data
  	Set ind=ind+1
	
	quit
}

ClassMethod QueryExternalAddItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExternalAddItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryExternalAddItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExternalAddItemExecute ]
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

/// 增加预约队列
/// w ##class(web.DHCRisPlatBook).AddBookResSchedule()
ClassMethod AddBookResSchedule(Info As %String) As %String
{
	n (Info)
	s ^DHCRisPlatTemp("AddBookResSchedule")=Info
	s num=$p(Info,"^",1)
	s itemList=$p(Info,"^",2)
	s bookQueue=$p(Info,"^",3)
	s currentDate=+$h
	
	s currentTime=$p($h,",",2)
	s (startTime,endTime,chargeTime)=""
	if (currentTime<$zth("12:00:00",1) )
	{
		s startTime=$zth("11:00:00",1)
		s endTime=$zth("11:30:00",1)
		s chargeTime=$zth("11:30:00",1)
	}
	else
	{
		s startTime=$zth("15:30:00",1)
		s endTime=$zth("16:00:00",1)
		s chargeTime=$zth("16:00:00",1)
	}
	
	//获取设备和服务组
	s bookQueueRowid=$o(^DHCRISBookQueuei("desc",bookQueue,""))
	if (bookQueueRowid'="")
	{
		s resourceRowid=$p(^DHCRISBookQueue(bookQueueRowid),"^",4)
		s locId=$p(^DHCRISBookQueue(bookQueueRowid),"^",8)
	}
	s serviceGroupRowid=$o(^RBC("SG",0,"Desc",$$ALPHAUP^SSUTIL4(bookQueue),""))
	
	b //01
	if ((serviceGroupRowid'="") &&($g(resourceRowid)'="")&&($g(locId)'="")&&(startTime'=""))
	{
		s resSchduleRowid=$o(^DHCRBCResSchdulei("Date-Time-ServiceRes",currentDate,startTime,serviceGroupRowid,resourceRowid,""))
		b //02
		if (resSchduleRowid="")
		{
			&sql(insert into DHCRBC_ResSchdule (DRPS_Date,DRPS_LocID,DRPS_RessourceID,DRPS_ServiceGroupID,DRPS_StartTime,DRPS_EndTime,DRPS_MaxNumber,DRPS_AutoNumber, DRPS_ChargeTime) 
     							values(:currentDate,:locId,:resourceRowid,:serviceGroupRowid,:startTime,:endTime,:num,:num,:chargeTime))
     		s resSchduleRowid=$p(%ROWID,$c(1))
     		for i=1:1:$l(itemList,"@")
     		{
	     		s itemRowid=$p(itemList,"@",i)
	     		s ^DHCRisPlatBookAddSchedule(currentDate,resourceRowid,startTime,itemRowid)=""
	     		s ^DHCRisPlatBookAddSchedule("add",resSchduleRowid)=""
     		}
		}
	}
	
	q $g(SQLCODE)
}

/// w ##class(web.DHCRisPlatBook).getBookInfo("959||69")
/// 函数:GetBookedPrintData
/// wf 获取预约打印信息 
ClassMethod getBookInfo(OrderItemRowid As %String) As %String
{

	s ^TempDHCRisWf("getBookInfo")=OrderItemRowid
    q:(OrderItemRowid="") ""
    
    s retInfo=""
    //获取部位
	s orderBodyList=""
	s bodyList=##class(web.DHCRisPlatCommonBusiness).GetBodyList(OrderItemRowid)
	if (bodyList'="")
	{
		s orderBodyList=OrderItemRowid_"$"_bodyList
	}
	else
	{
		s orderBodyList=OrderItemRowid
	}
	
	;b //01
	s hasBook=##class(web.DHCRisPlatCommonBusiness).hasBookOrder(orderBodyList)

	if ($p(hasBook,"^",1)="Y")
	{
		s ResDetailRowid=##class(web.DHCRisResourceApptSchudle).getBookDetailID(orderBodyList)
		if (ResDetailRowid'="")
		{
			s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",ResDetailRowid),"^",2)
       
       		i (ResSchduleID'="") 
       		{
	       		s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
       			i Date'="" s BookedDate=$zd(Date,3)
       			s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
       			i StartTime'="" s BooketTime=$zt(StartTime,2)
       			s EndTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",6) 
       			i EndTime'="" s BookEndTime=$zt(EndTime,2)
       			s retInfo=$g(BookedDate)_"^"_$g(BooketTime)_"^"_$g(BookEndTime)
       		}
       
		}
	}
		
    q retInfo
}

/// 判断患者预约是否有时间冲突
/// 20180322 wf
/// w ##class(web.DHCRisPlatBook).BookedConflict("19987740||5","390867")
ClassMethod BookedConflict(orderItemRowidIn As %String, resSchduleRowidIn As %String) As %String
{
 	n (orderItemRowidIn,resSchduleRowidIn)
 	s ^DHCRisTemp("BookedConflict")=$lb(orderItemRowidIn,resSchduleRowidIn)
 	
 	if ((orderItemRowidIn="")||(resSchduleRowidIn=""))
 	{
	 	quit ""
	}
	
 	/*****************************************
 	
 		是否需要时间冲突提醒(是一个配置还是分科室配置)？
 		同接收科室是否提醒，同接收科室不同设备是否提醒？
 		后期是不是可以加入检查项目关系来控制是否提醒？
 		  
 	******************************************/
 	
 	//选择的预约日期和时间
	s resourceRowidIn=$p(^DHCRBCResourceSchdule(resSchduleRowidIn),"^",1)
	s dateSel=$p(^DHCRBCResourceSchdule(resSchduleRowidIn),"^",2)
	s startTimeSel=$p(^DHCRBCResourceSchdule(resSchduleRowidIn),"^",5)
	s endTimeSel=$p(^DHCRBCResourceSchdule(resSchduleRowidIn),"^",6)
	
	//
	s orderItemRowidIn=$p(orderItemRowidIn,"@",1)
	s orderItemRowidIn=$p(orderItemRowidIn,"$",1)
	s orderRowidIn=$p(orderItemRowidIn,"||",1)
	s itemSubRowid=$p(orderItemRowidIn,"||",2)
	s recLocRowid=$p($g(^OEORD(orderRowidIn,"I",itemSubRowid,3)),"^",6)
	s admRowid=$p($g(^OEORD(orderRowidIn)),"^",1)
	s patMasRowid=$p($g(^PAADM(admRowid)),"^",1)
	//s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)
	s retInfo=""
	
	s paadmtype="" f  s paadmtype=$o(^PAPERdr(patMasRowid,"ADM",paadmtype)) q:paadmtype=""  d
	.s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(patMasRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
	..s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
	...s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
	....s (oeorditemdr,recLoc,ItemMastDr,ServerMaterial,OrdDate)=""
	....s oeorditemdr=OrderRowid_"||"_itemsub
	....s ItemMastDr=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
    ....q:(ItemMastDr="")
    ....;过滤非检查医嘱
    ....s ServerMaterial=$p($g(^ARCIM($p(ItemMastDr,"||",1),$p(ItemMastDr,"||",2),7)),"^",6)
    ....q:(ServerMaterial'="Service")&(ServerMaterial'="S")
    ....;过滤掉执行、停止和未激活的医嘱  
    ....s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
    ....i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ....q:((ItemStatusCode="D")||(ItemStatusCode="U")||(ItemStatusCode="C")||(ItemStatusCode="I"))
	....s bodyInfo=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(oeorditemdr)
	....s numOfBody=$L(bodyInfo,"^")
	....for j=1:1:numOfBody d 
	.....s bodypart=$p($g(bodyInfo),"^",j)
	.....s bodyRowid=$p($g(bodypart),":",1)
    .....;过滤已登记检查
    .....s regRowid=##class(web.DHCRisPlatCommonBusiness).getRegRowid(oeorditemdr,bodyRowid) //$o(^DHCPACRegInfoi("OEORI",oeorditemdr,0))
	.....q:regRowid'=""
	.....s resDetailRowid=##class(web.DHCRisPlatCommonBusiness).GetBookDetailRowid(OrderRowid,itemsub,bodyRowid) //$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,""))
	.....q:resDetailRowid=""
	.....s resScheduleRowid=$p($g(^DHCRBCResSchduleDetail("Detail",resDetailRowid)),"^",2)
    .....s resourceRowid=$p($g(^DHCRBCResourceSchdule(resScheduleRowid)),"^",1)
    .....s bookDate=$p($g(^DHCRBCResourceSchdule(resScheduleRowid)),"^",2)
    .....q:(dateSel'=bookDate)
    .....s startTime=$p($g(^DHCRBCResourceSchdule(resScheduleRowid)),"^",5)
    .....s endTime=$p($g(^DHCRBCResourceSchdule(resScheduleRowid)),"^",6)
    .....q:((startTime>=endTimeSel)||(startTimeSel>=endTime))
    .....s strBookDate=$zd(bookDate,3)
    .....s strBookTime=$zt(startTime,2)_"-"_$zt(endTime,2)
    .....s strOrderName=$p(^ARCIM($p(ItemMastDr,"||",1),$p(ItemMastDr,"||",2),1),"^",2)
    .....i bodyRowid'="" d
	......s bodyDesc=$p($g(^DHCAPPART(bodyRowid)),"^",1)
	......s strOrderName=strOrderName_"("_bodyDesc_")"
    .....s equipmentRowid=$p($g(^RB("RES",resourceRowid)),"^",3)
	.....s resourceDesc=$p(^RBC("EQ",equipmentRowid),"^",2)
	.....s recLocRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	.....s ordDate=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",9)
	.....s locDesc=$p(^CTLOC(recLocRowid),"^",2)
	.....i $l(locDesc,"-")>1 s locDesc=$p(locDesc,"-",2)
	.....s conflictInfo=strOrderName_"^"_$zd(ordDate,3)_"^"_locDesc_"^"_strBookDate_"^"_strBookTime_"^"_resourceDesc
	.....i retInfo="" s retInfo=conflictInfo
	.....e  s retInfo=retInfo_"@"_conflictInfo

    q retInfo
}

}
