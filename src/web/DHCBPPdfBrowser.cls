Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCBPPdfBrowser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Parameter BUILD = 1060;
/// Creator: mfc
/// CreatDate: 2019-05-16
/// Description: 获取病人相关信息及其透析记录
/// d ##class(%ResultSet).RunQuery("web.DHCBPPdfBrowser","GetPatInfo","26796888")
Query GetPatInfo(EpisodeID As %String = "") As %Query(ROWSPEC = "EpisodeID,medCareNo,PatientID,bpaId,regNo,patName,patSex,patAge,bpPatType,bpaDate,bpaDaySeqNo,bpaBPCBedDesc,bpaStatus,bpaEquipDesc,bpaBPCBPModeDesc,PAADMMainMRADMDR,admDept")
{
}

ClassMethod GetPatInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    //s dateformatnum=##class(websys.Conversions).DateFormat()
    q:EpisodeID="" $$$OK
    
    s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s bpprId=""
	f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d
		.s bpprStatus=$lg(^DHCBPPatRegister(bpprId),14)
		.q:bpprStatus=""
		.i bpprStatus="N" s bpprStatus="正常"
		.i bpprStatus="D" s bpprStatus="转归"
		.s PatientID=+$g(^PAADM(+EpisodeID))	
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
		.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
		.s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
		.s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
		.i patBirth'="" s patBirth=$zd(patBirth,3)	
		.s patAge=##class(web.DHCClinicCom).CalAge($zdh(patBirth,3),+$h)
		.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22) //20200515统一走病案接口
		.s paadmtype=$p($g(^PAADM(+EpisodeID)),"^",2)
		.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(+EpisodeID,paadmtype,.ErrMsg)
		.s bpPatType=$lg(^DHCBPPatRegister(bpprId),25)
		.i bpPatType="N" s bpPatType="常规"
		.i bpPatType="T" s bpPatType="临时"
		.s PAADMMainMRADMDR=$p($g(^PAADM(EpisodeID)),"^",61) 
		.s admDeptId=$p($g(^PAADM(EpisodeID)),"^",4)
		.s admDept=$p($g(^CTLOC(admDeptId)),"^",2)
		.s bpaId=""
		.f  s bpaId=$o(^DHCBPArrange(0,"PatRegister",bpprId,bpaId)) q:bpaId=""  d
			..q:($lg(^DHCBPArrange(bpaId),9)'="F")
			
			..s bpaDate=$lg(^DHCBPArrange(bpaId),4)
			..s bpaTime=$lg(^DHCBPArrange(bpaId),5)
			..i bpaDate'="" d
			...s bpaDate=##class(web.DHCClinicCom).ConvertToDate(bpaDate)
			..i bpaTime'="" d
			...s bpaTime=##class(web.DHCClinicCom).ConvertToTime(bpaTime)	
			..s bpaDaySeqNo=""
			..s bpaDaySeqNo=$lg(^DHCBPArrange(bpaId),6)	
			..i bpaDaySeqNo="A" s bpaDaySeqNo="上午"	
			..i bpaDaySeqNo="P" s bpaDaySeqNo="下午"
			..i bpaDaySeqNo="E" s bpaDaySeqNo="晚上"
			..s bpaBPCBedDr=$lg(^DHCBPArrange(bpaId),7)			
			..s bpaBPCBedDesc=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),2)
			..s bpcBedGroupDr=$lg($g(^DHCBPC("Bed",+bpaBPCBedDr)),3)
			..s bpcBedGroupDesc=$lg($g(^DHCBPC("BedGroup",+bpcBedGroupDr)),2)
			..s bpaStatus=$lg(^DHCBPArrange(bpaId),9)
			..i bpaStatus="F" s bpaStatus="完成"
			..i bpaStatus="M" s bpaStatus="上机"	
			..i bpaStatus="R" s bpaStatus="安排"
			..s bpaEquipDr=$lg(^DHCBPArrange(bpaId),25) //净化设备
			..s bpaEquipDesc=$lg($g(^DHCBPC("Equip",+bpaEquipDr)),3)
			..s bpaBPCBPModeDr=$lg(^DHCBPArrange(bpaId),26)
			..s bpaBPCBPModeDesc=$lg($g(^DHCBPC("BloodPurificationMode",+bpaBPCBPModeDr)),2)
				
			..do OutRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(EpisodeID,medCareNo,PatientID,bpaId,regNo,patName,patSex,patAge,bpPatType,bpaDate,bpaDaySeqNo,bpaBPCBedDesc,bpaStatus,bpaEquipDesc,bpaBPCBPModeDesc,PAADMMainMRADMDR,admDept)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：  YuanLin
