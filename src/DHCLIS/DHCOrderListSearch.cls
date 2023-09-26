Class DHCLIS.DHCOrderListSearch Extends %RegisteredObject
{

Query QueryOrderListByRegNo(fRegNo, fLocationDR, fWardDR, FromDate, ToDate, HospID, AuthFlag, fReadFlag, AdmDateFlag, UserCode, UserId, fPrintFlag, P12, P13, Sessions, Output RowCount As %String) As %Query(ROWSPEC = "VisitNumberReportDR,LabEpisode,SurName,OrdItemName,LabEpisode,TSResultAnomaly,TransComm,ReqDateTime,SpecDateTime,AuthDateTime,ResultStatus,BedNo,Age,Species,ReceiveDateTime,ReadFlag,PrintFlag,TSMemo,ReceiveNotes,MajorConclusion")
{
}

/// Creator：      sunzhiwen
/// CreatDate：    
/// Description:： 根据登记号，申请科室，申请病区查询
/// Table：        
/// Input：        就诊号,病员号
/// Return：       函数返回值的说明
/// Others：  d ##Class(%ResultSet).RunQuery("DHCLIS.DHCOrderList","QueryOrderListByRegNo","0000000139","95","","2015-05-22","2015-05-08","2","0","","301","","","","","","")
ClassMethod QueryOrderListByRegNoExecute(ByRef qHandle As %Binary, fRegNo, fLocationDR, fWardDR, FromDate, ToDate, HospID, AuthFlag, fReadFlag, AdmDateFlag, UserCode, UserId, fPrintFlag, P12, P13, Sessions, Output RowCount As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s EpisodeID=$g(EpisodeID),PatientID=$g(PatientID)
	i $l(FromDate) s FromDate=$tr(FromDate,"-")
	i $l(ToDate) S ToDate=$tr(ToDate,"-")

	i $l(HospID) s CurHospitalCode=$p(^CT("HOSP",HospID),"^",1)
	s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(CurHospitalCode),""))
	i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))

	s startDate="",endDate=""
	i $l(fRegNo) d
	.s fRegNo = " "_fRegNo
	.i $l(FromDate) d
	..s startDate=FromDate
	..s startDate = $o(^dbo.RPVisitNumberI("IndexPatientRequest",fRegNo,startDate),-1)
	.i $l(ToDate) d
	..s endDate = ToDate
	.for  s startDate = $o(^dbo.RPVisitNumberI("IndexPatientRequest",fRegNo,startDate)) q:(startDate="")||($l(endDate)&&(startDate>endDate))  d
	..s VisitNumberDR=""
	..for  s VisitNumberDR = $o(^dbo.RPVisitNumberI("IndexPatientRequest",fRegNo,startDate,VisitNumberDR))  q:VisitNumberDR=""  d
	...s (VisitNumberReportDR,LabEpisode,OrdItemName,LabEpisode,TSResultAnomaly,TransComm,ReqDateTime,SpecDateTime,AuthDateTime,ResultStatus,BedNo,Age,Species,ReadFlag,PrintFlag,TSMemo)=""
	...s VisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
	...d GetVisitNumberReportData
	e  i $l(fLocationDR)||$l(fWardDR) d
	.i '$l(FromDate) q
	.s RequestDate = FromDate-1
	.for  s RequestDate = $o(^dbo.RPVisitNumberI("IndexRequestDate",HospitalDR,RequestDate)) q:(RequestDate>ToDate)||(RequestDate="")  d
	..s VisitNumberDR=""
	..f  s VisitNumberDR = $o(^dbo.RPVisitNumberI("IndexRequestDate",HospitalDR,RequestDate,VisitNumberDR)) q:VisitNumberDR=""  d
	...s (VisitNumberReportDR,LabEpisode,OrdItemName,LabEpisode,TSResultAnomaly,TransComm,ReqDateTime,SpecDateTime,AuthDateTime,ResultStatus,BedNo,Age,Species,ReadFlag,PrintFlag,TSMemo)=""
	...s VisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
	...s LocationDR = $lg(VisitNumberData,22)
	...s WardDR = $lg(VisitNumberData,26)
	...i $l(fLocationDR),LocationDR'=fLocationDR q
	...i $l(fWardDR),WardDR'=fWardDR q
	...d GetVisitNumberReportData
	
	Set qHandle=$lb(0,repid,0)
	k TMP($zn,$j)
	Quit $$$OK
	
OutputRow
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit

