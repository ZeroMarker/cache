Import SQLUSER

Class web.DHCANCRoom Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCANCRoom","FindexeLoc","P")
Query FindexeLoc(BedType As %String) As %Query(ROWSPEC = "tOprId:%String,tOprCtLocId:%String,tOprCtLoc:%String,tOprCode:%String,tOprDesc:%String,tOprCtFloorId:%String,tOprCtTypeId:%String,tOprCtDefUseId:%String,tOprCtFloor:%String,tOprCtType:%String,tOprCtDefUse:%String,tOprAvailable:%String,tOprNotAvailReason:%String,tOprBedType:%String,tOprNotAvailReasonId:%String")
{
}

ClassMethod FindexeLocExecute(ByRef qHandle As %Binary, BedType As %String = "T") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tOprId=0
	f  s tOprId=$o(^DHCANC("OPRoom",tOprId))  q:tOprId=""  d
	.s tOprBedType=$p(^DHCANC("OPRoom",tOprId),"^",9) 
	.q:(BedType'="")&(tOprBedType'=BedType)
	.s tOprCode=$p(^DHCANC("OPRoom",tOprId),"^",1)
	.s tOprDesc=$p(^DHCANC("OPRoom",tOprId),"^",2)
	.s tOprCtLoc=""
	.s tOprCtFloor=""
	.s tOprCtType=""
	.s tOprCtDefLoc=""
	.s tOprCtFloorId=$p(^DHCANC("OPRoom",tOprId),"^",4)
	.s tOprCtFloor=$p($g(^DHCANC("Floor",+tOprCtFloorId)),"^",2)
	.s tOprCtTypeId=$p(^DHCANC("OPRoom",tOprId),"^",5)    //toptypeId
	.s tOprCtType=$p($g(^ORC("OTTYPE",+tOprCtTypeId)),"^",2)
	.s tOprCtDefUseId=$p(^DHCANC("OPRoom",tOprId),"^",6) //TDefUseCtlocId
	.s tOprCtDefUse=$p($g(^CTLOC(+tOprCtDefUseId)),"^",2)
	.s tOprCtLocId=$p(^DHCANC("OPRoom",tOprId),"^",3)
	.s tOprCtLoc=$p($g(^CTLOC(+tOprCtLocId)),"^",2)
	.s tOprAvailable=$p(^DHCANC("OPRoom",tOprId),"^",7)
	.s tOprNotAvailReasonId=$p(^DHCANC("OPRoom",tOprId),"^",8)
	.i tOprNotAvailReasonId'="" d
	..s tOprNotAvailReason=$p(^ORC("RNAV",+tOprNotAvailReasonId),"^",2) 
	.e  s tOprNotAvailReason=""
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tOprId,tOprCtLocId,tOprCtLoc,tOprCode,tOprDesc,tOprCtFloorId,tOprCtTypeId,tOprCtDefUseId,tOprCtFloor,tOprCtType,tOprCtDefUse,tOprAvailable,tOprNotAvailReason,tOprBedType,tOprNotAvailReasonId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeLocExecute ]
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

ClassMethod FindexeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*Query FindexeLocOfrcode(BedType As %String,rcode) As %Query(ROWSPEC = "TOPRRowid:%String,LocID:%String,TOPRCTLoc:%String,TOPRCode:%String,TOPRDesc:%String,FloorID:%String,TypeID:%String,DefUseID:%String,TOPRCTFloor:%String,TOPRCTType:%String,TOPRCTDefLoc:%String,TOPRAvailable:%String, TOPRNotAvailReason:%String,TOPRBedType:%String,TOPRNotAvailReasonID:%String")
{
}

