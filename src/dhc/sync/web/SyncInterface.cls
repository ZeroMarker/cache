Class dhc.sync.web.SyncInterface Extends %RegisteredObject
{

/// @desc 没上平台走自己的同步
/// @param Type 		"U"--User, "D"--Dept
/// @param SystemCodes  要同步的系统的代码. 如^HIS^OA^LIS^
/// @param Data 		用户数据或科室数据
ClassMethod Sync(Type, SystemCodes, Data)
{
	If $d(%session),$d(%session.Data("LOGON.USERID")){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}
	;Set ^Wanghc("SyncInterface",Type)=SystemCodes_","_Data
	If (Type="U"){
		Set rtn = ..SyncUserByCfg(SystemCodes,Data,SessionUserId,SessionUserName)
	}
	If (Type="D"){
		Set rtn = ..SyncDeptByCfg(SystemCodes,Data,SessionUserId,SessionUserName)
	}
	q rtn
}

ClassMethod SyncUserByCfg(SystemCodes, Data, SessionUserId, SessionUserName)
{
	Set $zt = "SyncError"
	Set len = $l(SystemCodes,"^")
	Set UserCode = $p(Data,"^"),itemCode=""
	Set SystemCodes = $zcvt(SystemCodes,"U")
	for i=1:1:len{
		Set itemCode = $p(SystemCodes,"^",i)
		if (itemCode'=""){
			Set SysId = $Order(^dhcsyncSystemI("syncSysCode",itemCode,""))
			if SysId>0{
				Set RowId = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,itemCode,""))
				IF RowId>0 Set $p(Data,"^",5)=3 	;修改
				Set Enc = $lg(^dhcsyncSystemD(SysId),7)
				Set ClsName = $lg(^dhcsyncSystemD(SysId),10)
				Set MthName = $lg(^dhcsyncSystemD(SysId),11)
				if ##class(websys.Conversions).IsValidMethodName(ClsName,MthName){
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","SyncInterface","同步"_itemCode_"开始",UserCode,"用户代码","E",$tr(Data,"^","|"))
					if (Enc="Y"){
						Set pwd = $p(Data,"^",3)
						set pwdEnc = ##Class(dhc.sync.web.U2SMap).Enc(pwd,itemCode)
						Set $p(Data,"^",3)=pwdEnc
					}
					Set WSObj = $CLASSMETHOD(ClsName,"%New")
					;调用ws
					if (MthName="SwitchSystem"){ ;集成平台接口
						Set WSRtn = $METHOD(WSObj,"SwitchSystem","U",itemCode,Data)	
					}else{	;单独接口
						//2016 先加上用户与密码
						do $METHOD(WSObj,"WSSecurityLogin","dhwebservice","dhwebservice")
						Set WSRtn = $METHOD(WSObj,MthName,"U",Data)
						 	
					}
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","SyncInterface","同步"_itemCode_"结束",UserCode,"用户代码","E",WSRtn)
					if WSRtn'<0 Set rtn =##class(dhc.sync.web.U2SMap).Save(UserCode,itemCode,SessionUserId,SessionUserName)
				}else{
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","SyncInterface","未发现同步方法",UserCode,"用户代码","E","0")
				}
			}
		}
	}
	Quit $$$OK
SyncError
	Set Err = $ze
	Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","SyncInterface",
						"同步"_$g(itemCode)_"异常错误",$g(UserCode),"用户代码","E",Err)
	Set $ze = ""
	Quit -101_"^"_Err
}