/// CreatDate：2018-01-10
/// Input：    就诊号 bpaId
/// Function:  判断服务器上指定文件是否存在
/// w ##class(web.DHCBPPdfBrowser).CheckPDFIfExist("BP","26830350","110049")
ClassMethod CheckPDFIfExist(FTPType As %String, EpisodeID As %String, bpaId As %String) As %String
{
	q:FTPType="" 0
	s existsFlag=""
	s str=##class(%GlobalCharacterStream).%New()
	&sql(select * into :PLIST() from SQLUSER.DHC_BP_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s FTPSrvIP=PLIST(2)
	.s FTPSrvPortNo=PLIST(3)
	.s FTPSrvUserName=PLIST(4)
	.s FTPSrvUserCode=PLIST(5)
	.s FTPFolderName=PLIST(6)
	.;w FTPSrvIP_"/"_FTPSrvUserName_"/"_FTPSrvUserCode_"/"_FTPSrvPortNo,!
	.s regNo=##class(web.DHCClinicCom).GetRegNobyEpisodeID(EpisodeID)
	.s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt(FTPSrvUserCode)  //解密 mfc 20211202
	.s ftp=##class(%Net.FtpSession).%New()
	.s ftp.SSLConfiguration="FTPS"
	.i 'ftp.Connect(FTPSrvIP,FTPSrvUserName,FTPSrvUserCode,FTPSrvPortNo) s existsFlag="服务器连接失败"
	.i existsFlag'="服务器连接失败" d 
	..s fileName="/"_FTPFolderName_"/"_regNo_"/"_bpaId_".PDF"
	..s fileName=regNo_"/"_bpaId_".PDF"
	..s existsFlag=ftp.Retrieve(fileName,str)
	..;w existsFlag,!
	..;w fileName_"/"_existsFlag,!
	e  s existsFlag="FTP服务器信息未维护！"
	q existsFlag
}

/// Creator：  YuanLin
/// CreatDate：2018-01-12
/// Input：    FTPType: BP(血透)，EpisodeID：就诊号，透析记录Id：bpaId, 登记号：regNo
/// Function:  透析记录单ftp服务器上指定文件的链接地址(存储路径)
/// return：https://172.18.18.150:1443/dhccftp/bpftp/0000000156/1270.PDF，其中FTPHttpsPortNo是获取ftps时htts端口号
/// w ##class(web.DHCBPPdfBrowser).GetPDFUrl("BP","","1270","")
ClassMethod GetPDFUrl(FTPType As %String, EpisodeID As %String = "", bpaId As %String, regNo As %String = "") As %String
{
	q:bpaId="" "bpaId透析记录Id不能为空"
	s PDFUrl=""
	i FTPType="" s FTPType="BP"	
	&sql(select * into :PLIST() from SQLUSER.DHC_BP_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s FTPSrvIP=PLIST(2)
	.s FTPSrvPortNo=PLIST(3)
	.s FTPSrvUserName=PLIST(4)
	.s FTPSrvUserCode=PLIST(5)
	.s FTPFolderName=PLIST(6)
	.s FTPHttpsPortNo=PLIST(10)
	.i EpisodeID'="" s regNo=##class(web.DHCClinicCom).GetRegNobyEpisodeID(EpisodeID)
	.i regNo="" d
		..s bpprId=$lg(^DHCBPArrange(bpaId),1)
		..s papmiId=$lg(^DHCBPPatRegister(bpprId),1)
		..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt(FTPSrvUserCode)  //解密 mfc 20211202
	.//s PDFUrl="ftp://"_FTPSrvUserName_":"_FTPSrvUserCode_"@"_FTPSrvIP_":"_FTPSrvPortNo_"/"_FTPFolderName_"/"_regNo_"/"_bpaId_".PDF"
	.//s PDFUrl="https://"_FTPSrvIP_":"_FTPHttpsPortNo_"/"_"dhccftp"_"/"_FTPFolderName_"/"_regNo_"/"_bpaId_".PDF"
	.s PDFUrl= FTPHttpsPortNo_"/"_FTPFolderName_"/"_regNo_"/"_bpaId_".PDF"
	q PDFUrl
}

/*
/// Creator：  mfc
/// CreatDate：2019-5-14
/// Input：    FTP上传文件类型 FTPType
/// Function:  获取FTP配置文件
/// d ##class(%ResultSet).RunQuery("web.DHCBPPdfBrowser","FindBPFTPConfig","BP")
Query FindBPFTPConfig(FTPType As %String = "") As %SQLQuery(CONTAINID = 1)
{
	SELECT BPP_RowId As FTPRowId,
	FTP_SrvIP As FTPSrvIP,
	FTP_SrvPortNo As FTPSrvPortNo,
	FTP_SrvUserName As FTPSrvUserName,
	FTP_SrvUserCode As FTPSrvUserCode,
	FTP_FolderName As FTPFolderName,
	FTP_Type As FTPType,	
	FTP_Active As FTPActive,
	FTP_LocalPath As FTPLocalPath
	from SQLUSER.DHC_BP_PDFConfig  where FTP_Type=:FTPType and FTP_Active='Y'
}
*/
/// Creator：  mfc
/// CreatDate：2021-12-02
/// Input：    FTP上传文件类型 FTPType
/// Function:  获取FTP配置文件
/// d ##class(%ResultSet).RunQuery("web.DHCBPPdfBrowser","FindBPFTPConfig","BP")
Query FindBPFTPConfig(ftpType As %String = "") As %Query(ROWSPEC = "FTPRowId,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPActive,FTPLocalPath")
{
}

ClassMethod FindBPFTPConfigExecute(ByRef qHandle As %Binary, ftpType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s FTPRowId=""
	s FTPSrvIP="",FTPSrvPortNo="",FTPSrvUserName="",FTPSrvUserCode="",FTPFolderName="",FTPType="",FTPActive="",FTPLocalPath=""
	f  s FTPRowId=$O(^DHCBPPDFConfig(FTPRowId)) q:FTPRowId=""  d
	.s FTPSrvIP=$li(^DHCBPPDFConfig(FTPRowId),1)
	.s FTPSrvPortNo=$li(^DHCBPPDFConfig(FTPRowId),2)
	.s FTPSrvUserName=$li(^DHCBPPDFConfig(FTPRowId),3)
	.s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt($li(^DHCBPPDFConfig(FTPRowId),4))  //解密 mfc 20211202
	.s FTPFolderName=$li(^DHCBPPDFConfig(FTPRowId),5)
	.s FTPType=$li(^DHCBPPDFConfig(FTPRowId),6)
	.q:(ftpType'="")&&(ftpType'=FTPType)
	.s FTPActive=$li(^DHCBPPDFConfig(FTPRowId),7)
	.q:FTPActive'="Y"
	.s FTPLocalPath=$li(^DHCBPPDFConfig(FTPRowId),8)
	.do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(FTPRowId,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPActive,FTPLocalPath)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPFTPConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPFTPConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPFTPConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPFTPConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
