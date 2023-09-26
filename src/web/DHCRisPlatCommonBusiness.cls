Import SQLUser

/// 名称: DHCRisPlanCommon
/// 描述: 公共类方法，提供内部公用的取业务数据方法
/// 编写者：wf
/// 编写日期: 2017.6.7
Class web.DHCRisPlatCommonBusiness Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetPatInfoByRowid(patMasRowid As %String) As %String
{
	n (patMasRowid)
	s patInfo=""
	q:(patMasRowid="") patInfo
	s patId=$p($g(^PAPER(patMasRowid,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(patMasRowid,"ALL")),"^",1)
	s patDob=$p($g(^PAPER(patMasRowid,"ALL")),"^",6)
	s patDob=##class(web.DHCRisPlatCommon).ChangeDateToString(patDob)
	s patSexRowid=$p($g(^PAPER(patMasRowid,"ALL")),"^",7)
	i patSexRowid'="" s patSex=$p(^CT("SEX",patSexRowid),"^",2)

	
	s patInfo=$g(patId)_"^"_$g(patName)_"^"_$g(patDob)_"^"_$g(patSex)_"^"
	q patInfo
}

ClassMethod GetAdmInfoByRowid(admRowid As %String) As %String
{
	n (admRowid)
	s admInfo=""
	q:(admRowid="") admInfo
	s patType=$p($g(^PAADM(admRowid)),"^",2)
	s epissubTypeDr=$p($g(^PAADM(admRowid,1)),"^",6)
	if ((epissubTypeDr="8")||(epissubTypeDr="10"))
	{
		//特需或国疗
	}
	s appLocRowid=$p($g(^PAADM(admRowid)),"^",4)
	if ($g(appLocRowid)'="")
	{
		s appLocName=$p($g(^CTLOC(appLocRowid)),"^",2)
		if $f(appLocName,"-")>0
		{
			s appLocName=$p(appLocName,"-",2)
		}
	}
	//住院病人病区等信息
	if (patType="I")
	{
		s ipRoomDr=$p($g(^PAADM(admRowid)),"^",69)
		i ipRoomDr'="" s ipRoomDesc=$p($g(^PAROOM(ipRoomDr)),"^",2)
		s wardRowid=$p($g(^PAADM(admRowid)),"^",70)
		i (wardRowid'="")
		{
			s wardDesc=$p($g(^PAWARD(wardRowid)),"^",2)
			if $f(wardDesc,"-")>0
			{
				s wardDesc=$p(wardDesc,"-",2)
			}
		}
		s bedRowid=$p($g(^PAADM(admRowid)),"^",73)
		if (bedRowid'="")
		{
			s wardRowid=$p(bedRowid,"||",1)
			s bedChildSub=$p(bedRowid,"||",2)
			i bedChildSub'="" s bedName=$p($g(^PAWARD(wardRowid,"BED",bedChildSub)),"^",1)			
		}
	}
	
	s admReasonRowid=$p($g(^PAADM(admRowid,1)),"^",7)
	i (admReasonRowid'="")
	{
		;s feeTypeCode=$p($g(^PAC("ADMREA",admReasonRowid)),"^",1)
		s feeType=$p($g(^PAC("ADMREA",admReasonRowid)),"^",2)
	}
	

	s admInfo=$g(patType)_"^"_$g(appLocName)_"^"_$g(wardDesc)_"^"_$g(ipRoomDesc)_"^"_$g(bedName)_"^"_$g(feeType)
	q admInfo
}

ClassMethod GetAppBillInfo(orderRowid As %String, itemSubRowid As %String) As %String [ SqlProc ]
{
	n (orderRowid,itemSubRowid)
	s appInfo=""
	q:((orderRowid="")||(itemSubRowid="")) appInfo
	s appbillRowid=$o(^DHCRBAppOrdi(0,orderRowid_"||"_itemSubRowid,0))
	if (appbillRowid'="")
	{
		s xmlData=$g(^DHCRBApp("Bill",appbillRowid,"XMLContent"))
		s GetValue=$P(xmlData,"<HopeDate>",2)
		s hopeDate=$p(GetValue,"</HopeDate>",1)
		s hopeDate=##class(web.DHCRisPlatCommon).ChangeDateToLogical(hopeDate)
		s hopeDate=##class(web.DHCRisPlatCommon).ChangeDateToString(hopeDate)
		s GetValue2=$P(xmlData,"<LocDoctor>",2)
		s locDoctor=$p(GetValue2,"</LocDoctor>",1)
		s GetValue3=$P(xmlData,"<purpose>",2)
	    s Purpose=$p(GetValue3,"</purpose>",1)
	    if ( $d(^DHCRISAPPINFOS("APPLICATIONBILL",orderRowid_"||"_itemSubRowid)))
	    {
		    s bedOpeInfo=$p(^DHCRISAPPINFOS("APPLICATIONBILL",orderRowid_"||"_itemSubRowid),"^",7)
	    }
		s appInfo=$g(hopeDate)_"^"_$g(locDoctor)_"^"_$g(Purpose)_"^"_$g(bedOpeInfo)
	}
	q appInfo
}

/// w ##class(web.DHCRisPlatCommonBusiness).GetOrderItemInfo("10975147","3")
ClassMethod GetOrderItemInfo(orderRowid As %String, itemSubRowid As %String) As %String
{
	n (orderRowid,itemSubRowid)
	s orderInfo=""
	if ((orderRowid'="")&&(itemSubRowid'=""))
	{
		if $d(^OEORD(orderRowid,"I",itemSubRowid,1))
		{
			s arcItmRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",2)
			if ( $d(^ARCIM($p(arcItmRowid,"||",1),$p(arcItmRowid,"||",2),1)))
			{
				//s strOrderName=$p(^ARCIM($p(arcItmRowid,"||",1),$p(arcItmRowid,"||",2),1),"^",2)
				s strOrderName=..GetAppItemName(orderRowid_"||"_itemSubRowid)
				s orderDate=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",9)
				
				s strOrderDate=##class(web.DHCRisPlatCommon).ChangeDateToString(orderDate)
				s orderTime=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",17)
				s strOrderTime=$zt(orderTime,1)
				;w !,orderDate_"**"_strOrderDate
				s recLocRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",6)
				if (recLocRowid'="")
				{
					s recLocDesc=$p($g(^CTLOC(recLocRowid)),"^",2)
					if ($f(recLocDesc,"-")>0)
					{
						s recLocDesc=$p(recLocDesc,"-",2)
					}
				}
				s orderDocRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",11)
				if (orderDocRowid'="")
				{
					s orderDoc=$p($g(^CTPCP(orderDocRowid,1)),"^",2)
				}
				s orderPrice=..GetItemPrice(orderRowid,itemSubRowid)
				s billed=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",5)
				if (billed="P")
				{
					s billDesc="已收费"
				}
				else
				{
					s billDesc="未收费"
				}
				
			}
		}
	}
		
	s orderInfo=$g(strOrderName)_"^"_$g(strOrderDate)_"^"_$g(strOrderTime)_"^"_$g(recLocDesc)_"^"_$g(orderDoc)_"^"_$g(orderPrice)_"^"_$g(billDesc)_"^"_$g(orderDate)_"^"_$g(orderTime)
	q orderInfo
}

/// 获取首次预约时间和收费时间的差额
/// 19987585||3
/// w ##class(web.DHCRisPlatCommonBusiness).GetFirstBookTimePeriod("19987585||3")
ClassMethod GetFirstBookTimePeriod(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	s admRowid=$p(^OEORD($p(orderItemRowid,"||",1)),"^",1)
	s patType=$p($g(^PAADM(admRowid)),"^",2)
	if ($d(^DHCRisBookFirst(orderItemRowid)))
	{
		s firstBookDate=$p(^DHCRisBookFirst(orderItemRowid),"^",1)
		s firstbookTime=$p(^DHCRisBookFirst(orderItemRowid),"^",2)
	}
	
	s hourDiff=""
	if ( ($g(firstBookDate)'="") && ($g(firstbookTime)'="" ) )
	{
		if (patType'="I")
		{
			//获取收费时间
			s patientBillRowid=$o(^DHCPBi(0,"OEORI",orderItemRowid,""))
			if patientBillRowid'=""
			{
				s pbChildSub=$o(^DHCPBi(0,"OEORI",orderItemRowid,patientBillRowid,""))
				if ( pbChildSub'="")
				{
					s detailChildSub=$o(^DHCPB(patientBillRowid,"O",pbChildSub,"D",0))
					if (detailChildSub'="")
					{
						s billDate=$p(^DHCPB(patientBillRowid,"O",pbChildSub,"D",detailChildSub),"^",11)
						s billTime=$p(^DHCPB(patientBillRowid,"O",pbChildSub,"D",detailChildSub),"^",12)
						s dateDiff=firstBookDate-billDate
						s timeDiff=(firstbookTime-billTime)\3600
						b //01
						s hourDiff=((dateDiff*24)+timeDiff)_"H"
					}
				}
			}
		}
		else
		{
			//获取申请时间
			s appbillRowid=$o(^DHCRBAppOrdi(0,orderItemRowid,0))
			if (appbillRowid'="")
			{
				s appDate=$p(^DHCRBApp("Bill",appbillRowid),"^",1)
				s appTime=$p(^DHCRBApp("Bill",appbillRowid),"^",2)
				s dateDiff=firstBookDate-appDate
				s timeDiff=(firstbookTime-appTime)\3600
				s hourDiff=((dateDiff*24)+timeDiff)_"H"
			}
		}
		
	}
	
	q $g(hourDiff)
}

/// //////////w ##class(web.DHCRisPlatCommonBusiness).GetItemPrice("","")
ClassMethod GetItemPrice(orderRowid As %String, itemSubRowid As %String) As %String
{
	n (orderRowid,itemSubRowid)
	s price=""
	q:((orderRowid="")||(itemSubRowid="")) price
	
	s admRowidPrice=$p(^OEORD(orderRowid),"^",1)
	s arcItmRowidPrice=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",2)
	s stdDate=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",9)
	s oePrice=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",25)
	s insTypeRowid=$p($g(^PAADM(admRowidPrice,1)),"^",7)
	s episSubRowid=$p($g(^PAADM(admRowidPrice,1)),"^",6)
	s priceInfo=##class(web.UDHCJFPRICE).GetOrderPrice(episSubRowid,insTypeRowid,arcItmRowidPrice,stdDate,"","","",oePrice)
	s price=$p(priceInfo,"^",1)
	
	q price
}

/// 取预约明细表rowid
/// wf 
/// w ##class(web.DHCRisPlatCommonBusiness).getBookDetailRowid("")
ClassMethod GetBookDetailRowid(orderRowid As %String, itemSubRowid As %String, bodyRowid As %String = "") As %String
{
	n (orderRowid,itemSubRowid,bodyRowid)
	s bookDetailRowid=""
	q:((orderRowid="")||(itemSubRowid="")) bookDetailRowid
		
	s ResDetailRowid=""
	for 
	{
		s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderRowid_"||"_itemSubRowid,ResDetailRowid)) 
		q:(ResDetailRowid="")
		
	   	if (bodyRowid'="")
	   	{
			
		   s detailBodyRowid=$o(^User.DHCRBCSchduleDetailBodyI("IndexDetailBody",ResDetailRowid,bodyRowid,0))
		   ;b //02
		   if (detailBodyRowid'="")
		   {
			   s bookDetailRowid=ResDetailRowid
		   }

	   }
	   else
	   {
	   		s bookDetailRowid=ResDetailRowid
	   }
		
	}

    q bookDetailRowid
}

ClassMethod GetBookInfo(orderRowid As %String, itemSubRowid As %String, bodyRowid As %String = "") As %String
{
	n (orderRowid,itemSubRowid,bodyRowid)
	s bookInfo=""
	q:((orderRowid="")||(itemSubRowid="")) bookInfo
	s bookDetailRowid=..GetBookDetailRowid(orderRowid,itemSubRowid,bodyRowid)
	if (bookDetailRowid'="")
	{
		s seqNumber=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",21)
		s resScheduleID=$p(^DHCRBCResSchduleDetail("Detail",bookDetailRowid),"^",2)
       	i (resScheduleID'="")
       	{
       		s ResouceId=$p(^DHCRBCResourceSchdule(resScheduleID),"^",1)
       		s ResourceDesc="",ResourceCode=""
       		i ResouceId'="" d
       		.s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
       		.i EqId'="" d
       		..s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 

       
       		s scheduleDate=$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",2)
       		i scheduleDate'="" s bookDate=##class(web.DHCRisPlatCommon).ChangeDateToString(scheduleDate)  ;$zd(Date,3)
       		s scheduleSTime=$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",5) 
       		s scheduleETime=$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",6) 
       		s timePeriodeCode=$p($g(^DHCRBCResourceSchdule(resScheduleID)),"^",3)
       		i timePeriodeCode'="" 
       		{ 
    			s tpsRowid=$o(^DHCRBCTimePeriodSeti("Code",timePeriodeCode,0))
    			s bookTimeDesc=$p(^DHCRBCTimePeriodSet(tpsRowid),"^",2)
       		}
       		if ($g(bookTimeDesc)="")
       		{
	       		s bookTimeDesc=$zt(scheduleSTime,2)_"-"_$zt(scheduleETime,2)
       		}
       		
       		
       		;s info=ResSchduleID_"^"_ResourceDesc_"^"_BookedDate_"^"_BooketTime
       	}
       	
       	s bookInfo=$g(ResourceDesc)_"^"_$g(bookDate)_"^"_$g(bookTimeDesc)_"^"_$g(seqNumber)
	}
	q bookInfo
}

ClassMethod GetRegInfo(orderRowid As %String, itemSubRowid As %String, bodyRowid As %String = "") As %String
{
	n (orderRowid,itemSubRowid,bodyRowid)
	s regInfo=""
	q:((orderRowid="")||(itemSubRowid="")) risInfo
	
	s regInfoRowid=$o(^DHCPACRegInfoi("OEORI",orderRowid_"||"_itemSubRowid,"")) 
	i (regInfoRowid'="")
	{
		i $d(^DHCPACRegInfo(regInfoRowid))
		{
			s studyNo=$p(^DHCPACRegInfo(regInfoRowid),"^",2)
			s regDate=$p(^DHCPACRegInfo(regInfoRowid),"^",8)
			if (regDate'="")
			{
				s strRegDate=##class(web.DHCRisPlatCommon).ChangeDateToString(regDate)
			}		
			s regTime=$p(^DHCPACRegInfo(regInfoRowid),"^",9)
			if (regTime'="")
			{
				s strRegTime=$zt(regTime,1)
			}
			
			s regInfo=$g(studyNo)_"^"_$g(strRegDate)_"^"_$g(strRegTime)
		}
	}

	q regInfo
}

ClassMethod GetReportInfo(studyNo As %String) As %String
{
	n (studyNo)
	s reportInfo=""
	q:(studyNo="") reportInfo
	
	s reportRowid=$o(^DHCRBStudyi("Report","StudyNo",studyNo,""),-1)
	if (reportRowid'="")
	{
		s statusRowid=$p(^DHCRBStudy("Report",reportRowid),"^",4)
		;有报告默认为已录入
		if statusRowid="" s statusRowid=3
		if (statusRowid'="")
		{
			s statusDesc=$p(^DHCRBCStatus("ReportStatus",statusRowid),"^",2)
		}
		s reportDocRowid=$p(^DHCRBStudy("Report",reportRowid),"^",8)
		if (reportDocRowid'="")
		{
			s reportDoc=$p($g(^SSU("SSUSR",reportDocRowid)),"^",2)
		}
		s reportDate=$p(^DHCRBStudy("Report",reportRowid),"^",9)
		if (reportDate'="")
		{
			s strReportDate=##class(web.DHCRisPlatCommon).ChangeDateToString(reportDate)
		}
		s reportTime=$p(^DHCRBStudy("Report",reportRowid),"^",10)
		if (reportTime'="")
		{
			s strReportTime=$zt(reportTime,1)
		}
		
		s isPrint=$p(^DHCRBStudy("Report",reportRowid),"^",43)
		if (isPrint="")
		{
			s isPrint="未打印"
			s examCode="E"
		}
		else
		{
			s isPrint="打印"
			s examCode="P"
		}
		
		s reportInfo=$g(statusDesc)_"^"_$g(reportDoc)_"^"_$g(strReportDate)_"^"_$g(strReportTime)_"^"_$g(isPrint)_"^"_$g(examCode)
	}
	
	q reportInfo
}

// 记录操作日志( Book  Reg UnReg CancelBook ModifyBook)

// w ##class(web.DHCRisPlatCommonBusiness).SaveOperationLog()

ClassMethod SaveOperationLog(OpeUser As %String, PatNo As %String, OeordRowid As %String, OpeType As %String, OpeContent As %String, OpeLoc As %String, ClientIp As %String, Note As %String = "", operateSource As %String = "") As %String
{
	n (OpeUser,PatNo,OeordRowid,OpeType,OpeContent,OpeLoc,ClientIp,Note,operateSource)
	s OpeDate=+$h
	s OpeTime=$p($h,",",2)
	s OpeType=$zcvt(OpeType,"U")
	s operateSource=$zcvt(operateSource,"U")
	if (OpeUser="")
	{
		s logonUser=##class(web.DHCRisPlatCommon).GetSession("LOGON.USERID")
	}
	&sql(insert into DHCRB_OperationLog(DOL_User_DR, DOL_RegNO,DOL_OeItem_DR,DOL_OpeType,DOL_Content,DOL_OpeLoc,DOL_IP,DOL_OperationDate,DOL_OperationTime,DOL_Note,DOL_OpeSource)
	                    values(:OpeUser,:PatNo,:OeordRowid,:OpeType,:OpeContent,:OpeLoc,:ClientIp,:OpeDate,:OpeTime,:Note,:operateSource) )
	s ^DHCRisPlatTemp("SaveOperationLog")=SQLCODE
	//b //01
	q SQLCODE
}

// 获取取消原因 web.DHCRisPlatCommonBusiness

Query GetCancelReason() As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetCancelReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s resrowid=0 f  s resrowid=$o(^DHCRBRR("Reason",0,resrowid)) q:(resrowid="")  d
	.s ResInfo=$p(^DHCRBRR("Reason",0,resrowid),"^",1)
	.Do OutCancelReason
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutCancelReason
	set Data=$lb(ResInfo,resrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCancelReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCancelReasonExecute ]
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

ClassMethod GetCancelReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCancelReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 函数:GetServiceGroup
/// 入参:医嘱项ID
/// 返回值:服务组ID[多服务组用,分隔]^服务组
/// w ##class(web.DHCRisPlatCommonBusiness).GetServiceGroup("10446||1","192")
ClassMethod GetServiceGroup(arcimid, bodyRowid As %String = "") As %String
{
	n (arcimid,bodyRowid)
	
	s SerGroup="",SerGroupDR="",BPRowid="",Info="",SerID="",SerDesc=""
	s Find=0
	
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s child=""
			for 
			{
				s child=$o(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child))
				;b //04
				q:(child="")
				s SerGroupDR=$lg($g(^User.DHCRBCBookParamD(bookparamRowid,"BPChild",child)),2)
				;b //02
				i SerGroupDR'=""  s SerGroup=$p($g(^RBC("SG",SerGroupDR)),"^",2)
				i SerID="" s SerID=SerGroupDR
				e  s SerID=SerID_","_SerGroupDR
				i SerDesc="" s SerDesc=SerGroup
				e  s SerDesc=SerDesc_","_SerGroup
			}
			
		}
		
	}
	else //if (SerID="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  s SubRowid="" f  s SubRowid=$o(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)) q:(SubRowid="")  d
		  .s (Rowid,SerGroupDR,SerGroup)=""
		  .s Rowid=BPRowid_"||"_SubRowid
		  .s SerGroupDR=$p($g(^DHCRBCItemBookPropertySG("ServiceGroup",BPRowid,SubRowid)),"^",4)
		  .i SerGroupDR'="" s SerGroup=$p($g(^RBC("SG",SerGroupDR)),"^",2)
		  .i SerID="" s SerID=SerGroupDR
		  .e  d
		  ..s SerID=SerID_","_SerGroupDR
		  .i SerDesc="" s SerDesc=SerGroup
		  .e  d
		  ..s SerDesc=SerDesc_","_SerGroup
		  .s Find=1
		}
	
		
		if (Find=0)
		{
			s SerID=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),8),"^",7)
	        i SerID'="" s SerDesc=$p($g(^RBC("SG",SerID)),"^",2)
		}
		
	}
	
	s Info=SerID_"^"_SerDesc
	q Info
}

ClassMethod GetAppMemo(ArcItemRowid As %String) As %String
{
	n (ArcItemRowid)
	s Memo="",DMRowid="",UMCode=""
	s DMRowid=$o(^DHCRBAppi("Memo-ItMast",ArcItemRowid,0))
	i DMRowid'="" d
	.s MTRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",4)
	.q:(MTRowid="")
	.s UMRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",5)
	.i (UMRowid'="") d
	..s UMCode=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",1)
	..i UMCode="NP" d
	...s Memo="到综合服务台拿检查须知"
	..e  d
	...i MTRowid'="" s Memo=$p($g(^DHCRBCApp("Memo-Template",MTRowid)),"^",3)
	q Memo
}

ClassMethod GetEqAddress(resourceId As %String) As %String
{
	s RoomID="",RoomDesc=""
	s EqRowid=$p($g(^RB("RES",resourceId)),"^",3)
	i (EqRowid'="")
	{
		s RoomID=$o(^DHCRBC("EQDR-ROOM",EqRowid,RoomID))
		i RoomID'="" d
		.s RoomDesc= $p($g(^DHCRBC("Room",RoomID)),"^",2)
	}
	
	q RoomDesc
}

// 获取检查状态，用于主工作列表

ClassMethod GetExamStatus(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	s examStatus=""
	s appbillRowid=$o(^DHCRBAppOrdi(0,orderItemRowid,0))
	q:(appbillRowid="") ""
	s examStatus="A"
	s ResDetailRowid=$o(^DHCRBCResSchduleDetaili(0,orderItemRowid,0))
	if (ResDetailRowid'="")
	{
		s examStatus="B"
	}
	s regInfoRowid=$o(^DHCPACRegInfoi("OEORI",orderItemRowid,"")) 
	i (regInfoRowid'="")
	{
		s examStatus="R"
		i $d(^DHCPACRegInfo(regInfoRowid))
		{
			s studyNo=$p(^DHCPACRegInfo(regInfoRowid),"^",2)
		}
	}
	if ( $g(studyNo)'="")
	{
		s reportRowid=$o(^DHCRBStudyi("Report","StudyNo",studyNo,""),-1)
		if (reportRowid'="")
		{
			s examStatus="E"
			//增加打印、未打印状态
			s isPrint=$p(^DHCRBStudy("Report",reportRowid),"^",43)
			if (isPrint'="")
			{
				s examStatus="P"
			}
		}
	}
	
	q examStatus
}

/// 获取超声分区信息 web.DHCRisPlatCommonBusiness
/// d ##class(%ResultSet).RunQuery("web.DHCRisPlatCommonBusiness","GetUltraSonicDistrict") 
Query GetUltraSonicDistrict() As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

ClassMethod GetUltraSonicDistrictExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	/*
	s ochildsub=0 f  s ochildsub=$o(^SSU("SSUSR",2283,"OTHLL",ochildsub)) q:(ochildsub="")  d
	.s LocDR=$p(^SSU("SSUSR",2283,"OTHLL",ochildsub),"^",1)
	.i LocDR'="" d
	..s LocDesc=$p(^CTLOC(LocDR),"^",2)
	..i $f(LocDesc,"-")>0  s LocDesc=$p(LocDesc,"-",2)  
	..q:(LocDesc'["超声")
	..q:($d(outLocId(LocDR)))
	..Do outDistrict 
	
	;增加默认科室
	s LocDR=$p(^SSU("SSUSR",2283),"^",4)
	i LocDR'="" d
	.s LocDesc=$p(^CTLOC(LocDR),"^",2)
	.i $f(LocDesc,"-")>0  s LocDesc=$p(LocDesc,"-",2)  
	.q:(LocDesc'["超声")
	.q:($d(outLocId(LocDR)))
	.Do outDistrict 
	*/
	
	s locBookParamRowid=""
	for
	{
		s locBookParamRowid=$o(^DHCRISLocBookParam(locBookParamRowid))
		q:(locBookParamRowid="")
		s examCatCode=$p(^DHCRISLocBookParam(locBookParamRowid),"^",3)
		if (examCatCode'="CS" )
		{
			continue
		}
		s locCode=$p(^DHCRISLocBookParam(locBookParamRowid),"^",1)
		s LocDR=$o(^CTLOC(0,"Code",$zcvt(locCode,"U"),""))
		i LocDR'=""
		{
			s LocDesc=$p(^CTLOC(LocDR),"^",2)
			i $f(LocDesc,"-")>0  s LocDesc=$p(LocDesc,"-",2) 
			s locDescCs=##class(web.DHCRisPlatCommon).getCsLocDesc(locCode)
	        if (locDescCs'="")
	        {
				s LocDesc=locDescCs
	        }
			Do outDistrict 
		}
	}
	
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

outDistrict
	set Data=$lb(LocDesc,LocDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	s outLocId(LocDR)=0
	quit
}

ClassMethod GetUltraSonicDistrictFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUltraSonicDistrictExecute ]
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

ClassMethod GetUltraSonicDistrictClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUltraSonicDistrictExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 判断是否是超声检查 
/// w ##class(web.DHCRisPlatCommonBusiness).IsCsExam("10974916||4")
ClassMethod IsCsExam(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	q:(orderItemRowid="") "N"
	s isCsExam="N"
	s recLocRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),3)),"^",6)
	s orderDate=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",9)
	if ( $g(orderDate)<$zd("2017-08-21",3) )
	{
		q "N"
	}
	s locCode=$p(^CTLOC(recLocRowid),"^",1)
	if (locCode'="")
	{
		s locBookParamRowid=$o(^DHCRISLocBookParami("loc",locCode,0))
		if (locBookParamRowid'="")
		{
			s examCatCode=$p(^DHCRISLocBookParam(locBookParamRowid),"^",3)
			if (examCatCode="CS")
			{
				s isCsExam="Y"
			}
		}
	}
	q isCsExam
}

/// 获取医嘱名称，增加申请单上部位
/// w ##class(web.DHCRisPlatCommonBusiness).GetAppItemName("10974916||4")
ClassMethod GetAppItemName(OEorditemID As %String) As %String
{
	n (OEorditemID)
	//修正预约报错
	s OEorditemID = $p(OEorditemID,"$",1)
	s strItemName="",arcimid="",strOrderName="",Info=""
	s AppInfo="",Posture="",BodyPartDesc="",BodyInfo="",OtherBodyPart=""
	s perOrditemId=$p(OEorditemID,"@",1)
	q:(perOrditemId="") ""
	
	s OrderRowid =$p($g(perOrditemId),"||",1)
	s itemsub=$p($g(perOrditemId),"||",2)
	i (OrderRowid'="")&(itemsub'="")
	{
	   s arcimid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
       q:'$d(^ARCIM($p($g(arcimid),"||",1),$p($g(arcimid),"||",2),1))
       ;申请单上实际遗嘱名称
       s strOrderName=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),9)),"^",14) 
       i strOrderName="" s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2) 
       s AppInfo=$g(^DHCRISAPPINFOS("APPLICATIONBILL",perOrditemId))
       i (AppInfo'="") d
       .s OtherBodyPart=$p($g(AppInfo),"^",2)
       .i OtherBodyPart'=""  s OtherBodyPart=$p($g(OtherBodyPart),"&",2)
       .s Posture=$p($g(AppInfo),"^",4)
       .s BodyPart=$p($g(AppInfo),"^",5)
       .i (BodyPart'="") d
       ..s num=$l(BodyPart,"&")
       ..f i=1:1:num  d
       ...s BodyPartDesc=$p(BodyPart,"&",i)
       ...i BodyPartDesc="其他" s BodyPartDesc=OtherBodyPart
       ...q:(BodyPartDesc="")
       ...i BodyInfo="" s BodyInfo=BodyPartDesc
       ...e  d
       ....s BodyInfo=BodyInfo_"、"_BodyPartDesc
       s Info=Posture_BodyInfo_strOrderName

	}

    q Info
}

/// //////////////////////////////////////////////////////////////////////////////////////////////////
/// w ##class(web.DHCRisPlatCommonBusiness).GetpatTypeAndfeel("10975147||3")
ClassMethod GetpatTypeAndfeel(OEorditemID As %String) As %String
{
	n (OEorditemID)
	s Info=""
	s OrderRowid =$p($g(OEorditemID),"||",1)
	s itemsub=$p($g(OEorditemID),"||",2)
	s admRowid=$p(^OEORD(OrderRowid),"^",1)
	s patType=$p($g(^PAADM(admRowid)),"^",2)
	s epissubTypeDr=$p($g(^PAADM(admRowid,1)),"^",6)
	s billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	if (patType'="I")
	{
		if (billed="P")
		{ 
			s Info="Y"	
		}
		else{
			s Info="N"
			}
	} 
	else{
		s Info="Y"
		
		}
	q Info
}

/// 获取医嘱的默认接收科室(根据检查项目设置)
ClassMethod GetDefaultRecLoc(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	s ^DHCRisPlatTemp("GetDefaultRecLoc")=orderItemRowid
	q:(orderItemRowid="") ""
	s defaultRecLoc=""
	s orderRowid=$p(orderItemRowid,"||",1)
	s itemSubRowid=$p(orderItemRowid,"||",2)
	s arcItmRowid=$p($g(^OEORD(orderRowid,"I",itemSubRowid,1)),"^",2)
	s arcItmCode=$p(^ARCIM($p(arcItmRowid,"||",1),$p(arcItmRowid,"||",2),1),"^",1)
	s episodeRowid=$p($g(^OEORD(orderRowid)),"^",1)
	
	s patType=$p($g(^PAADM(episodeRowid)),"^",2)
	s appLocRowid=$p($g(^PAADM(episodeRowid)),"^",4)
	s appLocCode=$p(^CTLOC(appLocRowid),"^",1)
	s hospitalRowid=$p(^CTLOC(appLocRowid),"^",22)
	if (hospitalRowid'="")
	{
		s hospitalCode=$p(^CT("HOSP",hospitalRowid),"^",1)
	}
	
	//
	s recLocSetRowid=$o(^DHCRISRecLocSeti("arcAppLoc",arcItmCode,appLocCode,""))
	if (recLocSetRowid'="")
	{
		s defaultRecLoc=$p(^DHCRISRecLocSet(recLocSetRowid),"^",3)
	}
	else
	{
		//无申请科室判断的
		s recLocSetRowid=""
		for
		{
			s recLocSetRowid=$o(^DHCRISRecLocSeti("arc",arcItmCode,recLocSetRowid))
			q:(recLocSetRowid="")
			s applocGet=$p(^DHCRISRecLocSet(recLocSetRowid),"^",1)
			if (applocGet'="")
			{
				continue
			}
			s hospitalGet=$p(^DHCRISRecLocSet(recLocSetRowid),"^",7)
			s patTypeGet=$p(^DHCRISRecLocSet(recLocSetRowid),"^",8)
			s recLocGet=$p(^DHCRISRecLocSet(recLocSetRowid),"^",3)
			
			if ( (hospitalGet'="") && (hospitalGet'=hospitalCode))
			{
				continue
			}
			if ((patTypeGet'="") && (patTypeGet'=patType) )
			{
				continue
			}
			s defaultRecLoc=recLocGet
		}
	}
	
	q defaultRecLoc
}

/// w ##class(web.DHCRisPlatCommonBusiness).GetOeitemRecLoc("10975147||3")
ClassMethod GetOeitemRecLoc(orderItemRowid As %String) As %String
{
	s orderRowid=$p($g(orderItemRowid),"||",1)
	s itemSubRowid=$p($g(orderItemRowid),"||",2)
	s RecLocdr=$p($g(^OEORD(orderRowid,"I",itemSubRowid,3)),"^",6)
	q RecLocdr
}

/// 获取医嘱部位(新申请单)
ClassMethod GetBodyList(orderItemRowid As %String) As %String
{
	n (orderItemRowid)
	q:(orderItemRowid="") ""
	
	s arReqID=$o(^DHCAPREP(0,"OrdItem",orderItemRowid,""))
	q:(arReqID="") ""
	
	s CH=$o(^DHCAPREP(0,"OrdItem",orderItemRowid,arReqID,""))
	q:(CH="") ""
	
	q:('$d(^DHCAPREP(arReqID,"AR",CH))) ""
	
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	
	s PartList=""
	s Sub="" f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	.s ExtStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) 
	.q:PartID=0
	.q:ExtStat="D"
	.;s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 				 ///部位
	.i PartList'="" s PartList=PartList_","_PartID
	.e  s PartList=PartID
	
	q PartList
}

/// 是否已经预约
ClassMethod hasBookOrder(orderList1 As %String) As %String
{
	n (orderList1)
	s hasBook="N"
	s detailRowid=""
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
						   s detailRowid=ResDetailRowid
					   }
				   }
			   }
		   }
		   else
		   {
		   	s hasBook="Y"
		   	s detailRowid=ResDetailRowid
		   }
			
		}
	}

    q hasBook_"^"_$g(detailRowid)
}

/*
/// 获取预约明细表rowid
ClassMethod getBookDetailRowid(orderList1 As %String) As %String
{
	n (orderList1)
	s detialRowid=""
	q:(orderList1="") detialRowid
	//需判断是否预约在一起
	s bookDifference=""
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
						   if (detialRowid="")
						   {
							   s detialRowid=ResDetailRowid1
						   }
						   else
						   {
							   if (detialRowid'=ResDetailRowid1)
							   {
								   s bookDifference="Y"
							   }
						   }
						   
					   }
				   }
			   }
		   }
		   else
		   {
		   	   if (detialRowid="")
			   {
				   s detialRowid=ResDetailRowid1
			   }
			   else
			   {
				   if (detialRowid'=ResDetailRowid1)
				   {
					   s bookDifference="Y"
				   }
			   }
		   }
			
		}
	}

    q detialRowid_"^"_bookDifference
}
*/
ClassMethod getBookType(orderRowid, bodyRowid As %String = "") As %String
{
	n (orderRowid, bodyRowid)
	s appointMethodId=""
	s Find=0
	s bookTypeRet=""
	q:(orderRowid="") ""
	s arcimid=$p(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1),"^",2)
	//b //008
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s appointMethodId=$lg(^User.DHCRBCBookParamD(bookparamRowid),5)
		}
		
	}	
	else //if (appointMethodId="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  	s appointMethodId=$p(^DHCRBCItemBookProperty(BPRowid),"^",2)
		}
		
	}
	
	if (appointMethodId'="")
	{
		s appointMethodDesc=$p(^DHCRBCAppointMethod(appointMethodId),"^",2)
		s bookTypeRet=appointMethodId_"^"_appointMethodDesc
	}
	q bookTypeRet
}

/// 判断是否自动预约
ClassMethod isAutoBook(orderBodyList As %String) As %String
{
	n (orderBodyList)
	s isAutoBook=""
	for num=1:1:$l(orderBodyList,"@")
	{
		s orderBody=$p(orderBodyList,"@",num)
		s orderRowid=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)
		q:(isAutoBook="N")
		for k=1:1:$l(bodyList,",")
		{
			//b //006
			s body=$p(bodyList,",",k)
			s bookType=..getBookType(orderRowid,body)
			s bookTypeDesc=$p(bookType,"^",2)
			//b //007
			if ( bookTypeDesc="自动预约")
			{
				s isAutoBook="Y"
			}
			else
			{
				s isAutoBook="N"
			}
			q:(isAutoBook="N")
		}
		
	}
	
	b //isAutoBook
	q isAutoBook
}

ClassMethod getBookParam(orderRowid, bodyRowid As %String = "") As %String
{
	n (orderRowid, bodyRowid)

	q:(orderRowid="") ""
	
	s arcimid=$p(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1),"^",2)
	if (bodyRowid'="")
	{
		s bookparamRowid=""
		s bookparamRowid=$o(^User.DHCRBCBookParamI("IndexItemBody",arcimid,bodyRowid,0))
		if (bookparamRowid'="")
		{
			s isEmpty=$lg(^User.DHCRBCBookParamD(bookparamRowid),6)
		}
		
	}	
	else //if (appointMethodId="")
	{
		s BPRowid=$o(^DHCRBCItemBookProperTypei(arcimid,0))
		i (BPRowid'="")
		{
		  	s isEmpty=$p(^DHCRBCItemBookProperty(BPRowid),"^",4)
		}
		
	}
	
	
	q $g(isEmpty)
}

/// 是否空腹isEmpty
ClassMethod isEmpty(orderBodyList As %String) As %String
{
	n (orderBodyList)
	s isEmptyRet=""
	for num=1:1:$l(orderBodyList,"@")
	{
		s orderBody=$p(orderBodyList,"@",num)
		s orderRowid=$p(orderBody,"$",1)
		s bodyList=$p(orderBody,"$",2)

		for k=1:1:$l(orderBody,",")
		{
			s body=$p(orderBody,",",k)
			s isEmpty=..getBookParam(orderRowid,body)
			if (isEmpty="Y")
			{
				s isEmptyRet="Y"
			}
		}
		
	}
	
	q isEmptyRet
}

/// 入参:医嘱rowid串@  (有可能含部位)
/// 返回值:服务组ID^服务组ID
/// 作者:wf 20160801
/// w ##class(web.DHCRisPlatCommonBusiness).GetSameServiceGroup("1635||13@1635||14")
ClassMethod GetSameServiceGroup(orderItemList) As %String
{
	n (orderItemList)
	s ^DHCRisTemp("GetSameServiceGroup")=orderItemList
	
	s serviceGrouplist=""
	s serviceGroupOrderList=""
	s number=0
	for lenOfList=1:1:$l(orderItemList,"@")
	{
		
		s orderBodyList=$p(orderItemList,"@",lenOfList)
		if (orderBodyList'="")
		{
			
			s orderRowid=$p(orderBodyList,"$",1)
			s arcimid=$p($g(^OEORD($p(orderRowid,"||",1),"I",$p(orderRowid,"||",2),1)),"^",2)
			s bodyList=$p(orderBodyList,"$",2)
			if (bodyList'="")   //有部位
			{
				for lenOfBody=1:1:$l(bodyList,",")
				{
					s bodyRowid=$p(bodyList,",",lenOfBody)
					if (bodyRowid'="")
					{
						s number=number+1
						s serviceList=..GetServiceGroup(arcimid,bodyRowid)
						
						s serviceGroupList=$p(serviceList,"^",1)
						for i=1:1:$l(serviceGroupList,",")
						{
							s SerGroupDR=$p(serviceGroupList,",",i)
							if (SerGroupDR'="")
							{
								if ($d(serviceGroupOrderList(SerGroupDR))) d
								.s serviceGroupOrderList(SerGroupDR)=serviceGroupOrderList(SerGroupDR)_"^"_number
								e  d
								.s serviceGroupOrderList(SerGroupDR)=number
							}
						}
					}
				}
			}
			else    //没有部位
			{
				s number=number+1
				s serviceList=..GetServiceGroup(arcimid,"")
				s serviceGroupList=$p(serviceList,"^",1)
				for i=1:1:$l(serviceGroupList,",")
				{
					s SerGroupDR=$p(serviceGroupList,",",i)
					if (SerGroupDR'="")
					{
						if ($d(serviceGroupOrderList(SerGroupDR))) d
						.s serviceGroupOrderList(SerGroupDR)=serviceGroupOrderList(SerGroupDR)_"^"_number
						e  d
						.s serviceGroupOrderList(SerGroupDR)=number
					}
				}
					
					
			}	
		}
	}
	
	s serviceGroupDr=""  f  s serviceGroupDr=$o(serviceGroupOrderList(serviceGroupDr)) q:(serviceGroupDr="")  d
	.if ($l(serviceGroupOrderList(serviceGroupDr),"^")=number) d
	..if serviceGrouplist="" d
	...s serviceGrouplist=serviceGroupDr
	..e  d
	...s serviceGrouplist=serviceGrouplist_"^"_serviceGroupDr
	
	
	k serviceGroupOrderList
	q serviceGrouplist
}

ClassMethod getRegRowid(orderItemRowid As %String, bodyRowID As %String = "") As %String
{
	s ^TempDHCRis("getRegRowid")=$lb(orderItemRowid,bodyRowID)
	
	n (orderItemRowid,bodyRowID)
	s rowidRet=""
	s reginfoRowid=""
	for
	{
		s reginfoRowid=$o(^DHCPACRegInfoi("OEORI",orderItemRowid,reginfoRowid))
		q:(reginfoRowid="")
		if (bodyRowID="")
		{
			s rowidRet=reginfoRowid
		}
		else
		{
			s childSub=""
			for 
			{
				s childSub=$o(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub))
				q:(childSub="")
				s bodyDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,reginfoRowid,childSub),"^",1)
				if (bodyDr=bodyRowID )
				{
					s rowidRet=reginfoRowid
				}
			}
		}
		
	}
	
	q rowidRet
}

}
