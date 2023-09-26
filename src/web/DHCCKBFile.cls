Import SQLUser

Class web.DHCCKBFile Extends %RegisteredObject [ StorageStrategy = StorageSQL ]
{

/// -100 未配置FTP服务器环境! 请移步侧菜单-消息管理-消息配置进行配置!
/// -101 FTP服务器IP未配置
/// -102 FTP服务器用户未配置
/// -103 FTP服务器密码未配置
/// -104 文件流为空
///  w ##class(web.DHCADVFile).FTPUpload("3@%CSP.BinaryStream","/dhcAdvEvt/picture/202048/","4.jpg")
ClassMethod FTPUpload(FileStream As %CSP.BinaryStream, Dir As %String, FileName As %String = "")
{
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
		Quit:Password="" Quit -103
		Set Port = obj.FTPPort 
		if Port="" Set Port=21
		b ;1
		quit ..Upload(IP, UserName, Password, Port, FileStream, Dir, FileName)
	}else{
		Quit "-100"
	}
}

///  w ##class(web.DHCADVFile).Upload("172.19.19.57","administrator","ytKhnCsyeP9aa","8090","3@%CSP.BinaryStream","/dhcAdvEvt/picture/202048/","3.jpg")
ClassMethod Upload(IP, UserName, Password, Port, FileStream As %CSP.BinaryStream, Dir As %String, FileName = "")
{
	s ftp=##class(%Net.FtpSession).%New()
	d ftp.CommandTranslateTableSet("GB18030")
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
	q PatName_$i(^DHCEMIMGNAME)
}

/// w ##class(web.DHCADVFile).saveUrl("235^http://192.168.0.155/imedicalftp/dhcAdvEvt/picture/2020327/Hydrangeas.jpg^7795")
ClassMethod saveUrl(Params)
{
	q ""
	s RecordId= $p(Params,"^",1)  //记录表ID
	s RepId=$o(^DHCADVMASTER(0,"FormRec",RecordId,""))
	s RepTypeDr=$p(^DHCADVMASTER(RepId),"^",2)
	s ImgUrl = $p(Params,"^",2)   //
	s CurUser = $p(Params,"^",3)
	s CurDate = +$h
	s CurTime = $p($h,",",2)
	s Filetype="img"
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
		Q:Password="" Quit -103
		Set Port = obj.FTPPort 
	}
	s FileList="0"_"&&"_IP_"&&"_UserName_"&&"_Password
	&sql(INSERT INTO DHC_AdvAttachRec (ATTR_Rep_Dr,ATTR_RepType_Dr,ATTR_User_Dr,ATTR_Date,ATTR_Time,ATTR_FileName,ATTR_FileType,ATTR_FileList) VALUES (:RepId,:RepTypeDr,:CurUser,:CurDate,:CurTime,:ImgUrl,:Filetype,:FileList))
	q SQLCODE
}

ClassMethod deleteUrl(ID)
{
	//&sql(DELETE DHC_ADVAttachRec WHERE ATTR_RowID=:ID)
	//q SQLCODE
}

/// w ##class(web.DHCADVFile).GetUrlByRedID(235)
ClassMethod GetUrlByRedID(recordId)
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
 	.s FTPPORT=18080			//##Class(web.DHCAppComPar).GetAppPropValue("DHCEMCHK","FTPPORT",LgHospID,"","","") //hxy 2020-04-16
	.i FTPPORT'="" d
	..s FTPPORT=$p(Url,"/",3)_":"_FTPPORT
	..s Url=$replace(Url,$p(Url,"/",3),FTPPORT) //ed
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
ClassMethod GetUploadList(page, rows, RecordId)
{
	s Start=page-1*rows+1
	s End=page*rows
	s RepId=$o(^DHCADVMASTER(0,"FormRec",RecordId,""))
	s RepTypeDr=$p(^DHCADVMASTER(RepId),"^",2)
	s ListTitle = "ATTRID^ATTRDate^ATTRTime^ATTRUser^ATTRFileName"
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
 	.s ATTRFileName= $p(^DHCADVATTR(ATTRID),"^",7)
 	.s ATTRFileName=$p(ATTRFileName,"/",$l(ATTRFileName,"/"))
 	.s ListDate = ATTRID_"^"_ATTRDate_"^"_ATTRTime_"^"_ATTRUser_"^"_ATTRFileName
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

}
