Class DHCDoc.DHCDocConfig.OrderOMPrior Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:彭军
/// date:2022年9月7日
/// desc:医生站设置程序->自备药药医嘱扩展设定 查询自备药医嘱扩展设定
Query Find(HospId As %String = "") As %Query(ROWSPEC = "Index:%String,ArcimDr:%String,ArcimDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderOMPrior","Find","2")
ClassMethod FindExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s HospCodeNode="HospDr_"_HospId
    s Value="OMLimitOrder"
	s Index=0
 	f  s Index=$o(^DHCDocConfig(HospCodeNode,Value,"Item",Index)) q:Index=""  d
 	.s ArcimDr=$p(^DHCDocConfig(HospCodeNode,Value,"Item",Index),"^",1)
 	.//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimDr,HospId)="N"
 	.s ArcimDesc=$P($G(^ARCIM(+ArcimDr,+$P(ArcimDr,"||",2),1)),"^",2)
	.Do OutputRowFindOMOrdLimit
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOMOrdLimit
	set Data=$lb(Index,$g(ArcimDr),$g(ArcimDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindExecute ]
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

/// creator:彭军
/// date:2022年9月7日
/// desc:医生站设置程序->自备药医嘱扩展设定 
Query FindCatList(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderOMPrior","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.i value'="" d
 	..s FrequencedItemCatListStr=..%GetConfig(value,HospId)  //$g(^DHCDocConfig(value,OutOrderPrior))
 	..s:("^"_FrequencedItemCatListStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

/// creator:彭军
/// date:2022年9月7日
/// desc:
Query FindPoison(value As %String, HospId As %String = "") As %Query(ROWSPEC = "PHCPORowId:%String,PHCPODesc:%String,selected:%Boolean")
{
}

ClassMethod FindPoisonExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.OrderOMPrior","FindPoison","OMOrderNotPoison",2)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PHCPORowId=0 
 	f  s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""  d
 	.s PHCPODesc=$p(^PHCPO(PHCPORowId),"^",2)
 	.s PHCPOCode=$p(^PHCPO(PHCPORowId),"^",1)
 	.s selected=0
 	.i value'="" d
 	..s PHCPORowIdStr=..%GetConfig(value,HospId) //$g(^DHCDocConfig(value,OutOrderPrior))
 	..s:("^"_PHCPORowIdStr_"^")[("^"_PHCPORowId_"^") selected=1
	.Do OutputRowFindPoison
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindPoison
	set Data=$lb($g(PHCPORowId),$g(PHCPODesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindPoisonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPoisonExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPoisonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPoisonExecute ]
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

ClassMethod delete(RowId As %String) As %String
{
	&sql(DELETE FROM SQLUser.DHC_OutOrderOtherContral WHERE OOC_RowId = :RowId)
 	Q SQLCODE
}

ClassMethod save(Para As %String, HospId As %String = "") As %String
{
	set HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	set rowid=$P(Para,"^",1)
	set ItemCatRowid=$P(Para,"^",2)
	set BillTypeRowid=$P(Para,"^",3)
	set DurationRowid=$P(Para,"^",4)
	set Drugspecies=$P(Para,"^",5)
	set count=0
	if (rowid="") {
		&sql(select count(OOC_RowId) into:count from SQLUser.DHC_OutOrderOtherContral where OOC_Hosp_DR=:HospId and OOC_ItemCat_DR=:ItemCatRowid and OOC_AdmReason_DR=:BillTypeRowid)
	 	Q:count>0 "repeat"
	 	&sql(INSERT INTO SQLUser.DHC_OutOrderOtherContral(OOC_ItemCat_DR,OOC_AdmReason_DR,OOC_Dur_DR,OOC_Drugspecies,OOC_Hosp_DR)
         VALUES(:ItemCatRowid,:BillTypeRowid,:DurationRowid,:Drugspecies,:HospId))
    }else{
	    &sql(select count(OOC_RowId) into:count from SQLUser.DHC_OutOrderOtherContral where OOC_Hosp_DR=:HospId and OOC_ItemCat_DR=:ItemCatRowid and OOC_AdmReason_DR=:BillTypeRowid and OOC_RowId<>:rowid)
	    Q:count>0 "repeat"
	    &sql(update SQLUser.DHC_OutOrderOtherContral (OOC_ItemCat_DR,OOC_AdmReason_DR,OOC_Dur_DR,OOC_Drugspecies)
         VALUES(:ItemCatRowid,:BillTypeRowid,:DurationRowid,:Drugspecies) where OOC_RowId=:rowid)
	}
    Q SQLCODE
}

ClassMethod SaveConfig(node, value, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,node)=value
	}else{
		s ^DHCDocConfig(node)=value
	}
	q 0
}

ClassMethod SaveLessLocConfig(node, nodeId, value, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,node,nodeId,"LessLoc")=value
	}else{
		s ^DHCDocConfig(node,nodeId,"LessLoc")=value
	}
	q 0
}

ClassMethod GetLessLocConfig(node, nodeId, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		Q $g(^DHCDocConfig(HospCodeNode,node,nodeId,"LessLoc"))
	}else{
		Q $g(^DHCDocConfig(node,nodeId,"LessLoc"))
	}
}

