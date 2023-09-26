Class DHCWL.WL.GetTitle Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//取分类

//EC     DHC_TarEMCCate  核算子分类

//"AC"   DHC_TarAcctCate         会计子分类

//"SC"   DHC_TarSubCate          收费子分类

//"OC"   DHC_TarOutpatCate       门诊子分类

//"MR"   DHC_TarMRCate           病历首页子分类

//"IC"   DHC_TarInpatCate        住院子分类

//d ##class(%ResultSet).RunQuery("DHCWL.WL.GetTitle","GetTarEC","EC")	

ClassMethod GetTarECExecute(ByRef qHandle As %Binary, tarType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    q:tarType="" $$$OK
    //s tarecId=0,tarecDesc=""
    //d OutputRow1
    s tarecId=0 f  s tarecId=$o(^DHCTarC(tarType,tarecId)) q:tarecId=""  d
    .s tarecDesc=$p(^DHCTarC(tarType,tarecId),"^",2)
    .d OutputRow1
     
	q $$$OK	
OutputRow1
    
    s Data=$lb(tarecId,tarecDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetTarECFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTarECExecute ]
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

ClassMethod GetTarECClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTarECExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetTarEC(tarType As %String) As %Query(ROWSPEC = "tarecId:%Integer,tarecDesc:%String") [ SqlProc ]
{
}

}
