Class DHCEPRFS.Srv.SrvMRLog Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRLog";

/// Desc:	增加日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail("1","CATALOG","2583")
ClassMethod AddNormalLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail) As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AMRAction = AEntity.MRAction
	s AActUserID = AEntity.ActUserID
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddNormalLogDetail(AMREpisodeID, AMRAction, AActUserID)
	q ret
}

/// Desc:	增加"病历生成检查"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogDetail("1","2583",12)
ClassMethod AddCreateCheckLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AMRItemID As %String) As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddCreateCheckLogDetail(AMREpisodeID, AActUserID, AActPages,AMRItemID)
	q ret
}

/// Desc:	增加"病历生成"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogDetail("1","2583",12)
ClassMethod AddCreateLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail) As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddCreateLogDetail(AMREpisodeID, AActUserID, AActPages)
	q ret
}

/// Desc:	增加"病历老病历生成"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddOldCreateLogDetail("573")
ClassMethod AddOldCreateLogDetail(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddOldCreateLogDetail(AEpisodeID)
	q ret
}

/// Desc:	增加"病历扫描"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogDetail("1","2583","12") 
ClassMethod AddScanLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AMRItemIDS As %String = "", AIP As %String = "") As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s AMRMedRecordID = AEntity.MRMedRecordID
	s:(AMRMedRecordID = $c(0)) AMRMedRecordID = ""
	if ((AMRMedRecordID '= "") && (AMRMedRecordID '= $c(0)))
	{
		s AMRAction = "SCANMEDRECORD"
	}
	else
	{
		s AMRAction = "SCAN"
	}
	//w ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogAll("31", "159", "-3","87","SCAN","","192.168.18.128")
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogAll(AMREpisodeID, AActUserID, AActPages,AMRItemIDS,AMRAction,AMRMedRecordID,AIP)
	q ret
}

/// Desc:	增加"扫描分类"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddArrangeLogDetail("1","2583","10")
ClassMethod AddArrangeLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AMRItemIDS As %String = "", AIP As %String = "") As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s AMRMedRecordID = AEntity.MRMedRecordID
	s:(AMRMedRecordID = $c(0)) AMRMedRecordID = ""
	if ((AMRMedRecordID '= "") && (AMRMedRecordID '= $c(0)))
	{
		s AMRAction = "ARRANGEMEDRECORD"
	}
	else
	{
		s AMRAction = "ARRANGE"
	}
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogAll(AMREpisodeID, AActUserID, AActPages,AMRItemIDS,AMRAction,AMRMedRecordID,AIP)
	q ret
}

/// Desc:	增加"病历扫描"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddConfirmScanLogDetail("1","2583","12") 
ClassMethod AddConfirmScanLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AIP As %String = "") As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddConfirmScanLogDetail(AMREpisodeID, AActUserID, AActPages,AIP)
	q ret
}

/// Desc:	增加"删除扫描"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddScanLogDetail("1","2583","12") 
ClassMethod AddScanDeleteLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AIP As %String = "") As %String [ WebMethod ]
{
	s AMREpisodeID = AEntity.MREpisodeID
	s AActUserID = AEntity.ActUserID
	s AActPages = AEntity.ActPages
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddScanDeleteLogDetail(AMREpisodeID, AActUserID, AActPages,AIP)
	q ret
}

