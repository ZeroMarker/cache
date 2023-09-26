/// dhc.sync.SyncService
Class dhc.sync.SyncService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "SyncService";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// TODO: add arguments and implementation.
/// Test
Method Test(userId, uname, data) As %String [ WebMethod ]
{
	s Code=$p(data,1)
	s Name=$p(data,2)
	s Password=$p(data,3)
	s Deptcode=$p(data,4)
	s State=$p(data,5)
	s Email=$p(data,6)
	s InvalidDate=$p(data,7)
	s EegDate=$p(data,8)
	s Type=$p(data,9)
	s Mnemonics=$p(data,10)
	s HealthType=$p(data,11)
	s IsExpert=$p(data,12)
	s Secgroup=$p(data,13)
	s Certificate=$p(data,14)
	s ISDrugRight=$p(data,15)
	s Number=$p(data,16)
	s Ename=$p(data,17)
	s userId=1,uname="demo group"
	s rowid=0
	s rowid=$o(^dhcsyncUserI("SyncUserCode",Code,rowid))
	i rowid<=0 d
	.s SaveUser=##class(dhc.sync.data.hrUser).%New()
	.d SaveUser.InsertRec(userId, uname, Code, Name, Password, Deptcode, State, Email, InvalidDate, "", EegDate, Type,Mnemonics,HealthType,IsExpert,Secgroup,Certificate,ISDrugRight,Number,Ename)
	Quit SQLCODE
}

/// Description:OA用户登录密码验证
/// 参数 1.ucode:用户编码 2.pass：加密后的密码
ClassMethod Certific(ucode, pass) As %String [ WebMethod ]
{
	Set $zt="CertificError"
	s userid=0
	k ^temphss
	s ^temphss=ucode_"^"_pass
	Set SysCode = "OA"	;哪个组加密来的密码得用哪个组对应的私钥解密
	;修改成md5(mcache())
	;Set psw = ##class(dhc.sync.web.U2SMap).Dec(pass,SysCode)
	Set userid = ##class(dhc.sync.web.User).GetIdByCode(ucode)
	;s ^temphss("userid")=userid_","_psw
	If userid>0 {
		s pswm=$List(^dhcsyncUserD(userid),4)
		s statu=$List(^dhcsyncUserD(userid),6)
		//禁用用户时
		b ;01
		if statu=2 quit -2  
		;s ^temphss("userid")=userid_","_psw_","_pswm
		//统一用户平台没有密码,则比较his中用户密码
		if pswm=""{
			if ##class(web.SSUser).IsValidUserMd5Password(ucode,pass)>0 {
				b ;md5
				;密码保存到统一平台中
				Set Data = ##class(dhc.sync.web.User).GetUserData(userid)
				Set $p(Data,"^",3)=pass
				Set SyncSysCode = ##class(dhc.sync.web.User).GetSystemCodes(userid)
				Set SyncSysCode = $tr(SyncSysCode,",","^")
				Set SyncSysCode = "^"_SyncSysCode_"^OA^PORTAL^"
				Set rtn = ##class(dhc.sync.web.User).SaveByData(Data,SysCode,"","")
				if (rtn>0) {q 0}
				else {quit rtn}
			}
		}else{
			//加密后对比
			q:pass=pswm 0 
		}
		q -1 ;密码不正确
	}
	q -4
CertificError
	Set ^tempPortal("error")=$ze
	Quit -3
}

