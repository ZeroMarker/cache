Import SQLUSER

Class web.DHCICUBedEquip Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 子表

// d ##class(%ResultSet).RunQuery("web.DHCICUBedEquip","FindexeBed","","")

// 20160809

Query FindexeBed(BedRowid As %String = "", TInterface As %String = "") As %Query(ROWSPEC = "TRowid:%String,TBedRowid:%String,TBed:%String,TEquipRowid:%String,TEquip:%String,TDefaultInterval:%String,TInterfaceProgram:%String,TPort:%String,TTcpipAddress:%String,TEditTcpipAddress:%String,TWardDesc:%String,TWardId:%String,TInterfaceProgramID:%String,TStat:%String") [ SqlProc ]
{
}

ClassMethod FindexeBedExecute(ByRef qHandle As %Binary, BedRowid As %String = "", TInterface As %String = "") As %Status
{
 	s ^tmpicudebug("FindexeBedExecute")=BedRowid_"   "_$h
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set BedRowid=$g(BedRowid)
	s TRowid=0
	f  s TRowid=$o(^DHCICUBedEquip(TRowid))  q:TRowid=""  d
		.
		.s TTcpipAddress=$p($g(^DHCICUBedEquip(TRowid)),"^",3)
		.s TPort=$p($g(^DHCICUBedEquip(TRowid)),"^",4)
		.s TInterfaceProgramID=$p($g(^DHCICUBedEquip(TRowid)),"^",5)
		.q:(TInterface'="")&(TInterfaceProgramID'=TInterface)
		.s TInterfaceProgram=$p($g(^DHCANC("CType",+TInterfaceProgramID)),"^",2)
		.s TDefaultInterval=$p($g(^DHCICUBedEquip(TRowid)),"^",6)
	    .s TBedRowid=$p($g(^DHCICUBedEquip(TRowid)),"^",1)
	    .i TBedRowid=$c(0) s TBedRowid=""
	    .q:(TBedRowid="")||((BedRowid'="")&(BedRowid'=TBedRowid))
	    .s wardId=$p($g(TBedRowid),"||",1)
	    .s childsub=$p($g(TBedRowid),"||",2)
	    .q:(wardId="")!(childsub="")
	    .s TWardDesc=$$GetWardDesc(wardId)
	    .s TBed=$$GetBedDesc(TBedRowid)
		.s TEquipRowid=$p($g(^DHCICUBedEquip(+TRowid)),"^",2)
		.s TEquip=""
		.i TEquipRowid'="" s TEquip=$p($g(^DHCEQEquip(TEquipRowid)),"^",1)
		.s TEditTcpipAddress=$p($g(^DHCICUBedEquip(TRowid)),"^",7)
		.s TStat=$p($g(^DHCICUBedEquip(TRowid)),"^",8)
		.d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(TRowid,TBedRowid,TBed,TEquipRowid,TEquip,TDefaultInterval,TInterfaceProgram,TPort,TTcpipAddress,TEditTcpipAddress,TWardDesc,wardId,TInterfaceProgramID,TStat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetBedDesc(TBedRowid)
	q:TBedRowid="" ""
	s wardId=$p($g(TBedRowid),"||",1)
	s childsub=$p($g(TBedRowid),"||",2)
	q:childsub="" ""
	s TBed=$p($g(^PAWARD(wardId,"BED",childsub)),"^",1)
	q TBed
GetWardDesc(wardId)
	q:wardId="" ""
	s TWardDesc=$p($g(^PAWARD(wardId)),"^",2)
	q TWardDesc
}

ClassMethod FindexeBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeBedExecute ]
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

