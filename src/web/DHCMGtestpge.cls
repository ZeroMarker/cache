Class web.DHCMGtestpge Extends %CSP.Page [ ProcedureBlock ]
{

// 取患者年龄

ClassMethod GetPatAgeByAdm(Adm As %String) As %String
{
	 s PatRowID=$P(^PAADM(Adm),"^",1)
	 s DOB=$P(^PAPER(PatRowID,"ALL"),"^",6)
	 s EstAgeMonth=$P(^PAPER(PatRowID,"ALL"),"^",16)
     s EstAgeYear=$P(^PAPER(PatRowID,"ALL"),"^",15)
 	 s EstAgeTmStmp=$P(^PAPER(PatRowID,"ALL"),"^",17)
 	 s AgeStr=$$CalAge^at182(DOB,+$H,EstAgeMonth,EstAgeYear,EstAgeTmStmp)
 	 s Year=$P(AgeStr,"|",12)
 	 s Month=$P(AgeStr,"|",13)
 	 s Day=$P(AgeStr,"|",14)
	 q Year
}

Query DHCNurComplexPrnComm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurComplexPrnCommExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurComplexPrn","10986739")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	//s EmrCode=$p(AnaesId,"^",2)
	//s AnaesId=$p(AnaesId,"^",1)
	s EmrCode="DHCNURANHUI22"
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	s CareDate=""
	f  s CareDate=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate)) q:CareDate=""  d
	.s CareTime=""
	.f  s CareTime=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime)) q:CareTime=""  d
	..s subid=""
	..f  s subid=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime,id,subid)) q:subid=""  d
	...s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	...Q:a.RecCancelUser'=""
	...s col=subid
	...s tmp(col,1)=$zd(a.CareDate,3)
	...s tmp(col,2)=$zt(a.CareTime,1)
	...s tmp(col,3)=a.Item1
	...s tmp(col,4)=a.Item2
	...s tmp(col,5)=a.Item3
	...s tmp(col,6)=a.Item4
	...s tmp(col,7)=a.Item5
	...s tmp(col,8)=a.Item6
	...s tmp(col,9)=a.Item7
	...s tmp(col,10)=a.Item8
	...s tmp(col,11)=a.Item9
	...s tmp(col,13)=a.Item11
	...s tmp(col,14)=a.Item12
	...s tmp(col,15)=a.Item13
	...i a.RecUser'="" s tmp(col,12)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...s ret="CareDate|"_$zd(a.CareDate,3)_" "_$zt(a.CareTime,1)_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...d OutRowtyp
	
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurComplexPrnCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurComplexPrnExecute ]
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

