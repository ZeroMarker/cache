/// 科主任手术统计
Class DtPortal.DD.DD07OperationStatistics Extends %RegisteredObject
{

// DD07.01.01查询手术统计明细数据

// opLevelId-手术级别ID   ""-全部

// opType-手术类型    E-急诊 B-择期

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD07OperationStatistics","DD070101","7^110","2019-01-01","2019-01-31","","")

Query DD070101(locGroupID As %String, startDate As %String, endDate As %String, opLevelId As %String = "", opType As %String = "", hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "BedNo,Name,Sex,Age,MedicareNo,AdmDoc,AdmReason,DiagnoseDesc,OpName,OpStratTime,OpEndTime,EpisodeID,EMRDocID,EMRInstanceID,PatientID,locID,opTypeDesc,opLevelDesc") [ SqlProc ]
{
}

ClassMethod DD070101Execute(ByRef qHandle As %Binary, locGroupID As %String, startDate As %String, endDate As %String, opLevelId As %String = "", opType As %String = "", hospitalId As %String = "") As %Status
{
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	
	f date=startDate:1:endDate d 
	.q:date=+$h  //不获取当天数据
	.s wlanrowid=0 f  s wlanrowid=$o(^DHCWLAnaesthesia(0,"STATDATE",date,wlanrowid)) q:wlanrowid=""  d
    ..s optype=$p(^DHCWLAnaesthesia(wlanrowid),"^",4)
    ..s opLevelIdTemp=$p(^DHCWLAnaesthesia(wlanrowid),"^",72)    ;手术规模
	..s OPARowid=$p(^DHCWLAnaesthesia(wlanrowid),"^",66)        /// DHC_AN_OPArrange
	..s Anaestdr=$p(^DHCANOPArrange(OPARowid),"^",2)
 	..s Admid=$p(Anaestdr,"||",1)
 	..s AnSubDr=$p(Anaestdr,"||",2)
    ..;s medthid=$p(^DHCWLAnaesthesia(wlanrowid),"^",8)    ;麻醉方式
    ..s medthid=$P($g(^OR(Admid,"ANA",AnSubDr)),"^",5)
    ..s MainMedthid=+medthid   ///主麻醉方式
    ..i +MainMedthid=0 s MainMedthid=99999
    ..s PatLocDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",5)    ;病人所在科室
    ..q:PatLocDr=""
    ..q:(locGroupID'="all")&&('$LF($LISTFROMSTRING(locGroupID,"^"),PatLocDr))   //按科室过滤
    ..set hospID=$p(^CTLOC(PatLocDr),"^",22)
    ..q:(hospitalId'="")&&(hospID'="")&&(hospID'=hospitalId)
    ..s PatWardDr=$p(^DHCWLAnaesthesia(wlanrowid),"^",6)    ;病人所在病区
    ..s admid=$p(^DHCWLAnaesthesia(wlanrowid),"^",1)
	..s reasonid=$p($g(^PAADM(admid,1)),"^",7)  ;病人身份    
    ..s recopdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",63)   ;接收科室
    ..s operdocdr=$p(^DHCWLAnaesthesia(wlanrowid),"^",50)    ;主刀医生
    ..i (operdocdr="")!(operdocdr=0) s operdocdr=99999
    ..s AssistDocdr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",52)    ;手术助理1 
    ..i (AssistDocdr1="")!(AssistDocdr1=0) s AssistDocdr1=99999
    ..s AssistDocdr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",53)    ;手术助理2 
    ..i (AssistDocdr2="")!(AssistDocdr2=0) s AssistDocdr2=99999
    ..;s AssistDocdr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",54)    ;手术助理3 
    ..;i (AssistDocdr2="")!(AssistDocdr2=0) s AssistDocdr2=99999
    ..s CirNursedr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",58)    ;新版：巡回护士|巡回护士
    ..s CirNursedr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",59)    ;新版：交巡回护士|交巡回护士
    ..s CirNursedr=CirNursedr1_"|"_CirNursedr2
    ..s ScrNursedr1=$p(^DHCWLAnaesthesia(wlanrowid),"^",60)    ;新版：器械护士|器械护士 
    ..s ScrNursedr2=$p(^DHCWLAnaesthesia(wlanrowid),"^",61)    ;新版：交器械护士|交器械护士
    ..s ScrNursedr=ScrNursedr1_"|"_ScrNursedr2
    ..s AnDoc=+$p(^DHCWLAnaesthesia(wlanrowid),"^",9)   ;麻醉医生1
    ..i (AnDoc="")!(AnDoc=0) s AnDoc=99999
    ..s AnDoc1=+$p(^DHCWLAnaesthesia(wlanrowid),"^",55)   ;麻醉医生2
    ..i (AnDoc1="")!(AnDoc1=0) s AnDoc1=99999
    ..s OPERDR=$p(^DHCWLAnaesthesia(wlanrowid),"^",42)
    ..s OPType=$p(^DHCWLAnaesthesia(wlanrowid),"^",65)  ;手术类型
	..//手术级别ID
	..i opLevelId'="" q:opLevelId'=opLevelIdTemp
	..i opType'="" q:opType'=OPType
	..s opLevelDesc=""
	..i opLevelIdTemp'="" s opLevelDesc=$p($g(^ORC("CATEG",opLevelIdTemp)),"^",2)
	..s opTypeDesc=""
	..i OPType="E" s opTypeDesc="急诊"
	..e  i OPType="B" s opTypeDesc="择期"
	..s EpisodeID=admid
	..s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(EpisodeID)
	..s BedNo=$p(patInfoStr,"^",1)
	..s MedicareNo=$p(patInfoStr,"^",5)
	..s Name=$p(patInfoStr,"^",2)
	..s Sex=$p(patInfoStr,"^",3)
	..s Age=$p(patInfoStr,"^",4)
	..s AdmReason=$p(patInfoStr,"^",6)
	..s AdmDoc=$p(patInfoStr,"^",11)  //主管医生
	..s OpName=$p($G(^ORC("OPER",OPERDR)),"^",2)
	..//取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
	..s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(EpisodeID)
	..s opaStartDate=$P(^OR(EpisodeID,"ANA",AnSubDr),"^",39)
	..s opsttime=$P(^OR(EpisodeID,"ANA",AnSubDr),"^",40)
	..i opaStartDate="" s opaStartDate=$P(^DHCANOPArrange(OPARowid),"^",14)   ;手术开始日期
	..i opaStartDate'="" s opaStartDate=$ZD(opaStartDate,3)
	..i opsttime="" s opsttime=$P(^DHCANOPArrange(OPARowid),"^",15)
	..i opsttime'=""  s opsttime=$ZT(opsttime,2)
	..s openddate=$P(^DHCANOPArrange(OPARowid),"^",16)
	..i openddate'="" s openddate=$zd(openddate,3)
	..e  s openddate=""
	..s opendtime=$P(^DHCANOPArrange(OPARowid),"^",17)
	..i opendtime'="" s opendtime=$zt(opendtime,2)
	..e  s opendtime=""    
	..s OpStratTime=opaStartDate_"&nbsp;"_opsttime  //手术开始时间
	..s OpEndTime=openddate_"&nbsp;"_opendtime  //手术开始时间
	
	..//获取打开电子病历所需要的参数
	..set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(EpisodeID)
	..set EMRDocID=$p(EMRinfo,"^",1)
	..set EMRInstanceID=$p(EMRinfo,"^",2)
	..set locID=$p(EMRinfo,"^",3)
	..set PatientID=$p(EMRinfo,"^",4)
	..set EpisodeID=$p(EMRinfo,"^",5)
	
	..s ^||CacheTemp(repid,ind)=$lb(BedNo,Name,Sex,Age,MedicareNo,AdmDoc,AdmReason,DiagnoseDesc,OpName,OpStratTime,OpEndTime,EpisodeID,EMRDocID,EMRInstanceID,PatientID,locID,opTypeDesc,opLevelDesc)
	..s ind=ind+1

	Quit $$$OK
}

// DD07.02.01查询手术类型的饼状图统计

// 返回：ENum-急诊类型数量 BNum-择期类型数量

// d ##class(%ResultSet).RunQuery("DtPortal.DD.DD07OperationStatistics","DD070201","7^110","2019-02-01","2019-02-14")

Query DD070201(locIDStr As %String, startDate As %String, endDate As %String, hospitalId As %String = "") As DtPortal.Query(ROWSPEC = "desc,num,code") [ SqlProc ]
{
}

ClassMethod DD070201Execute(ByRef qHandle As %Binary, locIDStr As %String, startDate As %String, endDate As %String, hospitalId As %String = "") As %Status
{
	Set repid1=$I(^||CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	q:(locIDStr="")||(startDate="")||(endDate="") $$$OK
	if (locIDStr["^") {
		s locIDStr=$tr(locIDStr,"^",",")
	}
	set kpiRule="SK0171,SK0172"
	set dateType="",mode="H"
	//set dateType="byMonth"
	set filterRule=""
	if (locIDStr="all"){
		//过滤院区
		if (hospitalId'=""){
			set filterRule="SK0171:({PatLoc.HospIdByLoc}="_hospitalId_"),SK0172:({PatLoc.HospIdByLoc}="_hospitalId_")"
		}

	}else{
		set filterRule="SK0171:({PatLoc}="_locIDStr_"),SK0172:({PatLoc}="_locIDStr_")"
	}
	
	
	s ENum=0,BNum=0
	
	set rs=##class(DHCWL.util.UniteQueryData).GetQueryDateRef("DHCWL.MKPIService.MKPIQuery:KpiQueryGrideShow",startDate,endDate,dateType,kpiRule,filterRule,mode,"")
	While rs.Next(.sc) {
		If $$$ISERR(sc) Quit
		s date=rs.Data("month")
		s ENum=ENum+$g(rs.Data("kpiValueCol1"))
		s BNum=BNum+$g(rs.Data("kpiValueCol2"))
		
	}
	s desc="急诊"
	s num=ENum
	s code="E"
	i num'=0 d DD070201
	
	
 	s desc="择期"
	s num=BNum
	s code="B"
	i num'=0 d DD070201
	Quit $$$OK
DD070201
	s ^||CacheTemp(repid1,ind1)=$lb(desc,num,code)
 	s ind1=ind1+1
	q
}

}
