Class dhc.sync.web.U2SMap Extends %RegisteredObject
{

ClassMethod GetAppDir()
{
	Set Config = $o(^websys.ConfigurationD(""))
	Set App = $lg(^websys.ConfigurationD(Config),2)
	If App="" Set App="/dthealth/web"
	Set dir=""
	Set CurNS=$namespace
	zn "%sys"
	if $d(^SYS("Security","ApplicationsD",App),g){
		Set dir = $lg(g,17)_"/key/"
	}else{
		Set App1 = $p(App,"/",1,$l(App,"/")-1)
		if $d(^SYS("Security","ApplicationsD",App1),g){
			Set dir = $lg(g,17)_"/"_$p(App,"/",$l(App,"/"))_"/key/"
		}
	}
	zn CurNS
	Set dir = ##class(%File).NormalizeDirectory(dir)
	Quit dir
}

//加密

ClassMethod Enc(Password, SystemCode)
{
	 Set PK = SystemCode_"_Public.csr"	
	 Set PKeyFile = ##class(%File).NormalizeFilename(..GetAppDir()_PK)
	 if '##class(%File).Exists(PKeyFile) Set flag=-1 quit Password
	 
	 SET password1 = ##class(web.Util.Encryption).RSAEncrypt(Password,PKeyFile)
	 Quit password1
}

//解密

ClassMethod Dec(Password1, SystemCode)
{
     Set SK = SystemCode_"_Privatekey.pem"	
	 Set SKeyFile = ##class(%File).NormalizeFilename(..GetAppDir()_SK)
	 if '##class(%File).Exists(SKeyFile) Set flag=-1 quit Password1
	 SET Password = ##class(web.Util.Encryption).RSADecrypt(Password1,SKeyFile)
	 Quit Password
}

/// @author :wanghc
/// 保存同步记录表
/// password为空表示不修改密码
ClassMethod Save(UserCode, SystemCode, SessionUserId = "", SessionUserName = "", password = "")
{
	Quit:UserCode="" ""
	Quit:SystemCode="" ""
	Set RowId = $O(^dhcsyncU2SMapI("U2SMapIndex",UserCode,SystemCode,""))
	If RowId>0 {
		Set Obj = ##class(dhc.sync.data.U2SMap).%OpenId(RowId)
		Set OperateType = "U" ;Upd
		Set State = 3 ;修改
	}Else {
		 Set Obj = ##class(dhc.sync.data.U2SMap).%New()
		 Set Obj.SystemCode = SystemCode
		 Set Obj.UserCode = UserCode
		Set OperateType="A" ;Add
		Set State = 1	;新增
	}
	Set Obj.State = State
	if password'=""{
		;密码加密存入
		Set password1 = ..Enc(password,SystemCode)
		Set Obj.Password = password1
	}
	Set sc = Obj.%Save()
	If $$$ISERR(sc) Quit "-100^"_$SYSTEM.Status.GetErrorText(sc)
	Set State = $case(State,3:"修改",1:"新增",2:"删除",:State)
	Do ##class(dhc.sync.web.ChangeLog).SaveLog("Sync_User","dhc.sync.web.U2SMap","同步用户成功" ,
		UserCode,"用户同步到"_SystemCode_"系统",OperateType,State) 

	Set RowId = Obj.%Id(),Obj=""
	Quit RowId
}

}