ClassMethod DHCNurComplexPrnCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurComplexPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod GetUser(UserCode) As %String
{
	 s ret=$g(UserCode)
	 i ($g(UserCode)'="") s SSUSRRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(UserCode),""))
	 i ($g(SSUSRRowId)'="")&&$d(^SSU("SSUSR",$g(SSUSRRowId))) s ret=$p(^SSU("SSUSR",SSUSRRowId),"^",2)
	 q ret
}

ClassMethod OnPage() As %Status
{

  /// w "{root1:[{a:'a', b:'b'}]}"
  //  s ^T("fffffff")="6666666"

 //   Quit $$$OK
 s ^TM("aa")=%request.Get("start")_"^"_%request.Get("limit")
 w "{d:["
 for i=0:1:10
 {
	if i'=10 w "{s1:"_i_",s2:'"_i_"a'"_"},"
	e  w "{s1:"_i_",s2:'"_i_"a'"_"}"
 }
 w "]}"
    Quit $$$OK
}

Query DHCNurComplexPrn1(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurComplexPrn1Execute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurComplexPrn1","13537074")
	//Parrm = "11010457!!!!!DHCNURANHUI10"
	s AnaesId=$p(AnaesId,"!",1)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI10"
	.Q:a.RecCancelUser'=""
	.;s col=subid
	.s col=a.CareDate_$zt(a.CareTime,2)
	.s tmp(col,1)=$zd(a.CareDate,3)
	.s tmp(col,2)=$zt(a.CareTime,2)
	.s tmp(col,3)=a.Item39
	.s tmp(col,4)=a.Item40
	.s tmp(col,5)=a.Item41
	.s tmp(col,6)=a.Item42
	.s tmp(col,7)=a.Item43
	.s tmp(col,8)=a.Item44
	.s tmp(col,9)=a.CaseMeasure
	.s tmp(col,10)=a.Item46
	.b  ;www
	.i a.RecUser'="" s tmp(col,12)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)

	S I=1
  	s rw=1  f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s ret="CareDate|"_$G(tmp(rw,1))_"^CareTime|"_$G(tmp(rw,2))_"^Item39|"_$G(tmp(rw,3))_"^Item40|"_$g(tmp(rw,4))_"^Item41|"_$g(tmp(rw,5))_"^Item42|"_$g(tmp(rw,6))_"^Item43|"_$g(tmp(rw,7))_"^Item44|"_$g(tmp(rw,8))_"^CaseMeasure|"_$g(tmp(rw,9))_"^Item46|"_$g(tmp(rw,10))_"^User|"_$g(tmp(rw,12))
  	.S I=I+1
  	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurComplexPrn1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurComplexPrn1Execute ]
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

ClassMethod DHCNurComplexPrn1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurComplexPrn1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query DHCNurComplexPrn(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurComplexPrnExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurComplexPrn","10986739")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s AnaesId=$p(AnaesId,"!")
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	
	s CareDate=""
	f  s CareDate=$o(^Nur.DHCNurseRecSubI("TypDatTim"," DHCNURANHUI9",CareDate)) q:CareDate=""  d
	.s CareTime=""
	.f  s CareTime=$o(^Nur.DHCNurseRecSubI("TypDatTim"," DHCNURANHUI9",CareDate,CareTime)) q:CareTime=""  d
	..s subid=""
	..f  s subid=$o(^Nur.DHCNurseRecSubI("TypDatTim"," DHCNURANHUI9",CareDate,CareTime,id,subid)) q:subid=""  d
	...s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	...Q:a.RecCancelUser'=""
	...s col=subid
	...s tmp(col,1)=$zd(a.CareDate,3)
	...s tmp(col,2)=$zt(a.CareTime,1)
	...s tmp(col,3)=a.Item44
	...s tmp(col,4)=a.Item45
	...s tmp(col,5)=a.Item46
	...s tmp(col,6)=a.Item47
	...s tmp(col,7)=a.Item48
	...s tmp(col,8)=a.Item49
	...s tmp(col,9)=a.CaseMeasure
	...s tmp(col,10)=a.Item41
	...s tmp(col,11)=a.Item11
	...s tmp(col,13)=a.Item36
	...s tmp(col,14)=a.Item37
	...s tmp(col,15)=a.Item39
	...s tmp(col,16)=a.Item50
	...b ;11
	...i a.RecUser'="" s tmp(col,12)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...s ret="CareDate|"_$zd(a.CareDate,3)_"/"_$zt(a.CareTime,1)_"^Item44|"_a.Item44_"^Item45|"_a.Item45_"^Item46|"_a.Item46_"^Item47|"_a.Item47_"^Item48|"_a.Item48_"^Item49|"_a.Item49_"^CaseMeasure|"_a.CaseMeasure_"^Item41|"_a.Item41_"^Item11|"_a.Item11_"^Item36|"_a.Item36_"^Item37|"_a.Item37_"^Item39|"_a.Item39_"^Item50|"_a.Item50_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7
	...d OutRowtyp
	
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurComplexPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurComplexPrnExecute ]
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

ClassMethod DHCNurComplexPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurComplexPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query DHCNurOperComplexPrn(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurOperComplexPrnExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	s tmp("gm")=AnaesId
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurOperComplexPrn","9606237")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI15"
	.Q:a.RecCancelUser'=""
	.s RecAuditUser="",RecUser=""
	.s col=a.CareDate
	.s colsub=$zt(a.CareTime,2)_$zt(a.RecTime,2)_subid
	.s tmp(col,colsub,1)=$zd(a.CareDate,3)
	.s tmp(col,colsub,2)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(col,colsub,3)=a.Item35
	.s tmp(col,colsub,4)=a.Item36
	.s tmp(col,colsub,5)=a.Item37
	.s tmp(col,colsub,6)=a.Item38
	.s tmp(col,colsub,16)=a.Item39
	.s tmp(col,colsub,7)=a.Item40
	.s tmp(col,colsub,8)=a.Item41
	.s tmp(col,colsub,9)=a.Item42
	.s tmp(col,colsub,10)=a.Item43
	.s tmp(col,colsub,11)=a.Item44
	.s tmp(col,colsub,12)=a.Item45
	.s tmp(col,colsub,13)=a.Item46
	.s tmp(col,colsub,14)=a.Item47
	.s tmp(col,colsub,18)=a.Item48
	.s tmp(col,colsub,15)=a.CaseMeasure_""
	.b ;00
	.i a.RecAuditUser'="" s RecAuditUser=$p($g(^SSU("SSUSR",a.RecAuditUser)),"^",2)
	.i a.RecUser'="" s RecUser=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	.s RecUser=$g(RecUser)_" "_$g(RecAuditUser)
	.i RecUser'="" s tmp(col,colsub,17)=RecUser
	.//i a.RecUser'="" s tmp(col,colsub,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	.//s tmp(id,subid,1)=$zd(a.CareDate,3)
	.//s tmp(id,subid,2)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.//s tmp(id,subid,3)=a.Item35
	.//s tmp(id,subid,4)=a.Item36
	.//s tmp(id,subid,5)=a.Item37
	.//s tmp(id,subid,6)=a.Item38
	.//s tmp(id,subid,16)=a.Item39
	.//s tmp(id,subid,7)=a.Item40
	.//s tmp(id,subid,8)=a.Item41
	.//s tmp(id,subid,9)=a.Item42
	.//s tmp(id,subid,10)=a.Item43
	.//s tmp(id,subid,11)=a.Item44
	.//s tmp(id,subid,12)=a.Item45
	.//s tmp(id,subid,13)=a.Item46
	.//s tmp(id,subid,14)=a.Item47
	.//s tmp(id,subid,15)=a.CaseMeasure_""
	.//i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,1))_"/"_$G(tmp(rw,rwsub,2))_"^Item35|"_$G(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,4))_"^Item37|"_$g(tmp(rw,rwsub,5))_"^Item38|"_$g(tmp(rw,rwsub,6))_"/"_$g(tmp(rw,rwsub,16))_"^Item40|"_$g(tmp(rw,rwsub,7))_"^Item41|"_$g(tmp(rw,rwsub,8))_"^Item42|"_$g(tmp(rw,rwsub,9))_"^Item43|"_$g(tmp(rw,rwsub,10))_"^Item44|"_$g(tmp(rw,rwsub,11))_"^Item45|"_$g(tmp(rw,rwsub,12))_"^Item46|"_$g(tmp(rw,rwsub,13))_"^Item47|"_$g(tmp(rw,rwsub,14))_"^Item48|"_$G(tmp(rw,rwsub,18))_"^CaseMeasure|"_$g(tmp(rw,rwsub,15))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/*ClassMethod DHCNurOperComplexPrnExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurOperComplexPrn","9606237")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI15"
	.Q:a.RecCancelUser'=""
	.s col=subid
	.s tmp(col,1)=$zd(a.CareDate,3)
	.s tmp(col,2)=$zt(a.CareTime,3)
	.s tmp(col,3)=a.Item35
	.s tmp(col,4)=a.Item36
	.s tmp(col,5)=a.Item37
	.s tmp(col,6)=a.Item38
	.s tmp(col,16)=a.Item39
	.s tmp(col,7)=a.Item40
	.s tmp(col,8)=a.Item41
	.s tmp(col,9)=a.Item42
	.s tmp(col,10)=a.Item43
	.s tmp(col,11)=a.Item44
	.s tmp(col,12)=a.Item45
	.s tmp(col,13)=a.Item46
	.s tmp(col,14)=a.Item47
	.s tmp(col,15)=a.CaseMeasure
	.i a.RecUser'="" s tmp(col,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1  f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s ret="CareDateTim|"_$G(tmp(rw,1))_"/"_$G(tmp(rw,2))_"^Item35|"_$G(tmp(rw,3))_"^Item36|"_$g(tmp(rw,4))_"^Item37|"_$g(tmp(rw,5))_"^Item38|"_$g(tmp(rw,6))_"/"_$g(tmp(rw,16))_"^Item40|"_$g(tmp(rw,7))_"^Item41|"_$g(tmp(rw,8))_"^Item42|"_$g(tmp(rw,9))_"^Item43|"_$g(tmp(rw,10))_"^Item44|"_$g(tmp(rw,11))_"^Item45|"_$g(tmp(rw,12))_"^Item46|"_$g(tmp(rw,13))_"^Item47|"_$g(tmp(rw,14))_"^CaseMeasure|"_$g(tmp(rw,15))_"^User|"_$g(tmp(rw,17))_"^DiagnosDr|"_""
  	.S I=I+1
  	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}*/
ClassMethod DHCNurOperComplexPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurOperComplexPrnExecute ]
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

ClassMethod DHCNurOperComplexPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurOperComplexPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 二次围手术护理单打印问题

Query DHCNurOperComplexPrnWss2(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurOperComplexPrnWss2Execute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	s tmp("gm")=AnaesId
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurOperComplexPrnWss2","9606237")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI15_wss2"
	.Q:a.RecCancelUser'=""
	.s RecAuditUser="",RecUser=""
	.s col=a.CareDate
	.s colsub=$zt(a.CareTime,2)_$zt(a.RecTime,2)
	.s tmp(col,colsub,1)=$zd(a.CareDate,3)
	.s tmp(col,colsub,2)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(col,colsub,3)=a.Item35
	.s tmp(col,colsub,4)=a.Item36
	.s tmp(col,colsub,5)=a.Item37
	.s tmp(col,colsub,6)=a.Item38
	.s tmp(col,colsub,16)=a.Item39
	.s tmp(col,colsub,7)=a.Item40
	.s tmp(col,colsub,8)=a.Item41
	.s tmp(col,colsub,9)=a.Item42
	.s tmp(col,colsub,10)=a.Item43
	.s tmp(col,colsub,11)=a.Item44
	.s tmp(col,colsub,12)=a.Item45
	.s tmp(col,colsub,13)=a.Item46
	.s tmp(col,colsub,14)=a.Item47
	.s tmp(col,colsub,18)=a.Item48
	.s tmp(col,colsub,15)=a.CaseMeasure_""
	.//b ;00
	.i a.RecAuditUser'="" s RecAuditUser=$p($g(^SSU("SSUSR",a.RecAuditUser)),"^",2)
	.i a.RecUser'="" s RecUser=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	.s RecUser=$g(RecUser)_" "_$g(RecAuditUser)
	.i RecUser'="" s tmp(col,colsub,17)=RecUser
	.//i a.RecUser'="" s tmp(col,colsub,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	.//s tmp(id,subid,1)=$zd(a.CareDate,3)
	.//s tmp(id,subid,2)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.//s tmp(id,subid,3)=a.Item35
	.//s tmp(id,subid,4)=a.Item36
	.//s tmp(id,subid,5)=a.Item37
	.//s tmp(id,subid,6)=a.Item38
	.//s tmp(id,subid,16)=a.Item39
	.//s tmp(id,subid,7)=a.Item40
	.//s tmp(id,subid,8)=a.Item41
	.//s tmp(id,subid,9)=a.Item42
	.//s tmp(id,subid,10)=a.Item43
	.//s tmp(id,subid,11)=a.Item44
	.//s tmp(id,subid,12)=a.Item45
	.//s tmp(id,subid,13)=a.Item46
	.//s tmp(id,subid,14)=a.Item47
	.//s tmp(id,subid,15)=a.CaseMeasure_""
	.//i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,1))_"/"_$G(tmp(rw,rwsub,2))_"^Item35|"_$G(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,4))_"^Item37|"_$g(tmp(rw,rwsub,5))_"^Item38|"_$g(tmp(rw,rwsub,6))_"/"_$g(tmp(rw,rwsub,16))_"^Item40|"_$g(tmp(rw,rwsub,7))_"^Item41|"_$g(tmp(rw,rwsub,8))_"^Item42|"_$g(tmp(rw,rwsub,9))_"^Item43|"_$g(tmp(rw,rwsub,10))_"^Item44|"_$g(tmp(rw,rwsub,11))_"^Item45|"_$g(tmp(rw,rwsub,12))_"^Item46|"_$g(tmp(rw,rwsub,13))_"^Item47|"_$g(tmp(rw,rwsub,14))_"^Item48|"_$G(tmp(rw,rwsub,18))_"^CaseMeasure|"_$g(tmp(rw,rwsub,15))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/*ClassMethod DHCNurOperComplexPrnExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurOperComplexPrn","9606237")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI15"
	.Q:a.RecCancelUser'=""
	.s col=subid
	.s tmp(col,1)=$zd(a.CareDate,3)
	.s tmp(col,2)=$zt(a.CareTime,3)
	.s tmp(col,3)=a.Item35
	.s tmp(col,4)=a.Item36
	.s tmp(col,5)=a.Item37
	.s tmp(col,6)=a.Item38
	.s tmp(col,16)=a.Item39
	.s tmp(col,7)=a.Item40
	.s tmp(col,8)=a.Item41
	.s tmp(col,9)=a.Item42
	.s tmp(col,10)=a.Item43
	.s tmp(col,11)=a.Item44
	.s tmp(col,12)=a.Item45
	.s tmp(col,13)=a.Item46
	.s tmp(col,14)=a.Item47
	.s tmp(col,15)=a.CaseMeasure
	.i a.RecUser'="" s tmp(col,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1  f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s ret="CareDateTim|"_$G(tmp(rw,1))_"/"_$G(tmp(rw,2))_"^Item35|"_$G(tmp(rw,3))_"^Item36|"_$g(tmp(rw,4))_"^Item37|"_$g(tmp(rw,5))_"^Item38|"_$g(tmp(rw,6))_"/"_$g(tmp(rw,16))_"^Item40|"_$g(tmp(rw,7))_"^Item41|"_$g(tmp(rw,8))_"^Item42|"_$g(tmp(rw,9))_"^Item43|"_$g(tmp(rw,10))_"^Item44|"_$g(tmp(rw,11))_"^Item45|"_$g(tmp(rw,12))_"^Item46|"_$g(tmp(rw,13))_"^Item47|"_$g(tmp(rw,14))_"^CaseMeasure|"_$g(tmp(rw,15))_"^User|"_$g(tmp(rw,17))_"^DiagnosDr|"_""
  	.S I=I+1
  	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}*/
ClassMethod DHCNurOperComplexPrnWss2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurOperComplexPrnWss2Execute ]
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

ClassMethod DHCNurOperComplexPrnWss2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurOperComplexPrnWss2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 2-27

