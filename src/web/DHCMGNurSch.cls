Class web.DHCMGNurSch Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetWardPat(ward, funname) As %String
{
  s pacward=$O(^PAWARD(0,"WARD_LocationDR",ward,""))
  q:pacward="" ""
   s num=0
  s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
  .s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
  ..s patinfo=..PatInfo(adm)
  ..s bed=$P(patinfo,"^",6)
  ..s admdate=$P(^PAADM(adm),"^",6)
  ..s admdate=$ZD(admdate,3)
  ..s name=$P(patinfo,"^",5)
  ..s sex=$P(patinfo,"^",4)
  ..s age=$P(patinfo,"^",7)
  ..s diag=$P(patinfo,"^",9)
  ..s num=num+1
  ..s rtnval=funname_"('"_$ZCVT($g(bed),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(admdate),"O","JS")_"','"_$ZCVT($g(Sex),"O","JS")_"','"_$ZCVT($g(age),"O","JS")_"','"_$ZCVT($g(diag),"O","JS")_"','"_$ZCVT($g(adm),"O","JS")_"');"
  ..&javascript<#(rtnval)#>
  q "本区病人("_num_")"
}

ClassMethod GetWardPatNum(ward) As %String
{
  s pacward=$O(^PAWARD(0,"WARD_LocationDR",ward,""))
  q:pacward="" "本区病人(0)"
  s num=0
  s room=""  f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
  .s adm=""  f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d   
  ..s num=num+1
  q "本区病人("_num_")"
}