ClassMethod FindexeBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod InsertBedEquip(BedRowid As %String, EquipRowid As %String, TcpipAddress As %String, Port As %String, InterfaceProgram As %String, DefaultInterval As %String, EditTcpipAddress As %String)
{
	s Rowid=0
	s InterfaceProgram=$g(InterfaceProgram)
	s InterfaceProgram=$$ALPHAUP^SSUTIL4(InterfaceProgram)
	s frist=$e(InterfaceProgram,1)
	s str="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	;i $f(str,frist)<=0 q 100  //该字段必须是英文字母型 现在存ID
	
	s cld="" s retStr=""
	i BedRowid="" s BedRowid=$c(0)
	f  s cld=$O(^DHCICUBedEquip(0,"Bed",BedRowid,cld)) q:cld=""  d
		.q:Rowid=cld
		.s port=$p(^DHCICUBedEquip(cld),"^",4)
		.s devType=$p(^DHCICUBedEquip(cld),"^",5)
		.s ipAdress=$p(^DHCICUBedEquip(cld),"^",3)
		.;b "aa"
		.i port=Port s retStr="端口重复" q
		.i devType=InterfaceProgram s retStr="设备重复" q	
		.;i (ipAdress=TcpipAddress)&(port=Port)  s retStr="添加失败：数据完全相同" q
	i retStr'="" q retStr
	
	k PLIST
	s EquipRowid=""
	TSTART
	s PLIST(2)=BedRowid
	s PLIST(3)=EquipRowid
	s PLIST(4)=TcpipAddress  
	s PLIST(5)=Port
	s PLIST(6)=InterfaceProgram
	s PLIST(7)=DefaultInterval
	s PLIST(8)=EditTcpipAddress
	&SQL(insert into DHC_ICU_BedEquip Values :PLIST())
	i SQLCODE
	{	TROLLBACK
	}
	else {	TCOMMIT}
	q SQLCODE
}

ClassMethod DeleteBedEquip(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from DHC_ICU_BedEquip where ICUBE_RowId=:Rowid)
	q SQLCODE
}

ClassMethod UpdateBedEquip(Rowid As %String, BedRowid As %String, EquipRowid As %String, TcpipAddress As %String, Port As %String, InterfaceProgram As %String, DefaultInterval As %String, EditTcpipAddress As %String)
{
	;s ^TMPDEBUG("dtj","UpdateBedEquip")="Rowid:"_Rowid_"BedRowid:"_BedRowid_Port_InterfaceProgram
	;&sql(SELECT COUNT(*) INTO :count from DHC_ICU_BedEquip where ICUBE_Bed_Dr=:BedRowid and (ICUBE_InterfaceProgram=:InterfaceProgram or ICUBE_Port=:Port))
	;i count>0 q "设备和端口号不能重复" ;_count_","_BedRowid_","_InterfaceProgram_","_Port
	;i count>0 q "设备和端口号不能重复" ;_count_","_BedRowid_","_InterfaceProgram_","_Port
	
	s cld="" s retStr=""
	i BedRowid="" s BedRowid=$c(0)
	f  s cld=$O(^DHCICUBedEquip(0,"Bed",BedRowid,cld)) q:cld=""  d
	.q:Rowid=cld
	.s port=$p(^DHCICUBedEquip(cld),"^",4)
	.s devType=$p(^DHCICUBedEquip(cld),"^",5)
	.;b "aa"
	.;i port=Port s retStr="端口重复" q
	.;i devType=InterfaceProgram s retStr="设备重复" q
	
	s EquipRowid=+EquipRowid
	i EquipRowid=0 s EquipRowid=""
	i retStr'="" q retStr
	b
	k PLIST 
	TSTART
	s PLIST(1)=Rowid
	s PLIST(2)=BedRowid
	s PLIST(3)=EquipRowid
	s PLIST(4)=TcpipAddress  
	s PLIST(5)=Port
	s PLIST(6)=InterfaceProgram
	s PLIST(7)=DefaultInterval
	s PLIST(8)=EditTcpipAddress
	&sql(update DHC_ICU_BedEquip Values :PLIST() where ICUBE_RowId=:Rowid)
	i SQLCODE
	{	TROLLBACK
	}
	else {	TCOMMIT}
	;s ^TMPDEBUG("dtj","UpdateBedEquip")=Rowid_","_BedRowid_","_EquipRowid_","_TcpipAddress_","_Port_","_InterfaceProgram_","_DefaultInterval_","_EditTcpipAddress
	q SQLCODE
}

