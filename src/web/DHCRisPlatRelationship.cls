Import SQLUser

/// 通用的检查关系判断方法
Class web.DHCRisPlatRelationship Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取患者所有未登记医嘱信息(数据来源于DHCRis_worlsit表，不从医嘱表获取)
/// w ##class(web.DHCRisPlatRelationship).GetWorklistByPatId("40189332")
ClassMethod GetWorklistByPatId(patID As %String) As %String
{
	n (patID)
	q:(patID="") ""
	
	s sql="SELECT OrderItemRowid, ArcItemRowid , Status , BodyCode , BookInfoRowid ,RegInfoRowid ,BodyRowid FROM DHCRIS_WorkList WHERE PatID=?"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sql)
	d result.Execute(patID)
	
	s examList=""
	while (result.Next())
	{
		//w !,result.Status
		
		//医嘱状态判断, 还需要增加部位状态的判断？？
		s orderItemRowid=result.OrderItemRowid
		s ItemStatDR=$p(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1),"^",13) ; 医嘱状态
    	i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    	b //01
    	continue:(($g(ItemStatusCode)="D")||($g(ItemStatusCode)="C")||($g(ItemStatusCode)="U"))
		
		//增加收费状态的判断 (门诊是否收费,应该增加配置【不收费是否允许预约】)
		s orderInfo=""
		if (result.RegInfoRowid="")
		{
			s orderInfo=orderItemRowid_"^"_result.BodyRowid_"^"_result.ArcItemRowid_"^"_result.BookInfoRowid_"^"_result.BodyCode
		}
		if (orderInfo'="")
		{
			if (examList="") s examList=orderInfo
			e  s examList=examList_"&&"_orderInfo
		}
	}
	
	q examList
}

/// w ##class(web.DHCRisPlatRelationship).GetExamlistByPatId("40189332")
ClassMethod GetExamlistByPatId(patientID As %String) As %String
{
	n (patientID)
	s ^DHCRisTemp("GetExamlistByPatId")=patientID
	s patientID=$ZCONVERT(patientID,"U")
	s NoRowid=$o(^PAPERi("PAPMI_PatNo",patientID,0))
	if NoRowid=""  q ""
	s examList=""
	s paadmtype="" f  s paadmtype=$o(^PAPERdr(NoRowid,"ADM",paadmtype)) q:paadmtype=""  d
	.s paadmrowid=0 f  s paadmrowid=$o(^PAPERdr(NoRowid,"ADM",paadmtype,paadmrowid)) q:paadmrowid=""  d
	..s OrderRowid=0 f  s OrderRowid=$o(^OEORD(0,"Adm",paadmrowid,OrderRowid)) q:OrderRowid=""  d
	...s itemsub=0  f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:itemsub=""  d
	....s (oeorditemdr,recLoc,ItemMastDr,ServerMaterial,OrdDate)=""
	....s oeorditemdr=OrderRowid_"||"_itemsub
	....s recLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	....q:recLoc=""
	....s OrdDate=$P(^OEORD(OrderRowid,"I",itemsub,1),"^",9)
	....;q:(recLoc'=LocDr)
	....q:((+$h-OrdDate)>100)
	....s ItemMastDr=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	....;w !,"ItemMastDr="_ItemMastDr
    ....q:(ItemMastDr="")
    ....s ServerMaterial=$p($g(^ARCIM($p(ItemMastDr,"||",1),$p(ItemMastDr,"||",2),7)),"^",6)
    ....;w !,"ServerMaterial="_ServerMaterial
    ....q:(ServerMaterial'="Service")&(ServerMaterial'="S")
    ....;过滤掉执行、停止和未激活的医嘱  
    ....s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
    ....i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
    ....;w !,"ItemStatusCode="_ItemStatusCode
    ....;q:((ItemStatusCode="D")||(ItemStatusCode="I")||(ItemStatusCode="E"))
    ....q:((ItemStatusCode="D")||(ItemStatusCode="I"))
    ....s (resDetailDR,RegInfoDR)=""
    ....s resDetailDR=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,resDetailDR))
    ....s RegInfoDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,RegInfoDR))
    ....i examList="" s examList=oeorditemdr ;;examList=oeorditemdr_"^"_""_"^"_ItemMastDr_"^"_resDetailDR_"^"
    ....e  s examList=examList_"@"_oeorditemdr  ;;examList=examList_"&&"_oeorditemdr_"^"_""_"^"_ItemMastDr_"^"_resDetailDR_"^"
    q examList
}

