/// Descript:	操作日志
/// Creator:    bianshuai
/// CreatDate:  2016-09-26
Class web.DHCCM.EMRservice.BL.BLEMRLogs Extends %RegisteredObject
{

/// Creator:    Candyxu
/// CreateDate: 2014-03-19
/// Desc:       增加或修改日志
/// Input:      pAction: 操作类型
///             pLoginUserId:登录用户ID
///             pOperUserId:操作用户ID
///             pIntanceId:实例ID
///             pIP:操作IP
/// return:     result 0: 失败  当前状态
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).AddOperateLog("Save","14||3",38,"127.0.0.1")
ClassMethod AddOperateLog(pAction As %String, pIntanceId As %String, pLoginUserId As %String, pOperUserId As %String, pIp As %String, pEMRSignId As %String = "")
{
	s $zt = "errhandle"
	s result = 0
	q:((pAction = "") || (pIntanceId = "")) result
	s objInstanceData = ##Class(User.DHCPHInstanceData).%OpenId(pIntanceId)
	q:(objInstanceData = "") result
	s emrNum = objInstanceData.ListNo
	s ecrecordId = $p(pIntanceId,"||",1)
	s objEcrecord = ##Class(User.DHCPHECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	s docId = objEcrecord.ChartItemID
	s episodeId = objEcrecord.EpisodeID
	s action = pAction
	s logID =..GetLogID(episodeId,docId,emrNum)
	if (logID = "")		//若为保存第一个界面模板
	{
		s logID = ..CreateEMRLog(action,objEcrecord,objInstanceData,pLoginUserId,pOperUserId,pIp,pEMRSignId)
		q:(logID = "0") result
	}
	else
	{
		s flag = ..UpdateEMRLogByID(logID,action,pLoginUserId,pOperUserId,pIp,objEcrecord,objInstanceData,pEMRSignId)
		q:(flag = "0") result
	}	
	s logStatus = ..GetLogStatus(objEcrecord.EpisodeID,objEcrecord.ChartItemID,emrNum)
	k objEcrecord,objInstanceData
	q logStatus
	
errhandle
	q result
}

/// Creator:     Candyxu
/// Createdate:  2014-3-20
/// Desc:        根据EpisodeID、EMRStructID、EMRNum取得病历日志记录的ID
/// Input:       pEpisodeID 就诊号
///              pEMRDocID 目录展现结构挂模板一层的ID
///              pEMRNum: EMRNum, 对唯一病历其值为1,对可重复病历,其值为对应实例数据的ListNo
/// Return:      RowID
/// Others:      
ClassMethod GetLogID(pEpisodeID As %String, pEMRDocID As %String, pEMRNum As %String) As %String
{
	s rowId = ""
	q:((pEpisodeID ="")||(pEMRDocID = "")||(pEMRNum = "")) rowId
	s rowId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
	q rowId
}

