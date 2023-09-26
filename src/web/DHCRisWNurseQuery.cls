Import SQLUser

Class web.DHCRisWNurseQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 21;

// 登记日期，登记时间，病人状态

// d ##class(%ResultSet).RunQuery("web.DHCRisWNurseQuery","QueryItemByWard","4","62628","62628") 

Query QueryItemByWard(ward As %String, startdate As %String, enddate As %String, InRegNo As %String, RisStatusCode As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime:%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String,TRisStatusDesc:%String")
{
}

ClassMethod QueryItemByWardExecute(ByRef qHandle As %Binary, ward As %String, startdate As %String, enddate As %String, InRegNo As %String, RisStatusCode As %String) As %Status
{
    s ^t00=ward_"^"_startdate_"^"_enddate
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ward="" Set qHandle=$lb(0,repid,0)
    q:ward="" $$$OK
    
    s room=0 f  s room=$o(^PAROOM(room)) q:room=""  d  ;pac_room
    .s papmidr=0 f  s papmidr=$o(^PAADMi("CurrWard",ward,room,papmidr)) q:papmidr=""  d 
    ..q:$p(^PAADM(papmidr),"^",20)'="A"                       
  	..s oeordrowid=0 f  s oeordrowid=$o(^OEORD(0,"Adm",papmidr,oeordrowid)) q:oeordrowid=""  d  
    ...s oeorisub=0  f  s oeorisub=$o(^OEORD(oeordrowid,"I",oeorisub)) q:oeorisub=""  d
    ....s oeoridate=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",7) ;OEORI_Date oe_orditem
    ....s strDate=$zd(oeoridate,3)
    ....s oeoritimeord=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",17)  ;OEORI_TimeOrd oe_orditem
    ....s strTime=$zt(oeoritimeord,3)
    ....i (oeoridate'>enddate)&(oeoridate'<startdate) d
    .....s ItemStatDR=$p(^OEORD(oeordrowid,"I",oeorisub,1),"^",13) ; 医嘱状态
    .....q:ItemStatDR=""
	.....s ItemStatusCode=$p($g(^OEC("OSTAT",ItemStatDR)),"^",1)
	.....i (ItemStatusCode="V")!(ItemStatusCode="E") d
    ......s papmino=$p($g(^PAADM(papmidr)),"^",1) 
    ......s regno=$p($g(^PAPER(papmino,"PAT",1)),"^",1) ; 
    ......q:(InRegNo'="")&(InRegNo'=regno)
    ......s name=$p($g(^PAPER(papmino,"ALL")),"^",1) ;PAPMI_Name PA_Patmas
    ......s sex="未知"
 	......s papmisexdr=$p($g(^PAPER(papmino,"ALL")),"^",7) ;PAPMI_Sex_DR PA_patmas
    ......i papmisexdr'="" s sex=$p($g(^CT("SEX",papmisexdr)),"^",2) ;CTSEX_Desc CT_Sex
    ......s bedno=""
    ......s beddr=$p($g(^PAADM(papmidr)),"^",73) ;PAADM_CurrentBed_DR PA_Adm
    ......i $g(beddr)'="" s bedno=$p($g(^PAWARD($p(beddr,"||",1),"BED",$p(beddr,"||",2))),"^",1)  ;BED_Code PAC_Bed
    ......;s warddr=$p($g(^PAADM(papmidr)),"^",70) ;PAADM_CurrentWard_DR PA_Adm
    ......;i warddr'="" s warddesc=$p($g(^PAWARD(warddr)),"^",2)  ;WARD_Desc
    ......;s admdr=$p($g(^OEORD(oeordrowid)),"^",1) ;OEORD_Adm_DR oe_order
    ......s itmmastdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,1)),"^",2) ;OEORI_ItmMast_DR  oe_orditem   
    ......s itemname=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",2) ;ARCIM_Desc ARC_ItmMast
    ......s recdepdr=$p($g(^OEORD(oeordrowid,"I",oeorisub,3)),"^",6) ; OEORI_RecDep_DR oe_orditem
    ......s depname=$p($g(^CTLOC(recdepdr)),"^",2) ;CTLOC_Desc CT_Loc
    ......s itemcatdr=$p($g(^ARCIM($p(itmmastdr,"||",1),$p(itmmastdr,"||",2),1)),"^",10)  ;ARCIM_ItemCat_DR ARC_ItmMast
 	......s arcicordcat=$p($g(^ARC("IC",itemcatdr)),"^",8)  ;ARCIC_OrdCat_DR ARC_ItemCat
    ......s orcatcode=$p($g(^OEC("ORCAT",arcicordcat)),"^",1)  ;ORCAT_Code OEC_OrderCategory 
    ......;q:orcatcode'="17"   ;  医嘱不是检查大类则退出
    ......s AppointDate1="", StudyNo="",AppointstTime="",AppointDate="",strRegDate="",strRegTime="",Index="",EQDesc="",ResDesc=""
	......s PatientStatus="医嘱核实"
	......s PatientStatusCode="V",RisPatStatusCode="A",RisStatusDesc=""
	......s approwid=""
	......s approwid=$p($g(^OEORD(oeordrowid,"I",oeorisub,6)),"^",5)
	......i (approwid'="")&(approwid'=$c(0)) d 
	.......s resrowid=$p(approwid,"||",1)
	.......s Schrowid=$p(approwid,"||",2)
	.......s scheInfo=^RBAS(resrowid,Schrowid)
	.......s AppointDate1=$p(scheInfo,"^",1)
	.......s AppointDate=$zd(AppointDate1,3)
	.......s AppointstTime=$p(scheInfo,"^",4) 
	.......s AppointstTime=$zt(AppointstTime,1)
	.......s CTCPDR=$p(^RB("RES",resrowid),"^",2)
	.......i CTCPDR'="" d
	........s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
	........i $g(^DHCRisGetNameSet)="ID" s ResDesc=$p(^CTPCP(CTCPDR,1),"^",3)
	.......else  d
	........s EQDR=$p(^RB("RES",resrowid),"^",3)
	........s ResDesc=$p(^RBC("EQ",EQDR),"^",2)
	.......s PatientStatus="预约"
	.......s PatientStatusCode="S",RisPatStatusCode="B"
	......s Info=""
	......s Info=$g(^DHCRISBOOKEDINFO(oeoritimeord))
	......i Info'="" d
	.......s ResDesc=$P($g(Info),"^",1)
	.......s AppointDate=$P($g(Info),"^",2)
	.......s AppointstTime=$P($g(Info),"^",3)
	.......s PatientStatus="预约"
	.......s PatientStatusCode="S",RisPatStatusCode="B"
	......s ReportDoc="",ReportVerifyDoc=""
    ......i ItemStatusCode="E"  d  ; 医嘱执行
	.......s PatientStatus="执行" 
	.......s PatientStatusCode="E",RisPatStatusCode="I"
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
	.........s PatientStatusCode="R",RisPatStatusCode="E"
	.........s CPReportDocDr=$p(^OEORD(oeordrowid,"I",oeorisub,"RES",resrowid),"^",35)
	.........i CPReportDocDr'="" d
	..........i $g(^CTPCP(CPReportDocDr,1))'="" d 
	...........i ^DHCRisGetNameSet="ID" d 
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",3)   
	...........else  d
	............s ReportDoc=$p(^CTPCP(CPReportDocDr,1),"^",2)    
	........i ResStatDR="3" d
	.........s PatientStatus="审核"
	.........s PatientStatusCode="A",RisPatStatusCode="O"
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
	......s RisStatusDesc=##class(web.DHCRisCommFunction).GetPatientStatusDesc(RisPatStatusCode)
	......q:(RisStatusCode'="")&(RisStatusCode'=RisPatStatusCode)
    ......Do OutRow
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow
	set Data=$lb(regno,name,sex,bedno,itemname,strDate,strTime,depname,PatientStatus,$g(AppointDate),$g(AppointstTime),$g(ResDesc),$g(strRegDate),$g(strRegTime),$g(StudyNo),$g(ReportDoc),$g(ReportVerifyDoc),$g(RisStatusDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryItemByWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryItemByWardExecute ]
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

ClassMethod QueryItemByWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryItemByWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryWard(ward As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Tregno:%String,Tname:%String,Tsex:%String,Tbedno:%String,Titemname:%String,TstrDate:%String,TstrTime:%String,Tdepname:%String,TPatientStatus:%String,TAppointDate:%String,TAppointstTime:%String,TResDesc:%String,TstrRegDate:%String,TstrRegTime%String,TStudyNo:%String,TReportDoc:%String,TReportVerifyDoc:%String")
{
}

ClassMethod QueryWardExecute(ByRef qHandle As %Binary, ward As %String, startdate As %String, enddate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    
    s rowid=0 f  s rowid=$o(^PAWARD(rowid)) q:rowid=""  d
    .s desc=$p(^PAWARD(rowid),"^",2)
     .Do OutRow1
    Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutRow1
	set Data=$lb(desc,rowid)
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

ClassMethod GetWardByLoc(LocDr) As %String
{
	s warrowid=0
	s warrowid=$o(^PAWARD(0,"WARD_LocationDR",LocDr,warrowid)) 
	s desc=$p($g(^PAWARD(warrowid)),"^",2)
	q desc_"^"_warrowid
}

/// 获取RIS3.0检查状态
/// do ##class(web.DHCRisWNurseQuery).GetRisStatusList()
ClassMethod GetRisStatusList() As %String
{
	s rset=##class(%ResultSet).%New("web.DHCRisCommFunction:QuerySystemPatientStatus")
	s ret=""
	do rset.Execute()
	while (rset.Next())
	{
		i ret="" s ret=rset.GetData(2)_$C(1)_rset.GetData(3)
	    e  s ret=ret_"^"_rset.GetData(2)_$C(1)_rset.GetData(3)
	}	
	d rset.Close()
	q ret
}

}
