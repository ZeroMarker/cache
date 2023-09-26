Class web.DHCNurCheckRoom Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod gethh(code, tmp, sun) As %String
{
	  s sun1=0
	  s sun1=tmp*sun
	  q sun1
       //for i=1:1:l
	   // {
		 // s rw=itm.CheckQuals.GetAt(i)
		 // s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  //s weight=a.QualWeight	    
		  //s sun =100/(sun+weight)
		 
		//}
}

ClassMethod GetCheckSumExecute(ByRef qHandle As %Binary, qPar As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//x	
 	//补贴调节记录
 	s ^JJ=qPar
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//d ##class(%ResultSet).RunQuery("web.DHCNurCheckRoom","GetCheckSum","49")
 	//s ^mw123(123)=qPar
 	//s sun
    //s a=##class(DHCMGNUR.MgCheckWard).%OpenId(qPar)
    //s sun=a.getcountweight(qPar) //权重系数
    //s sun1=a.getcountgrade(qPar,sun)
    s wetscore=""
    s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck"," "_qPar,loc)) q:loc=""  d
 	.s cweight=0
 	.s differ=0
 	.s cdiffer=0
 	.s code2=""  f  s code2=$O(^Nur.QualCheckRecI("QCheck"," "_qPar,loc,code2)) q:code2=""  d
 	..s chl2=""  f  s chl2=$O(^Nur.QualCheckRecI("QCheck"," "_qPar,loc,code2,chl2)) q:chl2=""  d
 	...s b=##class(Nur.QualCheckRec).%OpenId(chl2)
 	...s score=b.Score
 	...s code=b.CheckCode
 	...//s a=##class(DHCMGNUR.MgCheckWard).%OpenId(qPar)
 	...//s weight=a.getcountWeight2(qPar,code,score)
 	...if (code="Qual13") s differ=differ+score
 	...if (code="Qual16") s differ=differ+score
 	...if (code="Qual17") s differ=differ-score
 	...if (code="Qual20") s cdiffer=cdiffer+score
 	...if (code="Qual21") s cdiffer=cdiffer+score
 	...if (code="Qual22") s cdiffer=cdiffer+score
 	...s weight=0
 	...//if score'="" s weight=##class(DHCMGNUR.QualCodeItem).getqualWeight(code)
 	...if score'="" s weight=##class(DHCMGNUR.MgCheckWard).getqualWet(qPar,code)
 	...s cweight=cweight+weight
    ...//s tweight($tr(loc," ",""))=100/cweight
    .if (cweight=0) q
    .s tweight=100/cweight
    .if differ'="" s LOCDIFF("LOC",$tr(loc," ",""))=differ
    .if cdiffer'="" s CLOCDIFF("LOC",$tr(loc," ",""))=cdiffer
 	.s code=""  f  s code=$O(^Nur.QualCheckRecI("QCheck"," "_qPar,loc,code)) q:code=""  d
 	..s chl=""  f  s chl=$O(^Nur.QualCheckRecI("QCheck"," "_qPar,loc,code,chl)) q:chl=""  d
 	...s a=##class(Nur.QualCheckRec).%OpenId(chl)
 	...s score=a.Score
 	...s ward=a.WardLoc
 	...s checkcode=a.CheckCode
 	...//w score_","_checkcode
 	...s a=##class(DHCMGNUR.MgCheckWard).%OpenId(qPar)
 	...s wetscore=a.getcountgrade(qPar,tweight,checkcode,score)
 	...if (wetscore'=0) s score=$fn(wetscore,"",0)
    ...s TMP(ward,checkcode)=score
    ...b ;g001
   
 	s loc=""  
 	f  s loc=$O(TMP(loc)) q:loc=""  d 
 	.s finalscore=0
 	.s cjixi=0
 	.s dif=LOCDIFF("LOC",loc)
 	.s cdif=CLOCDIFF("LOC",loc)
 	.b ;119//d
 	.s code2="" f  s code2=$O(TMP(loc,code2)) q:code2=""  d
 	..//b //
 	..if (code2'="Qual13")&&(code2'="Qual16")&&(code2'="Qual17")&&(code2'="Qual20")&&(code2'="Qual21")&&(code2'="Qual22") s finalscore=finalscore+$fn(TMP(loc,code2),"",1)
 	..if finalscore>99 s finalscore=100
 	..b ;120 //g
 	..//s jixi=$fn(finalscore*0.05,"",1) //绩效
 	.s finalscore=finalscore-dif
 	.s jixi=$fn(finalscore*0.05,"",1) //绩效
 	.s cjixi=jixi+cdif
 	.s CtLoc=$p(^CTLOC(loc),"^",2)
 	.s ret="ward|"_$p(CtLoc,"-",2)_"^"_"loc|"_loc _"^"_"Qual18|"_finalscore_"^"_"Qual19|"_jixi_"^"_"Cperf|"_cjixi
    .s code="" f  s code=$O(TMP(loc,code)) q:code=""  d
    ..s ret=code_"|"_TMP(loc,code)_"^"_ret
 	.d OutRowtyp
  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCheckSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckSumExecute ]
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

ClassMethod GetCheckSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetCheckSum(CheckQual As %String) As %Query(ROWSPEC = "aa")
{
}

/// 
/// 计算总分
/// 
ClassMethod getCodeScore(id As %String) As %String
{
	;s ret=""
	s countScore=0
 	s item="" f  s item=$O(^Nur.QualCheckRecChildI("item",item)) q:item=""  d
 	.;b ;01
 	.s raw="" f  s raw=$O(^Nur.QualCheckRecChildI("item",item,id,raw)) q:raw=""  d
 	..s aa=##class(Nur.QualCheckRecChild).%OpenId(id_"||"_raw)
 	..s countScore=countScore+aa.CheckScore
 	..;b ;01
 	q countScore
}

/// 
/// 获取表字段拼串
/// 
ClassMethod getCode(id, tpp) As %String
{
	if id'=""
	{
		s a=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
		s tpp=""
		s code=a.CheckQuals
		f i=1:1:code.Count()
		{
		  s rww=code.GetAt(i)
		  s rw=$p(rww,"!",2)
		  ;s tpp("Qual")=""
		  s aa=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s Qual=aa.QualCode
		  s tpp(Qual)=Qual
		}
	}
	q 0
	;if id'=""
	;{
	;	s a=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
	;	s tpp=""
	;	if '$D(^tCodeItem("DHCMGNUR.MgCheckWard")) d a.ListProperties()
	;	b ;1999999
	;	s p="" f  s p=$O(^tCodeItem("DHCMGNUR.MgCheckWard",p)) q:p=""  d
	;	.s tpp(p)=$ZOBJPROPERTY(a,p)
	;
	;}
	;q 0
}

/// 
/// 质控汇总上半年查询（上一年12月到本年5月份以及本年度6月份到十一月份）
/// 
Query SearchTotalHalfCnt1(typ As %String, parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchTotalHalfCnt1Execute(ByRef qHandle As %Binary, typ As %String, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;w ##class(%ResultSet).RunQuery("web.DHCNurCheckRoom","SearchTotalHalfCnt1","2013-12-01^2014-01-01^2014-02-01^2014-03-01^2014-04-01^2014-05-01")
 	s ret=""
 	s ^TEMP("gzj2014091501")=parr
 	s sort="" f  s sort=$O(^DHCMGNUR.MgNurWardI("Sort",sort)) q:sort=""  d
 	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurWardI("Sort",sort,raw)) q:raw=""  d
 	..s a=##class(DHCMGNUR.MgNurWard).%OpenId(raw)
 	..s wardloc=a.WardLoc
 	..i typ="second" d
 	...s ret="wardloc|"_wardloc_"^"
 	...s yearStr=$P($ZD(+$H,3),"-",1)
 	...s monthString=yearStr-1_"-06-01^"_yearStr_"-07-01^"_yearStr_"-08-01^"_yearStr_"-09-01^"_yearStr_"-10-01^"_yearStr_"-11-01"
 	...f i=1:1:$l(monthString,"^")  d
 	....s date=$P(monthString,"^",i)
 	....s date1=$ZDH($P($ZD(+$H,3),"-",1)_"-05-31",3) f  s date1=$O(^Nur.QualCheckRecI("CheckFlag"," "_wardloc,date1)) q:date1=""  d
 	.....s totalScore=100
 	.....;q:$fn($P($ZD(date1,3),"-",1),"")'=$fn($P(date,"-",1),"")
 	.....q:$P($ZD(date1,3),"-",2)'=$P(date,"-",2) ;!$P($ZD(date1,3),"-",2)
 	.....s id="" f  s id=$O(^Nur.QualCheckRecI("CheckFlag"," "_wardloc,date1," QUALCHECK",id)) q:id=""  d
 	......s aa=##class(Nur.QualCheckRec).%OpenId(id)
 	......s qual=aa.CheckCode
 	......s score=aa.Score-##class(DHCMGNUR.QualCodeItem).getQualScore(qual)
 	......s totalScore=totalScore+score
 	......s checkQual=aa.CheckQual
 	......s iid="" f  s iid=$O(^Nur.QualCheckRecI("Check",date1," MASTERNUR"," "_wardloc," "_checkQual,iid)) q:iid=""  d
 	.......s iaa=##class(Nur.QualCheckRec).%OpenId(iid)
 	.......s iscore=iaa.Score
 	.......s totalScore=totalScore+iscore
 	.....s ret=ret_$ZD(date1,3)_"|"_totalScore_"^"
 	...s ret=ret ;_"wardloc|"_wardloc_"^"
	...d OutRowtyp
 	/*
 	s sort="" f  s sort=$O(^DHCMGNUR.MgNurWardI("Sort",sort)) q:sort=""  d
 	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurWardI("Sort",sort,raw)) q:raw=""  d
 	..s a=##class(DHCMGNUR.MgNurWard).%OpenId(raw)
 	..s wardloc=a.WardLoc
 	..i typ="second" d
 	...s ret="wardloc|"_wardloc_"^"
 	...s yearStr=$P($ZD(+$H,3),"-",1)
 	...s monthString=yearStr_"-06-01^"_yearStr_"-07-01^"_yearStr_"-08-01^"_yearStr_"-09-01^"_yearStr_"-10-01^"_yearStr_"-11-01"
 	...f i=1:1:$l(monthString,"^") d
 	....s date=$P(monthString,"^",i)
 	....s date1=$ZDH($P($ZD(+$H,3),"-",1)_"-05-31",3) f  s date1=$O(^Nur.QualCheckRecI("CheckSearch"," "_parr," "_wardloc,date1)) q:date1=""  d
 	.....s totalScore=100
 	.....q:($P($ZD(date1,3),"-",2)'=$P(date,"-",2))
 	.....;b ;001
 	.....s id="" f  s id=$O(^Nur.QualCheckRecI("CheckSearch"," "_parr," "_wardloc,date1," QUALCHECK",id)) q:id=""  d
 	......s aa=##class(Nur.QualCheckRec).%OpenId(id)
 	......s qual=aa.CheckCode
 	......s score=aa.Score-##class(DHCMGNUR.QualCodeItem).getQualScore(qual)
 	......;b ;110
 	......s totalScore=totalScore+score
 	.....s iraw="" f  s iraw=$O(^Nur.QualCheckRecI("CheckSearch"," "_parr," "_wardloc,date1," MASTERNUR",iraw)) q:iraw=""  d
 	......;b ;119
 	......s iaa=##class(Nur.QualCheckRec).%OpenId(iraw)
 	......s iscore=iaa.Score
 	......s totalScore=totalScore+iscore
 	.....s ret=ret_$ZD(date1,3)_"|"_totalScore_"^"
 	...s ret=ret ;_"wardloc|"_wardloc_"^"
	...d OutRowtyp
	*/
 	/*
 	s sort="" f  s sort=$O(^DHCMGNUR.MgNurWardI("Sort",sort)) q:sort=""  d
 	.s raw="" f  s raw=$O(^DHCMGNUR.MgNurWardI("Sort",sort,raw)) q:raw=""  d
 	..s a=##class(DHCMGNUR.MgNurWard).%OpenId(raw)
 	..s wardloc=a.WardLoc
 	..;s totalScore=100
 	..i typ="second" d
 	...s ret="wardloc|"_wardloc_"^"
 	...;s totalScore=100
 	...f i=1:1:$l(parr,"^") d
	....s date=$P(parr,"^",i)
	....s date1=$ZDH("2014-05-31",3) f  s date1=$O(^Nur.QualCheckRecI("CheckFlag"," "_wardloc,date1)) q:date1=""  d
	.....s totalScore=100
	.....q:(($P($ZD(date1,3),"-",1)'=$P(date,"-",1))!($P($ZD(date1,3),"-",2)'=$P(date,"-",2)))
	.....s id="" f  s id=$O(^Nur.QualCheckRecI("CheckFlag"," "_wardloc,date1," QUALCHECK",id)) q:id=""  d
	......s aa=##class(Nur.QualCheckRec).%OpenId(id)
	......s checkqual=aa.CheckQual
	......s qual=aa.CheckCode
	......s score=aa.Score-##class(DHCMGNUR.QualCodeItem).getQualScore(qual)
	......s totalScore=totalScore+score
	......;b ;p1101
	......s rid="" f  s rid=$O(^Nur.QualCheckRecI("CheckFlag"," "_wardloc,date1," MASTERNUR",rid)) q:rid=""  d
	.......s aaa=##class(Nur.QualCheckRec).%OpenId(rid)
	.......;b ;p1102
	.......q:aaa.CheckQual'=checkqual
	.......s totalScore=totalScore+aaa.Score
	......;b ;120
	......s ret=ret_$ZD(aa.CheckDate,3)_"|"_totalScore_"^"
	...s ret=ret ;_"wardloc|"_wardloc_"^"
	...d OutRowtyp
	..i typ="first" d
	...b 110
	*/
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchTotalHalfCnt1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchTotalHalfCnt1Execute ]
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

ClassMethod SearchTotalHalfCnt1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchTotalHalfCnt1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 护理质控汇总新
/// 
Query SearchWardCntTol2(CheckQual As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchWardCntTol2Execute(ByRef qHandle As %Binary, CheckQual As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;w ##class(%ResultSet).RunQuery("web.DHCNurCheckRoom","SearchWardCntTol2",185)
 	s ret=""
 	s ^TEMP("CheckQualGZJ")=CheckQual
 	s dateMonth=""
 	s currentQual=##class(DHCMGNUR.MgCheckWard).%OpenId(CheckQual)
 	s dateMonth=$ZD(currentQual.CheckStDate,3)
 	s loc1="" f  s loc1=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc1)) q:loc1=""  d
 	.s differ=100
 	.s cdiffer=0
 	.s code1=""  f  s code1=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc1,code1)) q:code1=""  d
 	..s codeItem=$Tr(code1," ","")
 	..s locItem=$Tr(loc1," ","")
 	..s row1=""  f  s row1=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc1,code1,row1)) q:row1=""  d
 	...;s b=##class(Nur.QualCheckRec).%OpenId(row1)
 	...i ..getCodeScore(row1)'=0 s TMPCODESCORE(locItem,codeItem)=..getCodeScore(row1)
 	...else  i ..getCodeScore(row1)=0  d
 	....s aObj=##class(Nur.QualCheckRec).%OpenId(row1)
 	....b ;test110
 	....s aTmp=aObj.Score
 	....s aQual=aObj.CheckCode
 	....i $D(aTmp)&((aQual'="QUAL43")&(aQual'="QUAL41")&(aQual'="QUAL13")&(aQual'="QUAL42")&(aQual'="QUAL16")&(aQual'="QUAL17")&(aQual'="QUAL22")&(aQual'="QUAL20")&(aQual'="QUAL21")) s TMPCODESCORE(locItem,codeItem)=0
 	....b ;test111
 	...s ma=##class(Nur.QualCheckRec).%OpenId(row1)
 	...i ma.CheckCode="QUAL43" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL41" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL13" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL42" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL16" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL17" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL20" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL21" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	...i ma.CheckCode="QUAL22" s TMPSCODESCORE(locItem,codeItem)=ma.Score
 	s loc2="" f  s loc2=$O(TMPCODESCORE(loc2)) q:loc2=""  d
 	.s ret="loc|"_loc2_"^ward|"_$P($P(^CTLOC(loc2),"^",2),"-",2)_"^"
 	.s sum=100
 	.s toJXSum=0
 	.s code2="" f  s code2=$O(TMPCODESCORE(loc2,code2)) q:code2=""  d
 	..s qual=code2
 	..i TMPCODESCORE(loc2,code2)'=0 d
 	...s qualValue="-"_TMPCODESCORE(loc2,code2)
 	...s sum=sum-TMPCODESCORE(loc2,code2)
 	..e  d
 	...s qualValue=""
 	...s sum=sum
 	..;s ret=ret_qual_"|"_"-"_TMPCODESCORE(loc2,code2)_"^"
 	..s ret=ret_qual_"|"_qualValue_"^"
 	.;s ret=ret_"^QUAL18|"_sum_"^"
 	.s code3="" f  s code3=$O(TMPSCODESCORE(loc2,code3)) q:code3=""  d
 	..s qual1=code3
 	..i qual1="QUAL43" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL41" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL13" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL42" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL16" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL17" s sum=sum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL20" s toJXSum=toJXSum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL21" s toJXSum=toJXSum+TMPSCODESCORE(loc2,code3)
 	..i qual1="QUAL22" s toJXSum=toJXSum+TMPSCODESCORE(loc2,code3)
 	..s ret=ret_qual1_"|"_TMPSCODESCORE(loc2,code3)_"^"
 	.;i $P(dateMonth,"-",2)<=5 s jXSum=sum*0.06
 	.;e  s jXSum=$fn(sum*0.055,"",2)
 	.s jXSum=$fn(sum*0.08,"",2)
 	.s toJXSum=toJXSum+jXSum
 	.s ret=ret_"QUAL18|"_sum_"^QUAL19|"_jXSum_"^Cperf|"_toJXSum_"^"
	.s ret=ret
	.b ;03
	.d OutRowtyp
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchWardCntTol2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardCntTol2Execute ]
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

ClassMethod SearchWardCntTol2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardCntTol2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// 病房质控汇总查询
/// 
Query SearchWardCntTol(CheckQual As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchWardCntTolExecute(ByRef qHandle As %Binary, CheckQual As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s ward=$P(^CTLOC($Tr(loc," ")),"^",2)
 	;w ##class(%ResultSet).RunQuery("web.DHCNurCheckRoom","SearchWardCntTol",185)
 	s ret=""
 	s ^TEMP("CheckQualGZJ")=CheckQual
 	s loc2="" f  s loc2=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc2)) q:loc2=""  d
 	.s code2="" f  s code2=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc2,code2)) q:code2=""  d
 	..s codeItem=$Tr(code2," ","")
 	..s locItem=$Tr(loc2," ","")
 	..s rw="" f  s rw=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual,loc2,code2,rw)) q:rw=""  d
 	...;i ..getCodeScore(rw)'=0 s TMPCODESCORE(locItem,codeItem)=..getCodeScore(rw)
 	...s TMPCODESCORE(locItem,codeItem)=..getCodeScore(rw)
 	s loc1="" f  s loc1=$O(TMPCODESCORE(loc1)) q:loc1=""  d
 	.s loc=loc1
 	.s ret="loc|"_loc
 	.s code=$O(TMPCODESCORE(loc,"")) q:code=""  d
 	..s ret=ret_"^Score|"_TMPCODESCORE(loc,code)_"^ward|"_$P($P(^CTLOC(loc1),"^",2),"-",2)_"^"
 	..s tpp=""
 	..s am=..getCode(CheckQual,.tpp)
 	..s QUAL18Score="100"
 	..s ccode="" f  s ccode=$O(tpp(ccode)) q:ccode=""  d
 	...s ccode1=$ZConvert(ccode,"U")
 	...i $G(TMPCODESCORE(loc,ccode1)) d
 	....s QUAL18Score=QUAL18Score-TMPCODESCORE(loc,ccode1)
 	....s ret=ret_ccode1_"|"_"-"_TMPCODESCORE(loc,ccode1)_"^"
 	...b ;ceshi001
 	...i $D(TMPCODESCORE(loc,"QUAL13")) d
 	....s QUAL13id=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual," "_loc," QUAL13","")) q:QUAL13id=""  d
 	.....s objQUAL13=##class(Nur.QualCheckRec).%OpenId(QUAL13id)
 	.....s objQUAL13=objQUAL13.Score
 	....s ret=ret_"Qual13|"_objQUAL13_"^QUAL18|"_QUAL18Score_"^"
 	...i $D(TMPCODESCORE(loc,"QUAL16")) d
 	....s QUAL16id=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual," "_loc," QUAL16","")) q:QUAL16id=""  d
 	.....s objQUAL16=##class(Nur.QualCheckRec).%OpenId(QUAL16id)
 	.....s ret=ret_"Qual16|"_objQUAL16.Score_"^"
 	...i $D(TMPCODESCORE(loc,"QUAL17")) d
 	....s QUAL17id=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual," "_loc," QUAL17","")) q:QUAL17id=""  d
 	.....s objQUAL17=##class(Nur.QualCheckRec).%OpenId(QUAL17id)
 	.....s ret=ret_"Qual17|"_objQUAL17.Score_"^"
 	...i $D(TMPCODESCORE(loc,"QUAL41")) d
 	....s QUAL41id=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual," "_loc," QUAL41","")) q:QUAL41id=""  d
 	.....s objQUAL41=##class(Nur.QualCheckRec).%OpenId(QUAL41id)
 	.....s ret=ret_"Qual41|"_objQUAL41.Score_"^"
 	...i $D(TMPCODESCORE(loc,"QUAL42")) d
 	....s QUAL42id=$O(^Nur.QualCheckRecI("QCheck"," "_CheckQual," "_loc," QUAL42","")) q:QUAL42id=""  d
 	.....s objQUAL42=##class(Nur.QualCheckRec).%OpenId(QUAL42id)
 	.....s ret=ret_"Qual42|"_objQUAL42.Score_"^"
 	...;i ccode=code s ret=ret_ccode_"|"_TMPCODESCORE(loc,ccode)_"^"
 	..;s bb=##class(web.DHCNurRecComm).getRet(.tpp)
 	..b ;110120 
 	..s QUAL19JiXiao=QUAL18Score*0.08
	..s ret=ret_"QUAL18|"_QUAL18Score_"^QUAL19|"_QUAL19JiXiao ;_"Score|"_TMPCODESCORE($TR(loc," ",""),$TR(code," ",""))_"^"_$TR(loc," ","")_"^"_$TR(code," ","")_"^"_rw_"^"
	..d OutRowtyp
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchWardCntTolFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchWardCntTolExecute ]
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

