Import SQLUser

Class web.DHCRegConFree Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 23;

ClassMethod RCFAdmReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RCFAdmReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// W ##class(%ResultSet).RunQuery("web.DHCRegConFree","RCFAdmReason")

ClassMethod RCFAdmReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s RCFRowID="1"
	f  s RCFRowID=$o(^DHCRCF(RCFRowID)) q:RCFRowID=""  d 
	.s RCFAdmReasonDr=$p(^DHCRCF(RCFRowID),"^",1)
	.q:RCFAdmReasonDr=""
	.s READesc=$P(^PAC("ADMREA",RCFAdmReasonDr),"^",2)
	.s RCFStartDate=$p(^DHCRCF(RCFRowID),"^",2)
	.s RCFStartDate=$zd(RCFStartDate,4)
	.s RCFStartTime=$p(^DHCRCF(RCFRowID),"^",3)
	.s RCFStartTime=$zt(RCFStartTime,4)
	.s RCFEndDate=$p(^DHCRCF(RCFRowID),"^",4)
	.s:(RCFEndDate'="") RCFEndDate=$zd(RCFEndDate,4)
	.s RCFEndTime=$p(^DHCRCF(RCFRowID),"^",5)
	.s:(RCFEndTime'="") RCFEndTime=$zt(RCFEndTime,4)
	.s RCFFreeRegFee=$p(^DHCRCF(RCFRowID),"^",7)
	.s RCFFreeCheckFee=$p(^DHCRCF(RCFRowID),"^",8)	
	.s RCFFreeAllFee=$p(^DHCRCF(RCFRowID),"^",6)
	.s:RCFFreeAllFee="Y" RCFFreeAllFee="是"
    .s:RCFFreeAllFee="N" RCFFreeAllFee="否"	
	.s RCFFreeAppFee=$p(^DHCRCF(RCFRowID),"^",9)
	.s RCFFreeOtherFee=$p(^DHCRCF(RCFRowID),"^",10)
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1      
	set Data=$lb(RCFAdmReasonDr,RCFRowID,READesc,RCFStartDate,RCFStartTime,RCFEndDate,RCFEndTime,RCFFreeRegFee,RCFFreeCheckFee,RCFFreeAllFee,RCFFreeAppFee,RCFFreeOtherFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod RCFAdmReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RCFAdmReasonExecute ]
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

Query RCFAdmReason() As %Query(ROWSPEC = "TRCFAdmReasonDr:%String,TRCFRowID:%String,TREADesc:%String,RCFStartDate:%String,RCFStartTime:%String,RCFEndDate:%String,RCFEndTime:%String,RCFFreeRegFee:%String,RCFFreeCheckFee:%String,RCFFreeAllFee:%String,RCFFreeAppFee:%String,RCFFreeOtherFee:%String")
{
}

// w ##class(web.DHCRegConFree).ADD("4^11/09/2010^12:34^^^N^N^N^N^N")

ClassMethod ADD(InString) As %String
{

	n (InString)
	s PLIST(2)=$p(InString,"^",1)
	s RCFStartDate=$p(InString,"^",2)
	s PLIST(3)=$zdh(RCFStartDate,4)
	s RCFStartTime=$p(InString,"^",3)
	s PLIST(4)=$zth(RCFStartTime,1)
	s RCFEndDate=$p(InString,"^",4)
	s:(RCFEndDate'="") PLIST(5)=$zdh(RCFEndDate,4)
	s RCFEndTime=$p(InString,"^",5)
	s:(RCFEndTime'="") PLIST(6)=$zth(RCFEndTime,1)
	s PLIST(7)=$p(InString,"^",6)
	s PLIST(8)=$p(InString,"^",7)
	s PLIST(9)=$p(InString,"^",8)
	s PLIST(10)=$p(InString,"^",9)
	s PLIST(11)=$p(InString,"^",10)
	&sql(insert into DHC_RegConFree values PLIST())
	q SQLCODE
}

// w ##class(web.DHCRegConFree1).FeeCate()

ClassMethod FeeCate() As %String
{
	s OutStr=""
	s REARowid="0"
	f  s REARowid=$o(^PAC("ADMREA",REARowid))  q:REARowid=""  d
	.s READesc=$P(^PAC("ADMREA",REARowid),"^",2)
	.s OutStr=OutStr_"|"_REARowid_"^"_READesc
	q OutStr
}

ClassMethod DELETE(TRCFRowID) As %String
{
	&sql(delete from DHC_RegConFree where RCF_RowId=:TRCFRowID)
	q:SQLCODE SQLCODE
}

//w ##class(web.DHCRegConFree).Update()

ClassMethod Update(Instring) As %String
{
	
	s TRCFRowID=$p(Instring,"^",1)
	s RCFAdmReasonDr=$p(Instring,"^",2)
	s StartDate=$p(Instring,"^",3)
	s StartDate=$zdh(StartDate,4)
	s StartTime=$p(Instring,"^",4)
	s StartTime=$zth(StartTime,1)
	s EndDate=$p(Instring,"^",5)
	s:(EndDate'="") EndDate=$zdh(EndDate,4)
	s EndTime=$p(Instring,"^",6)
	s:(EndTime'="") EndTime=$zth(EndTime,1)
	s FreeRegFee=$p(Instring,"^",7)
	s FreeCheckFee=$p(Instring,"^",8)
	s FreeAllFee=$p(Instring,"^",9)
	s FreeAppFee=$p(Instring,"^",10)
	s FreeOtherFee=$p(Instring,"^",11)
	&sql(Update DHC_RegConFree set RCF_AdmReason_Dr=:RCFAdmReasonDr, RCF_StartDate=:StartDate,RCF_StartTime=:StartTime,RCF_EndDate=:EndDate, RCF_EndTime=:EndTime,RCF_FreeAllFee=:FreeAllFee,RCF_FreeRegFee=:FreeRegFee,RCF_FreeCheckFee=:FreeCheckFee,RCF_FreeAppFee=:FreeAppFee,RCF_FreeOtherFee=:FreeOtherFee where RCF_Rowid=:TRCFRowID) 
	q:SQLCODE SQLCODE
}

}
