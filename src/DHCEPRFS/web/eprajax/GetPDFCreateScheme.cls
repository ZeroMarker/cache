Class DHCEPRFS.web.eprajax.GetPDFCreateScheme Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	
	s userID = $Get(%request.Data("UserID",1),"-1")
	
	s action = $Get(%request.Data("Action",1),"-1")
	s isPageQueue = $Get(%request.Data("IsPageQueue",1),"-1")
	s aid = $Get(%request.Data("AID",1),"-1")
	s pageInfoID = $Get(%request.Data("PageInfoID",1),"-1")
	s schemeID = $Get(%request.Data("SchemeID",1),"")
	s specialFlag = $Get(%request.Data("SpecialFlag",1),"")
	s specialParam = $Get(%request.Data("SpecialParam",1),"")
	s selectItemID = $Get(%request.Data("SelectItemID",1),"")
	
	if (action = "initpageinfo")
	{
		s ret = ..InitPageInfo(isPageQueue)
		w ret
	}
	elseif (action = "setpageinfo")
	{
		d ..SetPageInfo(aid, isPageQueue, pageInfoID)
	}
	elseif (action = "afterprint")
	{
		d ..AfterPrint(pageInfoID)
	}
	else
	{
		w ..GetPDFCreateSchemeJson(patientID, episodeID, userID, schemeID, specialFlag, specialParam,selectItemID)
	}
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).GetPDFCreateItems()
ClassMethod GetPDFCreateItems(ASchemeID As %String) As %String
{
	if ($e(ASchemeID,1,2) = "@@")	//如果是表达式则解析出MRItemID来
	{
		s items=##Class(DHCEPRFS.BL.BLPrintScheme).GetSchemeItemsByExp(ASchemeID)
		q items
	}
	else
	{
		s scheme = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(ASchemeID)
		q:(scheme = "") ""
		s items = scheme.SchemeItems
		q items
	}
}

ClassMethod GetPDFCreateScheme() As %String
{
	s rowID = $O(^DHCEPRFS.META.PrintSchemeI("IdxIsCreate", " Y", ""))
	q rowID
}

