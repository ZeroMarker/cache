Import SQLUSER

Class web.DHCANRoomEquip Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 主表

Query FindexeRoom(RoomRowid As %String) As %Query(ROWSPEC = "TRowid:%String,TRoomRowid:%String,TRoom:%String,TEquipRowid:%String,TEquip:%String,TDefaultInterval:%String,TInterfaceProgram:%String,TPort:%String,TTcpipAddress:%String,TUserIPAddress:%String,TInterfaceProgramRowid:%String")
{
}

ClassMethod FindexeRoomExecute(ByRef qHandle As %Binary, RoomRowid As %String) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
 	Set RoomRowid=$g(RoomRowid)
	s TRowid=0
	f  s TRowid=$o(^DHCANRoomEquip(TRowid))  q:TRowid=""  d
	.s TTcpipAddress=$p($g(^DHCANRoomEquip(TRowid)),"^",3)
	.s TPort=$p($g(^DHCANRoomEquip(TRowid)),"^",4)
	.s TInterfaceProgram=""
	.s TInterfaceProgramRowid=$p($g(^DHCANRoomEquip(TRowid)),"^",5)
	.i TInterfaceProgramRowid'=""  s TInterfaceProgram=$p($g(^DHCANC("CType",TInterfaceProgramRowid)),"^",2)
	.s TDefaultInterval=$p($g(^DHCANRoomEquip(TRowid)),"^",6)
    .s TRoomRowid=$p($g(^DHCANRoomEquip(TRowid)),"^",1)
    .q:(TRoomRowid="")||((RoomRowid'="")&(RoomRowid'=TRoomRowid))
    .s TRoom=$p($g(^DHCANC("OPRoom",TRoomRowid)),"^",2)
	.;s TEquipRowid=$p($g(^DHCANRoomEquip(TRowid)),"^",2)
	.;s TEquip=$p($g(^DHCEQEquip(TEquipRowid)),"^",1)
	.s TUserIPAddress=$p($g(^DHCANRoomEquip(TRowid)),"^",7)
	.d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //ResetVariablesIFD
	//s (TRowid,TRoom,TEquip,TDefaultInterval,TInterfaceProgram,TPort,TTcpipAddress)=""
	//quit
OutputRow1
	set Data=$lb(TRowid,TRoomRowid,TRoom,TEquipRowid,TEquip,TDefaultInterval,TInterfaceProgram,TPort,TTcpipAddress,TUserIPAddress,TInterfaceProgramRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeRoomExecute ]
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

ClassMethod FindexeRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod Insert(RoomRowid As %String, EquipRowid As %String, TcpipAddress As %String, Port As %String, InterfaceProgram As %String, DefaultInterval As %String, UserIPAdress As %String)
{
    s ^temp("0422",1)=RoomRowid_"^"_EquipRowid_"^"_TcpipAddress_"^"_Port_"^"_InterfaceProgram_"^"_DefaultInterval_"^"_UserIPAdress
	s Rowid=0
	s InterfaceProgram=$g(InterfaceProgram)
	s InterfaceProgram=$$ALPHAUP^SSUTIL4(InterfaceProgram)
	s frist=$e(InterfaceProgram,1)
	s str="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	b
	//i $f(str,frist)<=0 q 100
	k PLIST
	TSTART
	s PLIST(2)=RoomRowid
	//s PLIST(3)=EquipRowid
	s PLIST(4)=TcpipAddress  
	s PLIST(5)=Port
	s PLIST(6)=InterfaceProgram
	s PLIST(7)=DefaultInterval
	//sjq
	s PLIST(8)=UserIPAdress
	&SQL(insert into DHC_AN_RoomEquip Values :PLIST())
	i SQLCODE
	{	TROLLBACK
	}
	else {	TCOMMIT}
	q SQLCODE
}

ClassMethod DeleteRoomEquip(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from DHC_AN_RoomEquip where ANRE_RowId=:Rowid)
	q SQLCODE
}

ClassMethod updateRoomEquip(Rowid As %String, RoomRowid As %String, EquipRowid As %String, TcpipAddress As %String, Port As %String, InterfaceProgram As %String, DefaultInterval As %String, UserIPAdress As %String)
{
    s ^temp("0422",2)=Rowid_"^"_RoomRowid_"^"_EquipRowid_"^"_TcpipAddress_"^"_Port_"^"_InterfaceProgram_"^"_DefaultInterval_"^"_UserIPAdress
	k PLIST 
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_RoomEquip where ANRE_RowId=:Rowid)
    i SQLCODE TRollBack  q 
	s PLIST(1)=Rowid
	s PLIST(2)=RoomRowid
	;s PLIST(3)=EquipRowid
	s PLIST(4)=TcpipAddress  
	s PLIST(5)=Port
	s PLIST(6)=InterfaceProgram
	s PLIST(7)=DefaultInterval
	//sjq
	s PLIST(8)=UserIPAdress
	&sql(update DHC_AN_RoomEquip Values :PLIST() where ANRE_RowId=:Rowid)
	
	s ^TMPCCQ("ANRoomEquip")=Rowid_"^"_RoomRowid_"^"_EquipRowid_"^"_TcpipAddress_"^"_Port_"^"_InterfaceProgram_"^"_DefaultInterval_"^"_$System.SQL.SQLCODE(SQLCODE)
 q SQLCODE
}

