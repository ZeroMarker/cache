Import sqluser

Class web.DHCEMRotatBed Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:sufan
/// CreatorDate:2018-07-31
/// Descript: 急诊病区
/// W ##Class(web.DHCEMRotatBed).jsonEmPatWardBak(2)	
ClassMethod jsonEmPatWardBak(HospID As %String) As %String
{
	n (HospID)
	s WardID=0,Count=0
	w "["
	F  s WardID=$o(^PAWARD(WardID)) Q:(+WardID=0)  D
    .Q:$p(^PAWARD(WardID),"^",6)'="Y"
    .s WardDesc=$p($g(^PAWARD(WardID)),"^",2)
    .s LocID=$p(^PAWARD(WardID),"^",5)
    .Q:LocID=""
    .Q:$p(^CTLOC(LocID),"^",13)'="EM"
    .Q:'$o(^PAWARD(WardID,"ROOM",0))
    .Q:$p(^CTLOC(LocID),"^",22)'=HospID
    .s DateFrom=$P(^PAWARD(WardID),"^",7)
 	.s DateTo=$P(^PAWARD(WardID),"^",9)
 	.Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	.s:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",WardID_"^"_WardDesc)
	w "]"
	Q ""
}

/// Creator:hx
/// CreatorDate:2019-05-13
/// Descript: 急诊病区
/// W ##Class(web.DHCEMRotatBed).jsonEmPatWard(2)
ClassMethod jsonEmPatWard(HospID As %String, q = "") As %String
{
	n (HospID,q)
	w "["
	s ParRef=$o(^CT("LL",0,"Code","EMWARD",""))
	q:ParRef="" ""
	s CH=0,count=0
	F  s CH=$o(^CT("LL",ParRef,"LOC",CH)) Q:CH=""  D
	.s LocID=$p($g(^CT("LL",ParRef,"LOC",CH)),"^",1)
	.Q:LocID=""
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	.q:WardID=""
	.s WardDesc=$p(^PAWARD(WardID),"^",2)
	.s count=count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",WardID_"^"_WardDesc)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",WardID_"^"_WardDesc)
	w "]"
	q ""
}

/// Creator:sufan
/// CreatorDate:2018-07-31
/// Descript: 取急诊病区对应的床位
/// W ##Class(web.DHCEMRotatBed).jsonEmPatBed(30,1,"55",2)
ClassMethod jsonEmPatBed(rows As %String, page As %String, WardId As %String, HospID As %String)
{
	n (rows,page,WardId,HospID,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	s h=0,count=0
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
	//i WardId=""  d
	i 0 d
	.s WardId=0
	.for  s WardId=$o(^PAWARD(WardId)) Q:(+WardId=0)  d
    ..Q:$p(^PAWARD(WardId),"^",6)'="Y"
    ..s WardDesc=$p($g(^PAWARD(WardId)),"^",2)
    ..s LocID=$p(^PAWARD(WardId),"^",5)
    ..Q:LocID=""
    ..Q:$p(^CTLOC(LocID),"^",13)'="EM"
    ..Q:'$o(^PAWARD(WardId,"ROOM",0))
    ..Q:$p(^CTLOC(LocID),"^",22)'=HospID
    ..s DateFrom=$P(^PAWARD(WardId),"^",7)
 	..s DateTo=$P(^PAWARD(WardId),"^",9)
 	..Q:((+$h<DateFrom)&&(DateFrom'=""))!((+$h>DateTo)&&(DateTo'=""))
	..s BedIdSub=""
	..for  s BedIdSub=$o(^PAWARD(WardId,"BED",BedIdSub),-1)  q:BedIdSub=""  d
	...q:BedIdSub=0
	...s BedFlag=$p(^PAWARD(WardId,"BED",BedIdSub),"^",4)       //是否可用  yyt  2019-05-17
	...q:BedFlag'="Y"
	...d OutputRow
	E  d
	.s BedIdSub=""
	.for  s BedIdSub=$o(^PAWARD(+WardId,"BED",BedIdSub),-1)  q:BedIdSub=""  d
	..q:BedIdSub=0
	..s BedFlag=$p(^PAWARD(WardId,"BED",BedIdSub),"^",4)       //是否可用   yyt  2019-05-17
	..q:BedFlag'="Y"
	..d OutputRow
	
	i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	///转换数据为Json格式
	S ListTitle="BedId^WardId^WardDesc^BedCode^RoomCode^BedType^RoomType^BedFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(h) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCEM","web.DHCEMRotatBed","jsonEmPatBed",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCEM","web.DHCEMRotatBed","jsonEmPatBed",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
	
OutputRow
	s BedFlag="N"
	s Adm=$o(^PAWARDA(+WardId,"BED",BedIdSub,"ADM",0))
	//q:Adm'=""
	q:Adm'=""
	i Adm'="" s BedFlag="Y"
	s DateFrom=$p(^PAWARD(WardId,"BED",BedIdSub),"^",21)
	s DateTo=$p(^PAWARD(WardId,"BED",BedIdSub),"^",22)
	q:((+$H<DateFrom)&&(DateFrom'=""))||((+$H>DateTo)&&(DateTo'=""))
	s WardDesc=$p(^PAWARD(WardId),"^",2)                  //病区desc
	s BedCode=$p(^PAWARD(WardId,"BED",BedIdSub),"^",1)    //床code
	s RoomDr=$p(^PAWARD(WardId,"BED",BedIdSub),"^",3)     //room ID
	s RoomCode=""
	i RoomDr'="" s RoomCode=$p(^PAROOM(RoomDr),"^",1)  //room code
	s BedTypeDr=$p(^PAWARD(WardId,"BED",BedIdSub),"^",2)  //床类型 ID
	s BedType=""
	i BedTypeDr'="" s BedType=$p(^PAC("BEDTP",BedTypeDr),"^",2)  //床类型
	s RoomTypeDr=""
	i RoomDr'="" s RoomTypeDr=$p(^PAROOM(RoomDr),"^",3)  //roomtype id
	s RoomType=""
	i RoomTypeDr'="" s RoomType=$p(^PAC("ROOMT",RoomTypeDr),"^",3)
	s BedId=WardId_"||"_BedIdSub
	s WardDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",WardDesc) //hxy 2023-01-29 st
	s BedType=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACBedType","BEDTPDesc","",BedType)
	s RoomCode=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACRoom","ROOMDesc","",RoomCode) //ed
	s ListData=BedId_"^"_WardId_"^"_WardDesc_"^"_BedCode_"^"_RoomCode_"^"_BedType_"^"_RoomType_"^"_BedFlag
	s h=h+1
	s index=$s(BedCode["+":"A"_BedCode,1:BedCode)_"^"_h
	s ^TMP("DHCEM","web.DHCEMRotatBed","jsonEmPatBed",pid,index)=ListData
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	//Q $I(^DHCAPP("APPExaReportQuery"))
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	n (pid)
	k ^TMP("DHCEM","web.DHCEMRotatBed","jsonEmPatBed",pid)
}

/// 患者入院状态
/// w ##class(web.DHCEMRotatBed).getPatAllStatus(35052453)
ClassMethod getPatAllStatus(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:EpisodeID="" ""
	s Tempstr=""
    s avsId="-1"
    f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
    .s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2) //病人状态
    .q:patVisitStat=""	//病人状态
    .s EpisodeID=$p(^DHCADMVisitStatus(avsId),"^",1)
    .q:EpisodeID=""
    .s statDate = $p(^DHCADMVisitStatus(avsId),"^",5)
    .s statTime=$p($g(^DHCADMVisitStatus(avsId)),"^",6)
    .;s statTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),1) //变更状态时间
    .s userDesc=$p(^SSU("SSUSR",$p(^DHCADMVisitStatus(avsId),"^",4)),"^",2) //执行人
    .i Tempstr="" s Tempstr=patVisitStat
    .e  s Tempstr=Tempstr_"^"_patVisitStat
    q Tempstr
}

