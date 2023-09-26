Class DHCDoc.DHCDocConfig.AppendItemInItemCat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetAppendItemInItemCat(ItemSubCat As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCIMRowid:%String,ARCIMDesc:%String,Qty:%String,Loc:%String,LocId:%String,RecLoc:%String,RecLocId:%String,DHCICARowid:%String,DHCIAInstrId:%String,DHCIAInstr:%String,DHCIAARCICDesc:%String,Dose:%String,DoseUomDR:%String,DoseUom:%String,SPECCode:%String,SPECDesc:%String,LimitAdmType:%String")
{
}

ClassMethod GetAppendItemInItemCatExecute(ByRef qHandle As %Binary, ItemSubCat As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.AppendItemInItemCat","GetAppendItemInItemCat","AppendItem")
	Set repid=$I(^CacheTemp)
    Set ind=1 
  
    if (ItemSubCat="" ){
	    for {
		    s ItemSubCat=$o(^DHCItmSubCatAdd(0,"ItemCat",HospId,ItemSubCat))
		    q:(ItemSubCat="")
		    d LoopSubCatAdd
		}
	}else{
		d LoopSubCatAdd
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
LoopSubCatAdd
	s DHCIAARCICDesc=$p(^ARC("IC",ItemSubCat),"^",2)
	s DHCICARowid=0
    f  s DHCICARowid=$o(^DHCItmSubCatAdd(0,"ItemCat",HospId,ItemSubCat,DHCICARowid)) q:DHCICARowid=""  d
    .s ARCIMRowid=$p(^DHCItmSubCatAdd(DHCICARowid),"^",2)
    .//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,HospId)="N"
    .s ARCIMDesc=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
    .s Qty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",3)
    .s LocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",4)
    .s RecLocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",5)
    .s RecLoc="",Loc=""
    .if LocId'="" do
    ..s Loc=$p(^CTLOC(LocId),"^",2)
    .if RecLocId'="" do
    ..s RecLoc=$p(^CTLOC(RecLocId),"^",2)
    .s DHCIAInstrId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",6)
    .s DHCIAInstr=""
    .i DHCIAInstrId'="" s DHCIAInstr=$p($g(^PHCIN(DHCIAInstrId)),"^",2)
    .s DHCIADoseQty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",8)
    .s DHCIADoseUomDR=$p(^DHCItmSubCatAdd(DHCICARowid),"^",9)
    .s DoseUom=""
    .if (DHCIADoseUomDR'="") s DoseUom=$p($g(^CT("UOM",DHCIADoseUomDR)),"^",2)
    .s DHCIASpecCode=$p(^DHCItmSubCatAdd(DHCICARowid),"^",10)
    .s OrderLabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(ARCIMRowid,HospId)
	.for i=1:1:$L(OrderLabSpec,$C(2)) d
    ..s ArrData=$p(OrderLabSpec,$C(2),i)
    ..s SPECCode = $p(ArrData,$C(3),1)
    ..if (DHCIASpecCode=SPECCode) s SPECDesc = $p(ArrData,$C(3),2) Q
	.s LimitAdmType=$p(^DHCItmSubCatAdd(DHCICARowid),"^",11)
	.s LimitAdmType=$replace(LimitAdmType,"O","门诊")
	.s LimitAdmType=$replace(LimitAdmType,"I","住院")
	.s LimitAdmType=$replace(LimitAdmType,"E","急诊")
	.s LimitAdmType=$replace(LimitAdmType,"H","体检")
	.s LimitAdmType=$replace(LimitAdmType,"N","新生儿")
	.Do OutputRowGetAppendItemInItemCat
	quit
OutputRowGetAppendItemInItemCat
	set Data=$lb($g(ARCIMRowid),$g(ARCIMDesc),$g(Qty),Loc,LocId,RecLoc,RecLocId,DHCICARowid,DHCIAInstrId,DHCIAInstr,DHCIAARCICDesc,DHCIADoseQty,DHCIADoseUomDR,$g(DoseUom),DHCIASpecCode,$g(SPECDesc),LimitAdmType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetAppendItemInItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppendItemInItemCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAppendItemInItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppendItemInItemCatExecute ]
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

ClassMethod delete(DHCICARowid) As %String
{
	/*k ^DHCDocConfig(Node,Node1)
	q 0*/
	&sql(delete SQLUSER.DHC_ItmSubCatAdd where DHCICA_Rowid=:DHCICARowid)
	Q SQLCODE
}

ClassMethod FindAppendItem(DHCICARowid As %String, ItemSubCat As %String, ARCIMRowid As %String, LocId As %String, HospId As %String = "")
{
	s id=0,ExistRowId=""
    f  s id=$o(^DHCItmSubCatAdd(0,"ItemCat",HospId,ItemSubCat,id)) q:(id="")||(ExistRowId'="")  d
    .s ItemMastDr=$p(^DHCItmSubCatAdd(id),"^",2)
    .s LocRowid=$p(^DHCItmSubCatAdd(id),"^",4)
    .Quit:(id=DHCICARowid)&&(DHCICARowid'="")
	.if (ARCIMRowid=ItemMastDr)&&(LocRowid=LocId) s ExistRowId=id  
	Q ExistRowId
}

ClassMethod save(DHCICARowid As %String = "", ItemSubCat, ARCIMRowid, Qty, LocId As %String = "", RecLocId As %String = "", DHCIAInstrId As %String = "", ExpStr As %String = "", HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s arcimcode=""
	&sql(select ARCIM_Code into :arcimcode from SQLUSER.arc_itmmast where ARCIM_RowId=:ARCIMRowid)
	Q:arcimcode="" "-2"
	s findRepeat=..FindAppendItem(DHCICARowid,ItemSubCat,ARCIMRowid,LocId,HospId)
	Q:findRepeat'="" "-1"
	s Dose=$p(ExpStr,"^",1)
	s DoseUomDR=$p(ExpStr,"^",2)
	s SPECCode=$p(ExpStr,"^",3)
	s LimitAdmType=$p(ExpStr,"^",4)
	s LimitAdmType=$replace(LimitAdmType,"门诊","O")
	s LimitAdmType=$replace(LimitAdmType,"住院","I")
	s LimitAdmType=$replace(LimitAdmType,"急诊","E")
	s LimitAdmType=$replace(LimitAdmType,"体检","H")
	s LimitAdmType=$replace(LimitAdmType,"新生儿","N")
	if (DHCICARowid=""){
		&sql(insert into SQLUSER.DHC_ItmSubCatAdd 
			(DHCICA_ItemCat_DR,DHCICA_AddItm_DR,DHCICA_Qty,DHCICA_Loc_DR,DHCICA_RecLoc_DR,
			DHCICA_Instr_DR,DHCICA_Hosp_DR,DHCICA_DoseQty,DHCICA_DoseUom_DR,DHCICA_SpecCode,
			DHCICA_LimitAdmType)values 
			(:ItemSubCat,:ARCIMRowid,:Qty,:LocId,:RecLocId,
			:DHCIAInstrId,:HospId,:Dose,:DoseUomDR,:SPECCode,
			:LimitAdmType))
	}else{
		&sql(update SQLUSER.DHC_ItmSubCatAdd 
		set DHCICA_AddItm_DR=:ARCIMRowid,DHCICA_Qty=:Qty,DHCICA_Loc_DR=:LocId,DHCICA_RecLoc_DR=:RecLocId, DHCICA_Instr_DR=:DHCIAInstrId,
		DHCICA_DoseQty=:Dose,DHCICA_DoseUom_DR=:DoseUomDR,DHCICA_SpecCode=:SPECCode,DHCICA_LimitAdmType=:LimitAdmType
		where DHCICA_Rowid=:DHCICARowid )
	}
	Q SQLCODE
}

/// @附加医嘱设定(按子类),绑定医嘱指定了科室，则按照指定科室医嘱产生，未指定的则按未指定科室产生绑定医嘱
/// @ArcimId 医嘱项ID UserLoc开单科室ID
/// return 绑定医嘱串
/// w ##class(DHCDoc.DHCDocConfig.AppendItemInItemCat).GetCatItmAddItem("1811||1","")
ClassMethod GetCatItmAddItem(ARCIMItemCatDR As %String, UserLoc As %String, OrderOpenForAllHosp As %String = "", HospId As %String = "", EpisodeID = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s UserLocAppendItemStr="",AllLocAppendItemStr=""
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s DHCICARowid=0
    f  s DHCICARowid=$o(^DHCItmSubCatAdd(0,"ItemCat",HospId,ARCIMItemCatDR,DHCICARowid)) q:DHCICARowid=""  d
    .s DHCIAAddItmDR=$p(^DHCItmSubCatAdd(DHCICARowid),"^",2)
    .//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",DHCIAAddItmDR,HospId)="N"
    .s DHCIAQty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",3)
    .s DHCIALocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",4)
    .s DHCIARecLocId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",5)
    .s DHCIAInstrId=$p(^DHCItmSubCatAdd(DHCICARowid),"^",6)
    .s DHCICADoseQty=$p(^DHCItmSubCatAdd(DHCICARowid),"^",8)
    .s DHCICADoseUomDR=$p(^DHCItmSubCatAdd(DHCICARowid),"^",9)
    .s DHCICASpecCode=$p(^DHCItmSubCatAdd(DHCICARowid),"^",10)
	.s LimitAdmType=$p(^DHCItmSubCatAdd(DHCICARowid),"^",11)
	.q:(AdmType'="")&&(LimitAdmType'="")&&(LimitAdmType[AdmType)
    .s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId_$C(1)_DHCIAInstrId_$C(1)_OrderOpenForAllHosp_$C(1)_""_$C(1)_DHCICADoseQty_$C(1)_DHCICADoseUomDR_$C(1)_DHCICASpecCode_$C(1)_"IC" //_$C(1)_index
    .if (DHCIALocId=UserLoc) d
    ..i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
    ..e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
    .else  if (DHCIALocId="") d
    ..i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
    ..e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
	  /*s DHCIAAddItmDR=0
		For {
			s DHCIAAddItmDR=$o(^DHCDocConfig("AppendItem",DHCIAAddItmDR)) q:DHCIAAddItmDR=""
			s DHCIAQty=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",1)
			s DHCIALocId=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",2)
			s DHCIARecLocId=$p($g(^DHCDocConfig("AppendItem",DHCIAAddItmDR)),"^",3)
			i (+DHCIAQty=0) s DHCIAQty=1
			s oneInfo=DHCIAAddItmDR_$C(1)_DHCIAQty_$C(1)_DHCIARecLocId_$C(1)_index
			if (DHCIALocId=UserLoc){
				i UserLocAppendItemStr="" s UserLocAppendItemStr=oneInfo
				e  s UserLocAppendItemStr=UserLocAppendItemStr_"^"_oneInfo
			}else{
				if (DHCIALocId=""){
					i AllLocAppendItemStr="" s AllLocAppendItemStr=oneInfo
					e  s AllLocAppendItemStr=AllLocAppendItemStr_"^"_oneInfo
				}
			}
		}*/
		Q:UserLocAppendItemStr'="" UserLocAppendItemStr
	    Q AllLocAppendItemStr
}

}