/// Creator:    Candyxu
/// Createdate: 2014-3-19
/// Desc:       创建日志 
/// Input：	    pAction:操作类型
/// 		    pObjEcrecord:EMRinstance.ECRecord
/// 		    pObjInstanceData:EMRinstance.InstanceData
/// 		    pOperUserId:操作用户
/// 		    pIp:操作IP
/// Return：    EMRLogs的rowid  或者 0(失败)
/// Debug：     ##class(EMRservice.BL.BLEMRLogs).CreateEMRLog("1","1","save","10.10.141.116","50","1","1")
ClassMethod CreateEMRLog(pAction As %String, pObjEcrecord As EMRinstance.ECRecord, pObjInstanceData As EMRinstance.InstanceData, pLoginUserId As %String, pOperUserId As %String, pIp As %String, pEMRSignId As %String) As %String
{
	s result = 0
    q:((pAction = "")||(pObjEcrecord = "")||(pObjInstanceData = "")) result	

	s objEMRLogs = ##class(User.DHCPHEMRLogs).%New()
	s objEMRLogs.EpisodeID = pObjEcrecord.EpisodeID
	s objEMRLogs.EMRDocID = pObjEcrecord.ChartItemID
	s objEMRLogs.EMRNum = pObjInstanceData.ListNo
	s objEMRLogs.CreateUserID = pObjInstanceData.CreateUser
	s objEMRLogs.HappenDate = pObjInstanceData.HappenDate
	s objEMRLogs.HappenTime = pObjInstanceData.HappenTime
	s objEMRLogs.CreateDate = pObjInstanceData.CreateDate
	s objEMRLogs.CreateTime = pObjInstanceData.CreateTime
	s initStatus = " "	//初始状态	
	s finalStatus = ##class(EMRservice.BL.BLEMRActStatusCfg).GetPostStatus(initStatus, pAction)	//最终状态
	q:(finalStatus="") result
	s objEMRLogs.EMRStatus = finalStatus
	
	//插入一条EMRinstance.InstanceLog
	s instanceLog = ##class(User.DHCPHInstanceLog).%New()
	s instanceLog.ParRef = objEMRLogs
	s instanceLog.Action = pAction
	s instanceLog.OperateDate = $P($h,",",1)
	s instanceLog.OperateTime = $P($h,",",2)
	s instanceLog.OperateMachineIP= pIp
	s instanceLog.InitStatus = initStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = pOperUserId
	s instanceLog.LoginUserID = pLoginUserId
	s instanceLog.TemplateID = pObjInstanceData.TemplateID
	s instanceLog.EMRSignID = pEMRSignId
	s operUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pOperUserId)
	s operUserName = $tr(operUserName,$c(13),""),operUserName = $tr(operUserName,$c(10),"")
	s instanceLog.OperateUserName = operUserName
	s loginUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pLoginUserId)
	s loginUserName = $tr(loginUserName,$c(13),""),loginUserName = $tr(loginUserName,$c(10),"")
	s instanceLog.LoginUserName = loginUserName	
    s $zt = "ECRecordErrorHandler"
	Tstart
	s scEMRLog = objEMRLogs.%Save() 
	if ($$$ISOK(scEMRLog))
	{
       s scInstanceLog = instanceLog.%Save() 
       if ($$$ISOK(scInstanceLog))
       {
	      TCOMMIT
	      s result = objEMRLogs.%Id()
	   }else
	   {
		  Trollback
	   }
	   k objEMRLogs
	   k instanceLog
	}
	quit result
	 
ECRecordErrorHandler
    Trollback
    quit:result
}