/// debug: w ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).GetPDFCreateSchemeJson("201","582","831","67","","")
ClassMethod GetPDFCreateSchemeJson(APatientID As %String, AEpisodeID As %String, AUserID As %String, ASchemeID As %String, ASpecialFlag As %String, ASpecialParam As %String, ASelectItemID As %String) As %String
{
	s ret=""
	//未指定生成Scheme，无法正常生成
	if (ASchemeID = "")||(ASchemeID = $C(0))
	{
		s ret = "{""TotalCount"":0,""Data"":[]}"
		quit ret
	}
	if (ASelectItemID = "")||(ASelectItemID = $C(0))
	{
		//指定Scheme中归档项目为空，无法正常生成
		s items = ..GetPDFCreateItems(ASchemeID)
		if (items="")||(items=$c(0)) 
		{
			s ret = "{""TotalCount"":0,""Data"":[]}"
			quit ret
		}
		
		s totalCount = $l(items,"^")
		
		s ret = "{""Data"":["
		
		s needPrintCount = 0
		for i=1:1:totalCount
		{
			s item = $p(items,"^",i)
			continue:(item="")
			
			s MRCategoryID = $p(item,"#",1)
			s MRSubCategoryID = $p(item,"#",2)
			s MRItemID = $p(item,"#",3)
			
			s detailInfo = ..ItemDetailJson(needPrintCount+1,MRItemID,APatientID, AEpisodeID, AUserID, ASpecialFlag, ASpecialParam)
			if (detailInfo '= "")
			{
				if (needPrintCount > 0) {s ret = ret _ ","}
				s ret = ret _ detailInfo
				s needPrintCount = needPrintCount + 1
				//quit:(needPrintCount=1)
			}
		}
		s ret = ret _ "]"
		s ret = ret _ ",""TotalCount"":"_needPrintCount_"}"
	}
	else
	{
		s items = ASelectItemID
		s totalCount = $l(items,"_")
		s ret = "{""Data"":["
		
		s needPrintCount = 0
		for i=1:1:totalCount
		{
			s MRItemID = $p(items,"_",i)
			continue:(MRItemID="")
			s detailInfo = ..ItemDetailJson(needPrintCount+1,MRItemID,APatientID, AEpisodeID, AUserID, ASpecialFlag, ASpecialParam)
			if (detailInfo '= "")
			{
				if (needPrintCount > 0) {s ret = ret _ ","}
				s ret = ret _ detailInfo
				s needPrintCount = needPrintCount + 1
				//quit:(needPrintCount=1)
			}
		}
		s ret = ret _ "]"
		s ret = ret _ ",""TotalCount"":"_needPrintCount_"}"
	}
	q ret
}

/// debug: w ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).ItemDetailJson("1","23","","4264713","6448854","831")
ClassMethod ItemDetailJson(ANeedPrintCount As %String, AMRItemID As %String, APatientID As %String, AEpisodeID As %String, AUserID As %String, ASpecialFlag As %String, ASpecialParam As %String) As %String
{
	s ret = ""
	s MRItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(AMRItemID)
	s Type = MRItem.Type
	s TypeParams = MRItem.TypeParams
	s Name = MRItem.Name
	s Code = MRItem.Code
	s Description = MRItem.Description
	s Attachment = MRItem.Attachment
	s AttachType = MRItem.AttachType
	s SubFlag = MRItem.SubFlag
	
	s AttachType = $tr(AttachType,$c(0),"")
	
	//此项附加在其他项生成则跳过
	//q:(Attachment = 0) ""
	
	//有子项的MRItem项目,通过MRVerSubItem内容来判断
	if (SubFlag="1")
	{
		s HaveVerSubItem=##Class(DHCEPRFS.BL.BLMRVerSubItem).HaveVerSubItem(AEpisodeID,AMRItemID)
		q:(HaveVerSubItem = "0") ""  //如果没有子项数据，返回空
	}
	
	s flag = "false"
	if (Attachment = 0 )
	{
		/*
		s rowID	= ""
		for {
			s rowID = $O(^DHCEPRFS.META.MRItemI("IdxAttachment"," "_AMRItemID, rowID))
			q:(rowID = "")
			s AttachMRItem= ##Class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s AttachType = AttachMRItem.Type
			s AttachTypeParams = AttachMRItem.TypeParams
			s AttachName = AttachMRItem.Name
			s AttachCode = AttachMRItem.Code
			s AttachDescription = AttachMRItem.Description
			s AttachAttachment = AttachMRItem.Attachment
			s AttachAttachType = AttachMRItem.AttachType
			if (AttachAttachType = "1")
			{
				s AttachDetailInfo = ..GetItemDetailInfo(AttachType, AttachTypeParams, AttachName, APatientID, AEpisodeID, AUserID, AttachAttachment, AttachAttachType)
				if (AttachDetailInfo '= "")
				{
					s flag = "true"	
					q	
				}
			}
			elseif (AttachAttachType = "2")
			{
				s flag = "true"	
			}
			
		}*/
		s flag = ..IsAttached(AMRItemID,APatientID,AEpisodeID,AUserID)
	}
	//b "s"
	//此项附加在其他项生成则跳过
	q:(flag = "true") ""
	
	//b "s"
	s detailInfo = ..GetItemDetailInfo(Type, TypeParams, Name, APatientID, AEpisodeID, AUserID, Attachment, AttachType,ASpecialFlag, ASpecialParam)
	q:(detailInfo="") ret
	
	s ctItemTypeID = $O(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_Type, ""))
	s ctItemType = ##Class(DHCEPRFS.META.CTItemType).%OpenId(ctItemTypeID)
	s cspPath = ctItemType.CSPPath
	s cspPath = $tr(cspPath,$c(0),"")
	
	s allID = "CG"_Type
	s createType = ##Class(DHCEPRFS.BL.BLCTItem).GetCreateTypeByCode(allID)
	s ret = "{"
	s ret = ret_"""id"":"""_allID_""""
	s ret = ret_",""createType"":"""_createType_""""
	s ret = ret_",""cspPath"":"""_cspPath_""""
	s ret = ret_",""detailInfo"":"""_detailInfo_""""
	s ret = ret_",""text"":"""_Name_""""
	s ret = ret_",""detailAttachType"":"""_AttachType_""""
	s ret = ret_",""mrItemID"":"""_AMRItemID_""""
	s ret = ret_",""order"":"""_ANeedPrintCount_""""
	s ret = ret_",""subFlag"":"""_SubFlag_""""
	s ret = ret_"}"
	
	q ret
}

/// w ##Class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).IsAttached("97","","6689923","1")
ClassMethod IsAttached(AMRItemID As %String, APatientID, AEpisodeID, AUserID) As %String
{
	s flag = "false"
	
	s mrItemID = ""
	for {
		//b "s"
		s mrItemID = $O(^DHCEPRFS.META.MRItemI("IdxAttachment",mrItemID))
		q:(mrItemID="")
		continue:(mrItemID=" ")
		continue:(mrItemID=(" "_$c(0)))
		
		//b "s"
		s tmpMRItemID = "^"_$E(mrItemID,2,$L(mrItemID))_"^"
		continue:($f(tmpMRItemID,"^"_AMRItemID_"^")<1)
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRFS.META.MRItemI("IdxAttachment",mrItemID, rowID))
			q:(rowID = "")
			s AttachMRItem = ##Class(DHCEPRFS.META.MRItem).%OpenId(rowID)
			s AttachType = AttachMRItem.Type
			s AttachTypeParams = AttachMRItem.TypeParams
			s AttachName = AttachMRItem.Name
			s AttachCode = AttachMRItem.Code
			s AttachDescription = AttachMRItem.Description
			s AttachAttachment = AttachMRItem.Attachment
			s AttachAttachType = AttachMRItem.AttachType
			if (AttachAttachType = "1")
			{
				s AttachDetailInfo = ..GetItemDetailInfo(AttachType, AttachTypeParams, AttachName, APatientID, AEpisodeID, AUserID, AttachAttachment, AttachAttachType)
				if (AttachDetailInfo '= "")
				{
					s flag = "true"
					q
				}
			}
			elseif (AttachAttachType = "2")
			{
				s flag = "true"
			}
		}
	}
	
	q flag
}

/// Desc:	获取项目待打印明细信息
/// Other:	01 检查单
///         01A 检查报告-放射PACS
///         01B  检查报告-超声ES
///         01C  检查报告-内镜US
/// 		02 检验单
/// 		21 CS检验单
/// 		04 体温单
/// 		06 护理病历
///         06A 新版护理病历合并打印
///         06B 新版护理病历分项打印
/// 		61 日常生活评分
/// 		07 病历文书
/// 		08 手术麻醉记录(手麻)
/// 		09 病理
/// 		10 心电
/// 		11 费用清单
/// 		12 临床路径
/// 		13 输血申请单
///         53 输血单
/// 		14 会诊单
/// 		15 手术清点单(手麻)
/// 		16 产程图
///         17 产时记录
/// 		18 重症监护护理(重症)
/// 		22 发血报告单
///         24  术前访视(手麻)
///         25  术后访视(手麻)(暂时不用)
///         28 手术安全核查表(手麻)
///         29 麻醉前访视(手麻)
///         30 手术风险评估(手麻)
/// 		31 长期医嘱单	
/// 		32 临时医嘱单
///         34 处方
///         55 麻醉后访视(手麻)
/// 		61 护理病历
/// 		81 恢复式记录单(手麻)
///         35 静脉血栓栓塞
///         36 住院病案首页(编目)
ClassMethod GetItemDetailInfo(AType As %String, ATypeParams As %String, ADescription As %String, APatientID As %String, AEpisodeID As %String, AUserID As %String, Attachment As %String, AttachType As %String, ASpecialFlag As %String = "", ASpecialParam As %String = "") As %String
{
	s detailInfo = ""
	
	if ((ASpecialFlag '= "") && (ASpecialFlag '= $c(0)))
	{
		s detailInfo = ASpecialParam
		q detailInfo
	}
	
	if (AType = "01")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetStudyNo(AEpisodeID)
		if (detailInfo="")||(detailInfo=$c(0)) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "01A")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetPACSFTPPath(AEpisodeID)
		if (detailInfo="")||(detailInfo=$c(0)) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "01B")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetUSFTPPath(AEpisodeID)
		if (detailInfo="")||(detailInfo=$c(0)) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "01C")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLPACSInfo).GetESFTPPath(AEpisodeID)
		if (detailInfo="")||(detailInfo=$c(0)) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "02")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetResultCountByAdm(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "21")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasCSLISReport(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "22")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasCSLISBloodReport(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "04")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasTemperatureToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "05")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLDocInfo).HasIPBookToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "07")
	{
		s APrintDocID = ATypeParams
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEPRInfo).GetDetailInfoToPrint(APrintDocID, APatientID, AEpisodeID, AUserID, Attachment,AttachType)
	}
	elseif (AType = "51")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNPGInfo).HasConsultToPrintNew(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
	}
	elseif (AType = "71")
	{
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLEMRInfo).CheckCanPrintWOPriv(AEpisodeID,ATypeParams)
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = ATypeParams
		}
	}
	elseif (AType = "36")
	{
		s ret = "1"
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = ATypeParams
		}
	}
	elseif (AType = "11")
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLFeeInfo).HasFeeDetail(AEpisodeID)
		//费用清单是否打印判断方法
		s detailInfo = ##class(BILL.Interface.Inside.Service).IHasFeeDtlsByAdm(AEpisodeID)
		if (detailInfo = "0")
		{	s detailInfo = ""}
		else
		{	s detailInfo = ATypeParams}
	}
	elseif (AType = "12")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLCPWInfo).GetPathWayID(AEpisodeID)
	}
	elseif (AType = "13")
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLLISInfo).GetBloodIDCountByAdm(AEpisodeID)
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasBLDPath(AEpisodeID,"01007")
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType="53")
	{
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLLISInfo).HasBLDPath(AEpisodeID,"01003")
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
		
	}
	elseif (AType = "14")
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasConsultToPrint(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "08")	//手术麻醉记录
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasANToPrint(AEpisodeID)
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasAnaestRecordToPrintNew(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "81")	//恢复式记录单
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPACUToPrint(AEpisodeID)
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPACUNurseRecordToPrintNew(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "18")	//重症监护护理单
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasICUToPrint(AEpisodeID)
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasDHCICUToPrintNew(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "24")	//术前访视
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPREToPrint(AEpisodeID)
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPREToPrintNew(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "25")	//术后访视
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPOSTToPrint(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "09")	//病理
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLPISInfo).HasPISToPrint(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "10")	//心电
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).HasEKGToPrint(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "15")	//手术清点单
	{
		//s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPCountToPrint(AEpisodeID)
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPCountToPrintNew(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "16")	//产程图
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasBirthGraph(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "17")	//产时记录
	{
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLNurseInfo).ifHaveRecord(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType = "31")   //长期医嘱
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasCQordToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "32")   //临时医嘱
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLOrderInfo).HasLSordToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "33")	//疼痛评分
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasTouchGraph(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = ATypeParams}
	}
	elseif (AType="34")  //处方
	{
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLPHAInfo).CheckHasPHAToPrint(AEpisodeID)
		if (detailInfo < 1) 
		{s detailInfo = ""}
		else 
		{s detailInfo = "1"}
	}
	elseif (AType = "06")   //护理病历
	{
		//Add by Liaowp 2013-12-31 护理病历接口,有护理需打印内容返回1否则返回0
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseCareToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "06A")   //新版护理病历合并打印
	{
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNURToPrint(AEpisodeID,"")
		if (detailInfo < 1)
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = "1"
		}
	}
	elseif (AType = "06B")   //新版护理病历分项打印
	{
		
		s detailInfo = ##class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNURToPrint(AEpisodeID,ATypeParams)
		if (detailInfo < 1)
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = ATypeParams
		}
		
	}
	elseif (AType = "35")   //静脉血栓栓塞
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseXSMultToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "61")   //护理病历
	{
		//Add by Liaowp 2013-12-31 护理病历接口,有护理需打印内容返回1否则返回0
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseSHPFToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
		//s detailInfo = "1"
	}
	elseif (AType = "62")   //血糖表，护理
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasBloodGlucoseToPrint(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
	}
	elseif ($l(AType) = 3) && ($e(AType,1,1) = "6")
	{
		s ctItemTypeID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_AType,""))
		s objCTItemType = ##class(DHCEPRFS.META.CTItemType).%OpenId(ctItemTypeID)
		s nurType = objCTItemType.TypeNote
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLNurseInfo).HasNurseRecordByTypeCode(AEpisodeID,nurType)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
	}
	elseif ($l(AType) = 3) && ($e(AType,1,1) = "9")
	{
		s ctItemTypeID = $o(^DHCEPRFS.META.CTItemTypeI("IdxMain"," "_AType,""))
		s objCTItemType = ##class(DHCEPRFS.META.CTItemType).%OpenId(ctItemTypeID)
		s ekgType = objCTItemType.TypeNote
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEKGInfo).HasEKGToPrintByType(AEpisodeID,ekgType)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
	}
	elseif (AType = "84")
	{
		//中国医大第三方飞利浦重症监护
		//需要判断是否患者当前出院科室时重症监护或者转科记录中有重症监护时，才调用生成接口
		s detailInfo = ##class(DHCEPRFS.ThirdParty.BL.BLCheckNeedCreate).Check84NeedCreate(AEpisodeID)
		if (detailInfo < 1)
		{s detailInfo = ""}
		else
		{s detailInfo = "1"}
	}
	elseif (AType = "28")	//是否有手术安全核查表需要打印
	{
		//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOPSPDFToPrint(AEpisodeID)
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOperSafetyCheckToPrintNew(AEpisodeID)
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = "1"
		}
	}
	elseif (AType = "29")	//是否麻醉前访视需要打印
	{
		//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPrevVisitToPrint(AEpisodeID)
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPrevVisitToPrintNew(AEpisodeID)
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = "1"
		}
	}
	elseif (AType = "55")	//是否麻醉后访视需要打印
	{
		//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPostVisitToPrint(AEpisodeID)
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasPostANVisitToPrintNew(AEpisodeID)
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = "1"
		}
	}
	elseif (AType = "30")	//是否CHA手术风险评估需要打印
	{
		//s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasCHARecordToPrint(AEpisodeID)
		s ret = ##Class(DHCEPRFS.BL.HISInfo.BLANInfo).HasOperRiskAssessmentToPrintNew(AEpisodeID)
		if (ret = "0")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = "1"
		}
	}
	elseif (AType = "37")	//是否有体检报告需要打印
	{
		s ret = ##Class(DHCEPRFS.Prison.BL.HISInfo.BLHCInfo).HasHCPDFPath(AEpisodeID, ATypeParams)
		if (ret = "")
		{
			s detailInfo = ""
		}
		else
		{
			s detailInfo = ATypeParams
		}
	}
	elseif (AType = "PS")	//扫描项目,无法进行自动生成
	{
		s detailInfo = ""
	}
	elseif (AType = "MS")
	{
		s detailInfo = ""
	}
	elseif (AType = "NO")
	{
		s detailInfo = ""
	}
	elseif (AType = "MP")  //Media Picture 这个类型是指需要归档的图片，比如png、jpeg、tiff等
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).HasPicToPrint(AEpisodeID,ATypeParams)	
	}
	elseif (AType = "MA")  //Media Audio 这个类型是指需要归档音频，比如mp3等
	{
		s detailInfo = ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).HasAudioToPrint(AEpisodeID,ATypeParams)
	}
	elseif (AType = "MV")  //Media Video 这个类型是指需要归档视频，比如mp4等
	{
		s detailInfo = ""
	}
	else
	{
		s detailInfo = ATypeParams
	}
	
	q detailInfo
}

/// Desc:	设置页码信息
/// Input：	AIDInfo - 节点ID
/// 		AUserID - 操作用户
/// 		AIsPageQueue - 是否启用页码大排队
/// Output: 1 - 成功
/// 		-1 - 失败
ClassMethod SetPageInfo(AIDInfo As %String, AIsPageQueue As %String, pageInfoID) As %String
{
	s pageInfo = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%OpenId(pageInfoID)
	q:(pageInfo = "") "-1"
	s pageNumber = pageInfo.PageNumber
	
	//形式为节点ID|起始页码|结束页码
	//第一项，其实页码为1
	if (pageInfo.PageInfo = "")
	{
		s endPageNumber = pageNumber - 1
		s pageInfo.PageInfo = AIDInfo_"|1|"_endPageNumber
	}
	else
	{
		s length = $l(pageInfo.PageInfo,"^")
		//不启用页码排队
		if (AIsPageQueue = "false"){
			s startPageNumber = 1
		}
		//启用页码排队
		else {
			s startPageNumber = $p($p(pageInfo.PageInfo,"^",length),"|",3) + 1
		}
		s endPageNumber = pageNumber - 1
		s pageInfo.PageInfo = pageInfo.PageInfo_"^"_AIDInfo_"|"_startPageNumber_"|"_endPageNumber
	}

	s sc = pageInfo.%Save()
	d pageInfo.%Close()
	
	q:($$$ISOK(sc)) "1"
	q "-1"
}

/// Desc:	初始化页码信息
/// Input：	userID - 操作用户
/// 		isPageQueue - 是否启用页码大排队
/// Output: pageInfoID - 成功
/// 		-1 - 失败
/// Debug:	w ##class(DHCEPRFS.web.eprajax.GetPDFCreateScheme).InitPageInfo("true")
ClassMethod InitPageInfo(isPageQueue As %String) As %String
{
	//获得当前打印方案ID
	s schemeID = ..GetPDFCreateScheme()
	
	s obj = ##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%New()
	q:(obj="") "-1"
	//设置起始页码为1
	s obj.SchemeID = schemeID
	s obj.PageInfo = ""
	s obj.PageNumber = "1"
	s obj.IsQueue = isPageQueue
	
	s sc = obj.%Save()
	s pageInfoID = obj.%Id()
	d obj.%Close()
	
	q:($$$ISOK(sc)) pageInfoID
	q "-1"
}

/// Desc:	生成后操作
ClassMethod AfterPrint(pageInfoID As %String) As %String
{
	//清理
	s result=##class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%DeleteId(pageInfoID)
	q "1"
}

}
