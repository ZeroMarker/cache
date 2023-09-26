Class DHCEPRFS.web.eprajax.AjaxThirdParty Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
    s episodeID = $Get(%request.Data("EpisodeID",1),"")
    s action =  $Get(%request.Data("Action",1),"")
	
	//s ^CacheTemp("dhceprfs-debug-1") = episodeID
	//s ^CacheTemp("dhceprfs-debug-2") = action
	if (action = "geturl")
	{
		w ..GetURL(episodeID)
	}
	elseif (action = "checkexist")
	{
		w ..CheckExist(episodeID)	
	}
	Quit $$$OK
}

/// 检查联众lis是否存在
/// debug: w ##class(DHCEPRFS.web.eprajax.AjaxThirdParty).CheckExist(17937487)
ClassMethod CheckExist(AEpisodeID As %String) As %String
{
	q:((AEpisodeID = "") || (AEpisodeID = $c(0)))
	
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID) 
	s MedRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(PatientID)
	s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(PatientID)
	
	if ((MedRecordNo = "") || (MedRecordNo = $c(0)))
	{
		//新生儿没有病案号，也没有化验单，因此跳过
		q "0"
	}
	
	s AdmDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(AEpisodeID) 
	s DisDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID) 
		
	s StartDateTime = $zd($p(AdmDate,",",1),3)_" "_$zt($p(AdmDate,",",2),1)
	s EndDateTime = $zd($p(DisDate,",",1),3)_" "_$zt($p(DisDate,",",2),1)
	
	s service = ##class(DHCEPRFS.ThirdParty.WebService.LianZ.XieHeLianZWebServicePort).%New()
	s ret = service.WSREPORTNUM("2","1","0",StartDateTime,EndDateTime,RegNo)
	
	//没有lis是0，有lis是个正数
	q ret
}

/// 病案相关动作调用ajax方法插入队列
/// debug: w ##class(DHCEPRFS.web.eprajax.AjaxThirdParty).GetURL(17443235)
ClassMethod GetURL(AEpisodeID As %String) As %String
{
	q:((AEpisodeID = "") || (AEpisodeID = $c(0)))
	
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetPatientID(AEpisodeID) 
	s MedRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(PatientID)
	s RegNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(PatientID)
	
	if ((MedRecordNo = "") || (MedRecordNo = $c(0)))
	{
		//新生儿没有病案号，也没有化验单，因此跳过
		q "0"
	}
	
	s ret = ..CheckExist(AEpisodeID)
	if (ret = "0")
	{
		//调用lis webservice返回0表示没有化验单，因此跳过
		q "0"
	}
	
	s AdmDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetAdmDateTime(AEpisodeID) 
	s DisDate = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DisDateTime(AEpisodeID) 
		
	s StartDateTime = $zd($p(AdmDate,",",1),3)_" "_$zt($p(AdmDate,",",2),1)
	s EndDateTime = $zd($p(DisDate,",",1),3)_" "_$zt($p(DisDate,",",2),1)
		
	//http://10.160.28.243:49615/batchPrint3.aspx?ShenQingLX=2&BingRenLX=2&DaYinLX=0&ShiFouDY=1&KaiShiSJ=2016-10-26 01:22:23&JieShuSJ=2016-10-27 12:22:23&BingRenId=2206550
	s URL = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("CG83URL")
	s URL = URL_"?ShenQingLX=2&BingRenLX=1&DaYinLX=0&ShiFouDY=1&KaiShiSJ="_StartDateTime_"&JieShuSJ="_EndDateTime_"&BingRenId="_RegNo
	q URL
}

}
