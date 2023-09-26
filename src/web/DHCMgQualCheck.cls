Class web.DHCMgQualCheck Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getsortno(r, tm) As %String
{
	s r1=$O(tm(r,""),-1)+1
	q r1
}

ClassMethod getusercp(nurse)
{
 //s a=##class(web.DHCMgQualCheck).getusercp
    s ct="" f  s ct=$O(^CTPCP(ct)) q:ct=""  d
    .s ctypdr=$P($G(^CTPCP(ct,1)),"^",4)
    .q:ctypdr=""
    .s typ=$P(^CT("CPT",ctypdr),"^",4) //CTCPT_InternalType	
    .q:typ'="NURSE"
    .s code=$P(^CTPCP(ct,1),"^",1)
    .//if code["10" w !,code
    .s nursename=$P(^CTPCP(ct,1),"^",2)
    .//if nursename="许敏" b
    .q:((code'[nurse)&(nurse'=""))
    .s nurdr=..getctptouser(ct)
    .q:nurdr=""
   q ""
}

ClassMethod GetCheckItemSubExecute(ByRef qHandle As %Binary, Par As %String) As %Status
{
	s ^TEMP("g20141211155701")=Par
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	;if WardId="" Quit $$$OK
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
		..s ret=ret_"^rw|"_rw_"^Par|"_Par
		..d outtyp2
 	}
 	else
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
		.//d outtyp2
		s r=""  f  s r=$O(TMII(r)) q:r=""  d
		.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
		..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
		..;s ret=##class(DHCMGNUR.QuCheckWardChild).getVal(TMII(r,p))
		..s ret=##class(DHCMGNUR.QuCheckProjectChild).getQuVal(TMII(r,p))
		..s ret=ret_"^rw|"_rw_"^Par|"_Par
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

ClassMethod GetCheckItemSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCheckItemSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCheckItemSub(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod QualRep(Typ As %String, stdate As %String, eddate As %String) As %String
{
    s stdate=$ZDH(stdate,3)
 	s eddate=$ZDH(eddate,3)
 	s chktyp=$TR($ZConvert(Typ,"U")," ","")
    f date=stdate:1:eddate
 	{
	    s loc=""  f  s loc=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc)) q:loc=""  d
	    .s qu=""  f  s qu=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc,qu)) q:qu=""  d
	    ..s rw=""  f  s rw=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc,qu,rw)) q:rw=""  d
	    ...s LocDr=$tr(loc," ","")
	    ...s Ward=$p(^CTLOC(LocDr),"^",2)
	    ...s a=##class(Nur.QualCheckRec).%OpenId(rw)
	    ...s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
	    ...s Score=a.Score
	    ...s chekdate=$ZD(a.CheckDate,3)
	    ...s qudr=a.CheckQual
	    ...s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(a.CheckQual)
	    ...s QualDesc=qual.QualDesc
	    ...s Question=a.CheckQuestion
	    ...if '$D(tmp(LocDr,qudr)) s tmp(LocDr,qudr)=Score
	    ...e  s tmp(LocDr,qudr)=tmp(LocDr,qudr)+Score
	    ...if '$D(nmp(LocDr,qudr)) s nmp(LocDr,qudr)=Score
	    ...e  s nmp(LocDr,qudr)=nmp(LocDr,qudr)+Score
 	}
 	s HsDr=1  //质控项目排序
	 s qudr="" f  s qudr=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr)) q:qudr=""  d
	 .s rw="" f  s rw=$O(^DHCMGNUR.MgNurQualRelLocI("Typ",HsDr," "_typ,qudr,rw)) q:rw=""  d
 	 ..s a=##class(DHCMGNUR.MgNurQualRelLoc).%OpenId(rw)
 	 ..s sort=a.SortPos
 	 ..s q=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
 	 ..s QualDesc=q.QualDesc
 	 ..if '$D(qmp(sort)) s qmp(sort)=QualDesc_"^"_qudr
 	 ..e  s qmp(sort+1)=QualDesc_"^"_CtLocDr
             //科室排序
	s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr)) q:CtLocDr=""  d
	 .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr,rw)) q:rw=""  d
 	 ..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
 	 ..s sort=a.SortPos
 	 ..q:(CtLocDr'=ward)&(ward'="")
 	 ..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
 	 ..if '$D(locmp(sort)) s locmp(sort)=ctlocDesc_"^"_CtLocDr
 	 ..e  s locmp(sort+1)=ctlocDesc_"^"_CtLocDr
         //数据输出
     s s1=""  f  s s1=$O(locmp(s1)) q:s1=""  d
     .s loc=$P(locmp(s1),"^")
     .s locdr=$P(locmp(s1),"^",2)
     .s s2="" f  s s2=$O(qmp(s2)) q:s2=""  d
     ..s qudr=$P(qmp(s2),"^",2)
     ..s qudes=$P(qmp(s2),"^",1)
     ..s sum= tmp(locdr,qudr) //合计分数
     ..s score=sum/nmp(locdr,qudr)  //平均值
     ..s count=nmp(locdr,qudr)  //
}

