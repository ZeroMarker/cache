Class EMRservice.BL.BLEMRLogs Extends %RegisteredObject
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
ClassMethod AddOperateLog(pAction As %String, pIntanceId As %String, pLoginUserId As %String, pOperUserId As %String, pIp As %String, pEMRSignId As %String = "", pUserLoc As %String, pProductSource As %String = "", pEMRSignLogId As %String = "")
{
	s $zt = "errhandle"
	s result = 0
	q:((pAction = "") || (pIntanceId = "")) result
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(pIntanceId)
	q:(objInstanceData = "") result
	s emrNum = objInstanceData.ListNo
	s ecrecordId = $p(pIntanceId,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	s docId = objEcrecord.RealChartItemID
	s episodeId = objEcrecord.RealEpisodeID
	s action = pAction
	s logID =..GetLogID(episodeId,docId,emrNum)
    s emrLogId = ""
	if (logID = "")		//若为保存第一个界面模板
	{
		s logID = ..CreateEMRLog(action,objEcrecord,objInstanceData,pLoginUserId,pOperUserId,pIp,pEMRSignId,pUserLoc,pProductSource,pEMRSignLogId)
		q:($p(logID,"^",1) = "0") result_"^CreateEMRLog^"_logID
        s emrLogId = $p(logID,"^",1)
	}
	else
	{
		s flag = ..UpdateEMRLogByID(logID,action,pLoginUserId,pOperUserId,pIp,objEcrecord,objInstanceData,pEMRSignId,pUserLoc,pProductSource,pEMRSignLogId)
		q:($p(flag,"^",1) = "0") result_"^UpdateEMRLog^"_flag
        s emrLogId = $p(flag,"^",1)
	}	
    if (##Class(EMRservice.SystemParameter).IsSaveEMRLogSectionData() = "Y")
    {
        s sectionStatus = ..SaveEMRLogSectionData(pIntanceId,emrLogId)
        q:($p(sectionStatus,"^",1) = "0") result_"^SaveEMRLogSectionData^"_sectionStatus
	}	
	s logStatus = ..GetLogStatus(objEcrecord.RealEpisodeID,objEcrecord.RealChartItemID,emrNum)
	k objEcrecord,objInstanceData
	q logStatus
	
errhandle
	q result_"^"_$zerror
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
	s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pEMRDocID,pEMRNum,""))
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
ClassMethod CreateEMRLog(pAction As %String, pObjEcrecord As EMRinstance.ECRecord, pObjInstanceData As EMRinstance.InstanceData, pLoginUserId As %String, pOperUserId As %String, pIp As %String, pEMRSignId As %String, pUserLoc As %String, pProductSource As %String = "", pEMRSignLogId As %String = "") As %String
{
	s result = 0
    q:((pAction = "")||(pObjEcrecord = "")||(pObjInstanceData = "")) result	
	s $zt = "CreateEMRLogError"
	s objEMRLogs = ##class(EMRinstance.EMRLogs).%New()
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
	s instanceLog = ##class(EMRinstance.InstanceLog).%New()
	s instanceLog.ParRef = objEMRLogs
	s instanceLog.Action = pAction
	s instanceLog.OperateDate = $P($h,",",1)
	s instanceLog.OperateTime = $P($h,",",2)
	s instanceLog.OperateMachineIP= pIp
	s instanceLog.InitStatus = initStatus
	s instanceLog.FinalStatus = finalStatus
	s instanceLog.OperateUserID = ##class(User.SSUser).%OpenId(pOperUserId)
	s instanceLog.LoginUserID = pLoginUserId
	s instanceLog.UserLoginLocID = pUserLoc
	s instanceLog.TemplateID = pObjInstanceData.TemplateID
	s instanceLog.EMRSignID = pEMRSignId
	s instanceLog.ProductSource = pProductSource
	s instanceLog.EMRSignLogID = pEMRSignLogId
	s operUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pOperUserId)
	s operUserName = $tr(operUserName,$c(13),""),operUserName = $tr(operUserName,$c(10),"")
	s instanceLog.OperateUserName = operUserName
	s loginUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pLoginUserId)
	s loginUserName = $tr(loginUserName,$c(13),""),loginUserName = $tr(loginUserName,$c(10),"")
	s instanceLog.LoginUserName = loginUserName	
    
	s scEMRLog = objEMRLogs.%Save() 
	s:($$$ISOK(scEMRLog)) result = objEMRLogs.%Id()
	k objEMRLogs
	k instanceLog
	q result_"^"_scEMRLog
	 