ClassMethod RepBedEquip(EquipRowid As %String, RowidCur As %String)
{
	s Rowid=0
	s flag="N"
	f  s Rowid=$o(^DHCICUBedEquip(Rowid)) q:Rowid=""  d
	.s EquipDr=$p($g(^DHCICUBedEquip(Rowid)),"^",2)
	.i (EquipRowid=EquipDr)&(RowidCur'=Rowid) s flag="Y"
	q flag
}

Query FindEquip(DESC As %String) As %Query(ROWSPEC = "EquipDesc:%String,EquipRowid:%String") [ SqlProc ]
{
}

ClassMethod FindEquipExecute(ByRef qHandle As %Binary, DESC As %String) As %Status
{
   
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s EquipRowid=0
	f  s EquipRowid=$o(^DHCEQEquip(EquipRowid))  q:EquipRowid=""  d
	.s EquipDesc=$p(^DHCEQEquip(EquipRowid),"^",1)
	.q:EquipDesc'[DESC
	.d OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(EquipDesc,EquipRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEquipExecute ]
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

ClassMethod FindEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBed(BedRowid As %String) As %Query(ROWSPEC = "RoomDesc:%String,RoomRowid1:%String") [ SqlProc ]
{
}

ClassMethod FindBedExecute(ByRef qHandle As %Binary, wardId As %String) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i wardId'=""  d
	.s childsub=0
	.f  s childsub=$o(^PAWARD(wardId,"BED",childsub))  q:childsub=""  d
	..s RoomDesc=$p(^PAWARD(wardId,"BED",childsub),"^",1)
	..s RoomRowid1=wardId_"||"_childsub
	..d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RoomDesc,RoomRowid1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedExecute ]
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

ClassMethod FindBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Findward(needWardDesc As %String) As %Query(ROWSPEC = "wardDesc:%String,wardRowid:%String") [ SqlProc ]
{
}

ClassMethod FindwardExecute(ByRef qHandle As %Binary, needWardDesc As %String) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s needWardDesc=$$ALPHAUP^SSUTIL4(needWardDesc)
	s wardRowid=0
	f  s wardRowid=$o(^PAWARD(wardRowid))  q:wardRowid="BED_BedType_DR"  d
    .s wardDesc=$p(^PAWARD(wardRowid),"^",2)
    .s locId=+$p(^PAWARD(wardRowid),"^",5)
    .s locAlias=$p($g(^CTLOC(locId)),"^",43)
    .q:($$ALPHAUP^SSUTIL4(wardDesc)'[needWardDesc)&&(locAlias'[needWardDesc)
    .s wardRowid1=wardRowid
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(wardDesc,wardRowid1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindwardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindwardExecute ]
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

ClassMethod FindwardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindwardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBedEquipDetail(BedEquipRowid As %String) As %Query(ROWSPEC = "TRowid:%String,TMDIDesc:%String,TANREDActive:%String,TChannelNo:%String,TMDIRowid:%String,TBedEquipDesc:%String,TBedEquipRowid:%String,TEquipRowid:%String") [ SqlProc ]
{
}

ClassMethod FindBedEquipDetailExecute(ByRef qHandle As %Binary, BedEquipRowid As %String) As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.DHCANRoomEquipDetail","FindRoomEquipDetail","31")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i BedEquipRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	   s TEquipRowid=$p($g(^DHCICUBedEquip(BedEquipRowid)),"^",2)
	   s TBedEquipDesc=""
	   i TEquipRowid'="" s TBedEquipDesc=$p($g(^DHCEQEquip(TEquipRowid)),"^",1)
	   s ChildSub=0 
	   f  s ChildSub=$o(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub)) q:ChildSub=""  d
	      .s TMDIRowid=$p(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub),"^",1)
	      .s TMDIDesc=""
	      .i TMDIRowid'="" s TMDIDesc=$p($g(^DHCICUC("RecordItem",TMDIRowid)),"^",2)
	      .s TANREDActive=$p(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub),"^",2)
          .s TChannelNo=$p(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub),"^",3)
	      .s TRowid=BedEquipRowid_"||"_ChildSub
	      .s TBedEquipRowid=BedEquipRowid
	      .d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,TMDIDesc,TANREDActive,TChannelNo,TMDIRowid,TBedEquipDesc,TBedEquipRowid,TEquipRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedEquipDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedEquipDetailExecute ]
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

ClassMethod FindBedEquipDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedEquipDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindMoniDataItem(filter As %String) As %Query(ROWSPEC = "MDIDesc:%String,MDIRowid:%String,MDICode:%String") [ SqlProc ]
{
}

