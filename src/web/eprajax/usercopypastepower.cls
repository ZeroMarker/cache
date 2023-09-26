Class web.eprajax.usercopypastepower Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s type = $Get(%request.Data("Type",1),"")
	s locID = $Get(%request.Data("LocId",1),"")
	s userId=$Get(%request.Data("UserID",1),"")
	s ssgroupId=$Get(%request.Data("SSGroupID",1),"")
	s stDateTime=$Get(%request.Data("StartDateTime",1),"")
	s endDateTime=$Get(%request.Data("EndDateTime",1),"")
	s foreverban=$Get(%request.Data("Foreverban",1),"")
	s rowID=$Get(%request.Data("RowId",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s Filter = $Get(%request.Data("Filter",1),"")
	s userLocID = $Get(%request.Data("userLocID",1),"")
	s doctorName = $Get(%request.Data("doctorName",1),"")
	s HospitalID = $Get(%request.Data("HospitalID",1),"")
	s:(HospitalID="") HospitalID=$g(%session.Data("LOGON.HOSPID"))
	
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	
	if (action="GetAllCTLocID"){
		w ..GetAllCTLocID(type,Filter,HospitalID)
	}elseif (action = "GetCTLocID")
	{
 		w ..GetCTLocID(type,locID,Filter,HospitalID)
 		
	}
	elseif (action = "GetTransCTLocID")
	{
		w ..GetTransCTLocID(EpisodeID)
	}
	elseif (action = "GetTransEmployee")
	{
		w ..GetTransEmployee(EpisodeID,locID)
	}
	elseif (action = "GetUserID")
	{
		w ..GetUserID(locID)
	}
	elseif (action = "SetData")
	{
		if (stDateTime'=""){
			s stDate=$zdh($p(stDateTime," ",1),3)
			s stTime=$zth($p(stDateTime," ",2),1)
		}else{
			s stDate=""
			s stTime=""
		}
		if (endDateTime'=""){
			s endDate=$zdh($p(endDateTime," ",1),3)
			s endTime=$zth($p(endDateTime," ",2),1)
		}else{
			s endDate=""
			s endTime=""
		}
		w ##Class(EPRservice.Quality.BOUserCopyPastePower).SetData(userId,ssgroupId,stDate,stTime,endDate,endTime,foreverban)
	}
	elseif (action = "GetDataList")
	{
		w ##class(EPRservice.Quality.BOUserCopyPastePower).GetDataList()
	}
	elseif (action = "DeletData")
	{
		w ##class(EPRservice.Quality.BOUserCopyPastePower).DeletData(rowID)
	}elseif (action="GetMZCTLocID")
	{
		w ..GetMZCTLocID(type,Filter)
	}elseif (action="ssUser")
	{
		w ..GetssUser(userLocID,doctorName)
	}
	Quit $$$OK
}

/// Desc:获取科室ID、科室Name
/// w ##Class(web.eprajax.usercopypastepower).GetTransCTLocID(1881)
ClassMethod GetTransCTLocID(argAdmId As %String)
{
	s json = ""
	s count = 0

	//入参检查
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//定义变量
	s transDept="",tmpTransDept="",lastTransDept="",transStatusDR=""
	
	//最大的childSub节点
	s maxChildSub = $O(^PAADM(argAdmId,"TRANS",""),-1)
	
	s childSub = "0"
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
		//扬中项目：索引问题导致轮询到最后一个childSub后，又再次重新开始轮询
		q:(childSub = maxChildSub)
		
		
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
		
		s transCtlocDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",6)
		if transCtlocDR="" continue
		
		s tmpTransDept = $p($g(^CTLOC(transCtlocDR)),"^",2)
		if $l(tmpTransDept,"-")>1 {s tmpTransDept=$p(tmpTransDept,"-",2)}
		if tmpTransDept="" continue
		if tmpTransDept=lastTransDept continue
		
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""LocID"":"""_transCtlocDR_""","
		s json = json_"""LocName"":"""_tmpTransDept_""""
	    s json = json_"}"
		s count = count + 1
		
		s lastTransDept=tmpTransDept
	}
	
	if json=""
	{
	//获取该病人的接诊科室
		s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(argAdmId)
    		s LocID = $P(ObjRet,"^",1)
    		s LocName = $p(ObjRet,"^",2)
    	
    		s json = "{"
		s json = json_"""LocID"":"""_LocID_""","
		s json = json_"""LocName"":"""_LocName_""""
	    	s json = json_"}"
	}

	s json = "["_json_"]"
	//s json = "["_"{""LocID"":""100"",""LocName"":""内分泌测试""},{""LocID"":""195"",""LocName"":""内分泌测试2""}"_"]"

	q json
}

/// Desc:获取转科责任医师ID、责任医师Name
/// w ##Class(web.eprajax.usercopypastepower).GetTransEmployee(215)
ClassMethod GetTransEmployee(argAdmId As %String, ALocID As %String = "")
{
	s json = ""
	s count = 0

	//入参检查
	q:(($d(argAdmId)=0)||(argAdmId="")) ""
	
	//定义变量
	s transDept="",tmpTransEmployeeID="",lastTransEmployeeID="",transStatusDR=""
	
	//最大的childSub节点
	s maxChildSub = $O(^PAADM(argAdmId,"TRANS",""),-1)
	
	s childSub = "0"
	for {
		s childSub = $O(^PAADM(argAdmId,"TRANS",childSub))
		q:(childSub="")
				
		s transStatusDR = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",12)
		if transStatusDR=2 continue
	  
		s tmpTransEmployeeID = $p($g(^PAADM(argAdmId,"TRANS",childSub)),"^",5)
		
		if tmpTransEmployeeID="" continue
        
        s tmpTransEmployeeName = $s(tmpTransEmployeeID '= -1:$p($g(^CTPCP((+tmpTransEmployeeID),1)),"^",2),1:"未指定")
		if tmpTransEmployeeID=lastTransEmployeeID continue
		s IsCurrLocFlag=##class(EPRservice.Quality.DataGather.AdmInfo).IsCurrLocByEmployeeID(ALocID,tmpTransEmployeeID)
		continue:IsCurrLocFlag'=1
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""EmployeeID"":"""_tmpTransEmployeeID_""","
		s json = json_"""EmployeeName"":"""_tmpTransEmployeeName_""""
	    s json = json_"}"
		s count = count + 1
		
		s lastTransEmployeeID=tmpTransEmployeeID
	}
	
	if json=""
	{
	//获取该病人的接诊医师
		s ObjRet = ##Class(EPRservice.Quality.BOManualCheck).GetPatientInfoByEpisodeID(argAdmId)
    		s EmployeeID = $P(ObjRet,"^",3)
    		s EmployeeName = $P(ObjRet,"^",4)
    	
    		s json = "{"
		s json = json_"""EmployeeID"":"""_EmployeeID_""","
		s json = json_"""EmployeeName"":"""_EmployeeName_""""
	    	s json = json_"}"
	}	

	s json = "["_json_"]"
	

	q json
}