ClassMethod SearchWardCntTolClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchWardCntTolExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod GetSafeCheckSumExecute(ByRef qHandle As %Binary, qPar As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("qq")=parr
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
 	s loc=""  f  s loc=$O(^Nur.DHCNurSafeCheckI("Check"," "_qPar,loc)) q:loc=""  d
 	.s code=""  f  s code=$O(^Nur.DHCNurSafeCheckI("Check"," "_qPar,loc,code)) q:code=""  d
 	..s chl=""  f  s chl=$O(^Nur.DHCNurSafeCheckI("Check"," "_qPar,loc,code,chl)) q:chl=""  d
 	...s a=##class(Nur.DHCNurSafeCheck).%OpenId(chl)
 	...s score=a.Score
 	...s ward=a.WardLoc
 	...q:ward=""
 	...s checkcode=a.CheckCode
 	...s TMP(ward,checkcode)=score
 	...b
 	
 	s loc=""  f  s loc=$O(TMP(loc)) q:loc=""  d
 	.s ret="ward|"_$p(^CTLOC(loc),"^",2)_"^loc|"_loc
 	.s code="" f  s code=$O(TMP(loc,code)) q:code=""  d
 	..s ret=code_"|"_TMP(loc,code)_"^"_ret
 	.d OutRowtyp

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetSafeCheckSumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSafeCheckSumExecute ]
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

