Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCANCPDFConfig Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// Creator: YuanLin
/// CreatDate: 2018-01-12
/// Description: 获取FTP配置信息
/// d ##class(%ResultSet).RunQuery("web.DHCANCPDFConfig","FindPDFConfig","448")
Query FindPDFConfig() As %Query(ROWSPEC = "Id,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPHttpsPortNo")
{
}

ClassMethod FindPDFConfigExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	s FTPRowId="",FTPSrvIP="",FTPSrvPortNo="",FTPSrvUserName="",FTPSrvUserCode="",FTPFolderName="",FTPType="",FTPHttpsPortNo=""
	f  s FTPRowId=$O(^DHCANCPDFConfig(FTPRowId)) q:FTPRowId=""  d
	.s FTPSrvIP=$lg(^DHCANCPDFConfig(FTPRowId),1)
	.s FTPSrvPortNo=$lg(^DHCANCPDFConfig(FTPRowId),2)
	.s FTPSrvUserName=$lg(^DHCANCPDFConfig(FTPRowId),3)
	.s FTPSrvUserCode="******"     ;$lg(^DHCANCPDFConfig(FTPRowId),4)
	.s FTPFolderName=$lg(^DHCANCPDFConfig(FTPRowId),5)
	.s FTPType=$lg(^DHCANCPDFConfig(FTPRowId),6)
	.s FTPHttpsPortNo=$lg(^DHCANCPDFConfig(FTPRowId),7)
	.do OutRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(FTPRowId,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPHttpsPortNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPDFConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPDFConfigExecute ]
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

ClassMethod FindPDFConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPDFConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：  YuanLin
/// CreatDate：2018-01-12
/// Input：    服务器IP,端口号,用户名,密码,文件夹名,上传标记(A/I/PA/PO/PACU)
/// Function:  保存FTP服务器配置
/// w ##class(web.DHCANCPDFConfig).SaveFTPConfig("303","","","","","A")
ClassMethod SaveFTPConfig(FTPSrvIP As %String, FTPSrvPortNo As %String, FTPSrvUserName As %String, FTPSrvUserCode As %String, FTPFolderName As %String, FTPType As %String, FTPHttpsPortNo As %String) As %String
{
	s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleEncrypt(FTPSrvUserCode)  //明文密码加密保存 YuanLin 20210611
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s PLIST(2)=FTPSrvIP
	.s PLIST(3)=FTPSrvPortNo
	.s PLIST(4)=FTPSrvUserName
	.s PLIST(5)=FTPSrvUserCode
	.s PLIST(6)=FTPFolderName
	.s PLIST(7)=FTPType
	.s PLIST(8)=FTPHttpsPortNo
    .&sql(update SQLUSER.DHC_ANC_PDFConfig Values :PLIST() where FTP_Type=:FTPType)
    .s ret=SQLCODE
    e  d
	.s PLIST(2)=FTPSrvIP
	.s PLIST(3)=FTPSrvPortNo
	.s PLIST(4)=FTPSrvUserName
	.s PLIST(5)=FTPSrvUserCode
	.s PLIST(6)=FTPFolderName
	.s PLIST(7)=FTPType
	.s PLIST(8)=FTPHttpsPortNo
    .&sql(INSERT INTO SQLUSER.DHC_ANC_PDFConfig Values :PLIST())
    .s ret=SQLCODE
    q ret
}

/// Creator：  YuanLin
/// CreatDate：2018-01-12
/// Input：    系统号
/// Function:  删除FTP服务器配置
/// w ##class(web.DHCANCPDFConfig).DeleteFTPConfig(3)
ClassMethod DeleteFTPConfig(FTPRowId As %String) As %String
{
	s ret=0
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where ID=:FTPRowId)
	i SQLCODE=0 d
    .&sql(delete from SQLUSER.DHC_ANC_PDFConfig where ID=:FTPRowId)
    .s ret=SQLCODE
    q ret
}

/// Creator：  YuanLin
/// CreatDate：2021-06-08
/// Input：    FTP服务器IP，用户名
/// Function:  获取服务器密码
/// w ##class(web.DHCANCPDFConfig).GetPasswordDecrypt(3)
ClassMethod GetPasswordDecrypt(FTPIP As %String, FTPUserName As %String) As %String
{
	s Password=""
	&sql(select FTP_SrvUserCode into:Password from SQLUSER.DHC_ANC_PDFConfig where FTP_SrvIP =:FTPIP AND FTP_SrvUserName =:FTPUserName )
	s Password=##Class(web.Util.Encryption).SimpleDecrypt(Password)  //解密 YuanLin 20210611
    q Password
}

}