ClassMethod getchktypPar(user) As %String
{
 ///w ##class(web.DHCMgQualCheck).getchktypPar()
  s nur("NUR")=1
  s nur("LOCNUR")=2
  s nur("MASTERNUR")=3
  s maxn=0
  s par=""
  s typ=""  f  s typ=$O(^DHCMGNUR.MgNurseI("Nurse",user,typ)) q:typ=""  d
  .s ctyp=$TR(typ," ","")
  .s n=nur(ctyp)
  .if n>maxn d
  ..s maxn=n
  ..s par=$O(^DHCMGNUR.MgNurseI("Nurse",user,typ,""))
  q par
}

ClassMethod getsschk(user) As %String
{
 
  //护士没有填写的权限, 只能查看本科室的数据
  //护士长 只能查看本科室的数据 也可已填写本科评分
  //科护士长查看和填写所辖科室数据
  //护理部查看所有级别数据 填写护理部级别的数据
  //NUR：护士长 LOCNUR：科护士长 MASTERNUR: 护理部
  //w ##class(web.DHCMgQualCheck).getsschk()
  s ^TEMP("g20141211192001")=user
  s nur("NUR")=1
  s nur("LOCNUR")=2
  s nur("MASTERNUR")=3
  s group=$p(user,"^",2)
  i group="demo" s nurtyp=0
  e  i group="hlb" s nurtyp=3
  e  i group="nurhead" s nurtyp=1
  e  i group="znurhead" s nurtyp=2
  s maxn=0
  ;s typ=""  f  s typ=$O(^DHCMGNUR.MgNurseI("Nurse",user,typ)) q:typ=""  d
  ;.s ctyp=$TR(typ," ","")
  ;.s n=nur(ctyp)
  ;.if n>maxn s maxn=n
  s typ="" f  s typ=$O(^DHCMGNUR.MgNurseI("Nurse",$p(user,"^",1),typ)) q:typ=""  d
  .s ctyp=$TR(typ," ","")
  .s n=nur(ctyp)
  .i n'=nurtyp s maxn=0
  .e  s maxn=n
  q maxn
}

ClassMethod getqualitmdata(qupar As %String) As %String
{
 //w ##class(web.DHCMgQualCheck).getqualitmdata()
	  s ret=""
	  s quitm="" f  s quitm=$O(^Nur.QualCheckRecChildI("item",quitm)) q:quitm=""  d
	  .s rw=""  f  s rw=$O(^Nur.QualCheckRecChildI("item",quitm,qupar,rw)) q:rw=""  d
      ..s a=##class(Nur.QualCheckRecChild).%OpenId(qupar_"||"_rw)
      ..s itm=a.CheckItem
      ..s b=##class(DHCMGNUR.QualCodeItemSub).%OpenId(itm)
      ..s code=b.ItemCode
      ..s subitm=code_".1"
      ..s Par=$P(itm,"||")
	  ..if '$D(^DHCMGNUR.QualCodeItemSubI("Level"," "_code," "_subitm,Par)) d
      ...s ret=ret_code_"|"_a.CheckMem_"|"_a.CheckScore_"|"_a.CheckPeople_"|"_a.CheckComplete_"|"_a.CheckOccur_"^"  
      b //
      q ret
}