ClassMethod GetSafeCheckSumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSafeCheckSumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetSafeCheckSum(CheckQual As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckWardsExecute(ByRef qHandle As %Binary, Par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("qq")=parr
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","CheckWards","41")
       s itm=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
	    s ret=""
        s l=itm.Wards.Count()
	    for i=1:1:l
	    {
		  s rw=itm.Wards.GetAt(i)
		  s des=$p(^CTLOC(rw),"^",2)	    
		  s ret="Ward|"_des_"^rw|"_rw
		  d OutRowtyp
		}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckWardsExecute ]
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

ClassMethod CheckWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query CheckWards(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckNurseExecute(ByRef qHandle As %Binary, Par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s ^TMP("qq")=parr
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
    s itm=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
	s l=itm.CheckUsers.Count()
    s ret1="",ret2=""
    for i=1:1:l
    {
	  s rw=itm.CheckUsers.GetAt(i)
	  s des=$P(..getsuser(rw),"!",2)
	  s ret="Nurse|"_des_"^rw|"_rw
	  d OutRowtyp

	} 

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckNurseExecute ]
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

ClassMethod CheckNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query CheckNurse(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

Query CheckRoom(parr As %String = "") As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw,PatName,NightNur")
{
}

ClassMethod CheckRoomExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TM11("parr11")=parr
 	//s parr="2013-10-29^2013-10-29^NightChk^132^"
 	//d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","CheckRoom",parr)
 	s stdate=$ZDH($P(parr,"^",1),3)
 	s eddate=$ZDH($P(parr,"^",2),3)
 	s chktyp=$P(parr,"^",3)
 	s qualdr=$P(parr,"^",4)
 	s Wardloc=$P(parr,"^",5)
 	
 	s chktyp=$TR($ZConvert(chktyp,"U")," ","")
    if (chktyp="NIGHTCHK") s CheckTyp="夜查房"
    if (chktyp="DAYCHK") s CheckTyp="随机督查"
	s ret=""
 	f date=stdate:1:eddate
 	{
	    s loc=""  f  s loc=$O(^Nur.CheckRoomI("Check",date," "_chktyp,loc)) q:loc=""  d
	    .s qu=""  f  s qu=$O(^Nur.CheckRoomI("Check",date," "_chktyp,loc,qu)) q:qu=""  d
	    ..s rw=""  f  s rw=$O(^Nur.CheckRoomI("Check",date," "_chktyp,loc,qu,rw)) q:rw=""  d
	    ...s LocDr=$tr(loc," ","")
	    ...q:(LocDr'=Wardloc)&(Wardloc'="")
	    ...s Ward=$p(^CTLOC(LocDr),"^",2)
	    ...s a=##class(Nur.CheckRoom).%OpenId(rw)
	    ...q:(a.CheckQual'=qualdr)&(qualdr'="")
	    ...//2013-06-28"转换百分制"
	    ...;s b=##class(DHCMGNUR.QuCheckWard).%OpenId(qualdr)
	    ...;s sumscore=.
	    ...s sumscore=##Class(DHCMGNUR.QuCheckWard).getScore(qualdr)
	    ...;s CheckUser=$P(..getsuser(a.CheckUser),"!",2)     
	    ...s CheckUserT=a.CheckUser   //2013-7-2
	    ...s ret=""
	    ...s sum=$l(CheckUserT,";")
	    ...f i=1:1:sum {s des=$P(..getsuser($p(CheckUserT,";",i)),"!",2)  i des'="" s ret=ret_des_";"}
	    ...;s des=$P(..getsuser($p(CheckUserT,";",i)),"!",2)
	    ...;i des'="" s ret=ret_des_";"
	    ...s CheckUser=ret
	    ...s Score=a.Score
	    ...i sumscore'=0 s Score=$fnumber(Score/sumscore*100,"",1)
	    ...i a.CheckPat'="" s PatName=##Class(web.DHCMgQualCheck).getPatName(a.CheckPat)
	    ...s NurName=a.NightNur
	    ...s chekdate=$ZD(a.CheckDate,3)
	    ...s Question=a.CheckQuestion
	    ...d OutputRow8
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CheckTyp,chekdate,Ward,$G(QualDesc),Score,CheckUser,Question,rw,PatName,NurName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckRoomFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckRoomExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	
 
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckRoomClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckRoomExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getScore(Par) As %String
{
	s score=0
	s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
	.s code=a.ItemCode
	.s chkitm=a.CheckItem
	.s score=score+chkitm.ItemValue
	q score
}

ClassMethod GetCheckItemSubExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	//d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","GetCheckItemSub","42^102^DayChk")
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s ^TMP("aq")=parr
 	s Par=$P(parr,"^",1)
 	s qualCheckpar=$P(parr,"^",2)
 	s a=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
 	s flag=a.CheckFlag
 	if (flag=0)||(flag="")
  	{
	  	s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id)) q:id=""  d
 		.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
		.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
		.s code=a.ItemCode
		.s chkitm=a.CheckItem
		.s level=a.ItemLevel
		.s ItemDesc=chkitm.ItemDesc
		.s itmvalue=chkitm.ItemValue
		.//s itmmem=a.ItemMem
		.i level="" s level=code
		.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
		.if $D(TMII(I,II)) s II=..getsortno(I,.TMII)
		.if (II'="")&(III="") d
		..s II=$INUMBER(II,"T")
		..s TMII(I,II)=Par_"||"_id
		.//d outtyp2
		s r=""  f  s r=$O(TMII(r)) q:r=""  d
		.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
		..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
		..s ret=##class(DHCMGNUR.QuCheckWardChild).getVal(TMII(r,p))
		..if qualCheckpar'="" s ret1=##class(Nur.CheckRoomItem).getcheckitm(qualCheckpar,TMII(r,p))
		..e  s ret1=""
		..s ret=ret_"^rw|"_rw_"^Par|"_Par_"^"_ret1
		..d outtyp2
  	}else
 	{
		s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id)) q:id=""  d
 		.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
		.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
		.s code=a.ItemCode
		.;s chkitm=a.CheckItem
		.s chkitmid=$lg(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id),2)
		.s c=##class(DHCMGNUR.QuCheckProjectChild).%OpenId(chkitmid)
		.s chkitm=c.CheckItem
		.s level=a.ItemLevel
		.s ItemDesc=chkitm.ItemDesc
		.s itmvalue=chkitm.ItemValue
		.//s itmmem=a.ItemMem
		.i level="" s level=code
		.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
		.if $D(TMII(I,II)) s II=..getsortno(I,.TMII)
		.if (II'="")&(III="") d
		..s II=$INUMBER(II,"T")
		..s TMII(I,II)=Par_"||"_id
		s r=""  f  s r=$O(TMII(r)) q:r=""  d
		.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
		..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
		..;s ret=##class(DHCMGNUR.QuCheckWardChild).getVal(TMII(r,p))
		..s ret=##class(DHCMGNUR.QuCheckProjectChild).getQuVal(TMII(r,p))
		..if qualCheckpar'="" s ret1=##class(Nur.CheckRoomItem).getcheckitm(qualCheckpar,TMII(r,p))
		..e  s ret1=""
		..s ret=ret_"^rw|"_id_"^Par|"_Par_"^"_ret1
		..d outtyp2
  }

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCheckItemSubbfExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	//d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","GetCheckItemSub","42^102^DayChk")
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
 	s ^TMP("aq")=parr
 	s Par=$P(parr,"^",1)
 	s qualCheckpar=$P(parr,"^",2)
 	s id="" f  s id=$O(^DHCMGNUR.QuCheckWardD(Par,"ChildSub",id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QuCheckWardChild).%OpenId(Par_"||"_id)
	.//s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	.s code=a.ItemCode
	.s chkitm=a.CheckItem
	.s level=a.ItemLevel
	.s ItemDesc=chkitm.ItemDesc
	.s itmvalue=chkitm.ItemValue
	.//s itmmem=a.ItemMem
	.i level="" s level=code
	.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
	.if $D(TMII(I,II)) s II=..getsortno(I,.TMII)
	.if (II'="")&(III="") d
	..s II=$INUMBER(II,"T")
	..s TMII(I,II)=Par_"||"_id
	.//d outtyp2
	//b //
	s r=""  f  s r=$O(TMII(r)) q:r=""  d
	.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
	..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
	..s ret=##class(DHCMGNUR.QuCheckWardChild).getVal(TMII(r,p))
	..if qualCheckpar'="" s ret1=##class(Nur.CheckRoomItem).getcheckitm(qualCheckpar,TMII(r,p))
	..e  s ret1=""
	..s ret=ret_"^rw|"_rw_"^Par|"_Par_"^"_ret1
	..d outtyp2


    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCheckItemSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCheckItemSubExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetCheckItemSub(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getsortno(r, tm) As %String
{
	s r1=$O(tm(r,""),-1)+1
	q r1
}

ClassMethod QuCheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TPPPPP("parr")=parr
	Set repid=$I(^CacheTemp)
 	s ind=1
    s ^jj=parr
    //d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","QuCheckList","2013-12-18^2013-12-18^QualCheck")
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s CheckTyp=$TR($ZConvert(typ,"U")," ","")
    s loguser=$P(parr,"^",4)
    ;s flag=$P(parr,"^",5)
    s username=$p($g(^SSU("SSUSR",loguser)),"^",2)
    ;s date=edate f  s date=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date),-1) q:date=""  d
    ;.q:date<stdate
    ;.b ;0110
    ;.s p="" f  s p=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date,p)) q:p=""  d
    ;..s a=##class(DHCMGNUR.MgCheckWard).%OpenId(p)
    ;..s ret=##class(DHCMGNUR.MgCheckWard).getVal(p)
	;..s ret=ret_"^rw|"_p
	;..d OutRowtyp
 	;f date=stdate:1:edate
 	
 	if (typ="QualSelfCheck")||(typ="QualCheck")
    {
	    f date=stdate:1:edate
	    {
 			s p=""
	  		f { 
	    		s p=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date,p))
	     		q:p=""
	     		s a=##class(DHCMGNUR.MgCheckWard).%OpenId(p)
	     		s ret=##class(DHCMGNUR.MgCheckWard).getVal(p)
	     		s checkuser=$p($p(ret,"CheckUsers|",2),"^",1)
	     		continue:(loguser'=a.RecUser)&&(checkuser'[username)&&(loguser'=1)&&(loguser'=23254) 
	     		s ret=ret_"^rw|"_p
	     		d OutRowtyp
	   		}
	    }
	}
	else
	{
 	 	f date=stdate:1:edate
 	 	{
	  		s p=""
	  		f { 
	     	s p=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date,p))
	     	q:p=""
	     	s a=##class(DHCMGNUR.MgCheckWard).%OpenId(p)
	     	// if (typ'=a.CheckTyp)&(typ'="") continue
	     	s ret=##class(DHCMGNUR.MgCheckWard).getVal(p)
	     	s ret=ret_"^rw|"_p
	     	d OutRowtyp
	   }
	 }
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuCheckListExecute ]
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

