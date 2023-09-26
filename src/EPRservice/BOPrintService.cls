/// EPRservice.BOPrintService
Class EPRservice.BOPrintService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PrintService";

/// Desc:	取实例数据的标题, 用以根据标题判断是否做新起页处理
/// Input:	AInstanceDataID
/// Output:	实例数据标题
ClassMethod GetInstanceTitle(AInstanceDataID As %String) As %String [ WebMethod ]
{
	q:(AInstanceDataID="") ""
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(AInstanceDataID)
	q:(objInstance="") ""
	
	q objInstance.Title
}

/// Desc:	根据InstanceData取相应打印模板版本ID
/// 		使用范围：(1)旧框架可重复模板打印(2)新框架可重复模板打印
ClassMethod GetMultiPTVersionIDString(AInstanceIDString As %String) As %String [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("BOPrintService","GetMultiPTVersionIDString","input") = AInstanceIDString
	
	q:(AInstanceIDString = "") ""
	s ptVersionIDString = ""
	
	//使用系统参数控制取最新打印模板版本
	s sysOption = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintUseLastVersion")
	if (sysOption = "Y") 
	{
		s ptVersionIDString = ..GetLastPTVersionIDString(AInstanceIDString)
		q ptVersionIDString
	}
	
	s count = $L(AInstanceIDString, ",")
	for i = 1:1:count
	{
		s instanceID = $P(AInstanceIDString, ",", i)
		
		s ptVersionID = ..GetMultiPTVersionIDByInstanceID(instanceID)
		if ptVersionID = ""
		{	
			s ptID = ..GetBindPrtTplIDByInstanceID(instanceID)
			s ptVersionID = ##Class(EPRservice.BOPrintTemplate).GetMaxPublishVersionID(ptID)
		}
		
		if i = 1
		{	s ptVersionIDString = ptVersionID}
		else
		{	s ptVersionIDString = ptVersionIDString_","_ptVersionID}
	}
	
	q ptVersionIDString
}

/// Desc:	根据指定PrintTemplateVersionID获取打印模板版本信息
/// 		使用范围：(1)旧框架可重复模板打印(2)新框架可重复模板打印 	
ClassMethod GetMixPTVersionByPTVersionID(APrintTemplateVersionID As %String) As EPRservice.entity.EMixPrintVersion [ WebMethod ]
{
	s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPTVersionID(APrintTemplateVersionID)
	q objEMixPrintVersion
}

/// Desc:	根据InstanceDataID取相应打印记录所使用的打印模板版本ID
ClassMethod GetMultiPTVersionIDByInstanceID(AInstanceID As %String) As %String
{
	q:(AInstanceID = "") ""
		
	s instancePrintRecordID = ##Class(EPRservice.BOPrintRecord).GetMultiInstancePrtRecordID(AInstanceID)
	q:(instancePrintRecordID = "") ""
	
	s objInstancePrintRecord = ##Class(EPRinstance.InstancePrintRecord).%OpenId(instancePrintRecordID)
	q:(objInstancePrintRecord = "") ""
	q:(objInstancePrintRecord.PrintStatus = "")||(objInstancePrintRecord.PrintStatus = "UnPrint") ""
	
	s printTemplateID = objInstancePrintRecord.PrintTemplateID
	q:(printTemplateID = "") ""
	
	s versionNum = objInstancePrintRecord.PrintTemplateVersion
	q:(versionNum = "") ""
	
	s printTemplateVersionID = ##class(EPRmeta.PrintTemplateVersion).GetMaxPublishVersionID(printTemplateID, versionNum)
	s:(printTemplateVersionID = "0") printTemplateVersionID = ""

	q printTemplateVersionID
}

/// Desc: 	根据InstanceDataID获取打印模板和打印模板版本联合信息
/// 		使用范围：(1)旧框架唯一模板打印
/// Input:	AInstanceID : 指定InstanceDataID
/// Output:	EPRservice.entity.EMixPrintVersion : 打印模板和打印模板版本联合信息实体对象
/// Debug:	w ##Class(EPRservice.BOPrintService).GetMixPTVersionByInstanceID("17||1")
ClassMethod GetMixPTVersionByInstanceID(AInstanceID As %String) As EPRservice.entity.EMixPrintVersion [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("BOPrintService","GetMixPTVersionByInstanceID", "Input") = AInstanceID
	
	q:(AInstanceID = "") ""
	s objEMixPrintVersion = ""
	
	//使用系统参数控制取最新打印模板版本
	s sysOption = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintUseLastVersion")
	if (sysOption = "Y") 
	{
		s printTemplateID = ..GetBindPrtTplIDByInstanceID(AInstanceID)
		s objEMixPrintVersion = ..GetLastPTVersion(printTemplateID)
		q objEMixPrintVersion
	}
	
	//已打印过，根据打印记录获取打印模板及打印模板版本联合信息
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetPrintRecordByInstanceID(AInstanceID)
	if (objEPrintRecord '= "")&&(objEPrintRecord.PrintStatus '= "UnPrint")
	{
		s printTemplateID = objEPrintRecord.PrintTemplateID
		s versionNumber = objEPrintRecord.PrintTemplateVersion
		s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPTVersionNum(printTemplateID, versionNumber)
		
		q:(objEMixPrintVersion '= "") objEMixPrintVersion
	}
	
	//未打印过，获取界面模板默认绑定打印模板及已发布最新打印模板版本联合信息
	s printTemplateID = ..GetBindPrtTplIDByInstanceID(AInstanceID)
	s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPrintTemlateID(printTemplateID)
	q objEMixPrintVersion
}

/// Desc:	根据实例数据ID获取对应界面模板绑定的打印模板ID
/// Input:	AInstanceID : 指定InstanceDataID
/// Output:	打印模板ID
ClassMethod GetBindPrtTplIDByInstanceID(AInstanceID As %String) As %String
{
	s bindPrintTemplateID = ""
	
	q:(AInstanceID = "") bindPrintTemplateID
	
	s objInstance = ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstance = "") bindPrintTemplateID
	q:(objInstance.TemplateID = "") bindPrintTemplateID
	
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(objInstance.TemplateID)
	q:(objTemplate = "") bindPrintTemplateID
	s bindPrintTemplateID = objTemplate.BindPrintTemplateID
	
	s objTemplate = ""
	q bindPrintTemplateID
}