CreateEMRLogError
    q result_"^"_$zerror
}

/// Creator:    Candyxu
/// Createdate: 2014-3-19
/// Desc:       更新操作日志
/// Input:      pLogID EMRinstance.EMRLogs的rowid
///             pAction 操作类型
///             
/// return:     result 0:失败  成功:rowID
/// Debug:      w ##class(EMRservice.BL.BLEMRLogs).UpdateEMRLogByID("61","Reference","10.10.141.115","5972","Single","62236","56140",826)
ClassMethod UpdateEMRLogByID(pLogID As %String, pAction As %String, pLoginUserID As %String, pOperUserID As %String, pIP As %String, pObjEcrecord As EMRinstance.ECRecord, pObjInstanceData As EMRinstance.InstanceData, pEMRSignId As %String, pUserLoc As %String, pProductSource As %String = "", pEMRSignLogId As %String = "") As %String
{
	s result = 0
	q:((pLogID = "")||(pAction = "")||(pObjEcrecord = "")||(pObjInstanceData = "")) result
	
	s $zt = "UpdateEMRLogError"

	s objEMRLogs = ##class(EMRinstance.EMRLogs).%OpenId(pLogID)
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
	s objInstanceLog = ##class(EMRinstance.InstanceLog).%New()
	s objInstanceLog.ParRef = objEMRLogs
	s objInstanceLog.Action = pAction
	s objInstanceLog.OperateDate = $P($h,",",1)
	s objInstanceLog.OperateTime = $P($h,",",2)
	s objInstanceLog.OperateMachineIP = pIP
	s objInstanceLog.InitStatus = initStatus
	s objInstanceLog.FinalStatus = finalStatus
	s objInstanceLog.OperateUserID = ##class(User.SSUser).%OpenId(pOperUserID)
	s objInstanceLog.LoginUserID = pLoginUserID
	s objInstanceLog.UserLoginLocID = pUserLoc
	s objInstanceLog.TemplateID = pObjInstanceData.TemplateID
	s objInstanceLog.EMRSignID = pEMRSignId
	s objInstanceLog.ProductSource = pProductSource
	s objInstanceLog.EMRSignLogID = pEMRSignLogId
	s operUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pOperUserID)
	s operUserName = $tr(operUserName,$c(13),""),operUserName = $tr(operUserName,$c(10),"")
	s objInstanceLog.OperateUserName = operUserName
	s loginUserName = ##class(EMRservice.BL.BLPowerUser).GetUserName(pLoginUserID)
	s loginUserName = $tr(loginUserName,$c(13),""),loginUserName = $tr(loginUserName,$c(10),"")
	s objInstanceLog.LoginUserName = loginUserName
		
	s scEMRLog = objEMRLogs.%Save() 
	s:($$$ISOK(scEMRLog)) result = objEMRLogs.%Id()
	k objEMRLogs
	k objInstanceLog
	q result_"^"_scEMRLog
	 
