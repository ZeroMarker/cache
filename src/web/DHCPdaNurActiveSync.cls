Class web.DHCPdaNurActiveSync Extends %RegisteredObject [ ProcedureBlock ]
{

Query GetUserList(loc As %String = "") As %Query(ROWSPEC = "userid,usercode,username,password,logloc")
{
}

ClassMethod getmeasurepat(ward, TMP, ITM, curdate) As %String
{
  //s a=##class(web.DHCPdaNurActiveSync).getmeasurepat(111,"","","")
         // s ward=111
         // s TMP="",ITM=""
         // s curdate=$ZD(+$H,3)
          s LocCat=##class(web.DHCNurNeedMeasureTempPat).GetLocCat(ward)
 	      s Ward=##class(web.DHCThreeNew).getlocward(ward)
	      if (Ward'="")
	      {
		   //s a=##class(web.DHCNurNeedMeasureTempPat).gettyptimes(.ITM)
		   s a=##class(web.DHCNurNeedMeasureTempPat).gettyptimes(.ITM,LocCat)
            b
		   s a=##class(web.DHCNurNeedMeasureTempPat).NeedMeasureTempPats(Ward,curdate,.TMP,.ITM)
		   b  ///求出患者类型
	      }
	      q 0
}

ClassMethod GetUserListExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	  s rw=""  f  s rw=$O(^RB("RES",0,"CTLOC",loc,rw)) q:rw=""  d
 	  .s ctpcp=$P(^RB("RES",rw),"^",2)
 	  .s uname=$P(^RB("RES",rw),"^",17)
 	  .s userid=$O(^SSU("SSUSR",0,"CTPCP",ctpcp,""),-1)
 	  .q:userid=""
	  .s code=$P(^SSU("SSUSR",userid),"^",1)
      .s password="1"
      .s logloc=..getlogloc(userid)
      .d OutRowtyp
  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(userid,code,uname,password,logloc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListExecute ]
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

ClassMethod GetUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getuserdata()
{
 //用户  ##class(web.DHCNURActiveSync).getuserdata()
	  s rw="" f  s rw=$O( ^SSU("SSUSR",rw) ) q:rw=""  d
	  .s code=$P(^SSU("SSUSR",rw),"^",1)
	  .s uname=$P(^SSU("SSUSR",rw),"^",2)
	  .s password="1"
	  .s logloc=..getlogloc(rw)
	  .w !,logloc
}

ClassMethod getlogloc(UserID) As %String
{
 //登陆科室
   
   	 set UserDefaultDept=$piece($get(^SSU("SSUSR",UserID)),"^",4)
	 set UserDefaultGroupID=$piece($get(^SSU("SSUSR",UserID)),"^",5)
	 s desc=$P(^CTLOC(UserDefaultDept),"^",2)

	 s ret=""
	if (UserDefaultDept'="")
	{
		s ret=UserDefaultDept_"_"_desc_"_"_UserDefaultGroupID_"_Y"
		
	}
	set sub="0"
	while($order(^SSU("SSUSR",UserID,"OTHLL",sub))'="")
	{
		set sub=$order(^SSU("SSUSR",UserID,"OTHLL",sub))
		set DeptID=$piece($get(^SSU("SSUSR",UserID,"OTHLL",sub)),"^",1)
		s desc=$P(^CTLOC(DeptID),"^",2)
		set UserGroupID=$piece($get(^SSU("SSUSR",UserID,"OTHLL",sub)),"^",2)
	    if ret'="" s ret=DeptID_"_"_desc_"_"_UserGroupID_"_"_"."_ret
	    e  s ret=DeptID_"_"_desc_"_"_UserGroupID_"_"
	}
    q ret
}

Query GetLocList() As %Query(ROWSPEC = "code,desc,typ,wardid")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, userid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	   s rw=""  f  s rw=$O(^CTLOC(rw)) q:rw=""  d
	   .s code=$P(^CTLOC(rw),"^",1)
	   .s desc=$P(^CTLOC(rw),"^",2)
	   .s typ=$P(^CTLOC(rw),"^",13)
	   .q:typ'="W"
       .s wardid=$O(^PAWARD(0,"WARD_LocationDR",rw,""),-1)
       .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(code,desc,typ,wardid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
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

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getlocdata()
{
 //科室病区 w ##class(web.DHCNURActiveSync).getlocdata()
	   s rw=""  f  s rw=$O(^CTLOC(rw)) q:rw=""  d
	   .s code=$P(^CTLOC(rw),"^",1)
	   .s desc=$P(^CTLOC(rw),"^",2)
	   .s typ=$P(^CTLOC(rw),"^",13) 
	   .q:typ'="W"
       .s wardid=$O(^PAWARD(0,"WARD_LocationDR",rw,""),-1)
       .w !,wardid
}

Query GetPacbedList(ward As %String) As %Query(ROWSPEC = "ward,bedid,bedname")
{
}

ClassMethod GetPacbedListExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	   s bed=""  f  s bed=$O(^PAWARD(ward,"BED",bed)) q:bed=""  d
	   .s bedname=$P(^PAWARD(ward,"BED",bed),"^")
	   .s bedid=ward_"||"_bed
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ward,bedid,bedname)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPacbedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPacbedListExecute ]
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

ClassMethod GetPacbedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPacbedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getpacbeddata(ward)
{
 //床位  w ##class(web.DHCNURActiveSync).getpacbeddata()
	   s bed=""  f  s bed=$O(^PAWARD(ward,"BED",bed)) q:bed=""  d
	   .s bedname=$P(^PAWARD(ward,"BED",bed),"^")
	   .w bedname
}

ClassMethod getmrcobcode() As %String
{
  //体征代码 w ##class(web.DHCNURActiveSync).getmrcobcode()
       s ret=""
	   s rw=""  f  s rw=$O(^MRC("OBITM",rw)) q:rw=""  d
	   .s code=$P(^MRC("OBITM",rw),"^",1)
	   .s desc=$P(^MRC("OBITM",rw),"^",2)
	   .s ret=ret_desc_"^"_code_"^"_rw_"|"
	  q ret
}

ClassMethod getpaadmdata(locOrWardId)
{
 //病人w ##class(web.DHCNURActiveSync).getpaadmdata(124)

             s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",locOrWardId,paroom)) q:paroom=""  d
            .s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",locOrWardId,paroom,EpisodeID)) q:EpisodeID=""  d
                ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ..i pavisit'="A" q
               ..s admno=$p($g(^PAADM(EpisodeID)),"^",81)
                ..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
                ..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
                ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ..s mradm=$P(^PAADM(EpisodeID),"^",61) 
                ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
			    ..s diag=..Diag(mradm,"PRE")
			    ..s ctlocId=$p(^PAADM(EpisodeID),"^",4)
				..s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
				..s doc=$p(^PAADM(EpisodeID),"^",9)
				..if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
				..S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
			    ..s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
			    ..s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
			    ..s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
			    ..s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
			    ..s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
			    ..i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
			    ..i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
			    ..e  s bedCode=""
			    ..s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
			    ..s age=..CalAge(birth,+$h)
			    ..s age=$p(age,"Y",1)
				..s AdmDate=$ZD($p($g(^PAADM(EpisodeID)),"^",6),3)
				..s total=##class(web.UDHCJFCKD).totalamount(EpisodeID)
                ..s depos=##class(web.UDHCJFCKD).deposit(EpisodeID)
				..w patName,diag
}

ClassMethod Diag(mradm, typ)
{
 //web.DHCMGNurComm^GetPat^^S0|PATNAME@S1|AGE@S2|SEX@S3|DIAG@S4|LOC
         s i=0
         s diag=""
         f a2=1:1:$g(^MR(mradm,"DIA",0)) d
         .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
         .i icdr'="" d
         ..s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
         ..i diatypedr'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
         ..e  s diatype=""
         ..q:diatype'=typ
         ..s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
         ..s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
         ..//i statusdr'="" d
         ..//.s status=$P($g(^MRC("DSTAT",statusdr)),"^",2)
         ..//.e  d
         ..//..s status=""
         ..s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
         ..s mrdesc=""
         ..f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
         ...s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
         ..s i=i+1
         ..s diag=icdcode_" "_$g(mrdesc)
         ..
         .   
         q diag
}

ClassMethod PatInfo(curId) As %String
{
	//病人基本信息;入参:登记号或OEORI_ROWID,根据最后一个ADM取信息
   // n (curId)
    s admId=curId
    s papmiId=+^PAADM(admId)
    s mradm=$p(^PAADM(admId),"^",61)
    s diag=..Diag(mradm,"PRE")
    s ctlocId=$p(^PAADM(admId),"^",4)
	s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
	s doc=$p(^PAADM(admId),"^",9)
	if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
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
    s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)
	//e  s diag=""
	s AdmDate=$ZD($p($g(^PAADM(EpisodeID)),"^",6),3)

    //ctlocDesc未取后半部分 ypz 060522
    s retStr="^Telephone@"_homeTel_"^PatAddress@"_homeAddres_"^BirthDate@"_$ZD(birth,3)_"^BirthDate@"_$ZD(birth,3)_"^AdmDate@"_AdmDate_"^REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo
    q retStr
}

ClassMethod GetPatInfo(EpisodeId) As %String
{
 //##class(web.DHCMGNurComm).GetPatInfo
  s ret=..PatInfo(EpisodeId)
  s ret=$TR(ret,"@","|")
  q ret
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$g(IBirth) ""
    s XBirth=$zd(IBirth)
    s XToday=$zd(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $p(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

ClassMethod GetUserWardId(userId)
{
 ///获得用户病区
  //	n (userId)
  	s loc=$p(^SSU("SSUSR",userId),"^",4)
  	s warddes=$p(^CTLOC(loc),"^",2)
  	s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  	s ctcpt=$p(^SSU("SSUSR",userId),"^",14)
  	i $g(ctcpt)'="" s typid=$p(^CTPCP(ctcpt,1),"^",4)
  	i $g(typid)'="" s typdes=$p($g(^CT("CPT",typid)),"^",4)
  	i ($g(typdes)="NURSE") q warddes_"^"_wardid
  	q ""
}

ClassMethod getblankOld(adm) As %String
{
  //w ##class(web.DHCPdaNurActiveSync).getblank(124
	
	  s a=##class(Nur.DHCNurTempSet).GetSetID("TempChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)

	  s temp=$G(tmp("YTemp"))  //体温与
	  s wultemp=$G(tmp("WlTemp"))   //物理降温
	  s blankitm=$G(tmp("BlankCode"))
	  s StrDate=$P($H,",")
	  s HP=""
	  k tmp
	  s l=$L(blankitm,",")
	  for i=1:1:l
	  {
	    s itm=$P(blankitm,",",i)
	    s code=$P(itm,":",1)
	    s vcode=$P(itm,":",2)
	    b  ///s
	    s label=##class(User.DHCThreeBlankLabel).getlabel(adm,code,$ZD(StrDate,3))
	    q:label=""
	   // w !,label
	    b ////
	    //s ^TMP("code",RowId,code)=$LB(RowId,code,StrDate,label)
	    s tmp(code)=label_":"_vcode
	   // s Blank(code)=""
	  }
	  s ret=""
	  s code=""  f  s code=$O(tmp(code)) q:code=""  d
	  .s ret=ret_code_"|"_tmp(code)_"^"
	  b
	 q ret
}

ClassMethod getblank(adm, Sdate) As %String
{
  //w ##class(web.DHCPdaNurActiveSync).getblank(124
	
	  s a=##class(Nur.DHCNurTempSet).GetSetID("TempChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)

	  s temp=$G(tmp("YTemp"))  //体温与
	  s wultemp=$G(tmp("WlTemp"))   //物理降温
	  s blankitm=$G(tmp("BlankCode"))
	  //s StrDate=$P($H,",")
	  s HP=""
	  k tmp
	  s l=$L(blankitm,",")
	  for i=1:1:l
	  {
	    s itm=$P(blankitm,",",i)
	    s code=$P(itm,":",1)
	    s vcode=$P(itm,":",2)
	    b  ///s
	    s label=##class(User.DHCThreeBlankLabel).getlabel(adm,code,Sdate)
	    q:label=""
	   // w !,label
	    b ////
	    //s ^TMP("code",RowId,code)=$LB(RowId,code,StrDate,label)
	    s tmp(code)=label_":"_vcode
	   // s Blank(code)=""
	  }
	  s ret=""
	  s code=""  f  s code=$O(tmp(code)) q:code=""  d
	  .s ret=ret_code_"|"_tmp(code)_"^"
	  b
	 q ret
}

Query GetPatList(ward As %String) As %Query(ROWSPEC = "WardId,EpisodeID,regNo,bedCode,patName,sex,age,diag,wardDesc,ctlocDesc,DocDes,homeAddres,homeTel,workTel,handtel,AdmDate,total,depos,tempnum,bpnum")
{
}

ClassMethod GetPatListExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	if $G(loc)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s TMP="",ITM="",tmptyp="",TMBP=""
	d ..getmeasurepat(loc,TMP,ITM,$ZD(+$H,3))  //需测体温
	s adm=""  f  s adm=$O(TMP("Adm",adm)) q:adm=""  d
    .q:$G(TMP("Adm",adm))=""
    .s tmptyp(TMP("Adm",adm),adm)=""
     ///b  ///ssss
	s WardId=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
	d ..getBPNum(WardId,+$H,TMBP)
    if $G(WardId)="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	         s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",WardId,paroom)) q:paroom=""  d
            .s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardId,paroom,EpisodeID)) q:EpisodeID=""  d
                ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ..i pavisit'="A" q
                ..s admno=$p($g(^PAADM(EpisodeID)),"^",81)
                ..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
                ..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
                ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ..s mradm=$P(^PAADM(EpisodeID),"^",61) 
                ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
			    ..s diag=..Diag(mradm,"PRE")
			    ..s ctlocId=$p(^PAADM(EpisodeID),"^",4)
				..s ctlocDesc=$p(^CTLOC(+ctlocId),"^",2)	
				..s doc=$p(^PAADM(EpisodeID),"^",9)
				..if doc'="" s DocDes=$P($G(^CTPCP(doc,1)),"^",2)
				..S homeAddres=$g(^PAPER(papmiId,"PER","ADD")) // 住址
			    ..s homeTel=$p($g(^PAPER(papmiId,"PER",1)),"^",11)  //家庭电话
			    ..s workTel=$p($g(^PAPER(papmiId,"PER",1)),"^",9)   //工作电话
			    ..s handtel=$p($g(^PAPER(papmiId,"PER",4)),"^",21)  //手机
			    ..s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
			    ..s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)  
			    ..i curWardId'="" s wardDesc=$p(^PAWARD(curWardId),"^",1)
			    ..i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
			    ..e  s bedCode=""
			    ..s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
			    ..s age=..CalAge(birth,+$h)
			    ..s age=$p(age,"Y",1)
				..s AdmDate=$ZD($p($g(^PAADM(EpisodeID)),"^",6),3)
				..s total=##class(web.UDHCJFCKD).totalamount(EpisodeID)
                ..s depos=##class(web.UDHCJFCKD).deposit(EpisodeID)
                ..s tempnum=..gettempnum(EpisodeID,.tmptyp,ITM)
                ..//s bpnum=0 //需测血压
                ..s bpnum=$G(TMBP(EpisodeID)) //需测血压
                ..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(loc,EpisodeID,regNo,bedCode,patName,sex,age,diag,wardDesc,ctlocDesc,DocDes,homeAddres,homeTel,workTel,handtel,AdmDate,total,depos,tempnum,bpnum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod gettempnum(adm, tmptyp, ITM) As %String
{
  //需测体温次数
   		   s num=0
   		   s typ=""  f  s typ=$O(tmptyp(typ)) q:typ=""  d
		   .if $D(tmptyp(typ,adm)) d
		   ..s str=ITM(typ)
		   ..s tims=$P(str,"|")
		   ..s num=$L(tims,",")
   q num
}

ClassMethod GetPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatListExecute ]
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