/// Desc:	增加"病历打印"日志明细
/// Debug:	w ##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogDetail("1","2583","10","0.8","1")
ClassMethod AddPrintLogDetail(AEntity As DHCEPRFS.Entity.EMRLogDetail, AMRItemIDS As %String = "", AName As %String = "", ARelationship As %String = "", AContact As %String = "", AIDNumber As %String = "", APrintTimes As %String = "1", AIP As %String = "", APrintPurposeDesc As %String = "", APrintPurposeCode As %String = "") As %String [ WebMethod ]
{
	s APrintTimes = +APrintTimes
	s:(AMRItemIDS=$c(0)) AMRItemIDS=""
	s:(AName=$c(0)) AName=""
	s:(ARelationship =$c(0)) ARelationship=""
	s:(AContact=$c(0)) AContact=""
	s:(AIDNumber=$c(0)) AIDNumber=""
	s:(AIP=$c(0)) AIP=""
	s:(APrintPurposeDesc =$c(0)) APrintPurposeDesc=""
	s:(APrintPurposeCode=$c(0)) APrintPurposeCode=""
	for index=1:1:APrintTimes
	{
		s AMREpisodeID = AEntity.MREpisodeID
		s AActUserID = AEntity.ActUserID
		s AActPages = AEntity.ActPages
		s AActPrice = AEntity.ActPrice
		s AActSchemeID = AEntity.ActSchemeID
		s ARemark = AEntity.Remark
	
		s ret = ##Class(DHCEPRFS.BL.BLMRLog).AddPrintLogAll(AMREpisodeID, AActUserID, AActPages, AActPrice, AActSchemeID, ARemark, AMRItemIDS,AName,ARelationship,AContact,AIDNumber,AIP,APrintPurposeDesc,APrintPurposeCode)
	}
	q ret
}

/// Desc:  获取待扫描病历
ClassMethod GetToBeScannedPat() As %XML.DataSet [ WebMethod ]
{
	s startDate = "", endDate = ""
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetToBeScannedPat")
	d ds.SetArgs(startDate, endDate)
	q ds
}

/// Desc:  获取待分类病历
ClassMethod GetToBeArrangedPat(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AUserID = $c(0)) AUserID = ""
	s startDate = "", endDate = ""
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetToBeArrangedPat")
	d ds.SetArgs(startDate, endDate, AUserID)
	q ds
}

/// Desc:  获取待合并病历
ClassMethod GetToBeMergedPat(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AUserID = $c(0)) AUserID = ""
	s startDate = "", endDate = ""
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetToBeMergedPat")
	d ds.SetArgs(startDate, endDate, AUserID)
	q ds
}

/// Desc:  获取待确认扫描病历
ClassMethod GetToBeConfirmScanPat(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AUserID = $c(0)) AUserID = ""
	s startDate = "", endDate = ""
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetToBeScannedPat")
	d ds.SetArgs(startDate, endDate,"CONFIRMSCAN",AUserID)
	q ds
}

/// Desc:	是否已进行过病历扫描
ClassMethod HasScannedCommon(AMRID As %String, AType As %String = "") As %String [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s hasScanned = ##Class(DHCEPRFS.BL.BLMRLog).HasScanned(AMRID, AType)
	q hasScanned
}

/// Desc:	是否已进行过病历扫描
ClassMethod HasScanned(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s hasScanned = ##Class(DHCEPRFS.BL.BLMRLog).HasScanned(AMREpisodeID)
	q hasScanned
}

/// Desc: 获取患者病历状态
ClassMethod GetStatus(AMREpisodeID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLMRLog).GetStatus(AMREpisodeID)
}

/// Desc: 取扫描人和扫描时间
ClassMethod GetScanData(AMREpisodeID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLMRLog).GetScanData(AMREpisodeID)
}

/// Desc: 打印日志
ClassMethod GetPrintLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As DHCEPRFS.DataSet.EPrintLogDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPrintLogDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID)
	q dataset
}

/// Desc: 打印日志详细
ClassMethod GetPrintLogDetail(AMRLogDetailID As %String) As DHCEPRFS.DataSet.EPrintLogDetailDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPrintLogDetailDS).%New()
	d dataset.SetArgs(AMRLogDetailID)
	q dataset
}

/// Desc: 一次就诊的打印历史
ClassMethod GetPrintLogMREpisode(AMREpisodeID As %String) As DHCEPRFS.DataSet.EPrintLogMREpisodeDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPrintLogMREpisodeDS).%New()
	d dataset.SetArgs(AMREpisodeID)
	q dataset
}