ClassMethod GetQualItemGradeExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("g3291355001")=parr
	s typflag=$P(parr,"^",3)
  	;s qualcode=$P(parr,"^",1)
 	;s Par=##class(DHCMGNUR.QualCodeItem).getqualid(qualcode)
 	;if Par="" Quit $$$OK
    s Par=$P(parr,"^",1)
 	s qualCheckpar=$P(parr,"^",2)
 	s id="" f  s id=$O(^DHCMGNUR.QualCodeItemSubD(Par,id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItemSub).%OpenId(Par_"||"_id)
	.//bs ret=##class(DHCMGNUR.QualCodeItemSub).getVal(Par_"||"_id)
	.s code=a.ItemCode
	.s level=a.ItemLevel
	.s ItemDesc=a.ItemDesc
	.s itmvalue=a.ItemValue
	.//s itmmem=a.ItemMem
	.i level="" s level=code
	.s I=$INUMBER($P(code,"."),"T"),II=$P(code,".",2),III=$P(code,".",3)
	.if II="" s TMI(I)=Par_"||"_id //
	.if (II'="")&(III="") d
	..s II=$INUMBER(II,"T")
	..s TMII(I,II)=Par_"||"_id
	.if (III'="") d
	..s III=$INUMBER(III,"T")
	..s TMIII(I,II,III)=Par_"||"_id
	.//s ret=ret_"^rw|"_id_"^Par|"_Par
	.//d outtyp2
	s r="" f  s r=$O(TMI(r)) q:r=""  d
	.s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMI(r))
	.if qualCheckpar'="" s ret1=##class(Nur.QualCheckRecChild).getcheckitm(qualCheckpar,TMI(r))
	.e  s ret1=""
	.s Par=$P(TMI(r),"||",1),rw=$P(TMI(r),"||",2)
	.s ret=ret_"^rw|"_rw_"^Par|"_Par_"^"_ret1
	.d outtyp2
	.s p="" f  s p=$O(TMII(r,p)) q:p=""  d
	..s Par=$P(TMII(r,p),"||",1),rw=$P(TMII(r,p),"||",2)
	..s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMII(r,p))
	..if qualCheckpar'="" s ret1=##class(Nur.QualCheckRecChild).getcheckitm(qualCheckpar,TMII(r,p))
	..e  d
	...i $p($p(ret,"MinLevel|",2),"^",1)="N" s ret1=""
	...e  s ret1=""
	..s ret=ret_"^rw|"_rw_"^Par|"_Par_"^"_ret1
	..d outtyp2
	..s w=""  f  s w=$O(TMIII(r,p,w)) q:w=""  d
	...s Par=$P(TMIII(r,p,w),"||",1),rw=$P(TMIII(r,p,w),"||",2)
	...s ret=##class(DHCMGNUR.QualCodeItemSub).getVal(TMIII(r,p,w))
	...if qualCheckpar'="" s ret1=##class(Nur.QualCheckRecChild).getcheckitm(qualCheckpar,TMIII(r,p,w))
	...e  s ret1=""
	...s ret=ret_"^rw|"_rw_"^Par|"_Par_"^"_ret1
	...d outtyp2


    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetQualItemGradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQualItemGradeExecute ]
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

Query GetQualItemGrade(parr As %String) As %Query(ROWSPEC = "aa")
{
}

Query FindNur(nurse As %String = "") As %Query(ROWSPEC = "nursename,nurdr")
{
}

