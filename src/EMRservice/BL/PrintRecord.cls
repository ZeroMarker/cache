Class EMRservice.BL.PrintRecord Extends %RegisteredObject
{

/// desc: 初始化数据 批量添加病历打印记录表 happenDate 和 happenTime
/// creator: duanlijun
/// ceratedate: 2018-12-22
/// Debug：d ##class(EMRservice.BL.PrintRecord).AddPrintHappenDateAndTime()
ClassMethod AddPrintHappenDateAndTime()
{
	s EpisodePrintRecordID = ""
	for
	{
		s EpisodePrintRecordID = $Order(^DHCEMRI.InstancePrintRecordI("IdxEpisodePrintRecordID"," ",EpisodePrintRecordID))
		quit:EpisodePrintRecordID=""
		s obj = ##class(EMRinstance.InstancePrintRecord).%OpenId(EpisodePrintRecordID)
		s InstanceDataID = 	obj.InstanceDataID
		s InstanceDataObj =  ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
		q:(InstanceDataObj = "")
		s EpisodeID = InstanceDataObj.RealEpisodeID
		s PADischgeDate=$P($g(^PAADM(EpisodeID)),"^",17)
		if (PADischgeDate '= "") s PAStatus = "out"
		s PAStatus = "in"
		if (PAStatus = "out") continue
		s happenDate = 	InstanceDataObj.HappenDate
		s happenTime =  InstanceDataObj.HappenTime
		s obj.HappenDate = happenDate
		s obj.HappenTime = happenTime
		d obj.%Save()
	    d obj.%Close()
	    k obj
	}
}

/// desc: 获取下一个未打印的实例ID
/// input: AinstanceId 实例ID
/// creator: duanlijun
/// ceratedate: 2018-12-22
/// return: "0" 没有可打印的ID  "370||10" 实例ID 从该ID开始打印  
/// Debug：d ##class(EMRservice.BL.PrintRecord).GetInstanceNextId("370||1")
ClassMethod GetInstanceNextId(AinstanceId)
{
	s instanceIdNext = 0
	s AECRecordID = $P(AinstanceId,"||",1)
	s isECRecordIDSeq = 0
	s isECRecordIDSeq = $Order(^DHCEMRI.InstancePrintRecordI("IdxECRecordIDAndSeq"," "_AECRecordID,isECRecordIDSeq))
	if (isECRecordIDSeq = "")
	{
		//病历没有打印过
		s instanceHdate = 0
		s instanceHdate = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate))
		q:instanceHdate="" instanceIdNext
		s instanceHtime = 0
		s instanceHtime = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime))
		q:instanceHtime="" instanceIdNext
		s instanceID = 0
		s instanceID = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime,instanceID))
		q:instanceID="" instanceIdNext
		s instanceIdNext = AECRecordID_"||"_instanceID
	}
	else
	{
		s objEcrecord = ##class(EMRinstance.ECRecord).%OpenId(AECRecordID)
		q:(objEcrecord.DocumentCharacteristic '= 1) "0"
		s EpisodePrintRecordID = ""
		s EpisodePrintRecordID = $Order(^DHCEMRI.InstancePrintRecordI("IdxEpisodePrintRecordID"," ",EpisodePrintRecordID))
		q:EpisodePrintRecordID="" instanceIdNext
		s obj = ##class(EMRinstance.InstancePrintRecord).%OpenId(EpisodePrintRecordID)
		s InstanceDataID = 	obj.InstanceDataID
		s InstanceDataObj =  ##Class(EMRinstance.InstanceData).%OpenId(InstanceDataID)
		q:(InstanceDataObj = "") instanceIdNext
		s resultHdate = 0
		//判断当前病历在打印表中是否有(发生时间)的索引
		s isHave =$Order(^DHCEMRI.InstancePrintRecordI("IdxHappenDateTime"," "_AECRecordID,""))
		q:isHave="" instanceIdNext
		//取出打印表中的最新的一条数据
		s resultHdateMax = ""
		for
		{
			s resultHdate = $Order(^DHCEMRI.InstancePrintRecordI("IdxHappenDateTime"," "_AECRecordID,resultHdate))
			q:resultHdate=""
			s resultHdateMax = resultHdate
		}
		
		s resultHtime = 0
		s resultHtimeMax = ""
		for
		{
			s resultHtime = $Order(^DHCEMRI.InstancePrintRecordI("IdxHappenDateTime"," "_AECRecordID,resultHdateMax,resultHtime))
			q:resultHtime=""
			s resultHtimeMax = resultHtime
		}
		s instanceHdate = resultHdateMax
		s instanceHtime = resultHtimeMax
		//通过取发生时间 判断发生在当天  还是不同天数
		s instanceHtime = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime))
		if (instanceHtime="")
		{
			s instanceHdate= $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate))
			q:instanceHdate="" instanceIdNext
			s instanceHtime = 0
			s instanceHtime = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime))
			q:instanceHtime="" instanceIdNext
			s instanceID = 0
			s instanceID = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime,instanceID))
			q:instanceID="" instanceIdNext
			s instanceIdNext = AECRecordID_"||"_instanceID	
		}
		else
		{
			//取到时间 是同一天的行为
			s instanceID = 0
			s instanceID = $Order(^DHCEMRI.InstanceDataI("IdxHappenDateTime",AECRecordID," SAVE",instanceHdate,instanceHtime,instanceID))
			q:instanceID="" instanceIdNext
			s instanceIdNext = AECRecordID_"||"_instanceID						
		}
	}	
	q instanceIdNext
}

