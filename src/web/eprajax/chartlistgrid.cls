Class web.eprajax.chartlistgrid Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $Get(%request.Data("EpisodeID",1),"-1")
	q:(episodeID = -1) $$$OK

	set patientID = ($Get(%request.Data("PatientID",1),"-1"))
	
	set prtDocID = $Get(%request.Data("ProfileID",1),"-1") //选中界面模板所属的打印模板的DocID
	set templateDocID = $Get(%request.Data("TemplateDocID",1),"")
	set categoryID = $Get(%request.Data("CategoryID",1),"-1")
	
	set isShowAll = $Get(%request.Data("IsShowAll",1),"Y")
	set isShowSubsequent = $Get(%request.Data("IsShowSubsequent",1),"Y")
	
	set userid = %session.Get("LOGON.USERID")
	set ctlocid = %session.Get("LOGON.CTLOCID")
	set ssgroupid = %session.Get("LOGON.GROUPID")
	
	//当前页
	set currentPage = $Get(%request.Data("CurrentPage",1),1)
	//q:(currentPage < 1)
	
	s defaultPageSize = ##class(EPRmeta.SysOption).GetOptionValueByName("CenterTabListPageSize")
	if (defaultPageSize = "") s defaultPageSize = 25
	
	//每页显示记录数
	set pageSize = $Get(%request.Data("PageSize",1),defaultPageSize)
	//q:(pageSize < 1) 
	
	set lastPage = $Get(%request.Data("LastPage",1),"true")
	
	//debug
	/*
	if (episodeID '= "1")
	{
		s ^CacheTempDHCEPRDebug("web.eprajax.chartlistgrid","input") = episodeID_"^"_patientID_"^"_prtDocID_"^"_templateDocID_"^"_categoryID_"^"_isShowAll_"^"_userid_"^"_ctlocid_"^"_ssgroupid_"^"_currentPage_"^"_pageSize_"^"_lastPage_"^"_isShowSubsequent
	}
	*/
	
	do ..GetChartList(episodeID, patientID, prtDocID, templateDocID, categoryID, isShowAll, userid, ctlocid, ssgroupid,currentPage,pageSize,lastPage,isShowSubsequent)
	
	q $$$OK
}

