Class DHCDoc.DHCDocConfig.InstrRecloc Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->用法关联接受科室设置 根据用法查询关联接受科室
Query GetInstrLinkRecLoc(InstrRowId As %String, HospId As %String = "") As %Query(ROWSPEC = "InstrRecLocRowid:%String,OrdDepList:%String,RecLoc:%String,Default:%String,OrdSubCat:%String,OrdSubCatDesc:%String,OrdPrior:%String,OrdPriorDesc:%String,OrdTimeRangeFrom:%String,OrdTimeRangeTo:%String,HospitalDesc:%String,OrdDepListDr:%String,HospitalRowid:%String,RecLocDr:%String,OnlyChemotherapeuticAndTPN:%String")
{
}

ClassMethod GetInstrLinkRecLocExecute(ByRef qHandle As %Binary, InstrRowId As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetInstrLinkRecLoc",8)
	Set repid=$I(^CacheTemp)
    Set ind=1
    if (InstrRowId=""){
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s InstrRecLocSub=0 
	for{
		s InstrRecLocSub=$o(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)) q:InstrRecLocSub=""  d
    	s OrdDepListDr=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",1)
    	s OrdDepList=""
		for i=1:1:$L(OrdDepListDr,"!") {
			s OrdDepDr=$P(OrdDepListDr,"!",i)
			continue:(OrdDepDr="")
			s OrdDep=$p(^CTLOC(OrdDepDr),"^",2)
			if (OrdDepList=""){
				s OrdDepList=OrdDep
			}else{
				s OrdDepList=OrdDepList_","_OrdDep
			}
		}
		if (OrdDepList=""){
			s OrdDepList="全部"
		}
		s RecLocDr=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",2)
		s RecLoc=""
		s:RecLocDr'="" RecLoc=$p(^CTLOC(RecLocDr),"^",2)
		s Default=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",3)
		i Default="1" s Default="Y"
		e  s Default="N"
		s OrdSubCat=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",4)
		s OrdSubCatDesc=""
		s:OrdSubCat'="" OrdSubCatDesc=$p(^ARC("IC",OrdSubCat),"^",2)
		s OrdPrior=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",5)
		s OrdPriorDesc=""
		s:OrdPrior'="" OrdPriorDesc=$p(^OECPR(OrdPrior),"^",2)
		s OrdTimeRange=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",6)
		s OrdTimeRangeFrom=$p(OrdTimeRange,"~",1)
		s OrdTimeRangeTo=$p(OrdTimeRange,"~",2)
		s HospitalRowid=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",7)
		continue:HospitalRowid'=HospId
		s HospitalDesc=""
		i HospitalRowid'="" s HospitalDesc=$p($g(^CT("HOSP",HospitalRowid)),"^", 2)
		s InstrRecLocRowid=InstrRowId_"||"_InstrRecLocSub
		s OnlyChemotherapeuticAndTPN=$p($g(^PHCIN(InstrRowId,"RecLoc",InstrRecLocSub)),"^",8)
		s OnlyChemotherapeuticAndTPN=$CASE(OnlyChemotherapeuticAndTPN,"Y":"Y",:"N")
		Do OutputRowGetInstrLinkRecLoc
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetInstrLinkRecLoc
	set Data=$lb($g(InstrRecLocRowid),$g(OrdDepList),$g(RecLoc),$g(Default),$g(OrdSubCat),$g(OrdSubCatDesc),$g(OrdPrior),$g(OrdPriorDesc),$g(OrdTimeRangeFrom),$g(OrdTimeRangeTo),$g(HospitalDesc),$g(OrdDepListDr),$g(HospitalRowid),$g(RecLocDr),OnlyChemotherapeuticAndTPN)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetInstrLinkRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrLinkRecLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetInstrLinkRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrLinkRecLocExecute ]
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
/// desc:医生站设置程序->用法关联接受科室设置 查询接受科室
Query GetOrdDep(desc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String")
{
}

ClassMethod GetOrdDepExecute(ByRef qHandle As %Binary, desc As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetOrdDep")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s CTLOCRowID=0 
	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
	.s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_Loc",CTLOCRowID,HospId)
	.q:flag="N"
	.s LocHospDr=$p(^CTLOC(CTLOCRowID),"^",22)
	.Q:(LocHospDr'=HospId)&&(HospId'="")
    .s CTLOCDesc=$p(^CTLOC(CTLOCRowID),"^",2)
    .s CTLOCType=$p(^CTLOC(CTLOCRowID),"^",13)
    .q:(CTLOCType'="E")&&(CTLOCType'="W")
    .Q:(desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(CTLOCRowID,desc))
    .Q:##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0
	.q:($P(^CTLOC(CTLOCRowID),"^",14)'="Y")
    .//s CTLocContactName=$P(^CTLOC(CTLOCRowID),"^",43)
    .//s CTLOCDesc=CTLocContactName_" "_CTLOCDesc
	.Do OutputRowGetOrdDep
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetOrdDep
	set Data=$lb($g(CTLOCRowID),$g(CTLOCDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetOrdDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdDepExecute ]
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

/// 校验是否是患者就诊科室
/// w ##Class(DHCDoc.DHCDocConfig.InstrRecloc).CheckActiveAdmLoc(1)
ClassMethod CheckActiveAdmLoc(CTLOCRowID) As %String [ ProcedureBlock = 1 ]
{
	q:(CTLOCRowID="") "N"
	s CTLOCType=$p(^CTLOC(CTLOCRowID),"^",13)
	
	q:(CTLOCType'="E")&&(CTLOCType'="W") "N"
	q:(##class(web.DHCDocCommon).CheckLocIsValid(CTLOCRowID)=0) "N"
	q "Y"
}

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->用法关联接受科室设置查询医院列表
Query GetCTHospital() As %Query(ROWSPEC = "HOSPRowId:%String,HOSPDesc:%String")
{
}

ClassMethod GetCTHospitalExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.InstrRecloc","GetCTHospital")
	Set repid=$I(^CacheTemp)
    Set ind=1
	s HOSPRowId=0 
	f  s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""  d
    .s HOSPDesc=$p(^CT("HOSP",HOSPRowId),"^",2)
	.Do OutputRowGetCTHospital
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTHospital
	set Data=$lb($g(HOSPRowId),$g(HOSPDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTHospitalExecute ]
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

ClassMethod Save(InstrRowId As %String, RecLocStr As %String) As %String
{
	n (InstrRowId,RecLocStr)
	i (InstrRowId'="")&&(RecLocStr'=""){
		//s OrdDep=$p(RecLocStr,"!",1)
		s RecLoc=$p(RecLocStr,"!",2)
		s Default=$p(RecLocStr,"!",3)
		s OrdSubCat=$p(RecLocStr,"!",4)
		s OrdPrior=$p(RecLocStr,"!",5)
		s OrdTimeRange=$p(RecLocStr,"!",6)
		s Hospital=$p(RecLocStr,"!",7)
		s InstrRecLocRowid=$p(RecLocStr,"!",8)
		s OnlyChemotherapeuticAndTPN=$p(RecLocStr,"!",9)
		Set $ZT="ERROR^DHCSSERR"
		TS
		if (InstrRecLocRowid'="") {
			&sql(update SQLUser.DHC_PHCInstrRecLoc (Instr_RecLoc_ParRef,Instr_RecLoc,Instr_Default,Instr_OrdSubcat,Instr_OrdPrior,Instr_TimeRange,Instr_Hospital_DR,Instr_OnlyChemotherapeuticAndTPN) values(:InstrRowId,:RecLoc,:Default,:OrdSubCat,:OrdPrior,:OrdTimeRange,:Hospital,:OnlyChemotherapeuticAndTPN) where RowID=:InstrRecLocRowid)
		}else{
      		&sql(insert into SQLUser.DHC_PHCInstrRecLoc (Instr_RecLoc_ParRef,Instr_RecLoc,Instr_Default,Instr_OrdSubcat,Instr_OrdPrior,Instr_TimeRange,Instr_Hospital_DR,Instr_OnlyChemotherapeuticAndTPN) values(:InstrRowId,:RecLoc,:Default,:OrdSubCat,:OrdPrior,:OrdTimeRange,:Hospital,:OnlyChemotherapeuticAndTPN))
		}
		TC
		s InstrRecLocRowId=%ROWID
   }
		q SQLCODE
}

/// 保存关联的患者所在科室
ClassMethod SaveOrdDep(InstrRecLocRowid As %String, OrdDepStr As %String) As %String
{
	q:(InstrRecLocRowid="") "-100^未选中有效的用法关联医嘱接收科室数据"
	&sql(update SQLUser.DHC_PHCInstrRecLoc (Instr_OrdDep) values (:OrdDepStr) where RowID=:InstrRecLocRowid)
	q SQLCODE
}

ClassMethod Delete(InstrRecLocRowid) As %String
{
	n (InstrRecLocRowid) 
	q:InstrRecLocRowid="" 1
    &sql(delete from SQLUser.DHC_PHCInstrRecLoc where (RowID=:InstrRecLocRowid))
	q SQLCODE
}

}
