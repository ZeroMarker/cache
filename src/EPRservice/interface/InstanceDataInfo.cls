/// CreateUser: houj
/// CreateDate: 2010-01-18
/// Desc: 电子病历组接口，提供实例数据相关信息
Class EPRservice.interface.InstanceDataInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 取新框架历次病历列表
/// Input: 	episodeID 就诊rowid
/// 		docIDs 打印模板DocID列表，以^分隔
/// 		byDesc 排序方式：1 正序, -1  逆序， 预留的参数
/// Return: 历次病历列表
Query GetMultiList(episodeID As %String, docIDs As %String, byDesc As %String = "1") As %Query(ROWSPEC = "PrtDocID:%String, EPRNum:%String, EPRLogsID:%String, InstanceID:%String, CreateDate:%String, CreateTime:%String, HappenDate:%String, HappenTime:%String, Status:%String, CreateUser:%String")
{
}

ClassMethod GetMultiListExecute(ByRef qHandle As %Binary, episodeID As %String, docIDs As %String, byDesc As %String = "1") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	set ind=1
 	
	//将多个打印模板DocID中取出相应的Logs的docID及eprnum，将其按日期时间作为索引存放在^CacheTemp中
	s docIDCount = $l(docIDs, "^")
	for i=1:1:docIDCount
	{
		s curDocID = $p(docIDs, "^", i)
		
		//处理每一个打印模板的DocID
		if (curDocID="") continue
		s curEPRNum = 0
		for {
			s curEPRNum = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum))
			q:(curEPRNum="")

			//取日志对象
			s eprLogsRowID = $o(^DHCEPRI.EPRLogsI("IdxMain", " "_episodeID, " "_curDocID, curEPRNum, ""))
			if (eprLogsRowID = "") continue
			
			//取InstanceData的RowId
			s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_episodeID, " ML"_curDocID, ""))
			if (ecRecordID = "") continue
			s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_curEPRNum, ""))
			if (childSub = "") continue
			s instanceId = ecRecordID_"||"_childSub
			 
			//取日志相关信息
			s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsRowID)
			if (eprLogs="")	continue
			s createDate = eprLogs.CreateDate
			s createTime = eprLogs.CreateTime
			s happenDate = eprLogs.HappenDate
			s happenTime = eprLogs.HappenTime
			s createUser = eprLogs.CreateUserID
			s status = eprLogs.EPRStatus
			d eprLogs.%Close()
			s eprLogs = ""	
			
			//对数据进行处理和转换
			if happenDate="" {	s happenDate = $p($H,",",1)}
			if happenTime="" {	s happenTime = $p($H,",",2)}					
			s statusDesc = ""
			if status'=""
			{	&sql(SELECT StatusName into :statusDesc FROM EPRmeta.EPRStatus WHERE StatusCode = :status)}
			if createUser'=""
			{	s createUser=$P($G(^SSU("SSUSR",createUser)),"^",2)}
			
			//取InstanceData相关信息
			s title = ""
			s objInstance = ##class(EPRinstance.InstanceData).%OpenId(instanceId)
			if (objInstance '= "")
			{
				s title = objInstance.Title
			}
				
			//设置返回值								顺序号					实例数据ID
			s ^CacheTemp(repid, ind) = $LB(curDocID, curEPRNum, eprLogsRowID, instanceId, createDate, createTime, happenDate, happenTime, statusDesc, createUser)
			s ind = ind + 1			
		}
	}
	
	quit $$$OK
}

ClassMethod GetMultiListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMultiListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 以创建日期、创建人科室为条件，获取新框架历次病历列表
/// Input: 	episodeID 就诊rowid
/// 		startDate 起始日期
/// 		endDate 结束日期
/// 		ctLocID 创建人科室
/// 		byDesc 排序方式：1 正序, -1  逆序， 预留的参数
/// Return: 历次病历列表
Query GetMultiListByDate(docID As %String, startDate As %String, endDate As %String, ctLocID As %String, byDesc As %String = "1") As %Query(ROWSPEC = "InstanceDataID:%String, EpisodeID:%String, CreateDate:%String, CreateTime:%String, CreateUserID:%String, CreateCtLocID:%String, HappenDate:%String, HappenTime:%String, Status:%String, ModifyDate:%String, ModifyTime:%String")
{
}

