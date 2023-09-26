Class EPRservice.BOEPImageLog Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPImageLogInfo";

ClassMethod CreateEPImageLog(AEEPImageLog As EPRservice.entity.EEPImageLog) As %String [ WebMethod ]
{
	s id = ##Class(EPRservice.BLL.BLEPImageLog).CreateEPImageLog(AEEPImageLog)
	q id
}

ClassMethod DeleteEPImageLog(AEpisodeID As %String, AEPRLogsID As %String, ClientIP As %String) As %String [ WebMethod ]
{
	s status = ##Class(EPRservice.BLL.BLEPImageLog).DeleteEPImageLog(AEpisodeID, AEPRLogsID, ClientIP)
	q status
}

/// Return:	0 病历图片生成功能关闭
/// 			1 病历图片生成功能关闭，但由于删除了病历，要同步删除病历图片
/// 			2 需要生成图片，但服务器已有待生成队列，不需要再插入新的生成队列
/// 			3 需要生成图片，且在服务器插入了一个新的待生成队列，该生成队列由集中的生成客户端处理
/// 			4 需要生成图片，且在服务器插入了一个新的待生成队列，该生成队列需要写病历的客户端参与处理增加处理速度
ClassMethod RegEPImage(AEEPImageLog As EPRservice.entity.EEPImageLog) As %String [ WebMethod ]
{
	s savePrintImage = ##class(EPRmeta.SysOption).GetOptionValueByName("SavePrintImage")
	if ($zcvt(savePrintImage,"u") = "NULL")
	{
		q "0" 
	}
	
	s episodeID = AEEPImageLog.EpisodeID
	s eprLogsID = AEEPImageLog.EPRLogsID
	s clientIP = AEEPImageLog.ClientIP
	s imageStatus = ##Class(EPRservice.BOEPImage).GetEPRImageCheckStatus(episodeID,eprLogsID)
	if (imageStatus = "0")
	{
		s sc = ##class(EPRservice.BOEPImage).DeleteEPImage(episodeID,eprLogsID)
		s sc = ##Class(EPRservice.BLL.BLEPImageLog).DeleteEPImageLog(episodeID, eprLogsID, clientIP)
		if $$$ISOK(sc)
		{
			q "1"	//删除病历图片
		}
		else
		{
			q "-1" 
		}
	}
	
	
	
	s isExisted = ##Class(EPRservice.BLL.BLEPImageLog).HasNewLogExisted(episodeID,eprLogsID)
	q:(isExisted="1") "2"
	
	s id = ..CreateEPImageLog(AEEPImageLog)
	
	s type = ##class(EPRmeta.SysOption).GetOptionValueByName("SavePrintImageType")
	if ($f(type,"client") > 1)
	{
		q "4"
	}
	else
	{
		q "3"
	}
}

/// w ##class(EPRservice.BOEPImageLog).TestReg()
ClassMethod TestReg() As %String
{
	s e = ##class(EPRservice.entity.EEPImageLog).%New()
	s e.EpisodeID = "15"
	s e.EPRLogsID = "1"
	s e.ClientIP = "127.0.0.1"
	s e.PatientID = "13"
	s e.InstanceDataID = ""
	s e.PrintDocID = "38"
	s e.PrintTemplateID = "134"
	s e.PrintType = "Single"
	s e.UserID = "105"
	
	s ret = ..RegEPImage(e)
	q ret
}

}