/// modify by Candyxu 2013-1-23  增加对可重复模板新增的控制（用于协和管理非计划手术记录）
ClassMethod GetChartList(episodeID As %String, patientID As %String, prtDocID As %String, templateDocID As %String, categoryID As %String, isShowAll As %String, userid As %String, ctlocid As %String, ssgroupid As %String, currentPage As %Integer, pageSize As %Integer, lastPage As %String, isShowSubsequent As %String) As %Status
{
	s prtDocID = $e(prtDocID, 3, $l(prtDocID))
	s arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, episodeID, patientID, ctlocid, "", ssgroupid, "", prtDocID, "")
	s canNew = arr.GetAt("canNew")
	s:($g(canNew) = "") canNew = "1"
	s isCAOn = ##Class(CA.DigitalSignatureService).GetCAServiceStatus(ctlocid) 
	w "<table name='tablelist' id='tablelist' width='100%' border='0' cellpadding='1' cellspacing='1' class='tableStyle01'>"
	w "<tr>"
	w "<td nowrap align='center' class='TDstyle02'>"_"<input id='chkTitle' type='checkbox' onClick='chkChange()'"_" canNew='"_canNew_"'>"_"</td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>标题</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>备注</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>发生日期</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>发生时间</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>创建者</a></font></td>"	
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>起始页行</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>结束页行</a></font></td>"
	w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>当前状态</a></font></td>"
	if (isCAOn="1")
	{
		w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>签名者</a></font></td>"	
		w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>提交签名</a></font></td>"	
		w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>主治签名</a></font></td>"	
		w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>主任签名</a></font></td>"	
	
	}
	//在可重复病历列表中增加[医政组临床报告]信息列 --- add by zhuj on 2010-2-26	begin	增加列
	s printTemplateDocID = prtDocID
	s eprCategoryID = ##class(EPRservice.Privilege.BOPrivAssist).EPRCategoryID(printTemplateDocID)
	s WMRReportCategory = ##class(EPRmeta.SysOption).GetOptionValueByName("WMRReportCategory")
	if (WMRReportCategory = eprCategoryID)
	{
		s titles = ##class(web.DHCMedClinicalReport.ReportInterface).GetTHCellsString("1")
		s titlesLength = $l(titles, "^")
		for i = 1:1:titlesLength
		{
			s titleTmp = $p(titles, "^", i)
			w "<td width='' align='center' nowrap class='TDstyle02'><font color='#004E82'><a>"_titleTmp_"</a></font></td>"
		}
	}
	//end
	
	w "</tr>"
	
	//获取真正的PrintDocID	
	if (isShowAll = "N")
	{
		set allPrtDocID = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPrtDocIDInAssort(prtDocID)
	}
	else
	{
		set allPrtDocID = ##class(EPRservice.EPRDoc.DocCategoryFunSet).GetPrtDocIDInCategory(prtDocID)
	}
	
	//分页参数 --add by yang 2012-3-27
	//获取总记录数
	if (isShowSubsequent = "Y")
	{
		set totalRowsCount = ##class(web.DHCEPRExt).GetTotalLogCount2(episodeID,allPrtDocID)
	}
	else
	{
		set totalRowsCount = ##class(web.DHCEPRExt).GetTotalLogCount(episodeID,allPrtDocID)
	}
	
	set rowRangeInfo = ..GetRowRange(lastPage, totalRowsCount, pageSize, currentPage)
	set startRow = $p(rowRangeInfo, "^", 1)
	set endRow = $p(rowRangeInfo, "^", 2)
	set currentPage = $p(rowRangeInfo, "^", 3)
	
	//隐藏框用来记录总记录数，前端读取
	w "<input name='totalRowsCount' id='totalRowsCount' type='hidden' value="_totalRowsCount_" / >"
	w "<input name='currentPageNum' id='currentPageNum' type='hidden' value="_currentPage_" / >"
	
	///输出最后的</tabel>签
	if (totalRowsCount=0)
	{
		w "</table>"
		q $$$OK
	}
	s idx = -1
	if (isShowSubsequent = "Y")
	{
		Set rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportListPage2")
	}
	else
	{
		Set rset = ##class(%ResultSet).%New("web.DHCEPRExt:MultipleReportListPaging")
	}
	
	Set sc = rset.Execute(episodeID, allPrtDocID,startRow,endRow)
 	While (rset.Next()){
	 	s idx = idx + 1
	 	set curTemplateDocID = rset.Data("TemplateDocID")
	 	set curTemplateID = rset.Data("TemplateID")
	 	
	 	set arr = ##class(web.eprajax.ajaxGetPower).GetPowerArray(userid, episodeID, patientID, ctlocid, curTemplateID, ssgroupid, "", rset.Data("LogDocID"), rset.Data("EPRNum"))
		
	 	set needPrint = ""
	 	if (rset.Data("NeedPrint") = 1){set needPrint = "checked"} 
	 	
	 	//set title = $g(rset.Data("Title"))
	 	set title = ..GetTitle(episodeID, rset.Data("TemplateID"), rset.Data("ID"), $g(rset.Data("Title")))
	 	set title = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(title)
	 	
	 	set remark = $g(rset.Data("Remark"))
	 	set remark = ##Class(EPRservice.Util.StringHelper).FilterSpecialChar(remark)
	 	
	 	
	 	set chkPrintProperty = "instanceid='"_rset.Data("ID")_"' statusCode='"_rset.Data("EPRStatus")_"'"
	 	set chkPrintProperty = chkPrintProperty_" EPRNum='"_rset.Data("EPRNum")_"' logDocID='"_rset.Data("LogDocID")_"'"
	 	set chkPrintProperty = chkPrintProperty_" canView='"_arr.GetAt("canView")_"' canSave='"_arr.GetAt("canSave")_"'"
	 	set chkPrintProperty = chkPrintProperty_" canPrint='"_arr.GetAt("canPrint")_"' canCommit='"_arr.GetAt("canCommit")_"'"
	 	set chkPrintProperty = chkPrintProperty_" canSwitch='"_arr.GetAt("canSwitch")_"' canChiefCheck='"_arr.GetAt("canChiefCheck")_"'"
	 	set chkPrintProperty = chkPrintProperty_" canAttendingCheck='"_arr.GetAt("canAttendingCheck")_"' canExport='"_arr.GetAt("canExport")_"'"
	 	
	 	set onClickHandler = $C(34)_"OpenRecordClickHandler('"_rset.Data("EpisodeID")_"', '"_categoryID_"'"
	 	set onClickHandler = onClickHandler_", '"_prtDocID_"', '"_rset.Data("ID")_"'"
	 	set onClickHandler = onClickHandler_", '"_rset.Data("EPRNum")_"', 'ML"_rset.Data("LogDocID")_"'"
	 	set onClickHandler = onClickHandler_", '"_patientID_"', '"_rset.Data("LogRowID")_"'"
	 	set onClickHandler = onClickHandler_", '"_curTemplateDocID_"', '"_rset.Data("LogDocID")_"'"
	 	set onClickHandler = onClickHandler_", '"_title_"', '"_$zd(rset.Data("HappenDate"),3)_"')"_$C(34)
	 	
		w "<tr id='valueTr' episodeid='"_rset.Data("EpisodeID")_"' instanceid='"_rset.Data("ID")_"' onDblClick='dbChoTr(this)'; onMouseDown='choTr(this,0);'>"
		w "<td nowrap align='center' class='TDstyle01'>"_"<input id='ckbPrint' onClick='chkListChange()' "_chkPrintProperty_" type='checkbox' "_needPrint_">"_"</td>"
		w "<td nowrap align='center' class='TDstyle01'><a href='#' onclick="_onClickHandler_">"_title_"</a></td>"
		w "<td nowrap align='center' class='TDstyle01'>"_remark_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_$ZD(rset.Data("HappenDate"),3)_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_$ZT(rset.Data("HappenTime"))_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_rset.Data("CreateUser")_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_rset.Data("StartPageRow")_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_rset.Data("EndPageRow")_"</td>"
		w "<td nowrap align='center' class='TDstyle01'>"_rset.Data("EPRStatusName")_"</td>"
		
		if (isCAOn="1")
		{
			s eprNum=rset.Data("EPRNum")
			s Signer = ##Class(EPRservice.BLDigitalSignature).GetLastValidSigner(rset.Data("EpisodeID"), prtDocID, eprNum)
			
			s commitSigner = "", attendingSigner = "", chiefSigner = ""
			if (Signer '= "")
			{
				s commitSigner    = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(rset.Data("EpisodeID"), prtDocID, eprNum,"commit")
  				s attendingSigner = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(rset.Data("EpisodeID"), prtDocID, eprNum,"attendingCheck")
  				s chiefSigner     = ##Class(EPRservice.BOEPRLogs).GetUserNameByAction(rset.Data("EpisodeID"), prtDocID, eprNum,"chiefCheck")
  			}
			
			s HandSigner = ##Class(EPRservice.BLHandWrittenSign).GetLastValidSign(rset.Data("EpisodeID"), prtDocID, eprNum)
			if (HandSigner '= "")
			{
				s Signer = Signer_"/患者"
			}
			w "<td id='Signer"_idx_"' nowrap align='center' class='TDstyle01'>"_Signer_"</td>"
			
			w "<td nowrap align='center' class='TDstyle01'>"_commitSigner_"</td>"
			w "<td nowrap align='center' class='TDstyle01'>"_attendingSigner_"</td>"
			w "<td nowrap align='center' class='TDstyle01'>"_chiefSigner_"</td>"
		}
		
		//增加[医政组临床报告]信息 --- add by zhuj on 2010-2-26	begin	增加列
		if (WMRReportCategory = eprCategoryID)
		{
			s contents = ##class(web.DHCMedClinicalReport.ReportInterface).GetTDCellsString(rset.Data("ID"))
			s contentsLength = $l(contents, "^")
			for i = 1:1:contentsLength
			{
				s contentTmp = $p(contents, "^", i)
				w "<td nowrap align='center' class='TDstyle01'>"_contentTmp_"</td>"
			}
		}
		//end
				
		w "</tr>"
 	}
 	Do rset.Close()
 
	w "</table>"
	q $$$OK
}

/// Desc:	郑州人民医院需求，在日常病程标题前加医生名
/// w ##Class(web.eprajax.chartlistgrid).GetTitle("2632261","100","5090633||1","mytitle")
ClassMethod GetTitle(aEpisodeID As %String, aTemplateID As %String, aInstanceID As %String, aTitle As %String) As %String
{
	/* 直接写死医院和单元编码
	q:(""=aTitle) aTitle
	if (("ZZRMYY"=##class(EPRmeta.SysOption).GetOptionValueByName("HospitalName"))&&(50=aTemplateID))
	{
		s aItemPara = "#TYPE:Simple#TID:50#TVER:0#SCODE:I0003" 
		s doc=##class(EPRservice.BOScatterData).GetEPRMultipleData(aEpisodeID,aItemPara,aInstanceID)
		if (doc'="") { q doc_" "_aTitle }
	}
	
	q aTitle
	*/
	
	// 为标题指定Scheme，格式如下：
	// {}中的内容在运行时替换为实际值，{TITLE}为保留字，代表可重复病历的原来标题。
	// 比如Scheme:   {#TYPE:Simple#TID:50#TVER:0#SCODE:I0003}{TITLE}
	// 表示: "单元I003的值" 加上 "可重复病历的原来标题" 显示为新标题
	s titleScheme = ..GetCustomTitleScheme(aTemplateID)
	q:(titleScheme="")||(aTitle="") aTitle
	
	s titleContent = ""
	s leftCount = $L(titleScheme,"{")
	for i=1:1:leftCount
	{
		s scheme = $p(titleScheme,"{",i)
		if ($L(scheme,"}")=2)
		{
			//b "s"
			s itemCode = $p(scheme,"}",1)
			s record = ""
			if (itemCode = "TITLE")
			{
				s record = aTitle
			}
			else
			{
				s record= ##class(EPRservice.BOScatterData).GetEPRMultipleData(aEpisodeID, itemCode,aInstanceID)
			}
			s titleContent = titleContent_record_$p(scheme,"}",2)
		}
		else
		{
			s titleContent = titleContent_scheme
		}	
	}
	q titleContent
}

/// w ##Class(web.eprajax.chartlistgrid).GetCustomTitleScheme("100")
ClassMethod GetCustomTitleScheme(ATemplateID As %String) As %String
{
	q:(ATemplateID="") ""
	s schemeID = $O(^DHCEPRM.MultiTitleCustomI("IdxTemplateID"," "_ATemplateID,""))
	q:(schemeID="") ""
	s objTitleScheme = ##Class(EPRmeta.MultiTitleCustom).%OpenId(schemeID)
	q:(objTitleScheme="") ""
	q objTitleScheme.CustomScheme
}

/// Desc:	获取起始行、结束行、当前页信息
ClassMethod GetRowRange(isLastPage, totalRowsCount, pageSize, currentPage) As %String
{
	if (totalRowsCount = 0)
	{
		set startRow = 0
		set endRow = 0
		set currentPage = 0
	}
	else
	{
		if (isLastPage = "true")
		{
			//页的起始和结束
			set pageCount = totalRowsCount \ pageSize
			set pageMod = totalRowsCount # pageSize
			if (pageMod = 0)
			{
				set currentPage = pageCount
				set startRow = totalRowsCount - pageSize + 1
				set endRow = totalRowsCount
			}
			else
			{
				set currentPage = pageCount + 1
				set startRow = pageCount * pageSize + 1
				set endRow = totalRowsCount
			}
		}
		else
		{
			//页的起始和结束
			set startRow = (currentPage - 1) * pageSize + 1
			set endRow = startRow + pageSize - 1
			set currentPage = currentPage
		}
	}
	
	q startRow_"^"_endRow_"^"_currentPage
}

/// Debug:	d ##Class(web.eprajax.chartlistgrid).Test()
ClassMethod Test()
{
	s input = $g(^CacheTempDHCEPRDebug("web.eprajax.chartlistgrid","input"))
	
	s episodeID = $P(input, "^", 1)
	s patientID = $P(input, "^", 2)
	s prtDocID = $P(input, "^", 3)
	s templateDocID = $P(input, "^", 4)
	s categoryID = $P(input, "^", 5)
	s isShowAll = $P(input, "^", 6)
	s userid = $P(input, "^", 7)
	s ctlocid = $P(input, "^", 8)
	s ssgroupid = $P(input, "^", 9)
	s currentPage = +($P(input, "^", 10))
	s pageSize = +($P(input, "^", 11))
	s lastPage = +($P(input, "^", 12))
	s isShowSubsequent = $P(input, "^", 13)
	
	//b
	do ..GetChartList(episodeID, patientID, prtDocID, templateDocID, categoryID, isShowAll, userid, ctlocid, ssgroupid,currentPage,pageSize,lastPage,isShowSubsequent)
}

}