/// Creator:    Candyxu
/// Createdate: 2014-3-19
/// Desc:       更新操作日志
/// Input:      pLogID EMRinstance.EMRLogs的rowid
///             pAction 操作类型
///             
/// return:     result 0:失败  成功:rowID
/// Debug:      w ##class(EMRservice.BL.BLEMRLogs).UpdateEMRLogByID("61","Reference","10.10.141.115","5972","Single","62236","56140",826)
ClassMethod UpdateEMRLogByID(pLogID As %String, pAction As %String, pLoginUserID As %String, pOperUserID As %String, pIP As %String, pObjEcrecord As EMRinstance.ECRecord, pObjInstanceData As EMRinstance.InstanceData, pEMRSignId As %String) As %String
{
	s result = 0
	q:((pLogID = "")||(pAction = "")||(pObjEcrecord = "")||(pObjInstanceData = "")) result
	s objEMRLogs = ##class(User.DHCPHEMRLogs).%OpenId(pLogID)
	q:(objEMRLogs="") result
	//更新操作后的病历状态
	s initStatus = objEMRLogs.EMRStatus	  //初始状态	
	s finalStatus = ##class(EMRservice.BL.BLEMRActStatusCfg).GetPostStatus(initStatus, pAction)	  //最终状态
	q:(finalStatus = "") result
	s objEMRLogs.EMRStatus = finalStatus
	if (pObjEcrecord.ChartItemType = "Multiple")
	{
		s objEMRLogs.HappenDate = pObjInstanceData.HappenDate
		s objEMRLogs.HappenTime = pObjInstanceData.HappenTime
	}	
	//插入一条EMRinstance.InstanceLog
	s objInstanceLog = ##class(User.DHCPHInstanceLog).%New()
	s objInstanceLog.ParRef = objEMRLogs
	s objInstanceLog.Action = pAction
	s objInstanceLog.OperateDate = $P($h,",",1)
	s objInstanceLog.OperateTime = $P($h,",",2)
	s objInstanceLog.OperateMachineIP = pIP
	s objInstanceLog.InitStatus = initStatus
	s objInstanceLog.FinalStatus = finalStatus
	s objInstanceLog.OperateUserID = pOperUserID
	s objInstanceLog.LoginUserID = pLoginUserID
	s objInstanceLog.TemplateID = pObjInstanceData.TemplateID
	s objInstanceLog.EMRSignID = pEMRSignId
	s operUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pOperUserID)
	s operUserName = $tr(operUserName,$c(13),""),operUserName = $tr(operUserName,$c(10),"")
	s objInstanceLog.OperateUserName = operUserName
	s loginUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pLoginUserID)
	s loginUserName = $tr(loginUserName,$c(13),""),loginUserName = $tr(loginUserName,$c(10),"")
	s objInstanceLog.LoginUserName = loginUserName
		
    s $zt = "ECRecordErrorHandler"
	Tstart
	s scEMRLog = objEMRLogs.%Save() 
	if ($$$ISOK(scEMRLog))
	{
       s scobjInstanceLog = objInstanceLog.%Save() 
       if ($$$ISERR(scobjInstanceLog))
       {
	       Trollback
	       q result
	   }
	   TCOMMIT
	   s result = objEMRLogs.%Id()
	   k objEMRLogs
	   k objInstanceLog
	}
	quit result
	 
ECRecordErrorHandler
    Trollback
    quit:result
}

/// Creator:    Candyxu
/// Createdate: 2014-3-20
/// Desc:       取得病历当前状态
/// Input:      pEpisodeID 就诊ID
///             pEMRDocID 目录展现结构挂模板一层的ID
///             pEMRNum 病历顺序号
/// Return:     病历当前状态Code(EMRmeta.EMRStatus)
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatus(76,33,1)     
ClassMethod GetEMRStatus(pEpisodeID As %String, pEMRDocID As %String, pEMRNum As %String) As %String
{
	s status = ""
	q:((pEpisodeID ="")||(pEMRDocID = "")||(pEMRNum = "")) status
	s rowId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
    s objLog = ##Class(User.DHCPHEMRLogs).%OpenId(rowId)
    q:(rowId = "") status
    s status = objLog.EMRStatus
	q status
}

/// Creator:    Candyxu
/// CreateDate: 2014-3-19
/// Desc:       取最后一条日志数据
/// Input:      pEmrLogId  EMRinstance.EMRLogs rowId
/// Output:     EMRinstance.InstanceLog 记录
/// Debug:      ##Class(EMRservice.BL.BLEMRLogs).GetFinalLog(1)
ClassMethod GetFinalLog(pEmrLogId As %String) As EMRinstance.InstanceLog
{
	q:(pEmrLogId = "") ""
	s subId = $o(^DHCPHI.InstanceLogI("IdxParRef",pEmrLogId,""),-1)
	q:(subId = "") ""
	s rowId = pEmrLogId_"||"_subId
	s objLog = ##Class(User.DHCPHInstanceLog).%OpenId(rowId)
    q objLog
}

