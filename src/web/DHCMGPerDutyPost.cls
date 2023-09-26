Class web.DHCMGPerDutyPost Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod getdutycode(id) As %String
{
    s ret=""
    s a=##class(User.DHCMGPost).%OpenId(id)
    s loc=a.PostLocDr
    b
    s rw="" f  s rw=$O(^User.DHCMGCDutyI("Loc"," "_loc,rw)) q:rw=""  d
    .s d=^User.DHCMGCDutyD(rw)
    .s Code=$List(d,2)
    .s Desc=$List(d,3)
    .s ret=ret_rw_"|"_Code_"-"_Desc_"^"
    q ret
}

ClassMethod GetHpDutyExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s loc=$P(parr,"^",1)
    if loc'=""{
	    s rw="" f  s rw=$O(^User.DHCMGCDutyI("Loc"," "_loc,rw)) q:rw=""  d
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGCDutyD(rw)) q:rw=""  d
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Code,Desc,freq,Satur,years,Times,location)=""
    s a=^User.DHCMGCDutyD(rw)
    s Dep=$List(a,5)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s Satur=$List(a,8)
    s freq=$List(a,4)
    s Satur=$List(a,8)
    s years=$List(a,10)
    s Times=$ZT($List(a,13),2)_"-"_$ZT($List(a,12),2) 
    s location=$List(a,6)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,Code,Desc,freq,Satur,years,Times,location,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHpDutyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHpDutyExecute ]
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

ClassMethod GetHpDutyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHpDutyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHpDuty(parr As %String) As %Query(ROWSPEC = "DepDes,Code,Desc,freq,Satur,years,Times,location,rw")
{
}

ClassMethod GetPostCodeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s typ=$P(parr,"^",1)
    if typ'=""{
	    s rw="" f  s rw=$O(^User.DHCMGCPostCodeI("Typ"," "_typ,rw)) q:rw=""  d
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGCPostCodeD(rw)) q:rw=""  d
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (typ,Code,Desc)=""
    s a=^User.DHCMGCPostCodeD(rw)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s typ=$List(a,4)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(typ,Code,Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPostCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPostCodeExecute ]
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

ClassMethod GetPostCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPostCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPostCode(parr As %String) As %Query(ROWSPEC = "typ,Code,Desc,rw")
{
}

ClassMethod getdutyinfo(id) As %String
{
   //n (id)
    s a=^User.DHCMGCDutyD(id)
    s Dep=$List(a,5)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s freq=$List(a,4)
    s Satur=$List(a,8)
    s years=$List(a,10)
    s Times=""
    s sttime=$List(a,13)
    s edtime=$List(a,12)
    s sttime=$ZT(sttime,3)
    s edtime=$ZT(edtime,3)
    s location=$List(a,6)
    s profpos=..getprofpos(id)
    s teach=..getteach(id)
    s mentor=..getmentor(id)
    s ret=DepDes_$C(1)_Code_$C(1)_Desc_$C(1)_freq_$C(1)_Satur_$C(1)_years_$C(1)_Times_$C(1)_location_$C(1)_profpos_$C(1)_teach_$C(1)_mentor_$C(1)_sttime_$C(1)_edtime
   q ret
}

ClassMethod getteach(duty) As %String
{
    s ret=""
    s chl=""  f  s chl=$O(^User.DHCMGCDutyTeachI("Duty",duty,chl)) q:chl=""  d
    .Set sc = ##class(User.DHCMGCDutyTeach).%OpenId(chl)
    .s prof=sc.DutyTeach
    .s profdes=$List(^User.DHCMGCPostCodeD(prof),3)
    .s ret=ret_prof_"|"_profdes_"^"
    q ret
}

ClassMethod getmentor(duty) As %String
{
    s ret=""
    s chl=""  f  s chl=$O(^User.DHCMGCDutyMentorI("Duty",duty,chl)) q:chl=""  d
    .Set sc = ##class(User.DHCMGCDutyMentor).%OpenId(chl)
    .s prof=sc.DutyMentor
    .s profdes=$List(^User.DHCMGCPostCodeD(prof),3)
    .s ret=ret_prof_"|"_profdes_"^"
    q ret
}

