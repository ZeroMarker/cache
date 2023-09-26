/// Create by ZhouLi
/// 组件:DHCPEOrdSets
/// 体检医嘱套维护，可用于体检前台预约
Class web.DHCPE.OrdSets Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(%ResultSet).RunQuery("web.DHCPE.OrdSets","QueryOrders","qlx")
ClassMethod QueryOrdersExecute(ByRef qHandle As %Binary, AliasText As %Library.String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i ""'=AliasText d
 	.s ARCOSDr=""
 	.s text=$ZCONVERT(AliasText,"U")                    //大小写转换
 	.s text=$o(^ARC("ALIAS",0,"Desc",text_" "),-1)
 	.f  s text=$o(^ARC("ALIAS",0,"Desc",text_" ")) q:(text="")||(text'[$ZCONVERT(AliasText,"U"))  d
    ..s ALIASDesc=0
    ..f  s ALIASDesc=$o(^ARC("ALIAS",0,"Desc",text,ALIASDesc)) q:ALIASDesc=""  d
    ...s ALIASRowid=0
    ...f  s ALIASRowid=$o(^ARC("ALIAS",0,"Desc",text,ALIASDesc,ALIASRowid)) q:ALIASRowid=""  d
    ....q:$g(^ARC("ALIAS",ALIASRowid))=""
    ....s ARCOSDr=$p(^ARC("ALIAS",ALIASRowid),"^",2)     //医嘱套ROWID
    ....q:$g(ARCOSDr)=""
    ....q:$g(^ARCOS(ARCOSDr))=""      //ARC_OrdSets 
    ....s datefrom=$p($g(^ARCOS(ARCOSDr)),"^",15)
	....if datefrom'="" {s datefrom=+datefrom q:(+datefrom>+$h)}    //医嘱套当前未生效
	....s ARCOStime=$P(^ARCOS(ARCOSDr),"^",16)                     //医嘱套有效截止日期
    ....q:(+$h>ARCOStime)&&(ARCOStime'="")                         //医嘱套过期
    ....s ARCOSName=$p(^ARCOS(ARCOSDr),"^",2)
    ....s ARCOSCode=$p(^ARCOS(ARCOSDr),"^",1)
    ....d QueryOut
   
     i AliasText=""  d  
     .s ARCOSDr=0 
     .f  s ARCOSDr=$o(^ARCOS(ARCOSDr)) q:ARCOSDr=""  d
     ..q:$g(ARCOSDr)=""
     ..q:$g(^ARCOS(ARCOSDr))=""
     ..s datefrom=$p(^ARCOS(ARCOSDr),"^",15)
     ..if datefrom'=""   {s datefrom=+datefrom  q:(+datefrom>+$h)}
	 ..s ARCOStime=$P(^ARCOS(ARCOSDr),"^",16)
     ..q:(+$h>ARCOStime)&&(ARCOStime'="")
     ..s ARCOSName=$p(^ARCOS(ARCOSDr),"^",2)
     ..s ARCOSCode=$p(^ARCOS(ARCOSDr),"^",1)
   
    ..d QueryOut
  
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

QueryOut     
	set Data=$lb(ARCOSName,ARCOSDr,ARCOSCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryOrdersFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrdersExecute ]
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

Query QueryOrders(AliasText As %Library.String) As %Query(ROWSPEC = "OrdDesc:%String:名称,ROWIDOrd:%String:ID,OrdCode:%String:编码")
{
}

ClassMethod QueryOrdersClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrdersExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 再次保存界面上医嘱是否有早餐信息

ClassMethod SearchSavedSetsExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
    f  s id=$o(^DHCPESetting("DHCPEBaseData","PEARCOS",id))  q:id=""  d
    .s diet=$g(^DHCPESetting("DHCPEBaseData","PEARCOS",id))
    .s Name=$p($g(^ARCOS(id)),"^",2)
    .s Code=$p($g(^ARCOS(id)),"^",1)
 	.d SearchOut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(Name,id,Code,diet)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchSavedSetsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSavedSetsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
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

Query SearchSavedSets() As %Query(ROWSPEC = "OrdDesc:%String,ROWID:%String,OrdCode:%String,TDeitFlag:%String")
{
}

ClassMethod SearchSavedSetsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSavedSetsExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ^DHCPESetting("DHCPEBaseData","PEARCOS",$p(InString,"^",1))="N"
    q 0
}

ClassMethod Delete(ID)
{
	K ^DHCPESetting("DHCPEBaseData","PEARCOS",ID)
	q 0
}

ClassMethod Save1(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ^DHCPESetting("DHCPEBaseData","PEARCOS",$p(InString,"^",2))=$p(InString,"^",1)
    q 0
}

ClassMethod SchTarItemExecute(ByRef qHandle As %Binary, tarcode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
 	s flag=""
 	if tarcode'=""
 	{
	 	S tarcode=$$ALPHAUP^SSUTIL4(tarcode)
	 	s code=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(tarcode)),-1)
	    f  s code=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(code))) q:(code="")!(flag="Y")  d
	    .if ($E(code,1,$L(tarcode))'=tarcode) s flag="Y" q
	    .s rw=""
	    .f  s rw=$O(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(code),rw)) q:rw=""  d
	 	..s tarname=$P(^DHCTARI(rw),"^",2)
	 	..q:tarname=""
	 	..d SearchOut
 	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchOut      
	set Data=$lb(rw,code,tarname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SchTarItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchTarItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
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

Query SchTarItem(tarcode) As %Query(ROWSPEC = "rw:%String:ID,code:%String:编码,tarname:%String:描述")
{
}

ClassMethod SchTarItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchTarItemExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
