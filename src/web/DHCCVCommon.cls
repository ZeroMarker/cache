Class web.DHCCVCommon Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

ClassMethod ProcessStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ProcessStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCVCommon","ProcessStatus","")
ClassMethod ProcessStatusExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rowid="",code="",Desc=""
 	Do OutputRow
	s code="C",Desc="未完成"
	Do OutputRow
	s code="F",Desc="完成"
   	Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(rowid,Desc,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ProcessStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ProcessStatusExecute ]
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

Query ProcessStatus() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod AdmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AdmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCVCommon","AdmType")
ClassMethod AdmTypeExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rowid=""
 	s code="O",Desc="门诊"
 	Do OutputRow1
	s code="E",Desc="急诊"
	Do OutputRow1
	s code="I",Desc="住院"
   	Do OutputRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(code,Desc,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AdmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AdmTypeExecute ]
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

Query AdmType() As %Query(ROWSPEC = "Code:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetPatInfo(patientId) As %String
{
	n (patientId)
	
	s PatDetail=##class(web.DHCDocOrderEntry).GetPatientByRowid(patientId)
	s PatientName=$p(PatDetail,"^",3)
	s PatientSex=$p(PatDetail,"^",4)
	s AgeDesc=$p(PatDetail,"^",5)
	s Medcare=$p(PatDetail,"^",19)
	s AdmDepID=$p($g(^PAADM(Adm)),"^",4)
	i AdmDepID'="" s AdmDep=$p($g(^CTLOC(AdmDepID)),"^",2) 
	e  s AdmDep=""
	i $l(AdmDep,"-")=2 s AdmDep=$p(AdmDep,"-",2)
	s AdmDocID=$p($g(^PAADM(Adm)),"^",9)
	i AdmDocID'="" s AdmDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	e  s AdmDoc=""
	s Bed=$p($g(^PAADM(Adm)),"^",73)
	i Bed'="" s Bed=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
	s ret=PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_Medcare_"^"_AdmDep_"^"_AdmDoc_"^"_Bed_"^"_AdmDepID_"^"_AdmDocID
}

ClassMethod CVReportAlertClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CVReportAlertExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCCVCommon","CVReportAlert","locid")
/// d ##class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetAllPanicReport","2014-01-23","2014-01-24",30,"C","I",1)
ClassMethod CVReportAlertExecute(ByRef qHandle As %Binary, locid As %String) As %Status
{
	n (qHandle,locid)
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ^tempshp("loc",$h)=locid_","_(+$g(locid)=0)
 	i +$g(locid)=0 Set qHandle=$lb(0,repid,0)  Quit $$$OK
 	s stdate=$zd(+$h-1,3),edate=$zd(+$h,3)
 	s ^tempshp("loc1",$h)=locid
	s reporttype=""
	f reporttype=1:1:6 d
	.set objalert=##class(%ResultSet).%New("web.DHCAntCVReportSearch:GetAllPanicReport")
	.d objalert.Execute(stdate,edate,locid,"C","I",reporttype)
	.For  Quit:'objalert.Next()  Do
	..s ReportId=objalert.Data("ReportId")
	..s RegNo=objalert.Data("DebtorNo")
	..s PatName=objalert.Data("PatName")
	..s ReportTypeId=objalert.Data("ReportType")
	..//1检验,2病理,3心电,4超声,5内镜,6放射
	..s ReportType=##class(web.DHCAntCVReportNameQuery).GetPanicName(ReportTypeId)  //$S(ReportTypeId=1:"检验",ReportTypeId=2:"病理",ReportTypeId=3:"心电",ReportTypeId=4:"超声",ReportTypeId=5:"内镜",ReportTypeId=6:"放射")
	..d output
	.d objalert.%Close()
	.s objalert=""
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
	set Data=$lb(ReportId,RegNo,PatName,ReportType,ReportTypeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CVReportAlertFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CVReportAlertExecute ]
{
	n (qHandle,Row,AtEnd)
	
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

Query CVReportAlert(locid As %String) As %Query(ROWSPEC = "ReportId:%String,RegNo:%String,PatName:%String,ReportType:%String,ReportTypeId:%String")
{
}

ClassMethod GetPatAdmType(reportid As %String, RepType As %String) As %String
{
	n (reportid,RepType)
	s RepType=$g(RepType)
	i RepType="" s RepType=1
	s epis=$p(reportid,"||",1)
	i epis="" q ""
	s ord=$o(^DHCAntCVReport(RepType,epis,""),-1)
	i '$l(ord) q ""
	s adm=$p(^DHCAntCVReport(RepType,epis,ord),"\",7)
	s AdmType=$p(^PAADM(adm),"^",2)
	q AdmType
}

///   shp
///   20140519
///   w ##class(web.DHCCVCommon).GetPanicReportResult(1,"601||1")
ClassMethod GetPanicReportResult(RType As %String, ReportId As %String) As %String
{
	n (RType,ReportId)	
	q:+$g(RType)=0 ""
	//if RType'=1 {
		s ret=##class(web.DHCAntCVReportSearch).GetPanicReportResult(RType,ReportId)
	//}else{
		//s ret=##class(web.DHCAntCVReceive).GetCVReportResultOfRis(RType,ReportId)
		//}
	q ret
}

/// w ##class(web.DHCCVCommon).GetCVReportResultOfRis(1,"696||1")
ClassMethod GetCVReportResultOfRis(RType As %String, ReportId As %String)
{
	n (RType,ReportId)
	s ret="",num=0
	s VisitNumberReportDR=+ReportId
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),2)
	s AddDate="" f  s AddDate = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate))	q:AddDate=""  d
	.s AddTime="" f  s AddTime = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime)) q:AddTime=""  d
	..s PanicReportDR="" f  s PanicReportDR = $o(^dbo.RPVisitNumberPanicReportI("IndexMaster",VisitNumberDR,AddDate,AddTime,PanicReportDR)) q:PanicReportDR=""  d
	...s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR)) Quit:TestCodeDR=""  d
	....s PanicResultDR = $o(^dbo.RPVisitNumberPanicResultI("IndexMaster",PanicReportDR,TestCodeDR,""))
	....s Data=$g(^dbo.RPVisitNumberPanicResultD(PanicResultDR)),TestCodeName=""
	....i $l(TestCodeDR) s TestCodeName=$lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
	....s Result=$li(Data,3)
	....s Unit=$li(Data,9)
	....s Ranges=$li(Data,10)
	....s num=num+1
	....i ret=""  s ret=num_"、项目名称："_TestCodeName_"结果："_Result_"("_Unit_")    参考范围："_Ranges
	....e  s ret=ret_"；"_num_"、项目名称："_TestCodeName_"结果："_Result_"("_Unit_")    参考范围："_Ranges
	q ret
	/*
	s spis=+ReportId
	s ord=$p(ReportId,"||",2)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	s ret="",num=0
	s tc=""					
	f  s tc=$o(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc))  q:tc=""  d
	.s num=+$g(num)+1
	.s TestItem=$p(^TTAB("TC",tc),"\",1)
	.s Result=$P(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",2)
	.s Unit=$p(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",3)
	.;s Unit=$p(^DHCAntCVReport(RType,spis,ord,"TC",tc),"\",4)
	.s Ranges=$p(^[LabData]DHCPanicReport(RType,spis,ord,"TC",tc),"\",5)   //(1,2)标准参考范围，(3,4)危急值参考范围
	.i Ranges[$C(3)  D
	..S RangeStart=$p(Ranges,$C(3),1)  
	..S RangeEnd=$p(Ranges,$C(3),2) 
	..;s Ranges=RangeStart_"-"_RangeEnd
	..i (RangeStart="")&&(RangeEnd="") s Ranges=""
	..e  i (RangeStart'="")&&(RangeEnd="") s Ranges=RangeStart
	..e  i (RangeStart="")&&(RangeEnd'="") s Ranges=RangeEnd
	..e  s Ranges=RangeStart_"-"_RangeEnd
	.i ret=""  s ret=num_"、项目名称："_TestItem_"结果："_Result_"("_Unit_")    参考范围："_Ranges
	.e  s ret=ret_"；"_num_"、项目名称："_TestItem_"结果："_Result_"("_Unit_")    参考范围："_Ranges
	
	q ret
	*/
}

