/// creator:wangfujian
/// createDate:2009-03-17
/// description:体检前台->个人信息查询-》导出个人医嘱信息
Class web.DHCPE.iadmInfoOutput Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:wangfujian
/// creteDate:2009-03-16
/// description:根据登记号查询其基本信息，体检的大项，细项，站点
/// input:EpisodeID就诊表rowid
/// return:返回值形如:"汪福建^00111^24^男^内科%体检大项$心电@心率&外科%内科专业检查$心电@心率"
/// test：w ##class(web.DHCPE.iadmInfoOutput).FindSationInfoByAdm("224433")
ClassMethod FindSationInfoByAdm(EpisodeID As %String = "") As %String
{
   
	s admRowid=EpisodeID
	;S allInfo="汪福建^00111^24^男#内科%体检大项$心电@心率&外科%内科专业检查$心电@心率"
	s allInfo=##class(web.DHCPE.iadmInfoOutput).FindBaseInfoByAdmRowid(admRowid)
	s allInfo=allInfo_"#"_##class(web.DHCPE.iadmInfoOutput).FindOrderInfoByAdmRowid(admRowid)
	//w ! allInfo
	q allInfo
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description:由paadm的rowid查询出该病人的基本信息
/// input:EpisodeID为病人就诊表达rowid
/// return:"汪福建^00111^24^男"
/// test:w ##class(web.DHCPE.iadmInfoOutput).FindBaseInfoByAdmRowid("108779")
ClassMethod FindBaseInfoByAdmRowid(EpisodeID As %String = "") As %String
{
	q:EpisodeID=""
	s PAADMRowid=EpisodeID
	s PAPMIRowId=$p(^PAADM(PAADMRowid),"^",1)
	q:PAPMIRowId=""
	s CurData=$g(^PAPER(PAPMIRowId,"ALL"))  
	q:CurData=""
	//登记号
	s PAPMINo=""
	s PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",1)
	i PAPMINo="" s PAPMINo=$P($g(^PAPER(PAPMIRowId,"PAT",1)),"^",2)
	q:$g(PAPMINo)=""
	//	姓名
	s PIBIName=$p(CurData,"^",1)
	//性别
	s PIBISexDR=$p(CurData,"^",7)  
	i (""'=PIBISexDR)  Do  		
	.s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
	e  d
	.s PIBISexDRName=""
	//PIBI_DOB	生日
	s PIBIDOB=$p(CurData,"^",6)
	s currDate=+$h
	s age=$j((currDate-PIBIDOB+182)/365,1,0)
	
	s sort=..GetSortByPAADM(PAADMRowid)
	i sort'="" s PIBIName="("_sort_")"_PIBIName
	
	q PIBIName_"^"_PAPMINo_"^"_age_"^"_PIBISexDRName
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description:由paadm的rowid查询出该病人没停止的医嘱及细项
/// input:EpisodeID为病人就诊表达rowid
/// return:"内科%体检大项$心电@心率&外科%内科专业检查$心电@心率"
/// test:w ##class(web.DHCPE.iadmInfoOutput).FindOrderInfoByAdmRowid("108779")
ClassMethod FindOrderInfoByAdmRowid(EpisodeID As %String = "") As %String
{
	s orderInfo=""
	q:EpisodeID=""
	s PAADMRowid=EpisodeID
	s curLoc=$P($G(^PAADM(EpisodeID)),"^",4)
	// OE_Order
	s OEORDRowId=0
	s OEORDRowId=$O(^OEORD(0,"Adm",PAADMRowid,OEORDRowId))
	q:(""=OEORDRowId)
	// 医嘱项表
	s OEORIChildsub=0
	f  s OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) Q:(""=OEORIChildsub)  d
	.s OEORIRowid=OEORDRowId_"||"_OEORIChildsub
	.s stateStr=##class(web.DHCPE.iadmInfoOutput).getARCIMState(OEORIRowid)
	.q:stateStr="执行"
	.q:stateStr="谢绝检查"
	.q:stateStr="停止"
	.s ARCIMRowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
	.s STRowID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMRowid,0))     //add by zhouli
	.;Q:STRowID=^DHCPESetting("DHCPE","StationId_Lab")         //add by zhouli
	.Q:STRowID=^DHCPESetting("DHCPE","StationId_Lab",curLoc) 
	.//医嘱名
	.s ARCIMSubscript=$p(ARCIMRowid,"||",1)
	.s ARCIMVersion=$p(ARCIMRowid,"||",2)
	.s ARCIMName=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	.//站点名
	.s stationName=##class(web.DHCPE.iadmInfoOutput).getStationByARCItmMastRowid(ARCIMRowid)
	.s orderDetail=##class(web.DHCPE.iadmInfoOutput).getOrderDetailByARCItmMastRowid(ARCIMRowid)
	.i orderInfo="" d
	..s orderInfo=stationName_"%"_ARCIMName_"$"_orderDetail
	.else  d
	..s orderInfo=orderInfo_"&"_stationName_"%"_ARCIMName_"$"_orderDetail
	q orderInfo
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description:得到医嘱所在的站点
/// input:ARCItmMastRowid为医嘱项
/// return:科室名称如："内科"
/// test:w ##class(web.DHCPE.iadmInfoOutput).getStationByARCItmMastRowid("17415||1")
ClassMethod getStationByARCItmMastRowid(ARCItmMastRowid As %String = "") As %String
{
	s stationName="站点名称"
	s stationRowid=""
	s stationOrderRowid=""
	s stationRowid=$o(^DHCPEST(0,"STORD_ARCIM",ARCItmMastRowid,stationRowid))
	i stationRowid=""  q ""
	s stationName=$P(^DHCPEST(stationRowid),"^",2)
	q stationName
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description:得到医嘱的执行状态
/// input:OEORIRowid为病人医嘱的rowid
/// return:返回医嘱执行状态："核实"
/// test:w ##class(web.DHCPE.iadmInfoOutput).getARCIMState("96049||6")
ClassMethod getARCIMState(OEORIRowid As %String = "") As %String
{
	s stateStr=0
	s OEODRowid=$p(OEORIRowid,"||",1)
	s OEOIChildSub=$p(OEORIRowid,"||",2)
	s state=$p(^OEORD(OEODRowid,"I",OEOIChildSub,1),"^",13)
	s stateStr=$p(^OEC("OSTAT",state),"^",2)
	i (stateStr="核实")&($p($g(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowid)),"^",1)=1) d
	.s stateStr="谢绝检查"
	q stateStr
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description:通过医嘱的rowid得到医嘱所有点细项
/// input:医嘱的rowid
/// return:医嘱细项："心电@心率"
/// test:w ##class(web.DHCPE.iadmInfoOutput).getOrderDetailByARCItmMastRowid("5536||1")
ClassMethod getOrderDetailByARCItmMastRowid(ARCItmMastRowid As %String = "") As %String
{
	s orderDetail=""
	s ODRelateRowid=""
	f  s ODRelateRowid=$o(^DHCPEODR(0,"ARCIM",ARCItmMastRowid,ODRelateRowid)) q:ODRelateRowid=""  d
	.s ODRowid=$p(^DHCPEODR(ODRelateRowid),"^",2)
	.s stationRowid=$p(ODRowid,"||",1)
	.s detailSub=$p(ODRowid,"||",2)
	.i orderDetail="" d
	..s orderDetail=$P(^DHCPEST(stationRowid,"OD",detailSub),"^",1)
	.else  d
	..s orderDetail=orderDetail_"@"_$P(^DHCPEST(stationRowid,"OD",detailSub),"^",1)
	q orderDetail
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description：得到除ris，lib，other以外的站点名词
/// return:站点名称："一般检查,^内科,^外科,^妇科,^眼科,^耳鼻喉科,"
/// test:w ##class(web.DHCPE.iadmInfoOutput).getStation()
ClassMethod getStation() As %String
{
	s stationNames=""
	s stationRowid=0
	f  s stationRowid=$o(^DHCPEST(stationRowid)) q:stationRowid=""  d
	.q:stationRowid=^DHCPESetting("DHCPE","StationId_Other")
	.q:stationRowid=^DHCPESetting("DHCPE","StationId_Lab")
	.s risSationNum=$l(^DHCPESetting("DHCPE","StationId_Lab"),"^")
	.s flag=0
	.s iLoop=0
	.f  s iLoop=iLoop+1 q:(iLoop=(risSationNum+1))||flag=1  d
	..i stationRowid=$p(^DHCPESetting("DHCPE","StationId_Ris"),"^",iLoop) d
	...s flag=1
	.i flag=0 d
	..i stationNames="" d
	...s stationNames=$P(^DHCPEST(stationRowid),"^",2)_","
	..else  d
	...S stationNames=stationNames_"^"_$P(^DHCPEST(stationRowid),"^",2)_","
	q stationNames
}

/// creator:wangfujian
/// createDate:2009-03-17
/// description：通过PREGADM查处某团体的登记后的PAADM和所在组名
/// return:站点名称："1^2^3"
/// test:w ##class(web.DHCPE.iadmInfoOutput).GetPAADMsByPreGADM("4")
ClassMethod GetPAADMsByPreGADM(PreGADMRowid As %String = "") As %String
{
	s PAADMTeamNames=""
	s GTeamName=""
	//通过PreGADM找到 GADM
	s GADMRowid=""
	s GADMRowid=$o(^DHCPEGADM(0,"CRMGADM",PreGADMRowid,GADMRowid))
	q:GADMRowid="" ""
	//通过GADM查处所有的IADM（只有登记后的病人才会有IADM）
	s GTeamRowid=""
	f  s GTeamRowid=$o(^DHCPEIADM(0,"GADM",GADMRowid,GTeamRowid)) q:GTeamRowid=""  d
	.s GTeamName=$p(^DHCPEGADM(GADMRowid,"Team",$p(GTeamRowid,"||",2)),"^",1)
	.s IADMRowid=""
	.f  s IADMRowid=$o(^DHCPEIADM(0,"GADM",GADMRowid,GTeamRowid,IADMRowid)) q:IADMRowid=""  d
	..//如果取消体检，抛去该记录
	..s IADMStatus=$p(^DHCPEIADM(IADMRowid),"^",8)
	..q:IADMStatus="CANCELPE"
	..//通过IADMRowid得到PAADMRowid
	..s PAADM=$P(^DHCPEIADM(IADMRowid),"^",1)
	..i PAADMTeamNames="" d
	...s PAADMTeamNames=PAADM_"#"_GTeamName
	..e  d
	...s PAADMTeamNames=PAADMTeamNames_"^"_PAADM_"#"_GTeamName
	q PAADMTeamNames
}

// w ##class(web.DHCPE.iadmInfoOutput).GetSortByPAADM("4")

ClassMethod GetSortByPAADM(PAADM)
{
	s sort=""
	q:PAADM="" sort
	s PEIADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:PEIADM="" sort
	s PreIADM=$p($G(^DHCPEIADM(PEIADM)),"^",4)
	q:PreIADM="" sort
	q $G(^DHCPEDateEx("DHCPEPreIAMD","GADM","IAMD",PreIADM))
}

}