UpdateEMRLogError
    q result_"^"_$zerror
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
	s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pEMRDocID,pEMRNum,""))
    q:(rowId = "") status
    s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(rowId)
    q:(objLog = "") status
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
	s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",pEmrLogId,""),-1)
	q:(subId = "") ""
	s rowId = pEmrLogId_"||"_subId
	s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(rowId)
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
  	s objLogs = ##class(EMRinstance.EMRLogs).%OpenId(logID)
  	s happenDate = "",happenTime = "",creator = "",operator = "",operateDate = "",operateTime = "",happenDateCache="",happenTimeCache="",createDateCache="",createTimeCache=""
  	s ip = "",action = "",actionDesc = "",status = "",statusDesc = "",signName = "",productSource = "",emrSignID = ""
  	if (objLogs '= "")
  	{
  		//提取创建者信息
  		s creator = objLogs.CreateUserID
  		s happenDate = $zd(objLogs.HappenDate,3)
  		s happenTime = $zt(objLogs.HappenTime,1)
		s happenDateCache = objLogs.HappenDate
  		s happenTimeCache = objLogs.HappenTime
  		s createDateCache = objLogs.CreateDate
  		s createTimeCache = objLogs.CreateTime
  		s:(creator '= "") creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(creator)
  		s creator = $ZSTRIP(creator,"*C")
  		s lastInstanceLog = ..GetFinalLog(logID)
  		s operator = lastInstanceLog.OperateUserName
  		s operateDate = $zd(lastInstanceLog.OperateDate, 3)
  		s operateTime = $zt(lastInstanceLog.OperateTime, 1)
  		s ip = lastInstanceLog.OperateMachineIP
  		s action = lastInstanceLog.Action
		s productSource = lastInstanceLog.ProductSource
  		s actionDesc = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
  		s signName = ##Class(EMRservice.BL.BLSignRole).GetSignName(action)  		
  		s status = ..GetEMRStatus(pEpisodeId, pEmrDocId, pNum)
  		s statusDesc = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(status)
  		s emrSignID = lastInstanceLog.EMRSignID
  	}
  	else
  	{
	  	s currState = " "
	  	s statusDesc = "未完成"
	}
	s logStatus = creator_"^"_happenDate_"^"_happenTime_"^"_operator_"^"_operateDate_"^"_operateTime
	s logStatus = logStatus_"^"_ip_"^"_action_"^"_actionDesc_"^"_status_"^"_statusDesc_"^"_signName
  	s logStatus = logStatus_"^"_happenDateCache_"^"_happenTimeCache_"^"_createDateCache_"^"_createTimeCache
	s logStatus = logStatus_"^"_productSource_"^"_emrSignID
	q logStatus
}

/// Creator:    Candyxu
/// CreateDate: 2014-3-20
/// Desc:       病历日志明细
/// Input:      pEpisodeId 就诊ID
///           	pEmrDocId 目录展现结构挂模板一层的ID
///             pNum 顺序号
/// Debug:      d ##class(%ResultSet).RunQuery("EMRservice.BL.BLEMRLogs","GetDetialLog",76,35,1)
Query GetDetialLog(pEpisodeId As %String, pEmrDocId As %String, pNum As %String) As %Query(ROWSPEC = "OrderID:%String, LoginUser:%String,OperUser:%String, OperDate:%String, OperTime:%String, MachineIP:%String, Action:%String, TplName:%String, TplCreateDate:%String, TplCreateTime:%String, ProductSource:%String, CASignID:%String, ProductSourceCode:%String, TplHappenDate:%String, TplHappenTime:%String")
{
}

ClassMethod GetDetialLogExecute(ByRef qHandle As %Binary, pEpisodeId As %String, pEmrDocId As %String, pNum As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
 	s ind = 1
 	s eprLogId = ..GetLogID(pEpisodeId,pEmrDocId,pNum)
 	q:(eprLogId = "") $$$OK
 	Set langid=20
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
	}
 	s logSubId = ""
 	for
 	{
    	s logSubId = $o(^DHCEMRI.InstanceLogI("IdxParRef",eprLogId,logSubId))
    	q:(logSubId = "")
    	s rowId = eprLogId_"||"_logSubId
    	s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(rowId)
    	continue:(objInstanceLog = "")
    	s operUserName = objInstanceLog.OperateUserName
    	s operUserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objInstanceLog.OperateUserName,langid)
    	s loginUserName = objInstanceLog.LoginUserName
    	s loginUserName = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("User.SSUser","SSUSRName",objInstanceLog.LoginUserName,langid)
    	s operDate = objInstanceLog.OperateDate
    	s:(operDate '= "") operDate = $zd(operDate,3)
    	s operTime = objInstanceLog.OperateTime
    	s:(operTime '= "") operTime = $zt(operTime,1)
    	s machineIP = objInstanceLog.OperateMachineIP
    	s EMRSignLogID = objInstanceLog.EMRSignLogID
    	s caSignID=""
    	if (EMRSignLogID'="")
    	{
	    	s isSignValid=0
	    	s signLogObj = ##Class(EMRinstance.EMRSignLog).%OpenId(EMRSignLogID)
	    	s:(signLogObj'="") isSignValid = signLogObj.isSignValid
	    	s:(signLogObj'="")&(isSignValid=1) caSignID = signLogObj.SignID
	    }
    	s action = objInstanceLog.Action
    	s actionName = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
        s tplName = "",tplCreateDate = "",tplCreateTime = "",tplHappenDate="",tplHappenTime=""
		s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",pEpisodeId,pEmrDocId,""))
		continue:(ecrecordId = "")
		s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(ecrecordId_"||"_pNum)
		continue:(objInstanceData = "")
		s tplName =  ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRinstance.InstanceData","Title",objInstanceData.Title,langid)
        s tplCreateDate = $case(objInstanceData.CreateDate,"":"",:$zd(objInstanceData.CreateDate,3))
        s tplCreateTime = $case(objInstanceData.CreateTime,"":"",:$zt(objInstanceData.CreateTime))
        s tplHappenDate = $case(objInstanceData.HappenDate,"":"",:$zd(objInstanceData.HappenDate,3))
        s tplHappenTime = $case(objInstanceData.HappenTime,"":"",:$zt(objInstanceData.HappenTime))
		s productSourceCode = objInstanceLog.ProductSource
		s productSource =  ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Products","ProductName","电子病历",langid)
		if (productSourceCode '= "")
		{
			s productId = $O(^DHCEMRM.ProductsI("IdxProductCode"," "_$zcvt(productSourceCode,"U"),""))
	    	if (productId '= "")
	    	{
	    		s objProduct = ##Class(EMRmeta.Products).%OpenId(productId)
	    		s productSource = ##Class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.Products","ProductName",objProduct.ProductName,langid)
	    	}
		}
        s data = $lb(ind,loginUserName,operUserName,operDate,operTime,machineIP,actionName,tplName,tplCreateDate,tplCreateTime,productSource,caSignID,productSourceCode,tplHappenDate,tplHappenTime)
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceID)
	q:(objInstance = "") result
	s EMRLogsId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo,""))
	q:(EMRLogsId = "") result
	s:($d(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",EMRLogsId," "_$zcvt(pAction,"U")))>0) result = 1
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
	s LogsId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pEmrDocID,pNum,""))
	q:(LogsId = "") result
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",LogsId,subId))
		q:(subId = "")
		s objlog = ##Class(EMRinstance.InstanceLog).%OpenId(LogsId_"||"_subId)
		q:(objlog = "") 
		s action = $zcvt(objlog.Action,"U")
		s:(actions [ action) result = 1
		q:(actions [ action)
	}
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
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceID)
	q:(objInstance = "") result
	s logId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,objInstance.TheECRecord.RealChartItemID,objInstance.ListNo,"")) 
	q:(logId = "") result
	s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(logId)
	q:(objLog = "") result
	
	s date = $o(^DHCEMRI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),""))
	q:(date = "") result
	s time = $o(^DHCEMRI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),date,""))
	q:(time = "") result
	s instanceLogId = $o(^DHCEMRI.InstanceLogI("IdxParRefFinalStatusDateTime",logId," "_$zcvt(pStatus,"U"),date,time,"")) 
	q:(instanceLogId = "") result
	s result = ##Class(EMRinstance.InstanceLog).%OpenId(instanceLogId)
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
	s logId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pDocID,pEMRNum,"")) 
	q:(logId = "") result
	s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(logId)
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
	s logId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pDocID,pEMRNum,"")) 
	q:(logId = "") result
	s intanceLosgId = $o(^DHCEMRI.InstanceLogI("IdxParRef",logId,""),-1)
	q:(intanceLosgId = "") result
	s objInstanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(logId_"||"_intanceLosgId)
	q:(objInstanceLog = "") result
	s result = objInstanceLog
	q result
}

