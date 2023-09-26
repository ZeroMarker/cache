Import SQLUser

Class web.DHCCRM.ImportantIllResultSend Extends %Persistent
{

//d ##calss(web.DHCCRM.LisResultSend).GetCTLocList("","")

ClassMethod GetCTLocList(start, limit, CTLocDesc)
{
   
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.ImportantIllResultSend:SearchCTLoc")
	d rs.Execute(CTLocDesc)
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s RowId=rs.Get("CTLOC_RowId")
	 	s Code=rs.Get("CTLOC_Code")
	 	s Desc=rs.Get("CTLOC_Desc")
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""CTLocRowID"":"_""""_RowId_""""
		s mess=mess_","_"""CTLocCode"":"_""""_Code_""""
		s mess=mess_","_"""CTLocName"":"_""""_Desc_""""
		s mess=mess_"}"
	}	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

//d ##class(%ResultSet).RunQuery("web.DHCCRM.LisResultSend","SearchCTLoc","tx")

Query SearchCTLoc(Desc As %String = "") As %Query(ROWSPEC = "CTLOC_Code:%String,CTLOC_Desc:%String, CTLOC_RowId:%String")
{
}

ClassMethod SearchCTLocExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i Desc'=""  s Desc=$ZCVT(Desc,"U")
	s CTRowID=0
	f  s CTRowID=$o(^CTLOC(CTRowID))  q:CTRowID=""  d
	.s CTLOCDesc=$p($g(^CTLOC(CTRowID)),"^",2)
	.s CTLOCDesc=$ZCVT(CTLOCDesc,"U")
	.s CTLOCCode=$p($g(^CTLOC(CTRowID)),"^",1)
	.q:(Desc'="")&&(CTLOCDesc'[Desc)
    .d OutputRow

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(CTLOCCode,CTLOCDesc,CTRowID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchCTLocExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//

// .d ##class(web.DHCCRM.ImportantIllResultSend).GetPersonList("0","20","","2010-02-18","","","","")

ClassMethod GetPersonList(start, limit, CTLocRowID, DateFrom, DateTo, SendFlag, PatRegNo, PatName, Out, InHospital, PE)
{
     //                 "^     ^         ^2010-02-28         ^^false"
    s ^zl("FindList",1)=start_"^"_limit_"^"_CTLocRowID_"^"_DateFrom_"^"_DateTo_"^"_SendFlag_"^"_PatRegNo_"^"_PatName
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.ImportantIllResultSend:GetIllItem") 
    d rs.Execute(start,limit,CTLocRowID,DateFrom,DateTo,SendFlag,PatRegNo,PatName,Out, InHospital, PE)
 	s count=0
 	s mess=""
 	s topnum=start+limit
   
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s RegNo=rs.Get("PatRegNo")
	 	s Name=rs.Get("PatName")
	 	s ARCItemDesc=rs.Get("ARCItemDesc")
	 	s MobileSend=rs.Get("MobileSend")
	 	s EmailSend=rs.Get("EmailSend")
	 	s OEORItemID=rs.Get("OEORItemID")
	 	s MobilePhone=rs.Get("MobilePhone")
	 	s PAPMISex=rs.Get("PAPMISex")
	 	s PAPMIAge=rs.Get("PAPMIAge")
	 	i Name="test1"  s MobilePhone="13874623556"
	 	
		i (mess'="") s mess=mess_","
		s mess=mess_"{""PatRegNo"":"_""""_RegNo_""""
		s mess=mess_","_"""PatName"":"_""""_Name_""""
		s mess=mess_","_"""ARCItemDesc"":"_""""_ARCItemDesc_""""
	    s mess=mess_","_"""MobileSend"":"_""""_MobileSend_""""
		s mess=mess_","_"""EmailSend"":"_""""_EmailSend_""""
		s mess=mess_","_"""OEORItemID"":"_""""_OEORItemID_""""
		s mess=mess_","_"""MobilePhone"":"_""""_MobilePhone_""""
		s mess=mess_","_"""PAPMISex"":"_""""_PAPMISex_""""
		s mess=mess_","_"""PAPMIAge"":"_""""_PAPMIAge_""""
		s mess=mess_"}"
	}	 
	
   // w !,mess
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

Query GetIllItem(start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", SendFlag As %String = "", PatRegNo As %String = "", PatName As %String = "", Out As %String = "", InHospital As %String = "", PE As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,ARCItemDesc:%String,MobileSend:%String,EmailSend:%String,OEORItemID:%String,MobilePhone:%String,PAPMISex:%String,PAPMIAge:%String")
{
}

ClassMethod GetIllItemExecute(ByRef qHandle As %Binary, start As %String = "", limit As %String = "", CTLocRowID As %String = "", DateFrom As %String = "", DateTo As %String = "", SendFlag As %String = "", PatRegNo As %String = "", PatName As %String = "", Out As %String = "", InHospital As %String = "", PE As %String = "") As %Status
{
   
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    i DateFrom'=""  s DateFrom=$zdh(DateFrom,3)
	else  s DateFrom=+$h-365
	i DateTo'="" s DateTo=$zdh(DateTo,3)
	else  s DateTo=+$h
	s MobileSend="",EmailSend=""
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    s namespaceLab=^DHCCRMSetting("NAMESPACE","LABDATA")
	s Date=DateFrom-1
	f  s Date=$o(^[namespaceLab]TEPIi("AUTHORISED",Date))  q:(Date="")||(Date>DateTo)  d
	.s VisitNumber=0
	.f  s VisitNumber=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber))  q:VisitNumber=""  d
	..s TestSetDR=0
	..f  s TestSetDR=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber,TestSetDR))  q:TestSetDR=""  d
	...s Counter=0
	...f  s Counter=$o(^[namespaceLab]TEPIi("AUTHORISED",Date,VisitNumber,TestSetDR,Counter))  q:Counter=""  d
    ....s MobileSend="",EmailSend=""
    ....s OEORDRowId=0
    ....f  s OEORDRowId=$o(^OEORD(0,"EpisNo",VisitNumber,OEORDRowId))  q:OEORDRowId=""  d
    .....s PAADM=$p($G(^OEORD(OEORDRowId)),"^",1)
    .....q:PAADM=""
    .....S PAADMType=$P($G(^PAADM(PAADM)),"^",2)
    .....s StutasStr=Out_"^"_InHospital_"^"_PE
    .....q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    .....q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    .....q:((StutasStr["true")&&(PE="false")&&(PAADMType="H"))  
    .....s DepLoc=$P($G(^PAADM(PAADM)),"^",4)
    .....q:(CTLocRowID'="")&&(DepLoc'=CTLocRowID)
    .....s PAPMIDR=$P($G(^PAADM(PAADM)),"^",1) // PAADM_PAPMI_D//R
    .....q:PAPMIDR=""
    .....s PAPMIDeceased=$p(^PAPER(PAPMIDR,"ALL"),"^",12)
    .....q:PAPMIDeceased="Y"
    .....s Name=""
    .....s Name=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
    .....q:(PatName'="")&&(Name'[PatName)
    .....s RegNo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
    .....s RegNo=+RegNo
    .....q:(PatRegNo'="")&&(PatRegNo'=RegNo)
    .....S MobilePhone=$P(^PAPER(PAPMIDR,"PER",4),"^",21)  //移动号码
    .....i MobilePhone=""  S MobilePhone=$P(^PAPER(PAPMIDR,"PER",1),"^",11)  //电话
    .....s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIDR,"ALL")),"^",6),+$h)
	.....s PAPMIAge=$P(Age,"Y",1)
    .....s PAPMISexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
    .....i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    .....s OEORIChildsub=0
    .....s OEORIChildsub=$o(^OEORDi(0,"LabTS",OEORDRowId,VisitNumber_"||"_TestSetDR_"||"_Counter,0))
    .....q:OEORIChildsub=""
    .....s OEORItemID=OEORDRowId_"||"_OEORIChildsub
    .....q:((SendFlag="true")&&($o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,0))="" )) 
    .....s LRSSendStatusStr=""
    .....s LRSRowId=0
    .....f  s LRSRowId=$o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,LRSRowId))  q:LRSRowId=""  d
    ......s LRSSendStatus=$p(^DHCCRMLRS(LRSRowId),"^",4)
    ......s LRSSendMode=$p(^DHCCRMLRS(LRSRowId),"^",5)
    ......i (LRSSendMode="SMS")&&(LRSSendStatus="S")  s MobileSend="Y"
    ......i LRSSendStatusStr=""  S LRSSendStatusStr=LRSSendStatus
    ......else  s LRSSendStatusStr=LRSSendStatusStr_"^"_LRSSendStatus
    .....q:((SendFlag="false")&&(LRSSendStatusStr["S"))
    .....q:((SendFlag="true")&&(LRSSendStatusStr'["S"))
    .....s ItmMastDR=""
    .....s ItmMastDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    .....q:ItmMastDR=""                            //判断是否为重大疾病
    .....s ARCIMSubscript=$P(ItmMastDR,"||",1)
	.....s ARCIMVersion=$P(ItmMastDR,"||",2)
	.....s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    .....S AERowID=$o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ItmMastDR,0))
    .....q:AERowID=""
    .....Q:$p($G(^DHCCRMARCIMEx(AERowID)),"^",2)'="Y"	
    .....//s ^zl("OEORItemID",OEORItemID)=SendFlag_"^"_$o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,0))_"^"_ARCIMDesc
	.....S ^DHCCRM("LisResultSend",OEORItemID)=VisitNumber_"||"_TestSetDR_"||"_Counter_"$"_PAPMIDR
    .....d Output
    
    s DRPTReportDate=DateFrom-1
	f  s DRPTReportDate=$O(^DHCRBStudyi("ReportDate",DRPTReportDate)) Q:(""=DRPTReportDate)||((""'=DateTo)&&(DateTo<DRPTReportDate))  d
	.s DRPTRowID=0
	.f  s DRPTRowID=$O(^DHCRBStudyi("ReportDate",DRPTReportDate,DRPTRowID)) Q:(""=DRPTRowID)  d
	..Set RisItemStatus=$P(^DHCRBStudy("Report",DRPTRowID),"^",4)
	..//Quit:(RisItemStatus'="5")   //"Error: the result is not Verify."	//未发布	
	..s PAADM=$P(^DHCRBStudy("Report",DRPTRowID),"^",16)
	..s OEORItemID=$P(^DHCRBStudy("Report",DRPTRowID),"^",15)
	..q:((SendFlag="true")&&($o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,0))="" )) 
    ..s LRSSendStatusStr=""
    ..s LRSRowId=0
    ..f  s LRSRowId=$o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,LRSRowId))  q:LRSRowId=""  d
    ...s LRSSendStatus=$p(^DHCCRMLRS(LRSRowId),"^",4)
    ...s LRSSendMode=$p(^DHCCRMLRS(LRSRowId),"^",5)
    ...i (LRSSendMode="SMS")&&(LRSSendStatus="S")  s MobileSend="Y"
    ...i LRSSendStatusStr=""  S LRSSendStatusStr=LRSSendStatus
    ...else  s LRSSendStatusStr=LRSSendStatusStr_"^"_LRSSendStatus
    ..q:((SendFlag="false")&&(LRSSendStatusStr["S"))
    ..q:((SendFlag="true")&&(LRSSendStatusStr'["S"))
	..s ExamResult=^DHCRBStudy("Report",DRPTRowID,"ResultDescEx")  //4,诊断意见
    ..q:PAADM=""
    ..S PAADMType=$P($G(^PAADM(PAADM)),"^",2)
    ..s StutasStr=Out_"^"_InHospital_"^"_PE
    ..q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
    ..q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
    ..q:((StutasStr["true")&&(PE="false")&&(PAADMType="H"))  
    ..s PAPMIDR=$P($G(^PAADM(PAADM)),"^",1) // PAADM_PAPMI_D//R
    ..q:PAPMIDR=""
    ..s PAPMIDeceased=$p(^PAPER(PAPMIDR,"ALL"),"^",12)
    ..q:PAPMIDeceased="Y"
	..s PAPMIRegNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
    ..s PAPMIName=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
    ..S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",4)),"^",21)  //移动号码
    ..i PAPERTelH=""  S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",1)),"^",11)  //电话
    ..s PAPMISexDR=$p($g(^PAPER(PAPMIDR,"ALL")),"^",7)
    ..i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    ..s Age=##class(web.DHCLCNUREXCUTE).CalAge($P($G(^PAPER(PAPMIDR,"ALL")),"^",6),+$h)
	..s PAPMIAge=$P(Age,"Y",1)
    ..s RegNo=$p($g(^PAPER(PAPMIDR,"PAT",1)),"^",1)
    ..s Name=$p($g(^PAPER(PAPMIDR,"ALL")),"^",1)
    ..s ItmMastDR=$p($g(^OEORD($p(OEORItemID,"||",1),"I",$p(OEORItemID,"||",2),1)),"^",2)
    ..q:ItmMastDR=""                            //判断是否为重大疾病
    ..s ARCIMSubscript=$P(ItmMastDR,"||",1)
	..s ARCIMVersion=$P(ItmMastDR,"||",2)
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
    ..S AERowID=$o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ItmMastDR,0))
    ..q:AERowID=""
    ..Q:$p($G(^DHCCRMARCIMEx(AERowID)),"^",2)'="Y"
    ..s ^DHCCRM("RisResultSend",OEORItemID)=ExamResult_"^"_PAPMIName_"^"_PAPMISex_"^"_ARCIMDesc
    ..d Output
    
     /*
     //病理 
     s FReportDATE=DateFrom-1
     f  s FReportDATE=$O(^DHCPISTestMasteri("FDATE",FReportDATE))  q:FReportDATE=""   d
     .S TMROWID=0
     .f  s TMROWID=$O(^DHCPISTestMasteri("FDATE",FReportDATE,TMROWID)) q:TMROWID=""  d
     ..s TMPATHID=$p($g(^DHCPISTestMaster(TMROWID)),"^",4)
     ..s ReportInfo=..allReport(TMPATHID)
     ..s ResultInfo=$p(ReportInfo,"%",1)
     ..s ReportIDStr=$p(ReportInfo,"%",2)
     ..s PAADM=$p($g(^DHCPISTestMaster(TMROWID)),"^",3)
     ..q:PAADM=""
     ..S PAADMType=$P($G(^PAADM(PAADM)),"^",2)
     ..s StutasStr=Out_"^"_InHospital_"^"_PE
     ..q:((StutasStr["true")&&(Out="false")&&(PAADMType="O") )
     ..q:((StutasStr["true")&&(InHospital="false")&&(PAADMType="I"))
     ..q:((StutasStr["true")&&(PE="false")&&(PAADMType="H"))  
     ..s PAPMIDR=$P($G(^PAADM(PAADM)),"^",1) 
     ..q:PAPMIDR=""
     ..s TMNAME=$p($g(^DHCPISTestMaster(TMROWID)),"^",14)
     ..s PAPMISexDR=$p($g(^DHCPISTestMaster(TMROWID)),"^",17)
     ..i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
     ..s Age=##class(web.DHCLCNUREXCUTE).CalAge($p($g(^DHCPISTestMaster(TMROWID)),"^",18),+$h)
	 ..s PAPMIAge=$P(Age,"Y",1)
	 ..s RegNo=$p($g(^DHCPISTestMaster(TMROWID)),"^",33)
	 ..S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",4)),"^",21)  //移动号码
     ..i PAPERTelH=""  S PAPERTelH=$P($g(^PAPER(PAPMIDR,"PER",1)),"^",11)  //
	 ..s OEORItemID=$p($g(^DHCPISTestMaster(TMROWID)),"^",32)
	 ..q:((SendFlag="true")&&($o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,0))="" )) 
     ..s LRSSendStatusStr="",LRSReportIDS=""
     ..s LRSRowId=0
     ..f  s LRSRowId=$o(^DHCCRMLRS(0,"LRS_OEORI_DR",OEORItemID,LRSRowId))  q:LRSRowId=""  d
     ...s LRSSendStatus=$p(^DHCCRMLRS(LRSRowId),"^",4)
     ...s LRSSendMode=$p(^DHCCRMLRS(LRSRowId),"^",5)
     ...s LRSReportID=$p(^DHCCRMLRS(LRSRowId),"^",7)
     ...i (LRSSendMode="SMS")&&(LRSSendStatus="S")  s MobileSend="Y"
     ...i LRSSendStatusStr=""  S LRSSendStatusStr=LRSSendStatus
     ...else  s LRSSendStatusStr=LRSSendStatusStr_"^"_LRSSendStatus
    ..q:((SendFlag="false")&&(LRSSendStatusStr["S"))
    ..q:((SendFlag="true")&&(LRSSendStatusStr'["S"))
	 ..s ItmMastDR=$p($g(^OEORD($p(OEORItemID,"||",1),"I",$p(OEORItemID,"||",2),1)),"^",2)
     ..q:ItmMastDR=""                            //判断是否为重大疾病
     ..s ARCIMSubscript=$P(ItmMastDR,"||",1)
	 ..s ARCIMVersion=$P(ItmMastDR,"||",2)
	 ..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
     ..S AERowID=$o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ItmMastDR,0))
     ..q:AERowID=""
     ..//Q:$p($G(^DHCCRMARCIMEx(AERowID)),"^",2)'="Y"
     ..s ^DHCCRM("PisResultSend",OEORItemID)=ResultInfo_"^"_PAPMIName_"^"_PAPMISex_"^"_ARCIMDesc_"^"_ARCIMDesc_"^"_ReportIDStr
     
     */
     
     Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(RegNo,Name,ARCIMDesc,MobileSend,EmailSend,OEORItemID,MobilePhone,PAPMISex,PAPMIAge)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod allReport(pathId As %String)
{
	s pathId=$g(pathId)
    s rptRowIdStr=""
	s reptortInfo=""	
	s rptRowId=0 f  s rptRowId=$o(^DHCPISReporti("PATHID",pathId,rptRowId)) q:rptRowId=""  d
	.i '$d(^DHCPISReport(rptRowId)) q
	.s info="" s classdr="" s Report="" s docdr=""
	.s class="" s doc=""
	.s classdr=$p(^DHCPISReport(rptRowId),"^",2)
	.s Report=$p(^DHCPISReport(rptRowId),"^",3)
	.s docdr=$p(^DHCPISReport(rptRowId),"^",6)
	.i classdr=0 s class="病理冰冻切片报告"
	.i classdr=1 s class="病理标本检查报告"
	.i classdr=2 s class="病理会诊报告"
	.i classdr=3 s class="病理检查补充报告"
	.i classdr=4 s class="尸体检查报告"
	.i classdr=5 s class="细胞学检查报告"
	.i classdr=6 s class="体检类检查报告"
	.s info=class_":"_Report
	.s reptortInfo=reptortInfo_info_$c(13,10,13,10)
	.i rptRowIdStr=""  s rptRowIdStr=rptRowId
	.else  s rptRowIdStr=rptRowIdStr_"^"_rptRowId
    
    s reptortInfo=reptortInfo_"%"_rptRowIdStr
	q reptortInfo
}

ClassMethod GetIllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIllItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod trans(tc, ret)
{
   s itmtype=$p($g(^TTAB("TC",tc)),"\",3)
   //b //1
   i itmtype["N" d    ;numeric
   .s decimal=$e(itmtype,2)
   .i decimal="" s decimal="0"
   .s temres=..CheckResDecimal(ret,decimal)
   .s ret=temres_$c(1)_temres
   .//b //2
   .;标准备注
   e  i itmtype["S" d
   .s preres=""
   .i $l(ret),$d(^TTAB("TC",tc,2,ret,1))  d
   ..s preres=$g(^TTAB("TC",tc,2,ret,1))
   .s ret=ret_$c(1)_preres
   .;血型
   e  i itmtype["B" d
   .s preres=""
   .i $l(ret),$d(^TTAB("BB-BG",ret)) d
   ..s preres=$p(^TTAB("BB-BG",ret),"\",1)
   .s ret=ret_$c(1)_preres
   .;bug
   e  i itmtype="V" d
   .i $l(ret),$d(^TTAB("BUG",ret)) d
   ..s preres=$p(^TTAB("BUG",ret),"\",1)
   ..s ret=ret_$c(1)_preres
   e  d
   .s ret=ret_$c(1)_ret
   q ret
}

ClassMethod CheckResDecimal(res, dec)
{
	//n (res,dec)
	s res=$g(res),dec=+$g(dec)
	s ret=""
	i res="" q ret
	i dec="" q ret
	s flag=""
	i ($e(res)="<")!($e(res)=">") s flag=$e(res),res=$tr(res,"<>")
	s res=+res
	s ret=$fn(res,"",dec)
	q flag_ret
}

//d ##class(web.DHCCRM.LisResultSend).GetNormalStr("M1072","M")

ClassMethod GetNormalStr(CTTCCode, sex)
{
  q:CTTCCode="" ""
   s NormalRange=""
   //S Version=^DHCPESetting("DHCPE","TrakVerison")
   // s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    S Version=^DHCCRMSetting("DHCCRM","TrakVerison")
    s namespaceLab=^DHCCRMSetting("NAMESPACE","LABDATA")
    s CurSpace=$ZNSpace
    Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	ZN namespaceLab
	If ((ResultFormat="X")!(ResultFormat="S")) Do
	.Set CTTCTCode=""
	.Set NormalStr=""
	.For  Set CTTCTCode=$o(^TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:(CTTCTCode="")!(NormalStr'="")  Do
	..//Quit:($p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",22)'=sex)
	..Set IsNormal=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	..Set Format=$p(^TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	..If IsNormal="N" Set NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
	..If Format="Y" Set NormalStr=^TTAB("TC",CTTCCode,2,CTTCTCode,1)
	.If NormalStr="" Do
	..If Version="MedTrak" Do
	...Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","")
	..Else  Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","","","","")
	..Set NormalStr=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
	If $e(ResultFormat,1)="N" Do
	.If Version="MedTrak" Do
	..Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","")
	.Else  Set Ranges=$$ranges^LVBVIS1(CTTCCode,"17",sex,"",0,"","","","","")
	.Set NormalRange=$p(Ranges,$C(1),1)_"-"_$p(Ranges,$C(1),2)
	ZN CurSpace
	q NormalRange
}

//S1069  43.0(0.0-10.0) 2.09(1.50-2.50)

//d ##class(web.DHCCRM.LisResultSend).GetNormalFlag("2.09","S1126","1.50-2.50")

ClassMethod GetNormalFlag(Result, CTTCCode, NormalStr)
{
   
    q:CTTCCode="" ""
    S Normal=0
   // S Version=^DHCPESetting("DHCPE","TrakVerison")
   // s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
    S Version=^DHCCRMSetting("DHCCRM","TrakVerison")
    s namespaceLab=^DHCCRMSetting("NAMESPACE","LABDATA")
    s CurSpace=$ZNSpace
    Set ResultFormat=$p($g(^[namespaceLab]TTAB("TC",CTTCCode)),"\",3)
	If ResultFormat="X" Do
	.If NormalStr=Result Set Normal=1
	.If $o(^TTAB("TC",CTTCCode,4,""))'="" Do
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (Result>=Min)&&(Result<=Max) Set Normal=1
	.if (Result)="-" Set Normal=1
	If $e(ResultFormat,1)="N" Do
	.i NormalStr["<" d
	..s NormalStr=$p(NormalStr,"<",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(Result<=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(Result<NormalStr) Normal=1
	.e  i NormalStr[">" d
	..s NormalStr=$p(NormalStr,">",2)
	..s EqualFlag=0
	..i NormalStr["=" d
	...s NormalStr=$p(NormalStr,"=",2)
	...s EqualFlag=1
	..s NormalStr=+NormalStr
	..s:(EqualFlag=1)&&(Result>=NormalStr) Normal=1
	..s:(EqualFlag=0)&&(Result>NormalStr) Normal=1
	.e  d
	..Set Min=$p(NormalStr,"-",1)
	..Set Max=$p(NormalStr,"-",2)
	..If (Result>=Min)&&(Result<=Max) Set Normal=1
	If ResultFormat="S" Do
	.Set CTTCTCode=""
	.Set ResultDesc=""
	.Set NotNormal=""
	.For  Set CTTCTCode=$o(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode)) Quit:((CTTCTCode="")||(Normal=1))  Do
	..Set NotNormal=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",1)
	..Set Format=$p(^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode),"\",3)
	..Set ResultDesc=^[namespaceLab]TTAB("TC",CTTCCode,2,CTTCTCode,1)
	..If (ResultDesc=Result)&(NotNormal="A") Set Normal=0
	..If ((ResultDesc=Result)&(NotNormal'="A")) Set Normal=1
  q Normal
}

ClassMethod SMSSend(OEORDItemID, SendStatus, actiontype)
{
    s SendUserDR=%session.Get("LOGON.USERID")
    S SendDate=+$h,SendMode="SMS"
    s SendTime=$p($h,",",2)
    i actiontype'="SMSSend"  s SendMode="EMAIL"
	&sql(insert into DHC_CRM_LabResultSend
	     (LRS_OEORI_DR,LRS_SendDate,LRS_SendTime,LRS_SendStatus,LRS_SendMode,LRS_SendUser_DR)
	     values 
	     (:OEORDItemID,:SendDate,:SendTime,:SendStatus,:SendMode,:SendUserDR)
	     )
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台插入失败!"_SQLCODE_"""}"
    q ""
}

//133||101

//d ##class(web.DHCCRM.LisResultSend).GetResultList("133||101")

ClassMethod GetResultList(OEORDITEM)
{
   
	//s ^zl("mess")=OEORDITEM 
	s rs=##class(%ResultSet).%New("web.DHCCRM.ImportantIllResultSend:SearchResultList")
	d rs.Execute(OEORDITEM)
 	s count=0
 	s mess=""
	while (rs.Next())
 	{
	 	s count=count+1
	 	
	 	s ResultStr=rs.Get("ResultStr")
	 	s ARCIMDesc=rs.Get("ARCIMDesc")
	 	s mySex=rs.Get("mySex")
	 	s Name=rs.Get("Name")  //:%String,mySex:%String,Name:%String
	 	s OEORDItem=rs.Get("OEORDItem")
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ResultStr"":"_""""_ResultStr_""""
        s mess=mess_","_"""ARCIMDesc"":"_""""_ARCIMDesc_""""
		s mess=mess_","_"""mySex"":"_""""_mySex_""""
	    s mess=mess_","_"""Name"":"_""""_Name_""""
		s mess=mess_","_"""OEORDItem"":"_""""_OEORDItem_""""
		s mess=mess_"}"

	}	 
 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	//w !,mess
 	q mess
}

//d ##class(%ResultSet).RunQuery("web.DHCCRM.LisResultSend","SearchCTLoc","tx")

Query SearchResultList(OEORDItem As %String = "") As %Query(ROWSPEC = "ResultStr:%String,ARCIMDesc:%String,mySex:%String,Name:%String,OEORDItem:%String")
{
}

ClassMethod SearchResultListExecute(ByRef qHandle As %Binary, OEORDItem As %String = "") As %Status
{
  
    q:OEORDItem="" ""
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PAPERTelH=""
	//s HospitalName=$g(^DHCDRMSetting("DHCCRM","HospitalName"))
	//s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s HospitalName=^DHCCRMSetting("DHCCRM","HospitalName")   
    s namespaceLab=^DHCCRMSetting("NAMESPACE","LABDATA")
	i $D(^DHCCRM("LisResultSend",OEORDItem)){
	s Str=$g(^DHCCRM("LisResultSend",OEORDItem))     //=VisitNumber_"||"_TestSetDR_"||"_Counter
	s ItmMastDR=""
    s ItmMastDR=$p($g(^OEORD($p(OEORDItem,"||",1),"I",$p(OEORDItem,"||",2),1)),"^",2)
    q:ItmMastDR=""
    s ARCIMSubscript=$P(ItmMastDR,"||",1)
	s ARCIMVersion=$P(ItmMastDR,"||",2)
	s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)	
	s PAPMIDR=$p(Str,"$",2)
	q:PAPMIDR="" ""
	s Name=""
    s Name=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	s PAPMISexDR=$p(^PAPER(PAPMIDR,"ALL"),"^",7)
    S PAPMISex="" , mySex="M"
    i PAPMISexDR'=""  S PAPMISex=$P($g(^CT("SEX",PAPMISexDR)),"^",2)
    i PAPMISex="女"  s mySex="F"
    S PAPERTelH=$P(^PAPER(PAPMIDR,"PER",4),"^",21)  //移动号码
    i PAPERTelH=""  S PAPERTelH=$P(^PAPER(PAPMIDR,"PER",1),"^",11)  //电话
	s LabData=$p(Str,"$",1)
	s VisitNumber=$p(LabData,"||",1)
	s TestSetDR=$p(LabData,"||",2)
	s Counter=$p(LabData,"||",3)
	s ResultStr="",CTTCDesc="",Units="",labResult="",NormalStr=""
    s TestCodeDR=0
    f  s TestCodeDR=$o(^TEPI(VisitNumber,1,TestSetDR, Counter,"DATA",TestCodeDR))  q:TestCodeDR=""  d
    .s CTTCDesc=$p(^TTAB("TC",TestCodeDR),"\",1)
    .s Units=$p(^TTAB("TC",TestCodeDR),"\",2)
    .s TestData=$p(^TEPI(VisitNumber,1,TestSetDR, Counter,"DATA",TestCodeDR),"\",1)
    .s labResult=$p(..trans(TestCodeDR,TestData),$c(1),2)
    .s NormalStr=..GetNormalStr(TestCodeDR,mySex)
    .s IsNormal=..GetNormalFlag(labResult,TestCodeDR,NormalStr)
    .If $g(labResult)'="" Do
	..s CurSpace=$ZNSpace
	..zn namespaceLab
	..s LabResultStr=$$TestItmRes^CHDhcLabReport(VisitNumber,TestCodeDR,labResult,61062)
	..zn CurSpace
	..Set flag=$p(LabResultStr,$c(2),11)
	..If (flag'="")&(flag'="N") Set IsNormal="0"
	.q:IsNormal=1
    .s labResult=CTTCDesc_":"_labResult_"("_NormalStr_")"
    .i ResultStr=""  s ResultStr=labResult
    .else  s ResultStr=ResultStr_"   "_labResult
    
   s ResultStr=ResultStr_"   "_HospitalName
    d OutputRow1
	}
	
	if $D(^DHCCRM("RisResultSend",OEORDItem)){
	s ResultStr="",Name="",mySex="",ARCIMDesc=""
	s RisStr=$g(^DHCCRM("RisResultSend",OEORDItem))
	s ResultStr=$p(RisStr,"^",1)
	s Name=$p(RisStr,"^",2)
	s mySex=$p(RisStr,"^",3)
	s ARCIMDesc=$p(RisStr,"^",3)
	s ResultStr=ResultStr_"   "_HospitalName
    d OutputRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(ResultStr,ARCIMDesc,mySex,Name,OEORDItem)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchResultListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)

 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }

 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RegNoMask(RegNo)
{
	//s length=+$G(^DHCPESetting("DHCPE","RegNoLength"))
	s length=+$G(^DHCCRMSetting("DHCCRM","RegNoLength"))
	i length=0 s length=8
	s ZeroStr=$E("00000000000000000000000000",1,length)
	s RegNo=$E(ZeroStr,1,length-$l(RegNo))_RegNo
	q RegNo
}

Storage Default
{
<Data name="ImportantIllResultSendDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCRM.ImportantIll8E8D</DataLocation>
<DefaultData>ImportantIllResultSendDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCCRM.ImportantIll8E8D</IdLocation>
<IndexLocation>^web.DHCCRM.ImportantIll8E8I</IndexLocation>
<StreamLocation>^web.DHCCRM.ImportantIll8E8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