ClassMethod SyncDeptByCfg(SystemCodes, Data, SessionUserId, SessionUserName)
{
	Set $zt = "SyncError"
	Set len = $l(SystemCodes,"^")
	Set LocCode = $p(Data,"^"),itemCode=""
	Set SystemCodes = $zcvt(SystemCodes,"U")
	for i=1:1:len{
		Set itemCode = $p(SystemCodes,"^",i)
		if (itemCode'=""){
			Set SysId = $Order(^dhcsyncSystemI("syncSysCode",itemCode,""))
			if SysId>0{
				Set RowId = $O(^dhcsyncL2SMapI("L2SMapIndex",LocCode,itemCode,""))
				IF RowId>0 Set $p(Data,"^",5)=3 	;修改
				Set ClsName = $lg(^dhcsyncSystemD(SysId),10)
				Set MthName = $lg(^dhcsyncSystemD(SysId),11)
				if ##class(websys.Conversions).IsValidMethodName(ClsName,MthName){
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","SyncInterface","同步"_itemCode_"开始",LocCode,"科室代码","E",$tr(Data,"^","|"))
					Set WSObj = $CLASSMETHOD(ClsName,"%New")
					;调用ws
					if (MthName="SwitchSystem"){ ;集成平台接口
						Set WSRtn = $METHOD(WSObj,"SwitchSystem","D",itemCode,Data)	
					}else{	;单独接口
						//2016 先加上用户与密码
						do $METHOD(WSObj,"WSSecurityLogin","dhwebservice","dhwebservice")
						Set WSRtn = $METHOD(WSObj,MthName,"D",Data) 	
					}
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","SyncInterface","同步"_itemCode_"结束",LocCode,"科室代码","E",WSRtn)
					if WSRtn'<0 Set rtn =##class(dhc.sync.web.L2SMap).Save(LocCode,itemCode)
				}else{
					Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","SyncInterface","未发现同步方法",LocCode,"科室代码","E","0")
				}
				
			}
		}
	}
	Quit $$$OK
SyncError
	Set Err = $ze
	Set logRtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Loc","SyncInterface",
						"同步"_$g(itemCode)_"异常错误",$g(LocCode),"科室代码","E",Err)
	Set $ze = ""
	Quit -101_"^"_Err
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
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Dept","dhc.sync.web.SyncInterface","同步HIS开始",LocCode,"科室代码","E",$tr(Data,"^","|"))
		SET SoapRtn = ..SyncHISDept(Data,"HIS")
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Dept","dhc.sync.web.SyncInterface","同步HIS结束",LocCode,"科室代码","E",SoapRtn)
		if rtn<0 {
			q rtn
		}Else  {
			Set rtn =##class(dhc.sync.web.L2SMap).Save(LocCode,"HIS")
			if +rtn=-100 q rtn
		}
	}
	If (SystemCodes["^LIS^"){
	
	}
	If (SystemCodes["^PORTAL^"){
		;http://10.10.147.175:8081/Common_C91_UserSync/services/UserSyncServiceImpl?wsdl
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Dept","dhc.sync.web.SyncInterface","同步PORTAL开始",LocCode,"科室代码","E",$tr(Data,"^","|"))
		Set Soap = ##class(UserSyncServiceImplService.UserSyncServiceImpl).%New()
		Set SoapRtn = Soap.saveData("D",Data)
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Dept","dhc.sync.web.SyncInterface","同步PORTAL结束",LocCode,"科室代码","E",SoapRtn)
		if rtn<0 {
			q rtn
		}Else  {
			Set rtn =##class(dhc.sync.web.L2SMap).Save(LocCode,"PORTAL")
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
		Set RowId = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,"HIS",""))
		IF RowId>0 Set $p(Data,"^",5)=3
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.SyncInterface","同步HIS开始",UserCode,"用户代码","E",$tr(Data,"^","|"))
		Set SoapRtn = ##class(dhc.sync.web.SyncInterface).SyncHISUser(Data)
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.SyncInterface","同步HIS结束",UserCode,"用户代码","E",SoapRtn)
		If SoapRtn<0{
			q SoapRtn
		}else{
			if rtn<0 {
				q rtn_"^加同步日志失败"
			}Else{
				Set rtn =##class(dhc.sync.web.U2SMap).Save(UserCode,"HIS")
				if +rtn=-100 q rtn
			}
		}
	}
	If (SystemCodes["^LIS^"){
	
	}
	If (SystemCodes["^PORTAL^"){
		Set RowId = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,"HIS",""))
		IF RowId>0 Set $p(Data,"^",5)=3
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.SyncInterface","同步PORTAL开始",UserCode,"用户代码","E",$tr(Data,"^","|"))
		Set SoapRtn = ##class(dhc.sync.web.SyncInterface).SyncPORTALUser(Data)
		Set rtn = ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.SyncInterface","同步PORTAL开始",UserCode,"用户代码","E",SoapRtn)
		if SoapRtn<0 {
			q SoapRtn
		}Else  {
			if rtn<0{
				q rtn_"^加同步日志失败"
			}else{
				Set rtn =##class(dhc.sync.web.U2SMap).Save(UserCode,"PORTAL",SessionUserId,SessionUserName)
				if +rtn=-100 q rtn
			}
		}
	}
	q rtn
}