ClassMethod getprofpos(duty) As %String
{
    s ret=""
    s chl=""  f  s chl=$O(^User.DHCMGCDutyProfPosI("Duty",duty,chl)) q:chl=""  d
    .Set sc = ##class(User.DHCMGCDutyProfPos).%OpenId(chl)
    .s prof=sc.DutyProfPos
    .s profdes=$List(^User.DHCMGCPostCodeD(prof),3)
    .s ret=ret_prof_"|"_profdes_"^"
    q ret
}

ClassMethod getpostAExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s loc=$P(parr,"^",1)
    if loc'=""{
	    s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGPostD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
        .//s a.PostTypDr=##class(User.DHCMGCCode).%OpenId(7)
        .//s a.PostWeekendPers=""
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Code,Desc,nums,Times,flag,mem,week,weekendPer)=""
    ;i rw=214 b //5
    ;i rw=697 b //51
    s a=^User.DHCMGPostD(rw)
    s Dep=$List(a,4)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s Times=$List(a,5)
    s nums=$List(a,6)
    s flag=$List(a,7)
    s mem=$List(a,8)
    s week=$List(a,9)
    s weekendPer=$List(a,10)
    s psttyp=$List(a,11)
    
    if psttyp'="" s PostTyp=$list(^User.DHCMGCCodeD(psttyp),3)
    e  s PostTyp=""
    s curflag=$ListGet(a,12)
    s sort=$ListGet(a,13)
    s NightHour=$ListGet(a,14)
    s StartTime=$ListGet(a,15)
    i StartTime'="" s StartTime=$zt(StartTime,2)
    s EndTime=$ListGet(a,16)
    i EndTime'="" s EndTime=$zt(EndTime,2)
    s holflag=$ListGet(a,17)
    //i rw=214 b //8
    //i rw=697 b //81
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
    ;i rw=214 b //17
    ;i rw=697 b //171
	set Data=$lb(DepDes,Code,Desc,nums,Times,flag,mem,week,weekendPer,PostTyp,rw,curflag,sort,NightHour,StartTime,EndTime,holflag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getpostAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getpostAExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getpostAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getpostAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getpostA(parr As %String) As %Query(ROWSPEC = "DepDes,Code,Desc,nums,Times,flag,mem,week,weekendPer,PostTyp,rw,curflag,sort,NightHour,StartTime,EndTime,holflag")
{
}

ClassMethod GetPromoteExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s per=$P(parr,"^",1)
    if per'=""{
	    s rw="" f  s rw=$O(^User.DHCMGPersonPromoteI("Person"," "_per,rw)) q:rw=""  d
	    .//s duty=$List(^User.DHCMGPersonPromoteD(rw),2)
	    .d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (promdate,appprof,prof,Teach,mentor,Current)=""
    s a=^User.DHCMGPersonPromoteD(rw)
    s appprofdr=$List(a,2)
    s appprof=..getcode(appprofdr)
    s profdr=$List(a,6)
    s prof=..getcode(profdr)
    s mentorDr=$List(a,5)
    s mentor=..getcode(mentorDr)
    s TeachDr=$List(a,10)
    s Teach=..getcode(TeachDr)
    s Current=$List(a,3)
    s Recdate=$List(a,7)
    s rectime=$List(a,8)
    s recuser=$List(a,9)
    s promdate=$ZD($List(a,4),3)
    s person=$List(a,12)
    b
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(promdate,appprof,prof,Teach,mentor,Current,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getcode(code As %String) As %String
{
	if code="" q ""
	s a=^User.DHCMGCPostCodeD(code)
    s Desc=$List(a,3)
    q Desc
}

ClassMethod GetPromoteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPromoteExecute ]
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

ClassMethod GetPromoteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPromoteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPromote(parr As %String) As %Query(ROWSPEC = "promdate,appprof,prof,Teach,mentor,Current,rw")
{
}

ClassMethod GetPtDtExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s post=$P(parr,"^",1)
    if post'=""{
	    s rw="" f  s rw=$O(^User.DHCMGPostDutyI("Post"," "_post,rw)) q:rw=""  d
	    .s duty=$list(^User.DHCMGPostDutyD(rw),2)
	    .d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Code,Desc,freq,Satur,years,Times,location)=""
    s a=^User.DHCMGCDutyD(duty)
    s Dep=$List(a,5)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s Satur=$List(a,8)
    s freq=$List(a,4)
    s Satur=$List(a,8)
    s years=$List(a,10)
    s Times=$ZT($List(a,13),2)_"-"_$ZT($List(a,12),2) 
    s location=$List(a,6)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,Code,Desc,freq,Satur,years,Times,location,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPtDtFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPtDtExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPtDtClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPtDtExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPtDt(parr As %String) As %Query(ROWSPEC = "DepDes,Code,Desc,freq,Satur,years,Times,location,rw")
{
}

