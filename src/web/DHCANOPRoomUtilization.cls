Class web.DHCANOPRoomUtilization Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2009-12-23
/// Description: 手术间利用率统计
/// Table：DHC_AN_OPArrange,DHC_ANC_OPLevel,OR_Anaesthesia,OR_Anaest_Operation,OR_An_Oper_Assistant
/// Input：stdate:开始日期, enddate:结束日期, OpRoomDesc:手术间描术
/// Return：手术间占用时间:OpOccTime,实际利用时间+第一台延误时间+换台时间
/// 		手术间实际利用时间:OpAvailTime,第一台手术延迟时间:FirstOpDelayTime,换台时间:OpExchTime,
/// 		手术间占用率:OpOccRate,占用时间/24小时
/// 		手术间使用率:AvailRate,手术实际利用时间/占用时间
/// 		24小时使用率:AvailRate24H,手术实际利用时间/24小时
/// 		手术间:OpRoom,手术室:OpLoc
Query GetAnOpList(stdate As %String, enddate As %String, OpRoomDesc As %String = "", OPRCTLoc As %String = "") As %Query(ROWSPEC = "OpOccTime:%String,OpAvailTime:%String,FirstOpDelayTime:%String,OpExchTime:%String,OpOccRate:%String,AvailRate:%String,AvailRate24H:%String,OpRoom:%String,OpLoc:%String")
{
}

ClassMethod GetAnOpListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, OpRoomDesc As %String = "", OPRCTLoc As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^TMPAN("RUtil",$j)
	i (stdate="") s stdate=+$H
 	//e  s sdate=$zdh(stdate,4)	
 	i (enddate="") s enddate=+$H
 	//e  s edate=$zdh(enddate,4)
 	i enddate<stdate Quit $$$OK
 		
	s TOPRRowid=0
	f  s TOPRRowid=$o(^DHCANC("OPRoom",TOPRRowid))  q:TOPRRowid=""  d
	.s OpRoom=$p(^DHCANC("OPRoom",TOPRRowid),"^",2)			//OPR_Desc				手术间
	.q:(OpRoomDesc'="")&(OpRoomDesc'=OpRoom)
	.s OpLocId=$p(^DHCANC("OPRoom",TOPRRowid),"^",3)		//OPR_Ctloc_Dr			手术室
	.i OpLocId'="" s OpLoc=$P(^CTLOC(OpLocId),"^",2)
	.e  s OpLoc=""
	.q:(OPRCTLoc'="")&(OPRCTLoc'=OpLoc)
	.s OpOccTime=0,OpAvailTime=0,OneOpAvailTime=0,FirstOpDelayTime=0,OpExchTime=0,OpOccRate=0,AvailRate=0,AvailRate24H=0
	.f date=stdate:1:enddate d
	..s opaId=0
	..f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId))  q:opaId=""  d
	...s OPRRowid=$P(^DHCANOPArrange(opaId),"^",20)
	...q:OPRRowid'=TOPRRowid
	...s NOPRStat=$P(^DHCANOPArrange(opaId),"^",27)			//OPA_Status 			手术申请状态
	...q:NOPRStat'="F"										//非完成状态退出
	...s OPRSeq=$P(^DHCANOPArrange(opaId),"^",26)  			//OPA_Seq				手术台次
	...q:OPRSeq=""											//手术台次不能为空
	...s OPRAppDate=+$P(^DHCANOPArrange(opaId),"^",3)		//OPA_AppDate			手术申请日期
	...s OPRAppTime=+$P(^DHCANOPArrange(opaId),"^",5)		//OPA_AppTime			手术申请时间
	...s adm=$P(^DHCANOPArrange(opaId),"^",1)				//OPA_Adm_dr			病人EpisodeID
	...s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)	//OPA_Anaest_dr			麻醉表ID	OR_Anaesthesia
	...s AnThInDate=+$P(^OR(adm,"ANA",chl),"^",39)			//ANA_TheatreInDate		手术开始日期
	...s AnThInTime=+$P(^OR(adm,"ANA",chl),"^",40)			//ANA_TheatreInTime		手术开始时间
	...s AnThOutDate=+$P(^OR(adm,"ANA",chl),"^",41)			//ANA_TheatreOutDate	手术结束日期
	...s AnThOutTime=+$P(^OR(adm,"ANA",chl),"^",42)			//ANA_TheatreOutTime	手术结束时间
	...s OneOpAvailTime=(AnThOutDate-AnThInDate)*86400+(AnThOutTime-AnThInTime)
	...s OpAvailTime=+$g(OpAvailTime)+OneOpAvailTime		//手术实际利用时间
	...s ^TMPAN("RUtil",$j,TOPRRowid,date,OPRSeq)=OPRAppDate_"^"_OPRAppTime_"^"_AnThInDate_"^"_AnThInTime_"^"_AnThOutDate_"^"_AnThOutTime
	..s opseq=0,preenddate=0,preendtime=0  					//保存上一台手术结束日期与时间
	..f  s opseq=$o(^TMPAN("RUtil",$j,TOPRRowid,date,opseq)) q:opseq=""  d
	...s opappdate=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",1)
	...s opapptime=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",2)
	...s opstartdate=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",3)
	...s opstarttime=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",4)
	...s openddate=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",5)
	...s opendtime=$p(^TMPAN("RUtil",$j,TOPRRowid,date,opseq),"^",5)
	...i opseq=1 d
	....s FirstOpDelayTime=+$g(FirstOpDelayTime)+(opstartdate-opappdate)*86400+(opstarttime-opapptime)	//第一台手术延迟时间
	...e  d
	....s OpExchTime=+$g(OpExchTime)+(opstartdate-preenddate)*86400+(opstarttime-preendtime)			//换台时间
	...s preenddate=openddate,preendtime=opendtime
	.s OpOccTime=OpAvailTime+FirstOpDelayTime+OpExchTime	//占用时间=实际利用时间+第一台延误时间+换台时间
	.i OpOccTime'=0 d
	..s OpOccRate=OpOccTime/(86400*(enddate-stdate+1))		//占用率=占用时间/24小时
	..s OpOccRate=$fn(OpOccRate,"",1)*100
	..s OpOccRate=OpOccRate_"%"
	.i OpOccTime'=0	d
	..s AvailRate=OpAvailTime/OpOccTime						//利用率=手术实际利用时间/占用时间
	..s AvailRate=$fn(AvailRate,"",1)*100
	..s AvailRate=AvailRate_"%"
	.i OpAvailTime'=0 d
	..s AvailRate24H=OpAvailTime/(86400*(enddate-stdate+1))	//24小时利用率=手术实际利用时间/24小时
	..s AvailRate24H=$fn(AvailRate24H,"",1)*100
	..s AvailRate24H=AvailRate24H_"%"
	.s OpOccTime=$fn(OpOccTime/3600,"",1)
	.s OpAvailTime=$fn(OpAvailTime/3600,"",1)
	.s FirstOpDelayTime=$fn(FirstOpDelayTime/3600,"",1)
	.s OpExchTime=$fn(OpExchTime/3600,"",1)
	.d OutputRow
	//清楚临时Global
	k ^TMPAN("RUtil",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OpOccTime,OpAvailTime,FirstOpDelayTime,OpExchTime,OpOccRate,AvailRate,AvailRate24H,OpRoom,OpLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAnOpListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnOpListExecute ]
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

ClassMethod GetAnOpListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnOpListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