Query GetLocList(HospId As %String = "") As websys.Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocAlias:%String,PYFristStr:%String")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s LocRowID=0

    s LocRowID=0  f  s LocRowID=$o(^CTLOC(LocRowID)) q:LocRowID=""  d
	.s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
	.Q:(LocHospDr'=HospId)&&(HospId'="")
    .s LocDesc=$p(^CTLOC(LocRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
    .q:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
	.q:((CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")&&(CTLOCType'="OP"))
	.q:($P(^CTLOC(LocRowID),"^",14)'="Y")
    .s PYFristStr=##class(web.DHCINSUPort).GetCNCODE(LocDesc,4,"")
    .s ContactName=$p(^CTLOC(LocRowID),"^",43)
	.Do OutputRowLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLoc
	set Data=$lb($g(LocRowID),$g(LocDesc),ContactName,$G(PYFristStr))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

/// w ##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyNORMItemCat","NORM")
ClassMethod GetOMLimitOrdInfo(Value As %String, HospId As %String = "") As %String
{
	n (Value,PriorCode,HospId,%session)
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s HospCodeNode="HospDr_"_HospId
	s ArcItemStr=""
	s Index=""
	for {
		s Index=$O(^DHCDocConfig(HospCodeNode,Value,"Item",Index))
		q:(Index="")
		s Item=$G(^DHCDocConfig(HospCodeNode,Value,"Item",Index))
		continue:(Item="")
		i (ArcItemStr=""){
			s ArcItemStr=Item
		}else{
			s ArcItemStr=ArcItemStr_"^"_Item
		}
	}
	q ArcItemStr
}

ClassMethod SaveOMOrdLimit(Value As %String, rowid As %String = "", Info As %String, HospId As %String) As %String
{
	s ^tmp("SaveOMOrdLimit")=$LB(Value,Info,rowid)
	q:(+Info=0)||(Info'["||") "-2"
	q:'$d(^ARCIM(+Info,$p(Info,"||",2),1)) "-2"
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	
	
	s HospCodeNode="HospDr_"_HospId
	s Index=$O(^DHCDocConfig(HospCodeNode,Value,"Item",""),-1)
	s repeat=0
	for i=1:1:Index {
		continue:rowid=i
		s ArcimRowId=$g(^DHCDocConfig(HospCodeNode,Value,"Item",i))
		if (ArcimRowId=Info) s repeat=1 Q
	}
	Q:repeat=1 "-1"
	i rowid'=""{
		s ^DHCDocConfig(HospCodeNode,Value,"Item",rowid)=Info
		q 0
	}
	
	s Index=Index+1
	s ^DHCDocConfig(HospCodeNode,Value,"Item",Index)=Info
	q 0
}

ClassMethod DelOMOrdLimit(Value As %String, IndexS As %String, HospId As %String) As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	for i=1:1:$Length(IndexS,"^"){
		s Index=$P(IndexS,"^",i)
		k ^DHCDocConfig(HospCodeNode,Value,"Item",Index)
	}
	q 0
}

}
