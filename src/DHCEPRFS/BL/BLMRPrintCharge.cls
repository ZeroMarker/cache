Class DHCEPRFS.BL.BLMRPrintCharge Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	返回当日该患者打印病案未收费记录情况
/// Author：yangpeng 2015.10.27
/// Debug : w ##class( DHCEPRFS.BL.BLMRPrintCharge).GetPrintChargeXML("28")
ClassMethod GetPrintChargeXML(AMREpisodeID As %String) As %String
{
	
	//取得SysOption值 邮寄费和基础费
	
	s MailPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintMailPrice")
	if (MailPrice="") 
		{ s MailPrice=0 }
	s BasicPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintBasePrice")
	if (BasicPrice="")
		{ s BasicPrice=0 }
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	//b "1000"
	set writer=##class(%XML.Writer).%New()	///xml
	
	//取得MRPatientID
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s MRPatientID=objMREpisode.MRPatientID
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
	 
 	set status=writer.OutputToString()
	set status=writer.StartDocument()
 	set status=writer.RootElement("DATA")
 	
	set status=writer.Element("FootDate")
 	set status=writer.WriteChars($zd(nowDate,3))
 	set status=writer.EndElement()
 	
 	//b "1000"
	set status=writer.Element("FootTime")
 	set status=writer.WriteChars($zt(nowTime,1))
 	set status=writer.EndElement()
 	
 	//b "1233"
	set status=writer.Element("MRPatientID")
	//b "MRPatientID"
 	set status=writer.WriteChars(MRPatientID)
 	set status=writer.EndElement() 	
 	//b "1212"
	set status=writer.Element("Name")
 	set status=writer.WriteChars(objMRPatient.Name)
 	set status=writer.EndElement() 	
 	
 	set status=writer.Element("Sex")
 	set status=writer.WriteChars(objMRPatient.Gender)
 	set status=writer.EndElement() 	
 	
 	set status=writer.Element("Birthday")
 	set status=writer.WriteChars($zd(objMRPatient.Birthday,3))
 	set status=writer.EndElement() 	
 	
 	set status=writer.Element("Items")
	
	//b "2000"
	s MinActDate=""		//取最小打印时间
	s TotalAmount=0
	s arrEpisode=##class(%ArrayOfDataTypes).%New()
	//取得MRPatientID对应的所有EpisodeID
	s MREpisodeID=""
	for {	//按照Episodes 循环
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," " _ MRPatientID,MREpisodeID))
		q:(MREpisodeID="")
		//取Episode的MedRecordNO和AdmDate
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s MedRecordNO=objMREpisode.MedRecordNo
		s AdmDate=$case(objMREpisode.AdmDate="",1:"",:$zd(objMREpisode.AdmDate,3))
		
		s MRLogID=""
		s MRLogID=$o(^DHCEPRFS.INST.MRLogI("IdxUnique"," " _ MREpisodeID," ",""))
	
		continue:(MRLogID="")
		//从DHCEPRFS.INST.MRLogDetail 取数据
		s MRLogDetailDetailNum=""	//DetailNum
		s MRLogDetailchildsub="" 	//取childsub
		for { 	//按照LogDetailID 循环
			s MRLogDetailDetailNum=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum))	//取得DetailNum
			q:MRLogDetailDetailNum=""
			//因MRLogID 和 MRLogDetailDetailNum 是Unique，所以单条取childsub
			s MRLogDetailchildsub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum,""))
			q:MRLogDetailchildsub=""
			s objLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(MRLogID _ "||" _ MRLogDetailchildsub)
			
			//是PRINT 并且 当天 并且  不是批量打印
			if ((objLogDetail.MRAction="PRINT") && (objLogDetail.ActDate =nowDate)  && (objLogDetail.Remark'="BATCH"))
			{

				//用有效的objLogDetail.id 在 收费表中查询,是否存在收费记录
				s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeDetI("IdxMRLogDetail"," " _ objLogDetail.%Id(),""))
				
				if (MRPrintChargeID="")	//尚未收费
				{
					if (arrEpisode.Count()=0)	//如果还没有Episode被加入数组，对第一个Episode增加邮寄费
					{
						do InsertItemXML(MREpisodeID,"",MedRecordNO,AdmDate,$zt(objLogDetail.ActTime,1),"10","邮寄费",objLogDetail.%Id(),
							1, MailPrice,MailPrice)
					}
					if (arrEpisode.IsDefined(MREpisodeID)="0")	//如果Episode没有定义在数组中,需要增加一次基础费
					{
						do InsertItemXML(MREpisodeID,"",MedRecordNO,AdmDate,$zt(objLogDetail.ActTime,1),"20","基础费",objLogDetail.%Id(),
							1,BasicPrice,BasicPrice)
						do arrEpisode.SetAt(MREpisodeID,MREpisodeID)
					}
					//增加每次的打印费
					do InsertItemXML(MREpisodeID,"",MedRecordNO,AdmDate,$zt(objLogDetail.ActTime,1),"30","打印费",objLogDetail.%Id(),
							objLogDetail.ActPages,0.5,objLogDetail.ActPages*0.5)
					
					if (MinActDate="")	//获取最小ActTime 
					{	s MinActDate=objLogDetail.ActTime}
					else
					{ 	
						if (objLogDetail.ActTime<MinActDate)
						{	
							s MinActDate=objLogDetail.ActTime 
						}
					}
					
				}
			}
		}
	}
	
	w "end items"
	set status=writer.EndElement() //end items
	
	set status=writer.Element("BeginActDate")
	set status=writer.WriteChars($zd(nowDate,3))
	set status=writer.EndElement()

	set status=writer.Element("BeginActTime")
	set status=writer.WriteChars($zt(MinActDate,1))
	set status=writer.EndElement()

	set status=writer.Element("TotalAmount")
	set status=writer.WriteChars(TotalAmount)
	set status=writer.EndElement()
	
	set status=writer.EndRootElement()
	set status=writer.EndDocument()
	w "GetXMLString"
	q writer.GetXMLString(status)
InsertItemXML(AEpisodeID,AMRMedRecordID,AMedRecordNO,AAdmDate,APrintTime,AChargeTypeCode,AChargeTypeName,AMRLogDetailID,AQuan,APrice,AAmount)

	set status=writer.Element("Item")
	set status=writer.Element("MREpisodeID")
	set status=writer.WriteChars(AEpisodeID)
	set status=writer.EndElement()
	
	set status=writer.Element("MRMedRecordID")
	set status=writer.WriteChars(AMRMedRecordID)
	set status=writer.EndElement()
	
		set status=writer.Element("MedRecordNO")
	set status=writer.WriteChars(AMedRecordNO)
	set status=writer.EndElement()
	
		set status=writer.Element("AdmDate")
	set status=writer.WriteChars(AAdmDate)
	set status=writer.EndElement()
	
	set status=writer.Element("PrintTime")
	set status=writer.WriteChars(APrintTime)
	set status=writer.EndElement()
	
	set status=writer.Element("ChargeTypeCode")
	set status=writer.WriteChars(AChargeTypeCode)
	set status=writer.EndElement() 
	
	set status=writer.Element("ChargeTypeName")
	set status=writer.WriteChars(AChargeTypeName)
	set status=writer.EndElement() 		
	
	set status=writer.Element("MRLogDetailID")
	set status=writer.WriteChars(AMRLogDetailID)
	set status=writer.EndElement() 		
	
	set status=writer.Element("Quan")
	set status=writer.WriteChars(AQuan)
	set status=writer.EndElement() 	
	
	set status=writer.Element("Price")
	set status=writer.WriteChars(APrice)
	set status=writer.EndElement() 
	
	s TotalAmount=TotalAmount +AAmount //处理累计值
	set status=writer.Element("Amount")
	set status=writer.WriteChars(AAmount)
	set status=writer.EndElement()	
	set status=writer.EndElement()				

	quit
}

/// Desc:	保存患者打印病案收费记录
/// Author：yangpeng 2015.11.06
/// Debug : w ##class(DHCEPRFS.BL.BLMRPrintCharge).SavePrintCharge("2015-11-06^15:27:17^17^2015-11-06^14:16:21^19.5^159~28^^14:16:21^10^邮寄费^25||34^1^10^10~28^^14:16:21^20^基础费^25||34^1^8^8~28^^14:16:21^30^打印费^25||34^1^.5^.5~28^^15:26:57^30^打印费^25||35^1^.5^.5~28^^15:27:17^30^打印费^25||36^1^.5^.5~")
ClassMethod SavePrintCharge(AFootString As %String, AFootDate As %String, AFootTime As %String, AMRPatientID As %String, ABeginActDate As %String, ABeginActTime As %String, ATotalAmount As %String, AActUserID As %String) As %String
{
	//FootDate^FootTime^MRPatient^BeginActDate^BeginActTime^TotalAmount^UserID
	s strMain=$p(AFootString,"~",1)
	//MREpisodeID^MRMedRecordID^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID^Quan^Price^Amount 子表数据 from 2行开始
	
	s succeedFlag="true"
	
	TSTART
	s $zt = "OnSavePrintChargeErrorHandler"
	
	s objPrintCharge =##class(DHCEPRFS.INST.MRPrintCharge).%New()
	s objPrintCharge.FootDate=$zdh(AFootDate,3)
	s objPrintCharge.FootTime =$zth(AFootTime,1)
	s objPrintCharge.MRPatientID =AMRPatientID
	s objPrintCharge.BeginActDate=$zdh(ABeginActDate,3)
	s objPrintCharge.BeginActTime=$zth(ABeginActTime,1)
	s objPrintCharge.TotalAmount =ATotalAmount
	s objPrintCharge.ActUserID =AActUserID

	s sc=objPrintCharge.%Save()
	
	if ($$$ISOK(sc))
	{/*do nothing*/}
	else
	{
		TROLLBACK
		s succeedFlag="false"
		q ""
	}
	//MREpisodeID^MRMedRecordID^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID^Quan^Price^Amount
	for i=1:1:$l(AFootString,"~")
	{	
		s strSub=$p(AFootString,"~",i)
		s objPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
		s objPrintChargeDetail.MREpisodeID=$p(strSub,"^",1)
		s objPrintChargeDetail.MRMedRecordID=$p(strSub,"^",2)
		s objPrintChargeDetail.PrintTime=$zth($p(strSub,"^",3),3)
		s objPrintChargeDetail.ChargeTypeCode=$p(strSub,"^",4)
		s objPrintChargeDetail.MRLogDetailID=$p(strSub,"^",6)
		s objPrintChargeDetail.Quan=$p(strSub,"^",7)
		s objPrintChargeDetail.Price=$p(strSub,"^",8)
		s objPrintChargeDetail.Amount=$p(strSub,"^",9)
		s objPrintChargeDetail.DetailNum=i	//序号
		
		s objPrintChargeDetail.TheMRPrintCharge=objPrintCharge
		s sc=objPrintChargeDetail.%Save()
		if ($$$ISOK(sc))
		{/*do nothing*/}
		else
		{
			s succeedFlag="false"
			q 
		}
	}
	if (succeedFlag="true")
	{
		TCOMMIT
		q objPrintCharge.%Id()
	}
	else
	{
		TROLLBACK
		q ""
	}
OnSavePrintChargeErrorHandler
	TROLLBACK
	q ""
}

