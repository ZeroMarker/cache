Class web.eprajax.onestepprint Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	q:(episodeID="") $$$OK
	
	s patientID = $Get(%request.Data("PatientID",1),"")
	q:(patientID="") $$$OK
	
	s parentNodeID = $Get(%request.Data("node",1),"-1")
	
	s userID = $Get(%request.Data("UserID",1),"-1")
	s ctLocID = $Get(%request.Data("CTLocID",1),"-1")
	s ssGroupID = $Get(%request.Data("SSGroupID",1),"-1")
	s EKGTypeEnabled = $Get(%request.Data("EKGTypeEnabled",1),"")
	//s ^CacheTemp("debug","11111") = EKGTypeEnabled
	
	s action = $Get(%request.Data("Action",1),"")
	s categoryID = $Get(%request.Data("CategoryID",1),"") 
	s categoryDetail = $Get(%request.Data("CategoryDetail",1),"")
	s patName = $Get(%request.Data("PatName",1),"")
	
	if (action = "addprintrecord")
	{
		d ..AddPrintRecord(categoryID,categoryDetail,episodeID,patientID,userID,ctLocID,patName)
	}
	else
	{
		d ..GetJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID,EKGTypeEnabled)
	}
	Quit $$$OK
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
/// 			CG10	电生理（愿心电图）
/// 			CG51	护理病历(检验)
ClassMethod GetJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID, EKGTypeEnabled)
{
	//s ^CaheTempDHCEPRDebug("web.eprajax.onestepprint","input") = parentNodeID_"^"_episodeID
	s type = $E(parentNodeID,1,2)
	
	w "["
	
	if type = "RT"
	{	d ..GetCategoryJson(episodeID,EKGTypeEnabled)}
	elseif type = "CG"
	{	
		d ..GetCategoryDetailJson( parentNodeID, episodeID, userID, ctLocID, ssGroupID,EKGTypeEnabled)
	}
	
	w "]"
}

/// Desc:	获取打印文档类型信息
/// Input：	episodeID  就诊rowid
/// Output: json
/// Return: 无	
/// Others:
ClassMethod GetCategoryJson(episodeID, EKGTypeEnabled)
{
	s str="7^71^8^10^1^2^9^6^51^3^4^23"
	s count = $l(str,"^")
	for i = 1:1:count
	{
		s cgID = $p(str,"^",i)
		s info = ..GetCGInfo(cgID)
		s id = $P(info,"^",1)
		s desc = $P(info,"^",2)
		s isLeaf = $P(info,"^",3)
		s isLeaf = "False"
		
		continue:((EKGTypeEnabled = "") && ($p(str,"^",i) = 10))
		if (i>1) w ","
		w "{"
		w "id:'CG"_id_"'"
		w ",text:'"_desc_"'"
		//w ",leaf:'"_isLeaf_"'"
		w ",cls:'folder'"
		w ",checked:false"
		w "}"
	}
}

/// Desc:	获取指定打印文档ID的打印文档类型信息
/// Input：	cgID：打印文档类型ID
/// Output: json
/// Return: 无
ClassMethod GetCGInfo(cgID As %String) As %String
{
	q:(cgID = "1")||(cgID = "01") "01^检查报告^false"    
	q:(cgID = "2")||(cgID = "02") "02^检验报告^false"
	q:(cgID = "3")||(cgID = "03") "03^医嘱单^false"
	q:(cgID = "4")||(cgID = "04") "04^体温单^false"
	q:(cgID = "5")||(cgID = "05") "05^住院证^false"
	q:(cgID = "6")||(cgID = "06") "06^护理病历^false"
	q:(cgID = "7")||(cgID = "07") "07^病历文书^false"
	q:(cgID = "71")||(cgID = "71") "71^病历文书新版^false"
	q:(cgID = "8")||(cgID = "08") "08^麻醉记录^false"
	q:(cgID = "9")||(cgID = "09") "09^病理^false"
	q:(cgID = "10")||(cgID = "10") "10^电生理^false"
	q:(cgID = "51")||(cgID = "51") "51^护理病历(检验)^false"
	q:(cgID = "23")||(cgID = "23") "23^输血单^false"
}