ClassMethod SyncPORTALUser(Data, SysCode = "PORTAL")
{
	Set:SysCode="" SysCode="PORTAL"
	&sql(Select Ensemble,PublicKey,Enc into :Ensemble,:PublicKey,:Enc from dhc_sync_data.Sync_System where Code=:SysCode)
	if Ensemble="Y"{
		if Enc="Y"{
			Set pwd = $p(Data,"^",3)
			set pwdEnc = ##Class(dhc.sync.web.U2SMap).Enc(pwd,"PORTAL")
			;Set pwdEnc = ##class(web.Util.Encryption).RSAEncrypt(pwd,PublicKey)
			Set $p(Data,"^",3)=pwdEnc
		}
		set Soap=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
		set SoapRtn=Soap.SwitchSystem("U",SysCode,Data)
	}else{
		Set Soap = ##class(UserSyncServiceImplService.UserSyncServiceImpl).%New()
		Set SoapRtn = Soap.saveData("U",Data)
	}
	Quit SoapRtn
}

ClassMethod SyncPORTALDept(Data, SysCode = "PORTAL")
{
	Set:SysCode="" SysCode="PORTAL"
	&sql(Select Ensemble,PublicKey,Enc into :Ensemble,:PublicKey,:Enc from dhc_sync_data.Sync_System where Code=:SysCode)
	if Ensemble="Y"{
		set Soap=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
		set SoapRtn=Soap.SwitchSystem("D",SysCode,Data)
	}else{
		Set Soap = ##class(UserSyncServiceImplService.UserSyncServiceImpl).%New()
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.saveData("D",Data)
	}
	Quit SoapRtn
}

ClassMethod SyncHISUser(Data, SysCode = "HIS")
{
	Set:SysCode="" SysCode="HIS"
	&sql(Select Ensemble,PublicKey,Enc into :Ensemble,:PublicKey,:Enc from dhc_sync_data.Sync_System where Code=:SysCode)
	if Enc="Y"{
		Set pwd = $p(Data,"^",3)
		set pwdEnc = ##Class(dhc.sync.web.U2SMap).Enc(pwd,"HIS")
		;Set pwdEnc = ##class(web.Util.Encryption).RSAEncrypt(pwd,PublicKey)
		Set $p(Data,"^",3)=pwdEnc
	}
	if Ensemble="Y"{
		set Soap=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
		set SoapRtn=Soap.SwitchSystem("U",SysCode,Data)
	}else{
		Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.Save("U",Data)
	}
	Quit SoapRtn
}

ClassMethod SyncHISDept(Data, SysCode = "HIS")
{
	Set:SysCode="" SysCode="HIS"
	&sql(Select Ensemble,PublicKey,Enc into :Ensemble,:PublicKey,:Enc from dhc_sync_data.Sync_System where Code=:SysCode)
	if Ensemble="Y"{
		set Soap=##class(ClientService.SwitchSystemWebServiceSoap).%New() ;3表修改状态
		set SoapRtn=Soap.SwitchSystem("D",SysCode,Data)
	}else{
		Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.Save("D",Data)
	}
	Quit SoapRtn
}

ClassMethod ImportHISDept(over = 0)
{
	If $d(%session),$d(%session.Data("LOGON.USERID")){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}
	Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
	Set Count=30,Start=1,Len=Count,SaveCount=0
	While (Len=Count) {
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.GetDeptList(Start,Count)
		Set Start = Start+Count
		Set Len = $l(SoapRtn,"|")	;返回值行数
		For i=1:1:Len {
			Set Data = $p(SoapRtn,"|",i)
			Set Code = $p(Data,"^",1)
			If ($d(^dhcsyncLocI("syncLocIdx",Code))=0)||(over=1){
				Do ##class(dhc.sync.web.Loc).SaveByData(Data,"",SessionUserId,SessionUserName)
				Set SaveCount=SaveCount+1
			}
		}
	}
	Quit SaveCount
}

