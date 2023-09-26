Import SQLUSER

Class web.DHCOESet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindInstrAttachOrd(ExecLocId As %String) As %Query(ROWSPEC = "tInattId:%String,tPhcinId:%String,tPhcindesc:%String,tPhcfrId:%String,tPhcfrdesc:%String,tArcimId:%String,tArcimdesc:%String,tOrdqty:%String,tType:%String,NINATTDefault:%String,NINATTDefaultID:%String,tExecLoc:%String,tExecLocId:%String")
{
}

ClassMethod FindInstrAttachOrdExecute(ByRef qHandle As %Binary, ExecLocId As %String = "") As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.DHCOEInstrAttachOrd","FindInstrAttachOrd")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ExecLocId="" d
	.s logonLocId=%session.Data("LOGON.CTLOCID")
	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i logonLocType="W" s ExecLocId=logonLocId
	k tmpLoc
	s tInattId=0
	f  s tInattId=$o(^DHCOEInstrAttachOrd(tInattId)) q:tInattId=""  d
	   .s tPhcinId=$p(^DHCOEInstrAttachOrd(tInattId),"^",1)
	   .s tPhcindesc=""
	   .i tPhcinId'="" s tPhcindesc=$p(^PHCIN(tPhcinId),"^",2)
	   .s tPhcfrId=$p(^DHCOEInstrAttachOrd(tInattId),"^",2)
	   .s tPhcfrdesc=""
	   .//q:tPhcfrId=""
	   .i tPhcfrId'="" s tPhcfrdesc=$p($g(^PHCFR(tPhcfrId)),"^",3)
	   .s tArcimId=$p(^DHCOEInstrAttachOrd(tInattId),"^",4)
	   .s tArcimdesc=""
	   . s subid=$p(tArcimId,"||",1),verid=$p(tArcimId,"||",2)
	   .s tArcimdesc=$p($g(^ARCIM(+subid,+verid,1)),"^",2)
	   .s tOrdqty=$p(^DHCOEInstrAttachOrd(tInattId),"^",5)
	   .s tType=$p(^DHCOEInstrAttachOrd(tInattId),"^",7)
	   .S NINATTDefaultID=$p(^DHCOEInstrAttachOrd(tInattId),"^",6)
	   .I NINATTDefaultID="Y" D
	   .. S NINATTDefault="Yes"
	   .e  d 
	   .. S NINATTDefault="No"
	   .. S NINATTDefaultID="N"
	   .s tExecLocId=$p(^DHCOEInstrAttachOrd(tInattId),"^",9)
	   .q:(ExecLocId'="")&(ExecLocId'=tExecLocId)
	   .i tExecLocId'="" s tExecLoc=$P($G(^CTLOC(tExecLocId)),"^",2)
	   .e  s tExecLoc=""
	   .i tExecLocId'="" s tmpLoc(tExecLocId,tInattId)=tInattId_"@"_tPhcinId_"@"_tPhcindesc_"@"_tPhcfrId_"@"_tPhcfrdesc_"@"_tArcimId_"@"_tArcimdesc_"@"_tOrdqty_"@"_tType_"@"_NINATTDefault_"@"_NINATTDefaultID_"@"_tExecLoc_"@"_tExecLocId
	   .e  s tmpLoc(0,tInattId)=tInattId_"@"_tPhcinId_"@"_tPhcindesc_"@"_tPhcfrId_"@"_tPhcfrdesc_"@"_tArcimId_"@"_tArcimdesc_"@"_tOrdqty_"@"_tType_"@"_NINATTDefault_"@"_NINATTDefaultID_"@"_tExecLoc_"@"_tExecLocId
	   .//d OutputRow
	s curLoc="" f  s curLoc=$O(tmpLoc(curLoc)) q:curLoc=""  d
	.s curId="" f  s curId=$O(tmpLoc(curLoc,curId)) q:curId=""  d
	..s tInattId=$P(tmpLoc(curLoc,curId),"@",1)
	..s tPhcinId=$P(tmpLoc(curLoc,curId),"@",2)
	..s tPhcindesc=$P(tmpLoc(curLoc,curId),"@",3)
	..s tPhcfrId=$P(tmpLoc(curLoc,curId),"@",4)
	..s tPhcfrdesc=$P(tmpLoc(curLoc,curId),"@",5)
	..s tArcimId=$P(tmpLoc(curLoc,curId),"@",6)
	..s tArcimdesc=$P(tmpLoc(curLoc,curId),"@",7)
	..s tOrdqty=$P(tmpLoc(curLoc,curId),"@",8)
	..s tType=$P(tmpLoc(curLoc,curId),"@",9)
	..s NINATTDefault=$P(tmpLoc(curLoc,curId),"@",10)
	..s NINATTDefaultID=$P(tmpLoc(curLoc,curId),"@",11)
	..s tExecLoc=$P(tmpLoc(curLoc,curId),"@",12)
	..s tExecLocId=$P(tmpLoc(curLoc,curId),"@",13)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tInattId,tPhcinId,tPhcindesc,tPhcfrId,tPhcfrdesc,tArcimId,tArcimdesc,tOrdqty,tType,NINATTDefault,NINATTDefaultID,tExecLoc,tExecLocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInstrAttachOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInstrAttachOrdExecute ]
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