ClassMethod GetSortDep(typ, funname) As %String
{
 //获取排序科室//web.DHCMGNurSch.GetSortDep
  //  n (typ)
   //k ^TMP(typ)
   s nn=0
    s rw=""  f  s rw=$O(^User.DHCMGArrangPerSortI("Typ"," "_typ,rw)) q:rw=""  d
    .s dep=$List(^User.DHCMGArrangPerSortD(rw),4)
    .s sort=$List(^User.DHCMGArrangPerSortD(rw),5)
    .;s nn=nn+1
    .;q:nn>10
    .s m(sort)=dep
    s ret=""
    s rw="" f  s rw=$O(m(rw)) q:rw=""  d
    .s dep=m(rw), des=$P(^CTLOC($TR(dep," ")),"^",2)
    .s rtnval=funname_"('"_$ZCVT($g(dep),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"');"
    .&javascript<#(rtnval)#>
    q ret
}

ClassMethod getattentionData(typ, ward, AttItem = "", funname)
{
	//s a=##Class(web.DHCMGNurSch).getattentionData()
   	// s Date=$ZDH("2010-03-11",3)
  	s itm="" f  s itm=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr"," "_ward,+$H,itm)) q:itm=""  d
  	.b
  	.s rw=""  f  s rw=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr"," "_ward,+$H,itm,rw)) q:rw=""  d
   	.. s itmw=$TR(itm," ","")
   	.. s a=^User.DHCMGNurWorkItmD(itmw)
   	.. s Name=$ListGet(a,4)
   	.. s b=^Nur.DHCMGCurrDayAttenNumD(rw)
   	.. s num=$listget(b,4)
   	.. s des(itmw)=Name_"("_num_")"
   	.. b
   
   	s ItmTypNum=$l(typ,"^")
	for i=1:1:ItmTypNum {
		s curItmTyp=$p(typ,"^",i)
   		s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_curItmTyp,rw)) q:rw=""  d
   		.s a=^User.DHCMGNurWorkItmD(rw)
   		.s Code=$listget(a,2)
   		.q:(AttItem'="")&(Code'=AttItem)
   		.s Name=$listget(a,4)
   		. if Name["门诊" q
   		. if Name["急诊" q
   		. if Name["留观" q
   		.if $D(des(rw)) s des=des(rw)
   		.else  s des=Name
   		. s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"');"
   		. &javascript<#(rtnval)#>
	}
}

ClassMethod GetMzData(typ, ward, AttItem = "", funname)
{
 //s a=##Class(web.DHCMGNurSch).GetMzData()
   s mz=0,jz=0,lg=0
   s ^AA=$lb(typ,ward,funname)
   s loc=""  f  s loc=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr",loc)) q:loc=""  d
   .s itm=""  f  s itm=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr",loc,+$H,itm)) q:itm=""  d
   ..s rw=""  f  s rw=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr",loc,+$H,itm,rw)) q:rw=""  d
   ... s itmw=$TR(itm," ","")
   ... s a=^User.DHCMGNurWorkItmD(itmw)
   ... s Name=$ListGet(a,4)
   ... s b=^Nur.DHCMGCurrDayAttenNumD(rw)
   ... s num=$listget(b,4)
   ... if Name["门诊" s mz=mz+num
   ... if Name["急诊" s jz=jz+num
   ... if Name["留观" s lg=lg+num
   s num=""
   s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," O",rw)) q:rw=""  d
   .s a=^User.DHCMGNurWorkItmD(rw)
   .s Name=$listget(a,4)
   .s Code=$listget(a,2)
   .q:(AttItem'="")&(Code'=AttItem)
   . if Name["门诊" s num=mz
   . if Name["急诊" s num=jz
   . if Name["留观" s num=lg
   . q:num=""
   . b
   . s des=Name_"("_num_")"
   . s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(des),"O","JS")_"');"
   . s num=""
   . &javascript<#(rtnval)#>
}

ClassMethod getMzDetail(ward, itm, funname)
{
   //s a=##Class(web.DHCMGNurSch).getMzDetail()
      s Date=+$H
      s num=0
 //    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_diag
      s loc=""  f  s loc=$O(^Nur.DHCMGCurrDayAttenPatI("WardCurr",loc)) q:loc=""!(num=10)  d
      .s Adm=""  f  s Adm=$O(^Nur.DHCMGCurrDayAttenPatI("WardCurr",loc,Date," "_itm,Adm)) q:Adm=""!(num=10)  d
      ..s Admw=$TR(Adm," ","")
      ..s patinfo=..PatInfo(Admw)
      ..s admdate=$P(^PAADM(Admw),"^",6)
      ..s admdate=$ZD(admdate,3)
      ..s locdes=$P(patinfo,"^",2)
      ..s name=$P(patinfo,"^",5)
      ..s sex=$P(patinfo,"^",4)
      ..s age=$P(patinfo,"^",7)
      ..s diag=$P(patinfo,"^",9)
      ..s num=num+1
      ..s rtnval=funname_"('"_$ZCVT($g(locdes),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(admdate),"O","JS")_"','"_$ZCVT($g(Sex),"O","JS")_"','"_$ZCVT($g(age),"O","JS")_"','"_$ZCVT($g(diag),"O","JS")_"','"_$ZCVT($g(Admw),"O","JS")_"');"
      ..&javascript<#(rtnval)#>
    q
}

ClassMethod getAttenionDetail(ward, itm, funname)
{
   //s a=##Class(web.DHCMGNurSch).getAttenionDetail()
 //    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_diag
      s Adm=""  f  s Adm=$O(^Nur.DHCMGCurrDayAttenPatI("WardCurr"," "_ward,+$H," "_itm,Adm)) q:Adm=""  d
      .s Admw=$TR(Adm," ","")
      .s admdate=$P(^PAADM(Admw),"^",6)
      .s admdate=$ZD(admdate,3)
      .s patinfo=..PatInfo(Admw)
      .s bed=$P(patinfo,"^",6)
      .s name=$P(patinfo,"^",5)
      .s sex=$P(patinfo,"^",4)
      .s age=$P(patinfo,"^",7)
      .s diag=$P(patinfo,"^",9)
      .s rtnval=funname_"('"_$ZCVT($g(bed),"O","JS")_"','"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(admdate),"O","JS")_"','"_$ZCVT($g(Sex),"O","JS")_"','"_$ZCVT($g(age),"O","JS")_"','"_$ZCVT($g(diag),"O","JS")_"','"_$ZCVT($g(Admw),"O","JS")_"');"
      .&javascript<#(rtnval)#>
}

ClassMethod GetHead(funname, typ = "")
{
   if typ'="MZ" s head="BedCode|床号^PatName|姓名^admdate|就诊日期^Sex|性别^Age|年龄^Diag|诊断^Adm|就诊号"
   else   s head="Dep|科室^PatName|姓名^admdate|就诊日期^Sex|性别^Age|年龄^Diag|诊断^Adm|就诊号"
   s l=$l(head,"^")
   for i=1:1:l
   {
	   s itm=$p(head,"^",i)
	   s name=$P(itm,"|",2),id=$P(itm,"|",1)
       s rtnval=funname_"('"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"
       &javascript<#(rtnval)#>
   }
}

/// 取住院关注的项目名称(显示列)
ClassMethod GetAttHead(funname, typ = "")
{
	//w ##class(web.DHCMGNurSch).GetAttHead("","A^O")
	i typ="" q
	s head="Ward|病区^WardId|病区ID"
	s ItmTypNum=$l(typ,"^")
	for i=1:1:ItmTypNum 
	{
		s curItmTyp=$p(typ,"^",i)
		s rw=""  f  s rw=$O(^User.DHCMGNurWorkItmI("TYP"," "_curItmTyp,rw)) q:rw=""  d
		.s a=^User.DHCMGNurWorkItmD(rw)
		.s Code=$listget(a,2)
		.s Name=$listget(a,4)
		.i Name["门诊" q
   		.i Name["急诊" q
   		.i Name["留观" q
		.s flag=$listget(a,7)
		.q:flag="N"
		.i head="" s head=Code_"|"_Name
		.e  s head=head_"^"_Code_"|"_Name
	}
    i head="" q
    s l=$l(head,"^")
   	for i=1:1:l
   	{
		s itm=$p(head,"^",i)
		s name=$P(itm,"|",2),id=$P(itm,"|",1)
		i id="Ward" d
		.s width=180		//列宽
		.s align="left"
		e  d
		.s width=80
		.s align="center" 
		i id="WardId" s hidden="1" 	//隐藏
		e  s hidden=""				//显示
		s rtnval=funname_"('"_$ZCVT($g(name),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(width),"O","JS")_"','"_$ZCVT($g(hidden),"O","JS")_"','"_$ZCVT($g(align),"O","JS")_"');"
		&javascript<#(rtnval)#>
   }
}

/// 取住院关注的项目值
ClassMethod GetAttData(typ, funname)
{
	//w ##class(web.DHCMGNurSch).GetAttData("A^O","")
	s depitm=##class(web.DHCMGPERSON).GetSortDep("NUR")
	s l=$L(depitm,"^")
	for i=1:1:l
	{
		
		s aa=$P(depitm,"^",i)
	    if aa="" continue
	    s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
	    if dep="" continue
	    i $l(depdes,"-")>1 s depdes=$p(depdes,"-",2)
	    s ret="{'Ward':'"_depdes_"','WardId':'"_dep_"'"
		s YJHL=0,EJHL=0,WZBR=0,TJHL=0
		s ItmTypNum=$l(typ,"^")
		for j=1:1:ItmTypNum 
		{
			s k=0
			s curItmTyp=$p(typ,"^",j)
			s curTtmId=""  f  s curTtmId=$O(^User.DHCMGNurWorkItmI("TYP"," "_curItmTyp,curTtmId)) q:curTtmId=""  d
			.s a=^User.DHCMGNurWorkItmD(curTtmId)
			.s Code=$listget(a,2)
			.s Name=$listget(a,4)
			.i Name["门诊" q
   			.i Name["急诊" q
   			.i Name["留观" q
			.s flag=$listget(a,7)
			.q:flag="N"
			.s k=k+1
			.s num=0
			.s rw=""  f  s rw=$O(^Nur.DHCMGCurrDayAttenNumI("WardCurr"," "_dep,+$H," "_curTtmId,rw)) q:rw=""  d
   			..s b=^Nur.DHCMGCurrDayAttenNumD(rw)
   			..s num=$listget(b,4)
   			.i ret="" s ret="'"_Code_"':'"_num_"'"
   			.e  s ret=ret_",'"_Code_"':'"_num_"'"	
		}
		s ret=ret_"}"
		s rtnval=funname_"('"_$ZCVT($g(ret),"O","JS")_"');"
   		&javascript<#(rtnval)#>
	}
}

ClassMethod PatInfo(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   // n (curId)
    s admId=curId
    s papmiId=+^PAADM(admId)
    s mradm=$p(^PAADM(admId),"^",61)
    s diag=##class(web.DHCMGNurComm).Diag(mradm,"PRE")
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P(^CTPCP(doc,1),"^",2)
    s roomId=$p(^PAADM(admId),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s MedCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    i $d(^PAPER(papmiId,"PAT",3)) s safetyNetCardNo=$p(^PAPER(papmiId,"PAT",3),"^",4) ;病案号
    e  s safetyNetCardNo=""
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
    s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
    s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
    s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
    s bedSub=$p($p($g(^PAADM(admId)),"^",73),"||",2)
    s curWardId=$p($g(^PAADM(admId)),"^",70)  
    i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    e  s bedCode=""
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.DHCMGNurComm).CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    //ctlocDesc未取后半部分 ypz 060522
    s retStr=regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_diag
    q retStr
}

ClassMethod GetWorkNurRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s witm=$P(par,"^",2)
 	s RpId=$P(par,"^",1)
 	s l=$L(witm,"|")
 	s ret="科  室|200^"
 	for i=1:1:l
 	{
	   s a=$P(witm,"|",i)
	   if a="" continue
	   s cc=##class(User.DHCMGNurWorkItm).%OpenId(a)
       s itmname=cc.WorkItm
       s WorkItm(a)=itmname
       s ret=ret_itmname_"|100"_"^"
	}
	s SchItm=ret
    s pa=""  f  s pa=$O(^Nur.DHCMGNurWorkRpI("WorkRp",RpId,pa)) q:pa=""  d
     .s loc=$list(^Nur.DHCMGNurWorkRpD(pa),5)
     .s ret=""
     .k work
     .s rw=""  f  s rw=$O(^Nur.DHCMGNurWorkRpWardD(pa,rw)) q:rw=""  d
     ..s itm=$list(^Nur.DHCMGNurWorkRpWardD(pa,rw),4)
     ..q:'$D(WorkItm(itm))
     ..//s a=##class(User.DHCMGNurWorkItm).%OpenId(itm)
     ..//s itmname=a.WorkItm
     ..s num=$list(^Nur.DHCMGNurWorkRpWardD(pa,rw),5)
     ..s work(itm)=num
     ..//s count=$list(^Nur.DHCMGNurWorkRpWardD(par,rw),3)
     .s ret=""
     .s tt="" f  s tt=$O(WorkItm(tt)) q:tt=""  d
     ..if $D(work(tt)) s ret=ret_work(tt)_"^"
     ..e  s ret=ret_"^"
     .s WardWork(loc)=ret
     s depitm=##class(web.DHCMGPERSON).GetSortDep("NUR")
     s l=$L(depitm,"^")
     s workstr=SchItm
     d out
     for i=1:1:l
     {
	    s aa=$P(depitm,"^",i)
	    if aa="" continue
	    s dep=$P(aa,"|"),depdes=$P(aa,"|",2)
	    if '$D(WardWork(dep)) continue
	    s workstr=depdes_"^"_WardWork(dep)
	    d out
	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out
	set Data=$lb(workstr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkNurRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkNurRpExecute ]
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

ClassMethod GetWorkNurRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkNurRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkNurRp(parr As %String) As %Query(ROWSPEC = "itm")
{
}

ClassMethod GetWorkWardRpExecute(ByRef qHandle As %Binary, par As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s par="2010-01-01^2010-01-30"
    s stdate=$P(par,"^",1)
    s eddate=$P(par,"^",2)
    s stdate=$ZDH(stdate,3)
    s eddate=$ZDH(eddate,3)
    f date=stdate:1:eddate
    {
     s rw=""  f  s rw=$O(^Nur.DHCMGWorkRpI("StDate",date,rw)) q:rw=""  d
     .s sdate=$list(^Nur.DHCMGWorkRpD(rw),7)
     .s sdate=$ZD(sdate,3)
     .s edate=$list(^Nur.DHCMGWorkRpD(rw),5)
     .s edate=$ZD(edate,3)
     .s creatdate=$list(^Nur.DHCMGWorkRpD(rw),3)
     .s createdate=$ZD(creatdate,3)
     .s creattime=$list(^Nur.DHCMGWorkRpD(rw),2)
     .s createtime=$ZT(creattime)
     .s user=""  //$list(^Nur.DHCMGNurWorkRpD(rw),4)
     .s mem=$list(^Nur.DHCMGWorkRpD(rw),6)
     .s title=$list(^Nur.DHCMGWorkRpD(rw),8)
     .s mon=$list(^Nur.DHCMGWorkRpD(rw),9)
     .if mon'="" d
     ..s a=##class(User.DHCMGCCode).%OpenId(mon)
     ..s title=a.MgCodeDesc
     .d out
   

    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

  
out
	set Data=$lb(sdate,edate,createdate,createtime,mem,title,rw,"false")
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWorkWardRpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkWardRpExecute ]
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

ClassMethod GetWorkWardRpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkWardRpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetWorkWardRp(parr As %String) As %Query(ROWSPEC = "sdate,edate,createdate,createtime,mem,title,rw,Sel")
{
}

}
