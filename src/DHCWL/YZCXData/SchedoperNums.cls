Class DHCWL.YZCXData.SchedoperNums Extends %RegisteredObject [ ProcedureBlock ]
{

/// 院长查询专用-安排手术明细
/// Creator：xss
/// Desc:统计安排手术病人明细 ,modified by czx in 2017-01-19
/// CreateDate:2015-02-13
/// Table:
/// Input:      
/// Output: 科室、病人姓名、住院号、年龄、性别、手术时间、麻醉医师、手术级别
///  USERID,HOSPID从报表传递回话变量
/// d ##class(%ResultSet).RunQuery("DHCWL.YZCXData.SchedoperNums","GetSchedoperNums","2013-07-01","2013-07-01","2,3") 
Query GetSchedoperNums(startDate As %String, endDate As %String, hos As %String) As %Query(ROWSPEC = "depDesc:%String,patName:%String,inpatNO:%String,ageDesc:%String,sex:%String,opastime:%String,anaestDocName:%String,oPLevelDesc:%String") [ SqlProc ]
{
}

ClassMethod GetSchedoperNumsExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hos As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)	
	q:startDate="" $$$OK
	q:endDate="" $$$OK
	q:hos="" $$$OK
	
	k data
	
	s sDate=$zdh(startDate,3)
	s eDate=$zdh(endDate,3)
	
	d SplitMulitData(hos,,.data)
	 
	 
   f date=sDate:1:eDate d
   .s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
   ..s opaStatus=$p(^DHCANOPArrange(opaId),"^",27)
   ..q:opaStatus'="R"  ;取手术状态为"安排"状态
   ..;w opaStatus,!
   ..s admId=$p(^DHCANOPArrange(opaId),"^",1)
   ..s locDr=$p(^DHCANOPArrange(opaId),"^",21)              ;病人科室
   ..i locDr="" s locDr=$p(^PAADM(admId),"^",4)
   ..s hospId=$p($g(^CTLOC(locDr)),"^",22)
   ..;q:(hos'="")&&(hos'=hospId)  
   ..q:(hos'="")&&(hospId="")
   ..q:(hos'="")&&('$d(data(hospId))) 
   ..i $d(^CTLOC(locDr)) s depDesc=$p(^CTLOC(locDr),"^",2)   
   ..e  s depDesc="Null"
   ..i depDesc["-" s depDesc=$p(depDesc,"-",2) 
   ..s admId=$p(^DHCANOPArrange(opaId),"^",1)
   ..s papmiDr=$p($g(^PAADM(admId)),"^",1)
   ..s patName=$p($g(^PAPER(papmiDr,"ALL")),"^",1)          ;病人姓名
   ..s inpatNO=$p($g(^PAPER(papmiDr,"PAT",1)),"^",22)       ;住院号
   ..i inpatNO="" s inpatNO=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(admId,"I")
   ..s ageDesc=$$GetAge(papmiDr)	                        ;年龄
   ..s sex=$$GetSex^DHCWLCommon(papmiDr)                    ;性别	
   ..s opastime=$p(^DHCANOPArrange(opaId),"^",15)           ;手术开始时间
   ..s opastime=$zt(opastime,3)
   ..s Anaestdr=$p(^DHCANOPArrange(opaId),"^",2)
   ..s AnPaadmDr=$p(Anaestdr,"||",1)
   ..s AnSubDr=$p(Anaestdr,"||",2)
   ..s ANAOPChildsubM=0 s ANAOPChildsubM=$o(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM)) q:ANAOPChildsubM=""    ;手术表OR_Anaest_Operation中取手术信息
   ..s OpnameM=+$p(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM),"^",6)         ;手术名称
   ..;s oPLevelId=$p(^ORC("OPER",OpnameM,"DHC"),"^",1) ;手术级别 (有的项目不存在，标库不存在用下边的手术级别) 
   ..s oPLevelId=$P($g(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM,"DHC")),"^",1) ;手术级别 
   ..s oPLevelId=+$p($g(^OR(AnPaadmDr,"ANA",AnSubDr,"OP",ANAOPChildsubM,"DHC")),"^",1)
   ..i oPLevelId="" s oPLevelId=$p(^ORC("OPER",OpnameM),"^",7)     //手术级别 ORC_Operation（OPER_DefaultCategory_DR－> ORC_OperationCategory）  
   ..;b ;czx
   ..s oPLevelDesc=$p(^ORC("CATEG",oPLevelId),"^",2) ;手术级别描述
   ..;s oPLevelDesc=$p(^DHCANC("OPLevel",oPLevelId),"^",2) ;手术规模描述
   ..;b ;test
   ..s anaestdr=$p(^DHCANOPArrange(opaId),"^",2)
   ..s anPaadmDr=$p(anaestdr,"||",1)
   ..s anSubDr=$p(anaestdr,"||",2)
   ..s anaestDocDr=$p(^OR(anPaadmDr,"ANA",anSubDr),"^",6)       ;麻醉师
   ..i anaestDocDr'=""  s anaestDocName=$p($g(^CTPCP(anaestDocDr,1)),"^",2)
   ..d OutputRow1
   k data
	Quit $$$OK


  ///Creator：xss
  ///Desc:根据当前日期出生日期结算年龄
  //w $$GetAge^DHCMRIPday("")
GetAge(personId)

  q:'$d(^PAPER(personId,"ALL")) ""
  s dob=$p(^PAPER(personId,"ALL"),"^",6)  ;生日
  q:dob="" ""
  i dob["/" s dob=$zdh(dob,5)
  i dob["-" s dob=$zdh(dob,3)
  s calDate=+$h
  s age=$$CalAge^at182(dob,calDate,"","","")  
  s ageYear=$P(age,"|",12)
  s ageMonth=$P(age,"|",13)
  s ageDay=$P(age,"|",14) 
  s ageDesc=$$FormatAge(ageYear,ageMonth,ageDay)
  Q ageDesc
FormatAge(ageYear,ageMonth,ageDay)  
   if ageYear>0 s ageDesc=ageYear_"岁"
	else  d
	.if ageMonth>0 s ageDesc=ageMonth_"月"
	.else  s ageDesc=ageDay_"天"
	Q ageDesc 	

SplitMulitData(multiStr,detm=",",data)
	s hospId=""
	q:multiStr=""
	s multiLen=$l(multiStr,detm)
	f len=1:1:multiLen d
	.s hospId=$p(multiStr,",",len)
	.q:hospId=""
	.s data(hospId)="" 
    q	
	
OutputRow1
    s data=$lb(depDesc,patName,inpatNO,ageDesc,sex,opastime,anaestDocName,oPLevelDesc)
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