/// Desc:	按照日期分组查询操作员收费情况 杨鹏 2015.11.9
/// Input：	ABeginDate 	开始日期
/// 		AEndDate 	截止日期
/// 			ARoel 角色 LIST/CHARGE/PRINT
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintChargeGpByUser","2015-11-30","2015-11-30")
/// SQL check:
Query GetPrintChargeGpByUser(ABeginDate As %String, AEndDate As %String, ARole As %String, AUserID As %String = "") As %Query(ROWSPEC = "UserID:%String,UserName:%String,Count:%Integer,MailCount:%Integer,MailAmount:%Float,BasicCount:%Integer,BasicAmount:%Float,PrintCount:%Integer,PrintAmount:%Float,TotalAmount:%Float")
{
}

ClassMethod GetPrintChargeGpByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintChargeGpByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintChargeGpByUserExecute(ByRef qHandle As %Binary, ABeginDate As %String, AEndDate As %String, ARole As %String, AUserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	 //获取操作员同区域人员
 	s arrUsers=##class(DHCEPRFS.BL.BLQueryUser).GetDistrictOperators(AUserID)
 	s AllUsersFlag=arrUsers.IsDefined("ALLUSERS")
 	
	//将日期格式转换为数字
 	s BeginDate = $zdh(ABeginDate,3)
 	s EndDate = $zdh(AEndDate,3)
 	
 	s arr=##class(%ArrayOfObjects).%New()	//存放结果数据
 	
 	//按照时间循环
 	s date=BeginDate-1
 	for {								//日期循环
 		s date=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxFootDate",date))	
 		q:(date="")||(date>EndDate)	//为空或者Date>EndDate结束循环
 		
 		s MRPrintChargeID=""
 		for {				//MRPrintCharge主表循环
	 		s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxFootDate",date,MRPrintChargeID))
	 		q:MRPrintChargeID=""
	 		s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
	 		continue:((objMRPrintCharge.Status="LIST")||(objMRPrintCharge.Status="")||(objMRPrintCharge.Status="CANCEL"))			//只加入收费列表的不计算在内/或为空
	 		
	 		s KEY=""		//用以Key及区别角色
	 		if (ARole="LIST")
	 		{s KEY=objMRPrintCharge.ActUserID}
	 		if (ARole="CHARGE")
	 		{s KEY=objMRPrintCharge.FootUserID}
	 		if (ARole="PRINT")
	 		{s KEY=objMRPrintCharge.PrintUserID}
	 		if (ARole="")	//空默认为打印操作员
	 		{s KEY=objMRPrintCharge.PrintUserID}
	 		continue:(KEY="")
	 		if (arr.IsDefined(KEY)="0")	//如果未User未存入Array则创建查询对象保存之
	 		{
		 		s objQueryUserPrintCharge=##class(DHCEPRFS.Entity.EQueryUserPrintCharge).%New()
	 			s objQueryUserPrintCharge.UserID=KEY

	 			if ($p(KEY ,"^",1) = "TEMP")
    			{	
					s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(KEY,"^",2))
					s objQueryUserPrintCharge.UserName = objUser.UserName    
				}
				else
				{
    				s objQueryUserPrintCharge.UserName = 
    					##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(KEY)
				}
	 			s objQueryUserPrintCharge.Count=0
	 			s objQueryUserPrintCharge.MailCount=0
	 			s objQueryUserPrintCharge.MailAmount=0
	 			s objQueryUserPrintCharge.BasicCount=0
	 			s objQueryUserPrintCharge.BasicAmount=0
	 			s objQueryUserPrintCharge.PrintCount=0
	 			s objQueryUserPrintCharge.PrintAmount=0
	 			s objQueryUserPrintCharge.TotalAmount=0
	 			d arr.SetAt(objQueryUserPrintCharge,KEY)	//存储该User对象
	 		}
	 		
 			if (objMRPrintCharge.Status'="CANCEL")	//笔数
	 		{
		 		s arr.GetAt(KEY).Count=arr.GetAt(KEY).Count+1
	 		}
		 			
	 		s MRPrintListFeeID=""
	 		for {			//MRPrintChargeDetail子表循环	改用MRPrintListFee计算收费
		 		s MRPrintListFeeID=$o(^DHCEPRFS.INST.MRPrintListFeeI("IdxMRPrintChargeID"," "_MRPrintChargeID,MRPrintListFeeID))
		 		q:MRPrintListFeeID=""
		 		
		 		s objMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%OpenId(MRPrintListFeeID)
		
		 		if (objMRPrintListFee.ChargeTypeCode="10")	//邮寄费
		 		{
			 		s arr.GetAt(KEY).MailCount=
			 				arr.GetAt(KEY).MailCount+objMRPrintListFee.Quan
			 		s arr.GetAt(KEY).MailAmount=
			 				arr.GetAt(KEY).MailAmount+objMRPrintListFee.Amount		
			 	}
			 	
		 		if (objMRPrintListFee.ChargeTypeCode="20")	//基础费
		 		{
			 		s arr.GetAt(KEY).BasicCount=
			 				arr.GetAt(KEY).BasicCount+objMRPrintListFee.Quan
			 		s arr.GetAt(KEY).BasicAmount=
			 				arr.GetAt(KEY).BasicAmount+objMRPrintListFee.Amount		
			 	}			 	
			 	
			 	if (objMRPrintListFee.ChargeTypeCode="30")	//打印费
		 		{
			 		s arr.GetAt(KEY).PrintCount=
			 				arr.GetAt(KEY).PrintCount+objMRPrintListFee.Quan
			 		s arr.GetAt(KEY).PrintAmount=
			 				arr.GetAt(KEY).PrintAmount+objMRPrintListFee.Amount		
			 	}
			 	
			 	s arr.GetAt(KEY).TotalAmount=
	 		 				arr.GetAt(KEY).TotalAmount+objMRPrintListFee.Amount
	 		}
 		}
 		
 	}	
 	//循环结束
 	s strReturn=""
 	s strUserID=""
	for {
		s strUserID=arr.Next(strUserID)
	 	q:strUserID=""
	 	s obj=arr.GetAt(strUserID)	//取得数组里的对象
	 	if (AllUsersFlag="0")	//不是全用户
		{	
			continue:(arrUsers.IsDefined(strUserID)="0") //不是同区域操作员给予排除
		}
	 	s ^CacheTemp(repid,ind) = $lb(obj.UserID,obj.UserName,obj.Count,obj.MailCount,obj.MailAmount,
	 		obj.BasicCount,obj.BasicAmount,obj.PrintCount,obj.PrintAmount,obj.TotalAmount)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetPrintChargeGpByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintChargeGpByUserExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	按照日期查询操作员的打印结算记录 杨鹏 2015.11.12
/// Input：	ABeginDate 		开始日期
/// 		AEndDate 		截止日期
/// 		AUserID			操作员编码
/// 			ARoel 角色 LIST/CHARGE/PRINT
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetOperPrintChargeDetail","2015-11-01","2015-11-11","159")
/// return MRPrintChargeID^UserName^BeginDate^FootDate^MRPatientID^PatientName^TotalAmount^MedRecordNO^AdmDate^PrintTime
/// 			^ChargeTypeCode^ChargeTypeName^Quan^Price^Amount
Query GetOperPrintChargeDetail(AStartDate As %String, AEndDate As %String, AUserID As %String, ARole As %String) As %Query(ROWSPEC = "MRPrintChargeID:%String,UserName:%String,BeginDate:%String,FootDate:%String,MRPatientID:%String,PatientName:%String,TotalAmount:%String,MREpisodeID:%String,MedRecordNO:%String,AdmDate:%String,DisDate:%String,AdmLoc:%String,DisLoc:%String,PrintTime:%String,ChargeTypeCode:%String,ChargeTypeName:%String,Quan:%Float,Price:%Float,Amount:%Float")
{
}

ClassMethod GetOperPrintChargeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperPrintChargeDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOperPrintChargeDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String, ARole As %String) As %Status
{

	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s StartDate=$zdh(AStartDate,3)
	s EndDate=$zdh(AEndDate,3)
	

	
    s date=StartDate-1
    for {	//日期循环
	    s date=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxFootDate",date))
    	q:(date="")||(date>EndDate)	//为空或者Date>EndDate结束循环
    	
    	s MRPrintChargeID=""
    	for {				//MRPrintCharge 主表循环
	    	s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxFootDate",date,MRPrintChargeID))
	    	q:MRPrintChargeID=""
	    	
	    	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
	    	
	    	s UserID=""	//区别角色用户
			if (ARole="LIST")
			{s UserID=objMRPrintCharge.ActUserID}
			if (ARole="CHARGE")
			{s UserID=objMRPrintCharge.FootUserID}
			if (ARole="PRINT")
			{s UserID=objMRPrintCharge.PrintUserID}
			if (ARole="")	//空默认为打印操作员
			{s UserID=objMRPrintCharge.PrintUserID}
	    	
	    	if ((UserID'=AUserID)||(objMRPrintCharge.Status="LIST"))	//不是本用户或是暂存记录continue
	    	{
		    	continue	
		    }
	    	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMRPrintCharge.MRPatientID)
	    	
	    	if ($p(UserID ,"^",1) = "TEMP")	//UserName
    		{
				s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(UserID,"^",2))
				s UserName = objUser.UserName    
			}
			else
			{
    			s UserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(UserID)
			}
			
	    	s MRPrintListFeeID=""
	    	for {			//MRPrintListFee子表循环
		 		s MRPrintListFeeID=$o(^DHCEPRFS.INST.MRPrintListFeeI("IdxMRPrintChargeID"," "_MRPrintChargeID,MRPrintListFeeID))
		 		q:(MRPrintListFeeID="")
		 		
		 		s objMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%OpenId(MRPrintListFeeID)
		 		s objEpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRPrintListFee.MREpisodeID)
		 		
		 		s MRChargeTypeID=$o(^DHCEPRFS.META.MRChargeTypeI("IdxMain"," "_objMRPrintListFee.ChargeTypeCode,""))
		 		s objChargeType=##class(DHCEPRFS.META.MRChargeType).%OpenId(MRChargeTypeID)
		 		
		 		//ROWSPEC = "MRPrintChargeID:%String,UserName:%String,BeginDate:%String,FootDate:%String,MRPatientID:%String,
		 		//PatientName:%String,TotalAmount:%float,MedRecordNO:%String,AdmDate:%String,PrintTime:%String,
		 		//ChargeTypeCode:%String,ChargeTypeName:%String,Quan:%Float,Price:%Float,Amount:%Float
		 		s ^CacheTemp(repid,ind) = $lb(MRPrintChargeID,UserName,
		 						$zd(objMRPrintCharge.BeginActDate,3)_" "_$zt(objMRPrintCharge.BeginActTime,1),
		 						$zd(objMRPrintCharge.FootDate,3)_" "_$zt(objMRPrintCharge.FootTime,1),objMRPrintCharge.MRPatientID,
		 						objMRPatient.Name,objMRPrintCharge.TotalAmount,objEpisode.%Id(), objEpisode.MedRecordNo,
		 						$case(objEpisode.AdmDate="",1:"",:$zd(objEpisode.AdmDate,3)),
		 						$case(objEpisode.DisDate="",1:"",:$zd(objEpisode.DisDate,3)),
		 						objEpisode.AdmLoc,objEpisode.DisLoc,
		 						$zt(objMRPrintCharge.PrintTime,1),objMRPrintListFee.ChargeTypeCode,objChargeType.ChargeTypeName,
		 						objMRPrintListFee.Quan,objMRPrintListFee.Price,objMRPrintListFee.Amount)
				s ind = ind + 1
	    	}
	    	
    	}
    	
    }
    

	
	q $$$OK
}

