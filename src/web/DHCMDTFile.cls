Import sqluser

Class web.DHCMDTFile Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// -100 未配置FTP服务器环境! 请移步侧菜单-消息管理-消息配置进行配置!
/// -101 FTP服务器IP未配置
/// -102 FTP服务器用户未配置
/// -103 FTP服务器密码未配置
/// -104 文件流为空
ClassMethod FTPUpload(FileStream As %CSP.BinaryStream, Dir As %String, FileName As %String = "", LgHospID = "")
{
	If 'FileStream Quit "-104"
	
	Set FTPIP=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPIP",LgHospID,"","","")
	Set FTPUSERNAME=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPUSERNAME",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPPASSWORD",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.Util.Encryption).SimpleDecrypt(FTPPASSWORD,"FTPPASSWORD")
	Set FTPPORT=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPPORT",LgHospID,"","","")
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
	s ^qqa = $lb(IP,UserName,Password,Port)
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
	q 1_"^http://"_##class(ext.util.String).Replace(IP_"/"_..#FTP2WEB_"/"_$tr(Dir,"\","/")_"/"_FileName,"//","/") 
	q 1
}

Parameter FTP2WEB = "imedicalftp";

/// ftp的名字
ClassMethod GetSaveImgName(CstID)
{
	s PatientID = $p(^DHCMDTCON(CstID),"^",26)
	s PatName = $p($g(^PAPER(PatientID,"ALL")),"^",1)
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
	&sql(INSERT INTO DHC_MDTPatChkDocu (MPCD_Chk_Dr,MPCD_DocuUrl,MPCD_Doc_Type,MPCD_Date,MPCD_Time,MPCD_User_Dr) VALUES (:PCLRowID,:ImgUrl,:ImgType,:CurDate,:CurTime,:CurUser))
	q SQLCODE
}

/// w ##class(web.DHCMDTFile).deleteUrl(112)
ClassMethod deleteUrl(ID)
{
	
	s Err=0
	
	s MdtID=$p(^DHCMDTPCD(ID),"^",1)
	s EpisodeID=$p(^DHCMDTCON(MdtID),"^",1)      /// 就诊ID
	s LocHospId = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	s FileUrl=$p(^DHCMDTPCD(ID),"^",5)
	s LastUrl = $p(FileUrl,"dhcnewpro",2)
	
	i FileUrl'="" {
		i $e(LastUrl,0,1)="/"{
			s FileUrl="dhcnewpro"_$p(FileUrl,"dhcnewpro",2)
		}else{
			s FileUrl="dhcnewpro/"_$p(FileUrl,"dhcnewpro",2)
		}
	}
	s Dir=$p(FileUrl,"/",1,$l(FileUrl,"/")-1)
	s FileName=$p(FileUrl,"/",$l(FileUrl,"/"),$l(FileUrl,"/"))
	
	s ^qqa("error") = $lb(Dir,FileName,LocHospId)
	ts
	
	s Err=##class(web.DHCMDTFile).FTPDeleteFile(Dir,FileName,LocHospId)
	tro:Err'=0 
	q:Err'=0 Err
	
	&sql(DELETE DHC_MDTPatChkDocu WHERE MPCD_RowID=:ID)
	s Err=SQLCODE
	tro:Err'=0 
	q:Err'=0 "删除DHC_EmPatChkDocu失败,Code="_Err
	
	tc
	q SQLCODE
}

/// w ##class(web.DHCEMFile).FTPDeleteFile("/dhcnewpro/patchecklev/202164/1","耳105.png",2)
ClassMethod FTPDeleteFile(Dir, FileName, LgHospID)
{
	Set FTPIP=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPIP",LgHospID,"","","")
	Set FTPUSERNAME=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPUSERNAME",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPPASSWORD",LgHospID,"","","")
	Set FTPPASSWORD=##Class(web.Util.Encryption).SimpleDecrypt(FTPPASSWORD,"FTPPASSWORD")
	Set FTPPORT=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPPORT",LgHospID,"","","")
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