ClassMethod FindInstrAttachOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInstrAttachOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindMasterItem(arcimdesc As %String, HospID = "") As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, arcimdesc As %String, HospID = "") As %Status
{
    // d ##class(%ResultSet).RunQuery("web.DHCOESet","FindMasterItem","手术","2")
 	Set repid=$I(^CacheTemp)
 	s ^tempsc("FindMasterItem")=$lb(arcimdesc, HospID )
 	If $g(ind)="" Set ind=1
    i (arcimdesc'="") s arcimdesc=$$ALPHAUP^SSUTIL4(arcimdesc)    
    
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s defHospID=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("ARC_ItmMast",HospID)
	..s hospFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ArcimDR,defHospID)
	..q:hospFlag'="Y"
	..s Flag=0
	..q:$g(^ARCIM(ArcimID,ArcimSubID,1))=""
	..s dateFrom=$p($p($G(^ARCIM(ArcimID,ArcimSubID,1)),"^",13),",",1)
	..s dateTo=$p($G(^ARCIM(ArcimID,ArcimSubID,7)),"^",1)
	..s h=+$h
	..s OrderOnItsOwn = $p($g(^ARCIM(ArcimID,ArcimSubID,7)),"^",13)
	..q:OrderOnItsOwn="N"
	..q:OrderOnItsOwn=""
	..q:(+dateFrom=0)||(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	..s ArcimDesc=$p($G(^ARCIM(ArcimID,ArcimSubID,1)),"^",2)
	..i ArcimDesc[arcimdesc s Flag=1
	..i Flag=0  d
	...s AlisDR=""
	...f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	....s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	....i AlisDesc[arcimdesc s Flag=1
	..i Flag=1 Do OutputRow5
	..//s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""))
	..//q:AlisDR=""
	..//s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..//s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..//s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..//q:ArcimDesc'[arcimdesc
	..//Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetInstruc() As %SQLQuery(CONTAINID = 1, ROWSPEC = "PHCIN_Desc1:%String,PHCIN_RowId:%Integer")
{
	select PHCIN_Desc1,PHCIN_RowId from PHC_Instruc
}

Query GetInstrucItem(phcindesc As %String) As %Query(ROWSPEC = "PHCINDesc:%String,PHCINRowId:%String")
{
}

ClassMethod GetInstrucItemExecute(ByRef qHandle As %Binary, phcindesc As %String) As %Status
{
	;s ^sctmpv1("GetInstrucItem") = phcindesc
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (phcindesc'="") s phcindesc=$$ALPHAUP^SSUTIL4(phcindesc)    
    
 	s ArcimID=0 
 	f  s ArcimID=$o(^PHCIN(ArcimID)) q:ArcimID=""  d
 	.s Flag = 0
	.s PHCINDesc = $p(^PHCIN(ArcimID),"^",2)
	.s PHCINRowId = ArcimID
	.i PHCINDesc[phcindesc s Flag=1
	.i Flag=1 d OutInstruc
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInstruc
	set Data=$lb(PHCINDesc,PHCINRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInstrucItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInstrucItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetInstrucItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInstrucItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFreq() As %SQLQuery(CONTAINID = 1, ROWSPEC = "PHCFR_Desc1:%String,PHCFR_RowId:%Integer")
{
    select PHCFR_Desc1,PHCFR_RowId from PHC_Freq
}

Query FindPHCType() As %Query(ROWSPEC = "PHCType:%String,PHCTypeId:%String,PHCDesc:%String")
{
}

ClassMethod FindPHCTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PHCTypeId="2",PHCType="D",PHCDesc="一天一次"
	d OutputRow2
	s PHCTypeId="1",PHCType="F",PHCDesc="频次"
	d OutputRow2
	s PHCTypeId="0",PHCType="N",PHCDesc="最大频次"
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(PHCType,PHCTypeId,PHCDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPHCTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPHCTypeExecute ]
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

ClassMethod FindPHCTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPHCTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepOEARCIM(arcimdesc As %String, ArcimId As %String)
{
	s flag="N"
	s InattId=0
	f  s InattId=$o(^DHCOEInstrAttachOrd(InattId)) q:InattId=""  d
	   .s tArcimId=$p($g(^DHCOEInstrAttachOrd(InattId)),"^",4)
	   .q:tArcimId=""
	   .i tArcimId=ArcimId s flag="Y"
	   .s tArcimdesc=""
	   .i tArcimId'="" s subid=$p(tArcimId,"||",1),verid=$p(tArcimId,"||",2)
	   .s tArcimdesc=$p(^ARCIM(subid,verid,1),"^",2)
	   .i tArcimdesc=arcimdesc s flag="Y"
	 q flag
}

ClassMethod InsertOEInstr(phcinId As %String, phcfrId As %String, arcimId As %String, ordqty As %String, type As %String, INATTDefault As %String, IneffectLoc As %String, ExecLocId As %String)
{
  ;w ##class(web.DHCOEInstrAttachOrd).InsertOEInstr("12","93","15||1","1","F")
    q:+phcinId=0 "用法不能为空!"
    q:arcimId="" "医嘱项不能为空!"
    q:+ordqty=0 "数量不能为空!"
    q:type="" "类型不能为空"
    q:+ExecLocId=0 "科室不能为空"
    
    s id=$o(^DHCOEInstrAttachOrd(0,"PhcinLoc",phcinId,ExecLocId,0))
    q:id'="" "病区内一个用法只能有一种配置!"
    k PLIST
	s IneffectLoc=$tr(IneffectLoc,"^","|")
	TSTART
	s PLIST(2)=phcinId
	s PLIST(3)=phcfrId
	s PLIST(5)=arcimId
	s PLIST(6)=ordqty
	s PLIST(7)=INATTDefault 
	s PLIST(8)=type
	s PLIST(9)=IneffectLoc
	s PLIST(10)=ExecLocId
	&SQL(insert into DHC_OE_InstrAttachOrd Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCOD
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateOEInstr(InattId As %String, phcinId As %String, phcfrId As %String, arcimId As %String, ordqty As %String, type As %String, INATTDefault As %String, IneffectLoc As %String, ExecLocId As %String)
{
  ;w ##class(web.DHCOEInstrAttachOrd).UpdateOEInstr("14","12","93","15||1","1","F")
	;w !,InattId_"^"_phcinId_"^"_phcfrId_"^"_arcimId_"^"_ordqty_"^"_type
	k PLIST 
	s IneffectLoc=$tr(IneffectLoc,"^","|")
	;&sql(select * into PLIST() from SQLUSER.DHC_ANC_MoniDataItem where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q 
	s PLIST(1)=InattId
	s PLIST(2)=phcinId
	s PLIST(3)=phcfrId
	s PLIST(5)=arcimId
	s PLIST(6)=ordqty
	s PLIST(7)=INATTDefault
	s PLIST(8)=type
	s PLIST(9)=IneffectLoc
	s PLIST(10)=ExecLocId
	&sql(update DHC_OE_InstrAttachOrd  Values PLIST() where INATT_RowId=:InattId)
 q SQLCODE
}

ClassMethod DeleteOEInst(InattId As %String)
{
	i InattId'="" d
	.&SQL(delete from SQLUSER.DHC_OE_InstrAttachOrd where INATT_RowId=:InattId)
	q SQLCODE
}

Query FindLookUpDefault() As %Query(ROWSPEC = "ANREDActive:%String,ActiveRowid:%String")
{
}

ClassMethod FindLookUpDefaultExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ActiveRowid="Y",ANREDActive="Yes"
	d OutputRow2
	s ActiveRowid="N",ANREDActive="No"
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ANREDActive,ActiveRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLookUpDefaultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLookUpDefaultExecute ]
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

ClassMethod FindLookUpDefaultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLookUpDefaultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 屏蔽科室
ClassMethod GetlocDet(rowId As %Library.String = "")
{
	q:rowId="" ""
	s locId=$p(^DHCOEInstrAttachOrd(rowId),"^",8)
	s locIdsDe=""
	f num=1:1:$l(locId,"|") d
    .s locIds=$p(locId,"|",num)
    .q:locIds=""
	.i locIdsDe="" s locIdsDe=..GetlocInfo(locIds)
	.e  s locIdsDe=locIdsDe_"^"_(..GetlocInfo(locIds))

	//i ctcpAnDoc'="" s retVal="SetElementValue('anadoc','andocid','"_$ZCVT(ctcpAnDoc,"O","JS")_"');"
	i locIdsDe'=""  d
	.s retVal="InitList('IneffectLocO','"_$ZCVT(locIdsDe,"O","JS")_"');"
    .&javascript<#(retVal)#>
    q
}

ClassMethod GetlocInfo(ctcpId As %Library.String = "")
{
	s retStr1="!"
	q:ctcpId="" retStr1
	s ctcpDesc=$P($G(^CTLOC(ctcpId)),"^",2)
	q:ctcpDesc="" retStr1
	s retStr1=ctcpDesc_"!"_ctcpId
	q retStr1
}

Query GetCtloc(desc) As %Query(ROWSPEC = "CTLOC_Desc:%String,CTLOC_RowId:%Integer")
{
}

ClassMethod GetCtlocExecute(ByRef qHandle As %Binary, desc) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)
	s locId=0 f  s locId=$o(^CTLOC(locId)) q:locId=""  d
	.s CTLOCDesc=$p(^CTLOC(locId),"^",2)
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s spell=$p(^CTLOC(locId),"^",43)
	.s comparCTLOCDesc=$$ALPHAUP^SSUTIL4(spell)
	.q:(desc'="")&&(comparCTLOCDesc'[desc)
	.s CTLOCType=$p(^CTLOC(locId),"^",13)
	.q:CTLOCType'="W"
	.d OutputRowGetCtloc
	Quit $$$OK
OutputRowGetCtloc
	set Data=$lb(CTLOCDesc,locId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocExecute ]
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

ClassMethod GetCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
