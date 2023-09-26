Import SQLUser

Class web.UDHCJFyjfind Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 213;

ClassMethod findpatientExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, admreasonid As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery(a,b,60578,60578,"")
	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s stdate=$g(stdate)
 	s enddate=$g(enddate)
 	s admreasonid=$g(admreasonid)
	i stdate=""  s stdate=+$h
	i enddate=""  s enddate=+$h
	for i=stdate:1:enddate   d
	.s rowid=0
	.f  s rowid=$o(^PAADMi("PAADM_AdmDate",i,rowid ))  q:rowid=""  d
	..s pttype=$P($g(^PAADM(rowid)),"^",2)
	..q:(pttype'="I")
	..s Tadmreasonid=$P($g(^PAADM(rowid,1)),"^",7)
	..q:((Tadmreasonid'=admreasonid)&(admreasonid'=""))
	..i Tadmreasonid'="" d
	...s Tadmreasonid=$p(Tadmreasonid,$c(1))
    ...s Tadmreason= $p($g(^PAC("ADMREA",Tadmreasonid)),"^",2)
	..s Tadmdate=$P($g(^PAADM(rowid)),"^",6)
	..s Tadmdate=$zd(Tadmdate,3)
	..s Tadmtime=$P($g(^PAADM(rowid)),"^",7)
	..s Tadmtime=$zt(Tadmtime,1)
	..s updateuser=$P($g(^PAADM(rowid)),"^",43)
	..i updateuser'="" d
	...s updateuser=$P(updateuser,$c(1))
	...s Tupdusecode=$P($g(^SSU("SSUSR",updateuser)),"^",1)
	...s Tupdateuser=$P($g(^SSU("SSUSR",updateuser)),"^",2)
	...s Tupdateuser=$P(Tupdateuser,$c(1))
	..s word=$P($g(^PAADM(rowid)),"^",70)
	..i word'="" d
	...s word=$P(word,$c(1))
	...s Tword=$p($g(^PAWARD(word)),"^",2)
	...s Tword=$p(Tword,"-",2)
	..s depid=$P($g(^PAADM(rowid)),"^",4)
   ..i depid'="" d
    ...s Tdepname=$p($g(^CTLOC(depid)),"^",2)
    ...s Tdepname=$p(Tdepname,"-",2)
   ..s papmi=$P($g(^PAADM(rowid)),"^",1)
   ..i papmi'="" d
   ...s papmi=$p(papmi,$c(1))
   ...&sql( select PAPMI_EPRDescription,PAPMI_PAPER_DR into :desc,:personid from sqluser.pa_patmas where papmi_rowid=:papmi )
   ...s Tname=$P($g(desc),",",1)
   ...s Tsex=$p($g(desc),",",3)
   ...s Tregno=$p($g(desc),",",4)
   ...s Tregno=$p(Tregno,$c(1))
   ...s personid=$p(personid,$c(1))
   ...s Tstname=$g(^PAPER(personid,"PER","ADD",1))
   ...s Tsafetynetcar=$P($g(^PAPER(personid,"PAT",3)),"^",4)
   ...&sql(select PAPER_AgeYr,PAPER_AgeMth,PAPER_AgeDay into :age,:mth,:day from sqluser.pa_person where paper_rowid=:personid )
   ...s Tage=$g(age)
   ...i Tage=0 d
   ....s Tage=$g(mth)
   ....i Tage=0 d
   .....s Tage=$g(day)_"天"
   ....else  d
   .....s Tage=$g(mth)_"月"
   ..s Txh=ind
   ..s Tdw=""
   ..d outputrow1
  	s ^tmp("ptnum",1)=ind
	s qHandle=$lb(0,repid,0)
	quit $$$OK

outputrow1
	set Data=$lb(Txh,Tregno,Tsafetynetcar,Tname,Tsex,Tage,Tdw,Tstname,Tdepname,Tadmreason,Tadmdate,Tupdateuser,Tupdusecode,Tadmtime,Tword)
 	Set ^CacheTemp(repid,ind)=Data
 	set ^tmp("patinfo",ind)=Txh_"^"_Tregno_"^"_Tsafetynetcar_"^"_Tname_"^"_Tsex_"^"_Tage_"^"_Tdw_"^"_Tstname_"^"_Tword_"^"_Tdepname_"^"_Tadmreason_"^"_Tadmdate_"^"_Tadmtime_"^"_Tupdateuser_"^"_Tupdusecode
 	Set ind=ind+1
	quit
}