/// Creator:    Candyxu
/// CreateTime: 2014-3-19
/// Desc:       取日志信息
/// Input：     pEpisodeId 就诊ID
///             pEmrDocId 目录展现结构挂模板一层的ID
///             pNum
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(76,53,1)
ClassMethod GetLogStatus(pEpisodeId As %String, pEmrDocId As %String, pNum As %String) As %String
{
  	s logStatus = ""
  	q:((pEpisodeId = "")||(pEmrDocId = "")||(pNum = "")) logStatus
  	s logID = ..GetLogID(pEpisodeId, pEmrDocId, pNum) 
  	s objLogs = ##class(User.DHCPHEMRLogs).%OpenId(logID)
  	s happenDate = "",happenTime = "",creator = "",operator = "",operateDate = "",operateTime = ""
  	s ip = "",action = "",actionDesc = "",status = "",statusDesc = "",signName = ""
  	if (objLogs '= "")
  	{
  		//提取创建者信息
  		s creator = objLogs.CreateUserID
  		s happenDate = $zd(objLogs.HappenDate,3)
  		s happenTime = $zt(objLogs.HappenTime,1)
  		s:(creator '= "") creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(creator)
  		s creator = $ZSTRIP(creator,"*C")
  		s lastInstanceLog = ..GetFinalLog(logID)
  		s operator = lastInstanceLog.OperateUserName
  		s operateDate = $zd(lastInstanceLog.OperateDate, 3)
  		s operateTime = $zt(lastInstanceLog.OperateTime, 1)
  		s ip = lastInstanceLog.OperateMachineIP
  		s action = lastInstanceLog.Action
  		s actionDesc = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
  		s signName = ##Class(EMRservice.BL.BLSignRole).GetSignName(action)  		
  		s status = ..GetEMRStatus(pEpisodeId, pEmrDocId, pNum)
  		s statusDesc = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(status)
  	}
  	else
  	{
	  	s currState = " "
	  	s statusDesc = "未完成"
	}
	s logStatus = creator_"^"_happenDate_"^"_happenTime_"^"_operator_"^"_operateDate_"^"_operateTime
	s logStatus = logStatus_"^"_ip_"^"_action_"^"_actionDesc_"^"_status_"^"_statusDesc_"^"_signName
  	q logStatus
}

/// Creator:    Candyxu
/// CreateDate: 2014-3-20
/// Desc:       病历日志明细
/// Input:      pEpisodeId 就诊ID
///           	pEmrDocId 目录展现结构挂模板一层的ID
///             pNum 顺序号
/// Debug:      d ##class(%ResultSet).RunQuery("EMRservice.BL.BLEMRLogs","GetDetialLog",76,35,1)
Query GetDetialLog(pEpisodeId As %String, pEmrDocId As %String, pNum As %String) As %Query(ROWSPEC = "OrderID:%String, LoginUser:%String,OperUser:%String, OperDate:%String, OperTime:%String, MachineIP:%String, Action:%String, TplName:%String, TplCreateDate:%String, TplCreateTime:%String")
{
}

ClassMethod GetDetialLogExecute(ByRef qHandle As %Binary, pEpisodeId As %String, pEmrDocId As %String, pNum As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	s eprLogId = ..GetLogID(pEpisodeId,pEmrDocId,pNum)
 	q:(eprLogId = "") $$$OK
 	s logSubId = ""
 	for
 	{
    	s logSubId = $o(^DHCPHI.InstanceLogI("IdxParRef",eprLogId,logSubId))
    	q:(logSubId = "")
    	s rowId = eprLogId_"||"_logSubId
    	s objInstanceLog = ##Class(User.DHCPHInstanceLog).%OpenId(rowId)
    	continue:(objInstanceLog = "")
    	s operUserName = objInstanceLog.OperateUserName
    	s loginUserName = objInstanceLog.LoginUserName
    	s operDate = objInstanceLog.OperateDate
    	s:(operDate '= "") operDate = $zd(operDate,3)
    	s operTime = objInstanceLog.OperateTime
    	s:(operTime '= "") operTime = $zt(operTime,1)
    	s machineIP = objInstanceLog.OperateMachineIP
    	s action = objInstanceLog.Action
    	s actionName = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
    	s tplName = "",tplCreateDate = "",tplCreateTime = ""
		s ecrecordId = $o(^DHCCMI.ECRecordI("IdxEpisodeIDChartItemID"," "_pEpisodeId," "_pEmrDocId,""))
		continue:(ecrecordId = "")
		s objInstanceData = ##Class(User.DHCPHInstanceData).%OpenId(ecrecordId_"||"_pNum)
		continue:(objInstanceData = "")
		s tplName = objInstanceData.Title
		s tplCreateDate = $case(objInstanceData.HappenDate,"":"",:$zd(objInstanceData.HappenDate,3))
		s tplCreateTime = $case(objInstanceData.HappenTime,"":"",:$zt(objInstanceData.HappenTime))
		s data = $lb(ind,loginUserName,operUserName,operDate,operTime,machineIP,actionName,tplName,tplCreateDate,tplCreateTime)
		s ^CacheTemp(repid,ind) = data
		s ind=ind+1 
 	}
	Quit $$$OK
}

ClassMethod GetDetialLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetialLogExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetialLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetialLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// Desc:		判断病历日志中是否有某操作
/// Creator: 	Candy
/// CreateTime: 2014-10-13
/// input:		pEpisodeID 就诊号
/// 			pDocID 目录展现结构DOCID
/// 			pEMRNum Numer
/// 			pAction(需要判断的病历操作)
/// return:		0--没有, 1--有
/// debug: 		w ##class(EMRservice.BL.BLEMRLogs).RecHasAction(76,"1||1","complete")
ClassMethod RecHasAction(pEpisodeID As %String, pInstanceID As %String, pAction As %String) As %String
{
	s $zt="errhandle"
	s result = 0
	q:(pEpisodeID = "")||(pInstanceID = "")||(pAction = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(pInstanceID)
	q:(objInstance = "") result
	s EMRLogsId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_objInstance.TheECRecord.ChartItemID,objInstance.ListNo,""))
	q:(EMRLogsId = "") result
	s:($d(^DHCPHI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(pAction,"U")))>0) result = 1
    q result
errhandle
	q "0"
}

/// Desc:		病历是否签名
/// Creator:		Candy
/// CreateDate:	2015-8-10
/// Input:       pEpisodeID 就诊科室
///             pEmrDocID 目录ID
///             pNum 病历序号
/// Debug:       w ##Class(EMRservice.BL.BLEMRLogs).HasRecordSign(76,53,1)
ClassMethod HasRecordSign(pEpisodeID As %String, pEmrDocID As %String, pNum As %String) As %String
{
	s result = 0
	q:(pEpisodeID = "")||(pEmrDocID = "")||(pNum = "") result
	s actions = ""
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.SignRoleD(rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.SignRole).%OpenId(rowId)
		continue:(obj = "")
		s actions = actions_$lb($zcvt(obj.ActionCode,"U"))
	}
	s LogsId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEmrDocID,pNum,""))
	q:(LogsId = "") result
	s subId = $o(^DHCPHI.InstanceLogI("IdxParRef",LogsId,""),-1)
	s objlog = ##Class(User.DHCPHInstanceLog).%OpenId(LogsId_"||"_subId)
	q:(objlog = "") result
	s action = $zcvt(objlog.Action,"U")
	s:(actions [ action) result = 1
	q result
}

