/// Desc：      导出病历工具类
/// Creator：   yejian
/// CreateDate：2019-6-24
Class EMRservice.BL.BLExportTool Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc: 根据病历保存时间段获取病历实例ID并插入队列数据中
/// Creator:    yejian
/// CreateDate: 2019-6-24
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     插入的数量
/// Debug       w ##Class(EMRservice.BL.BLExportTool).SetDataByRecordDate("2018-03-23","2018-03-30","IMAGE")
ClassMethod SetDataByRecordDate(AStartDate As %String, AEndDate As %String, AType As %String = "IMAGE") As %String
{
	s resCount = 0	
	q:(AStartDate = "") resCount
    q:(AEndDate = "") resCount
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)

	s sdate=startDate-1
	s startOutDate="",startOutTime="",startInDate="",startIntTime=""
	
	for 
	{	
		s sdate=$o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate))
		q:(sdate = "")
		q:(sdate>endDate)			
		s stime=""			
		for
		{   
			s stime = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime))
			q:(stime = "")		         
			s EpisodeID=""
			for
			{
				s EpisodeID = $o(^DHCEMRI.EMRLogsI("IdxCreateDateTime",sdate,stime,EpisodeID))		                
				q:(EpisodeID = "")		                
				s EpisodeID=$tr(EpisodeID," ","")			                	                
				s InstanceID=..GetInstanceID(sdate,stime,EpisodeID)
				q:(InstanceID="")
				s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
				q:(objInstance = "")
				q:(objInstance.Status'="Save")
				s startInDate=objInstance.CreateDate
				s startIntTime=objInstance.CreateTime
				s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(EpisodeID)
				s ipAddress=##Class(EMRservice.SystemParameter).GetServerIP()
				q:((startOutDate>startInDate)||((startOutDate=startInDate)&&(startOutTime>=startIntTime))) 

				q:($d(^DHCEMRI.Export.QueueI("IdxTyQueue"," "_AType," "_patientId," "_EpisodeID," "_InstanceID))>0)

				s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,EpisodeID,InstanceID,ipAddress,AType)        
				s resCount=resCount+1
				q		
			}
		}	
	}
	q resCount
}

/// Desc: 根据就诊时间段获取病历实例ID并插入队列数据中
/// Creator:    yejian
/// CreateDate: 2019-6-24
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     插入的数量
/// Debug       w ##Class(EMRservice.BL.BLExportTool).SetDataByAdmitDate("2018-07-18","2018-09-18","IMAGE")
ClassMethod SetDataByAdmitDate(AStartDate As %String, AEndDate As %String, AType As %String = "IMAGE") As %String
{

	s resCount = 0	
	q:(AStartDate = "") resCount
    q:(AEndDate = "") resCount
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	s InstanceID=""
	for Adate = startDate:1:endDate
	{
		s AEpisodeId = ""
		for {
			s AEpisodeId = $O(^PAADMi("PAADM_AdmDate",Adate,AEpisodeId))
			q:(AEpisodeId = "")
			s InstanceID=""
			s AStatus = " SAVE"
			s date = ""
			for
			{
				s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date))
				q:(date = "")
				s time = ""
				for
				{
					s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time))
					q:(time = "")
					s parentId = ""
					for
					{
						s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId))
						q:(parentId = "")
						s subId = ""
						for
						{
							s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId,subId))
							q:(subId = "")
						    s InstanceID=parentId_"||"_subId
						    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
			                q:(objInstance = "")
			                continue:(objInstance.Status'="Save")
			                s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeId)
			                s ipAddress=##Class(EMRservice.SystemParameter).GetServerIP()
						    q:($d(^DHCEMRI.Export.QueueI("IdxTyQueue"," "_AType," "_patientId," "_AEpisodeId," "_InstanceID))>0)
						    s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,AEpisodeId,InstanceID,ipAddress,AType)        
	                     	s resCount=resCount+1
						}
					}
				}
			}
		}
	}
	q resCount
}

