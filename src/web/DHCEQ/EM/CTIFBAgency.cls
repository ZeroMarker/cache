Class web.DHCEQ.EM.CTIFBAgency Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 描述: HISUI改造：页面除入参元素之外的所有Lookup元素初始化
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.IFBAgency","GetIFBAgency","")
Query GetIFBAgency(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String,TQualification:%String,TAddress:%String")
{
}

ClassMethod GetIFBAgencyExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCIFBAgency",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetIFBAgency
	.Set TRowID = rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",2)
	.Quit:(Desc'="")&&(TDesc'=Desc)
	.Set TQualification=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",3)
	.Set TAddress=$Piece($Get(^DHCEQCCode("DHCEQCIFBAgency",rowid)),"^",4)
	.Do OutputRowGetIFBAgency
	Quit $$$OK
OutputRowGetIFBAgency
	Set Data=$lb(TRowID,TDesc,TCode,TQualification,TAddress)   //add by wy 2020-4-20 1274414
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetIFBAgency
	Set (TRowID,TDesc,TCode,TQualification,TAddress)=""
	Quit
}

ClassMethod GetIFBAgencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIFBAgencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetIFBAgencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIFBAgencyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