/// 患者当前所在病区
/// w ##class(web.DHCEMRotatBed).getPatCurWard("35052293")
ClassMethod getPatCurWard(EpisodeID)
{
	n (EpisodeID)
	s WardDr=""
	s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	s PAAdmWard=""
	i WardDr'="" s PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	q PAAdmWard
}

/// Descript: 急诊病人信息
/// w ##class(web.DHCEMRotatBed).GetPatEssInfo("0000000011")
ClassMethod GetPatEssInfo(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	s PatWard="",PatBed=""
	i EpisodeID'="" d
	.s WardDr=$P($g(^PAADM(EpisodeID)),"^",70)
	.i WardDr'="" s PatWard=$P($g(^PAWARD(WardDr)),"^",2)                       /// 病区
	.s:PatWard'="" PatWard=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",PatWard) //hxy 2023-01-29
	.s:PatWard["-" PatWard=$p(PatWard,"-",2)
	.s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	.I BedId'="" s PatBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)  /// 床号
	.E  s PatBed=""
	s ListData=PatBed_"^"_PatWard
	s ListTitle="PatBed^PatWard"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-03-05
/// Descript:    病人转移历史
/// Input:   	 EpisodeID - 就诊ID
/// w ##Class(web.DHCEMRotatBed).JsonQryPatTrsHis("165")
ClassMethod JsonQryPatTrsHis(rows As %String, page As %String, EpisodeID As %String) As %String
{
	n (rows, page, EpisodeID,%session)
	q:EpisodeID="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json串
	s End = page*rows
	s Start=(page-1)*rows+1
	k TmpVsArr
	s TrsCH=0, Num=0
	F  s TrsCH=$o(^PAADM(EpisodeID,"TRANS",TrsCH)) Q:TrsCH=""  D
	.s StartDate=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",1) /// 开始日期
	.s StartDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(StartDate)
	.s StartTime=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",2) /// 开始时间
	.i StartTime'="" s StartTime=$zt(StartTime,2)
	.s EndDate=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",3)   /// 结束日期
	.s EndDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(EndDate)
	.s EndTime=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",4)   /// 结束时间
	.i EndTime'="" s EndTime=$zt(EndTime,2)
	.s PatBed=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",8)    /// 床号
	.i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	.s WardID=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",9)    /// 病区
	.s Ward=$p($g(^PAWARD(+WardID)),"^",2)
	.s UserID=$p(^PAADM(EpisodeID,"TRANS",TrsCH),"^",16)   /// 操作人
	.s User=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	.s Ward=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACWard","WARDDesc","",Ward) //hxy 2023-01-29
	.s User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User) //hxy 2023-01-29
	.s ListData=StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_PatBed_"^"_Ward_"^"_User
	.s Num=Num+1
	.s TmpVsArr(Num)=ListData
	.

	s ListTitle="StartDate^StartTime^EndDate^EndTime^PatBed^Ward^User"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TmpVsArr(index),-1) Q:index=""  D
	.s ListData=$g(TmpVsArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.Q:(Num<Start)||(Num>End)
	.i Num=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

}
