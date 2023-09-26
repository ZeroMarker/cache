/// 名称: EMRservice.BL.BIToTimeLine
/// 描述: 给时间线的数据接口
/// 编写者：FangLuoCheng
/// 编写日期: 2015-03-30
Class EMRservice.BL.BIToTimeLine Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetDataByTimeSpanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataByTimeSpanExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataByTimeSpanExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %Status
{
	//b "s"
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)
	
	q:(AEpisodeID="") $$$OK	   
	s EMRDocID = ""
	for {
		s EMRDocID = $O(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID, EMRDocID))
		q:(EMRDocID = "")
		
		s realEMRDocID = $e(EMRDocID, 2, $L(EMRDocID))
		
		s hasECRecordIDGeted = "0", ecRecordID = "" 
		s EMRNum = 0
		for {
			s EMRNum = $O(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID, EMRDocID, EMRNum))
			q:(EMRNum = "")
			
			//约定：
			//将病历默认为可重复病历取ECRecordID，
			//若ECRecordID不为空则为可重复病历
			//若ECRecordID为空则为唯一病历
			if (hasECRecordIDGeted = "0")
			{
				s ecRecordID = ..GetMultiECRecordID(AEpisodeID, realEMRDocID)
				s hasECRecordIDGeted = "1"
			}
			
			s isFirstCommplete = "1"
			
			s EMRLogID = $O(^DHCEMRI.EMRLogsI("IdxMain",AEpisodeID, EMRDocID, EMRNum, ""))			
			q:(EMRLogID = "")	
			
			s subId=""
			for
			{
				s subId = $o(^DHCEMRI.InstanceLogI("IdxParRef",EMRLogID,subId))
				q:(subId = "")
				s rowId = EMRLogID_"||"_subId				
				s instanceLog = ##Class(EMRinstance.InstanceLog).%OpenId(rowId)
				continue:(instanceLog = "")				
			   
			    //事件
			    s Action = instanceLog.Action					
			    s ActCode = ..ConvertActCode(Action)
			    continue:(ActCode = "")							//校验操作码
			    //住院医师、主治医师、副主任医师/主任医师 审核即可
			    continue:(ActCode '= "090103")&&(ActCode '= "090104")&&(ActCode '= "090105")
			    //continue:(ActCode = "090102")&&(isFirstCommplete = "0")
				
			  
			    //日期和时间, 格式为Cache内部逻辑值
			    s ActDate = instanceLog.OperateDate				
			    s ActTime = instanceLog.OperateTime
			    s idValid = "1"
			    //在协和无法生成数据修改
			    //s isValid = ..IsDateTimeValid(ActDate,ActTime,AStartDate,AStartTime,AEndDate,AEndTime)
			    //continue:(isValid = "0")						//校验日期时间
			    //摘要
			    s Summary = ..GetSummaryInfo(ecRecordID, AEpisodeID, realEMRDocID, EMRNum)								//摘要
				
			    s EpisodeID = AEpisodeID						//就诊指针
			    s DataTypeCode = "0901"							//数据类型
			    s DataValue = ""								//数据
			    s ObjectID = EMRLogID							//业务数据指针
			    s CareProviderID = instanceLog.RRealOperateUserID	//医护人员指针
			    s Parameters = ""								//自定义数据项
			   				
			    s ^CacheTemp(repid,ind) = $LB(EpisodeID,ActCode,ActDate,ActTime,DataTypeCode,Summary,DataValue,ObjectID,CareProviderID,Parameters)
			    s ind = ind + 1
			}
	
	
			s instanceLog =##Class(EMRservice.BL.BLEMRLogs).GetFinalLog(EMRLogID)		
			continue:(instanceLog = "")
				
			
		}
	}
	
	Quit $$$OK
}

ClassMethod GetDataByTimeSpanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataByTimeSpanExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	FangluoCheng
/// CreatDate:	2015-03-30
/// Desc:：   	获取指定时间段内电子病历文书信息
/// Table：		无
/// Input：     AEpisodeID ：就诊指针
/// 			AStartDate ：起始日期，格式为Cache内部逻辑值（如$H的日期部分）
/// 			AStartTime ：起始时间，格式为Cache内部逻辑值（如$H的时间部分）
/// 			AEndDate : 截止日期，格式为Cache内部逻辑值（如$H的日期部分）
/// 			AEndTime : 截止时间，格式为Cache内部逻辑值（如$H的时间部分）
/// Output:		EpisodeID : 就诊指针,
/// 			ActCode : 事件
/// 			ActDate : 日期, 格式为Cache内部逻辑值（如$H的日期部分）
/// 			ActTime : 时间, 格式为Cache内部逻辑值（如$H的时间部分）
/// 			DataTypeCode : 数据类型,
/// 			Summary : 摘要
/// 			DataValue : 数据,
/// 			ObjectID : 业务数据指针,
/// 			CareProviderID : 医护人员指针,
/// 				Parameters : 自定义数据项
/// Return:		无
/// Others：    d ##Class(%ResultSet).RunQuery("EMRservice.BL.BIToTimeLine","GetDataByTimeSpan","50929","","","","")	
Query GetDataByTimeSpan(AEpisodeID As %String, AStartDate As %String, AStartTime As %String, AEndDate As %String, AEndTime As %String) As %Query(ROWSPEC = "EpisodeID:%String,ActCode:%String,ActDate:%String,ActTime:%String,DataTypeCode:%String,Summary:%String,DataValue:%String,ObjectID:%String,CareProviderID:%String,Parameters:%String")
{
}