/// w ##class(web.DHCEMFile).GetUrlByPclID(82,1)
ClassMethod GetUrlByPclID(PCLID, Type, LgHospID)
{
	s Count=0
	s PCDID=""
 	f  s PCDID = $o(^DHCMDTPCD(0,"PCLID",PCLID,PCDID)) q:PCDID=""  d
 	.s PCDDate = $p(^DHCMDTPCD(PCDID),"^",2)
 	.s:PCDDate'="" PCDDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(PCDDate)
 	.s PCDTime = $p(^DHCMDTPCD(PCDID),"^",3)
 	.s:PCDTime'="" PCDTime = $zt(PCDTime,2)
 	.s Url = $p(^DHCMDTPCD(PCDID),"^",5)
 	.s FTPRELEASEURL=##Class(web.DHCAppComPar).GetAppPropValue("DHCMDT","FTPRELEASEURL",LgHospID,"","","")
 	.;s:$e(Url,$l(Url),$l(Url))'="/" Url=Url_"/"
 	.s Url=FTPRELEASEURL_"dhcnewpro"_$p(Url,"dhcnewpro",2)
 	.s:Url'["http" Url="http://"_Url
 	.s PCDFileName=$p(Url,"/",$l(Url,"/"))
 	.
 	.s DocType= $p(^DHCMDTPCD(PCDID),"^",6)
 	.s ImgDesc = PCDDate_" "_PCDTime_" "_PCDFileName
 	.q:(Type'="")&&(Type'=DocType)
 	.w $case(Count,0:"",:"$")
 	.w "<img modal='zoomImg' src='"_Url_"' height='150px' alt='' index='"_Count_"'>"
 	.w "<p class='imgDesc' style='display:none;position:relative;top:-40px;left:10px'>"_ImgDesc _"</p>"
 	.s Count=Count+1 
 	q ""
}

/// w ##class(web.DHCEMFile).GetUploadList(1,20,12,1)
ClassMethod GetUploadList(page, rows, PCLID, Type)
{
	n (page, rows,PCLID,Type,%session)
	s Start=page-1*rows+1
	s End=page*rows
	
	s ListTitle = "MPCDID^MPCDDate^MPCDTime^MPCDUser^MPCDType^MPCDFileName"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s Count=0
	s MPCDID=""
 	f  s MPCDID = $o(^DHCMDTPCD(0,"PCLID",PCLID,MPCDID)) q:MPCDID=""  d
 	.s MPCDTypeDr= $p(^DHCMDTPCD(MPCDID),"^",6)
 	.q:(Type'="")&&(Type'=MPCDTypeDr)
 	.s MPCDType=""
 	.s MPCDType=$case(MPCDTypeDr,1:"检查",2:"检验",3:"其他",:"")
 	.s MPCDType=##class(websys.Translation).Get("dhcmdt.uploadify.csp",MPCDType)
 	.s MPCDDate = $p(^DHCMDTPCD(MPCDID),"^",2)
 	.s:MPCDDate'="" MPCDDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(MPCDDate)
 	.s MPCDTime = $p(^DHCMDTPCD(MPCDID),"^",3)
 	.s:MPCDTime'="" MPCDTime = $zt(MPCDTime,2)
 	.s MPCDUserDr = $p(^DHCMDTPCD(MPCDID),"^",4)
 	.s MPCDUser=""
 	.s:MPCDUserDr'="" MPCDUser=$p($g(^SSU("SSUSR",MPCDUserDr)),"^",2)
 	.s MPCDUser=##class(web.DHCMDTCom).GetTransDesc("User.SSUser","SSUSRName","",MPCDUser)  
 	.s MPCDFileName= $p(^DHCMDTPCD(MPCDID),"^",5)
 	.s MPCDFileName=$p(MPCDFileName,"/",$l(MPCDFileName,"/"))
 	.s ListDate = MPCDID_"^"_MPCDDate_"^"_MPCDTime_"^"_MPCDUser_"^"_MPCDType_"^"_MPCDFileName
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
 	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListDate)
 	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Count)
 	q ""
}

}
