/// 手术（麻醉）安排业务类
Class CIS.AN.BL.OperArrange Extends %RegisteredObject
{

/// 保存排班时忽略的状态(这些状态的手术，保存排班时不用修改状态)
Parameter ArrIgnoreStatus As %String = "Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish";

/// 发布排班时忽略的状态(这些状态的手术，发布排班时不用修改状态)
Parameter SubmitIgnoreStatus As %String = "AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish";

/// w ##class(CIS.AN.BL.OperArrange).GetArrOperList("2020-04-26","2020-04-26","296")
ClassMethod GetArrOperList(startDate As %String, endDate As %String, deptId As %String) As %String
{
	set statusCode=..GetStatusCodeList()
	set EMStatusCode=..GetEMStatusCodeList()
	set ret=##class(CIS.AN.COM.String).QueryToJSONWithOrderField("CIS.AN.BL.OperScheduleList","FindOperScheduleList","ArrRoomDesc",startDate,endDate,deptId,"","","",statusCode,"","","","N","","",EMStatusCode)
	quit ret
}

/// 获取手术排班时，可查询的择期手术状态代码
ClassMethod GetStatusCodeList() As %String
{
	set NeedAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	set statusCode="Application^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	set:(NeedAuditOperation="Y") statusCode="Audit^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	quit statusCode
}

/// 获取手术排班时，可查询的急诊手术状态代码
ClassMethod GetEMStatusCodeList() As %String
{
	set NeedAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	set statusCode="Application^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	set:(NeedAuditOperation="Y") statusCode="Audit^Receive^Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Finish"
	quit statusCode
}

/// Creator：      	陈长青
/// CreatDate：    	2017-03-13
/// Description： 	保存手术(麻醉)安排信息
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).SaveOperArrange("")
ClassMethod SaveOperArrange(data As %String) As %String
{
	set ^temSaveOperArrange=data
	tstart
	set status=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult=""
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		m operObj=array(objIndex)
		
		if ($get(operObj("Status"))="")&($get(operObj("StatusCode"))'="")
		{
			set operObj("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(operObj("StatusCode"))	
		}
		
		set operRoomId=$get(operObj("OperRoom"))
		set originalRoomId=$get(operObj("OriginalRoom"))
		set opsId=operObj("RowId")
		set opsList(opsId)=""
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		
		// 判断腔镜手术
		set operSeq=+$get(operObj("OperSeq"))
		if (operSeq=1)
		{
			set mirrorOper=..HasEnoughMirrorEquip(opsId,operSchedule.OperDeptID)
			set:(mirrorOper="N") saveResult="E^首台手术腔镜设备不足，请排到后面的台次。"
			quit:($piece(saveResult,"^",1)="E")	
		}
			
		
		set operStatusCode=""
		if (operSchedule.Status'="")
		{
			set operStatusCode=operSchedule.Status.Code	
		}
		if (("^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Cancel^") [ ("^"_operStatusCode_"^"))
		{
			kill operObj("Status")	
		}
		else
		{
			set operObj("Status")=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")	
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.operObj)
		quit:($piece(saveResult,"^",1)="E")
		
		// 已排手术切换手术间，则原手术间台次自动按顺序调整
		if (opsId'="")&(operRoomId'="")&(operRoomId'=originalRoomId)&(originalRoomId'="")
		{
			set saveResult=..ChangeOriginalSeq(opsId,originalRoomId)
			quit:($piece(saveResult,"^",1)="E")	
		}
	}	
	
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}
	tcommit
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-10
/// Description： 	更换手术间（自动设置台次）
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ChangeOperRoom("2022-09-30","262","5")
ClassMethod ChangeOperRoom(date As %String, opsId As %String, targetOperRoomId As %String) As %String
{
	if '(##class(CIS.AN.OperSchedule).%ExistsId(opsId)) quit "E^手术安排参数错误！"
	if '(##class(CF.AN.Location).%ExistsId(targetOperRoomId)) quit "E^目标手术间参数错误！"
	
	tstart
	set saveResult=""
	kill seqList,roomSeqList
	set seqList="",operRoomId=""
		
	set changingObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set EpisodeID=changingObj.EpisodeID
	set paadmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	set:paadmStatus="C" saveResult="E^该就诊记录已经取消，不能安排手术"
	set:paadmStatus="D" saveResult="E^该患者已出院，不能安排手术"
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}
	
	set:changingObj.OperRoom'="" operRoomId=changingObj.OperRoom.%Id()
	set seq=changingObj.OperSeq
	
	set lastSeq=##class(CIS.AN.BL.OperArrange).GetLastSequence(date,targetOperRoomId,.seqList)
	merge roomSeqList=seqList(+operRoomId)
	kill roomSeqList(+seq)
	
	set changingObj.OperSeq=lastSeq+1
	set changingObj.OperRoom=##class(CF.AN.Location).%OpenId(targetOperRoomId)
	set changingObj.ArrOperRoom=##class(CF.AN.Location).%OpenId(targetOperRoomId)
	//set changingObj.ArrOperSeq=lastSeq+1
	
	// BY CCQ 20181008 
	// 判断手术状态，如果状态不是安排、术中、术毕、入PACU、出PACU、离室和取消，
	// 那么自动将状态改为安排
	set operStatusCode=""
	if (changingObj.Status'="")
	{
		set operStatusCode=changingObj.Status.Code	
	}

	if (("^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Cancel^") '[ ("^"_operStatusCode_"^"))
	{
		set operStatus=	##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
		set changingObj.Status=##class(CT.AN.OperStatus).%OpenId(operStatus)
	} // end BY CCQ 20181008
	
	set status=changingObj.%Save()
	if +status < 1 set saveResult="E^"
	else  set saveResult=..SerializeOperSeq(.roomSeqList)
	
	//回写旧表 YL 20200629
	set opaId=changingObj.ExternalID
	quit:(##class(User.DHCANOPArrange).%ExistsId(opaId)=0) "E^手术记录不存在！"
	set operArrange=##class(User.DHCANOPArrange).%OpenId(opaId)
	set:("RILPF" '[ operArrange.OPAStatus) operArrange.OPAStatus="R"
	set oldRoomId=changingObj.OperRoom.ExternalID
	set operArrange.OPAOpRoomDr=##class(User.DHCANCOperRoom).%OpenId(oldRoomId)
	set operArrange.OPASeq=changingObj.OperSeq
	set sc=operArrange.%Save()
	
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}
	tcommit
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-10
/// Description： 	更换手术间（自动设置台次）
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ChangeRoomOperSeq("6452","8")
ClassMethod ChangeOriginalSeq(opsId As %String, targetOperRoomId As %String) As %String
{
	if '(##class(CIS.AN.OperSchedule).%ExistsId(opsId)) quit "E^手术安排参数错误！"
	if '(##class(CF.AN.Location).%ExistsId(targetOperRoomId)) quit "E^目标手术间参数错误！"
	set saveResult=""
	kill seqList,roomSeqList
	set seqList=""
		
	set changingObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set date=changingObj.OperDate
	
	set lastSeq=##class(CIS.AN.BL.OperArrange).GetLastSequence(date,targetOperRoomId,.seqList)
	merge roomSeqList=seqList(+targetOperRoomId)
	set saveResult=..SerializeOperSeq(.roomSeqList)
	quit saveResult
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-5
/// Description： 	手术台次上移或下移
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ChangeRoomOperSeq("6452","8")
ClassMethod ChangeRoomOperSeq(opsId As %String, direction As %String) As %String
{
	if '(##class(CIS.AN.OperSchedule).%ExistsId(opsId)) quit "E^手术安排参数错误！"
	quit:(direction="") "E^手术移动方向不能为空"
	set $zt="Error"
	tstart
	set saveResult=""
	kill seqList,roomSeqList
	set seqList="",operRoomId=""
		
	set changingObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set:changingObj.ArrOperRoom'="" operRoomId=changingObj.ArrOperRoom.%Id()
	set seq=+changingObj.ArrOperSeq
	set date=changingObj.OperDate
	
	set lastSeq=##class(CIS.AN.BL.OperArrange).GetLastSequence(date,operRoomId,.seqList)
	merge roomSeqList=seqList(+operRoomId)
	if (direction="up")&(seq'=1)
	{
		set roomSeqList(seq)=roomSeqList(seq-1)
		set roomSeqList(seq-1)=opsId	
	}
	if (direction="down")&(seq'=lastSeq)
	{
		set roomSeqList(seq)=roomSeqList(seq+1)
		set roomSeqList(seq+1)=opsId	
	}
	set saveResult=..SerializeOperSeq(.roomSeqList)
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}

	// by ccq 20200228 排班信息先保存在Arr开头的字段，再进行同步
	set changingObj.OperRoom=changingObj.ArrOperRoom
	set changingObj.OperSeq=changingObj.ArrOperSeq
	set sc=changingObj.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult		
	}

	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-10
/// Description： 	获取最大台次
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).GetLastSequence("")
ClassMethod GetLastSequence(date As %String, operRoomId As %List, ByRef seqList As %List) As %String
{
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date,"")
	set seqList=""
	set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		
		set operRoom=$lg(^CIS.AN.OperScheduleD(opsId),69)
		set operSeq=$lg(^CIS.AN.OperScheduleD(opsId),70)
		if (operSeq>0){
			set seqList(+operRoom,+operSeq)=opsId
		}
	}
	
	quit +$o(seqList(+operRoomId,""),-1)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-10
/// Description： 	获取最大台次
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			data:数据字符串
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).GetLastSequence("")
ClassMethod GetNextSeq(date As %String, operRoomId As %List) As %String
{
	quit:(##class(CF.AN.Location).%ExistsId(operRoomId)=0) ""
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(date,"")
	kill seqList
	set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		
		set operRoom=$lg(^CIS.AN.OperScheduleD(opsId),55)
		set operSeq=$lg(^CIS.AN.OperScheduleD(opsId),56)
		if (operSeq>0){
			set seqList(+operRoom,+operSeq)=opsId
		}
	}
	quit:($d(seqList(+operRoomId))=0) 1
	
	quit ((+$o(seqList(+operRoomId,""),-1))+1)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-08-13
/// Description： 	序列化手术台次
/// Table：        	DHCAN.OperSchedule,DHCAN.SurgicalProcedure
/// Input:			roomSeqList:手术间台次序列
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).SerializeOperSeq("")
ClassMethod SerializeOperSeq(ByRef roomSeqList As %List) As %String
{
	set lastSeqList=""
	set seq=0,counter=0,result="S^"
	for
	{
		set seq=$o(roomSeqList(seq))
		quit:(seq="")
		
		set counter=counter+1
		set opsId=+$g(roomSeqList(seq))
		set opsObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set opsObj.ArrOperSeq=counter
		set status=opsObj.%Save()
		if +status < 1 set result="E^" quit
	}
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	停手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术申请ID，userId:用户ID，stopReason:停手术原因
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).StopOperation("44","10211","")
ClassMethod StopOperation(opsId As %String, userId As %String, stopReason As %String = "") As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.Status.Code="Stop") "E^该手术已经被停止了，不能再次停止。"
	set stopStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Stop")
	quit:(##class(CT.AN.OperStatus).%ExistsId(stopStatusId)=0) "E^手术停止状态不存在。"
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(stopStatusId)
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set arrangeLog=..CreateArrangeLog(opsId,"",userId)
	set arrangeLog.ReleaseDate=+$h
	set arrangeLog.ReleaseTime=$p($h,",",2)
	set arrangeLog.Note="停止手术"
	set sc=arrangeLog.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set stopRet=##class(CIS.AN.SRV.OperAppService).StopOperation(opsId,"")
	quit:($p(stopRet,"^")'="S") stopRet
	quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	恢复手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术申请ID
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).RecoverOperation("75")
ClassMethod RecoverOperation(opsId As %String, userId As %String = "") As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.Status.Code'="Stop") "E^该手术已经未被停止了，不能被恢复。"
	set targetOperStatusCode="Application"
	set:operSchedule.OperRoom'="" targetOperStatusCode="Arrange"
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode(targetOperStatusCode)
	quit:(##class(CT.AN.OperStatus).%ExistsId(arrangeStatusId)=0) "E^手术安排状态不存在。"	
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId)
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	set arrangeLog=..CreateArrangeLog(opsId,"",userId)
	set arrangeLog.ReleaseDate=+$h
	set arrangeLog.ReleaseTime=$p($h,",",2)
	set arrangeLog.Note="恢复手术"
	set sc=arrangeLog.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	手术台次变更
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术申请ID，moveDirection:移动方向
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ChangeOperSeq("171","up")
ClassMethod ChangeOperSeq(opsId As %String, moveDirection As %String = "") As %String
{
	quit:(moveDirection="") "E^移动方向不能为空。"
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.OperRoom="") "E^患者"_operSchedule.PatName_"的手术还未安排手术间。"
	set roomOperList=..GetRoomOperList(operSchedule.OperDate,operSchedule.OperDeptID,operSchedule.OperRoom.%Id())
	set $zt="Error"
	tstart
	set saveResult="S^"
	for i=1:1:roomOperList.Size
	{
		set roomOper=roomOperList.GetAt(i)
		continue:(roomOper.%Id()'=operSchedule.%Id())
		continue:(moveDirection="down")&(i=roomOperList.Size)
		continue:(moveDirection="up")&(i=1)
		set:(moveDirection="down") nextOper=roomOperList.GetAt(i+1)
		set:(moveDirection="up") nextOper=roomOperList.GetAt(i-1)
		set curOperSeq=+operSchedule.OperSeq
		set operSchedule.OperSeq=nextOper.OperSeq
		set operSchedule.ArrOperSeq=nextOper.OperSeq
		set nextOper.OperSeq=curOperSeq
		set nextOper.ArrOperSeq=curOperSeq
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		set sc=nextOper.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	获取手术间手术列表，按台次排序
/// Table：        	CIS.AN.OperSchedule
/// Input:			operDate:手术日期，operDeptId:手术室ID，roomId:手术间ID
/// Return：       	手术间手术列表
/// w ##class(CIS.AN.BL.OperArrange).GetRoomOperList("")
ClassMethod GetRoomOperList(operDate As %String, operDeptId As %String, roomId As %String) As %ListOfObjects
{
	set ret=##class(%ListOfObjects).%New()
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rset.Execute(operDate,operDate,operDeptId,"","","","",roomId)
	k roomOperList
	while(rset.%Next())
	{
		set opsId=rset.Get("RowId")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set roomOperList(+operSchedule.OperSeq)=opsId
	}
	if ($data(roomOperList))
	{
		// 根据台次排序，后将对象插入列表
		set operSeq=0
		for
		{
			set operSeq=$order(roomOperList(operSeq))
			quit:(operSeq="")
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(roomOperList(operSeq))
			do ret.Insert(operSchedule)	
		}	
	}
	quit ret
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	判断首台手术是否有足够的腔镜设备
/// Table：        	CIS.AN.OperSchedule
/// Input:			curOpsId:手术申请ID，deptId：手术室ID
/// Return：       	如果足够返回“Y”,否则返回“N”
/// w ##class(CIS.AN.BL.OperArrange).GetRoomOperList("")
ClassMethod HasEnoughMirrorEquip(curOpsId As %String, deptId As %String) As %String
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
	
	// 已安排的手术无需判断
	if (operSchedule.Status'="")
	{
		quit:("^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^" [ operSchedule.Status.Code) "Y"	
	}
	
	
	set comparePara="腔镜",roomTypePara="R",equipTypePara="普通腔镜^3D腔镜"
	// 非腔镜手术无需判断
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
	set sc=rset.Execute("","","",curOpsId),operDesc=""
	while(rset.%Next())
	{
		set operDesc=rset.Get("OperationDesc")	
	}
	quit:(operDesc '[ comparePara) "Y"
	
	set mirrorOperCount=+..GetFirstMirrorOperCount(deptId,operSchedule.OperDate,comparePara)
	set mirrorEquipCount=+##class(CIS.AN.BL.DeptEquip).GetMirrorEquipCount(deptId,roomTypePara,equipTypePara)	
	quit:(mirrorOperCount>=mirrorEquipCount) "N"
	
	quit "Y"
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	获取首台腔镜手术数量
/// Table：        	CIS.AN.OperSchedule
/// Input:			deptId:手术室ID，operDate:手术日期，comparePara:比较字符串
/// Return：       	首台腔镜手术数量
/// w ##class(CIS.AN.BL.OperArrange).GetFirstMirrorOperCount("")
ClassMethod GetFirstMirrorOperCount(deptId As %String, operDate As %String, comparePara As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperSchedule:FindOperScheduleList")
	set sc=rset.Execute(operDate,operDate,deptId,"","","","Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut")
	set operCount=0
	while(rset.%Next())
	{
		set operSeq=+rset.Get("OperSeq")
		continue:(operSeq'=1)
		set operDesc=rset.Get("OperationDesc")
		continue:(operDesc '[ comparePara)
		set operCount=operCount+1	
	}	
	quit operCount
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	撤回手术安排信息
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsIdPara：手术申请ID
/// Return：       	首台腔镜手术数量
/// w ##class(CIS.AN.BL.OperArrange).RevokeArrange(200,35)
ClassMethod RevokeArrange(opsIdPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set opsIdCount=$length(opsIdPara,"^")
	set saveResult="S^"
	set NeedAuditOper=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	set NeedAuditEMOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditEMOperation")
	//&sql(select DataValue into :NeedAuditOper from CF_AN.DataConfig where DataKey='NeedAuditOperation')
	//手术申请配置为需要审核时，撤销排班变更状态为"审核"，配置为不需要审核时，撤销排班变更状态为"申请" YuanLin 20200221
	set applicationStatus=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")
	set auditStatus=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
	set bookStatus=applicationStatus,emStatus=applicationStatus 	// 择期手术撤回状态，急诊手术撤回状态
	set:(NeedAuditOper="Y") bookStatus=auditStatus
	set:(NeedAuditEMOperation="Y") emStatus=auditStatus
	for i=1:1:opsIdCount
	{
		set opsId=$piece(opsIdPara,"^",i)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set status=bookStatus
		set:(operSchedule.SourceType="E") status=emStatus
		&sql(update CIS_AN.operschedule set status=:status,operSeq=null,operroom=null,ScrubNurse=null,CircualNurse=null,ArrOperRoom=null,ArrOperSeq=null,ArrScrubNurse=null,ArrCircualNurse=null where RowId=:opsId)
		set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^撤回失败。"
		//set saveResult=##class(CIS.AN.BL.Interface).RevokeArrange(opsId)
		quit:($piece(saveResult,"^",1)="E")
		set arrangeLog=..CreateArrangeLog(opsId,"",userId)
		set arrangeLog.Note="撤回排班"
		set status=arrangeLog.%Save()
		if ($System.Status.IsError(status))
		{
			set saveResult="E^"_$System.Status.GetErrorText(status)	
		}
		quit:($piece(saveResult,"^",1)="E")
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"RA",userId,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
		//20230221
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,userId,"6")
	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 清空麻醉护士
		set saveResult=##class(CIS.AN.BL.AnaArrange).ClearArrAnaNurse(opsId)
	}
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用接口回写旧表
		set statusCode="A"
		set saveResult=##class(CIS.AN.SRV.OperAppService).RevokeArrange(opsId,statusCode)
	}
	set opaId=""
	if ($piece(saveResult,"^",1)="S")
	{
		// 调用平台接口存入接口表数据
		//set opaId=$p(saveResult,"^",2)
        //set OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULE",opaId)
		//set:(+OAret'=0) saveResult="E^存入接口表数据失败，原因："_$p(OAret,"^",2)
	}
	if ($piece(saveResult,"^",1)="S") && (operSchedule.ExternalID'="")
	{
		//改变医嘱状态(执行->核实) YL 20200612
		set opaId=operSchedule.ExternalID
		set anaId=$p(^DHCANOPArrange(opaId),"^",2)
		set ordId=$o(^OEORDi(0,"Ana",anaId,""))
		set ordSubId=$o(^OEORDi(0,"Ana",anaId,+ordId,""))
		set:ordSubId'="" orderret=##class(appcom.OEOrdItem).Verify(ordId_"||"_ordSubId,userId)
	}
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	陈长青
/// CreatDate：    	2018-10-22
/// Description： 	撤回手术安排信息
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsIdPara：手术申请ID
/// Return：       	首台腔镜手术数量
/// w ##class(CIS.AN.BL.OperArrange).GetFirstMirrorOperCount("")
ClassMethod CancelArrange(opsIdPara As %String, cancelUserId As %String = "") As %String
{
	set $zt="Error"
	tstart
	set opsIdCount=$length(opsIdPara,"^")
	set saveResult="S^"
	set today=+$h,now=$p($h,",",2)
	for i=1:1:opsIdCount
	{
		set opsId=$piece(opsIdPara,"^",i)
		&sql(update CIS_AN.operschedule set status=8 where RowId=:opsId)
		set:(SQLCODE'=0)&(SQLCODE'=100) saveResult="E^取消手术失败。"
		quit:($piece(saveResult,"^",1)="E")	
		&sql(insert into CIS_AN.OperArrange (OperSchedule,OperStatus,Note,ReleaseUser) values (:opsId,8,'',:cancelUserId))
		set:(SQLCODE'=0) saveResult="E^取消手术失败。"
		quit:($piece(saveResult,"^",1)="E")	
		set saveResult=##class(CIS.AN.BL.Interface).RevokeArrange(opsId,"D")
		quit:($piece(saveResult,"^",1)="E")	
	}
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SyncAnaArrangeInfo(operDate As %String) As %String
{
	set $zt="Error"
	tstart
	set opsId=0,saveResult="S^"
	set operDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate)
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",operDate,opsId))
		quit:(opsId="")
		set ansId=$order(^CIS.AN.AnaArrangeI("OPS",opsId,0))
		continue:(##class(CIS.AN.AnaArrange).%ExistsId(ansId)=0)
		set anaSchedule=##class(CIS.AN.AnaArrange).%OpenId(ansId)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		continue:("Accept^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ (operSchedule.Status.Code))
		set operSchedule.AnaExpert=anaSchedule.AnaExpert
		set operSchedule.Anesthesiologist=anaSchedule.Anesthesiologist
		set operSchedule.AnaAssistant=anaSchedule.AnaAssistant
		set operSchedule.AnaAddtionalStaff=anaSchedule.AnaAddtionalStaff
		set operSchedule.PrevAnaMethod=anaSchedule.AnaMethod
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))	
	}
	if ($piece(saveResult,"^",1)'="S"){
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod HasArrangeFirstSeq(operDate As %String, deptID As %String, careProvID As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rset.Execute(operDate,operDate,deptID,"","","","Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut")
	set result="S^"
	while(rset.%Next())
	{
		set operSeq=rset.Get("OperSeq")
		continue:(+operSeq'=1)
		set opsId=rset.Get("RowId")
		set roomDesc=rset.Get("RoomDesc")
		set ansId=""
		&sql(select RowId into :ansId from CIS_AN.AnaArrange where operschedule=:opsId)
		continue:(##class(CIS.AN.AnaArrange).%ExistsId(ansId)=0)
		set anaestSchedule=##class(CIS.AN.AnaArrange).%OpenId(ansId)
		continue:(anaestSchedule.Anesthesiologist'=careProvID)
		set result="E^"_roomDesc	
	}
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-08
/// Description： 	返回术中
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术安排表ID
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ReturnRoomIn("1")
ClassMethod ReturnRoomIn(opsId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	quit:(operSchedule.Status.Code'="RoomOut")&&(operSchedule.Status.Code'="Finish") "E^该手术不是术毕状态，不能返回监护"
	set roomInStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("RoomIn")
	quit:(##class(CT.AN.OperStatus).%ExistsId(roomInStatusId)=0) "E^术中状态不存在"
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(roomInStatusId)
	set sc=operSchedule.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	// 置空麻醉结束时间
	set anaId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set AnaesthesiaObj=##class(CIS.AN.Anaesthesia).%OpenId(anaId)
	set AnaesthesiaObj.TheatreOutDT=""
	do AnaesthesiaObj.%Save()
	
	quit "S^"
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-13
/// Description： 	手术护士保存麻醉方法
/// Table：        	CIS.AN.OperSchedule
/// Input:			
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).SaveAnaestMethod("2018-11-01","8803","1")
ClassMethod SaveAnaestMethod(opsId As %String, anaestMethodId As %String) As %String
{
	if '(##class(CIS.AN.OperSchedule).%ExistsId(opsId)) quit "E^手术安排参数错误！"
	if '(##class(CT.AN.AnaMethod).%ExistsId(anaestMethodId)) quit "E^麻醉方法参数错误！"
	
	set $zt="Error"
	tstart
	set saveResult="S^"
	
	set rowId = $o(^CIS.AN.AnaesthesiaI("OPS",opsId,""))
	if (rowId'="") set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(rowId)
	else  set anaesthesia=##class(CIS.AN.Anaesthesia).%New()
	
	set anaesthesia.OperSchedule = ##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set anaesthesia.AnaMethod = ##class(CT.AN.AnaMethod).%OpenId(anaestMethodId)
	set sc=anaesthesia.%Save()
	
	if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($piece(saveResult,"^",1)'="S"){
		trollback
		quit saveResult	
	}
	
	set anaesthesiaRowId=anaesthesia.%Id()
	set anaCatheterRowId=$o(^CIS.AN.AnaestCatheterI("Ana",anaesthesiaRowId,""))
	if (anaCatheterRowId="")
	{
		set anaesthesiaCatheter=##class(CIS.AN.AnaestCatheter).%New()
		set anaesthesiaCatheter.Anaesthesia = anaesthesia
		set sc=anaesthesiaCatheter.%Save()
		if ($System.Status.IsError(sc)) set saveResult="E^"_$System.Status.GetErrorText(sc)
	}
	
	if ($piece(saveResult,"^",1)'="S"){
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod UpdateOperRoom(opsId As %String, roomId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	quit:(##class(CF.AN.Location).%ExistsId(roomId)=0) "E^手术间不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set oriRoomId="",oriSeq=""
	if (operSchedule.ArrOperRoom'="")
	{
		set oriRoomId=operSchedule.ArrOperRoom.%Id()
		set oriSeq=operSchedule.ArrOperSeq
	}
	
	//set operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(roomId)
	set operSchedule.ArrOperRoom=##class(CF.AN.Location).%OpenId(roomId)
	set operSchedule.OperRoom=operSchedule.ArrOperRoom
	
	// 自动生成台次
	set autoGenSeq=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AutoGenSeq")
	if (autoGenSeq="Y")
	{
		set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)
		if (oriRoomId'=roomId)
		{
			set lastSeq=+(..GetLastSequence(operDate,roomId,.seqList))
			set operSchedule.ArrOperSeq=lastSeq+1	
		}
		
		if (oriRoomId'="") ///调整原手术间的台次
		{
			do ..GetLastSequence(operDate,oriRoomId,.seqList)
			set seq=oriSeq
			for
			{
				set seq=$O(seqList(oriRoomId,seq))
				quit:seq=""
				
				set nextSeqOpsId=seqList(oriRoomId,seq)
				if (##class(CIS.AN.OperSchedule).%ExistsId(nextSeqOpsId)) && (+seq>1)
				{
					set nextSeqOperSchedule=##class(CIS.AN.OperSchedule).%OpenId(nextSeqOpsId)
					set nextSeqOperSchedule.ArrOperSeq=+seq-1
					set nextSeqOperSchedule.OperSeq=+seq-1
					set status=nextSeqOperSchedule.%Save()
				}
			}
		}
	}
	
	if (..#ArrIgnoreStatus '[ operSchedule.Status.Code)
	{
		//去掉提取手术操作后,不再改变状态
		set statusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Receive")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusId)	
	}
	
	
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set oriRoom=""
	if (##class(CF.AN.Location).%ExistsId(oriRoomId))
	{
		set oriRoom=##class(CF.AN.Location).%OpenId(oriRoomId)	
	}
	set arrangeLog=##class(CIS.AN.OperArrange).%New()
	set arrangeLog.OperSchedule=operSchedule
	set arrangeLog.ReleaseUser=##class(CF.AN.SSUser).%OpenId(userId)
	set arrangeLog.OperRoom=operSchedule.ArrOperRoom
	set arrangeLog.ScrubNurse=operSchedule.ArrScrubNurse
	set arrangeLog.CircualNurse=operSchedule.ArrCircualNurse
	set arrangeLog.Note="安排到"_arrangeLog.OperRoom.Description
	set arrangeLog.OperStatus=operSchedule.Status
	if (oriRoom'="")
	{
		set arrangeLog.Note=arrangeLog.Note_"，原手术间"_oriRoom.Description	
	}
	
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

ClassMethod ArrangeOperList(opsIdStr As %String, roomId As %String, scrubNurse1 As %String, scrubNurse2 As %String, cirNurse1 As %String, cirNurse2 As %String = "") As %String
{
	//quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set $zt="Error"
	quit:(##class(CF.AN.Location).%ExistsId(roomId)=0) "E^手术间不存在！"
	tstart
	set opsCount=$l(opsIdStr,"^"),saveResult="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,"^",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"手术记录！"	
		quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set oriRoomId=""
		if (operSchedule.OperRoom'="")
		{
			set oriRoomId=operSchedule.OperRoom.%Id()	
		}
		
		set operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(roomId)
		set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)
		if (oriRoomId'=roomId)
		{
			set lastSeq=+(..GetLastSequence(operDate,roomId,.seqList))
			set operSchedule.OperSeq=lastSeq+1	
		}
		set operSchedule.ScrubNurse=scrubNurse1_","_scrubNurse2
		set operSchedule.CircualNurse=cirNurse1_","_cirNurse2
		set status=operSchedule.%Save()
		set:($System.Status.IsError(status)) saveResult="E^"_$System.Status.GetErrorText(status)
		quit:($System.Status.IsError(status))
	}
	
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult
	}	
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

ClassMethod ArrangeOperListRoom(opsIdStr As %String, roomId As %String) As %String
{
	//quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set $zt="Error"
	quit:(##class(CF.AN.Location).%ExistsId(roomId)=0) "E^手术间不存在！"
	tstart
	set opsCount=$l(opsIdStr,"^"),saveResult="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,"^",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"手术记录！"	
		quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set oriRoomId=""
		if (operSchedule.OperRoom'="")
		{
			set oriRoomId=operSchedule.OperRoom.%Id()	
		}
		
		set operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(roomId)
		set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate)
		if (oriRoomId'=roomId)
		{
			set lastSeq=+(..GetLastSequence(operDate,roomId,.seqList))
			set operSchedule.OperSeq=lastSeq+1	
		}
		set status=operSchedule.%Save()
		set:($System.Status.IsError(status)) saveResult="E^"_$System.Status.GetErrorText(status)
		quit:($System.Status.IsError(status))
	}
	
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult
	}	
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

ClassMethod ArrangeOperListNurse(opsIdStr As %String, operNurse As %String, nurseType As %String) As %String
{
	set $zt="Error"
	tstart
	set opsCount=$l(opsIdStr,"^"),saveResult="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,"^",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveResult="E^不存在ID为"_opsId_"手术记录！"	
		quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		if (nurseType="scrubNurse1")
		{
			set scrubNurse2=$p(operSchedule.ScrubNurse,",",2)
			set operSchedule.ScrubNurse=operNurse_","_scrubNurse2	
		}
		elseif (nurseType="scrubNurse2")
		{
			set scrubNurse1=$p(operSchedule.ScrubNurse,",",1)
			set operSchedule.ScrubNurse=scrubNurse1_","_operNurse	
		}
		elseif (nurseType="cirNurse1")
		{
			set cirNurse2=$p(operSchedule.CircualNurse,",",2)
			set operSchedule.CircualNurse=operNurse_","_cirNurse2
		}
		else
		{
			set cirNurse1=$p(operSchedule.CircualNurse,",",1)
			set operSchedule.CircualNurse=cirNurse1_","_operNurse	
		}
		set status=operSchedule.%Save()
		set:($System.Status.IsError(status)) saveResult="E^"_$System.Status.GetErrorText(status)
		quit:($System.Status.IsError(status))
	}
	
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult
	}	
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

/*
ClassMethod UpdateScrubNurse(opsId As %String, scrubNurseId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operSchedule.ScrubNurse=scrubNurseId
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	quit "S^"
}*/
ClassMethod UpdateScrubNurse(opsId As %String, scrubNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	//set operSchedule.ScrubNurse=scrubNurseId
	set origialNurse=operSchedule.ArrScrubNurse
	set scrubNurseCount=$l(operSchedule.ArrScrubNurse,","),scrubNurseStr=""
	for i=1:1:scrubNurseCount
	{
		if (i=1)
		{
			set origialNurse=$p(operSchedule.ArrScrubNurse,",",1)
			set scrubNurseStr=scrubNurseId		
		} 
		else
		{
			set scrubNurseStr=scrubNurseStr_$p(operSchedule.ArrScrubNurse,",",i)	
		}
		set:(i<scrubNurseCount) scrubNurseStr=scrubNurseStr_","	
	}
	//set operSchedule.ScrubNurse=scrubNurseStr
	set operSchedule.ArrScrubNurse=scrubNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrScrubNurse)
	set arrangeLog.Note="现器械护士："_currentNurseDesc_"，原器械护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// 添加安排的器械护士
ClassMethod AddScrubNurse(opsId As %String, addingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)

	set origialNurse=operSchedule.ArrScrubNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	if $ListFind(origialNurseList,addingNurseId) quit "S^already added"
	
	set newNurseList=origialNurseList_$lb(addingNurseId)
	set newNurseStr=$ListToString(newNurseList,",")
	
	set operSchedule.ArrScrubNurse=newNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrScrubNurse)
	set arrangeLog.Note="现器械护士："_currentNurseDesc_"，原器械护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// 移除安排的器械护士
ClassMethod RemoveScrubNurse(opsId As %String, removingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set origialNurse=operSchedule.ArrScrubNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	set index=$ListFind(origialNurseList,removingNurseId)
	if 'index quit "S^does not exist"
	
	set newNurseList=$ListUpdate(origialNurseList,index,"")
	set newNurseStr=$ListToString(newNurseList,",")
	set newNurseStr=$Replace(newNurseStr,",,",",")
	set length=$l(newNurseStr)
	if $e(newNurseStr,1)="," set newNurseStr=$e(newNurseStr,2,length)
	if $e(newNurseStr,length)="," set newNurseStr=$e(newNurseStr,1,length-1)
	
	set operSchedule.ArrScrubNurse=newNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrScrubNurse)
	set arrangeLog.Note="现器械护士："_currentNurseDesc_"，原器械护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// 添加安排的巡回护士
ClassMethod AddCirNurse(opsId As %String, addingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set origialNurse=operSchedule.ArrCircualNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	if $ListFind(origialNurseList,addingNurseId) quit "S^already added"
	
	set newNurseList=origialNurseList_$lb(addingNurseId)
	set newNurseStr=$ListToString(newNurseList,",")
	
	set operSchedule.ArrCircualNurse=newNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrCircualNurse)
	set arrangeLog.Note="现巡回护士："_currentNurseDesc_"，原巡回护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// 移除安排的巡回护士
ClassMethod RemoveCirNurse(opsId As %String, removingNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set origialNurse=operSchedule.ArrCircualNurse
	set origialNurseList=$ListFromString(origialNurse,",")
	set index=$ListFind(origialNurseList,removingNurseId)
	if 'index quit "S^does not exist"
	
	set newNurseList=$ListUpdate(origialNurseList,index,"")
	set newNurseStr=$ListToString(newNurseList,",")
	set newNurseStr=$Replace(newNurseStr,",,",",")
	set length=$l(newNurseStr)
	if $e(newNurseStr,1)="," set newNurseStr=$e(newNurseStr,2,length)
	if $e(newNurseStr,length)="," set newNurseStr=$e(newNurseStr,1,length-1)
	
	set operSchedule.ArrCircualNurse=newNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrCircualNurse)
	set arrangeLog.Note="现巡回护士："_currentNurseDesc_"，原巡回护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// 交换安排的器械和巡回护士
ClassMethod SwitchNurse(opsId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	set origialNurse=operSchedule.ArrScrubNurse
	set operSchedule.ArrScrubNurse=operSchedule.ArrCircualNurse
	set operSchedule.ArrCircualNurse=origialNurse
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set scrubNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrScrubNurse)
	set circualNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrCircualNurse)
	set arrangeLog.Note="交换已安排的器械护士："_scrubNurseDesc_"→巡回，巡回护士："_circualNurseDesc_"→器械"
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// w ##class(CIS.AN.BL.OperArrange).CreateArrangeLog(44,"",35)
ClassMethod CreateArrangeLog(opsId As %String, reasonType As %String, userId As %String) As CIS.AN.OperArrange
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set arrangeLog=##class(CIS.AN.OperArrange).%New()
	set arrangeLog.OperSchedule=operSchedule
	set arrangeLog.OperRoom=operSchedule.ArrOperRoom
	set arrangeLog.ReleaseUser=userId
	//set arrangeLog.ReleaseUser=##class(CF.AN.SSUser).%OpenId(userId)
	set arrangeLog.OperSeq=operSchedule.ArrOperSeq
	set arrangeLog.ScrubNurse=operSchedule.ArrScrubNurse
	set arrangeLog.CircualNurse=operSchedule.ArrCircualNurse
	set arrangeLog.OperStatus=operSchedule.Status	
	quit arrangeLog
}

/*
ClassMethod UpdateFirstCirNurse(opsId As %String, cirNurseId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operSchedule.CircualNurse=cirNurseId
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	quit "S^"
}
*/
ClassMethod UpdateFirstCirNurse(opsId As %String, cirNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	//set operSchedule.CircualNurse=cirNurseId
	set origialNurse=operSchedule.ArrCircualNurse
	set scrubNurseCount=$l(operSchedule.ArrCircualNurse,","),scrubNurseStr=""
	for i=1:1:scrubNurseCount
	{
		if (i=1)
		{
			set scrubNurseStr=cirNurseId	
			set origialNurse=$p(operSchedule.ArrCircualNurse,",",1)	
		} 
		else
		{
			set scrubNurseStr=scrubNurseStr_$p(operSchedule.ArrCircualNurse,",",i)	
		}
		set:(i<scrubNurseCount) scrubNurseStr=scrubNurseStr_","	
	}
	//set operSchedule.CircualNurse=scrubNurseStr
	set operSchedule.ArrCircualNurse=scrubNurseStr
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ArrCircualNurse)
	set arrangeLog.Note="现巡回护士："_currentNurseDesc_"，原巡回护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/*
ClassMethod UpdateSecCirNurse(opsId As %String, cirNurseId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operSchedule.SecCirNurse=cirNurseId
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	quit "S^"
}
*/
ClassMethod UpdateSecCirNurse(opsId As %String, cirNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	//set operSchedule.SecCirNurse=cirNurseId
	set origialNurse=operSchedule.ArrCircualNurse
	set scrubNurseCount=$l(operSchedule.ArrCircualNurse,","),scrubNurseStr=""
	if (scrubNurseCount=1)
	{
		set operSchedule.ArrCircualNurse=operSchedule.ArrCircualNurse_","_cirNurseId	
	}
	else
	{
		for i=1:1:scrubNurseCount
		{
			if (i=2)
			{
				set origialNurse=$p(operSchedule.ArrCircualNurse,",",2)
				set scrubNurseStr=scrubNurseStr_cirNurseId		
			} 
			else
			{
				set scrubNurseStr=scrubNurseStr_$p(operSchedule.ArrCircualNurse,",",i)	
			}
			set:(i<scrubNurseCount) scrubNurseStr=scrubNurseStr_","	
		}
		set operSchedule.ArrCircualNurse=scrubNurseStr	
	}
	
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ScrubNurse)
	set arrangeLog.Note="现巡回护士："_currentNurseDesc_"，原巡回护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	
	quit "S^"
}

/// w ##class(CIS.AN.BL.OperArrange).AcceptOperList("2020-01-08","10211")
ClassMethod AcceptOperList(operDate As %String, acceptUserId As %String) As %String
{
	set $zt="Error"
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set opsId=0,saveResult="E^未更新任何记录！"
	set needAuditOperation=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("NeedAuditOperation")
	b ;
	tstart
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set statusCode=operSchedule.Status.Code
		set sourceType=operSchedule.SourceType
		// 择期手术，且需要审核手术，只有审核状态的手术才被提取
		continue:(sourceType'="E")&(statusCode'="Audit")&(needAuditOperation="Y")
		// 择期手术，且不需要审核手术，申请和审核状态的手术才被提取
		continue:(sourceType'="E")&(statusCode'="Audit")&(statusCode'="Application")&(needAuditOperation'="Y")
		// 急诊手术，要求申请和审核状态的手术都会被提取
		continue:(sourceType="E")&(statusCode'="Audit")&(statusCode'="Application")
		set statusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Accept")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusID)
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		set surProc=##class(CIS.AN.OperArrange).%New()
		set surProc.OperSchedule=operSchedule
		set surProc.OperStatus=operSchedule.Status
		set surProc.ReleaseUser=##class(CF.AN.SSUser).%OpenId(acceptUserId)
		set surProc.Note="提取手术"
		set sc=surProc.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		
		//set saveResult=##class(CIS.AN.BL.Interface).AcceptArrange(opsId)
		//quit:($p(saveResult,"^",1)="E")
		set saveResult="S^"
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperArrange).SubmitOperList("2021-09-30",10211)
ClassMethod SubmitOperList(operDate As %String, arrangeUserId As %String) As %String
{
	set $zt="Error"
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set opsId=0,saveResult="E^状态不符合条件或未更新任何记录！"
	tstart
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set statusCode=operSchedule.Status.Code
		;continue:(..#ArrIgnoreStatus '[ statusCode)
		continue:(..#SubmitIgnoreStatus [ statusCode)
		set operRoom=operSchedule.ArrOperRoom
		continue:(operRoom="")	// 无手术间手术不能提交
		set EpisodeID=operSchedule.EpisodeID
		set paadmStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		continue:(paadmStatus="C")	// 该就诊记录已经取消
		continue:(paadmStatus="D")	// 该患者已出院
		set operSchedule.OperRoom=operSchedule.ArrOperRoom
		set operSchedule.OperSeq=operSchedule.ArrOperSeq
		set operSchedule.ScrubNurse=operSchedule.ArrScrubNurse
		set operSchedule.CircualNurse=operSchedule.ArrCircualNurse
		set circualNurse=$tr(operSchedule.CircualNurse,",","")
		set scrubNurse=$tr(operSchedule.ScrubNurse,",","")
		if (circualNurse="")&(scrubNurse="")
		{
			set preNurse=..GetPreSeqNurse(opsId)
			
			set operSchedule.ArrScrubNurse=$p(preNurse,"#",1)
			set operSchedule.ArrCircualNurse=$p(preNurse,"#",2)
			set operSchedule.ScrubNurse=$p(preNurse,"#",1)
			set operSchedule.CircualNurse=$p(preNurse,"#",2)	
		}
		;continue:(circualNurse="")&(scrubNurse="")  // 无巡回护士手术不能提交
		set statusID=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
		set:(..#SubmitIgnoreStatus '[ statusCode) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusID)
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		set arrangeLog=..CreateArrangeLog(opsId,"",arrangeUserId)
		set arrangeLog.Note="发布排班"
		set sc=arrangeLog.%Save()
		set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
		set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",arrangeUserId,+$h,$p($h,",",2))
		quit:($p(saveResult,"^",1)="E")
		set saveResult="S^"
				//20211214
		s retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,arrangeUserId,"5")

		do ..AfterSubmitArrange(opsId,arrangeUserId)
	}
	b
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	
	do ##class(CIS.AN.BL.AnaArrange).SyncArrAnaNurse(operDate,arrangeUserId)
	do ..TriggerEvent(operDate)
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

ClassMethod TriggerEvent(operDate) As %String
{
	try
	{
		set args=##class(CIS.AN.DTO.Event.Args.OnArrangeSubmit).%New()
		set args.Date=operDate
		
		set sc=##class(CIS.AN.SRV.Event.OnArrangeSubmit).Trigger(args)
	}
	catch(e)
	{
		write e.DisplayString(),!
	}
	quit ""
}

ClassMethod AfterSubmitArrange(opsId, arrangeUserId) As %Status
{
	try
	{
		//set extUserId=##class(CIS.AN.SRV.IMedicalService).GetRowIdByExt("CF_AN.SSUser",arrangeUserId)
		set saveResult=##class(CIS.AN.SRV.OperAppService).SendOperArrange(opsId,arrangeUserId)
		set saveResult="S^"
		//quit:($p(saveResult,"^",1)="E")
		//set saveResult=##class(CIS.AN.BL.Interface).SubmitArrange(opsId,arrangeUserId)
		//quit:($p(saveResult,"^",1)="E")
		// 调用消息平台接口	
		set opaId=$lg(^CIS.AN.OperScheduleD(opsId),2)
		//改变医嘱状态(核实->执行) YL 20200612
		//set anaId=$p(^DHCANOPArrange(opaId),"^",2)
		//set ordId=$o(^OEORDi(0,"Ana",anaId,""))
		//set ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		//set orderret=##class(appcom.OEOrdItem).Execute(ordId_"||"_ordSubId,arrangeUserId)
		
		set OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONSCHEDULEINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术排班消息失败，原因："_$p(OAret,"^",2)
	}
	catch(e)
	{
		
	}
	
	quit $$$OK
}

ClassMethod GetPreSeqNurse(curOpsId As %String) As %String
{
	set curOperSchedule=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
	set date=##class(CIS.AN.COM.DateTime).ConvertToDate(curOperSchedule.OperDate,"")
	set curRoomId=curOperSchedule.ArrOperRoom.%Id()
	set curOperSeq=+curOperSchedule.ArrOperSeq,operSeq=curOperSeq
	set lastSeq=##class(CIS.AN.BL.OperArrange).GetLastSequence(date,curRoomId,.seqList)
	set scrubNurse="",cirNurse=""
	for
	{
		set operSeq=$o(seqList(curRoomId,operSeq),-1)
		quit:(operSeq="")!(scrubNurse'="")
		set opsId=seqList(curRoomId,operSeq)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set curScrubNurse=$tr(operSchedule.ArrScrubNurse,",","")
		continue:(curScrubNurse="")
		set scrubNurse=operSchedule.ArrScrubNurse	
	}
	
	set operSeq=curOperSeq
	for
	{
		set operSeq=$o(seqList(curRoomId,operSeq),-1)
		quit:(operSeq="")!(cirNurse'="")
		set opsId=seqList(curRoomId,operSeq)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set curCirNurse=$tr(operSchedule.ArrCircualNurse,",","")
		continue:(curCirNurse="")
		set cirNurse=operSchedule.ArrCircualNurse	
	}
	
	quit scrubNurse_"#"_cirNurse
}

/// w ##class(CIS.AN.BL.OperArrange).UpdateOperSeq(309,2)
ClassMethod UpdateOperSeq(opsId As %String, operSeq As %String) As %String
{
	set $zt="Error"
	tstart
	set saveResult="E^未更新任何记录"
	set operRoomId=""
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set autoGenSeq=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("AutoGenSeq")
	if (autoGenSeq="Y")
	{
		set operRoomId=operSchedule.ArrOperRoom.%Id()
		if operRoomId="" TRollBack  q "E^手术间不能为空,请先安排手术间!"
		set operDate=##class(CIS.AN.COM.DateTime).ConvertToDate(operSchedule.OperDate,"")
		set lastSeq=..GetLastSequence(operDate,operRoomId,.seqList)
		set loopSeq=0
		kill newSeqList
		for
		{
			set loopSeq=$o(seqList(operRoomId,loopSeq))
			quit:(loopSeq="")
			set curOpsId=seqList(operRoomId,loopSeq)
			if (curOpsId=opsId)
			{
				set newSeqList(operRoomId,+operSeq)=opsId	
			}
			else
			{
				if (loopSeq>=(+operSeq))
				{
					set newSeqList(operRoomId,(loopSeq+1))=curOpsId	
				}	
				else
				{
					set newSeqList(operRoomId,loopSeq)=curOpsId	
				}
			}	
		}
		set:(+loopSeq=0) newSeqList(operRoomId,((+lastSeq)+1))=opsId
		set loopSeq=0,saveResult="E^未更新任何记录"
		for
		{
			set loopSeq=$o(newSeqList(operRoomId,loopSeq))
			quit:(loopSeq="")
			set curOpsId=newSeqList(operRoomId,loopSeq)
			set schedule=##class(CIS.AN.OperSchedule).%OpenId(curOpsId)
			set schedule.ArrOperSeq=loopSeq
		    set operSchedule.OperSeq=loopSeq
			set sc=schedule.%Save()
			set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
			quit:($System.Status.IsError(sc))
			set saveResult="S^"
		}
	}
	else
	{
		set operSchedule.ArrOperSeq=operSeq
		set operSchedule.OperSeq=operSeq
		set sc= operSchedule.%Save()
		if ($System.Status.IsError(sc))
		{
			set saveResult="E^"_$System.Status.GetErrorText(sc)		
		}
		else
		{
			set saveResult="S^"	
		}
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	d ##class(CIS.AN.BL.OperArrange).UpdateOpRoomOperSeq(opsId,operSeq)
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// 更新手术间所有手术台次20211012whl
/// w ##class(CIS.AN.BL.OperArrange).UpdateOpRoomOperSeq(1357,2)
ClassMethod UpdateOpRoomOperSeq(opsIdold As %String, operSeqold As %String) As %String
{
	set curoperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsIdold)
    set:curoperSchedule.ArrOperRoom'="" curOperRoomId=curoperSchedule.ArrOperRoom.%Id()
    set dateH=curoperSchedule.OperDate
    set curoperSchedule.OperSeq=operSeqold
	set sc= curoperSchedule.%Save()
    set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		quit:(opsId="")
		quit:(opsIdold=opsId)
 		set:operSchedule.ArrOperRoom'="" operRoomId=operSchedule.ArrOperRoom.%Id()
 		set OperSeq=operSchedule.OperSeq
 		continue:OperSeq=""
		continue:(curOperRoomId'=operRoomId)
		;set ret=..ChangeRoomOperSeq(opsId,"up")
		;set ret=..ChangeRoomOperSeq(opsId,"down")
		if (OperSeq>=operSeqold)  
		{
		  set OperSeq=OperSeq+1
 		  set operSchedule.OperSeq=OperSeq
	      set sc= operSchedule.%Save()
 		}
	}
	
	quit 0
}

/// Creator：      	雍阳
/// CreatDate：    	2020-08-11
/// Description： 	保存多个手术安排台次
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:数据参数，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperArrange).UpdateOperSeqList("","")
ClassMethod UpdateOperSeqList(data As %String, userId As %String) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		
		set opsId=array(objIndex,"RowId")
		set seq=array(objIndex,"ArrOperSeq")
		
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set operSchedule.ArrOperSeq=seq
		
		set sc=operSchedule.%Save()
		if ($System.Status.IsError(sc))
		{
			set saveResult="E^"_$System.Status.GetErrorText(sc)	
			quit	
		}
		else
		{
			set saveResult="S^"	
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2020-08-11
/// Description： 	保存多个手术安排台次
/// Table：        	CIS.AN.OperSchedule
/// Input:			data:数据参数，userId:用户ID
/// Return：       	保存成功返回"S^"，失败返回"E^原因"
/// Debug:			w ##class(CIS.AN.BL.OperArrange).UpdateOperSeqList("","")
ClassMethod UpdateEstimatedTimeList(data As %String, userId As %String) As %String
{
	quit:(data="") "E^保存的数据不能为空！"
	
	set $zt="Error"
	tstart
	set sc=##class(CIS.AN.COM.String).ToArray(data,.array)
	set objIndex=0,saveResult="S^"
	for
	{
		set objIndex=$order(array(objIndex))
		quit:(objIndex="")
		
		set opsId=array(objIndex,"RowId")
		set time=array(objIndex,"EstimatedOperTime")
		
		if ##class(CIS.AN.OperSchedule).%ExistsId(opsId)
		{
			set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
			set operSchedule.EstimatedOperTime=##class(CIS.AN.COM.DateTime).ConvertToTimeH(time,"")
		
		
			set sc=operSchedule.%Save()
			if ($System.Status.IsError(sc))
			{
				set saveResult="E^"_$System.Status.GetErrorText(sc)	
				quit	
			}
			else
			{
				set saveResult="S^"	
			}
		}
	}
	
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit "S^"

Error
	trollback
	quit "E^"_$ze
}

// w ##class(CIS.AN.BL.OperArrange).UpdateSecScrubNurse("51","1868")

ClassMethod UpdateSecScrubNurse(opsId As %String, scrubNurseId As %String, userId As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术记录不存在！"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	//set operSchedule.ScrubNurse=$p(operSchedule.ScrubNurse,",",1)_","_scrubNurseId
	set origialNurse=operSchedule.ArrScrubNurse
	set scrubNurseCount=$l(operSchedule.ArrScrubNurse,","),scrubNurseStr=""
	if (scrubNurseCount=1)
	{
		set operSchedule.ArrScrubNurse=operSchedule.ArrScrubNurse_","_scrubNurseId	
	}
	else
	{
		for i=1:1:scrubNurseCount
		{
			if (i=2)
			{
				set scrubNurseStr=scrubNurseStr_scrubNurseId
				set origialNurse=$p(operSchedule.ArrScrubNurse,",",2)		
			} 
			else
			{
				set scrubNurseStr=scrubNurseStr_$p(operSchedule.ArrScrubNurse,",",i)	
			}
			set:(i<scrubNurseCount) scrubNurseStr=scrubNurseStr_","	
		}	
		set operSchedule.ArrScrubNurse=scrubNurseStr
	}
	
	
	set status=operSchedule.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}	
	
	set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
	set origialNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(origialNurse)
	set currentNurseDesc=##class(CIS.AN.BL.OperationList).GetCareProvDesc(operSchedule.ScrubNurse)
	set arrangeLog.Note="现器械护士："_currentNurseDesc_"，原器械护士："_origialNurseDesc
	set status=arrangeLog.%Save()
	if ($System.Status.IsError(status))
	{
		quit "E^"_$System.Status.GetErrorText(status)	
	}
	
	quit "S^"
}

/// w ##class(CIS.AN.BL.OperArrange).ChangeOperListStatus("2019-04-05","2019-04-25","116")
ClassMethod ChangeOperListStatus(startDate As %String, endDate As %String, deptId As %String, opsId As %String = "") As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleStatistics:FindOperScheduleList")
	set sc=rs.Execute(startDate,endDate,deptId,opsId)
	set $zt="Error"
	set ret="S^"
	while(rs.%Next())
	{
		set opsId=rs.Get("RowId")
		set ret=..ChangeFinishStatus(opsId)
		quit:($p(ret,"^",1)="E")	
	}	
	quit ret
Error
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperArrange).ChangeFinishStatus("118")
ClassMethod ChangeFinishStatus(opsId As %String) As %String
{
	set ret="S^"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operStartDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","OperStartDT")
	set operEndDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","OperFinishDT")
	if (operStartDT'="")&(operEndDT'="")&(operSchedule.AnaStartDT="")
	{
		if ("Application^Accept^Arrange" [ operSchedule.Status.Code)	
		{
			set statusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("RoomOut")
			set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusId)
			set sc=operSchedule.%Save()
			set:($System.Status.IsError(sc)) ret="E^"_$System.Status.GetErrorText(sc)	
		}
	}	
	quit ret
}

/// w ##class(CIS.AN.BL.OperArrange).ChangeOperListStatusNew("2019-04-05","2019-04-25","116")
ClassMethod ChangeOperListStatusNew(startDate As %String, endDate As %String, deptId As %String, opsId As %String = "") As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleStatistics:FindOperScheduleList")
	set sc=rs.Execute(startDate,endDate,deptId,opsId)
	set $zt="Error"
	set ret="S^"
	while(rs.%Next())
	{
		set opsId=rs.Get("RowId")
		set ret=..ChangeFinishStatusNew(opsId)
		quit:($p(ret,"^",1)="E")	
	}	
	quit ret
Error
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperArrange).ChangeFinishStatus("118")
ClassMethod ChangeFinishStatusNew(opsId As %String) As %String
{
	set ret="S^"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operStartDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","OperStartDT")
	set operEndDT=##class(CIS.AN.BL.OperData).GetOperDataByCode(opsId,"OperCount","OperFinishDT")
	;if (operStartDT'="")&(operEndDT'="")&(operSchedule.AnaStartDT="")
	if (operSchedule.TheatreInDT'="")&(operSchedule.TheatreOutDT'="")&(operSchedule.AnaStartDT'="")
	{
		if ("Stop^Cancel^Decline" [ operSchedule.Status.Code)	
		{
			set statusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("RoomOut")
			set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(statusId)
			set sc=operSchedule.%Save()
			set:($System.Status.IsError(sc)) ret="E^"_$System.Status.GetErrorText(sc)	
		}
	}	
	quit ret
}

/// 保存手术列表排班
ClassMethod SaveOperListArrange(opsId As %String, dataPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	k array
	set status=##class(CIS.AN.COM.String).ToArray(dataPara,.array)	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operRoom=$g(array(1,"OperRoom")),operSeq=$g(array(1,"OperSeq"))
	set scrubNurse=$g(array(1,"ScrubNurse")),circualNurse=$g(array(1,"CircualNurse"))
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.ArrOperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set operSchedule.OperSeq=operSeq
	set operSchedule.ArrOperSeq=operSeq
	set operSchedule.ScrubNurse=scrubNurse
	set operSchedule.ArrScrubNurse=scrubNurse
	set operSchedule.CircualNurse=circualNurse
	set operSchedule.ArrCircualNurse=circualNurse
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set operArrangeLog=..CreateArrangeLog(opsId,"手术排班",userId)
	set sc=operArrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set saveRet=##class(CIS.AN.SRV.OperAppService).SendOperArrange(opsId,userId)
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperArrange).ArrangeOperation("302","7","OperRoom","10211")
ClassMethod ArrangeOperation(opsId As %String, arrangeInfo As %String, arrangCode As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	if (arrangCode="OperRoom")
	{
		if (operSchedule.OperRoom=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set:(##class(CF.AN.Location).%ExistsId(arrangeInfo)) operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(arrangeInfo)
		set:(##class(CF.AN.Location).%ExistsId(arrangeInfo)) operSchedule.ArrOperRoom=##class(CF.AN.Location).%OpenId(arrangeInfo)
	}
	elseif (arrangCode="OperSeq")
	{
		if (operSchedule.OperSeq=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set operSchedule.OperSeq=arrangeInfo
		set operSchedule.ArrOperSeq=arrangeInfo
	}
	elseif (arrangCode="ScrubNurse")
	{
		if (operSchedule.ScrubNurse=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set operSchedule.ScrubNurse=arrangeInfo
		set operSchedule.ArrScrubNurse=arrangeInfo
	}
	elseif (arrangCode="CircualNurse")
	{
		if (operSchedule.CircualNurse=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set operSchedule.CircualNurse=arrangeInfo
		set operSchedule.ArrCircualNurse=arrangeInfo
	}
	
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set operArrangeLog=..CreateArrangeLog(opsId,"手术排班",userId)
	set sc=operArrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set saveRet=##class(CIS.AN.SRV.OperAppService).SendOperArrange(opsId,userId)
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// 保存手术列表麻醉排班
/// d ##class(CIS.AN.BL.OperArrange).ArrangeAnaest(326,614,"Anesthesiologist",12175)
ClassMethod ArrangeAnaest(opsId As %String, arrangeInfo As %String, arrangeCode As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set:(arrangeCode="AnaMethod") operSchedule.PrevAnaMethod=arrangeInfo
	
	
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	if (arrangeCode="AnaExpert")
	{
		if (anaesthesia.AnaExpert=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set anaesthesia.AnaExpert=arrangeInfo
		set anaesthesia.ArrAnaExpert=arrangeInfo
	}
	elseif (arrangeCode="Anesthesiologist")
	{
		if (anaesthesia.Anesthesiologist=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set anaesthesia.Anesthesiologist=arrangeInfo
		set anaesthesia.ArrAnesthesiologist=arrangeInfo
	}
	elseif (arrangeCode="AnaAssistant")
	{
		if (anaesthesia.AnaAssistant=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set anaesthesia.AnaAssistant=arrangeInfo
		set anaesthesia.ArrAnaAssistant=arrangeInfo
	}
	elseif (arrangeCode="AnaMethod")
	{
		if (anaesthesia.AnaMethod=arrangeInfo)
		{
			tcommit
			quit "S^"	
		}
		set saveRet=##class(CIS.AN.BL.AnaArrange).UpdateAnaMethod(opsId,arrangeInfo)
		if ($p(saveRet,"^",1)'="S")
		{
			trollback
			quit saveRet	
		}
	}
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	if (arrangeCode'="AnaMethod")
	{
		set sc=anaesthesia.%Save()
		if ($System.Status.IsError(sc))
		{
			trollback
			quit "E^"_$System.Status.GetErrorText(sc)	
		}
	}
	
	set arrangeLog=##class(CIS.AN.BL.AnaArrange).CreateArrangeLog(opsId,"麻醉排班",userId)
	if ($p(arrangeLog,"^",1)'="S")
	{
		trollback
		quit arrangeLog	
	}
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ANA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// 保存手术列表麻醉排班
ClassMethod SaveAnaListArrange(opsId As %String, dataPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	k array
	set anaMethod=$g(array(1,"AnaMethod")),anaExpert=$g(array(1,"AnaExpert"))
	set anaAssistant=$g(array(1,"AnaAssistant")),anaDoc=$g(array(1,"Anesthesiologist"))
	set anaStaff=$g(array(1,"AnaStaff"))
	set status=##class(CIS.AN.COM.String).ToArray(dataPara,.array)	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set operSchedule.PrevAnaMethod=anaMethod
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	set anaesthesia.Anesthesiologist=anaDoc
	set anaesthesia.ArrAnesthesiologist=anaDoc
	set anaesthesia.AnaExpert=anaExpert
	set anaesthesia.ArrAnaExpert=anaExpert
	set anaesthesia.AnaAssistant=anaAssistant
	set anaesthesia.ArrAnaAssistant=anaAssistant
	set anaesthesia.AnaStaff=anaStaff
	set anaesthesia.ArrAnaStaff=anaStaff
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.AnaArrange).UpdateAnaMethod(opsId,anaMethod)
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set arrangeLog=##class(CIS.AN.BL.AnaArrange).CreateArrangeLog(opsId,"麻醉排班",userId)
	set sc=arrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ANA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// 保存手术+麻醉排班
ClassMethod SaveAllListArrange(opsId As %String, dataPara As %String, userId As %String) As %String
{
	set $zt="Error"
	tstart
	k array
	set status=##class(CIS.AN.COM.String).ToArray(dataPara,.array)	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set operRoom=$g(array(1,"OperRoom")),operSeq=$g(array(1,"OperSeq"))
	set scrubNurse=$g(array(1,"ScrubNurse")),circualNurse=$g(array(1,"CircualNurse"))
	set anaMethod=$g(array(1,"AnaMethod")),anaExpert=$g(array(1,"AnaExpert"))
	set anaAssistant=$g(array(1,"AnaAssistant")),anaDoc=$g(array(1,"Anesthesiologist"))
	set anaStaff=$g(array(1,"AnaStaff"))
	
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.OperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set:(##class(CF.AN.Location).%ExistsId(operRoom)) operSchedule.ArrOperRoom=##class(CF.AN.Location).%OpenId(operRoom)
	set operSchedule.OperSeq=operSeq
	set operSchedule.ArrOperSeq=operSeq
	set operSchedule.ScrubNurse=scrubNurse
	set operSchedule.ArrScrubNurse=scrubNurse
	set operSchedule.CircualNurse=circualNurse
	set operSchedule.ArrCircualNurse=circualNurse
	set arrangeStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Arrange")
	set:("Arrange^AreaIn^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut" '[ operSchedule.Status.Code) operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(arrangeStatusId) 
	set sc=operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set operArrangeLog=..CreateArrangeLog(opsId,"手术排班",userId)
	set sc=operArrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set anaestId=##class(CIS.AN.BL.Anaesthesia).GetMainAnaId(opsId)
	set anaesthesia=##class(CIS.AN.Anaesthesia).%OpenId(anaestId)
	set anaesthesia.Anesthesiologist=anaDoc
	set anaesthesia.ArrAnesthesiologist=anaDoc
	set anaesthesia.AnaExpert=anaExpert
	set anaesthesia.ArrAnaExpert=anaExpert
	set anaesthesia.AnaAssistant=anaAssistant
	set anaesthesia.ArrAnaAssistant=anaAssistant
	set anaesthesia.AnaStaff=anaStaff
	set anaesthesia.ArrAnaStaff=anaStaff
	set anaesthesia.PrevAnaMethod=anaMethod
	set sc=anaesthesia.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.AnaArrange).UpdateAnaMethod(opsId,anaMethod)
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	set arrangeLog=##class(CIS.AN.BL.AnaArrange).CreateArrangeLog(opsId,"麻醉排班",userId)
	set sc=arrangeLog.%Save()
	if ($System.Status.IsError(sc))
	{
		trollback
		quit "E^"_$System.Status.GetErrorText(sc)	
	}
	
	set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"ANA",userId,+$h,$p($h,",",2))
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	
	
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// 判断手术间的台次是否存在
ClassMethod ExistsOperSeq(operDate As %String, operRoomId As %String, operSeq As %String) As %String
{
	set dateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDate,"")
	set operSeq=+operSeq
	set ret="N"
	set opsId=0
	for
	{
		set opsId=$order(^CIS.AN.OperScheduleI("OPDate",dateH,opsId))
		quit:(opsId="")
		set curOperRoomId=$lg(^CIS.AN.OperScheduleD(opsId),55)
		continue:(curOperRoomId'=operRoomId)
		//set curOperSeq=$lg(^CIS.AN.OperScheduleD(opsId),70)
		set curOperSeq=$lg(^CIS.AN.OperScheduleD(opsId),56)
		set:(+curOperSeq=operSeq) ret="Y"
		quit:(ret="Y")
	}
	
	quit ret
}

/// 拒绝手术
/// d ##class(CIS.AN.BL.OperArrange).DeclineOperation(33,18885)
ClassMethod DeclineOperation(opsIdStr As %String, userId As %String) As %String
{
	quit:(opsIdStr="") "E^手术ID不能为空"
	set $zt="Error"
	tstart
	set opsCount=$l(opsIdStr,","),saveRet="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveRet="E^不存ID为"_opsId_"的手术申请。"
		quit:($p(saveRet,"^",1)'="S")
		
		set declineStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Decline")
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set NeedAuditOperation=##class(CIS.AN.BL.OperApplication).NeedAuditOperation(opsId)
		set:("Audit^Arrange" '[ operSchedule.Status.Code)&(NeedAuditOperation="Y") saveRet="E^只能拒绝审核和安排状态的手术。"
		set:("Application^Arrange" '[ operSchedule.Status.Code)&(NeedAuditOperation'="Y") saveRet="E^只能拒绝申请和安排状态的手术。"
		quit:($p(saveRet,"^",1)'="S")
		
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(declineStatusId)
		set operSchedule.OperRoom=""
		set operSchedule.OperSeq=""
		set operSchedule.ScrubNurse=""
		set operSchedule.CircualNurse=""
		set operSchedule.ArrCircualNurse=""
		set operSchedule.ArrScrubNurse=""
		set operSchedule.ArrOperRoom=""
		set operSchedule.ArrOperSeq=""
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")
		
		set arrangeLog=..CreateArrangeLog(opsId,"",userId)
		set arrangeLog.Note="拒绝手术"
		set sc=arrangeLog.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")
		
		set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPD",userId,+$h,$p($h,",",2))
		quit:($p(saveRet,"^",1)'="S")
	}
	
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	tcommit
	
	set opsCount=$l(opsIdStr,",")
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		do ..AfterDeclineOper(opsId,userId)
	}
	
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

/// d ##class(CIS.AN.BL.OperArrange).AfterDeclineOper(38,18885)
ClassMethod AfterDeclineOper(opsId, userId) As %Status
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operSchedule.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		//write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	try
	{
		// 发送拒绝手术消息
		set actionUserId=operSchedule.AppUserID
		set actionDeptId=operSchedule.AppDeptID
	    set SendOperMessage=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("SendOperMessage")
		if (SendOperMessage="Y") Set rtnMes =##class(websys.DHCMessageInterface).Send("拒绝手术", "1054", userId, operSchedule.EpisodeID ,"",actionUserId, "opaId为"_opaId ,actionDeptId_"|OnlyFlag")
		//write "send to MS:",rtnMes,!	
	}
	catch(e)
	{
		write "DTS:发送拒绝手术消息错误:",e.DisplayString(),!
	}
	
	try
	{
		set saveRet=##class(CIS.AN.SRV.OperAppService).DeclineApplication(opsId,userId)
	}
	catch(e)
	{
		//write "DTS:调用旧版兼容接口错误:",e.DisplayString(),!
	}
	try
	{
		//改变医嘱状态(执行->核实) YL 20210629
		set opaId=operSchedule.ExternalID
		set anaId=$p(^DHCANOPArrange(opaId),"^",2)
		set ordId=$o(^OEORDi(0,"Ana",anaId,""))
		set ordSubId=$o(^OEORDi(0,"Ana",anaId,+ordId,""))
		set:ordSubId'="" orderret=##class(appcom.OEOrdItem).Verify(ordId_"||"_ordSubId,userId)
	}
	catch(e)
	{
		//write "改变医嘱状态错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod AfterCancelOper(opsId) As %Status
{
	set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operScheduleObj.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	try
	{
		set retCircle=##class(web.DHCANAdaptor).UpdateOperCircle(opsId,operScheduleObj.AppUserID,"2")
	}
	catch(e)
	{
		//write "DTS:调用手术闭环状态接口错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

/// 取消拒绝手术
ClassMethod CancelDecline(opsIdStr As %String, userId As %String) As %String
{
	quit:(opsIdStr="") "E^手术ID不能为空"
	set $zt="Error"
	tstart
	set opsCount=$l(opsIdStr,","),saveRet="S^"
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveRet="E^不存ID为"_opsId_"的手术申请。"
		quit:($p(saveRet,"^",1)'="S")
		
		
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set:("Decline" '= operSchedule.Status.Code) saveRet="E^只能取消状态是拒绝的手术。"
		quit:($p(saveRet,"^",1)'="S")
		
		set NeedAuditOperation=##class(CIS.AN.BL.OperApplication).NeedAuditOperation(opsId)
		set originalStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Audit")
		set:(NeedAuditOperation'="Y") originalStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Application")
		set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(originalStatusId)
		set sc=operSchedule.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")
		
		set arrangeLog=..CreateArrangeLog(opsId,"",userId)
		set arrangeLog.Note="取消拒绝手术"
		set sc=arrangeLog.%Save()
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($p(saveRet,"^",1)'="S")
		
		set saveRet=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"COPD",userId,+$h,$p($h,",",2))
		quit:($p(saveRet,"^",1)'="S")
	}
	
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	tcommit
	
	set opsCount=$l(opsIdStr,",")
	for i=1:1:opsCount
	{
		set opsId=$p(opsIdStr,",",i)
		do ..AfterCancelDecline(opsId,userId)
	}
	
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod AfterCancelDecline(opsId, userId) As %Status
{
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	
	try
	{
		//20211214
		set opaId=operSchedule.ExternalID
		// 调用消息平台接口	
		s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		set:(+OAret'=0) saveResult="E^发送手术申请失败，原因："_$p(OAret,"^",2)
		if (+OAret'=0) write "DTS:调用消息平台接口错误:",$p(OAret,"^",2),!
	}
	catch(e)
	{
		//write "DTS:调用消息平台接口错误:",e.DisplayString(),!
	}
	
	try
	{
		set saveRet=##class(CIS.AN.SRV.OperAppService).CancelDecline(opsId,userId)
	}
	catch(e)
	{
		//write "DTS:调用旧版兼容接口错误:",e.DisplayString(),!
	}
	
	try
	{
		set opaId=operSchedule.ExternalID
		//改变医嘱状态(核实->执行) YL 20210629
		//set anaId=$p(^DHCANOPArrange(opaId),"^",2)
		//set ordId=$o(^OEORDi(0,"Ana",anaId,""))
		//set ordSubId=$o(^OEORDi(0,"Ana",anaId,ordId,""))
		//set orderret=##class(appcom.OEOrdItem).Execute(ordId_"||"_ordSubId,userId)
	}
	catch(e)
	{
		//write "改变医嘱状态错误:",e.DisplayString(),!
	}
	
	quit $$$OK
}

ClassMethod UpdateOperTime(opsId As %String, operTime As %String) As %String
{
	set $zt="Error"
	tstart
	set saveResult="E^未更新任何记录"
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	b ;1
	set operSchedule.ArrOperTime=operTime
	set sc= operSchedule.%Save()
	if ($System.Status.IsError(sc))
	{
		set saveResult="E^"_$System.Status.GetErrorText(sc)	
	}
	else
	{
		set saveResult="S^"	
    }
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	雍阳
/// CreatDate：    	2020-08-13
/// Description： 	拒绝手术
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId：手术申请ID，cancelReason：拒绝原因，userId：操作人
/// Return：       	
/// w ##class(CIS.AN.BL.OperArrange).CancelOperForReason("")
ClassMethod CancelOperForReason(opsId As %String, cancelReason As %String, userId As %String) As %String
{
	quit:(opsId="") "E^手术ID不能为空"
	set saveResult="S^"
	set $zt="Error"
	tstart
	
	set:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) saveRet="E^不存ID为"_opsId_"的手术申请。"
		
	set declineStatusId=##class(CIS.AN.BL.OperStatus).GetStatusIDByCode("Decline")
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set NeedAuditOperation=##class(CIS.AN.BL.OperApplication).NeedAuditOperation(opsId)
	set:("Audit^Arrange" '[ operSchedule.Status.Code)&(NeedAuditOperation="Y") saveRet="E^只能拒绝审核和安排状态的手术。"
	set:("Application^Arrange" '[ operSchedule.Status.Code)&(NeedAuditOperation'="Y") saveRet="E^只能拒绝申请和安排状态的手术。"
		
	set operSchedule.Status=##class(CT.AN.OperStatus).%OpenId(declineStatusId)
	set operSchedule.OperRoom=""
	set operSchedule.OperSeq=""
	set operSchedule.ScrubNurse=""
	set operSchedule.CircualNurse=""
	set operSchedule.ArrCircualNurse=""
	set operSchedule.ArrScrubNurse=""
	set operSchedule.ArrOperRoom=""
	set operSchedule.ArrOperSeq=""
	set operSchedule.CancelReason=cancelReason
	set operSchedule.CancelUser=userId
	set operSchedule.CancelTime=$zd(+$h,3)_" "_$zt($p($h,",",2))
	set sc=operSchedule.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
		
	set arrangeLog=..CreateArrangeLog(opsId,"",userId)
	set arrangeLog.Note="拒绝手术"
	set sc=arrangeLog.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
		
	set saveResult=##class(CIS.AN.BL.SurgicalProcedure).SaveProcedure(opsId,"OPD",userId,+$h,$p($h,",",2))
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
		
	set saveResult=##class(CIS.AN.SRV.OperAppService).DeclineApplication(opsId,userId)
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	
	// 发送拒绝手术消息
	set actionUserId=operSchedule.AppUserID
	set actionDeptId=operSchedule.AppDeptID	
	set opaId=operSchedule.ExternalID
	set SendOperMessage=##class(CIS.AN.BL.DataConfiguration).GetValueByKey("SendOperMessage")
	if (SendOperMessage="Y") Set rtnMes =##class(websys.DHCMessageInterface).Send("拒绝手术", "1054", userId, operSchedule.EpisodeID ,"",actionUserId, "opaId为"_opaId ,actionDeptId_"|OnlyFlag")
	
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// Creator：      	元琳
/// CreatDate：    	2020-09-09
/// Description： 	器械护士与巡回护士对调
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术申请ID，moveDirection:移动方向
/// Return：       	保存成功返回"S^"，保存失败返回"E^失败原因"
/// w ##class(CIS.AN.BL.OperArrange).ExchangeNurseArrange("171","up")
ClassMethod ExchangeNurseArrange(opsId As %String, ArrFirstScrubNurse As %String, ArrSecScrubNurse As %String, ArrFirstCirNurse As %String, ArrSecCirNurse As %String) As %String
{
	quit:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0) "E^手术申请记录不存在。"	
	set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	set $zt="Error"
	tstart
	set saveResult="S^"
	set operSchedule.ArrScrubNurse=ArrFirstCirNurse_","_ArrSecCirNurse
	set operSchedule.ArrCircualNurse=ArrFirstScrubNurse_","_ArrSecScrubNurse
	set sc=operSchedule.%Save()
	set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	quit:($System.Status.IsError(sc))
	if ($piece(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

/// Creator:ban
/// CreatDate:2021-03-20
/// Description:根据登记号获取病人信息
/// Table:CSSD_ExtDevBind
/// w ##class(CIS.AN.BL.OperArrange).GetAdmListByHospitalNo("0000000004")
ClassMethod GetAdmListByHospitalNo(HospitalNo) As %Library.String
{
	//n (HospitalNo)
	q:HospitalNo="" ""
	s PatMasId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(HospitalNo),0))
	q:+PatMasId=0 ""

	s PatName=$p(^PAPER(PatMasId,"ALL"),"^",1)
	s PaPersonId=PatMasId
	s SexId=$p(^PAPER(PaPersonId,"ALL"),"^",7)  ;PA_Person
	s Sex=""
	s:SexId'="" Sex=$p(^CT("SEX",SexId),"^",2)
	s DOB=+$p(^PAPER(PatMasId,"ALL"),"^",6)
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PatMasId,"")
	s IPNo=$p(^PAPER(PatMasId,"PAT",1),"^",1)  ;住院号
	s PaAdmId=$o(^PAPERdr(PatMasId,"ADM","I",""),-1)
	s BedId="",Bed=""
	s:PaAdmId'="" BedId=$p(^PAADM(PaAdmId),"^",73)
	i BedId'="" d
	.s WardId=+BedId
	.s Ch=$p(BedId,"||",2)
	.s Bed=$p(^PAWARD(WardId,"BED",Ch),"^",1)
	s AdmList=HospitalNo_"^"_PatName_"^"_Age_"^"_Sex_"^"_Bed
     ;登记号^姓名^年龄^性别^床位
	q AdmList
}

/// w ##class(CIS.AN.BL.OperArrange).SaveAttendance("213","1447","2020-09-24","","20518")
ClassMethod SaveAttendance(deptId As %String, careProv As %String, arrangeDate As %String, status As %String, userId As %String) As %String
{
	
	set attendanceId=""
	&sql(select RowId into :attendanceId from CIS_AN.Attendance where AttendDate=%ODBCIN(:arrangeDate) and Dept=:deptId and Member=:careProv)
	set attendance=""
	b //ccq
	if (##class(CIS.AN.Attendance).%ExistsId(attendanceId))
	{
		if (status="")
		{
			set sc=##class(CIS.AN.Attendance).%DeleteId(attendanceId)
			quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
			quit "S^"
				
		}
		set attendance=##class(CIS.AN.Attendance).%OpenId(attendanceId)	
	}	
	else
	{
		
		set attendance=##class(CIS.AN.Attendance).%New()	
	}
	set attendance.AttendDate=##class(CIS.AN.COM.DateTime).ConvertToDateH(arrangeDate)
	if (attendance.%Id()="")
	{
		set attendance.CreateUser=userId
		set attendance.CreateDate=+$h
		set attendance.CreateTime=$p($h,",",2)
	}
	set attendance.UpdateUser=userId
	set attendance.UpdateDate=+$h
	set attendance.UpdateTime=$p($h,",",2)
	set attendance.Dept=deptId
	set attendance.Member=careProv
	set:(status="") attendance.Shift=""
	if (status'="")
	{
		set shiftId=""
		&sql(select RowId into :shiftId from CF_AN.CrewShift where Status->Code=:status)
		set attendance.Shift=##class(CF.AN.CrewShift).%OpenId(shiftId)
	}
	
	set sc=attendance.%Save()
	quit:($System.Status.IsError(sc)) "E^"_$System.Status.GetErrorText(sc)
	quit "S^"_attendance.%Id()
}

/// Description:安排器械护士、巡回护士时同步相同手术间（未排护士）的护士数据
/// Creator:zhengtao
/// CreatDate:2021-11-03
/// w ##class(CIS.AN.BL.OperArrange).SyncNurseArrangeInfo("1090","11136")
ClassMethod SyncNurseArrangeInfo(opsIdArrange As %String, userId As %String) As %String
{
	quit:((opsIdArrange="")!(userId="")) "E^手术ID和用户Id不能为空"
	set saveResult="S^"
	set $zt="Error"
	tstart
	
	set:(##class(CIS.AN.OperSchedule).%ExistsId(opsIdArrange)=0) saveResult="E^不存ID为"_opsId_"的手术申请。"	
	set operScheduleArrange=##class(CIS.AN.OperSchedule).%OpenId(opsIdArrange)
	set operDateArrange=operScheduleArrange.OperDate
	set:(operDateArrange="") saveResult="E^手术日期不能为空。"
	set operDateH=+##class(CIS.AN.COM.DateTime).ConvertToDateH(operDateArrange,"")
	set operRoomArrange=operScheduleArrange.ArrOperRoom
	set ArrOperSeqArrange=operScheduleArrange.ArrOperSeq
	set:(operRoomArrange="") saveResult="E^手术间不能为空。"
	set:(ArrOperSeqArrange="") saveResult="E^台次不能为空。"
	set:("Receive^Arrange" '[ operScheduleArrange.Status.Code) saveResult="E^手术状态不是接收或者安排。"
	set ArrCircualNurseArrange=operScheduleArrange.ArrCircualNurse
	set ArrScrubNurseArrange=operScheduleArrange.ArrScrubNurse
	set:((ArrCircualNurseArrange="")&(ArrScrubNurseArrange="")) saveResult="E^手术没有护士排班信息。"
	if ($p(saveResult,"^",1)="S")
	{
		for date=operDateH:1:operDateH
    	{
	        set opsId=0
	        for
	        {
	            set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
	            quit:((opsId="")!($p(saveResult,"^",1)="E"))
	            set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	            set operRoom=operSchedule.ArrOperRoom
	            continue:(operRoom'=operRoomArrange)
	            set arrOperSeq=operSchedule.ArrOperSeq
	            continue:(arrOperSeq<=ArrOperSeqArrange)
	            set statusCode=operSchedule.Status.Code
	            continue:("Receive^Arrange" '[statusCode)
	            set ArrCircualNurse=operSchedule.ArrCircualNurse
				set ArrScrubNurse=operSchedule.ArrScrubNurse
	            continue:((ArrCircualNurse'="")&(ArrCircualNurseArrange'[ArrCircualNurse))
	            continue:((ArrScrubNurse'="")&(ArrScrubNurseArrange'[ArrScrubNurse))
	            set operSchedule.ArrCircualNurse=ArrCircualNurseArrange
				set operSchedule.ArrScrubNurse=ArrScrubNurseArrange
				set sc=operSchedule.%Save()
				set:($System.Status.IsError(sc)) saveResult="E^"_$System.Status.GetErrorText(sc)
	            
	            set arrangeLog=..CreateArrangeLog(opsId,"ASN",userId)
				set arrangeLog.Note="手术排班同步护士数据"
				set status=arrangeLog.%Save()
				set:($System.Status.IsError(status)) saveResult="E^"_$System.Status.GetErrorText(status)
	        }
    	}
	}
	if ($p(saveResult,"^",1)="E")
	{
		trollback
		quit saveResult	
	}
	tcommit
	quit saveResult
Error
	trollback
	quit "E^"_$ze
}

ClassMethod SaveTicketPrintFlag(opsIdStr As %String, flag As %String = "Y") As %String
{
	set $zt="Error"
	tstart
	set count=$l(opsIdStr,","),saveRet="S^"
	for i=1:1:count
	{
		set opsId=$p(opsIdStr,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		set operSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set operSchedule.ArrPrintFlag=flag
		set sc=operSchedule.%Save()	
		set:($System.Status.IsError(sc)) saveRet="E^"_$System.Status.GetErrorText(sc)
		quit:($System.Status.IsError(sc))
	}
	if ($p(saveRet,"^",1)'="S")
	{
		trollback
		quit saveRet	
	}
	tcommit
	quit "S^"
	
Error
	trollback
	quit "E^"_$ze
}

/// w ##class(CIS.AN.BL.OperArrange).GetLeatestLog(32)
ClassMethod GetLeatestLog(opsId As %String) As %DynamicObject
{
	set result={}
	
	set rowId=$o(^CIS.AN.OperArrangeI("IOPS",opsId,""),-1)
	if ##class(CIS.AN.OperArrange).%ExistsId(rowId)
	{
		set arrange=##class(CIS.AN.OperArrange).%OpenId(rowId)
		set result.OperSchedule=opsId
		if $IsObject(arrange.OperRoom)
		{
			set result.OperRoomID=arrange.OperRoom.%Id()
			set result.OperRoom=arrange.OperRoom.Description
		}
		set result.OperSeq=arrange.OperSeq
		set result.Note=arrange.Note
		set result.UserID=arrange.ReleaseUser
		set result.Date=$zd(arrange.ReleaseDate,3)
		set result.Time=$zt(arrange.ReleaseTime)
	}
	
	quit result
}

/// 判断麻醉医生是否已被安排到其他手术间的相同台次，避免排班冲突
/// YL 20220120
ClassMethod ExistsOperSeqByAnDoc(operDate As %String, deptID As %String, careProvID As %String, selectedOperSeq As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	set sc=rset.Execute(operDate,operDate,deptID,"","","","Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut")
	set result="S^"
	while(rset.%Next())
	{
		set operSeq=rset.Get("OperSeq")
		set opsId=rset.Get("RowId")
		set roomDesc=rset.Get("RoomDesc")
		set ansId=""
		&sql(select RowId into :ansId from CIS_AN.AnaArrange where operschedule=:opsId)
		continue:(##class(CIS.AN.AnaArrange).%ExistsId(ansId)=0)
		set anaestSchedule=##class(CIS.AN.AnaArrange).%OpenId(ansId)
		continue:(anaestSchedule.Anesthesiologist'=careProvID)
		continue:(+operSeq'=+selectedOperSeq)
		set result="E^"_roomDesc	
	}
	quit result
}

}
