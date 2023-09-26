Class DHCDoc.DHCDocConfig.ItemPrior Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->出院带药医嘱扩展设定 查询出院带药医嘱扩展设定
Query Find(Alias As %String, HospId As %String = "") As %Query(ROWSPEC = "rowid:%String,BillTypeRowid:%String,BillType:%String,ItemCatRowid:%String,ItemCat:%String,DurationRowid:%String,Duration:%String,Drugspecies:%String")
{
}

ClassMethod FindExecute(ByRef qHandle As %Binary, Alias As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","Find")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	 s rowid=0
     for  s rowid=$O(^DHCOOOC(rowid)) Q:rowid=""  d
     .set ItemCatRowid=$P(^DHCOOOC(rowid),"^",1)
     .set BillTypeRowid=$P(^DHCOOOC(rowid),"^",2)
     .set DurationRowid=$P(^DHCOOOC(rowid),"^",3)
     .set Drugspecies=$P(^DHCOOOC(rowid),"^",4)
     .set Hospdr=$P(^DHCOOOC(rowid),"^",5)
     .Q:Hospdr'=HospId
     .s (ItemCat,BillType,Duration)=""
     .if ItemCatRowid'="" s ItemCat=$p($g(^ARC("IC",ItemCatRowid)),"^",2)
     .if BillTypeRowid'="" s BillType=$p($g(^PAC("ADMREA",BillTypeRowid)),"^",2)
     .if DurationRowid'="" s Duration=$p($g(^PHCDU(DurationRowid)),"^",3)
	 .d OutputRowFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	Set Data=$lb(rowid,BillTypeRowid,BillType,ItemCatRowid,ItemCat,DurationRowid,Duration,Drugspecies)
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->出院带药医嘱扩展设定 录入频次疗程的非药品子类
Query FindCatList(value As %String, HospId As %String = "") As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindCatList","NeedExecCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICRowId,HospId)="N"
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
 	.i value'="" d
 	..s FrequencedItemCatListStr=..%GetConfig1(value,OutOrderPrior,HospId)  //$g(^DHCDocConfig(value,OutOrderPrior))
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->出院带药医嘱扩展设定 录入频次疗程的非药品子类
Query FindPoison(value As %String, HospId As %String = "") As %Query(ROWSPEC = "PHCPORowId:%String,PHCPODesc:%String,selected:%Boolean")
{
}

ClassMethod FindPoisonExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindPoison","OutOrderNotPoison")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PHCPORowId=0 
 	f  s PHCPORowId=$o(^PHCPO(PHCPORowId)) q:PHCPORowId=""  d
 	.s PHCPODesc=$p(^PHCPO(PHCPORowId),"^",2)
 	.s PHCPOCode=$p(^PHCPO(PHCPORowId),"^",1)
 	.//q:((PHCPOCode="J1")||(PHCPOCode="J2")||(PHCPOCode="DX")||(PHCPOCode="MZ"))&&(value="OutOrderNotPoison")
 	.s selected=0
 	.s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
 	.i value'="" d
 	..s PHCPORowIdStr=..%GetConfig1(value,OutOrderPrior,HospId) //$g(^DHCDocConfig(value,OutOrderPrior))
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
	s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,node,OutOrderPrior)=value
	}else{
		s ^DHCDocConfig(node,OutOrderPrior)=value
	}
	q 0
}

ClassMethod SaveLessLocConfig(node, nodeId, value, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		s ^DHCDocConfig(HospCodeNode,node,OutOrderPrior,nodeId,"LessLoc")=value
	}else{
		s ^DHCDocConfig(node,OutOrderPrior,nodeId,"LessLoc")=value
	}
	q 0
}

ClassMethod GetLessLocConfig(node, nodeId, HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
		Q $g(^DHCDocConfig(HospCodeNode,node,OutOrderPrior,nodeId,"LessLoc"))
	}else{
		Q $g(^DHCDocConfig(node,OutOrderPrior,nodeId,"LessLoc"))
	}
}