ClassMethod RepRoomEquip(EquipRowid As %String)
{
	s Rowid=0
	s flag="N"
	f  s Rowid=$o(^DHCANRoomEquip(Rowid)) q:Rowid=""  d
	.s EquipDr=$p($g(^DHCANRoomEquip(Rowid)),"^",2)
	.i EquipRowid=EquipDr s flag="Y"
	q flag
}

Query exeEquip(DESC As %String) As %Query(ROWSPEC = "EquipDesc:%String,EquipRowid:%String")
{
}

ClassMethod exeEquipExecute(ByRef qHandle As %Binary, DESC As %String) As %Status
{
   
 	Set repid=$I(^CacheTemp)
 	;s DESC=$tr($g(DESC)," ")
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

ClassMethod exeEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = exeEquipExecute ]
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

ClassMethod exeEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = exeEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query exeRoom() As %Query(ROWSPEC = "RoomDesc:%String,RoomRowid:%String")
{
}

ClassMethod exeRoomExecute(ByRef qHandle As %Binary) As %Status
{
 
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RoomRowid=0
	f  s RoomRowid=$o(^DHCANC("OPRoom",RoomRowid))  q:RoomRowid=""  d
    .s RoomDesc=$p(^DHCANC("OPRoom",RoomRowid),"^",2)
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RoomDesc,RoomRowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod exeRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = exeRoomExecute ]
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

ClassMethod exeRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = exeRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 子表

Query FindRoomEquipDetail(RoomEquipRowid As %String) As %Query(ROWSPEC = "TRowid:%String,TMDIDesc:%String,TANREDActive:%String,TChannelNo:%String,TMDIRowid:%String,TRoomEquipDesc:%String,TRoomEquipRowid:%String,TEquipRowid:%String,tAnredValuePiece:%String")
{
}

ClassMethod FindRoomEquipDetailExecute(ByRef qHandle As %Binary, RoomEquipRowid As %String) As %Status
{
   ;d ##class(%ResultSet).RunQuery("web.DHCANRoomEquipDetail","FindRoomEquipDetail","31")
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i RoomEquipRowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	   s TEquipRowid=$p($g(^DHCANRoomEquip(RoomEquipRowid)),"^",2)
	   s TRoomEquipDesc=""
	   i TEquipRowid'="" s TRoomEquipDesc=$p($g(^DHCEQEquip(TEquipRowid)),"^",1)
	   s ChildSub=0 
	   f  s ChildSub=$o(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub)) q:ChildSub=""  d
	      .s TMDIRowid=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",1)
	      .s TMDIDesc=""
	      .i TMDIRowid'="" s TMDIDesc=$p($g(^DHCANC("ComOrd",TMDIRowid)),"^",2)
	      .s TANREDActive=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",2)
          .s TChannelNo=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",3)
	      .s TRowid=RoomEquipRowid_"||"_ChildSub
	      .s TRoomEquipRowid=RoomEquipRowid
	      .s tAnredValuePiece=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",4)
	      .d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(TRowid,TMDIDesc,TANREDActive,TChannelNo,TMDIRowid,TRoomEquipDesc,TRoomEquipRowid,TEquipRowid,tAnredValuePiece)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindRoomEquipDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRoomEquipDetailExecute ]
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

ClassMethod FindRoomEquipDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRoomEquipDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindMoniDataItem(ancoType As %String) As %Query(ROWSPEC = "MDIDesc:%String,MDIRowid:%String")
{
}

ClassMethod FindMoniDataItemExecute(ByRef qHandle As %Binary, ancoType As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ancoType="" s ancoType="V"
	s MDIRowid=0
	f  s MDIRowid=$o(^DHCANC("ComOrd",MDIRowid)) q:MDIRowid=""  d
	   .q:$p(^DHCANC("ComOrd",MDIRowid),"^",3)'=ancoType
	   .s MDIDesc=$p($g(^DHCANC("ComOrd",MDIRowid)),"^",2)
	   .d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(MDIDesc,MDIRowid)
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

Query FindANREDActive() As %Query(ROWSPEC = "ANREDActive:%String,ActiveRowid:%String")
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

ClassMethod RepMoniDataItemDesc(RoomEquipRowid As %String, MDIDesc As %String = "", AnredValuePiece As %String = "")
{
    ;w ##class(web.DHCANRoomEquipDetail).RepMoniDataItemDesc("31","脉搏")
    s flag="N"
	s ChildSub=0 
	   f  s ChildSub=$o(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub)) q:(ChildSub="")!(flag="Y")  d
	      .s TMDIRowid=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",1)
	      .s TMDIDesc="", TAnredValuePiece=""
	      .i TMDIRowid'="" s TMDIDesc=$p($g(^DHCANC("ComOrd",TMDIRowid)),"^",2)
	      .S TAnredValuePiece=$p(^DHCANRoomEquip(RoomEquipRowid,"I",ChildSub),"^",4)
	      .i TMDIDesc=MDIDesc,AnredValuePiece=TAnredValuePiece s flag="Y"
	q flag
}

