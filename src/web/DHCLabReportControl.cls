Class web.DHCLabReportControl Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：      huhm
/// CreatDate：    20100107
/// Description:： 判断是预警报告
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：
ClassMethod ReportAlert(AdmNo As %String) As %String
{
	Set RetValue=0
	Set RetValue=##class(web.DHCLabReportControl).ReportWarn(AdmNo)
	If RetValue=1 Quit RetValue
	Set RetValue=##class(web.DHCLabReportControl).PreReportWarn(AdmNo)
	Quit RetValue
}

/// Creator：      huhm
/// CreatDate：    20090504
/// Description:： 判断是否有未阅读过包含警戒值或荒诞值结果的报告
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：       
ClassMethod ReportWarn(AdmNo As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s RtnValue=0
	s OEOrdId=""
	f {
		s OEOrdId=$o(^OEORD(0,"Adm",AdmNo,OEOrdId))
		q:OEOrdId=""
		s OEOrdSub="0"
		f {
			s OEOrdSub=$o(^OEORD(OEOrdId,"I",OEOrdSub))
			q:OEOrdSub=""
			i RtnValue=1 q
			s TestSetRow=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",35)
			i $l(TestSetRow){
				//w !,TestSetRow
				Set WebNS=$ZUTIL(5)
				s RepStus=..ReportStatus(TestSetRow,LabData)
				//w ",",RepStus
				zn WebNS
				i $e(RepStus,1)=0{
					i ..ReportViewLog(OEOrdId_"||"_OEOrdSub)=100{
						//w !,"oeord",OEOrdId_"||"_OEOrdSub
						s RtnValue=1
						s ^TMPWREPORT(AdmNo)=""
					}
				}
			}
		}
	} 
	s ^TMPREPORT($G(AdmNo))=RtnValue
	Quit RtnValue
}

//结果查看记录

//0已读 

ClassMethod ReportViewLog(requestId As %String, userCode As %String) As %String
{
	S userCode=$G(userCode),%session=$G(%session)
	I '$L(userCode),$L(%session) {
		S userCode=%session.Get("LOGON.USERCODE")
	}
	s retVal=100
	f i=1:1:$l(requestId,",") {
		s reqID=$p(requestId,",",i)
		i $l(reqID) s ret=##Class(web.DHCLabPortal).IsRead(reqID,userCode) 
		i ret=1 s retVal=1 q
	}
	Q retVal
	
	//&sql(select * from websys.Log where requestID=:requestId)
	//Quit SQLCODE
}