Query FindCatListPrior(PriorCode As %String, value As %String, HospId As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean,exceptPrior")
{
}

ClassMethod FindCatListPriorExecute(ByRef qHandle As %Binary, PriorCode As %String, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindCatListPrior","NORM","OnlyNORMItemCat")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
    s HospCodeNode="HospDr_"_HospId
    s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	s ItemCatListStr=""
 	i value'="" d
 	.s ItemCatListStr=$g(^DHCDocConfig(HospCodeNode,value,OrderPrior))
    s ItemCatRowId=0
 	f  s ItemCatRowId=$o(^ARC("IC",ItemCatRowId)) q:ItemCatRowId=""  d
 	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ItemCatRowId,HospId)="N"
 	.s ItemCatDesc=$p(^ARC("IC",ItemCatRowId),"^",2)
 	.s selected=("^"_ItemCatListStr_"^")[("^"_ItemCatRowId_"^")
	.s exceptPrior=..GetExceptPriorStr("Cat", ItemCatRowId, value, PriorCode, HospId)
	.Do OutputRowFindCatListPrior
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatListPrior
	set Data=$lb($g(ItemCatRowId),$g(ItemCatDesc),$g(selected),exceptPrior)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListPriorExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListPriorExecute ]
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

Query FindOrdPriorLimit(PriorCode As %String, Value As %String, HospId As %String = "") As %Query(ROWSPEC = "Index:%String,ArcimDr:%String,ArcimDesc:%String,exceptPrior")
{
}

ClassMethod FindOrdPriorLimitExecute(ByRef qHandle As %Binary, PriorCode As %String, Value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","FindOrdPriorLimit","NORM","OnlyNORMItemCat",2)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (PriorCode ="") {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
    s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
    s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
    s HospCodeNode="HospDr_"_HospId
	s Index=0
 	f  s Index=$o(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index)) q:Index=""  d
 	.s ArcimDr=$p(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index),"^",1)
 	.//Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimDr,HospId)="N"
 	.s ArcimDesc=$P($G(^ARCIM(+ArcimDr,+$P(ArcimDr,"||",2),1)),"^",2)
	.s exceptPrior=..GetExceptPriorStr("Item", Index, Value, PriorCode, HospId)
	.Do OutputRowFindOrdPriorLimit
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindOrdPriorLimit
	set Data=$lb(Index,$g(ArcimDr),$g(ArcimDesc),exceptPrior)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOrdPriorLimitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdPriorLimitExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrdPriorLimitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdPriorLimitExecute ]
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

ClassMethod SaveOrdPriorLimit(Value As %String, PriorCode As %String, Info As %String, HospId As %String) As %String
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	s LONGLimitInfo=##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyLongItemCat","S",HospId)
	s LONGLimitArcItemStr=$P(LONGLimitInfo,$C(1),2)
	s NORMLimitInfo=##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyNORMItemCat","NORM",HospId)
	s NORMLimitArcItemStr=$P(NORMLimitInfo,$C(1),2)
	s HospCodeNode="HospDr_"_HospId
	s err=""
	TS
	for i=1:1:$L(Info,"^"){
		s ArcimRowid=$P(Info,"^",i)
		continue:ArcimRowid=""
		s ArcimDesc=$P(^ARCIM(+ArcimRowid,1,1),"^",2)
		if (PriorCode="NORM") {
			if (LONGLimitArcItemStr'="")&&(("^"_LONGLimitArcItemStr_"^")[("^"_ArcimRowid_"^")) {
				s err=ArcimDesc_" 该医嘱已设置成仅可开长期医嘱！"
				Q 
			}
		}elseif(PriorCode="S") {
			if (NORMLimitArcItemStr'="")&&(("^"_NORMLimitArcItemStr_"^")[("^"_ArcimRowid_"^")) {
				s err=ArcimDesc_" 该医嘱已设置成仅可开临时医嘱！"
				Q 
			}
		}
		s Index=$O(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",""),-1)
		s repeat=0
		for i=1:1:Index {
			s ArcimRowId=$g(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",i))
			if (ArcimRowId=ArcimRowid) s repeat=1 Q
		}
		if repeat{
			s err="项目重复:"_ArcimDesc
			Q
		}
		s Index=Index+1
		s ^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index)=ArcimRowid
	}
	if err'=""{
		TRO
		Q err
	}
	TC
	q 0
}

