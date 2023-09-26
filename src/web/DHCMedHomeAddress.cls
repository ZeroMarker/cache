Import SQLUser

Class web.DHCMedHomeAddress Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod QueryHomeAddressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHomeAddressExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryHomeAddressExecute(ByRef qHandle As %Binary, Type As %String, Flag As %String) As %Status
{

	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:Type="" $$$OK
	;^DHCMedHA(0,"Type",{MHA_Type},{MHA_Rowid})
	s Rowid=0
	f  s Rowid=$o(^DHCMedHA(0,"Type",Type,Rowid)) q:Rowid=""  d
	.s tmp=$g(^DHCMedHA(Rowid))
	.q:tmp=""
	.s Active=$p(tmp,"^",9)
	.q:(Flag'="")&&(Flag'=Active)
	.s s=Rowid_"^"_tmp
	.d BuildData

	Quit $$$OK
	
BuildData      
	;set Data=$lb(id,code,desc,Fpfl,Lb)
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryHomeAddressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHomeAddressExecute ]
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

//Query QueryHomeAddress(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,Alias:%String,Type:%String,Text1:%String,Text2:%String,Text3:%String,Text4:%String,IsActive:%String,Resume:%String")

Query QueryHomeAddress(Type As %String, Flag As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

}
