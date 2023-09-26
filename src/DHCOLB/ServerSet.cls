Import SQLUser

Class DHCOLB.ServerSet Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LookUpServer() As %Query(ROWSPEC = "ServerId:%String,ServerIP:%String,ServerName:%String,ServerActive:%String,LicenseMax:%String,LicenseMin:%String,IISConMax:%String,IISConMin:%String,CPUMax:%String,MemoryMax:%String,ProfileDR:%String,Profile:%String,ServerNote:%String")
{
}

ClassMethod LookUpServerExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s ServerId=""
	f  s ServerId=$O(^DHCOLBServer(ServerId)) q:ServerId=""  d
	.s ServerStr=$G(^DHCOLBServer(ServerId))
	.q:ServerStr=""
	.s ServerName=$P(ServerStr,"^",1)
	.s ServerIP=$P(ServerStr,"^",2)
	.s ServerActive=$P(ServerStr,"^",3)
	.s ProfileDR=$P(ServerStr,"^",4)
	.i ProfileDR'="" s Profile=$P($G(^DHCOLBProfile(ProfileDR)),"^",2)
	.e  s Profile=""
	.s LicenseMax=$P(ServerStr,"^",5)
	.s LicenseMin=$P(ServerStr,"^",6)
	.s IISConMax=$P(ServerStr,"^",7)
	.s IISConMin=$P(ServerStr,"^",8)
	.s CPUMax=$P(ServerStr,"^",9)
	.s MemoryMax=$P(ServerStr,"^",10)
	.s ServerNote=$P(ServerStr,"^",11)
	.d OutServerRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutServerRow
	s Data=$lb(ServerId,ServerIP,ServerName,ServerActive,LicenseMax,LicenseMin,IISConMax,IISConMin,CPUMax,MemoryMax,ProfileDR,Profile,ServerNote)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpServerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpServerExecute ]
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

ClassMethod LookUpServerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpServerExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod ServerInsert(ServerIP As %String, ServerName As %String, ServerActive As %String, LicenseMax As %String = "", LicenseMin As %String = "", IISConMax As %String = "", IISConMin As %String = "", CPUMax As %String = "", MemoryMax As %String = "", ProfileDR As %String = "", ServerNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	q:(ServerIP="")!(ServerName="")!(ServerActive="") "信息不完整!"
	&SQL(insert into DHC_OLBServer(ServerName,ServerIP,ActiveFlag,ProfileDR,LicenseMax,LicenseMin,IISConMax,IISConMin,CPUMax,MemoryMax,Note) values (:ServerName,:ServerIP,:ServerActive,:ProfileDR,:LicenseMax,:LicenseMin,:IISConMax,:IISConMin,:CPUMax,:MemoryMax,:ServerNote))                 
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod ServerUpdate(ServerId As %String, ServerIP As %String, ServerName As %String, ServerActive As %String, LicenseMax As %String = "", LicenseMin As %String = "", IISConMax As %String = "", IISConMin As %String = "", CPUMax As %String = "", MemoryMax As %String = "", ProfileDR As %String = "", ServerNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	q:(ServerId="")!(ServerIP="")!(ServerName="")!(ServerActive="") "信息不完整!"
	&SQL(update DHC_OLBServer set ServerIP=:ServerIP,ServerName=:ServerName,ActiveFlag=:ServerActive,ProfileDR=:ProfileDR,LicenseMax=:LicenseMax,LicenseMin=:LicenseMin,IISConMax=:IISConMax,IISConMin=:IISConMin,CPUMax=:CPUMax,MemoryMax=:MemoryMax,Note=:ServerNote where ID=:ServerId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod ServerDelete(ServerId As %String) As %String
{
	q:(ServerId="") "信息不完整!"
	&SQL(Delete from DHC_OLBServer where ID=:ServerId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

//w ##Class(DHCOLB.ServerSet).GetProfileApplication("127.0.0.1")

ClassMethod GetProfileApplication(ServerIP As %String = "") As %String
{
	s Application=""
	s ServerID=$O(^DHCOLBServeri(0,"ServerIP",ServerIP,""))
	q:ServerID="" ""
	s ProfileID=$P($G(^DHCOLBServer(ServerID)),"^",4)
	q:ProfileID="" ""
	s Application=$P($G(^DHCOLBProfile(ProfileID)),"^",5)
	q Application
}

Storage Default
{
<Data name="ServerSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCOLB.ServerSetD</DataLocation>
<DefaultData>ServerSetDefaultData</DefaultData>
<IdLocation>^DHCOLB.ServerSetD</IdLocation>
<IndexLocation>^DHCOLB.ServerSetI</IndexLocation>
<StreamLocation>^DHCOLB.ServerSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