/// 修改用户密码与姓名，调用接口
/// UserCode 用户代码
/// UserName 用户名
/// Pwd      加密后的密码
/// SysCode  其它系统代码
ClassMethod Save(UserCode, UserName, Pwd, SysCode) As %String [ WebMethod ]
{
	Quit:UserCode="" "-1"
	Set UserId = $O(^dhcsyncUserI("SyncUserCode",UserCode,""))
	Quit:UserId="" "-1"
	Set UName= $lg(^dhcsyncUserD(UserId),3)
	Set UserObj = ##class(dhc.sync.data.User).%OpenId(UserId)
	Quit:'$IsObject(UserObj) "-1"
	If (UserName'="") && (UserName'=UName){
		Set UserObj.Name = UserName
	}
	Set UPwd = $Lg(^dhcsyncUserD(UserId),4)
	Set DecPwd = ##class(dhc.sync.web.U2SMap).Dec(Pwd,SysCode)
	If (DecPwd'="")&&(UPwd'=DecPwd){
		Set UserObj.Password = DecPwd
		Set UserObj.PasswordDate = +$h
	}
	Set sc = UserObj.%Save()
	If $$$ISERR(sc){
		Quit -1_"^Save Error"
	}
	Set UserSysCodes = ##class(dhc.sync.web.User).GetSystemCodes(UserId)
	For i=1:1:$l(UserSysCodes,","){
		Set ItemSysCode = $p(UserSysCodes,",",i)
		If ItemSysCode'=""{
			Set Data = ##class(dhc.sync.web.User).GetUserData(UserId)
			Set rtn = ##class(dhc.sync.web.SyncInterface).Sync("U",ItemSysCode,Data) 
		}
	}
	Quit rtn
}

ClassMethod SavePassword(UserCode, UserPassword)
{
	quit ##class(dhc.sync.web.User).SavePassword(UserCode,UserPassword)
}

// w ##class(dhc.sync.SyncService).CertificByPT("ris^oU9bUauESpLkPlRVJ+flNKclHnQy58kIzMA1MymVcZBcCSK0694HN1Suj6Wlb6LfQ4xrWNths4Fr"_$c(10)_"qAwMWM0u+jpxnkFvwf9IRqOKDjmEXwWHEG/DPqsp8b3wRo16S+A1MeeVZW+mkv6JTIbdtbF7Zf1w"_$c(10)_"hw0RVgqq8jpCkbo2bkE=")

/// w ##class(dhc.sync.SyncService).CertificByPT("4140^7DDEB10883804C0C04911262A37E420C")
/// 入参修改成一个，集成平台只支持一个入参
ClassMethod CertificByPT(ucodePass) As %String [ WebMethod ]
{
	s userid=0
	k ^tempPortal
	s ^tempPortal("CertificByPT")=ucodePass
	
	s ucode=$p(ucodePass,"^",1)
	s pass=$p(ucodePass,"^",2)
	;q 0
	Q ..Certific(ucode,pass)
	
	
	Set SysCode = "OA"	;哪个组加密来的密码得用哪个组对应的私钥解密
	Set psw = ##class(dhc.sync.web.U2SMap).Dec(pass,SysCode)
	/*
	Set userid = ##class(dhc.sync.web.User).GetIdByCode(ucode)
	If userid>0 {
		s pswm=$List(^dhcsyncUserD(userid),4)
		q:psw=pswm 0
	}
	*/
	if (##class(web.SSUser).IsValidUser(ucode,psw)>0){
		q 0
	}
	
	q -1
}

/// usercode_$c(9812)_oldPassword_$c(9812)_newPassword
/// w ##class(dhc.sync.SyncService).ChangeHISPassword("demo"_$c(9812)_##class(web.Util.Encryption).MD5HexStr(##class(web.SSUser).Encrypt(1))_$c(9812)_##class(web.SSUser).Encrypt(2))
ClassMethod ChangeHISPassword(input As %String = "") As %String [ WebMethod ]
{
	//s ^Temp("ChangeHISPassword")=input
	s $zt="Err"
	s status=1,data=-1,errMsg="",json=""
	s delim=$c(9812)
	s usercode=$p(input,delim,1)
	s oldPassword=$p(input,delim,2)
	s newPassword=$p(input,delim,3)
	i $$ALPHAUP^SSUTIL4(usercode)="" s errMsg="用户名不能为空" g qJson
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	i userid'>0 s errMsg="用户不存在" g qJson
	s obj=##class(User.SSUser).%OpenId(userid)
	s persistPWD=obj.SSUSRPassword
	s persistPWDMD5=##class(web.Util.Encryption).MD5HexStr(persistPWD)
	i persistPWDMD5'=oldPassword{
		s errMsg="原密码不正确"
	}else{
		s obj.SSUSRPassword=newPassword   //新密码 
		//s obj.SSUSRPin=newPassword  //pin
		s obj.SSUSRPasswordDate=+$h   //密码修改日期
		s obj.SSUSRPasswordChanged="N"  //下次登陆修改密码
		s sc=obj.%Save()
		if $$$ISERR(sc){
			s status=-1,errMsg="保存失败"_$system.Status.GetErrorText(sc)	
		}else{
			s data=1
		}
		d obj.%Close()
		s obj=""
	}
	g qJson