/// Desc: 		    依据就诊号EpisodeID和病历ID获取当前病历状态的操作者
/// Creator:		Lina
/// CreateDate: 	2016-12-8
/// Input:          就诊号  AEpisodeId
/// 					病历ID  AInstanceId
/// Output: 	    操作者  operator
/// Debug:          w ##Class(EMRservice.BL.BLEMRLogs).GetOperatorByInstanceId(174,"5||5")	
ClassMethod GetOperatorByInstanceId(AEpisodeId As %String, AInstanceId As %String) As %String
{
	s operator = ""
	q:(AEpisodeId = "")||(AInstanceId = "") operator
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	q:(objInstance = "") operator
	s num = objInstance.ListNo
	s ecrecordID = $p(AInstanceId,"||",1)
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
	q:(objRecord = "") operator
	s docId = objRecord.RealChartItemID
	s EMRLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeId,docId,num,""))
	q:(EMRLogId = "") operator
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",EMRLogId,subId),-1)
		q:(subId = "")
		s LogId = EMRLogId_"||"_subId
		s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogId)
		//若病历日志明细最后一次操作为打印,则病历目前最新状态status未发生改变
		continue:(objLog.Action = "print")
		//病历目前最新状态status的操作者operator
		s operator = objLog.OperateUserName
		q
	}
	k objInstance,objRecord,objLog
	q operator
}