ClassMethod ImportHISUser(over = 0)
{
	If $d(%session),$d(%session.Data("LOGON.USERID")){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}
	B
	Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
	Set Count=30,Start=1,Len=Count,SaveCount=0
	While (Len=Count) {
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.GetUserList(Start,Count)
		B ;SoapRtn
		Set Start = Start+Count
		Set Len = $l(SoapRtn,"|")	;返回值行数
		For i=1:1:Len {
			Set Data = $p(SoapRtn,"|",i)
			Set Code = $p(Data,"^",1)
			If ($d(^dhcsyncUserI("SyncUserCode",Code))=0)||(over=1){
				Do ##class(dhc.sync.web.User).SaveByData(Data,"",SessionUserId,SessionUserName)
				Set SaveCount=SaveCount+1
			}
		}
		
	}
	Quit SaveCount
}

ClassMethod ImportUser(SysCode, over)
{
	If SysCode="HIS"{
		Quit ..ImportHISUser(over)
	}
	Quit 0
}

ClassMethod ImportDept(SysCode, over)
{
	If SysCode="HIS"{
		Quit ..ImportHISDept(over)
	}
	Quit 0
}

ClassMethod ExportUser(SysCode, over)
{
	If SysCode="HIS"{
		Quit ..ExportHISUser(over)
	}
	If SysCode = "OA"{
		
	}
	Quit 0
}

ClassMethod ExportDept(SysCode, over)
{
	If SysCode="HIS"{
		Quit ..ExportHISDept(over)
	}
	If SysCode = "OA"{
		
	}
	Quit 0
}

ClassMethod ExportHISUser(over)
{
	If $d(%session),$d(%session.Data("LOGON.USERID")){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}
	Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
	Set Count=0
	Set RowId=""
	for  {
		Set RowId = $O(^dhcsyncUserD(RowId)) 
		Quit:RowId=""
		Set Data = ##class(dhc.sync.web.User).GetUserData(RowId)
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice") 
		Set SoapRtn = Soap.Save("U",Data)
		D ##class(dhc.sync.udata.uSyncLog).InsertRec("导出用户数据:"_SoapRtn,RowId,"HIS",$tr(Data,"^","|"))
		Set Count = Count+1
	}
	Quit Count
}

ClassMethod ExportHISDept(over)
{
	If $d(%session),$d(%session.Data("LOGON.USERID")){
		Set SessionUserId = %session.Data("LOGON.USERID")
		Set SessionUserName = %session.Data("LOGON.USERNAME")
	}Else{
		Set SessionUserId = "1"
		Set SessionUserName = "Debug"
	}
	Set Soap = ##class(dhc.sync.ws.SynchronizeUserLocSoap).%New()
	Set RowId=""
	for  {
		Set RowId = $O(^dhcsyncLocD(RowId)) 
		Quit:RowId=""
		Set Data = ##class(dhc.sync.web.Loc).GetLocData(RowId)
		do Soap.WSSecurityLogin("dhwebservice","dhwebservice")
		Set SoapRtn = Soap.Save("D",Data)
		D ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_Dept","Interface","导出科室HIS",$p(Data,"^",1),"科室代码","E",SoapRtn_"|"_$tr(Data,"^","|"))
	}
	Quit 0
}

/// / d ##class(dhc.sync.web.SyncInterface).ExportToText()
ClassMethod ExportToText()
{
	Set Count=0
	Set RowId=""
	set file = ##class(%File).%New("/tmp/UserNew.txt")
	do file.Open("WSN")
	for  {
		Set RowId = $O(^dhcsyncUserD(RowId)) 
		Quit:RowId=""
		Set Data = ##class(dhc.sync.web.User).GetUserData(RowId)
		d file.WriteLine(Data)
		Set Count = Count+1
	}
	Do file.%Save()
	Set file=""
	Quit Count
}

}