/*
293||97$70^293||91$^P^warn^24^小时&&
293||97$70^293||90$^P^warn^24^小时&&
293||97$70^293||93$^P^warn^24^小时&&
293||97$70^293||88$^P^warn^24^小时&&
293||97$70^293||85$^P^warn^24^小时&&
293||97$70^293||96$^P^warn^24^小时&&
293||97$70^293||48$^P^warn^24^小时&&
293||95$^293||91$^R^force^1^天&&
293||95$^293||90$^R^force^1^天&&
293||95$^293||93$^R^force^1^天&&
293||95$^293||88$^R^force^1^天&&
293||95$^293||85$^R^force^1^天&&
293||95$^293||96$^R^force^1^天&&
293||95$^293||48$^R^force^1^天
*/
/// wf 20190301
/// 查找医嘱关系
/// 入参 ：  医嘱id$部位@....//医嘱id^部位^^$$医嘱id^部位id^^&&....
/// 返回值 ：医嘱id^部位id^关系医嘱id^关系部位id^关系类型[R/P]^提示类型^时间^时间单位&&....
/// w ##class(web.DHCRisPlatRelationship).GetOrderRelationShip()
ClassMethod GetOrderRelationShip(orderList As %String) As %String
{
	n (orderList)
	
	s retRelationShip=""
	for i=1:1:$l(orderList,"@")
	{
		if ($p($p(orderList,"@",i),"$",2)'="")
		{
			s orderBody=$p($p(orderList,"@",i),"$",1)_"$"_$p($p(orderList,"@",i),"$",2)
		}
		else
		{
			s orderBody=$p($p(orderList,"@",i),"$",1)
		}
		
		
		for j=1:1:$l(orderList,"@")
		{
			
			continue:(i=j)	
			
			if ($p($p(orderList,"@",j),"$",2)'="")
			{
				s orderBodyAs=$p($p(orderList,"@",j),"$",1)_"$"_$p($p(orderList,"@",j),"$",2)
			}
			else
			{
				s orderBodyAs=$p($p(orderList,"@",j),"$",1)
			}
			
			//查找2条医嘱之间的关系
			s rejectRowid=..GetRejectInfo(orderBody,orderBodyAs)
			;w !,"reject="_orderBody_"****"_orderBodyAs_"****"_rejectRowid
			if (rejectRowid'="")
			{
				s rejectTime=$lg(^User.DHCRBExamRejectItemD(rejectRowid),5)
				s rejectTimeSpan=$lg(^User.DHCRBExamRejectItemD(rejectRowid),6)
				s rejectHintType=$lg(^User.DHCRBExamRejectItemD(rejectRowid),15)
				if (retRelationShip="")
				{
					s retRelationShip=orderBody_"^"_orderBodyAs_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
				}
				else
				{
					s retRelationShip=retRelationShip_"&&"_orderBody_"^"_orderBodyAs_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
				}
			}
			s prepositionRowid=..GetPrepositionInfo(orderBody,orderBodyAs)
			;w !,"prepositon="_orderBody_"****"_orderBodyAs_"****"_prepositionRowid
			if (prepositionRowid'="")
			{
				s prepositionTime=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),4)
				s propositionTimeSpan=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),6)
				s prepositionHintType=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),15)
				if (retRelationShip="")
				{
					s retRelationShip=orderBody_"^"_orderBodyAs_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
				}
				else
				{
					s retRelationShip=retRelationShip_"&&"_orderBody_"^"_orderBodyAs_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
				} 
			}
		}
	}
	q retRelationShip
}

