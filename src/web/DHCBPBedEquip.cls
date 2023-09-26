Import SQLUser

Class web.DHCBPBedEquip Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPBedEquip","FindBedEquip")
Query FindBedEquip(bed As %String = "", equip As %String = "", hospId As %String = "") As %Query(ROWSPEC = "tBPBERowId:%String,tBPBEBedDr:%String,tBPBEBed:%String,tBPBEBPCEquipDr:%String,tBPBEBPCEquip:%String,tBPBETcpipAddress:%String,tBPBEPort:%String,tBPBECollectTypeDr:%String,tBPBECollectType:%String,tBPBEDefaultInterval:%Float,tBPBEEditTcpipAddress:%String,tBPBEIfConnectedB:%String,tBPBEIfConnected:%String")
{
}

ClassMethod FindBedEquipExecute(ByRef qHandle As %Binary, bed As %String = "", equip As %String = "", hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPBERowId=0 	
	f  s tBPBERowId=$o(^DHCBPBedEquip(tBPBERowId)) q:tBPBERowId=""  d
		.s hospitalId=""
		.s DataAttributionDr=$lg(^DHCBPBedEquip(tBPBERowId),9)
		.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		.q:((hospitalId'="")&(hospId'="")&(hospId'=hospitalId))
	    .s tBPBEBedDr=$lg(^DHCBPBedEquip(tBPBERowId),1)
	    .i tBPBEBedDr'="" s tBPBEBed=$lg($g(^DHCBPC("Bed",tBPBEBedDr)),2)
	    .q:(bed'="")&($$ALPHAUP^SSUTIL4(tBPBEBed)'[$$ALPHAUP^SSUTIL4(bed))
	    .s tBPBEBPCEquipDr=$lg(^DHCBPBedEquip(tBPBERowId),2)
	    .;q:(equipDr'="")&&(equipDr'=tBPBEBPCEquipDr)
	    .i tBPBEBPCEquipDr'="" s tBPBEBPCEquip=$lg($g(^DHCBPC("Equip",tBPBEBPCEquipDr)),3)_"-"_tBPBEBed
	    .q:(equip'="")&($$ALPHAUP^SSUTIL4(tBPBEBPCEquip)'[$$ALPHAUP^SSUTIL4(equip))
	    .s tBPBETcpipAddress=$lg(^DHCBPBedEquip(tBPBERowId),3)
	    .s tBPBEPort=$lg(^DHCBPBedEquip(tBPBERowId),4)
	    .s tBPBECollectTypeDr=$lg(^DHCBPBedEquip(tBPBERowId),5)
	    .s tBPBECollectType=""
	    .i tBPBECollectTypeDr'="" s tBPBECollectType=$p(^DHCANC("CType",tBPBECollectTypeDr),"^",2)
	    .s tBPBEDefaultInterval=$lg(^DHCBPBedEquip(tBPBERowId),6)
	    .s tBPBEEditTcpipAddress=$lg(^DHCBPBedEquip(tBPBERowId),7)
	    .s tBPBEIfConnectedB=$lg(^DHCBPBedEquip(tBPBERowId),8)
	    .s:tBPBEIfConnectedB=1 tBPBEIfConnected="是"
	    .s:tBPBEIfConnectedB=0 tBPBEIfConnected="否"
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPBERowId,tBPBEBedDr,tBPBEBed,tBPBEBPCEquipDr,tBPBEBPCEquip,tBPBETcpipAddress,tBPBEPort,tBPBECollectTypeDr,tBPBECollectType,tBPBEDefaultInterval,tBPBEEditTcpipAddress,tBPBEIfConnectedB,tBPBEIfConnected)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBedEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedEquipExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBedEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedEquipExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPBedEquip).InsertBedEquip(1,6,"117.128.1.1",4001,6,3000,"1.1.1.1",1)
ClassMethod InsertBedEquip(bpbeBedDr As %String, bpbeBPCEquipDr As %String, bpbeTcpipAddress As %String, bpbePort As %String, bpbeCollectTypeDr As %String, bpbeDefaultInterval As %Float, bpbeEditTcpipAddress As %String, bpbeIfConnected As %String, hospId As %String = "")
{
	k PLIST
	q:bpbeBPCEquipDr="" "设备选择不能为空"
	s bpbeId=0,ifDupBed=0
	f  s bpbeId=$o(^DHCBPBedEquip(bpbeId)) q:bpbeId=""  d
		.i $lg(^DHCBPBedEquip(bpbeId),1)=bpbeBedDr s ifDupBed=1
	q:ifDupBed "床位重复！"

	s status="US"
	//q:'##class(User.DHCBPCEquip).%ExistsId(bpbeBPCEquipDr)
	s equipStatus=$lg(^DHCBPC("Equip",bpbeBPCEquipDr),7)
	q:equipStatus'="SP" "当前设备的状态不允许被绑定,设备状态不是备用状态:"_equipStatus
	s equipDesc=$lg(^DHCBPC("Equip",bpbeBPCEquipDr),3)
	s equipDesc=bpbeBedDr_"-"_equipDesc
	TSTART
    s PLIST(2)=bpbeBedDr
	s PLIST(3)=bpbeBPCEquipDr
	s PLIST(4)=bpbeTcpipAddress
	s PLIST(5)=bpbePort
	s PLIST(6)=bpbeCollectTypeDr
	s PLIST(7)=bpbeDefaultInterval
	s PLIST(8)=bpbeEditTcpipAddress
	s PLIST(9)=bpbeIfConnected	
	&SQL(insert into DHC_BP_BedEquip values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
	s DataRowId=%ROWID
	
	;更新设备的状态和设备描述
	&SQL(update DHC_BPC_Equip set BPCE_Desc=:equipDesc,BPCE_Status=:status where BPCE_RowId=:bpbeBPCEquipDr)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}		
    TCOMMIT
        
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPBedEquip")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPBedEquip",DataRowId,hospId)
    }
    
	q SQLCODE
}

/// d ##class(web.DHCBPBedEquip).UpdateBedEquip(1,1,6,"117.128.1.1",4001,6,3000,"2.2.2.2",0)
ClassMethod UpdateBedEquip(bpbeRowId As %String, bpbeBedDr As %String, bpbeBPCEquipDr As %String, bpbeTcpipAddress As %String, bpbePort As %String, bpbeCollectTypeDr As %String, bpbeDefaultInterval As %Float, bpbeEditTcpipAddress As %String, bpbeIfConnected As %String, hospId As %String = "")
{
	q:bpbeRowId="" "ID不能为空"
	
	s bpbeId=0,ifDupBed=0
	f  s bpbeId=$o(^DHCBPBedEquip(bpbeId)) q:bpbeId=""  d
		.i $lg(^DHCBPBedEquip(bpbeId),1)=bpbeBedDr s ifDupBed=1
	//q:ifDupBed "床位重复！"
	K PLIST
	TSTART	
    s PLIST(1)=bpbeRowId
    s PLIST(2)=bpbeBedDr
	s PLIST(3)=bpbeBPCEquipDr
	s PLIST(4)=bpbeTcpipAddress
	s PLIST(5)=bpbePort
	s PLIST(6)=bpbeCollectTypeDr
	s PLIST(7)=bpbeDefaultInterval
	s PLIST(8)=bpbeEditTcpipAddress
	s PLIST(9)=bpbeIfConnected
	&SQL(update DHC_BP_BedEquip values:PLIST() where BPBE_RowId=:bpbeRowId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}	
    TCOMMIT
    s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPBedEquip")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPBedEquip",DataRowId,hospId)
    }
	q SQLCODE
}

