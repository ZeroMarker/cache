Import SQLUser

Class web.DHCRisWardDetailQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 21;

ClassMethod GetWardByLoc(LocDr, FindFlag As %String = "") As %String
{
	s ^DHCRis("XH0306")=LocDr_"^"_FindFlag
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
/// w ##class(%ResultSet).RunQuery("web.DHCRisWardDetailQuery","QueryWard","GKY-") 
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

/// w ##class(web.DHCRisWardQuery).GetItemDate("62||994")
ClassMethod GetItemDate(oeorditemdr As %String) As %String
{
	q:(oeorditemdr="")
	s oeordrowid=$p(oeorditemdr,"||",1)
	s oeorisub=$p(oeorditemdr,"||",2)
	
	s (itmmastdr,IPRowid,AppointMethodId,AppointMethod,Date,ResSchduleID)=""
	s (IsAppoint,WAppFlag,AppDate)=""
	
	s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2)
	i itmmastdr'=""  s IPRowid=$o(^DHCRBCItemBookProperTypei(itmmastdr,0)) 
	i IPRowid'="" s AppointMethodId=$p($g(^DHCRBCItemBookProperty(IPRowid)),"^",2)
	i AppointMethodId'="" s AppointMethod=$p(^DHCRBCAppointMethod(AppointMethodId) ,"^",2)	 

	i (AppointMethod="自动预约") !(AppointMethod="服务台预约")!(AppointMethod="专科预约")!(AppointMethod="会诊预约")!(AppointMethod="科室内预约")!(AppointMethod="外部预约")
	{
	  s IsAppoint="Y"
	}
	
	i (AppointMethod="外部预约")
	{
		s WAppFlag="Y"
	}
	
	i (AppointMethod="无需预约")! (AppointMethod="不需预约")
	{
	  s IsAppoint="N"	
	}
	
	i (IsAppoint="Y")!(WAppFlag="Y")
	{
		s approwid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	    i (approwid'="")&(approwid'=$c(0)) d 
	    .s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",approwid)),"^",2)
	    .i ResSchduleID'=""  s AppDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	    e  d
	    .s AppDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	    .i AppDate'="" s AppDate=$zdh(AppDate,3)
	    
	    s Date=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",7)
	    s Date=Date_"^"_IsAppoint_"^"_WAppFlag_"^"_AppDate
	    
	}
	else
	{
	    s Date=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",7)
	    s Date=Date_"^"_IsAppoint_"^"_WAppFlag_"^"_AppDate
	  	
	}

	
	q Date
}

/// w ##class(%ResultSet).RunQuery("web.DHCRisWardDetailQuery","QueryItemStatus")
Query QueryItemStatus() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QueryItemStatusExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//^OEC("RESST",{RESST_RowId})
	
	s rowid=0 f  s rowid=$o(^OEC("RESST",rowid)) q:(rowid="")  d
	.s code=$p($g(^OEC("RESST",rowid)),"^",1)
	.s desc=$p($g(^OEC("RESST",rowid)),"^",2)
	.i (code="BK")!(code="SC")!(code="RP")!(code="CM") Do OutItemStatus 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutItemStatus
	set Data=$lb(rowid,desc,code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemStatusExecute ]
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

ClassMethod QueryItemStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##class(web.DHCRisWardDetailQuery).GetStatusList()
ClassMethod GetStatusList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisWardDetailQuery:QueryItemStatus")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(3)_$C(1)_rset.GetData(2)
	    e  s ret=ret_"^"_rset.GetData(3)_$C(1)_rset.GetData(2)
	}	
	d rset.Close()
	q ret
}

/// do ##class(%ResultSet).RunQuery("web.DHCRisWardDetailQuery","QueryWardDetail","19^^^100","","","")
Query QueryWardDetail(Info As %String, startdate As %String, enddate As %String, FindFlag As %String = "") As %Query(ROWSPEC = "TRecLoc:%String,TBedNo:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String,TARCItem:%String,TstrDate:%String,TstrTime:%String,Attention:%String,Location:%String,TAppointDate:%String,TAppointstTime:%String,TComplete:%String,TMemo:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TPrintFlag:%String,TMedicareNo:%String,TOERowid:%String,TWardName:%String,TPrintDate:%String,TPrintTime:%String,TUrgency:%String,AttentionURL:%String")
{
}

