Class DHCBILL.Diet.DHCIPMealSendOutDiet Extends web.DHCOPPrintCommIF [ ClassType = "", Not ProcedureBlock ]
{

/// Lid
/// 2012-03-08
/// 查询膳食医嘱
/// w ##class(DHCBILL.Diet.DHCIPMealSendOutDiet).GetDietOrder("1111","2012-03-09","2012-03-09","","","","")
ClassMethod GetDietOrder(Job As %String, StartDate As %String, EndDate As %String, ArcItmCatDR As %String, MealType As %String, GroupDR As %String = "", HospitalDR As %String, WardDR As %String)
{
	n (Job,StartDate,EndDate,ArcItmCatDR,MealType,GroupDR,HospitalDR,WardDR)
	i $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	i StartDate="" s StartDate=+$h
	i $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	i EndDate="" s EndDate=+$h
	k ^TMP("DHCBILL","DietOrder",Job)
	k ^TMP("DHCBILL","DietOrderHeader",Job)
	b ;
	f ordSttDate=StartDate:1:EndDate  d
	.s oeordId="" f  s oeordId=$o(^OEORDi(0,"StDt",ordSttDate,oeordId)) q:oeordId=""  d
	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"StDt",ordSttDate,oeordId,oeoriSub)) q:oeoriSub=""  d
	...s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2)
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)	//oeori_itmmast_dr->arcim_itemcat_dr->ARc_Itemcat				
	...s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
	...s OrdCatCode=$p(^OEC("ORCAT",OrdCatDR),"^",1)
	...q:(OrdCatCode'="06")
	...s ARCIMDesc=$p($g(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	...q:((MealType'="")&(ARCIMDesc'[MealType))
	...q:((ArcItmCatDR'="")&(ArcItmCatDR'=ItemCatDR))
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	...q:(ordStatCode'="V")
	...s Adm=$p(^OEORD(oeordId),"^",1)
	...s PatType=$p(^PAADM(Adm),"^",2)
	...q:PatType'="I" ;只查询住院病人
	...s VisitStatus=$p(^PAADM(Adm),"^",20)
	...;q:VisitStatus'="A" ;
	...s PatWardDR=$p(^PAADM(Adm),"^",70)
	...q:(+PatWardDR=1329)!(+PatWardDR=203) ;过滤测试病区
	...q:((WardDR'="")&(WardDR'=PatWardDR))
	...s PatDepartmentDR=$p(^PAADM(Adm),"^",4)
	...//s CurHospitalDR=$P($G(^CTLOC(PatDepartmentDR)),"^",4)
	...//q:CurHospitalDR'=HospitalDr
	...s ^TMP("DHCBILL","DietOrderHeader",Job,PatWardDR)=""
	...s ^TMP("DHCBILL","DietOrder",Job,ArcimDR,PatWardDR)=+$g(^TMP("DHCBILL","DietOrder",Job,ArcimDR,PatWardDR))+1 	;膳食医嘱的数量一定为1
	q 0
}

ClassMethod QueryPatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPatDataExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询病人信息
ClassMethod QueryPatDataExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, ArcItmCatDR As %String, MealType As %String, GroupDR As %String = "", HospitalDR As %String, WardDR As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealSendOutDiet","QueryPatData","2012-03-10","2012-03-10","","","","","")
    Set repid=$I(^CacheTemp)
    s ind=1
  	i $l(StartDate,"-")=3 s StartDate=$zdh(StartDate,3)
	i StartDate="" s StartDate=+$h
	i $l(EndDate,"-")=3 s EndDate=$zdh(EndDate,3)
	i EndDate="" s EndDate=+$h
	s Job=$j
	k ^TMP("DHCBILL","LabelPrintData",Job)
	k AdmAry(Job)
	f ordSttDate=StartDate:1:EndDate  d
	.s oeordId="" f  s oeordId=$o(^OEORDi(0,"StDt",ordSttDate,oeordId)) q:oeordId=""  d
	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"StDt",ordSttDate,oeordId,oeoriSub)) q:oeoriSub=""  d
	...s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2)
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10)	//oeori_itmmast_dr->arcim_itemcat_dr->ARc_Itemcat				
	...s OrdCatDR=$p(^ARC("IC",ItemCatDR),"^",8)
	...s OrdCatCode=$p(^OEC("ORCAT",OrdCatDR),"^",1)
	...q:(OrdCatCode'="06")
	...s ARCIMDesc=$p($g(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	...q:((MealType'="")&(ARCIMDesc'[MealType))
	...q:((ArcItmCatDR'="")&(ArcItmCatDR'=ItemCatDR))
	...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	...q:(ordStatCode'="V")
	...s Adm=$p(^OEORD(oeordId),"^",1)
	...s PatType=$p(^PAADM(Adm),"^",2)
	...q:PatType'="I" ;只查询住院病人
	...s VisitStatus=$p(^PAADM(Adm),"^",20)
	...;q:VisitStatus'="A" ;
	...s PatWardDR=$p(^PAADM(Adm),"^",70)
	...q:((WardDR'="")&(WardDR'=PatWardDR))
	...s CurrentBedDR=$p(^PAADM(Adm),"^",73)
	...s CurrentBed=""
	...s:CurrentBedDR'="" CurrentBed=$p(^PAWARD(+CurrentBedDR,"BED",$p(CurrentBedDR,"||",2)),"^",1)
	...s PatDepartmentDR=$p(^PAADM(Adm),"^",4)
	...s AdmAry(Job,Adm)=$g(AdmAry(Job,Adm))_" "_ARCIMDesc
	;
	s Adm=""
	f  s Adm=$o(AdmAry(Job,Adm)) q:Adm=""  d
	.s s=##class(web.UDHCJFBaseCommon).GetPatAdmInfo(Adm,"","")
	.s PatInfo=$p(s,"#",1)
	.s AdmInfo=$p(s,"#",2)
	.s PatName=$p(PatInfo,"^",2)
	.s PatNO=$p(PatInfo,"^",1)
	.s PatWard=$p(AdmInfo,"^",5)
	.s OrdItmDesc=AdmAry(Job,Adm)
	.s CurrentBed=$p(AdmInfo,"^",6)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set ^TMP("DHCBILL","LabelPrintData",Job,Adm)=PatName_"^"_PatNO_"^"_PatWard_"^"_OrdItmDesc_"^"_CurrentBed
	set Data=$lb(Adm,PatName,PatNO,PatWard,OrdItmDesc,Job,CurrentBed)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryPatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPatDataExecute ]
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

Query QueryPatData(StartDate As %String, EndDate As %String, ArcItmCatDR As %String, MealType As %String, GroupDR As %String = "", HospitalDR As %String, WardDR As %String) As %Query(ROWSPEC = "Adm:%String,PatName:%String,PatNO:%String,PatWard:%String,OrdItmDesc:%String,Job:%String,CurrentBed:%String")
{
}

ClassMethod PrintLabelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PrintLabelExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查询病人信息
ClassMethod PrintLabelExecute(ByRef qHandle As %Binary, Job As %String = "", AdmStr As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealSendOutDiet","PrintLabel","5396","111999^112179")
    Set repid=$I(^CacheTemp)
    s ind=1
	;
	s Adm=""
	f  s Adm=$o(^TMP("DHCBILL","LabelPrintData",Job,Adm)) q:Adm=""  d
	.q:("^"_AdmStr_"^")'[("^"_Adm_"^")
	.s s=$g(^TMP("DHCBILL","LabelPrintData",Job,Adm))
	.s PatName=$p(s,"^",1)
	.s PatNO=$p(s,"^",2)
	.s PatWard=$p(s,"^",3)
	.s OrdItmDesc=$p(s,"^",4)
	.s PatBed=$p(s,"^",5)
	.d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Adm,PatName,PatNO,PatWard,OrdItmDesc,PatBed)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PrintLabelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PrintLabelExecute ]
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

Query PrintLabel(Job As %String = "", AdmStr As %String) As %Query(ROWSPEC = "Adm:%String,PatName:%String,PatNO:%String,PatWard:%String,OrdItmDesc:%String,PatBed:%String") [ SqlProc ]
{
}

/// Lid
/// 2012-03-08
/// 医嘱子分类
ClassMethod ToArcItmCatJson()
{
	;w ##class(DHCBILL.Diet.DHCIPMealSendOutDiet).ToArcItmCatJson()
	s mealTypeJson="{rows:["
	s OrdCatDR=25 	;医嘱大类指针,25是"饮食"
	s rowid=0
	f  s rowid=$o(^ARC("IC",0,"OrdCat",OrdCatDR,rowid)) q:rowid=""  d
	.s desc=$p(^ARC("IC",rowid),"^",2)
	.i mealTypeJson="{rows:[" d
	..s mealTypeJson=mealTypeJson_"{arcItmCatRowID:"_rowid_",arcItmCatDesc:'"_desc_"'}"
	.e  d
	..s mealTypeJson=mealTypeJson_",{arcItmCatRowID:"_rowid_",arcItmCatDesc:'"_desc_"'}"
	q mealTypeJson_"]}"
}

}
