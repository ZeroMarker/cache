/// 名称: 与前台交付,设置病历所在科室相关操作的类
/// 描述: 主要用于“病历转移功能”的前台页面交互
/// 编写者：牛才才
/// 编写日期: 2015-11-02
Class EMRservice.Ajax.appointdeptmanager Extends %CSP.Page
{

ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
	i ##Class(websys.SessionEvents).SessionExpired() q 1
	q 1
}

ClassMethod OnPage() As %Status
{
	s episodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	s appType = $Get(%request.Data("AppType",1),"null")		//操作类型 List--获取该病人本次就诊所住过的科室  Appoint--主管医生指定该病人的病历所在科室
	s userID = %session.Get("LOGON.USERID")
	q:(userID = "") $$$OK
	q:(appType = "null") $$$OK
	s type = $Get(%request.Data("Type",1),"")           //前端页面类型标识符，"HSIUI"标识用HISUI控件写的前端页面，空值兼容原有使用页面
	q:(episodeID = -1) $$$OK

	if (appType = "List")
	{
		//List--获取该病人本次就诊所住过的科室
		d ..GetPatientDeptList(episodeID, type)
	}
	elseif (appType = "Status")
	{
		//Status--获取当前的转移
		d ..GetStatusList(episodeID, type)
	}
	elseif (appType = "Withdraw")
	{
		//Withdraw--收回病历
		w ..Withdraw(episodeID,userID)	
	}
	elseif (appType = "Appoint")
	{
		//Appoint--主管医生指定该病人的病历所在科室
		s ^tempncc("0") = episodeID
		s result = ..AppointDept(episodeID,userID)
		if (result = "Y")
		{
			w "{""success"":""true""}"
		}
		else
		{
			w "{""success"":""false""}"	
		}
	}
	elseif (appType = "getHistory")
	{
		s start = $g(%request.Data("start",1),0)
		s limit = $g(%request.Data("limit",1),20)
		s ResultStream = ..getHistory(episodeID,start,limit)
		//输出流数据
		while (ResultStream.AtEnd = 0)
		{
			w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
		}
		
	}
	
	Quit $$$OK
}