Err
	s status=-1,errMsg=$ze
	g qJson
qJson
	s jsonObj=##class(ext.util.JsonObject).%New()
	d jsonObj.Put("status",status).Put("errMsg",errMsg).Put("data",data)
	q jsonObj.Json()
}

/// usercode_$c(9812)_oldPassword
/// w ##class(dhc.sync.SyncService).ValidHISPassword("demo"_$c(9812)_##class(web.Util.Encryption).MD5HexStr(##class(web.SSUser).Encrypt(1)))
ClassMethod ValidHISPassword(input As %String = "") As %String [ WebMethod ]
{
	s ^Temp("ValidHISPassword")=input
	s $zt="Err"
	s success=0,needChangePwd=0,errMsg="",json=""
	s delim=$c(9812)
	s usercode=$p(input,delim,1)
	s oldPassword=$p(input,delim,2)
	s newPassword=$p(input,delim,3)
	i $$ALPHAUP^SSUTIL4(usercode)="" s errMsg="用户名不能为空" g qJson
	s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
	i userid'>0 s errMsg="用户不存在" g qJson
	s obj=##class(User.SSUser).%OpenId(userid,0)
	If '$IsObject(obj) s errMsg="用户不存在" g qJson
	s persistPWD=obj.SSUSRPassword
	s persistPWDMD5=##class(web.Util.Encryption).MD5HexStr(persistPWD)
	i persistPWDMD5'=oldPassword s errMsg="密码不正确" g qJson
	i obj.SSUSRActive'="Y" s errMsg="用户未激活" g qJson
	i obj.SSUSRDateFrom'="",obj.SSUSRDateFrom>+$h s errMsg="未到激活开始日期" g qJson
	i obj.SSUSRDateTo'="",obj.SSUSRDateTo<+$h s errMsg="已过激活截止日期" g qJson
	set success=1
	i obj.SSUSRPasswordChanged="Y" s needChangePwd=1 g qJson  //需要修改密码
	if ##class(websys.Conversions).IsValidMethodName("websys.Configuration","GetFieldValue"){
		set pwdDate = obj.SSUSRPasswordDate		 ;SSUSR_PasswordDate -> 修改密码时间
		set pwdValidInterval = ##class(websys.Configuration).GetFieldValue("PwdValidInterval")
		if pwdValidInterval>0,pwdValidInterval+pwdDate<=+$h s needChangePwd=1 g qJson  //需要修改密码
	}
	g qJson
Err
	s success=0,errMsg=$ze
	g qJson
qJson
	s obj=""
	s jsonObj=##class(ext.util.JsonObject).%New()
	d jsonObj.Put("success",success).Put("errMsg",errMsg).Put("needChangePwd",needChangePwd)
	q jsonObj.Json()
}