/// Desc:获取科室ID、科室Name
/// w ##Class(web.eprajax.usercopypastepower).GetCTLocID("E")
ClassMethod GetCTLocID(AType As %String, ALocID As %String  = { ""}, AFilter As %String, AHospitalID As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetLocationList")
	d ds.Execute(AType,ALocID,AFilter,AHospitalID)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""ID"":"""_ds.Data("ID")_""","
		s json = json_"""Name"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// w ##Class(web.eprajax.usercopypastepower).GetssUser(21,"")
ClassMethod GetssUser(currentLogLocID As %String, doctorName As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetDoctorByDeptId")
	d ds.Execute(currentLogLocID,doctorName)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""ID"":"""_ds.Data("ID")_""","
		s json = json_"""Name"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// Desc:依据科室ID获取用户ID、用户Name
ClassMethod GetUserID(ALocID As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetUserDataList")
	d ds.Execute("",ALocID)
	While (ds.Next())
	{
		if (ds.Data("UserID")'=""){
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""UserID"":"""_ds.Data("UserID")_""","
			s json = json_"""UserDesc"":"""_ds.Data("UserDesc")_""""
	    	s json = json_"}"
			s count = count + 1
		}
	}
	s json = "["_json_"]"
	q json
}

/// 获取门诊科室ID、科室Name
ClassMethod GetMZCTLocID(AType As %String, AFilter As %String)
{
	s json = ""
	s count = 0
	s HospitalID=$g(%session.Data("LOGON.HOSPID"))
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetMZLocationList")
	d ds.Execute(AType,"",AFilter,HospitalID)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""ID"":"""_ds.Data("ID")_""","
		s json = json_"""Name"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

/// 获取所有科室ID、科室Name
ClassMethod GetAllCTLocID(AType As %String, AFilter As %String, HospitalID As %String)
{
	s json = ""
	s count = 0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetAllLocationList")
	d ds.Execute(AType,"",AFilter,HospitalID)
	While (ds.Next())
	{
		s:(count '=0) json =json_","
		s json = json_"{"
		s json = json_"""ID"":"""_ds.Data("ID")_""","
		s json = json_"""Name"":"""_ds.Data("Name")_""""
	    s json = json_"}"
		s count = count + 1
	}
	s json = "["_json_"]"
	q json
}

}