ClassMethod FindexeLocOfrcodeExecute(ByRef qHandle As %Binary, BedType As %String,rcode) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s OPRowid=0
	f  s OPRowid=$o(^DHCANC("OPRoom",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("OPRoom",OPRowid),"^",1)
	.i (RCode=rcode) s TOPRRowid=OPRowid
	s TOPRBedType=$p(^DHCANC("OPRoom",TOPRRowid),"^",9) 
	q:TOPRBedType'=BedType
	s TOPRCode=$p(^DHCANC("OPRoom",TOPRRowid),"^",1)
    s TOPRDesc=$p(^DHCANC("OPRoom",TOPRRowid),"^",2)
	s TOPRCTLoc=""
	s TOPRCTFloor=""
	s TOPRCTType=""
	s TOPRCTDefLoc=""
	s FloorID=$p(^DHCANC("OPRoom",TOPRRowid),"^",4)
	s TOPRCTFloor=$p($g(^DHCANC("Floor",+FloorID)),"^",2)
	s TypeID=$p(^DHCANC("OPRoom",TOPRRowid),"^",5)    //toptypeId
	s TOPRCTType=$p($g(^ORC("OTTYPE",+TypeID)),"^",2)
	s DefUseID=$p(^DHCANC("OPRoom",TOPRRowid),"^",6) //TDefUseCtlocId
	s TOPRCTDefLoc=$p($g(^CTLOC(+DefUseID)),"^",2)
	s ctlocId=$p(^DHCANC("OPRoom",TOPRRowid),"^",3)
	s TOPRCTLoc=$p($g(^CTLOC(+ctlocId)),"^",2)
	s TOPRAvailable=$p(^DHCANC("OPRoom",TOPRRowid),"^",7)
	s TOPRNotAvailReasonID=$p(^DHCANC("OPRoom",TOPRRowid),"^",8)
	i TOPRNotAvailReasonID'="" s TOPRNotAvailReason=$p(^ORC("RNAV",TOPRNotAvailReasonID),"^",2) 
	e  s TOPRNotAvailReason=""
	d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TOPRRowid,ctlocId,TOPRCTLoc,TOPRCode,TOPRDesc,FloorID,TypeID,DefUseID,TOPRCTFloor,TOPRCTType,TOPRCTDefLoc,TOPRAvailable,TOPRNotAvailReason,TOPRBedType,TOPRNotAvailReasonID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeLocOfrcodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeLocOfrcodeExecute ]
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

ClassMethod FindexeLocOfrcodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeLocOfrcodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}
*/
ClassMethod RepOperRoom(oprCode As %String, oprDesc As %String)
{
	s opId=0
	s flag="N"
	f  s opId=$o(^DHCANC("OPRoom",opId)) q:(opId="")  d
	.s rCode=$p(^DHCANC("OPRoom",opId),"^",1)
	.s rDesc=$p(^DHCANC("OPRoom",opId),"^",2)
	.i (rCode=oprCode)||(rDesc=oprDesc) s flag="Y"
	q flag
}

ClassMethod InsertOperRoom(oprLocId As %String, oprCode As %String, oprDesc As %String, oprCtFloorId As %String, oprCtTypeId As %String, oprCtDefUseId As %String, oprAvailable As %String, oprNotAvailReasonId As %String, BedType As %String)
{
   
    //s ^TMPdd=oprLocId_"^"_oprCode_"^"_oprDesc_"^"_oprCtFloorId_"^"_oprCtTypeId_"^"_oprCtDefUseId_"^"_oprAvailable_"^"_oprNotAvailReasonId_"^"_BedType
	s objOperRoom=##class(User.DHCANCOperRoom).%New()
	s objOperRoom.OPRCtlocDr=oprLocId
	s objOperRoom.OPRCode=oprCode
	s objOperRoom.OPRDesc=oprDesc
	s oprCtFloorId=##class(User.DHCANCFloor).%OpenId(oprCtFloorId)
	s objOperRoom.OPRFloorDr=oprCtFloorId
	s objOperRoom.OPROTTypeDr=oprCtTypeId
	s objOperRoom.OPRDefUseCtlocDr=oprCtDefUseId
	s objOperRoom.OPRAvailable=oprAvailable
	s objOperRoom.OPRNotAvailReason=oprNotAvailReasonId
	s objOperRoom.OPRBedType=BedType
	s saveStatus=objOperRoom.%Save()
	q:(+saveStatus=0) 1
	s operRoomID=objOperRoom.%Id()
	d objOperRoom.%Close()
	q 0
}