/// Desc: 根据就诊时间段补非连续性加载病历到等待队列表中
/// Creator:    yejian
/// CreateDate: 2019-6-24
/// Input:      AStartDate 开始时间 
///             AEndDate 结束时间
/// Output:     插入的数量
/// Debug       w ##Class(EMRservice.BL.BLExportTool).SetRepairDataByRecordDate("2018-03-23","2018-03-30","IMAGE")
ClassMethod SetRepairDataByRecordDate(AStartDate As %String, AEndDate As %String, AType As %String = "IMAGE") As %String
{
	s resCount = 0	
	s InstanceID=""
	q:(AStartDate = "") $$$OK
    q:(AEndDate = "") $$$OK
	s startDate = $zdh(AStartDate,3)
	s endDate = $zdh(AEndDate,3)	
	  	
	for Adate = startDate:1:endDate
	{
		s AEpisodeId = ""
		for {
			s AEpisodeId = $O(^PAADMi("PAADM_AdmDate",Adate,AEpisodeId))
			q:(AEpisodeId = "")
			s InstanceID=""
			s AStatus = " SAVE"
			s ChartItemID = ""
			for
			{
				s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID))
				q:(ChartItemID = "")
				s eRowid = ""
				for
				{
					s eRowid = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID,eRowid))
					q:(eRowid = "")
					s objEcreord = ##Class(EMRinstance.ECRecord).%OpenId(eRowid)
					//只取重复的非连续加载病历
					continue:((objEcreord.ChartItemType '= "Multiple")||(objEcreord.DocumentCharacteristic '="0"))
					
					Set key = ""
					do
					{ 
				    	S objInstanceData = objEcreord.Instances.GetNext(.key)
					    if (objInstanceData '= "")
				     	{ 
					     	continue:(objInstanceData.Status'="Save")
					     	s InstanceID = objInstanceData.%Id()
						    s startInDate=objInstanceData.CreateDate
							s startIntTime=objInstanceData.CreateTime
							s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeId)
							s ipAddress=##Class(EMRservice.SystemParameter).GetServerIP()
							
							continue:($d(^DHCEMRI.Export.QueueI("IdxTyQueue"," "_AType," "_patientId," "_AEpisodeId," "_InstanceID))>0)
							
							s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,AEpisodeId,InstanceID,ipAddress,AType)        
							s resCount=resCount+1	
					  	} 
			 		 } 
			 		 while (key '="" )
				}
			}
		}
	}
	q resCount
}

/// 修改DocumentCharacteristic值(协和)
/// w ##Class(EMRservice.BL.BLExportTool).UpdateSetDocumentCharacteristic()
ClassMethod UpdateSetDocumentCharacteristic() As %String
{
	s totCount = 0
	s resCount=""
	s resModCount=""
	s AEpisodeId = ""
	for
	{
		s AEpisodeId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId))
		q:(AEpisodeId = "")
		s ChartItemID = ""
		for
		{
			s ChartItemID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID))
			q:(ChartItemID = "")
			s eRowid = ""
			for
			{
				s eRowid = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeId,ChartItemID,eRowid))
				q:(eRowid = "")
				
				s totCount =  totCount + 1
				if ((totCount#500)=0)
				{
					w !, "totCount:"_totCount
				}
				
				s objEcreord = ##Class(EMRinstance.ECRecord).%OpenId(eRowid)
				
				if ((objEcreord.ChartItemType = "Multiple")&&(objEcreord.DocumentCharacteristic ="0"))
				{
					s resModCount= resModCount+1
				}
				
				//只取重复的非连续加载病历
				continue:((objEcreord.ChartItemType '= "Multiple")||(objEcreord.DocumentCharacteristic '="0"))
				s aChartItemID = $tr(ChartItemID," ","")
				s objEmrTemplateCategory = ##class(EMRmeta.EMRTemplateCategory).%OpenId(aChartItemID)
				q:(objEmrTemplateCategory="")
				continue:(objEmrTemplateCategory.IsLeadframe'=1)
				s objEcreord.DocumentCharacteristic=1
				//s sc= objEcreord.%Save()
				s resCount=resCount+1
				
			}
				
		}
	}
	
	w !,"recreate image:"_resModCount
	w !,"update ecrecord:"_resCount
	
	q resCount_"^"_resModCount
}

