Class web.DHCPE.Report.DHCPEPhlPriStatistic Extends %RegisteredObject [ ProcedureBlock ]
{

Query SearchPrintUser(PrintUser As %Library.String = "") As %Query(ROWSPEC = "SSUSERName:%String:姓名,Initials:%String:用户ID,RowId:%String:ID")
{
}

ClassMethod SearchPrintUserExecute(ByRef qHandle As %Binary, PrintUser As %Library.String = "") As %Status
{
	
    s ind=1
 	s id=0	
 	s amount=0
 	s PrintUser=##class(web.DHCPE.DHCPECommon).UnEscape(PrintUser)
	Set repid=$I(^CacheTemp)
    s RowId=0
    f  s RowId=$o(^SSU("SSUSR",RowId))  q:RowId=""  d
    .s Initials=$P($G(^SSU("SSUSR",RowId)),"^",1)
    .s Name=$P($G(^SSU("SSUSR",RowId)),"^",2) 
    .q:((Initials'[PrintUser)&&(Name'[PrintUser)&&(PrintUser'=""))
    .d SearchPrintUserOut
 	 
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
SearchPrintUserOut
    s Data=$LB(Name,Initials,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPrintUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPrintUserExecute ]
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

ClassMethod SearchPrintUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPrintUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DHCPEPhlPriStatistic","ReportPrintStatistic","62305","","")

Query ReportPrintStatistic(StartDate As %Library.String = "", EndDate As %Library.String = "", UserId As %Library.String = "", LocId As %Library.String = "") As %Query(ROWSPEC = "TStartDate:%String,TEndDate:%String,TUser:%String,TPrintAmount:%String,TPhlAmount:%String,TPreIADMamount:%String,TUserID:%String,TScanBarCode:%String,TPersonAmount:%String")
{
}

ClassMethod ReportPrintStatisticExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", UserId As %Library.String = "", LocId As %Library.String = "") As %Status
{
	k ^TempDHCPE($J)
	k ^TempDHCPE("User")
	k ^TempDHCPE("Print")
    s ind=10000
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if ((""=StartDate) && (""=EndDate)&&(""=UserId)){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	//s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
 	s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocId))
 	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
    i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
    
    i StartDate="" s StartDate=0
    i EndDate="" s EndDate=+$H
    s RowId=""
 	f  s RowId=$O(^DHCPERPT(RowId))  q:RowId=""  d
 	.s PIADM=$p($G(^DHCPERPT(RowId)),"^",1)
 	.q:PIADM=""
 	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",PIADM)        //Add by 090702
  	.q:LocFlag=1
 	.s PrintUserDR=$P($G(^DHCPERPT(RowId)),"^",6)
 	.q:PrintUserDR=""
 	.q:(PrintUserDR'=UserId)&&(UserId'="")
 	.s PrintDate=$P($G(^DHCPERPT(RowId)),"^",7)
 	.i ((PrintDate>=StartDate)&&(PrintDate<=EndDate)) d 
 	..s PrintuserName=$P($G(^SSU("SSUSR",PrintUserDR)),"^",2)
 	..s ^TempDHCPE($J,PrintUserDR)=+$G(^TempDHCPE($J,PrintUserDR))+1 	
    
    //i HosCode="SYYD" {
 	s CurDate=StartDate-1
 	f  s CurDate=$O(^DHCPETempLabEpisodeNo("Date",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
 	.s Time=0
 	.f  s Time=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time)) q:Time=""  d
 	..s Spec=""
 	..f  s Spec=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time,Spec))  q:Spec=""  d
 	...s OEORD=$O(^OEORD(0,"EpisNo",Spec,0))
 	...q:OEORD=""
 	...s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	...q:LocFlag=1
 	...s FindUserId=$P($G(^DHCPETempLabEpisodeNo(Spec)),"^",3)
 	...q:FindUserId=""
 	...q:((UserId'="")&&(FindUserId'=UserId))
 	...s ^TempDHCPE($J,FindUserId,"Print")=+$G(^TempDHCPE($J,FindUserId,"Print"))+1
 	...i (("^"_$G(^TempDHCPE($J, "PAADMList",FindUserId))_"^")'[("^"_PAADM_"^")) d
 	....S ^TempDHCPE($J,"PAADMList",FindUserId)=$G(^TempDHCPE($J,"PAADMList",FindUserId))_"^"_PAADM
 	....S ^TempDHCPE($J,"PAADMListNum",FindUserId)=+$G(^TempDHCPE($J,"PAADMListNum",FindUserId))+1
    /*
    }
    else{
 	s CurDate=StartDate-1
 	f  s CurDate=$o(^DHCOrdExec(0,"SCollDate",CurDate))  q:CurDate=""  d
 	.s CollRowId=0
 	.f  s CollRowId=$o(^DHCOrdExec(0,"SCollDate",CurDate,CollRowId)) q:CollRowId=""  d
 	..//s ^zl("CurDate",CollRowId)=1
 	..s OEORERowID=$P(^DHCOrdExec(CollRowId),"^",1)
 	..s OEORD=$p(OEORERowID,"||",1)
 	..s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	..s Spec=$p(^OEORD($P(OEORERowID,"||",1),"I",$P(OEORERowID,"||",2),3),"^",20)
 	..//s ^zl("CurDate",CollRowId,1)=Spec
 	..s FindUserId=$P(^DHCOrdExec(CollRowId),"^",12)
 	..q:FindUserId=""
 	..q:((UserId'="")&&(FindUserId'=UserId))
 	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	..q:LocFlag=1
    ..i (("^"_$G(^TempDHCPE($J, "SpecList",FindUserId))_"^")'[("^"_Spec_"^")) d
    ...S ^TempDHCPE($J,"SpecList",FindUserId)=$G(^TempDHCPE($J,"SpecList",FindUserId))_"^"_Spec
 	...s ^TempDHCPE($J,FindUserId,"Print")=+$G(^TempDHCPE($J,FindUserId,"Print"))+1
	..i (("^"_$G(^TempDHCPE($J, "PAADMList",FindUserId))_"^")'[("^"_PAADM_"^")) d
 	...S ^TempDHCPE($J,"PAADMList",FindUserId)=$G(^TempDHCPE($J,"PAADMList",FindUserId))_"^"_PAADM
 	...S ^TempDHCPE($J,"PAADMListNum",FindUserId)=+$G(^TempDHCPE($J,"PAADMListNum",FindUserId))+1
    ..//s ^zl("CurDate","FindUserId",FindUserId,1)=$G(^zl("CurDate","FindUserId",FindUserId,1))+1
    }
 	*/
 	
 	s CurDate=StartDate-1
 	f  s CurDate=$O(^DHCPETempLabEpisodeScan("Date",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
 	.s Time=0
 	.f  s Time=$O(^DHCPETempLabEpisodeScan("Date",CurDate,Time)) q:Time=""  d
 	..s Spec=""
 	..f  s Spec=$O(^DHCPETempLabEpisodeScan("Date",CurDate,Time,Spec))  q:Spec=""  d
 	...s OEORD=$O(^OEORD(0,"EpisNo",Spec,0))
 	...q:OEORD=""
 	...s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	...//s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        
  	...//q:LocFlag=1
 	...s FindUserId=$P($G(^DHCPETempLabEpisodeScan(Spec)),"^",3)
 	...q:FindUserId=""
 	...q:((UserId'="")&&(FindUserId'=UserId))
 	...s ^TempDHCPE($J,FindUserId,"Scan")=+$G(^TempDHCPE($J,FindUserId,"Scan"))+1
 	
 	s CurDate=StartDate-1
 	f  s CurDate=$O(^DHCPEPreIADM(0,"UpdateDate",CurDate)) q:(CurDate="")||(CurDate>EndDate)  d
 	.s User=0
 	.f  s User=$O(^DHCPEPreIADM(0,"UpdateDate",CurDate,User)) q:(User="")  d
 	..q:(UserId'="")&&(UserId'=User)
 	..s PIADM=0
 	..f  s PIADM=$O(^DHCPEPreIADM(0,"UpdateDate",CurDate,User,PIADM)) q:(PIADM="")  d
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)        //Add by 090702
  	...q:LocFlag=1
 	...s ^TempDHCPE($J,User,"PreIADM")=+$G(^TempDHCPE($J,User,"PreIADM"))+1
 	
 	s TotalPrint=0
 	s TotalPhl=0
 	s TotalPre=0
 	s TotalScan=0
 	s TotalPerson=0
 	s StartDate=##class(websys.Conversions).DateLogicalToHtml(StartDate)
 	s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
 	s Name=""
 	f  s Name=$o(^TempDHCPE($J,Name))  q:Name=""  d
 	.s UserName=$P($G(^SSU("SSUSR",Name)),"^",2)
 	.s Printamount=+$G(^TempDHCPE($J,Name))
 	.s Phlamount=+$G(^TempDHCPE($J,Name,"Print"))
 	.s PreIADMamount=+$G(^TempDHCPE($J,Name,"PreIADM"))
 	.s Scanamount=+$G(^TempDHCPE($J,Name,"Scan"))
 	.s Personamount=+$G(^TempDHCPE($J,"PAADMListNum",Name))
 	.s TotalPrint=TotalPrint+Printamount
 	.s TotalPhl=TotalPhl+Phlamount
 	.s TotalPre=TotalPre+PreIADMamount
 	.s TotalScan=TotalScan+Scanamount
 	.s TotalPerson=TotalPerson+Personamount
 	.q:((Phlamount="0")&&(Printamount="0")&&(Personamount="0"))
 	.d ReportPrintStatisticOut
 	s ind=1
	s UserName="汇总"
	s Printamount=TotalPrint
	s Phlamount=TotalPhl
	s PreIADMamount=TotalPre
	s Scanamount=TotalScan
	s Personamount=TotalPerson
	d ReportPrintStatisticOut
    k ^TempDHCPE($J)
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
ReportPrintStatisticOut
    s Data=$LB(StartDate,EndDate,UserName,Printamount,Phlamount,PreIADMamount,Name,Scanamount,Personamount)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ReportPrintStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReportPrintStatisticExecute ]
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

ClassMethod ReportPrintStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReportPrintStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchListInfo(UserID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", Flag As %Library.String = "", LocId As %Library.String = "") As %Query(ROWSPEC = "TUserName:%String,TUserCode:%String,TPatRegno:%String,TPatName:%String,TEpisodeNo:%String,TARCIMDesc:%String,TRecDep:%String,TJob:%String")
{
}

ClassMethod SearchListInfoExecute(ByRef qHandle As %Binary, UserID As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", Flag As %Library.String = "", LocId As %Library.String = "") As %Status
{
	
    s ind=1
 	s CTLOCDesc="",ARCIMDescStr="",PAPMINO="",PAPMIName="",UserName="",Initials=""
 	s Job=$j
	Set repid=$I(^CacheTemp)
	
	//s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode"))
	s HosCode=$G(^DHCPESetting("DHCPE","HospitalCode",LocId))
    i DateFrom="" s DateFrom=0
    i DateTo="" s DateTo=+$H
    s CurDate=DateFrom-1
    if HosCode="SYYD"  {
    if Flag="P"  d   //抽血工作量
 	.f  s CurDate=$O(^DHCPETempLabEpisodeNo("Date",CurDate)) q:(CurDate="")||(CurDate>DateTo)  d
 	..s Time=0
 	..f  s Time=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time)) q:Time=""  d
 	...s Spec=""
 	...f  s Spec=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time,Spec))  q:Spec=""  d
 	....s OEORD=$O(^OEORD(0,"EpisNo",Spec,0))
 	....s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	....q:LocFlag=1
 	....s UserId=$P($G(^DHCPETempLabEpisodeNo(Spec)),"^",3)
 	....q:UserId=""
 	....q:((UserID'="")&&(UserId'=UserID))
 	....s UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	....s Initials=$P($G(^SSU("SSUSR",UserId)),"^",1)
 	....s ^TempDHCPE("User",$J,Spec)=OEORD_"^"_CurDate_"^"_UserName_"^"_Initials
 	
 	if Flag="Person"  d     //抽血人次
 	.f  s CurDate=$O(^DHCPETempLabEpisodeNo("Date",CurDate)) q:(CurDate="")||(CurDate>DateTo)  d
 	..s Time=0
 	..f  s Time=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time)) q:Time=""  d
 	...s Spec=""
 	...f  s Spec=$O(^DHCPETempLabEpisodeNo("Date",CurDate,Time,Spec))  q:Spec=""  d
 	....s OEORD=$O(^OEORD(0,"EpisNo",Spec,0))
 	....s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)      
  	....q:LocFlag=1
 	....s UserId=$P($G(^DHCPETempLabEpisodeNo(Spec)),"^",3)
 	....q:UserId=""
 	....q:((UserID'="")&&(UserId'=UserID))
 	....s UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	....s Initials=$P($G(^SSU("SSUSR",UserId)),"^",1)
	....s ^TempDHCPE("User",$J,"PAADM",PAADM)=$g(^TempDHCPE("User",$J,"PAADM",PAADM))_","_Spec
 	....s ^TempDHCPE("User",$J,PAADM)=OEORD_"^"_CurDate_"^"_UserName_"^"_Initials_"^"_$g(^TempDHCPE("User",$J,"PAADM",PAADM))
 	
 	else  d      //沈阳送检之前扫条码
 	.f  s CurDate=$O(^DHCPETempLabEpisodeScan("Date",CurDate)) q:(CurDate="")||(CurDate>DateTo)  d
 	..s Time=0
 	..f  s Time=$O(^DHCPETempLabEpisodeScan("Date",CurDate,Time)) q:Time=""  d
 	...s Spec=""
 	...f  s Spec=$O(^DHCPETempLabEpisodeScan("Date",CurDate,Time,Spec))  q:Spec=""  d
 	....s OEORD=$O(^OEORD(0,"EpisNo",Spec,0))
 	....s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	....q:LocFlag=1
 	....s UserId=$P($G(^DHCPETempLabEpisodeScan(Spec)),"^",3)
 	....q:UserId=""
 	....q:((UserID'="")&&(UserId'=UserID))
 	....s UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	....s Initials=$P($G(^SSU("SSUSR",UserId)),"^",1)
 	....s ^TempDHCPE("User",$J,Spec)=OEORD_"^"_CurDate_"^"_UserName_"^"_Initials
 	
    }
    ELSE {
	if Flag="P"  d   //抽血工作量
 	.f  s CurDate=$o(^DHCOrdExec(0,"SCollDate",CurDate))  q:CurDate=""  d
 	..s CollRowId=0
 	..f  s CollRowId=$o(^DHCOrdExec(0,"SCollDate",CurDate,CollRowId)) q:CollRowId=""  d
 	...s OEORERowID=$P(^DHCOrdExec(CollRowId),"^",1)
 	...q:OEORERowID=""
 	...s OEORD=$p(OEORERowID,"||",1)
 	...s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	...s Spec=$p(^OEORD(OEORD,"I",$P(OEORERowID,"||",2),3),"^",20)
 	...s UserId=$P(^DHCOrdExec(CollRowId),"^",12)
 	...q:UserId=""
 	...q:((UserID'="")&&(UserId'=UserID))
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	...q:LocFlag=1
  	...s UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	...s Initials=$P($G(^SSU("SSUSR",UserId)),"^",1)
 	...s ^TempDHCPE("User",$J,Spec)=OEORD_"^"_CurDate_"^"_UserName_"^"_Initials
 	...//s ^zlTempDHCPE("User",$J,Spec)=$P(OEORERowID,"||",1)_"^"_CurDate_"^"_UserName_"^"_Initials
 	
 	if Flag="Person"  d 
 	.f  s CurDate=$o(^DHCOrdExec(0,"SCollDate",CurDate))  q:CurDate=""  d
 	..s CollRowId=0
 	..f  s CollRowId=$o(^DHCOrdExec(0,"SCollDate",CurDate,CollRowId)) q:CollRowId=""  d
 	...s OEORERowID=$P(^DHCOrdExec(CollRowId),"^",1)
 	...q:OEORERowID=""
 	...s OEORD=$p(OEORERowID,"||",1)
 	...s PAADM=$p($G(^OEORD(OEORD)),"^",1)
 	...s Spec=$p(^OEORD(OEORD,"I",$P(OEORERowID,"||",2),3),"^",20)
 	...s UserId=$P(^DHCOrdExec(CollRowId),"^",12)
 	...q:UserId=""
 	...q:((UserID'="")&&(UserId'=UserID))
 	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	...q:LocFlag=1
  	...s UserName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	...s Initials=$P($G(^SSU("SSUSR",UserId)),"^",1)
 	...s ^TempDHCPE("User",$J,"PAADM",PAADM)=$g(^TempDHCPE("User",$J,"PAADM",PAADM))_","_Spec
 	...s ^TempDHCPE("User",$J,PAADM)=OEORD_"^"_CurDate_"^"_UserName_"^"_Initials_"^"_$g(^TempDHCPE("User",$J,"PAADM",PAADM))
    }

	i (DateFrom'="")||(DateFrom'=0) s DateFrom=$zd(DateFrom,3)
	i DateTo'=""   s DateTo=$zd(DateTo,3)
	if Flag'="Person"  d     //抽血工作量
	.s LabEpisodeNo=0
	.f  s LabEpisodeNo=$o(^TempDHCPE("User",$J,LabEpisodeNo))  q:LabEpisodeNo=""  d
	..//s ^zlTempDHCPE("User",$J,LabEpisodeNo,1)=$g(^TempDHCPE("User",$J,LabEpisodeNo))
	..s ARCIMDescStr=""
	..s OEORD=$p($g(^TempDHCPE("User",$J,LabEpisodeNo)),"^",1)
	..s BloodDate=$p($g(^TempDHCPE("User",$J,LabEpisodeNo)),"^",2)
	..s UserName=$p($g(^TempDHCPE("User",$J,LabEpisodeNo)),"^",3)
	..s Initials=$p($g(^TempDHCPE("User",$J,LabEpisodeNo)),"^",4)
	..s OEORIChildsub=0
	..f  s OEORIChildsub=$o(^OEORD(0,"EpisNo",LabEpisodeNo,OEORD,OEORIChildsub))  q:OEORIChildsub=""  d
	...s OEORDItem=OEORD_"||"_OEORIChildsub
    ...s ItmMastDR=$P($G(^OEORD(OEORD,"I",OEORIChildsub,1)),"^",2)
   	...s ARCIMSubscript=$P(ItmMastDR,"||",1)
	...s ARCIMVersion=$P(ItmMastDR,"||",2)
	...s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	...s OEORIRecDepDR=$P($G(^OEORD(OEORD,"I",OEORIChildsub,3)),"^",6)
	...i OEORIRecDepDR'=""  s CTLOCDesc=$P($G(^CTLOC(OEORIRecDepDR)),"^",2)   //科室名称
	...i ARCIMDescStr=""  s ARCIMDescStr=ARCIMDesc
	...else  s ARCIMDescStr=ARCIMDescStr_","_ARCIMDesc
	..s ^zlTempDHCPE("User",$J,LabEpisodeNo,2)=ARCIMDescStr
	..s PAADM=$p($G(^OEORD(OEORD)),"^",1)
	..q:PAADM=""
	..s PAPMIID=$p($g(^PAADM(PAADM)),"^",1) 
	..i PAPMIID'=""  d
	...S PAPMINO=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
	...S PAPMIName=$P($g(^PAPER(PAPMIID,"ALL")),"^",1)
    ..d SearchListOut
    else  d
    .s PAADM=0
	.f  s PAADM=$o(^TempDHCPE("User",$J,PAADM))  q:PAADM=""  d
	..s ARCIMDescStr=""
	..s BloodDate=$p($g(^TempDHCPE("User",$J,PAADM)),"^",2)
	..s UserName=$p($g(^TempDHCPE("User",$J,PAADM)),"^",3)
	..s Initials=$p($g(^TempDHCPE("User",$J,PAADM)),"^",4)
	..S LabEpisodeNoStr=$p($g(^TempDHCPE("User",$J,PAADM)),"^",5)
	..s LabEpisodeNo=$p(LabEpisodeNoStr,",",2,$l(LabEpisodeNoStr,","))
	..q:$g(^PAADM(PAADM))=""
	..s PAPMIID=$p($g(^PAADM(PAADM)),"^",1) 
	..Q:PAPMIID=""  
	..S PAPMINO=$P(^PAPER(PAPMIID,"PAT",1),"^",1)
	..S PAPMIName=$P($g(^PAPER(PAPMIID,"ALL")),"^",1)
	
    ..d SearchListOut
    k ^TempDHCPE("User",$J)
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 	
SearchListOut
    s Data=$LB(UserName,Initials,PAPMINO,PAPMIName,LabEpisodeNo,ARCIMDescStr,CTLOCDesc,Job)
    i UserID=""  s UserID="0"
    i Flag="P"  d
    .s ^TempDHCPE("Print",$J,UserID,ind)=UserName_"^"_Initials_"^"_PAPMINO_"^"_PAPMIName_"^"_LabEpisodeNo_"^"_ARCIMDescStr_"^"_CTLOCDesc_"^"_DateFrom_"^"_DateTo_"^"_BloodDate
 	i Flag="Person"  d
 	.s ^TempDHCPE("Person",$J,UserID,ind)=UserName_"^"_Initials_"^"_PAPMINO_"^"_PAPMIName_"^"_LabEpisodeNo_"^"_ARCIMDescStr_"^"_CTLOCDesc_"^"_DateFrom_"^"_DateTo_"^"_BloodDate
 	else  s ^TempDHCPE("Scan",$J,UserID,ind)=UserName_"^"_Initials_"^"_PAPMINO_"^"_PAPMIName_"^"_LabEpisodeNo_"^"_ARCIMDescStr_"^"_CTLOCDesc_"^"_DateFrom_"^"_DateTo_"^"_BloodDate
 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1

 	q
}

