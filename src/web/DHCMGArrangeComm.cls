Class web.DHCMGArrangeComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetQueryData(QueryName, Parr) As %String
{
  // n (QueryName,Parr)
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()

 // Execute the query
   if $L(Parr,"^")&(Parr'="")=1
   {
    s sc = rset.Execute(Parr)
   }
   if (Parr=""){
   Set sc = rset.Execute()
   }
   s QueryName=$TR(QueryName,":","&")

 // Now fetch the results
   s ret=$P(QueryName,"&",2)_"&"
  s i=0
  While (rset.Next()) {
       i (i=0){
        For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s ret=ret_rset.GetColumnName(col)_"&"
        }
       }
       s coldata=""
       For col = 1:1:columns {
	        if rset.GetColumnName(col)="ItemData" continue
            s coldata=coldata_rset.GetData(col)_"^"
        }

      if (i=0){
	      s ret=ret_"$"_coldata_"&"
	      }else{
		    s ret=ret_coldata_"&"

		      }
      s i=i+1
      if i>500  q
      
 }
 Do rset.Close()
 s qu=$P(QueryName,"&",2)_"&"
 if ret=qu  s ret="-1"
 q ret
}

ClassMethod GetSystTime() As %String
{
	s date=$ZD(+$H,3)
	s week=$ZD(+$H,10)
	s tim=$P($H,",",2)
	s tim=$ZT(tim)
 q date_"^"_week_"^"_tim
}

ClassMethod GetUserGrp(user As %String, logloc As %String) As %String
{
  //s a=##class(web.DHCMGArrangeComm).GetUserGrp()
  //根据登陆科室求安全组//2008-11-11 qse
    s grp="",mgrp=""
    s chl=""  f  s chl=$O(^SSU("SSUSR",user,"OTHLL",chl)) q:(chl="")!(grp'="")  d
    .s loc=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",1)
    .q:loc'=logloc
    .s grp=$P(^SSU("SSUSR",user,"OTHLL",chl),"^",2)
    if grp'="" s mgrp=##class(User.DHCMGSSGRPRELHISGRP).getgrp(grp)
    s loglocdes=$p($G(^CTLOC(logloc)),"^",2)
    q grp_"^"_mgrp_"^"_loglocdes
}

ClassMethod GetRelGrp(ssgrp As %String, logloc As %String = "") As %String
{
  //s a=##class(web.DHCMGArrangeComm).GetUserGrp()
  //根据登陆科室求安全组//2008-11-11 qse
    if ssgrp'="" s mgrp=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgrp)
    if logloc'="" s loglocdes=$p($G(^CTLOC(logloc)),"^",2)
    q mgrp_"^"_$G(loglocdes)
}

ClassMethod Logon(userid, pinnumber) As %String
{
  //s a=##class(web.DHCMGArrangeComm).Logon
    s ^TMP("Hospital")="JST"
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
	s userid=$Tr(userid,"-","")
  	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""))
  	//q:User="" "-3"
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
  	s pin=$$ENCR^SSUTIL2(pinnumber)
  	if pin=""{
	  	 zn oldnamespace
         q "-4"
	  	} 
	i pin'=$p(^SSU("SSUSR",User),"^",3) {
	  	 zn oldnamespace
		q "-4"
	}
	
	//Do $system.OBJ.CompileProject("DHCNURMG","cukfv")
	s ssgrp=$p(^SSU("SSUSR",User),"^",5)
    s ssgrpdes=$P(^SSU("SSGRP",ssgrp),"^",1)
	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	s UserID=$p(^SSU("SSUSR",User),"^")
	s DefLocDes=$p($G(^CTLOC(DefLoc)),"^",2)
	s DocID=$p(^SSU("SSUSR",User),"^",14)
	s MgPerson=$O(^User.DHCMGPersonsI("SSDR"," "_User,""))

   	zn oldnamespace 
    s ret=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgrp)
    s grp=$P(ret,"^",1),grptyp=$P(ret,"^",2)
 // d ##class(DHCPdaComm).Init(User)
	s LogonDep=##class(web.DHCMGArrangeComm).Getlogonctloc(User)
	if LogonDep="-1"{
		s LogonDep="logonctloc&LocDesc&rowid&$"_DefLocDes_"|"_ssgrpdes_"|"_ssgrp_"^"_DefLoc_"^&"
		}else{
			s LogonDep=LogonDep_DefLocDes_"|"_ssgrpdes_"|"_ssgrp_"^"_DefLoc_"^&"
			}
	q User_"^"_DefLoc_"^"_ssgrp_"^"_UserName_"^"_UserID_"^"_DocID_"^"_MgPerson_"^"_grp_"|"_grptyp_"@"_LogonDep
}

