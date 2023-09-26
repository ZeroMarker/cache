Class DHCMA.VTE.DI.Oper Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator 丁延丽 2017-08-03   日期索引：^DHCANOPArrange(0,"SDate",日期数字的)
/// d ##class(%ResultSet).RunQuery("DHCMA.VTE.DI.Oper","GetAnOpListForM",20754179,"2018-01-13","2019-01-15")
Query GetAnOpListForM(EpisodeId As %String, stdate As %String, enddate As %String) As %Query(ROWSPEC = "OperID,EpisodeID,OperICD,OperDesc,OperLevel,StartDate,StartTime,EndDate,EndTime,OperHour,AnesMethodCode,AnesMethod,OpaStatus") [ SqlProc ]
{
}

ClassMethod GetAnOpListForMExecute(ByRef qHandle As %Binary, EpisodeId As %String, stdate As %String, enddate As %String) As %Status
{
	///paidType "Y"已收费，"N"未收费，其它为全部
  	Set repid=$I(^CacheTemp)
  	s ind=1
    k ^TMPAN("AppM",$j)
    Set $ZT="AutoTaskErr"
	//手麻记录ID：OperID、手术编码：OperICD、手术名称：OperDesc、手术类型：OperType、手术开始日期：StartDate
	//OperID,OperICD,OperDesc,OperType,StartDate
	//、手术开始时间：StartTime、手术结束日期：EndDate、手术结束时间：EndTime、手术时长：OperHour、
	//,StartTime,EndDate,EndTime,OperHour
	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
	Set sdate=stdate
	Set edate=enddate
	Set:stdate["-" sdate=$zdh(stdate,3)
	Set:enddate["-" edate=$zdh(enddate,3)
	s opaId=""
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",+EpisodeId,opaId)) q:opaId=""  d
	.d GetANOperationForM	 
	k ^TMPAN("AppM",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

GetANOperationForM
	q:$d(^DHCANOPArrange(opaId))<1
	s ifOutOper=$g(^DHCANOPArrange("OUTOP",opaId))
	q:(ifOutOper="O") ;门诊不在之内
	
	s opstdate=$P(^DHCANOPArrange(opaId),"^",14) ;手术开始日期
	q:opstdate=""
	q:((sdate'="")&&(opstdate<sdate))
	q:((edate'="")&&(opstdate>edate))
	i opstdate'="" s opstdate=$ZD(opstdate,3)
	s opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;手术开始时间
	i opsttime'=""  s opsttime=$ZT(opsttime,2)
	s openddate=$P(^DHCANOPArrange(opaId),"^",16) ;手术结束日期
	i openddate'="" s openddate=$ZD(openddate,3)
	s opendtime=$P(^DHCANOPArrange(opaId),"^",17) ;手术结束时间
	i opendtime'=""  s opendtime=$ZT(opendtime,2)
	s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm ;就诊ID
	q:adm=""
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27) ;手术状态,Apply,Cancel,Decline,Receive,InRoom,Operate,LeaveRoom,Finish,NotApp,PACU,Surgery
	q:(opaStatus="D")!(opaStatus="C")  ;跳过拒绝和取消的
	// Update By zhoubo 2017-12-12 手术状态为离室、完成的才算
	//q:(opaStatus'="L")&&(opaStatus'="F")
	s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23) ;,AnaLoc,InPatLoc,OperLoc
	s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2) ;手术序号
	
	;最后手术登记存放的时间，20120607+dyl
	//s anaTheatreInDate=$p(^OR(adm,"ANA",chl),"^",39)
	//i anaTheatreInDate'="" s opstdate=$zd(anaTheatreInDate,3) ;手术开始日期更新
	//s anaTheatreInTime=$p(^OR(adm,"ANA",chl),"^",40)
	//i anaTheatreInTime'="" s opsttime=$zt(anaTheatreInTime,2) ;手术开始时间更新
	
	//s anaTheatreOutDate=$p(^OR(adm,"ANA",chl),"^",41)
	//i anaTheatreOutDate'="" s opstdate=$zd(anaTheatreOutDate,3) ;手术结束日期更新
	//s anaTheatreOutTime=$p(^OR(adm,"ANA",chl),"^",42)
	//i anaTheatreOutTime'="" s opsttime=$zt(anaTheatreOutTime,2) ;手术结束时间更新
		
	//手麻记录ID：OperID、手术编码：OperICD、手术名称：OperDesc、手术类型：OperType、手术开始日期：StartDate
	//OperID,OperICD,OperDesc,OperType,StartDate
	//、手术开始时间：StartTime、手术结束日期：EndDate、手术结束时间：EndTime、手术时长：OperHour、
	//,StartTime,EndDate,EndTime,OperHour
	
	;ANA_Method:麻醉方法+dyl+20120611
	s anmethod="",anmethodCodeStr=""
	s anmthdr=$P(^OR(adm,"ANA",chl),"^",5)
	s anmthdr=$tr(anmthdr,"|",",")
	i anmthdr'="" d
	.s anmetNum=$l(anmthdr,",")
	.f i=1:1:anmetNum d
	..s anmetId=$p(anmthdr,",",i)
	..q:anmetId=""
	..s anmethodCode=$p($g(^ORC("ANMET",anmetId)),"^",1)
	..s anmetDesc=$p($g(^ORC("ANMET",anmetId)),"^",2)
	..i $P(anmetDesc,"-",2)'="" s anmetDesc=$P(anmetDesc,"-",2)
	..i (anmethod'="")&(anmethod'[anmetDesc) s anmethod=anmethod_","_anmetDesc
	..i (anmethod'="")&(anmethod[anmetDesc) s anmethod=anmethod
	..e  s anmethod=anmetDesc
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr'[anmethodCode) s anmethodCodeStr=anmethodCodeStr_","_anmethodCode
	..e  i (anmethodCodeStr'="")&(anmethodCodeStr[anmethodCode) s anmethodCodeStr=anmethodCode
	..e  s anmethodCodeStr=anmethodCode

	s i=0
	s icdCodeStr="",opdes=""
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P($g(^OR(adm,"ANA",chl,"OP",subchl)),"^",6) ;ANAOP_Type_DR ；手术名称
	.i opdr'=""  d
	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d  
	...s operICDcode=$p(^ORC("OPER",+opdr),"^",14)
	...s operCateg = $p(^ORC("OPER",+opdr),"^",7) ;ORC_OperationCategory手术级别类别表 DHC_ANC_OPLevel 手术级别表 
	...s operLevel="" ;手术级别 1234 一二三四级
	...i operCateg'="" s operLevel=$p(^ORC("CATEG",+operCateg),"^",1) ;手术级别 1234 一二三四级
	...i opdes'="" s opdes=opdes_"," _$P($g(^ORC("OPER",+opdr)),"^",2)
	...e  s opdes=$P($g(^ORC("OPER",+opdr)),"^",2)
	...i icdCodeStr'="" s icdCodeStr=icdCodeStr _"," _operICDcode
	...e  s icdCodeStr=operICDcode
	.e  d
	..i $g(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))'="" d
	...s opdes=$G(^OR(adm,"ANA",chl,"OP",subchl,"REM",2))
	.s i=i+1
	.q:i>1 ;手术级别只取主手术的
	.s operLocId=$P(^OR(adm,"ANA",chl,"OP",subchl),"^",10) ;ANAOP_CTLOC_DR
	.s as=0 f  s as=$O(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as)) q:(as="")  d
	..s asdr=$P(^OR(adm,"ANA",chl,"OP",subchl,"ASS",as),"^",1)
	..i as=1 s ass1=##class(web.DHCANOPCom).GetNameById(asdr)
	..i as=2 s ash=##class(web.DHCANOPCom).GetNameById(asdr)
	
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	
	//麻醉信息表
	/*Set opsId=""
	Set opsId = $O(^CIS.AN.OperScheduleI("Adm"," "_EpisodeId,opsId),-1)
	if (opsId'=""){
		set anaestObj=##class(CIS.AN.COM.Query).ToObject("CIS.AN.BL.Anaesthesia:FindAnaesthesia",opsId)
		set TheatreInDT=anaestObj.GetValue("TheatreInDT")			// 入手术间时间
		set TheatreOutDT=anaestObj.GetValue("TheatreOutDT")			// 离手术间时间
		set OperStartDT=anaestObj.GetValue("OperStartDT")			// 手术开始时间
		set OperFinishDT=anaestObj.GetValue("OperFinishDT")			// 手术结束时间
		set AnaStartDT=anaestObj.GetValue("AnaStartDT")				// 麻醉开始时间
		set AnaFinishDT=anaestObj.GetValue("AnaFinishDT")			// 麻醉结束时间
		set TubeInDT=anaestObj.GetValue("TubeInDT")					// 插管时间
		set TubeOutDT=anaestObj.GetValue("TubeOutDT")				// 拔管时间
		set AreaInDT=anaestObj.GetValue("AreaInDT")					// 入手术室时间
		set AreaOutDT=anaestObj.GetValue("AreaOutDT")				// 离手术室时间
		set PACUInDT=anaestObj.GetValue("PACUInDT")					// 入手术室时间
		set PACUOutDT=anaestObj.GetValue("PACUOutDT")				// 离手术室时间
		
		Set:OperStartDT'="" opsttime=$p(OperStartDT," ",2)
		Set:(opendtime="")&&(OperFinishDT'="") opendtime=$p(OperFinishDT," ",2)
	}*/
	
	// 手术时长
	Set OperHour = ..GetHourByDateTime(opstdate,opsttime,openddate,opendtime)
	s ^TMPAN("AppM",$j,opaId)=$lb(opaId,EpisodeID,icdCodeStr,opdes,operLevel,opstdate,opsttime,openddate,opendtime,OperHour,anmethodCodeStr,anmethod,opaStatus)
	d OutRow2
	q

OutRow2
	Set ^CacheTemp(repid,ind)=^TMPAN("AppM",$j,opaId)
	Set ind=ind+1
	quit
AutoTaskErr
	Quit $$$OK
}

ClassMethod GetAnOpListForMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  	Set repid=$LIST(qHandle,2)
  	Set ind=$LIST(qHandle,3)
  	Set ind=$o(^CacheTemp(repid,ind))
  	If ind="" { // if there are no more rows, finish fetching
  		Set AtEnd=1
  		Set Row=""
  	}
  	Else {
  		Set Row=^CacheTemp(repid,ind)
  	}
  	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAnOpListForMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListForMExecute ]
{
	Set repid=$LIST(qHandle,2)
  	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-04
/// Description:  计算两个时间的间隔分钟数（时差-小时）
/// Input：       aFromDate ：开始日期  YYYY-MM-DD 或者 数字格式
///               aFromTime : 开始时间  HH:MM:SS   或者 数字格式
///               aEndDate  ：结束日期  YYYY-MM-DD 或者 数字格式
///               aEndTime  : 结束时间  HH:MM:SS   或者 数字格式
/// Return:		  时间间隔分钟数
/// Debug:		  w ##class(DHCHAI.Utils.CommonSrv).GetHourByDateTime("2017-08-04","01:00:00","2017-08-04","05:00:00")
ClassMethod GetHourByDateTime(aFromDate As %String, aFromTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aFromDate,aFromTime,aEndDate,aEndTime)
	Set return=0
	Quit:(aFromDate="")||(aFromTime="")||(aEndDate="")||(aEndTime="") return
	Set Hours=0
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromTime[":" aFromTime=$zth(aFromTime,1)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	Set:aEndTime[":" aEndTime=$zth(aEndTime,1)
	Quit:(aFromDate>aEndDate) return  // 开始日期大于结束日期
	Quit:(aFromDate=aEndDate)&&(aFromTime>aEndTime) return
	
	If (aFromDate=aEndDate) {
		Set Hours=$Number((aEndTime-aFromTime)/60,0)+1     // 向上取整
	} Else {  // aFromDate<aEndDate
		Set DayHours=(aEndDate-aFromDate)*24*60
		Set tmpHours=$Number((aEndTime-aFromTime)/60,0)+1  // 向上取整
		Set Hours=DayHours+tmpHours
	}
	Set return = Hours
	Quit return
}

}
