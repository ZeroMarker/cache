Class web.UDHCOrderItemLabPrint Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetOrderItems(EpisodeID As %String, IsPhamacy As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "Rowid:%String,OrderName:%String,StartDate:%String,Priority:%String,Status:%String,PackQty:%String,PackUOM:%String,Price:%String,Sum:%String,RecDep:%String,Billed:%String,BillType:%String,OrderType:%String,Spec:%String,UserAddName:%String,LabEpisodeNo:%String,orcat:%String,orcatdesc:%String,RecDepAdress:%String,DepProcNotes:%String,StatusCode:%String,ExecuteTime:%String,Spec1:%String,ProcessingNotes:%String,BillTypeDesc:%String,LabOrdPlacerNo:%String,Container:%String,OrderNotifyClinician:%String")
{
}

ClassMethod GetOrderItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetOrderItemsExecute(ByRef qHandle As %Binary, EpisodeID As %String, IsPhamacy As %String) As %Status
{
 // d ##class(%ResultSet).RunQuery("web.UDHCOrderItemLabPrint","GetOrderItems","935","")
 s HospId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
 s HospitalCode=$p($g(^CT("HOSP",HospId)),"^",1)
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s PatType="", InsType="", PriorRowid="", InstrRowid="", LinkTo="", OEPrice="",LabEpisodeNo="",Spec1=""
 set RowCount=0
 s OrderType="L"
 s IsPhamacy=0
 ;if IsPhamDepProcNotesacy='1' s OrderType='R'
 i EpisodeID'="" d
 .s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
 .&sql(DECLARE EmpCursor CURSOR FOR
 SELECT OEORI_Rowid,OEORI_ItmMast_DR,OEORI_ItmMast_DR->ARCIM_Desc,OEORI_SttDat,
	    OEORI_Priority_dr->OECPR_Desc,OEORI_Itemstat_dr->OSTAT_Desc,OEORI_Itemstat_dr->OSTAT_Code,
	    OEORI_QtyPackUOM,
	    OEORI_RecDep_DR->CTLOC_Desc,$LIST(OEORI_RecDep_DR->ctloc_address,1),OEORI_Billed,OEORI_ItmMast_DR,OEORI_SttDat,
	    OEORI_BBExtCode,OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType,
	    OEORI_UserAdd->SSUSR_Name,OEORI_LabEpisodeNo,OEORI_DepProcNotes,OEORI_ItmMast_DR->ARCIM_ProcessingNotes 
 INTO :Rowid,:ArcimRowid,:OrderName,:StartDate,:Priority,:Status,:StatusCode,:PackQty,:RecDep,:RecDepAdress,:Billed,:ARCIMRowid,:SttDate,:BillType,:OrderType,:UserAddName,:LabEpisodeNo,:DepProcNotes,:ProcessingNotes
 From SQLUser.OE_OrdItem 
 WHERE OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and (OEORI_ItemStat_DR->OSTAT_Code='V' or OEORI_ItemStat_DR->OSTAT_Code='E')
	 and ((OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='R' and :IsPhamacy=1) or (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType<>'R' and :IsPhamacy<>1))
 Order By OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR desc)
 .&sql(OPEN EmpCursor)
 .for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
    ..s SttDate=..%ZD(SttDate)
	..s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	..s orcat=$p($g(^ARC("IC",+subcat)),"^",8)
	..s OrdSubDesc=$p($g(^ARC("IC",+subcat)),"^",2)
	..s orcatdesc=""
	..//Q:((orcat'=25)&(orcat'=26)&(orcat'=27)&(orcat'=28)&(orcat'=29)&(orcat'=30)&(orcat'=31)&(orcat'=32)&(orcat'=24)&(orcat'=41)&(HospitalCode="HF"))
	..Q:(OrderType'="L") //&((HospitalCode="YKYZLYY")||(HospitalCode="BJZYY")||(HospitalCode="ZGYDYY"))
	..;s RecDepAdress=$List($g(RecDepAdress))   ;lgl
	..//i DepProcNotes'="" s DepProcNotes=$List($G(DepProcNotes))
	..i orcat'="" s orcatdesc=$p($g(^OEC("ORCAT",orcat)),"^",2)
	..q:(orcatdesc="消耗材料")
	..q:((orcatdesc="消耗材料")||(orcatdesc="其他")||(orcatdesc="申请"))&&(HospitalCode="YKYZLYY")
	..s RecDepDesc=$p(RecDep,"-",2)
	..i RecDepDesc'="" s RecDep=RecDepDesc
	..s OrderRecDepRowid=$P($G(^OEORD(+Rowid,"I",$p(Rowid,"||",2),3)),"^",6)
	..s ExpStr=Rowid_"^"_""_"^"_EpisodeID_"^"_OrderRecDepRowid
	..
	..s ARCIMBillingUOM=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(Rowid)
	..s PackUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCIMBillingUOM)
	..
	..s retPrice=##class(web.DHCDocOrderCommon).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice,OrderRecDepRowid,PAADMRegConDisDR,ARCIMBillingUOM,ExpStr)
	..s Price=$P(retPrice,"^",1)
	..s DiscPrice=$P(retPrice,"^",2)
	..s InsPrice=$P(retPrice,"^",3)
	..s PatPrice=$P(retPrice,"^",4)
	..//s ^yjy(222)= EpisodeID _"^"_IsPhamacy
	..s Sum=PackQty*Price
	..i BillType="" s BillTypeDesc="自费"
	..e  s BillTypeDesc=$P(^PAC("ADMREA",BillType),"^",2)
	..s DoseqtySum=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),1)),"^",12)
	..s DepProcNotes=$G(^OEORD(+Rowid,"I",$p(Rowid,"||",2),"DEP",1))
	..;i DepProcNotesRowid'="" s DepProcNotes=^OEORD(+Rowid,"I",$p(Rowid,"||",2),"DEP",DepProcNotesRowid)
	..s PackQty=DoseqtySum
	..s PackUOM=$p(PackUOM,"(",1)
	..s Sum=PackQty*Price
	..s Spec=##class(web.DHCOEOrdItem).GetLabSpec(Rowid,HospId)
	..s Container=##Class(web.DHCOEOrdItem).GetLabContainer(Rowid,HospId)
	..s Spec1=Spec
	..s ARCItemExcID=0,TSCode=0
	..f  s ARCItemExcID=$O(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID)) q:ARCItemExcID=""  d
	...s DateFrom=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",1)
	...s DateTo=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",2)
	...Q:(DateTo<(+$H))&&(DateTo'="")
	...s TSCode=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"EXT",ARCItemExcID),"^",4)
	..s CTNationName=""
	..s:HospitalCode'="" CTNationName=##Class(DHCLIS.DHCCommon).GetTestSetCollectPrompt(TSCode,HospitalCode)
	..//i $D(^|"LABDATA"|TTAB("TS",TSCode)) s CTNationName=$P(^|"LABDATA"|TTAB("TS",TSCode),"\",33)
	..;i Spec'="" s Spec1=$p($g(Spec),"-",2)
	..;s ExecuteTime=$G(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),"RB",1))
	..;s ExecuteTime=$P(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),9),"^",14)
	..s ExecuteTime=""
	..s StartDate=..%ZD(StartDate) //$ZD(StartDate,3)
	..s LabOrdPlacerNo=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),3)),"^",36) 
	..s OrderNotifyClinician=$p($g(^OEORD(+Rowid,"I",$p(Rowid,"||",2),11)),"^",55)
	..do OutputRow4
	.&sql(CLOSE EmpCursor)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow4
 set Data=$lb(Rowid,OrderName,StartDate,Priority,Status,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillType,OrderType,Spec,UserAddName,LabEpisodeNo,OrdSubDesc,orcatdesc,RecDepAdress,DepProcNotes,StatusCode,ExecuteTime,Spec1,CTNationName,BillTypeDesc,LabOrdPlacerNo,Container,OrderNotifyClinician)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
