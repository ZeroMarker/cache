Import SQLUser

Class web.DHCADVFile Extends %RegisteredObject [ StorageStrategy = StorageSQL ]
{

/// -100 未配置FTP服务器环境! 请移步侧菜单-消息管理-消息配置进行配置!
/// -101 FTP服务器IP未配置
/// -102 FTP服务器用户未配置
/// -103 FTP服务器密码未配置
/// -104 文件流为空
///  w ##class(web.DHCADVFile).FTPUpload("3@%CSP.BinaryStream","/dhcAdvEvt/picture/202048/","4.jpg")
ClassMethod FTPUpload(FileStream As %CSP.BinaryStream, Dir As %String, FileName As %String = "")
{
	// 2021-06-03 cy 避免文件名重复 st
	S FileName=$tr(FileName,"——,-","_")  // 处理特殊字符
	S len=$L(FileName,".")
	s FileName=$p(FileName,".",1,len-1)_"("_$i(^DHCADVIMGNAME)_")."_$p(FileName,".",len)
	// ed
	If 'FileStream Quit "-104"
	Set RowID = $o(^DHCADVFTPC(0,"Code","DHCADV",""),-1)
	Quit:+RowID=0 "-1100"
	Set obj=##class(User.DHCAdvFTPConfig).%OpenId(RowID)
	IF (obj){
		Set IP = obj.FTPAddressIP 
		Quit:IP="" Quit -101
		Set UserName = obj.FTPUserName 
		Quit:UserName="" Quit -102
		Set Password = obj.FTPPassWord
		Set Password=##Class(web.DHCADVCOMMON).DeCode(Password) /// 2021-06-15 cy 密码 解密
		Quit:Password="" Quit -103
		Set Port = obj.FTPPort 
		if Port="" Set Port=21
		quit ..Upload(IP, UserName, Password, Port, FileStream, Dir, FileName)
	}else{
		Quit "-100"
	}
}

///  w ##class(web.DHCADVFile).Upload("172.19.19.57","administrator","ytKhnCsyeP9aa","8090","3@%CSP.BinaryStream","/dhcAdvEvt/picture/202048/","3.jpg")
ClassMethod Upload(IP, UserName, Password, Port, FileStream As %CSP.BinaryStream, Dir As %String, FileName = "")
{
	s ftp=##class(%Net.FtpSession).%New()
	Set ftp.SSLConfiguration="FTPS"   ;2021-05-27 cy 配置ftps访问
	d ftp.CommandTranslateTableSet("UTF8")  ;2021-06-03 cy 格式
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
	q 1_"^http://"_##class(ext.util.String).Replace(IP_"/"_..#FTP2WEB_"/"_$tr(Dir,"\","/")_"/"_FileName,"//","/")
	q 1
}

Parameter FTP2WEB = "imedicalftp";

/// ftp的名字
ClassMethod GetSaveImgName(PCLRowID)
{
	s PatientID =$P(^DHCEMPCL(PCLRowID),"^",1)
	s PatName = $p(^PAPER(PatientID,"ALL"),"^",1)
	q PatName_$i(^DHCADVIMGNAME)
}

/// w ##class(web.DHCADVFile).saveUrl("235^http://192.168.0.155/imedicalftp/dhcAdvEvt/picture/2020327/Hydrangeas.jpg^7795")
ClassMethod saveUrl(Params)
{
	s RecordId= $p(Params,"^",1)  //记录表ID
	s RepId=$o(^DHCADVMASTER(0,"FormRec",RecordId,""))
	s RepTypeDr=$p(^DHCADVMASTER(RepId),"^",2)
	s FileUrl = $p(Params,"^",2)   //
	s Filetype=$p(FileUrl,".",$l(FileUrl,"."))
	s CurUser = $p(Params,"^",3)
	s CurDate = +$h
	s CurTime = $p($h,",",2)	
	//s Filetype=$S(FileUrl]".doc":"doc",FileUrl]".docx":"doc",FileUrl]".pdf":"doc",FileUrl]".gif":"img",FileUrl]".jpg":"img",FileUrl]".png":"img",FileUrl]".jpeg":"img",1:"")
	
	s RowID = $o(^DHCADVFTPC(0,"Code","DHCADV",""),-1)
	Quit:+RowID=0 "-1100"
	s obj=##class(User.DHCAdvFTPConfig).%OpenId(RowID)
	IF (obj)
	{
		S IP = obj.FTPAddressIP 
		q:IP="" Quit -101
		S UserName = obj.FTPUserName 
		Q:UserName="" Quit -102
		S Password = obj.FTPPassWord
		S Password=##Class(web.DHCADVCOMMON).DeCode(Password) /// 2021-06-15 cy 密码 解密
		Q:Password="" Quit -103
		Set Port = obj.FTPPort 
	}
	s FileList="0"_"&&"_IP_"&&"_UserName_"&&"_Password
	&sql(INSERT INTO DHC_AdvAttachRec (ATTR_Rep_Dr,ATTR_RepType_Dr,ATTR_User_Dr,ATTR_Date,ATTR_Time,ATTR_FileName,ATTR_FileType,ATTR_FileList) VALUES (:RepId,:RepTypeDr,:CurUser,:CurDate,:CurTime,:FileUrl,:Filetype,:FileList))
	q SQLCODE
}

ClassMethod deleteUrl(ID)
{
	s Err=0
	
	s RepID=$p(^DHCADVATTR(ID),"^",1)
	s RepLocDr=$p(^DHCADVMASTER(+RepID),"^",7)
	s RepHospID=$p($g(^CTLOC(+RepLocDr)),"^",22) 	
	s FileUrl=""
 	s FileName= $p(^DHCADVATTR(ID),"^",7)
	s:FileName'="" FileUrl="dhcAdvEvt/"_$p(FileName,"dhcAdvEvt",2)
	s Dir=$p(FileUrl,"/",1,$l(FileUrl,"/")-1)
 	s FileName=$p(FileName,"/",$l(FileName,"/"))
	
	ts
	
	s Err=##class(web.DHCADVFile).FTPDeleteFile(Dir,FileName,RepHospID)
	tro:Err'=0 
	q:Err'=0 Err
	
	&sql(DELETE DHC_ADVAttachRec WHERE ATTR_RowID=:ID)
	s Err=SQLCODE
	tro:Err'=0 
	q:Err'=0 "删除DHC_AdvAttachRec失败,Code="_Err
	
	tc
	q SQLCODE
}

/// w ##class(web.DHCADVFile).GetUrlByRedID(235)
ClassMethod GetUrlByRedID(recordId, LgHospID)
{
	s Count=0
	s RepId=$o(^DHCADVMASTER(0,"FormRec",recordId,""))
	s RepTypeDr=$p(^DHCADVMASTER(RepId),"^",2)
	s ATTRID=""
 	f  s ATTRID = $o(^DHCADVATTR(0,"RepIdType",RepId,RepTypeDr,ATTRID)) q:ATTRID=""  d
 	.s ATTRDate = $p(^DHCADVATTR(ATTRID),"^",5)
 	.s:ATTRDate'="" ATTRDate = ##class(web.DHCADVCOMMON).DateLogicalToHtml(ATTRDate)
 	.s ATTRTime = $p(^DHCADVATTR(ATTRID),"^",6)
 	.s:ATTRTime'="" ATTRTime = $zt(ATTRTime,2)
 	.s Url = $p(^DHCADVATTR(ATTRID),"^",7)
 	.s FTPRELEASEURL=##Class(web.DHCADVCOMMON).GetEmSysConfig("FTPRELEASEURL","^^^"_LgHospID)
 	.s Url=FTPRELEASEURL_"dhcAdvEvt"_$p(Url,"dhcAdvEvt",2)
 	.s:Url'["http" Url="http://"_Url
 	.s ATTRFileName=$p(Url,"/",$l(Url,"/"))
 	.s ImgDesc = ATTRDate_" "_ATTRTime_" "_ATTRFileName
 	.;q:(Type'="")&&(Type'=DocType)
 	.w $case(Count,0:"",:"$")
 	.w "<img modal='zoomImg' src='"_Url_"' height='150px' alt='' index='"_Count_"'>"
 	.w "<p class='imgDesc' style='display:none;position:relative;top:-40px;left:10px'>"_ImgDesc _"</p>"
 	.s Count=Count+1 
 	q ""
}

/// w ##class(web.DHCADVFile).GetUploadList(1,20,12,1)
ClassMethod GetUploadList(page, rows, RecordId, LgHospID)
{
	n (%session)
	s Start=page-1*rows+1
	s End=page*rows
	s RepId=$o(^DHCADVMASTER(0,"FormRec",RecordId,""))
	s RepTypeDr=$p(^DHCADVMASTER(RepId),"^",2)
	s ListTitle = "ATTRID^ATTRDate^ATTRTime^ATTRUser^ATTRFileName^FileUrl"
	w ##class(web.DHCADVJSONCOMMON).getJsonStartNoTotal() //输出json前缀串
	s Count=0
	s ATTRID=""
 	f  s ATTRID = $o(^DHCADVATTR(0,"RepIdType",RepId,RepTypeDr,ATTRID)) q:ATTRID=""  d
    .s ATTRUser=""
 	.s ATTRDate = $p(^DHCADVATTR(ATTRID),"^",5)
 	.s:ATTRDate'="" ATTRDate = ##class(web.DHCADVCOMMON).DateLogicalToHtml(ATTRDate)
 	.s ATTRTime = $p(^DHCADVATTR(ATTRID),"^",6)
 	.s:ATTRTime'="" ATTRTime = $zt(ATTRTime,2)
 	.s ATTRUserDr = $p(^DHCADVATTR(ATTRID),"^",4)
 	.s:ATTRUserDr'="" ATTRUser=$p($g(^SSU("SSUSR",ATTRUserDr)),"^",2)
	.S ATTRUser=##class(web.DHCADVCOMMON).GetTransDesc("User.SSUser","SSUSRName","",ATTRUser)
 	.s ATTRFileName= $p(^DHCADVATTR(ATTRID),"^",7)
 	.s FTPRELEASEURL=##Class(web.DHCADVCOMMON).GetEmSysConfig("FTPRELEASEURL","^^^"_LgHospID)
 	.s FileUrl=FTPRELEASEURL_"dhcAdvEvt"_$p(ATTRFileName,"dhcAdvEvt",2)
 	.s:FileUrl'["http" FileUrl="http://"_FileUrl
	.s ATTRFileName=$p(ATTRFileName,"/",$l(ATTRFileName,"/"))
 	.s ListDate = ATTRID_"^"_ATTRDate_"^"_ATTRTime_"^"_ATTRUser_"^"_ATTRFileName_"^"_FileUrl
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
 	.w ##class(web.DHCADVJSONCOMMON).getJsonData(ListTitle,ListDate)
 	w ##class(web.DHCADVJSONCOMMON).getJsonEndConTotal(Count)
 	q ""
}

/// w ##class(web.DHCADVFile).ChkRepUpload(1,87||1)
ClassMethod ChkRepUpload(RepId, RepTypeDr)
{
	S Flag=0
	Q:RepId="" Flag
	Q:RepTypeDr="" Flag
	S:$D(^DHCADVATTR(0,"RepIdType",RepId,RepTypeDr)) Flag=1
	Q Flag
}

/// w ##class(web.DHCADVFile).FTPDeleteFile()
ClassMethod FTPDeleteFile(Dir, FileName, LgHospID)
{
	Set RowID = $o(^DHCADVFTPC(0,"Code","DHCADV",""),-1)
	Quit:+RowID=0 "-1100"
	Set obj=##class(User.DHCAdvFTPConfig).%OpenId(RowID)
	IF (obj){
		Set IP = obj.FTPAddressIP 
		Quit:IP="" Quit -201
		Set UserName = obj.FTPUserName 
		Quit:UserName="" Quit -202
		Set Password = obj.FTPPassWord
		Set Password=##Class(web.DHCADVCOMMON).DeCode(Password) /// 密码 解密
		Quit:Password="" Quit -203
		Set Port = obj.FTPPort 
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
	}else{
		Quit "-200"
	}
	q 0
}

}
