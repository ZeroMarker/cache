/// Desc:      查询病历接口
/// Creator:   Candy
/// CreateDate:2017-8-11
Class EMRservice.HISInterface.QueryInterface Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       查询医师所管患者未完成病历
/// Creator:    Candy
/// CreateDate: 2017-8-11
/// Input:      argUserID 用户ID,argEpisodeID 就诊号
/// Output:     InstanceID:病历ID,Title:病历名称
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetUnfinishedInstance",105,112)
Query GetUnfinishedInstance(argUserID As %String, argEpisodeID As %String) As %Query(ROWSPEC = "InstanceID:%String,Title:%String")
{
}

ClassMethod GetUnfinishedInstanceExecute(ByRef qHandle As %Binary, argUserID As %String, argEpisodeID As %String) As %Status
{
	q:(argUserID = "")||(argEpisodeID = "") $$$OK
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1

	s docId = ""
	for
	{
		s docId = $o(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID,docId))
		q:(docId = "")
		s num = ""
		for
		{
			s num = $o(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID,docId,num))
			q:(num = "")
			s emrLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",argEpisodeID,docId,num,""))
			continue:(emrLogId = "")
			s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(emrLogId) 
			continue:(objLog = "")
			continue:(objLog.CreateUserID '= argUserID)
			continue:(objLog.EMRStatus '= "finished")
			s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",argEpisodeID,docId,""))
			continue:(ecrecordId = "")
			s instanceId = ecrecordId_"||"_num
			s objIstance = ##class(EMRinstance.InstanceData).%OpenId(instanceId)
			continue:(objIstance = "")
			s title = objIstance.Title
			s ^CacheTemp(repid,ind) = $lb(instanceId,title)
			s ind=ind+1 					
		}
	}
	Quit $$$OK
}

ClassMethod GetUnfinishedInstanceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnfinishedInstanceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUnfinishedInstanceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnfinishedInstanceExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       实习医生电子病历工作量
/// Creator:    Candy
/// CreateDate: 2018-4-18
/// Input:      argStartDate 开始日期 格式(YYYY-MM-DD)
///             argEndDate   结束日期 格式(YYYY-MM-DD)
/// Output:     DocID 病历类型ID
///             RecordName 病历类型名称 
///             UserID 用户ID
///             UserName 用户名称
///             SignDate 签名日期
///             SignTime 签名时间
///             PatientID 病人号
///             PatientName 病人名称
///             EpisodeID 就诊号
///             MedicareNo 病案号
///             LoginLocID 科室            
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetWorkload","2018-03-01","2018-04-01")
Query GetWorkload(argStartDate As %String, argEndDate As %String, argAction As %String = "internCheck") As %Query(ROWSPEC = "DocID:%String,RecordName:%String,UserID:%String,UserName:%String,SignDate:%String,SignTime:%String,PatientID:%String,PatientName:%String,EpisodeID:%String,MedicareNo:%String,LoginLocID:%String")
{
}