ClassMethod GetPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getBPNum(Ward, curdate, TMP) As %String
{

 	      s room=""
          f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       .s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ..s VistStatus=$P(^PAADM(RowId),"^",20)
	       ..q:VistStatus'="A"
		   ..s Oew=$O(^OEORD(0,"Adm",RowId,""))
		   ..q:Oew=""
		   ..s timstr="" ,phcfrCode="",ArcimName="",phcfrstr="",phcfactor=""
		   ..s OrdSub="" f  s OrdSub=$O(^OEORDi(0,"StDt",curdate,Oew,OrdSub)) q:(OrdSub="")  d
		   ...s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13)  ; OEC_OrderStatus             OEORI_ItemStat_DR 
		   ...s OrdStat=""
		   ...i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
		   ...q:OrdStat="D"
		   ...s ArcimName=##class(web.DHCNurNeedMeasureTempPat).getarcimname(Oew,OrdSub)
		   ...s phcfrId=$p($g(^OEORD(Oew,"I",OrdSub,2)),"^",4)
		   ...q:phcfrId=""
	       ...s phcfrCode=$p($g(^PHCFR(phcfrId)),"^",3)
	       ...s phcfactor=$p($g(^PHCFR(phcfrId)),"^",2)
		   ...i (ArcimName["测血压")||(ArcimName["测生命体征") d
		   ....s TMP(RowId)=phcfactor
   q 0
}

}
