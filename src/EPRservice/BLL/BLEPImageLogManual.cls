Class EPRservice.BLL.BLEPImageLogManual Extends %RegisteredObject
{

/// Desc:	创建病历图片生成服务日志
/// Input:	AEEPImageLog 病历图片生成服务日志实体类
/// Output:	
/// Return:	创建的病历图片生成服务日志ID,若创建失败则返回空
ClassMethod CreateEPImageLog(AEEPImageLog As EPRservice.entity.EEPImageLog) As %String
{
	s objEPImageLog = ##Class(EPRinstance.EPImageLogManual).%New()
	s objEPImageLog.PatientID = AEEPImageLog.PatientID
	s objEPImageLog.EpisodeID = AEEPImageLog.EpisodeID
	s objEPImageLog.EPRLogsID = AEEPImageLog.EPRLogsID
	s objEPImageLog.PrintType = AEEPImageLog.PrintType
	s objEPImageLog.PrintTemplateID = AEEPImageLog.PrintTemplateID
	s objEPImageLog.PrintDocID = AEEPImageLog.PrintDocID
	s objEPImageLog.InstanceDataID = AEEPImageLog.InstanceDataID
	s objEPImageLog.UserID = AEEPImageLog.UserID
	s objEPImageLog.ClientIP = AEEPImageLog.ClientIP
	s objEPImageLog.CreateDate = $p($h,",",1)
	s objEPImageLog.CreateTime = $p($h,",",2)
	s objEPImageLog.UpdateDate = objEPImageLog.CreateDate
	s objEPImageLog.UpdateTime = objEPImageLog.CreateTime
	s objEPImageLog.ResultFlag = "0"
	s objEPImageLog.HospitalID = ..GetHospitalID(AEEPImageLog.EpisodeID)
	
	s sc = objEPImageLog.%Save()
	if ($$$ISOK(sc))
	{
		q objEPImageLog.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:	删除病历图片生成日志
/// Input:	AEpisodeID : 就诊rowid
/// 		AEPRLogsID : EPRinstance.EPRLogs的rowid
/// 		ClientIP   : 客户端ip地址
/// Output：
/// Return：1 : 删除成功，0 : 指定病历图片日志不存在，-1 : 删除失败
ClassMethod DeleteByID(AEPImageManualID As %String) As %String
{
		s sc = ##Class(EPRinstance.EPImageLogManual).%DeleteId(AEPImageManualID)
		if ($$$ISOK(sc))
		{
			q "1"
		}
		else
		{
			q "-1"
		}
}

/// Debug:	d ##Class(EPRservice.BLL.BLEPImageLogManual).MoveToSys("1")
ClassMethod MoveToSys(AEPImageManualID As %String) As %String
{
	s obj = ##Class(EPRinstance.EPImageLogManual).%OpenId(AEPImageManualID)
	q:(obj = "") "0"
	
	s id = ##Class(EPRservice.BLL.BLEPImageLog).RegEPImageLog(obj.EPRLogsID,obj.PrintType,obj.UserID,obj.ClientIP)
	
	d ..DeleteByID(AEPImageManualID)
}

/// Debug:	w ##Class(EPRservice.BLL.BLEPImageLogManual).AddManualTaskByDate2("2015-09-16")
ClassMethod AddManualTaskByDate2(ACreateDate As %String) As %Integer
{
	s date = $zdh(ACreateDate,3)
	s ret = ..AddManualTaskByDate(date)
	q ret
}

ClassMethod AddManualTaskByDate(ACreateDate As %String) As %Integer
{
	s count = 0
	
	q:(ACreateDate="")||(ACreateDate= $c(0)) count
		
	s blankDate = " "_ACreateDate
	
	s time = ""
	for {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
		s time = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,time))
		q:(time="")
		
		s admID = ""
		for {
			s admID = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,time,admID))
			q:(admID="")
			
			s eprDocId=""
			for {
				s eprDocId = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,time,eprDocId))
				q:(eprDocId="")
			
				s eprNum = ""
				for {
					s eprNum = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,time,eprDocId,eprNum))
					q:(eprNum = "")
				
					s rowid = ""
					for {
						s rowid = $O(^DHCEPRI.EPRLogsI("IdxCreateDateTime",blankDate,time,eprDocId,eprNum,rowid))
						q:(rowid = "")
				
						//b "s"
						s obj = ##Class(EPRinstance.EPRLogs).%OpenId(rowid)
						continue:(obj = "")
						continue:(obj.EPRNum < 1)
						
						//已存在，不需要重复添加
						s isExisted = ..HasLogExisted(obj.EpisodeID, rowid)
						continue:(isExisted = "1")
				
						s printInfoList = ..GetPrintInfo(obj.EpisodeID, obj.EPRDocID, obj.EPRNum)	
						continue:(printInfoList = "")
				
						s printTemplateID = $lg(printInfoList,1)
						s printType = $lg(printInfoList,2)
						s instanceDataID = $lg(printInfoList,3)
				
						s patientID = ##Class(EPRservice.HISInterface.PatientInfoAssist).GetPapmiDR(obj.EpisodeID)
						
						s e = ##class(EPRservice.entity.EEPImageLog).%New()
						s e.EpisodeID = obj.EpisodeID
						s e.EPRLogsID = rowid
						s e.ClientIP = "127.0.0.1"
						s e.PatientID = patientID
						s e.PrintDocID = obj.EPRDocID
						s e.UserID = obj.CreateUserID
						s e.PrintTemplateID = printTemplateID
						s e.PrintType = printType
						s e.InstanceDataID = instanceDataID
				
						do ..CreateEPImageLog(e)
						
						s count = count + 1
					}
				}
			}
		}
	}
	
	q count
}