/// s stream=##class(dhc.sync.SyncService).getPermissionsByRole(1)
ClassMethod getPermissionsByRole(roleId) As %GlobalCharacterStream [ WebMethod ]
{
	s $zt="getPermissionsByRoleErr"
	s stream=##class(%GlobalCharacterStream).%New()
	s obj=##class(BSP.SYS.COM.ProxyObject).%New()
	
	s eprgrpid=##Class(epr.GroupSettings).GetIdFromGroupId(roleId)
	if eprgrpid>0 {
		Set security = $lg(^ooGroupSettingsD(eprgrpid),24)
		Set smg = $lg(^ooGroupSettingsD(eprgrpid),1)
		set hm=$lg(^ooGroupSettingsD(eprgrpid),14)
		
		s obj.state=0,obj.errMSG="",obj.count=1
		s pData=##class(BSP.SYS.COM.ProxyObject).%New()
		s obj.pData=pData
		s permTypeList=##class(BSP.SYS.COM.ProxyObject).%FromJSON("[{""permType"": ""01"",""permTypeNm"":""头菜单"",""permTypeDesc"":""系统中顶部显示的菜单""},{""permType"": ""02"",""permTypeNm"": ""侧菜单"",""permTypeDesc"": ""系统中在左侧显示的菜单""}]")
		s pData.permTypeList=permTypeList
		s permList=##class(BSP.SYS.COM.ProxyArray).%New()
		s pData.permList=permList
		
		//头菜单
		set permListItem=##class(BSP.SYS.COM.ProxyObject).%New()
		set permListItem.permType="01"
		set perms=##class(BSP.SYS.COM.ProxyArray).%New()
		if hm>0,$d(^websys.MenuD(hm)){
			d ..Menu2Array(hm,security,perms,1)
		}
		s permListItem.perms=perms
		d permList.%Push(permListItem)
		
		//侧菜单
		set permListItem=##class(BSP.SYS.COM.ProxyObject).%New()
		set permListItem.permType="02"
		set perms=##class(BSP.SYS.COM.ProxyArray).%New()
		if smg>0 {
			set SGObj=##class(websys.MenuGroup).%OpenId(smg,0)
			if SGObj {
				set sidemunes=SGObj.MenuItemsGet()
				set SGObj=""
				for i=1:1:$l(sidemunes,"|"){
					set itemid=$p(sidemunes,"|",i)
					continue:itemid'>0
					if (security'="")&&($zbitlen(security)>=itemid)&&$zbitget(security,itemid) d ..Menu2Array(itemid,security,perms,1)
				}
			}
		}else{
			d ..Menu2Array(1,security,perms,1)
		}
		s permListItem.perms=perms
		d permList.%Push(permListItem)
	}else{
		s obj.state=-1,obj.errMSG="roleId="_roleId_"，不正确或未配置",obj.count=0
	}
	
 	s sc=obj.%ToJSON(stream,10)
 	
 	if sc=1 {
	 	q stream
 	}else{
	 	d stream.Clear()
	 	d stream.Write("{""state"":-1,""errMSG"":"""_$system.Status.GetErrorText(sc)_"""}")
	 	q stream
	}


getPermissionsByRoleErr
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("{""state"":-1,""errMSG"":"""_$zcvt($ze,"O","JS")_"""}")
	q stream
}

ClassMethod Menu2Array(menuid, security, array As BSP.SYS.COM.ProxyArray, isRoot = 0)
{
	q:($g(menuid)'>0)||('$d(^websys.MenuD(menuid))) ""
	s code=$lg(^websys.MenuD(menuid),4)
	q:code="" ""
	s desc=$lg(^websys.MenuD(menuid),1)
	s desc=$p($g(^websys.TranslationD("MENU",20,menuid,code),desc),"^",1)
	s parent=$lg(^websys.MenuD(menuid),12)
	
	s obj=##class(BSP.SYS.COM.ProxyObject).%New()
	s obj.permId=menuid,obj.permName=desc,obj.permDesc=desc,obj.parentPermId=parent_""
	d array.%Push(obj)
	
	Set Seq=""
    For {
		Set Seq=$Order(^websys.MenuI("SubMenuOf2",menuid,Seq))		;;Sequence
		Quit:(Seq="")
		Set SubMenuId=0
		For {
			Set SubMenuId=$Order(^websys.MenuI("SubMenuOf2",menuid,Seq, SubMenuId))
			Quit:(SubMenuId="")
			
			if (security'="")&&($zbitlen(security)>=SubMenuId)&&$zbitget(security,SubMenuId) d ..Menu2Array(SubMenuId,security,array,0)
			
		}
    }
}

}