/// w ##class(web.DHCRisPlatRelationship).GetRejectInfo("293||95","293||48")  patid  290  293||97$70
/// 是否是互斥关系
/// 返回排斥关系表rowid，为空即为不排斥
ClassMethod GetRejectInfo(orderBody As %String, orderBodyTwo As %String) As %String
{
	n (orderBody,orderBodyTwo)
	
	//b //getrejectinfo
	s orderItemRowid=$p(orderBody,"$",1)
	s itemMastRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
	s orderItemBody=$p(orderBody,"$",2)
	
	s orderItemRowidTwo=$p(orderBodyTwo,"$",1)
	s itemMastRowidTwo=$p($g(^OEORD($p(orderItemRowidTwo,"||",1),"I",$p(orderItemRowidTwo,"||",2),1)),"^",2)
	s orderItemBodyTwo=$p(orderBodyTwo,"$",2)
	s isReject="N"
	s rejectRowidRet=""
	
	//项目之间关系
	s rejectTabelRowid=""
	for	
	{
		s rejectTabelRowid=$o(^User.DHCRBExamRejectItemI("RejectItmMastIndex"," "_itemMastRowid," "_itemMastRowidTwo,rejectTabelRowid))
		q:(rejectTabelRowid="")
		q:(isReject="Y")
		s itemMastBodyRowid=$lg(^User.DHCRBExamRejectItemD(rejectTabelRowid),13)
		s rejectItemMastBodyRowid=$lg(^User.DHCRBExamRejectItemD(rejectTabelRowid),11)

		//continue:((itemMastBodyRowid'=itemMastRowid)&&(itemMastBodyRowid'=""))
		if (itemMastBodyRowid="")
		{
			if (rejectItemMastBodyRowid="")
			{
				s isReject="Y"
			}
			elseif (orderItemBodyTwo=rejectItemMastBodyRowid)
			{
				s isReject="Y"
			}
		}
		else
		{
			if (itemMastBodyRowid=orderItemBody)
			{
				if (rejectItemMastBodyRowid="")
				{
					s isReject="Y"
				}
				elseif (orderItemBodyTwo=rejectItemMastBodyRowid)
				{
					s isReject="Y"
				}
			}
		}
		if (isReject="Y")
		{
			s rejectRowidRet=rejectTabelRowid
		}
	}
	
	//和组之间的关系,没有找到项目和项目匹配后再查组关系
	if (isReject="N")
	{	
		s rejectExamID=""
		for
		{
			s rejectExamID=$o(^User.DHCRBExamRejectItemI("ExamGroupIndex"," "_itemMastRowid,rejectExamID))
			q:(rejectExamID="")
			q:(isReject="Y")

			//判断是否属于这个组
			if ( ..isInExamGroup(orderBodyTwo,rejectExamID)="Y")
			{
				s isReject="Y"
				s rejectRowidRet=$o(^User.DHCRBExamRejectItemI("ExamGroupIndex"," "_itemMastRowid,rejectExamID,""))
			}
		}
	}
	q $g(rejectRowidRet)
}

/// w ##class(web.DHCRisPlatRelationship).GetPrepositionInfo("293||97$70","293||48")
/// 是否是前置关系
/// 返回前置关系表rowid，为空即为不是前置关系
ClassMethod GetPrepositionInfo(orderBody As %String, orderBodyTwo As %String) As %String
{
	n (orderBody,orderBodyTwo)
	s orderItemRowid=$p(orderBody,"$",1)
	s itemMastRowid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
	s orderItemBody=$p(orderBody,"$",2)
	
	s orderItemRowidTwo=$p(orderBodyTwo,"$",1)
	s itemMastRowidTwo=$p($g(^OEORD($p(orderItemRowidTwo,"||",1),"I",$p(orderItemRowidTwo,"||",2),1)),"^",2)
	s orderItemBodyTwo=$p(orderBodyTwo,"$",2)
	
	s isPreposition="N"
	s prepositionRowidRet=""
	
	//项目之间关系
	s prepositionTabelRowid=""
	for	
	{
		s prepositionTabelRowid=$o(^User.DHCRBExamPrepositionItemI("PreItmMastIndex"," "_itemMastRowid," "_itemMastRowidTwo,prepositionTabelRowid))
		q:(prepositionTabelRowid="")
		s itemMastBodyRowid=$lg(^User.DHCRBExamPrepositionItemD(prepositionTabelRowid),13)
		s preItemMastBodyRowid=$lg(^User.DHCRBExamPrepositionItemD(prepositionTabelRowid),11)

		//continue:((itemMastBodyRowid'=itemMastRowid)&&(itemMastBodyRowid'=""))
		if (itemMastBodyRowid="")
		{
			if (preItemMastBodyRowid="")
			{
				s isPreposition="Y"
			}
			elseif (orderItemBodyTwo=preItemMastBodyRowid)
			{
				s isPreposition="Y"
			}
		}
		else
		{
			if (itemMastBodyRowid=orderItemBody)
			{
				if (preItemMastBodyRowid="")
				{
					s isPreposition="Y"
				}
				elseif (orderItemBodyTwo=preItemMastBodyRowid)
				{
					s isPreposition="Y"
				}
			}
		}
		if (isPreposition="Y")
		{
			s prepositionRowidRet=prepositionTabelRowid
		}
	}
	
	//和组之间的关系,没有找到项目和项目匹配后再查组关系
	if (isPreposition="N")	
	{
		s preExamID=""
		for
		{
			s preExamID=$o(^User.DHCRBExamPrepositionItemI("ExamGroupIndex"," "_itemMastRowid,preExamID))
			q:(preExamID="")

			//判断是否属于这个组
			if ( ..isInExamGroup(orderBodyTwo,preExamID)="Y")
			{
				s isPreposition="Y"
				s prepositionRowidRet=$o(^User.DHCRBExamPrepositionItemI("ExamGroupIndex"," "_itemMastRowid,preExamID,""))
			}
		}
	}
	
	q $g(prepositionRowidRet)
}

