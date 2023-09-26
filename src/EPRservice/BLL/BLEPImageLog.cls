Class EPRservice.BLL.BLEPImageLog Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	创建病历图片生成服务日志
/// Input:	AEEPImageLog 病历图片生成服务日志实体类
/// Output:	
/// Return:	创建的病历图片生成服务日志ID,若创建失败则返回空
ClassMethod CreateEPImageLog(AEEPImageLog As EPRservice.entity.EEPImageLog) As %String
{
	s objEPImageLog = ##Class(EPRinstance.EPImageLog).%New()
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
ClassMethod DeleteEPImageLog(AEpisodeID As %String, AEPRLogsID As %String, ClientIP As %String) As %String
{
	s rowID = ..GetEPImageLogIDWithouIP(AEpisodeID, AEPRLogsID)
	q:(rowID="") ""
	
	s rowID2 = ..GetEPImageLogID(AEpisodeID, AEPRLogsID, ClientIP)
	if (rowID2 '= "")
	{
		s rowID = rowID2
	}
	
	if (rowID = "")
	{
		q ""
	}
	else
	{
		s sc = ##Class(EPRinstance.EPImageLog).%DeleteId(rowID)
		if ($$$ISOK(sc))
		{
			q "1"
		}
		else
		{
			q "-1"
		}
	}
}

/// Desc:	获取指定病历图片生成日志ID
/// Input:	AEpisodeID : 就诊rowid
/// 		AEPRLogsID : EPRinstance.EPRLogs的rowid
/// 		ClientIP   : 客户端ip地址
/// Output：
/// Return：病历图片生成日志ID
ClassMethod GetEPImageLogID(AEpisodeID As %String, AEPRLogsID As %String, ClientIP As %String) As %String
{
	s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID," "_ClientIP,""))
	q rowID
}

/// Desc:	指定病历预览服务日志是否存在
/// Input:	AEpisodeID : 就诊指针，APrintDocID : 打印模板DocID
/// Return: 1 : 存在，0 : 不存在
/// Debug:	w ##Class(EPRservice.BLL.BLEPImageLog).IsEPImageLogExisted("201764","24")
ClassMethod IsEPImageLogExisted(AEpisodeID As %String, APrintDocID As %String) As %Boolean
{
	q:(AEpisodeID="")||(APrintDocID="") "0"
	
	s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndDocID"," "_AEpisodeID," "_APrintDocID,""))
	if (rowID = "")
	{
		q "0"
	}
	else
	{
		q "1"
	}
}

/// Desc:	指定病历预览服务日志是否存在
/// Input:	AEpisodeID : 就诊指针，APrintDocIDList : 打印模板DocID列表
/// Return: 1 : 存在，0 : 不存在
/// Debug:	w ##Class(EPRservice.BLL.BLEPImageLog).IsEPImageLogListExisted("201764","24^26")
ClassMethod IsEPImageLogListExisted(AEpisodeID As %String, APrintDocIDList As %String) As %Boolean
{
	s isExisted = "0"
	
	q:(AEpisodeID="")||(APrintDocIDList="") isExisted
	
	s count = $L(APrintDocIDList, "^")
	for i = 1:1:count
	{
		s printDocID = $p(APrintDocIDList, "^", i)
		s isExisted = ..IsEPImageLogExisted(AEpisodeID, printDocID)
		q:(isExisted="1")
	}
	
	q isExisted
}

/// Desc:	获取指定病历图片生成日志ID
/// Input:	AEpisodeID : 就诊rowid
/// 		AEPRLogsID : EPRinstance.EPRLogs的rowid
/// 		ClientIP   : 客户端ip地址
/// Output：
/// Return：病历图片生成日志ID
ClassMethod GetEPImageLogIDWithouIP(AEpisodeID As %String, AEPRLogsID As %String) As %String
{
	s ip = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,""))
	q:(ip="") ""
	s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip,""))
	q rowID
}

ClassMethod HasNewLogExisted(AEpisodeID As %String, AEPRLogsID As %String) As %String
{
	s isExisted = "0"
	
	s ip = ""
	for {
		s ip = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip))
		q:(ip="")
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip,rowID))
			q:(rowID="")
			
			s obj = ##Class(EPRinstance.EPImageLog).%OpenId(rowID)
			if (obj.ResultFlag = "0")
			{
				s isExisted = "1"
				q
			}
		}
		
		q:(isExisted="1")
	}
	
	q isExisted
}

