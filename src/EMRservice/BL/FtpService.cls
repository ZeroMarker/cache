/// 名称:	EMRservice.BL.FtpService
/// 描述:	FTP服务
/// 编写者：yejian
/// 编写日期: 2021-12-11
Class EMRservice.BL.FtpService Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       上传FTP数据
/// Creator:    yejian
/// Createdate: 2021-12-11
/// Input:      aInstanceID 实例ID
///             argInData 文件流
/// Output:     成功：成功队列ID，失败:0或""
/// debug q ##class(EMRservice.BL.FtpService).FTPStoreData()
ClassMethod FTPStoreData(aInstanceID As %String, argInData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	s strRes = ""
	q:(aInstanceID="") strRes
	s objInstance = ##class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objInstance="") strRes
	s strPatientID = objInstance.TheECRecord.PatientID
	s strEpisodeID = objInstance.EpisodeID
	d objInstance.%Close()
	k objInstance
	s ftpUpload = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("HTMLUploadFtp","Y")
	if (ftpUpload="N")
	{
		//调用服务总线接口通过返回值判断迁移到成功，还是失败队列中
		goto MoveExeData
		q strRes
	} 
	//获取FTP相关配置
	s eftp = ##class(EMRservice.BL.FtpService).GetFtpData(aInstanceID,strPatientID,strEpisodeID)
	if (eftp="")||(eftp.StoreFileName="")
	{
		goto MoveExeData
		q strRes
	} 
	
	s ftpService=##class(%Net.FtpSession).%New()
	if 'ftpService.Connect(eftp.Server ,eftp.Username,eftp.Password,eftp.Port)
	{
		s ftpService.UsePASV = 1  //如果项目ftp服务器要求必须使用PASV模式
		goto MoveExeData
		q strRes
		 
	}
	s strDir = eftp.FileDirectory
	;create dir and goto dir
	if (strDir'="")&&'ftpService.SetDirectory(strDir)
	{
		s strDir = $REPLACE(strDir,"//","/")
		if strDir["/" s DirLen = $l(strDir,"/"),sep="/"
		if strDir["\" s DirLen = $l(strDir,"\"),sep="\"
		for i=1:1:DirLen 
		{
			s CurrentDir = $p(strDir,sep,i)
			if $l(CurrentDir)>0 
			{
				if 'ftpService.SetDirectory(CurrentDir)
				{
					s MakeDir = ftpService.MakeDirectory(CurrentDir)
					s cdFlag = ftpService.SetDirectory(CurrentDir)
				}
			}
		}
	}
	//q:('strMake) strRes
	s strRes =ftpService.Store(eftp.StoreFileName,argInData)
	goto MoveExeData
	q strRes
MoveExeData
	s strExeID = $o(^DHCEMRI.Export.ExeI("IdxTyQueue"," HTML"," "_strPatientID," "_strEpisodeID," "_aInstanceID,""))
	//上传成功
	if (strRes)
	{
		if (strExeID>0) 
		{
			s strRes = ##class(EMRservice.BOExportQueue).ExeMoveToSucced(strExeID,"HTML")
		}
		else
		{
			s strRes =  ##Class(EMRservice.BL.FtpService).SetQueueData(aInstanceID)
		}
		//上传后，数据发送给服务总线
		s objHtml = ##class(EMRservice.BL.BLHtmlMedicalRecords).GetHtmlData(aInstanceID,argInData)
		s strEnsRes = ##class(web.DHCENS.EnsHISService).SendEMRMessageInfo("MES0516",objHtml)
	}
	else
	{
		s:(strExeID>0) strRes = ##class(EMRservice.BOExportQueue).ExeMoveToFailure(strExeID,"HTML")	
	}
	q strRes
Error
	q "0"
}

/// Desc:       获取FTP数据
/// Creator:    yejian
/// Createdate: 2021-12-11
/// Input:      
/// Output:    成功：1，失败:0或""
/// debug: w ##class(EMRservice.BL.FtpService).FTPRetrieveData("/emrhtml/vol1/61/67/283/5/1.html")
ClassMethod FTPRetrieveData(aFileName As %String) As %Stream
{
	s $zt = "Error"
	s objRes = ##class(%GlobalBinaryStream).%New()
	q:(aFileName="") objRes
	//获取FTP相关配置
	s aInstanceID="",strPatientID="",strEpisodeID=""
	s eftp = ##class(EMRservice.BL.FtpService).GetFtpData(aInstanceID,strPatientID,strEpisodeID)
	q:(eftp="") objRes
	s ftpService=##class(%Net.FtpSession).%New()
	if 'ftpService.Connect(eftp.Server ,eftp.Username,eftp.Password,eftp.Port)
	{
		s ftpService.UsePASV = 1  //如果项目ftp服务器要求必须使用PASV模式
		q objRes
	}
	s readStream = ##class(%GlobalBinaryStream).%New()
	if ftpService.Retrieve(aFileName, .readStream)
	{
		//输出64位图片编码
		while (readStream.AtEnd = 0)
		{
			s strData = $System.Encryption.Base64Encode(readStream.Read(25000))
			//w strData
			d objRes.Write(strData)
		}
	}
	q objRes
Error
	q objRes
}

/// Desc:       类似病程记录连续显示的病历，只要队列中有一条即可
/// Modify:     yejian
/// ModifyDate: 2018-12-14
/// Input:      APatientID 患者ID
/// Output:     成功：1，失败:0          
/// Debug:      w ##Class(EMRservice.BL.FtpService).SetQueueData("24||109")
ClassMethod SetQueueData(aInstanceID As %String, AOutType As %String = "HTML") As %String
{
	s strRes = "0"
	q:(aInstanceID="") strRes
	s obj = ##class(EMRservice.entity.EQueue).%New()
	s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(aInstanceID)
	q:(objInstance = "") strRes
	s obj.PatientID = objInstance.TheECRecord.PatientID
	s obj.EpisodeID = objInstance.EpisodeID
	s obj.InstanceID = aInstanceID
	s obj.PluginType = objInstance.TheECRecord.DocumentType
	s obj.ChartItemType = objInstance.TheECRecord.ChartItemType
	s obj.ClientIP = "127.0.0.1"
	s obj.Type = AOutType
	s obj.StartPage= 1
	s obj.EndPage = 1
	s obj.PageCount = 1
	s obj.HappenDate = $p($h,",",1)
	s obj.HappenTime = $p($h,",",2)
	s obj.FileType = "html"
	s obj.AdmType = $p($g(^PAADM(obj.EpisodeID)),"^",2)
	d objInstance.%Close()
	k objInstance
	s strId = ##Class(EMRservice.BL.BLExportQueue).CheckInstanceIDIsExit(obj.PatientID,obj.EpisodeID ,obj.InstanceID,"Succed",obj.Type)
	if (strId>0)
	{
		s strRes = ##class(EMRservice.BL.BLExportQueue).UpdateSucced(strId,obj)
	}
	else
	{
		s strRes = ##class(EMRservice.BL.BLExportQueue).InsertSucced(obj)
	}
	q strRes
}

/// Desc:       获取FTP配置数据
/// Creator:    yejian
/// Createdate: 2021-12-11
/// Input:      aInstanceID 实例ID
///             aPatientId 住院号
/// 				aEpisodeID 就诊号
/// Output:     EMRservice.entity.EFtpData
/// debug: s obj = ##class(EMRservice.BL.FtpService).GetFtpData("1||1",1,1)
/// 			w obj.StoreFileName
ClassMethod GetFtpData(aInstanceID As %String, aPatientId As %String, aEpisodeID As %String) As EMRservice.entity.EFtpData
{
	s objRes=##class(EMRservice.entity.EFtpData).%New()
	s FtpParams = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("FTP_CONNECT_CDAXML","") 
	s key = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DECRYPTKEY")
	q:(FtpParams="") objRes
	s Count=$l(FtpParams,",")
	for i=1:1:Count	
	{
		s Param=$P(FtpParams,",",i)
		s splitParamName=$P(Param,":",1)
		s ParamName=$P(splitParamName,"'",2)
		s splitParamValue=$P(Param,":",2)
		s ParamValue=$P(splitParamValue,"'",2)
		s:(ParamName="server") objRes.Server = ParamValue
		s:(ParamName="port") objRes.Port = ParamValue
		if (ParamName="username") 
		{
			s ParamValue = ##Class(web.Util.Encryption).SimpleDecrypt(ParamValue,"lacideMi"_key)
			s objRes.Username = ParamValue
		}
		if (ParamName="password") 
		{
			s ParamValue = ##Class(web.Util.Encryption).SimpleDecrypt(ParamValue,"lacideMi"_key)
			s objRes.Password = ParamValue
		}
	}
	q:(aInstanceID="")||(aPatientId="")||(aEpisodeID="") objRes
	s FileType=".html"
	s InstanceID = $REPLACE(aInstanceID,"||","/")
	s InstanceID = $REPLACE(InstanceID,"//","/")			
	s volNo=aPatientId\10000+1	
	s fileDirectory ="/emrhtml/vol"_volNo_"/"_aPatientId_"/"_aEpisodeID_"/"_InstanceID_"/"
	s fileLocation=fileDirectory_1_FileType
	s objRes.FileDirectory = fileDirectory
	s objRes.StoreFileName = fileLocation
	q objRes
}

}
