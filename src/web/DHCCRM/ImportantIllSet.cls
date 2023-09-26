Import SQLUser

Class web.DHCCRM.ImportantIllSet Extends %RegisteredObject
{

//w ##class(web.DHCCRM.ImportantIllSet).GetItemMast(0,20,"外")

ClassMethod GetItemMast(start, limit, ItemDesc)
{
    //S ^zl("GetItemMast",1)=ItemDesc 
    
    
    s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.ImportantIllSet:SearchARCItem")
	d rs.Execute(ItemDesc)
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s ARCIMCode=rs.Get("ARCIM_Code")
	 	s ARCIMDesc=rs.Get("ARCIM_Desc")
	 	s ARCIMDR=rs.Get("ARCIM_DR")
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ARCIMCode"":"_""""_ARCIMCode_""""
		s mess=mess_","_"""ARCIMDesc"":"_""""_ARCIMDesc_""""
		s mess=mess_","_"""ARCIMDR"":"_""""_ARCIMDR_""""
		s mess=mess_"}"
	}
	//s ^zl("mess",2)=mess	 	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

Query SearchARCItem(Desc As %String = "") As %Query(ROWSPEC = "ARCIM_Code:%String,ARCIM_Desc:%String,ARCIM_DR:%String")
{
}

ClassMethod SearchARCItemExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ""'=Desc   d
    .s Desc=$ZCVT(Desc,"U")
 	.s ALIASText=$O(^ARC("ALIAS",0,"Desc",Desc),-1)
	.f  s ALIASText=$O(^ARC("ALIAS",0,"Desc",ALIASText)) Q:(""=ALIASText)||(ALIASText'[Desc)  d
	..s ALIASDesc=""  //ALIAS_Desc
	..f  s ALIASDesc=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc)) Q:(""=ALIASDesc)  d
	...s ALIASRowId=""
	...f  s ALIASRowId=$O(^ARC("ALIAS",0,"Desc",ALIASText, ALIASDesc, ALIASRowId)) Q:(""=ALIASRowId)  d
	....s CurData=$G(^ARC("ALIAS", 0, "Desc", ALIASText, ALIASDesc, ALIASRowId,1))
	....s iARCIMDR=$P(CurData,"^",1)
	....s ItemType=$P(CurData,"^",2)
	....q:iARCIMDR=""
	....s Subscript=$p(iARCIMDR,"||",1),Version=$p(iARCIMDR,"||",2)
	....q:Version=""    //医嘱套
	....s iARCIMCode=$p($g(^ARCIM(Subscript,Version,1)),"^",1)
	....s iARCIMDesc=$p($g(^ARCIM(Subscript,Version,1)),"^",2)
	....s EffDate=$p($g(^ARCIM(Subscript,Version,7)),"^",1)
	....i EffDate="" s EffDate=+$H+1
	....q:EffDate<+$H
	....//s ^zl("GetItemMast",iARCIMDR)=iARCIMDesc
	....d OutputRow
	else  d
	.s Subscript=0
	.f  s Subscript=$o(^ARCIM(Subscript))  q:Subscript=""  d
	..s Version=0
	..f  s Version=$o(^ARCIM(Subscript,Version))  q:Version=""  d
	...s iARCIMCode=$p(^ARCIM(Subscript,Version,1),"^",1)
	...s iARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
	...s iARCIMDR=Subscript_"||"_Version
	...s EffDate=$p($g(^ARCIM(Subscript,Version,7)),"^",1)
	...i EffDate="" s EffDate=+$H+1
	...q:EffDate<+$H
	...q:EffDate<+$h
    ...d OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(iARCIMCode,iARCIMDesc,iARCIMDR)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SearchARCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchARCItemExecute ]
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

ClassMethod SearchARCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchARCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Save(ARCIMDR, IllFlag, AllFlag)
{
    s ^zl("save")=ARCIMDR_"^"_IllFlag_"^"_AllFlag
    if IllFlag="true"  s IllFlag="Y"
    else  s IllFlag="N"
    if AllFlag="true"  s AllFlag="Y"
    else  s AllFlag="N"
    S EistFlag=0
    //s ^zl("ARCIMDR",ARCIMDR)=$o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ARCIMDR,0))
    i $o(^DHCCRMARCIMEx(0,"AE_ARCIM_DR",ARCIMDR,0))'=""   d
    .s EistFlag=1
    .w "{""success"":""false"",""info"":""医嘱已存在""}"
    q:EistFlag=1 ""
 
	&sql(insert into DHC_CRM_ARCIMEx
	     (AE_ARCIM_DR,AE_MajorDiseases,AE_SendAllRlt)
	     values 
	     (:ARCIMDR,:IllFlag,:AllFlag)
	     )

	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台插入失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod Delete(AERowId)
{
   
   S ^zl("AERowId")=AERowId
 &sql(delete from DHC_CRM_ARCIMEx where AE_RowId=:AERowId)
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台操作失败!"_SQLCODE_"""}"
    q ""
}

