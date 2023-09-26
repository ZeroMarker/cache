Class web.eprajax.CentralizedPrintDisplay Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	q:(patientID="") $$$OK
	
	s userID = $Get(%request.Data("UserID",1),"-1")
	s ctLocID = $Get(%request.Data("CTLocID",1),"-1")
	s ssGroupID = $Get(%request.Data("SSGroupID",1),"-1")
	
	s pageInfoID = $Get(%request.Data("PageInfoID",1),"")
	s pdfCreateFlag = $Get(%request.Data("Action",1),"")
	
	if (pdfCreateFlag = "pdfcreate"){
		d ..GetPdfCreateSchemeJson(episodeID, userID, ctLocID, ssGroupID, pageInfoID)
	}
	else{
		d ..GetDefaultSchemeJson(episodeID, userID, ctLocID, ssGroupID, pageInfoID)
	}
	Quit $$$OK
}

/// Desc:	获取当前打印方案中设置的打印项目
/// Input：	episodeID - 病人就诊号
/// 		userID - 操作用户ID
/// Output: 当前打印方案中设置的打印项目Json串
/// 			若没有设置当前打印方案，则为全部可打印项目Json串
/// Debug：	d ##Class(web.eprajax.CentralizedPrintDisplay).GetDefaultSchemeJson("201868", "5972","13")
ClassMethod GetPdfCreateSchemeJson(episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String, pageInfoID As %String) As %String
{
	s rowID = ""
	s count = 0

	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsPDF", " DEFAULTPDF", rowID))
		if (rowID '= "")
		{
			s count = count + 1
		}
		q:(rowID = "") 
		//取当前打印方案设置的打印项目	
		s scheme = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		q:(scheme = "")
		
		s items = scheme.SchemeItems

		w "["
			d ..GetSchemeCategoryJson(episodeID, userID, ctLocID, ssGroupID, items, pageInfoID)
		w "]"
	}
	if (count = 0)
	{
		//没有设置当前打印方案则取全部
		d ..GetJson(episodeID, userID, ctLocID, ssGroupID, pageInfoID)
	}
	
	q 1
}

/// Desc:	获取当前打印方案中设置的打印项目
/// Input：	episodeID - 病人就诊号
/// 		userID - 操作用户ID
/// Output: 当前打印方案中设置的打印项目Json串
/// 			若没有设置当前打印方案，则为全部可打印项目Json串
/// Debug：	d ##Class(web.eprajax.CentralizedPrintDisplay).GetDefaultSchemeJson("201868", "5972","13")
ClassMethod GetDefaultSchemeJson(episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String, pageInfoID As %String) As %String
{
	s rowID = ""
	s count = 0

	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		if (rowID '= "")
		{
			s count = count + 1
		}
		q:(rowID = "") 
		//取当前打印方案设置的打印项目	
		s scheme = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%OpenId(rowID)
		q:(scheme = "")
		
		s items = scheme.SchemeItems

		w "["
			d ..GetSchemeCategoryJson(episodeID, userID, ctLocID, ssGroupID, items, pageInfoID)
		w "]"
	}
	if (count = 0)
	{
		//没有设置当前打印方案则取全部
		d ..GetJson(episodeID, userID, ctLocID, ssGroupID, pageInfoID)
	}
	
	q 1
}