ClassMethod FindNurExecute(ByRef qHandle As %Binary, nurse As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^TMP("nurse")=nurse
    s ct="" f  s ct=$O(^CTPCP(ct)) q:ct=""  d
    .s ctypdr=$P($G(^CTPCP(ct,1)),"^",4)
    .q:ctypdr=""
    .s typ=$P(^CT("CPT",ctypdr),"^",4) //CTCPT_InternalType	
    .q:typ'="NURSE"
    .s code=$P(^CTPCP(ct,1),"^",1)
    .s nursename=$P(^CTPCP(ct,1),"^",2)
    .q:((nursename'[nurse)&(nurse'=""))
    .s nurdr=..getctptouser(ct)
    .q:nurdr=""
    .d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(nursename,nurdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurExecute ]
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

ClassMethod FindNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getctptouser(ctpdr) As %String
{
 //医护人员关联用户
   s ssdr="" s ssdr=$O(^SSU("SSUSR",0,"CTPCP",ctpdr,ssdr))
   q ssdr
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

ClassMethod getctp(recuserId) As %String
{
  q:recuserId="" ""
  s User=$P($G(^CTPCP(recuserId,1)),"^",2)
  q recuserId_"!"_User
}

Query FindTypNur(typ As %String = "", nur = "", CheckTyp = "", Name = "", nurloc = "") As %Query(ROWSPEC = "checktyp,nursename,nurdr,ctlocDesc,loc,rw,Level")
{
}

ClassMethod FindTypNurExecute(ByRef qHandle As %Binary, typ As %String = "", nur = "", CheckTyp = "", Name As %String = "", nurloc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//d ##Class(%ResultSet).RunQuery("web.DHCMgQualCheck","FindTypNur","","23254","")
 	s ^TEMP("g03131642001")=typ_"%"_nur_"%"_CheckTyp_"%"_Name_"%"_nurloc
 	s typ=$TR($ZConvert(typ,"U")," ","")
    
    i (CheckTyp="QualSelfCheck") //病房自查
    {
	    ;s loc=$Get(%session.Data("LOGON.CTLOCID")) //从GLOBE里取%session
	    ;s loc=%session.Data("LOGON.CTLOCID") //从GLOBE里取%session
	    s loc=nurloc
	    if loc'="" s ctlocDesc=$p(^CTLOC(loc),"^",2)
	    s checktyp=""	    
	    s ctlocDesc=$$ALPHAUP^SSUTIL4(ctlocDesc)
	    /*
	    s rw=""
	    f  s rw=$o(^RB("RES",0,"CTLOC",loc,rw))  q:rw=""  d
	    .s nurdr=$p(^RB("RES",rw),"^",2)
	    .q:($d(^CTPCP(nurdr))=0)
	    .;q:(nur'="")&&(nur'=nurdr)
	    .s nursename=$p(^CTPCP(nurdr,1),"^",2)
	    .s CTPCPCarPrvTpDR=$p(^CTPCP(nurdr,1),"^",4)
	    .s NurTyp=$p(^CT("CPT",CTPCPCarPrvTpDR),"^",4)
	    .q:NurTyp'="NURSE"  //不等于护士类型就退出
	    .d OutputRow8
	    */
	    s PerDR="" f  s PerDR=$O(^DHCMGNUR.MgPersonsI("Dep"," "_loc,PerDR)) q:PerDR=""  d
	    .s a=##class(DHCMGNUR.MgPersons).%OpenId(PerDR)
		.s PerID=a.PersonID
		.s Personheadship=a.PersonheadshipDR.CodeDesc
		.s NearDate=0,NearID=""
		.s ID="" f  s ID=$O(^DHCMGNUR.MgNurDepartmentWorkI("PerID"," "_$Zcvt(PerID,"U"),PerDR,ID)) q:ID=""  d
		..s b=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(PerDR_"||"_ID)
		..s PerDate=b.PerDate
		..i (PerDate<=+$h)&&(NearDate<PerDate) d
		...s NearDate=PerDate
		...s NearID=ID
		...i NearID'="" d
		....s c=##class(DHCMGNUR.MgNurDepartmentWork).%OpenId(PerDR_"||"_NearID)
		....i c.PerQualCtrNurse=1  d
		.....s nursename=c.PerName
		.....s PerID=$ZConvert(PerID,"U")
		.....s NurId=$O(^SSU("SSUSR",0,"SSUSR_Initials",PerID,""))
		.....s mtemp(NurId)=$lb("护士长",nursename,NurId,$G(ctlocDesc),$g(loc),rw,NurTyp)
		.s PerID=$ZConvert(PerID,"U")
		.s NurId=$O(^SSU("SSUSR",0,"SSUSR_Initials",PerID,""))
		.s nursename=a.PersonName
		.i (Personheadship="副护士长")||(Personheadship="护士长") s mtemp(NurId)=$lb("护士长",nursename,NurId,$G(ctlocDesc),$g(loc),rw,NurTyp)
	    ;b ;00
	    //耳鼻咽喉单独判断
	    ;i loc=1552 d
	    ;.s mtemp(23279)=$lb("护士长","崔江萍",23279,$G(ctlocDesc),$g(loc),$g(rw),$g(NurTyp))
	    ;.s mtemp(22791)=$lb("护士长","薛贵芝",22791,$G(ctlocDesc),$g(loc),$g(rw),$g(NurTyp))
	    
    }
    else
    {
		//护理部查房    
    	s tp=""  f  s tp=$O(^DHCMGNUR.MgNurseI("typ",tp))  q:tp=""  d
   		.s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseI("typ",tp,rw))   q:rw=""  d
    	..s a=##class(DHCMGNUR.MgNurse).%OpenId(rw)
    	..s ctyp=$TR(tp," ","")
    	..q:((typ'=ctyp)&(typ'=""))
    	..s checktyp=""
    	..if (ctyp="NUR") s checktyp="护士长" s NurTyp="Nur"
    	..if (ctyp="LOCNUR") s checktyp="总护士长" s NurTyp="LocNur"
    	..if (ctyp="MASTERNUR") s checktyp="护理部" s NurTyp="MasterNur"
    	..s nurdr=a.Nurse
    	..q:(nurdr'=nur)&&(nur'="")
    	..s ctlocDesc=""
    	..s nursename=$P(..getsuser(a.Nurse),"!",2)
    	..q:(nursename'[Name)&&(Name'="")
    	..s loc=a.WardLoc
    	..if a.WardLoc'="" s ctlocDesc=$p(^CTLOC(a.WardLoc),"^",2)
    	..s mtemp(nurdr)=$lb(checktyp,nursename,nurdr,$G(ctlocDesc),loc,rw,NurTyp)
    }
    s nur="" f  s nur=$o(mtemp(nur)) q:nur=""  d
    .d OutputRow8
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	;set Data=$lb(checktyp,nursename,nurdr,$G(ctlocDesc),loc,rw)
 	set Data=mtemp(nur)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindTypNurFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTypNurExecute ]
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

ClassMethod FindTypNurClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTypNurExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindNurLocWard(Par As %String = "") As %Query(ROWSPEC = "LocDr,LocWard,Par,rw")
{
}

ClassMethod FindNurLocWardExecute(ByRef qHandle As %Binary, Par As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
    s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseD(Par,"ChildSub",rw)) q:rw=""  d
    .s a=##class(DHCMGNUR.MgNurseSub).%OpenId(Par_"||"_rw)
    .s LocDr=a.WardLoc
    .s LocWard=$p(^CTLOC(LocDr),"^",2)
    .d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(LocDr,LocWard,Par,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurLocWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurLocWardExecute ]
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

ClassMethod FindNurLocWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurLocWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query CheckList(parr As %String = "") As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw")
{
}

ClassMethod CheckListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TMP("parr")=parr
 	s stdate=$ZDH($P(parr,"^",1),3)
 	s eddate=$ZDH($P(parr,"^",2),3)
 	s chktyp=$P(parr,"^",3)
 	s qualcode=$P(parr,"^",4)
 	s Wardloc=$P(parr,"^",5)
 	
 	s qualdr=##class(DHCMGNUR.QualCodeItem).getqualid(qualcode)
 	s chktyp=$TR($ZConvert(chktyp,"U")," ","")
    if (chktyp="NUR") s CheckTyp="护士长"
    if (chktyp="LOCNUR") s CheckTyp="科护士长"
    if (chktyp="MASTERNUR") s CheckTyp="护理部"

 	f date=stdate:1:eddate
 	{
	    s loc=""  f  s loc=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc)) q:loc=""  d
	    .s qu=""  f  s qu=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc,qu)) q:qu=""  d
	    ..s rw=""  f  s rw=$O(^Nur.QualCheckRecI("Check",date," "_chktyp,loc,qu,rw)) q:rw=""  d
	    ...s LocDr=$tr(loc," ","")
	    ...q:(LocDr'=Wardloc)&(Wardloc'="")
	    ...s Ward=$p(^CTLOC(LocDr),"^",2)
	    ...s a=##class(Nur.QualCheckRec).%OpenId(rw)
	    ...q:(a.CheckQual'=qualdr)&(qualdr'="")
	    ...s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
	    ...s Score=a.Score
	    ...s chekdate=$ZD(a.CheckDate,3)
	    ...s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(a.CheckQual)
	    ...s QualDesc=qual.QualDesc
	    ...s Question=a.CheckQuestion
	    ...d OutputRow8
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckListExecute ]
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

