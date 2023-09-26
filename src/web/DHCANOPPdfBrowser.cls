Import SQLUser

Include webimport

IncludeGenerator webimport

Class web.DHCANOPPdfBrowser Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1060;

/// Creator: YuanLin
/// CreatDate: 2018-01-07
/// Description: 获取病人相关信息
/// Table：DHC_AN_OPArrange\OR_Anaest_Operation\OR_Anaesthesia
/// d ##class(%ResultSet).RunQuery("web.DHCANOPPdfBrowser","GetPatInfo","448")
Query GetPatInfo(EpisodeID As %String = "") As %Query(ROWSPEC = "status,jzstat,oproom,regno,patname,sex,age,opname,opdoc,loc,anmethod,andoc,opaId,adm,opdatestr,medCareNo,PatientID,PAADMMainMRADMDR,AnaesthesiaID")
{
}

ClassMethod GetPatInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s dateformatnum=##class(websys.Conversions).DateFormat()
    q:EpisodeID="" $$$OK
    s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s status="",jzstat="",oproom="",regno="",patname="",sex="",age="",opname="",opdoc="",loc="",anmethod="",andoc="",opdatestr="",medCareNo="",PatientID="",PAADMMainMRADMDR="",AnaesthesiaID=""
	.s AnaesthesiaID=$P($G(^DHCANOPArrange(opaId)),"^",2)
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s opdate=$ZD($P(^DHCANOPArrange(opaId),"^",14),4)
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
	.s openddate=$P(^DHCANOPArrange(opaId),"^",16)
	.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	.i openddate<=opstdate s openddate=""
	.i openddate'=""  s openddate=$ZD(openddate,dateformatnum)_" "
	.i opendtime'=""  s opendtime=$ZT(opendtime,2)
	.i opsttime'=""  s opsttime=$ZT(opsttime,2)
	.s opdatestr=$ZD(opstdate,dateformatnum)_" "_opsttime_"~"_openddate_opendtime
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	.i oproomdr'="" s oproom=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:opaStatus="S"
	.q:opaStatus="N"
	.q:opaStatus=""
	.i opaStatus="A" s status="申请"
	.i opaStatus="D" s status="拒绝"
	.i opaStatus="R" s status="安排"
	.i opaStatus="N" s status="非预约"
	.i opaStatus="I" s status="术中"
	.i opaStatus="P" s status="恢复室"
	.i opaStatus="L" s status="术毕"
	.i opaStatus="F" s status="完成"
	.i opaStatus="C" s status="取消"
	.q:opaStatus="C"
	.s jz=$P(^OR(EpisodeID,"ANA",chl),"^",32)
	.i jz="E" s jzstat="急诊"
	.e  s jzstat="择期"
	.s PAADMMainMRADMDR=$p($g(^PAADM(EpisodeID)),"^",61) 
	.s PatientID=+$g(^PAADM(+EpisodeID))
	.s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	.s regno=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	.s patname=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s paadmtype=$p($g(^PAADM(+EpisodeID)),"^",2)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	.s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
	.q:admLocId=""
	.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	.i +appLocId=0 s appLocId=admLocId
	.s loc=$P($g(^CTLOC(appLocId)),"^",2)
	.s mzdr=$P(^OR(EpisodeID,"ANA",chl),"^",6)
	.i mzdr'="" s andoc=##class(web.DHCANOPCom).GetNameById(mzdr)
	.e  s andoc=""
	.s anmthdr=$P(^OR(EpisodeID,"ANA",chl),"^",5)
	.s anmthdr=$tr(anmthdr,"|",",")
	.i anmthdr'="" d
		..s anmetNum=$l(anmthdr,",")
		..f i=1:1:anmetNum d
			...s anmetId=$p(anmthdr,",",i)
			...q:anmetId=""
			...s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
			...i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
			...i anmethod="" s anmethod=anmetDesc
			...e  i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
			...e  i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d
		..s opdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",6)
		..i opdr'=""  d
			...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d
			....i opname'="" s opname=opname_";"
			....s opname=opname_$P($g(^ORC("OPER",+opdr)),"^",2)
		..e  d
			...i $g(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))'="" d
				....i opname'="" s opname=opname_";"
				....s opname=opname_$G(^OR(EpisodeID,"ANA",chl,"OP",subchl,"REM",2))
		..s docdr=$P(^OR(EpisodeID,"ANA",chl,"OP",subchl),"^",8)
		..i docdr'="" s opdoc=##class(web.DHCANOPCom).GetNameById(docdr)
		..e  s opdoc=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")
	.do OutRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutRow
	set Data=$lb(status,jzstat,oproom,regno,patname,sex,age,opname,opdoc,loc,anmethod,andoc,opaId,EpisodeID,opdatestr,medCareNo,PatientID,PAADMMainMRADMDR,AnaesthesiaID)
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
/// Input：    就诊号 opaId
/// Function:  判断服务器上指定文件是否存在
/// w ##class(web.DHCANOPPdfBrowser).CheckPDFIfExist("303","115")
ClassMethod CheckPDFIfExist(FTPType As %String, EpisodeID As %String, opaId As %String) As %String
{
	s existsFlag=""
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s FTPSrvIP=PLIST(2)
	.s FTPSrvPortNo=PLIST(3)
	.s FTPSrvUserName=PLIST(4)
	.s FTPSrvUserCode=PLIST(5)
	.s FTPFolderName=PLIST(6)
	.s ftp=##class(%Net.FtpSession).%New()
	.i 'ftp.Connect(FTPSrvIP,FTPSrvUserName,FTPSrvUserCode,FTPSrvPortNo) s existsFlag="服务器连接失败"
	.i existsFlag'="服务器连接失败" d 
	..s fileName="/"_FTPFolderName_"/"_EpisodeID_"/"_opaId_".PDF"
	..s existsFlag=ftp.Retrieve(fileName)
	e  s existsFlag="FTP服务器信息未维护！"
	q existsFlag
}