ClassMethod DisplayReadUnreadIcon(tsrowid As %String, OrdID As %String) As %String
{
  s tsrowid=$g(tsrowid),OrdID=$g(OrdID)
  i '$l(tsrowid) q ""
  i $l(tsrowid,",")>1 s tsrowid=$p(tsrowid,",",1)
  s labno=$p(tsrowid,"||",1)
  s ts=$p(tsrowid,"||",2)
  s tscnt=$p(tsrowid,"||",3)
  i '$l(labno) q ""
  i '$l(ts) q ""
  i '$l(tscnt) q ""
  i '$d(^TEPI(labno,1,ts,tscnt)) q ""
  i $p(^TEPI(labno,1,ts,tscnt),"\",31)'="A" q ""
  s %session=$G(%session)
  I $L(%session) {
		S userCode=%session.Get("LOGON.USERCODE")
  }  
  i ..ReportViewLog(OrdID,userCode)=0 {
	  s ret="webemr/Unread Results.gif"
  }else{
     s ret="webemr/ReadResults.gif"
  }
  q ret
}

ClassMethod DisplayOldResultIcon(tsrowid As %String, OrdID As %String) As %String
{
  s tsrowid=$g(tsrowid),OrdID=$g(OrdID)
  i '$l(tsrowid) q ""
  s labno=$p(tsrowid,"||",1)
  s ts=$p(tsrowid,"||",2)
  s tscnt=$p(tsrowid,"||",3)
  i '$l(labno) q ""
  i '$l(ts) q ""
  i '$l(tscnt) q ""
  i '$d(^TEPI(labno,1,ts,tscnt)) q ""
  i $p(^TEPI(labno,1,ts,tscnt),"\",31)'="A" q ""
  s ret="webemr/laboldresult.gif"
  q ret
}

ClassMethod test(requestId As %String) As %String
{
	s ^TMPREPCTL=requestId
	Quit 0
}

/// Creator：      huhm
/// CreatDate：    200906015
/// Description:： 增加阅读结果记录
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others
ClassMethod AddViewLog(UserId As %String, Episode As %String, PatientID As %String, OrderID As %String) As %String
{
	i '$l(UserId) quit 0
	i '$l(OrderID) quit 0
	s IP=$ZUTIL(67,15,$J)
 	s EXEC=$ZUTIL(67,13,$J)
 	s CACHEUSER=$ZUTIL(67,11,$J)
 	s MRADM=$p(^OEORD(+OrderID),"^",1)
 	s MRADM=$p(^PAADM(MRADM),"^",61)
	s tObj=##Class(websys.Log).%OpenId(UserId)
 	s obj=##Class(websys.Log).%New()
 	s obj.CacheUser=CACHEUSER
 	s obj.ClientExe=EXEC
 	s obj.ClientIP=IP
 	s obj.ClientName="localhost"
 	s obj.SourceType="W"
 	s obj.Type="O"
 	s obj.UserDR=tObj
 	s obj.requestEPISODE=Episode
 	s obj.requestID=OrderID
 	s obj.requestMRADM=MRADM
 	s obj.requestPATIENT=PatientID
 	s obj.ReferencedId=1403
 	s obj.ReferencedClass="websys.Component"
 	s RetValue=obj.%Save()
 	/*
	&sql(insert into websys.Log (CacheUser,ClientExe,ClientIP,ClientName,SourceType,Type,
		UserDR,requestEPISODE,requestID,requestMRADM,requestPATIENT) 
	     values(:CACHEUSER,:EXEC,:IP,"W","O",:UserId,:Episode,:OrderID,:MRADM,:PatientID))
	*/ 
 
	//往Portal更新阅读日志信息,wwh,20141008
	S userCode=""
	I $L(UserId) {
		S userCode=$P($G(^SSU("SSUSR",UserId)),"^",1)
		S userName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	
		D ##Class(web.DHCLabPortal).ReadingLog(OrderID,userCode)

		//更新检验阅读日志 VisitNumberReportDR
		i $l(Episode)
		{
			S HospID=$g(%session.Get("LOGON.HOSPID"))
			s HospCode=""
			i $l(HospID) s HospCode=$p($g(^CT("HOSP",HospID)),"^",1)
			s DoctorDR=##Class(DHCLIS.DHCCommon).GetDoctorDR(userCode, userName, HospCode)
	 		s objRead=##Class(dbo.RPVisitNumberReportRead).%New()
			s objRead.VisitNumberReportDR=Episode
			s objRead.ReadDate=$tr($zd(+$h,3),"-")
			s objRead.ReadTime=$p($h,",",2)
			s objRead.ReadDoctorDR=DoctorDR
			s objRead.ReadNotes=""
			s RetValue=objRead.%Save()
		}	
	}
	Quit RetValue
}

//报告状态

ClassMethod ReportStatus(TSRowId As %String, LabNS As %String) As %String
{
	//new (TSRowId)
	//
	
	Set LabNo=$p(TSRowId,"||",1)
	Set TS=$p(TSRowId,"||",2)
	Set TSCnt=$p(TSRowId,"||",3)
	If '$l(LabNo) Quit 100
	If '$l(TS) Quit 100
	i '$d(^TEPI(LabNo,1,TS,TSCnt)) Quit 100
	//接收日期时间
	s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
	i $l(RecDate) s RecDate=$zd(RecDate,3)
	s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
	i $l(RecTime) s RecTime=$zt(RecTime*60,2)
	//新的危急值处理
	//^DHCPanicReport(125,1) = "62924\41567\demo\62924\31560\demo\349\34\C\C\\" 
	//RetValue_"^"_TransMemo_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTim
	s ord=$o(^[LabNS]DHCPanicReport(1,LabNo,""),-1)
	i $l(ord) d  q RetValue_"^"_TransMemo_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTim
	.s AuthDate=$p(^[LabNS]DHCPanicReport(1,LabNo,ord),"\",1)
	.s AuthTim=$p(^[LabNS]DHCPanicReport(1,LabNo,ord),"\",2)
	.s TransMemo=$p(^[LabNS]DHCPanicReport(1,LabNo,ord),"\",8)
    .s TransMemoDr=$p($p(TransMemo,"{",2),"}",1)
    .i $L(TransMemoDr),$d(^[LabNS]DHCTSTransComment(TransMemoDr)) s TransMemo=$p(^[LabNS]DHCTSTransComment(TransMemoDr),"\",1)
	.i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
	.i $l(AuthTim) s AuthTim=$zt(AuthTim,2)
	.s RetValue="0"
	// 	
	Set ResStus=$p(^TEPI(LabNo,1,TS,TSCnt),"\",31)
	i ResStus'="A" Quit 100
	s TransDate=$o(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,""),-1)
	i '$l(TransDate) Quit 100
	s TransTime=$o(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,TransDate,""),-1)
	i '$l(TransTime) Quit 100
	s TransStr=$g(^[LabNS]DHCTSTrans(LabNo,TS,TSCnt,TransDate,TransTime))
	i '$l(TransStr) Quit 100
	s RetValue=100
	s Status=$p(TransStr,"\",2)
	//警戒报告
	i Status="PNC" s RetValue=0
	//荒诞报告
	i Status="RU" s RetValue=0
	//报告说明
	s TransMemoDr=$p(TransStr,"\",4)
	s TransMemo=""
	if $e(TransMemoDr,1)'="{"{
		s TransMemo=TransMemoDr
	}
	else{
		s TransMemoDr=$p($p(TransMemoDr,"{",2),"}",1)
		i $L(TransMemoDr),$d(^[LabNS]DHCTSTransComment(TransMemoDr)){
			 s TransMemo=$p(^[LabNS]DHCTSTransComment(TransMemoDr),"\",1)
		}
	} 
	//审核日期时间
	s AuthDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",4)
	i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
	s AuthTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",5)
	i $l(AuthTime) s AuthTime=$zt(AuthTime*60,2)
	Quit RetValue_"^"_TransMemo_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTime
}

//预报告状态

ClassMethod PreReportStatus(TSRowId As %String, LabNS As %String) As %String
{
	zn LabNS
	Set LabNo=$p(TSRowId,"||",1)
	Set TS=$p(TSRowId,"||",2)
	Set TSCnt=$p(TSRowId,"||",3)
	If '$l(LabNo) Quit 100
	If '$l(TS) Quit 100
	i '$d(^TEPI(LabNo,1,TS,TSCnt)) Quit 100
	Set ResStus=$p(^TEPI(LabNo,1,TS,TSCnt),"\",31)
	i ResStus="A" Quit 100
	s PreReportStr=""
     
    s RetValue=0
	s seq=""
	f {
		s seq=$o(^DHCPreReporti("STATUS","A",LabNo,TS,TSCnt,seq),-1)
		q:seq=""
		i '$d(^DHCPreReport(LabNo,TS,TSCnt,seq,"ReadLog")) s RetValue=1 q
	}
	i RetValue=0 q 100
	s PreReportStr=$g(^DHCPreReport(LabNo,TS,TSCnt,seq))
	s TransMemo=""
	//接收日期时间
	s RecDate=$p(^TEPI(LabNo,1,TS,TSCnt),"\",21)
	i $l(RecDate) s RecDate=$zd(RecDate,3)
	s RecTime=$p(^TEPI(LabNo,1,TS,TSCnt),"\",22)
	i $l(RecTime) s RecTime=$zt(RecTime*60,2)
	//审核日期时间
	s AuthDate=$p(PreReportStr,"\",4)
	i $l(AuthDate) s AuthDate=$zd(AuthDate,3)
	s AuthTime=$p(PreReportStr,"\",5)
	i $l(AuthTime) s AuthTime=$zt(AuthTime,2)
	Quit "1^"_TransMemo_"^"_RecDate_" "_RecTime_"^"_AuthDate_" "_AuthTime
}

//预报告状态0,1

ClassMethod PreReportStatus1(TSRowId As %String, LabNS As %String) As %String
{
	zn LabNS
	Set LabNo=$p(TSRowId,"||",1)
	Set TS=$p(TSRowId,"||",2)
	Set TSCnt=$p(TSRowId,"||",3)
	If '$l(LabNo) Quit 100
	If '$l(TS) Quit 100
	i '$d(^TEPI(LabNo,1,TS,TSCnt)) Quit 100
	Set ResStus=$p(^TEPI(LabNo,1,TS,TSCnt),"\",31)
	i ResStus="A" Quit 100
	s PreReportStr=""
     
    s RetValue=0
	s seq=""
	f {
		s seq=$o(^DHCPreReporti("STATUS","A",LabNo,TS,TSCnt,seq),-1)
		q:seq=""
		i '$d(^DHCPreReport(LabNo,TS,TSCnt,seq,"ReadLog")) s RetValue=1 q
	}
	q RetValue
}

/// Creator：      huhm
/// CreatDate：    20090608
/// Description:： 得到医嘱标本和采样信息
/// Table：       
/// Input：        医嘱ID
/// Output：       
/// Return：       采集日期,采集时间,采集人
/// Others：
ClassMethod GetCollectionInfo(OrdRowId As %String) As %String
{
	//n (OrdRowId)
	s OrdRowId=$g(OrdRowId)
	s CollRowId=OrdRowId_"||1"
	s (execrowid,SpecDate,SpecTime,CollUser)=""
	i $d(^DHCOrdExec(0,"OEOREDR",CollRowId)) s execrowid=$o(^DHCOrdExec(0,"OEOREDR",CollRowId,""))
	i $l(execrowid),$d(^DHCOrdExec(execrowid)){
 		s SpecDate=$p(^DHCOrdExec(execrowid),"^",13)
 		s SpecTime=$p(^DHCOrdExec(execrowid),"^",14)
 		s CollUser=$p(^DHCOrdExec(execrowid),"^",12)
	}
	s OrdId=$p(OrdRowId,"||",1)
	s SubId=$p(OrdRowId,"||",2)
	i $l(SpecDate) s SpecDate=$zd(SpecDate,3)
	i $l(SpecTime) s SpecTime=$zt(SpecTime,2)
	s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	s SpecCode=""
	i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
	Set temord=$Order(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
	i $l(temord) Set specstr=$Get(^OEORD(OrdId,"I",SubId,"SPEC",temord))
	q SpecCode_"^"_SpecDate_" "_SpecTime_"^"_CollUser
}

ClassMethod WarnReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WarnReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WarnReportListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s AdmNo=$g(EpisodeID)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s OEOrdId=""
	f {
		s OEOrdId=$o(^OEORD(0,"Adm",AdmNo,OEOrdId))
		q:OEOrdId=""
		s OEOrdSub="0"
		f {
			s OEOrdSub=$o(^OEORD(OEOrdId,"I",OEOrdSub))
			q:OEOrdSub=""
			s TestSetRow=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",35)
			i $l(TestSetRow){
				//w !,TestSetRow
				Set WebNS=$ZUTIL(5)
				s RepStus=..ReportStatus(TestSetRow,LabData)
				//w ",",RepStus
				zn WebNS
				i $e(RepStus,1)=0{
					i ..ReportViewLog(OEOrdId_"||"_OEOrdSub)=100{
						//w !,"oeord",OEOrdId_"||"_OEOrdSub
						s ItmMastDr=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,1)),"^",2)
						s ReqDate=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",7)
						s ReqTime=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,1)),"^",17)
						i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
						i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
    					s OrdName=$Piece(^ARCIM($Piece(ItmMastDr,"||",1),$Piece(ItmMastDr,"||",2),1),"^",2)
						s OrdRowId=OEOrdId_"||"_OEOrdSub
						s CollInfo=..GetCollectionInfo(OrdRowId)
						s SpecCode=$p(CollInfo,"^",1)
						s SpecDesc=""
						i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
								s SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
						}
						s CollDT=$p(CollInfo,"^",2)
						s TransMemo=$p(RepStus,"^",2)
						s RecDT=$p(RepStus,"^",3)
						s AuthDT=$p(RepStus,"^",4)
						d OutputRow
					}
				}
			}
		}
	} 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OrdRowId,OrdName,SpecDesc,TransMemo,ReqDate_" "_ReqTime,CollDT,RecDT,AuthDT,TestSetRow)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod WarnReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WarnReportListExecute ]
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

/// Creator：      huhm
/// CreatDate：    200906010
/// Description:： 得到未阅读过的警戒值或荒诞值结果的报告列表
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：
Query WarnReportList(EpisodeID As %String) As %Query(ROWSPEC = "orderid:%String,OrdDesc:%String,SpecDesc:%String,TransMemo:%String,ReqDateTime:%String,CollDateTime:%String,RecDateTime:%String,AuthDateTime:%String,LabTSRow:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20091208
/// Description:： 判断是否有未阅读过的预报告
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others：       
ClassMethod PreReportWarn(AdmNo As %String) As %String
{
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s RtnValue=0
	s OEOrdId=""
	f {
		s OEOrdId=$o(^OEORD(0,"Adm",AdmNo,OEOrdId))
		q:OEOrdId=""
		s OEOrdSub="0"
		f {
			s OEOrdSub=$o(^OEORD(OEOrdId,"I",OEOrdSub))
			q:OEOrdSub=""
			i RtnValue=1 q
			s TestSetRow=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",35)
			i $l(TestSetRow){
				//w !,TestSetRow
				Set WebNS=$ZUTIL(5)
				s PreStus=..PreReportStatus1(TestSetRow,LabData)
				//w ",",RepStus
				zn WebNS
				i PreStus=1 s RtnValue=1
			}
		}
	} 
	Quit RtnValue
}

ClassMethod PreReportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PreReportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PreReportListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMPPRE=$g(EpisodeID)
	s AdmNo=$g(EpisodeID)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s OEOrdId=""
	f {
		s OEOrdId=$o(^OEORD(0,"Adm",AdmNo,OEOrdId))
		q:OEOrdId=""
		s OEOrdSub="0"
		f {
			s OEOrdSub=$o(^OEORD(OEOrdId,"I",OEOrdSub))
			q:OEOrdSub=""
			s TestSetRow=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",35)
			i $l(TestSetRow){
				//w !,TestSetRow
				Set WebNS=$ZUTIL(5)
				s PreRepStus=..PreReportStatus(TestSetRow,LabData)
				zn WebNS
				i $p(PreRepStus,"^")=1{
						//w !,"oeord",OEOrdId_"||"_OEOrdSub
						s ItmMastDr=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,1)),"^",2)
						s ReqDate=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,3)),"^",7)
						s ReqTime=$p($g(^OEORD(OEOrdId,"I",OEOrdSub,1)),"^",17)
						i $l(ReqDate) s ReqDate=$zd(ReqDate,3)
						i $l(ReqTime) s ReqTime=$zt(ReqTime,2)
    					s OrdName=$Piece(^ARCIM($Piece(ItmMastDr,"||",1),$Piece(ItmMastDr,"||",2),1),"^",2)
						s OrdRowId=OEOrdId_"||"_OEOrdSub
						s CollInfo=..GetCollectionInfo(OrdRowId)
						s SpecCode=$p(CollInfo,"^",1)
						s SpecDesc=""
						i $l(SpecCode),$d(^TTAB("SPEC",SpecCode)){
								s SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
						}
						s CollDT=$p(CollInfo,"^",2)
						s TransMemo=$p(PreRepStus,"^",2)
						s RecDT=$p(PreRepStus,"^",3)
						s AuthDT=$p(PreRepStus,"^",4)
						d OutputRow
				}
			}
		}
	} 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(OrdRowId,OrdName,SpecDesc,TransMemo,ReqDate_" "_ReqTime,CollDT,RecDT,AuthDT,TestSetRow)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PreReportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PreReportListExecute ]
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