ClassMethod GetOperPrintChargeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperPrintChargeDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	返回当日该患者打印病案未收费记录情况 杨鹏 2015.11.27
/// Input：	AMREpisodeID  	就诊ID
/// Deubg:	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintChargeDS","7")
/// Return:FootDate^FootTime^MRPatientID^Name^Sex^Birthday^BeginActDate^BeginActTime^TotalAmount
/// ^MREpisodeID^MRMedRecordID^MedRecordNO^AdmDate^PrintTime^ChargeTypeCode^ChargeTypeName^MRLogDetailID
/// ^Quan^Price^Amount
Query GetPrintChargeDS(AMREpisodeID As %String) As %Query(ROWSPEC = "FootDate:%String,FootTime:%String,MRPatientID:%String,Name:%String,Sex:%String,Birthday:%String,BeginActDate:%String,BeginActTime:%String,TotalAmount:%String,MREpisodeID:%String,MRMedRecordID:%String,MedRecordNO:%String,AdmDate:%String,DisDate:%String,AdmLoc:%String,DisLoc:%String,PrintTime:%String,ChargeTypeCode:%String,ChargeTypeName:%String,MRLogDetailID:%String,Quan:%Float,Price:%Float,Amount:%Float")
{
}

ClassMethod GetPrintChargeDSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintChargeDSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPrintChargeDSExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
    //取得SysOption值 邮寄费和基础费、打印费
	s MailPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintMailPrice")
	if (MailPrice="") 
		{ s MailPrice=0 }
	s BasicPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintBasePrice")
	if (BasicPrice="")
		{ s BasicPrice=0 }
	s PrintPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintPrice")
	if (PrintPrice="")
		{ s PrintPrice=0 }
		
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	//取得MRPatientID
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s MRPatientID=objMREpisode.MRPatientID
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
	
	s MinActDate=""		//取最小打印时间
	s TotalAmount=0
	s arrEpisode=##class(%ArrayOfDataTypes).%New()
	//取得MRPatientID对应的所有EpisodeID
	s MREpisodeID=""
	for {	//按照Episodes 循环
		s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," " _ MRPatientID,MREpisodeID))
		q:(MREpisodeID="")
		//取Episode的MedRecordNO和AdmDate
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
		s MedRecordNO=objMREpisode.MedRecordNo
		s AdmDate=$case(objMREpisode.AdmDate="",1:"",:$zd(objMREpisode.AdmDate,3))
		s DisDate=$case(objMREpisode.DisDate="",1:"",:$zd(objMREpisode.DisDate,3))
		s AdmLoc=objMREpisode.AdmLoc
		s DisLoc=objMREpisode.DisLoc
		
		s MRLogID=""
		s MRLogID=$o(^DHCEPRFS.INST.MRLogI("IdxUnique"," " _ MREpisodeID," ",""))
	
		continue:(MRLogID="")
		//从DHCEPRFS.INST.MRLogDetail 取数据
		s MRLogDetailDetailNum=""	//DetailNum
		s MRLogDetailchildsub="" 	//取childsub
		for { 	//按照LogDetailID 循环
			s MRLogDetailDetailNum=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum))	//取得DetailNum
			q:MRLogDetailDetailNum=""
			//因MRLogID 和 MRLogDetailDetailNum 是Unique，所以单条取childsub
			s MRLogDetailchildsub=$o(^DHCEPRFS.INST.MRLogDetailI("IdxMain",MRLogID,MRLogDetailDetailNum,""))
			q:MRLogDetailchildsub=""
			s objLogDetail=##class(DHCEPRFS.INST.MRLogDetail).%OpenId(MRLogID _ "||" _ MRLogDetailchildsub)
			
			//是PRINT 并且 当天 并且  不是批量打印
			if ((objLogDetail.MRAction="PRINT") && (objLogDetail.ActDate =nowDate)  && (objLogDetail.Remark'="BATCH"))
			{

				//用有效的objLogDetail.id 在 收费表中查询,是否存在收费记录
				s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeDetI("IdxMRLogDetail"," " _ objLogDetail.%Id(),""))
				
				if (MRPrintChargeID="")	//尚未收费
				{
					if (arrEpisode.Count()=0)	//如果还没有Episode被加入数组，对第一个Episode增加邮寄费
					{
						do InsertOneRow("","","","","","","","","",
							MREpisodeID,"",MedRecordNO,AdmDate,DisDate,AdmLoc,DisLoc,$zt(objLogDetail.ActTime,1),"10","邮寄费",
							objLogDetail.%Id(),1, MailPrice,MailPrice)
						s TotalAmount=TotalAmount+MailPrice
					}
					if (arrEpisode.IsDefined(MREpisodeID)="0")	//如果Episode没有定义在数组中,需要增加一次基础费
					{
						do InsertOneRow("","","","","","","","","",
							MREpisodeID,"",MedRecordNO,AdmDate,DisDate,AdmLoc,DisLoc,$zt(objLogDetail.ActTime,1),"20","基础费",
							objLogDetail.%Id(),1, BasicPrice,BasicPrice)	
						s TotalAmount=TotalAmount+BasicPrice
						do arrEpisode.SetAt(MREpisodeID,MREpisodeID)
					}
					//增加每次的打印费
					do InsertOneRow("","","","","","","","","",
						MREpisodeID,"",MedRecordNO,AdmDate,DisDate,AdmLoc,DisLoc,$zt(objLogDetail.ActTime,1),"30","打印费",
						objLogDetail.%Id(),objLogDetail.ActPages, PrintPrice,objLogDetail.ActPages*PrintPrice)	
					s TotalAmount=TotalAmount+(objLogDetail.ActPages*PrintPrice)
					
					
					if (MinActDate="")	//获取最小ActTime 
					{	s MinActDate=objLogDetail.ActTime}
					else
					{ 	
						if (objLogDetail.ActTime<MinActDate)
						{	
							s MinActDate=objLogDetail.ActTime 
						}
					}
					
				}
			}
		}
	}
	
	//增加主表信息
	do InsertOneRow($zd(nowDate,3),$zt(nowTime,1),MRPatientID,objMRPatient.Name,objMRPatient.Gender,$zd(objMRPatient.Birthday,3),
	$zd(nowDate,3),$zt(MinActDate,1),TotalAmount,
	"","",MedRecordNO,"","","","","","","","",
	"", "","")
	
	q $$$OK
InsertOneRow(FootDate,FootTime,MRPatientID,Name,Sex,Birthday,BeginActDate,BeginActTime,TotalAmount,MREpisodeID,MRMedRecordID,MedRecordNO,AdmDate,DisDate,AdmLoc,DisLoc,PrintTime,ChargeTypeCode,ChargeTypeName,MRLogDetailID,Quan,Price,Amount)

    s ^CacheTemp(repid,ind) = $lb(FootDate,FootTime,MRPatientID,Name,Sex,Birthday,BeginActDate,BeginActTime,TotalAmount,MREpisodeID,MRMedRecordID,MedRecordNO,AdmDate,DisDate,AdmLoc,DisLoc,PrintTime,ChargeTypeCode,ChargeTypeName,MRLogDetailID,Quan,Price,Amount)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintChargeDSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintChargeDSExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:	查询时间段内未结算打印记录明细
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserName	用户名称 模糊查询
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetUnChargePrintDetail","2015-12-01","2015-12-01","程丹颖")
Query GetUnChargePrintDetail(AStartDate As %String, AEndDate As %String, AUserName As %String) As %Query(ROWSPEC = "UserID:%String,UserName:%String,PrintDate:%String,PrintTime:%String,MRPatientID:%String,PatiName:%String,MREpisodeID:%String,MedRecordNO:%String,AdmDate:%String,DisDate:%String,AdmLoc:%String,DisLoc:%String,PrintPages:%String,PrintPrice:%String,PrintAmount:%String")
{
}

ClassMethod GetUnChargePrintDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserName As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	
 	s AStartDate=$zdh(AStartDate,3)
 	s AEndDate=$zdh(AEndDate,3)
 	s flagAction = "PRINT"
 	s UserID = ""
 	s UserName=""
	s rset = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRLog:GetUserIDByUserName")
	s sc = rset.Execute(AUserName)
	while (rset.Next())
	{
		
		s SSUserID = rset.Data("SSUserID")	
		s UserID = ""
		if ((SSUserID = "") || (SSUserID = $c(0)))
		{
			s UserID = "TEMP^"_rset.Data("UserID") 	
			s UserName=rset.Data("UserName")
		}
		else
		{
			s UserID = SSUserID	
			s UserName=rset.Data("UserName")
		}

 		for date = AStartDate:1:AEndDate
		{
			s time = ""
	 		for {
		 		s time = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_UserID,date,time))
		 		q:(time="")
		 	
		 		s mrLogID = ""
				for {
			 		s mrLogID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_UserID,date,time,mrLogID))
			 		q:(mrLogID="")
			 		
			 		s subID = ""
			 		for {
				 		
				 		s subID = $O(^DHCEPRFS.INST.MRLogDetailI("IdxMRActUserID"," "_flagAction," "_UserID,date,time,mrLogID,subID))
				 		q:(subID="")
				 		
				 		s objMRLogDetail = ##Class(DHCEPRFS.INST.MRLogDetail).%OpenId(mrLogID_"||"_subID)
				 		continue:(objMRLogDetail="")
				 		if (objMRLogDetail.Remark'="BATCH")
				 		{
					 		//用有效的objLogDetail.id 在 收费表中查询,是否存在收费记录
							s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeDetI("IdxMRLogDetail"," " _ objMRLogDetail.%Id(),""))
							if (MRPrintChargeID="")	//尚未收费
							{
								s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRLogDetail.MREpisodeID)
								s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
								s ^CacheTemp(repid,ind) = $lb(UserID,UserName,$zd(objMRLogDetail.ActDate,3),
								$zt(objMRLogDetail.ActTime,1),objMREpisode.MRPatientID,objMRPatient.Name,
								objMREpisode.%Id(),objMREpisode.MedRecordNo,
								$case(objMREpisode.AdmDate="",1:"",:$zd(objMREpisode.AdmDate,3)),
		 						$case(objMREpisode.DisDate="",1:"",:$zd(objMREpisode.DisDate,3)),
		 						objMREpisode.AdmLoc,objMREpisode.DisLoc,objMRLogDetail.ActPages,objMRLogDetail.ActPrice,
		 						objMRLogDetail.ActPages*objMRLogDetail.ActPrice)
								s ind = ind + 1
							}
				 		}
			 		}
				}
	 		}
		}
	}
 q $$$OK
}

ClassMethod GetUnChargePrintDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnChargePrintDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetUnChargePrintDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnChargePrintDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug : w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPatiInfo("28")
ClassMethod GetPatiInfo(AMREpisodeID As %String) As %String
{
	//取得MRPatientID
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s MRPatientID=objMREpisode.MRPatientID
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
	s id=objMRPatient.%Id()
	s Name=objMRPatient.Name
	s Gender=objMRPatient.Gender
	s Birthday=$zd(objMRPatient.Birthday,3)
	q id_"^"_Name_"^"_Gender_"^"_Birthday
}

/// Debug : w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetChargePriceParam()
ClassMethod GetChargePriceParam() As %String
{
	//取得SysOption值 邮寄费和基础费、打印费
	s MailPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintMailPrice")
	if (MailPrice="") 
		{ s MailPrice=0 }
	s BasicPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintBasePrice")
	if (BasicPrice="")
		{ s BasicPrice=0 }
	s PrintPrice=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintPrice")
	if (PrintPrice="")
		{ s PrintPrice=0 }
	q MailPrice_"^"_BasicPrice_"^"_PrintPrice
}