/// 名称: 返回病人转科科室的json
/// 描述: 
/// 编写者：牛才才
/// 编写日期: 2015-11-02
ClassMethod GetPatientDeptList(episodeID As %String, type As %String = "") As %String
{
	s transDept = ..TransDeptIDDetail(episodeID, "null")
	
	s transDeptCount = $l(transDept, "->")
	
	w:(""=type) "{""root"":["
	w:("HISUI"=type) "["
	s i = 1
	s isFirstDept = "Y"
	WHILE (i <= transDeptCount) 
	{
		s curDept = $p(transDept, "->", i)
		//计数上移，在continue位置会导致死循环
		s i = i + 1
        //过滤掉患者当前所在科室
		
        s admCurrDept = $P($g(^PAADM(episodeID)),"^",4)
        continue:(admCurrDept = $p(curDept,"^",1))
        
		if ((curDept '= "") && (curDept '= "无"))
		{
			if (isFirstDept = "N"){w ","}
			w "{""deptID"":"""_$p(curDept,"^",1)_""",""deptName"":"""_$p(curDept,"^",2)_""",""TransStartDate"":"""_$p(curDept,"^",3)_""",""TransStartTime"":"""_$p(curDept,"^",4)_"""}"
			s isFirstDept = "N"
		}
		
		
	}
	w:("HISUI"=type) "]"
	w:(""=type) "]}"
	//Quit "Y"
}

/// Desc:	转科明细
/// Output:	(科室ID^科室名称^日期^时间->科室ID^科室名称^日期^时间->...)或(无)
ClassMethod TransDeptIDDetail(argAdmId As %String, argHospital As %String = "") As %String
{
	//q "12^名称^1^1->13^名称1^11^11->"
	//入参检查
	q:($d(argAdmId)=0)||($d(argHospital)=0)||(argAdmId="") ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept=""
	
	s childSub = ""
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		
		s startDate = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",1)
		s startTime = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",2)
		
		s HISFormatstartDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",startDate)
		s HISFormatstartTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",startTime)
		
		s transDept = transDept_transCtlocDR_"^"_tmpTransDept_"^"_HISFormatstartDate_"^"_HISFormatstartTime
		s transDept = transDept_"->"
		
		s lastTransDept=tmpTransDept
	}
	
	if transDept'=""
	{
		s transDept=$e(transDept,1,$l(transDept)-2)
		if '($f(transDept,"->")>0) {s transDept = "无"}
	}
		
	q transDept
}

/// 名称: 保存指定的病历科室的信息
/// 描述: 
/// 编写者：牛才才
/// 编写日期: 2015-11-02
/// w ##Class(EMRservice.Ajax.appointdeptmanager).AppointDept("49")
ClassMethod AppointDept(episodeID As %String, userID As %String) As %String
{
	s emrDept  = $Get(%request.Data("EMRDept",1),"-1")
	s hours = $Get(%request.Data("Times",1),"-1")	
	q:(emrDept = "-1") "N"
	q:(hours = "-1") "N"
	s flag = "1"
	TStart
	s startDate = $p($h, ",", 1)
	s startTime = $p($h, ",", 2)
	
	//计算截止日期与时间
	s activityDates = ((+hours)) \ 24	//有效期的天数
	s activityHours = (+hours) - (activityDates * 24)
	
	s endDate = (+startDate) + activityDates
	s endTime = (+startTime) + (activityHours * 60 * 60)
	if (endTime > 86399)
	{
		s endDate = endDate + 1
		s endTime = endTime - 86399
	}
	//
	
	//修改病历科室表
	//s userID = %session.Get("LOGON.USERID")
	//s userID = "209"
	s curObjAppointDept = ""
	s curAppointDeptRowID = $o(^DHCEMRI.EMRDeptI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAppointDeptRowID = "")
	{
		s curObjAppointDept = ##class(EMRinstance.EMRDept).%New()
	}
	else
	{
		s curObjAppointDept = ##class(EMRinstance.EMRDept).%OpenId(curAppointDeptRowID)
	}
	q:(curObjAppointDept = "") $$$OK
	
	s curObjAppointDept.EpisodeID = episodeID
	s curObjAppointDept.EMRDept = emrDept
	s curObjAppointDept.StartDate = startDate
	s curObjAppointDept.StartTime = startTime
	s curObjAppointDept.EndDate = endDate
	s curObjAppointDept.EndTime = endTime
	s curObjAppointDept.IsActivity = "Y"
	s curObjAppointDept.AppointUserID = userID
	
	s sc = curObjAppointDept.%Save()
	if ($$$ISOK(sc))
	{
		s TransferLogObj = ##class(EMRinstance.RecordTransferLog).%New()
		
		s TransferLogObj.Action = "O"
		s TransferLogObj.EpisodeID = episodeID
		s TransferLogObj.OperationDate = startDate
		s TransferLogObj.OperationTime = startTime
		s TransferLogObj.OperationUserID = userID
		s TransferLogObj.TransInDeptID = emrDept
		s TransferLogObj.TransOutStartDate = startDate
		s TransferLogObj.TransOutStartTime = startTime
		s TransferLogObj.TransOutEndDate = endDate
		s TransferLogObj.TransOutEndTime = endTime
		
		s TransferSC = TransferLogObj.%Save()
		if ('$$$ISOK(TransferSC))
		{
			s flag = "-1"
		}
		d TransferLogObj.%Close()
		
	}
	else
	{
		s flag = "-1"
	}
	
	d curObjAppointDept.%Close()
	s curObjAppointDept = ""
	//
	if (flag = "-1")
	{
		TRollback
		q "N"
	}
	
	TCommit
	
	//返回
	q "Y"
}

/// 名称: 返回当前转出的转科科室的json
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
/// d ##Class(EMRservice.Ajax.appointdeptmanager).GetStatusList("49")
ClassMethod GetStatusList(episodeID As %String, type As %String = "") As %String
{
	s json = ""

	s rowID = ""
	for {
		s rowID=$o(^DHCEMRI.EMRDeptI("EpisodeIDIdx", " "_episodeID, rowID))
		q:rowID=""
		
		s obj = ##Class(EMRinstance.EMRDept).%OpenId(rowID)

		//科室名称
		s emrDeptID = obj.EMRDept
		if (emrDeptID '= "")
		{
			s emrDeptDesc = $p($g(^CTLOC(emrDeptID)),"^",2)
			if $l(emrDeptDesc,"-")>1 {s emrDeptDesc=$p(emrDeptDesc,"-",2)}
		}
		else
		{
			s emrDeptDesc = ""
		}
		s episodeID = obj.EpisodeID
			
		//转出到期时间
		s endDate = obj.EndDate
		s endTime = obj.EndTime
			
		//是否有效
		s isActivity = obj.IsActivity
		
		d obj.%Close()	
		//判断是否已到期，到期后IsActivity改为“N”
		d ..SetActivity(endDate,endTime,episodeID)
			
		//当前有效
		if (isActivity = "Y")
		{
			//业务要求同一时间只能有一份病历是有效的，即同一时间只能转出一份病历
			//if (json '= "")
			//{ 
			//	s json = json_","
			//}
			s HISFormatendDate = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",endDate)
			s HISFormatendTime = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",endTime)
			s json = json_"{""emrDept"":"""_emrDeptDesc_""",""endDate"":"""_HISFormatendDate_""",""endTime"":"""_HISFormatendTime_"""}"
		}
	}
	
	//返回json
	w:(""=type) "{data:["_json_"]}"
	w:("HISUI"=type) "["_json_"]"
	//q "Y"
}

/// 名称: 收回转出的病历
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
ClassMethod Withdraw(episodeID As %String, userID As %String) As %String
{
	s flag = "1"
	TStart
	s curObjAppointDept = ""
	s curAppointDeptRowID = $o(^DHCEMRI.EMRDeptI("EpisodeIDIdx", " "_episodeID, 0))
	if (curAppointDeptRowID = "")
	{
		s curObjAppointDept = ##class(EMRinstance.EMRDept).%New()
	}
	else
	{
		s curObjAppointDept = ##class(EMRinstance.EMRDept).%OpenId(curAppointDeptRowID)
	}
	q:(curObjAppointDept = "") $$$OK
	
	//置为无效
	s curObjAppointDept.IsActivity = "N"
	
	//到期时间写为收回时的时间
	s curObjAppointDept.EndDate = $p($h,",",1)
	s curObjAppointDept.EndTime = $p($h,",",2)
	
	s sc = curObjAppointDept.%Save()
	if ($$$ISOK(sc))
	{
		s TransferLogObj = ##class(EMRinstance.RecordTransferLog).%New()
		
		s TransferLogObj.Action = "I"
		s TransferLogObj.EpisodeID = episodeID
		s TransferLogObj.OperationDate = $p($h,",",1)
		s TransferLogObj.OperationTime = $p($h,",",2)
		s TransferLogObj.OperationUserID = userID
		s TransferLogObj.TransInDeptID = curObjAppointDept.EMRDept
		s TransferLogObj.TransOutStartDate = curObjAppointDept.StartDate
		s TransferLogObj.TransOutStartTime = curObjAppointDept.StartTime
		s TransferLogObj.TransOutEndDate = curObjAppointDept.EndDate
		s TransferLogObj.TransOutEndTime = curObjAppointDept.EndTime
		
		s TransferSC = TransferLogObj.%Save()
		if ('$$$ISOK(TransferSC))
		{
			s flag = "-1"
		}
		d TransferLogObj.%Close()
		
	}
	else
	{
		s flag = "-1"
	}
	d curObjAppointDept.%Close()
	s curObjAppointDept = ""
	
	if (flag = "-1")
	{
		TRollback
		q "N"
	}
	
	TCommit

	q "Y"
}

/// 名称: 判断是否有效，若当前时间大于到期时间，则置为无效
/// 编写者：杨丰华
/// 编写日期: 2012/05/10
ClassMethod SetActivity(EndDate As %Date, EndTime As %Date, episodeID As %String)
{
	if (EndDate > $p($h,",",1))
	{
		q 
	}
	elseif ((EndDate = $p($h,",",1)) && (EndTime > $p($h,",",2)))
	{
		q 	
	}	
	else
	{
		s curObjAppointDept = ""
		s curAppointDeptRowID = $o(^DHCEMRI.EMRDeptI("EpisodeIDIdx", " "_episodeID, 0))
		if (curAppointDeptRowID = "")
		{
			s curObjAppointDept = ##class(EMRinstance.EMRDept).%New()
		}
		else
		{
			s curObjAppointDept = ##class(EMRinstance.EMRDept).%OpenId(curAppointDeptRowID)
		}
		q:(curObjAppointDept = "") $$$OK
		
		s curObjAppointDept.IsActivity = "N"
		d curObjAppointDept.%Save()
		d curObjAppointDept.%Close()
		s curObjAppointDept = ""

		q 
	}
}

/// w ##Class(EMRservice.Ajax.appointdeptmanager).getHistory("220",1,20)
ClassMethod getHistory(episodeID As %String, AStartRowIndex As %Integer, ARowCount As %Integer) As %GlobalCharacterStream
{
	//数据输出
	s ResultStream = ##Class(%GlobalCharacterStream).%New()
	d ResultStream.Write("{success:true,Data:[")
	s Count = 0
	s TransferLogID = ""
	for
	{
		s TransferLogID = $O(^DHCEMRI.RecordTransferLogI("EpisodeIDIdx"," "_episodeID,TransferLogID))
		q:(TransferLogID = "")
		
		s TransferLogObj = ##class(EMRinstance.RecordTransferLog).%OpenId(TransferLogID)
		continue:(TransferLogObj = "")
		
		s Count = Count + 1
		
		continue:(Count < (AStartRowIndex + 1))
		continue:(Count > (AStartRowIndex + ARowCount))
		
		if (Count > (AStartRowIndex + 1))
		{
			d ResultStream.Write(",")
		}
		
		s Action = TransferLogObj.Action
		s:(Action = "O") Action = "转出"
		s:(Action = "I") Action = "收回"
		
		s OperationDateTime = $ZD(TransferLogObj.OperationDate,3)_" "_$ZT(TransferLogObj.OperationTime)
		
		s OperationUserID = TransferLogObj.OperationUserID
		s OperationUserName = ""
		s:(OperationUserID '= "") OperationUserName = ##class(EMRmeta.PowerUser).GetUserName(OperationUserID)
		
		s TransInDeptID = TransferLogObj.TransInDeptID
		s TransInDeptDesc = ""
		s:(TransInDeptID '= "") TransInDeptDesc = $p($p($g(^CTLOC(TransInDeptID)),"^",2),"-",2)
		
		s TransOutStartDateTime = $ZD(TransferLogObj.TransOutStartDate,3)_" "_$ZT(TransferLogObj.TransOutStartTime)
		s TransOutEndDateTime = $ZD(TransferLogObj.TransOutEndDate,3)_" "_$ZT(TransferLogObj.TransOutEndTime)
		
		d ResultStream.Write("{")
		s EpisodeID = ..TrimEnterAndWrite(TransferLogObj.EpisodeID)
		d ResultStream.Write("EpisodeID:'"_EpisodeID_"'")
		s Action = ..TrimEnterAndWrite(Action)
		d ResultStream.Write(",Action:'"_Action_"'")
		d ResultStream.Write(",OperationDateTime:'"_OperationDateTime_"'")
		s OperationUserName = ..TrimEnterAndWrite(OperationUserName)
		d ResultStream.Write(",OperationUserName:'"_OperationUserName_"'")
		s TransInDeptDesc = ..TrimEnterAndWrite(TransInDeptDesc)
		d ResultStream.Write(",TransInDeptDesc:'"_TransInDeptDesc_"'")
		d ResultStream.Write(",TransOutStartDateTime:'"_TransOutStartDateTime_"'")
		d ResultStream.Write(",TransOutEndDateTime:'"_TransOutEndDateTime_"'")
		d ResultStream.Write("}")
		
	}
	d ResultStream.Write("],TotalCount:'"_Count_"'}")
	q ResultStream
}

ClassMethod TrimEnterAndWrite(input As %String)
{
	s input = $TR(input,$C(13),"")
	s input = $TR(input,$C(10),"")
	s input = $TR(input,$C(0),"")
	//替换单引号
	for {
		s count = $f(input,"'")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"@@@"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换斜杠
	for {
		s count = $f(input,"\")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"xiegangxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换反斜杠
	for {
		s count = $f(input,"/")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"fanxiegangfanxiegang"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文逗号
	for {
		s count = $f(input,",")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文逗号
	for {
		s count = $f(input,"，")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"douhaodouhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换英文叹号
	for {
		s count = $f(input,"!")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文叹号
	for {
		s count = $f(input,"！")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"tanhaotanhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文句号
	for {
		s count = $f(input,"。")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"juhaojuhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文左单引号
	for {
		s count = $f(input,"‘")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"zuodanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//替换中文右单引号
	for {
		s count = $f(input,"’")
		if (count > 0)
		{
			s input = $e(input,1,count-2)_"youdanyinhao"_$e(input,count,$l(input))	
		}
		else
		{
			q
		}	
	}
	
	//s input = $TR(input,"'","@@@")
	q input
}

}
