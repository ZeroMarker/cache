/// 名称:	EMR.DOC.BL.DocLog
/// 描述:	病历操作日志业务类(权限规则)
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DocLog Extends %RegisteredObject
{

/// Desc:       病历操作日志
/// Creator:    yejian
/// CreateDate: 2022-4-13
/// Input:      dtoLog 日志对象
/// OutPut:     成功 当前状态，
/// 			失败 -1^失败信息
/// 			argOutData json数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DocLog).AddOperateLog("","",.argOutData)
ClassMethod AddOperateLog(dtoLog As EMR.DOC.DTO.DocLog, aDocumentData) As %String
{
	s $zt = "errhandle"
	s res = "-1"
	q:((dtoLog.Action = "") || (aDocumentData = "")) "-1^状态或实例ID不能为空"
	s AEpisodeID = aDocumentData.EpisodeID.%Id()
	q:(aDocumentData = "") "-1^实例不能为空"

	s logID = ##class(EMR.DOC.BL.DocLog).CreateEMRLog(dtoLog,aDocumentData)
	q:($p(logID,"^",1) = "-1") res_"^CreateEMRLog^"_logID
    s emrLogId = $p(logID,"^",1)
    //增加语言ID
	s:(dtoLog.LangID="") dtoLog.LangID=20
	s logStatus = ##class(EMR.DOC.BL.DocLog).GetLogStatus(AEpisodeID,aDocumentData.%Id(),dtoLog.LangID)
	q logStatus
	
errhandle
	q res_"^"_$zerror
}

/// Desc:       创建日志 
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input：	    dtoILog:EMR.DOC.DTO.DocLog 日志对象
/// 		    pEcrecord:EMR.OP.ECRecord 
/// 		    pDocumentData:EMR.OP.DocumentData
/// Return：    EMRLogs的rowid  或者 -1(失败)
/// Debug：     ##class(EMR.DOC.BL.DocLog).CreateEMRLog("1","1","save","10.10.141.116","50","1","1")
ClassMethod CreateEMRLog(dtoILog As EMR.DOC.DTO.DocLog, pDocumentData) As %String
{
	s res = "-1"
    q:((dtoILog.Action = "")||(pDocumentData = "")) res	
	s $zt = "CreateEMRLogError"
	s AEpisodeID = pDocumentData.EpisodeID.%Id()
	
	//插入一条EMR.OP.docLog
	s docLog = ##Class(EMR.DAO.DocLog).doCreateInstance(AEpisodeID)
	s docLog.DocumentData = pDocumentData
	s docLog.Action = dtoILog.Action
	s docLog.EpisodeID = pDocumentData.EpisodeID
	s docLog.OperateDate = $P($h,",",1)
	s docLog.OperateTime = $P($h,",",2)
	s docLog.OperateMachineIP= dtoILog.OperateMachineIP
	;s docLog.InitStatus = initStatus ;initStatus值为空不用赋值
	s initStatus = $case(pDocumentData.EMRStatus,"":" ",:pDocumentData.EMRStatus.Code) //初始状态	
	s objFStatus = ##class(EMR.DOC.BL.DocLog).GetFinaStatus(initStatus,dtoILog.Action)
	q:(objFStatus="") res
	s docLog.FinalStatus = objFStatus
	s objOUser = ##class(User.SSUser).%OpenId(dtoILog.OperateUserID,0)
	s:(objOUser'="") docLog.OperateUserID = objOUser
	s:(objOUser'="") docLog.OperateUserName =  $tr(objOUser.SSUSRName,$c(13)_$c(10),"")
	s objLUser = ##class(User.SSUser).%OpenId(dtoILog.LoginUserID,0)
	s:(objLUser'="") docLog.LoginUserID = objLUser
	s:(objLUser'="") docLog.LoginUserName = $tr(objLUser.SSUSRName,$c(13)_$c(10),"")	
	s docLog.UserLoginLocID = dtoILog.UserLoginLocID
	s docLog.TemplateID = pDocumentData.TemplateID
	s docLog.EMRSignID = dtoILog.EMRSignID
	s docLog.ProductSource = dtoILog.ProductSource
	s docLog.EMRSignLogID = dtoILog.EMRSignLogID
	//更新文档最新状态
	if (objFStatus'=pDocumentData.EMRStatus)
	{
	    s pDocumentData.EMRStatus = objFStatus
	    s scdoc = pDocumentData.%Save()
	}
	s sc = docLog.%Save() 
	s:($$$ISOK(sc)) res = docLog.%Id()
	k docLog
	q res_"^"_sc
	 
CreateEMRLogError
    q res_"^"_$zerror
}

/// Desc:       取日志信息
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input：     pEpisodeId 就诊ID
///             pEmrDocId 目录展现结构挂模板一层的ID
///             pNum
/// Debug:      w ##Class(EMR.DOC.BL.DocLog).GetLogStatus(76,53,1)
ClassMethod GetLogStatus(aEpisodeID As %String, aDocumentID As %String, aLangid As %String = "20") As %DynamicObject
{
  	s resJson  = ##class(%DynamicObject).%New()
  	q:((aEpisodeID = "")||(aDocumentID = "")) resJson
  	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(aDocumentID)
    if (objDocument '= "")
  	{
  		//提取创建者信息
  		s creator = objDocument.CreateUser
  		s:(creator '= "") creator = creator.SSUSRName
  		s resJson.creator = $ZSTRIP(creator,"*C")
  		s resJson.happenDateTime =$case(objDocument.HappenDate,"":"",:$zd(objDocument.HappenDate,3)_" "_$zt(objDocument.HappenTime,1))
  		s resJson.createDateTime = $zd(objDocument.CreateDate,3)_" "_$zt(objDocument.CreateTime,1)
  		s lastdocLog = ..GetFinalLog(aEpisodeID,aDocumentID)
  		s resJson.operator = lastdocLog.OperateUserName
  		s resJson.operateDateTime = $case(lastdocLog.OperateDate,"":"",:$zd(lastdocLog.OperateDate, 3)_" "_$zt(lastdocLog.OperateTime, 1))
  		s resJson.ip = lastdocLog.OperateMachineIP
  		s action = lastdocLog.Action
  		s resJson.action = action
		s resJson.productSource = lastdocLog.ProductSource
  		s resJson.actionDesc = ##Class(EMR.DOC.BL.EMRAction).GetActionNameByCode(action,aLangid)
  		s resJson.signName = ##Class(EMR.DOC.BL.SignRole).GetSignName(action)  		
  		s status = $case(objDocument.EMRStatus,"":"",:objDocument.EMRStatus.Code)
  		s resJson.status = status
  		s resJson.statusDesc = ##Class(EMR.DOC.BL.EMRStatus).GetStatusNameByCode(status,aLangid)
  		s resJson.emrSignID = lastdocLog.EMRSignID
  	}
  	else
  	{
	  	s resJson.currState = " "
	  	s resJson.statusDesc = "未完成"
	}
	q resJson
}

/// Desc:       取最后一条日志数据
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      pEmrLogId  aDocumentID
/// Output:     EMR.OP.DocLog 记录
/// Debug:      ##Class(EMR.DOC.BL.DocLog).GetFinalLog(1)
ClassMethod GetFinalLog(AEpisodeID As %String, aDocumentID As %String)
{
	q:(aDocumentID = "")||(AEpisodeID="") ""
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(AEpisodeID)
	s subId = $o(@TILDocLog@("IdxDoc",aDocumentID,""),-1)
	q:(subId = "") ""
	s objLog = ##Class(EMR.DAO.DocLog).doOpenByID(AEpisodeID,subId)
    q objLog
}

/// Desc:		病历是否签名
/// Creator:	yejian
/// CreateDate:	2022-4-27
/// Input:      pEpisodeID 就诊科室
///             pEmrDocID 目录ID
///             pNum 病历序号
/// Debug:       w ##Class(EMR.DOC.BL.DocLog).HasRecordSign(76,53,1)
ClassMethod HasRecordSign(aEpisodeID As %String, aDocumentID As %String) As %String
{
	s result = 0
	q:(aEpisodeID = "")||(aDocumentID = "") result
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(aEpisodeID)
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
	s subId = ""
	for
	{
		s subId = $o(@TILDocLog@("IdxDoc",aDocumentID,subId))
		q:(subId = "")
		s objlog = ##Class(EMR.DAO.DocLog).doOpenByID(aEpisodeID,subId)
		q:(objlog = "") 
		s action = $zcvt(objlog.Action,"U")
		s:(actions [ action) result = 1
		q:(actions [ action)
	}
	q result
}

/// Desc:		判断病历日志中是否有某操作
/// Creator: 	yejian
/// CreateTime: 2022-8-11
/// input:		pEpisodeID 就诊号
/// 			pDdocumentID 文档ID
/// 			pAction(需要判断的病历操作)
/// return:		0--没有, 1--有
/// debug: 		w ##class(EMR.DOC.BL.DocLog).RecHasAction(76,"3","complete")
ClassMethod RecHasAction(pEpisodeID As %String, pDocumentID As %String, pAction As %String) As %String
{
	s $zt="errhandle"
	s result = 0
	q:(pEpisodeID = "")||(pDocumentID = "")||(pAction = "") result
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(pEpisodeID)
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(pDocumentID)
	q:(objDocument = "") result
	s:($d(@TILDocLog@("IdxDocActionDateTime",pDocumentID," "_$zcvt(pAction,"U")))>0) result = 1
    q result
errhandle
	q "0"
}

/// Desc: 		取出当前日志记录中第一个FinalStatus是pStatus的日志
/// Creator: 	yejian
/// CreateDate:	2014-10-14
/// input:		pEpisodeID 就诊号
/// 			pDocumentID 病历ID
/// 			pStatus 状态
/// OutPut:     reuslt EMRinstance.docLog
ClassMethod GetFirstLogByFinalStatus(pEpisodeID As %String, pDocumentID As %String, pStatus As %String)
{
	s result = ""
	q:(pEpisodeID = "")||(pDocumentID = "")||(pStatus = "") result
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(pEpisodeID)
	s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(pDocumentID)
	q:(objDocument = "") result
	
	s date = $o(@TILDocLog@("IdxDocFinalStatusDateTime",pDocumentID," "_$zcvt(pStatus,"U"),""))
	q:(date = "") result
	s time = $o(@TILDocLog@("IdxDocFinalStatusDateTime",pDocumentID," "_$zcvt(pStatus,"U"),date,""))
	q:(time = "") result
	s docLogId = $o(@TILDocLog@("IdxDocFinalStatusDateTime",pDocumentID," "_$zcvt(pStatus,"U"),date,time,"")) 
	q:(docLogId = "") result
	s result = ##Class(EMR.DAO.DocLog).doOpenByID(pEpisodeID,docLogId)
	q result
}

/// Desc: 		取当前log明细的当前操作
/// Creator:	yejian
/// CreateDate: 2014-11-04
/// input:		pEpisodeID 就诊号
/// 			pDocumentID 病历ID
/// OutPut:     reuslt 病历创建用户ID
/// Debug:      w ##Class(EMR.DOC.BL.DocLog).GetCurrentdocLog(76,616,1)
ClassMethod GetCurrentInstanceLog(pEpisodeID As %String, pDocumentID As %String) As %String
{
	s result = ""
	q:(pEpisodeID = "")||(pDocumentID = "") result
	s TILDocLog = ##Class(EMR.DAO.DocLog).GetTureIndexLocation(pEpisodeID)
	s intanceLosgId = $o(@TILDocLog@("IdxDoc",pDocumentID,""),-1)
	q:(intanceLosgId = "") result
	s objDocumentLog = ##Class(EMR.DAO.DocLog).doOpenByID(pEpisodeID,intanceLosgId)
	q:(objDocumentLog = "") result
	s result = objDocumentLog
	q result
}

/// Desc:       取得病历操作后状态
/// Creator:     yejian
/// Createdate:  2022-4-20
/// Input:      aInitStatus 初始状态（创建为 " "）
/// 			aAction	操作状态
/// Return:     病历当前状态Code(EMRmeta.EMRStatus)
/// Debug:      w ##Class(EMR.DOC.BL.DocLog).GetFinaStatus(76,33,1)     
ClassMethod GetFinaStatus(aInitStatus As %String, aAction As %String) As CF.EMR.DOC.EMRStatus
{
	q:(aAction ="") "-1^操作状态Action不能为空"
	s finalStatusID = ##class(EMR.DOC.BL.EMRActStatusCfg).GetPostStatus(aInitStatus, aAction)	//最终状态
	q:(finalStatusID="") "-1^获取操作后的状态失败"
	s objFStatus = ##class(CF.EMR.DOC.EMRStatus).%OpenId(finalStatusID)
	q objFStatus
}

}