/// Desc: 扫描日志
ClassMethod GetScanLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String = "", AScan As %String = "") As DHCEPRFS.DataSet.EScanLogDS [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s:(AScan = $c(0)) AScan = ""
	s:(AUserName = $c(0)) AUserName = ""
	s dataset = ##class(DHCEPRFS.DataSet.EScanLogDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID,AType,AScan)
	q dataset
}

/// Desc: 扫描日志
ClassMethod GetCheckScanLog(AStartDate As %String, AEndDate As %String, AMedRecordNo As %String = "", AUserName As %String = "") As DHCEPRFS.DataSet.ECheckScanLogDS [ WebMethod ]
{
	s:(AStartDate = $c(0)) AStartDate = ""
	s:(AEndDate = $c(0)) AEndDate = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	s:(AUserName = $c(0)) AUserName = ""
	s dataset = ##class(DHCEPRFS.DataSet.ECheckScanLogDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate,AMedRecordNo,AUserName)
	q dataset
}

/// Desc: 未完成分类列表汇总
ClassMethod GetNeedArrangeList(AStartDate As %String, AEndDate As %String, AScan As %String = "") As DHCEPRFS.DataSet.ENeedArrangeListDS [ WebMethod ]
{
	s:(AScan = $c(0)) AScan = ""
	s dataset = ##class(DHCEPRFS.DataSet.ENeedArrangeListDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate,AScan)
	q dataset
}

ClassMethod CheckPrint(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRLog).CheckPrint(AMREpisodeID)
	q ret
}

ClassMethod CheckAction(AMREpisodeID As %String, AAction As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRLog).CheckAction(AMREpisodeID,AAction)
	q ret
}

ClassMethod CheckActionEpisode(AEpisodeID As %String, AAction As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRLog).CheckActionEpisode(AEpisodeID,AAction)
	q ret
}

/// Desc: 证件扫描日志列表汇总
ClassMethod GetScanIDList(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As DHCEPRFS.DataSet.EScanIDListDS [ WebMethod ]
{
	s:(AScan = $c(0)) AScan = ""
	s:(AUserName = $c(0)) AUserName = ""
	s dataset = ##class(DHCEPRFS.DataSet.EScanIDListDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID,AScan)
	q dataset
}

/// Desc:	增加按照MRItem类型统计打印页数查询 杨鹏 2015.09.12
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// Debug：	do ##class(DHCEPRFS.Srv.SrvMRLog).GetPrintPagesByMRItem("2011-06-01","2015-09-15")
ClassMethod GetPrintPagesByMRItem(AStartDate As %String, AEndDate As %String) As DHCEPRFS.DataSet.MRPrintPagesDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.MRPrintPagesDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate)
	q dataset
}

/// Desc:	增加按照MRItem类型查询打印明细 杨鹏 2015.09.13
/// Input：	AStartDate 	起始日期
/// 		AEndDate 	结束日期
/// 			AMRItemId	归档病历编码
/// Debug：	do ##class(DHCEPRFS.Srv.SrvMRLog).GetPrintDetailByMRItem("2011-06-01","2015-09-15","4")
ClassMethod GetPrintDetailByMRItem(AStartDate As %String, AEndDate As %String, AMRItemId As %String) As DHCEPRFS.DataSet.MRPrintDetailDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.MRPrintDetailDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate,AMRItemId)
	q dataset
}

/// Desc:	病历示踪模块增加按照病案号、登记号、姓名查询病人信息 杨鹏 2015.10.8
/// Input：	AQueryType 		查询方式 1=病案号 2=登记号 3=姓名
/// 		AQueryContent 	结束日期
/// Debug：	w ##Class(DHCEPRFS.BL.BLMRLog).GetPatientInfoForMRTrack("1","500224")
ClassMethod GetPatientInfoForMRTrack(AQueryType As %String, AQueryContent As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRLog).GetPatientInfoForMRTrack(AQueryType,AQueryContent)
	q ret
}

