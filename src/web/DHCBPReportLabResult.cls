Class web.DHCBPReportLabResult Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 根据Id获取病人登记号
/// d ##class(%ResultSet).RunQuery("web.DHCBPReportLabResult","LookUpTestResult","","1831141","","2013-09-23","2013-10-23")
/// d ##class(%ResultSet).RunQuery("web.DHCBPReportLabResult","LookUpTestResult","00000000064","","","2013-09-23","2014-10-31")
Query LookUpTestResult(regNo, medCareNo, LongCode, startDate, endDate, subType As %String = "") As %Query(ROWSPEC = "ItemName,ResultStr") [ SqlProc ]
{
}

ClassMethod LookUpTestResultExecute(ByRef qHandle As %Binary, regNo, medCareNo, LongCode, startDate, endDate, subType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	s regNoList="",papmiIdStr=""
	i (regNo="")&(medCareNo'="") d
		.s papmiId=$o(^PAPERi("Medicare1",medCareNo,""))
		.q:papmiId=""
		.i regNoList'="" s regNoList=regNoList_"^"
		.s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	e  s regNoList=regNo
	
	i regNoList="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s STX=$c(2)
	s ETX=$c(3)
	//;血常规
	s LongCode1="HGB^RBC^HCT^MCV^MCH^MCHC^WBC^NEUTP^EOSP^BASOP^LYP^MONOP^PLT"
	//;生化全项
	s LongCode2="CR^UA^UREA^GLU^P^CA^TP^ALB^PA^AG^TBA^TG^CHO1^ALP^HDLC^LDLC^HSCRP^K^NA^CL^TCO2"
	//;其他
	s LongCode3="PTH^SI^SF^TIBC^TS^TRF^SFA^VB12^TBIL^DBIL"
	s LongCodeStr=LongCode1_"^"_LongCode2_"^"_LongCode3
	//Cr+Urea(腹透液前液)、葡萄糖(Glu)(腹透液0h)、乳糜试验、Cr+Urea(腹透液24h)、24h尿尿酸（U-UA）、24h尿肌酐(U-Cr)、24h尿尿素(U-Urea)
	//24h尿磷(U-P)、24h尿钾(U-K)、24h尿镁(U-Mg)、24h尿钠(U-Na)、24h尿氯化物(U-CI)、24h尿钙(U-Ca)、
	s LongCode4="2041^0112^2071^9999^UUA^0089^UCR^UUREA^UP^UK^UMG^UNA^UCI^UCA"
	i subType="P" s LongCodeStr=LongCodeStr_"^"_LongCode4  //腹透标识
	s regno="",patName="",SpecDate="",SpecTime=""
	f i=1:1:$l(regNoList,"^") d
		.s regno=$p(regNoList,"^",i)
		.q:regno=""
		.i LongCode'="" d
			..s testStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LongCode, startDate, "0:00", endDate, "23:59", "0", "", "touchQty")
			..q:testStr=""
			..f j=1:1:$l(testStr,ETX) d
				...s testResult=$p(testStr,ETX,j)
				...s result=$p(testResult,STX,1) 
				...s reportDateD=$p(testResult,STX,4)
				...s reportDateT=$p(testResult,STX,5)
				...s reportDate=$zd(reportDateD,3)_" "_$zt(reportDateT,2)
				...s tc=$p(testResult,STX,7)
				...s labno=$p(testResult,STX,9)
				...q:labno=""					
				...s resultStr=reportDate_"|"_result_"|"_labno
				...s ^tmpDylBlood($j,"T",reportDate)=""
				...i $d(^tmpDylBlood($j,"Result",LongCode,tc)) s ^tmpDylBlood($j,"Result",LongCode,tc)=^tmpDylBlood($j,"Result",LongCode,tc)_"^"_resultStr
				...e  s ^tmpDylBlood($j,"Result",LongCode,tc)=resultStr
		.e  d		
			..f len=1:1:$l(LongCodeStr,"^") d
				...s LongCodeN=$p(LongCodeStr,"^",len)
				...q:LongCodeN=""
				...s testStr=##class(web.DHCClinicCom).GetTestResult("", regNo, "", LongCodeN, startDate, "0:00", endDate, "23:59", "0", "", "touchQty")
				...;w "结果"_testStr,!
				...q:testStr=""
				...f j=1:1:$l(testStr,ETX) d
			    	....s testResult=$p(testStr,ETX,j)
					....s result=$p(testResult,STX,1) 
					....s reportDateD=$p(testResult,STX,4)
					....s reportDateT=$p(testResult,STX,5)
					....s reportDate=$zd(reportDateD,3)_" "_$zt(reportDateT,2)
					....s tc=$p(testResult,STX,7)
					....s labno=$p(testResult,STX,9)
					....i LongCodeN="PLT"	w "1"_LongCodeN_":"_testResult,!
					....q:labno=""					
					....s resultStr=reportDate_"|"_result_"|"_labno
					....s ^tmpDylBlood($j,"T",labno)=reportDate
					....i LongCodeN="PLT"	w "2"_LongCodeN_":"_testResult,!
					....i $d(^tmpDylBlood($j,"Result",LongCodeN,tc)) s ^tmpDylBlood($j,"Result",LongCodeN,tc)=^tmpDylBlood($j,"Result",LongCodeN,tc)_"^"_resultStr
					....e  s ^tmpDylBlood($j,"Result",LongCodeN,tc)=resultStr
	
	s testCode="",reStr=""
	s leth=$l(LongCodeStr,"^")
	f len2=1:1:leth d
		.s NationLong=$p(LongCodeStr,"^",len2)
		.q:NationLong=""
		.;w NationLong,!
		.;i NationLong="PLT"	w NationLong,!	
		.;B ;w
		.q:$d(^tmpDylBlood($j,"Result",NationLong))<1
		.s tc="" f  s tc=$O(^tmpDylBlood($j,"Result",NationLong,tc)) q:tc=""  d
			..;s itemName=$p($g(^TTAB("TC",tc)),"\",1)
			..i NationLong="PLT" w "PLT:"_^tmpDylBlood($j,"Result",NationLong,tc),!
			..s TestCode=tc
			..//s TestCode=" "_tc //20220510 mfc
			..s itemName=""
			..s HospitalDR="" f  s HospitalDR=$o(^dbo.BTTestCodeI("IndexCode",HospitalDR)) q:HospitalDR=""  d
			...i '$d(^dbo.BTTestCodeI("IndexCode",HospitalDR,TestCode)) q
			...s TestCodeDR = $o(^dbo.BTTestCodeI("IndexCode",HospitalDR,TestCode,""))
			...s itemName = $lg(^dbo.BTTestCodeD(TestCodeDR),3)
			..s reStr=^tmpDylBlood($j,"Result",NationLong,tc)
			..;s reStr=^tmpDylBlood($j,"Result",NationLong,tc)
			..s labno=""  f  s labno=$o(^tmpDylBlood($j,"T",labno)) q:labno=""  d
				...i reStr'[labno d
						....s reStr=reStr_"^"_^tmpDylBlood($j,"T",labno)_"|"_""_"|"_labno
			..;w reStr,!
			..d OutputRow
	k ^tmpDylBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(itemName,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTestResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTestResultExecute ]
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

ClassMethod LookUpTestResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTestResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*Query LookUpTestResultOld(regNo, medCareNo, LongCode, startDate, endDate) As %Query(ROWSPEC = "ItemName,ResultStr") [ SqlProc ]
{
}

ClassMethod LookUpTestResultOldExecute(ByRef qHandle As %Binary, regNo, medCareNo, LongCode, startDate, endDate) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TMPzt("goto")=regNo_"/"_medCareNo_"/"_LongCode_"/"_startDate_"/"_endDate
	s regNoList="",papmiIdStr=""
	i (regNo="")&(medCareNo'="") d
		.s papmiId=$o(^PAPERi("Medicare1",medCareNo,""))
		.q:papmiId=""
		.i regNoList'="" s regNoList=regNoList_"^"
		.s regNoList=regNoList_$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	e  s regNoList=regNo
	
	i regNoList="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	;血常规
	s LongCode1="HGB^RBC^HCT^MCV^MCH^MCHC^WBC^NEUTP^EOSP^BASOP^LYP^MONOP^PLT"
	;生化全项
	s LongCode2="CR^UA^UREA^GLU^P^CA^TP^ALB^PA^AG^TBA^TG^CHO1^ALP^HDLC^LDLC^HSCRP^K^NA^CL^TCO2"
	;其他
	s LongCode3="PTH^SI^SF^TIBC^TS^TRF^SFA^VB12"
	s LongCodeStr=LongCode1_"^"_LongCode2_"^"_LongCode3
	s regno="",patName="",SpecDate="",SpecTime=""
	f i=1:1:$l(regNoList,"^") d
		.s regno=$p(regNoList,"^",i)
		.q:regno=""
		.i LongCode'="" d
				..s tc="" f  s tc=$O(^TTABi("TC","NNL",LongCode,tc)) q:tc=""  d
					...s itemName=$P($g(^TTAB("TC",tc)),"\",1)
					...s ADate="" f  s ADate=$O(^TDHCOldResult(1,regno,tc,ADate)) q:ADate=""  d
						....q:(($zdh(startDate,3)>ADate)||(ADate>$zdh(endDate,3)))
						....s ATime="" f  s ATime=$O(^TDHCOldResult(1,regno,tc,ADate,ATime)) q:ATime=""  d
							.....s Labno=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,""),-1)
							.....q:Labno=""
							.....s ts=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,Labno,""),-1)
							.....s tscnt=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,Labno,ts,""),-1)
							.....s Result=$p(^TEPI(Labno,1,ts,tscnt,"DATA",tc),"\",1)
							.....q:Result=""
							.....;21,22,接收标本，4,5报告
							.....s ReportDateD=$p(^TEPI(Labno,1,ts,tscnt),"\",21)
							.....;b	;w ADate_"/"_ReportDateD_"/"_Labno
							.....;q:ADate<ReportDateD
							.....s ReportDateT=$p(^TEPI(Labno,1,ts,tscnt),"\",22)
							.....s ReportDate=$zd(ReportDateD,3)_" "_$zt(ReportDateT,2)
							.....s ResultStr=ReportDate_"|"_Result_"|"_Labno
							.....s ^tmpDylBlood($j,"T",ReportDate)=""
							.....i $d(^tmpDylBlood($j,"Result",LongCode,tc)) s ^tmpDylBlood($j,"Result",LongCode,tc)=^tmpDylBlood($j,"Result",LongCode,tc)_"^"_ResultStr
							.....e  s ^tmpDylBlood($j,"Result",LongCode,tc)=ResultStr
							.....;d OutputRow
		.e  d
			..s length=$l(LongCodeStr,"^")
			..f len=1:1:length d
					...s LongCodeN=$p(LongCodeStr,"^",len)
			    	...s tc="" f  s tc=$O(^TTABi("TC","NNL",LongCodeN,tc)) q:tc=""  d
					    ....s itemName=$P($g(^TTAB("TC",tc)),"\",1)
					    ....;审核报告时间
						....s ADate="" f  s ADate=$O(^TDHCOldResult(1,regno,tc,ADate)) q:ADate=""  d
							.....q:(($zdh(startDate,3)>ADate)||(ADate>$zdh(endDate,3)))
							.....s ATime="" f  s ATime=$O(^TDHCOldResult(1,regno,tc,ADate,ATime)) q:ATime=""  d
								......s Labno=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,""),-1)
								......q:Labno=""
								......s ts=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,Labno,""),-1)
								......s tscnt=$O(^TDHCOldResult(1,regno,tc,ADate,ATime,Labno,ts,""),-1)
								......s Result=$p(^TEPI(Labno,1,ts,tscnt,"DATA",tc),"\",1)
								......s ReportDateD=$p(^TEPI(Labno,1,ts,tscnt),"\",21)	;4,5审核
								......;b	;w ADate_"/"_ReportDateD_"/"_Labno
								......;q:ReportDateD=""
								......s ReportDateT=$p(^TEPI(Labno,1,ts,tscnt),"\",22)
								......;q:ReportDateT=""
								......s ReportDate=$zd(ReportDateD,3)_" "_$zt(ReportDateT*60,2)
								......s ResultStr=ReportDate_"|"_Result_"|"_Labno
								......s ^tmpDylBlood($j,"T",ReportDate)=""
								......i $d(^tmpDylBlood($j,"Result",LongCodeN,tc)) s ^tmpDylBlood($j,"Result",LongCodeN,tc)=^tmpDylBlood($j,"Result",LongCodeN,tc)_"^"_ResultStr
								......e  s ^tmpDylBlood($j,"Result",LongCodeN,tc)=ResultStr
								......;d OutputRow
	
	s testCode="",reStr=""
	s leth=$l(LongCodeStr,"^")
	f len2=1:1:leth d
		.s NationLong=$p(LongCodeStr,"^",len2)
		.q:NationLong=""
		.q:$d(^tmpDylBlood($j,"Result",NationLong))<1
		.s tc="" f  s tc=$O(^tmpDylBlood($j,"Result",NationLong,tc)) q:tc=""  d
			..s itemName=$p($g(^TTAB("TC",tc)),"\",1)
			..s reStr=^tmpDylBlood($j,"Result",NationLong,tc)
			..s date=""  f  s date=$o(^tmpDylBlood($j,"T",date)) q:date=""  d
				...i reStr'[date d
						....s reStr=reStr_"^"_date_"|"_""_"|"_""
			..d OutputRow
	k ^tmpDylBlood($j)			
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(itemName,reStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpTestResultOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpTestResultOldExecute ]
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

ClassMethod LookUpTestResultOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpTestResultOldExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
/// 根据Id获取病人登记号
/// d ##class(%ResultSet).RunQuery("web.DHCBPReportLabResult","LookUpTestResult","","1831141","","2013-09-23","2013-10-23")
/// d ##class(%ResultSet).RunQuery("web.DHCBPReportLabResult","LookUpTestResult","00000000064","","","2013-09-23","2014-10-31")
/// 检查医嘱项目是否是否检验医嘱
ClassMethod isLabTS(ItemMast As %String) As %String
{
	s ItemMast=$g(ItemMast)
	s RtnValue="0"
	s ItmCat=$p(^ARCIM(+ItemMast,$p(ItemMast,"||",2),1),"^",10)
	i $l(ItmCat),$d(^ARC("IC",ItmCat)){
		i $p(^ARC("IC",ItmCat),"^",7)="L" s RtnValue="1"
	}
	Quit RtnValue
}

ClassMethod FindWardPatient(wardId As %String = "", ctlocId As %String = "") As %String
{
	s retStr=""
	q:(wardId="")&(ctlocId="") retStr
	
	s wardIdList=wardId
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i ctlocType="W" d
			..s wardIdList=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
		.e  d
			..i ctlocType="E" d  
			..s linksub=0
			..f  s linksub=$o(^CTLOC(ctlocId,"LINK",linksub)) q:linksub=""  d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i linkCtlocId'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i linkCtlocType="W" d 
						.....i wardIdList'="" s wardIdList=wardIdList_"^"
						.....s wardIdList=wardIdList_$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,0))
	q:wardIdList="" retStr
	f i=1:1:$l(wardIdList,"^") d
	    .s wardId=$p(wardIdList,"^",i)
	    .i ctlocId="" s ctlocId=$p(^PAWARD(+wardId),"^",5)
	    .s roomId=0
	    .f  s roomId=$o(^PAADMi("CurrWard",wardId,roomId)) q:roomId=""  d
    		..s EpisodeID=0
    		..f  s EpisodeID=$o(^PAADMi("CurrWard",wardId,roomId,EpisodeID)) q:EpisodeID=""  d
        		...q:'$d(^PAADM(EpisodeID))
        		...s paadmVisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
        		...i paadmVisitStatus'="A" q
        		...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
        		...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
       			...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        		...//s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
        		...i retStr'="" s retStr=retStr_"^"
        		...s retStr=retStr_EpisodeID 
    q retStr
}

}