/// Creator:    Donglulu
/// CreateTime: 2017-9-7
/// Desc:       取病历创建者信息
/// Input：     pInstanceId 实例ID
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetCreatorMessage("913||1")
ClassMethod GetCreatorMessage(pInstanceId As %String, AUserID As %String) As %String
{
  	s json = ""
  	q:(pInstanceId = "") json
  	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceId)
	q:(objInstance = "") json
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
	s status = objInstance.Status
  	s logID = ..GetLogID(epsiodeId, docId, num)
  	s objLogs = ##class(EMRinstance.EMRLogs).%OpenId(logID)
  	s creatorID = ""
  	s creatorCode = ""
  	s creatorName = ""
  	s CurrSSGroupAndName = ""
  	s SSGroupAndName = ""
  	s ispasswordState = "0"
  	if (objLogs '= "")
  	{
  		//提取创建者信息
  		s creatorrowID = objLogs.CreateUserID
  		q:(creatorrowID = "") json
  		Set ssuser=##class(User.SSUser).%OpenId(creatorrowID)
		q:(ssuser="") json
  		s creatorID = ssuser.SSUSRInitials
  		s creatorName = ssuser.SSUSRName
  		
  		// 获取病历是否有有效签名
  		s HasValidSign = ##Class(EMRservice.BOPrivAssist).HasValidSign(pInstanceId)
  		// 是否开启实习生创建未签名病历删除不需要输入创建者密码
  		s IsPassWordByIntern = ##Class(EMRservice.SystemParameter).IsPassWordByIntern()
  		if ((HasValidSign = "0")&&(IsPassWordByIntern = "Y"))
  		{
	  		s SignLevelAndDesc = ##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(objLogs.CreateUserID)
	  		if ($p(SignLevelAndDesc,"^",1) = "intern")
	  		{
		  		s ispasswordState = "1"
		  	} 	
	  	}
	  	if (ispasswordState = "1")
	  	{
		  	//获取当前登录医师的人员维护类型
	  		s CurrSignLevelAndDesc = ##class(EMRservice.BL.BLSignRole).GetUserLevelbyHis(AUserID)
	  		// 判断当前登录的医师如果是实习医师，删除病历是需要输入密码
	  		if ($p(CurrSignLevelAndDesc,"^",1) = "intern")
	  		{
		  		s ispasswordState = "0"
		  	}
		}		

  	}
  	s json = json_"{"
	s json = json_"""creatorID"":"""_creatorID_""""
	s json = json_",""creatorName"":"""_creatorName_""""
	s json = json_",""status"":"""_$zcvt(status,"U")_""""
	s json = json_",""ispasswordState"":"""_ispasswordState_""""
	s json = json_"}"
	s json = $ZSTRIP(json,"*C")
  	q json
}

/// Desc:		判断上级医师是否签名
/// Creator:	Donglulu
/// CreateDate:	2017-9-25
/// Input:      pEpisodeID 就诊号
///             pEMRDocID 目录展现结构挂模板一层的ID
///             pEMRNum 病历顺序号
///             pUserID
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).IsSuperiorPhysicianSign(230,53,980,359)
ClassMethod IsSuperiorPhysicianSign(pEpisodeID As %String, pEmrDocID As %String, pNum As %String, pUserID As %String) As %String
{
	s result = 0
	s status = ""
	q:(pEpisodeID = "")||(pEmrDocID = "")||(pNum = "") result
	s rowId = $o(^DHCEMRI.EMRLogsI("IdxMain",pEpisodeID,pEmrDocID,pNum,""))
    q:(rowId = "") result
    s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(rowId)
    q:(rowId = "") result
    s status = $zcvt(objLog.EMRStatus,"U")
    q:(status '[ "CHECKED") result
    
    s userLevel = ##class(EMRservice.BL.BLSignRole).GetUserLevel(pUserID)
	s userLevel = $p(userLevel,"^",1)
    
    if (status = "CHECKEDREVISION")
    {
	    if ($d(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum," CHIEFCHECK"))>0)
	    {
		    s status = "CHIEFCHECKED"
	    }
	    elseif($d(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum," VICECHIEFCHECK"))>0)
	    {
		    s status = "VICECHIEFCHECKED"
	    }
	    elseif($d(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum," ATTENDINGCHECK"))>0)
	    {
		    s status = "ATTENDINGCHECKED"
	    }
	    elseif($d(^DHCEMRI.EMRSignI("IdxMain"," "_pEpisodeID," "_pEmrDocID," "_pNum," RESIDENTCHECK"))>0)
	    {
		    s status = "RESIDENTCHECKED"
	    }
    }
    
	if (status = "CHIEFCHECKED")
	{
		s:(userLevel '= "Chief") result = 1
	}
	elseif (status = "VICECHIEFCHECKED")
	{
		s:((userLevel '= "Chief")&&(userLevel '= "ViceChief")) result = 1
	}
	elseif (status = "ATTENDINGCHECKED") 
	{
		s:((userLevel '= "Chief")&&(userLevel '= "ViceChief")&&(userLevel '= "Attending")) result = 1
	}
	elseif (status = "RESIDENTCHECKED") 
	{
		s:((userLevel '= "Chief")&&(userLevel '= "ViceChief")&&(userLevel '= "Attending")&&(userLevel '= "Resident")) result = 1
	}
	q result
}

/// Desc:		提供给医生接口，返回最新修改过病历的附属账号，用于医生站病人列表显示患者附属账号。
/// Creator:	Donglulu
/// CreateDate:	2017-12-4
/// Input:      pEpisodeID 就诊号
///             pSsGroupID 安全组rowid
///             pUserID
/// Debug:      d ##Class(EMRservice.BL.BLEMRLogs).SetInternToDocStation(308,230,359)
ClassMethod SetInternToDocStation(pSsGroupID As %String, pEpisodeID As %String, pUserID As %String)
{
	s ssGroupID = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("SetInternToDocStation")
	q:(ssGroupID = "")
	for i=1:1:$l(ssGroupID,"^")
	{
		
		s ssGroupIDSub = $p(ssGroupID,"^",i)
		q:(ssGroupIDSub = "")
		if (pSsGroupID = ssGroupIDSub)
		{
			
			d ##Class(web.DHCDocMain).SaveInternDoc(pEpisodeID,"",pUserID,"")
			q
		}
	}
}

/// Creator:    Donglulu
/// CreateTime: 2018-10-15
/// Desc:       获取病历作者信息
/// Input：     pInstanceId 实例ID
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetAuthorMessage("913||1")
ClassMethod GetAuthorMessage(pInstanceId As %String) As %String
{
  	s json = ""
  	q:(pInstanceId = "") json
  	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceId)
	q:(objInstance = "") json
	s epsiodeId = objInstance.TheECRecord.RealEpisodeID
	s docId = objInstance.TheECRecord.RealChartItemID
	s num = objInstance.ListNo
  	s logID = ..GetLogID(epsiodeId, docId, num)
  	s objLogs = ##class(EMRinstance.EMRLogs).%OpenId(logID)
  	s creatorID = ""
  	s creatorCode = ""
  	s creatorName = ""
  	s happenDate = $zd(objInstance.HappenDate,3)
  	s happenTime = $zt(objInstance.HappenTime,1)
  	if (objLogs '= "")
  	{
  		//提取创建者信息
  		s creatorrowID = objLogs.CreateUserID
  		q:(creatorrowID = "") json
  		Set ssuser=##class(User.SSUser).%OpenId(creatorrowID)
		q:(ssuser="") json
  		s creatorID = ssuser.SSUSRInitials
  		s creatorName = ssuser.SSUSRName
  	}
  	s time = happenDate_" "_happenTime
  	s json = time_"^"_creatorID_"^"_creatorName_"^"_creatorrowID
  	q json
}

/// Creator:    Lina
/// CreateTime: 2019-5-28
/// Desc:       取病历当前状态信息，给温岭项目病案编目页面emr.interface.medical.csp使用
/// Input：     AInstanceId 实例ID
/// Output:     creator     病历创建者
///             createDate  病历创建日期
///             createTime  病历创建时间
///             statusDesc  病历当前状态
///             actionDesc  病历当前操作描述
///             operator    病历当前状态的操作者
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetInsStatusInfo("1||11")
ClassMethod GetInsStatusInfo(AInstanceId As %String) As %String
{
    s result = ""
    q:(AInstanceId = "") result
    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
    q:(objInstance = "") result
    s epsiodeId = objInstance.TheECRecord.RealEpisodeID
    s docId = objInstance.TheECRecord.RealChartItemID
    s num = objInstance.ListNo
    s logID = ..GetLogID(epsiodeId, docId, num)
    if (logID '= "") {
        s objLogs = ##class(EMRinstance.EMRLogs).%OpenId(logID)
        if (objLogs '= "") {
            //提取创建者信息
            s creator = objLogs.CreateUserID
            s:(creator '= "") creator = ##class(EMRservice.BL.BLPowerUser).GetUserName(creator)
            s creator = $ZSTRIP(creator,"*C")
            s createDate = $zd(objLogs.CreateDate,3)
            s createTime = $zt(objLogs.CreateTime,1)
            s status = objLogs.EMRStatus
            s statusDesc = ##Class(EMRservice.BL.BLEMRStatus).GetStatusNameByCode(status)
            s subId = ""
            for {
                s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",logID,subId),-1)
                q:(subId = "")
                s LogId = logID_"||"_subId
                s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogId)
                //若病历日志明细最后一次操作为打印,则病历目前最新状态status未发生改变
                continue:(objLog.Action = "print")
                s action = objLog.Action
                s actionDesc = ##Class(EMRservice.BL.BLEMRAction).GetActionNameByCode(action)
                //病历目前最新状态status的操作者operator
                s operator = objLog.OperateUserName
                q
            }
            d setOutput   
        }else {
            s creator = "", createDate = "", createTime = "", actionDesc = "", operator = ""
            s statusDesc = "未完成"
            d setOutput
        }
    }else {
        s creator = %session.Get("LOGON.USERNAME"), actionDesc = "创建", operator = %session.Get("LOGON.USERNAME")
        s createDate = $zd($p($h,",",1),3)
        s createTime = $zt($p($h,",",2),1)
        s statusDesc = "未完成"
        d setOutput
    }
    k objInstance,objLogs,objLog
    q result
setOutput
    s result = "{""creator"":"""_creator_""""
    s result = result_",""createDate"":"""_createDate_""""
    s result = result_",""createTime"":"""_createTime_""""
    s result = result_",""statusDesc"":"""_statusDesc_""""
    s result = result_",""actionDesc"":"""_actionDesc_""""
    s result = result_",""operator"":"""_operator_"""}"
    s result = $ZSTRIP(result,"*C")
}

/// Creator:    Lina
/// Createdate: 2019-8-29
/// Desc:       存储病历打散的章节文本 
/// Input：     pIntanceId EMRinstance.InstanceData rowId
///             pEmrLogId  EMRinstance.EMRLogs rowId
/// Return：    EMRinstance.InstanceLogSectionData的rowid  或者 0(失败)
/// Debug：     ##class(EMRservice.BL.BLEMRLogs).SaveEMRLogSectionData("11||1","21")
ClassMethod SaveEMRLogSectionData(pIntanceId As %String, pEmrLogId As %String) As %String
{
    s result = 0
    q:((pIntanceId = "")||(pEmrLogId = "")) result
    s objEMRSectionData = ##class(EMRinstance.InstanceLogSectionData).%New()
    s objInstanceLog = ..GetFinalLog(pEmrLogId)
    s objEMRSectionData.InstanceLogID = objInstanceLog.%Id()
    s objEMRSectionData.InstanceDataID = pIntanceId
    s sectionContent = ""
    s objInstance = ##class(EMRinstance.InstanceData).%OpenId(pIntanceId)
    if ((objInstance '= "")||(objInstance.Status = "Save"))
    {
        //压缩改造代码
        //s tmpInstanceStream = ##class(%GlobalBinaryStream).%New()
        //d tmpInstanceStream.CopyFrom(objInstance.InstanceData)
        //s stream = ##Class(EMRservice.InterfaceService.TumourReport).GetDocumentContent(tmpInstanceStream)
        s stream = ##class(EMRservice.InterfaceService.EMRRecordInfo).GetDocumentContent(pIntanceId)
        if (stream.Size > 0)
        {
            s sectionContent = stream.Read()
        }
    }
    d objEMRSectionData.Text.Write(sectionContent)
     
    s $zt = "SaveSectionHandler"
    s scEMRSectionData = objEMRSectionData.%Save() 
    if ($$$ISOK(scEMRSectionData))
    {
       s result = objEMRSectionData.%Id()
       k objInstanceLog
       k objInstance
       k objEMRSectionData
    }
 
    q result_"^"_scEMRSectionData
         
SaveSectionHandler
    q result_"^"_$zerror
}

/// Creator:    donglulu
/// Createdate: 2019-9-20
/// Desc:       根据pInstanceId取得病历当前状态(已删除为DELETE,其他为NORMAL)
/// Input:      pInstanceId 实例ID
/// Return:     "NORMAL"/"DELETE"
/// Debug:      w ##Class(EMRservice.BL.BLEMRLogs).GetEMRStatusByInstanceID("40||5")     
ClassMethod GetEMRStatusByInstanceID(pInstanceId As %String) As %String
{
	s status = "NORMAL"
	q:(pInstanceId ="") status
    s objEcrecord = ##class(EMRinstance.ECRecord).%OpenId($p(pInstanceId,"||",1))
	q:(objEcrecord = "") status
	s episodeId = objEcrecord.RealEpisodeID
	s docID = objEcrecord.RealChartItemID
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(pInstanceId)
	q:(objInstanceData = "") status
	s emrNum = objInstanceData.ListNo
    s log = ##Class(EMRservice.BL.BLEMRLogs).GetLogStatus(episodeId,docID,emrNum)
	s status = $p(log,"^",10)
	s:(status = "deleted") status = "DELETE"
	q status
}

/// Desc: 		    依据病历ID获取当前病历状态的操作IP
/// Creator:		yangbing
/// CreateDate: 	2022-12-6
/// Input:			病历ID  AInstanceId
/// Output: 	    操作电脑IP  OperateMachineIP
/// Debug:          w ##Class(EMRservice.BL.BLEMRLogs).GetOperateIPByInstanceId("95||1")	
ClassMethod GetOperateIPByInstanceId(AInstanceId As %String) As %String
{
	s OperateMachineIP = ""
	q:(AInstanceId = "") OperateMachineIP
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId,0)
	q:(objInstance = "") OperateMachineIP
	s episodeID = objInstance.RealEpisodeID
	s num = objInstance.ListNo
	s ecrecordID = $p(AInstanceId,"||",1)
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID,0)
	q:(objRecord = "") OperateMachineIP
	s docId = objRecord.RealChartItemID
	s EMRLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",episodeID,docId,num,""))
	q:(EMRLogId = "") OperateMachineIP
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",EMRLogId,subId),-1)
		q:(subId = "")
		s LogId = EMRLogId_"||"_subId
		s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogId,0)
		//若病历日志明细最后一次操作为打印,则病历目前最新状态status未发生改变
		continue:(objLog.Action = "print")
		//病历目前最新状态status的操作者operator
		s OperateMachineIP = objLog.OperateMachineIP
		q
	}
	k objInstance,objRecord,objLog
	q OperateMachineIP
}

/// Desc: 		    依据病历ID获取当前病历状态的操作日期和时间
/// Creator:		wangyu
/// CreateDate: 	2023-04-25
/// Input:			病历ID  AInstanceId
/// Output: 	    操作日期和时间  OperateMachineDateTime
/// Debug:          w ##Class(EMRservice.BL.BLEMRLogs).GetOperateDateTimeByInstanceId("269||1")	
ClassMethod GetOperateDateTimeByInstanceId(AInstanceId As %String) As %String
{
	s OperateMachineDateTime = ""
	q:(AInstanceId = "") OperateMachineDateTime
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AInstanceId)
	q:(objInstance = "") OperateMachineDateTime
	s episodeID = objInstance.RealEpisodeID
	s num = objInstance.ListNo
	s ecrecordID = $p(AInstanceId,"||",1)
	s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
	q:(objRecord = "") OperateMachineDateTime
	s docId = objRecord.RealChartItemID
	s EMRLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",episodeID,docId,num,""))
	q:(EMRLogId = "") OperateMachineDateTime
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",EMRLogId,subId),-1)
		q:(subId = "")
		s LogId = EMRLogId_"||"_subId
		s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogId,0)
		//若病历日志明细最后一次操作为打印,则病历目前最新状态status未发生改变
		continue:(objLog.Action = "print")
		//病历目前最新状态status的操作者operator
		s OperateMachineDateTime = objLog.OperateDate_"^"_objLog.OperateTime
		q
	}
	k objInstance,objRecord,objLog
	q OperateMachineDateTime
}

}