ClassMethod GetCategoryDetailJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID, EKGTypeEnabled)
{
	s cgID = $E(parentNodeID,3,$L(parentNodeID))

	//病历文书
	if (parentNodeID = "CG07")
	{
		d ..GetEPRDetailJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID)
	}
	elseif (parentNodeID = "CG71")
	{
		d ..GetEMRDetailJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID)
	}
	//电生理
	elseif (parentNodeID = "CG10")
	{
		d ..GetEKGDetailJson(episodeID,EKGTypeEnabled)
	}
	else
	{
		s info = ..GetCGDetailInfo(cgID)
		s id = $P(info,"^",1)
		s desc = $P(info,"^",2)
		s isLeaf = "true"
		s allID = "CD"_cgID_id
			
		w "{"
		w "id:'"_allID_"'"
		w ",text:'"_desc_"'"
		w ",leaf:'true'"
		w ",cls:'folder'"
		w ",checked:false"
		w ",detailInfo:'"_desc_"'"
		w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
		w "}"
	}
}

/// Desc:	获取指定打印文档ID的打印文档类型信息
/// Input：	cgID：打印文档类型ID
/// Output: json
/// Return: 无
ClassMethod GetCGDetailInfo(cgID As %String) As %String
{
	q:(cgID = "1")||(cgID = "01") "01^检查报告^true"    
	q:(cgID = "2")||(cgID = "02") "02^检验报告^true"
	q:(cgID = "3")||(cgID = "03") "03^医嘱单^true"
	q:(cgID = "4")||(cgID = "04") "04^体温单^true"
	q:(cgID = "5")||(cgID = "05") "05^住院证^true"
	q:(cgID = "6")||(cgID = "06") "06^护理病历^true"
	q:(cgID = "7")||(cgID = "07") "07^病历文书^true"
	q:(cgID = "71")||(cgID = "71") "61^病历文书新版^true"
	q:(cgID = "8")||(cgID = "08") "08^麻醉记录^true"
	q:(cgID = "9")||(cgID = "09") "09^病理^true"
	q:(cgID = "10")||(cgID = "10") "10^电生理^true"
	q:(cgID = "51")||(cgID = "51") "51^护理病历(检验)^true"
	q:(cgID = "23")||(cgID = "23") "23^输血单^true"
}

/// 	Desc:	获取电子病历打印文档详细信息
/// 	Input:	episodeID: 就诊rowid
/// 	Output：json
/// 	Return:	无
/// Debug:	d ##Class(web.eprajax.onestepprint).GetEPRDetailJson("CG07", "201764", "16")
ClassMethod GetEPRDetailJson(parentNodeID As %String, episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	
	s count = 0
	s cgID = ""
	for {
		s cgID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " 0", cgID))
		q:(cgID = "")
		
		s cgDesc = ..GetEPRTemplateCategoryDesc(cgID)
		
		s ccID = ""
		for {
			s ccID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_cgID, ccID))
			q:(ccID = "")
			
			s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
			
			
			s prtID = ""
			for {
				s prtID = $O(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_ccID, prtID))
				q:(prtID = "")
				
				//是否需要打印
				continue:(..NeedPrint(episodeID, prtID) = "0")
				continue:(..CheckCanPrint(userID,ctLocID,ssGroupID,episodeID,patientID,prtID) = "0")
				
				s desc = cgDesc_"."_ccDesc
				s info = ""
				s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(prtID)
				if (objEPRTemplateCategory.CategoryType = "PhotoScan")
				{
					s allID = "PS"_cgID_"#"_ccID_"#"_prtID
					s info = ..GetPhotoScanLocation(prtID, episodeID)
					continue:(info = "")	
				}
				else
				{
					s allID = parentNodeID_prtID
					s info = ..GetDetailInfo(prtID, patientID, episodeID, userID)
				}
				
				s count = count + 1
				if (count > 1) w ","
				
				w "{"
				w "id:'"_allID_"'"
				w ",text:'"_desc_"'"
				w ",leaf:'true'"
				w ",cls:'folder'"
				w ",checked:false"
				w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
				w ",detailInfo:'"_info_"'"
				w "}"
			}
		}
	}
}