GetVisitNumberReportData
	s OrdItemName = ""
	s TestSetDR="" f  s TestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,TestSetDR)) q:TestSetDR=""  d
	.i $l(OrdItemName) s OrdItemName=OrdItemName_"+"_$lg($g(^dbo.BTTestSetD(TestSetDR)),3)
	.e  s OrdItemName=$lg(^dbo.BTTestSetD(TestSetDR),3)
	s BedNo = $lg(VisitNumberData,27)
	s SpeciesDR = $lg(VisitNumberData,15)
	s Age = $lg(VisitNumberData,18)
	s AgeUnitDR = $lg(VisitNumberData,19)
	s AgeUnit=""
	i $l(AgeUnitDR) s AgeUnit=$lg($g(^dbo.BTAgeUnitD(AgeUnitDR)),3)
	s Age = Age_AgeUnit
	s Species=""
	i $l(SpeciesDR) s Species=$lg($g(^dbo.BTSpeciesD(SpeciesDR)),3)
	s RequestDate = $lg(VisitNumberData,24)
	s RequestTime = $lg(VisitNumberData,25)
	s ReqDateTime = RequestDate
	i $l(RequestTime) s ReqDateTime = ReqDateTime_" "_$zt(RequestTime)
	s LabEpisode=$lg(VisitNumberData,2)
	s SurName=$lg(VisitNumberData,13)
	s CollectDate = $lg(VisitNumberData,51)
	s CollectTime = $lg(VisitNumberData,52)
	s SpecDateTime= CollectDate
	if $l(CollectTime) s SpecDateTime = SpecDateTime_" "_$zt(CollectTime)
	s ReceiveDate = $lg(VisitNumberData,66)
	s ReceiveTime = $lg(VisitNumberData,67)
	s ReceiveDateTime = ReceiveDate
	i $l(ReceiveTime) s ReceiveDateTime = ReceiveDateTime_" "_$zt(ReceiveTime)
	
		//标本提示为接收备注
	s ReceiveNotes = $lg(VisitNumberData,70)
	s WorkGroupMachineDR=""
	for {
		s WorkGroupMachineDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR))
		q:WorkGroupMachineDR=""
		s OrderNo=""
		for {
			s OrderNo = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo))
			q:OrderNo=""
			s VisitNumberReportDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
			s VisitNumberReportData = $g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
			
			s MajorConclusion =$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)
			s TSMemo="" 
			s ResultStatus=$lg(VisitNumberReportData,22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
			i ResultStatus'=3 continue
			//结果异常标志
			s TSResultAnomaly=##class(DHCLIS.DHCCommon).checkTSResultStatus(VisitNumberReportDR)
			///危机值提示
			s TransComm=##Class(DHCLIS.DHCCommon).GetPanicMsg(VisitNumberDR)
			//阅读标记
			i $l(UserId),(ResultStatus=3) s ReadFlag=##Class(DHCLIS.DHCReportControl).ReportViewLog(VisitNumberReportDR,UserId,HospID)
			///打印标记
			i $l(VisitNumberReportDR),$l(UserId) s PrintFlag=##Class(DHCLIS.DHCOrderList).GetPrintFlag(VisitNumberReportDR,UserId)
			s ResultStatus=$lg($g(VisitNumberReportData),22)
			s AuthDate=$lg(VisitNumberReportData,19)
			s AuthTime=$lg(VisitNumberReportData,20)
			s ResultStatus=$lg(VisitNumberReportData,22) 
			s AuthDateTime = AuthDate
			i $l(AuthTime) s AuthDateTime = AuthDateTime_" "_$zt(AuthTime)
			i $l(AuthFlag),AuthFlag=1,ResultStatus'=3 q
			i (fReadFlag=1),(ResultStatus'=3) q               ///未阅读
			i (fReadFlag=1),(ResultStatus=3),(ReadFlag=1) q  ///未阅读
			i (AuthFlag=1),(ResultStatus'=3) q   //是否出报告
			i fPrintFlag="N",PrintFlag="Y" q
			i fPrintFlag="N",(ResultStatus'=3) q
			s Data = $lb(VisitNumberReportDR,LabEpisode,SurName,OrdItemName,LabEpisode,TSResultAnomaly,TransComm,ReqDateTime,SpecDateTime,AuthDateTime,ResultStatus,BedNo,Age,Species,ReceiveDateTime,ReadFlag,PrintFlag,TSMemo,ReceiveNotes,MajorConclusion)
			d OutputRow
		}
			
	}
	
#;	i '$l(WorkGroupMachineDR) q
#;	
#;	s VisitNumberReportDR = $o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""))
#;	s VisitNumberReportData = $g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
#;	
#;	s MajorConclusion =$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),40)
#;	s TSMemo="" 
#;	s ResultStatus=$lg(VisitNumberReportData,22)   //(1登记，2初审，3审核，4复查，5取消审核，6作废，O其他)
#;	//结果异常标志
#;	s TSResultAnomaly=##class(DHCLIS.DHCCommon).checkTSResultStatus(VisitNumberReportDR)
#;	///危机值提示
#;	s TransComm=##Class(DHCLIS.DHCCommon).GetPanicMsg(VisitNumberDR)
#;	//阅读标记
#;	i $l(UserId),(ResultStatus=3) s ReadFlag=##Class(DHCLIS.DHCReportControl).ReportViewLog(VisitNumberReportDR,UserId,HospID)
#;	///打印标记
#;	i $l(VisitNumberReportDR),$l(UserId) s PrintFlag=##Class(DHCLIS.DHCOrderList).GetPrintFlag(VisitNumberReportDR,UserId)
#;	s ResultStatus=$lg($g(VisitNumberReportData),22)
#;	s AuthDate=$lg(VisitNumberReportData,19)
#;	s AuthTime=$lg(VisitNumberReportData,20)
#;	s ResultStatus=$lg(VisitNumberReportData,22) 
#;	s AuthDateTime = AuthDate
#;	i $l(AuthTime) s AuthDateTime = AuthDateTime_" "_$zt(AuthTime)
#;	q
}

ClassMethod QueryOrderListByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListByRegNoExecute ]
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

