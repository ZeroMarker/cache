Import SQLUser

Class web.DHCRisWardQueryJDSY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 21;

ClassMethod GetWardByLoc(LocDr, FindFlag As %String = "") As %String
{
	s LocType=$p(^CTLOC(LocDr),"^","13")
	if (LocType="W")
	{
		q:FindFlag=1 %request.Get("WardName")_"^"_%request.Get("ward")
		s warrowid=0
		s warrowid=$o(^PAWARD(0,"WARD_LocationDR",LocDr,warrowid)) 
		s desc=$p(^PAWARD(warrowid),"^",2)
		q desc_"^"_warrowid
	}
	else
	{
	
		 q "^"
	}
}

/// 查询病区信息
/// w ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryWard","GKY-") 
Query QueryWard(InDesc As %String) As %Query(ROWSPEC = "Desc:%String,TRowid:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, InDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^DHCRis("2011RIS")=InDesc
    i (InDesc'="")
    {
      s Info=""
      s Info=InDesc
      s Info=$p($g(InDesc),"-",1)
      s InDesc= $ZCONVERT(Info,"U")
	  
    }
    
    s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
    .s Getdesc=$p($g(^PAWARD(rowid)),"^",2)
    .i (InDesc="") d
    ..Do OutRow1
    .i (InDesc'="")&(Getdesc[InDesc) d
    ..Do OutRow1
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow1
	set Data=$lb(Getdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 病区查询 56^62413^62413^^^^^^N^^1^103
/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryItembyWard","56","62413","62413","","","","","","N","","1","103")
/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryItembyWard","","62365","62391","","","","","","","")
Query QueryItembyWard(ward As %String, startdate As %String, enddate As %String, ItemSubId As %String, RecLocId As %String, InRegNo As %String, InMedicareNo As %String, IsApp As %String, IsPFlag As %String, UrgencyFlag As %String, FindFlag As %String = "", GroupID As %String) As %Query(ROWSPEC = "TRecLoc:%String,TBedNo:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TARCItem:%String,TstrDate:%String,TstrTime:%String,Attention:%String,Location:%String,TAppointDate:%String,TAppointstTime:%String,TComplete:%String,TMemo:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TPrintFlag:%String,TMedicareNo:%String,TOERowid:%String,TWardName:%String,TPrintDate:%String,TPrintTime:%String,TUrgency:%String")
{
}

ClassMethod QueryItembyWardExecute(ByRef qHandle As %Binary, ward As %String, startdate As %String, enddate As %String, ItemSubId As %String, RecLocId As %String, InRegNo As %String, InMedicareNo As %String, IsApp As %String, IsPFlag As %String, UrgencyFlag As %String, FindFlag As %String = "", GroupID As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^DHCRis("XHRIS")=ward_"^"_startdate_"^"_enddate_"^"_ItemSubId_"^"_RecLocId_"^"_InRegNo_"^"_InMedicareNo_"^"_IsApp_"^"_IsPFlag_"^"_UrgencyFlag_"^"_FindFlag_"^"_GroupID
	i (ward'="")
	{
		s return=..QuerybyWardRowid(ward, startdate, enddate,ItemSubId,RecLocId,InRegNo,InMedicareNo,IsApp,IsPFlag,UrgencyFlag,FindFlag,GroupID)
		 Quit $$$OK
	}
	else
	{
		s return=..QueryAllWard(startdate, enddate,ItemSubId,RecLocId,InRegNo,InMedicareNo,IsApp,IsPFlag,UrgencyFlag,FindFlag,GroupID)
		 Quit $$$OK
		
	}
}

ClassMethod QueryItembyWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItembyWardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryItembyWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItembyWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerybyWardRowid(ward, startdate, enddate, ItemSubId, RecLocId, InRegNo, InMedicareNo, IsApp, IsPFlag, UrgencyFlag, FindFlag, GroupID)
{
	if ward="" Set qHandle=$lb(0,repid,0)
    q:ward="" $$$OK
   
    k ^DHCRISTEMPWARDQUERY(ward,$J,"Ward")
    s ^DHCRISTEMPWARDQUERY(ward,"Ward")=$J
    s i=0
    
    s room=0 f  s room=$o(^PAROOM(room)) q:room=""  d  ;pac_room
    .s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ..q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	..s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",papmidr,oeordrowid)) q:oeordrowid=""  d  
    ...s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    ....s oeorditemdr=oeordrowid_"||"_oeorisub
    ....s Data="",Date="",IsAppointment=""
    ....s Data=..GetItemDate(oeorditemdr) q:(Data="")
    ....s Date=$p($g(Data),"^",1)
    ....q:(Date="")
    ....s IsAppointment=$p($g(Data),"^",2)
    ....q:(GroupID="")
    ....s GetPFlag=..IsPrint(oeorditemdr,GroupID)
    ....i (Date'>enddate)&(Date'<startdate) d
    .....q:(IsApp'="")&(IsApp'=IsAppointment)
    .....q:(IsPFlag'=GetPFlag) ;按未打印查询（默认）
    .....s PrintData="",PrintDate="",PrintTime=""
	.....s PrintData=..GetPrintDataTime(oeorditemdr)
	.....i PrintData'="" s PrintDate=$p(PrintData,"^",1) s PrintTime=$p(PrintData,"^",2)
	.....s Urgency=""
	.....s Urgency=$p($g(^OEORD(oeordrowid,"I",oeorisub,11)),"^",55)
	.....q:(UrgencyFlag'="")&(UrgencyFlag'=Urgency) //按加急标志查询
    .....;w !,IsApp_"^"_IsAppointment_"&"
    .....s oeoridate=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",7)  ;OEORI_Date oe_orditem
    .....s strDate=$zd(oeoridate,3)
    .....s oeoritimeord=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",17)  ;OEORI_TimeOrd oe_orditem
    .....s strTime=$zt(oeoritimeord,3)
    .....s WardName=$p($p($g(^PAWARD(ward)),"^",2),"-",2)
    .....s ItemStatDR=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",13) ; 医嘱状态
    .....q:ItemStatDR=""
	.....s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	.....i (ItemStatusCode="V")!(ItemStatusCode="E") d 
	......s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)   ;OEORI_ItmMast_DR  oe_orditem
    ......s itemcatdr=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",10)  ;ARCIM_ItemCat_DR ARC_ItmMast
    ......q:(ItemSubId'="")&(ItemSubId'=itemcatdr)   ;按医嘱子类查询
 	......s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)                   ;ARCIC_OrdCat_DR ARC_ItemCat
    ......s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)                ;ORCAT_Code OEC_OrderCategory
    ......s recdepdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6)    ; OEORI_RecDep_DR oe_orditem
    ......q:(RecLocId'="")&(RecLocId'=recdepdr) ;按接收科室查询
    ......s depname=$p($g(^CTLOC(recdepdr)),"^",2)                      ;CTLOC_Desc CT_Loc
    ......i depname'="" s depname=$p($g(depname),"-",2)
    ......s LocAddress=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",6)     ;$g(^CTLOC(recdepdr,"ADDR",1)) ;预约科室的物理位置 
    ......s papmino=$p($g(^PAADM(papmidr)),"^",1) 
    ......s RegNo=$p($g(^PAPER(papmino,"PAT",1)),"^",1)
    ......s patType=$p(^PAADM(papmidr),"^",2)
    ......s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(papmidr,patType,.ErrMsg)
    ......q:(InMedicareNo'="")&(InMedicareNo'=MedicareNo) ;按病历号查询
    ......s Age=..GetAge(papmino)
    ......q:(InRegNo'="")&(InRegNo'=RegNo)  ;按登记号查询
    ......s Name=$p($g(^PAPER(papmino,"ALL")),"^",1)              ;PAPMI_Name PA_Patmas
    ......s Sex="未知",Memo=""
 	......s papmisexdr=$p($g(^PAPER(papmino,"ALL")),"^",7)           ;PAPMI_Sex_DR PA_patmas
    ......i papmisexdr'="" s Sex=$p($g(^CT("SEX",papmisexdr)),"^",2) ;CTSEX_Desc CT_Sex
    ......s BedNo="",ResultFlag="",Complete="",RERowid=""
    ......s beddr=$p($g(^PAADM(papmidr)),"^",73)                      ;PAADM_CurrentBed_DR PA_Adm
    ......i $g(beddr)'="" s BedNo=$p($g(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2))),"^",1)  ;BED_Code PAC_Bed
    ......s DMRowid="" ,Attention=""
    ......s DMRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastdr,0))
	......i Attention="" s Attention=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",5)
    ......s Memo=..GetMemo(oeorditemdr)   ;$g(^OEORD(oeordrowid,"I",oeorisub,"REM"))
    ......s ItemName=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",2) ;ARCIM_Desc ARC_ItmMast
    ......s ServerMaterial=""
    ......s ServerMaterial=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),7)),"^",6)
    ......q:(ServerMaterial'="S")
    ......s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    ......i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    ......i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2) 
    ......s StudyNo="",AppointstTime="",AppointDate="",strRegDate="",strRegTime="",Index="",EQDesc="",ResDesc=""
	......s PatientStatus="医嘱核实"
	......s PatientStatusCode="V"
	......s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	......s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	......s PrintFlag=$g(^DHCRisOrdPrinted(oeorditemdr,GroupID))
	......i (AppointDate'="")&(AppointDate'=$c(0)) d 
	.......s PatientStatus="预约"
	.......s PatientStatusCode="S"
	......s ReportDoc="",ReportVerifyDoc=""
    ......i ItemStatusCode="E"  d  ; 医嘱执行
	.......s PatientStatus="执行" 
	.......s PatientStatusCode="E"
	.......s oeorditemdr=oeordrowid_"||"_oeorisub
	.......s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,0))  ; 登记的表中获得检查号
	.......q:regrowid=""  
	.......s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	.......s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	.......s strRegDate=$zd(RegDate,3) 
	.......s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	.......s strRegTime=$zt(RegTime,1)
	.......s ResStatDR="",resrowid=0
	.......s resrowid=$o(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid))
	.......i resrowid'="" d 
	........s ResStatDR=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",2)
	........i ResStatDR="2"  d 
	.........s PatientStatus="报告" ; 审核的报告
	.........s PatientStatusCode="R"
	.........s CPReportDocDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",35)
	.........i CPReportDocDr'="" d
	..........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	...........i ^DHCRisGetNameSet="ID" d 
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	...........else  d
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)    
	........i ResStatDR="3" d
	.........s PatientStatus="审核"
	.........s PatientStatusCode="A"
	.........s CPVerifyDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",36)
	.........i CPVerifyDr'=""  d
	..........i $g(^CTPCP(CPVerifyDr,1))'="" d 
	...........i $g(^DHCRisGetNameSet)="ID" d 
	............s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	...........else  d
	............s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
	.........s CPReportDocDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",35)
	.........i CPReportDocDr'="" d
	..........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	...........i $g(^DHCRisGetNameSet)="ID" d 
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	...........else  d
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2) 
	......s i=i+1
	......s ^DHCRISTEMPWARDQUERY(ward,$J,"Ward",i)=$g(oeorditemdr)_"^"_$J_"^"_$g(depname)_"^"_$g(BedNo)_"^"_$g(RegNo)_"^"_$g(Name)_"^"_$g(Sex)_"^"_$g(Age)_"^"_$g(ItemName)_"^"_$g(strDate)_"^"_$g(strTime)_"^"_$g(Attention)_"^"_$g(LocAddress)_"^"_$g(AppointDate)_"^"_$g(AppointstTime)_"^"_$g(Complete)_"^"_$g(Memo)_"^"_$g(strRegDate)_"^"_$g(strRegTime)_"^"_$g(StudyNo)_"^"_$g(ReportDoc)_"^"_$g(ReportVerifyDoc)_"^"_$g(PrintFlag)_"^"_$g(WardName)_"^"_$g(MedicareNo)_"^"_$g(PrintDate)_"^"_$g(PrintTime)_"^"_$g(Urgency)
    ......Do OutRow  
    ;k ^DHCRISTEMPWARDQUERY(ward,$J,"Ward")
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
	set Data=$lb(depname,BedNo,RegNo,Name,Sex,Age,ItemName,strDate,strTime,$g(Attention),$g(LocAddress),$g(AppointDate),$g(AppointstTime),$g(Complete),$g(Memo),$g(strRegDate),$g(strRegTime),$g(StudyNo),$g(ReportDoc),$g(ReportVerifyDoc),$g(PrintFlag),$g(MedicareNo),$g(oeorditemdr),$g(WardName),$g(PrintDate),$g(PrintTime),$g(Urgency))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAllWard(startdate, enddate, ItemSubId, RecLocId, InRegNo, InMedicareNo, IsApp, IsPFlag, UrgencyFlag, FindFlag, GroupID)
{

    s i=0
    s ward=0 f  s ward=$o(^PAWARD(ward)) q:ward=""  d
    .k ^DHCRISTEMPWARDQUERY(ward,$J,"Ward")
    .s ^DHCRISTEMPWARDQUERY(ward,"Ward")=$J
    .s room=0 f  s room=$o(^PAADMi("CurrWard",ward,room)) q:room=""  d  ;pac_room
    ..s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ...q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	...s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",papmidr,oeordrowid)) q:oeordrowid=""  d  
    ....s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    .....s oeorditemdr=oeordrowid_"||"_oeorisub
    .....s Date="",Date="",IsAppointment=""
    .....s Data=..GetItemDate(oeorditemdr) q:(Data="")
    .....s Date=$p($g(Data),"^",1)
    .....q:(Date="")
    .....s IsAppointment=$p($g(Data),"^",2)
    .....q:(GroupID="")
    .....s GetPFlag=..IsPrint(oeorditemdr,GroupID)
    .....i (Date'>enddate)&(Date'<startdate) d
    ......q:(IsApp'="")&(IsApp'=IsAppointment)
    ......q:(IsPFlag'=GetPFlag) ;按未打印查询（默认）
    ......s PrintData="",PrintDate="",PrintTime=""
	......s PrintData=..GetPrintDataTime(oeorditemdr)
	......i PrintData'="" s PrintDate=$p(PrintData,"^",1) s PrintTime=$p(PrintData,"^",2)
	......s Urgency=""
	......s Urgency=$p($g(^OEORD(oeordrowid,"I",oeorisub,11)),"^",55)
	......q:(UrgencyFlag'="")&(UrgencyFlag'=Urgency) //按加急标志查询
    ......s oeoridate=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",7)  ;OEORI_Date oe_orditem
    ......s strDate=$zd(oeoridate,3)
    ......s oeoritimeord=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",17)  ;OEORI_TimeOrd oe_orditem
    ......s strTime=$zt(oeoritimeord,3)
    ......s WardName=$p($p($g(^PAWARD(ward)),"^",2),"-",2)
    ......s ItemStatDR=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",13) ; 医嘱状态
    ......q:ItemStatDR=""
	......s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	......i (ItemStatusCode="V")!(ItemStatusCode="E") d 
	.......s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)   ;OEORI_ItmMast_DR  oe_orditem
    .......s itemcatdr=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",10)  ;ARCIM_ItemCat_DR ARC_ItmMast
    .......q:(ItemSubId'="")&(ItemSubId'=itemcatdr)   ;按医嘱子类查询
 	.......s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)                   ;ARCIC_OrdCat_DR ARC_ItemCat
    .......s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)                ;ORCAT_Code OEC_OrderCategory
    .......s recdepdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6)    ; OEORI_RecDep_DR oe_orditem
    .......q:(RecLocId'="")&(RecLocId'=recdepdr) ;按接收科室查询
    .......s depname=$p($g(^CTLOC(recdepdr)),"^",2)                      ;CTLOC_Desc CT_Loc
    .......i depname'="" s depname=$p($g(depname),"-",2)
    .......s LocAddress=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",6)     ;$g(^CTLOC(recdepdr,"ADDR",1)) ;预约科室的物理位置 
    .......s papmino=$p($g(^PAADM(papmidr)),"^",1) 
    .......s RegNo=$p($g(^PAPER(papmino,"PAT",1)),"^",1) ; 
    .......s patType=$p(^PAADM(papmidr),"^",2)
    .......s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(papmidr,patType,.ErrMsg)
    .......q:(InMedicareNo'="")&(InMedicareNo'=MedicareNo) ;按病历号查询
    .......s Age=..GetAge(papmino)
    .......q:(InRegNo'="")&(InRegNo'=RegNo)  ;按登记号查询
    .......s Name=$p($g(^PAPER(papmino,"ALL")),"^",1)              ;PAPMI_Name PA_Patmas
    .......s Sex="未知",Memo=""
 	.......s papmisexdr=$p($g(^PAPER(papmino,"ALL")),"^",7)           ;PAPMI_Sex_DR PA_patmas
    .......i papmisexdr'="" s Sex=$p($g(^CT("SEX",papmisexdr)),"^",2) ;CTSEX_Desc CT_Sex
    .......s BedNo="",ResultFlag="",Complete="",RERowid=""
    .......s beddr=$p($g(^PAADM(papmidr)),"^",73)                      ;PAADM_CurrentBed_DR PA_Adm
    .......i $g(beddr)'="" s BedNo=$p($g(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2))),"^",1)  ;BED_Code PAC_Bed
    .......s DMRowid="",Attention=""
    .......s DMRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastdr,0))
	.......i Attention="" s Attention=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",5)
    .......s Memo=..GetMemo(oeorditemdr)         ;$g(^OEORD(oeordrowid,"I",oeorisub,"REM"))
    .......s ItemName=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",2) ;ARCIM_Desc ARC_ItmMast
    .......s ServerMaterial=""
    .......s ServerMaterial=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),7)),"^",6)
    .......q:(ServerMaterial'="S")
    .......s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    .......i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    .......i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2) 
    .......s StudyNo="",AppointstTime="",AppointDate="",strRegDate="",strRegTime="",Index="",EQDesc="",ResDesc=""
	.......s PatientStatus="医嘱核实"
	.......s PatientStatusCode="V"
	.......s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	.......s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	.......s PrintFlag=$g(^DHCRisOrdPrinted(oeorditemdr,GroupID))
	.......i (AppointDate'="")&(AppointDate'=$c(0)) d 
	........s PatientStatus="预约"
	........s PatientStatusCode="S"
	.......s ReportDoc="",ReportVerifyDoc=""
    .......i ItemStatusCode="E"  d  ; 医嘱执行
	........s PatientStatus="执行" 
	........s PatientStatusCode="E"
	........s oeorditemdr=oeordrowid_"||"_oeorisub
	........s regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,0))  ; 登记的表中获得检查号
	........q:regrowid=""  
	........s StudyNo=$p(^DHCPACRegInfo(regrowid),"^",2)
	........s RegDate=$p(^DHCPACRegInfo(regrowid),"^",8)
	........s strRegDate=$zd(RegDate,3) 
	........s RegTime=$p(^DHCPACRegInfo(regrowid),"^",9)
	........s strRegTime=$zt(RegTime,1)
	........s ResStatDR="",resrowid=0
	........s resrowid=$o(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid))
	........i resrowid'="" d 
	.........s ResStatDR=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",2)
	.........i ResStatDR="2"  d 
	..........s PatientStatus="报告" ; 审核的报告
	..........s PatientStatusCode="R"
	..........s CPReportDocDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",35)
	..........i CPReportDocDr'="" d
	...........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	............i ^DHCRisGetNameSet="ID" d 
	.............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	............else  d
	.............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)    
	.........i ResStatDR="3" d
	..........s PatientStatus="审核"
	..........s PatientStatusCode="A"
	..........s CPVerifyDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",36)
	..........i CPVerifyDr'=""  d
	...........i $g(^CTPCP(CPVerifyDr,1))'="" d 
	............i $g(^DHCRisGetNameSet)="ID" d 
	.............s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",3)
	............else  d
	.............s ReportVerifyDoc=$p(^CTPCP(CPVerifyDr,1),"^",2)
	..........s CPReportDocDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",35)
	..........i CPReportDocDr'="" d
	...........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	............i $g(^DHCRisGetNameSet)="ID" d 
	.............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	............else  d
	.............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2) 
	.......s i=i+1
	.......s ^DHCRISTEMPWARDQUERY(ward,$J,"Ward",i)=$g(oeorditemdr)_"^"_$J_"^"_$g(depname)_"^"_$g(BedNo)_"^"_$g(RegNo)_"^"_$g(Name)_"^"_$g(Sex)_"^"_$g(Age)_"^"_$g(ItemName)_"^"_$g(strDate)_"^"_$g(strTime)_"^"_$g(Attention)_"^"_$g(LocAddress)_"^"_$g(AppointDate)_"^"_$g(AppointstTime)_"^"_$g(Complete)_"^"_$g(Memo)_"^"_$g(strRegDate)_"^"_$g(strRegTime)_"^"_$g(StudyNo)_"^"_$g(ReportDoc)_"^"_$g(ReportVerifyDoc)_"^"_$g(PrintFlag)_"^"_$g(WardName)_"^"_$g(MedicareNo)_"^"_$g(PrintDate)_"^"_$g(PrintTime)_"^"_$g(Urgency)
    .......Do OutRow6
    ;k ^DHCRISTEMPWARDQUERY(ward,$J,"Ward")  
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow6
	set Data=$lb(depname,BedNo,RegNo,Name,Sex,Age,ItemName,strDate,strTime,$g(Attention),$g(LocAddress),$g(AppointDate),$g(AppointstTime),$g(Complete),$g(Memo),$g(strRegDate),$g(strRegTime),$g(StudyNo),$g(ReportDoc),$g(ReportVerifyDoc),$g(PrintFlag),$g(MedicareNo),$g(oeorditemdr),$g(WardName),$g(PrintDate),$g(PrintTime),$g(Urgency))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// w ##class(web.DHCRisWardQuery).GetItemDate("62||994")