ClassMethod GetEMRDetailJson(parentNodeID As %String, episodeID As %String, userID As %String, ctLocID As %String, ssGroupID As %String) As %String
{
	s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(episodeID)
	d ##Class(EMRservice.HISInterface.CentralizedPrint).GetEMRDetailJson(parentNodeID,episodeID,patientID,userID,ctLocID,ssGroupID)
}

ClassMethod GetEKGDetailJson(episodeID, EKGTypeEnabled)
{
	s count = 0
	//以"^"开头，所以从2开始记数
	for index=2:1:$l(EKGTypeEnabled,"!")
	{
		s count = count + 1
		if (count > 1) w ","
		w "{"
		w "id:'CD10"_index_"'"
		w ",text:'"_$p($p(EKGTypeEnabled,"!",index),":",2)_"'"
		w ",leaf:'true'"
		w ",cls:'folder'"
		w ",checked:false"
		w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
		w ",detailInfo:'"_$p($p(EKGTypeEnabled,"!",index),":",1)_"'"
		w "}"	
	}
}

ClassMethod NeedPrint(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
				
	q:(objEPRTemplateCategory = "") "0"
	if (objEPRTemplateCategory.CategoryType = "PhotoScan")
	{
		q "1"	
	}
	q:(objEPRTemplateCategory.CategoryType '= "PrtTemplate") "0"
	q:(..IsSaved(AEpisodeID, APrintTemplateDocID) = "0") "0"
	q "1"
}

ClassMethod IsSaved(AEpisodeID As %String, APrintTemplateDocID As %String) As %String
{
	s eprLogsID = ""
	&sql(select top 1 ID into :eprLogsID from EPRinstance.EPRLogs 
		where EpisodeID = :AEpisodeID and EPRDocID = :APrintTemplateDocID)
	
	q:(eprLogsID = "")||(eprLogsID = $c(0)) "0"
	q "1"
}

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

ClassMethod AddPrintRecord(ACategoryID As %String, ACategoryDetail As %String, AEpisodeID As %String, APatientID As %String, AUserID As %String, ACTLocID As %String, APatName As %String)
{
	for i=1:1:$l(ACategoryDetail,"!")
	{
		//打印记录
		s obj = ##class(EPRinstance.OneStepPrintRecord).%New()
		q:(obj="")
		
		s obj.EpisodeID = AEpisodeID
		s obj.CategoryID = ACategoryID
		s obj.PatientID = APatientID
		s obj.PatientName = APatName
		s obj.UserID = AUserID
		s obj.UserCTLocID = ACTLocID
		s obj.FinishDate = $p($H,",",1)
		s obj.FinishTime = $p($H,",",2)
		
		if (ACategoryID = "CG07")
		{
			//printType_"^"_APatientID_"^"_AEpisodeID_"^"_AUserID_"^"_printTemplateID_"^"_APrintTemplateDocID_"^"_instanceDataIDs
			s obj.PrintDocID = $p($p(ACategoryDetail,"!",i),"^",6)
		}
		//三版病历打印，也需要和二版一样，一个模板对应一条打印记录 add by niucaicai 2017-03-09
		elseif (ACategoryID = "CG71")
		{
			s obj.PrintDocID = $p(ACategoryDetail,"!",i)
		}
		else
		{
			s obj.PrintDocID = ACategoryDetail
		}
	
		s sc = obj.%Save()
		
		d obj.%Close()
		continue:($$$ISOK(sc))
		q 
	}
}

/// d ##class(web.eprajax.onestepprint).Test()
ClassMethod Test()
{
	s input = $g(^CaheTempDHCEPRDebug("web.eprajax.onestepprint","input"))
	s episodeID = $p(input,"^",2)
	s userID = $p(input,"^",3)
	s ctLocID = $p(input,"^",4)
	s ssGroupID = $p(input,"^",5)
	s parentNodeID = "RT0"
	s EKG = $p(input,"^",6)
	d ..GetJson(parentNodeID, episodeID, userID, ctLocID, ssGroupID,EKG)
}

}