ClassMethod GetMultiECRecordID(AEpisodeID As %String, APrintDocID As %String) As %String
{
	s ecRecordID = $O(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID," ML"_APrintDocID,""))
	q ecRecordID
}

ClassMethod GetSummaryInfo(AECRecordID As %String, AEpisodeID As %String, AEMRDocID As %String, AEMRNum As %String) As %String
{
	s summary = ""
	
	if (AECRecordID = "")
	{
		s objEMRCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(AEMRDocID)
		q:(objEMRCategory = "") summary
		
		s objParentEMRCategory = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEMRCategory.ParentCategoryID)
		q:(objParentEMRCategory = "") summary
		
		s summary = objParentEMRCategory.CategoryName
	}
	else
	{
		s childSub = $O(^DHCEMRI.InstanceDataI("IdxEcRecordAndListNo",AECRecordID," "_AEMRNum,""))
		q:(childSub = "") summary
		
		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(AECRecordID_"||"_childSub)
		q:(objInstance = "") summary
		
		s summary = objInstance.Title
	}
	
	q summary
}

ClassMethod IsDateTimeValid(date As %String, time As %String, fromDate As %String, fromTime As %String, toDate As %String, toTime As %String) As %Boolean
{
	q:(date < fromDate) "0"
	q:(date = fromDate)&&(time < fromTime) "0"
	q:(date > toDate) "0"
	q:(date = toDate)&&(time > toTime) "0"
	q "1"
}

ClassMethod ConvertActCode(AEMRActCode As %String) As %String
{
	s AEMRActCode = $zcvt(AEMRActCode,"U") 
	q:(AEMRActCode = "COMPLETE") "090102"
	q:(AEMRActCode = "REFCOMPLETE") "090102"
	q:(AEMRActCode = "RESIDENTCHECK") "090103"
	q:(AEMRActCode = "ATTENDINGCHECK") "090104"
	q:(AEMRActCode = "CHIEFCHECK") "090105"
	q:(AEMRActCode = "PRINT") "090106"
	q ""
}

/// Debug:	d ##Class(EMRservice.BL.BIToTimeLine).TestQuery("58")
ClassMethod TestQuery(AEpisodeID As %String)
{
	Set rset = ##class(%ResultSet).%New("EMRservice.BL.BIToTimeLine:GetDataByTimeSpan")
	Set columns = rset.GetColumnCount()
	
	// Execute the query
	//set startDate = "1"
	set startDate = $zdh("2011-01-01",3)
	set startTime = "1"
	//set endDate = $P($H,",",1)
	set endDate = $zdh("2015-12-31",3)
	set endTime = $P($H,",",2)
	Set sc = rset.Execute(AEpisodeID,startDate,startTime,endDate,endTime)

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

/// Debug:	d ##Class(EMRservice.BL.BIToTimeLine).InitEprInstance("77152")
ClassMethod InitEMRInstance(AEpisodeID As %String)
{
	
	Set rset = ##class(%ResultSet).%New("EMRservice.BL.BIToTimeLine:GetDataByTimeSpan")
	Set columns = rset.GetColumnCount()
	
	// Execute the query
	//set startDate = "1"
	set startDate = $zdh("2011-01-01",3)
	set startTime = "1"
	//set endDate = $P($H,",",1)
	set endDate = $zdh("2011-12-31",3)
	set endTime = $P($H,",",2)
	Set sc = rset.Execute(AEpisodeID,startDate,startTime,endDate,endTime)
	// Now fetch the results
	//根据就诊ID取得病人ID
	s PatientID=+^PAADM(AEpisodeID)
	s serviceobj=##class(icare.TimeLineService.BOClinicalRepository).%New()
	While (rset.Next()) {
		s obj=##class(icare.entity.ClinicalRepository).%New()
		s obj.EpisodeID=rset.Data("EpisodeID")
		s obj.PatientID=PatientID
		s objAct=##Class(icare.ClinicalDataTypeAct).%OpenId(rset.Data("ActCode"))
		if (objAct '= "")
		{
		s obj.ActCode= objAct.Code
		s obj.ActDate= rset.Data("ActDate")
		s obj.ActTime= rset.Data("ActTime")
		s objDataType=##Class(icare.ClinicalDataType).%OpenId(rset.Data("DataTypeCode"))
		
		s obj.DataTypeCode= objDataType.Code
		//s obj.DataTypeCode= "0901"
		s obj.DataValue= rset.Data("DataValue")
		
		s obj.ObjectID= rset.Data("ObjectID")
		s obj.CareProviderID= rset.Data("CareProviderID")
		s obj.Summary= rset.Data("Summary")
		s id = $o(^icare.ClinicalRepositoryI("IndexActDateTime"," "_AEpisodeID,obj.DataTypeCode," "_obj.ObjectID,obj.ActCode,obj.ActDate,obj.ActTime,0))
		if (id '="")
		{
			s obj.ID= id
			d serviceobj.Update(obj)
		}
		else
		{
			d serviceobj.Insert(obj)
		}
		}
		//d obj.%Save()
		//d obj.%Close()
		s obj=""
		
	}
	
	Do rset.Close()
}

}
