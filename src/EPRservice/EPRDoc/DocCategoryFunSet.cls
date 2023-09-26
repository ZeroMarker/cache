/// 名称: 新框架病历结构的控制函数集
/// 描述: 存放新框架病历结构的控制方法
/// 编写者：chenwenjun
/// 编写日期: 09/08/19
Class EPRservice.EPRDoc.DocCategoryFunSet Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator: 陈文俊
/// CreatDate: 2009-08-19
/// Description：判断指定打印模板Doc下的界面模板为唯一模板还是可重复模板
/// Table:
/// Input: prtDocID--绑定打印模板的DocID
/// Output:
/// Return: Single--唯一 Multiple--可重复
ClassMethod GetPrtDocType(prtDocID As %String) As %String
{
	q:(($d(prtDocID) = 0) || (prtDocID = "")) ""
	s result = ""
	
	//根据打印模板Doc取出其下的第一个绑定界面模板，并取出其类型
	s curTemplateDocID = $o(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID"," "_prtDocID,""))
	q:(curTemplateDocID = "") ""
	
	s objTemplateDoc = ##class(EPRmeta.EPRTemplate).%OpenId(curTemplateDocID)
	q:(objTemplateDoc = "") ""
	s bindTemplateID = objTemplateDoc.BindTemplateID
	d objTemplateDoc.%Close()
	k objTemplateDoc
	
	s objTemplate = ##class(EPRmeta.Template).%OpenId(bindTemplateID)
	q:(objTemplate = "") ""
	s chartItemType = objTemplate.ChartItemType
	d objTemplate.%Close()
	k objTemplate
	
	q chartItemType
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-19
/// Description：判断指定分类(Chapter)Doc下的界面模板为唯一模板还是可重复模板
/// Table:
/// Input: chapterDocID--分类(Chapter)DocID
/// Output:
/// Return: Single--唯一 Multiple--可重复
ClassMethod GetChapterDocType(chapterDocID As %String) As %String
{
	q:(($d(chapterDocID) = 0) || (chapterDocID = "")) ""
	s result = ""
	
	//根据分类(Chapter)Doc取出其下的第一个打印模板Doc，并取出其类型
	s curPrtDocID = ""
	s curPrtDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_chapterDocID, curPrtDocID))
	q:(curPrtDocID = "") "" 
	
	q ..GetPrtDocType(curPrtDocID)
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-17
/// Description：根根指定的打印模板DocID取出同一"目录"下所有的打印模板DocID
/// Table:
/// Input: prtDocID--打印模板DocID
/// Output:
/// Return: 打印模板DocID(多个打印模板DocID组成的串 DocID1^DocID2^DocID3)
ClassMethod GetPrtDocIDInCategory(prtDocID As %String) As %String
{
	 q:(($d(prtDocID)=0) || (prtDocID = "")) ""

	 //取出分类DocID
	 s objPrtTemplate = ##class(EPRmeta.EPRTemplateCategory).%OpenId(prtDocID)
	 q:(objPrtTemplate = "") ""
	 s assortDocID = objPrtTemplate.ParentCategoryID
	 d objPrtTemplate.%Close()
	 s objPrtTemplate = ""
	 q:(assortDocID = "") ""
	 
	 //取出目录DocID
	 s objAssort = ##class(EPRmeta.EPRTemplateCategory).%OpenId(assortDocID)
	 q:(objAssort = "") ""
	 s categoryDocID = objAssort.ParentCategoryID
	 d objAssort.%Close()
	 s objAssort = ""
	 q:(categoryDocID = "") ""

	 //根据目录取出其下的所有打印模板DocID
	 s isFirstDocID = "Y"
	 s resultPrtDocIDs = ""
	 s curAssortDocID = ""
	 s curAssortDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_categoryDocID, curAssortDocID))
	 while (curAssortDocID '= "")	//分类
	 {
		s curPrtDocID = ""
		s curPrtDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curAssortDocID, curPrtDocID))
		while (curPrtDocID '= "")	//打印模板
		{
			if (isFirstDocID = "N"){s resultPrtDocIDs = resultPrtDocIDs_"^"}
			s resultPrtDocIDs = resultPrtDocIDs_curPrtDocID
			s isFirstDocID = "N"
		
			s curPrtDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_curAssortDocID, curPrtDocID))
		}
		
		s curAssortDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_categoryDocID, curAssortDocID))
	 }
     
     q resultPrtDocIDs
}