/// Desc:	根据就诊ID和打印模板ID获取打印模板和打印模板版本联合信息
/// 		使用范围：(1)旧框架唯一模板打印(2)新框架唯一模板打印
/// Debug:	w ##Class(EPRservice.BOPrintService).GetMixPTVersionByAdmIDAndPTID("201764","262")
ClassMethod GetMixPTVersionByAdmIDAndPTID(AEpisodeID As %String, APrintTemplateID As %String) As EPRservice.entity.EMixPrintVersion [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("BOPrintService","GetMixPTVersionByAdmIDAndPTID", "Input") = AEpisodeID_"^"_APrintTemplateID
	
	s objEMixPrintVersion = ""
	
	//使用系统参数控制取最新打印模板版本
	s sysOption = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintUseLastVersion")
	if (sysOption = "Y") 
	{
		s objEMixPrintVersion = ..GetLastPTVersion(APrintTemplateID)
		q objEMixPrintVersion
	}
	
	//已打印过，根据打印记录获取打印模板及打印模板版本
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetSinglePrtRecord(AEpisodeID, APrintTemplateID)
	if (objEPrintRecord '= "")&&(objEPrintRecord.PrintStatus '= "UnPrint")
	{
		s printTemplateID = objEPrintRecord.PrintTemplateID
		s versionNumber = objEPrintRecord.PrintTemplateVersion
		s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPTVersionNum(printTemplateID, versionNumber)
		
		q:(objEMixPrintVersion '= "") objEMixPrintVersion
	}
	
	//获取界面模板默认绑定打印模板
	s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPrintTemlateID(APrintTemplateID)
	q objEMixPrintVersion
}

/// Desc:	取打印记录
/// Debug:	w ##Class(EPRservice.BOPrintService).GetPrintRecord()
ClassMethod GetPrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String, ByRef APageNum As %String, ByRef ARowNum As %String) As EPRservice.entity.EPrintRecord [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("BOPrintService","GetPrintRecord", "Input") = AEpisodeID_"^"_AInstanceDataID_"^"_APrintType_"^"_APrintTemplateID_"^"_APageNum_"^"_ARowNum
	s objEPrintRecord = ""
	
	if (APrintType = "Single")
	{
		s objEPrintRecord = ..GetSinglePrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID)
	}
	else
	{
		s objEPrintRecord = ..GetMultiPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID, .APageNum, .ARowNum)
	}
	
	q objEPrintRecord
}

/// Desc:	集中打印取打印记录
/// Debug:	w ##Class(EPRservice.BOPrintService).GetPrintRecord()
ClassMethod GetCentralizedPrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String, ByRef APageNum As %String, ByRef ARowNum As %String) As EPRservice.entity.EPrintRecord [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("BOPrintService","GetPrintRecord", "Input") = AEpisodeID_"^"_AInstanceDataID_"^"_APrintType_"^"_APrintTemplateID_"^"_APageNum_"^"_ARowNum
	s objEPrintRecord = ""
	
	if (APrintType = "Single")
	{
		s objEPrintRecord = ..GetSingleCentralizedPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID, .APageNum, .ARowNum)
	}
	else
	{
		s objEPrintRecord = ..GetMultiPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID, .APageNum, .ARowNum)
	}
	
	q objEPrintRecord
}

/// Desc:	取唯一模板打印记录
ClassMethod GetSinglePrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String) As EPRservice.entity.EPrintRecord
{
	s objEPrintRecord = ""
	
	// 取已打印过的记录
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetSinglePrtRecord(AEpisodeID, APrintTemplateID)
	
	// 取未打印过的记录
	if (objEPrintRecord = "")
	{
		s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GenerateUnprintedEPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID)
	}
	
	q objEPrintRecord
}

