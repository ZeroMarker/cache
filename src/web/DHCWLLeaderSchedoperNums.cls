Class web.DHCWLLeaderSchedoperNums Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：xss
/// Desc:按入院日期、结算日期统计患者基本信息及费用
/// CreateDate: 2014-05-20
/// Table:      DHCWorkLoad
/// Input:      startDate-开始日期,endDate-结束日期
/// Output:     科室、病人姓名、住院号、年龄、性别、手术名称、手术者、麻醉医师、手术规模
/// d ##class(%ResultSet).RunQuery("web.DHCWLLeaderSchedoperNums","GetSchedoperNums","2013-05-18","2013-05-23")
Query GetSchedoperNums(startDate As %String, endDate As %String, HOSPID As %String) As %Query(ROWSPEC = "locDesc:%String,patName:%String,inpatNO:%String,ageDesc:%String,sex:%String,operTime:%String,OperName:%String,surgeonDocName:%String,anaestdocName:%String,ancoplDesc:%String") [ SqlProc ]
{
}

ClassMethod GetSchedoperNumsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, HOSPID As %String) As %Status
{
	
	set repid=$I(^CacheTemp)
	if $g(ind)="" Set ind=1
	set qHandle=$lb(0,repid,0)	
	q:startDate="" $$$OK
	q:endDate="" $$$OK	
	
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)	
	
	
	
   f operDate=sDate:1:eDate  d	
   .s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",operDate,opaId)) q:opaId=""  d
   ..s opaStatus=$p(^DHCANOPArrange(opaId),"^",27)
   ..q:opaStatus'="R"  ;取手术状态为"安排"状态
   ..s admId=$p(^DHCANOPArrange(opaId),"^",1)
   ..s locDr=$p(^DHCANOPArrange(opaId),"^",21)        ;病人科室	
   ..i locDr="" s locDr=$p(^PAADM(admId),"^",4)
   ..s mHosp=$p(^CTLOC(locDr),"^",22)                ;医院ID
   ..q:(HOSPID'="")&&(HOSPID'=mHosp) 
   ..s locDesc=$p(^CTLOC(locDr),"^",2)
   ..i locDesc [ "-" s locDesc=$p(locDesc,"-",2)
   ..s operTime=$p($g(^DHCANOPArrange(opaId)),"^",15)
   ..s inpatNO=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(admId) ;住院号
   ..s papmiDr=$p($g(^PAADM(admId)),"^",1)
   ..s patName=$p($g(^PAPER(papmiDr,"ALL")),"^",1)          ;病人姓名
   ..s sex=$$GetSex^DHCWLCommon(papmiDr)                    ;性别
   ..s ageDesc=$$GetAge^DHCWLCommon(papmiDr)	            ;年龄
   ..s oPLevelId=$p(^DHCANOPArrange(opaId),"^",28)          ;手术规模
   ..i oPLevelId="" s ancoplDesc=""
   ..e  s ancoplDesc=$p($g(^DHCANC(oPLevelId)),"^",2)
   ..s anaestDr=$p($g(^DHCANOPArrange(opaId)),"^",2)        ;手术麻醉Id
   ..i anaestDr'="" d
   ...s anPaadmDr=$p(anaestDr,"||",1)
   ...s anSubDr=$p(anaestDr,"||",2)
   ...s anaestDocDr=$p(^OR(anPaadmDr,"ANA",anSubDr),"^",6)   ;麻醉师
   ...i anaestDocDr="" s anaestdocName=""
   ...e  s anaestdocName=$p(^CTPCP(anaestDocDr,1),"^",2)  
   ...s anaOpSub=0 s anaOpSub=$o(^OR(anPaadmDr,"ANA",anSubDr,"OP",anaOpSub)) q:anaOpSub=""    ;手术表OR_Anaest_Operation中取手术信息
   ....s OperDr=+$p(^OR(anPaadmDr,"ANA",anSubDr,"OP",anaOpSub),"^",6)           ;ORC_Operation手术名称
   ....i OperDr="" s OperName=""
   ....e  s OperName=$p($g(^ORC("OPER",OperDr)),"^",2)                          
   ....s surgeonDr=+$p(^OR(anPaadmDr,"ANA",anSubDr,"OP",anaOpSub),"^",8)         ;CT_CareProv主刀医生
   ....i surgeonDr="" s surgeonDocName=""
   ....e  s surgeonDocName=$p(^CTPCP(surgeonDr,1),"^",2)      
   ..d OutputRow1
	
	Quit $$$OK
	
		
OutputRow1
    s data=$lb(locDesc,patName,inpatNO,ageDesc,sex,operTime,OperName,surgeonDocName,anaestdocName,ancoplDesc)
 	Set ^CacheTemp(repid,ind)=data
 	Set ind=ind+1
 	quit
}

ClassMethod GetSchedoperNumsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchedoperNumsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSchedoperNumsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchedoperNumsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
