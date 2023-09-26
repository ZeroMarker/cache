/// FTPPDF上传服务器配置业务类
Class web.DHCBPPDFConfig Extends %RegisteredObject
{

ClassMethod InsertFTP(data As %String) As %String
{
	set result=""
	quit:data="" "数据为空"
	set obj=##class(User.DHCBPPDFConfig).%New()
	set obj.FTPSrvIP=$piece(data,"^",1)
	set obj.FTPSrvPortNo=$piece(data,"^",2)
	set obj.FTPSrvUserName=$piece(data,"^",3)
	i ($piece(data,"^",4)'="") s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleEncrypt($piece(data,"^",4))  //明文密码加密保存 mfc 20211202
	e  s FTPSrvUserCode=""
	set obj.FTPSrvUserCode=FTPSrvUserCode
	set obj.FTPFolderName=$piece(data,"^",5)
	set obj.FTPType=$piece(data,"^",6)
	set obj.FTPLocalPath=$piece(data,"^",7)
	set obj.FTPActive=$piece(data,"^",8)
	set obj.FTPHttpsPortNo=$piece(data,"^",9)
	set sc=obj.%Save()
	if ($$$ISOK(sc))
	{
		set result=0	
	}
	else
	{
		set result="E^保存失败"_$System.Status.GetErrorText(sc)	
	}
	quit result
}

ClassMethod UpdateFTP(bppId As %String, data As %String) As %String
{
	set result=""
	
	quit:bppId="" "bppId为空"
	quit:data="" "data为空"
	set obj=##class(User.DHCBPPDFConfig).%OpenId(bppId)
	quit:obj="" "E^该对象不存在"
	set:($piece(data,"^",1)'="") obj.FTPSrvIP=$piece(data,"^",1)
	set:($piece(data,"^",2)'="") obj.FTPSrvPortNo=$piece(data,"^",2)
	set:($piece(data,"^",3)'="") obj.FTPSrvUserName=$piece(data,"^",3)
	i ($piece(data,"^",4)'="") s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleEncrypt($piece(data,"^",4))  //明文密码加密保存 mfc 20211202
	e  s FTPSrvUserCode=""
	set:($piece(data,"^",4)'="") obj.FTPSrvUserCode=FTPSrvUserCode
	set:($piece(data,"^",5)'="") obj.FTPFolderName=$piece(data,"^",5)
	set:($piece(data,"^",6)'="") obj.FTPType=$piece(data,"^",6)
	set:($piece(data,"^",7)'="") obj.FTPLocalPath=$piece(data,"^",7)
	set:($piece(data,"^",8)'="") obj.FTPActive=$piece(data,"^",8)
	set:($piece(data,"^",9)'="") obj.FTPHttpsPortNo=$piece(data,"^",9)
	set sc=obj.%Save()
	if ($$$ISOK(sc))
	{
		set result=0	
	}
	else
	{
		set result="E^修改失败"_$System.Status.GetErrorText(sc)	
	}
	quit result
}

ClassMethod DelFTP(bppId As %String) As %String
{
	set result=""
	quit:bppId="" "bppId为空"

	quit:'##class(User.DHCBPPDFConfig).%ExistsId(bppId) "E^该对象不存在"	
	set sc=##class(User.DHCBPPDFConfig).%DeleteId(bppId)
	if ($$$ISOK(sc))
	{
		set result=0
	}
	else
	{
		set result="E^删除失败"_$System.Status.GetErrorText(sc)	
	}

	quit result
}

/*
Query FindFTPList(bppId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT 	 BPP_RowId As BPPID,
			 FTP_SrvIP As FTPSrvIP,
			 FTP_SrvPortNo As FTPSrvPortNo,
			 FTP_SrvUserName As FTPSrvUserName,
			 FTP_SrvUserCode As FTPSrvUserCode,			 
			 FTP_FolderName As FTPFolderName,
			 FTP_Type As FTPType,
			 FTP_LocalPath As FTPLocalPath,
			 FTP_Active As FTPActive,
			 CASE WHEN (FTP_Active="Y") THEN '是' ELSE '否' END As FTPActiveDesc
	FROM SQLUser.DHC_BP_PDFConfig 
	WHERE (BPP_RowId=:bppId) or (:bppId is null)
}
*/
Query FindFTPList(bppId As %String = "") As %Query(ROWSPEC = "BPPID,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPActive,FTPActiveDesc,FTPLocalPath,FTPHttpsPortNo")
{
}

ClassMethod FindFTPListExecute(ByRef qHandle As %Binary, bppId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s BPPID=""
	s FTPSrvIP="",FTPSrvPortNo="",FTPSrvUserName="",FTPSrvUserCode="",FTPFolderName="",FTPType="",FTPActive="",FTPActiveDesc="",FTPLocalPath="",FTPHttpsPortNo=""
	f  s BPPID=$O(^DHCBPPDFConfig(BPPID)) q:BPPID=""  d
	.q:(bppId'="")&&(bppId'=BPPID)
	.s FTPSrvIP=$li($g(^DHCBPPDFConfig(BPPID)),1)
	.s FTPSrvPortNo=$li($g(^DHCBPPDFConfig(BPPID)),2)
	.s FTPSrvUserName=$li($g(^DHCBPPDFConfig(BPPID)),3)
	.s FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt($li($g(^DHCBPPDFConfig(BPPID)),4))  //解密 mfc 20211202
	.s FTPFolderName=$li($g(^DHCBPPDFConfig(BPPID)),5)
	.s FTPType=$li($g(^DHCBPPDFConfig(BPPID)),6)
	.s FTPActive=$li($g(^DHCBPPDFConfig(BPPID)),7)
	.i FTPActive="Y" s FTPActiveDesc="是"
	.e  s FTPActiveDesc="否"
	.s FTPLocalPath=$li($g(^DHCBPPDFConfig(BPPID)),8)
	.s FTPHttpsPortNo=$li($g(^DHCBPPDFConfig(BPPID)),9)
	.do OutRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(BPPID,FTPSrvIP,FTPSrvPortNo,FTPSrvUserName,FTPSrvUserCode,FTPFolderName,FTPType,FTPActive,FTPActiveDesc,FTPLocalPath,FTPHttpsPortNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFTPListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFTPListExecute ]
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

ClassMethod FindFTPListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFTPListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
