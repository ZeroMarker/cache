Class web.DHCEQ.RM.CTPriceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORPriceType"
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSCPriceType",JsonData,.PLIST)
	s RowID = JsonData.PTRowID
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQSCPriceType set PT_InvalidFlag='Y' where PT_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	ELSE
	{
		s PLIST(5)="N"  
		s PTDesc=JsonData.PTDesc
		s TmpID=""
		&SQL(Select PT_RowID Into :TmpID from SQLUSER.DHC_EQSCPriceType Where PT_Desc=:PTDesc and PT_InvalidFlag='N')
		
		i (TmpID'="")&&(TmpID'=RowID) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQSCPriceType Values :PLIST() where PT_RowID = :RowID)
		}
		else
		{	
			&SQL(insert into SQLUSER.DHC_EQSCPriceType Values :PLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s RowID=$g(%ROWID)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORPriceType
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.CTPriceType","GetPriceType","1","","")
Query GetPriceType(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String")
{
}

ClassMethod GetPriceTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQSCPriceType(rowid))  quit:rowid=""  d
	.d ResetVariablesGetPriceType
	.q:$p($g(^DHCEQSCPriceType(rowid)),"^",4)="Y"
	.s TCode = $p($g(^DHCEQSCPriceType(rowid)),"^",1)
	.q:(Code'="")&&(Code'=TCode)
	.s TDesc = $p($g(^DHCEQSCPriceType(rowid)),"^",2)
	.q:(Desc'="")&&(Desc'=TDesc)
	.s TRemark = $p($g(^DHCEQSCPriceType(rowid)),"^",3)
	.s TRowID = rowid
	.d OutputRowGetPriceType
	Quit $$$OK
OutputRowGetPriceType
	s Data=$lb(TRowID,TCode,TDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPriceType
	s (TRowID,TCode,TDesc,TRemark)=""
	quit
}

ClassMethod GetPriceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPriceTypeExecute ]
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

ClassMethod GetPriceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPriceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