/// Desc:	检查生成图片预览日志, 
/// 			被 EPRinstance.EPRLogs的 InitAfterSigleOper 和 InitAfterMultiOper 引用，临时优化病历图片生成功能
/// Debug:	w ##Class(EPRservice.BLL.BLEPImageLog).RegEPImageLog("7","Single","5972","127.0.0.1")
/// 		w ##Class(EPRservice.BLL.BLEPImageLog).RegEPImageLog("9","Multiple","5972","127.0.0.1")
ClassMethod RegEPImageLog(AEPRLogsID As %String, APrintType As %String, AUserID As %String, AClientIP As %String)
{
	s objEPRLogs = ##Class(EPRinstance.EPRLogs).%OpenId(AEPRLogsID)
	q:(objEPRLogs = "") "0"
	
	s AEpisodeID = objEPRLogs.EpisodeID
	s AEPRDocID = objEPRLogs.EPRDocID
	s AEPRNum = objEPRLogs.EPRNum
	s AEPRStatus = objEPRLogs.EPRStatus
	
	q:(AEPRNum < 1) "1"
	
	//检查图片状态，如果删除了图片，则需要把所有待生成日志都删除
	s imageStatus = ##Class(EPRservice.BOEPImage).RegEPImageByStatus(AEpisodeID,AEPRLogsID,AEPRStatus)
	if (imageStatus = "0")
	{
		do ..DeleteByEPRLogsID(AEpisodeID, AEPRLogsID)
		quit "1"
	}
	
	//未绑定打印模板，不需要生成日志
	//s printType =  ##class(EPRservice.BOEPRTemplateCategory).GetBindPrtTemplateType(AEPRDocID)
	//q:(printType = "") "1"
	s objEPRTemplateCategory = ##class(EPRmeta.EPRTemplateCategory).%OpenId(AEPRDocID)
	q:(objEPRTemplateCategory="") ""
	s bindPrtTemplateId = objEPRTemplateCategory.BindPrnTemplateID
	q:(bindPrtTemplateId="") ""	
	
	//存在未生成的日志，不需要再插入日志
	s hasExisted = ..HasNewLogExisted(AEpisodeID, AEPRLogsID)
	q:(hasExisted = "1") "1"
	
	
	//获取InstanceDataID
	if (APrintType = "Single")
	{
		s instanceID = ""
	}
	else
	{
		s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID, " ML"_AEPRDocID,""))
		q:(ecRecordID="") "0"
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
		q:(childSub="") "0"
		s instanceID = ecRecordID_"||"_childSub
	}
	
	
	s patientID = $P($g(^PAADM(AEpisodeID)),"^",1)
	
	s entity = ##Class(EPRservice.entity.EEPImageLog).%New()
	s entity.PatientID = patientID
	s entity.EpisodeID = AEpisodeID
	s entity.EPRLogsID = AEPRLogsID
	s entity.PrintType = APrintType
	s entity.PrintTemplateID = bindPrtTemplateId
	s entity.PrintDocID = AEPRDocID
	s entity.InstanceDataID = instanceID
	s entity.UserID = AUserID
	s entity.ClientIP = AClientIP
	do ..CreateEPImageLog(entity)
	
	q "1"
}

/// Desc:	删除指定EPRLogsID的所有日志
ClassMethod DeleteByEPRLogsID(AEpisodeID, AEPRLogsID)
{
	s ip = ""
	for {
		s ip = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID,ip))
		q:(ip = "")
		
		s rowID = ""
		for {
			s rowID = $O(^DHCEPRI.EPImageLogI("IdxEpisodeIDAndLogsID"," "_AEpisodeID," "_AEPRLogsID, ip,""))
			q:(rowID = "")
			
			s sc = ##Class(EPRinstance.EPImageLog).%DeleteId(rowID)
		}
	}
}

ClassMethod GetHospitalID(AEpisodeID As %String) As %String
{
	q:(AEpisodeID = "") ""
	
	s deptDR = $P($g(^PAADM(AEpisodeID)),"^",4)
	q:(deptDR = "") ""
	
	s hosptialDR = $p($g(^CTLOC(deptDR)),"^",22)
	q hosptialDR
}

/// Debug:	d ##Class(EPRservice.BLL.BLEPImageLog).InitUpdateDateTime()
ClassMethod InitUpdateDateTime()
{
	s id = ""
	for {
		s id = $O(^DHCEPRI.EPImageLogD(id))
		q:(id="")
		
		s obj = ##Class(EPRinstance.EPImageLog).%OpenId(id)
		continue:(obj = "")
		
		if (obj.UpdateDate = "")||(obj.UpdateDate = $c(0))
		{
			s obj.UpdateDate = obj.CreateDate
			s obj.UpdateTime = obj.CreateTime
			s obj.HospitalID = ..GetHospitalID(obj.EpisodeID)
			d obj.%Save()
			
			w !,id_" 已更新!"
		}
		else
		{
			w !, id_" 不需更新!"
		}
	}
}

}