ClassMethod HasLogExisted(AEpisodeID As %String, AEPRLogsID As %String) As %String
{
	s isExisted = "0"
	
	s ip = ""
	for {
		s ip = $O(^DHCEPRI.EPImageLogManualI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip))
		q:(ip="")
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRI.EPImageLogManualI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip,rowID))
			q:(rowID="")
			
			s obj = ##Class(EPRinstance.EPImageLog).%OpenId(rowID)
			continue:(obj = "")
			
			s isExisted = "1"
			q
		}
		
		q:(isExisted="1")
	}
	
	q isExisted
}

ClassMethod GetPrintInfo(AEpisodeID As %String, APrintTemplateDocID As %String, AEPRNum As %String) As %List
{
	//b "s"
	s objEPRTemplateCategory = ##Class(EPRmeta.EPRTemplateCategory).%OpenId(APrintTemplateDocID)
	q:(objEPRTemplateCategory = "") ""
	
	s printTemplateID = objEPRTemplateCategory.BindPrnTemplateID
	q:(printTemplateID = "") ""
	
	s objPrintTemplate = ##Class(EPRmeta.PrintTemplate).%OpenId(printTemplateID)
	q:(objPrintTemplate = "") ""
	s printType = objPrintTemplate.ChartItemType

	s instanceDataIDs = ""	
	if (printType = "Multiple")
	{
		s instanceDataIDs = ..GetInstanceData(AEpisodeID, APrintTemplateDocID, AEPRNum) 
	}
	
	q $listbuild(printTemplateID,printType,instanceDataIDs)
}

ClassMethod GetInstanceData(AEpisodeID As %String, APrintTemplateDocID As %String, AEPRNum As %String) As %String
{
	s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID", " "_AEpisodeID, " ML"_APrintTemplateDocID, ""))
	q:(ecRecordID = "") ""
		
	s childSub = $o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo", ecRecordID, " "_AEPRNum, ""))
	q:(childSub = "") ""
	
	q ecRecordID_"||"_childSub
}

ClassMethod GetHospitalID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") ""
	
	s deptDR = $P($g(^PAADM(AEpisodeID)),"^",4)
	q:(deptDR = "") ""
	
	s hosptialDR = $p($g(^CTLOC(deptDR)),"^",22)
	q hosptialDR
}

}