ClassMethod UpdateOperRoom(oprId As %Integer, oprLocId As %Integer, oprCode As %Integer, oprDesc As %Integer, oprCtFloorId As %Integer, oprCtTypeId As %Integer, oprCtDefUseId As %Integer, oprAvailable As %Integer, oprNotAvailReasonId As %Integer, BedType As %Integer)
{
 	//s ^tmpYpz("operData")=oprId_"^"_oprLocId_"^"_oprCode_"^"_oprDesc_"^"_oprCtFloorId_"^"_oprCtTypeId_"^"_oprCtDefUseId_"^"_oprAvailable_"^"_oprNotAvailReasonId_"^"_BedType
  q:oprId="" "系统号不能为空！"
  q:oprLocId="" "手术室科室不能为空"
  q:oprCode="" "手术间代码不能为空"	
  q:oprDesc="" "手术间名称不能为空"
    s RowId=0,retStr=0
  f  s RowId=$o(^DHCANC("OPRoom",RowId)) q:(RowId="")!(retStr'=0)  d
	    .i oprCode=$p(^(RowId),"^",1)&(oprId'=RowId) s retStr="代码相同!"
	    .i oprDesc=$p(^(RowId),"^",2)&(oprId'=RowId) s retStr="描述重复!"
  q:retStr'=0 retStr 

  q:'##class(User.DHCANCOperRoom).%ExistsId(oprId) "表中无对应指针记录"
  s objOperRoom=##class(User.DHCANCOperRoom).%OpenId(oprId)
  s objOperRoom.OPRCtlocDr=oprLocId
  s objOperRoom.OPRCode=oprCode
  s objOperRoom.OPRDesc=oprDesc
  s oprCtFloor=##class(User.DHCANCFloor).%OpenId(oprCtFloorId)
  s objOperRoom.OPRFloorDr=oprCtFloor
  s objOperRoom.OPROTTypeDr=oprCtTypeId
  s objOperRoom.OPRDefUseCtlocDr=oprCtDefUseId
  s objOperRoom.OPRAvailable=oprAvailable
  s objOperRoom.OPRNotAvailReason=oprNotAvailReasonId
  s objOperRoom.OPRBedType=BedType
  s updateStatus=objOperRoom.%Save()
  q:(+updateStatus=0) "更新失败！"
  s operRoomId=objOperRoom.%Id()
  d objOperRoom.%Close()
  q 0
}

ClassMethod DeleteOperRoom(oprId As %String)
{
	s retStr=0
	i oprId'="" d
	.;k ^DHCANC("OPRoom",OPRRowid)
	.&SQL(delete from DHC_ANC_OperRoom  where OPR_RowId=:oprId)
	.i SQLCODE'=0 s retStr="删除手术间失败!"
	Q retStr
}

Query ctloclookup(desc As %String) As %Query(ROWSPEC = "oprCtLoc:%String,oprLocId:%String")
{
}

// d ##class(%ResultSet).RunQuery("web.DHCANCRoom","ctloclookup","WKSSS-外科手术室")

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode("OP^OUTOP^EMOP","")
	s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.q:'$d(^CTLOC(ctlocId))
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.q:(desc'="")&($p($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)),desc)'="")
		.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
 		.Do OutputRow4	 
 	i ctlocIdList="" d
		.s rowid=0
		.i $g(desc)=""  d
			..s desc="%"
		.e  d
			..s desc=desc_"%"
		.&sql(declare ctloc cursor  for select distinct CTLOC_RowId,CTLOC_Desc,CTLOC_Code,CTLOC_Hospital_DR->HOSP_Desc
	from SQLUser.CT_LOC WHERE (UPPER(CTLOC_Desc) like :desc))
		.&sql(open ctloc)
		.f  &sql(fetch ctloc into :ctlocId,:ctlocDesc,ctlocCode,:hospital) q:SQLCODE  d
			..Do OutputRow4 	
		.&sql(close ctloc)	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocDesc,ctlocId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query ctfloorlookup(desc As %String) As %Query(ROWSPEC = "oprCtFloor:%String,oprCtFloorId:%String")
{
}

ClassMethod ctfloorlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctfloor cursor  for 
	select distinct ancf_desc,ancf_rowid
	              from SQLUser.DHC_ANC_Floor 
	              WHERE (UPPER(ancf_desc) like :desc))
	&sql(open ctfloor)
	f  &sql(fetch ctfloor into :ancfdesc,:ancfrowid) q:SQLCODE  d
 	.Do OutputRow5	 	
 	&sql(close ctfloor)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow5
	set Data=$lb(ancfdesc,ancfrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctfloorlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctfloorlookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ctfloorlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctfloorlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query cttypelookup(desc As %String) As %Query(ROWSPEC = "oprCtType:%String,oprCtTypeId:%String")
{
}

ClassMethod cttypelookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare cttype cursor  for 
	select distinct ottype_desc,ottype_rowid
	              from SQLUser.ORC_OperTheatreType 
	              WHERE (UPPER(ottype_desc) like :desc))
	&sql(open cttype)
	f  &sql(fetch cttype into :ottypedesc,:ottyperowid) q:SQLCODE  d
 	.Do OutputRow6	 	
 	&sql(close cttype)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow6
	set Data=$lb(ottypedesc,ottyperowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod cttypelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctfloorlookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod cttypelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctfloorlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCANCRoom","ctdefuselookup","ck")

Query ctdefuselookup(desc As %String) As %Query(ROWSPEC = "oprCtLoc:%String,oprLocId:%String")
{
}

ClassMethod ctdefuselookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	s desc=##class(web.DHCClinicCom).GetChinaChar(desc)
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode("INOPDEPT","")
	s ctlocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
	s find=0
	f i=1:1:$l(ctlocIdList,"^") d
		.s ctlocId=$p(ctlocIdList,"^",i)
		.q:ctlocId=""
		.s ctlocrowid=ctlocId
		.q:'$d(^CTLOC(ctlocId))
		.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
		.q:(desc'="")&($p($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc)),desc)'="")
		.s ctlocCode=$p(^CTLOC(ctlocId),"^",1)
		.s find=1
		.Do OutputRow7
	i (find=0)!(ctlocIdList="") d
		.s ctlocrowid="" f  s ctlocrowid=$o(^CTLOC(ctlocrowid)) q:ctlocrowid=""  d
			..q:'$d(^CTLOC(ctlocrowid))
			..s ctlocDesc=$p(^CTLOC(ctlocrowid),"^",2)
			..q:(desc'="")&($$ALPHAUP^SSUTIL4(##class(web.DHCClinicCom).GetChinaChar(ctlocDesc))'[desc)
			..Do OutputRow7
			..
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow7
	set Data=$lb(ctlocDesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctdefuselookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ctdefuselookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query NotAvailReasonlookup() As %Query(ROWSPEC = "RNAVDesc:%String,RNAVRowID:%String")
{
}

ClassMethod NotAvailReasonlookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s RNAVRowID=0
 	f  s RNAVRowID=$o(^ORC("RNAV",RNAVRowID)) q:RNAVRowID=""  d
 	.s RNAVCode=$p($g(^ORC("RNAV",RNAVRowID)),"^",1)
 	.s RNAVDesc=$p($g(^ORC("RNAV",RNAVRowID)),"^",2)
 	.Do OutputRow	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK   
OutputRow
	set Data=$lb(RNAVDesc,RNAVRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NotAvailReasonlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NotAvailReasonlookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod NotAvailReasonlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NotAvailReasonlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Availablelookup() As %Query(ROWSPEC = "AvailableCode:%String,AvailableDesc:%String")
{
}

ClassMethod AvailablelookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s AvailableCode="Y"
 	s AvailableDesc="可用"
 	Do OutputRow	 	
 	s AvailableCode="N"
 	s AvailableDesc="不可用"
 	Do OutputRow	 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK   
OutputRow
	set Data=$lb(AvailableCode,AvailableDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod AvailablelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AvailablelookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AvailablelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AvailablelookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query BedTypelookup() As %Query(ROWSPEC = "BedTypeCode:%String,BedTypeDesc:%String")
{
}

ClassMethod BedTypelookupExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s BedTypeCode="T"
 	s BedTypeDesc="Theatre"
 	Do OutputRow	 	
 	s BedTypeCode="P"
 	s BedTypeDesc="PACU"
 	Do OutputRow	
 	s BedTypeCode="I"
 	s BedTypeDesc="Induce"
 	Do OutputRow	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK   
OutputRow
	set Data=$lb(BedTypeCode,BedTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod BedTypelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BedTypelookupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BedTypelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BedTypelookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindOperRoomList() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   OPR_Code As Code,
	   OPR_Desc As Description,
	   OPR_Floor_Dr As FloorId,
	   OPR_Floor_Dr->ANCF_Code As FloorCode,
	   OPR_Floor_Dr->ANCF_Desc As FloorDescription,
	   OPR_Ctloc_Dr As DefaultSurgeonDeptId,
	   OPR_Available As Available
	   FROM DHC_ANC_OperRoom
}

/// Creator：      	陈长青
/// CreatDate：    	2015-04-05
/// Description： 	根据手术科室ID查询手术间
/// Table：        	DHC_ANC_OperRoom
/// Input：        	locId:手术科室ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("web.DHCANStatistics","FindOperRoomForLoc","")
Query FindOperRoomForLoc(locId As %String) As %Query(ROWSPEC = "OperRoomId:%String,OperRoomDesc:%String,OperLocId:%String") [ SqlProc ]
{
}

ClassMethod FindOperRoomForLocExecute(ByRef qHandle As %Binary, locId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	set operRoomId=0
	for
	{
		set operRoomId=$order(^DHCANC("OPRoom",operRoomId))
		quit:(operRoomId="")
		set operLocId=$piece(^DHCANC("OPRoom",operRoomId),"^",3)
		continue:(operLocId'=locId)
		set operRoomDesc=$piece(^DHCANC("OPRoom",operRoomId),"^",2)	
		do OutputRow
	}
	
	set operRoomId=""
	set operRoomDesc=""
	do OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow
	Set Data=$lb(operRoomId,operRoomDesc,locId)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindOperRoomForLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperRoomForLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOperRoomForLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperRoomForLocExecute ]
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

/// Creator：      	ypz
/// CreatDate：    	2015-06-16
/// Description： 	通过日期获取科室手术日
/// Table：        	
/// Input：        	开始日期、结束日期、申请科室ID(为空查全院)
/// Return：       	科室Id，科室名称，手术日累计
/// d ##class(%ResultSet).RunQuery("web.DHCANCRoom","FindSurgeryDay","2015-06-01","2015-06-18","")
Query FindSurgeryDay(fromDate As %String, toDate As %String, needDeptGroupId As %String = "") As %Query(ROWSPEC = "LocId,LocDesc,OperDate,OperDayNum") [ SqlProc ]
{
}

ClassMethod FindSurgeryDayExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, needDeptGroupId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCANCRoom","FindSurgeryDay",$h-2,$h)
	//web.DHCANCRoom.GetOperRoomDay($h-5,$h)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if (needDeptGroupId=$c(0)) set needDeptGroupId=""
	s fromDateH=##Class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDateH=##Class(web.DHCClinicCom).ConvertToDateH(toDate)
	k deptGroupList
	if (+needDeptGroupId<=0)
	{
		s surgeryDayId=0,locCount=0
		for
		{
			set surgeryDayId=$order(^DHCANC("OPRoomDay",surgeryDayId))
			quit:(surgeryDayId="")
			set deptGroupId=$lg(^DHCANC("OPRoomDay",surgeryDayId),3)
			continue:(+deptGroupId<=0)
			set deptGroupList(+deptGroupId)=""	
		}	
	}

	for i=fromDateH:1:toDateH
	{
		set operDate=##Class(web.DHCClinicCom).ConvertToDate(i)
		if (+needDeptGroupId>0)
		{
			set dayNum=..GetOperDay(operDate,needDeptGroupId)
			continue:(+dayNum<=0)
			set deptGroupId=needDeptGroupId
			set depGroupDesc=$piece($get(^RBC("DEP",deptGroupId)),"^",2)
			do OutputSurgeryLocDay
		}
		else
		{
			set deptGroupId=0
			for
			{
				set deptGroupId=$o(deptGroupList(deptGroupId))
				quit:(deptGroupId="")
				set dayNum=..GetOperDay(operDate,deptGroupId)
				continue:(+deptGroupId<=0)!(+dayNum<=0)
				set depGroupDesc=$piece($get(^RBC("DEP",deptGroupId)),"^",2)
				do OutputSurgeryLocDay	
			}	
		}	
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputSurgeryLocDay
	Set Data=$lb(deptGroupId,depGroupDesc,operDate,dayNum)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindSurgeryDayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSurgeryDayExecute ]
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

ClassMethod FindSurgeryDayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSurgeryDayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 取按日期取科室手术日，needLocId为空取全院手术日

ClassMethod GetOperDay(date As %String, needDeptGroupId As %String = "") As %String
{
	//w ##Class(web.DHCANCRoom).GetOperDay($h,"")
	s date=##Class(web.DHCClinicCom).ConvertToDateH(date)
	s weekDay=$zd(date,10)
	//w "weekDay="_weekDay,!
	s oprdId=0,sum=0
	f  s oprdId=$o(^DHCANC("OPRoomDay",0,"Day",weekDay,oprdId)) q:oprdId=""  d
		.q:'$d(^DHCANC("OPRoomDay",oprdId))
		.s deptGroupId=$lg(^DHCANC("OPRoomDay",oprdId),3)
		.q:(needDeptGroupId'="")&(needDeptGroupId'=deptGroupId)
		.//w oprdId,!
		.s sum=sum+$lg(^DHCANC("OPRoomDay",oprdId),5)
	q sum
}

// d ##class(%ResultSet).RunQuery("web.DHCANCRoom","FindLocationListByGroup","")

Query FindLocationListByGroup(groupId) As %Query(ROWSPEC = "LocId,LocCode,LocDesc") [ SqlProc ]
{
}

ClassMethod FindLocationListByGroupExecute(ByRef qHandle As %Binary, groupId) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	if (groupId=$c(0)) set groupId=""
 	if (+groupId<=0)
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK  	
	}
 	if (+groupId>0)&($data(^CTLOC(0,"DepGrp",groupId)))
 	{
	 	set locId=0
 		for
 		{
			set locId=$order(^CTLOC(0,"DepGrp",groupId,locId))
			quit:(locId="")
			set locCode=$piece($get(^CTLOC(locId)),"^",1)
			set locDesc=$piece($get(^CTLOC(locId)),"^",2)
			Do OutputRow 		
		}	
	}
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK   
OutputRow
	set Data=$lb(locId,locCode,locDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocationListByGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocationListByGroupExecute ]
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
 	Else      {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocationListByGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocationListByGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CheckValidData(desc, id)
{
	q:(id="")&(desc="") 1
	q:+id'>0 0
	q:$d(^CTLOC(id))<1 0
	s curDesc=$p(^CTLOC(id),"^",2)
	q:curDesc'=desc 0
	q 1
}

Storage Default
{
<Data name="DHCANCRoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCANCRoomD</DataLocation>
<DefaultData>DHCANCRoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCANCRoomD</IdLocation>
<IndexLocation>^web.DHCANCRoomI</IndexLocation>
<StreamLocation>^web.DHCANCRoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