/// Desc:	获取当前打印方案中设置的打印项目
/// Input：	AEpisodeID - 病人就诊号
/// 		AUserID - 操作用户ID
/// 		AItems - 打印项目串
/// Output: Json串
/// debug: 	d ##class(web.eprajax.CentralizedPrintDisplay).GetSchemeCategoryJson("201868","5972","CG05#CD0505^CG07#CD#6#25","13")
ClassMethod GetSchemeCategoryJson(AEpisodeID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String, AItems As %String, APageInfoID As %String)
{
	//检查是否有续打项目，有续打项目的话组合两个续打项目为一项
	s items = ..CheckComboPrint(AItems,AEpisodeID,AUserID,ACTLocID,ASSGroupID)
	s rowID = ""
	s order = 0
	for i=1:1:$l(items,"^")
	{	
		s category = $p(items,"^",i)
		s categoryIDNum = $e(category,3,4)
		if (categoryIDNum '= "07")
		{
			s rowID = ""
			for {
				s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxCategoryID", " "_categoryIDNum, rowID))
				q:(rowID = "")
			
				s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)

				s desc = objItem.CategoryDesc_"."_objItem.CategoryDesc
				s id = category
				
				//页码信息
				s pageInformation = ""
				s pageRange = ""
				s pageInfo = ..GetPageInfo(APageInfoID)
				if (pageInfo '= "-1")
				{
					for k=1:1:$l(pageInfo,"^")
					{
						s pageInfoID = $p($p(pageInfo,"^",k),"|",1)
						if (pageInfoID = id)
						{
							s startPageNumber = $p($p(pageInfo,"^",k),"|",2)
							s endPageNumber = $p($p(pageInfo,"^",k),"|",3)
							s pageInformation = startPageNumber_"-"_endPageNumber
							s pageRange = endPageNumber - startPageNumber + 1
							if (pageRange = 0){
								s pageInformation = "error"	
							} 	
						}	
					}	
				}
				s order = order + 1
				if (order>1) w ","
				w "{"
				w "id:'"_id_"'"
				w ",text:'"_desc_"'"
				w ",order:'"_order_"'"
				w ",detailInfo:'"_desc_"'"
				//w ",pageInformation:'"_pageInformation_"'"
				//w ",pageRange:'"_pageRange_"'"
				w "}"
			}
		}
		else
		{
			//病历文书部分
			s order = ..GetEPRItem(category,order, AEpisodeID, AUserID, ACTLocID, ASSGroupID, APageInfoID)
		}
	}
	
	q "1"
}

/// Desc:	获取当前打印方案中设置的打印项目（病历文书部分）
/// Input：	AEpisodeID - 病人就诊号
/// 		AUserID - 操作用户ID
/// 		AItem - 打印项目
/// 		AOrder - 序列号
/// Output: Json串
/// debug: 	d ##class(web.eprajax.CentralizedPrintDisplay).GetEPRItem("CG07#CD#6#25","1","201868","5972","13")
ClassMethod GetEPRItem(AItem As %String, AOrder As %String, AEpisodeID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String, APageInfoID As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)
	s allID = AItem
	
	//满足续打
	if ($f(AItem,"@") '= 0)
	{
		//在CheckComboPrint里已经检查两个打印模板均可以打印
		//第一项
		s itemsOne = $p(AItem,"@",1)
		s cgIDOne = $p(itemsOne,"#",3)
		s ccIDOne = $p(itemsOne,"#",4)
		s cgDescOne = ..GetEPRTemplateCategoryDesc(cgIDOne)
		s ccDescOne = ..GetEPRTemplateCategoryDesc(ccIDOne)
		s pIDOne = ..GetPrintTplCategoryID(ccIDOne, AEpisodeID)
		s infoOne = ..GetDetailInfo(pIDOne, patientID, AEpisodeID, AUserID)	
		
		//第二项，此项接着第一项续打
		s itemsTwo = $p(AItem,"@",2)
		s cgIDTwo = $p(itemsTwo,"#",3)
		s ccIDTwo = $p(itemsTwo,"#",4)
		s cgDescTwo = ..GetEPRTemplateCategoryDesc(cgIDTwo)
		s ccDescTwo = ..GetEPRTemplateCategoryDesc(ccIDTwo)
		s pIDTwo = ..GetPrintTplCategoryID(ccIDTwo, AEpisodeID)
		s infoTwo = ..GetDetailInfo(pIDTwo, patientID, AEpisodeID, AUserID)	
		//合并信息
		s desc = cgDescOne_"."_ccDescOne_" + "_cgDescTwo_"."_ccDescTwo
		s info = infoOne_"!"_infoTwo
		//页码
		s pageInformation = ""
		s pageRange = ""
		s pageInfo = ..GetPageInfo(APageInfoID)
		if (pageInfo '= "-1")
		{
			for k=1:1:$l(pageInfo,"^")
			{
				s pageInfoID = $p($p(pageInfo,"^",k),"|",1)
				if (pageInfoID = allID)
				{
					s startPageNumber = $p($p(pageInfo,"^",k),"|",2)
					s endPageNumber = $p($p(pageInfo,"^",k),"|",3)
					s pageInformation = startPageNumber_"-"_endPageNumber
					s pageRange = endPageNumber - startPageNumber + 1 
					if (pageRange = 0){
						s pageInformation = "error"	
					}	
				}	
			}	
		}
		s allID = AItem
		s AOrder = AOrder + 1
		if (AOrder > 1) w ","
		w "{"
		w "id:'"_allID_"'"
		w ",detailInfo:'"_info_"'"
		w ",text:'"_desc_"'"
		w ",order:'"_AOrder_"'"
		w ",pageInformation:'"_pageInformation_"'"
		w ",pageRange:'"_pageRange_"'"	
		w "}"
	}
	//无续打
	else
	{
		s photoScan = 0
	
		s cgID = $p(AItem,"#",3)
		s ccID = $p(AItem,"#",4)
		s cgDesc = ..GetEPRTemplateCategoryDesc(cgID)
		s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
		
		s prtID = ""
		for {
			s prtID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ccID, prtID))
			q:(prtID = "")
			continue:(..CheckCanPrint(AUserID,ACTLocID,ASSGroupID,AEpisodeID,patientID,prtID) = "0")
			continue:(..NeedPrint(AEpisodeID, prtID) = "0")
			
			s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(prtID)
			//扫描图片
			if (objEPRTemplateCategory.CategoryType = "PhotoScan")
			{
				s photoScan = 1
			}
		
			s desc = cgDesc_"."_ccDesc
			s pageInformation = ""
			s pageRange = ""
			s info = ""
			if (photoScan = 1)
			{
				s info = ..GetPhotoScanLocation(prtID, AEpisodeID)
				//扫描图片不可打印
				continue:(info = "")
				s pageInformation = "scan"
				s pageRange = "scan"
			}
			else
			{
				s info = ..GetDetailInfo(prtID, patientID, AEpisodeID, AUserID)	
				s pageInfo = ..GetPageInfo(APageInfoID)
				if (pageInfo '= "-1")
				{
					for k=1:1:$l(pageInfo,"^")
					{
						s pageInfoID = $p($p(pageInfo,"^",k),"|",1)
						if (pageInfoID = allID)
						{
							s startPageNumber = $p($p(pageInfo,"^",k),"|",2)
							s endPageNumber = $p($p(pageInfo,"^",k),"|",3)
							s pageInformation = startPageNumber_"-"_endPageNumber
							s pageRange = endPageNumber - startPageNumber + 1 
							if (pageRange = 0){
								s pageInformation = "error"	
							}	
						}	
					}	
				}
			}
			
			s AOrder = AOrder + 1
			if (AOrder > 1) w ","
			w "{"
			w "id:'"_allID_"'"
			w ",detailInfo:'"_info_"'"
			w ",text:'"_desc_"'"
			w ",order:'"_AOrder_"'"
			w ",pageInformation:'"_pageInformation_"'"
			w ",pageRange:'"_pageRange_"'"	
			w "}"
		}
	}
	q AOrder
}

/// Desc:	检查是否满足续打
/// Input：	AItems - 所有待打印项目串
/// 		AEpisodeID - 就诊号
/// Output: AItems - 合并续打后的待打印项目串
/// debug: 	w ##class(web.eprajax.CentralizedPrintDisplay).CheckComboPrint("CG07#CD#4#20^CG07#CD#5#23","201868","5972","34","576")
ClassMethod CheckComboPrint(AItems As %String, AEpisodeID As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeID)

	//获取续打系统参数
	s sysOption = ##class(EPRmeta.SysOption).GetOptionValueByName("PrtTplOrder")
	for i=1:1:$l(sysOption,"|")
	{
		for j=1:1:$l(AItems,"^")
		{
			s flag = 0
			//不是病历文书项
			continue:($p($p(AItems,"^",j),"#",1) '= "CG07")
			s printTmpltIDFirst = ""
			s printTmpltIDFirst = ..GetPrintTplCategoryID($p($p(AItems,"^",j),"#",4), AEpisodeID)
			//无打印模板继续
			continue:(printTmpltIDFirst = "")
			continue:(..CheckCanPrint(AUserID,ACTLocID,ASSGroupID,AEpisodeID,patientID,printTmpltIDFirst) = 0)
			//判断是否是唯一模板，续打必须是唯一模板后面接可重复模板
			s printTmpltIDFirst = ..GetPrintTplID(printTmpltIDFirst)
			s objPrintFirst = ##Class(EPRmeta.PrintTemplate).%OpenId(printTmpltIDFirst)
			continue:(objPrintFirst = "")
			s printTypeFirst = objPrintFirst.ChartItemType
			continue:(printTypeFirst = "Multiple")
			
			//第一项不与系统参数续打第一个位置的模板id相同，则不续打
			continue:(printTmpltIDFirst '= $p($p(sysOption,"|",i),"^",1))
			//第一项已符合续打条件，判断紧跟着的可打印模板是否符合续打第二项条件
			for k=(j+1):1:($l(AItems,"^"))
			{
				//不是病历文书项
				q:($p($p(AItems,"^",k),"#",1) '= "CG07")
				s printTmpltIDSecond = ""
				s printTmpltIDSecond = ..GetPrintTplCategoryID($p($p(AItems,"^",k),"#",4), AEpisodeID)
				//无打印模板继续
				continue:(printTmpltIDSecond = "")
				continue:(..CheckCanPrint(AUserID,ACTLocID,ASSGroupID,AEpisodeID,patientID,printTmpltIDSecond) = 0)
				//判断是否是可重复模板，续打必须是唯一模板后面接可重复模板
				s printTmpltIDSecond = ..GetPrintTplID(printTmpltIDSecond)
				s objPrintSecond = ##Class(EPRmeta.PrintTemplate).%OpenId(printTmpltIDSecond)
				q:(objPrintSecond = "")
				s printTypeSecond = objPrintSecond.ChartItemType
				q:(printTypeSecond = "Single")
				
				//第二项不与系统参数续打第二个位置的模板id相同，则不续打
				q:(printTmpltIDSecond '= $p($p(sysOption,"|",i),"^",2))	
				
				//已匹配第二项，第一项和第二项之间有不可打印的部分，删除
				//删除之间不可打印的项目
				s locationEnd = ($f(AItems,$p(AItems,"^",k)) - 1)
				s locationBegin = ($f(AItems,$p(AItems,"^",j)) - 1)
				//将分割符"^"替换成"@"
				s AItems = $e(AItems,1,locationBegin)_"@"_$p(AItems,"^",k)_$e(AItems,(locationEnd+1),$l(AItems))
			}
		}
	}
	q AItems
}

/// debug: w ##class(web.eprajax.CentralizedPrintDisplay).GetPrintTplCategoryID("23","201868")
ClassMethod GetPrintTplCategoryID(ccID As %String, AEpisodeID As %String) As %String
{
	s printTplID = ""
	s rowID = ""
	for {
		s rowID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ccID, rowID))
		q:(rowID = "")
		//不可打印
		continue:(..NeedPrint(AEpisodeID, rowID) = "0")
		s printTplID = rowID
	}
	q printTplID
}

ClassMethod GetPrintTplID(printTmpltID As %String) As %String
{
	s obj = ##class(EPRmeta.EPRTemplateCategory).%OpenId(printTmpltID)
	
	q obj.BindPrnTemplateID
}

/// Desc:	获取页码信息
/// Input：	AUserID - 操作用户ID
/// Output: pageInfo - 页码信息
/// Debug: w ##class(web.eprajax.CentralizedPrintDisplay).GetPageInfo("13")
ClassMethod GetPageInfo(pageInfoID As %String) As %String
{
	if (pageInfoID '=""){
		s obj = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintInfo).%OpenId(pageInfoID)
		q:(obj = "") "-1"
	
		s pageInfo = obj.PageInfo
	
		d obj.%Close()
		q pageInfo
	}
	else{
		q ""	
	}
}

/// Desc:	获取当前打印方案ID
/// Input：	
/// Output: schemeID
ClassMethod GetDefault() As %String
{
	s rowID = ""
	s default = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		q:(rowID = "") 
		
		s default = default + 1
	}	
	
	if (default > 0)
	{
		s rowID = ""
		s schemeID = ""
		for {
			s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
			q:(rowID = "") 
		
			s schemeID = rowID
			q 
		}
		
	}
	else
	{
		s rowID = ""
		s schemeID = ""
		for {
			s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " NODEFAULT", rowID))
			q:(rowID = "") 
		
			s schemeID = rowID
			q 
		}	
	}
	q schemeID
}