ClassMethod Logon1(userid) As %String
{
  //s a=##class(web.DHCMGArrangeComm).Logon
    s oldnamespace=$ZNSPACE
	s datanamespace=$LIST(^websys.ConfigurationD(1),12)
	zn datanamespace
  	s userid=$Tr(userid,"-","")
	s User=$O(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(userid,"U"),""))
  	//q:User="" "-3"
  	if User=""{
	  	 zn oldnamespace
         q "-3"
	  	} 
	s ssgrp=$p(^SSU("SSUSR",User),"^",5)

	s DefLoc=$p(^SSU("SSUSR",User),"^",4)
	s UserName=$p(^SSU("SSUSR",User),"^",2)
	s UserID=$p(^SSU("SSUSR",User),"^")
	s DefLocDes=$p($G(^CTLOC(DefLoc)),"^",2)
	s DocID=$p(^SSU("SSUSR",User),"^",14)
	s MgPerson=$O(^User.DHCMGPersonsI("SSDR"," "_User,""))
   	zn oldnamespace 
    s ret=##class(User.DHCMGSSGRPRELHISGRP).getgrp(ssgrp)
    s grp=$P(ret,"^",1),grptyp=$P(ret,"^",2)
 // d ##class(DHCPdaComm).Init(User)
	s LogonDep=##class(web.DHCMGArrangeComm).Getlogonctloc(User)
	if LogonDep="-1"{
		s LogonDep="logonctloc&LocDesc&rowid&$"_DefLocDes_"^"_DefLoc_"^&"
		}else{
			s LogonDep=LogonDep_DefLocDes_"^"_DefLoc_"^&"
			}
	q User_"^"_DefLoc_"^"_ssgrp_"^"_UserName_"^"_UserID_"^"_DocID_"^"_MgPerson_"^"_grp_"|"_grptyp_"@"_LogonDep
}

ClassMethod GetDepGroupExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Dep=$P(parr,"^",1)
	    s rw=""  f  s rw=$O(^User.DHCMGCGroupI("Dep"," "_Dep,rw)) q:rw=""  d
	    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,Desc)=""
    s a=^User.DHCMGCGroupD(rw)
    s Dep=$List(a,2)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s Desc=$List(a,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDepGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepGroupExecute ]
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

ClassMethod GetDepGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDepGroup(parr As %String) As %Query(ROWSPEC = "DepDes,Desc,rw")
{
}