/// Desc:	根据条件查询暂存记录
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 		AUserName	用户名称 模糊查询
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintList","2015-12-01","2015-12-01","1","","ALL")
Query GetPrintList(AStartDate As %String, AEndDate As %String, AConditionType As %String, ACondition As %String, AStatus As %String, AUserID As %String = "") As %Query(ROWSPEC = "MRPrintChargeID:%String,MRPatientID:%String,PatientName:%String,MedRecordNOs:%String,ActDateTime:%String,ActUserID:%String,ActUserName:%String,FootDateTime:%String,FootUserID:%String,FootUserName:%String,PrintDateTime:%String,PrintUserID:%String,PrintUserName:%String,Status:%String,InvoiceNo:%String,TotalAmount:%Float")
{
}

ClassMethod GetPrintListExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AConditionType As %String, ACondition As %String, AStatus As %String, AUserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	
 	s StartDate=$zdh(AStartDate,3)
 	s EndDate=$zdh(AEndDate,3)
 	s MRPatientIDStr=""
 	
 	
 	//获取操作员同区域人员
 	s arrUsers=##class(DHCEPRFS.BL.BLQueryUser).GetDistrictOperators(AUserID)
 	s AllUsersFlag=arrUsers.IsDefined("ALLUSERS")
	
 	if ((ACondition = "") || (ACondition = $c(0)))	//如果条件为空默认查询全部
 	{
	 	s date=StartDate-1
	 	for {
		 	s date=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxBeginActDate",date))
		 	q:((date="")||(date>EndDate))
		 	s MRPrintChargeID=""
		 	for {
			 	s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxBeginActDate",date,MRPrintChargeID))
			 	q:(MRPrintChargeID="")
			 	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
			 	if (AStatus="ALL")
			 	{
				 	do InsertOneRow(MRPrintChargeID)
			 	}
			 	else
			 	{
				 	if (objMRPrintCharge.Status=AStatus)
				 	{
					 	do InsertOneRow(MRPrintChargeID)
					}
				}
		 	}
		} 
		q $$$OK	//退出
	}
 	
 	if (AConditionType="2")	//病案号查询方式
 	{
		s MRMedRecordID=""
		s MRMedRecordID=$o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_ACondition,MRMedRecordID))
		if (MRMedRecordID="")
		{
			q $$$OK	
		}
	 	s objMRMedRecord=##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
	 	s MRPatientIDStr=objMRMedRecord.MRPatientID
	}
	if (AConditionType="3")	//姓名查询方式 
	{
		s MRPatientID=""
		for {
			s MRPatientID=$o(^DHCEPRFS.INST.MRPatientI("IdxName"," "_ACondition,MRPatientID))
			q:(MRPatientID="")
			if (MRPatientIDStr="")
			{s MRPatientIDStr=MRPatientID}
			else
			{s MRPatientIDStr=MRPatientIDStr_"^"_MRPatientID}
		}
	}
	
	if ((AConditionType="2") || (AConditionType="3"))
	{
		for i=1:1:$l(MRPatientIDStr,"^")	//每个患者
		{
			s MRPatientID=$p(MRPatientIDStr,"^",i)
			s MRPrintChargeID=""
			for {
				s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxMRPatient"," "_MRPatientID,MRPrintChargeID))
				q:(MRPrintChargeID="")
				s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
				if ((objMRPrintCharge.BeginActDate>=StartDate)&&(objMRPrintCharge.BeginActDate<=EndDate))
				{
				 	if (AStatus="ALL")
				 	{
					 	do InsertOneRow(MRPrintChargeID)
				 	}
				 	else
				 	{
					 	if (objMRPrintCharge.Status=AStatus)
					 	{
						 	do InsertOneRow(MRPrintChargeID)
						}
					}
				}
			}
		}
	}
	if (AConditionType="1")
 	{
		s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(ACondition)
		if (objMRPrintCharge'="")
		{
			//加入查询结果	
			do InsertOneRow(ACondition)
		}
	}
	
 q $$$OK
InsertOneRow(MRPrintChargeID)
	
	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
	if (AllUsersFlag="0")	//不是全用户
	{	
		q:(arrUsers.IsDefined(objMRPrintCharge.ActUserID)="0") //不是同区域操作员给予排除
	}
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMRPrintCharge.MRPatientID)
	
	s ActDateTime=""
	if (objMRPrintCharge.BeginActDate="")
	{s ActDateTime=""}
	else
	{s ActDateTime=$zd(objMRPrintCharge.BeginActDate,3)_" "_$zt(objMRPrintCharge.BeginActTime,1) }
	
	s FootDateTime=""
	if (objMRPrintCharge.FootDate="")
	{s FootDateTime=""}
	else
	{s FootDateTime=$zd(objMRPrintCharge.FootDate,3)_" "_$zt(objMRPrintCharge.FootTime,1) }
	
	s PrintDateTime=""
	if (objMRPrintCharge.PrintDate="")
	{s PrintDateTime=""}
	else
	{s PrintDateTime=$zd(objMRPrintCharge.PrintDate,3)_" "_$zt(objMRPrintCharge.PrintTime,1) }
	
	s ActUserName=""
	if ($p(objMRPrintCharge.ActUserID ,"^",1) = "TEMP")
	{
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(objMRPrintCharge.ActUserID,"^",2))
		s ActUserName = objUser.UserName    
	}
	else
	{
		s ActUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(objMRPrintCharge.ActUserID)
	}
	
	s FootUserName=""
	if ($p(objMRPrintCharge.FootUserID ,"^",1) = "TEMP")
	{
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(objMRPrintCharge.FootUserID,"^",2))
		s FootUserName = objUser.UserName    
	}
	else
	{
		s FootUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(objMRPrintCharge.FootUserID)
	}
	
	s PrintUserName=""
	if ($p(objMRPrintCharge.PrintUserID ,"^",1) = "TEMP")
	{
		s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(objMRPrintCharge.PrintUserID,"^",2))
		s PrintUserName = objUser.UserName    
	}
	else
	{
		s PrintUserName = ##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(objMRPrintCharge.PrintUserID)
	}
	
	//取MedRecordNOs
	s MedRecordNOs=""
	s arrMedRecordNO=##class(%ArrayOfDataTypes).%New()
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_MRPrintChargeID,MRPrintListRecID))
		q:MRPrintListRecID=""
		s objMRPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRPrintListRec.MREpisodeID)
		//if (MRPrintChargeID = "133288") b "s"
		s medRecord = objMREpisode.MedRecordNo
		if (medRecord = "")	// medRecordNO is empty 
		{
			if (objMRPatient.ObservedNo'="")	// ObservedNo is not empty ,use ObservedNo
			{
				s medRecord=objMRPatient.ObservedNo
			}
			else
			{
				s medRecord = objMRPatient.RegNo_" "_objMREpisode.EpisodeID
			}
		}
		if (arrMedRecordNO.IsDefined(medRecord)="0")
		{
			if (MedRecordNOs="")
			{s MedRecordNOs=medRecord}
			else
			{s MedRecordNOs=MedRecordNOs_","_medRecord}
			//b "01"
			do arrMedRecordNO.SetAt(medRecord,medRecord)
			//b "02"
		}
	}
	s InvoiceNo=##class(DHCEPRFS.BL.BLMRPrintInvoice).GetMRPrintChargeLastInvoiceNo(objMRPrintCharge.%Id())
    //s ^CacheTemp(repid,ind) = $lb(MRPrintChargeID,MRPatientID,PatientName,ActDateTime,ActUserID,FootDateTime,FootUserID,PrintDateTime,PrintUserID,Status,TotalAmount)
    s ^CacheTemp(repid,ind) = $lb(objMRPrintCharge.%Id(),objMRPrintCharge.MRPatientID,objMRPatient.Name,MedRecordNOs,
    							ActDateTime,objMRPrintCharge.ActUserID,ActUserName,
    							FootDateTime,objMRPrintCharge.FootUserID,FootUserName,
    							PrintDateTime,objMRPrintCharge.PrintUserID,PrintUserName,
    							objMRPrintCharge.Status,InvoiceNo,objMRPrintCharge.TotalAmount)
	s ind = ind + 1
	
	quit
}

ClassMethod GetPrintListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	根据MRPrintChargeID查询收费明细项目
/// Input：	MRPrintChargeID 
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintListFee","110")
Query GetPrintListFee(AMRPrintChargeID As %String) As %Query(ROWSPEC = "MRPrintListFeeID:%String,DetailNum:%String,MREpisodeID:%String,MedRecordNO:%String,ChargeTypeCode:%String,ChargeTypeName:%String,Quan:%Integer,Price:%Float,Amount:%Float")
{
}

ClassMethod GetPrintListFeeExecute(ByRef qHandle As %Binary, AMRPrintChargeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	s MRPrintListFeeID=""
	for {
		s MRPrintListFeeID=$o(^DHCEPRFS.INST.MRPrintListFeeI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListFeeID))
		q:MRPrintListFeeID=""
		s objMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%OpenId(MRPrintListFeeID)
		//取ChargeTypeName
		s MRChargeTypeID=$o(^DHCEPRFS.META.MRChargeTypeI("IdxMain"," "_objMRPrintListFee.ChargeTypeCode,""))
		s objMRChargeType=##class(DHCEPRFS.META.MRChargeType).%OpenId(MRChargeTypeID)
		//取MedRecordNO
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRPrintListFee.MREpisodeID)
		
		s ^CacheTemp(repid,ind) = $lb(objMRPrintListFee.%Id(),objMRPrintListFee.DetailNum,objMRPrintListFee.MREpisodeID,objMREpisode.MedRecordNo,
							objMRPrintListFee.ChargeTypeCode,objMRChargeType.ChargeTypeName,objMRPrintListFee.Quan,objMRPrintListFee.Price,objMRPrintListFee.Amount )
		s ind = ind + 1
	}
 	
 q $$$OK
}

ClassMethod GetPrintListFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintListFeeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintListFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintListFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	根据MRPrintChargeID查询打印明细记录
/// Input：	MRPrintChargeID 
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintListRec","110")
Query GetPrintListRec(AMRPrintChargeID As %String) As %Query(ROWSPEC = "MRPrintChargeID:%String,MRPrintListRecID:%String,MREpisodeID:%String,MedRecordNO:%String,ActPages:%Integer,ActPrice:%Float,PrintTimes:%Integer")
{
}

ClassMethod GetPrintListRecExecute(ByRef qHandle As %Binary, AMRPrintChargeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListRecID))
		q:MRPrintListRecID=""
		s objMRPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
		//取MedRecordNO
		s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRPrintListRec.MREpisodeID)
		
		s ^CacheTemp(repid,ind) = $lb(objMRPrintListRec.MRPrintChargeID,objMRPrintListRec.%Id(),objMRPrintListRec.MREpisodeID,
								objMREpisode.MedRecordNo,objMRPrintListRec.ActPages,objMRPrintListRec.ActPrice,objMRPrintListRec.PrintTimes )
		s ind = ind + 1
	}
 	
 q $$$OK
}

ClassMethod GetPrintListRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintListRecExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintListRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintListRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:	根据MRPrintChargeID查询打印VerItem细项
/// Input：	MRPrintChargeID 
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetPrintListItem","110")
Query GetPrintListItem(AMRPrintChargeID As %String) As %Query(ROWSPEC = "MRPrintListRecID:%String,DetailNum:%String,MRItemID:%String,MRItemDesc:%String,MRVerItemID:%String,OriginalPageTotal:%Integer,PageNumStr:%String,PrintPageTotal:%Integer")
{
}

