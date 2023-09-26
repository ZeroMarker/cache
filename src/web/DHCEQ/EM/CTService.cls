Class web.DHCEQ.EM.CTService Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by czf 20200404
/// 描述: 服务商
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTService","GetService","")
Query GetService(Service As %String = "") As %Query(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String,TContPerson:%String,TTel:%String")
{
}

ClassMethod GetServiceExecute(ByRef qHandle As %Binary, Service As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Service=##Class(web.DHCEQCommon).UnEscape(Service)		//modified by CZF0103 20200408
 	Set Service=$ZCONVERT(Service ,"U")
 	
	Set index=1
	Set FirmType=4
	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid)) q:rowid=""  d
	.s FCRowid=$o(^DHCEQCCode("DHCEQCFirmContrast",0,"FirmType",FirmType,rowid,""))
	.q:FCRowid=""
	.q:$p($g(^DHCEQCCode("DHCEQCFirmContrast",FCRowid)),"^",3)="Y"		 //modified by CZF0103 20200408
	.Do ResetGetService
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s THold3=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",22)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TDescription=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.Quit:(Service'="")&&($ZCONVERT(TCode ,"U")'[Service)&&($ZCONVERT(TDescription ,"U")'[Service)
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.Do OutputGetService
	Quit $$$OK

OutputGetService
	Set Data=$lb(TDescription,TRowID,TCode,TContPerson,TTel)	//modified by CZF0103 20200408
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetService
	Set (TDesc,TRowID,TCode,TTel,TContPerson)=""
	Quit
}

ClassMethod GetServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceExecute ]
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
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
