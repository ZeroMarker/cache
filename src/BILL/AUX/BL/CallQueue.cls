/// 名称: BILL.AUX.BL.CallQueue.cls
/// 描述: 叫号队列表操作类
/// 编写者: ZhYW
/// 编写日期: 2021-08-18
/// 产品组: 计费医保组
Class BILL.AUX.BL.CallQueue Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 生成队列
/// Input: jsonStr:生成队列参数(json字符串)
/// Return: success^id, success(0:成功, <>0:失败)
/// Debug: w ##class(BILL.AUX.BL.CallQueue).CreatQueue("{"PAPMIDR":1,"AdmDRStr":1,"CreatServer":"127.0.0.1","CreatUserDR":1,"BIZType":"IPDEP","HospDR":2}")
ClassMethod CreatQueue(jsonStr As %String) As %String
{
	set $zt="ERROR"

	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	set patientId=json.PAPMIDR
	set adm=json.AdmDR
	set creatServer=json.CreatServer
	set creatUserDR=json.CreatUserDR
	set bizType=json.BIZType
	set queueType=json.QueueType
	set initQueueDR=json.InitQueueDR
	set hospDR=json.HospDR
	
	set curDate=+$h
	&SQL(SELECT TOP 1 QueueNo
		 INTO :curMaxNo
		 FROM BILL_AUX.CallQueue
		 WHERE QueueType=:queueType AND CreatDate=:curDate AND HospDR=:hospDR
		 ORDER BY %ID DESC
	)
	set queueNo=$i(curMaxNo)
	
	lock +^BILL.AUX.CallQueueI(queueType,hospDR,queueNo):0 else  quit -110_"^加锁失败"
	
	ts
	
	set dataObj=##class(BILL.AUX.CallQueue).%New()
	if ('$isObject(dataObj)) {
		tro
		quit -1_"^"_"创建对象失败"
	}
	do dataObj.PAPMIDRSetObjectId(patientId)
	do dataObj.AdmDRSetObjectId(adm)
	set dataObj.CreatServer=creatServer
	do dataObj.CreatUserDRSetObjectId(creatUserDR)
	set dataObj.BIZType=bizType
	set dataObj.QueueType=queueType
	set dataObj.QueueNo=queueNo
	set dataObj.CalledStatus="G"
	do dataObj.InitQueueDRSetObjectId(initQueueDR)
	do dataObj.HospDRSetObjectId(hospDR)
	set sc=dataObj.%Save()
	set id=dataObj.%Id()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		lock -^BILL.AUX.CallQueueI(queueType,hospDR,queueNo)
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	lock -^BILL.AUX.CallQueueI(queueType,hospDR,queueNo)
	
	quit 0_"^"_id
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 保存叫号信息
/// Input: jsonStr:叫号参数(json字符串)
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.AUX.BL.CallQueue).SaveCall()
ClassMethod SaveCall(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	set id=json.Id
	set userId=json.UserDR
	set client=json.Client
	
	set dataObj=##class(BILL.AUX.CallQueue).%OpenId(id)
	if ('$isObject(dataObj)) {
		quit -1_"^"_"id不存在"
	}
	if ((dataObj.CalledStatus="C")&&(dataObj.CalledClient'=client)) {
		do dataObj.%Close()
		set msg="该患者已由【"_"操作员："_$p(^SSU("SSUSR",dataObj.CalledUserDRGetObjectId()),"^",2)
		set msg=msg_"，"_"客户端："_dataObj.CalledClient_"锁定，您不能呼叫该患者""】"
		quit -1_"^"_msg
	}
	lock +^BILL.AUX.CallQueueD(id):0 else  quit -110_"^加锁失败"
	
	set numOfCalls=dataObj.NumOfCalls
	
	ts
	
	set dataObj.CalledStatus="C"
	set dataObj.UpdateDate=+$h
	set dataObj.UpdateTime=$p($h,",",2)
	do dataObj.UpdateUserDRSetObjectId(userId)
	set dataObj.CalledClient=client
	set dataObj.NumOfCalls=$i(numOfCalls)
	set sc=dataObj.%Save()
	set id=dataObj.%Id()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		lock -^BILL.AUX.CallQueueD(id)
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
	lock -^BILL.AUX.CallQueueD(id)

	quit 0
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 保存过号信息
/// Input: jsonStr:过号参数(json字符串)
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.AUX.BL.CallQueue).SavePass()
ClassMethod SavePass(jsonStr As %String) As %String
{
	set $zt="ERROR"
	set json=##class(%DynamicObject).%FromJSON(jsonStr)
	set id=json.Id
	set userId=json.UserDR
	set client=json.Client
	
	set dataObj=##class(BILL.AUX.CallQueue).%OpenId(id)
	if ('$isObject(dataObj)) {
		quit -1_"^"_"id不存在"
	}
	if ((dataObj.CalledStatus="Y")&&(dataObj.CalledClient'=client)) {
		do dataObj.%Close()
		set msg="该患者已由【"_"操作员："_$p(^SSU("SSUSR",dataObj.CalledUserDRGetObjectId()),"^",2)
		set msg=msg_"，"_"客户端："_dataObj.CalledClient_"锁定，您不能将该患者过号""】"
		quit -1_"^"_msg
	}
	lock +^BILL.AUX.CallQueueD(id):0 else  quit -110_"^加锁失败"
	
	ts
	
	set dataObj.CalledStatus="P"
	set dataObj.UpdateDate=+$h
	set dataObj.UpdateTime=$p($h,",",2)
	do dataObj.UpdateUserDRSetObjectId(userId)
	set sc=dataObj.%Save()
	set id=dataObj.%Id()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		tro
		lock -^BILL.AUX.CallQueueD(id)
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	
	//生成新队列
	set newDataObj=##class(%DynamicObject).%New()
	set newDataObj.PAPMIDR=dataObj.PAPMIDRGetObjectId()
	set newDataObj.AdmDR=dataObj.AdmDRGetObjectId()
	set newDataObj.CreatServer=dataObj.CreatServer
	set newDataObj.CreatUserDR=userId
	set newDataObj.BIZType=dataObj.BIZType
	set newDataObj.QueueType=dataObj.QueueType
	set newDataObj.InitQueueDR=id
	set newDataObj.HospDR=dataObj.HospDRGetObjectId()
	set rtnValue=..CreatQueue(newDataObj.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	set newId=$p(rtnValue,"^",2)
	if (+rtn) {
		tro
		lock -^BILL.AUX.CallQueueD(id)
		quit rtnValue
	}
	
	if ($tl>0) tc
	
	lock -^BILL.AUX.CallQueueD(id)
	
	quit 0_"^"_newId
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 叫号
/// Input: 
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.AUX.BL.CallQueue).CallNO("IP","193.168.77.53","12173^240^163^2")
ClassMethod CallNO(queueType As %String, client As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)

	set curDate=+$h
	&SQL(SELECT TOP 1 %ID
		 INTO :queueId
		 FROM BILL_AUX.CallQueue
		 WHERE QueueType=:queueType AND CreatDate=:curDate AND CalledStatus='G' AND HospDR=:hospId
		 ORDER BY %ID ASC
	)
	if (queueId="") {
		quit -1_"^"_"无叫号队列"
	}
	
	ts
	
	set dto={}
	set dto.Id=queueId
	set dto.UserDR=userId
	set dto.Client=client
	set rtnValue=..SaveCall(dto.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	
	//叫号服务
	set rtnValue=..InvokeIQueue(queueId, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	
	if ($tl>0) tc
	
	quit 0_"^"_queueId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 重复叫号
/// Input: 
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.AUX.BL.CallQueue).ReCallNO()
ClassMethod ReCallNO(queueType As %String, client As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set curDate=+$h
	&SQL(SELECT TOP 1 %ID
		 INTO :queueId
		 FROM BILL_AUX.CallQueue
		 WHERE QueueType=:queueType AND CreatDate=:curDate AND CalledStatus='C' AND CalledClient=:client AND HospDR=:hospId
		 ORDER BY %ID DESC
	)
	if (queueId="") {
		quit -1_"^"_"无叫号队列"
	}
	
	ts
	
	set dto={}
	set dto.Id=queueId
	set dto.UserDR=userId
	set dto.Client=client
	set rtnValue=..SaveCall(dto.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	
	//叫号服务
	set rtnValue=..InvokeIQueue(queueId, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	
	if ($tl>0) tc
	
	quit 0_"^"_queueId

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 过号
/// Input: 
/// Return: 0:成功, <>0:失败
/// Debug: w ##class(BILL.AUX.BL.CallQueue).PassCallNO("IP","193.168.77.53","12173^240^163^2")
ClassMethod PassCallNO(queueType As %String, client As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("PassCallNO")=$lb(queueType, client, sessionStr)

	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set curDate=+$h
	&SQL(SELECT TOP 1 %ID
		 INTO :queueId
		 FROM BILL_AUX.CallQueue
		 WHERE QueueType=:queueType AND CreatDate=:curDate AND CalledStatus='C' AND HospDR=:hospId
		 ORDER BY %ID DESC
	)
	if (queueId="") {
		quit -1_"^"_"无叫号队列"
	}
	
	ts
	
	//过号当前队列
	set dto={}
	set dto.Id=queueId
	set dto.UserDR=userId
	set dto.Client=client
	set rtnValue=..SavePass(dto.%ToJSON())
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	
	//呼叫下一队列
	set rtnValue=..CallNO(queueType, client, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) {
		tro
		quit rtnValue
	}
	if ($tl>0) tc
	
	quit rtnValue

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2021-08-18
/// Description: 调用多媒体组接口发送叫号信息
/// Input: BILL.AUX.CallQueue.RowId, sessionStr: userId^groupId^ctLocId^hospId
/// Debug: w ##class(BILL.AUX.BL.CallQueue).InvokeIQueue("15", "12173^241^222^2^20")
ClassMethod InvokeIQueue(queueId As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	&SQL(SELECT PAPMIDR, AdmDR, BIZType, QueueNo, CalledClient
		 INTO :papmi, :adm, :bizType, :queueNo, :client
		 FROM BILL_AUX.CallQueue
		 WHERE %ID = :queueId
	)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	//调用多媒体组接口发送叫号信息
	set rtn=##class(web.DHCVISQueueManage).SendVoiceCallInPat(queueNo, patName, client, userId, adm, bizType)
	quit:(+rtn) rtn
	
	quit 0
}

/// Creator: ShangXuehao
/// CreatDate: 2021-08-18
/// Description: 查询叫号列表
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("BILL.AUX.BL.CallQueue","QryQueueList","19/08/2021","19/08/2021","","0","12173^241^222^2^20")
Query QryQueueList(stDate As %String, endDate As %String, queueType As %String, bizType As %String, calledStatus As %String, sessionStr As %String) As websys.Query(ROWSPEC = "patNo:%String,patName:%String,queueNo:%String,creatServer:%String,creatDate:%String,creatTime:%String,creatUser:%String,bizType:%String,updateDate:%String,updateTime:%String,updateUser:%String,calledClient:%String,calledNum:%Integer,queueId:%Integer")
{
}

ClassMethod QryQueueListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, queueType As %String, bizType As %String, calledStatus As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("QryQueueList")=$lb(stDate, endDate, queueType, bizType, calledStatus, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	kill queueList
	
	for date=stDate:1:endDate {
		set id=0
		while ($o(^BILL.AUX.CallQueueI("QueTypeDate",queueType,date,id))) {
			set id=$o(^BILL.AUX.CallQueueI("QueTypeDate",queueType,date,id))
			set queData=$g(^BILL.AUX.CallQueueD(id))
			set hospDR=$lg(queData,18)
			continue:(hospId'=hospDR)
			set myBizType=$lg(queData,8)
			continue:((bizType'="")&&(bizType'=myBizType))
			set myBizType=$case(myBizType,"IPReg":"住院登记","IPDep":"住院押金","IPPay":"住院收费","HDDep":"血透押金",:"") 
			set queNo=$lg(queData,10)
			set myStatus=$lg(queData,11)
			continue:((calledStatus=0)&&(myStatus'="G"))
			continue:((calledStatus=1)&&(myStatus'="C"))
			continue:((calledStatus=2)&&(myStatus'="P"))
			set papmi=$lg(queData,2)
			set patNo=$p(^PAPER(papmi,"PAT",1),"^",1)
			set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
			set creatServer=$lg(queData,4)
			set creatDate=$lg(queData,5)
			set creatTime=$lg(queData,6)
			set creatDate=##class(websys.Conversions).DateLogicalToHtml(creatDate)
			set creatTime=##class(websys.Conversions).TimeLogicalToHtml(creatTime)
			set creatUserDR=$lg(queData,7)
			set creatUser=$s((creatUserDR'=""):$p($g(^SSU("SSUSR",creatUserDR)),"^",2),1:"")
			set creatUser=##class(User.SSUser).GetTranByDesc("SSUSRName", creatUser, langId)
			set updateDate=$lg(queData,12)
			set updateTime=$lg(queData,13)
			set updateDate=##class(websys.Conversions).DateLogicalToHtml(updateDate)
			set updateTime=##class(websys.Conversions).TimeLogicalToHtml(updateTime)
			set updateUserDR=$lg(queData,14)
			continue:((updateUserDR'="")&&(updateUserDR'=userId))   //查询自己的已叫号记录
			set updateUser=$s((updateUserDR'=""):$p($g(^SSU("SSUSR",updateUserDR)),"^",2),1:"")
			set updateUser=##class(User.SSUser).GetTranByDesc("SSUSRName", updateUser, langId)
			set calledClient=$lg(queData,15)
			set calledNum=$lg(queData,16)
			set seqDate=$s((calledStatus=1):updateDate,1:creatDate)
			set seqTime=$s((calledStatus=1):updateTime,1:creatTime)
			set queueList(seqDate,seqTime,$i(queueList))=$lb(patNo,patName,queNo,creatServer,creatDate,creatTime,creatUser,myBizType,updateDate,updateTime,updateUser,calledClient,calledNum,id)
		}
	}
	
	if (calledStatus=1) {
		//按已叫号查询时，倒叙输出
		set date=""
		while($o(queueList(date),-1)) {
			set date=$o(queueList(date),-1)
			set time=""
			while($o(queueList(date,time),-1)) {
				set time=$o(queueList(date,time),-1)
				set idx=""
				while($o(queueList(date,time,idx),-1)) {
					set idx=$o(queueList(date,time,idx),-1)
					set data=$g(queueList(date,time,idx))
					set ^CacheTemp(repid,ind)=data
					set ind=ind+1
				}
			}
		}
		quit $$$OK
	}
	
	set date=""
	while($o(queueList(date))) {
		set date=$o(queueList(date))
		set time=""
		while($o(queueList(date,time))) {
			set time=$o(queueList(date,time))
			set idx=0
			while($o(queueList(date,time,idx))) {
				set idx=$o(queueList(date,time,idx))
				set data=$g(queueList(date,time,idx))
				set ^CacheTemp(repid,ind)=data
				set ind=ind+1
			}
		}
	}
	
	quit $$$OK
}

}
