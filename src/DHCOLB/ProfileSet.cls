Import SQLUser

Class DHCOLB.ProfileSet Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query LookUpProfile() As %Query(ROWSPEC = "SiteId:%String,OLBName:%String,SiteIP:%String,SiteName:%String,Application:%String,SiteNote:%String")
{
}

ClassMethod LookUpProfileExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s SiteId=""
	f  s SiteId=$O(^DHCOLBProfile(SiteId)) q:SiteId=""  d
	.s SiteStr=$G(^DHCOLBProfile(SiteId))
	.q:SiteStr=""
	.s OLBName=$P(SiteStr,"^",2)
	.s SiteIP=$P(SiteStr,"^",3)
	.s SiteName=$P(SiteStr,"^",4)
	.s Application=$P(SiteStr,"^",5)
	.s SiteNote=$P(SiteStr,"^",6)
	.d ProfileRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
ProfileRow
	s Data=$lb(SiteId,OLBName,SiteIP,SiteName,Application,SiteNote)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpProfileFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpProfileExecute ]
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

ClassMethod LookUpProfileClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpProfileExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// / SiteId,OLBName,SiteIP,SiteName,Application,SiteNote
ClassMethod ProfileInsert(OLBName As %String, SiteIP As %String, SiteName As %String, Application As %String = "", SiteNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	q:(OLBName="")!(SiteName="") "信息不完整!"
	//q:(SiteIP="")!(OLBName="")!(SiteName="") "信息不完整!"
	&SQL(insert into DHC_OLBProfile(OLBName,SiteIP,SiteName,Application,Note) values (:OLBName,:SiteIP,:SiteName,:Application,:SiteNote))                 
	i SQLCODE'=0 q "插入失败!"
	q SQLCODE
}

ClassMethod ProfileUpdate(SiteId As %String, OLBName As %String, SiteIP As %String, SiteName As %String, Application As %String = "", SiteNote As %String = "") As %String
{
	s nowDate=+$H
	s nowTime=$P($H,",",2)
	q:(SiteId="")!(SiteName="")!(OLBName="") "信息不完整!"
	//q:(SiteId="")!(SiteIP="")!(SiteName="")!(OLBName="") "信息不完整!"
	&SQL(update DHC_OLBProfile set OLBName=:OLBName,SiteIP=:SiteIP,SiteName=:SiteName,Application=:Application,Note=:SiteNote where ID=:SiteId)
	i SQLCODE'=0 q "更新失败!"
	q SQLCODE
}

ClassMethod ProfileDelete(SiteId As %String) As %String
{
	q:(SiteId="") "信息不完整!"
	&SQL(Delete from DHC_OLBProfile where ID=:SiteId)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

ClassMethod ClearLoadInfo() As %String
{
	&SQL(Delete from DHC_OLBInfo)
	i SQLCODE'=0 q "删除失败!"
	q SQLCODE
}

Storage Default
{
<Data name="ProfileSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCOLB.ProfileSetD</DataLocation>
<DefaultData>ProfileSetDefaultData</DefaultData>
<IdLocation>^DHCOLB.ProfileSetD</IdLocation>
<IndexLocation>^DHCOLB.ProfileSetI</IndexLocation>
<StreamLocation>^DHCOLB.ProfileSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