ClassMethod GetMultiListByDateExecute(ByRef qHandle As %Binary, docID As %String, startDate As %String, endDate As %String, ctLocID As %String, byDesc As %String = "1") As %Status
{
	//b "s"
	
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
 	
 	//校验入参合法性
 	quit:((docID="")||(startDate="")||(endDate="")) $$$OK
 	quit:(startDate>endDate) $$$OK
	
	//开始查询实例数据
	set date = " "_startDate
	for {
		s time = ""
		for {
			s time = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", date, time))
			q:(time="")
			
			s episodeID = ""
			for {
				s episodeID = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", date, time, episodeID))
				q:(episodeID="")
				
				s eprNum = ""
				for {
					s eprNum = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", date, time, episodeID, " "_docID, eprNum))
					q:(eprNum="")
					
					//取EPRLogs的RowId
					s eprLogsID = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", date, time, episodeID, " "_docID, eprNum, ""))
					if eprLogsID="" continue
					
					//取InstanceData的RowId
					s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", episodeID, " ML"_docID, ""))
					if (ecRecordID = "") continue
					s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_eprNum, ""))
					if (childSub = "") continue
					s instanceId = ecRecordID_"||"_childSub
					
					
					s retInstanceId = instanceId, retEpisodeId = $E(episodeID,2,$L(episodeID))
					s retCreateDate = "", retCreateTime = "", retCreateUserID = "", retCreateCtLocID="", retHappenDate="", retHappenTime="", retStatus=""
					s retModifyDate = "", retModifyTime = ""
					 
					s eprLogs = ##class(EPRinstance.EPRLogs).%OpenId(eprLogsID)
					if eprLogs '= ""
					{
						s retCreateDate = eprLogs.CreateDate
						s retCreateTime = eprLogs.CreateTime
						s retCreateUserID = eprLogs.CreateUserID
						s retHappenDate = eprLogs.HappenDate
						s retHappenTime = eprLogs.HappenTime
						s retStatus = eprLogs.EPRStatus
						if (retStatus'="") {	&sql(SELECT StatusName into :retStatus FROM EPRmeta.EPRStatus WHERE StatusCode = :retStatus)}
					}
					
					s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(retInstanceId)
					if objInstanceData '= ""
					{
						s retModifyDate = objInstanceData.ModifyDate
						s retModifyTime = objInstanceData.ModifyTime
					}
					
					//设置返回值					实例数据ID		就诊rowid	创建日期		创建时间		创建人ID		创建科室（暂时为空）
					s ^CacheTemp(repid, ind) = $LB(retInstanceId, retEpisodeId, retCreateDate, retCreateTime, retCreateUserID, retCreateCtLocID, retHappenDate, retHappenTime, retStatus, retModifyDate, retModifyTime)
					s ind = ind + 1		
				}
			}
		}
		
		s date = $o(^DHCEPRI.EPRLogsI("IdxCreateDateTime", date))
		q:(date="")
		q:(date>endDate)
	}
	
	quit $$$OK
}

ClassMethod GetMultiListByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMultiListByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMultiListByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMultiListByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