Query DHCNurANHUI26(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurANHUI26Execute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurANHUI26","11808461")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI26"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(id,subid,13)=a.Item13
	.s tmp(id,subid,14)=a.Item14
	.s tmp(id,subid,15)=a.Item15
	.s tmp(id,subid,1)=a.Item1
	.s tmp(id,subid,2)=a.Item2
	.s tmp(id,subid,3)=a.Item3
	.s tmp(id,subid,4)=a.Item4
	.s tmp(id,subid,5)=a.Item5
	.s tmp(id,subid,6)=a.Item6
	.s tmp(id,subid,7)=a.Item7
	.s tmp(id,subid,8)=a.Item8
	.s tmp(id,subid,9)=a.Item9
	.s tmp(id,subid,10)=a.Item10
	.s tmp(id,subid,11)=a.Item11
	.s tmp(id,subid,12)=a.Item12
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurANHUI26Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurANHUI26Execute ]
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

ClassMethod DHCNurANHUI26Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurANHUI26Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 手术介入打印2

Query DHCNurANHUI33(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurANHUI33Execute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurANHUI26","11808461")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI33"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(id,subid,13)=a.Item13
	.s tmp(id,subid,14)=a.Item14
	.s tmp(id,subid,15)=a.Item15
	.s tmp(id,subid,1)=a.Item1
	.s tmp(id,subid,2)=a.Item2
	.s tmp(id,subid,3)=a.Item3
	.s tmp(id,subid,4)=a.Item4
	.s tmp(id,subid,5)=a.Item5
	.s tmp(id,subid,6)=a.Item6
	.s tmp(id,subid,7)=a.Item7
	.s tmp(id,subid,8)=a.Item8
	.s tmp(id,subid,9)=a.Item9
	.s tmp(id,subid,10)=a.Item10
	.s tmp(id,subid,11)=a.Item11
	.s tmp(id,subid,12)=a.Item12
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurANHUI33Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurANHUI33Execute ]
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

ClassMethod DHCNurANHUI33Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurANHUI33Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 手术介入打印3

Query DHCNurANHUI34(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurANHUI34Execute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurANHUI26","11808461")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURANHUI34"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(id,subid,13)=a.Item13
	.s tmp(id,subid,14)=a.Item14
	.s tmp(id,subid,15)=a.Item15
	.s tmp(id,subid,1)=a.Item1
	.s tmp(id,subid,2)=a.Item2
	.s tmp(id,subid,3)=a.Item3
	.s tmp(id,subid,4)=a.Item4
	.s tmp(id,subid,5)=a.Item5
	.s tmp(id,subid,6)=a.Item6
	.s tmp(id,subid,7)=a.Item7
	.s tmp(id,subid,8)=a.Item8
	.s tmp(id,subid,9)=a.Item9
	.s tmp(id,subid,10)=a.Item10
	.s tmp(id,subid,11)=a.Item11
	.s tmp(id,subid,12)=a.Item12
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurANHUI34Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurANHUI34Execute ]
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

ClassMethod DHCNurANHUI34Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurANHUI34Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod GetFHPrnValComm(parr) As %String
{
 
    //w ##class(web.DHCNurMouldDataComm).GetPrnValComm("@285665@DHCNURHYD_Assessment@DHCNURHYD_DisSummary")
	
	
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)
    
    s parrtmp="@"_Adm_"@"_RecTyp_"@"_""
    s ParrFlag=$P(parrtmp,"@",1)	
	s AnaesIDOrEpisodeID=$P(parrtmp,"@",2)
	q:AnaesIDOrEpisodeID="" ""
    
    s ret=""
    //从第3分隔值开始为模版的代码
    f ii=3:1:$l(parrtmp,"@") d
	.s curEmrCode=$p(parrtmp,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .s curRet=##class(Nur.DHCMoudData).getVal(curId)
    .s ret=ret_$TR(curRet,"|","&")
	
	
	
	s ParrFlag=$P(parr,"@",1)	
	s AnaesIDOrEpisodeID=$P(parr,"@",2)
	q:AnaesIDOrEpisodeID="" ""
    s ret=""
    //从第3分隔值开始为模版的代码
    f ii=3:1:$l(parr,"@") d
	.s curEmrCode=$p(parr,"@",ii)
	.i ParrFlag'="OP" s curId=##class(Nur.DHCMoudData).GetId(curEmrCode,AnaesIDOrEpisodeID)
	.e  s curId=##class(Nur.DHCMoudData).GetAnaesId(curEmrCode,AnaesIDOrEpisodeID)
    .q:curId=""
    .s curRet=##class(Nur.DHCMoudData).getVal(curId)
    .s ret=ret_$TR(curRet,"|","&")
    q ret
}

Query GetFHCareRecComm(parr1 As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetFHCareRecCommExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="18187850"!2015-08-18!01:15!!!DHCNURANHUI202"
 	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","GetFHCareRecComm","29!!!!!DHCNURANHUI29!")
	s Adm=$P(parr,"!",1)
	s RecTyp=$P(parr,"!",6)
	s stdate=$P(parr,"!",2)
	s StTime=$P(parr,"!",3)   
      s ^objcyf333(parr)=""
	b
	if stdate=""
	{
		s arr=##class(Nur.DHCNursePrintRec).getstdatetim(RecTyp,Adm)
		//"0^0^"_stdate_"^"_stim_"^^"
		s stdate=$P(arr,"^",3)
		s StTime=$P(arr,"^",4)
		b ;1
	}
	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	i StTime'="" s StTime=$ZTH(StTime,3)
 	if $P(parr,"!",2)'="" s stdate=$ZDH($P(parr,"!",2),3)
 	if $P(parr,"!",4)'="" s eddate=$ZDH($P(parr,"!",4),3)
 	e  s eddate=$P($H,",")
 	if $P(parr,"!",3)'="" s StTime=$ZTH($P(parr,"!",3))
 	if $P(parr,"!",5)'="" s EndTime=$ZTH($P(parr,"!",5))
 	e  s EndTime=$P($H,",",2)
 	s stdatetime=..GetAbsTime(stdate_","_StTime)
 	s endatetime=..GetAbsTime(eddate_","_EndTime)
 	//s RecTyp=$P(parr,"!",6)
 	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_Adm,""))
    if par=""  Set qHandle=$lb(0,repid,0)	Quit $$$OK
    s fdatetim=""
	s dat="" f  s dat=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat)) q:(dat="")!(fdatetim'="")  d
    .s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim)) q:(tim="")!(fdatetim'="")  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,dat,tim,par,rw)) q:(rw="")!(fdatetim'="")  d
    ...s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
    ...s fdate=$listget(arr,3),ftime=$listget(arr,4)
    ...s fdatetim=..GetAbsTime($G(fdate)_","_$G(ftime))
	//血压及显示到病情变化列
	s ret=##class(Nur.DHCNurseRecSet).getSet(RecTyp)
	s PartInProperty=$P(ret,"^",3)
	s PartInNameProperty=$P(PartInProperty,"&",1)
	s PartInAmountProperty=$P(PartInProperty,"&",2)
	s PartOutProperty=$P(ret,"^",4)
	s PartOutNameProperty=$P(PartOutProperty,"&",1)
	s PartOutAmountProperty=$P(PartOutProperty,"&",2)
	//s Pressure=$P(ret,"^",5)
	s CaseMeasureItem=$P(ret,"^",7)
    s PrnItm=$P(ret,"^",5)
    b "lgl"
	f date=stdate:1:eddate
	{   
        s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim)) q:tim=""  d
        .s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,date,tim,par,rw)) q:rw=""  d
        ..s arr=^Nur.DHCNurseRecSubD(par,rw)
        ..s tmp=""
        ..b "qse"
        ..s a=##class(Nur.DHCNurseRecSub).getVal(par_"||"_rw,.tmp)
        ..s cdate=tmp("CareDate"),ctime=tmp("CareTime")
        ..s cdatetime=..GetAbsTime(cdate_","_ctime)
        ..//除了第一条 和打印记录相同的过滤掉
        ..if (fdatetim'=cdatetime)&(cdatetime=stdatetime) q
        ..q:((cdatetime>endatetime)!(cdatetime<stdatetime))
		..s cdate=$ZD(cdate,3),ctime=$ZT(ctime)
		..b "odj"
		..//作废护理记录不打印
		..s reccanceluserId=tmp("RecCancelUser")
		..q:reccanceluserId'=""
		..s CaseMeasure=tmp("CaseMeasure")
		..s CareDate=cdate,CareTime=ctime
		..s tmp("CareDateTim")=CareDate_"/"_CareTime
		..s CareDate=$P(CareDate,"-",2)_"-"_$P(CareDate,"-",3)
		..s CareTime=$P(CareTime,":",1)_":"_$P(CareTime,":",2)
		..if RecTyp="DHCNURANHUI30" s CareDate=CareDate_"/"_CareTime
		..if RecTyp="DHCNURANHUI29" s CareDate=CareDate_"/"_CareTime
		..if RecTyp="DHCNURANHUI28" s CareDate=CareDate_"/"_CareTime
		..s tmp("CareDate")=CareDate,tmp("CareTime")=CareTime
		..s recuserId=tmp("RecUser")
		..i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
		..e  s tmp("User")=""
		..s recaudituserId=tmp("RecAuditUser")
		..i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
		..e  s AuditUser=""
		..i AuditUser'="" d
		...s tmp("User")=tmp("User")_" "_AuditUser
		..//s DiagnosDr=tmp("DiagnosDr")
		..for nn=1:1:$l(PrnItm,"/") d
		...s itm=$P(PrnItm,"/",nn)
		...q:itm=""
		...s tmp($P(itm,"&"))=..getitmdata(itm,.tmp)
		..s tmp("CaseMeasure")=..getcasedata(CaseMeasureItem,.tmp)_tmp("CaseMeasure")
		..s aa=..getRet(.tmp)
		..d OutRowtyp
 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFHCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFHCareRecCommExecute ]
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