ClassMethod CheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QCheckList(CheckCode, QualDr, WardLoc, SEDate) As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw,PatName")
{
}

ClassMethod QCheckListExecute(ByRef qHandle As %Binary, CheckCode, QualDr, WardLoc, SEDate) As %Status
{
	
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	;b ;01
 	s ^TMP("g201501071526001")=CheckCode_"%"_QualDr_"%"_WardLoc_"%"_SEDate
 	s stdate=$zdh($p(SEDate,"^",1),3)
    s eddate=$zdh($p(SEDate,"^",2),3)
    ;s CheckCode=$ZConvert(CheckCode,"U")
 	s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc)) q:loc=""  d
 	.;q:($TR(loc," ","")'=WardLoc)&(WardLoc'="")
 	.s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek)) q:Chek=""  d
 	..q:($TR(Chek," ","")'=CheckCode)&&(CheckCode'="")
 	..s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek,rw)) q:rw=""  d
    ...s LocDr=$tr(loc," ","")
    ...q:(LocDr'=WardLoc)&&(WardLoc'="")
    ...s Ward=$p(^CTLOC(LocDr),"^",2)
    ...s a=##class(Nur.QualCheckRec).%OpenId(rw)
    ...;q:(typ'="")&&(a.ChkTyp'=typ)
    ...s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
    ...q:(a.CheckDate<stdate)!(a.CheckDate>eddate)
    ...s CheckTypId=""
    ...s CheckTypId=a.CheckTyp
    ...i CheckTypId="Nur" s CheckTyp="护士长"
    ...i CheckTypId="LocNur" s CheckTyp="科护士长"
    ...i CheckTypId="MasterNur" s CheckTyp="护理部"
    ...s Score=a.Score_"/"_a.CompRate
    ...s PatName=a.CheckPat
    ...s chekdate=$ZD(a.CheckDate,3)
    ...;s qudr=##class(DHCMGNUR.QualCodeItem).getqualid(CheckCode)   
    ...s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(CheckCode)
    ...s QualDesc=qual.QualDesc
    ...s Question=a.CheckQuestion
    ...;s flag=a.ChkTyp
    ...;i flag="Nur" s CheckTyp="护士长"
    ...;i flag="LocNur" s CheckTyp="科护士长"
    ...;i flag="MasterNur" s CheckTyp="护理部"
    ...d OutputRow8
 
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw,PatName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QCheckListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QCheckListExecute ]
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

