Import sqluser

Class web.INSUPatTypeCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 42;

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id="0"
	f  s id=$o(^DHCINPAT(id)) q:id=""  d
	.;w $g(^DHCINSUPatTypeD(id)
	.;&js<alert(#(id)#)>
	.s xx=$g(^DHCINPAT(id))
	.s code=$p(xx,"^",1)    
    .s desc=$p(xx,"^",2)
    .s enab=$p(xx,"^",3)
    .s demo=$p(xx,"^",4)  
	.s fPatSill1=$j($p(xx,"^",5),3,2)
	.s fPatSill2=$j($p(xx,"^",6),3,2)
	.s fPatSill3=$j($p(xx,"^",7),3,2)
	.s fPatTcSelfP1=$j($p(xx,"^",8),3,2)
	.s fPatTcSelfP2=$j($p(xx,"^",9),3,2)
	.s fPatJzSelfP1=$j($p(xx,"^",10),3,2)
	.s fPatJzSelfP2=$j($p(xx,"^",11),3,2)
	.s fPatJzSelfP3=$j($p(xx,"^",12),3,2)
	.s fPatTcSelfP3=$j($p(xx,"^",13),3,2)
	.s fPatFD=$j($p(xx,"^",14),3,2)
    .;s:enab1="1" enab="Yes"
    .;s:enab1'="1" enab="No"
    .;&js<alert(#(enab)#)>
	.d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build      
	set Data=$lb(code,desc,demo,enab,$g(id),fPatSill1,fPatSill2,fPatSill3,fPatTcSelfP1,fPatTcSelfP2,fPatJzSelfP1,fPatJzSelfP2,fPatJzSelfP3,fPatTcSelfP3,fPatFD)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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

Query QueryAll() As %Query(ROWSPEC = "TCode:%String,TDesc:%String,TDemo:%String,TEnable:%String,TId:%String,fPatSill1,fPatSill2,fPatSill3,fPatTcSelfP1,fPatTcSelfP2,fPatJzSelfP1,fPatJzSelfP2,fPatJzSelfP3,fPatTcSelfP3,fPatFD:%String")
{
}

ClassMethod WriteTest(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s val=itmjs_"('"_InString_"');"
	s ^CACHETEMP=val
	;&js<alert(#(val)#)>
	&javascript<#(val)#>
	;&js<alert('111111111')>
	q 0
}

ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s flag=$$Save^DHCINSUPatType(InString)	
	q flag
}

ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", Rowid As %Library.String = "")
{
	q:$d(^DHCINPAT(Rowid))=0 100
	&sql(delete from INSU_PatType where INPAT_RowID=:Rowid)
	q SQLCODE
}

}