/// Desc: 		取出当前日志记录中第一个FinalStatus是pStatus的日志
/// Creator: 	Candy
/// CreateDate:	2014-10-14
/// input:		pEpisodeID 就诊号
/// 			argInstanceID 病历ID
/// 			pStatus 状态
/// OutPut:     reuslt EMRinstance.InstanceLog
ClassMethod GetFirstLogByFinalStatus(pEpisodeID As %String, pInstanceID As %String, pStatus As %String) As EMRinstance.InstanceLog
{
	s result = ""
	q:(pEpisodeID = "")||(pInstanceID = "")||(pStatus = "") result
	s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(pInstanceID)
	q:(objInstance = "") result
	s logId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_objInstance.TheECRecord.ChartItemID,objInstance.ListNo,"")) 
	q:(logId = "") result
	s objLog = ##Class(User.DHCPHEMRLogs).%OpenId(logId)
	q:(objLog = "") result
	
	s date = $o(^DHCPHI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),""))
	q:(date = "") result
	s time = $o(^DHCPHI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),date,""))
	q:(time = "") result
	s instanceLogId = $o(^DHCPHI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),date,time,"")) 
	q:(instanceLogId = "") result
	s result = ##Class(User.DHCPHInstanceLog).%OpenId(instanceLogId)
	q result
}