/// creator    :shp
/// description: 通过epis  ，得到联系人信息
/// debug   :w ##class(web.DHCCVCommon).GetCantactInfo(100079,1)
ClassMethod GetCantactInfo(reportid, RepType) As %String
{
	//处理取最后一次
	
	s ^tempshp("hh")=reportid_"^"_RepType
	s $p(RetVal,"\",3)=""
	q:$g(reportid)="" RetVal
	s epis=$p(reportid,"||",1)
	s ord=$p(reportid,"||",2)
	//s ord=$o(^DHCAntCVReport(RepType,epis,""),-1)
	s TransOrd=+$o(^DHCAntCVReport(RepType,epis,ord,"TR",""),-1)
	s (ToPerson,PhoneNo,TransMemo)=""
	;w !,epis,",",ord
	i $l(TransOrd) d
	.s str=$g(^DHCAntCVReport(RepType,epis,ord,"TR",TransOrd))
	.s $p(RetVal,"\",1)=$p(str,"\",5)  //联系人
	.s $p(RetVal,"\",2)=$p(str,"\",6)	//电话
	.s $p(RetVal,"\",3)=$p(str,"\",7)	//处理结果
	.s $p(RetVal,"\",4)=$p(str,"\",9)	//处理结果
	q RetVal
}

/// Creator：      hw
/// CreatDate：    2016-2-23
/// Description:： 通过就诊号获取对应危急值信息
/// Table：        DHC_AntCVReport
/// Input：        pa_adm表Rowid,危急值状态
/// Return：        
/// Others：   	   d ##class(%ResultSet).RunQuery("web.DHCCVCommon","CVReportFromAdm",1205,"C")
ClassMethod CVReportFromAdmExecute(ByRef qHandle As %Binary, EpisodeId As %String, TransStatus As %String) As %Status
{
	//s ^templsj("0301")=EpisodeId_"!"_TransStatus
	
	n (qHandle,EpisodeId,TransStatus,%request,%session)
	
	s useTrans=0,langId=20
	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
	
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i +$g(EpisodeId)=0 Set qHandle=$lb(0,repid,0)  Quit $$$OK
 	
 	if TransStatus'="" s TransStatus=","_TransStatus_","
 	
 	s DPRPType=""
	f  s DPRPType=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType)) q:DPRPType=""  d
	.s DPRPLabNo=""
	.f  s DPRPLabNo=$o(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo)) q:DPRPLabNo=""  d
	..s DPRPOrder=""
	..f  s DPRPOrder=$O(^DHCAntCVReport(0,"ADM",EpisodeId,DPRPType,DPRPLabNo,DPRPOrder)) q:DPRPOrder=""  d
	...s Status=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",9)
	...q:(Status="D")&&(TransStatus'[",D,") //删除的
	...q:(TransStatus'="")&&(TransStatus'[(","_Status_",")) //(Status'=TransStatus)
	...s ReportType=##class(web.DHCAntCVReportNameQuery).GetPanicName(DPRPType)  //$S(DPRPType=1:"检验",DPRPType=2:"病理",DPRPType=3:"心电",DPRPType=4:"超声",DPRPType=5:"内镜",DPRPType=6:"放射")
	...//1检验,2病理,3心电,4超声,5内镜,6放射
	...s ReportStatus=$s(Status="F":"已处理",Status="C":"未处理",Status="Rec":"已接收",Status="D":"已撤销",1:"未处理")
	...s ReportId=DPRPLabNo_"||"_DPRPOrder
	...s Date=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",1)
	...s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	...s Time=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",2)
	...s DateTime=Date_" "_$zt(Time,3)
	...s OEOrdItemID=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",14)
	...s OrderInfo=$p(^DHCAntCVReport(DPRPType,DPRPLabNo,DPRPOrder),"\",17)
	...s ApplyDT=$p($g(OrderInfo),"^",2) //申请时间
	...s ApplyD=$p(ApplyDT," ",1)
	...s ApplyT=$p(ApplyDT," ",2)
	...i ApplyD'="" s ApplyD=$zdh(ApplyD,3)
	...s ApplyD=##class(websys.Conversions).DateLogicalToHtml(ApplyD)
	...s ApplyDT=ApplyD_" "_ApplyT
	...s SamplingDT=$p($g(OrderInfo),"^",4) //采样时间
	...s SamplingD=$p(SamplingDT," ",1)
	...s SamplingT=$p(SamplingDT," ",2)
	...i SamplingD'="" s SamplingD=$zdh(SamplingD,3)
	...s SamplingD=##class(websys.Conversions).DateLogicalToHtml(SamplingD)
	...s SamplingDT=SamplingD_" "_SamplingT
	...s ReceiveDT=$p($g(OrderInfo),"^",6) //接收时间
	...s ReceiveD=$p(ReceiveDT," ",1)
	...s ReceiveT=$p(ReceiveDT," ",2)
	...i ReceiveD'="" s ReceiveD=$zdh(ReceiveD,3)
	...s ReceiveD=##class(websys.Conversions).DateLogicalToHtml(ReceiveD)
	...s ReceiveDT=ReceiveD_" "_ReceiveT
	...s AuditDT=$p($g(OrderInfo),"^",11) //审核时间
	...s AuditD=$p(AuditDT," ",1)
	...s AuditT=$p(AuditDT," ",2)
	...i AuditD'="" s AuditD=$zdh(AuditD,3)
	...s AuditD=##class(websys.Conversions).DateLogicalToHtml(AuditD)
	...s AuditDT=AuditD_" "_AuditT
	...s Specimen=$p($g(OrderInfo),"^",12) //标本
	...s DPRPAlert=$p($g(OrderInfo),"^",13) //警戒提示
	...s TSName=##Class(web.DHCAntCVReportSearch).GetOrdItemName(OEOrdItemID)
	...if useTrans d TransData
	...d output1
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	set Data=$lb(ReportId,TSName,ReportStatus,ReportType,DPRPType,DateTime,ApplyDT,SamplingDT,ReceiveDT,AuditDT,Specimen,DPRPAlert)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
TransData
	s ReportStatus=##class(web.DHCAntCVComm).GetCVStatusTrans(ReportStatus,langId)
	s ReportType=##class(web.DHCAntCVComm).GetCVTypeTrans(ReportType,langId)
	q
}

ClassMethod CVReportFromAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CVReportFromAdmExecute ]
{
	n (qHandle,Row,AtEnd)
	
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

Query CVReportFromAdm(EpisodeId As %String, TransStatus As %String) As %Query(ROWSPEC = "ReportId:%String,TSName:%String,ReportStatus:%String,ReportType:%String,DPRPType:%String,DateTime:%String,ApplyDT:%String,SamplingDT:%String,ReceiveDT:%String,AuditDT:%String,Specimen:%String,DPRPAlert:%String")
{
}

ClassMethod CVReportFromAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CVReportFromAdmExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
