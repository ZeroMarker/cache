Class web.eprajax.hisinterface.hospitalinfo Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"null")
	s frameType = $g(%request.Data("frameType",1),"")
	s HospID = $Get(%session.Data("LOGON.HOSPID"))
	q:(action = "null") $$$OK
	
	if (action = "getLocs")
	{
#;		s ShowShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","Y")
#;		s:(ShowShareHospital = "Y") HospID = ""
		d ..GetLocationList("E","","",frameType,HospID)
	}
	elseif (action = "getWards")
	{
		d ..GetLocationList("W","","",frameType,HospID)	
	}
	elseif (action = "getWardsByLocID")
	{
		s locID = $g(%request.Data("LocID",1),"-1")
		d ..GetLocationList("W",locID,"",frameType,HospID)		
	}
	
	q $$$OK
}

/// Debug:	d ##Class(web.eprajax.hisinterface.hospitalinfo).GetLocationList("E","","")
ClassMethod GetLocationList(AType As %String, ALocID As %String, ALocName As %String, AframeType As %String = "", AHospID As %String = "")
{
	s ShowShareHospital = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ShowShareHospital","Y")
	s:(ShowShareHospital = "Y") HospID = ""
	s count = 0
	s json = "["
	s result = ##Class(EPRservice.HISInterface.BLLocationInfo).GetLocationList(AType,ALocID,ALocName,AHospID)
	While (result.Next())
	{
		s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
		s json = json_"""Name"":"""_$g(result.Data("Name"))_"""},"	
		s count = count + 1
	}
	
	s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	if (AframeType = "HISUI")
	{
		s ret = "{""total"":"_count_",""rows"":"_json_"}"
	}
	else
	{
		s ret = json
	}
	
	w ret
}

}