ClassMethod GetFHCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFHCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod getitmdata(itm, tmp) As %String
{
   s ret=""
   for i=1:1:$L(itm,"&")
   {
      s code=$P(itm,"&",i)
      if code=""  continue
      if ($P(itm,"&",(i+1))="")
      {
	      s ret=ret_tmp(code)
	  }else{
         s ret=ret_tmp(code)_"/"
	  }
   }
   q ret
}

ClassMethod getcasedata(itm, tmp) As %String
{
   s ret=""
   for i=1:1:$L(itm,"&")
   {
      s cc=$P(itm,"&",i)
      if cc=""  continue
      s code=$P(cc,"!")
      s titl=$P(cc,"!",2)
      
      s ret=ret_titl_":"_tmp(code)_" "
   }
   q ret
}

ClassMethod getRet(tmp) As %String
{
	s k=""
	s ret=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
 q ret
}

ClassMethod GetScore(EmrCode, EpisodeId) As %String
{
	//w ##class(web.DHCMGtestpge).GetScore("DHCNURANHUI21","134")
	s ret=""
	
	s curId="" 
	if (EmrCode'="")&(EpisodeId'="")
	{
	 s flag="false"
	 s code=$ZConvert(EmrCode,"U")
	 s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,id)) q:id=""  d
	 .q:flag="ture"
	 .s b=##class(Nur.DHCMoudData).%OpenId(id)
	 .i (b.RecCancelUser="")  s flag="ture", curId=id  //取第一条记录的值
	}
	//q id
	//b  ;
	//s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
    i (curId="") q ret
    //s curRet=##class(Nur.DHCMoudData).getVal(curId)
    s c=##class(Nur.DHCMoudData).%OpenId(curId)
    b ;22
	s ret=c.Item53_"^"_c.Item27_"^"_c.Item34_"^"_c.Item40_"^"_c.Item72
	//s ret=
	q ret
}

// 获取儿科专项评估单的值

ClassMethod ChildGetScore(EmrCode, EpisodeId) As %String
{
	//w ##class(web.DHCMGtestpge).ChildGetScore("DHCNURANHUI24","309")
	s ret=""
	
	s curId="" 
	if (EmrCode'="")&(EpisodeId'="")
	{
	 s flag="false"
	 s code=$ZConvert(EmrCode,"U")
	 s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,id)) q:id=""  d
	 .q:flag="ture"
	 .s b=##class(Nur.DHCMoudData).%OpenId(id)
	 .i (b.RecCancelUser="")  s flag="ture", curId=id  //取第一条记录的值
	}
	//q id
	
	//s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
    i (curId="") q ret
    //s curRet=##class(Nur.DHCMoudData).getVal(curId)
    s bb=##class(Nur.DHCMoudData).%OpenId(curId)
    s ADLScore=bb.Item12
    s BrendScore=bb.Item13
    s DDZCScore=bb.Item14
    s GLHTScore=bb.Item20
	s ret=ADLScore_"^"_BrendScore_"^"_DDZCScore_"^"_GLHTScore
	//s ret=
	q ret
}

// W ##class(web.DHCMGtestpge).DDGetScore1("DHCNURANHUI21","50^")

ClassMethod DDGetScore(EmrCode, EpisodeId) As %String
{
	s rowid=$p(EpisodeId,"^",2)
	//q:rowid="" ""
	s EpisodeId=$p(EpisodeId,"^",1)
	s ret=""
	s curId="" //##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
	s code=$ZConvert(EmrCode,"U")
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,id)) q:(id="")!(curId'="")  d
	.s b=##class(Nur.DHCMoudData).%OpenId(id)
	.q:b.Status="C"
	.s curId=id
	.b ;3444
	b ;33
    i (curId="") q ret
    i rowid'=""  s curId=rowid
    b ;
    s obj=##class(Nur.DHCMoudData).%OpenId(curId)
    b ;
    s ret=obj.Item28_"^"_obj.Item29_"^"_obj.Item60_"^"_obj.Item30_"^"_obj.Item31_"^"_obj.Item32_"^"_obj.Item33_"^"_obj.Item34
    //w !,curRet
	//s ret=$p($p(curRet,"^",28),"!",1)_"^"_$p($p(curRet,"^",29),"!",1)_"^"_$p($p(curRet,"^",64),"!",1)_"^"_$p($p(curRet,"^",31),"!",1)_"^"_$p($p(curRet,"^",32),"!",1)_"^"_$p($p(curRet,"^",33),"!",1)_"^"_$p($p(curRet,"^",34),"!",1)_"^"_$p(curRet,"^",35)
	//s ret=
	q ret
	
	
	
	//w ##class(web.DHCMGtestpge).GetDDScore("DHCNURANHUI16",9606237)
	//s ret=""
	//s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
    //i (curId="") q ret
    //s curRet=##class(Nur.DHCMoudData).getVal(curId)
    //w !,curRet
	//s ret=$p($p(curRet,"^",28),"!",1)_"^"_$p($p(curRet,"^",29),"!",1)_"^"_$p($p(curRet,"^",64),"!",1)_"^"_$p($p(curRet,"^",31),"!",1)_"^"_$p($p(curRet,"^",32),"!",1)_"^"_$p($p(curRet,"^",33),"!",1)_"^"_$p($p(curRet,"^",34),"!",1)_"^"_$p(curRet,"^",35)
	//s ret=
	//q ret
}

ClassMethod YCGetScore(EmrCode, EpisodeId) As %String
{
	//w ##class(web.DHCMGtestpge).YCGetScore("DHCNURANHUI16",9606237)
	s rowid=$p(EpisodeId,"^",2)
	q:rowid="" ""
	s EpisodeId=$p(EpisodeId,"^",1)
	s ret=""
	s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
    i (curId="") q ret
    i rowid'=""  s curId=rowid
    s curRet=##class(Nur.DHCMoudData).getVal(curId)
    i curId'="" d
    .s obj=##class(Nur.DHCMoudData).%OpenId(curId)
    .q:obj=""
    .q:obj.RecCancelUser'=""
    .s Item21=obj.Item21
    .s Item22=obj.Item22
    .s Item23=obj.Item23
    .s Item24=obj.Item24
    .s Item25=obj.Item25
    .s Item26=obj.Item26
	.s ret=Item21_"^"_Item22_"^"_Item23_"^"_Item24_"^"_Item25_"^"_Item26
	//s ret=
	q ret
}

// 检查护士填写压疮上报在入院科室已经上报院外带入压疮，转科后不可再重复上报

ClassMethod CheckPressureUlcers(EmrCode, EpisodeId) As %String
{
	s ret=0
	s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
	i (curId'="")
	{
		set a=##class(Nur.DHCMoudData).%OpenId(curId)
		s TSkinulcerQuality=$p(a.Item14,"!",1)
		i (TSkinulcerQuality'="压疮高危患者")&&(TSkinulcerQuality'="")
		{
			s ret=1
		}
	}
	q ret
}

// 检查护士填写不可避免压疮上报在入院科室已经上报不可避免压疮压疮，转科后不可再重复上报

ClassMethod CheckAvoidPressureUlcers(EmrCode, EpisodeId) As %String
{
	s ret=0
	s rw=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeId,""))
	i (rw'="")
	{
		s subrowid=""  f  s subrowid=$o(^Nur.DHCNurseRecSubD(rw,subrowid)) q:subrowid=""  d
		.s tmp("Id")=rw_"||"_subrowid
		.s a=##class(Nur.DHCNurseRecSub).%OpenId(tmp("Id"))
		.q:a.RecTyp'=EmrCode
		.i (a.Item36="是")&&(a.RecCancelUser="")  s ret=1
	}
	q ret
}

