Import SQLUser

Class DHCOLB.ClientSet Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LookUpClient() As %Query(ROWSPEC = "ClientId:%String,ClientName:%String,ServerDR:%String,ServerName:%String,ComputerActive:%String,ComputerIP:%String,ComputerMac:%String,ComputerName:%String,ComputerIPUpper:%String,ComputerIPLower:%String,ComputerNote:%String")
{
}

ClassMethod LookUpClientExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s ClientId=""
	f  s ClientId=$O(^DHCOLBClient(ClientId)) q:ClientId=""  d
	.s ClientStr=$G(^DHCOLBClient(ClientId))
	.q:ClientStr=""
	.s ClientName=$P(ClientStr,"^",1)
	.s ServerDR=$P(ClientStr,"^",2)
	.i ServerDR'="" s ServerName=$P($G(^DHCOLBServer(ServerDR)),"^") 
	.e  s ServerName=""
	.s ComputerActive=$P(ClientStr,"^",3)
	.s ComputerIP=$P(ClientStr,"^",4)
	.s ComputerMac=$P(ClientStr,"^",5)
	.s ComputerName=$P(ClientStr,"^",6)
	.s ComputerIPUpper=$P(ClientStr,"^",7)
	.s ComputerIPLower=$P(ClientStr,"^",8)
	.s ComputerNote=$P(ClientStr,"^",9)
	.d OutClientRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutClientRow
	s Data=$lb(ClientId,ClientName,ServerDR,ServerName,ComputerActive,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,ComputerNote)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpClientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpClientExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpClientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpClientExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod ClientInsert(ClientName As %String, ServerDR As %String, ComputerActive As %String, ComputerIP As %String = "", ComputerMac As %String = "", ComputerName As %String = "", ComputerIPUpper As %String = "", ComputerIPLower As %String = "", ComputerNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	//q:(ComputerIP="")!(ClientName="")!(ComputerActive="") "信息不完整!"
	q:(ClientName="")!(ComputerActive="") "信息不完整!"
	&SQL(insert into DHC_OLBClient(ClientName,ServerDR,ActiveFlag,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,Note) values (:ClientName,:ServerDR,:ComputerActive,:ComputerIP,:ComputerMac,:ComputerName,:ComputerIPUpper,:ComputerIPLower,:ComputerNote))                 
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod ClientUpdate(ClientId As %String, ClientName As %String, ServerDR As %String, ComputerActive As %String, ComputerIP As %String = "", ComputerMac As %String = "", ComputerName As %String = "", ComputerIPUpper As %String = "", ComputerIPLower As %String = "", ComputerNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	//q:(ClientId="")!(ComputerIP="")!(ClientName="")!(ComputerActive="") "信息不完整!"
	q:(ClientId="")!(ClientName="")!(ComputerActive="") "信息不完整!"
	&SQL(update DHC_OLBClient set ComputerIP=:ComputerIP,ClientName=:ClientName,ActiveFlag=:ComputerActive,ServerDR=:ServerDR,ComputerMac=:ComputerMac,ComputerIPUpper=:ComputerIPUpper,ComputerIPLower=:ComputerIPLower,Note=:ComputerNote where ID=:ClientId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod ClientDelete(ClientId As %String) As %String
{
	q:(ClientId="") "信息不完整!"
	&SQL(Delete from DHC_OLBClient where ID=:ClientId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

}