ClassMethod Modify(AERowId, IllFlag, AllFlag)
{
   
   if IllFlag="true"  s IllFlag="Y"
    else  s IllFlag="N"  
   if AllFlag="true"  s AllFlag="Y"
   else  s AllFlag="N"

   &sql(update DHC_CRM_ARCIMEx
	     set AE_MajorDiseases=:IllFlag,AE_SendAllRlt=:AllFlag
	     where AE_RowId=:AERowId)
	     
   
	i (SQLCODE = 0) d
    .w "{""success"":""true"",""info"":"_%ROWID_"}"
    e  d
    .w "{""success"":""false"",""info"":""后台操作失败!"_SQLCODE_"""}"
    q ""
}

//w ##class(web.DHCCRM.ImportantIllSet).Load("","","","","")

ClassMethod Load(start, limit, ARCIMDR, IllFlag, AllFlag)
{
   // s ^zl("Load",1)=start_"^"_limit_"^"_ARCIMDR_"^"_IllFlag
	s start=$G(start)
	s limit=$G(limit)
	s rs=##class(%ResultSet).%New("web.DHCCRM.ImportantIllSet:LoadARCItem")
	d rs.Execute(ARCIMDR,IllFlag,AllFlag)
 	s count=0
 	s mess=""
 	s topnum=start+limit
	while (rs.Next())
 	{
	 	s count=count+1
	 	i (start'="")&(limit'="") continue:(count<=start)!(count>topnum)
	 	
	 	s ARCIMCode=rs.Get("ARCIM_Code")
	 	s ARCIMDesc=rs.Get("ARCIM_Desc")
	 	s ARCIMDR=rs.Get("ARCIM_DR")
	 	s IllFlag=rs.Get("IllFlag")
	 	s AllFlag=rs.Get("AllFlag")
	 	if IllFlag="Y" s IllFlag="true"
	 	else  s IllFlag="flase"
	 	if AllFlag="Y" s AllFlag="true"
	 	else  s AllFlag="flase"
	 	s AERowId=rs.Get("AERowId")
		i (mess'="") s mess=mess_","
		s mess=mess_"{""ARCIMCode"":"_""""_ARCIMCode_""""
		s mess=mess_","_"""ARCIMDesc"":"_""""_ARCIMDesc_""""
		s mess=mess_","_"""ARCIMDR"":"_""""_ARCIMDR_""""
		s mess=mess_","_"""IllFlag"":"_""""_IllFlag_""""
		s mess=mess_","_"""AERowId"":"_""""_AERowId_""""
		s mess=mess_","_"""AllFlag"":"_""""_AllFlag_""""
		s mess=mess_"}"
	}	 
	// s ^zl("Load",2)=mess	 
 	s mess="["_mess_"]"
 	s mess="{""results"":"_""""_count_""""_","_"""rows"""_":"_mess_"}"
 	q mess
}

Query LoadARCItem(iARCIMDR As %String = "", iIllFlag As %String = "", iAllFlag As %String = "") As %Query(ROWSPEC = "ARCIM_Desc:%String,ARCIM_Code:%String,ARCIM_DR:%String,IllFlag:%String,AERowId:%String,AllFlag:%String")
{
}

ClassMethod LoadARCItemExecute(ByRef qHandle As %Binary, iARCIMDR As %String = "", iIllFlag As %String = "", iAllFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//if 
	S AERowId=0
	f  s AERowId=$o(^DHCCRMARCIMEx(AERowId))  q:AERowId=""  d
	.s ARCIMDR=$p(^DHCCRMARCIMEx(AERowId),"^",1)
	.q:(iARCIMDR'="")&&(iARCIMDR'=ARCIMDR)
	.s IllFlag=$p(^DHCCRMARCIMEx(AERowId),"^",2)
	.//q:(iIllFlag'="")&&(iIllFlag'=IllFlag)
	.s AllFlag=$p(^DHCCRMARCIMEx(AERowId),"^",3)
	.s ARCIMSubscript=$P(ARCIMDR,"||",1)
	.s ARCIMVersion=$P(ARCIMDR,"||",2)
	.s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.s ARCIMCode=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
    .d OutputItem
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputItem
	set Data=$lb(ARCIMDesc,ARCIMCode,ARCIMDR,IllFlag,AERowId,AllFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod LoadARCItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LoadARCItemExecute ]
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

ClassMethod LoadARCItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LoadARCItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
