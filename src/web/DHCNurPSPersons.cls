Class web.DHCNurPSPersons Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
   s ^objcyf123(QueryName)=parrm_"^"_funname
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  b
  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_"'"_$ZCVT(rset.GetData(col),"O","JS")_"',"
        }

   s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>

      
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurPSPersons","FindPSPersons","2014-06-01^2014-06-30^S")
Query FindPSPersons(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPSPersonsExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s StDate=$zdh($P(parr,"^",1),3)
	s EndDate=$zdh($P(parr,"^",2),3)
	s Type=$P(parr,"^",3)
	s ID="" f  s ID=$O(^DHCMGNUR.MgPSPersonsI("Type"," "_Type,ID)) q:ID=""  d
	.s a=##class(DHCMGNUR.MgPSPersons).%OpenId(ID)
	.s PersonStDate=a.PersonStDate
	.s PersonEndDate=a.PersonEndDate
	.q:((PersonEndDate'="")&&(PersonEndDate<StDate))||(PersonStDate>EndDate)
	.q:a.PersonStatus="N"
	.s ret=##class(DHCMGNUR.MgPSPersons).getVal(ID)
	.d OutputPerson
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerson      
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPSPersonsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPSPersonsExecute ]
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

ClassMethod FindPSPersonsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPSPersonsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