ClassMethod SearchListInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchListInfoExecute ]
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

ClassMethod SearchListInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchListInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(web.DHCPE.Report.DHCPEPhlPriStatistic).GetMaxNum("1")

ClassMethod GetMaxNum(UserID, Flag, Job)
{
 
 s Num=0
 i Flag="P" S Num=$o(^TempDHCPE("Print",Job,UserID,""),-1) 
 i Flag="Person"   S Num=$o(^TempDHCPE("Person",Job,UserID,""),-1) 
 ELSE  S Num=$O(^TempDHCPE("Scan",Job,UserID,""),-1)
 Q Num
}

ClassMethod GetExportData(UserID, Num, Flag, Job)
{

 

  i Flag="P"  S Str=$g(^TempDHCPE("Print",Job,UserID,Num))
  i Flag="Person"   S Str=$g(^TempDHCPE("Person",Job,UserID,Num))
  ELSE   S Str=$g(^TempDHCPE("Scan",Job,UserID,Num))
 s BloodDate=$p(Str,"^",10)
 s StartDate=##class(websys.Conversions).DateHtmlToLogical($p(Str,"^",8))
 s EndDate=##class(websys.Conversions).DateHtmlToLogical($p(Str,"^",9))
 i (BloodDate>EndDate)||(BloodDate<StartDate)  s str="Quit"
 Q Str
}

}