Query DHCNURSPQuery(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURSPQueryExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//s ^test=Parr
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURKPQuery","2012-05-01^2012-08-27")
	//s userid=%session.Get("LOGON.USERID")   权限控制查后放开
	s aa=""
	s adm=$p(Parr,"^",1)
  	s stdate=$p(Parr,"^",2)
  	s edate=$p(Parr,"^",3)
  	s EmrCode=$p(Parr,"^",4)
  	s logonLoc=$p(Parr,"^",5)
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h
	
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
    .s str=##class(Nur.DHCMoudData).getVal(id)
    .if (EmrCode="DHCNURANHUIZLTYS")&&(a.EmrUser'="") s EmrUser=$p($g(^SSU("SSUSR",a.EmrUser)),"^",2)
    .e  s EmrUser=a.EmrUser
    .s Episode=adm
    .s PatName=$P(patinf,"^",5)
    .s bedcode=$P(patinf,"^",6)
    .s PatCtloc=a.Item4
    .s PatEKSPCtloc=a.Item2 //  儿科四评单科室
    .;s PJDate=$ZD(a.EmrDate,3)
    .s PJDate=a.Item41
    .q:a.EmrDate<stdate
    .q:a.EmrDate>edate
    .q:a.RecCancelUser'=""
    .s PJTime=$ZT(a.EmrTime)
    .s PJNurse=$p(a.Item42,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s EKPJNurse=$p(a.Item41,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s RowId=id 	
	.s aa="Episode"_"|"_Episode_"^"_"PatName"_"|"_$P($g(PatName),"@",2)_"^"_"PatBed"_"|"_$P($g(bedcode),"@",2)_"^"_"PJDate"_"|"_PJDate_"^"_"PJTime"_"|"_PJTime_"^"_"PJNurse"_"|"_PJNurse_"^"_"RowId"_"|"_RowId_"^"_"PatCtloc"_"|"_PatCtloc_"^PatEKSPCtloc|"_PatEKSPCtloc_"^"_"EKPJNurse"_"|"_EKPJNurse_"^"_str_"^"_"EmrUser"_"|"_EmrUser
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURSPQuery1Execute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURKPQuery","2012-05-01^2012-08-27")
	//s userid=%session.Get("LOGON.USERID")   权限控制查后放开
	s aa=""
	s adm=$p(Parr,"^",1)
  	s stdate=$p(Parr,"^",2)
  	s edate=$p(Parr,"^",3)
  	s EmrCode=$p(Parr,"^",4)
  	s logonLoc=$p(Parr,"^",5)
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h
	
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
    .s Episode=adm
    .s PatName=$P(patinf,"^",5)
    .s bedcode=$P(patinf,"^",6)
    .s PatCtloc=a.Item4
    .s PatEKSPCtloc=a.Item2 //  儿科四评单科室
    .s PJDate=$ZD(a.EmrDate,3)
    .q:a.EmrDate<stdate
    .q:a.EmrDate>edate
    .q:a.RecCancelUser'=""
    .s PJTime=$ZT(a.EmrTime)
    .s PJNurse=$p(a.Item42,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s EKPJNurse=$p(a.Item41,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s RowId=id 	
	.s aa="Episode"_"|"_Episode_"^"_"PatName"_"|"_$P($g(PatName),"@",2)_"^"_"PatBed"_"|"_$P($g(bedcode),"@",2)_"^"_"PJDate"_"|"_PJDate_"^"_"PJTime"_"|"_PJTime_"^"_"PJNurse"_"|"_PJNurse_"^"_"RowId"_"|"_RowId_"^"_"PatCtloc"_"|"_PatCtloc_"^PatEKSPCtloc|"_PatEKSPCtloc_"^"_"EKPJNurse"_"|"_EKPJNurse
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURSPQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURSPQueryExecute ]
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

ClassMethod DHCNURSPQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURSPQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DHCMGtestpge).GetSPLIST("11227343^2012-11-16^2012-11-18^DHCNURANHUI21^1209","addSPLIST")

ClassMethod GetSPLIST(parr, funname) As %String
{
	s adm=$p(parr,"^",1)
  	s stdate=$p(parr,"^",2)
  	s edate=$p(parr,"^",3)
  	s EmrCode=$p(parr,"^",4)
  	s logonLoc=$p(parr,"^",5)
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h

    s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
    .s Episode=adm
    .s PatName=$P(patinf,"^",5)
    .s bedcode=$P(patinf,"^",6)
    .s PJDate=$ZD(a.EmrDate,3)
    .s PJTime=$ZT(a.EmrTime)
    .s PJNurse=a.EmrUser
    .s RowId=a.AnaesId 
    .d OutputPatInfo
    q 0
OutputPatInfo
    i funname="" d
    .s ^mtemp($J,"SPLIST",id)=Episode_"^"_PatName_"^"_bedcode_"^"_PJDate_"^"_PJTime_"^"_PJNurse_"^"_RowId
    e  d
    .s rtnval=funname_"('"_$ZCVT($g(Episode),"O","JS")_"','"_$ZCVT($g(PatName),"O","JS")_"','"_$ZCVT($g(bedcode),"O","JS")_"','"_$ZCVT($g(PJDate),"O","JS")_"','"_$ZCVT($G(PJTime),"O","JS")_"','"_$ZCVT($g(PJNurse),"O","JS")_"','"_$ZCVT($g(RowId),"O","JS")_"');"		
	.&javascript<#(rtnval)#>
}

ClassMethod GetFourList(EpisodeId As %String) As %String
{
 //s a=##class(web.DHCMGtestpge).GetFourList(11062752)
     //q:"" ""
     s ret=""
     s EmrCode="DHCNURANHUI21"
    if ($g(EpisodeId)'="")
	{
	 s code=$ZConvert(EmrCode,"U")
	 s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,id)) q:id=""  d
	 .s b=##class(Nur.DHCMoudData).%OpenId(id)
	 .q:(b.RecCancelUser'="")
	 .s rw=id
	 .s date=##class(websys.Conversions).DateLogicalToHtml(b.EmrDate)
	 .s name=date_" "_$zt(b.EmrTime,3)
	 .d ListOutprow
	}
	q ret
	
ListOutprow     
     s ret=ret_rw_"|"_name_"^"     
     q
}

ClassMethod GetPatRecntWeight(EpisodeId As %String) As %String
{
	s ret=""
	s MRADMROWId=$P(^PAADM(EpisodeId),"^",61) 
	s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",chl)) q:chl=""  d
	.s itmdr=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",1)
	.s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	.q:itmcode=""
	.q:itmcode'="Item2"
	.s P1=$P($G(^MR(MRADMROWId,"OBS",chl)),"^",2)
	.i P1'="" s ret=P1
	q ret
}

Query DHCNURGDQuery(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURGDQueryExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//d ##class(%ResultSet).RunQuery("web.DHCBlurQuery","DHCNURKPQuery","2012-05-01^2012-08-27")
	//s userid=%session.Get("LOGON.USERID")   权限控制查后放开
	s aa=""
	s adm=$p(Parr,"^",1)
  	s stdate=$p(Parr,"^",2)
  	s edate=$p(Parr,"^",3)
  	s EmrCode=$p(Parr,"^",4)
  	s logonLoc=$p(Parr,"^",5)
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h
	
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
    .s Episode=adm
    .s PatName=$P(patinf,"^",5)
    .s bedcode=$P(patinf,"^",6)
    .s PatCtloc=a.Item1
    .s PatEKSPCtloc=a.Item2
    .s PJDate=$ZD(a.EmrDate,3)
    .q:a.EmrDate<stdate
    .q:a.EmrDate>edate
    .q:a.RecCancelUser'=""
    .s PJTime=$ZT(a.EmrTime)
    .s PJNurse=$p(a.Item15,"!",2)
    .//s PJNurse=$p(a.Item28,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s EKPJNurse=$p(a.Item41,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s RowId=id 	
	.s aa="Episode"_"|"_Episode_"^"_"PatName"_"|"_$P($g(PatName),"@",2)_"^"_"PatBed"_"|"_$P($g(bedcode),"@",2)_"^"_"PJDate"_"|"_PJDate_"^"_"PJTime"_"|"_PJTime_"^"_"PJNurse"_"|"_PJNurse_"^"_"RowId"_"|"_RowId_"^"_"PatCtloc"_"|"_PatCtloc_"^PatEKSPCtloc|"_PatEKSPCtloc_"^"_"EKPJNurse"_"|"_EKPJNurse
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURGDQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURGDQueryExecute ]
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

ClassMethod DHCNURGDQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURGDQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetCareRecCommExecute(ByRef qHandle As %Binary, Parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="316213^2010-09-21^00:00^2010-09-22^00:00^DHCNUR6"
    //d ##class(%ResultSet).RunQuery("web.DHCNurseRecordComm","GetCareRecComm","9921323^2012-05-02^00:00^2012-05-20^23:59^DHCNURANHUI9^")
 	s aa=""
	s adm=$p(Parr,"^",1)
  	s stdate=$p(Parr,"^",2)
  	s edate=$p(Parr,"^",3)
  	s EmrCode=$p(Parr,"^",4)
  	s logonLoc=$p(Parr,"^",5)
  	s ifCancelRec=$p(Parr,"^",6) //2015-12-16：添加撤销作废
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h
	
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_EmrCode," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s patinf=##class(web.DHCMGNurComm).PatInfo(adm)
    .s Episode=adm
    .s PatName=$P(patinf,"^",5)
    .s bedcode=$P(patinf,"^",6)
    .s PatCtloc=a.Item2
    .i EmrCode="DHCNURJMSY" s PatCtloc=$p($P(patinf,"^",2),"@",2)
    .s PatEKSPCtloc=a.Item2
    .s PJDate=$ZD(a.EmrDate,3)
    .q:a.EmrDate<stdate
    .q:a.EmrDate>edate
    .;q:a.RecCancelUser'=""
    .//添加撤销作废功能********   //2015-12-16：添加撤销作废
    .i ifCancelRec="false" q:a.RecCancelUser'=""
    .e  q:a.RecCancelUser=""
    .//************************
    .s PJTime=$ZT(a.EmrTime)
    .i EmrCode="DHCNURYWSJ" s PJNurse=$p(a.Item4,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .i EmrCode="DHCNURHLCC" s PJNurse=$p(a.Item37,"!",2)
    .i EmrCode="DHCNURJMSY" s PJNurse=$p(a.Item15,"!",2)
    .s EKPJNurse=$p(a.Item41,"!",2)  //$P(^SSU("SSUSR",a.EmrUser),"^",2) //a.EmrUser
    .s RowId=id 	
	.s aa="par"_"|"_RowId_"^"_"Episode"_"|"_Episode_"^"_"PatName"_"|"_$P($g(PatName),"@",2)_"^"_"PatBed"_"|"_$P($g(bedcode),"@",2)_"^"_"PJDate"_"|"_PJDate_"^"_"PJTime"_"|"_PJTime_"^"_"PJNurse"_"|"_PJNurse_"^"_"RowId"_"|"_RowId_"^"_"PatCtloc"_"|"_PatCtloc_"^PatEKSPCtloc|"_PatEKSPCtloc_"^"_"EKPJNurse"_"|"_EKPJNurse
	.d OutRowtyp	 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCareRecCommFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCareRecCommExecute ]
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

ClassMethod GetCareRecCommClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCareRecCommExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCareRecComm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

// 2015-12-16:添加撤销作废功能

ClassMethod GetIfCancelUser(rowid) As %String
{
	s ret=1
	s a=##class(Nur.DHCMoudData).%OpenId(rowid)
	i a.RecCancelUser'="" s ret=0 //作废的记录
	q ret
}

/// 撤销作废
/// 2015-12-16
ClassMethod RevokeCancel(Id As %String, userId As %String, usergroup As %String) As %String
{
	//w ##class(web.DHCNurseRecordComm).CancelRecord(17,259)
	//w ##class(Nur.DHCMoudData).CancelRecord(654948,23309,"住院护士长")
	q:(Id="")!(userId="") "没有选中护理记录或登陆用户为空!"
	s a=##class(Nur.DHCMoudData).%OpenId(Id)
	if a.RecCancelUser="" q "该护理记录已经撤销作废!"
	s recuserId=a.EmrUser
	i recuserId'="" s recuser=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	e  s recuser=""
	//if (usergroup'["护士长")&(userId'=recuserId) q "对不起您无权撤销作废,请联系护士长或"_recuser
	s a.RecCancelUser=""
	s a.RecCancelDate=""
	s a.RecCancelTime=""
	d a.%Save()
	q 0
}

ClassMethod GetDischargeDT(Adm) As %String
{
	s ret=""
 	s rw=0  f  s rw=$O(^DHCADMQTREC("adm",Adm,rw)) q:rw=""  d
	.s TypDr=$P(^DHCADMQTREC("QTREC",rw),"^",4)
	.if TypDr'="" s TypCode=$P(^DHCQTRECTYP("typ",TypDr),"^",1)
	.q:"QtItem7^QtItem6"'[TypCode
	.s ADate=$P(^DHCADMQTREC("QTREC",rw),"^",2)
	.s ATime=$P(^DHCADMQTREC("QTREC",rw),"^",3)
	.if ADate'="" s Date=$ZD(ADate,3)
	.if ATime'="" s Time=$ZT(ATime,2)
	.s ret=ret_Date_"^"_Time
	b ;01
	q ret
}

// 自杀打印3

Query DHCNurANHUIKil(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurANHUIKilExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurANHUIKil","50")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.;b ;0
	.Q:a.RecTyp'="DHCNURANHUIKILL"
	.Q:a.RecCancelUser'=""
	.;b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime,3) //fish20120924修改围手术护理单显示的时间24进制
	.s tmp(id,subid,13)=a.Item51
	.s tmp(id,subid,14)=a.Item52
	.s tmp(id,subid,15)=a.Item53
	.s tmp(id,subid,1)=a.Item54
	.s tmp(id,subid,2)=a.Item55
	.s tmp(id,subid,3)=a.Item56
	.s tmp(id,subid,4)=a.Item57
	.s tmp(id,subid,5)=a.Item58
	.s tmp(id,subid,6)=a.Item59
	.s tmp(id,subid,7)=a.Item60
	.//s tmp(id,subid,8)=a.Item61
	.//s tmp(id,subid,9)=a.Item62
	.//s tmp(id,subid,10)=a.Item63
	.//s tmp(id,subid,11)=a.Item64
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item51|"_$G(tmp(rw,rwsub,13))_"^Item52|"_$g(tmp(rw,rwsub,14))_"^Item53|"_$g(tmp(rw,rwsub,15))_"^Item57|"_$g(tmp(rw,rwsub,4))_"^Item58|"_$g(tmp(rw,rwsub,5))_"^Item54|"_$g(tmp(rw,rwsub,1))_"^Item55|"_$g(tmp(rw,rwsub,2))_"^Item56|"_$g(tmp(rw,rwsub,3))_"^Item59|"_$g(tmp(rw,rwsub,6))_"^Item60|"_$g(tmp(rw,rwsub,7))_"^Item61|"_$g(tmp(rw,rwsub,8))_"^Item62|"_$g(tmp(rw,rwsub,9))_"^Item63|"_$g(tmp(rw,rwsub,10))_"^Item64|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurANHUIKilFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurANHUIKilExecute ]
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

ClassMethod DHCNurANHUIKilClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurANHUIKilExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 下肢静脉打印3   DHCNURANHUILEG

ClassMethod DHCNURANHUILEGExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNURANHUILEG","14517631")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.b ;0
	.Q:a.RecTyp'="DHCNURANHUILEG"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime,2) //fish20120924修改围手术护理单显示的时间24进制
	.;s tmp(id,subid,13)=a.Item51
	.;s tmp(id,subid,14)=a.Item52
	.;s tmp(id,subid,15)=a.Item53
	.s tmp(id,subid,1)=a.Item31
	.s tmp(id,subid,2)=a.Item32
	.s tmp(id,subid,3)=a.Item33
	.s tmp(id,subid,4)=a.Item34
	.s tmp(id,subid,5)=a.Item35
	.s tmp(id,subid,6)=a.Item36
	.s tmp(id,subid,7)=a.Item37
	.s tmp(id,subid,8)=a.Item38
	.;s tmp(id,subid,9)=a.Item62
	.;s tmp(id,subid,10)=a.Item63
	.;s tmp(id,subid,11)=a.Item64
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item51|"_$G(tmp(rw,rwsub,13))_"^Item52|"_$g(tmp(rw,rwsub,14))_"^Item53|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"^Item5|"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item61|"_$g(tmp(rw,rwsub,8))_"^Item62|"_$g(tmp(rw,rwsub,9))_"^Item63|"_$g(tmp(rw,rwsub,10))_"^Item64|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item34|"_$g(tmp(rw,rwsub,4))_"^Item35|"_$g(tmp(rw,rwsub,5))_"^Item31|"_$g(tmp(rw,rwsub,1))_"^Item32|"_$g(tmp(rw,rwsub,2))_"^Item33|"_$g(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,6))_"^Item37|"_$g(tmp(rw,rwsub,7))_"^Item38|"_$g(tmp(rw,rwsub,8))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query DHCNURANHUILEG(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURANHUILEGFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURANHUILEGExecute ]
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

ClassMethod DHCNURANHUILEGClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURANHUILEGExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 下肢静脉打印(新)   DHCNURANHUILEGN

ClassMethod DHCNURANHUILEGNExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNURANHUILEGN","19274446")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.;b ;0
	.Q:a.RecTyp'="DHCNURANHUILEGN"
	.Q:a.RecCancelUser'=""
	.;b ;01
	.s col=a.CareDate
	.s colsub=$zt(a.CareTime,2)
	.s tmp(col,colsub,19)=$zd(a.CareDate,3)
	.s tmp(col,colsub,20)=$zt(a.CareTime,2) //fish20120924修改围手术护理单显示的时间24进制
	.;s tmp(id,subid,13)=a.Item51
	.;s tmp(id,subid,14)=a.Item52
	.;s tmp(id,subid,15)=a.Item53
	.s tmp(col,colsub,1)=a.Item31
	.s tmp(col,colsub,2)=..DHCNURANHUILEGNTRAN(a.Item32)
	.s tmp(col,colsub,3)=..DHCNURANHUILEGNTRAN(a.Item33)
	.s tmp(col,colsub,4)=a.Item34
	.s tmp(col,colsub,5)=..DHCNURANHUILEGNTRAN(a.Item35)
	.s tmp(col,colsub,6)=..DHCNURANHUILEGNTRAN(a.Item36)
	.s tmp(col,colsub,7)=a.Item37
	.s tmp(col,colsub,8)=a.Item38
	.;s tmp(id,subid,9)=a.Item62
	.;s tmp(id,subid,10)=a.Item63
	.;s tmp(id,subid,11)=a.Item64
	.s tmp(col,colsub,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(col,colsub,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item51|"_$G(tmp(rw,rwsub,13))_"^Item52|"_$g(tmp(rw,rwsub,14))_"^Item53|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"^Item5|"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item61|"_$g(tmp(rw,rwsub,8))_"^Item62|"_$g(tmp(rw,rwsub,9))_"^Item63|"_$g(tmp(rw,rwsub,10))_"^Item64|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item34|"_$g(tmp(rw,rwsub,4))_"^Item35|"_$g(tmp(rw,rwsub,5))_"^Item31|"_$g(tmp(rw,rwsub,1))_"^Item32|"_$g(tmp(rw,rwsub,2))_"^Item33|"_$g(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,6))_"^Item37|"_$g(tmp(rw,rwsub,7))_"^Item38|"_$g(tmp(rw,rwsub,8))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query DHCNURANHUILEGN(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURANHUILEGNFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURANHUILEGNExecute ]
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

ClassMethod DHCNURANHUILEGNClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURANHUILEGNExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// d ##Class(web.DHCMGtestpge).DHCNURANHUILEGNTRAN("5,6,7")

ClassMethod DHCNURANHUILEGNTRAN(parr As %String) As %String
{
	s ret=0
	s len=$l(parr,",")
	for i=1:1:len
   {
	  s tmp=$p(parr,",",i)
	  s ret=ret+tmp
   }
   ;b ;0
   q ret
}

// 手术护理单查询

Query DHCNUROperListQuery(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNUROperListQueryExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//s ^test=Parr
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNUROperListQuery","13386545")
	//s userid=%session.Get("LOGON.USERID")   权限控制查后放开
	s aa=""
	s adm=$p(Parr,"^",1)
  	s stdate=$p(Parr,"^",2)
  	s edate=$p(Parr,"^",3)
  	s EmrCode=$p(Parr,"^",4)
  	s logonLoc=$p(Parr,"^",5)
  	i stdate'="" s stdate=$ZDH(stdate,3)
	e  s stdate=+$h-2
	i edate'="" s edate=$ZDH(edate,3)
	e  s edate=+$h
	
	s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURANHUIOPER1"," "_adm,id)) q:id=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(id)
    .s str=##class(Nur.DHCMoudData).getVal(id)
    .s EmrUser=$P(^SSU("SSUSR",a.EmrUser),"^",2)
    .s Episode=adm	
    .s RowId1=id
    .s OperDate=a.Item13
	.s arr(OperDate)="Episode"_"|"_Episode_"^"_str_"^"_"EmrUser"_"|"_EmrUser_"^"_"Item13"_"|"_OperDate_"^"_"RowId1"_"|"_RowId1_"^"_"RowId2"_"|"
	
	s idn="" f  s idn=$O(^Nur.DHCMoudDataI("EmrCode"," DHCNURANHUIOPER2"," "_adm,idn)) q:idn=""  d
    .set a=##class(Nur.DHCMoudData).%OpenId(idn)
    .s RowId2=idn
    .s OperDate=a.Item203
	.i $D(arr(OperDate)) s arr(OperDate)=arr(OperDate)_"^"_"RowId2"_"|"_RowId2
	b ;01
	s n="" f  s n=$O(arr(n)) q:n=""  d
	.s aa=arr(n)
	.do OutPatDetail
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatDetail
	set Data=$lb(aa)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNUROperListQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNUROperListQueryExecute ]
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

ClassMethod DHCNUROperListQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNUROperListQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 手术记录单表格

Query DHCNUROper1Query(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNUROper1QueryExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNUROper1Query","13386545^2014-05-12")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	//s EmrCode=$p(AnaesId,"^",2)
	//s AnaesId=$p(AnaesId,"^",1)
	s AnaesId=$p(parr,"^",1)
	s StDate=$zdh($p(parr,"^",2),3)
	
	s EmrCode="DHCNURANHUIOPER1"
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	b ;1
	s CareDate="" f  s CareDate=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate)) q:CareDate=""  d
	.q:(CareDate<StDate)||(CareDate>(StDate+1))
	.s CareTime="" f  s CareTime=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime)) q:CareTime=""  d
	..s subid="" f  s subid=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime,id,subid)) q:subid=""  d
	...s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	...Q:a.RecCancelUser'=""
	...;s ret="CareDate|"_$zd(a.CareDate,3)_" "_$zt(a.CareTime,1)_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^Item13|"_a.Item13_"^Item14|"_a.Item14_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...s ret="CareDate|"_$zd(a.CareDate,3)_"^CareTime|"_$zt(a.CareTime,2)_"^par|"_id_"^rw|"_subid_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^Item13|"_a.Item13_"^Item14|"_a.Item14_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNUROper1QueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNUROper1QueryExecute ]
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