/// Createdate: 2015-5-15
/// Desc:       创建病历打印记录 
/// Input：	    pIntanceId:实例ID
/// 		    pStartPageNum:起始页
/// 		    pStartRowNum:起始行号
/// 		    pEndPageNum:结束页
/// 		    pEndRowNum:结束行号
/// Return：    result 0:失败  成功:rowID
/// Debug：     w ##class(EMRservice.BL.PrintRecord).CreatePrintRecord("24||2","1","1","1","45")
ClassMethod CreatePrintRecord(pIntanceId As %String, pStartPageNum As %String, pStartRowNum As %String, pEndPageNum As %String, pEndRowNum As %String, pTemplateID As %String = "", pTemplateVersion As %String = "") As %String
{
	s result = 0
	q:(pIntanceId = "") result
	s ecrecordId = $p(pIntanceId,"||",1)
	s objEcrecord = ##Class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objEcrecord = "") result
	s objInstanceData = ##Class(EMRinstance.InstanceData).%OpenId(pIntanceId)
	q:(objInstanceData = "") result
	s instancePrintRecord = ##class(EMRinstance.InstancePrintRecord).%New()
	//ContinuePrint,是否续打
	s instancePrintRecord.ContinuePrint = ""
	s instancePrintRecord.CreateDate = objInstanceData.CreateDate
	s instancePrintRecord.CreateTime = objInstanceData.CreateTime
	s instancePrintRecord.CreateUserID = objInstanceData.CreateUser
	s instancePrintRecord.ECRecordID = ecrecordId
	s instancePrintRecord.ECRSeq = objInstanceData.ListNo
	s instancePrintRecord.EndPageNum = pEndPageNum
	s instancePrintRecord.EndRowNum = pEndRowNum
	s instancePrintRecord.InstanceDataID = pIntanceId
	//LastRowProperty,末行属性
	s instancePrintRecord.LastRowProperty = ""
	s instancePrintRecord.PrintStatus = "Printed"
	s instancePrintRecord.PrintTemplateID = $Case(pTemplateID,"":objInstanceData.RealTemplateID,:pTemplateID)
    s instancePrintRecord.PrintTemplateVersion = $Case(pTemplateVersion,"":objInstanceData.TemplateVersion,:pTemplateVersion)
	s instancePrintRecord.PrintType = objEcrecord.CategoryType
	s instancePrintRecord.StartPageNum = pStartPageNum
	s instancePrintRecord.StartRowNum = pStartRowNum
	s instancePrintRecord.UpdateDate = objInstanceData.ModifyDate
	s instancePrintRecord.UpdateTime = objInstanceData.ModifyTime
	s instancePrintRecord.UpdateUserID = objInstanceData.ModifyUser
	s instancePrintRecord.HappenDate = objInstanceData.HappenDate
	s instancePrintRecord.HappenTime = objInstanceData.HappenTime
	s sc = instancePrintRecord.%Save()
	if ($$$ISOK(sc))
	{

		s result = instancePrintRecord.%Id()
	}
	q result
}

}