/// 名称：
/// 功能：查询检查项目是否属于组
/// 参数：
/// 返回：
/// 作者：wangfeng
/// 日期：2018-12-27
/// w ##class(web.DHCRisPlatRelationship).isInExamGroup("293||48","3")
ClassMethod isInExamGroup(orderBody As %String, examGroupDr As %String) As %String
{
	n (orderBody,examGroupDr)
	s isIn="N"
	q:((orderBody="" )||(examGroupDr="")) isIn
	s orderItemRowid=$p(orderBody,"$",1)
	s arcimid=$p($g(^OEORD($p(orderItemRowid,"||",1),"I",$p(orderItemRowid,"||",2),1)),"^",2)
	s bodyRowid=$p(orderBody,"$",2)
	s itmCatDr=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)
	
	q:(itmCatDr="") isIn
	
	s itmMastDrGroup=$p($g(^DHCRBExamGroup(examGroupDr)),"^",3)
	
	if ( itmMastDrGroup'="")
	{
		if (itmMastDrGroup=arcimid)
		{
			s isIn="Y"
		}
	}
	else
	{
		
		s itmCatDrGroup=$p($g(^DHCRBExamGroup(examGroupDr)),"^",4)
		s relationship=$p($g(^DHCRBExamGroup(examGroupDr)),"^",5)
		
		//支持部位后可能会有多个
		s findItem="N"
		s examItemSubDr=""
		for
		{
			s examItemSubDr=$o(^DHCRBExamGroup(0,"ItemMastIndex",arcimid,examGroupDr,examItemSubDr))
			q:(examItemSubDr="")
			
			s bodyRowidGet=$p(^DHCRBExamGroup(0,"ExamItem",examGroupDr,examItemSubDr),"^",5)
			
			if (bodyRowidGet="")
			{
				s findItem="Y"
			}
			else
			{
				if (bodyRowidGet=bodyRowid)
				{
					s findItem="Y"
				}
			}
			
		}
		
		if (relationship="out")
		{
			if (itmCatDr=itmCatDrGroup)
			{
				if (findItem="N")
				{
					s isIn="Y"
				}
			}
		}
		else
		{
			if (findItem="Y")
			{
				s isIn="Y"
			}
			else
			{
				
				//没找到可以能是只配置的子类,并且没有子表记录
				s childSub=$o(^DHCRBExamGroup(0,"ExamItem",examGroupDr,""))
				
				if (childSub="")
				{
					if (itmCatDr=itmCatDrGroup)
					{
						s isIn="Y"
					}
				}
			}
		}
		

		
	}
	q isIn
}