ClassMethod DHCNUROper1QueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNUROper1QueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

// 手术记录单表格print

Query DHCNUROper1PrintQuery(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNUROper1PrintQueryExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNUROper1PrintQuery","13386545^2014-05-12")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	//s EmrCode=$p(AnaesId,"!",2)
	//s AnaesId=$p(AnaesId,"^",1)
	s AnaesId=$p(parr,"!",1)
	s StDate=$zdh($p(parr,"!",2),3)
	
	s EmrCode="DHCNURANHUIOPER1"
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	b ;1
	s CareDate="" f  s CareDate=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate)) q:CareDate=""  d
	.q:(CareDate<StDate)||(CareDate>(StDate+1))
	.s CareTime="" f  s CareTime=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime)) q:CareTime=""  d
	..s subid="" f  s subid=$o(^Nur.DHCNurseRecSubI("TypDatTim"," "_EmrCode,CareDate,CareTime,id,subid)) q:subid=""  d
	...s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	...Q:a.RecCancelUser'=""
	...;s ret="CareDate|"_$zd(a.CareDate,3)_" "_$zt(a.CareTime,1)_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^Item13|"_a.Item13_"^Item14|"_a.Item14_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...s ret="CareDate|"_$zd(a.CareDate,3)_"^CareTime|"_$zt(a.CareTime,2)_"^par|"_id_"^rw|"_subid_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^Item13|"_a.Item13_"^Item14|"_a.Item14_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)
	...;s ret="CareDateTim|"_$zd(a.CareDate,3)_" "_$zt(a.CareTime,2)_"^Item1|"_a.Item1_"^Item2|"_a.Item2_"^Item3|"_a.Item3_"^Item4|"_a.Item4_"^Item5|"_a.Item5_"^Item6|"_a.Item6_"^Item7|"_a.Item7_"^Item8|"_a.Item8_"^Item9|"_a.Item9_"^Item10|"_a.Item10_"^Item11|"_a.Item11_"^Item12|"_a.Item12_"^Item13|"_a.Item13_"^Item14|"_a.Item14_"^User|"_$p($g(^SSU("SSUSR",a.RecUser)),"^",2)_"^par|"_id_"^rw|"_subid
	...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNUROper1PrintQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNUROper1PrintQueryExecute ]
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