ClassMethod QueryOrderListByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListByRegNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Function: 根据登记号查报告信息
/// CreateDate: 2014/11/18
/// Table:     ARC_ItmMast
/// P1代码,P2描述,P3药物查找,P4别名,P5记账组,P6记账子组,P7医嘱子类,P8服务组,P9收费规定
/// Debugs:    d ##class(%ResultSet).RunQuery("DHCLIS.DHCOrderListSearch","QryItmByRegNo","123")
Query QryItmByRegNo(RegNo As %String) As %Query(ROWSPEC = "test_type,grbh,test_id,test_name,test_time,reviewer")
{
}

ClassMethod QryItmByRegNoExecute(ByRef qHandle As %Binary, RegNo As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1

 s ReqDate="" f  s ReqDate=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),ReqDate)) q:ReqDate=""  d
 .s VisitNumberDR="" f  s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexPatientRequest",##Class(LIS.Util.Common).IndexData(RegNo),ReqDate,VisitNumberDR)) q:VisitNumberDR=""  d 
 ..d GetInfoFast
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
 
GetInfoFast
    s gdata=$g(^dbo.RPVisitNumberD(VisitNumberDR)) 
    s Labno=$lg(gdata,2)
    s RegNo=$lg(gdata,3)	 
    s TestSetDesc=""
	s fTestSetDR="" f  s fTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",VisitNumberDR,fTestSetDR)) q:(fTestSetDR="")  d
	.i $l(TestSetDesc) s TestSetDesc=TestSetDesc_"+"_$lg(^dbo.BTTestSetD(fTestSetDR),3)
	.e  s TestSetDesc=$lg(^dbo.BTTestSetD(fTestSetDR),3)	
    s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$O(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	.s WorkGroupMachine=$LG($G(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),3)
	.s RptOrder=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGroupMachineDR,""),-1) 
	.i '$l(RptOrder) Quit  ///只查询本工作组医嘱
	.s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR, WorkGroupMachineDR,RptOrder,""))
	.s ReportData=$g(^dbo.RPVisitNumberReportD(ReportDR))
	.s EpisodeNo=$lg(ReportData,8)
	.s Status=$lg(ReportData,22)
	.q:Status'=3
 	.s AuthDate=$lg(ReportData,19)
 	.s AuthTime=$lg(ReportData,20)
 	.s AuthUserDR=$lg(ReportData,21) s AuthUser=""
 	.i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
 	.i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)	
 	.d OutputRow
 	Quit
 	
OutputRow
    set Data=$lb(1,RegNo,Labno,TestSetDesc,AuthDate,AuthUser)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod QryItmByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryItmByRegNoExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QryItmByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryItmByRegNoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