/// Creator：      huhm
/// CreatDate：    20091207
/// Description:： 得到未阅读过的预报告的报告列表
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       0:无,1:有
/// Others
Query PreReportList(EpisodeID As %String) As %Query(ROWSPEC = "orderid:%String,OrdDesc:%String,SpecDesc:%String,TransMemo:%String,ReqDateTime:%String,CollDateTime:%String,RecDateTime:%String,AuthDateTime:%String,LabTSRow:%String")
{
}

/// Creator：      huhm
/// CreatDate：    20091208
/// Description:： 增加阅读预报告记录
/// Table：       
/// Input：        用户,报告ID
/// Output：       
/// Return：       0
/// Others
ClassMethod AddPreViewLog(UserId As %String, TSRow As %String) As %String
{
	s IP=$ZUTIL(67,15,$J)
 	//s EXEC=$ZUTIL(67,13,$J)
 	//s CACHEUSER=$ZUTIL(67,11,$J)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	Set WebNS=$ZUTIL(5)
	s LabNo=$p(TSRow,"||",1)
	s TS=$p(TSRow,"||",2)
	s TSCnt=$p(TSRow,"||",3)
	zn LabData
	s seq=""
	f {
		s seq=$o(^DHCPreReporti("STATUS","A",LabNo,TS,TSCnt,seq),-1)
		q:seq=""
		s ord=$o(^DHCPreReport(LabNo,TS,TSCnt,seq,"ReadLog",""),-1)+1
		s ^DHCPreReport(LabNo,TS,TSCnt,seq,"ReadLog",ord)=UserId_"\"_$h_"\"_IP
	}
	zn WebNS
	q 0
}

