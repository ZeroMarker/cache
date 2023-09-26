/// 名称: DHCHAI.IO.BuildNurSrv（web.DHCNurInterface）
/// 描述: 创建护理接口类方法
/// 编写者：zhufei
/// 编写日期: 2017-03-23
Class DHCHAI.IO.BuildNurSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:      songchao
/// CreateDate:   2018.3.14
/// Description:  获取第一次的生命体征值
/// Input:       episodeID:就诊号, itemCode:生命体征代码
/// Return:       
/// Other:        ##Class(web.DHCNurInterface).getFirstItemValue("17","weight")
ClassMethod getFirstItemValue(episodeID, itemCode)
{
	s mrAdmID=$P(^PAADM(episodeID),"^",61)
	s itemID=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4(itemCode),""))
	s date="" f  s date=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date)) q:(date="")!($g(findFlag)=1)  d
	.s time="" f  s time=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time)) q:(time="")!($g(findFlag)=1)  d
	..s obsID=$o(^MR(mrAdmID,"OBS",0,"Item",itemID,date,time,""))
	..q:obsID=""
	..s value=$P(^MR(mrAdmID,"OBS",obsID),"^",2)
	..s findFlag=1
	q $g(value)
}

/// 医生站/计费接口
/// 返回值 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
/// w ##class(web.DHCADMVisitStat).GetStayStatus(14402247)
ClassMethod GetStayStatus(Adm) As %String
{
	n (Adm)
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	;q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
    s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	
	q:((PatAllStatusCode'["STAY")&&(PatAllStatusCode'["SALVAGE")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")||($p(PatAllStatusCode,"^",ii)="SALVAGE")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}

/// Creator:      songchao
/// CreateDate:   2018.3.14
/// Description:  获取患者急诊留观信息
/// Input:       episodeID:就诊号
/// Return:       status(留观状态:1正在留观,2曾经留观)$入院日期^入院时间$出院日期^出院时间
/// Other:        ##Class(web.DHCNurInterface).getEmStayInfo("17")
ClassMethod getEmStayInfo(episodeID)
{
	s ret=""
	s stayStatus=..GetStayStatus(episodeID)
	s admDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetAdmDateTime(episodeID)
	s dischargeDateTime=##Class(DHCHAI.IO.FromAdmSrv).GetDischDateTime(episodeID)
	s ret=stayStatus_"$"_admDateTime_"$"_dischargeDateTime
	q ret
}

/// Creator:      Songchao
/// CreateDate:   2020.05.07
/// Description:  获取患者离床时间
/// Input:        EpisodeID:就诊号
/// Return:       1:是 0:否
/// Other:        ##Class(Nur.Interface.OutSide.Patient).getPatOutBedDateTime(24)
ClassMethod getPatOutBedFlag(EpisodeID)
{
	n (EpisodeID)
	s visitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	q:visitStatus'="A" "0^非在院患者"
	s MotherDr= $p($g(^PAADM(EpisodeID)),"^",75)	//之婴
	q:MotherDr'="" "0^非在院患者"	
	s currBedDR=$p($g(^PAADM(EpisodeID)),"^",73)
	s admWardDR=$p($g(^PAADM(EpisodeID)),"^",70)
	q:admWardDR="" "0^当前病区为空"
	s currWardDR=$o(^PAWARDA(0,"WADM",EpisodeID,""),-1)
	s:currWardDR="" currWardDR=$o(^PAWARDA(0,"RADM",EpisodeID,""),-1)
	q:currWardDR="" "0^患者不在等候区"
	s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	s admTime=$p($g(^PAADM(EpisodeID)),"^",7)
	
	i currWardDR'=admWardDR d
	.d getTransRecord
	e  d
	.s wadmChildsub=$o(^PAWARDA(0,"WADM",EpisodeID,currWardDR,""),-1)
	.s:wadmChildsub="" wadmChildsub=$o(^PAWARDA(0,"RADM",EpisodeID,currWardDR,""),-1)
	.q:wadmChildsub=""
	.s transDr=$p(^PAWARDA(currWardDR,"WADM",wadmChildsub),"^",3)
	.s transSub=$p(transDr,"||",2)
	.i transSub'="" d getTRANS
	.e  d getTransRecord
	q:(startDate=admDate)&&(admTime=startTime) "0^预住院患者"
	q:(+$h)<(startDate+1) "0^非长期在等候区"
	q 1_"^"_$g(startDate)_"^"_$g(startTime)
	
getTransRecord
	s transDr=$o(^Nur.Data.TransRecordI("TransDataState"," "_EpisodeID," N",""),-1)
	q:transDr=""
	s startDate=$lg(^Nur.Data.TransRecordD(transDr),12)
	s startTime=$lg(^Nur.Data.TransRecordD(transDr),13)
	q
getTRANS
	s startDate=$p($g(^PAADM(EpisodeID,"TRANS",transSub)),"^",1)
	s startTime=$p($g(^PAADM(EpisodeID,"TRANS",transSub)),"^",2)
	q
}

}