ClassMethod QuCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query QuCheckList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

Query CheckSatisfy(CheckTyp, QualDr, WardLoc) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckSatisfyExecute(ByRef qHandle As %Binary, CheckTyp, QualDr, WardLoc) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("qu")=$LB( CheckTyp,QualDr, WardLoc)
     s CheckTyp=$ZConvert(CheckTyp,"U")
 	 s loc=""  f  s loc=$O(^Nur.DHCNurSatisCheckI("Check"," "_CheckTyp," "_QualDr,loc)) q:loc=""  d
 	 .q:(loc'=WardLoc)&(WardLoc'="")
 	 .s rw=""  f  s rw=$O(^Nur.DHCNurSatisCheckI("Check"," "_CheckTyp," "_QualDr,loc,rw)) q:rw=""  d
 	 ..s ret=##class(Nur.DHCNurSatisCheck).getVal1(rw)_"^rw|"_rw
	 ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckSatisfyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckSatisfyExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckSatisfyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckSatisfyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuItemsExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
   		s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(par)
        s l=itm.CheckQuals.Count()
	    for i=1:1:l
	    {
		  s rw=itm.CheckQuals.GetAt(i)
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s des=a.QualDesc	    
		  s ret="Qualdes|"_des_"^rw|"_rw
		  d OutRowtyp
		}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuItemsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuItemsExecute ]
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