ClassMethod GetHolCodeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	    s rw=""  f  s rw=$O(^User.DHCMGCHolidayD(rw)) q:rw=""  d
	    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (flag,Code,Desc)=""
    s a=^User.DHCMGCHolidayD(rw)
    s Code=$List(a,2)
    s Desc=$List(a,4)
    s flag=$List(a,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(flag,Code,Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetHolCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHolCodeExecute ]
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

ClassMethod GetHolCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHolCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetHolCode(parr As %String) As %Query(ROWSPEC = "flag,Code,Desc,rw")
{
}

Query GetSchool(parr As %String) As %Query(ROWSPEC = "schooldate,GraduateSchool,AgeDr,DegreeDR,Profession,Language,Current,Reading,Mem,rw,SchoolType,SchoolMedWest")
{
}

ClassMethod GetSchoolExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	  Set repid=$I(^CacheTemp)
 	 s ind=1
   s per=$P(parr,"^",1)
   if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
   if per'=""{
	  s rw="" f  s rw=$O(^User.DHCMGPersonSchoolI("Person"," "_per,rw)) q:rw=""  d
	  .d out
    }
   Set qHandle=$lb(0,repid,0)
  	Quit $$$OK

out
   s (schooldate,GraduateSchool,AgeDr,DegreeDR,Profession,Language,Current,Reading,Mem,SchoolType,SchoolMedWest)=""
   s a=^User.DHCMGPersonSchoolD(rw)
   s schooldate=$List(a,2)
   i schooldate'="" s schooldate=$zd(schooldate,3)
   s GraduateSchool=$List(a,3)
   i GraduateSchool'="" s GraduateSchool=$list(^User.DHCMGCCodeD(GraduateSchool),3)
   s AgeDr=$List(a,4)
   i AgeDr'="" s AgeDr=$list(^User.DHCMGCCodeD(AgeDr),3)
   s DegreeDR=$List(a,5)
   i DegreeDR'="" s DegreeDR=$list(^User.DHCMGCCodeD(DegreeDR),3)
   s Profession=$List(a,6)
   i Profession'="" s Profession=$list(^User.DHCMGCCodeD(Profession),3)
   s Language=$List(a,7)
   i Language'="" s Language=$list(^User.DHCMGCCodeD(Language),3)
   s Current=$List(a,8)
   s Reading=$List(a,9)
   s Mem=$List(a,11)
   s SchoolType=$listget(a,12)
   i SchoolType'="" s SchoolType=$listget(^User.DHCMGCCodeD(SchoolType),3)
   s SchoolMedWest=$listget(a,13)
   i SchoolMedWest'="" s SchoolMedWest=$listget(^User.DHCMGCCodeD(SchoolMedWest),3)
   d OutRowtyp
   q
   Set qHandle=$lb(0,repid,0)
	  Quit $$$OK
  
OutRowtyp
	set Data=$lb(schooldate,GraduateSchool,AgeDr,DegreeDR,Profession,Language,Current,Reading,Mem,rw,SchoolType,SchoolMedWest)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSchoolFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSchoolExecute ]
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

ClassMethod GetSchoolClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSchoolExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
