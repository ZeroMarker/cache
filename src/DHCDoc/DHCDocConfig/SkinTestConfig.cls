Class DHCDoc.DHCDocConfig.SkinTestConfig Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->皮试设置 查询所有用法
Query FindAllInstr(value As %String) As %Query(ROWSPEC = "InstrRowID:%String,InstrDesc:%String,selected:%Boolean")
{
}

ClassMethod FindAllInstrExecute(ByRef qHandle As %Binary, value As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.DocConfig","FindAllInstr","FrequencedItemDur")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s InstrRowID=0
 	f  s InstrRowID=$o(^PHCIN(InstrRowID)) q:InstrRowID=""  d
 	.s str=$g(^PHCIN(InstrRowID))
 	.s InstrDesc=$p(str,"^",2)
 	.s PHCINDesc2=$p(str,"^",3)
	.s selected=0
	.i InstrRowID=$g(^DHCDocConfig(value)) s selected=1
	.Do OutputRowFindAllInstr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllInstr
	set Data=$lb($g(InstrRowID),$g(InstrDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindAllInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllInstrExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllInstrExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->皮试设置 查询所有皮试备注
Query GetSkinAction() As %Query(ROWSPEC = "ActRowid:%String,ACTDesc:%String")
{
}

ClassMethod GetSkinActionExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SkinTestConfig","GetSkinAction")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s ActRowid=0 f  s ActRowid=$o(^OEC("ACT",ActRowid)) q:ActRowid=""  d
	.s ACTCode=$p($g(^OEC("ACT",ActRowid)),"^",1)
	.s ACTDesc=$p($g(^OEC("ACT",ActRowid)),"^",2)
	.s DateFrom=$p($g(^OEC("ACT",ActRowid)),"^",3)
	.Q:(DateFrom'="")&&(DateFrom>+$h)
	.s DateTo=$p($g(^OEC("ACT",ActRowid)),"^",4)
	.Q:(DateTo'="")&&(DateTo<=..%SysDate())
	.Do OutputRowGetSkinAction
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSkinAction
	set Data=$lb($g(ActRowid),$g(ACTDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSkinActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinActionExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSkinActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinActionExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->皮试设置 查询皮试备注绑定的医嘱
Query GetSkinLinkItem(ActRowid As %String, HospId As %String = "") As %Query(ROWSPEC = "ActIARCIMDR:%String,ActIARCIMDesc:%String,ActIQty:%String,Rowid:%String,InstrDR:%String,Instr:%String,Dose:%String,DoseUomDR:%String,DoseUom:%String")
{
}

ClassMethod GetSkinLinkItemExecute(ByRef qHandle As %Binary, ActRowid As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.SkinTestConfig","GetSkinLinkItem")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	i ActRowid'="" d
	.s ActIChildsub=0  f  s ActIChildsub=$o(^OEC("ACT",ActRowid,"Item",ActIChildsub)) q:ActIChildsub=""  d
	..s ActIARCIMDR=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",1)
	..//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ActIARCIMDR,HospId)="N"
	..s ActIARCIMDesc=$p(^ARCIM(+ActIARCIMDR,$p(ActIARCIMDR,"||",2),1),"^",2)
	..s ActIQty=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",2)
	..s InstrDR=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",3)
	..s ACTIHospDr=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",4)
	..Q:ACTIHospDr'=HospId
	..s Dose=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",5)
	..s DoseUomDR=$p($g(^OEC("ACT",ActRowid,"Item",ActIChildsub)),"^",6)
	..if (DoseUomDR'="") s DoseUom=$p($g(^CT("UOM",DoseUomDR)),"^",2)
	..else  s DoseUom=""
	..s Instr=""
	..s:InstrDR'="" Instr=$p($g(^PHCIN(InstrDR)),"^",2)
	..Do OutputRowGetSkinLinkItem
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSkinLinkItem
	set Data=$lb($g(ActIARCIMDR),$g(ActIARCIMDesc),$g(ActIQty),ActRowid_"||"_ActIChildsub,InstrDR,Instr,Dose,DoseUomDR,DoseUom)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSkinLinkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSkinLinkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSkinLinkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSkinLinkItemExecute ]
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

ClassMethod Save(Rowid As %String, ActRowid As %String, ArcimRowid As %String, ActQty As %String, InstrDR As %String, Dose As %String, DoseUomDR As %String, HospId As %String) As %String
{
    s arcimcode=""
	&sql(select arcim_code into :arcimcode from SQLUSER.arc_itmmast where arcim_rowid=:ArcimRowid)
	q:arcimcode="" "-1"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	if (Rowid="") {
		&sql(select * from SQLUser.DHC_OECAction WHERE ACTI_ACT_ParRef=:ActRowid AND ACTI_ARCIM_DR=:ArcimRowid AND ACTI_Instr_DR=:InstrDR AND ACTI_Hosp_DR=:HospId)
	    if (SQLCODE'="100") Q "repeat"
    	&sql(Insert INTO SQLUser.DHC_OECAction(ACTI_ACT_ParRef,ACTI_ARCIM_DR,ACTI_Qty,ACTI_Instr_DR,ACTI_Hosp_DR,ACTI_DoseQty,ACTI_DoseUom_DR) values(:ActRowid,:ArcimRowid,:ActQty,:InstrDR,:HospId,:Dose,:DoseUomDR))
	}else{
		&sql(select * from SQLUser.DHC_OECAction WHERE ACTI_ACT_ParRef=:ActRowid AND ACTI_ARCIM_DR=:ArcimRowid AND ACTI_Hosp_DR=:HospId  AND ACTI_Instr_DR=:InstrDR and ACTI_ChildSub>0 and ACTI_RowId<>:Rowid)
	    if (SQLCODE'="100") Q "repeat"
    	&sql(update  SQLUser.DHC_OECAction set ACTI_ACT_ParRef=:ActRowid,ACTI_ARCIM_DR=:ArcimRowid,ACTI_Qty=:ActQty,ACTI_Instr_DR=:InstrDR,ACTI_DoseQty=:Dose,ACTI_DoseUom_DR=:DoseUomDR where ACTI_RowId=:Rowid) 
	}
	q SQLCODE
}

ClassMethod delete(ARCIRowid As %String) As %String
{
	&sql(Delete from SQLUser.DHC_OECAction where ACTI_RowId=:ARCIRowid)
    q SQLCODE
}

Query FindItem(Alias As %String, HospId As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, Alias As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	Set rs2=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
	d rs2.Execute(Alias,"","","","","","",HospId)
	while(rs2.Next()){
		s ArcimID = rs2.GetData(1)
		continue:ArcimID=""
		s ArcimDesc=rs2.GetData(2)
		s ItemCatRowid=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		continue:OrderType="L"
		continue:##class(web.DHCDocOrderCommon).GetItemServiceFlag(ArcimID)=1
		continue:##class(web.DHCDocOrderCommon).IsCNMedItem(ArcimID)=1
		d OutputRowFindItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

}