ClassMethod InsertMoniDataItem(RoomEquipRowid As %String, MDIRowid As %String, ANREDActive As %String, ChannelNo As %String, anredValuePiece As %String)
{
	k PLIST
	TSTART
	;w ##class(web.DHCANRoomEquipDetail).InsertMoniDataItem("31","18","Y","11")
	s PLIST(0)=RoomEquipRowid
	s PLIST(3)=MDIRowid
	s PLIST(4)=ANREDActive
	s PLIST(5)=ChannelNo
	s PLIST(6)=anredValuePiece
	&SQL(insert into SQLUSER.DHC_AN_RoomEquipDetail Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateMoniDataItem(Rowid As %String, RoomEquipRowid As %String, MDIRowid As %String, ANREDActive As %String, ChannelNo As %String, anredValuePiece As %String)
{
   ;w ##class(web.DHCANRoomEquipDetail).UpdateMoniDataItem("31||5","31","12","N","11")
	k PLIST 
	;&sql(select * into :PLIST() from SQLUSER.DHC_ANC_MoniDataItem where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q
	s PLIST(0)=RoomEquipRowid
	s PLIST(1)=Rowid
	s PLIST(3)=MDIRowid
	s PLIST(4)=ANREDActive
	s PLIST(5)=ChannelNo
	s PLIST(6)=anredValuePiece
	&sql(update SQLUSER.DHC_AN_RoomEquipDetail Values :PLIST() where ANRED_RowId=:Rowid)
 q SQLCODE
}

ClassMethod DeleteMoniDataItem(Rowid As %String)
{
	i Rowid'="" d
	.&SQL(delete from SQLUSER.DHC_AN_RoomEquipDetail where ANRED_RowId=:Rowid)
	q SQLCODE
}

// 复制某手术间某设备的通道号信息，只用于旧版本

// s srcRowId=6

// s dstRowId=7

// w ##class(web.DHCANRoomEquip).CopyChNO(6,7)

ClassMethod CopyChNO(srcRowId As %String, dstRowId As %String, deleteOld As %String = "N")
{
	i deleteOld="Y" d
	.&SQL(delete from SQLUSER.DHC_AN_RoomEquipDetail where ANRED_Parref=:dstRowId)
	s roomEq=""
	f  s roomEq=$O(^DHCANRoomEquip(srcRowId,"I",roomEq)) q:roomEq=""  d
	.s chStr=^DHCANRoomEquip(srcRowId,"I",roomEq)
	.s RoomEquipRowid=dstRowId
	.s MDIRowid=$p(chStr,"^",1)
	.s ANREDActive=$p(chStr,"^",2)
	.s ChannelNo=$p(chStr,"^",3)
	.s anredValuePiece=$p(chStr,"^",4)
	.
	.d ..InsertMoniDataItem(RoomEquipRowid, MDIRowid , ANREDActive , ChannelNo,anredValuePiece)
	q "完成"
}

/// w ##class(web.DHCANRoomEquip).GetRoomDesc("")
ClassMethod GetRoomDesc(ipconfig As %String)
{
	s TRowid=0
	f  s TRowid=$o(^DHCANRoomEquip(TRowid))  q:TRowid=""  d
    .s TRoomRowid=$p($g(^DHCANRoomEquip(TRowid)),"^",1)
    .q:TRoomRowid=""
    .s TRoom=$p($g(^DHCANC("OPRoom",TRoomRowid)),"^",2)
	.s TUserIPAddress=$p($g(^DHCANRoomEquip(TRowid)),"^",7)
	.s ip=$p(TUserIPAddress,"|",1)
	.w !,ip
	.q:ip'=ipconfig
	q TRoom_"^"_ip
}

Query FindRoomEquipList() As %SQLQuery(CONTAINID = 1)
{
	select %ID as Id,
		   ANRE_Room_Dr as RoomId,
		   ANRE_Room_Dr->OPR_Desc as RoomDesc,
		   ANRE_Equip_Dr as EquipId,
		   ANRE_TcpipAddress as TcpipAddress,
		   ANRE_Port as CommPort,
		   ANRE_InterfaceProgram as CommInterfaceProgram,
		   ANRE_DefaultInterval as DefaultInterval,
		   ANRE_EditTcpipAddress as EditTcpipAddress
		   from DHC_AN_RoomEquip
}

ClassMethod CheckValidRecordData(desc, id)
{
	q:+id'>0 0
	q:$d(^DHCANC("ComOrd",id))<1 0
	s curDesc=$p(^DHCANC("ComOrd",id),"^",2)
	q:curDesc'=desc 0
	q 1
}

}