ClassMethod GetWorkloadExecute(ByRef qHandle As %Binary, argStartDate As %String, argEndDate As %String, argAction As %String = "internCheck") As %Status
{
	q:(argStartDate = "")||(argEndDate = "") $$$OK
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1

	s docIds = "879,882,883,4561,891,1011,1019,2810,2812,885,1006,880,888"
	s stDate = $zdh(argStartDate,3)
	s endDate = $zdh(argEndDate,3)
	for tmpDate = stDate:1:endDate
	{
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.EMRSignI("IdxAction"," "_$zcvt(argAction,"U"),tmpDate,time))
			q:(time = "")
			for i=1:1:$l(docIds,",")
			{
				s tmpDocId = $p(docIds,",",i)
				s rowId = ""
				for
				{
					s rowId = $o(^DHCEMRI.EMRSignI("IdxAction"," "_$zcvt(argAction,"U"),tmpDate,time," "_tmpDocId,rowId))
					q:(rowId = "")
					s obj = ##Class(EMRinstance.EMRSign).%OpenId(rowId)
					continue:(obj = "")
					s instanceId = obj.InstanceID
					s objInstanace = ##Class(EMRinstance.InstanceData).%OpenId(instanceId)
					continue:(objInstanace = "")
					s title = objInstanace.Title
					s userId = obj.UsrID
					s userName = ##Class(EMRservice.BL.BLPowerUser).GetUserName(userId)
					s signDate = $zd(obj.SignDate,3)
					s signTime = $zt(obj.SignTime)
					s episodeId = obj.EpisodeID
					s patientId = $P(^PAADM(episodeId),"^",1)
					s patientName = ##Class(EMRservice.HISInterface.PatientInfoAssist).Name(patientId)
					s medicareNo = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetMRNoByEpisodeID(episodeId)
					s loginLoc = obj.UsrLoginLocID
					s ^CacheTemp(repid,ind) = $lb(tmpDocId,title,userId,userName,signDate,signTime,patientId,patientName,episodeId,medicareNo,loginLoc)
					s ind=ind+1 								
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod GetWorkloadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkloadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWorkloadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkloadExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:     根据起始时间以及DocIds统计所书写病历数量
/// CreatDate:2018-12-25
/// Creator:  Lina
/// Input:    ADocIds    目录展现结构挂模板一层的目录Id,多个用"^"来分隔
///           AStartDate 开始查询日期
///           AEndDate   结束查询日期
/// Output:   count      病历数量
/// Debug:    w ##Class(EMRservice.HISInterface.QueryInterface).GetInstanceCount("66^68","2017-1-01","2018-12-15") 
ClassMethod GetInstanceCount(ADocIds As %String, AStartDate As %String, AEndDate As %String) As %String
{
	s count = 0
	q:(ADocIds = "")||(AStartDate = "")||(AEndDate = "") count
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	for date = StartDate:1:EndDate
	{
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
			q:(time = "")
			s EpisodeID = ""
			for
			{
				s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
				q:(EpisodeID = "")
				s EpisodeID = $tr(EpisodeID," ","")
				s length = $l(ADocIds,"^")
				for I = 1:1:length
				{
					s docId = $p(ADocIds,"^",I)
					s EMRNum = ""
					for
					{
						s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,EMRNum))
						q:(EMRNum = "")
						s EMRNum = $tr(EMRNum," ","")
						s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,docId,""))
						q:(ecrecordID = "")
						s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
						q:(objRecord = "")
						s rowId = ecrecordID_"||"_EMRNum
						s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(rowId)
						q:(objInstance = "")
						continue:(objInstance.Status '= "Save")
						s count = count + 1
					}
				}
			}
		}
	}
	q count
}

/// Desc:       获取docid和病历名称
/// Creator:    yejian
/// CreateDate: 2019-1-8
/// Output:     DocID 病历类型ID
///             RecordName 病历类型名称            
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetDocIDName")
Query GetDocIDName() As %Query(ROWSPEC = "DocID:%String,RecordName:%String")
{
}

ClassMethod GetDocIDNameExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.EMRTemplateCategoryD(rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(rowId)
		q:(obj="")
		continue:(obj.CategoryType'="TempCate")
		s DocID = rowId
		s RecordName = obj.CategoryName
		s ^CacheTemp(repid,ind) = $lb(DocID,RecordName)
		s ind=ind+1 								
	}
			
	Quit $$$OK
}

ClassMethod GetDocIDNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDocIDNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDocIDNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDocIDNameExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:       统计修改的病历
/// Creator:    yejian
/// CreateDate: 2018-4-18
/// Input:      aStartDate 创建开始日期 格式(YYYY-MM-DD)
///             aEndDate   创建结束日期 格式(YYYY-MM-DD)
///             aCtLocID   科室ID
///             aUserId	   医生ID 
/// 			apapmiNo   患者登记号
/// 			aAdmType  患者类型
/// 			aChartItemID 病历分类
/// Output:     papmiNo 患者登记号
///             PatientName 患者名称
///             PAAdmDate 就诊日期
///             SignTime 就诊时间
///             PatientID 住院号
///             TitleName 病历类型名称 
///             CreateDate 创建日期
///             CreateTime 创建时间
///             SignDate 签名日期
///             SignTime 签名时间
///             EpisodeID 就诊号
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetModRecordDatas","2018-03-01","2018-05-01","","","","","")
Query GetModRecordDatas(aStartDate As %String, aEndDate As %String, aCtLocID As %String, aUserId As %String, apapmiNo As %String, aAdmType As %String, aChartItemID As %String) As %Query(ROWSPEC = "ID:%String,papmiNo:%String,PatientName:%String,PAAdmDate:%String,PAAdmTime:%String,PatientID:%String,TitleName:%String,CreateDate:%String,CreateTime:%String,SignDate:%String,SignTime:%String,EpisodeID:%String,InstanceID:%String")
{
}

