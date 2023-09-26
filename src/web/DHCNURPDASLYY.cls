Import SQLUser

Class web.DHCNURPDASLYY Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetADLScore(Adm, EmrCode) As %String
{
 //w ##class(web.DHCNURPDASLYY).GetADLScore("9947742","DHCNURANHUI16")
 s ADLScore=""
 s DHCMoudDataRowid=$o(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_Adm,""))
 q:DHCMoudDataRowid="" "No Record"
 q:'$d(^Nur.DHCMoudDataD(DHCMoudDataRowid)) "No Record"
 s MoudStr=^Nur.DHCMoudDataD(DHCMoudDataRowid)
 s jcScore=$LIST(MoudStr,45)
 s jcScore=..GetFormatScore(jcScore)
 s XZScore=$LIST(MoudStr,46)
 s XZScore=..GetFormatScore(XZScore)
 s XSScore=$LIST(MoudStr,47)
 s XSScore=..GetFormatScore(XSScore)
 s CYScore=$LIST(MoudStr,48)
 s CYScore=..GetFormatScore(CYScore)
 s KDBScore=$LIST(MoudStr,49)
 s KDBScore=..GetFormatScore(KDBScore)
 s KXBScore=$LIST(MoudStr,50)
 s KXBScore=..GetFormatScore(KXBScore)
 s YCScore=$LIST(MoudStr,51)
 s YCScore=..GetFormatScore(YCScore)
 s CYZYScore=$LIST(MoudStr,52)
 s CYZYScore=..GetFormatScore(CYZYScore)
 s PDXZScore=$LIST(MoudStr,53)
 s PDXZScore=..GetFormatScore(PDXZScore)
 s SXLTScore=$LIST(MoudStr,54)
 s SXLTScore=..GetFormatScore(SXLTScore)
 s ADLScore=jcScore+XZScore+XSScore+CYScore+KDBScore+KXBScore+YCScore+CYZYScore+PDXZScore+SXLTScore
 q ADLScore
}

ClassMethod GetFormatScore(value) As %String
{
   s value=$p(value,"!",2)
   s value=$p(value,"  ",2)
   s value=$p(value,"(分)",1)
   q value
}

Query GetOper(ids As %String) As %Query(ROWSPEC = "OPTypeDes:%String")
{
}

ClassMethod GetOperExecute(ByRef qHandle As %Binary, ids As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
   
    s ids=$ZConvert(ids,"U")

	 s id=ids
	 s ln=$L(ids)
	 s im=ids
	 s ret=""
	 if (ids'="") d
	 .s ids=$$ALPHAUP^SSUTIL4(ids)
	 .s flag="N"
	 .s OpDes=$O(^ORC("OPER",0,"ALIAS",ids),-1)
	 .if ids'="" d
	 ..f  s OpDes=$O(^ORC("OPER",0,"ALIAS",OpDes)) q:(OpDes="")!(flag="Y")  d
	 ...i $p(OpDes,ids)'="" s flag="Y" q
	 ...s operId=""
	 ...f  s operId=$O(^ORC("OPER",0,"ALIAS",OpDes,operId)) q:operId=""  d
	 ....s rowid0=operId
	 ....s OPTypeDes=$p(^ORC("OPER",operId),"^",2)
	 ....s OPTypeCode=$p(^ORC("OPER",operId),"^",1)
	 ....s Opcatdr=$p(^ORC("OPER",operId),"^",7)
	 ....i Opcatdr'="" d
	 .....s Opcatdesc=$p(^ORC("CATEG",Opcatdr),"^",2)
	 .....d OutRowtyp
   
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(OPTypeDes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetItemCode(wardid As %String) As %Query(ROWSPEC = "ItemCodeDes:%String")
{
}

ClassMethod GetItemCodeExecute(ByRef qHandle As %Binary, wardid As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCNURPDASLYY","GetItemCode","814")
	
	Set repid=$I(^CacheTemp)
 	s ind=1
   
    s wardid=$ZConvert(wardid,"U")
    s ItemCodeDes=""
	 
	 if (wardid'="") d
	 .s wardid=$$ALPHAUP^SSUTIL4(wardid)
	 .s typ="管道"
	 .s rw=""  f  s rw=$O(^User.DHCNurItemCodeI("CodeIndex"," "_wardid," "_typ,rw)) q:rw=""  d
 	 ..s a=##class(User.DHCNurItemCode).%OpenId(rw)
 	 ..s flag=a.StopFlag
 	 ..s ItemCodeDes=a.ItmDesc
 	 ..q:(wardid'=a.WardId)&&(flag="N")
	 ..d OutputRow
  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutputRow
	set Data=$lb(ItemCodeDes)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetItemCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemCodeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetItemCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