ClassMethod ReportDoctor(requestId As %String) As %String
{
    //S ^TWebSysLog("Log",RequestID)=ComponentID
	//^websys.LogI("ReferenceId"," 1403"," 50594||1113",6384)	=	"
	S ComponentID=1403
	s ret="^^"
	//I $D(^TWebSysLog("Log",requestId)) S ComponentID=$G(^TWebSysLog("Log",requestId))
	I '$L(ComponentID) Q ret 
	//b ;1
	S RequestID=requestId
	s id="" f  s id=$o(^websys.LogI("ReferenceId",$c(32)_ComponentID,$c(32)_RequestID,id)) q:id=""  d
	.s str=$g(^websys.LogD(id))
	.s UserDr=$li(str,5)
	.s AudDate=$li(str,1)
	.i $l(AudDate) s AudDate=$zd(AudDate,3)
	.s AudTime=$li(str,2)
	.i $l(AudTime) s AudTime=$zt(AudTime)
	.s loc=$li(str,22)
	.S Doctor=""
	.s (CPTDr,CPTType,CPTTypeDesc)=""
	.i $l(UserDr),$d(^SSU("SSUSR",UserDr)) s CPTDr=$p(^SSU("SSUSR",UserDr),"^",14),Doctor=$p(^SSU("SSUSR",UserDr),"^",2)
	.i $l(CPTDr),$d(^CTPCP(CPTDr)) s CPTType=$p(^CTPCP(CPTDr,1),"^",4)
	.i $l(CPTType),$d(^CT("CPT",CPTType)) s CPTTypeDesc=$p(^CT("CPT",CPTType),"^",2)
	.S ret=Doctor_"^"_AudDate_" "_AudTime_"^"_CPTTypeDesc
	.//b ;2
	Q ret
}

}