ClassMethod QuItemsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuItemsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query QuItems(par As %String) As %Query(ROWSPEC = "aa")
{
}

Query CheckNurDocSt(CheckTyp, QualDr, WardLoc) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckNurDocStExecute(ByRef qHandle As %Binary, CheckTyp, QualDr, WardLoc) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("qu")=$LB( CheckTyp,QualDr, WardLoc)
     s CheckTyp=$ZConvert(CheckTyp,"U")
 	 s loc=""  f  s loc=$O(^Nur.DHCNurSatisCheckI("Check"," "_CheckTyp," "_QualDr,loc)) q:loc=""  d
 	 .q:(loc'=WardLoc)&(WardLoc'="")
 	 .s rw=""  f  s rw=$O(^Nur.DHCNurSatisCheckI("Check"," "_CheckTyp," "_QualDr,loc,rw)) q:rw=""  d
 	 ..s ret=##class(Nur.DHCNurSatisCheck).getVal2(rw)_"rw|"_rw
	 ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckNurDocStFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckNurDocStExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckNurDocStClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckNurDocStExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckSafeList(CheckCode, QualDr, WardLoc) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CheckSafeListExecute(ByRef qHandle As %Binary, CheckCode, QualDr, WardLoc) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("qu")=$LB( CheckTyp,QualDr, WardLoc)
     s CheckCode=$ZConvert(CheckCode,"U")
 	 s loc=""  f  s loc=$O(^Nur.DHCNurSafeCheckI("Check"," "_QualDr,loc)) q:loc=""  d
 	 .q:($TR(loc," ","")'=WardLoc)&(WardLoc'="")
 	 .b
 	 .s Chek=""  f  s Chek=$O(^Nur.DHCNurSafeCheckI("Check"," "_QualDr,loc,Chek)) q:Chek=""  d
 	 ..b
 	 ..q:($TR(Chek," ","")'=CheckCode)&(CheckCode'="")
 	 ..s rw=""  f  s rw=$O(^Nur.DHCNurSafeCheckI("Check"," "_QualDr,loc,Chek,rw)) q:rw=""  d
 	 ...s ret=##class(Nur.DHCNurSafeCheck).getVal2(rw)_"rw|"_rw
	 ...d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckSafeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckSafeListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CheckSafeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckSafeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QualCheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s ^TPPPPP("parrtest")=parr
	Set repid=$I(^CacheTemp)
 	s ind=1
    s ^jjtest1=parr
    //d ##Class(%ResultSet).RunQuery("web.DHCNurCheckRoom","QualCheckList","2013-12-18^2013-12-18^QualCheck")
    s stdate=$P(parr,"^",1)
    s edate=$P(parr,"^",2)
    s typ=$P(parr,"^",3)
    s checkPeople=$P(parr,"^",4)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    s CheckTyp=$TR($ZConvert(typ,"U")," ","")
    
    ;s date=edate f  s date=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date),-1) q:date=""  d
    ;.q:date<stdate
    ;.b ;0110
    ;.s p="" f  s p=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date,p)) q:p=""  d
    ;..s a=##class(DHCMGNUR.MgCheckWard).%OpenId(p)
    ;..s checkUser=a.CheckUsers.Find(checkPeople)
    ;..q:checkUser=""
    ;..b ;0111
    ;..;q:$G(a.CheckUsers.Find(checkPeople))=""
    ;..s ret=##class(DHCMGNUR.MgCheckWard).getVal(p)
	;..s ret=ret_"^rw|"_p
	;..d OutRowtyp
    
 	;f date=stdate:1:edate
 	f date=edate:-1:stdate
 	{
	  s p="" f  s p=$O(^DHCMGNUR.MgCheckWardI("CheckDate"," "_CheckTyp,date,p),-1) q:p=""  d
	  .s a=##class(DHCMGNUR.MgCheckWard).%OpenId(p)
	  .b ;110
	  .s checkUser=a.CheckUsers.Find(checkPeople)
	  .;s a.CheckUsers
	  .q:checkUser=""
	  .s ret=##class(DHCMGNUR.MgCheckWard).getVal(p)
	  .s ret=ret_"^rw|"_p
	  .d OutRowtyp 
	}

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QualCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QualCheckListExecute ]
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

