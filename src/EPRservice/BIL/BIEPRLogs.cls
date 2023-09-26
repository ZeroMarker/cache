Class EPRservice.BIL.BIEPRLogs Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// Desc:	是否已经打印
/// Input:	AEpisodeID 	就诊ID
/// 		AEPRDocID	EPRmeta.EPRTemplateCategory中类型为PrnTemplate的记录ID(即PrintDocID)
/// 		AEPRNum		病历顺序号，唯一病历此值永远是1
ClassMethod HasPrinted(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String) As %Boolean
{
	s hasPrinted = ##class(EPRinstance.EPRLogs).RecHasAction(AEpisodeID,AEPRDocID,AEPRNum,"print")
	q hasPrinted
}

/// Desc:	是否已经提交
/// Input:	AEpisodeID 	就诊ID
/// 		AEPRDocID	EPRmeta.EPRTemplateCategory中类型为PrnTemplate的记录ID(即PrintDocID)
/// 		AEPRNum		病历顺序号，唯一病历此值永远是1
ClassMethod HasCommitted(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String) As %Boolean
{
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,AEPRDocID,AEPRNum)
	q:(eprLogs = "") "0"
	s status = eprLogs.EPRStatus
	q:(status = "unfinished") "0"
	q:(status = "finished") "0"
	q "1"
}

/// Desc:	指定病历是否已经完成
/// Input:	AEpisodeID 	就诊ID
/// 		AEPRDocID	EPRmeta.EPRTemplateCategory中类型为PrnTemplate的记录ID(即PrintDocID)
/// 		AEPRNum		病历顺序号，唯一病历此值永远是1
ClassMethod HasFinished(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String) As %Boolean
{
	q:(AEpisodeID="")||(AEPRDocID="")||(AEPRNum="") "0"
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,AEPRDocID,AEPRNum)
	q:(eprLogs = "") "0"
	s status = eprLogs.EPRStatus
	q:(status = "unfinished") "0"
	q "1"
}

/// Desc:	指定病历是否已经完成
/// Input:	AEpisodeID 	就诊ID
/// 		AEPRDocID	EPRmeta.EPRTemplateCategory中类型为PrnTemplate的记录ID(即PrintDocID)
/// 		AEPRNum		病历顺序号，唯一病历此值永远是1
ClassMethod GetCreateUserID(AEpisodeID As %String, AEPRDocID As %String, AEPRNum As %String) As %Boolean
{
	q:(AEpisodeID="")||(AEPRDocID="")||(AEPRNum="") "0"
	s eprLogs = ##class(EPRinstance.EPRLogs).GetCurrLog(AEpisodeID,AEPRDocID,AEPRNum)
	q:(eprLogs = "") ""
	s createUserID = eprLogs.CreateUserID
	q createUserID
}

/// Desc:	打印模板的DocID配置
/// 		配置的数据供以下方法使用：EPRservice.BIL.BIEPRLogs.GetFirstPagePrintDocID()
/// Input：	APrintDocID : 打印模板DocID
/// 		ADesc : 描述
/// Debug：	w ##Class(EPRservice.BIL.BIEPRLogs).InitFirstPagePrintDocID("21^34","病案首页DocID")
/// Others:	如何确定 APrintDocID参数：
/// 		打开病案首页界面模板，在保存按钮左侧单击右键，在弹出菜单选择查看源文件，
/// 		在源文件中找到下列代码：
/// 		var printTemplateDocId = '34';    其中的 printTemplateDocId 即是。
ClassMethod InitFirstPagePrintDocID(APrintDocID As %String, ADesc As %String) As %String
{
	q:(APrintDocID = "") "PrintDocID不能为空"
	
	
	&sql(select top 1 ID into :mastID from EPRmeta.CustomDictionary where CtmDictType = 'PrintDocType' and CtmDictName= 'FPDocID' and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		&sql(update EPRmeta.CustomDictionary set CtmDictID = :APrintDocID, CtmDictDesc = :ADesc where ID = :mastID) 
	}	
	else
	{
		&sql(insert into EPRmeta.CustomDictionary (CtmDictType, CtmDictStatus, CtmDictName, CtmDictID, CtmDictDesc) values ('PrintDocType', 'Y', 'FPDocID', :APrintDocID, :ADesc))
	}
	
	q SQLCODE
}