ClassMethod QCheckListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QCheckListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//通过住院号查询病人姓名

ClassMethod getPatName(No) As %String
{

  q:No="" ""
  s rowid=""
  ;s rowid=^PAPERi("PAPMI_PatNo",$$ALPHAUP(No),rowid)
  s rowid=$o(^PAPERi("PAPMI_PatNo",No,rowid))
  ;b ;01
  q:rowid="" ""
  s Name=$P($G(^PAPER(rowid,"ALL")),"^",1)
   ;b ;01
  q $g(Name)
 // s ^mw123("zzz")=No_"^"_Name
}

//2013-5-22

ClassMethod CheckNurseExecute(ByRef qHandle As %Binary, Par As %String = "") As %Status
{
	s ^TEMP("g20141211161401")=Par
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="2009-10-4^2009-12-25" 	
   // s itm=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
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
	//s ^mw123("c")=Par_"!"_ret
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

/// 
/// Method Description:病房质控快速输入检查者查询
/// 
ClassMethod CheckUserExecute(ByRef qHandle As %Binary, Par As %String = "") As %Status
{
	s ^TEMP("g312001")=Par
	Set repid=$I(^CacheTemp)
 	s ind=1
    //s parr="2009-10-4^2009-12-25" 	
   // s itm=##class(DHCMGNUR.QuCheckWard).%OpenId(Par)
    s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(Par)
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
	//s ^mw123("c")=Par_"!"_ret
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckUserExecute ]
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

ClassMethod CheckUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query CheckUser(Par As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getQualCode(typ As %String, tm) As %String
{
 //##class(web.DHCMgQualCheck).getQualCode()
   	s ret=""
   	s id="" 
 	f  s id=$O(^DHCMGNUR.QualCodeItemD(id)) q:id=""  d
 	.s a=##class(DHCMGNUR.QualCodeItem).%OpenId(id)
 	.q:(typ'=a.QualCat)&(typ'="")
 	.q:a.QualWeight=""
	.q:$D(tm(id))
	.s code=a.QualCode
	.s ret=ret_code_"^"
	q ret
}

ClassMethod getUnCheckCode(id, EmrCode) As %String
{
  //##class(web.DHCMgQualCheck).getUnCheckCode()
        s ^yy(123)=id_","_EmrCode
   		s itm=##class(DHCMGNUR.MgCheckWard).%OpenId(id)
		s tm=""
        s l=itm.CheckQuals.Count()
        s cat=""
	    for i=1:1:l
	    {
		  s rww=itm.CheckQuals.GetAt(i)
		  s rw=$p(rww,"!",2)
		  s tm(rw)=""
		  s a=##class(DHCMGNUR.QualCodeItem).%OpenId(rw)
		  s cat=a.QualCat
		}
		s ret=""
		if cat'=""
		{
	    	s ret=##class(web.DHCMgQualCheck).getQualCode(cat,.tm)
		}
		if ret'=""  s ^DHCMgNurCheckSum(EmrCode)=ret
		q ret
}

Query CheckQuestion(CheckCode, QualDr, WardLoc, SEDate) As %Query(ROWSPEC = "CheckTyp,CheckDate,WardLoc,QualDesc,Score,CheckUser,Question,rw,PatName")
{
}

ClassMethod CheckQuestionExecute(ByRef qHandle As %Binary, CheckCode, QualDr, WardLoc, SEDate) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	 s stdate=$zdh($p(SEDate,"^",1),3)
     s eddate=$zdh($p(SEDate,"^",2),3)
     s CheckCode=$ZConvert(CheckCode,"U")
 	 s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc)) q:loc=""  d
 	 .;q:($TR(loc," ","")'=WardLoc)&(WardLoc'="")
 	 .s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek)) q:Chek=""  d
 	 ..q:($TR(Chek," ","")'=CheckCode)&&(CheckCode'="")
 	 ..s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek,rw)) q:rw=""  d
     ...s LocDr=$tr(loc," ","")
     ...q:(LocDr'=WardLoc)&&(WardLoc'="")
     ...s Ward=$p(^CTLOC(LocDr),"^",2)
     ...s a=##class(Nur.QualCheckRec).%OpenId(rw)
     ...//q:(a.CheckQual'=QualDr)&(QualDr'="")
     ...s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
     ...q:(a.CheckDate<stdate)!(a.CheckDate>eddate)
     ...s Score=a.Score
     ...s PatName=a.CheckPat
     ...s chekdate=$ZD(a.CheckDate,3)
     ...s qudr=##class(DHCMGNUR.QualCodeItem).getqualid($TR(Chek," ",""))   
     ...s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
     ...s QualDesc=qual.QualDesc
     ...s Question=a.CheckQuestion
     ...q:(Question="")
     ...s Ward=$P(Ward,"-",2)
     ...s tmp(QualDesc,Ward)=$LB(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw,PatName)
     s qu=""  f  s qu=$O(tmp(qu)) q:qu=""  d
     .s w=""  f  s w=$O(tmp(qu,w)) q:w=""   d
     ..s Data=tmp(qu,w)
     ..d OutputRow8
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	//set Data=$lb(CheckTyp,chekdate,Ward,QualDesc,Score,CheckUser,Question,rw,PatName)
	;set Data=$lb(CheckTyp,Ward,Ward,QualDesc,Score,CheckDate,CheckUser,Question,rw)
	;set ^mw123("data")=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CheckQuestionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckQuestionExecute ]
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

