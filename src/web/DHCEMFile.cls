Import SQLUser

Class web.DHCEMFile Extends %RegisteredObject
{

/// -100 未配置FTP服务器环境! 请移步侧菜单-消息管理-消息配置进行配置!
/// -101 FTP服务器IP未配置
/// -102 FTP服务器用户未配置
/// -103 FTP服务器密码未配置
/// -104 文件流为空
ClassMethod FTPUpload(FileStream As %CSP.BinaryStream, Dir As %String, FileName As %String = "", LgHospID = "")
{
	If 'FileStream Quit "-104"
	
	Set FTPIP=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPIP",LgHospID,"","","")
	Set FTPUSERNAME=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPUSERNAME",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPPASSWORD",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.Util.Encryption).SimpleDecrypt(FTPPASSWORD,"FTPPASSWORD")
	Set FTPPORT=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPPORT",LgHospID,"","","")
	Quit:((FTPIP="")||(FTPUSERNAME="")||(FTPPASSWORD="")) "-1100"
	Set IP = FTPIP 
	Quit:IP="" Quit -101
	Set UserName = FTPUSERNAME 
	Quit:UserName="" Quit -102
	Set Password = FTPPASSWORD
	Quit:Password="" Quit -103
	Set Port = FTPPORT
	if Port="" Set Port=21
	quit ..Upload(IP, UserName, Password, Port, FileStream, Dir, FileName,LgHospID)
}

ClassMethod Upload(IP, UserName, Password, Port, FileStream As %CSP.BinaryStream, Dir As %String, FileName = "", LgHospID = "")
{
	s ftp=##class(%Net.FtpSession).%New()
	Set ftp.SSLConfiguration="FTPS"	;公司要求走ftps
	d ftp.CommandTranslateTableSet("UTF8")
	;s ^qqa = $lb(IP,UserName,Password,Port,FileStream,Dir,FileName,LgHospID)
	i 'ftp.Connect(IP,UserName,Password,Port) q "-1^"_ftp.ReturnMessage
	i 'ftp.Binary() q "-2^"_ftp.ReturnMessage
	if (FileName="") Set FileName = FileStream.FileName
	;create dir and goto dir
	if Dir'="" {
		Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
		if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
		if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
		for i=1:1:DirLen {
			set CurrentDir = $p(Dir,sep,i)
			if $l(CurrentDir)>0 {
				i ftp.SetDirectory(CurrentDir){
				}else{
					s MakeDir = ftp.MakeDirectory(CurrentDir)
					s cdFlag = ftp.SetDirectory(CurrentDir)
				}
			}
		}
	}
	i 'ftp.Store(FileName,FileStream) q "-3^"_ftp.ReturnMessage
	d FileStream.Clear()
	s FileStream=""
	i 'ftp.Logout() quit "-4^"_ftp.ReturnMessage
	s ftp=""
	;q 1_"^"_##class(ext.util.String).Replace(FileName,"//","/")
	q 1_"^"_##class(ext.util.String).Replace($tr(Dir,"\","/")_"/"_FileName,"//","/")
	q 1
}