/// w ##class(web.DHCRisPlatRelationship).GetRelationShipByOrderItem("26980347||5","606142")
/// 获取一条医嘱的所有关系的医嘱列表
ClassMethod GetRelationShipByOrderItem(orderItemRowid As %String, schduleRowid As %String) As %String
{
	n (orderItemRowid,schduleRowid)
	
	s ^TEMPDHCRis("GetRelationShipByOrderItem")=$lb(orderItemRowid,schduleRowid)
	q:((orderItemRowid="")||(schduleRowid="")) ""
	
	s admRowId=$p(^OEORD($p(orderItemRowid,"||",1)),"^",1)
	s patMasRowid=$p(^PAADM(admRowId),"^",1)
	//s patName=$p($g(^PAPER(patMasRowid,"ALL")),"^",1)
	s patientID=$p($g(^PAPER(patMasRowid,"PAT",1)),"^",1)
	
	s orderList=..GetExamlistByPatId(patientID)
	
	b //orderList
	
	s retRelationShip=""
	for i=1:1:$l(orderList,"@")
	{
		s orderItemFind=$p(orderList,"@",i)
		
		continue:(orderItemFind="")
		continue:(orderItemFind=orderItemRowid)	
			
		//查找2条医嘱之间的关系
		s rejectRowid=..GetRejectInfo(orderItemRowid,orderItemFind)
		;w !,"reject="_orderBody_"****"_orderBodyAs_"****"_rejectRowid
		if (rejectRowid'="")
		{
			s rejectTime=$lg(^User.DHCRBExamRejectItemD(rejectRowid),5)
			s rejectTimeSpan=$lg(^User.DHCRBExamRejectItemD(rejectRowid),6)
			s rejectHintType=$lg(^User.DHCRBExamRejectItemD(rejectRowid),15)
			if (retRelationShip="")
			{
				s retRelationShip=orderItemRowid_"^"_orderItemFind_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
			}
			else
			{
				s retRelationShip=retRelationShip_"&&"_orderItemRowid_"^"_orderItemFind_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
			}
		}
		s prepositionRowid=..GetPrepositionInfo(orderItemRowid,orderItemFind)
		;w !,"prepositon="_orderBody_"****"_orderBodyAs_"****"_prepositionRowid
		if (prepositionRowid'="")
		{
			s prepositionTime=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),4)
			s propositionTimeSpan=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),6)
			s prepositionHintType=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),15)
			if (retRelationShip="")
			{
				s retRelationShip=orderItemRowid_"^"_orderItemFind_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
			}
			else
			{
				s retRelationShip=retRelationShip_"&&"_orderItemRowid_"^"_orderItemFind_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
			} 
		}
		
		///反向查询关系
		s rejectRowid=..GetRejectInfo(orderItemFind,orderItemRowid)
		;w !,"reject="_orderBody_"****"_orderBodyAs_"****"_rejectRowid
		if (rejectRowid'="")
		{
			s rejectTime=$lg(^User.DHCRBExamRejectItemD(rejectRowid),5)
			s rejectTimeSpan=$lg(^User.DHCRBExamRejectItemD(rejectRowid),6)
			s rejectHintType=$lg(^User.DHCRBExamRejectItemD(rejectRowid),15)
			if (retRelationShip="")
			{
				s retRelationShip=orderItemFind_"^"_orderItemRowid_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
			}
			else
			{
				s retRelationShip=retRelationShip_"&&"_orderItemFind_"^"_orderItemRowid_"^"_"R"_"^"_rejectHintType_"^"_rejectTime_"^"_rejectTimeSpan
			}
		}
		s prepositionRowid=..GetPrepositionInfo(orderItemFind,orderItemRowid)
		;w !,"prepositon="_orderBody_"****"_orderBodyAs_"****"_prepositionRowid
		if (prepositionRowid'="")
		{
			s prepositionTime=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),4)
			s propositionTimeSpan=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),6)
			s prepositionHintType=$lg(^User.DHCRBExamPrepositionItemD(prepositionRowid),15)
			if (retRelationShip="")
			{
				s retRelationShip=orderItemFind_"^"_orderItemRowid_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
			}
			else
			{
				s retRelationShip=retRelationShip_"&&"_orderItemFind_"^"_orderItemRowid_"^"_"P"_"^"_prepositionHintType_"^"_prepositionTime_"^"_propositionTimeSpan
			} 
		}
	}
	
	b //001
	s orderItemDesc=##class(web.DHCRisPlatCommonBusiness).GetAppItemName(orderItemRowid)
	s scheduleDate=$p($g(^DHCRBCResourceSchdule(schduleRowid)),"^",2)
	s scheduleTime=$p($g(^DHCRBCResourceSchdule(schduleRowid)),"^",5)
	// 根据医嘱关系提示
	s conflictList=""
	s info=""
	for m=1:1:$l(retRelationShip,"&&")
	{
		s (nurseInfo,nurseStatus,nurseData)=""
		s (OrdDate,itmMastDrA,itmDescA,resScheduleDrFind,scheduleDateFind,schuduleTimeFind)=""
		s relationShipItem=$p(retRelationShip,"&&",m)
		
		s firstExam=$p(relationShipItem,"^",1)
		s secondExam=$p(relationShipItem,"^",2)

		s relationShipType=$p(relationShipItem,"^",3)
		s time=$p(relationShipItem,"^",5)
		s timeSpan=$p(relationShipItem,"^",6)
		
		
		if (secondExam=orderItemRowid)
		{
			
			s OrdDate=$P(^OEORD($p(firstExam,"||",1),"I",$p(firstExam,"||",2),1),"^",9)
			s OrdTime=$P(^OEORD($p(firstExam,"||",1),"I",$p(firstExam,"||",2),1),"^",10)
			//s itmMastDrA=$P(^OEORD($p(firstExam,"||",1),"I",$p(firstExam,"||",2),1),"^",2)
			//s itmDescA=$p(^ARCIM($p(itmMastDrA,"||",1),$p(itmMastDrA,"||",2),1),"^",2)
			s itemDesc=##class(web.DHCRisPlatCommonBusiness).GetAppItemName(firstExam)
			;查询预约日期
			s resDetailDr=$o(^DHCRBCResSchduleDetaili(0,firstExam,""))
			continue:(resDetailDr="")
			if (resDetailDr'="")
			{
				s resScheduleDrFind=$p($g(^DHCRBCResSchduleDetail("Detail",resDetailDr)),"^",2)
				if (resScheduleDrFind'="")
				{
					s scheduleDateFind=$p($g(^DHCRBCResourceSchdule(resScheduleDrFind)),"^",2)
					s schuduleTimeFind=$p($g(^DHCRBCResourceSchdule(resScheduleDrFind)),"^",5)
				}
				if (scheduleDateFind'="")
				{
					;w !,$ZABS(scheduleDateFind-scheduleDate)_"**"_time
					if ( ((scheduleDate-scheduleDateFind)<=time)&&((scheduleDate-scheduleDateFind)>=0))
					{
						b //003
						s info=itemDesc_" ("_$zd(OrdDate,3)_") 已经预约到"_$zd(scheduleDateFind,3)_" "_$zt(schuduleTimeFind,1)_",需要间隔"_time_timeSpan_"!!"
						s conflictList=conflictList_"&&"_relationShipType_"^"_""_"^"_info
					}
					
				}
			}
			
					
		}
		elseif (firstExam=orderItemRowid)
		{
			s OrdDate=$P(^OEORD($p(secondExam,"||",1),"I",$p(secondExam,"||",2),1),"^",9)
			//s OrdTime=$P(^OEORD($p(orderRowidAss,"||",1),"I",$p(orderRowidAss,"||",2),1),"^",10)
			//s itmMastDrA=$P(^OEORD($p(senconExam,"||",1),"I",$p(senconExam,"||",2),1),"^",2)
			//s itmDescA=$p(^ARCIM($p(itmMastDrA,"||",1),$p(itmMastDrA,"||",2),1),"^",2)
			
			s itemDesc=##class(web.DHCRisPlatCommonBusiness).GetAppItemName(secondExam)
			
			;查询预约日期
			s resDetailDr=$o(^DHCRBCResSchduleDetaili(0,secondExam,""))
			continue:(resDetailDr="")
			if (resDetailDr'="")
			{
				s resScheduleDrFind=$p($g(^DHCRBCResSchduleDetail("Detail",resDetailDr)),"^",2)
				if (resScheduleDrFind'="")
				{
					s scheduleDateFind=$p($g(^DHCRBCResourceSchdule(resScheduleDrFind)),"^",2)
					s schuduleTimeFind=$p($g(^DHCRBCResourceSchdule(resScheduleDrFind)),"^",5)
				}
				if (scheduleDateFind'="")
				{
					;w !,$ZABS(scheduleDateFind-scheduleDate)
					if ( ((scheduleDateFind-scheduleDate)<=time)&&((scheduleDateFind-scheduleDate)>=0))
					{
						b //004
						s info=itemDesc_" ("_$zd(OrdDate,3)_") 已经预约到"_$zd(scheduleDateFind,3)_" "_$zt(schuduleTimeFind,1)_",需要间隔"_time_timeSpan_"!!"
						s conflictList=conflictList_"&&"_relationShipType_"^"_""_"^"_info
					}
				}
			}
			
		}

	}
	
	
	q conflictList
}

}