/// Desc:	获取"病案首页"相关文书参数
/// Debug:	w ##Class(EPRservice.BIL.BIEPRLogs).GetFirstPagePrintDocID()
ClassMethod GetFirstPagePrintDocID() As %String
{
	k SQLCODE
	
	&sql(select top 1 CtmDictID into :info from EPRmeta.CustomDictionary where CtmDictType = 'PrintDocType' and CtmDictName= 'FPDocID' and CtmDictStatus='Y')
	
	q:(SQLCODE '= 0) ""
	
	q info
}

/// Desc:	病案首页状态
/// Input:	AEpisodeID 就诊指针
/// Return:	病历状态
/// Debug:	w ##Class(EPRservice.BIL.BIEPRLogs).GetFristPageStatus("201871")
ClassMethod GetFristPageStatus(AEpisodeID As %String) As %String
{
	s status = ""
	
	s printDocIDInfo = ..GetFirstPagePrintDocID()
	q:(printDocIDInfo = "") ""
	
	s id = "0"
	s count = $L(printDocIDInfo,"^")
	for i=1:1:count
	{
		s printDocID = $P(printDocIDInfo,"^",i)
		
		s id=$O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_printDocID, 1, id))
		s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(id)
		if (objEPRLogs '= "")
		{
			s status = objEPRLogs.EPRStatus
			q
		}
	}
	
	q status
}

/// Desc:	门诊病案首页打印模板的DocID配置
/// 		配置的数据供以下方法使用：EPRservice.BIL.BIEPRLogs.GetOutFPPrintDocID()
/// Input：	APrintDocID : 打印模板DocID
/// 		ADesc : 描述
/// Debug：	w ##Class(EPRservice.BIL.BIEPRLogs).InitOutFPPrintDocID("21^34","门诊病案首页DocID")
/// Others:	如何确定 APrintDocID参数：
/// 		打开病案首页界面模板，在保存按钮左侧单击右键，在弹出菜单选择查看源文件，
/// 		在源文件中找到下列代码：
/// 		var printTemplateDocId = '34';    其中的 printTemplateDocId 即是。
ClassMethod InitOutFPPrintDocID(APrintDocID As %String, ADesc As %String) As %String
{
	q:(APrintDocID = "") "PrintDocID不能为空"
	
	
	&sql(select top 1 ID into :mastID from EPRmeta.CustomDictionary where CtmDictType = 'PrintDocType' and CtmDictName= 'OutFPDocID' and CtmDictStatus='Y')
	if (SQLCODE = 0)
	{
		&sql(update EPRmeta.CustomDictionary set CtmDictID = :APrintDocID, CtmDictDesc = :ADesc where ID = :mastID) 
	}	
	else
	{
		&sql(insert into EPRmeta.CustomDictionary (CtmDictType, CtmDictStatus, CtmDictName, CtmDictID, CtmDictDesc) values ('PrintDocType', 'Y', 'OutFPDocID', :APrintDocID, :ADesc))
	}
	
	q SQLCODE
}

/// Desc:	获取"门诊病案首页"相关文书参数
/// Debug:	w ##Class(EPRservice.BIL.BIEPRLogs).GetOutFPPrintDocID()
ClassMethod GetOutFPPrintDocID() As %String
{
	k SQLCODE
	
	&sql(select top 1 CtmDictID into :info from EPRmeta.CustomDictionary where CtmDictType = 'PrintDocType' and CtmDictName= 'OutFPDocID' and CtmDictStatus='Y')
	
	q:(SQLCODE '= 0) ""
	
	q info
}

/// Desc:	门诊病案首页状态
/// Input:	AEpisodeID 就诊指针
/// Return:	病历状态
/// Debug:	w ##Class(EPRservice.BIL.BIEPRLogs).GetOutFristPageStatus("201871")
ClassMethod GetOutFristPageStatus(AEpisodeID As %String) As %String
{
	s status = ""
	
	s printDocIDInfo = ..GetOutFPPrintDocID()
	q:(printDocIDInfo = "") ""
	
	s id = "0"
	s count = $L(printDocIDInfo,"^")
	for i=1:1:count
	{
		s printDocID = $P(printDocIDInfo,"^",i)
		
		s id=$O(^DHCEPRI.EPRLogsI("IdxMain", " "_AEpisodeID, " "_printDocID, 1, id))
		s objEPRLogs = ##class(EPRinstance.EPRLogs).%OpenId(id)
		if (objEPRLogs '= "")
		{
			s status = objEPRLogs.EPRStatus
			q
		}
	}
	
	q status
}

}
