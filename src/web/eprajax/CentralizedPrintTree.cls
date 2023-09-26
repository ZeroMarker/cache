Class web.eprajax.CentralizedPrintTree Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s patientID = $Get(%request.Data("PatientID",1),"")

	s parentNodeID = $Get(%request.Data("node",1),"-1")
	s userID = $Get(%request.Data("UserID",1),"-1")
	s action = $Get(%request.Data("Action",1),"")
	s schemeID = $Get(%request.Data("SchemeID",1),"")


	d ..GetJson(parentNodeID, episodeID, userID)
	
	Quit $$$OK
}

/// Desc:	根据节点类型，获取相应json字串，（不存在默认方案时）
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
/// Output: 所有范围的树Json
ClassMethod GetJson(parentNodeID As %String, episodeID As %String, userID As %String)
{
	s type = $E(parentNodeID,1,2)
	
	w "["
	
	if type = "RT"
	{	d ..GetCategoryJson(episodeID)}
	elseif type = "CG"
	{	
		d ..GetCategoryDetailJson(parentNodeID, episodeID, userID)
	}
	
	w "]"
}

/// Desc:	获取树根节点下第一层目录
/// Input：	episodeID - 就诊号
/// Output: Json
/// Debug:	d ##Class(web.eprajax.CentralizedPrintTree).GetCategoryJson("201764", "CG07^CG01^CG02","true")
ClassMethod GetCategoryJson(episodeID As %String)
{
	s initOK = ##Class(EPRservice.BLL.BLCentralizedPrintInit).CentralizedPrintInit()
	s rowID = ""
	s sequence = 0
	s total = 10
		
	for i=1:1:total
	{	
		s sequence = i
		
		for {
			s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxSequence", sequence, rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)
			s id = "CG"_objItem.CategoryID
			s desc = objItem.CategoryDesc			
			
			if (i>1) w ","
			w "{"
			w "id:'"_id_"'"
			w ",text:'"_desc_"'"
			w ",cls:'folder'"
			w ",checked:false"
			w "}"
		}
	}
}

/// Desc:	获取树根节点下第二层目录
/// Input：	parentNodeID - 父节点ID
/// 		episodeID - 就诊号
/// 		userID - 用户ID
/// Output: Json
ClassMethod GetCategoryDetailJson(parentNodeID As %String, episodeID As %String, userID As %String)
{
	s cgID = $E(parentNodeID,3,$L(parentNodeID))

	//病历文书
	if parentNodeID = "CG07"
	{
		d ..GetEPRDetailJson(parentNodeID, episodeID, userID)
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
	s rowID = ""
	s info = ""
	for {
		s rowID = $O(^DHCEPRM.CentralizedPrintItemI("IdxCategoryID", " "_cgID, rowID))
		q:(rowID = "")
			
		s objItem = ##Class(EPRmeta.CentralizedPrint.CentralizedPrintItem).%OpenId(rowID)
		s id = objItem.CategoryID
		s desc = objItem.CategoryDesc
		s info = id_"^"_desc_"^true"
		q
	}
	q info
}

/// Desc:	获取树病历文书
/// Input：	parentNodeID - 父节点ID,"CG07"
/// 		episodeID - 就诊号
/// 		userID - 用户ID
/// Output: 病历文书Json
ClassMethod GetEPRDetailJson(parentNodeID As %String, episodeID As %String, userID As %String) As %String
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
			
			s count = count + 1
			s ccDesc = ..GetEPRTemplateCategoryDesc(ccID)
			s desc = cgDesc_"."_ccDesc
			s allID = "CD#"_cgID_"#"_ccID

			if (count > 1) w ","
			w "{"
			w "id:'"_allID_"'"
			w ",text:'"_desc_"'"
			w ",leaf:'true'"
			w ",cls:'folder'"
			w ",checked:false"
			w ",icon:'../scripts/epr/ExtJS/resources/images/default/tree/folder.gif'"
			w "}"
		}
	}
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

}