/// Desc:	根据节点类型，获取相应json字串
/// Input：	parentNodeID 父节点ID
/// 			RT00 	根节点
/// 			CG01	检查报告    
/// 			CG02	检验报告
/// 			CG03	医嘱单
/// 			CG04	体温单
/// 			CG05	住院证
/// 			CG06	护理病历
/// 			CG07	病历文书
/// 			CG08	麻醉记录
/// 			CG09	病理
/// 			CG10	心电图
/// debug 	d ##class(web.eprajax.CentralizedPrintDisplay).GetJson("201868","5972")
ClassMethod GetJson(episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String, pageInfoID As %String) As %String
{
	
	s rowID = ""
	s default = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " DEFAULT", rowID))
		q:(rowID = "") 
		
		s default = default + 1
	}	
	
	s rowID = ""
	s noDefault = 0
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintSchemeI("IdxIsDefault", " NODEFAULT", rowID))
		q:(rowID = "") 
		
		s noDefault = noDefault + 1
	}

	if ((default = 0) && (noDefault = 0))
	{
		s items = ..AllPrintItem(episodeID, userID, ctLocID, ssGroupID)
		s objScheme = ##class(EPRmeta.CentralizedPrint.CentralizedPrintScheme).%New()
		q:(objScheme="") "-1"
		s objScheme.IsDefault = "noDefault"
		s objScheme.SchemeItems = items
		
		s sc = objScheme.%Save()
	
		d objScheme.%Close()

		w "["

			d ..GetSchemeCategoryJson(episodeID, userID, ctLocID, ssGroupID, items, pageInfoID)
	
		w "]"
	}
	elseif (noDefault > 0)
	{
		s items = ..AllPrintItem(episodeID, userID, ctLocID, ssGroupID)
		w "["
			d ..GetSchemeCategoryJson(episodeID, userID, ctLocID, ssGroupID, items, pageInfoID)
		w "]"
	}
}

