Class web.DHCMGArrangeSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetFeastSetExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="^2009-04-13^2009-04-13"
 	if parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	    s yy=$P(parr,"^",1)
	    s fe=""  f  s fe=$O(^User.DHCMGFeastDateI("FeastYear",yy,fe)) q:fe=""  d
	    .s rw=""  f  s rw=$O(^User.DHCMGFeastDateI("FeastYear",yy,fe,rw)) q:rw=""  d
	    ..b 
	    ..d out
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out 
    s (year,feast,stdate,edate,allowance,funit,mem,stopdate)=""
    s a=^User.DHCMGFeastDateD(rw)
    s allowance=$List(a,2)
    s stdate=$List(a,6)
    s edate=$List(a,4)
    s stopdate=$List(a,9)
    s feastdr=$List(a,3)
    s yeardr=$List(a,7)
    s funit=$List(a,8)
    s mem=$List(a,5)
    s f=##class(User.DHCMGCCode).%OpenId(feastdr)
    s feast=f.MgCodeDesc
    s y=##class(User.DHCMGCCode).%OpenId(yeardr)
    s year=y.MgCodeDesc
    if stdate'="" s stdate=$ZD(stdate,3)
    if edate'="" s edate=$ZD(edate,3)
    if stopdate'="" s stopdate=$ZD(stopdate,3)
    d OutRowtyp
    q
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK  
OutRowtyp
	set Data=$lb(year,feast,stdate,edate,allowance,funit,mem,stopdate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetFeastSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFeastSetExecute ]
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

ClassMethod GetFeastSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFeastSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetFeastSet(parr As %String) As %Query(ROWSPEC = "year,feast,stdate,edate,allowance,funit,mem,stopdate,rw")
{
}

ClassMethod GetAlloAdjExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
    s date=""  f  s date=$O(^User.DHCMGAllowanceAdjI("SDate",date)) q:date=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGAllowanceAdjI("SDate",date,rw)) q:rw=""  d
    ..b
    ..d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (feaprice,ferprice,stdate,edate,allunit)=""
    s a=^User.DHCMGAllowanceAdjD(rw)
    s user=$List(a,7)
    s stdate=$List(a,9)
    s edate=$List(a,8)
    s feaprice=$List(a,3)
    s ferprice=$List(a,4)
    s allunit=$List(a,2)
    if stdate'="" s stdate=$ZD(stdate,3)
    if edate'=""  s edate=$ZD(edate,3)
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(feaprice,ferprice,stdate,edate,allunit,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAlloAdjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAlloAdjExecute ]
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

ClassMethod GetAlloAdjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAlloAdjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAlloAdj(parr As %String) As %Query(ROWSPEC = "feaprice,ferprice,stdate,edate,funit,rw")
{
}