ClassMethod GetPrintListItemExecute(ByRef qHandle As %Binary, AMRPrintChargeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListRecID))
		q:(MRPrintListRecID="")
		s MRPrintListItemID=""
		for {
			s MRPrintListItemID=$o(^DHCEPRFS.INST.MRPrintListItemI("IdxMRPrintListRecID"," "_MRPrintListRecID,MRPrintListItemID))
			q:(MRPrintListItemID="")
			s objMRPrintListItem=##class(DHCEPRFS.INST.MRPrintListItem).%OpenId(MRPrintListItemID)
			s ^CacheTemp(repid,ind) = $lb(objMRPrintListItem.MRPrintListRecID,objMRPrintListItem.DetailNum,objMRPrintListItem.MRItemID,
									objMRPrintListItem.MRItemDesc,objMRPrintListItem.MRVerItemID,
									objMRPrintListItem.OriginalPageTotal,objMRPrintListItem.PageNumStr,objMRPrintListItem.PrintPageTotal  )
			s ind = ind + 1
		}
	}
 	
 q $$$OK
}

ClassMethod GetPrintListItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintListItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetPrintListItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintListItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetPrintListCharge(AMRPrintChargeID As %String, AChargeUserID As %String, AInvoiceNo) As %String
{
	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(AMRPrintChargeID)
	if (objMRPrintCharge.Status'="LIST")
	{
		q "状态错误，不允许操作"	
	}
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	TSTART	//开始事务
	s $zt = "OnSetChargeEHandler"
	
	s objMRPrintCharge.FootUserID=AChargeUserID
	s objMRPrintCharge.FootDate=nowDate
	s objMRPrintCharge.FootTime=nowTime
	s objMRPrintCharge.Status="CHARGE"
	
	s sc=objMRPrintCharge.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q "更新缴费操作出错!"
	}
	s ret=##class(DHCEPRFS.BL.BLMRPrintInvoice).AddInvoice(objMRPrintCharge.%Id(),AInvoiceNo,nowDate,nowTime,AChargeUserID)
	if (ret="")
	{
		TROLLBACK
		q "插入发票信息出错!"
	} 
	
	//增加打印计费日志
	s ret=..AddPrintChargeLog(objMRPrintCharge.%Id(),"CHARGE",nowDate,nowTime,AChargeUserID)
	if (ret="")
	{
		TROLLBACK
		q "插入打印计费日志出错!"
	}
	
	TCOMMIT
	q ""
OnSetChargeEHandler
	TROLLBACK
	q "更新缴费操作出错!"
}

ClassMethod SetPrintListPrint(AMRPrintChargeID As %String, APrintUserID As %String) As %String
{
	s flag = "true"
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)

	//更新MRPrintCharge表打印相关字段
	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(AMRPrintChargeID)
	if (objMRPrintCharge.Status'="CHARGE")
	{
		q "状态错误,不允许操作"	
	}
	
	TSTART	//开始事务
	s $zt = "OnSetPrintListPrintErrorHandler"
	
	s objMRPrintCharge.PrintUserID=APrintUserID
	s objMRPrintCharge.PrintDate=nowDate
	s objMRPrintCharge.PrintTime=nowTime
	s objMRPrintCharge.Status="PRINT"
	
	s sc=objMRPrintCharge.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q "更新打印操作出错!"
	}
	
	//增加打印计费日志
	s ret=..AddPrintChargeLog(objMRPrintCharge.%Id(),"PRINT",nowDate,nowTime,APrintUserID)
	if (ret="")
	{
		TROLLBACK
		q "插入打印计费日志出错"
	}
	
	//插入打印日志
	s ChargeDetailDetailNum=0	//明细累计序号
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListRecID))
		q:(MRPrintListRecID="")
		s objMrPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
		for i=1:1:objMrPrintListRec.PrintTimes	//每个打印次数计入日志一次
		{
			//增加打印日志
			s mrLogDetailID=##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogAllWOT(objMrPrintListRec.MREpisodeID,APrintUserID,objMrPrintListRec.ActPages,
								objMrPrintListRec.ActPrice,objMrPrintListRec.ActSchemeID,objMrPrintListRec.Remark,
								objMrPrintListRec.MRItemIDS,objMrPrintListRec.Name,objMrPrintListRec.Relationship,
								objMrPrintListRec.Contact,objMrPrintListRec.IDNumber)
			if (mrLogDetailID="")
			{
				s flag="false"
				q
			}
			//增加结算子表记录
			s objPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
			s ChargeDetailDetailNum=ChargeDetailDetailNum+1
			s objPrintChargeDetail.MREpisodeID=objMrPrintListRec.MREpisodeID
			s objPrintChargeDetail.MRMedRecordID=""
			s objPrintChargeDetail.PrintTime=nowTime
			s objPrintChargeDetail.ChargeTypeCode="30"
			s objPrintChargeDetail.MRLogDetailID=mrLogDetailID
			s objPrintChargeDetail.Quan=objMrPrintListRec.ActPages
			s objPrintChargeDetail.Price=objMrPrintListRec.ActPrice
			s objPrintChargeDetail.Amount=objMrPrintListRec.ActPages*objMrPrintListRec.ActPrice
			s objPrintChargeDetail.DetailNum=ChargeDetailDetailNum	//序号
			s objPrintChargeDetail.TheMRPrintCharge=objMRPrintCharge
			s sc=objPrintChargeDetail.%Save()
			if ($$$ISERR(sc))
			{
				s flag="false"
				q
			}
			
		}
		q:(flag="false")
	}
	if (flag = "false")
	{
		TROLLBACK
	  	q "插入打印明细出错!"
	}	
	
	//插入基础费和邮寄费
	s MRPrintListFeeID=""
	for {
		s MRPrintListFeeID=$o(^DHCEPRFS.INST.MRPrintListFeeI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListFeeID))
		q:(MRPrintListFeeID="")
		s objMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%OpenId(MRPrintListFeeID)
		if ((objMRPrintListFee.ChargeTypeCode="10")||(objMRPrintListFee.ChargeTypeCode="20"))	//基础费和邮寄费
		{
			s objPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
			s ChargeDetailDetailNum=ChargeDetailDetailNum+1
			s objPrintChargeDetail.MREpisodeID=objMRPrintListFee.MREpisodeID
			s objPrintChargeDetail.MRMedRecordID=objMRPrintListFee.MRMedRecordID
			s objPrintChargeDetail.PrintTime=nowTime
			s objPrintChargeDetail.ChargeTypeCode=objMRPrintListFee.ChargeTypeCode
			s objPrintChargeDetail.MRLogDetailID=""
			s objPrintChargeDetail.Quan=objMRPrintListFee.Quan
			s objPrintChargeDetail.Price=objMRPrintListFee.Price
			s objPrintChargeDetail.Amount=objMRPrintListFee.Amount
			s objPrintChargeDetail.DetailNum=ChargeDetailDetailNum	//序号
			s objPrintChargeDetail.TheMRPrintCharge=objMRPrintCharge
			s sc=objPrintChargeDetail.%Save()
			if ($$$ISERR(sc))
			{
				s flag="false"
				q
			}
		}
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q ""
	}
  	else
  	{
	  	TROLLBACK
	  	q "插入打印明细出错!"
  	}	
  	
OnSetPrintListPrintErrorHandler
	TROLLBACK
	q "更新打印状态出错"
}

/// Desc:	增加打印暂存表记录
/// Input：	APrintLogStr="PMRVersionID^PMREpisodeID^PActPages^PActPrice^PActSchemeID^PRemark^PMRItemIDS^PName^PRelationship^PContact^PIDNumber^PPrintTimes~"
/// 		AItemStr="MRVerItemID^MRItemID^MRItemDesc^OriginalPageTotal^PrintPageTotal^PageNumStr(,)`another~"
/// 		AFootChargeStr="MREpisodeID^MRMedRecordID^ChargeTypeCode^Quan^Price^Amount~""
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).GetPrintPagesGroupByPrintScheme("2015-11-09","2015-11-09")
ClassMethod Add2PrintList(AMRPatientID As %String, ATotalAmount As %String, AActUserID As %String, AFootChargeStr As %String, APrintLogStr As %String, AItemStr As %String) As %String
{
	s flag = "true"
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)
	
	TSTART	//开始事务
	s $zt = "OnAdd2PrintListErrorHandler"
	
	//新增收费主表
	s objPrintCharge =##class(DHCEPRFS.INST.MRPrintCharge).%New()

	s objPrintCharge.MRPatientID =AMRPatientID
	s objPrintCharge.ActUserID =AActUserID
	s objPrintCharge.BeginActDate=nowDate
	s objPrintCharge.BeginActTime=nowTime
	s objPrintCharge.TotalAmount =ATotalAmount
	s objPrintCharge.Status="LIST"
	s sc=objPrintCharge.%Save()
	
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q ""
	}
	//增加打印计费日志
	s ret=..AddPrintChargeLog(objPrintCharge.%Id(),"LIST",nowDate,nowTime,AActUserID)
	if (ret="")
	{
		TROLLBACK
		q ""
	}
	
	//新增
	//					1			2			3			4			5		6			7		8		9
	//APrintLogStr="PMRVersionID^PMREpisodeID^PActPages^PActPrice^PActSchemeID^PRemark^PMRItemIDS^PName^PRelationship
	//		10		11		12
	//^PContact^PIDNumber^PPrintTimes~"
	for i=1:1:$l(APrintLogStr,"~")	//每一次打印
	{
		s onePrintLog=$p(APrintLogStr,"~",i)
		s objPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%New()
		s objPrintListRec.MRPrintChargeID=objPrintCharge.%Id()
		s objPrintListRec.MRVersionID=$p(onePrintLog,"^",1)
		s objPrintListRec.MREpisodeID=$p(onePrintLog,"^",2)
		s objPrintListRec.MRMedRecordID=""
		s objPrintListRec.ActPages=$p(onePrintLog,"^",3)
		s objPrintListRec.ActPrice=$p(onePrintLog,"^",4)
		s objPrintListRec.ActSchemeID=$p(onePrintLog,"^",5)
		s objPrintListRec.Remark=$p(onePrintLog,"^",6)
		s objPrintListRec.MRItemIDS=$p(onePrintLog,"^",7)
		s objPrintListRec.Name=$p(onePrintLog,"^",8)
		s objPrintListRec.Relationship=$p(onePrintLog,"^",9)
		s objPrintListRec.Contact=$p(onePrintLog,"^",10)
		s objPrintListRec.IDNumber=$p(onePrintLog,"^",11)
		s objPrintListRec.PrintTimes=$p(onePrintLog,"^",12)
		s sc=objPrintListRec.%Save()
		if ($$$ISERR(sc))
		{
			s flag="false"
			q
		}
		
		s onePrintLogItem=$p(AItemStr,"~",i)	//每一次打印对应的VerItems项
		//				1			2		3				4				5			6
		//AItemStr="MRVerItemID^MRItemID^MRItemDesc^OriginalPageTotal^PrintPageTotal^PageNumStr(,)`another~"
		s DetailNum=0
		for j=1:1:$l(onePrintLogItem,"`")		//取每一次打印对应的VerItem子项
		{
			s oneItem=$p(onePrintLogItem,"`",j)
			s objPrintListItem=##Class(DHCEPRFS.INST.MRPrintListItem).%New()
			s DetailNum=DetailNum+1
			s objPrintListItem.MRPrintListRecID=objPrintListRec.%Id()
			s objPrintListItem.DetailNum=DetailNum
			s objPrintListItem.MRVerItemID=$p(oneItem,"^",1)
			s objPrintListItem.MRItemID=$p(oneItem,"^",2)
			s objPrintListItem.MRItemDesc=$p(oneItem,"^",3)
			s objPrintListItem.OriginalPageTotal=$p(oneItem,"^",4)
			s objPrintListItem.PrintPageTotal=$p(oneItem,"^",5)
			s objPrintListItem.PageNumStr=$p(oneItem,"^",6)
			s sc=objPrintListItem.%Save()
			if ($$$ISERR(sc))
			{
				s flag="false"
				q
			}
		}
		q:flag="false"
	}
	
	if (flag="false")
	{
		TROLLBACK
		q ""
	}
	//						1		2				3			4		5	6
	//AFootChargeStr="MREpisodeID^MRMedRecordID^ChargeTypeCode^Quan^Price^Amount~"
	s ChargeDetailDetailNum=0
	for i=1:1:$l(AFootChargeStr,"~")	//每一次打印
	{
		s oneFootCharge=$p(AFootChargeStr,"~",i)
		//增加结算子表记录
		s objPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%New()
		s ChargeDetailDetailNum=ChargeDetailDetailNum+1
		s objPrintListFee.MRPrintChargeID=objPrintCharge.%Id()
		s objPrintListFee.MREpisodeID=$p(oneFootCharge,"^",1)
		s objPrintListFee.MRMedRecordID=""
		s objPrintListFee.ChargeTypeCode=$p(oneFootCharge,"^",3)
		
		s objPrintListFee.DetailNum=ChargeDetailDetailNum	//序号
		s objPrintListFee.Quan=$p(oneFootCharge,"^",4)
		s objPrintListFee.Price=$p(oneFootCharge,"^",5)
		s objPrintListFee.Amount=$p(oneFootCharge,"^",6)
		
		s sc=objPrintListFee.%Save()
		
		if ($$$ISERR(sc))
		{
			s flag="false"
			q
		}
	}

	if (flag = "true")
	{
		TCOMMIT
		q objPrintCharge.%Id()	
	}
  	else
  	{
	  	TROLLBACK
	  	q ""
  	}	