/// Desc:	集中打印取唯一模板打印记录
ClassMethod GetSingleCentralizedPrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String, ByRef APageNum As %String, ByRef ARowNum As %String) As EPRservice.entity.EPrintRecord
{
	s objEPrintRecord = ""
	
	// 取已打印过的记录
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetSinglePrtRecord(AEpisodeID, APrintTemplateID)
	
	// 取未打印过的记录
	if (objEPrintRecord = "")
	{
		s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GenerateUnprintedEPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID)
	}
	
	// 取最新的起始页行信息
	s (newPage, newRow) = ""
	s isFirstRecord = (APageNum ="0")&&(ARowNum="0")  
	if (isFirstRecord)
	{
		//本次打印动作的第一条病历数据
		s newPageAndRow = ..GetFirstStartPageAndRow(AEpisodeID, AInstanceDataID)
		s newPage = $P(newPageAndRow, "^", 1)
		s newRow = $P(newPageAndRow, "^", 2)
	}
	else
	{
		//非本次打印动作的第一条病历数据, 起始行接着本次打印动作上一条记录的结束行
		s newPage = APageNum
		s newRow = ARowNum + 1
	}
	
	// 更新返回值
	s:(newPage = "0") newPage = "1"	//解决打印记录结束页为0时导致的打印错误
	s objEPrintRecord.StartPageNum = newPage
 	s objEPrintRecord.StartRowNum = newRow
 	s objEPrintRecord.CurPageNum = newPage
 	s objEPrintRecord.CurRowNum = newRow
 	
 	q objEPrintRecord
}

/// Desc:	取可重复模板打印记录
ClassMethod GetMultiPrintRecord(AEpisodeID As %String, AInstanceDataID As %String, APrintType As %String, APrintTemplateID As %String, ByRef APageNum As %String, ByRef ARowNum As %String) As EPRservice.entity.EPrintRecord
{
	s objEPrintRecord = ""
	
	// 取已打印过的记录
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetMultiPrtRecord(AInstanceDataID)
	
	// 取未打印过的记录
	if (objEPrintRecord = "")
	{
		s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GenerateUnprintedEPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID)
	}
	
	// 取最新的起始页行信息
	s (newPage, newRow) = ""
	s isFirstRecord = (APageNum ="0")&&(ARowNum="0")  
	if (isFirstRecord)
	{
		//本次打印动作的第一条病历数据
		s newPageAndRow = ..GetFirstStartPageAndRow(AEpisodeID, AInstanceDataID)
		s newPage = $P(newPageAndRow, "^", 1)
		s newRow = $P(newPageAndRow, "^", 2)
	}
	else
	{
		//非本次打印动作的第一条病历数据, 起始行接着本次打印动作上一条记录的结束行
		s newPage = APageNum
		s newRow = ARowNum + 1
	}
	
	// 更新返回值
	s:(newPage = "0") newPage = "1"	//解决打印记录结束页为0时导致的打印错误
	s objEPrintRecord.StartPageNum = newPage
 	s objEPrintRecord.StartRowNum = newRow
 	s objEPrintRecord.CurPageNum = newPage
 	s objEPrintRecord.CurRowNum = newRow
 	
 	q objEPrintRecord
}