/// Creator: 陈文俊
/// CreatDate: 2009-08-17
/// Description：根根指定的打印模板DocID取出同一"分类"下所有的打印模板DocID
/// Table:
/// Input: prtDocID--打印模板DocID
/// Output:
/// Return: 打印模板DocID(多个打印模板DocID组成的串 DocID1^DocID2^DocID3)
ClassMethod GetPrtDocIDInAssort(prtDocID As %String) As %String
{
	 q:(($d(prtDocID)=0) || (prtDocID = "")) ""
	 
	 //取出分类DocID
	 s objPrtTemplate = ##class(EPRmeta.EPRTemplateCategory).%OpenId(prtDocID)
	 q:(objPrtTemplate = "") ""
	 s assortDocID = objPrtTemplate.ParentCategoryID
	 d objPrtTemplate.%Close()
	 s objPrtTemplate = ""
	 q:(assortDocID = "") ""
	 
	 //根据分类取出其下的所有打印模板DocID
	 s isFirstDocID = "Y"
	 s resultPrtDocIDs = ""
	 s curPrtDocID = ""
	 s curPrtDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_assortDocID, curPrtDocID))
	 while (curPrtDocID '= "")	//打印模板
	 {
		if (isFirstDocID = "N"){s resultPrtDocIDs = resultPrtDocIDs_"^"}
		s resultPrtDocIDs = resultPrtDocIDs_curPrtDocID
		s isFirstDocID = "N"
	
		s curPrtDocID = $o(^DHCEPRM.EPRTemplateCategoryI("IdxParentCategoryID", " "_assortDocID, curPrtDocID))
	 }
		
     q resultPrtDocIDs
}

/// 名称: 返回病人所在科室的所有病人类型
/// 描述: 供切换病人类型的备选项使用
/// 编写者：chenwenjun
/// 返回值：json的数组格式
/// 编写日期: 09/08/12
ClassMethod GetPatientTypeList(episodeID As %String) As %String
{
	//先判断是否有指定的科室，如果有则用指定科室，如没有则用病人当前科室
	/* 
	s curPatDeptID = ""
	s curPatDeptID = ##class(EPRservice.DocRestLogic.PrivLogic).GetAppointDept(episodeID)
	if (curPatDeptID = "")
	{
		s curDeptNote = ##class(EPRservice.HISInterface.PatientInfoAssist).CurrentDept(episodeID)
		s curPatDeptID = $p(curDeptNote,"^",1)
	}
	*/
	// +<modified on 2009-12-18 by houj, sugguested by chenwj>
	s curPatDept = ##class(EPRservice.DocRestLogic.PatientInfoAssist).GetDept(episodeID)
	s curPatDeptID = $P(curPatDept,"^",1)
	
	//取出对应科室的病人类型
	s result = ##class(%ResultSet).%New()
	//wangwentao update 20100609
	s Hospital=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName")
	s EpisodeNo=##Class(EPRservice.HISInterface.PatientInfoAssist).GetEpisodeNo(episodeID)
	if ($f(EpisodeNo,"OP")'=0)||($f(EpisodeNo,"EP")'=0)
	{
		//s sql = "select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID=? union select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID=? "	
		s sql = "select CtmDictCode, CtmDictDesc from EPRview.PatType where CtmDictID=? union select CtmDictCode, CtmDictDesc from EPRview.PatType where CtmDictID [ '^'||?||'^' "	
		d result.Prepare(sql)
		d result.Execute("OP",curPatDeptID)
	}
	else
	{
		//20110825 wangwentao update
		//s sql = "select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID=?  union select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID= 'ALL' "
		//s sql = "select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID [ '^'||?||'^'  union select CtmDictCode, CtmDictDesc from SQLUser.DHCEPRVPatType where CtmDictID= 'ALL' "
		//20110825 wangwentao update end 
		s sql = "select CtmDictCode, CtmDictDesc from EPRview.PatType where CtmDictID [ '^'||?||'^'  union select CtmDictCode, CtmDictDesc from EPRview.PatType where CtmDictID= 'ALL' "
		d result.Prepare(sql)
		d result.Execute(curPatDeptID)
	}


	//取当前指定的病人类型
	s sltPatTypeCode = ""
	&SQL(select PatType into :sltPatTypeCode from EPRinstance.AdmPatType where EpisodeID=:episodeID)
	
	s resultStr = ""
	s resultStr = resultStr_"["
	s isExist = 0
	s isFirst = "Y"
	WHILE (result.Next()) 
	{
		s patTypeCode = result.Data("CtmDictCode")
	 	s patTypeDesc = result.Data("CtmDictDesc")
		i $f(patTypeDesc,"-") { s patTypeDesc = $p(patTypeDesc,"-",2) }  //+<added on 2009-12-04 by wangwt>

	 	s isCurExist = 0
	 	if ((sltPatTypeCode '= "") && (sltPatTypeCode = patTypeCode))
	 	{
			s isExist = 1
			s isCurExist = 1
		}

		if (isFirst = "N"){s resultStr = resultStr_","}
		s resultStr = resultStr_"['"_patTypeCode_"', '"_patTypeDesc_"', '"_isCurExist_"']"
		s isFirst = "N"
	}
	d result.Close()
	
	s resultStr = resultStr_"]"
	
	//如果当前下拉列表中不包含之前选中的病人类型，则说明该病人可能是转科了，所以需要把之前为该病人选择的病人类型清空
	if ((sltPatTypeCode '= "") && (isExist = 0))
	{
		&SQL(delete from EPRinstance.AdmPatType where EpisodeID=:episodeID)
	}
	
	Quit resultStr
}

/// Creator: 陈文俊
/// CreatDate: 2009-09-01
/// Description：转换字符串
/// Table:
/// Input: 
/// Output:
/// Return: 
ClassMethod TransResultStr(sourceStr As %String) As %String
{
	q:(($d(sourceStr) = 0) || (sourceStr = "")) ""
	s result = sourceStr
	
	s result = $tr(result,"'","‘")
	q result
}

}