/// Desc:	获取所有打印项目
/// Input：	episodeID - 就诊号
/// Output: items - 所有项目串
/// debug 	w ##class(web.eprajax.CentralizedPrintDisplay).AllPrintItem("201868")
ClassMethod AllPrintItem(episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String) As %String
{
	s initOK = ##Class(EPRservice.BLL.BLCentralizedPrintInit).CentralizedPrintInit()
	s items = ""
	s rowID = ""
	s i = 1
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxSequence", i, rowID))
		q:(rowID = "")
			
		s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)
		//病历文书
		if (i = 7)
		{
			if (items = "")	
			{
				s items = ..AllEPRPrintItem(episodeID)
			}
			else
			{
				s items = items_"^"_..AllEPRPrintItem(episodeID)	
			}
		}
		else
		{
			if (items = "")	
			{
				s items = "CG"_objItem.CategoryID_"#CD"_objItem.CategoryID_objItem.CategoryID	
			}
			else
			{
				s items = items_"^"_"CG"_objItem.CategoryID_"#CD"_objItem.CategoryID_objItem.CategoryID		
			}
		}
		s i = i + 1
	}
	//检查是否有续打项目，有续打项目的话组合两个续打项目为一项
	s items = ..CheckComboPrint(items,episodeID,userID, ctLocID, ssGroupID)
	q items
}