OnAdd2PrintListErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 增加打印计费日志
ClassMethod AddPrintChargeLog(AMRPrintChargeID As %String, AAction As %String, AActDate As %Date, AActTime As %Time, AActUserID As %String, ARemark As %String = "") As %String
{
	s objPrintChargeLog=##class(DHCEPRFS.INST.MRPrintChargeLog).%New()
	
	s objPrintChargeLog.MRPrintChargeID=AMRPrintChargeID
	s objPrintChargeLog.ActionCode=AAction
	s objPrintChargeLog.ActDate=AActDate
	s objPrintChargeLog.ActTime=AActTime
	s objPrintChargeLog.ActUserID=AActUserID
	s objPrintChargeLog.Remark=ARemark
	
	s sc=objPrintChargeLog.%Save()
	if ($$$ISOK(sc))
	{
		q objPrintChargeLog.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc: 暂存记录保存仅打印日志，用于已经是打印状态的再次打印
ClassMethod SavePrintListPrintLogOnly(AMRPrintChargeID As %String, APrintUserID As %String) As %String
{
	s flag = "true"
	
	//更新MRPrintCharge表打印相关字段
	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(AMRPrintChargeID)
	if (objMRPrintCharge.Status'="PRINT")
	{
		q "非打印状态,不允许操作"	
	}
	
	TSTART	//开始事务
	s $zt = "OnPrintLogOEHandler"
	
	//插入打印日志
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListRecID))
		q:(MRPrintListRecID="")
		s objMrPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
		for i=1:1:objMrPrintListRec.PrintTimes	//每个打印次数计入日志一次
		{
			//增加打印日志
			s mrLogDetailID=##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogAllWOT(objMrPrintListRec.MREpisodeID,APrintUserID,objMrPrintListRec.ActPages,
								objMrPrintListRec.ActPrice,objMrPrintListRec.ActSchemeID,objMrPrintListRec.Remark,
								objMrPrintListRec.MRItemIDS,objMrPrintListRec.Name,objMrPrintListRec.Relationship,
								objMrPrintListRec.Contact,objMrPrintListRec.IDNumber)
			if (mrLogDetailID="")
			{
				s flag="false"
				q
			}
		}
		q:(flag="false")
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q ""
	}
  	else
  	{
	  	TROLLBACK
	  	q "保存打印明细数据出错"
  	}	
  	
OnPrintLogOEHandler
	TROLLBACK
	q "保存打印明细数据出错"
}

/// Desc: 作废打印记录
/// Debug: d ##class(DHCEPRFS.BL.BLMRPrintCharge).SetPrintListCancel("134","159")
ClassMethod SetPrintListCancel(AMRPrintChargeID As %String, ACancelUserID As %String) As %String
{
	s flag = "true"
	
	//取当前时间
	s now = $h
	s nowDate = $p(now,",",1)
	s nowTime = $p(now,",",2)

	//更新MRPrintCharge表打印相关字段
	s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(AMRPrintChargeID)
	if ((objMRPrintCharge.Status="CHARGE")||(objMRPrintCharge.Status="PRINT"))	//收费或打印状态允许作废
	{}
	else
	{ q "状态错误,不允许操作"	}
	
	TSTART	//开始事务
	s $zt = "OnSetCancelEHandler"
	
	s objMRPrintCharge.Status="CANCEL"	//设置原单“取消”状态
	
	s sc=objMRPrintCharge.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q "更新打印操作出错!"
	}
	
	//作废原发票
	s ret=##class(DHCEPRFS.BL.BLMRPrintInvoice).CancelInvoice(AMRPrintChargeID,"业务作废",ACancelUserID)
	if (ret="0")
	{
		TROLLBACK
		q "作废原发票出错!"
	}
	
	//增加打印计费日志
	s ret=..AddPrintChargeLog(objMRPrintCharge.%Id(),"CANCEL",nowDate,nowTime,ACancelUserID)	//增加原单“取消”日志
	if (ret="")
	{
		TROLLBACK
		q "插入打印计费日志出错"
	}
	
	//新增作废记录
	s objNewMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%New()
	
	s objNewMRPrintCharge.MRPatientID=objMRPrintCharge.MRPatientID
	s objNewMRPrintCharge.BeginActDate=nowDate
	s objNewMRPrintCharge.BeginActTime=nowTime
	s objNewMRPrintCharge.ActUserID=objMRPrintCharge.ActUserID
	s objNewMRPrintCharge.FootDate=nowDate
	s objNewMRPrintCharge.FootTime=nowTime
	s objNewMRPrintCharge.FootUserID=ACancelUserID
	s objNewMRPrintCharge.Status="CANCEL"
	s objNewMRPrintCharge.TotalAmount=-objMRPrintCharge.TotalAmount
	
	s sc=objNewMRPrintCharge.%Save()
	if ($$$ISERR(sc))
	{
		TROLLBACK
		q "新增作废记录出错"
	}
	
	//新增作废记录的日志
	s ret=..AddPrintChargeLog(objNewMRPrintCharge.%Id(),"CANCEL",nowDate,nowTime,ACancelUserID,objMRPrintCharge.%Id())	//增加原单“取消”日志
	if (ret="")
	{
		TROLLBACK
		q "插入打印计费日志出错"
	}
	
	//copy 原PrintListRec表 和 原PrintListItem表
	s MRPrintListRecID=""
	for {
		s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListRecID))
		q:(MRPrintListRecID="")
		s objMrPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
		s objNewMRPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%New()
		s objNewMRPrintListRec.MRPrintChargeID= objNewMRPrintCharge.%Id()
		s objNewMRPrintListRec.MRVersionID= objMrPrintListRec.MRVersionID
		s objNewMRPrintListRec.MREpisodeID= objMrPrintListRec.MREpisodeID
		s objNewMRPrintListRec.MRMedRecordID=objMrPrintListRec.MRMedRecordID
		s objNewMRPrintListRec.ActPages= -objMrPrintListRec.ActPages
		s objNewMRPrintListRec.ActPrice= objMrPrintListRec.ActPrice
		s objNewMRPrintListRec.ActSchemeID= objMrPrintListRec.ActSchemeID
		s objNewMRPrintListRec.Remark= objMrPrintListRec.Remark
		s objNewMRPrintListRec.MRItemIDS= objMrPrintListRec.MRItemIDS
		s objNewMRPrintListRec.Name= objMrPrintListRec.Name
		s objNewMRPrintListRec.Relationship= objMrPrintListRec.Relationship
		s objNewMRPrintListRec.Contact= objMrPrintListRec.Contact
		s objNewMRPrintListRec.IDNumber= objMrPrintListRec.IDNumber
		s objNewMRPrintListRec.PrintTimes= objMrPrintListRec.PrintTimes
		
		s sc=objNewMRPrintListRec.%Save()
		if ($$$ISERR(sc))
		{
			s flag="false"
			q
		}
		//保存PrintListItem 表
		s MRPrintListItemID=""
		for {
			s MRPrintListItemID=$o(^DHCEPRFS.INST.MRPrintListItemI("IdxMRPrintListRecID"," "_objMrPrintListRec.%Id(),MRPrintListItemID))
			q:(MRPrintListItemID="")
			s objMRPrintListItem=##class(DHCEPRFS.INST.MRPrintListItem).%OpenId(MRPrintListItemID)
			s objNewMRPrintListItem=##class(DHCEPRFS.INST.MRPrintListItem).%New()
			
			s objNewMRPrintListItem.MRPrintListRecID=objNewMRPrintListRec.%Id()
			s objNewMRPrintListItem.DetailNum=objMRPrintListItem.DetailNum
			s objNewMRPrintListItem.MRVerItemID=objMRPrintListItem.MRVerItemID
			s objNewMRPrintListItem.MRItemID=objMRPrintListItem.MRItemID
			s objNewMRPrintListItem.MRItemDesc=objMRPrintListItem.MRItemDesc
			s objNewMRPrintListItem.OriginalPageTotal=objMRPrintListItem.OriginalPageTotal
			s objNewMRPrintListItem.PrintPageTotal=objMRPrintListItem.PrintPageTotal
			s objNewMRPrintListItem.PageNumStr=objMRPrintListItem.PageNumStr
			
			s sc=objNewMRPrintListItem.%Save()
			if ($$$ISERR(sc))
			{
				s flag="false"
				q
			}
		}
		q:(flag="false")	
	}

	if (flag="false")
	{
		TROLLBACK
		q "保存PrintListRec数据出错"
	}
	
	//copy MRPrintListFee 表
	s MRPrintListFeeID=""
	for {
		s MRPrintListFeeID=$o(^DHCEPRFS.INST.MRPrintListFeeI("IdxMRPrintChargeID"," "_AMRPrintChargeID,MRPrintListFeeID))
		q:(MRPrintListFeeID="")
		s objMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%OpenId(MRPrintListFeeID)
		s objNewMRPrintListFee=##class(DHCEPRFS.INST.MRPrintListFee).%New()
		
		s objNewMRPrintListFee.MRPrintChargeID=objNewMRPrintCharge.%Id()
		s objNewMRPrintListFee.MREpisodeID=objMRPrintListFee.MREpisodeID
		s objNewMRPrintListFee.MRMedRecordID=objMRPrintListFee.MRMedRecordID
		s objNewMRPrintListFee.ChargeTypeCode=objMRPrintListFee.ChargeTypeCode
		s objNewMRPrintListFee.DetailNum=objMRPrintListFee.DetailNum
		s objNewMRPrintListFee.Quan=-objMRPrintListFee.Quan
		s objNewMRPrintListFee.Price=objMRPrintListFee.Price
		s objNewMRPrintListFee.Amount=-objMRPrintListFee.Amount
		
		s sc=objNewMRPrintListFee.%Save()
		if ($$$ISERR(sc))
		{
			s flag="false"
			q
		}
	}
	
	if (flag="false")
	{
		TROLLBACK
		q "保存MRPrintListFee数据出错"
	}
	
	//copy mrprintchargedetail
	s DetailNum=""
	for {			//MRPrintChargeDetail子表循环
		s DetailNum=$o(^DHCEPRFS.INST.MRPrintChargeDetI("IdxMain",AMRPrintChargeID,DetailNum))
		q:DetailNum=""
		s childSub=$o(^DHCEPRFS.INST.MRPrintChargeDetI("IdxMain",AMRPrintChargeID,DetailNum,""))
		s objMRPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%OpenId(AMRPrintChargeID_"||"_childSub)
		s objNewMRPrintChargeDetail=##class(DHCEPRFS.INST.MRPrintChargeDetail).%New()
		
		s objNewMRPrintChargeDetail.TheMRPrintCharge=objNewMRPrintCharge
		s objNewMRPrintChargeDetail.DetailNum=objMRPrintChargeDetail.DetailNum
		s objNewMRPrintChargeDetail.MREpisodeID=objMRPrintChargeDetail.MREpisodeID
		s objNewMRPrintChargeDetail.MRMedRecordID=objMRPrintChargeDetail.MRMedRecordID
		s objNewMRPrintChargeDetail.ChargeTypeCode=objMRPrintChargeDetail.ChargeTypeCode
		s objNewMRPrintChargeDetail.MRLogDetailID=""
		s objNewMRPrintChargeDetail.PrintTime=""
		s objNewMRPrintChargeDetail.Quan=-objMRPrintChargeDetail.Quan
		s objNewMRPrintChargeDetail.Price=objMRPrintChargeDetail.Price
		s objNewMRPrintChargeDetail.Amount=-objMRPrintChargeDetail.Amount
		
		s sc=objNewMRPrintChargeDetail.%Save()
		if ($$$ISERR(sc))
		{
			s flag="false"
			q
		}
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q ""
	}
  	else
  	{
	  	TROLLBACK
	  	q "插入作废记录出错!"
  	}	
  	