ClassMethod DelPriorLimit(Value As %String, PriorCode As %String, IndexS As %String, HospId As %String) As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	for i=1:1:$Length(IndexS,"^"){
		s Index=$P(IndexS,"^",i)
		k ^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index)
	}
	q 0
}

ClassMethod SavePriorLimitConfig(Value As %String, PriorCode As %String, ItemCatS As %String, HospId As %String = "") As %String
{
	s errMsg=""
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (ItemCatS'="") {
		if (PriorCode="NORM") {
			s LONGLimitInfo=##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyLongItemCat","S",HospId)
			s LONGLimitItemCatStr=$P(LONGLimitInfo,$C(1),1)
			if (LONGLimitItemCatStr '="") {
				for i=1:1:$l(LONGLimitItemCatStr,"^") {
					s ItemCatRowid=$p(LONGLimitItemCatStr,"^",i)
					continue:ItemCatRowid=""
					s ItemCateDesc=$p(^ARC("IC",ItemCatRowid),"^",2)
					if (("^"_ItemCatS_"^")[("^"_ItemCatRowid_"^")) {
						i errMsg="" s errMsg=ItemCateDesc
						e  s errMsg=errMsg_","_ItemCateDesc
					}
				}
			}
			Q:errMsg'="" errMsg_" 已设置成不能下临嘱的医嘱子类！"
		}elseif(PriorCode="S") {
			s NORMLimitInfo=##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyNORMItemCat","NORM",HospId)
			s NORMLimitItemCatStr=$P(NORMLimitInfo,$C(1),1)
			if (NORMLimitItemCatStr '="") {
				for i=1:1:$l(NORMLimitItemCatStr,"^") {
					s ItemCatRowid=$p(NORMLimitItemCatStr,"^",i)
					continue:ItemCatRowid=""
					s ItemCateDesc=$p(^ARC("IC",ItemCatRowid),"^",2)
					if (("^"_ItemCatS_"^")[("^"_ItemCatRowid_"^")) {
						i errMsg="" s errMsg=ItemCateDesc
						e  s errMsg=errMsg_","_ItemCateDesc
					}
				}
			}
			Q:errMsg'="" errMsg_" 已设置成不能下长嘱的医嘱子类！"
		}
	}
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId		
		s ^DHCDocConfig(HospCodeNode,Value,OrderPrior)=ItemCatS
	}else{
		s ^DHCDocConfig(Value,OrderPrior)=ItemCatS
	}
	q 0
}

/// w ##Class(DHCDoc.DHCDocConfig.ItemPrior).GetPriorLimitInfo("OnlyNORMItemCat","NORM")
ClassMethod GetPriorLimitInfo(Value As %String, PriorCode As %String, HospId As %String = "") As %String
{
	n (Value,PriorCode,HospId,%session)
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	q:(OrderPrior="") ""
	s HospCodeNode="HospDr_"_HospId
	s ItemCatStr=$G(^DHCDocConfig(HospCodeNode,Value,OrderPrior))
	s ArcItemStr=""
	s Index=""
	for {
		s Index=$O(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index))
		q:(Index="")
		s Item=$G(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",Index))
		continue:(Item="")
		//continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",Item,HospId)="N"
		i (ArcItemStr=""){
			s ArcItemStr=Item
		}else{
			s ArcItemStr=ArcItemStr_"^"_Item
		}
	}
	q ItemCatStr_$C(1)_ArcItemStr
}

Query GetLocList(HospId As %String = "") As websys.Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocAlias:%String,PYFristStr:%String")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s LocRowID=0
    /*for {
	    s LocRowID=$o(^PAC("ADMLOC",0,"AdmType","I",LocRowID)) Q:LocRowID=""
	    s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
		Q:(LocHospDr'=HospId)&&(HospId'="")
	    s LocDesc=$p(^CTLOC(LocRowID),"^",2)
	    s ContactName=$p(^CTLOC(LocRowID),"^",43)
		Do OutputRowLoc
	}*/
    s LocRowID=0  f  s LocRowID=$o(^CTLOC(LocRowID)) q:LocRowID=""  d
	.q:##class(web.DHCDocCommon).CheckLocIsValid(LocRowID)=0
	.s LocHospDr=$p(^CTLOC(LocRowID),"^",22)
	.Q:(LocHospDr'=HospId)&&(HospId'="")
    .s LocDesc=$p(^CTLOC(LocRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(LocRowID),"^",13)
    .Q:'$D(^PAC("ADMLOC",0,"AdmType","I",LocRowID))&&(CTLOCType'="W")
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

Query FindFreq(value, HospId As %String = "") As %Query(ROWSPEC = "FreqID,FreqDesc,selected")
{
}

ClassMethod FindFreqExecute(ByRef qHandle As %Binary, value, HospId As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s OutOrderPrior=$O(^OECPR(0,"Code","OUT",0))
	s OutOrderNotFreqIDStr="^"_..%GetConfig1(value,OutOrderPrior,HospId)_"^"
	&SQL(DECLARE OrdCursor CURSOR FOR
 		SELECT PHCFR_RowId,PHCFR_Desc1 FROM SQLUser.PHC_Freq)
 	&SQL(OPEN OrdCursor)
  	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare("SELECT PHCFR_RowId,PHCFR_Desc1 FROM SQLUser.PHC_Freq")
	d rs.Execute()
	while rs.Next(){
		s FreqID=rs.Data("PHCFR_RowId")
		continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("PHC_Freq",FreqID,HospId)="N"
		s Active=$P(^PHCFR(FreqID),"^",6)
		continue:(Active="N")
		s FreqDesc=rs.Data("PHCFR_Desc1")
		s selected=OutOrderNotFreqIDStr[("^"_FreqID_"^")
		d rows.%Push($LB(FreqID,FreqDesc,selected))
	}
	Quit $$$OK
}

ClassMethod FindFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFreqExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

Query QueryPrior(ItemType, ItemValue, Value, PriorCode, HospId As %String = "") As %Query(ROWSPEC = "id,text,selected:%Boolean")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ItemPrior","QueryPrior","NORM",2)
ClassMethod QueryPriorExecute(ByRef qHandle As %Binary, ItemType, ItemValue, Value, PriorCode, HospId As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	s rows=[]
	s qHandle=rows.%GetIterator()
	s PriorStr=..GetExceptPriorIDStr(ItemType, ItemValue, Value,PriorCode,HospId)
	s PriorRowid=0 for{
		s PriorRowid=$O(^OECPR(PriorRowid)) Q:PriorRowid=""
		s Prior=$P(^OECPR(PriorRowid),"^",2)
		s LongOrderPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		continue:(LongOrderPriorFlag&&(PriorCode="S"))||('LongOrderPriorFlag&&(PriorCode="NORM"))
		s selected=("^"_PriorStr_"^")[("^"_PriorRowid_"^")
		d rows.%Push($LB(PriorRowid,Prior,selected))
	}
	Quit $$$OK
}

ClassMethod QueryPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPriorExecute ]
{
	if 'qHandle.%GetNext(.key,.Row) s AtEnd=1
	Quit $$$OK
}

ClassMethod SaveExceptPrior(ItemType, ItemValue, Value, PriorCode, PriorStr, HospId) [ ProcedureBlock = 1 ]
{
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	Q:OrderPrior="" -1
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	if (ItemType="Item"){
		s ^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",ItemValue,"ExceptPrior")=PriorStr
	}else{
		s ^DHCDocConfig(HospCodeNode,Value,OrderPrior,"ExceptPrior",ItemValue)=PriorStr
	}
	Q 0
}

ClassMethod GetExceptPriorIDStr(ItemType, ItemValue, Value, PriorCode, HospId) [ ProcedureBlock = 1 ]
{
	set HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s HospCodeNode="HospDr_"_HospId
	s OrderPrior=$O(^OECPR(0,"Code",PriorCode,0))
	if (ItemType="Item"){
		s PriorStr=$G(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"Item",ItemValue,"ExceptPrior"))
	}else{
		s PriorStr=$G(^DHCDocConfig(HospCodeNode,Value,OrderPrior,"ExceptPrior",ItemValue))
	}
	Q PriorStr
}

ClassMethod GetExceptPriorStr(ItemType, ItemValue, Value, PriorCode, HospId)
{
	s PriorStr=""
	s PriorIDStr=..GetExceptPriorIDStr(ItemType, ItemValue, Value,PriorCode,HospId)
	for i=1:1:$L(PriorIDStr,"^"){
		s PriorRowid=$P(PriorIDStr,"^",i)
		continue:PriorRowid=""
		s Prior=$P(^OECPR(PriorRowid),"^",2) 
		if PriorStr="" s PriorStr=Prior
		else  s PriorStr=PriorStr_";"_Prior
	}
	Q PriorStr
}

/// 医嘱是否允许开此医嘱类型
/// 1允许 0不允许
ClassMethod CheckItemPriorAllow(ArcimRowid, PriorRowid, HospId = "", ByRef ErrMsg = "") As %Boolean [ ProcedureBlock = 1 ]
{
	Q:PriorRowid="" 1
	Q:ArcimRowid'["||" 1
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s LongPriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
	if LongPriorFlag{
		s Node1="OnlyNORMItemCat",Node2=$O(^OECPR(0,"Code","NORM",0))
		s ErrMsg="该医嘱仅能下临时"
	}else{
		s Node1="OnlyLongItemCat",Node2=$O(^OECPR(0,"Code","S",0))
		s ErrMsg="该医嘱仅能下长期"
	}
	s HospCodeNode="HospDr_"_HospId
	s ItemCatStr=$G(^DHCDocConfig(HospCodeNode,Node1,Node2))
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	if (ItemCatStr'="")&&(("^"_ItemCatStr_"^")[("^"_ItemCatRowid_"^")){
		s ExceptPriorStr=$G(^DHCDocConfig(HospCodeNode,Node1,Node2,"ExceptPrior",ItemCatRowid))
		if ("^"_ExceptPriorStr_"^")'[("^"_PriorRowid_"^"){
			if ExceptPriorStr'=""{
				for i=1:1:$L(ExceptPriorStr,"^"){
					s id=$P(ExceptPriorStr,"^",i)
					continue:id=""
					s ErrMsg=ErrMsg_"、"_$P(^OECPR(id),"^",2) 
				}
			}
			Q 0
		}
		s ErrMsg=""
		Q 1
	}
	s Flag=1
	s Index=0 for{
		s Index=$O(^DHCDocConfig(HospCodeNode,Node1,Node2,"Item",Index)) Q:Index=""
		s ItemID=^DHCDocConfig(HospCodeNode,Node1,Node2,"Item",Index)
		if ItemID=ArcimRowid{
			s ExceptPriorStr=$G(^DHCDocConfig(HospCodeNode,Node1,Node2,"Item",Index,"ExceptPrior"))
			s Flag=("^"_ExceptPriorStr_"^")[("^"_PriorRowid_"^")
			if 'Flag&&(ExceptPriorStr'=""){
				for i=1:1:$L(ExceptPriorStr,"^"){
					s id=$P(ExceptPriorStr,"^",i)
					continue:id=""
					s ErrMsg=ErrMsg_"、"_$P(^OECPR(id),"^",2) 
				}
			}
			Q
		}
	}
	s:Flag ErrMsg=""
	Q Flag
}

}