/// Desc:	获取所有病历文书打印项目
/// Input：	episodeID - 就诊号
/// Output: allID - 所有项目串
ClassMethod AllEPRPrintItem(episodeID As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
	s cgID = ""
	s allID = ""
	for {
		s cgID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		
		s cgDesc = ..GetEPRTemplateCategoryDesc(cgID)

		s ccID = ""
		for {
			s ccID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
			if (allID = "")
			{
				s allID = "CG07#CD#"_cgID_"#"_ccID
			}
			else
			{
				s allID = allID_"^"_"CG07#CD#"_cgID_"#"_ccID
			}
		}
	}
	q allID
}

/// Desc:	判断07病历文书下的节点是否能打印
/// Input：	AEpisodeID - 就诊号
/// 		APrintTemplateDocID - 打印模板ID	
/// Output: 0 - 不可打印
/// 		1 - 可打印（PhotoScan全为可打印，在GetEPRItem中处理）
ClassMethod NeedPrint(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
				
	q:(objEPRTemplateCategory = "") "0"
	q:(objEPRTemplateCategory.CategoryType = "PhotoScan") "1"
	q:(objEPRTemplateCategory.CategoryType '= "PrtTemplate") "0"
	q:(..IsSaved(AEpisodeID, APrintTemplateDocID) = "0") "0"
	q "1"
}

/// Desc:	判断07病历文书下的节点是否已保存
/// Input：	AEpisodeID - 就诊号
/// 		APrintTemplateDocID - 打印模板ID	
/// Output: 0 - 未保存
/// 		1 - 已保存
ClassMethod IsSaved(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s eprLogsID = ""
	&sql(select top 1 ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :APrintTemplateDocID)
	
	q:(eprLogsID = "")||(eprLogsID = $c(0)) "0"
	q "1"
}

/// Desc:	获得07病历文书下的图片扫描节点路径
/// Input：	prtID - 打印模板ID
/// 		episodeID - 就诊号	
/// Output: 节点下所有路径集，以^分隔节点下各个图片路径
ClassMethod GetPhotoScanLocation(prtID As %String, episodeID As %String) As %String
{
	s rowID = ""
	s parentNodeID = ""
	for {
		s rowID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", " "_prtID, rowID))
		q:(rowID = "")
		
		s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(rowID)
		s parentNodeID = objEPRTemplate.BindTemplateCategoryID	
	}
	
	s rowID = ""
	s info = ""
	for {
		s rowID = $o(^DHCEPRI.RecordScanI("IdxParentEpisodeID", " "_parentNodeID, " "_episodeID, rowID))
		q:(rowID = "")
		
		s objPhotoScan = ##Class(EPRinstance.RecordScan).%OpenId(rowID)
		if (info = "")
		{
			s info = "PS"_"^"_objPhotoScan.Postion
		}
		else
		{
			s info = info_"^"_objPhotoScan.Postion	
		}
	}
	q info
}

/// Desc:	07病历文书下的节点打印信息
/// Input：	ACategoryChapterDocID - 模板目录ID
/// 		APatientID - 病人ID	
/// 		AEpisodeID - 就诊号
/// 		AUserID - 操作用户
/// Output: printType^APatientID^AEpisodeID^AUserID^printTemplateID^APrintTemplateDocID^instanceDataIDs
ClassMethod GetDetailInfo(APrintTemplateDocID As %String, APatientID, AEpisodeID, AUserID) As %String
{
	//b "s"
	s (printType, patientID, episodeID,userID) = ""
	s (printTemplateID, printDocID, instanceDataIDs) = ""

	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType
	
	if (printType = "Multiple")
	{
		s instanceDataIDs = ..GetInstanceData(AEpisodeID, APrintTemplateDocID)
		q:(instanceDataIDs = "") "" 
	}
	q printType_"^"_APatientID_"^"_AEpisodeID_"^"_AUserID_"^"_printTemplateID_"^"_APrintTemplateDocID_"^"_instanceDataIDs
}

/// Desc:	07病历文书下的模板目录的文字描述
/// Input：	ACategoryChapterDocID - 模板目录ID	
/// Output: ccDesc - 模板目录的文字描述
ClassMethod GetEPRTemplateCategoryDesc(ACategoryChapterDocID As %String) As %String
{
	s obj = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(ACategoryChapterDocID)
	q:(obj = "") ""
	s ccDesc = obj.CategoryName
	s ccDesc = $tr(ccDesc, $c(10), "")
	s ccDesc = $tr(ccDesc, $c(13), "")
	s ccDesc = $tr(ccDesc, "'", "")
	
	q ccDesc
}

ClassMethod GetInstanceData(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s instanceDataIDs = ""
	Set rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportList")
 	Set sc = rset.Execute(AEpisodeID, APrintTemplateDocID)
 	While (rset.Next()){
 		if (instanceDataIDs = "")
		{	s instanceDataIDs = rset.Data("ID")}
		else
		{	s instanceDataIDs = instanceDataIDs_","_rset.Data("ID")}
 	}
 	
 	q instanceDataIDs
}

/// debug: w ##class(web.eprajax.onestepprint).CheckCanPrint("5972","34","576","201868","11","24")
ClassMethod CheckCanPrint(AUserID, ACTLocID, ASSGroupID, AEpisodeID, APatientID, eprCategoryID) As %String
{
	s authorizationSwitch =##class(EPRmeta.SysOption).GetOptionValueByName("AuthorizationOneStepPrintSwitch")
	q:(authorizationSwitch '= "Y") "1"

	//扫描在程序里判断，这里凡是扫描的都返回可以
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(eprCategoryID)			
	q:(objEPRTemplateCategory = "") "0"
	q:(objEPRTemplateCategory.CategoryType = "PhotoScan") "1"

	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType

	s rowID = ""
	s canViewOneDoc = 0
	s canPrintOneDoc = 0
	s canView = 0
	s canPrint = 0
	
	//是否打印模板已完成
	s finish = 0
	s finish = ##class(EPRservice.BIL.BIEPRLogs).HasFinished(AEpisodeID, eprCategoryID, "1")
	q:(finish = "0") "0"
	
	s docID = eprCategoryID
	if (printType = "Multiple"){
		s rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportList")
 		s sc = rset.Execute(AEpisodeID, docID)
		While (rset.Next()){
	 		s TemplateDocID = rset.Data("TemplateDocID")
	 		s TemplateID = rset.Data("TemplateID")
	 		s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(AUserID, AEpisodeID, APatientID, ACTLocID, TemplateID, ASSGroupID, "", rset.Data("LogDocID"), rset.Data("EPRNum"))
			s canViewOneDoc = arr.GetAt("canView")
			s canPrintOneDoc = arr.GetAt("canPrint")

			if (canViewOneDoc = 0){
				s canView = 0
				q			
			}
			else{
				s canView = 1	
			}
			if (canPrintOneDoc = 0){
				s canPrint = 0
				q			
			}
			else{
				s canPrint = 1	
			}
		}
	}

	else{	
		//检查权限脚本，是否有浏览和打印的权限
		for {
			s rowID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", " "_eprCategoryID, rowID))
			q:(rowID = "")
		
			s objEPRTemplate = ##Class(EPRmeta.EPRTemplate).%OpenId(rowID)
			s bindTemplateCategoryID = objEPRTemplate.BindTemplateCategoryID	
			s bindTemplateID = objEPRTemplate.BindTemplateID
			s EPRNum = ##class(EPRservice.BOEPRLogs).GetSingleEPRNumByDocType(docID)
			s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(AUserID, AEpisodeID, APatientID, ACTLocID, bindTemplateID, ASSGroupID, bindTemplateCategoryID, docID, EPRNum)	
			s canViewOneDoc = arr.GetAt("canView")
			s canPrintOneDoc = arr.GetAt("canPrint")

			if (canViewOneDoc = 0){
				s canView = 0
				q			
			}
			else{
				s canView = 1	
			}
			if (canPrintOneDoc = 0){
				s canPrint = 0
				q			
			}
			else{
				s canPrint = 1	
			}
		}
	}
	q:(canView = 0) "0"
	q:(canPrint = 0) "0"
	q "1"
}

}