ClassMethod DHCNUROper1PrintQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNUROper1PrintQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query DHCNurOperComplexPrnnew(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNurOperComplexPrnnewExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNurOperComplexPrnnewExecute","9606237")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	b ;1
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.Q:a.RecTyp'="DHCNURNQANHUI19"
	.Q:a.RecCancelUser'=""
	.b ;22
	.;s col=subid
	.s col=a.CareDate_"!"_$zt(a.CareTime,2)_"!"_subid
	.s tmp(col,1)=$zd(a.CareDate,3)
	.s tmp(col,2)=$zt(a.CareTime,2)
	.s tmp(col,3)=a.Item35
	.s tmp(col,4)=a.Item36
	.s tmp(col,5)=a.Item37
	.s tmp(col,6)=a.Item38
	.s tmp(col,18)=a.Item39
	.s tmp(col,7)=a.Item40
	.s tmp(col,8)=a.Item48
	.s tmp(col,9)=a.Item49
	.s tmp(col,10)=a.Item41
	.s tmp(col,11)=a.Item42
	.s tmp(col,12)=a.Item43
	.s tmp(col,13)=a.Item44
	.s tmp(col,14)=a.Item45
	.s tmp(col,15)=a.Item46
	.s tmp(col,16)=a.Item47
	.s tmp(col,17)=a.CaseMeasure
	.s recuserId=a.RecUser
	.i recuserId'="" s tmp("User")=$p($g(^SSU("SSUSR",recuserId)),"^",2)
	.e  s tmp("User")=""
	.s recaudituserId=a.RecAuditUser
	.i recaudituserId'="" s AuditUser=$p($g(^SSU("SSUSR",recaudituserId)),"^",2)
	.e  s AuditUser=""
	.i AuditUser'="" d
	.s tmp("User")=tmp("User")_" "_AuditUser
	.i tmp("User")'="" s tmp(col,19)=tmp("User")
	.;i a.RecUser'="" s tmp(col,19)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)

	b ;01
	S I=1
  	s rw=1  f  s rw=$O(tmp(rw)) q:rw=""  d
  	.q:$g(tmp(rw,1))=""
  	.s ret="CareDateTim|"_$G(tmp(rw,1))_"/"_$G(tmp(rw,2))_"^Item35|"_$G(tmp(rw,3))_"^Item36|"_$g(tmp(rw,4))_"^Item37|"_$g(tmp(rw,5))_"^Item38|"_$g(tmp(rw,6))_"/"_$g(tmp(rw,18))_"^Item40|"_$g(tmp(rw,7))_"^Item41|"_$g(tmp(rw,10))_"^Item42|"_$g(tmp(rw,11))_"^Item43|"_$g(tmp(rw,12))_"^Item44|"_$g(tmp(rw,13))_"^Item45|"_$g(tmp(rw,14))_"^Item46|"_$g(tmp(rw,15))_"^Item47|"_$g(tmp(rw,16))_"^CaseMeasure|"_$g(tmp(rw,17))_"^Item48|"_$g(tmp(rw,8))_"^Item49|"_$g(tmp(rw,9))_"^User|"_$g(tmp(rw,19))_"^DiagnosDr|"_""
  	.S I=I+1
  	.d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNurOperComplexPrnnewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNurOperComplexPrnnewExecute ]
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

ClassMethod DHCNurOperComplexPrnnewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNurOperComplexPrnnewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query DHCNURANHUILEGNXQ(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURANHUILEGNXQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURANHUILEGNXQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod DHCNURANHUILEGNXQExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNURANHUILEGNXQ","14517631")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s idd=""
	s ret=""
	s tmp=""
	s idd=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,idd))
	i $g(idd)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subidd=0
	f  s subidd=$o(^Nur.DHCNurseRecSubD(idd,subidd)) q:subidd=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(idd_"||"_subidd)
	.b ;0
	.Q:a.RecTyp'="DHCNURANHUILEGNXQ"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s id=a.CareDate
	.s subid=$zt(a.CareTime,2)
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime,2) //fish20120924修改围手术护理单显示的时间24进制
	.;s tmp(id,subid,13)=a.Item51
	.;s tmp(id,subid,14)=a.Item52
	.;s tmp(id,subid,15)=a.Item53
	.s tmp(id,subid,1)=a.Item31
	.s tmp(id,subid,2)=..DHCNURANHUILEGNTRAN(a.Item32)
	.s tmp(id,subid,3)=..DHCNURANHUILEGNTRAN(a.Item33)
	.s tmp(id,subid,4)=a.Item34
	.s tmp(id,subid,5)=..DHCNURANHUILEGNTRAN(a.Item35)
	.s tmp(id,subid,6)=..DHCNURANHUILEGNTRAN(a.Item36)
	.s tmp(id,subid,7)=a.Item37
	.s tmp(id,subid,8)=a.Item38
	.;s tmp(id,subid,9)=a.Item62
	.;s tmp(id,subid,10)=a.Item63
	.;s tmp(id,subid,11)=a.Item64
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item51|"_$G(tmp(rw,rwsub,13))_"^Item52|"_$g(tmp(rw,rwsub,14))_"^Item53|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"^Item5|"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item61|"_$g(tmp(rw,rwsub,8))_"^Item62|"_$g(tmp(rw,rwsub,9))_"^Item63|"_$g(tmp(rw,rwsub,10))_"^Item64|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item34|"_$g(tmp(rw,rwsub,4))_"^Item35|"_$g(tmp(rw,rwsub,5))_"^Item31|"_$g(tmp(rw,rwsub,1))_"^Item32|"_$g(tmp(rw,rwsub,2))_"^Item33|"_$g(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,6))_"^Item37|"_$g(tmp(rw,rwsub,7))_"^Item38|"_$g(tmp(rw,rwsub,8))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod DHCNURANHUILEGNXQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURANHUILEGNXQExecute ]
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

// 下肢静脉打印(新)南区   DHCNURANHUILEGN

ClassMethod DHCNURANHUILEGNNQExecute(ByRef qHandle As %Binary, AnaesId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCMGtestpge","DHCNURANHUILEGN","14517631")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s id=""
	s ret=""
	s tmp=""
	s id=$O(^Nur.DHCNurseRecParentI("Episode"," "_AnaesId,id))
	i $g(id)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0
	f  s subid=$o(^Nur.DHCNurseRecSubD(id,subid)) q:subid=""  d
	.s a=##class(Nur.DHCNurseRecSub).%OpenId(id_"||"_subid)
	.b ;0
	.Q:a.RecTyp'="DHCNURANHUILEGNNQ"
	.Q:a.RecCancelUser'=""
	.b ;01
	.s col=a.CareDate
	.s colsub=a.CareTime
	.s tmp(id,subid,19)=$zd(a.CareDate,3)
	.s tmp(id,subid,20)=$zt(a.CareTime,2) //fish20120924修改围手术护理单显示的时间24进制
	.;s tmp(id,subid,13)=a.Item51
	.;s tmp(id,subid,14)=a.Item52
	.;s tmp(id,subid,15)=a.Item53
	.s tmp(id,subid,1)=a.Item31
	.s tmp(id,subid,2)=..DHCNURANHUILEGNTRAN(a.Item32)
	.s tmp(id,subid,3)=..DHCNURANHUILEGNTRAN(a.Item33)
	.s tmp(id,subid,4)=a.Item34
	.s tmp(id,subid,5)=..DHCNURANHUILEGNTRAN(a.Item35)
	.s tmp(id,subid,6)=..DHCNURANHUILEGNTRAN(a.Item36)
	.s tmp(id,subid,7)=a.Item37
	.s tmp(id,subid,8)=a.Item38
	.s tmp(id,subid,9)=a.Item10
	.;s tmp(id,subid,10)=a.Item63
	.;s tmp(id,subid,11)=a.Item64
	.s tmp(id,subid,16)=a.CaseMeasure_""
	.i a.RecUser'="" s tmp(id,subid,17)=$p($g(^SSU("SSUSR",a.RecUser)),"^",2)


	S I=1
  	s rw=1 f  s rw=$O(tmp(rw)) q:rw=""  d
  	.s rwsub=1  f  s rwsub=$O(tmp(rw,rwsub)) q:rwsub=""  d
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item13|"_$G(tmp(rw,rwsub,13))_"^Item14|"_$g(tmp(rw,rwsub,14))_"^Item15|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"/"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item8|"_$g(tmp(rw,rwsub,8))_"^Item9|"_$g(tmp(rw,rwsub,9))_"^Item10|"_$g(tmp(rw,rwsub,10))_"^Item11|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..;s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item51|"_$G(tmp(rw,rwsub,13))_"^Item52|"_$g(tmp(rw,rwsub,14))_"^Item53|"_$g(tmp(rw,rwsub,15))_"^Item4|"_$g(tmp(rw,rwsub,4))_"^Item5|"_$g(tmp(rw,rwsub,5))_"^Item1|"_$g(tmp(rw,rwsub,1))_"^Item2|"_$g(tmp(rw,rwsub,2))_"^Item3|"_$g(tmp(rw,rwsub,3))_"^Item6|"_$g(tmp(rw,rwsub,6))_"^Item7|"_$g(tmp(rw,rwsub,7))_"^Item61|"_$g(tmp(rw,rwsub,8))_"^Item62|"_$g(tmp(rw,rwsub,9))_"^Item63|"_$g(tmp(rw,rwsub,10))_"^Item64|"_$g(tmp(rw,rwsub,11))_"^Item12|"_$g(tmp(rw,rwsub,12))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..s ret="CareDateTim|"_$G(tmp(rw,rwsub,19))_"/"_$G(tmp(rw,rwsub,20))_"^Item34|"_$g(tmp(rw,rwsub,4))_"^Item35|"_$g(tmp(rw,rwsub,5))_"^Item31|"_$g(tmp(rw,rwsub,1))_"^Item32|"_$g(tmp(rw,rwsub,2))_"^Item33|"_$g(tmp(rw,rwsub,3))_"^Item36|"_$g(tmp(rw,rwsub,6))_"^Item37|"_$g(tmp(rw,rwsub,7))_"^Item38|"_$g(tmp(rw,rwsub,8))_"^Item10|"_$g(tmp(rw,rwsub,9))_"^Item16|"_$g(tmp(rw,rwsub,16))_"^CaseMeasure|"_$g(tmp(rw,rwsub,16))_"^User|"_$g(tmp(rw,rwsub,17))_"^DiagnosDr|"_""
  	..S I=I+1
  	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

Query DHCNURANHUILEGNNQ(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod DHCNURANHUILEGNNQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DHCNURANHUILEGNNQExecute ]
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

ClassMethod DHCNURANHUILEGNNQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DHCNURANHUILEGNNQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 日间放化疗取二评单
ClassMethod GetEPDScore(EmrCode, EpisodeId) As %String
{
	//w ##class(web.DHCMGtestpge).GetScore(9606237)
	s ret=""
	
	s curId="" 
	if (EmrCode'="")&(EpisodeId'="")
	{
	 s flag="false"
	 s code=$ZConvert(EmrCode,"U")
	 s id="" f  s id=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,id)) q:id=""  d
	 .q:flag="ture"
	 .s b=##class(Nur.DHCMoudData).%OpenId(id)
	 .i (b.RecCancelUser="")  s flag="ture", curId=id  //取第一条记录的值
	}
	//q id
	
	//s curId=##class(Nur.DHCMoudData).GetId(EmrCode,EpisodeId)
    i (curId="") q ret
    s curRet=##class(Nur.DHCMoudData).getVal(curId)
	s ret=$p(curRet,"^",35)_"^"_$p(curRet,"^",27)
	//s ret=
	q ret
}

/// 取一个病人的就诊号
ClassMethod GetAdmId() As %String
{
	
	s ret=""
	
	s wardId=""  
	f  s wardId=$O(^PAADMi("CurrWard",wardId)) q:(wardId="")!(ret'="")  d
	.s curRoomId=""
	.f  s curRoomId=$O(^PAADMi("CurrWard",wardId,curRoomId)) q:(curRoomId="")!(ret'="")  d
	..s EpisodeID="" 
	..f  s EpisodeID=$O(^PAADMi("CurrWard",wardId,curRoomId,EpisodeID)) q:(EpisodeID="")!(ret'="")  d
	...q:$g(^PAADM(EpisodeID))=""
	...s ret=EpisodeID
	q ret
}

/// 判断病人是否有填写该护理记录单
/// EpisodeID 病人就诊号,code 护理单据关键字
/// 返回 1,有填写,返回 0,未填写,返回其他见错误提示
/// w ##class(web.DHCMGtestpge).JugeIfWSubRec("5541","DHCNURANHUI9")
/// ty 20180205
ClassMethod JugeIfWSubRec(EpisodeID As %String, code As %String) As %String
{
	q:EpisodeID="" "未选择病人"
	q:code="" "护理单据未选择"
	s code=$ZConvert(code,"U")
	s retflag=0
	s par=$O(^Nur.DHCNurseRecParentI("Episode"," "_EpisodeID,""))
	q:par="" retflag
	s date="" f  s date=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_code,date)) q:(date="")!(retflag=1)  d
	.s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_code,date,tim)) q:(tim="")!(retflag=1)  d
    ..s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_code,date,tim,par,rw)) q:(rw="")!(retflag=1)  d
    ...s subobj=##class(Nur.DHCNurseRecSub).%OpenId(par_"||"_rw)
    ...q:'$IsObject(subobj)
    ...q:subobj.RecCancelUser'=""
    ...s retflag=1
	q retflag
}

}
