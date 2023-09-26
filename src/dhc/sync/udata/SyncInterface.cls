Class dhc.sync.udata.SyncInterface Extends %RegisteredObject
{

/// @desc 没上平台走自己的同步
/// @param Type 		"U"--User, "D"--Dept
/// @param SystemCodes  要同步的系统的代码. 如^HIS^OA^LIS^
/// @param Data 		用户数据或科室数据
ClassMethod Sync(Type, SystemCodes, Data)
{
	If $d(%session){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}

	If (Type="U"){
		Set rtn = ..SyncUser(SystemCodes,Data,SessionUserId,SessionUserName)
	}
	If (Type="D"){
		Set rtn = ..SyncDept(SystemCodes,Data,SessionUserId,SessionUserName)
	}
	q rtn
}

ClassMethod SyncDept(SystemCodes, Data, SessionUserId, SessionUserName)
{
	s tn="dhc_sync_data.Sync_L2SMap"
	s cn="dhc.sync.udata.syncL2SMap"
	s cnd="科室信息同步"
	s od="修改科室信息同步到系统的信息"
	set rtn=0
	Set LocCode = $p(Data,"^")
	If (SystemCodes["^HIS^"){
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("开始同步",LocCode,"HIS", $tr(Data,"^","|"))
		Set Soap = ##class(SynchronizeUserLoc.SynchronizeUserLocSoap).%New()
		Set SoapRtn = Soap.Save("D",Data)
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("同步结束"_SoapRtn,LocCode,"HIS", $tr(Data,"^","|"))
		if rtn<0 {
			q rtn
		}Else  {
			Set rtn =##class(dhc.sync.udata.uSyncl2SMap).Save(LocCode,"HIS",SessionUserId,SessionUserName)
			if +rtn=-100 q rtn
		}
	}
	If (SystemCodes["^LIS^"){
	
	}
	If (SystemCodes["^PORTAL^"){
		;http://10.10.147.175:8081/Common_C91_UserSync/services/UserSyncServiceImpl?wsdl
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("开始同步",LocCode,"PORTAL", $tr(Data,"^","|"))
		Set Soap = ##class(UserSyncServiceImplService.UserSyncServiceImpl).%New()
		Set SoapRtn = Soap.saveData("D",Data)
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("同步结束"_SoapRtn,LocCode,"PORTAL", $tr(Data,"^","|"))
		if rtn<0 {
			q rtn
		}Else  {
			Set rtn =##class(dhc.sync.udata.uSyncl2SMap).Save(LocCode,"PORTAL",SessionUserId,SessionUserName)
			if +rtn=-100 q rtn
		}
	}
	q rtn
}

ClassMethod SyncUser(SystemCodes, Data, SessionUserId, SessionUserName)
{
	s tn="dhc_sync_data.Sync_U2SMap"
	s cn="dhc.sync.udata.syncU2SMap"
	s cnd="用户信息同步"
	s od="修改用户信息同步到系统的信息"
	Set UserCode = $p(Data,"^")
	set rtn=0
	If (SystemCodes["^HIS^"){
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("开始同步",UserCode,"HIS",$tr(Data,"^","|"))
		Set Soap = ##class(SynchronizeUserLoc.SynchronizeUserLocSoap).%New()
		Set SoapRtn = Soap.Save("U",Data)
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("同步结束"_SoapRtn,UserCode,"HIS",$tr(Data,"^","|"))
		if rtn<0 {
			q rtn
		}Else{
			Set rtn =##class(dhc.sync.udata.syncU2SMap).Save(UserCode,"HIS",SessionUserId,SessionUserName)
			if +rtn=-100 q rtn
		}
	}
	If (SystemCodes["^LIS^"){
	
	}
	If (SystemCodes["^PORTAL^"){
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("开始同步",UserCode,"PORTAL",$tr(Data,"^","|"))
		Set Soap = ##class(UserSyncServiceImplService.UserSyncServiceImpl).%New()
		Set SoapRtn = Soap.saveData("U",Data)
		Set rtn = ##class(dhc.sync.udata.uSyncLog).InsertRec("同步结束"_SoapRtn,UserCode,"PORTAL",$tr(Data,"^","|"))
		if rtn<0 {
			q rtn
		}Else  {
			Set rtn =##class(dhc.sync.udata.syncU2SMap).Save(UserCode,"PORTAL",SessionUserId,SessionUserName)
			if +rtn=-100 q rtn
		}
	}
	q rtn
}

}