ClassMethod GetGroupPersonExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Grp=$P(parr,"^",1)
	    s rw=""  f  s rw=$O(^User.DHCMGGroupPersonsI("Grp",Grp,rw)) q:rw=""  d
	    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (Person)=""
    s a=^User.DHCMGGroupPersonsD(rw)
    s personDr=$List(a,3)
    //s parr=^DHCMGPERSON("person",personDr)
    //s Person=$P(parr,"^",10)
    s parr=$g(^User.DHCMGPersonsD(personDr))
    s Person=$List(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(Person,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGroupPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGroupPersonExecute ]
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

ClassMethod GetGroupPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGroupPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetGroupPerson(parr As %String) As %Query(ROWSPEC = "Person,rw")
{
}

ClassMethod findgroup(Dep As %String) As %String
{
		 s ret=""
		 s rw=""  f  s rw=$O(^User.DHCMGCGroupI("Dep"," "_Dep,rw)) q:rw=""  d
         .s a=^User.DHCMGCGroupD(rw)
         .s Desc=$List(a,3)
         .s ret=ret_rw_"|"_Desc_"^"
         q ret
}

ClassMethod GetRelayExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1079^2009-2-24"
 	s Date=$P(parr,"^",2)
 	s Dep=$P(parr,"^",1)
 	s Date=$ZDH(Date,3)
	    s rw=""  f  s rw=$O(^User.DHCMGArrRelayRecordI("RelDate",Date,rw)) q:rw=""  d
	    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (nurse,bynurse,date,post,sttim,endtim)=""
    s a=^User.DHCMGArrRelayRecordD(rw)
    s nur=$List(a,2)
    s bynur=$List(a,3)
    s date=$List(a,4)
    s postdr=$List(a,6)
    s endtim=$List(a,5)
    s sttim=$List(a,7)
    s sttim=$ZT(sttim)
    s endtim=$ZT(endtim)
    s parr=^DHCMGPERSON("person",nur)
    s loc=$P(parr,"^",3)
    q:loc'=Dep
    s nurse=$P(parr,"^",10)
    s parr=^DHCMGPERSON("person",bynur)
    s bynurse=$P(parr,"^",10)
    s pt=^User.DHCMGPostD(postdr)
    s post=$List(pt,3)
    s date=$ZD(date,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(nurse,bynurse,date,post,sttim,endtim,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetRelayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRelayExecute ]
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

ClassMethod GetRelayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRelayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetRelay(parr As %String) As %Query(ROWSPEC = "nurse,bynurse,date,post,sttim,endtim,rw")
{
}

ClassMethod GetAdjRecExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="1079^2009-02-24"
 	s Dep=$P(parr,"^",1)
 	s Date=$P(parr,"^",2)
 	s Date=$ZDH(Date,3)
	    s rw=""  f  s rw=$O(^User.DHCMGPostAdjustI("AdjDate",Date,rw)) q:rw=""  d
	    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (nurse,pdate,oldpost,newpost,mem)=""
    s a=^User.DHCMGPostAdjustD(rw)
    s pdate=$List(a,2)
    s mem=$List(a,3)
    s newpst=$List(a,4)
    s oldpst=$List(a,5)
    s perdr=$List(a,6)
    s parr=^DHCMGPERSON("person",perdr)
    s nurse=$P(parr,"^",10)
    s loc=$P(parr,"^",3)
    q:loc'=Dep
    s pdate=$ZD(pdate,3)
    s pt=^User.DHCMGPostD(oldpst)
    s oldpost=$List(pt,3)
    s pt=^User.DHCMGPostD(newpst)
    s newpost=$List(pt,3)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(nurse,pdate,oldpost,newpost,mem,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAdjRecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdjRecExecute ]
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

ClassMethod GetAdjRecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdjRecExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAdjRec(parr As %String) As %Query(ROWSPEC = "nurse,pdate,oldpost,newpost,mem,rw")
{
}

ClassMethod GetPerDatePst(parr As %String) As %String
{
	s nurdr=$P(parr,"^",1)
	s date=$P(parr,"^",2)
  	s rw=""  s rw=$O(^User.DHCMGPersonArrangeI("PersonDate"," "_nurdr,date,rw))
  	.s arr=^User.DHCMGPersonArrangeD(rw)
	.s Nur=$List(arr,5)
	.s PostDr=$List(arr,6)
	.s Post=$List(^User.DHCMGPostD(PostDr),3)
}

ClassMethod getpsetExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s loc=$P(parr,"^",1)
    s typ=$P(parr,"^",2)
    if loc'=""{
	    s rw="" f  s rw=$O(^User.DHCMGArrSetI("DepTyp"," "_loc," "_typ,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGArrSetD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (no,post,num)=""
    s a=^User.DHCMGArrSetD(rw)
    s no=$List(a,3)
    s num=$List(a,4)
    s PostDr=$List(a,5)
	s post=$List(^User.DHCMGPostD(PostDr),3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(no,post,num,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getpsetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getpsetExecute ]
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

ClassMethod getpsetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getpsetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getpset(parr As %String) As %Query(ROWSPEC = "no,post,num,rw")
{
}

ClassMethod gethollevelExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s loc=""
 	s typ=""
    if loc'=""{
	    s rw="" f  s rw=$O(^User.DHCMGArrSetI("DepTyp"," "_loc," "_typ,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGCHolWorkAgeD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (holdes,level,days)=""
    s a=^User.DHCMGCHolWorkAgeD(rw)
    s hol=$List(a,2)
    s holdes=$list(^User.DHCMGCHolidayD(hol),4)
    s level=$List(a,3)
    s days=$List(a,4)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(holdes,level,days,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod gethollevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = gethollevelExecute ]
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

ClassMethod gethollevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = gethollevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query gethollevel(parr As %String) As %Query(ROWSPEC = "holdes,level,days,rw")
{
}

ClassMethod getCodeTypExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s loc=""
    if loc'=""{
	    s rw="" f  s rw=$O(^User.DHCMGPostI("Loc"," "_loc,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGCodeTypD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (Code,Desc)=""
    s a=^User.DHCMGCodeTypD(rw)
    s Code=$List(a,2)
    s Desc=$List(a,3)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(Code,Desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getCodeTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getCodeTypExecute ]
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

ClassMethod getCodeTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getCodeTypExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getCodeTyp(parr As %String) As %Query(ROWSPEC = "Code,Desc,rw")
{
}

ClassMethod getDataCodeExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s typ=$P(parr,"^",1)
    if typ'=""{
	    s rw="" f  s rw=$O(^User.DHCMGCCodeI("Typ",typ,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGCCodeD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (typdes,Code,Desc,stdate,edate)=""
    s a=^User.DHCMGCCodeD(rw)
    s typ=$List(a,6)
    s b=##class(User.DHCMGCodeTyp).%OpenId(typ)
    s typdes=b.TypDesc
    s Code=$List(a,2)
    s Desc=$List(a,3)
    s stdate=$List(a,5)
    
    s edate=$List(a,4)
    b
    s stdate=$ZD(stdate,3)
  
    
    if edate'="" s edate=$ZD(edate,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(typdes,Code,Desc,stdate,edate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getDataCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getDataCodeExecute ]
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

ClassMethod getDataCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getDataCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getDataCode(parr As %String) As %Query(ROWSPEC = "typdesc,Code,Desc,stdate,edate,rw")
{
}

ClassMethod Gettyp() As %String
{
   s ret=""
	    s rw=""  f  s rw=$O(^User.DHCMGCodeTypD(rw)) q:rw=""  d
	    . s a=^User.DHCMGCodeTypD(rw)
	    . s Desc=$List(a,3)
	    . s Code=$List(a,2)
	    . s ret=ret_rw_"|"_Desc_"^"
 q ret
}

ClassMethod getcodedata() As %String
{
	 s rw=""  f  s rw=$O(^User.DHCMGCCodeD(rw)) q:rw=""  d
	 .s a=^User.DHCMGCCodeD(rw)
	 .s typ=$list(a,6)
	 .s desc=$list(a,3)
	 .s ret(typ)=$G(ret(typ))_rw_"|"_desc_"^"
	 s ret=""
	 s typ="" f  s typ=$O(ret(typ)) q:typ=""  d
	 .s ret=ret_ret(typ)_"!"
	 q ret
}

ClassMethod getPerTanlocExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s per=$P(parr,"^",1)
    if per'=""{
      s rw=""  f  s rw=$O(^User.DHCMGTransI("Person",per,rw)) q:rw=""  d
	    .
	    .d out
    }else{
	    s rw=""  f  s rw=$O(^User.DHCMGTransD(rw)) q:rw=""  d
	    .//s a=##class(User.DHCMGPost).%OpenId(rw)
	    .//s a.PostFlag="N"
	    .//s a.Postmem="sdf"
	    .//d a.%Save()
	    .//b //
	    .//d a.%Close()
	    .//b
	    .d out
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,StDate,StTime,EndDate,EndTime,flag,mem)=""
    s a=^User.DHCMGTransD(rw)
    s Dep=$List(a,9)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s StDate=$List(a,5)
    s StTime=$List(a,8)
    s EndDate=$List(a,3)
    s EndTime=$List(a,7)
    s flag=$List(a,2)
    s mem=$List(a,4)
    s StDate=$ZD(StDate,3)
    if EndDate'="" s EndDate=$ZD(EndDate,3)
    s StTime=$ZT(StTime)
    if EndTime'="" s EndTime=$ZT(EndTime)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,StDate,StTime,EndDate,EndTime,flag,mem,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getPerTanlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getPerTanlocExecute ]
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

ClassMethod getPerTanlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getPerTanlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getPerTanloc(parr As %String) As %Query(ROWSPEC = "DepDes,StDate,StTime,EndDate,EndTime,flag,mem,rw")
{
}

ClassMethod GetDepPerson(parr As %String) As %String
{
	  s ret=""
	  s pdep=$P(parr,"^")
	  s rw="" f  s rw=$O(^User.DHCMGPersonsI("Dep"," "_pdep,rw)) q:rw=""  d
	   . s parr=^User.DHCMGPersonsD(rw)
       . s name=$list(parr, 21)
	   . s ret=ret_rw_"|"_name_"^"
	   q ret
}

ClassMethod Getlogonctloc(UserId) As %String
{
	s retStr=..GetQueryData("web.DHCMGArrangeComm:logonctloc",UserId)
	q retStr
}

Query logonctloc(userid As %String) As %Query(ROWSPEC = "LocDesc:%String,rowid:%String")
{
}

ClassMethod logonctlocExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=""  f  s chl=$O(^SSU("SSUSR",userid,"OTHLL",chl)) q:chl=""  d
    .q:(+chl=0)
    .s loc=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",1)
    .q:loc=""
    .s locdes=$p($G(^CTLOC(loc)),"^",2)
    .q:locdes=""
    .s grp=$P(^SSU("SSUSR",userid,"OTHLL",chl),"^",2)
    .q:grp=""
    .q:$g(^SSU("SSGRP",grp))=""
    .s grpdes=$P(^SSU("SSGRP",grp),"^",1 )
    .s locdes=locdes_"|"_grpdes_"|"_grp
    .s tm(loc)=locdes
    s loc=""  f  s loc=$O(tm(loc)) q:loc=""  d
    .s locdes=tm(loc)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(locdes,loc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod logonctlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = logonctlocExecute ]
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

ClassMethod logonctlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = logonctlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod gethisgrp() As %String
{
   s ret=""
   s rw=0  f  s rw= $O(^SSU("SSGRP",rw)) q:rw=""   d
   .s name=$P(^SSU("SSGRP",rw),"^",1) 
   .s ret=ret_rw_"|"_name_"^"
   q ret
}

Query GetPhcin() As %Query(ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String,Sel:%String")
{
}

ClassMethod GetPhcinExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s chl=0  f  s chl=$O(^PHCIN(chl) )  q:chl=""  d
    .s des=$P(^PHCIN(chl) ,"^",2)
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(chl,des,sel)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinExecute ]
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

ClassMethod GetPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetGlboalExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s i=0
 	s rw=""  f  s rw=$O(^CacheTemp(rw),-1) q:(rw="")!(i=1000)  d
 	.q:..ifnum(w)
 	.s sub="" f  s sub=$O(^CacheTemp(rw,sub)) q:(sub="")!(i=1000)  d
 	..s a1=$Listget(^CacheTemp(rw,sub),1)
 	..s a2=$Listget(^CacheTemp(rw,sub),2)
 	..s a3=$Listget(^CacheTemp(rw,sub),3)
 	..s a4=$Listget(^CacheTemp(rw,sub),4)
 	..s a5=$Listget(^CacheTemp(rw,sub),5)
 	..s a6=$Listget(^CacheTemp(rw,sub),6)
 	..s a7=$Listget(^CacheTemp(rw,sub),7)
 	..s a8=$Listget(^CacheTemp(rw,sub),8)
 	..s a9=$Listget(^CacheTemp(rw,sub),9)
 	..s a10=rw
 	..s i=i+1
 	..d OutRowtyp
 	//s parr="2009-011-18^2009-12-18"
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10)
 	Set ^CacheTemp1(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGlboalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGlboalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp1(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp1(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetGlboalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGlboalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp1(repid)
 	Quit $$$OK
}

Query GetGlboal(parr As %String) As %Query(ROWSPEC = "a1,a2,a3,a4,a5,a6,a7,a8,a9,a10")
{
}

ClassMethod ifnum(val As %String) As %String
{
	s l=$l(val)
	s flag=0
	for i=1:1:l
	{
	   s s1=$E(val,i,i)
	  // if ($ZC(s1)'<48)&($ZC(s1)'>57)
	   if (($ZC(s1)<48)!($ZC(s1)>57)) 
	   {
	     s flag=1
	   }
	   
	}
	q flag
}

}