ClassMethod GetModRecordDatasExecute(ByRef qHandle As %Binary, aStartDate As %String, aEndDate As %String, aCtLocID As %String, aUserId As %String, apapmiNo As %String, aAdmType As %String, aChartItemID As %String) As %Status
{
	q:(aStartDate = "")||(aEndDate = "") $$$OK
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	s InstanceID = ""

	s StartDate = $zdh(aStartDate,3)
	s EndDate = $zdh(aEndDate,3)
	s EpisodeID = ""
	//如果登记号不为空情况
	if (apapmiNo'="")
	{
		s PAPMIDR = ""
		for
		{
			s PAPMIDR = $o(^PAPERi("PAPMI_PatNo",apapmiNo,PAPMIDR))
			q:(PAPMIDR = "")
			s PAADMRowID = ""
			s APAAdmType = ""
			for {
				s APAAdmType = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType))
				q:(APAAdmType ="")
				continue:((aAdmType'="")&&(aAdmType'=APAAdmType))
				continue:((APAAdmType '="O")&&(APAAdmType '="E")&&(APAAdmType '="I"))
				s EpisodeID=""
				for {
					s EpisodeID = $o(^PAPERdr(PAPMIDR,"ADM",APAAdmType,EpisodeID))
					q:(EpisodeID = "")
					s docId = ""
					for
					{
						s docId = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,docId))
						q:(docId = "")
						s EMRNum= ""
						for
						{
							s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,docId,EMRNum))
							q:(EMRNum = "")
							s emrLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,docId,EMRNum,""))
							q:(emrLogId = "")
							s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(emrLogId) 
							continue:(objLog.EMRStatus="deleted")
							continue:((objLog.CreateDate<StartDate)&&(objLog.CreateDate>EndDate))
							//通过日志判断签名后是否有修改
							s isModSign = ##Class(EMRservice.HISInterface.QueryInterface).GetIsModSignRecordByLog(emrLogId)
							continue:(isModSign '="1")
							
							s EMRNum = $tr(EMRNum," ","")
							s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,docId,""))
							q:(ecrecordID = "")
							s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
							q:(objRecord = "")
							s PatientID = objRecord.PatientID
							s ChartItemID = objRecord.RealChartItemID
							s InstanceID = ecrecordID_"||"_EMRNum
							s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
							q:(objInstance = "")
							continue:(objInstance.Status '= "Save")
							s signRowID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_InstanceID,""))
							continue:(signRowID="")
							s objSign = ##class(EMRinstance.EMRSign).%OpenId(signRowID)
							s SignDate = objSign.SignDate
							s SignTime = objSign.SignTime
							s EpisodeID = objInstance.RealEpisodeID
							d outputrow
						}
					}
				}
			}			
		}
	}
	else //其他情况根据日期范围查找相应数据
	{
		for date = StartDate:1:EndDate
		{
			s time = ""
			for
			{
				s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
				q:(time = "")
				s EpisodeID = ""
				for
				{
					s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
					q:(EpisodeID = "")
					s EpisodeID = $tr(EpisodeID," ","")
					s docId = ""
					for
					{
						s docId = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId))
						q:(docId = "")
						s EMRNum = ""
						for
						{
							s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,EMRNum))
							q:(EMRNum = "")
							s emrLogId = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,EMRNum,""))
							q:(emrLogId = "")
							s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(emrLogId) 
							continue:(objLog.EMRStatus="deleted")
							//通过日志判断签名后是否有修改
							s isModSign = ##Class(EMRservice.HISInterface.QueryInterface).GetIsModSignRecordByLog(emrLogId)
							continue:(isModSign '="1")
							
							s EMRNum = $tr(EMRNum," ","")
							s ecrecordID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,docId,""))
							q:(ecrecordID = "")
							s objRecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordID)
							q:(objRecord = "")
							s PatientID = objRecord.PatientID
							s ChartItemID = objRecord.RealChartItemID
							s InstanceID = ecrecordID_"||"_EMRNum
							s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)
							q:(objInstance = "")
							continue:(objInstance.Status '= "Save")
							s signRowID = $o(^DHCEMRI.EMRSignI("IdxInstance"," "_InstanceID,""))
							continue:(signRowID="")
							s objSign = ##class(EMRinstance.EMRSign).%OpenId(signRowID)
							s SignDate = objSign.SignDate
							s SignTime = objSign.SignTime
							s EpisodeID = objInstance.RealEpisodeID
							d outputrow
						}
					}
				}
			}
		}
	}
	Quit $$$OK