ClassMethod ReBindBedEquip(rowId As %String, equipId As %String) As %String
{
	q:rowId="" "ID不能为空"
	
	K PLIST
	TSTART	
    s PLIST(1)=rowId
	s PLIST(3)=equipId
	&SQL(update DHC_BP_BedEquip values:PLIST() where BPBE_RowId=:rowId)
	i SQLCODE
	{
		TROLLBACK
		q "更新失败！"	
	}	
    TCOMMIT
	q rowId
}

/// d ##class(web.DHCBPBedEquip).DeleteBedEquip(3,1)
ClassMethod DeleteBedEquip(bpbeRowId, equipID) As %String
{
	q:bpbeRowId="" "ID不能为空!"
	q:equipID="" "绑定的设备号为空"
	//i bpbeRowId'=""  d
	s status="SP"
	s equipDesc=$lg($g(^DHCBPC("Equip",equipID)),3)
	;q:(equipDesc="")&&(equipDesc'["-") "该条设备记录不存在"
	i (equipDesc'="")&&(equipDesc["-") s equipDesc=$p(equipDesc,"-",2)
	b
	TSTART	
	&SQL(delete from DHC_BP_BedEquip where %ID=:bpbeRowId)
	i SQLCODE
	{
		TROLLBACK
		q "更新失败！"	
	}
	b ;01
	&SQL(update DHC_BPC_Equip set BPCE_Desc=:equipDesc,BPCE_Status=:status where BPCE_RowId=:equipID)
	i SQLCODE
	{
		TROLLBACK
	}
	b ;02
	TCOMMIT

	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPBedEquip")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPBedEquip",bpbeRowId)
    }
	q SQLCODE
}

Query FindBoolen() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBoolenExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="是"
	d OutputRow1
	s Id="0",Desc="否"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBoolenFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBoolenExecute ]
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

ClassMethod FindBoolenClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBoolenExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetBedEquipList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPBE_Bed_Dr As BedId,
	   BPBE_BPCEquip_Dr As EquipId,
	   BPBE_TcpipAddress As IpAddress,
	   BPBE_Port As Port,
	   BPBE_CollectType_Dr As CollectTypeId,
	   BPBE_DefaultInterval As DefaultInterval,
	   BPBE_EditTcpipAddress As EditIpAddress,
	   BPBE_IfConnected As IfConnected
       FROM DHC_BP_BedEquip
}

}