/// Creator：  YuanLin
/// CreatDate：2018-01-12
/// Input：    就诊号 opaId
/// Function:  输出服务器上指定文件的存储路径
/// w ##class(web.DHCANOPPdfBrowser).GetPDFUrl("A","303","115")
ClassMethod GetPDFUrl(FTPType As %String, EpisodeID As %String, opaId As %String) As %String
{
	s PDFUrl=""
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s FTPSrvIP=PLIST(2)
	.s FTPSrvPortNo=PLIST(3)
	.s FTPSrvUserName=PLIST(4)
	.s FTPSrvUserCode=PLIST(5)
	.s FTPFolderName=PLIST(6)
	.s PDFUrl="ftp://"_FTPSrvUserName_":"_FTPSrvUserCode_"@"_FTPSrvIP_":"_FTPSrvPortNo_"/"_FTPFolderName_"/"_EpisodeID_"/"_opaId_".PDF"
	q PDFUrl
}

/// Creator：   YuanLin
/// CreatDate： 2019-07-18
/// Description:电子病案归档项目标准接口
/// Input：     就诊号 EpisodeID 文件类型 FTPType (麻醉记录单:A;术前访视:PR;术后访视:PO;恢复室记录单:PA)
/// Function:   判断服务器上有无文档需要归档,没有返回空,有则返回路径,多个路径用"^"分割,其他则返回具体内容
/// w ##class(web.DHCANOPPdfBrowser).GetANOPPDFPath("361","A")
ClassMethod GetANOPPDFPath(EpisodeID As %String, FTPType As %String) As %String
{
	s existsFlag=""
	s PDFURLStr="",PDFUrl=""
	&sql(select * into :PLIST() from SQLUSER.DHC_ANC_PDFConfig where FTP_Type=:FTPType)
	i SQLCODE=0 d
	.s FTPSrvIP=PLIST(2)
	.s FTPSrvPortNo=PLIST(3)
	.s FTPSrvUserName=PLIST(4)
	.s FTPSrvUserCode=PLIST(5)
	.s FTPFolderName=PLIST(6)
	.s ftp=##class(%Net.FtpSession).%New()
	.i 'ftp.Connect(FTPSrvIP,FTPSrvUserName,FTPSrvUserCode,FTPSrvPortNo) s existsFlag="服务器连接失败"
	.i existsFlag'="服务器连接失败" d
	..s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	...s fileName="/"_FTPFolderName_"/"_EpisodeID_"/"_opaId_".PDF"
	...s existsFlag=ftp.Retrieve(fileName)
	...i existsFlag=1 d
	....s PDFUrl="ftp://"_FTPSrvUserName_":"_FTPSrvUserCode_"@"_FTPSrvIP_":"_FTPSrvPortNo_fileName
	....i PDFURLStr="" s PDFURLStr=PDFUrl
	....e  s PDFURLStr=PDFURLStr_"^"_PDFUrl
	.e  s PDFURLStr=existsFlag
	e  d
	.s existsFlag="FTP服务器信息未维护！"
	.s PDFURLStr=existsFlag
	q PDFURLStr
}

}