/// Desc: 		取当前log
/// Creator:	Candy
/// CreateDate: 2014-10-31
/// input:		pEpisodeID 就诊号
/// 			pDocID 目录展现结构DOCID
/// 			pEMRNum Numer
/// 			pAction(需要判断的病历操作)
/// OutPut:     reuslt 病历创建用户ID
/// Debug:	    w ##Class(EMRservice.BL.BLEMRLogs).GetCurrentLog(76,616,1)
ClassMethod GetCurrentLog(pEpisodeID As %String, pDocID As %String, pEMRNum As %String)
{
	s result = ""
	q:(pEpisodeID = "")||(pDocID = "")||(pEMRNum = "") result
	s logId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pDocID,pEMRNum,"")) 
	q:(logId = "") result
	s objLog = ##Class(User.DHCPHEMRLogs).%OpenId(logId)
	q:(objLog = "") result
	s result = objLog
	q result
}

/// Desc: 		取当前log明细的当前操作
/// Creator:	Candy
/// CreateDate: 2014-11-04
/// input:		pEpisodeID 就诊号
/// 			pDocID 目录展现结构DOCID
/// 			pEMRNum Numer
/// 			pAction(需要判断的病历操作)
/// OutPut:     reuslt 病历创建用户ID
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetCurrentInstanceLog(76,616,1)
ClassMethod GetCurrentInstanceLog(pEpisodeID As %String, pDocID As %String, pEMRNum As %String) As %String
{
	s result = ""
	q:(pEpisodeID = "")||(pDocID = "")||(pEMRNum = "") result
	s logId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pDocID,pEMRNum,"")) 
	q:(logId = "") result
	s intanceLosgId = $o(^DHCPHI.InstanceLogI("IdxParRef",logId,""),-1)
	q:(intanceLosgId = "") result
	s objInstanceLog = ##Class(User.DHCPHInstanceLog).%OpenId(logId_"||"_intanceLosgId)
	q:(objInstanceLog = "") result
	s result = objInstanceLog
	q result
}

