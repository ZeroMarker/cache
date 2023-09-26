Class web.DHCCTAntUseReasonItem Extends %RegisteredObject
{

/// creator:董亚平
/// creatdate:2013-01-31
/// Description:取使用目的子类字典维护
/// table:User.DHCCTAntUseReasonItem
/// input:
/// d ##class(%ResultSet).RunQuery("web.DHCCTAntUseReasonItem","GetAntUseReaItem")
Query GetAntUseReaItem() As %Query(ROWSPEC = "Rowid:%String,IDDesc:%String,Itemid:%String,Code:%String,Desc:%String,IPActiveDesc:%String")
{
}

ClassMethod GetAntUseReaItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	set ID=""
 	FOR {
	 	 set ID=$o(^DCTAR("AUR",ID))  QUIT:ID=""
 	     set Itemid=0
 	     for{
	 	     set Itemid=$o(^DCTAR("AUR",ID,"I",Itemid))  QUIT:Itemid=""
	 	     set POSITION=$g(^DCTAR("AUR",ID,"I",Itemid))
	 	     set IPCode=$p(POSITION,"^",1)
	 	     set IPDesc=$p(POSITION,"^",2)
	 	     set IPActive=$p(POSITION,"^",3)
	 	     set IDDesc=$p(^DCTAR("AUR",ID),"^",2)
	 	     if IPActive="Y"  set IPActivedesc="是"
	 	     else  d  set IPActivedesc="否"
	 	     set data=$lb(ID_"||"_Itemid,IDDesc,Itemid,IPCode,IPDesc,IPActivedesc)
 	         Set ^CacheTemp(repid,ind)=data
		     Set ind=ind+1
 	     }
	 	}
	Quit $$$OK
}

ClassMethod GetAntUseReaItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntUseReaItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAntUseReaItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntUseReaItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// creator:董亚平
/// creatdate:2013-01-31
/// description：增加和更新使用目的子类维护字典
/// input:"^"分隔
/// return: return>0 成功  return<=0失败
/// w ##class(web.DHCCTAntUseReasonItem).update("2||4^1-4^其他^true^3","")
ClassMethod update(input As %String, Separate As %String = "") As %String
{
    s ^dyp(12)=input   _"!"_Separate
	Set return=0
	set:Separate="" Separate="^"
	set ID=$P(input,Separate,1)
	set DAURICode=$p(input,Separate,2)
	set DAURIDesc=$p(input,Separate,3)
	&sql(SELECT count(*) INTO :mycount   
 FROM  SQLUSER.DHC_CTAntUseReasonItem
 WHERE (DAURI_Code=:DAURICode)and(DAURI_Desc=:DAURIDesc))
	IF (ID=""){
		set obj=##class(User.DHCCTAntUseReasonItem).%New($p(input,Separate,5))  //生成一个对象
	}else{
		set obj=##class(User.DHCCTAntUseReasonItem).%OpenId(ID)  //打开一个对象
	}
	Quit:'$IsObject(obj) return
	do obj.DAURIAURParRefSetObjectId($p(input,Separate,5))
	set obj.DAURICode=$P(input,Separate,2)
	set obj.DAURIDesc=$p(input,Separate,3)
	set active=$p(input,Separate,4)
	if active="true"  set active="Y"
	else  d  set active="N"
	set obj.DAURIActiveFlag=active
	b  ;;
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
    	Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
 	}
	Do obj.%Close()
	
	Quit return
}

/// w ##class(web.DHCCTAntUseReasonItem).GetAntUseReason()
ClassMethod GetAntUseReason()
{
  
    set outstr=""
	set rowid=0
	for  set rowid=$o(^DCTAR("AUR",rowid)) quit:rowid=""   d
	.set categorycode=$p(^DCTAR("AUR",rowid),"^",1)
	.set categorydesc=$p(^DCTAR("AUR",rowid),"^",2)
	.set outstr=outstr_"!"_rowid_"^"_categorydesc_"^"_categorycode
	q outstr
}

}