ClassMethod findpatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findpatientExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query findpatient(stdate As %String, enddate As %String, admreasonid As %String) As %Query(ROWSPEC = "Txh:%String,Tregno:%String,Tsafetynetcar:%String,Tname:%String,Tsex:%String,Tage:%String,Tdw:%String,Tstname:%String,Tdepname:%String,Tadmreason:%String,Tadmdate:%String,Tupdateuser:%String,Tupdusecode:%String,Tadmtime:%String,Tword:%String")
{
}

ClassMethod findpatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findpatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
  s num=$g(^tmp("ptnum",1)) 
   q num
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", i)
{
  s str=$g(^tmp("patinfo",i))
   q str
}

ClassMethod gettoday(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
  s date=$zd($h,3)
   q date
}

ClassMethod findtypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findtypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findtypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s rowid1=0
    f  s rowid1=$o(^PAC("ADMREA",rowid1))  q:rowid1=""  d
    .s type1=$p($g(^PAC("ADMREA",rowid1)),"^",2)
    .d outputrow4
 	 s qHandle=$lb(0,repid,0)
  quit $$$OK
outputrow4
	set Data=$lb(type1,rowid1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findtypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findtypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query findtype() As %Query(ROWSPEC = "type:%String,rowid:%String")
{
}

ClassMethod findadminfroClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findadminfroExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findadminfroExecute(ByRef qHandle As %Binary, name As %String, papno As %String) As %Status
{
 ;d ##class(%ResultSet).RunQuery("web.UDHCJFinfro","findadminfro","lihao","")
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	set papno=$g(papno)
	i papno'="" s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	//set name=$g(name)
	set name=$ZCVT($g(name),"U")
	;if (($l(papno)<8) && (papno'=""))  d
	.;s num=$l(papno)+1
	.;f i=num:1:8  d
	..;s papno="0"_papno
	set papid=""
	if papno'=""  d
	.f  s papid=$o(^PAPERi("PAPMI_PatNo",papno,papid))  q:papid=""  d
	..s papid=$p(papid,$c(1))
	..d getadm(papid)
	if (((papno="")||(papno=" ")) && (name'=""))  d
    .f  s papid=$o(^PAPERi("PAPER_PatName",name,papid))  q:papid=""  d
 	..s papid=$p(papid,$c(1))
	..d getadm(papid)
    s qHandle=$lb(0,repid,0)
    quit $$$OK	
	//if Tsex="1"  set Tsex="男" 
	//if Tsex="2"  set Tsex="女" 
	//if Tsex="3"  set Tsex="不确定" 
	//if Tsex="4"  set Tsex="未告知"
getadm(rowid)
    s Tpapno=$p(rowid,$c(1))
    s Tadmname=$p($g(^PAPER(rowid,"ALL")),"^",1)
 	s Tsex=$p($g(^PAPER(rowid,"ALL")),"^",7)	
	s admid=""
	f  s admid=$o(^PAPERdr(rowid,"ADM","I",admid))  q:admid=""  d
	.s Tadmid=$p(admid,$c(1))
	.s admstatus=$p(^PAADM(admid),"^",20)
	.q:admstatus="C"
	.s Tadmdate=$p($g(^PAADM(admid)),"^",6)
	.s Tadmdate=$zd(Tadmdate,3)
	.s Tadmtime=$p($g(^PAADM(admid)),"^",7)
	.s Tadmtime=$zt(Tadmtime)
	.s Tdisdate=$p($g(^PAADM(admid)),"^",17)
	.s Tdisdate=$zd(Tdisdate,3)
	.s Tdistime=$p($g(^PAADM(admid)),"^",18)
	.s Tdistime=$zt(Tdistime)
	.s admreason=$p($p($g(^PAADM(admid,1)),"^",7),$c(1))
	.s Tadmreason=$p($g(^PAC("ADMREA",admreason)),"^",2)
	.s depid=$p($p($g(^PAADM(admid)),"^",4),$c(1))
	.s Tdepdesc=$p($p($g(^CTLOC(depid)),"^",2),"-",2)
	.d outputrow5
	quit
    
outputrow5
	set Data=$lb(Tadmid,Tadmname,Tsex,Tdepdesc,Tadmreason,Tadmdate,Tadmtime,Tdisdate,Tdistime,Tpapno)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findadminfroFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findadminfroExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query findadminfro(name As %String, papno As %String) As %Query(ROWSPEC = "Tadmid:%String,Tadmname:%String,Tsex:%String,Tdepdesc:%String,Tadmreason:%String,Tadmdate:%String,Tadmtime:%String,Tdisdate:%String,Tdistime:%String,Tpapno:%String")
{
}

ClassMethod findbedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findbedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findbedExecute(ByRef qHandle As %Binary, wardid As %String) As %Status
{
 ;d ##class(%ResultSet).RunQuery("web.UDHCJFinfro","findbed","")
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
 	set wardid=$g(wardid)
 	if wardid=""  s qHandle=$lb(0,repid,0)    quit $$$OK
	set roomid=0
	f  s roomid=$o(^PAADMi("CurrWard",wardid,roomid))  q:roomid=""  d
    .s rowid=0
	.f  s rowid=$o(^PAADMi("CurrWard",wardid,roomid,rowid))  q:rowid=""   d                        
    ..s visitstatus=$p($g(^PAADM(rowid)),"^",20)
    ..q:(visitstatus'="A") 
    ..s papno=$p($p($g(^PAADM(rowid)),"^",1),$c(1)) 
    ..s bed=$p($g(^PAADM(rowid)),"^",73)
    ..s admname=$p($g(^PAPER(papno,"ALL")),"^",1) 
    ..d outputrow6      
    s qHandle=$lb(0,repid,0)
    quit $$$OK	
outputrow6
	set Data=$lb(papno,admname,bed)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findbedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findbedExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query findbed(wardid As %String) As %Query(ROWSPEC = "papno:%String,admname:%String,bed:%String")
{
}

ClassMethod findwardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findwardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findwardExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)

 	If $g(ind)="" Set ind=1
	s wardid=0
    f  s wardid=$o(^PAWARD(wardid))  q:wardid=""  d
    .s ward=$p($g(^PAWARD(wardid)),"^",2)
    .d outputrow7
 	 s qHandle=$lb(0,repid,0)
  quit $$$OK
outputrow7
	set Data=$lb(ward,wardid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findwardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findwardExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query findward() As %Query(ROWSPEC = "ward:%String,wardid:%String")
{
}

ClassMethod getadm(itmjs As %Library.String = "", itmjsex As %Library.String = "", papno)
{
  ;d ##class(web.UDHCJFinfro).getadm("","",a)
   i papno'="" s papno=$g(papno)
   s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	s papmi=""
	s str=""
	f  s papmi=$o(^PAPERi("PAPMI_PatNo",papno,papmi)) q:papmi=""  d
	.s name=$p(^PAPER(papmi,"ALL"),"^",1)
	.s zyno=$p(^PAPER(papmi,"PAT",1),"^",22)   ;病案号
	.s Adm=""
	.f  s Adm=$o(^PAPERdr(papmi,"ADM","I",Adm)) q:Adm=""  d  	
	..s visitstatus=$p(^PAADM(Adm),"^",20)
	..;q:visitstatus'="A"
	..s ward=$p(^PAADM(Adm),"^",70)
	..s str=name_"^"_ward
   s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

ClassMethod getinfro(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm)
{
 ; d ##class(web.UDHCJFinfro).getinfro("","",a)
  s Adm=$p(Adm,$c(1))
   s str=""
   s papmi=$p($p($g(^PAADM(Adm)),"^",1),$c(1))
   if papmi'=""  d
   .s name=$p(^PAPER(papmi,"ALL"),"^",1)
   .s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
   .s str=papno_"^"_name
    s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
   i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
   &javascript<#(retval)#>
   q 1
}

}
