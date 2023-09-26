Class web.DHCMGPrintComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetQueryHead(QueryName) As %String
{
  // n (QueryName,Parr)s a=##class(web.DHCMGPrintComm).GetQueryHead()
   s ret=""
   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()
        For col = 1:1:columns {
	       // if rset.GetColumnName(col)="ItemData" continue
            s ret=ret_rset.GetColumnName(col)_"&"
        }
    s parm=""
        For i = 1 :1: rset.GetParamCount()
        {
        s parm=parm_rset.GetParamName(i)_"&"
        }

 q ret_$C(1)_parm
}

ClassMethod GetData(mth As %String, parrm As %String) As %String
{
   //mth="##class(web.DHCMGNurComm).GetLoc"
   //s mth="web.DHCMGNurComm:GetLoc" ,parrm=p1:4^p2:5
   s mth="##class("_$P(mth,":")_")."_$P(mth,":",2)
   s l=$L(parrm,"^")
   q:parrm="" ""
   b ;getdata
   //s ^objcyf2=parrm
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"^",i)
     s p=$P(itm,":",1)
     s v=$P(itm,":",2)
     s @p=v
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
   }
   	s mth=mth_"("_pp_")"
	b
	q @mth
}

ClassMethod GetTest(typ As %String, l1 As %String) As %String
{
	if typ=1 q "Ret1^Ret2^Ret3^Ret4^Ret5"
	q "Ret1"_$C(1)_"23^Ret2"_$C(1)_"44^Ret3"_$C(1)_"66^Ret4"_$C(1)_"88^Ret5"_$C(1)_"99"
}

ClassMethod GetTGlboalExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s i=0
 	s rw=""  f  s rw=$O(^CacheTemp(rw),-1) q:(rw="")!(i=1000)  d
 	.q:..ifnum(rw)=1
 	.q:'$D(^CacheTemp(rw))
 	.s sub="0" f  s sub=$O(^CacheTemp(rw,sub)) q:(sub="")!(i=1000)  d
 	..q:'$D(^CacheTemp(rw,sub))
 	..q:$G(^CacheTemp(rw,sub))=""
 	..s dd=$E(^CacheTemp(rw,sub),1,1)
 	..q:$ZC(dd)'=5
 	..s a1=$Listget(^CacheTemp(rw,sub),1)
 	..s a2=$Listget($G(^CacheTemp(rw,sub)),2)
 	..s a3=$Listget($G(^CacheTemp(rw,sub)),3)
 	..s a4=$Listget($G(^CacheTemp(rw,sub)),4)
 	..s a5=$Listget($G(^CacheTemp(rw,sub)),5)
 	..s a6=$Listget($G(^CacheTemp(rw,sub)),6)
 	..s a7=$Listget($G(^CacheTemp(rw,sub)),7)
 	..s a8=$Listget($G(^CacheTemp(rw,sub)),8)
 	..s a9=$Listget($G(^CacheTemp(rw,sub)),9)
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

ClassMethod GetTGlboalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTGlboalExecute ]
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

ClassMethod GetTGlboalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTGlboalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp1(repid)
 	Quit $$$OK
}

Query GetTGlboal(parr As %String) As %Query(ROWSPEC = "a1,a2,a3,a4,a5,a6,a7,a8,a9,a10")
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