ResetVariables4
	set (Rowid,OrderName,StartDate,Priority,Status,PackQty,PackUOM,Price,Sum,RecDep,Billed,BillTypeDesc,OrderType,Spec,UserAddName,LabEpisodeNo,OrdSubDesc,orcatdesc,RecDepAdress,DepProcNotes,StatusCode,ExecuteTime,CTNationName,BillType,LabOrdPlacerNo,OrderNotifyClinician)=""
	quit
}

ClassMethod GetOrderItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderItemsExecute ]
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

ClassMethod GetPrescItemCount(EpisodeID As %String, PrescNo As %String) As %Integer
{
 &SQL(Select Count(*) Into :OrderItemCount From SQLUser.OE_OrdItem 
	 WHERE OEORI_PrescNo=:PrescNo and OEORI_OEORD_PARREF->OEORD_ADM_DR=:EpisodeID and OEORI_ItemStat_DR->OSTAT_Code='V' and OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='R')
 Quit OrderItemCount
}

ClassMethod GetPrescItemsBroker(itmjs As %Library.String = "", EpisodeID As %String, PrescNo As %String) As %Library.String
{
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem:GetPrescItems")
	do rset.Execute(EpisodeID,PrescNo)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod GetPrescItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrescItemsExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetLabSpec(OrderItemRowid As %String) As %String
{
 s SpecStr=""
 s OrderRowid=$p(OrderItemRowid,"||",1)
 s Childsub=$p(OrderItemRowid,"||",2)
 s spec=0 for  s spec=$o(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)) QUIT:spec=""  do
 . s SpecCode=$P($g(^OEORD(OrderRowid,"I",Childsub,"SPEC",spec)),"^",1)
 . s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
 . i SpecStr="" s SpecStr=SpecDesc
 . e  s SpecStr=SpecStr+","+SpecDesc
 Q SpecStr

 n (Ord, Sub,OrderItemRowid)
 s Ord=+OrderItemRowid
 s Sub=$P(OrderItemRowid,"||",2)
 s retno=""
 q:Ord="" retno
 q:'$d(^OEORD(Ord,"I",Sub,1)) retno
 s ItmMastDR=$p(^OEORD(Ord,"I",Sub,1),"^",2)
 q:ItmMastDR="" retno
 s arcsub=$p(ItmMastDR,"||",2)
 q:arcsub="" retno
 s excode=""
 s chl="" f  s chl=$o(^ARCIM(+ItmMastDR,arcsub,"EXT",chl)) q:chl=""  d
 .s tod=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",2)
 .q:(tod'="")&(tod<+$h)
 .s excode=$p(^ARCIM(+ItmMastDR,arcsub,"EXT",chl),"^",4)
 q:excode="" retno
	s contdr=$o(^TTAB("TS",excode,"SC",""))
	q:contdr="" retno
	s specdr=$o(^TTAB("TS",excode,"SC",contdr,""))
	q:specdr="" retno  
	s specdesc=$p($G(^TTAB("SPEC",specdr)),"\",1)
	q specdesc
}

}