OnSetCancelEHandler
	TROLLBACK
	q "插入作废记录出错!"
}

/// Desc:	查询病历打印计费收费员日结
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetDailyChargeTotal","2016-04-01","2016-04-10")
Query GetDailyChargeTotal(AStartDate As %String, AEndDate As %String, AUserID As %String = "") As %Query(ROWSPEC = "UserID:%String,UserName:%String,FootDate:%String,StartInvoiceNo:%String,EndInvoiceNo:%String,Count:%Integer,NormalCount:%Integer,CancelCount:%Integer,Amount:%Float,CancelAmount:%Float,InvoiceCount:%Integer,CancelInvoiceCount:%Integer,CancelInvoices:%String")
{
}

ClassMethod GetDailyChargeTotalExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AUserID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
 	
 	 //获取操作员同区域人员
 	s arrUsers=##class(DHCEPRFS.BL.BLQueryUser).GetDistrictOperators(AUserID)
 	s AllUsersFlag=arrUsers.IsDefined("ALLUSERS")
 	
 	s StartDate=$zdh(AStartDate,3)
	s EndDate=$zdh(AEndDate,3)
	
	s arr=##class(%ArrayOfObjects).%New()	//存放结果数据 
 	for date=StartDate:1:EndDate	//按天循环
 	{
	 	s MRPrintChargeID=""
	 	for {
	 		s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxFootDate",date,MRPrintChargeID))
	 		q:(MRPrintChargeID="")
	 		s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
	 		if ((objMRPrintCharge.Status="LIST")||(objMRPrintCharge.Status=""))	//“加入暂存”状态不统计在内\或为空
	 		{
		 		continue 	
		 	}
	 		s KEY=objMRPrintCharge.FootDate_"|"_objMRPrintCharge.FootUserID
	 		if (arr.IsDefined(KEY)="0")	//未加入结果集中则加入
	 		{
		 		s objEQueryPrintDaily=##class(DHCEPRFS.Entity.EQueryPrintDaily).%New()
		 		s objEQueryPrintDaily.UserID=objMRPrintCharge.FootUserID
		 		s objEQueryPrintDaily.UserName=""
		 		s objEQueryPrintDaily.FootDate=$zd(objMRPrintCharge.FootDate,3)
		 		s objEQueryPrintDaily.StartInvoiceNo=""
		 		s objEQueryPrintDaily.EndInvoiceNo=""
		 		s objEQueryPrintDaily.Count=0
		 		s objEQueryPrintDaily.NormalCount=0
		 		s objEQueryPrintDaily.CancelCount=0
		 		s objEQueryPrintDaily.Amount=0
		 		s objEQueryPrintDaily.CancelAmount=0
		 		s objEQueryPrintDaily.InvoiceCount=0
		 		s objEQueryPrintDaily.CancelInvoiceCount=0
		 		s objEQueryPrintDaily.CancelInvoices=""
		 		d arr.SetAt(objEQueryPrintDaily,KEY)
		 	}
		 	
		 	if (objMRPrintCharge.TotalAmount>0)		//全部笔数
	 		{ s arr.GetAt(KEY).Count=arr.GetAt(KEY).Count+1	}
	 		
	 		if (objMRPrintCharge.Status'="CANCEL")	//正常笔数
	 		{ s arr.GetAt(KEY).NormalCount=arr.GetAt(KEY).NormalCount+1	}
	 		
			if ((objMRPrintCharge.Status="CANCEL")&&(objMRPrintCharge.TotalAmount<0))	//作废笔数
	 		{ s arr.GetAt(KEY).CancelCount=arr.GetAt(KEY).CancelCount+1	}
	 		
	 		s arr.GetAt(KEY).Amount=arr.GetAt(KEY).Amount+objMRPrintCharge.TotalAmount	//金额
	 		if ((objMRPrintCharge.Status="CANCEL")&&(objMRPrintCharge.TotalAmount<0))	//作废金额
	 		{ s arr.GetAt(KEY).CancelAmount=arr.GetAt(KEY).CancelAmount+$ZABS(objMRPrintCharge.TotalAmount)	}
	 		
	 		
	 		///处理发票
	 		s MRPrintInvoiceID=""
	 		for {
		 		s MRPrintInvoiceID=$o(^DHCEPRFS.INST.MRPrintInvoiceI("IdxMRPrintChargeID"," "_objMRPrintCharge.%Id(),MRPrintInvoiceID))	
		 		q:(MRPrintInvoiceID="")
		 		s objMRPrintInvoice=##class(DHCEPRFS.INST.MRPrintInvoice).%OpenId(MRPrintInvoiceID)
		 		if (arr.GetAt(KEY).StartInvoiceNo="")	//起始票据号
		 		{
			 		s arr.GetAt(KEY).StartInvoiceNo=objMRPrintInvoice.InvoiceNO
			 	}
		 		else
		 		{
			 		if (..StringCompare(objMRPrintInvoice.InvoiceNO,arr.GetAt(KEY).StartInvoiceNo)=-1)
			 		{
				 		s arr.GetAt(KEY).StartInvoiceNo=objMRPrintInvoice.InvoiceNO
				 	}
			 	}
			 	if (arr.GetAt(KEY).EndInvoiceNo="")	//截止票据号
		 		{
			 		s arr.GetAt(KEY).EndInvoiceNo=objMRPrintInvoice.InvoiceNO
			 	}
		 		else
		 		{
			 		if (..StringCompare(objMRPrintInvoice.InvoiceNO,arr.GetAt(KEY).EndInvoiceNo)=1)
			 		{
				 		s arr.GetAt(KEY).EndInvoiceNo=objMRPrintInvoice.InvoiceNO
				 	}
			 	}
		 		s arr.GetAt(KEY).InvoiceCount=arr.GetAt(KEY).InvoiceCount+1	//票据张数
		 		
		 		if (objMRPrintInvoice.CancelFlag="1")	//作废票据张数
		 		{
			 		s arr.GetAt(KEY).CancelInvoiceCount=arr.GetAt(KEY).CancelInvoiceCount+1
			 		s CancelInvoices=arr.GetAt(KEY).CancelInvoices
			 		s thisInvoiceNo=objMRPrintInvoice.InvoiceNO
			 		if (thisInvoiceNo=$c(0))
			 		{
				 		s thisInvoiceNo=""
				 	}
			 		if (CancelInvoices="")
			 		{
				 		s CancelInvoices=thisInvoiceNo
				 	}
				 	else
				 	{
					 	s CancelInvoices=CancelInvoices_","_thisInvoiceNo
					}
					s arr.GetAt(KEY).CancelInvoices=CancelInvoices
			 	}
		 	}
	 	}
	}
	s totalUserName="合计:"
	s totalFootDate=""
	s totalStartInvoiceNo=""
	s totalEndInvoiceNo=""
	s totalCount=0
	s totalNormalCount=0
	s totalCancelCount=0
	s totalAmount=0
	s totalCancelAmount=0
	s totalInvoiceCount=0
	s totalCancelInvoiceCount=0
	s totalCancelInvoices=""
	
	//遍历array返回结果
	s oneKey=""
	for {
		s oneKey=arr.Next(oneKey)
	 	q:oneKey=""
	 	s obj=arr.GetAt(oneKey)	//取得数组里的对象
	 	
	 	if (AllUsersFlag="0")	//不是全用户
		{	
			continue:(arrUsers.IsDefined(obj.UserID)="0") //不是同区域操作员给予排除
		}
	 	s userName=""
	 	if ($p(obj.UserID ,"^",1) = "TEMP")
    	{	
			s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(obj.UserID,"^",2))
			s userName = objUser.UserName    
		}
		else
		{
			s userName = 
				##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetUserName(obj.UserID)
		}
	 	s ^CacheTemp(repid,ind) = $lb(obj.UserID,userName,obj.FootDate,obj.StartInvoiceNo,obj.EndInvoiceNo,
	 									obj.Count,obj.NormalCount,obj.CancelCount,obj.Amount,obj.CancelAmount,obj.InvoiceCount,obj.CancelInvoiceCount,obj.CancelInvoices)
		s ind = ind + 1
		s totalCount=totalCount+obj.Count
		s totalNormalCount=totalNormalCount+obj.NormalCount
		s totalCancelCount=totalCancelCount+obj.CancelCount
		s totalAmount=totalAmount+obj.Amount
		s totalCancelAmount=totalCancelAmount+obj.CancelAmount
		s totalInvoiceCount=totalInvoiceCount+obj.InvoiceCount
		s totalCancelInvoiceCount=totalCancelInvoiceCount+obj.CancelInvoiceCount
	}
	//增加合计行
	s ^CacheTemp(repid,ind) = $lb("",totalUserName,"","","",
	 									totalCount,totalNormalCount,totalCancelCount,totalAmount,totalCancelAmount,totalInvoiceCount,totalCancelInvoiceCount,"")
	q $$$OK
}

ClassMethod GetDailyChargeTotalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDailyChargeTotalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetDailyChargeTotalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDailyChargeTotalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 比较两个字符串的大小
/// Output:Integer str1>str2 返回 1，str1<str2 返回-1,str1<str2 返回0
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).StringCompare("A001","A002")
ClassMethod StringCompare(str1 As %String, str2 As %String) As %Integer
{
	s str1Length=$length(str1)
	s str2Length=$length(str2)
	s maxLength=0
	if (str1Length>str2Length)
	{ s maxLength=str1Length }
	else
	{ s maxLength=str2Length }
	
	s result=0
	for i=1:1:maxLength
	{
		if ($ASCII(str1,i)>$ASCII(str2,i))
		{
			s result=1
			q
		}
		if ($ASCII(str1,i)<$ASCII(str2,i))
		{
			s result=-1
			q
		}
	}
	q result
}