/// Debug: w ##Class(EMRservice.BL.BLEMRLogs).HasRecordAction(3263,230,"PRINT") 
/// Desc：判断门诊诊断证明是否打印过
ClassMethod HasRecordAction(pEpisodeID As %String, pEMRDocID As %String, Action As %String) As %String
{
    s result = "0",resultinfo = ""
    q:((pEpisodeID ="")||(pEMRDocID = "")||(Action = "")) result
    s PaadmStr = "",PaadmRowID = ""
    s PapmiDR = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(pEpisodeID)
    for  
    {
	s PaadmRowID = $O(^PAPERdr(PapmiDR,"ADM","O",PaadmRowID))
	q:(PaadmRowID = "")
	s CurDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(PaadmRowID,"")
	s CurDeptDesc = $P(CurDept,"^",3)
	s AdmDoctor = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(PaadmRowID,"")
	s AdmDoctor = $P(AdmDoctor,"^",3)
   	
    s pEMRNum = ""
    s pEMRNum = $o(^DHCPHI.EMRLogsI("IdxMain"," "_PaadmRowID," "_pEMRDocID,""),-1)
    continue:(pEMRNum="")
    s rowId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_PaadmRowID," "_pEMRDocID,pEMRNum,""))
    continue:(rowId = "")
    s Date = "",Time=""
    for 
    {
    s Date = $o(^DHCPHI.InstanceLogI("IdxParRefActionDateTime",rowId," "_Action,Date))
    s CurDate = +$H
    q:(Date="")||(CurDate-Date>31)
    for 
    	{
      	s Time = $o(^DHCPHI.InstanceLogI("IdxParRefActionDateTime",rowId," "_Action,Date,Time))
    	q:(Time="")
    	;b ;1
   	    	s result = result + 1
   	    	;s resultinfo = "科室:"_CurDeptDesc_" 医生:"_AdmDoctor_" "_resultinfo
   	    	s:(resultinfo'="") resultinfo = resultinfo_$C(1)_"科室:"_CurDeptDesc_" 医生:"_AdmDoctor_" "_$ZD(Date,3)_" "_$ZT(Time)
   	    	s:(resultinfo="") resultinfo = "科室:"_CurDeptDesc_" 医生:"_AdmDoctor_" "_$ZD(Date,3)_" "_$ZT(Time)
   	    	b ;1
    	}
    }
    }
    q result_"^"_resultinfo
}

/// Debug: w ##Class(EMRservice.BL.BLEMRLogs).HasRecordAction1(3263,228,"PRINT") 
/// Desc：判断门诊病历是否打印过
ClassMethod HasRecordAction1(pEpisodeID As %String, pEMRDocID As %String, Action As %String) As %String
{
    s result = "0",resultinfo = ""
    q:((pEpisodeID ="")||(pEMRDocID = "")||(Action = "")) result
	
	s CurDept = ##Class(EMRservice.HISInterface.PatientInfoAssist).DisDept(pEpisodeID,"")
	s CurDeptDesc = $P(CurDept,"^",3)
	s AdmDoctor = ##Class(EMRservice.HISInterface.PatientInfoAssist).AdmDoctor(pEpisodeID,"")
	s AdmDoctor = $P(AdmDoctor,"^",3)
   	
    s pEMRNum = ""
    s pEMRNum = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,""),-1)
    q:(pEMRNum="") result
    s rowId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") result
    s Date = "",Time=""
    for 
    {
    s Date = $o(^DHCPHI.InstanceLogI("IdxParRefActionDateTime",rowId," "_Action,Date))
    q:(Date="")
    for 
    	{
      	s Time = $o(^DHCPHI.InstanceLogI("IdxParRefActionDateTime",rowId," "_Action,Date,Time))
    	q:(Time="")
   	    	s result = result + 1
   	    	s:(resultinfo'="") resultinfo = resultinfo_$C(1)_"科室:"_CurDeptDesc_" 医生:"_AdmDoctor_" "_$ZD(Date,3)_" "_$ZT(Time)
   	    	s:(resultinfo="") resultinfo = "科室:"_CurDeptDesc_" 医生:"_AdmDoctor_" "_$ZD(Date,3)_" "_$ZT(Time)
   	    	b ;1
    	}
    }
    q result_"^"_resultinfo
}

/// Debug: w ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatusNew(1421,230)
ClassMethod GetEMRStatusNew(pEpisodeID As %String, pEMRDocID As %String) As %String
{
    s status = "unsave"
    q:((pEpisodeID ="")||(pEMRDocID = "")) status
    s pEMRNum = ""
    s pEMRNum = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,""),-1)
    q:(pEMRNum="") status
    s rowId = $o(^DHCPHI.EMRLogsI("IdxMain"," "_pEpisodeID," "_pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
    s objLog = ##Class(User.DHCPHEMRLogs).%OpenId(rowId)
    q:(rowId = "") status
    s status = objLog.EMRStatus
    q status
}

}