ClassMethod FindMoniDataItemExecute(ByRef qHandle As %Binary, filter As %String) As %Status
{
	k ^TMPDEBUG
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s MDIRowid=0
	f  s MDIRowid=$o(^DHCICUC("RecordItem",MDIRowid)) q:MDIRowid=""  d
	   .;q:$p(^DHCICUC("RecordItem",MDIRowid),"^",3)'="V"
	   .s str=$g(^DHCICUC("RecordItem",MDIRowid))
	   .q:str=""
	   .s rowid=$p(str,"^",5)
	   .s MDIDesc=$p(str,"^",2)
	   .s MDICode=$p(str,"^",1)
	   .
	   .s isIcuApply="Y",isAnApply="Y"
	   .s isAnApply=$p(str,"^",9)
	   .
	   .s isIcuApply=$p(str,"^",10)
	   .q:(isIcuApply'="Y")
	   .s MDIDesc=$$UPPER^SSUTIL4(MDIDesc)
	   .s filter=$$UPPER^SSUTIL4(filter)
	   .i MDIDesc[filter d OutputRow1	
	   .e  i MDICode[filter d OutputRow1	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(MDIDesc,MDIRowid,MDICode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMoniDataItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMoniDataItemExecute ]
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

ClassMethod FindMoniDataItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMoniDataItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindANREDActive() As %Query(ROWSPEC = "ANREDActive:%String,ActiveRowid:%String") [ SqlProc ]
{
}

ClassMethod FindANREDActiveExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ActiveRowid="1",ANREDActive="Y"
	d OutputRow2
	s ActiveRowid="0",ANREDActive="N"
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ANREDActive,ActiveRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANREDActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANREDActiveExecute ]
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

ClassMethod FindANREDActiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANREDActiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepMoniDataItemDesc(BedEquipRowid As %String, MDIDesc As %String)
{
    ;w ##class(web.DHCANRoomEquipDetail).RepMoniDataItemDesc("31","脉搏")
    s flag="N"
	s ChildSub=0 
	   f  s ChildSub=$o(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub)) q:ChildSub=""  d
	      .s TMDIRowid=$p(^DHCICUBedEquip(BedEquipRowid,"I",ChildSub),"^",1)
	      .s TMDIDesc=""
	      .i TMDIRowid'="" s TMDIDesc=$p($g(^DHCICUC("RecordItem",TMDIRowid)),"^",2)
	      .i TMDIDesc=MDIDesc   s flag="Y"
	q flag
}

ClassMethod InsertMoniDataItem(BedEquipRowid As %String, MDIRowid As %String, ANREDActive As %String, ChannelNo As %String)
{
	k PLIST
	TSTART
	;w ##class(web.DHCANRoomEquipDetail).InsertMoniDataItem("31","18","Y","11")
	s PLIST(0)=BedEquipRowid
	s PLIST(3)=MDIRowid
	s PLIST(4)=ANREDActive
	s PLIST(5)=ChannelNo
	&SQL(insert into SQLUSER.DHC_ICU_BedEquipDetail Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateMoniDataItem(Rowid As %String, BedEquipRowid As %String, MDIRowid As %String, ANREDActive As %String, ChannelNo As %String)
{
   ;w ##class(web.DHCANRoomEquipDetail).UpdateMoniDataItem("31||5","31","12","N","11")
	k PLIST 
	;&sql(select * into :PLIST() from SQLUSER.DHC_ICU_BedEquipDetail where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q
	s PLIST(0)=BedEquipRowid
	s PLIST(1)=Rowid
	s PLIST(3)=MDIRowid
	s PLIST(4)=ANREDActive
	s PLIST(5)=ChannelNo
	&sql(update SQLUSER.DHC_ICU_BedEquipDetail Values :PLIST() where ICUBED_RowId=:Rowid)
 q SQLCODE
}

ClassMethod DeleteMoniDataItem(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_ICU_BedEquipDetail where ICUBED_RowId=:Rowid)
	q SQLCODE
}

ClassMethod SetDefault(bedRowid As %String)
{
	s ^TMPDEBUG("SetDefault")=bedRowid
	s cld=""
	i bedRowid'="" d
	.k ^TMPDEBUG("Default",bedRowid)
	.f  s cld=$o(^DHCICUBedEquip(0,"Bed",bedRowid,cld)) q:cld=""  d
	..s ^TMPDEBUG("Default",bedRowid,cld)=^DHCICUBedEquip(cld)
	q "0"
}

ClassMethod RecoveryDefault(bedRowid As %String)
{
	s ^TMPDEBUG("RecoveryDefault")=bedRowid_":"_$ztime($p($h,"^",2))
	s cld=""
	i bedRowid'="" d
	.&SQL(delete from DHC_ICU_BedEquip where ICUBE_Bed_Dr=:bedRowid)
	.f  s cld=$o(^TMPDEBUG("Default",bedRowid,cld)) q:cld=""  d
	..s rowStr=^TMPDEBUG("Default",bedRowid,cld)
	..s devIp=$p(rowStr,"^",3)
	..s port=$p(rowStr,"^",4)
	..s devType=$p(rowStr,"^",5)
	..s sti=$p(rowStr,"^",6)
	..s pcIP=$p(rowStr,"^",7)
	..
	..s ret=..UpdateBedEquip(cld,bedRowid,"",devIp,port,devType,sti,pcIP)
	..i ret'=0 d
	...
	...d ..InsertBedEquip(bedRowid,"",devIp,port,devType,sti,pcIP)
	q 0
}

ClassMethod GetConfirmedTime()
{
	s min=+$g(^DHCCLSet("ICU","ConfirmedTime"))
	q min
}

ClassMethod SetConfirmedTime(min As %String)
{
	s ^DHCCLSet("ICU","ConfirmedTime")=min
	q "0"
}

// 协和医院：血气设备

// 启动共享数据

// w ##class(web.DHCICUBedEquip).StartShareDev()

ClassMethod StartShareDev() As %String
{
	// s ^DHCCLSet("ShareDev",1)="S^1^10.160.16.30^4001^5000^ABL800^"
	// source^equipId^IP^Port^STI^InterfaceProgram^ExtInfo
	s sub="" , retStr="DoNothing"
	f  s sub=$O(^DHCCLSet("ShareDev",sub)) q:sub=""  d
	.s item=^DHCCLSet("ShareDev",sub)
	.s source=$p(item,"^",1)
	.s equipId=$p(item,"^",2)
	.s IP=$p(item,"^",3)
	.s port=$p(item,"^",4)
	.s sti=$p(item,"^",5)
	.s interfaceProgram=$p(item,"^",6)
	.s extInfo=$p(item,"^",7)
	.;启动共享设备
	.s objDeviceServer=##class(web.DHCEKGService.OAICUDevSrvSoap).%New() 
    .;采集服务IP
    .s mIP=$g(^DHCCLSet("MSrvIP")) 
    .i mIP'="" d
    ..s locStr=objDeviceServer.Location
    ..s $p(locStr,"/",3)=mIP
    ..s objDeviceServer.Location=locStr
    ..s retStr=objDeviceServer.Start("", "", equipId, source, "", IP, port, sti, interfaceProgram, extInfo)
    ..
    ..i $p(retStr,"^")="SUCCESS" s retStr=0
    ..i $p(retStr,"^")="FAILED" s retStr="设备服务未启动! 请联系信息中心!"
    ..i $p(retStr,"^")="Unstarted" s retStr="设备未启动! 请检查监护仪输出网线连接,终端服务器电源!"
    ..i $p(retStr,"^")="INVALID" s retStr="启动设备参数错! 请联系系统管理人员!"
    ..i $p(retStr,"^")="STOP" s retStr="设备状态停止! 请检查监护仪输出网线连接,终端服务器电源!"
    ..i $p(retStr,"^")="SUSPEND" s retStr="设备状态为暂停! "
    .d objDeviceServer.%Close()
    q retStr
}

ClassMethod ModifyStat(equipId As %String, icuaId As %String, stat As %String)
{
	// w ##class(web.DHCICUBedEquip).ModifyStat(60,115,"Y")
	s retStr=""
	s eqItem=$g(^DHCICUBedEquip(equipId))
	q:eqItem="" "未找到："_equipId

	i stat'="N" s stat="Y"

	
	s interval=$p(eqItem,"^",3)
	s IP=$p(eqItem,"^",6)
	s port=$p(eqItem,"^",6)
	
	s source="I",interval=0,devType="",devTypeId="",extInfo=""
	s IP=$p($g(eqItem),"^",3)
	s port=$p($g(eqItem),"^",4)
	s devTypeId=$p($g(eqItem),"^",5)
	s interval=+$p($g(eqItem),"^",6)
	i +interval=0 s interval=300
	s interval=interval*1000
	
	i devTypeId=+devTypeId d
	.i $d(^DHCANC("CType",devTypeId)) s devType=$p($g(^DHCANC("CType",devTypeId)),"^",1)
	.q:devType'=""
	.s devType=$p($g(^DHCANC("EquipTypeCode",devTypeId)),"^",2)
	e  s devType=devTypeId
	s $p(^DHCICUBedEquip(equipId),"^",8)=stat
	i stat="N" d
	.;停止设备
	.s cmd="StopEq"
	e  d
	.;启动设备
	.s cmd="StartEq"
	
	s retStr=##class(web.DHCCLDevTool).ExcuteDevTask(source,equipId,"",icuaId,"",IP,port,interval,devType,extInfo,cmd)
	
	q retStr
}

}