ClassMethod QueryWardDetailExecute(ByRef qHandle As %Binary, Info As %String, startdate As %String, enddate As %String, FindFlag As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s ^DHCRis("XXX")=Info_"&"_startdate_"&"_enddate_"&"_FindFlag
	s ward=$p($g(Info),"^",1)
	s Status=$p($g(Info),"^",2)
	s InRegNo=$p($g(Info),"^",3)
	s GroupID=$p($g(Info),"^",4)
	
	
	i (ward'="")
	{
		s return=..QuerybyWardRowid(ward, startdate, enddate,Status,InRegNo,GroupID,FindFlag)
		 Quit $$$OK
	}
	else
	{
		s return=..QueryAllWard(startdate, enddate,Status,InRegNo,GroupID,FindFlag)
		 Quit $$$OK
		
	}
}

ClassMethod QueryWardDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWardDetailExecute ]
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

ClassMethod QueryWardDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWardDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerybyWardRowid(ward, startdate, enddate, Status, InRegNo, GroupID, FindFlag)
{
	if ward="" Set qHandle=$lb(0,repid,0)
    q:ward="" $$$OK
    
    s room=0 f  s room=$o(^PAROOM(room)) q:room=""  d  ;pac_room
    .s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ..q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	..s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",papmidr,oeordrowid)) q:oeordrowid=""  d  
    ...s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    ....s oeorditemdr=oeordrowid_"||"_oeorisub
    ....s Data="",Date="",IsAppointment="",WAppFlag="",AppDate=""
    ....s Data=..GetItemDate(oeorditemdr) q:(Data="")
    ....s Date=$p($g(Data),"^",1)
    ....q:(Date="")
    ....s IsAppointment=$p($g(Data),"^",2)
    ....s WAppFlag=$p($g(Data),"^",3)
    ....s AppDate=$p($g(Data),"^",4)
    ....i (Date'>enddate)&(Date'<startdate) d 
    .....q:(AppDate'="")&(AppDate<$p($h,",",1))    ;过滤预约日期小于当天医嘱
    .....s ResultFlag=""
    .....s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    .....q:(Status'="")&(Status'=ResultFlag)
    .....s PrintData="",PrintDate="",PrintTime=""
	.....s PrintData=##class(web.DHCRisWardQuery).GetPrintDataTime(oeorditemdr)
	.....i PrintData'="" s PrintDate=$p(PrintData,"^",1) s PrintTime=$p(PrintData,"^",2)
	.....s Urgency=""
	.....s Urgency=$p($g(^OEORD(oeordrowid,"I",oeorisub,11)),"^",55)
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
 	......s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)                   ;ARCIC_OrdCat_DR ARC_ItemCat
    ......s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)                ;ORCAT_Code OEC_OrderCategory
    ......s recdepdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6)    ; OEORI_RecDep_DR oe_orditem
    ......s depname=$p($g(^CTLOC(recdepdr)),"^",2)                      ;CTLOC_Desc CT_Loc
    ......i depname'="" s depname=$p($g(depname),"-",2)
    ......s LocAddress=$g(^CTLOC(recdepdr,"ADDR",1)) ;预约科室的物理位置 
    ......s papmino=$p($g(^PAADM(papmidr)),"^",1) 
    ......s RegNo=$p($g(^PAPER(papmino,"PAT",1)),"^",1)
    ......s patType=$p(^PAADM(papmidr),"^",2)
    ......s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(papmidr,patType,.ErrMsg)  ;$p($g(^PAPER(papmino,"PAT",1)),"^",22)
    ......s Age=##class(web.DHCRisWardQuery).GetAge(papmino)
    ......q:(InRegNo'="")&(InRegNo'=RegNo)  ;按登记号查询
    ......s Name=$p($g(^PAPER(papmino,"ALL")),"^",1)              ;PAPMI_Name PA_Patmas
    ......s Sex="未知",Memo=""
 	......s papmisexdr=$p($g(^PAPER(papmino,"ALL")),"^",7)           ;PAPMI_Sex_DR PA_patmas
    ......i papmisexdr'="" s Sex=$p($g(^CT("SEX",papmisexdr)),"^",2) ;CTSEX_Desc CT_Sex
    ......s BedNo="",ResultFlag="",Complete="",RERowid=""
    ......s beddr=$p($g(^PAADM(papmidr)),"^",73)                      ;PAADM_CurrentBed_DR PA_Adm
    ......i $g(beddr)'="" s BedNo=$p($g(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2))),"^",1)  ;BED_Code PAC_Bed
    ......s DMRowid="" ,Attention="",AttentionURL="",UMRowid="",UMCode="",TemplateID=""
    ......s DMRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastdr,0))
	......i DMRowid'="" d 
	.......s UMRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",5)
	.......s TemplateID=$p($g(^DHCRBApp("Memo",DMRowid)),"^",4)
	.......i UMRowid'="" s UMCode=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",1)
	.......i UMCode="NP"  d
	........s AttentionURL="注意事项"
	........s Attention=""
	.......e  d
	........i TemplateID'="" s Attention=$p($g(^DHCRBCApp("Memo-Template",TemplateID)),"^",3)
	........i Attention="" s Attention=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",5)
    ......s Memo=$g(^OEORD(oeordrowid,"I",oeorisub,"REM"))
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
	......i WAppFlag="Y" d  ;外部预约
	.......s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	.......s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	......s approwid=""
	......s approwid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	......s PrintFlag=$g(^DHCRisOrdPrinted(oeorditemdr,GroupID))
	......i (approwid'="")&(approwid'=$c(0)) d 
	.......s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",approwid)),"^",2)
	.......i ResSchduleID'=""  d
	........s AppointDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	........s AppointstTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
	.......i AppointDate="" s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	.......i AppointstTime="" s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	.......i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	.......i AppointstTime'="" s AppointstTime=$zt(AppointstTime,1)
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
    ......Do OutRow  
 
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
	set Data=$lb(depname,BedNo,RegNo,Name,Sex,Age,ItemName,strDate,strTime,$g(Attention),$g(LocAddress),$g(AppointDate),$g(AppointstTime),$g(Complete),$g(Memo),$g(strRegDate),$g(strRegTime),$g(StudyNo),$g(ReportDoc),$g(ReportVerifyDoc),$g(PrintFlag),$g(MedicareNo),$g(oeorditemdr),$g(WardName),$g(PrintDate),$g(PrintTime),$g(Urgency),AttentionURL)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryAllWard(startdate, enddate, Status, InRegNo, GroupID, FindFlag)
{

    s ward=0 f  s ward=$o(^PAWARD(ward)) q:ward=""  d
    .s room=0 f  s room=$o(^PAADMi("CurrWard",ward,room)) q:room=""  d  ;pac_room
    ..s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ...q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	...s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",papmidr,oeordrowid)) q:oeordrowid=""  d  
    ....s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    .....s oeorditemdr=oeordrowid_"||"_oeorisub
    .....s Date="",Date="",IsAppointment="",WAppFlag="",AppDate=""
    .....s Data=..GetItemDate(oeorditemdr) q:(Data="")
    .....s Date=$p($g(Data),"^",1)
    .....q:(Date="")
    .....s IsAppointment=$p($g(Data),"^",2)
    .....s WAppFlag=$p($g(Data),"^",3)
    .....s AppDate=$p($g(Data),"^",4)
    .....i (Date'>enddate)&(Date'<startdate) d
    ......q:(AppDate'="")&(AppDate<$p($h,",",1))    ;过滤预约日期小于当天医嘱
    ......s ResultFlag=""
    ......s ResultFlag=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",5)
    ......q:(Status'="")&(Status'=ResultFlag)
    ......s PrintData="",PrintDate="",PrintTime=""
	......s PrintData=##class(web.DHCRisWardQuery).GetPrintDataTime(oeorditemdr)
	......i PrintData'="" s PrintDate=$p(PrintData,"^",1) s PrintTime=$p(PrintData,"^",2)
	......s Urgency=""
	......s Urgency=$p($g(^OEORD(oeordrowid,"I",oeorisub,11)),"^",55)
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
 	.......s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)                   ;ARCIC_OrdCat_DR ARC_ItemCat
    .......s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)                ;ORCAT_Code OEC_OrderCategory
    .......s recdepdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6)    ; OEORI_RecDep_DR oe_orditem
    .......s depname=$p($g(^CTLOC(recdepdr)),"^",2)                      ;CTLOC_Desc CT_Loc
    .......i depname'="" s depname=$p($g(depname),"-",2)
    .......s LocAddress=$g(^CTLOC(recdepdr,"ADDR",1)) ;预约科室的物理位置 
    .......s papmino=$p($g(^PAADM(papmidr)),"^",1) 
    .......s RegNo=$p($g(^PAPER(papmino,"PAT",1)),"^",1) ; 
    .......s patType=$p(^PAADM(papmidr),"^",2)
    .......s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(papmidr,patType,.ErrMsg)
    .......s Age=##class(web.DHCRisWardQuery).GetAge(papmino)
    .......q:(InRegNo'="")&(InRegNo'=RegNo)  ;按登记号查询
    .......s Name=$p($g(^PAPER(papmino,"ALL")),"^",1)              ;PAPMI_Name PA_Patmas
    .......s Sex="未知",Memo=""
 	.......s papmisexdr=$p($g(^PAPER(papmino,"ALL")),"^",7)           ;PAPMI_Sex_DR PA_patmas
    .......i papmisexdr'="" s Sex=$p($g(^CT("SEX",papmisexdr)),"^",2) ;CTSEX_Desc CT_Sex
    .......s BedNo="",ResultFlag="",Complete="",RERowid=""
    .......s beddr=$p($g(^PAADM(papmidr)),"^",73)                      ;PAADM_CurrentBed_DR PA_Adm
    .......i $g(beddr)'="" s BedNo=$p($g(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2))),"^",1)  ;BED_Code PAC_Bed
    .......s DMRowid="" ,Attention="",AttentionURL="",UMRowid="",UMCode="",TemplateID=""
    .......s DMRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastdr,0))
	.......i DMRowid'="" d 
	........s UMRowid=$p($g(^DHCRBApp("Memo",DMRowid)),"^",5)
	........s TemplateID=$p($g(^DHCRBApp("Memo",DMRowid)),"^",4)
	........i UMRowid'="" s UMCode=$p($g(^DHCRBCApp("USE-METHOD",UMRowid)),"^",1)
	........i UMCode="NP"  d
	.........s AttentionURL="注意事项"
	.........s Attention=""
	........e  d
	.........i TemplateID'="" s Attention=$p($g(^DHCRBCApp("Memo-Template",TemplateID)),"^",3)
	.........i Attention="" s Attention=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",5)	
    .......s Memo=$g(^OEORD(oeordrowid,"I",oeorisub,"REM"))
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
	.......i WAppFlag="Y" d  ;外部预约
	........s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	........s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	.......s approwid=""
	.......s approwid=$o(^DHCRBCResSchduleDetaili(0,oeorditemdr,0))
	.......q:(GroupID="")
	.......s PrintFlag=$g(^DHCRisOrdPrinted(oeorditemdr,GroupID))
	.......i (approwid'="")&(approwid'=$c(0)) d 
	........s ResSchduleID=$p($g(^DHCRBCResSchduleDetail("Detail",approwid)),"^",2)
	........i ResSchduleID'=""  d
	.........s AppointDate=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
	.........s AppointstTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5)
	........i AppointDate="" s AppointDate=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",2)
	........i AppointstTime="" s AppointstTime=$p($g(^DHCRISBOOKEDINFO(oeorditemdr)),"^",3)
	........i AppointDate'="" s AppointDate=$zd(AppointDate,3)
	........i AppointstTime'="" s AppointstTime=$zt(AppointstTime,1)
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
    .......Do OutRow6
  
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow6
	set Data=$lb(depname,BedNo,RegNo,Name,Sex,Age,ItemName,strDate,strTime,$g(Attention),$g(LocAddress),$g(AppointDate),$g(AppointstTime),$g(Complete),$g(Memo),$g(strRegDate),$g(strRegTime),$g(StudyNo),$g(ReportDoc),$g(ReportVerifyDoc),$g(PrintFlag),$g(MedicareNo),$g(oeorditemdr),$g(WardName),$g(PrintDate),$g(PrintTime),$g(Urgency),AttentionURL)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