/// Desc: 查询当天患者打印暂存记录
/// Output: BeginActTime,MRPrintChargeID、MedRecordNo、Name、Pay
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRPrintCharge","GetCharge4Receipt","28")
Query GetCharge4Receipt(AMREpisodeID As %String) As %Query(ROWSPEC = "BeginActTime:%String,MRPrintChargeID:%String,MedRecordNo:%String,Name:%String,Pay:%String")
{
}

ClassMethod GetCharge4ReceiptExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1	
	
	//取得MRPatientID 
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s MRPatientID=objMREpisode.MRPatientID
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
	s Name=objMRPatient.Name
	
	//取当前时间
	s nowDate = $p($h,",",1)
	s MRPrintChargeID=""
	for {
		s MRPrintChargeID=$o(^DHCEPRFS.INST.MRPrintChargeI("IdxMRPatient"," "_MRPatientID,MRPrintChargeID))
		q:(MRPrintChargeID="")
		s objMRPrintCharge=##class(DHCEPRFS.INST.MRPrintCharge).%OpenId(MRPrintChargeID)
		if (objMRPrintCharge.BeginActDate=nowDate)
		{
			//取明细第一条MREpisodeID 并从MREpisode中取得MedRecordNo
			s MRPrintListRecID=$o(^DHCEPRFS.INST.MRPrintListRecI("IdxMRPrintChargeID"," "_MRPrintChargeID,""))
			s objMRPrintListRec=##class(DHCEPRFS.INST.MRPrintListRec).%OpenId(MRPrintListRecID)
			s objDetailMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(objMRPrintListRec.MREpisodeID)
			
			s ^CacheTemp(repid,ind) = $lb($zt(objMRPrintCharge.BeginActTime,1),MRPrintChargeID,
	 			objDetailMREpisode.MedRecordNo,Name,objMRPrintCharge.TotalAmount)
			s ind = ind + 1
		}
	}
	quit $$$OK
}

ClassMethod GetCharge4ReceiptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCharge4ReceiptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod GetCharge4ReceiptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCharge4ReceiptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 通过病案号获取患者出院的分院
/// Output: 分院名称
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetDtlHospital("500307")
ClassMethod GetDtlHospital(AMedRecordNo As %String) As %String
{
	s SysHospitalName=##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalName")
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	q:(hospitalFlag '= "NYFY") SysHospitalName	//非宁医返回系统配置医院名称
	
	s MREpisodeID=""
	s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxMedRecordNo"," "_AMedRecordNo,""))
	q:(MREpisodeID = "") SysHospitalName
	
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	q:(objMREpisode = "") SysHospitalName
	
	s DisLocID=objMREpisode.DisLocID
	q:(DisLocID = "") SysHospitalName

	s CTLocInfo = ##class(%ArrayOfDataTypes).%New()
	s CTLocInfo =##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetCTLocInfoByCTLocID(DisLocID)
	//s HospitalDR=$p($g(^CTLOC(DisLocID)),"^",22)
	s HospitalDR = CTLocInfo.GetAt("CTLocHospitalDR")
	q:(HospitalDR = "") SysHospitalName
	s HospInfo = ##class(%ArrayOfDataTypes).%New()
	s HospInfo =##Class(DHCEPRFS.BL.HISInfo.BLHISInfo).GetHospitalInfoByHospitalID(HospitalDR)
	s HospCode = HospInfo.GetAt("HospCode")
	//s HospCode=$p($g(^CT("HOSP",HospitalDR)),"^",1)
	//s HospitalName=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	
	if (hospitalFlag = "NYFY")	//宁医附院
	{
		if (HospCode="02")
		{
			q "宁夏医科大学总医院心脑血管病医院"
		}
		elseif (HospCode="07")
		{
			q "宁夏慈济老年病医院"
		}
		else
		{
			q "宁夏医科大学总医院"
		}
	}

	q SysHospitalName
}

/// Desc: 保存打印申请单
/// Output: ID
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).AddPrintApply("500307")
ClassMethod AddPrintApply(AEPrintApply As DHCEPRFS.Entity.EPrintApply) As %String
{
	 //s ^CacheTemp("DHCEPRFSTest","AddPrintApply")=$h
	 s nowDate = $p($h,",",1)
	 s nowTime = $p($h,",",2)
	 s objPrintApply=##class(DHCEPRFS.INST.PrintApply).%New()
	 
	 s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(AEPrintApply.MREpisodeID)
	 s objPrintApply.MRPatientID = objMREpisode.MRPatientID
	 s objPrintApply.MREpisodeID = AEPrintApply.MREpisodeID
	 s objPrintApply.ApplyDate = nowDate
	 s objPrintApply.ApplyTime = nowTime

	 s objPrintApply.Reason = AEPrintApply.Reason
	 s objPrintApply.Applicant = AEPrintApply.Applicant
	 s objPrintApply.ApplicantIDCard = AEPrintApply.ApplicantIDCard
	 s objPrintApply.Relation = AEPrintApply.Relation
	 s objPrintApply.UserID = AEPrintApply.UserID

	 s objPrintApply.Picture1 = AEPrintApply.Picture1
	 s objPrintApply.Picture2 = AEPrintApply.Picture2
	 s objPrintApply.Picture3 = AEPrintApply.Picture3
	 s objPrintApply.Picture4 = AEPrintApply.Picture4
	 s objPrintApply.CardType = AEPrintApply.CardType
	 
	 s status = objPrintApply.%Save()
	if ($$$ISOK(status))
	{
		q objPrintApply.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc: 获取打印申请单
/// Output: ID
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyByID("500307")
ClassMethod GetPrintApplyByID(APrintApplyID As %String) As DHCEPRFS.Entity.EPrintApply
{
	
     s AEPrintApply=##class(DHCEPRFS.Entity.EPrintApply).%New()
	 s objPrintApply=##class(DHCEPRFS.INST.PrintApply).%OpenId(APrintApplyID)
	
	 s AEPrintApply.MRPatientID = objPrintApply.MRPatientID
	 s AEPrintApply.MREpisodeID = objPrintApply.MREpisodeID
	 s AEPrintApply.ApplyDate = objPrintApply.ApplyDate
	 s AEPrintApply.ApplyTime = objPrintApply.ApplyTime
	 s AEPrintApply.Name = objPrintApply.Name
	 s AEPrintApply.Sex = objPrintApply.Sex
	 s AEPrintApply.IDCardNO =objPrintApply.IDCardNO
	 s AEPrintApply.DisDate = objPrintApply.DisDate
	 s AEPrintApply.DisLoc = objPrintApply.DisLoc
	 s AEPrintApply.MedRecordNo = objPrintApply.MedRecordNo
	 s AEPrintApply.HospitalNo = objPrintApply.HospitalNo
	 s AEPrintApply.Reason = objPrintApply.Reason
	 s AEPrintApply.Applicant = objPrintApply.Applicant
	 s AEPrintApply.ApplicantIDCard = objPrintApply.ApplicantIDCard
	 s AEPrintApply.Relation = objPrintApply.Relation
	 s AEPrintApply.UserID = objPrintApply.UserID
	 s AEPrintApply.SelfBase64 = objPrintApply.SelfBase64
	 s AEPrintApply.SelfName = objPrintApply.SelfName
	 s AEPrintApply.SelfSex = objPrintApply.SelfSex
	 s AEPrintApply.SelfNation = objPrintApply.SelfNation
	 s AEPrintApply.SelfBirth = objPrintApply.SelfBirth
	 s AEPrintApply.SelfAddress = objPrintApply.SelfAddress
	 s AEPrintApply.SelfCertNo = objPrintApply.SelfCertNo
	 s AEPrintApply.SelfDepartment = objPrintApply.SelfDepartment
	 s AEPrintApply.SelfEffectData = objPrintApply.SelfEffectData
	 s AEPrintApply.SelfExpire = objPrintApply.SelfExpire
	 s AEPrintApply.OtherBase64 = objPrintApply.OtherBase64
	 s AEPrintApply.OtherName = objPrintApply.OtherName
	 s AEPrintApply.OtherSex = objPrintApply.OtherSex
	 s AEPrintApply.OtherNation = objPrintApply.OtherNation
	 s AEPrintApply.OtherBirth = objPrintApply.OtherBirth
	 s AEPrintApply.OtherAddress = objPrintApply.OtherAddress
	 s AEPrintApply.OtherCertNo = objPrintApply.OtherCertNo
	 s AEPrintApply.OtherDepartment = objPrintApply.OtherDepartment
	 s AEPrintApply.OtherEffectData = objPrintApply.OtherEffectData
	 s AEPrintApply.OtherExpire = objPrintApply.OtherExpire
	 s AEPrintApply.SELFBM = objPrintApply.SELFBM
	 s AEPrintApply.SELFZM = objPrintApply.SELFZM
	 s AEPrintApply.OTHERBM = objPrintApply.OTHERBM
	 s AEPrintApply.OTHERZM = objPrintApply.OTHERZM
	 

	 q AEPrintApply
}

/// Desc: 根据日期和patientid获取证件留存信息
/// Output: DHCEPRFS.Entity.EPrintApply
/// param: MPatientid,applyDate 申请日期
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyByDateAndID("1","2020-5-9")
ClassMethod GetPrintApplyByDateAndID(MPatientid As %String, MApplyDate As %String) As DHCEPRFS.Entity.EPrintApply
{
	 s applyDate=$zdh(MApplyDate,3)
	 s rowid=$o(^DHCEPRFS.INST.PrintApplyI("IdxMRPatientIDAndApplyDate"," "_MPatientid,applyDate,""),-1)
     //b ;rowid
     q:rowid="" ""
     
     s printApply=##class(DHCEPRFS.INST.PrintApply).%OpenId(rowid)
     if ($isObject(printApply)){
	     s AEPrintApply=##class(DHCEPRFS.Entity.EPrintApply).%New()
	     S AEPrintApply.Applicant=printApply.Applicant
	     s AEPrintApply.ApplicantIDCard=printApply.ApplicantIDCard
	     s AEPrintApply.ApplyDate=printApply.ApplyDate
	     s AEPrintApply.ApplyTime=printApply.ApplyTime
	     s AEPrintApply.MREpisodeID=printApply.MREpisodeID
	     s AEPrintApply.MRPatientID=printApply.MRPatientID
	     s AEPrintApply.Reason=printApply.Reason
	     s AEPrintApply.Relation=printApply.Relation
	     s AEPrintApply.Picture1=printApply.Picture1
	     s AEPrintApply.Picture2=printApply.Picture2
	     s AEPrintApply.Picture3=printApply.Picture3
	     s AEPrintApply.Picture4=printApply.Picture4
	     s AEPrintApply.CardType=printApply.CardType
	     }
     
	 q AEPrintApply
}

/// Desc: 查询打印申请单记录
/// Output: ID
/// Debug: w ##class(DHCEPRFS.BL.BLMRPrintCharge).GetPrintApplyHis("32981")
ClassMethod GetPrintApplyHis(AMREpisodeID As %String) As %String
{
	s ret=""
	s PrintApplyID=""
	for {
		s PrintApplyID=$o(^DHCEPRFS.INST.PrintApplyI("IdxMREpisodeID"," "_AMREpisodeID,PrintApplyID),-1)
		q:(PrintApplyID="")
		s objPrintApply=##class(DHCEPRFS.INST.PrintApply).%OpenId(PrintApplyID)
		if (ret="")
		{
			s ret=PrintApplyID_"#"_$zd(objPrintApply.ApplyDate,3)
		}
		else
		{
			s ret=ret_"^"_PrintApplyID_"#"_$zd(objPrintApply.ApplyDate,3)
		}
	}
	q ret
}

}