outputrow
	s mCurrRow = $g(^PAADM(EpisodeID))
	s PAADMDepCode = $p($g(mCurrRow),"^",4)
	s PAAdmDepCodeDR = $p($g(^CTLOC(PAADMDepCode)),"^",2)
	s TmpPAAdmTypeDR = $p($g(mCurrRow),"^",2)
	//只查询门诊，急诊和住院
	q:((aAdmType'="")&&(aAdmType'=TmpPAAdmTypeDR))
	q:((TmpPAAdmTypeDR'="O")&&(TmpPAAdmTypeDR'="E")&&(TmpPAAdmTypeDR'="I"))
	//科室ID验证
	q:((aCtLocID '= "")&&(PAADMDepCode '= aCtLocID))
	s DocId = ""
	//用户ID验证
	s:(aUserId '= "") DocId = $p($g(^SSU("SSUSR",aUserId)),"^",14)
	q:((DocId '= "")&&(PAADMDocCode '= DocId))
	//登记号验证
	s papmiNo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiNo(PatientID)
	q:((apapmiNo '="")&&(papmiNo'=apapmiNo))
	//病历分类验证
	q:((aChartItemID'="")&&(ChartItemID'=aChartItemID))
	//姓名
	s PatientName = ##class(EMRservice.HISInterface.PatientInfoAssist).Name(PatientID)
	s PAAdmDate = "" 
	s PAAdmTime = "" 
	s PAAdmDateTime=##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(EpisodeID)
	s PAAdmDate = $p(PAAdmDateTime,",",1) 
	s:(PAAdmDate '= "") PAAdmDate = $zd(PAAdmDate,3)
	s PAAdmTime = $p(PAAdmDateTime,",",2)
	s:(PAAdmTime '= "") PAAdmTime = $zt(PAAdmTime)
	s TitleName = objInstance.Title
	s CreateDate = $zd(objInstance.CreateDate,3)
	s CreateTime = $zt(objInstance.CreateTime) 
	s SignDate = $zd(SignDate,3)
	s SignTime = $zt(SignTime) 
	s ID=ind
	s ^CacheTemp(repid,ind) = $lb(ID,papmiNo,PatientName,PAAdmDate,PAAdmTime,PatientID,TitleName,CreateDate,CreateTime,SignDate,SignTime,EpisodeID,InstanceID)
	s ind=ind+1 
	Quit $$$OK
}

ClassMethod GetModRecordDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModRecordDatasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetModRecordDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModRecordDatasExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc: 		    签名后是否有修改
/// Creator:		yejian
/// CreateDate: 	2019-1-8
/// Input:          emrLogId  日志ID
/// Output: 	    isModRecord  签名后是否有修改
/// Debug:          w ##Class(EMRservice.HISInterface.QueryInterface).GetIsModSignRecordByLog("303")	
ClassMethod GetIsModSignRecordByLog(emrLogId As %String) As %String
{
	s isModRecord = "0"
	q:(emrLogId = "") isModRecord
	s isSign= ""
	s subId = ""
	for
	{
		s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",emrLogId,subId))
		q:(subId = "")
		s LogId = emrLogId_"||"_subId
		s objLog = ##Class(EMRinstance.InstanceLog).%OpenId(LogId)
		//判断是否签名
		s:(objLog.FinalStatus [ "Checked") isSign = "1"
		//签名后，有修改操作
		if ((isSign="1")&&(objLog.FinalStatus="finished")) 
		{
			s isModRecord ="1"
			q
		}
	}
	k objLog
	q isModRecord
}

/// Desc:       统计修改的病历占比
/// Creator:    yejian
/// CreateDate: 2018-4-18
/// Input:      aStartDate 创建开始日期 格式(YYYY-MM-DD)
///             aEndDate   创建结束日期 格式(YYYY-MM-DD)
/// 			aAdmType  患者类型
/// Output:     CtLocID 患者登记号
///             CtLocName 患者名称
///             UserId 就诊日期
///             UserName 就诊时间
///             AllCount 所有病历数
///             ModCount 修改病历数 
///             Percent 创建日期
/// Debug       d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetRecordsByDate","2018-03-01","2018-05-01")
Query GetRecordsByDate(aStartDate As %String, aEndDate As %String, aAdmType As %String) As %Query(ROWSPEC = "ID:%String,CtLocID:%String,CtLocName:%String,UserId:%String,UserName:%String,AllCount:%String,ModCount:%String,Percent:%String")
{
}

ClassMethod GetRecordsByDateExecute(ByRef qHandle As %Binary, aStartDate As %String, aEndDate As %String, aAdmType As %String) As %Status
{
	q:(aStartDate = "")||(aEndDate = "") $$$OK
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	s InstanceID = ""
	S ArrayData = ##class(%ArrayOfDataTypes).%New()
	s StartDate = $zdh(aStartDate,3)
	s EndDate = $zdh(aEndDate,3)
	s EpisodeID = ""
	for date = StartDate:1:EndDate
	{
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
			q:(time = "")
			s EpisodeID = ""
			for
			{
				s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
				q:(EpisodeID = "")
				s EpisodeID = $tr(EpisodeID," ","")
				s docId = ""
				for
				{
					s docId = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId))
					q:(docId = "")
					s EMRNum = ""
					for
					{
						s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,EMRNum))
						q:(EMRNum = "")
						s emrLogId = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,docId,EMRNum,""))
						q:(emrLogId = "")
						s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(emrLogId) 
						continue:(objLog.EMRStatus="deleted")
						s aUserID = objLog.CreateUserID
						//通过日志判断签名后是否有修改
						s isModSign = ##Class(EMRservice.HISInterface.QueryInterface).GetIsModSignRecordByLog(emrLogId)
						d outputrow
					}
				}
			}
		}
	}
	s intL=ArrayData.Count()
	s key=""
	for
	{	
		s key = ArrayData.Next(key)
		q:(key = "")
		s strRelut = ""
		s aCounts = ArrayData.GetAt(key)
		s CTLocid = $p(key,"^",1)
		s:(CTLocid'="") CTLocName = $p($g(^CTLOC(CTLocid)),"^",2)
		s UserID = $p(key,"^",2)
		s:(UserID'="") UserName = $p($g(^CTPCP(UserID,1)),"^",2)
		s aCount = $p(aCounts,"^",1)
		s mCount = $p(aCounts,"^",2)
		s Percent = "0"
		s:(aCount '="0") Percent =$e((mCount/aCount)*100,0,5) 
		s ID =ind
		s ^CacheTemp(repid,ind) = $lb(ID,CTLocid,CTLocName,UserID,UserName,aCount,mCount,Percent)
		s ind=ind+1 
	}
	Quit $$$OK
outputrow
	s mCurrRow = $g(^PAADM(EpisodeID))
	s TmpPAAdmTypeDR = $p($g(mCurrRow),"^",2)
	//只查询门诊，急诊和住院
	q:((aAdmType'="")&&(aAdmType'=TmpPAAdmTypeDR))
	s aCtLocID = $p($g(mCurrRow),"^",4)
	s DocId = ""
	s:(aUserID'="") DocId = $p($g(^SSU("SSUSR",aUserID)),"^",14)
	s strKey = aCtLocID_"^"_DocId
	if (ArrayData.GetAt(strKey)'="")
	{
		s strValue = ArrayData.GetAt(strKey)
		s aCount = $p(strValue,"^",1)+1
		s mCount = $p(strValue,"^",2)
		s:(isModSign="1") mCount =mCount+1
		s newValue = aCount_"^"_mCount
		d ArrayData.SetAt(newValue,strKey)
	}
	else
	{
		s aCount = 1
		s mCount = 0
		s:(isModSign="1") mCount =1
		s newValue = aCount_"^"_mCount
		d ArrayData.SetAt(newValue,strKey)
	}
	Quit $$$OK
}

ClassMethod GetRecordsByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRecordsByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRecordsByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecordsByDateExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:     根据起始时间统计指定DocId所书写病历的打印数量
/// CreatDate:2019-02-27
/// Creator:  Lina
/// Input:    AStartDate 开始查询日期
///           AEndDate   结束查询日期
///           ADocId     目录展现结构挂模板一层的目录Id
/// Output:   title      病历名称
///           printCount 打印数量
/// Debug:    d ##Class(%ResultSet).RunQuery("EMRservice.HISInterface.QueryInterface","GetInstancePrintCount","2019-01-01","2019-02-15","102") 
Query GetInstancePrintCount(AStartDate As %String, AEndDate As %String, ADocId As %String) As %Query(ROWSPEC = "title:%String,printCount:%String")
{
}

ClassMethod GetInstancePrintCountExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADocId As %String) As %Status
{
	q:(AStartDate = "")||(AEndDate = "")||(ADocId = "") $$$OK
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	S ArrayData = ##class(%ArrayOfDataTypes).%New()
	s StartDate = $zdh(AStartDate,3)
	s EndDate = $zdh(AEndDate,3)
	for date = StartDate:1:EndDate
	{
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time))
			q:(time = "")
			s EpisodeID = ""
			for
			{
				s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID))
				q:(EpisodeID = "")
				s EpisodeID = $tr(EpisodeID," ","")
				//q:(EpisodeID '= "2173")
				s EMRNum = ""
				for
				{
					s EMRNum = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",date,time,EpisodeID,ADocId,EMRNum))
					q:(EMRNum = "")
					s emrLogId = $o(^DHCEMRI.EMRLogsI("IdxMain",EpisodeID,ADocId,EMRNum,""))
					q:(emrLogId = "")
					s objLog = ##Class(EMRinstance.EMRLogs).%OpenId(emrLogId) 
					q:(objLog.EMRStatus = "deleted")
					s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",EpisodeID,ADocId,""))
					q:(ecrecordId = "")
					s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(ecrecordId_"||"_EMRNum)
					q:(objInstanceData = "")
					q:($zcvt(objInstanceData.Status,"U") '= "SAVE")
					s title = objInstanceData.Title
					//b ;emrLogId
					if (ArrayData.GetAt(ADocId_"^"_objInstanceData.RealTemplateID) '= "")
					//if (ArrayData.GetAt(ADocId_"^"_title_"^"_ecrecordId_"||"_EMRNum) '= "")
					//if (ArrayData.GetAt(ADocId_"^"_title) '= "")
					{
						s printcount = $p(ArrayData.GetAt(ADocId_"^"_objInstanceData.RealTemplateID),"^",2)
						//s printcount = ArrayData.GetAt(ADocId_"^"_title_"^"_ecrecordId_"||"_EMRNum)
						//s printcount = ArrayData.GetAt(ADocId_"^"_title)
					}else {
						s printcount = 0
					}
					s printcount = printcount + ..RecHasActionCount(emrLogId,"PRINT")
					d ArrayData.SetAt(title_"^"_printcount,ADocId_"^"_objInstanceData.RealTemplateID)
					//d ArrayData.SetAt(printcount,ADocId_"^"_title_"^"_ecrecordId_"||"_EMRNum)
					//d ArrayData.SetAt(printcount,ADocId_"^"_title)
				}
			}
		}
	}

	s key=""
	for
	{	
		s key = ArrayData.Next(key)
		q:(key = "")
		s result = ArrayData.GetAt(key)
		s title = $p(result,"^",1)
		s printcount = $p(result,"^",2)
		//s printcount = ArrayData.GetAt(key)
		//s title = $p(key,"^",2)
		//s ID = $p(key,"^",3)
		//s ID = ind
		s ^CacheTemp(repid,ind) = $lb(title,printcount)
		s ind=ind+1 
	}
	Quit $$$OK
}

ClassMethod GetInstancePrintCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstancePrintCountExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstancePrintCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstancePrintCountExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:     根据AEMRLogsId统计病历被指定Aaction操作的次数
/// CreatDate:2019-02-27
/// Creator:  Lina
/// Input:    AEMRLogsId 表EMRinstance.EMRLogs的rowId
///           Aaction    操作
/// Output:   count      操作次数
/// Debug:    w ##Class(EMRservice.HISInterface.QueryInterface).RecHasActionCount("288","PRINT")
ClassMethod RecHasActionCount(AEMRLogsId As %String, Aaction As %String) As %String
{
	s count = 0
	q:(AEMRLogsId = "")||(Aaction = "") count
	s OperateDate = ""
	for
	{
		s OperateDate = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",AEMRLogsId," "_$zcvt(Aaction,"U"),OperateDate))
		q:(OperateDate = "")
		s OperateTime = ""
		for
		{
			s OperateTime = $o(^DHCEMRI.InstanceLogI("IdxParRefActionDateTime",AEMRLogsId," "_$zcvt(Aaction,"U"),OperateDate,OperateTime))
			q:(OperateTime = "")
			s count = count + 1
		}
	}
    q count
}

}
