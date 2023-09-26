/// Lid
/// 2012-03-13
/// 菜订单统计
Class DHCBILL.Diet.DHCIPMealBillItmDetail Extends web.DHCOPPrintCommIF [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindBillItmDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBillItmDetailExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:Lid
/// CreateDate:2012-03-13
/// Desc:查询一段时间内符合条件的菜订单
/// Input     :
/// OutPut    :
/// Dubug:d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealBillItmDetail","FindBillItmDetail","2012-03-12","2012-03-13","","","2877","")
ClassMethod FindBillItmDetailOLDExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AdmDR As %String, Modality As %String, ItmDR As %String, WardDR As %String, PrtUser As %String = "") As %Status
{
	s ^TMP("Lid")=StartDate_"^"_EndDate_"^"_AdmDR _"^"_Modality_"^"_ItmDR_"^"_WardDR
    Set repid=$I(^CacheTemp)
    s ind=1,Job=$j
 	s:StartDate["-" StartDate=$zdh(StartDate,3)
 	s:EndDate["-" EndDate=$zdh(EndDate,3)
 	s:StartDate="" StartDate=+$h
 	s:EndDate="" EndDate=+$h
    i ItmDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;
    k ItmDetailAry("DHCBILL",Job)
    ;
  	f Update=StartDate:1:EndDate  d
  	.s MBRowID=""
  	.f  s MBRowID=$o(^DHCIPMEALBILL(0,"UpdateDate",Update,MBRowID)) q:MBRowID=""  d
  	..s s=$g(^DHCIPMEALBILL(MBRowID))
  	..s Adm=$p(s,"^",1)
  	..q:((AdmDR'="")&(+AdmDR'=+Adm))
  	..s PatType=$p(^PAADM(Adm),"^",2)
	..q:PatType'="I" ;只查询住院病人
	..s VisitStatus=$p(^PAADM(Adm),"^",20)
	..;q:VisitStatus'="A" ;
	..s PatWardDR=$p(^PAADM(Adm),"^",70)
	..q:((WardDR'="")&(WardDR'=PatWardDR))
	..s CurrentBedDR=$p(^PAADM(Adm),"^",73)
	..s CurrentBed=""
	..s:CurrentBedDR'="" CurrentBed=$p(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2)),"^",1)
	..s PatDepartmentDR=$p(^PAADM(Adm),"^",4)
  	..s MBDSub="0"
  	..f  s MBDSub=$o(^DHCIPMEALBILL(MBRowID,"D",MBDSub)) q:MBDSub=""  d
  	...s ss=$g(^DHCIPMEALBILL(MBRowID,"D",MBDSub))
  	...s Price=+$p(ss,"^",2)
  	...s Qty=+$p(ss,"^",3)
  	...s TotalAmt=+$p(ss,"^",4)
  	...s MODR=$p(ss,"^",1)
  	...s Itm=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",1)
  	...q:(+ItmDR'=+Itm)
  	...s MealTypeDR=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",21)
  	...s MealModalityDR=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",22)
  	...q:((Modality'="")&(+Modality'=+MealModalityDR))
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",1)=+Price
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",2)=+$p($g(ItmDetailAry("DHCBILL",Job,Adm,Itm)),"^",2)+Qty
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",3)=+$p($g(ItmDetailAry("DHCBILL",Job,Adm,Itm)),"^",3)+TotalAmt
  	;
  	s Adm=""
  	f  s Adm=$o(ItmDetailAry("DHCBILL",Job,Adm)) q:Adm=""  d
  	.s s=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(Adm,"","")
	.s PatInfo=$p(s,"#",1)
	.s AdmInfo=$p(s,"#",2)
	.s PatName=$p(PatInfo,"^",2)
	.s PatNO=$p(PatInfo,"^",1)
	.s PatWard=$p(AdmInfo,"^",5)
	.s CurrentBed=$p(AdmInfo,"^",6)
	.s Itm=""
  	.f  s Itm=$o(ItmDetailAry("DHCBILL",Job,Adm,Itm)) q:Itm=""  d
  	..s tmp=$g(ItmDetailAry("DHCBILL",Job,Adm,Itm))
  	..s ItmDesc=$p(^DHCIPMEALITEM(Itm),"^",2)
  	..s Price=$p(tmp,"^",1)
  	..s Qty=$p(tmp,"^",2)
  	..s TotalAmt=$p(tmp,"^",3)
  	..d OutputRow1
  	k ItmDetailAry("DHCBILL",Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
    
	set Data=$lb(PatNO,PatName,PatWard,CurrentBed,ItmDesc,Price,Qty,TotalAmt,Job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Creator:Lid
/// CreateDate:2012-03-13
/// Desc:查询一段时间内符合条件的菜订单
/// Input     :
/// OutPut    :
/// Dubug:d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealBillItmDetail","FindBillItmDetail","2012-03-12","2012-03-13","","","2877","")
ClassMethod FindBillItmDetailExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, AdmDR As %String, Modality As %String, ItmDR As %String, WardDR As %String, PrtUser As %String = "") As %Status
{
	s ^TMP("Lid")=StartDate_"^"_EndDate_"^"_AdmDR _"^"_Modality_"^"_ItmDR_"^"_WardDR
    Set repid=$I(^CacheTemp)
    s ind=1,Job=$j
 	s:StartDate["-" StartDate=$zdh(StartDate,3)
 	s:EndDate["-" EndDate=$zdh(EndDate,3)
 	s:StartDate="" StartDate=+$h
 	s:EndDate="" EndDate=+$h
    i ItmDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;
    k ItmDetailAry("DHCBILL",Job)
    ;
  	f Update=StartDate:1:EndDate  d
  	.s MBRowID=""
  	.f  s MBRowID=$o(^DHCIPMEALBILL(0,"BillDate",Update,MBRowID)) q:MBRowID=""  d
  	..s s=$g(^DHCIPMEALBILL(MBRowID))
  	..s Adm=$p(s,"^",1)
  	..q:((AdmDR'="")&(+AdmDR'=+Adm))
  	..s PatType=$p(^PAADM(Adm),"^",2)
	..q:PatType'="I" ;只查询住院病人
	..s VisitStatus=$p(^PAADM(Adm),"^",20)
	..;q:VisitStatus'="A" ;
	..s PatWardDR=$p(^PAADM(Adm),"^",70)
	..q:((WardDR'="")&(WardDR'=PatWardDR))
	..s CurrentBedDR=$p(^PAADM(Adm),"^",73)
	..s CurrentBed=""
	..s:CurrentBedDR'="" CurrentBed=$p(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2)),"^",1)
	..s PatDepartmentDR=$p(^PAADM(Adm),"^",4)
  	..s MBDSub="0"
  	..f  s MBDSub=$o(^DHCIPMEALBILL(0,"BillDate",Update,MBRowID,MBDSub)) q:MBDSub=""  d
  	...s ss=$g(^DHCIPMEALBILL(MBRowID,"D",MBDSub))
  	...s Price=+$p(ss,"^",2)
  	...s Qty=+$p(ss,"^",3)
  	...s TotalAmt=+$p(ss,"^",4)
  	...s MODR=$p(ss,"^",1)
  	...s Itm=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",1)
  	...q:(+ItmDR'=+Itm)
  	...s MealTypeDR=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",21)
  	...s MealModalityDR=$p(^DHCIPMEALORDER(+MODR,"I",$p(MODR,"||",2)),"^",22)
  	...q:((Modality'="")&(+Modality'=+MealModalityDR))
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",1)=+Price
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",2)=+$p($g(ItmDetailAry("DHCBILL",Job,Adm,Itm)),"^",2)+Qty
  	...s $p(ItmDetailAry("DHCBILL",Job,Adm,Itm),"^",3)=+$p($g(ItmDetailAry("DHCBILL",Job,Adm,Itm)),"^",3)+TotalAmt
  	;
  	s Adm=""
  	f  s Adm=$o(ItmDetailAry("DHCBILL",Job,Adm)) q:Adm=""  d
  	.s s=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(Adm,"","")
	.s PatInfo=$p(s,"#",1)
	.s AdmInfo=$p(s,"#",2)
	.s PatName=$p(PatInfo,"^",2)
	.s PatNO=$p(PatInfo,"^",1)
	.s PatWard=$p(AdmInfo,"^",5)
	.s CurrentBed=$p(AdmInfo,"^",6)
	.s Itm=""
  	.f  s Itm=$o(ItmDetailAry("DHCBILL",Job,Adm,Itm)) q:Itm=""  d
  	..s tmp=$g(ItmDetailAry("DHCBILL",Job,Adm,Itm))
  	..s ItmDesc=$p(^DHCIPMEALITEM(Itm),"^",2)
  	..s Price=$p(tmp,"^",1)
  	..s Qty=$p(tmp,"^",2)
  	..s TotalAmt=$p(tmp,"^",3)
  	..d OutputRow2
  	k ItmDetailAry("DHCBILL",Job)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    
	set Data=$lb(PatNO,PatName,PatWard,CurrentBed,ItmDesc,Price,Qty,TotalAmt,Job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBillItmDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBillItmDetailExecute ]
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
	Quit $$$OK
}

Query FindBillItmDetail(StartDate As %String, EndDate As %String, AdmDR As %String, Modality As %String, ItmDR As %String, WardDR As %String, PrtUser As %String = "") As %Query(ROWSPEC = "PatNO,PatName,PatWard,CurrentBed,ItmDesc,Price,Qty,TotalAmt,Job")
{
}

}