/// w ##class(web.DHCEMFile).FTPDeleteFile("/dhcnewpro/patchecklev/202164/1","耳105.png",2)
ClassMethod FTPDeleteFile(Dir, FileName, LgHospID)
{
	Set FTPIP=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPIP",LgHospID,"","","")
	Set FTPUSERNAME=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPUSERNAME",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPPASSWORD",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.Util.Encryption).SimpleDecrypt(FTPPASSWORD,"FTPPASSWORD")
	Set FTPPORT=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPPORT",LgHospID,"","","")
	Quit:((FTPIP="")||(FTPUSERNAME="")||(FTPPASSWORD="")) "-1100"
	Set IP = FTPIP 
	Quit:IP="" Quit -101
	Set UserName = FTPUSERNAME 
	Quit:UserName="" Quit -102
	Set Password = FTPPASSWORD
	Quit:Password="" Quit -103
	Set Port = FTPPORT
	if Port="" Set Port=21
	Set ftp=##class(%Net.FtpSession).%New()
	Set ftp.SSLConfiguration="FTPS"	;公司要求走ftps
	d ftp.CommandTranslateTableSet("UTF8")
	if 'ftp.Connect(IP,UserName,Password,Port) q "链接失败,"_ftp.ReturnMessage
	if Dir'="" {
		Set Dir = ##class(ext.util.String).Replace(Dir,"//","/")
		if Dir["/" Set DirLen = $l(Dir,"/"),sep="/"
		if Dir["\" Set DirLen = $l(Dir,"\"),sep="\"
		for i=1:1:DirLen {
			set CurrentDir = $p(Dir,sep,i)
			if $l(CurrentDir)>0 {
				i ftp.SetDirectory(CurrentDir){
				}else{
					s MakeDir = ftp.MakeDirectory(CurrentDir)
					s cdFlag = ftp.SetDirectory(CurrentDir)
				}
			}
		}
	}
	if 'ftp.Delete(FileName) q "删除失败,"_ftp.ReturnMessage
	do ftp.Logout()
	q 0
}

Parameter FTP2WEB = "imedicalftp";

/// ftp的名字
ClassMethod GetSaveImgName(PCLRowID)
{
	s PatientID =$P(^DHCEMPCL(PCLRowID),"^",1)
	s PatName = $p(^PAPER(PatientID,"ALL"),"^",1)
	q PatName_$i(^DHCEMIMGNAME)
}

/// w ##class(web.DHCEMFile).saveUrl("1","http://172.19.19.57/imedicalftp/dhcnewpro/patchecklev/1/10.jpg")
/// w ##class(web.DHCEMFile).saveUrl("1","2")
/// w ##class(web.DHCEMFile).saveUrl("84^http://172.19.19.82/imedicalftp/dhcnewpro/patchecklev/2020416/1/刘楠25.png^1^10211^2")
ClassMethod saveUrl(Params)
{
	s PCLRowID= $p(Params,"^",1)
	s ImgUrl = $p(Params,"^",2)
	s ImgType = $p(Params,"^",3)
	s CurDate = +$h
	s CurTime = $p($h,",",2)
	s CurUser = $p(Params,"^",4)
	s PCDBase = $p(Params,"^",5)
	&sql(INSERT INTO DHC_EmPatChkDocu (PCD_Chk_Dr,PCD_DocuUrl,PCD_Doc_Type,PCD_Date,PCD_Time,PCD_User_Dr,PCD_Base) VALUES (:PCLRowID,:ImgUrl,:ImgType,:CurDate,:CurTime,:CurUser,:PCDBase))
	q SQLCODE
}

/// w ##class(web.DHCEMFile).deleteUrl(98)
ClassMethod deleteUrl(ID)
{
	s Err=0
	
	s ChkRowId=$p(^DHCEMPCDO(ID),"^",1)
	s FileUrl=$p(^DHCEMPCDO(ID),"^",5)
	s OtherFileUrl=$p(FileUrl,"dhcnewpro",2)
	s:$e(OtherFileUrl,0,1)'="/" FileUrl="dhcnewpro/"_OtherFileUrl
	s:$e(OtherFileUrl,0,1)="/" FileUrl="dhcnewpro"_OtherFileUrl
	s Dir=$p(FileUrl,"/",1,$l(FileUrl,"/")-1)
	s FileName=$p(FileUrl,"/",$l(FileUrl,"/"),$l(FileUrl,"/"))
	s ChkLocId=$p($g(^DHCEMPCL(+ChkRowId)),"^",10)
	s LocHospId=$p($g(^CTLOC(+ChkLocId)),"^",22)
	ts
	
	s Err=##class(web.DHCEMFile).FTPDeleteFile(Dir,FileName,LocHospId)
	tro:Err'=0 
	q:Err'=0 Err
	
	&sql(DELETE DHC_EmPatChkDocu WHERE PCD_RowID=:ID)
	s Err=SQLCODE
	tro:Err'=0 
	q:Err'=0 "删除DHC_EmPatChkDocu失败,Code="_Err
	
	tc
	q SQLCODE
}