/// Desc:	病历示踪模块增加按照病案号、登记号、姓名查询病人信息 杨鹏 2015.10.10
/// Input：	AMREpisodeID 		病案就诊ID
/// 		AEpisodeID 	就诊号
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRLog","GetMRTrackInfoByEpisodeID","2011-06-01","2015-09-15","4")
/// SQL check:
ClassMethod GetMRTrackInfoByEpisodeID(AMREpisodeID As %String, AEpisodeID As %String) As DHCEPRFS.DataSet.MRTrackInfoDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.MRTrackInfoDS).%New()
	d dataset.SetArgs(AMREpisodeID, AEpisodeID)
	q dataset
}

/// Desc:	按照日期查询打印方案的打印次数及金额 杨鹏 2015.11.9
/// Input：	AMREpisodeID 		病案就诊ID
/// 		AEpisodeID 	就诊号
/// Debug：	w ##Class(DHCEPRFS.Srv.SrvMRLog).GetPrintPagesGroupByPrintScheme("2015-11-09","2015-11-09")
/// SQL check:
ClassMethod GetPrintPagesGroupByPrintScheme(ABeginDate As %String, AEndDate As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLMRLog).GetPrintPagesGroupByPrintScheme(ABeginDate,AEndDate)
	q ret
}

/// Desc:获得所有扫描者名字
/// Creator：Candy
ClassMethod GetScanOperator() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetScanOperator")
	d obj.SetArgs()
	q obj
}

/// Desc:获得所有扫描角色名字
/// Creator：liushuang
ClassMethod GetAllRoleItems() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetAllRoleItems")
	d obj.SetArgs()
	q obj
}

/// Desc: 扫描日志汇总
/// Creator: liushuang
ClassMethod GetScanLogSummary(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AType As %String, AScan As %String = "") As DHCEPRFS.DataSet.EScanLogSummaryDS [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s:(AScan = $c(0)) AScan = ""
	s:(AUserName = $c(0)) AUserName = ""
	s dataset = ##class(DHCEPRFS.DataSet.EScanLogSummaryDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID,AType,AScan)
	q dataset
}

/// Desc: 扫描日志，按照病案号段查询
ClassMethod GetLogByMedRecordRange(AStartMedRecord As %String, AEndMedRecord As %String) As DHCEPRFS.DataSet.ELogByMedRecordRangeDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.ELogByMedRecordRangeDS).%New()
	d dataset.SetArgs(AStartMedRecord, AEndMedRecord)
	q dataset
}

ClassMethod GetLogByRange(AParam As DHCEPRFS.Entity.ELogByRange) As DHCEPRFS.DataSet.ELogByRangeDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.ELogByRangeDS).%New()
	d dataset.SetArgs(AParam)
	q dataset
}

/// 历史病案录入日志
ClassMethod GetInputHistoryLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String, AScan As %String = "") As DHCEPRFS.DataSet.EInputHistoryLogDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EInputHistoryLogDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate, AUserName, AMedRecordID, AScan)
	q dataset
}

ClassMethod SaveHistoryInputLog(AUserID As %String, AType As %String, AOperatorType As %String, AMedRecordNo As %String, AMRMedRecordNo As %String, AEpisodeID As %String = "", AMREpisodeID As %String = "") As %String [ WebMethod ]
{
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	s ret = ##class(DHCEPRFS.BL.BLMRLog).SaveHistoryInputLog(AUserID,AType,AOperatorType,AMedRecordNo,AMRMedRecordNo,AEpisodeID,AMREpisodeID)
	q ret
}

/// Desc:操作员扫描工作量汇总
ClassMethod GetScanWorkload(AStartDate As %String, AEndDate As %String) As DHCEPRFS.DataSet.EScanWorkloadDS [ WebMethod ]
{
	s dataset = ##Class(DHCEPRFS.DataSet.EScanWorkloadDS).%New()
	d dataset.SetArgs(AStartDate, AEndDate)
	q dataset
}