ClassMethod CheckQuestionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckQuestionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getQuestions(QualDr) As %String
{
  //w ##class(web.DHCMgQualCheck).getQuestions
 	 s loc=""  f  s loc=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc)) q:loc=""  d
 	 .s Chek=""  f  s Chek=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek)) q:Chek=""  d
 	 ..s rw=""  f  s rw=$O(^Nur.QualCheckRecI("QCheck"," "_QualDr,loc,Chek,rw)) q:rw=""  d
     ...s LocDr=$tr(loc," ","")
     ...s Ward=$p(^CTLOC(LocDr),"^",2)
     ...s a=##class(Nur.QualCheckRec).%OpenId(rw)
     ...s CheckUser=$P(..getsuser(a.CheckUser),"!",2)
     ...s Score=a.Score
     ...s PatName=a.CheckPat
     ...s chekdate=$ZD(a.CheckDate,3)
     ...s qudr=##class(DHCMGNUR.QualCodeItem).getqualid($TR(Chek," ",""))   
     ...s qual=##class(DHCMGNUR.QualCodeItem).%OpenId(qudr)
     ...s QualDesc=qual.QualDesc
     ...s Question=a.CheckQuestion
     ...q:Question=""
     ...s Ward=$P(Ward,"-",2)
     ...s tmp(QualDesc,Ward)=Question
     s itm=""
     s i=0
     s ret=""
     s qu=""  f  s qu=$O(tmp(qu)) q:qu=""  d
     .s ret=ret_qu_"^"
     .s i=i+1
     .s w=""  f  s w=$O(tmp(qu,w)) q:w=""   d
     ..s Data=tmp(qu,w)
     ..s ret=ret_w_"|"_tmp(qu,w)_"^"
     ..s i=i+1
    q ret
}

