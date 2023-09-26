Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCICUPdfBrowser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// Creator: YuanLin
/// CreatDate: 2018-01-07
/// Description: 获取病人相关信息
/// Table：DHC_ICU_OPArrange
/// d ##class(%ResultSet).RunQuery("web.DHCICUPdfBrowser","GetPatInfo","361")
Query GetPatInfo(EpisodeID As %String = "") As %Query(ROWSPEC = "tStartDateTime:%String,tEndDateTime:%String,tBedCode:%String,tWardDesc:%String,tPatName:%String,tRegNo:%String,tEpisodeID:%String,tMedCareNo:%String,tStatus:%String,tDiagDesc:%String,sex:%String,age:%String,tPatHeight:%String,tPatWeight:%String,icuaId:%String,icuBedId:%String,curWardId:%String")
{
}

ClassMethod GetPatInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
	Set repid=$INCREMENT(^CacheTemp)
	If $GET(ind)="" Set ind=1
	Set dateformatnum=##class(websys.Conversions).DateFormat()
    Quit:EpisodeID="" $$$OK
    Set icuaId=""
	For  Set icuaId=$ORDER(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) Quit:icuaId=""  Do
	.Quit:$DATA(^DHCANOPArrange(icuaId))<1
	.Set tStartDateTime="",tEndDateTime="",tRegNo="",tPatName="",tAdmLocDesc="",tStatus="",tBedCode="",tDiagDesc="",tWardDesc="",tPatHeight="",tPatWeight="",tMedCareNo="",tBodySquare="",icuBedId="",curWardId="",sex="",age=""
    .Set startDate=$PIECE($GET(^DHCICUArrange(icuaId)),"^",6)
	.Set startTime=+$PIECE($GET(^DHCICUArrange(icuaId)),"^",8)
	.Set endDate=$PIECE($GET(^DHCICUArrange(icuaId)),"^",7)
	.Set endTime=+$PIECE($GET(^DHCICUArrange(icuaId)),"^",9)
    .If (startDate'="")&&(startTime'="") Set tStartDateTime=$ZDATE(startDate,dateformatnum)_" "_$ZTIME(startTime)
	.If (endDate'="")&&(endTime'="") Set tEndDateTime=$ZDATE(endDate,dateformatnum)_" "_$ZTIME(endTime)
	.Set papmiId=$PIECE($GET(^PAADM(EpisodeID)),"^",1)
	.Set paadmtype=$PIECE($GET(^PAADM(EpisodeID)),"^",2)
	.Set tRegNo=$PIECE($GET(^PAPER(papmiId,"PAT",1)),"^",1)
	.Set tPatName=$PIECE($GET(^PAPER(papmiId,"ALL")),"^",1)
	.Set admLocId=+$PIECE($GET(^DHCICUArrange(icuaId)),"^",2)
	.If admLocId=0 Set admLocId=+$PIECE($GET(^PAADM(EpisodeID)),"^",4)
	.Set tAdmLocDesc=$PIECE(^CTLOC(admLocId),"^",2)
	.Set tStatus=$PIECE($GET(^DHCICUArrange(icuaId)),"^",18)
	.Set statusDesc=$SELECT(tStatus="R":"安排",tStatus="M":"监护",tStatus="T":"停止",1:"异常")
	.Set bedId=$PIECE($GET(^PAADM(EpisodeID)),"^",73)
	.If bedId'="" Set bedSub=$PIECE(bedId,"||",2)
	.Set icuBedId=$PIECE($GET(^DHCICUArrange(icuaId)),"^",4)
	.If icuBedId'="" Set icuBedSub=$PIECE(icuBedId,"||",2)
	.Set tBedCode=$PIECE($GET(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
	.If tBedCode="" Set tBedCode=$PIECE($GET(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	.Set tWardDesc=$PIECE($GET(^PAWARD(+bedId)),"^",2)
	.Set patHeight=$PIECE(^DHCICUArrange(icuaId),"^",24)
	.Set patWeight=$PIECE(^DHCICUArrange(icuaId),"^",25)
	.;s tMedCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID , .ErrMsg)
	.Set tMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.If (patHeight'="")&&(patWeight'="") Set tBodySquare=..Sqr((patHeight*patWeight)/3600)
	.Set age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	.Set sex=$PIECE($GET(^CT("SEX",$PIECE($GET(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.Set curWardId=$ORDER(^PAWARDA(0,"ADM",EpisodeID,""))
	.Set tDiagDesc=""
	.Set tDiagdr=$PIECE($GET(^DHCICUArrange(icuaId)),"^",20)
	.Set num=$LENGTH(tDiagdr,"|")
	.For k=1:1:num  Do
		..Set Diagdr=$PIECE(tDiagdr,"|",k)
		..Quit:Diagdr=""
		..If tDiagDesc="" Set tDiagDesc=$PIECE(^MRC("ID",Diagdr),"^",2)
		..e  Set tDiagDesc=tDiagDesc_";"_$PIECE(^MRC("ID",Diagdr),"^",2)
	.Set tmpList(+curWardId,0_tBedCode,EpisodeID_"."_+icuaId)=$LISTBUILD(tStartDateTime,tEndDateTime,tBedCode,tWardDesc,tPatName,tRegNo,EpisodeID,tMedCareNo,statusDesc,tDiagDesc,sex,age,tPatHeight,tPatWeight,icuaId,icuBedId,curWardId)
	Set tBedCode=0,curWardId=""
	For  Set curWardId=$ORDER(tmpList(curWardId)) Quit:curWardId=""  Do
	    .For  Set tBedCode=$ORDER(tmpList(curWardId,tBedCode)) Quit:tBedCode=""  Do 
		..Set icuaId=0
		..For  Set icuaId=$ORDER(tmpList(curWardId,tBedCode,icuaId)) Quit:icuaId=""  Do
			...Do OutputRow
	Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
OutputRow
	Set Data=tmpList(curWardId,tBedCode,icuaId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$ORDER(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	Set qHandle=$LISTBUILD(AtEnd,repid,ind)
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
/// Input：    就诊号 opaId
/// Function:  判断服务器上指定文件是否存在
/// w ##class(web.DHCICUPdfBrowser).CheckPDFIfExist("60","1","03/03/2021")
ClassMethod CheckPDFIfExist(EpisodeID As %String, icuaId As %String, date As %String) As %String
{
	Set existsFlag=""
	Quit:date="" "查看日期为空,请重新选择"
    Set dateformatnum=##class(websys.Conversions).DateFormat()
	Set date=$ZDATE($ZDATEH(date,dateformatnum),8)
	Set str=##class(%GlobalCharacterStream).%New()
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type="I")
	If SQLCODE=0 Do
	.Set FTPSrvIP=PLIST(2)
	.Set FTPSrvPortNo=PLIST(3)
	.Set FTPSrvUserName=PLIST(4)
	.Set FTPSrvUserCode=PLIST(5)
	.Set FTPFolderName=PLIST(6)
	.Set FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt(FTPSrvUserCode)  //解密 YuanLin 20210611
	.Set ftp=##class(%Net.FtpSession).%New()
	.Set ftp.SSLConfiguration="FTPS"
	.If 'ftp.Connect(FTPSrvIP,FTPSrvUserName,FTPSrvUserCode,FTPSrvPortNo) Set existsFlag="服务器连接失败"
	.If existsFlag'="服务器连接失败" Do 
	..Set fileName=EpisodeID_"/"_icuaId_date_".PDF"
	..;s fileName="/"_FTPFolderName_"/"_EpisodeID_"/"_icuaId_date_".PDF"
	..Set existsFlag=ftp.Retrieve(fileName,str)
	..;s existsFlag=ftp.Retrieve(fileName)
	e  Set existsFlag="FTP服务器信息未维护！"
	Quit existsFlag
}

/// Creator：  YuanLin
/// CreatDate：2018-01-12
/// Input：    就诊号 opaId
/// Function:  输出服务器上指定文件的存储路径
/// w ##class(web.DHCICUPdfBrowser).GetPDFUrl("468","1","15/1/2018")
ClassMethod GetPDFUrl(EpisodeID As %String, icuaId As %String, date As %String) As %String
{
	Set PDFUrl=""
	Quit:date="" "查看日期为空,请重新选择"
    Set dateformatnum=##class(websys.Conversions).DateFormat()
	Set date=$ZDATE($ZDATEH(date,dateformatnum),8)
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type="I")
	If SQLCODE=0 Do
	.Set FTPSrvIP=PLIST(2)
	.Set FTPSrvPortNo=PLIST(3)
	.Set FTPSrvUserName=PLIST(4)
	.Set FTPSrvUserCode=PLIST(5)
	.Set FTPFolderName=PLIST(6)
	.Set FTPHttpsPortNo=PLIST(8)
	.Set FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt(FTPSrvUserCode)  //解密 YuanLin 20210611
	.;s PDFUrl="ftp://"_FTPSrvUserName_":"_FTPSrvUserCode_"@"_FTPSrvIP_":"_FTPSrvPortNo_"/"_FTPFolderName_"/"_EpisodeID_"/"_icuaId_date_".PDF"
	.Set PDFUrl=FTPHttpsPortNo_"/"_FTPFolderName_"/"_EpisodeID_"/"_icuaId_date_".PDF"
	Quit PDFUrl
}

ClassMethod Sqr(Number As %String)
{
	Set res=$ZSQR(Number)
	Set res=$FNUMBER(res,"",3)
	Quit res
}

/// Creator：   YuanLin
/// CreatDate： 2019-07-18
/// Description:电子病案归档项目标准接口
/// Input：     就诊号 EpisodeID 文档日期 date (YYYY-MM-DD格式)
/// Function:   判断服务器上有无文档需要归档,没有返回空,有则返回路径,多个路径用"^"分割,其他则返回具体内容
/// w ##class(web.DHCICUPdfBrowser).GetICUPDFPath("361","2019-5-14")
ClassMethod GetICUPDFPath(EpisodeID As %String, date As %String) As %String
{
	Set existsFlag=""
	Set PDFURLStr="",PDFUrl=""
	Quit:date="" "日期不能为空!"
    //Set dateformatnum=##class(websys.Conversions).DateFormat()
	Set dateformatnum=3
	Set date=$ZDATE($ZDATEH(date,dateformatnum),8)
	Set str=##class(%GlobalCharacterStream).%New()
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type="I")
	If SQLCODE=0 Do
	.Set FTPSrvIP=PLIST(2)
	.Set FTPSrvPortNo=PLIST(3)
	.Set FTPSrvUserName=PLIST(4)
	.Set FTPSrvUserCode=PLIST(5)
	.Set FTPFolderName=PLIST(6)
	.Set FTPHttpsPortNo=PLIST(8)
	.Set FTPSrvUserCode=##Class(web.Util.Encryption).SimpleDecrypt(FTPSrvUserCode)  //解密 YuanLin 20210611
	.Set ftp=##class(%Net.FtpSession).%New()
	.Set ftp.SSLConfiguration="FTPS"
	.If 'ftp.Connect(FTPSrvIP,FTPSrvUserName,FTPSrvUserCode,FTPSrvPortNo) Set existsFlag="服务器连接失败"
	.If existsFlag'="服务器连接失败" Do
	..Set icuaId="" For  Set icuaId=$ORDER(^DHCICUArrange(0,"Adm",EpisodeID,icuaId)) Quit:icuaId=""  Do
	...Set fileName=EpisodeID_"/"_icuaId_date_".PDF"
	...Set existsFlag=ftp.Retrieve(fileName,str)
	...If existsFlag=1 Do
	....Set PDFUrl=FTPHttpsPortNo_"/"_FTPFolderName_"/"_EpisodeID_"/"_icuaId_date_".PDF"
	....If PDFURLStr="" Set PDFURLStr=PDFUrl
	....e  Set PDFURLStr=PDFURLStr_"^"_PDFUrl
	.e  Set PDFURLStr=existsFlag
	e  Do
	.Set existsFlag="FTP服务器信息未维护！"
	.Set PDFURLStr=existsFlag
	Quit PDFURLStr
}

/// d ##class(web.DHCICUPdfBrowser).FTPSTest()
ClassMethod FTPSTest() As %String
{
	Set ftp=##class(%Net.FtpSession).%New()
	Set ftp.SSLConfiguration="FTPS"
	Set ret=ftp.Connect("172.18.18.138","icuftp","ApdLwaR8","2121")
	Break ;3
	If 'ftp.Connect("172.18.18.138","icuftp","ApdLwaR8","2121") Quit "NoConnect"
	Write "Ftp server messsage:",!,ftp.ReturnMessage,!
	Set str=##class(%GlobalCharacterStream).%New()
	If 'ftp.Binary() Write "Can not swap to binary mode",! Quit
	Write "Mode now: ",ftp.Type,!
	If 'ftp.Retrieve("ADSSL.pfx",str) Write "Failed to get file",! Quit
	Write "Length of file received: ",str.Size,!
	If 'ftp.Logout() Write "Failed to logout",!
	Quit
}

}
