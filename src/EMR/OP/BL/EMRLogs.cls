/// 名称:	EMR.OP.BL.EMRLogs
/// 描述:	门诊病历 病历操作日志业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.OP.BL.EMRLogs Extends EMR.OP.COM.ActionBase
{

/// Desc:       病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-4-13
/// Input:      dtoLog 日志对象
/// OutPut:     成功 当前状态，
/// 			失败 -1^失败信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.OP.BL.EMRLogs).AddOperateLog("","",.argOutData)
ClassMethod AddOperateLog(dtoELog As EMR.OP.DTO.EMRLogs, dtoLog As EMR.OP.DTO.InstanceLog) As %String
{
	s $zt = "errhandle"
	s res = "-1"
	q:((dtoLog.Action = "") || (dtoELog.DocumentData = "")) "-1^状态或实例ID不能为空"
	s AEpisodeID = dtoELog.EpisodeID.%Id()
	s objDocument = dtoELog.DocumentData
	q:(objDocument = "") "-1^实例不能为空"
	s emrNum = objDocument.ListNo
	s dtoELog.DOCCode = objDocument.DOCCode
	s dtoELog.EMRStatus= dtoLog.Action
	s logID =##class(EMR.OP.BL.EMRLogs).GetLogID(dtoELog)
    s emrLogId = ""
	if (logID = "")		//若为保存第一个界面模板
	{
		s logID = ##class(EMR.OP.BL.EMRLogs).CreateEMRLog(dtoLog,objDocument)
		q:($p(logID,"^",1) = "-1") res_"^CreateEMRLog^"_logID
        s emrLogId = $p(logID,"^",1)
	}
	else
	{
		s flag = ##class(EMR.OP.BL.EMRLogs).UpdateEMRLogByID(logID,dtoLog,objDocument)
		q:($p(flag,"^",1) = "-1") res_"^UpdateEMRLog^"_flag
        s emrLogId = $p(flag,"^",1)
	}	
	s logStatus = ##class(EMR.OP.BL.EMRLogs).GetLogStatus(dtoELog)
	k objEcrecord,objDocumentData
	q logStatus
	
errhandle
	q res_"^"_$zerror
}

/// Desc:       根据EpisodeID、EMRStructID、EMRNum取得病历日志记录的ID
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:       EMR.OP.DTO.EMRLogs 日志对象
/// Return:      RowID
/// Others:      
ClassMethod GetLogID(dtoLog As EMR.OP.DTO.EMRLogs) As %String
{
	s rowId = ""
	q:((dtoLog ="")||(dtoLog.EpisodeID = "")||(dtoLog.DocumentData = "")) rowId
	s TILEmrLogs = ##Class(EMR.DAO.EMRLogs).GetTureIndexLocation(dtoLog.EpisodeID.%Id())
	s rowId = $o(@TILEmrLogs@("IdxMain",dtoLog.EpisodeID.%Id(),dtoLog.DocumentData.%Id(),""))
	q rowId
}

/// Desc:       创建日志 
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input：	    dtoILog:EMR.OP.DTO.InstanceLog 日志对象
/// 		    pEcrecord:EMR.OP.ECRecord 
/// 		    pDocumentData:EMR.OP.DocumentData
/// Return：    EMRLogs的rowid  或者 -1(失败)
/// Debug：     ##class(EMR.OP.BL.EMRLogs).CreateEMRLog("1","1","save","10.10.141.116","50","1","1")
ClassMethod CreateEMRLog(dtoILog As EMR.OP.DTO.InstanceLog, pDocumentData) As %String
{
	s res = "-1"
    q:((dtoILog.Action = "")||(pDocumentData = "")) res	
	s $zt = "CreateEMRLogError"
	s AEpisodeID = pDocumentData.EpisodeID.%Id()
	s objEMRLogs = ##Class(EMR.DAO.EMRLogs).doCreateInstance(AEpisodeID)
	s objEMRLogs.EpisodeID = pDocumentData.EpisodeID
	s objEMRLogs.DocumentData = pDocumentData
	s objEMRLogs.DOCCode = pDocumentData.DOCCode
	s objCreateUser =pDocumentData.CreateUser
	s objEMRLogs.CreateUserID = objCreateUser
	s objEMRLogs.TemplateID = pDocumentData.TemplateID
	s objEMRLogs.HappenDate = pDocumentData.HappenDate
	s objEMRLogs.HappenTime = pDocumentData.HappenTime
	s objEMRLogs.CreateDate = pDocumentData.CreateDate
	s objEMRLogs.CreateTime = pDocumentData.CreateTime
	s initStatus = " "	//初始状态	
	s finalStatusID = ##class(EMR.DOC.BL.EMRActStatusCfg).GetPostStatus(initStatus, dtoILog.Action)	//最终状态
	q:(finalStatusID="") res
	s objFStatus = ##class(CF.EMR.DOC.EMRStatus).%OpenId(finalStatusID)
	q:(objFStatus="") res
	s objEMRLogs.EMRStatus = objFStatus
	
	//插入一条EMR.OP.InstanceLog
	s instanceLog = ##Class(EMR.DAO.InstanceLog).doCreateInstance(AEpisodeID)
	s instanceLog.ParRef = objEMRLogs
	s instanceLog.Action = dtoILog.Action
	s instanceLog.OperateDate = $P($h,",",1)
	s instanceLog.OperateTime = $P($h,",",2)
	s instanceLog.OperateMachineIP= dtoILog.OperateMachineIP
	;s instanceLog.InitStatus = initStatus ;initStatus值为空不用赋值
	s instanceLog.FinalStatus = objFStatus
	s objOUser = ##class(User.SSUser).%OpenId(dtoILog.OperateUserID,0)
	s:(objOUser'="") instanceLog.OperateUserID = objOUser
	s:(objOUser'="") instanceLog.OperateUserName =  $tr(objOUser.SSUSRName,$c(13)_$c(10),"")
	s objLUser = ##class(User.SSUser).%OpenId(dtoILog.LoginUserID,0)
	s:(objLUser'="") instanceLog.LoginUserID = objLUser
	s:(objLUser'="") instanceLog.LoginUserName = $tr(objLUser.SSUSRName,$c(13)_$c(10),"")	
	s instanceLog.UserLoginLocID = dtoILog.UserLoginLocID
	s instanceLog.TemplateID = pDocumentData.TemplateID
	s instanceLog.EMRSignID = dtoILog.EMRSignID
	s instanceLog.ProductSource = dtoILog.ProductSource
	s instanceLog.EMRSignLogID = dtoILog.EMRSignLogID

    
	s scEMRLog = objEMRLogs.%Save() 
	s:($$$ISOK(scEMRLog)) res = objEMRLogs.%Id()
	k objEMRLogs
	k instanceLog
	q res_"^"_scEMRLog
	 
CreateEMRLogError
    q res_"^"_$zerror
}

/// Desc:       更新操作日志
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      pLogID EMR.OP.EMRLogs的rowid
/// 		    dtoILog:EMR.OP.DTO.InstanceLog 日志对象
/// 		    pEcrecord:EMR.OP.ECRecord 
/// 		    pDocumentData:EMR.OP.DocumentData
/// return:     res -1:失败  成功:rowID
/// Debug:      w ##class(EMR.OP.BL.EMRLogs).UpdateEMRLogByID("61","Reference","10.10.141.115","5972","Single","62236","56140",826)
ClassMethod UpdateEMRLogByID(pLogID As %String, dtoILog As EMR.OP.DTO.InstanceLog, pDocumentData) As %String
{
	s res = "-1"
	q:((pLogID = "")||(dtoILog.Action = "")||(pDocumentData = "")) res
	
	s $zt = "UpdateEMRLogError"
	s objInitStatus=""
	s AEpisodeID = pDocumentData.EpisodeID.%Id()
	s objEMRLogs = ##class(EMR.DAO.EMRLogs).doOpenByID(AEpisodeID,pLogID)
	q:(objEMRLogs="") res
	//更新操作后的病历状态
	s objInitStatus = objEMRLogs.EMRStatus	  //初始状态
	s initStatus = objEMRLogs.EMRStatus.Code	  //初始状态	
	s finalStatusID = ##class(EMR.DOC.BL.EMRActStatusCfg).GetPostStatus(initStatus, dtoILog.Action)	  //最终状态
	q:(finalStatusID = "") res
	s objFStatus = ##class(CF.EMR.DOC.EMRStatus).%OpenId(finalStatusID)
	q:(objFStatus="") res
	s objEMRLogs.EMRStatus = objFStatus
	s strChartType = pDocumentData.TemplateID.ChartItemType
	if ($zcvt(strChartType,"U") = "MULTIPLE")
	{
		s objEMRLogs.HappenDate = pDocumentData.HappenDate
		s objEMRLogs.HappenTime = pDocumentData.HappenTime
	}	
	s:(objEMRLogs.HappenDate="") objEMRLogs.HappenDate =pDocumentData.HappenDate
	s:(objEMRLogs.HappenTime="") objEMRLogs.HappenTime = pDocumentData.HappenTime
	//插入一条EMR.OP.InstanceLog
	s instanceLog = ##class(EMR.DAO.InstanceLog).doCreateInstance(AEpisodeID)
	s instanceLog.ParRef = objEMRLogs
	s instanceLog.Action = dtoILog.Action
	s instanceLog.OperateDate = $P($h,",",1)
	s instanceLog.OperateTime = $P($h,",",2)
	s instanceLog.OperateMachineIP= dtoILog.OperateMachineIP
	s:(objInitStatus'="") instanceLog.InitStatus = objInitStatus
	s instanceLog.FinalStatus = objFStatus
	s objOUser = ##class(User.SSUser).%OpenId(dtoILog.OperateUserID,0)
	s:(objOUser'="") instanceLog.OperateUserID = objOUser
	s:(objOUser'="") instanceLog.OperateUserName =  $tr(objOUser.SSUSRName,$c(13)_$c(10),"")
	s objLUser = ##class(User.SSUser).%OpenId(dtoILog.LoginUserID,0)
	s:(objLUser'="") instanceLog.LoginUserID = objLUser
	s:(objLUser'="") instanceLog.LoginUserName = $tr(objLUser.SSUSRName,$c(13)_$c(10),"")
	s instanceLog.UserLoginLocID = dtoILog.UserLoginLocID
	s instanceLog.TemplateID = pDocumentData.TemplateID
	s instanceLog.EMRSignID = ""
	s instanceLog.ProductSource = dtoILog.ProductSource
	s instanceLog.EMRSignLogID = dtoILog.EMRSignLogID
		
	s scEMRLog = objEMRLogs.%Save() 
	s:($$$ISOK(scEMRLog)) res = objEMRLogs.%Id()
	k objEMRLogs
	k objDocumentLog
	q res_"^"_scEMRLog
	 
UpdateEMRLogError
    q res_"^"_$zerror
}

/// Desc:       取日志信息
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input：     pEpisodeId 就诊ID
///             pEmrDocId 目录展现结构挂模板一层的ID
///             pNum
/// Debug:      w ##Class(EMR.OP.BL.EMRLogs).GetLogStatus(76,53,1)
ClassMethod GetLogStatus(dtoLog As EMR.OP.DTO.EMRLogs) As %DynamicObject
{
  	s resJson  = ##class(%DynamicObject).%New()
  	q:((dtoLog.EpisodeID = "")||(dtoLog.DocumentData = "")) resJson
  	s AEpisodeID= dtoLog.EpisodeID.%Id()
  	s logID = ..GetLogID(dtoLog)
  	s objLogs = ##class(EMR.DAO.EMRLogs).doOpenByID(AEpisodeID,logID)
    if (objLogs '= "")
  	{
  		//提取创建者信息
  		s creator = objLogs.CreateUserID
  		s:(creator '= "") creator = creator.SSUSRName
  		s resJson.creator = $ZSTRIP(creator,"*C")
  		s resJson.happenDateTime =$case(objLogs.HappenDate,"":"",:$zd(objLogs.HappenDate,3)_" "_$zt(objLogs.HappenTime,1))
  		s resJson.createDateTime = $zd(objLogs.CreateDate,3)_" "_$zt(objLogs.CreateTime,1)
  		s lastInstanceLog = ..GetFinalLog(AEpisodeID,logID)
  		s resJson.operator = lastInstanceLog.OperateUserName
  		s resJson.operateDateTime = $case(lastInstanceLog.OperateDate,"":"",:$zd(lastInstanceLog.OperateDate, 3)_" "_$zt(lastInstanceLog.OperateTime, 1))
  		s resJson.ip = lastInstanceLog.OperateMachineIP
  		s action = lastInstanceLog.Action
  		s resJson.action = action
		s resJson.productSource = lastInstanceLog.ProductSource
  		s resJson.actionDesc = ##Class(EMR.DOC.BL.EMRAction).GetActionNameByCode(action)
  		s resJson.signName = ##Class(EMR.DOC.BL.SignRole).GetSignName(action)  		
  		s status = ..GetEMRStatus(dtoLog)
  		s resJson.status = status
  		s resJson.statusDesc = ##Class(EMR.DOC.BL.EMRStatus).GetStatusNameByCode(status)
  		s resJson.emrSignID = lastInstanceLog.EMRSignID
  	}
  	else
  	{
	  	s resJson.currState = " "
	  	s resJson.statusDesc = "未完成"
	}
	q resJson
}

/// Desc:       取得病历当前状态
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      dtoLog 日志对象
/// Return:     病历当前状态Code(EMRmeta.EMRStatus)
/// Debug:      w ##Class(EMR.OP.BL.EMRLogs).GetEMRStatus(76,33,1)     
ClassMethod GetEMRStatus(dtoLog As EMR.OP.DTO.EMRLogs) As %String
{
	s status = ""
	q:((dtoLog.EpisodeID ="")||(dtoLog.DocumentData = "")) status
	s AEpisodeID= dtoLog.EpisodeID.%Id()
	s TILEmrLogs = ##Class(EMR.DAO.EMRLogs).GetTureIndexLocation(AEpisodeID)
	s rowId = $o(@TILEmrLogs@("IdxMain",AEpisodeID,dtoLog.DocumentData.%Id(),""))
    q:(rowId = "") status
    s objLog = ##Class(EMR.DAO.EMRLogs).doOpenByID(AEpisodeID,rowId)
    q:(rowId = "") status
    s status = objLog.EMRStatus.Code
	q status
}

/// Desc:       取最后一条日志数据
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      pEmrLogId  EMR.OP.EMRLogs rowId
/// Output:     EMR.OP.InstanceLog 记录
/// Debug:      ##Class(EMR.OP.BL.EMRLogs).GetFinalLog(1)
ClassMethod GetFinalLog(AEpisodeID As %String, pEmrLogId As %String)
{
	q:(pEmrLogId = "")||(AEpisodeID="") ""
	s TILInstanceLog = ##Class(EMR.DAO.InstanceLog).GetTureIndexLocation(AEpisodeID)
	s subId = $o(@TILInstanceLog@("IdxParRef",pEmrLogId,""),-1)
	q:(subId = "") ""
	s rowId = pEmrLogId_"||"_subId
	s objLog = ##Class(EMR.DAO.InstanceLog).doOpenByID(AEpisodeID,rowId)
    q objLog
}

/// Desc:		病历是否签名
/// Creator:	yejian
/// CreateDate:	2022-4-27
/// Input:      pEpisodeID 就诊科室
///             pEmrDocID 目录ID
///             pNum 病历序号
/// Debug:       w ##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(76,53,1)
ClassMethod HasRecordSign(dtoLog As EMR.OP.DTO.EMRLogs) As %String
{
	s result = 0
	q:(dtoLog.EpisodeID = "")||(dtoLog.DocumentData = "") result
	s AEpisodeID= dtoLog.EpisodeID.%Id()
	s TILEmrLogs = ##Class(EMR.DAO.EMRLogs).GetTureIndexLocation(AEpisodeID)
	s TILInstanceLog = ##Class(EMR.DAO.InstanceLog).GetTureIndexLocation(AEpisodeID)
	s actions = ""
	s rowId = ""
	for
	{
		s rowId = $o(^CF.EMR.DOC.SignRoleD(rowId))
		q:(rowId = "")
		s obj = ##Class(CF.EMR.DOC.SignRole).%OpenId(rowId)
		continue:(obj = "")
		s actions = actions_$lb($zcvt(obj.ActionCode,"U"))
	}
	s LogsId = $o(@TILEmrLogs@("IdxMain",AEpisodeID,dtoLog.DocumentData.%Id(),""))
	q:(LogsId = "") result
	s subId = ""
	for
	{
		s subId = $o(@TILInstanceLog@("IdxParRef",LogsId,subId))
		q:(subId = "")
		s objlog = ##Class(EMR.DAO.InstanceLog).doOpenByID(AEpisodeID,LogsId_"||"_subId)
		q:(objlog = "") 
		s action = $zcvt(objlog.Action,"U")
		s:(actions [ action) result = 1
		q:(actions [ action)
	}
	q result
}

}