/// 
/// 检查人员维护
/// 
Query FindCheckPerson(typ As %String = "", nur = "", CheckTyp = "", Name = "") As %Query(ROWSPEC = "checktyp,nursename,nurdr,ctlocDesc,loc,rw,Level")
{
}

ClassMethod FindCheckPersonExecute(ByRef qHandle As %Binary, typ As %String = "", nur = "", CheckTyp = "", Name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("g201412251723001")=typ_"%"_nur_"%"_CheckTyp_"%"_Name
 	s ret=""
 	s typ=$TR($ZConvert(typ,"U")," ","")
 	s tp=""  f  s tp=$O(^DHCMGNUR.MgNurseI("typ",tp))  q:tp=""  d
   	.s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseI("typ",tp,rw))   q:rw=""  d
    ..s a=##class(DHCMGNUR.MgNurse).%OpenId(rw)
    ..s ctyp=$TR(tp," ","")
    ..q:((typ'=ctyp)&(typ'=""))
    ..s NurType=a.NurTyp
    ..s nurdr=a.Nurse
    ..s WardLoc=a.WardLoc
    ..s nursename=$P(..getsuser(a.Nurse),"!",2)
    ..s loc=a.WardLoc
    ..i loc'="" s ctlocDesc=$p(^CTLOC(loc),"^",2)
    ..i NurType="Nur" s checktyp="护士长" s NurTyp="Nur"
    ..i NurType="LocNur" s checktyp="总护士长" s NurTyp="LocNur"
    ..i NurType="MasterNur" s checktyp="护理部"	s NurTyp="MasterNur"
    ..d OutputRow8
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(checktyp,nursename,nurdr,$G(ctlocDesc),loc,rw,NurTyp)
 	;set Data=mtemp(nur)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCheckPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCheckPersonExecute ]
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

ClassMethod FindCheckPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCheckPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