/// Desc: 	取本次打印动作的第一条病历数据的起始页行信息
/// 		若当前病历为整个ECRecord中的第一条,它有可能会接着唯一病历续打,要取关联打印模板的页行信息
/// 		若当前病历不是整个ECREcord的第一条,它要取其上一条病历的页行信息
ClassMethod GetFirstStartPageAndRow(AEpisodeID As %String, AInstanceDataID As %String) As %String
{
	s retStartPageAndRow = "1^1"
	
	//根据日期时间排序，取到实例数据的次序
	d ..ResortSeqByHappenTime(AInstanceDataID, .curDateSeq, .preDateSeq, .preInstanceID)
 
	if (curDateSeq = "1") 		
	{
		//发生日期顺序为第一条, 取出关联打印模板的结束页与行
	 	//若没有关联打印模板，则默认起始页为1，起始行为1
	 	set retStartPageAndRow = ..GetStartPageAndRow(AEpisodeID, AInstanceDataID, "1", "1")
	}	 
	elseif (curDateSeq > "1")	
	{
		//发生日期顺序不是第一条, 取出上一条病历的页行信息
		s ecRecordID = $P(AInstanceDataID, "||", 1)
		s previousSeq = $P(preInstanceID, "||", 2)
		s lastInstancePrintRecordID= ##class(EPRinstance.InstancePrintRecord).GetMaxLastInstanceRecordIDBySeq(ecRecordID,previousSeq)	
		if (lastInstancePrintRecordID '= "")	
		{
			set objLastInstancePrintRecord = ##class(EPRinstance.InstancePrintRecord).%OpenId(lastInstancePrintRecordID)  
 		 	if (objLastInstancePrintRecord.LastRowProperty = "1")
 		 	{
	 		 	//上一条病历已打印到最后一行, 需要换页
 				s startPage = objLastInstancePrintRecord.EndPageNum + 1
		    	s startRow = "1"
		    }
 		 	else
 		 	{
 				s startPage = objLastInstancePrintRecord.EndPageNum
 				s startRow = objLastInstancePrintRecord.EndRowNum + 1
		 	}
		 	
		 	s retStartPageAndRow = startPage_"^"_startRow
	   	}
	}
	
	q retStartPageAndRow
}

/// **************************************************************************
/// Creator:	Chenwj
/// CreatDate:	/
/// Description:获取可重复打印模板的第一条记录的起始页与行(处理了相关联打印模板的自动续打问题)
/// 			
/// Table:		/
/// Input:		/
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:	/
/// **************************************************************************
ClassMethod GetStartPageAndRow(AEpisodeID As %String, AInstanceID As %String, ACurStartPage As %String, ACurStartRow As %String) As %String
{
	q:($d(AInstanceID) = 0 || AInstanceID = "") ACurStartPage_"^"_ACurStartRow
	
	//取出模板ID
	s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(AInstanceID)
	q:(objInstanceData = "") ACurStartPage_"^"_ACurStartRow
	s templateID = objInstanceData.TemplateID
	d objInstanceData.%Close()
	k objInstanceData
	q:(templateID = "") ACurStartPage_"^"_ACurStartRow
	
	//取出打印模板ID
	s objTemplate = ##class(EPRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") ACurStartPage_"^"_ACurStartRow
	s prtTemplateID = objTemplate.BindPrintTemplateID
	d objTemplate.%Close()
	k objTemplate
	q:(prtTemplateID = "") ACurStartPage_"^"_ACurStartRow
	
	//判断是否是参数中设置的打印模板,如果不是则直接返回
	s prtTplOrdOption = ..GetPrtTplOrdOption()
	q:(prtTplOrdOption = "") ACurStartPage_"^"_ACurStartRow
	s preTemplateID = ""
	s curPreTemplateID = ""
	s templateIDGroupCount = $l(prtTplOrdOption, "|")
	For k=1:1:templateIDGroupCount
	{
		s curTemplateIDGroup = $p(prtTplOrdOption, "|", k)
		s templateIDCount = $l(curTemplateIDGroup, "^")
		s curPreTemplateID = $p(curTemplateIDGroup,"^",1)
		For i=2:1:templateIDCount
		{
			set curTemplateID = $p(curTemplateIDGroup, "^", i)
			if (curTemplateID = prtTemplateID)
			{
				//解决同一个日常病程记录接着不同首次病程记录打印
				//set preTemplateID = curPreTemplateID
				//q
				if preTemplateID="" 
				{set preTemplateID = curPreTemplateID}
				else 
				{set preTemplateID = preTemplateID_"^"_curPreTemplateID}
			}
			
			set curPreTemplateID = curTemplateID
		}
		
		//q:(preTemplateID '= "")
	}
	q:(preTemplateID = "") ACurStartPage_"^"_ACurStartRow
	
	//取出相关联打印模板结束的页与行
	//一个打印模板可能关联多个其他打印模板，只需找到第一条不为空的其他打印模板打印记录
	s preCount = $L(preTemplateID,"^")
	for i=1:1:preCount
	{
		s preTid = $p(preTemplateID,"^",i)
		s preEndPageAndRow = ..GetPrintPageAndRow(AEpisodeID, preTid)
		q:(preEndPageAndRow '= "") 
	}
	
	//返回
	q:(preEndPageAndRow '= "") preEndPageAndRow
	q ACurStartPage_"^"_ACurStartRow
}

/// **************************************************************************
/// Creator:	Chenwj(原作者：wangwt)
/// CreatDate:	/
/// Description:获取指定就诊号指定模板（唯一模板）的打印结束页与行
/// 			
/// Table:		/
/// Input:		/
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:	w ##class(EPRservice.BOPrintService).GetPrintPageAndRow("65","69")
/// **************************************************************************
ClassMethod GetPrintPageAndRow(argAdm As %String, argPrintTID As %String) As %String
{
	//定义返回值
	s PrintPageAndRow = ""
	
	s EndPage="",EndRow="",IsLastRow="0"
	s objEPrintRecord = ##Class(EPRservice.BOPrintRecord).GetSinglePrtRecord(argAdm, argPrintTID)
	if (objEPrintRecord '= "")&&(objEPrintRecord.PrintStatus '= "UnPrint")
	{
		s EndPage = objEPrintRecord.EndPageNum
		s EndRow = objEPrintRecord.EndRowNum
		s IsLastRow = objEPrintRecord.LastRowProperty
	}
	
	//判断
	if ((EndPage'="")&&(EndRow'=""))
	{
		if IsLastRow = "1"
		{
			s EndPage = EndPage + 1
			s EndRow = "1"
		}
		else
		{
			s EndPage = EndPage
			s EndRow = EndRow + 1
		}
		s PrintPageAndRow = EndPage_"^"_EndRow
	}

	q PrintPageAndRow
}

/// **************************************************************************
/// Creator:	Chenwj
/// CreatDate:	/
/// Description:获取关联打印模板的系统参数
/// 			
/// Table:		/
/// Input:		/
/// Output:		/
/// Return:		/
/// Others:		/
/// Example:	/
/// **************************************************************************
ClassMethod GetPrtTplOrdOption() As %String
{
	 s prtTplOrdOptionStr = ""
	 s prtTplOrdOptionID = ""
	 
     s prtTplOrdOptionID = $o(^DHCEPRM.SysOptionI("NameIndex"," PRTTPLORDER",""))
	 if prtTplOrdOptionID'=""
	 {
		s prtTplOrdOptionStr=$li(^DHCEPRM.SysOptionD(prtTplOrdOptionID),4)	
	 }
	 
	 q prtTplOrdOptionStr
}

/// Desc:	保存打印记录
/// Debug:	w ##class(EPRservice.BOPrintService).SavePrintRecord(objRecord)
ClassMethod SavePrintRecord(AEPrintRecord As EPRservice.entity.EPrintRecord) As %String [ WebMethod ]
{
	//b "s"
	q:(AEPrintRecord = "") "0"
	
	s isSucceed = "0"
	
	//取 EpisodePrintRecordID
	s episodePrintRecordID = AEPrintRecord.EpisodePRID
	if (episodePrintRecordID = "")
	{
		//之前未创建, 检查是否现在已被其它用户创建, 因为可能会有多个用户并发打印同一份病历
		s episodePrintRecordID = ..GetEpisodePrintRecordID(AEPrintRecord)
	}
	if (episodePrintRecordID = "")
	{
		//创建 EpisodePrintRecord
		s episodePrintRecordID = ##class(EPRservice.BOPrintRecord).AddEpisodePrintRecord(AEPrintRecord)
	}
	q:(episodePrintRecordID = "") isSucceed
	
	s AEPrintRecord.EpisodePRID = episodePrintRecordID
	
	//取 InstancePrintRecordID
	s instancePrintRecordID = ..GetInstancePrintRecordID(AEPrintRecord)
	
	if (instancePrintRecordID = "")
	{
		//创建 InstancePrintRecord
		s instancePrintRecordID = ##class(EPRservice.BOPrintRecord).AddInstancePrintRecord(AEPrintRecord)
		s:(instancePrintRecordID '= "") isSucceed = "1"
	}
	else
	{
		//更新 InstancePrintRecord
		s isUpateOK = ##class(EPRservice.BOPrintRecord).UpdateInstancePrintRecord(instancePrintRecordID, AEPrintRecord)
		s:(isUpateOK) isSucceed = "1"
	}
	
	q isSucceed
}

/// Desc:	取 EpisodePrintRecordID
ClassMethod GetEpisodePrintRecordID(AEPrintRecord As EPRservice.entity.EPrintRecord) As %String
{
	q:(AEPrintRecord = "") ""

	s episodeID = AEPrintRecord.EpisodeID
	if (AEPrintRecord.PrintType = "Single")
	{
		s episodePrintRecordID = ##class(EPRservice.BOPrintRecord).GetSingleEpisodePrtRecordID(episodeID, AEPrintRecord.PrintTemplateID)
	}
	else
	{
		s episodePrintRecordID = ##class(EPRservice.BOPrintRecord).GetMultiEpisodePrtRecordID(episodeID, AEPrintRecord.InstanceDataID)
	}
	q episodePrintRecordID
}

/// Desc:	取 InstancePrintRecordID
ClassMethod GetInstancePrintRecordID(AEPrintRecord As EPRservice.entity.EPrintRecord) As %String
{
	q:(AEPrintRecord = "") ""
	q:(AEPrintRecord.EpisodePRID = "") ""
	
	if (AEPrintRecord.PrintType = "Single")
	{
		s episodePrintRecordID = AEPrintRecord.EpisodePRID
		s printTemplateID = AEPrintRecord.PrintTemplateID
		s instancePrintRecordID = ##class(EPRservice.BOPrintRecord).GetSingleInstancePrtRecordID(episodePrintRecordID, printTemplateID)
	}
	else
	{
		s instancePrintRecordID = ##class(EPRservice.BOPrintRecord).GetMultiInstancePrtRecordID(AEPrintRecord.InstanceDataID)
	}
	
	q instancePrintRecordID
}

/// Desc：	判断打印记录是否发生了变化
/// Return：0 未发生变化
/// 		1^InstanceDataId^Title^HappenDate HappenTime  发生了变化^第一个条打印就发生变化的InstanceData的ID^名称^发生时间 发生时间
/// Debug: 	w ##class(EPRservice.BOPrintService).CheckPrintRecordListChanged("","")
ClassMethod CheckDirtyPrintRecord(AInstanceIDList As %String, APrintRecordList As %String) As %String [ WebMethod ]
{
	//b "s"
	//s ^CacheTempDHCEPRDebug("EPRservice.BOPrintService", "CheckPrintRecordListChanged", "input")=AInstanceIDList_"#"_APrintRecordList
	
	s ret = "0"
	s changedInstanceId= ""
	
	q:(AInstanceIDList="")||(APrintRecordList="") "0"
	
	s FirstInstanceID =  $p(AInstanceIDList, "^", 1)
	s RecordID = $P(FirstInstanceID,"||",1)
	q:(RecordID="") "0"
	
	//将可重复病历按照发生日期时间排序
	s arrInstIDToDateSeq = ##class(%ArrayOfDataTypes).%New()
	s arrDateSeqToInstID = ##class(%ArrayOfDataTypes).%New()
	d ..GetInstanceSeqByRecord(RecordID, .arrInstIDToDateSeq, .arrDateSeqToInstID)
	
	//检查病历的打印记录是否发生了变化
	s preInstanceID = "", preSeq = "" 
	s curInstnaceID = "", curSeq = ""
	s count = $L(AInstanceIDList,"^")
	for i = 1:1:count
	{
		if (i = "1")
		{
			s preInstanceID = FirstInstanceID
			s preSeq = arrInstIDToDateSeq.GetAt(FirstInstanceID)
		}
		else
		{
			s preInstanceID = curInstnaceID
			s preSeq = curSeq
		}
		
		s curInstnaceID = $p(AInstanceIDList,"^",i)
		continue:(curInstnaceID="")
		
		//在排序中没有找到curInstnaceID，说明curInstnaceID的数据有问题
		s curSeq = arrInstIDToDateSeq.GetAt(curInstnaceID)
		if (curSeq = "")
		{	s changedInstanceId = curInstnaceID	}
		quit:(changedInstanceId '= "")
		
		//打印时跳过了某些病历，需要确认这些病历没有被打印过
		if (curSeq > preSeq + 1)
		{
			s tmpStSeq = preSeq + 1
			s tmpEndSEq = curSeq - 1
			for j = tmpStSeq:1:tmpEndSEq
			{
				s tmpInstanceId = arrDateSeqToInstID.GetAt(j)
				continue:(tmpInstanceId="")
				s tmpPrintRecord = ##class(EPRservice.BOPrintRecord).GetMultiPrtRecord(tmpInstanceId)
				continue:(tmpPrintRecord = "")
				continue:(tmpPrintRecord.EndPageNum = "")||(tmpPrintRecord.EndPageNum = $c(0))
				
				s changedInstanceId = curInstnaceID
				quit
			}
		}
		q:(changedInstanceId '= "")
		
		//判断当前病历打印记录是否变化
		s isChanged = ..IsPrintRecordChanged(curInstnaceID,$P(APrintRecordList,"^",i))
		if isChanged = "1"
		{	s changedInstanceId = curInstnaceID}
		q:(changedInstanceId '= "")
	}
	
	//初始化返回值
	if (changedInstanceId '= "")
	{
		s title = "", happenDate = "", happenTime = ""
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(changedInstanceId)
		if (objInstance '= "")
		{
			s title = objInstance.Title
			s happenDate = objInstance.HappenDate
			s happenTime = objInstance.HappenTime
			if (happenDate '= "") s happenDate = $Zd(happenDate,3)
			if (happenTime '= "") s happenTime = $Zt(happenTime,1)
			s ret = "1"_"^"_changedInstanceId_"^"_title_"^"_happenDate_" "_happenTime
		}
		else
		{
			s ret = "1^^^"
		}
		
		q ret
	}
	
	q "0"
}

/// Desc: 	指定InstanceData的打印记录是否发生了变化
ClassMethod IsPrintRecordChanged(AInstanceDataID As %String, ANewPrintRecord As %String) As %String
{
	s oldRecord = ##class(EPRservice.BOPrintRecord).GetMultiPrtRecord(AInstanceDataID)
	q:(oldRecord = "") "0"
		
	s startInfo = $p(ANewPrintRecord,";",1)
	s endInfo = $p(ANewPrintRecord,";",2)	
	q:(oldRecord.StartPageNum '= $p(startInfo,",",1)) "1"
	q:(oldRecord.StartRowNum '= $p(startInfo,",",2)) "1"
	q:(oldRecord.EndPageNum '= $p(endInfo,",",1)) "1"
	q:(oldRecord.EndRowNum '= $p(endInfo,",",2)) "1"
	
	q "0"
}

/// Desc:	清空发生变化的打印记录
/// Debug: 	d ##class(EPRservice.BOPrintService).ClearDirtyPrintRecord("35||2")
ClassMethod ClearDirtyPrintRecord(AInstanceID As %String) [ WebMethod ]
{
	//s ^CacheTempDHCEPRDebug("EPRservice.BOPrintService", "ClearDirtyRecord", "input") = AInstanceID
	
	s recordID = $P(AInstanceID,"||",1)
	q:(recordID="")
	
	s arrInstIDToDateSeq = ##class(%ArrayOfDataTypes).%New()
	s arrDateSeqToInstID = ##class(%ArrayOfDataTypes).%New()
	d ..GetInstanceSeqByRecord(recordID, .arrInstIDToDateSeq, .arrDateSeqToInstID)
	
	s dateSeq = arrInstIDToDateSeq.GetAt(AInstanceID)
	q:(dateSeq="")
	
	for {
		s instanceID = arrDateSeqToInstID.GetNext(.dateSeq)
		q:(dateSeq="")
		
		continue:(instanceID="")
		
		s recordID = $P(instanceID,"||",1)
		s seq = $P(instanceID,"||",2)
		&sql(update EPRinstance.InstancePrintRecord 
			set PrintStatus = 'UnPrint', StartPageNum = '0', StartRowNum = '0', EndPageNum = '0', EndRowNum = '0'
			where ECRecordID = :recordID and ECRSeq = :seq)
	}
}

/// 	Desc:	将可重复病历按照发生日期时间排序
/// Debug: 	w ##class(EPRservice.BOPrintService).ResortSeqByHappenTime("495525||3",.a,.b,.c)
ClassMethod ResortSeqByHappenTime(ACurInstanceDataID As %String, ByRef ACurSeq As %String, ByRef APreSeq As %String, ByRef APreInstanceDataID As %String)
{
	//added on 2009-01-21 by HouJian
	//将历次病历的InstanceData按发生日期排序
	//b "s"
	s repid = $I(^CacheTemp)
	s RecordID = $P(ACurInstanceDataID,"||",1)
	//s listNo = " 0"
	s childsub = 0
	for {
		//b "s"
		//s listNo = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",RecordID,listNo))
		//q:(listNo="")
		//s childsub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",RecordID,listNo,""))
		//s instanceid = RecordID_"||"_childsub
		s childsub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,childsub))
		q:(childsub="")
		s instanceid = RecordID_"||"_childsub
		//跳过已删除日常病程
		continue:(##class(EPRservice.BLRecInstanceData).CheckRecordAvailable(instanceid)="Dumped")
		
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
		if objInstance '= ""
		{
			if (objInstance.HappenDate = "")
			{	s date = $p($H,",",1)}
			else 
			{	s date = objInstance.HappenDate}
			if (objInstance.HappenTime = "")
			{	s time = $p($H,",",2)}
			else
			{	s time = objInstance.HappenTime}
			s ^CacheTemp(repid, date, time) = instanceid
		}
	}
	
	s repidSort = $I(^CacheTemp)
	s date =""
	s dateSeqCount = 0
	for {
		s date = $O(^CacheTemp(repid,date))
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repid,date,time))
			q:(time="")
			
			s dateSeqCount = dateSeqCount + 1
			s ^CacheTemp(repidSort, "DateSeqToInstSeq",dateSeqCount) = $g(^CacheTemp(repid,date,time))
			s ^CacheTemp(repidSort, "InstSeqToDateSeq",$g(^CacheTemp(repid,date,time)))=dateSeqCount
		}
	}
	
	s ACurSeq = $g(^CacheTemp(repidSort, "InstSeqToDateSeq",ACurInstanceDataID))
	s APreSeq = ACurSeq - 1
	s APreInstanceDataID = ""
	if (APreSeq '< 1) {s APreInstanceDataID = $g(^CacheTemp(repidSort, "DateSeqToInstSeq",APreSeq))}
	
	kill ^CacheTemp(repid)
	kill ^CacheTemp(repidSort)
	// 将历次病历的InstanceData按发生日期排序 结束
}

/// Desc: 	将可重复病历按照发生日期时间排序
/// Ouput:  arrInstIDToDateSeq    key为InstanceDataID，value为按照日期时间排的顺序号
/// 		arrDateSeqToInstID    key为按照日期时间排的顺序号，value为InstanceDataID
ClassMethod GetInstanceSeqByRecord(RecordID As %String, ByRef arrInstIDToDateSeq As %ArrayOfDataTypes, ByRef arrDateSeqToInstID As %ArrayOfDataTypes)
{
	Set arrInstIDToDateSeq = ##class(%ArrayOfDataTypes).%New()
	Set arrDateSeqToInstID = ##class(%ArrayOfDataTypes).%New()
	
	//将可重复病历按照发生日期时间排序
	s repid = $I(^CacheTemp)
	s repidSort = $I(^CacheTemp)
	
	s childsub = 0
	for {
		s childsub = $O(^DHCEPRI.InstanceDataI("IdxECRecord",RecordID,childsub))
		q:(childsub="")
		s instanceid = RecordID_"||"_childsub
		s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceid)
		if objInstance '= ""
		{
			if (objInstance.HappenDate = "")
			{	s date = $p($H,",",1)}
			else 
			{	s date = objInstance.HappenDate}
			if (objInstance.HappenTime = "")
			{	s time = $p($H,",",2)}
			else
			{	s time = objInstance.HappenTime}
			s ^CacheTemp(repid, date, time) = instanceid
		}
	}
	
	s date =""
	s dateSeqCount = 0
	for {
		s date = $O(^CacheTemp(repid,date))
		q:(date="")
		
		s time = ""
		for {
			s time = $O(^CacheTemp(repid,date,time))
			q:(time="")
			
			s dateSeqCount = dateSeqCount + 1
			s instnaceid = $g(^CacheTemp(repid,date,time))
			d arrInstIDToDateSeq.SetAt(dateSeqCount, instnaceid)
			d arrDateSeqToInstID.SetAt(instnaceid, dateSeqCount)
		}
	}
	
	kill ^CacheTemp(repid)
	kill ^CacheTemp(repidSort)
}

/// Desc:	获取可重复病历最新的打印模板(包含未发布的版本)
///  		方便在测试库测试打印模板制作
///  		正式库请确认：系统参数 PrintUseLastVersion 值为 N
ClassMethod GetLastPTVersionIDString(AInstanceIDString As %String) As %String
{
	q:(AInstanceIDString = "") ""
	s ptVersionIDString = ""
	
	s count = $L(AInstanceIDString, ",")
	for i = 1:1:count
	{
		s instanceID = $P(AInstanceIDString, ",", i)
		
		s ptID = ..GetBindPrtTplIDByInstanceID(instanceID)
		s ptVersionID = ##Class(EPRservice.BOPrintTemplate).GetMaxVIDByTempID(ptID)
		
		if i = 1
		{	s ptVersionIDString = ptVersionID}
		else
		{	s ptVersionIDString = ptVersionIDString_","_ptVersionID}
	}
	
	q ptVersionIDString
}

/// Desc:	获取最新的打印模板(包含未发布的版本)
/// 		方便在测试库测试打印模板制作
/// 		正式库请确认：系统参数 PrintUseLastVersion 值为 N
ClassMethod GetLastPTVersion(APrintTemplateID As %String) As EPRservice.entity.EMixPrintVersion
{
	q:(APrintTemplateID = "") ""
	s lastVersionID = ##Class(EPRservice.BOPrintTemplate).GetMaxVIDByTempID(APrintTemplateID)		
	s objEMixPrintVersion = ##Class(EPRservice.BOPrintTemplate).GetMixVersionByPTVersionID(lastVersionID)
	q objEMixPrintVersion
}

/// +++++++++++++++	停用代码 ++++++++++++++++++
/// 	Desc:	根据界面模板版本确定要使用的打印模板版本ID
/// w ##class(EPRservice.BOPrintService).GetPrintTplVerByTplVer("805","5","328")
ClassMethod GetPrintTplVerByTplVer(ATplID As %String, ATplVerion As %String, APrintTplID As %String) As %String
{
	s printTplVersionID = ""
	
	q:(ATplID="")||(ATplVerion="")||(APrintTplID="") printTplVersionID
	
	s para = ##class(EPRmeta.SysOption).GetOptionValueByName("PrintByTemplateVersion")
	q:(para '= "Y") ""
		
	s tplVersionID = ""
	&sql(select top 1 ID into :tplVersionID
		from EPRmeta.TemplateVersion where TemplateID = :ATplID and VersionNumber = :ATplVerion)
	q:(tplVersionID="") printTplVersionID
	
	s objTplVersion = ##class(EPRmeta.TemplateVersion).%OpenId(tplVersionID)
	q:(objTplVersion = "") printTplVersionID
	
	s tplPublishDate = objTplVersion.PublicationDate
	s tplPublishTime = objTplVersion.PublicationTime
	q:(tplPublishDate = "")||(tplPublishTime = "") printTplVersionID
	
	s version = ""
	for {
		s version = $O(^DHCEPRM.PrintTemplateVersionI("IdxForPrintTIDAndVerNum", " "_APrintTplID, version),-1)
		q:(version = "")
		
		s versionId = $O(^DHCEPRM.PrintTemplateVersionI("IdxForPrintTIDAndVerNum", " "_APrintTplID, version,""))
		
		s objPrintTplVer = ##class(EPRmeta.PrintTemplateVersion).%OpenId(versionId)
		continue:(objPrintTplVer="")
		
		s date = objPrintTplVer.PublicationDate
		s time = objPrintTplVer.PublicationTime
		continue:(date="")||(time="")
		
		if (date > tplPublishDate)
		{
			s printTplVersionID = versionId
		}
		elseif (date = tplPublishDate)&&(time > tplPublishTime)
		{
			s printTplVersionID = versionId
		}
		else
		{
			quit
		}
	}
	
	q printTplVersionID
}

ClassMethod PrintDataTransByStream(APString As %String) As EPRservice.entity.ReStreamData [ WebMethod ]
{
 	Set Reslut = ##class(EPRservice.BODataGateway).DBInterFaceByStream(APString)	
 	Quit Reslut
}

ClassMethod PrintDTByStreamPL(APString As %String, APrivacyLevel) As EPRservice.entity.ReStreamData [ WebMethod ]
{
 	Set Reslut = ##class(EPRservice.BODataGateway).DBInterFaceByStreamPrivacyInfo(APString, APrivacyLevel)	
 	Quit Reslut
}

/// +++++++++++++++ 测试代码 +++++++++++++++++
/// Debug: w ##class(EPRservice.BOPrintService).TestCheckPrintRecordListChanged()
ClassMethod TestCheckPrintRecordListChanged() As %String
{
	s instancList = $P(^CacheTempDHCEPRDebug("EPRservice.BOPrintService", "CheckPrintRecordListChanged", "input"),"#",1)
	s recordList = $P(^CacheTempDHCEPRDebug("EPRservice.BOPrintService", "CheckPrintRecordListChanged", "input"),"#",2)
	w ##class(EPRservice.BOPrintService).CheckPrintRecordListChanged(instancList,recordList)
	q "end"
}

/// Debug:	d ##class(EPRservice.BOPrintService).TestGetPrintRecord()
ClassMethod TestGetPrintRecord()
{
	//b "s"
	s param = ^CacheTempDHCEPRDebug("BOPrintService","GetPrintRecord", "Input")
	s AEpisodeID = $p(param, "^", 1)
	s AInstanceDataID = $p(param, "^", 2)
	s APrintType = $p(param, "^", 3)
	s APrintTemplateID = $p(param, "^", 4)
	s APageNum = $p(param, "^", 5)
	s ARowNum = $p(param, "^", 6)
	s obj = ..GetPrintRecord(AEpisodeID, AInstanceDataID, APrintType, APrintTemplateID, .APageNum, .ARowNum)
	q obj
}

/// Debug:	d ##class(EPRservice.BOPrintService).TestGetMixPTVersionByAdmAndPTID()
ClassMethod TestGetMixPTVersionByAdmAndPTID()
{
	//b "s"
	s param = ^CacheTempDHCEPRDebug("BOPrintService","GetMixPTVersionByAdmIDAndPTID", "Input")
	s eid  = $P(param,"^",1)
	s pid = $P(param,"^",2)
	s obj = ..GetMixPTVersionByAdmIDAndPTID(eid, pid)
	w "ok"
}

/// Debug:	d ##class(EPRservice.BOPrintService).TestGetMixPTVersionByInstanceID()
ClassMethod TestGetMixPTVersionByInstanceID()
{
	//b "s"
	s param = $g(^CacheTempDHCEPRDebug("BOPrintService","GetMixPTVersionByInstanceID", "Input"))
	s instanceId  = param
	s obj = ..GetMixPTVersionByInstanceID(instanceId)
	w "ok"
}

/// Debug:	d ##class(EPRservice.BOPrintService).TestSavePrintRecord()
ClassMethod TestSavePrintRecord()
{
	s obj = ..TestGetPrintRecord()
	s sc = ..SavePrintRecord(obj)
	w sc
}

}