ClassMethod GetAllSubHospital() As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRLog).GetAllSubHospital()
}

ClassMethod GetPrintPagesGroupBySubHos(ABeginDate As %String, AEndDate As %String, ASubHospitalID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRLog).GetPrintPagesGroupBySubHos(ABeginDate,AEndDate,ASubHospitalID)
}

ClassMethod GetPrintTotalFromLog(ABeginDate As %String, AEndDate As %String, ASubHospitalID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetPrintTotalFromLog")
	d obj.SetArgs(ABeginDate,AEndDate,ASubHospitalID)
	q obj
}

ClassMethod GetScanUser() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetScanUser")
	d obj.SetArgs()
	q obj
}

ClassMethod GetScanNeedArrange(AuserID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(AuserID = $c(0)) AuserID = ""
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetScanNeedArrange")
	d obj.SetArgs(AuserID)
	q obj
}

ClassMethod AddExportLog(AMREpisodeID As %String, AActUserID As %String, AActPages As %String, ADetailVersion As %String, AMRItemIDS As %String, AIP As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRLog).AddExportLog(AMREpisodeID,AActUserID,AActPages,ADetailVersion,AMRItemIDS,AIP)
}

ClassMethod GetExportLog(AStartDate As %String, AEndDate As %String, AUserName As %String, AMedRecordID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetExportLog")
	d obj.SetArgs(AStartDate,AEndDate,AUserName,AMedRecordID)
	q obj
}

ClassMethod GetExportLogDetail(AMRLogDetailID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRLog:GetExportLogDetail")
	d obj.SetArgs(AMRLogDetailID)
	q obj
}

/// Desc: 操作者打印工作量汇总
/// Input: AStartDate: 起始日期, AEndDate: 截止日期
ClassMethod GetUserPrintTotalFromLog(AStartDate As %String, AEndDate As %String) As DHCEPRFS.DataSet.EPrintTotalByUserDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPrintTotalByUserDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate)
	q dataset
}

/// Desc: 获取病人扫描项目的页数
/// Input: AMREpisode
ClassMethod GetPatientScanDetail(AMREpisodeID As %String) As DHCEPRFS.DataSet.EScanDetailDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EScanDetailDS).%New()
	d dataset.SetArgs(AMREpisodeID)
	q dataset
}

/// Desc: 获取扫描过的就诊列表
/// Input: 
ClassMethod GetPatListByScanned(ADisLocID As %String, AStartDate As %String, AEndDate As %String) As DHCEPRFS.DataSet.EPatInfo4ScanDetailDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPatInfo4ScanDetailDS).%New()
	d dataset.SetArgs(AStartDate,AEndDate,ADisLocID)
	q dataset
}

/// Desc: 根据提供的病案号查询是否上传
/// Input: AMedRecordIDs 本地scanbatch那个目录里面的对应的病案号 AScanDate 同上
ClassMethod GetScanLogFlagByMedRecordIds(AMedRecordIDs As %String, AScanDate As %String = "") As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRLog).GetScanLogByMedRecords(AMedRecordIDs,AScanDate)
	q ret
}

/// Desc: 根据起止日期获取归档系统审计日志(登陆操作日志)
ClassMethod GetAuditList(begin As %String = "", end As %String = "") As %XML.DataSet [ WebMethod ]
{
	s:begin'="" begin = $REPLACE(begin,":","-")
	s:begin'="" begin = $zdh(begin,3)
	s:end'="" end = $REPLACE(end,":","-")
	s:end'="" end = $zdh(end,3)
	
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLAuditOperation:QryRecordByDate")
	d obj.SetArgs(begin,end)
	q obj
}

/// Desc: 向审计日志表中添加一条记录
ClassMethod AddAuditRecord(AUserID As %String = "", AUserName As %String = "", AType As %String = "", AIP As %String = "", AMachineName As %String = "", AMacAddr As %String = "") As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLAuditOperation).AddRecord(AUserID,AUserName,AType,AIP,AMachineName,AMacAddr)
}

}