ClassMethod GetItemDate(oeorditemdr As %String) As %String
{
	q:(oeorditemdr="")
	s oeordrowid=$p(oeorditemdr,"||",1)
	s oeorisub=$p(oeorditemdr,"||",2)
	
	s (ResultFlag,Complete,RERowid,Date,IsComplete,IsAppointment)=""
	
	s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    i ResultFlag'="" s RERowid=$o(^OEC("RESST",0,"Code",$$ALPHAUP^SSUTIL4(ResultFlag),""))
    i RERowid'="" s Complete=$p($g(^OEC("RESST",RERowid)),"^",2)
    
    
    i (Complete="预约")
    {
	  s IsComplete="Y"  
	}
	
	i (IsComplete="Y")
	{
		
	    s Date=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	    i Date'="" s Date=$zdh(Date,3)
	    s IsAppointment="Y"
	    s Date=Date_"^"_IsAppointment
	
	}
	
	q Date
}

/// 查询检查医嘱子类
/// w ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryItemCat")
Query QueryItemCat() As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryItemCatExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
   
    s rowid=0 f  s rowid=$o(^ARC("IC",rowid)) q:rowid=""  d
    .s desc=$p($g(^ARC("IC",rowid)),"^",2)
    .s daleicode=$p($g(^ARC("IC",rowid)),"^",8)
    .i daleicode'="" d
	..s rCategory=$p($g(^OEC("ORCAT",daleicode)),"^",2)
    ..i rCategory["检查" Do OutRow12
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow12
	set Data=$lb(rowid,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemCatExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询医嘱的接收科室
/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryRecLoc","Y","")
Query QueryRecLoc(Flag As %String, Desc As %String) As %Query(ROWSPEC = "TRowid:%String,Desc:%String")
{
}

ClassMethod QueryRecLocExecute(ByRef qHandle As %Binary, Flag As %String, Desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
    s hospital="(西院)"
    s Stop="(停用)"
    s LocType="E"
    
    s ^DHCRis("XX")=Flag_"^"_Desc
    
    s Desc=$ZCONVERT(Desc,"U")
    Set rowid=0	f  s rowid=$o(^CTLOC(0,"LocType",LocType,rowid)) q:rowid=""  d
	.s GetDesc=$p($g(^CTLOC(rowid)),"^",2) 
	.i Flag="Y" d
	..i (GetDesc[hospital)&(GetDesc'[Stop)&(GetDesc[Desc) d
	...;w !,GetDesc
	...Do OutRow8
	.i Flag="" d
	..i (GetDesc'[Stop)&(GetDesc[Desc) d
	...Do OutRow8
	.i Flag="N" d
	..i (GetDesc'[hospital)&(GetDesc'[Stop)&(GetDesc[Desc) d
	...Do OutRow8
	 
	 Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
 	
OutRow8
	set Data=$lb(rowid,GetDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRecLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod QueryRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// do ##class(%ResultSet).RunQuery("web.DHCRisWardQuery","QueryOrdItemCS","CS")
Query QueryOrdItemCS(ItemDesc As %String) As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String,ItemRowID:%String,SubCategoryDesc:%String")
{
}

ClassMethod QueryOrdItemCSExecute(ByRef qHandle As %Binary, ItemDesc As %String) As %Status
{
	s rARCIMDesc="",rItemRowID="",rSubCategoryDesc="",rPrice=""
	Set repid=$I(^CacheTemp)
	s index=1
	
	s ItemDesc=$g(ItemDesc)
	s ItemDesc=$ZCONVERT(ItemDesc,"U")
	s i=0
	s id=0 f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
	.s text=$p(^ARC("ALIAS",id),"^",6)
	.s text=$ZCONVERT(text,"U")
	.q:($l(text)=0)
	.q:(($e((text),1,$l(ItemDesc)))'[ItemDesc)
	.s tarid=$p(^ARC("ALIAS",id),"^",1)
	.q:tarid=""
	.s id1=$p(tarid,"||",1)
	.s id2=$p(tarid,"||",2)
	.q:$d(^ARCIM(id1,id2,1))=0
	.s rItemRowID=id1_"||"_id2
	.s rARCIMDesc=$p(^ARCIM(id1,id2,1),"^",2)
	.s yzcode=$p(^ARCIM(id1,id2,1),"^",1)
	.s lei=""
	.s leiname=""
	.s daleicode=""
	.s daleiname=""
	.s uomcode=""
	.s uomdesc=""
	.s uomcode=$p(^ARCIM(id1,id2,8),"^",14)
	.i uomcode'="" s uomdesc=$p(^CT("UOM",uomcode),"^",2)
	.s lei=$p(^ARCIM(id1,id2,1),"^",10)
	.i lei'="" s rSubCategory=$p(^ARC("IC",lei),"^",2)
	.s daleicode=$p(^ARC("IC",lei),"^",8)
	.i daleicode'="" d
	..s rCategory=$p(^OEC("ORCAT",daleicode),"^",2)
	..;b //rCategory
	..i rCategory["检查" Do OutOrdItemCS
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutOrdItemCS
	set Data=$lb(rARCIMDesc,rItemRowID, rSubCategory)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod QueryOrdItemCSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
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

ClassMethod QueryOrdItemCSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdItemCSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCRisWardQuery).SetPrintData("56")
/// 获取病区打印数据
ClassMethod SetPrintData(ward As %String) As %String
{
	if (ward'="") 
	{
	  s PRowid=$g(^DHCRISTEMPWARDQUERY(ward,"Ward")) q:(PRowid="")
	  
	  s Info=""
	  s rowid=0 f  s rowid=$o(^DHCRISTEMPWARDQUERY(ward,PRowid,"Ward",rowid))  q:rowid=""  d
	  .s Info=$g(^DHCRISTEMPWARDQUERY(ward,PRowid,"Ward",rowid))_"&"_Info
	}
	else
	{
		 s Info=""
		 s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
		 .s PRowid=$g(^DHCRISTEMPWARDQUERY(rowid,"Ward"))
		 .i PRowid'="" d
		 ..s Printrowid=0 f  s Printrowid=$o(^DHCRISTEMPWARDQUERY(rowid,PRowid,"Ward",Printrowid))  q:Printrowid=""  d
	     ...s Info=$g(^DHCRISTEMPWARDQUERY(rowid,PRowid,"Ward",Printrowid))_"&"_Info
	}
	 
	 q Info
}

/// 按照医嘱号和用户服务组来设置打印标示
/// sunyi 2011-12-16
ClassMethod SetPrintFlag(oeorditemdr As %String, GroupID As %String)
{
	s ^t=oeorditemdr_"&"_GroupID
	s ^DHCRisOrdPrinted(oeorditemdr,GroupID)="Y"	
	q 0
}

ClassMethod GetAge(papatmasmdr As %String) As %String
{
	i (papatmasmdr'="")
	{
		s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
	    i DOB="" d
	 	.s strDOB=""
	 	.s strAge=""
	 	e  d
	    .s strDOB=$ZD(DOB,3)
	    .s strToday=$ZD(+$h,3)
	    .s strAge=##class(web.DHCRisCommFunction).CalAge(strDOB,strToday)
	}
	
    q $g(strAge)
}

/// 判断医嘱是否已打印
/// "Y"_已打印——N_未打印
/// sunyi 2011-11-17
/// w ##class(web.DHCRisWardQuery).IsPrint("1747||50")
ClassMethod IsPrint(oeorditemdr As %String, GroupID As %String)
{
	
	s PrintFlag=$g(^DHCRisOrdPrinted(oeorditemdr,GroupID))
	
	i (PrintFlag="Y")
	{
	   s IsFlag="Y"
	}
	else
	{
		s IsFlag="N"
	}	
	
	q IsFlag
}

/// 打印时保存日期、时间到临时节点
/// sunyi 2011-11-18
ClassMethod SetPrintDateTime(oeorditemdr As %String)
{
	s PrintDate= $zd($h,3)
    s PrintTime=$zt($p($h,",",2))
	s ^DHCRISPRINTDATETIME(oeorditemdr)=PrintDate_"^"_PrintTime
	s Info=$g(^DHCRISPRINTDATETIME(oeorditemdr))
	q Info
}

ClassMethod GetPrintDataTime(oeorditemdr As %String)
{
	s PrintData=$g(^DHCRISPRINTDATETIME(oeorditemdr))
	q PrintData
}

ClassMethod GetMemo(oeorditemdr As %String)
{
	q:(oeorditemdr="") ""
	s OrderRowid=$p(oeorditemdr,"||",1)
	s itemsub=$p(oeorditemdr,"||",2)
	s ItmMastDR="",ItmCatDR="",Memo=""
	
	s ItmMastDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
	i ItmMastDR'="" s ItmCatDR=$p(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1),"^",10)
	i ItmCatDR'=""  s Memo=$g(^JDSYYYBZ(ItmCatDR))
	
	q Memo
}

}