ClassMethod GetMoudleExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
    s rw=""  f  s rw=$O(^User.DHCMGMoudleD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (mname,mcode)=""
    s a=^User.DHCMGMoudleD(rw)
    s mname=$List(a,2)
    s mcode=$List(a,3)

   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(mname,mcode,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMoudleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoudleExecute ]
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

ClassMethod GetMoudleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoudleExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMoudle(parr As %String) As %Query(ROWSPEC = "mname,mcode,rw")
{
}

ClassMethod GetMoudSubExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	if par=""   Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rw=""  f  s rw=$O(^User.DHCMGMoudleSubD(par,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (mname,mcode)=""
    s a=^User.DHCMGMoudleSubD(par,rw)
    s mname=$List(a,2)
    s mcode=$List(a,3)
    s mtyp=$list(a,4)
    s rowid=par_"||"_rw
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(mname,mcode,mtyp,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMoudSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoudSubExecute ]
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

ClassMethod GetMoudSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoudSubExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMoudSub(parr As %String) As %Query(ROWSPEC = "mname,mcode,mtyp,rw")
{
}

ClassMethod GetSSGRPExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录   s rw=""  f  s rw=$O(^User.DHCMGSSGROUPD(rw)) q:rw=""  d

 	//s parr="^2009-04-13^2009-04-13"
    s rw=""  f  s rw=$O(^User.DHCMGSSGROUPD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (mname,mcode)=""
    s a=^User.DHCMGSSGROUPD(rw)
    s mname=$List(a,2)
    s mcode=$List(a,3)
    s typ=$ListGet(a,4)
    s typdes=""
    if typ="D" s typdes="Doc"
    if typ="N" s typdes="Nur"
    if typ="A" s typdes="All"
    

   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(mname,mcode,typdes,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSSGRPFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSGRPExecute ]
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

ClassMethod GetSSGRPClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSGRPExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSSGRP(parr As %String) As %Query(ROWSPEC = "mname,mcode,typ,rw")
{
}

ClassMethod GetSSRELAYExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录   s rw=""  f  s rw=$O(^User.DHCMGSSGROUPD(rw)) q:rw=""  d
    s pgrp=parr
 	//s parr="^2009-04-13^2009-04-13"
    s rw=""  f  s rw=$O(^User.DHCMGSSGRPRELHISGRPD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (grpname,hgrpname)=""
    s a=^User.DHCMGSSGRPRELHISGRPD(rw)
    s grp=$List(a,3)
    if (pgrp'=grp)&(pgrp'="") q
    s hgrp=$List(a,2)
    s a=^User.DHCMGSSGROUPD(grp)
    s grpname=$List(a,2)
    q:grpname=""                     
    q:'$d(^SSU("SSGRP",hgrp))
    s hgrpname=$P(^SSU("SSGRP",hgrp),"^",1) 
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(grpname,hgrpname,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSSRELAYFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSSRELAYExecute ]
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

ClassMethod GetSSRELAYClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSSRELAYExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetSSRELAY(parr As %String) As %Query(ROWSPEC = "grpname,hgrpname,rw")
{
}

ClassMethod GetGrpTitleExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s grp=parr
 	if grp=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCMGSSGRPLAYOUTI("grp",grp,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (grpdes,title,pos)=""
    s a=^User.DHCMGSSGRPLAYOUTD(rw)
    s title=$List(a,3)
    s mgrp=$List(a,2)
    s pos=$ListGet(a,4)
    s flag=$ListGet(a,5)
    s b=^User.DHCMGSSGROUPD(mgrp)
    s grpdes=$List(b,2)
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(grpdes,title,pos,flag,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetGrpTitleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpTitleExecute ]
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

ClassMethod GetGrpTitleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpTitleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetGrpTitle(parr As %String) As %Query(ROWSPEC = "grpdes,title,pos,flag,rw")
{
}

ClassMethod GetPstFixWeekExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s dep=parr
 	if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCMGPostPerWeekFixI("Dep"," "_dep,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,person,post,week,stdate)=""
    s a=^User.DHCMGPostPerWeekFixD(rw)
    s dep=$List(a,2)
    s per=$List(a,3)
    s pst=$List(a,4)
    s week=$List(a,5)
    s stdate=$List(a,6)
    if dep'="" s DepDes=$P(^CTLOC(dep),"^",2)   
    s parr=^User.DHCMGPersonsD(per)
    s person=$list(parr,21)
    s b=^User.DHCMGPostD(pst)
    s post=$List(b,3)
    if stdate'=""  s stdate=$ZD(stdate,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp  
	set Data=$lb(DepDes,person,post,week,stdate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPstFixWeekFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPstFixWeekExecute ]
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

ClassMethod GetPstFixWeekClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPstFixWeekExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPstFixWeek(parr As %String) As %Query(ROWSPEC = "DepDes,person,post,week,stdate,rw")
{
}

ClassMethod getmoudledata(ssgrp, titl) As %String
{
 //  $C(3) 
  //   !
  //   $C(2)
  //   ^
   
    s ret=""
    s rw=""  f  s rw=$O(^User.DHCMGMoudleD(rw)) q:rw=""  d
    .s a=^User.DHCMGMoudleD(rw)
    .s mname=$List(a,2)
    .s mcode=$List(a,3)
    .if titl="" s flag=..getpar(ssgrp,rw,"")
    .e  s flag=..getparitm(titl,rw,"")
    .s ret=ret_mcode_"^"_mname_"^"_rw_"^"_flag_"!"
    .s subret=""
    .s chl=""  f  s chl=$O(^User.DHCMGMoudleSubD(rw,chl)) q:chl=""  d
    ..s b=^User.DHCMGMoudleSubD(rw,chl)
    ..s sname=$List(b,2)
    ..s scode=$List(b,3)
    ..if titl="" s flag=..getpar(ssgrp,"",rw_"||"_chl)
    ..e  s flag=..getparitm(titl,"",rw_"||"_chl)
    ..s subret=subret_scode_"^"_sname_"^"_rw_"||"_chl_"^"_flag_$C(2)
    .s ret=ret_subret_$C(3)
    q ret
}

ClassMethod getparitm(par, mw, sub) As %String
{
    s flag="false"
    s md="",submoud=""
    s chl=""  f  s chl=$O(^User.DHCMGSSGRPLAYOUTD(par,"ChildSub",chl)) q:chl=""  d
    .s c=^User.DHCMGSSGRPLAYOUTD(par,"ChildSub",chl)
    .q:c=""
    .s moud=$list(c,3)
    .s itm=$list(c,2)
    .s md(moud)=""
    .if itm'="" d
    ..s ln=$l(itm,"^")
    ..f i=1:1:ln d
    ...s dd=$P(itm,"^",i)
    ...q:dd=""
    ...s submoud(dd)=""
    if mw'=""{
      if $D(md(mw)) s flag="true"
    }
    if (sub'="")
    {
	  if $D(submoud(sub)) s flag="true"
	}
    //s ret=ret_itm_"!"_moud_"&"
    q flag
}

ClassMethod getTitle(grp) As %String
{
 // s a=##class(web.DHCMGArrangeSet).getTitle
  s titstr=""
  if grp="" q titstr
  s i=0
  s rw="" f  s rw=$O(^User.DHCMGSSGRPLAYOUTI("grp",grp,rw)) q:(rw="")  d
  .s a=^User.DHCMGSSGRPLAYOUTD(rw)
  .s pos=$ListGet(a,4)
  .s flag=$ListGet(a,5)
  .if flag="N" q
  .if pos="" s pos=i
  .s Tmp(pos)=rw
  .s i=i+1
  s p="" f  s p=$O(Tmp(p)) q:p=""  d
  .s rw=Tmp(p)
  .s substr=..getsubtitle(rw)
  .s titstr=titstr_substr_$C(4)
 q titstr
}

ClassMethod getsubtitle(par) As %String
{
 //s a=##class(web.DHCMGArrangeSet).gettitle()
  //$C(3)
  //!
  //$C(2),^
  //

    s a=^User.DHCMGSSGRPLAYOUTD(par)
    s title=$List(a,3)
 
    s ret=""
    s chl=""  f  s chl=$O(^User.DHCMGSSGRPLAYOUTD(par,"ChildSub",chl)) q:chl=""  d
    .s c=^User.DHCMGSSGRPLAYOUTD(par,"ChildSub",chl)
    .q:c=""
    .s moud=$list(c,3)
    .s sort=$listGet(c,4)
    .if sort="" s sort=chl
    .s a=^User.DHCMGMoudleD(moud)
    .s mname=$List(a,2)
    .s mcode=$List(a,3)
    .s sret=mcode_"^"_mname_"^"_moud_"!"
    .s itm=$list(c,2)
    .s subret=""
    .if (itm'="")&(itm'=$C(0))&(itm'="<<$C(0)>>") d
    ..s ln=$l(itm,"^")
    ..f i=1:1:ln d
    ...s dd=$P(itm,"^",i)
    ...q:dd=""
    ...q:dd'["||"
    ...s b=^User.DHCMGMoudleSubD($P(dd,"||"),$P(dd,"||",2))
    ...s sname=$List(b,2)
    ...s scode=$List(b,3)
    ...s subret=subret_scode_"^"_sname_"^"_dd_$C(2)
    .s sret=sret_subret
    .//s ^TMP("ret",par,chl)=sret
    .s sret(sort)=sret
   s rw=""  f  s rw=$O(sret(rw)) q:rw=""  d
   .s ret=ret_sret(rw)_$C(3)
   // s ^RET(par)=ret
    s ret=title_$C(1)_ret
 q ret
}

ClassMethod getpar(grp, mw, sub) As %String
{
   
   s flag="false"
   q:grp="" flag
   s chl="" f  s chl=$O(^User.DHCMGSSGRPLAYOUTI("grp",grp,chl)) q:(chl="")!(flag="true")  d
   .s flag=..getparitm(chl,mw,sub)
  q flag
}

ClassMethod getmoudset(mcode, ssgrp) As %String
{
  //取模块设置
   // s mcode=$ZConvert("NurseManager.frmReportHoliday","U")
    s mcode=$ZConvert(mcode,"U")
    s ret=""
    s rw=""  s rw=$O(^User.DHCMGMoudleI("code"," "_mcode,rw))
    b
    q:rw="" ""
    s chl=""  f  s chl=$O(^User.DHCMGMoudleSubD(rw,chl)) q:chl=""  d
    .s b=^User.DHCMGMoudleSubD(rw,chl)
    .s sname=$List(b,2)
    .s scode=$List(b,3)
    .s styp=$List(b,4)
    .s flag=..getpar(ssgrp,"",rw_"||"_chl)
    .b
    .if flag="true" q
    .s ret=ret_scode_"^"_styp_$C(1)
   q ret
}

ClassMethod GetPerCyclePlanExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s doc=$P(parr,"^",2)
 	if (loc="")&(doc="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
    if doc'=""
    {
	    s rw=""  f  s rw=$O(^User.DHCMGPerCyclePlanI("person",doc,rw)) q:rw=""  d
        .b
        .d out

	
	}else{
    
    s rw=""  f  s rw=$O(^User.DHCMGPerCyclePlanI("dep"," "_loc,rw)) q:rw=""  d
    .b
    .d out
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (DepDes,person,stdate,edate)=""
    s a=^User.DHCMGPerCyclePlanD(rw)
    s dep=$List(a,2)
    if (dep'=loc)&(loc'="")
    s per=$List(a,3)
    s stdate=$List(a,4)
    s edate=$List(a,5)
    s stdate=$ZD(stdate,3),edate=$ZD(edate,3)
    if dep'="" s DepDes=$P(^CTLOC(dep),"^",2)   
    s parr=^User.DHCMGPersonsD(per)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,person,stdate,edate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPerCyclePlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPerCyclePlanExecute ]
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

ClassMethod GetPerCyclePlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPerCyclePlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPerCyclePlan(parr As %String) As %Query(ROWSPEC = "DepDes,person,stdate,edate,rw")
{
}

Storage Default
{
<Data name="DHCMGArrangeSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCMGArrangeSetD</DataLocation>
<DefaultData>DHCMGArrangeSetDefaultData</DefaultData>
<IdLocation>^web.DHCMGArrangeSetD</IdLocation>
<IndexLocation>^web.DHCMGArrangeSetI</IndexLocation>
<StreamLocation>^web.DHCMGArrangeSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