/// Desc: 根据就诊号获取病历实例ID并插入队列数据中
/// Creator:    yejian
/// CreateDate: 2019-6-24
/// Input:      AEpisodeId 就诊号 
///             AType 生成类型
/// Output:     插入的数量
/// Debug       w ##Class(EMRservice.BL.BLExportTool).SetDataByAdmID("317","IMAGE")
ClassMethod SetDataByAdmID(AEpisodeId As %String, AType As %String = "IMAGE") As %String
{

	s resCount = 0	
	q:(AEpisodeId = "") resCount
    q:(AType = "") resCount
	s InstanceID=""
	s AStatus = " SAVE"
	s date = ""
	for
	{
		s date = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date))
		q:(date = "")
		s time = ""
		for
		{
			s time = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time))
			q:(time = "")
			s parentId = ""
			for
			{
				s parentId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId))
				q:(parentId = "")
				s subId = ""
				for
				{
						s subId = $o(^DHCEMRI.InstanceDataI("IdxEpisodeStatusHappenDateTime",AEpisodeId,AStatus,date,time,parentId,subId))
						q:(subId = "")
					    s InstanceID=parentId_"||"_subId
					    s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(InstanceID)  
		                q:(objInstance = "")
		                continue:(objInstance.Status'="Save")
		                s patientId = ##Class(EMRservice.HISInterface.PatientInfoAssist).GetPapmiDR(AEpisodeId)
		                s ipAddress=##Class(EMRservice.SystemParameter).GetServerIP()
					    q:($d(^DHCEMRI.Export.QueueI("IdxTyQueue"," "_AType," "_patientId," "_AEpisodeId," "_InstanceID))>0)
					    s insertQueue = ##Class(EMRservice.BL.BLExportQueue).SetData(patientId,AEpisodeId,InstanceID,ipAddress,AType)        
                     	s resCount=resCount+1
				}
			}
		}
	} 
	
	q resCount
}

/// Desc: 将失败队列数据迁移到等待队列数据中
/// Creator:    yejian
/// CreateDate: 2020-2-4
/// Input:      aNums 迁移最大数 
/// Output:     插入的数量
/// Debug       w ##Class(EMRservice.BL.BLExportTool).FailureMoveToQueues("10")
ClassMethod FailureMoveToQueues(aNums As %String = "10", AType As %String = "IMAGE") As %String
{

	s resCount = 0	
	s blnMark = 0
    q:(AType = "") resCount
	s date = ""
	for
	{
		s date =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date))
		q:(date = "")
		q:(blnMark=1)
		s time = ""
		for
		{
			s time =  $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, time))
			q:(time = "")
			q:(blnMark=1)
			s rowID = ""
			for
			{
				s rowID = $o(^DHCEMRI.Export.FailureI("IdxHappenDateTime", date, time, rowID))
				q:(rowID = "")
				q:(blnMark=1)
				//continue:(rowID<aRowIDS)
				
			    s insertQueue = ..FailureMoveToQueue(rowID,AType)
			    if (insertQueue>0)
			    {        
	             	s resCount=resCount+1
			    }
			    if (resCount>=aNums)
				{
					s blnMark = 1
					q
				}
				
			}
		}
	} 
	
	q "迁移总数:"_resCount_",最后一条迁移记录的rowid："_rowID
}

/// 失败队列移动到执行队列
/// w ##Class(EMRservice.BL.BLExportQueue).FailureMoveToExe("260")
ClassMethod FailureMoveToQueue(ID As %String, OutType As %String) As %String
{
	
	q:(ID="") 0
	s obj = ##Class(EMRinstance.Export.Failure).%OpenId(ID)	
	q:(obj="") 0	
	s status = 0
	
	s sID = $o(^DHCEMRI.Export.QueueI("IdxQueue", " "_obj.PatientID, " "_obj.EpisodeID," "_obj.InstanceID,""),-1)
	if (sID="")
	{
	s objQueue = ##Class(EMRinstance.Export.Queue).%New()
	s objQueue.ChartItemType =obj.ChartItemType
	s objQueue.ClientIP =obj.ClientIP
	s objQueue.EndPage =obj.EndPage
	s objQueue.EpisodeID =obj.EpisodeID
	s objQueue.HappenDate =obj.HappenDate
	s objQueue.HappenTime =obj.HappenTime
	s objQueue.InstanceID =obj.InstanceID
	s objQueue.PageCount =obj.PageCount
	s objQueue.PatientID =obj.PatientID
	s objQueue.PluginType =obj.PluginType
	s objQueue.Priority =obj.Priority
	s objQueue.StartPage =obj.StartPage
	s objQueue.TaskDate =obj.TaskDate
	s objQueue.TaskIP =obj.TaskIP
	s objQueue.TaskRemark =obj.TaskRemark
	s objQueue.TaskTime =obj.TaskTime
	s objQueue.Type =obj.Type	
	s objQueue.FileType =obj.FileType
	s status = objQueue.%Save()
	}
	q status
}

ClassMethod GetInstanceID(aCreateDate As %String, aCreateTime As %String, aEpisodeID As %String)
{
	s InstanceID=""
	&SQL(Select ID into :InstanceID From EMRinstance.InstanceData Where CreateDate=:aCreateDate and CreateTime=:aCreateTime and EpisodeID=:aEpisodeID)
	q InstanceID
}

}