/// Desc: 	获取ECRecord的RowId
/// Input:	aEpisodeID: 就诊RowId
/// 		aMountCategoryId: 挂载目录Id,即模板所属Normal或Group类型目录的Id
/// 		aCategoryId: 父目录Id,即模板直接所属目录Id，当模板为Normal类型时，它与挂载目录Id相同
/// 		aType: 类型，Single 或 Multi
/// Return: ECRecordID
/// Debug: w ##class(EPRservice.interface.InstanceDataInfo).GetECRecordIDByCate("65","28","28","Multi")
ClassMethod GetECRecordIDByCate(aEpisodeId As %String, aMountCategoryId As %String, aCategoryId As %String, aType As %String) As %String
{
	b "s"
	q:(($d(aEpisodeId)=0)||($d(aMountCategoryId)=0)||($d(aCategoryId)=0)||($d(aType)=0)) ""
	q:((aEpisodeId="")||(aMountCategoryId="")||(aCategoryId="")||(aType="")) ""
	
	s retVal = ""
	
	if aType = "Single"
	{	s retVal = ..GetSingleECRecord(aEpisodeId,aMountCategoryId, aCategoryId)}
	elseif aType = "Multi"
	{	s retVal = ..GetMultiECRecord(aEpisodeId,aMountCategoryId)}
	
	q retVal
}

ClassMethod GetSingleECRecord(aEpisodeId As %String, aMountCategoryId As %String, aCategoryId As %String) As %String
{
	s retVal = ""
	
	// 取ECRecord
	s oldRecCount = ##class(EPRinstance.ECRecord).GetOldRecCount(aEpisodeId)
	if oldRecCount > 0
	{	
		//旧框架，使用 [挂载目录Id] 获取 [ECRecord]
		s retVal = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	}
	else
	{	
		//新框架，使用 [父目录Id] 获取 [ECRecord]
		s retVal = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aCategoryId)
	}
	
	q retVal
}

ClassMethod GetMultiECRecord(aEpisodeId As %String, aMountCategoryId As %String)
{
	s retVal = ""
	s retVal = ##class(EPRinstance.ECRecord).GetIDByEpisodeAndCategoryID(aEpisodeId, aMountCategoryId)
	q retVal
}

/// Desc: 根据InstanceDataID获取InstanceData相关信息
/// Input: instanceDataId
/// Return: ModifyDate^ModifyTime 时间日期格式为Cache内部格式
/// Debug：w ##class(EPRservice.interface.InstanceDataInfo).GetInstanceModifyTime("119||3")
ClassMethod GetInstanceModifyTime(instanceDataId As %String) As %String
{
	q:(instanceDataId="") ""
	
	s objInstanceData = ##class(EPRinstance.InstanceData).%OpenId(instanceDataId)
	q:(objInstanceData="") ""
	
	s retVal = ""
	s retVal = objInstanceData.ModifyDate
	s retVal = retVal_"^"_objInstanceData.ModifyTime
	q retVal
}

/// -------------------- 以下为测试方法 --------------
/// w ##Class(EPRservice.interface.InstanceDataInfo).TestGetMultiList("65","24")
ClassMethod TestGetMultiList(Adm, prtDocId)
{
	 Set rset = ##class(%ResultSet).%New("EPRservice.interface.InstanceDataInfo:GetMultiList")
	 Set columns = rset.GetColumnCount()
	 Set sc = rset.Execute(Adm,prtDocId)
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

/// w ##Class(EPRservice.interface.InstanceDataInfo).TestGetMultiListByDate("24","2001-1-1","2010-1-1","12")
ClassMethod TestGetMultiListByDate(prtDocId, stDate, endDate, ctLocId)
{
	s stDate = $zdh(stDate,3)
	s endDate = $zdh(endDate,3)
	Set rset = ##class(%ResultSet).%New("EPRservice.interface.InstanceDataInfo:GetMultiListByDate")
	 Set columns = rset.GetColumnCount()
	 Set sc = rset.Execute(prtDocId,stDate,endDate,ctLocId)
	 // Now fetch the results
	 While (rset.Next()) {
	 Write "------------------------",!
	 For col = 1:1:columns {
	 Write rset.GetColumnName(col),": "
	 Write rset.GetData(col),!
	 }
	 Write "------------------------"
	 }
	 Do rset.Close()
}

}