/// w ##class(web.DHCEMFile).GetUrlByPclID(82,1)
ClassMethod GetUrlByPclID(PCLID, Type, LgHospID)
{
	s Count=0
	s PCDID=""
 	f  s PCDID = $o(^DHCEMPCDO(0,"PCLID",PCLID,PCDID)) q:PCDID=""  d
 	.s PCDDate = $p(^DHCEMPCDO(PCDID),"^",2)
 	.s:PCDDate'="" PCDDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(PCDDate)
 	.s PCDTime = $p(^DHCEMPCDO(PCDID),"^",3)
 	.s:PCDTime'="" PCDTime = $zt(PCDTime,2)
 	.s Url = $p(^DHCEMPCDO(PCDID),"^",5)
 	.s FTPRELEASEURL=##Class(web.DHCEMComPar).GetAppPropValue("DHCEMCHK","FTPRELEASEURL",LgHospID,"","","")
 	.;s:$e(Url,$l(Url),$l(Url))'="/" Url=Url_"/"
 	.s Url=FTPRELEASEURL_"dhcnewpro"_$p(Url,"dhcnewpro",2)
 	.s:Url'["http" Url="http://"_Url
 	.s PCDFileName=$p(Url,"/",$l(Url,"/"))
 	.
 	.s DocType= $p(^DHCEMPCDO(PCDID),"^",6)
 	.s DocBase= $p(^DHCEMPCDO(PCDID),"^",7) //
 	.s:DocBase'="" Url=DocBase //
 	.s ImgDesc = PCDDate_" "_PCDTime_" "_PCDFileName
 	.q:(Type'="")&&(Type'=DocType)
 	.w $case(Count,0:"",:"$")
 	.w "<img modal='zoomImg' src='"_Url_"' height='150px' width='150px' alt='' index='"_Count_"'>"
 	.w "<p class='imgDesc' style='display:none;position:relative;top:-40px;left:10px'>"_ImgDesc _"</p>"
 	.s Count=Count+1 
 	q ""
}

/// w ##class(web.DHCEMFile).GetUploadList(1,20,12,1)
ClassMethod GetUploadList(page, rows, PCLID, Type)
{
	s Start=page-1*rows+1
	s End=page*rows
	
	s ListTitle = "PCDID^PCDDate^PCDTime^PCDUser^PCDType^PCDFileName"
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s Count=0
	s PCDID=""
 	f  s PCDID = $o(^DHCEMPCDO(0,"PCLID",PCLID,PCDID)) q:PCDID=""  d
 	.s PCDTypeDr= $p(^DHCEMPCDO(PCDID),"^",6)
 	.q:(Type'="")&&(Type'=PCDTypeDr)
 	.s PCDType=""
 	.s PCDType=$case(PCDTypeDr,1:"急救单",2:"救助单",3:"接警单",:"")
 	.s PCDType = ##class(websys.Translation).Get("dhcem.uploadify.csp",PCDType)
 	.s PCDDate = $p(^DHCEMPCDO(PCDID),"^",2)
 	.s:PCDDate'="" PCDDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(PCDDate)
 	.s PCDTime = $p(^DHCEMPCDO(PCDID),"^",3)
 	.s:PCDTime'="" PCDTime = $zt(PCDTime,2)
 	.s PCDUserDr = $p(^DHCEMPCDO(PCDID),"^",4)
 	.s PCDUser=""
 	.s:PCDUserDr'="" PCDUser=$p($g(^SSU("SSUSR",PCDUserDr)),"^",2)
 	.s PCDUser=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.SSUser","SSUSRName","",PCDUser)
 	.s PCDFileName= $p(^DHCEMPCDO(PCDID),"^",5)
 	.s PCDFileName=$p(PCDFileName,"/",$l(PCDFileName,"/"))
 	.s ListDate = PCDID_"^"_PCDDate_"^"_PCDTime_"^"_PCDUser_"^"_PCDType_"^"_PCDFileName
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
 	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListDate)
 	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
 	q ""
}

}