ClassMethod QualCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QualCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query QualCheckList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

Query FindQualItemRel(HsDr, typ, ward = "", Par = "") As %Query(ROWSPEC = "QualDesc,qudr,SortPos,QualWeight,rw")
{
}

ClassMethod FindQualItemRelExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//D ##class(%ResultSet).RunQuery("web.DHCMgNurSysComm","FindQualItemRel","1","Ward","","")
 	;s ^TMP("k")=$LB(HsDr,typ)
 	s ^TMP("k")=HsDr_"^"_typ
 	s typ=$TR($ZConvert(typ,"U")," ","")
    s tmp=""
	s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr)) q:qudr=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr,rw)) q:rw=""  d
	..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
	..s sort=a.SortPos
	..s q=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
	..s QualDesc=q.QualDesc
	..s wet=q.QualWeight
	..s qucode=q.QualCode
	..s rd=##class(DHCMGNUR.QualCodeItem).getqualid(qucode)
	..if '$D(tmp(sort)) s tmp(sort)=QualDesc_"^"_qucode_"^"_wet_"^"_rd
	..e  s tmp(sort+1)=QualDesc_"^"_CtLocDr_"^"_wet_"^"_rd
	s p=""   f  s p=$O(tmp(p)) q:p=""  d
	.s QualDesc=$P(tmp(p),"^"),qudr=$P(tmp(p),"^",2),wet=$p(tmp(p),"^",3),rd=$p(tmp(p),"^",4)
	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(QualDesc,qudr,p,wet,rd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindQualItemRelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualItemRelExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindQualItemRelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualItemRelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
