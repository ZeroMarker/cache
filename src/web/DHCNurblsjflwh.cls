Class web.DHCNurblsjflwh Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getdata() As %String
{
   s ret="" 
   s id="" f  s id=$O(^User.DHCNurblsjflwhD(id)) q:id=""  d
 	.s a=##class(User.DHCNurblsjflwh).%OpenId(id)
 	.s des=a.Desc1
	.s ret=ret_des_"|"_des_"!"
	.//b
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

ClassMethod getnurinfo(Adm As %String) As %String
{
	s ret=""
	s Papmidr=$P(^PAADM(Adm),"^",1)
	s ctlocdr=$P(^PAADM(Adm),"^",4)
	i ctlocdr'=""  s ctlocdr=$p($p(^CTLOC(ctlocdr),"^",2),"-",2)
	s AdmDate=$ZD($P(^PAADM(Adm),"^",6),3)_" "_$ZT($P(^PAADM(Adm),"^",7))
	s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=..CalAge(birth,+$h)
    s age=$p(age,"Y",1)
    s year=$p(age,"Y",1)
    i (year<2)  d
    .s month=$p($p(age,"Y",2),"M",1)
    .s day=$p($p(age,"M",2),"D",1)
    .s month=$tr(month," ","")
    .s day=$tr(day," ","")
    .i (month>0) s age=year*12+month_"月"
    .i (year=0)&(month=0) s age=day_"天"
    e  s age=year
    s ret=ctlocdr_"#"_Name_"#"_sex_"#"_age
    q ret
}

// d ##class(web.DHCNurblsjflwh).getpf("DHCNURHTPFB^2407")

ClassMethod MoudDatabyadmExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr=^TMP("parr")
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	//s stdate=$ZDH($P(parr,"^",4),3)
 	//s eddate=$ZDH($P(parr,"^",5),3)
 	s IfCncelRec=$p(parr,"^",6)
 	s patinfostr=""
 	i EpisodeId'="" s patinfostr=##class("web.DHCMGNurComm").GetPatInfo(EpisodeId)
 	s ii=0        
 	 	s p="" f  s p=$O(^Nur.DHCMoudDataI("EmrCode"," "_code," "_EpisodeId,p)) q:p=""  d
	    .s a=##class(Nur.DHCMoudData).%OpenId(p)
	    .s sta=a.Status
	    .q:(IfCncelRec="false")&(sta="C")
	    .q:(IfCncelRec="true")&(sta'="C")
	 	.s ret=..getValPGD(p)
	 	.s canceldate="",canceltime="",canceluser=""
	 	.i (IfCncelRec="true") d
	 	..s canceldate=a.RecCancelDate
	 	..i canceldate'="" s canceldate=##class(websys.Conversions).DateLogicalToHtml(canceldate)
	 	..s canceltime=a.RecCancelTime
	 	..i canceltime'="" s canceltime=$E($ZT(canceltime),1,5)
	 	..s canceluser=a.RecCancelUser
	 	..i canceluser'="" s canceluser=$p(^SSU("SSUSR",canceluser),"^",2)
	 	.i (IfCncelRec="true")&&(code="DHCNURANHUI24") d
	 	..s ret=ret_"^Item41|"_canceldate_" "_canceltime_" "_canceluser_"作废"
	 	.i (IfCncelRec="true")&&(code="DHCNURXHFFYC") d
	 	..s ret=ret_"^Item31|"_canceldate_" "_canceltime_" "_canceluser_"作废"
	 	.i (IfCncelRec="true")&&(code="DHCNURXHFFDD") d
	 	..s ret=ret_"^Item31|"_canceldate_" "_canceltime_" "_canceluser_"作废"
	 	.i (IfCncelRec="true")&&(code="DHCNURANHUI21") d
	 	..s ret=ret_"^Item42|"_canceldate_" "_canceltime_" "_canceluser_"作废"
	 	.if p="RecAuditUser"  d
	 	..s ret=$P(^SSU("SSUSR",ret),"^")
	 	.s ii=ii+1
	 	.s ret=ret_"^par|"_p_"^Seqno|"_ii_"^"_patinfostr
	 	
		.d outtyp2
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDatabyadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDatabyadmExecute ]
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

Query MoudDatabyadm(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDatabyadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDatabyadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(Nur.DHCMoudData).getVal("50")

ClassMethod getValPGD(id)
{
 	s ret=""
	b
	if id'=""
	{
	s a=##class(Nur.DHCMoudData).%OpenId(id)
	
	s tmp("AnaesId")=a.AnaesId
	s tmp("EpisodeId")=a.EpisodeId
	s tmp("EmrDate")=$ZD(a.EmrDate,3)
	s tmp("EmrTime")=$ZT(a.EmrTime)
	s tmp("EmrUser")=a.EmrUser
	s tmp("EmrCode")=a.EmrCode
	
	f i=1:1:300 
	{
		s itm="Item"_i  

		s tmp(itm)= $ZOBJPROPERTY(a,itm)
	}
	i (tmp("EmrCode")="DHCNURXHFFDD") d //防范跌倒
	.i tmp("Item6")'=""  d //入院日期
	..s date=$zdh(tmp("Item6"),3)
	..s tmp("Item6")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item7")'=""  d //出院日期
	..s date=$zdh(tmp("Item7"),3)
	..s tmp("Item7")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item12")'=""  d //评估日期1
	..s date=$zdh(tmp("Item12"),3)
	..s tmp("Item12")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item13")'=""  d //评估日期2
	..s date=$zdh(tmp("Item13"),3)
	..s tmp("Item13")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item14")'=""  d //评估日期3
	..s date=$zdh(tmp("Item14"),3)
	..s tmp("Item14")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item68")'=""  d //评估日期4
	..s date=$zdh(tmp("Item68"),3)
	..s tmp("Item68")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item69")'=""  d //评估日期5
	..s date=$zdh(tmp("Item69"),3)
	..s tmp("Item69")=##class(websys.Conversions).DateLogicalToHtml(date)
	i (tmp("EmrCode")="DHCNURXHFFYC") d //防范压疮
	.i tmp("Item6")'=""  d //入院日期
	..s date=$zdh(tmp("Item6"),3)
	..s tmp("Item6")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item7")'=""  d //出院日期
	..s date=$zdh(tmp("Item7"),3)
	..s tmp("Item7")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item12")'=""  d //评估日期1
	..s date=$zdh(tmp("Item12"),3)
	..s tmp("Item12")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item13")'=""  d //评估日期2
	..s date=$zdh(tmp("Item13"),3)
	..s tmp("Item13")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item14")'=""  d //评估日期3
	..s date=$zdh(tmp("Item14"),3)
	..s tmp("Item14")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item9")'=""  d //转入日期
	..s date=$zdh(tmp("Item9"),3)
	..s tmp("Item9")=##class(websys.Conversions).DateLogicalToHtml(date)
	
    i (tmp("EmrCode")="DHCNURANHUI21") d //四评单
	.i tmp("Item41")'=""  d //评价日期
	..s date=$zdh(tmp("Item41"),3)
	..s tmp("Item41")=##class(websys.Conversions).DateLogicalToHtml(date)
	.i tmp("Item42")'=""  d //评价护士
	..i tmp("Item42")["!" s tmp("Item42")=$p(tmp("Item42"),"!",2)
	..e  d
	...i $d(^SSU("SSUSR",tmp("Item42"))) s tmp("Item42")=$p(^SSU("SSUSR",tmp("Item42")),"^",2)
	
	i (tmp("EmrCode")="DHCNURANHUI24") d //儿科四评单
	.i tmp("Item41")'=""  d //评价护士
	..i tmp("Item41")["!" s tmp("Item41")=$p(tmp("Item41"),"!",2)
	..e  d
	..i $d(^SSU("SSUSR",tmp("Item41"))) s tmp("Item41")=$p(^SSU("SSUSR",tmp("Item41")),"^",2)
	.i tmp("Item40")'=""  d //评价日期
	..s date=$zdh(tmp("Item40"),3)
	..s tmp("Item40")=##class(websys.Conversions).DateLogicalToHtml(date)
   
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod NurseDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	//s stdate=$ZDH($P(parr,"^",4),3)
 	//s eddate=$ZDH($P(parr,"^",5),3)
 	s stdate=$P(parr,"^",4)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",5)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	b ;
 	for date=stdate:1:eddate
 	{
 	 	s p="" f  s p=$O(^Nur.DHCNurseDataI("emdate",date," "_code,p)) q:p=""  d
	    .s a=##class(Nur.DHCNurseData).%OpenId(p)
	    .s EmrLoc=a.EmrLoc
	    .q:EmrLoc'=Loc
	 	.s ret=##class(Nur.DHCNurseData).getVal(p)
	 	.s ret=ret_"^par|"_p
		.d outtyp2
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NurseDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NurseDataExecute ]
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

Query NurseData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod NurseDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NurseDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getpf(adm As %String) As %String
{
 
 	s code="DHCNURHTPFB"
 	s EpisodeId=adm
 	s Item7=""
 	s ret=""
    s rw=""
    s rw=$O(^Nur.DHCNurSBDataI("EmrCode"," "_code," "_EpisodeId,rw)) 
    if rw'="" d
    .s a=##class(Nur.DHCNurSBDataSub).%OpenId(rw_"||"_"1")
    .q:a=""
    .s Item7=a.Item7
    .s ret=Item7
    q ret
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","CRItem","parr$111")

ClassMethod CRItemExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s id="" f  s id=$O(^User.DHCNurblsjflwhD(id)) q:id=""  d
 	.s a=##class(User.DHCNurblsjflwh).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=..getVal(rw)
	.s ret=ret_"^rw|"_id
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CRItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CRItemExecute ]
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

Query CRItem(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod CRItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CRItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetpatypExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret="code|"_1_"^Desc|转出^"_"^rw|转出"
	d out1
	s ret="code|"_2_"^Desc|愈合^"_"^rw|愈合"
	d out1
	s ret="code|"_3_"^Desc|死亡^"_"^rw|死亡"
	d out1
	s ret="code|"_4_"^Desc|出院^"_"^rw|出院"
	d out1
	s ret="code|"_5_"^Desc|未愈合^"_"^rw|未愈合"
	d out1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out1
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetpatypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetpatypExecute ]
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

ClassMethod GetpatypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetpatypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","Getpatyp","")

Query Getpatyp(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetsourceExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret="code|"_3_"^Desc|院内发生^"_"^rw|院内发生"
	d out11
	s ret="code|"_4_"^Desc|院外带来^"_"^rw|院外带来"
	d out11

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out11
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetsourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetsourceExecute ]
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

ClassMethod GetsourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetsourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","Getpatyp","")

Query Getsource(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetfjExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ret="code|"_1_"^Desc|可疑深部组织损伤^"_"^rw|可疑深部组织损伤"
	d out111
	s ret="code|"_2_"^Desc|Ⅰ局部红肿发硬^"_"^rw|Ⅰ局部红肿发硬"
 
	d out111
	s ret="code|"_3_"^Desc|Ⅱ不规则的表皮破溃，限于表皮及真皮层^"_"^rw|Ⅱ不规则的表皮破溃，限于表皮及真皮层"
 
	d out111
	s ret="code|"_4_"^Desc|Ⅲ皮肤变厚溃烂，并延伸至皮下脂肪组织^"_"^rw|Ⅲ皮肤变厚溃烂，并延伸至皮下脂肪组织"
 	
	d out111
	s ret="code|"_5_"^Desc|Ⅳ深部组织坏死呈溃疡，延伸至肌肉层^"_"^rw|Ⅳ深部组织坏死呈溃疡，延伸至肌肉层"
    d out111
	s ret="code|"_5_"^Desc|Ⅴ深部组织坏死呈溃疡已延伸至骨骼、关节结构^"_"^rw|Ⅴ深部组织坏死呈溃疡已延伸至骨骼、关节结构"
    d out111
	s ret="code|"_5_"^Desc|不能分期^"_"^rw|不能分期"
 
	d out111

 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
out111
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetfjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetfjExecute ]
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

ClassMethod GetfjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetfjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","Getpatyp","")

Query Getfj(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod getlocdesc(id As %String) As %String
{
	q:id=""
	s ret=$P(^CTLOC(id),"^",2)
	q ret
}

ClassMethod GetWardExecute(ByRef qHandle As %Binary, typ As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	s rw=""
	f {
      s rw=$O(^CTLOC(rw))
      q:rw=""
      s desc=$P(^CTLOC(rw),"^",2)
      i desc["停用"  continue
      s ret="^rw|"_rw_"^Desc|"_desc
      d outtyp2

	 }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardExecute ]
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

Query GetWard(typ As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getVal(id) As %String
{
	s ret=""
	if id'=""
	{
	s a=##class(User.DHCNurblsjflwh).%OpenId(id)	
	s tmp("Code")=a.Code
	s tmp("Desc")=a.Desc1	
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod Save(parr As %String, id As %String) As %String
{
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	if id=""
	{
	 s a=##class(User.DHCNurblsjflwh).%New()
	}else
	{
	 s a=##class(User.DHCNurblsjflwh).%OpenId(id)
	}
	if $D(tmp("Code")) s a.Code=tmp("Code")
	if $D(tmp("Desc")) s a.Desc1=tmp("Desc")
	s a.RECDate=$p($h,",",1)
	s a.RECTime=$p($h,",",2)
	s a.UserREC=%session.Get("LOGON.USERNAME")
	d a.%Save()
	q 0
}

ClassMethod QtDelete(id As %String) As %String
{
  
   s a=##class(User.DHCNurblsjflwh).%DeleteId(id)
	q 0
}

// d ##class(web.DHCNurblsjflwh).getdiedaoyc(DHCNURykdPFYC^10833)

ClassMethod getdiedaoyc(parr As %String) As %String
{
	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Item20=""
 	s Item33=""
 	s ret=""
    s rw=""
    s rw=$O(^Nur.DHCNurSBDataI("EmrCode"," "_code," "_EpisodeId,rw))  
    if rw'="" d
    .s a=##class(Nur.DHCNurSBData).%OpenId(rw)
    .s Item20=a.Item20
    .s Item33=a.Item33
    .s ret=Item20_"^"_Item33
    .b ;1
    q ret
}

ClassMethod GetAllPatientExecute(ByRef qHandle As %Binary, Parr As %String) As %Status
{
	      Set repid=$I(^CacheTemp)
 	      s ind=1
 	      s Ward=$p(Parr,"^")
 	      s RegNo=$p(Parr,"^",2)
 	      s StrDate=$p(Parr,"^",3)
 	      s StrTime=$p(Parr,"^",4)
 	      s BabyFlag=$p(Parr,"^",5)
 	      //按就诊ID只查询出院病人
 	      i RegNo'="" d
 	      .s admVisitStat=$p($g(^PAADM(RegNo)),"^",20)
		  .i admVisitStat'="D" s RegNo=""
		  
		  s wardFlag=$P($g(^CTLOC(Ward)),"^",13)
		  i wardFlag="W" s Ward=..getlocward(Ward)
		  s pf=""
	      if (Ward'="")&&(RegNo="")
	      {
		   i wardFlag="W"  d
	       .s room="" 
	       .f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	       ..s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	       ...s VistStatus=$P(^PAADM(RowId),"^",20)
	       ...q:VistStatus="D"
	       ...s pinfo=..Patinfo(RowId)
	       ...q:pinfo=""
     	   ...s Name=$P(pinfo,"#",2)
           ...s Bed=$P(pinfo,"#",3)
           ...s left=$P(pinfo,"#",6)
           ...s top=$P(pinfo,"#",7)
           ...s Adm=RowId
           ...s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ...q:(MotherAdm="")&(BabyFlag="1")
    	   ...q:(MotherAdm'="")&(BabyFlag'="1")
           ...s PatRegNo=$P(pinfo,"#",8)
           ...i (left="")!(top="") s DataOther(RowId)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
           ...e  s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
      	   .s r="" f  s r=$O(Data(r)) q:r=""  d
           ..s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ...s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ...s aa=..getobjval(Adm,StrDate,StrTime)
           ...S pf=..getpf(Adm)
	       ...s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^pf|"_pf_"^"_aa
           ...d OutPat
           .s r="" f  s r=$O(DataOther(r)) q:r=""  d
           ..s Adm=$P(DataOther(r),"^",1),Name=$P(DataOther(r),"^",2),Bed=$P(DataOther(r),"^",3),PatRegNo=$P(DataOther(r),"^",4)
           ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aa
           ..d OutPat
           e  d
           .s admDate=""
		   .f  s admDate=$O(^PAADMi("CurrLoc",Ward,admDate)) q:admDate=""  d
		   ..s admTime="" f  s admTime=$O(^PAADMi("CurrLoc",Ward,admDate,admTime)) q:admTime=""  d
           ...s RowId="" f  s RowId=$O(^PAADMi("CurrLoc",Ward,admDate,admTime,RowId)) q:RowId=""  d
           ....s VistStatus=$P(^PAADM(RowId),"^",20)
	       ....q:(VistStatus="D")
	       ....s pinfo=..Patinfo(RowId)
	       ....q:pinfo=""
     	   ....s Name=$P(pinfo,"#",2)
           ....s Bed=$P(pinfo,"#",3)
           ....s left=$P(pinfo,"#",6)
           ....s top=$P(pinfo,"#",7)
           ....s Adm=RowId
           ....s MotherAdm=$p($g(^PAADM(Adm)),"^",75)
    	   ....q:(MotherAdm="")&(BabyFlag="1")
    	   ....q:(MotherAdm'="")&(BabyFlag'="1")
           ....s PatRegNo=$P(pinfo,"#",8)
           ....s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
           ....i (left="")!(top="") s DataOther(RowId)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
           ....e  s Data(top,left)=Adm_"^"_Name_"^"_Bed_"^"_PatRegNo
	     
      	   .s r="" f  s r=$O(Data(r)) q:r=""  d
           ..s c=""  f  s c=$O(Data(r,c)) q:c=""  d
           ...s Adm=$P(Data(r,c),"^",1),Name=$P(Data(r,c),"^",2),Bed=$P(Data(r,c),"^",3),PatRegNo=$P(Data(r,c),"^",4)
           ...s aa=..getobjval(Adm,StrDate,StrTime)
            ...S pf=..getpf(Adm)
	       ...s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^pf|"_pf_"^"_aa
           ...d OutPat
           
           .s r="" f  s r=$O(DataOther(r)) q:r=""  d
           ..s Adm=$P(DataOther(r),"^",1),Name=$P(DataOther(r),"^",2),Bed=$P(DataOther(r),"^",3),PatRegNo=$P(DataOther(r),"^",4)
           ..s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_PatRegNo_"^"_aa
           ..d OutPat
	      }
	      if (RegNo'="")
	      {        s RowId=RegNo
		           s pinfo=..DischargePatinfo(RowId)
		           b ;05
	               q:pinfo=""
	               s Reg=$P(pinfo,"#",8)
	               s Name=$P(pinfo,"#",2)
	               s Bed=$P(pinfo,"#",3)
	               s Adm=RowId
	               s aa=..getobjval(Adm,StrDate,StrTime)
	               S pf=..getpf(Adm)
	               s aa="Adm|"_Adm_"^PatName|"_Name_"^BedCode|"_Bed_"^RegNo|"_Reg_"^pf|"_pf_"^"_aa
	               d OutPat

		  }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPat
	set Data=$lb(aa)
	s ^pjf($i(^pjf))=aa
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod GetAllPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllPatientExecute ]
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

ClassMethod GetAllPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getobjval(RowId, StrDate, StrTime) As %String
{
	  s a=##class(Nur.DHCNurTempSet).GetSetID("TempChart")
      s tmp=""
      s ret=##class(Nur.DHCNurTempSet).getVal(a)
      s aa=##class(web.DHCMGNurComm).settmp(ret,.tmp)
	  s temp=tmp("YTemp")  //体温与
	  s wultemp=tmp("WlTemp")   //物理降温
	  s blankitm=tmp("BlankCode")
	  s HP=""
	  s l=$L(blankitm,",")
	  for i=1:1:l
	  {
	    s itm=$P(blankitm,",",i)
	    s code=$P(itm,":",1)
	    s label=##class(User.DHCThreeBlankLabel).getlabel(RowId,code,StrDate)
	    s tmp(code)=label
	    s Blank(code)=""
	  }
	  s StrDate=$ZDH(StrDate,3)
	  s StrTime=$ZTH(StrTime,3)  
	  s MRADMROWId=$P(^PAADM(RowId),"^",61)    
	  s itmdr=""  f  s itmdr=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr)) q:itmdr=""  d
	  .b
	  .s chl=""  f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,itmdr,chl)) q:chl=""  d
	  ..s time=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
	  ..if time=StrTime d
	  ...s P1=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
	  ...s Desc=$P(^MR(MRADMROWId,"OBS",chl),"^",6)
	  ...s itmcode=$p($G(^MRC("OBITM",itmdr)),"^",1)
	  ...q:itmcode=""
	  ...q:$D(Blank(itmcode)) //如果空白栏已有值
	  ...s tmp(itmcode)=P1
	  ...if (Desc'="" )&(itmcode=temp) s tmp(wultemp)=Desc
	  s ret=""
	   s k=""  
	  	f {
		   s k=$O(tmp(k))
		   q:k=""  
		   s ret=ret_k_"|"_tmp(k)_"^"
	  	  }

	  q ret
}

ClassMethod Patinfo(Adm As %String) As %String
{
           s CurrentBedDR=$P(^PAADM(Adm),"^",73)
	       q:CurrentBedDR="" ""
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s bedchl=$P(CurrentBedDR,"||",2)
	       s Ward=$P(CurrentBedDR,"||",1)
	       s wardloc=$P(^PAWARD(Ward),"^",5) 
	       s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s adm(Bed)=Adm_"#"_Name_"#"_Bed_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_pstop_"#"_psleft_"#"_RegNo
         q adm(Bed)
}

ClassMethod DischargePatinfo(Adm As %String) As %String
{
	       s Papmidr=$P(^PAADM(Adm),"^",1)
	       s Name=$P(^PAPER(Papmidr,"ALL"),"^",1)
	       s RegNo=$P(^PAPER(Papmidr,"PAT",1),"^",1)
	       s ctlocdr=$P(^PAADM(Adm),"^",4)
	       s CurrentBedDR=$P(^PAADM(Adm),"^",73)
	       i CurrentBedDR'="" d
	       .s Ward=$P(CurrentBedDR,"||",1)
	       .s bedchl=$P(CurrentBedDR,"||",2)
	       .s wardloc=$P(^PAWARD(Ward),"^",5) //s name="F",cttypdes="NURSE"
	       .s Bed=$P(^PAWARD(Ward,"BED",bedchl),"^",1)
	       .s pstop=$P(^PAWARD(Ward,"BED",bedchl),"^",15)
	       .s psleft=$P(^PAWARD(Ward,"BED",bedchl),"^",16)
	       s aa=Adm_"#"_Name_"#"_$g(Bed)_"#"_$G(ctlocdr)_"#"_$G(wardloc)_"#"_$g(pstop)_"#"_$g(psleft)_"#"_RegNo
         q $g(aa)
}

Query GetAllPatient(Parr As %String) As %Query(ROWSPEC = "aa")
{
}

// 科护士长及病区护士长判断是否有要填写的数据

// d ##class(web.DHCNurblsjflwh).if7d("DHCNURXHSB_pf^30710^^2012-11-14^2012-11-15")

ClassMethod if7d(parr As %String) As %String
{
	//s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	s stdate=$ZDH($P(parr,"^",4),3)
 	s eddate=$ZDH($P(parr,"^",5),3)
 	k tempcyf
 	for date=stdate:1:eddate
 	{
 	 	s p="" f  s p=$O(^Nur.DHCNurSBDataI("emdate",date," "_code,p)) q:p=""  d
	    .s a=##class(Nur.DHCNurSBData).%OpenId(p)
	    .s Epi=a.EpisodeId
	    .q:EpisodeId'=Epi
	    .s Item39=a.EmrDate
	    .s Item3=a.Item3
	    .s Item1=a.Item1
	    .s update=Item39
	    .//s update=$zdh(Item39,3)
	    .s subdate=+$h-update
	    .i subdate>0  d
	    ..s la=$p(subdate/7,",",2)
	    ..i la="" s tempcyf(p)=Item1_"^"_Item3
 	}

 	s ret=""
 	s rw="" f  s rw=$o(tempcyf(rw)) q:rw=""  d
 	.i ret="" s ret=tempcyf(rw)
 	.e  s ret=ret_"|"_tempcyf(rw)
 	b ;99
 	q ret
}

// d ##class(web.DHCNurblsjflwh).AuditSetStatus("6101^693^00506")

// 12^691^03562

ClassMethod AuditSetStatus(parr As %String) As %String
{
	//s ^objcyf242=parr
 	s par=$P(parr,"^",1)
 	s userid=$P(parr,"^",2)
 	s usercode=$P(parr,"^",3)
 	s Usertype=##class(Nur.DHCNURLocData).gettype(usercode)
    //s EmrDate=$zdh(EmrDate,3)
    q:par=""
    s a=##class(Nur.DHCNurSBData).%OpenId(par)
	s update=a.EmrDate
	s Status=a.Status
	s flag=0
	s flag1=0
	s flag2=0
	s flag3=0
	s flag4=0
	s fir=0
	s la=5
	s subdate=+$h-update
	i subdate>0  d
	.s la=$p(subdate/7,".",2)
	.i la="" s flag1=1
	.s fir=$p(subdate/7,".")
	i Usertype="科护士长" d
	.s Item46=a.Item46
	.i Item46="" s flag2=1
	i Usertype="" d
	.s Item41=a.Item41
	.s Item44=a.Item44
	.i (Item41="")&&(Item44="") s flag3=1
	i Usertype="护理部" d
	.s Item49=a.Item49
	.s Item53=a.Item53
	.i (Item49="")&&(Item53="") s flag4=1
	i (flag1=1)&&(flag2=1) s flag=1
	i (flag1=1)&&(flag3=1) s flag=1
	i (flag1=1)&&(flag4=1) s flag=1
	s ^odj11(par,flag,flag1,flag2,flag3,flag4)=Status_subdate_"%"_la_"%"_fir
	q:Status'="S1" flag
	i (subdate'<"0") d
	.s aa=##class(Nur.DHCNurSBData).SetStatus(par,"S2",userid) 
 	q flag
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","MoudData",^objcyf24)

// DHCNURykdGLHT^152^1^2012-04-07^2012-04-08"

// DHCNURykdPFYC^7003^414^2012-06-09^2012-06-10

ClassMethod MoudDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr=^TMP("parr")
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	//s stdate=$ZDH($P(parr,"^",4),3)
 	//s eddate=$ZDH($P(parr,"^",5),3)
 	s stdate=$P(parr,"^",4)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",5)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	s ifcancel=$P(parr,"^",6)
 	s ii=0
 	for date=stdate:1:eddate
 	{
        
 	 	s p="" f  s p=$O(^Nur.DHCNurSBDataI("emdate",date," "_code,p)) q:p=""  d
	 	.//s chl=""  f  s chl=$O(^Nur.DHCNurSBDataD(p,"ChildRec",chl)) q:chl=""  d
	    .s a=##class(Nur.DHCNurSBData).%OpenId(p)
	    .s Epi=a.EpisodeId
	    .s EmrLoc=a.EmrLoc
	    .s Status=a.Status
	    .q:(Status="C")&&(ifcancel="false")
	    .q:(Status'="C")&&(ifcancel="true")
	    .q:(EpisodeId'=Epi)&&(EpisodeId'="")&&(Epi'="1043562")
	    .//q:(Loc'=EmrLoc)&&(Loc'="")
	 	.s ret=..getVal2(p)
	 	.if p="RecAuditUser"  d
	 	..s ret=$P(^SSU("SSUSR",ret),"^")
	 	.s ii=ii+1
	 	.s ret=ret_"^par|"_p_"^Seqno|"_ii
		.d outtyp2
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDataExecute ]
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

Query MoudData(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(Nur.DHCNurSBData).getVal2("282")

ClassMethod getVal2(id)
{
 	s ret=""

	if id'=""
	{
	s a=##class(Nur.DHCNurSBData).%OpenId(id)
	if '$D(^tdata("Nur.DHCNurSBData")) d a.ListProperties()
	s tdata="",tmp=""
	s p="" f  s p=$O(^tdata("Nur.DHCNurSBData",p)) q:p=""  d
	.s tmp(p)=$ZOBJPROPERTY(a,p)
	if tmp("EmrDate")'=""  d
	.s tmp("EmrDate")=##class(websys.Conversions).DateLogicalToHtml(tmp("EmrDate"))
	if tmp("EmrTime")'=""  s tmp("EmrTime")=$ZT(tmp("EmrTime"),2)
	if tmp("EmrUser")'="" s tmp("usercode")=$P($g(^SSU("SSUSR",tmp("EmrUser"))),"^")
	if tmp("EmrUser")'="" s tmp("EmrUser")=$P(..getsuser(tmp("EmrUser")),"!",2)
	if (tmp("EmrCode")="DHCNURXHSB_pf") d         //压疮上报
	.s cmqk=a.Item26 //创面情况
	.s cmqkqt=a.Item27
	.i cmqk["其他" s tmp("Item26")=cmqk_":"_cmqkqt
	.s cmqk=a.Item29 //患者因素
	.s cmqkqt=a.Item33
	.i cmqk["其他" s tmp("Item29")=cmqk_":"_cmqkqt
	.s cmqk=a.Item30 //医疗因素
	.s cmqkqt=a.Item34
	.i cmqk["其他" s tmp("Item30")=cmqk_":"_cmqkqt
	.s cmqk=a.Item31 //护理人员因素
	.s cmqkqt=a.Item35
	.i cmqk["其他" s tmp("Item31")=cmqk_":"_cmqkqt
	.s cmqk=a.Item32 //其他因素
	.s cmqkqt=a.Item36
	.i cmqk["其他" s tmp("Item32")=cmqk_":"_cmqkqt
	.s cmqk=a.Item37 //已采取护理措施
	.s cmqkqt=a.Item59
	.i cmqk["其他" s tmp("Item37")=cmqk_":"_cmqkqt
	.s cmqk=a.Item21 //压疮部位
	.s cmqkqt=a.Item23
	.i cmqk["其他" s tmp("Item21")=cmqk_":"_cmqkqt
	.s cmqk=a.Item16 //患者状态
	.s cmqkqt=a.Item17
	.i cmqk["其他" s tmp("Item16")=cmqk_":"_cmqkqt
	.s cmqk=a.Item13 //科外带来
	.s cmqkqt=a.Item14
	.i cmqk["其他" s tmp("Item13")=cmqk_":"_cmqkqt
	.s cmqk=a.Item10 //院外带来
	.s cmqkqt=a.Item15
	.i cmqk["其他" s tmp("Item10")=cmqk_":"_cmqkqt
	.s cmqk=a.Item37 //采取措施
    .s l=$l(tmp("Item37"),";")
    .s Item61str=""
    .f i=1:1:l d
    ..s tempstr=$p(tmp("Item37"),";",i)
    ..s Item61str=Item61str_" "_i_". "_tempstr
    .s tmp("Item37")=Item61str
	if (tmp("EmrCode")="DHCNURXHSB_geiyao") d    //给药缺陷
	.s cmqk=a.Item12 //发生地点
	.s cmqkqt=a.Item18
	.i cmqk["其他" s tmp("Item12")=cmqk_":"_cmqkqt
	.s cmqk=a.Item25 //遗漏给药
	.s cmqkqt=a.Item26
	.i cmqk["其他" s tmp("Item25")=cmqk_":"_cmqkqt
	.s cmqk=a.Item27 //给药日期错误
	.s cmqkqt=a.Item28
	.i cmqk["其他" s tmp("Item27")=cmqk_":"_cmqkqt
	.s cmqk=a.Item36 //医嘱药名
	.s cmqkqt=a.Item39
	.i cmqk["其他" s tmp("Item36")=cmqk_":"_cmqkqt
	.s cmqk=a.Item38 //错误给药名称
	.s cmqkqt=a.Item65
	.i cmqk["其他" s tmp("Item38")=cmqk_":"_cmqkqt
	.s cmqk=a.Item61 //处理其他
	.s cmqkqt=a.Item69
	.i cmqk["其他" s tmp("Item61")=cmqk_":"_cmqkqt
	.s cmqk=a.Item66 //缺陷引起的后果
	.s cmqkqt=a.Item71
    .i cmqk["其他" s tmp("Item66")=cmqk_":"_cmqkqt
    .s cmqk=a.Item61 //处理
	.s Item62=a.Item62
	.s Item63=a.Item63
	.s Item64=a.Item64
    .i (cmqk["立即通知其他护理人员")!(cmqk["用药")!(cmqk["诊断性检查") d
    ..s l=$l(tmp("Item61"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item61"),";",i)
    ...i tempstr="立即通知其他护理人员"  s tempstr=tempstr_":"_Item62
    ...i tempstr="用药"  s tempstr=tempstr_" (药物名称:"_Item63_")"
    ...i tempstr="诊断性检查"  s tempstr=tempstr_" (具体名称:"_Item64_")"
    ...s Item61str=Item61str_" "_i_" "_tempstr
    ..s tmp("Item61")=Item61str
	if (tmp("EmrCode")="DHCNURXHSB_glhuatuo") d    //管路滑脱报告单
	.s cmqk=a.Item16 //导管类型
	.s cmqkqt=a.Item17
	.i cmqk["其他" s tmp("Item16")=cmqk_":"_cmqkqt
	.s cmqk=a.Item19 //精神状态
	.s cmqkqt=a.Item22
	.i cmqk["其他" s tmp("Item19")=cmqk_":"_cmqkqt
	.s cmqk=a.Item20 //活动能力
	.s cmqkqt=a.Item23
	.i cmqk["其他" s tmp("Item20")=cmqk_":"_cmqkqt
	.s cmqk=a.Item24 //脱管原因
	.s cmqkqt=a.Item25
	.i cmqk["其他" s tmp("Item24")=cmqk_":"_cmqkqt
	.s cmqk=a.Item26 //固定方法
	.s cmqkqt=a.Item27
	.i cmqk["其他" s tmp("Item26")=cmqk_":"_cmqkqt
	.s cmqk=a.Item38 //并发症
	.s cmqkqt=a.Item39
	.i cmqk["其他" s tmp("Item38")=cmqk_":"_cmqkqt
    .s cmqk=a.Item34 //处理
	.s Item35=a.Item35
	.s Item36=a.Item36
	.s Item37=a.Item37
    .i (cmqk["其他")!(cmqk["用药")!(cmqk["诊断性检查") d
    ..s l=$l(tmp("Item34"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item34"),";",i)
    ...i tempstr="其他"  s tempstr=tempstr_":"_Item37
    ...i tempstr="用药"  s tempstr=tempstr_" (药物名称:"_Item35_")"
    ...i tempstr="诊断性检查"  s tempstr=tempstr_" (具体名称:"_Item36_")"
    ...s Item61str=Item61str_" "_i_" "_tempstr
    ..s tmp("Item34")=Item61str
    .i tmp("Item10")'=""  d
    ..s val=$zdh(tmp("Item10"),3)
    ..s tmp("Item10")=##class(websys.Conversions).DateLogicalToHtml(val)
    .i tmp("Item12")'=""  d
    ..s val=$zdh(tmp("Item12"),3)
    ..s tmp("Item12")=##class(websys.Conversions).DateLogicalToHtml(val)
    if (tmp("EmrCode")="DHCNURXHSB_yiwsh") d    //意外伤害事件报告单
	.s cmqk=a.Item12 //发生地点
	.s cmqkqt=a.Item13
	.i cmqk["其他" s tmp("Item12")=cmqk_":"_cmqkqt
	.s cmqk=a.Item14 //发生前状态
	.s cmqkqt=a.Item15
	.i cmqk["其他" s tmp("Item14")=cmqk_":"_cmqkqt
	.s cmqk=a.Item16 //发生后状态
	.s cmqkqt=a.Item17
	.i cmqk["其他" s tmp("Item16")=cmqk_":"_cmqkqt
	.s cmqk=a.Item22 //跌倒坠落
	.s cmqkqt=a.Item23
	.i cmqk["其他" s tmp("Item22")=cmqk_":"_cmqkqt
	.s cmqk=a.Item29 //误吸
	.s cmqkqt=a.Item30
	.i cmqk["其他" s tmp("Item29")=cmqk_":"_cmqkqt
	.s cmqk=a.Item31 //约束意外
	.s cmqkqt=a.Item32
	.i cmqk["其他" s tmp("Item31")=cmqk_":"_cmqkqt
	.s cmqk=a.Item33 //其他其他
	.s cmqkqt=a.Item76
	.i cmqk["其他" s tmp("Item33")=cmqk_":"_cmqkqt
	.s cmqk=a.Item36 //患者住院天数
	.s cmqkqt=a.Item37
	.i cmqk["其他" s tmp("Item36")=cmqk_":"_cmqkqt
    .s cmqk=a.Item24 //治疗或措施异常
	.s Item25=a.Item25
	.s Item26=a.Item26
	.s Item27=a.Item27
	.s Item28=a.Item28
    .i (cmqk["其他")!(cmqk["医疗用物使用不当")!(cmqk["医疗仪器使用不当")!(cmqk["治疗措施程序或技术不当") d
    ..s l=$l(tmp("Item24"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item24"),";",i)
    ...i tempstr["医疗用物使用不当"  s tempstr=tempstr_":"_Item25
    ...i tempstr["医疗仪器使用不当"  s tempstr=tempstr_" ("_Item26_")"
    ...i tempstr["治疗措施程序或技术不当"  s tempstr=tempstr_" ("_Item27_")"
    ...i tempstr="其他"  s tempstr=tempstr_":"_Item28
    ...s Item61str=Item61str_" "_i_" "_tempstr
    ..s tmp("Item24")=Item61str
    
    .s cmqk=a.Item38 //意外事件处理经过
	.s Item40=a.Item40
	.s Item61=a.Item61
	.s Item62=a.Item62
	.s Item63=a.Item63
    .i (cmqk["立即通知")!(cmqk["医疗或护理措施")!(cmqk["其他") d
    ..s l=$l(tmp("Item38"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item38"),";",i)
    ...i tempstr="立即通知"  d
    ....s tempstr=tempstr_":"_Item40
    ....i Item61'="" s tempstr=tempstr_"("_Item61_")"
    ...i tempstr["医疗或护理措施"  s tempstr=tempstr_" ("_Item62_")"
    ...i tempstr="其他"  s tempstr=tempstr_":"_Item63
    ...s Item61str=Item61str_" "_i_" "_tempstr
    ..s tmp("Item38")=Item61str
    .s cmqk=a.Item64 //处理与建议
	.s Item65=a.Item65
	.s Item66=a.Item66
	.s Item67=a.Item67 //修订改进
	.s Item68=a.Item68
    .i (cmqk["发生原因")!(cmqk["防范措施")!(cmqk["修订改进") d
    ..s l=$l(tmp("Item64"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item64"),";",i)
    ...i tempstr="修订改进"  d
    ....s tempstr=tempstr_":"_Item67
    ....i Item68'="" s tempstr=tempstr_"("_Item68_")"
    ...i tempstr["医疗或护理措施"  s tempstr=tempstr_" ("_Item62_")"
    ...i tempstr="发生原因"  s tempstr=tempstr_":"_Item65
    ...i tempstr="防范措施"  s tempstr=tempstr_":"_Item66
    ...s Item61str=Item61str_" "_i_" "_tempstr
    ..s tmp("Item64")=Item61str
    .i tmp("Item10")'=""  d
    ..s val=$zdh(tmp("Item10"),3)
    ..s tmp("Item10")=##class(websys.Conversions).DateLogicalToHtml(val)
	if (tmp("EmrCode")="DHCNURXHSB_dulou") d    //堵漏报告单
	.s tmp("Item3")=tmp("Item32")
	.i tmp("Item10")'=""  d
    ..s val=$zdh(tmp("Item10"),3)
    ..s tmp("Item10")=##class(websys.Conversions).DateLogicalToHtml(val)
	if (tmp("EmrCode")="DHCNURXHSB_geiyao") d    //给药报告单
	.i tmp("Item10")'=""  d
    ..s val=$zdh(tmp("Item10"),3)
    ..s tmp("Item10")=##class(websys.Conversions).DateLogicalToHtml(val)
	if (tmp("EmrCode")="DHCNURXHSB_ssfy") d    //输液(血)反应报告单
	.s Item13=a.Item13 //时间
	.s Item14=a.Item14
	.s Item15=a.Item15
	.s Item16=a.Item16
	.s Item17=a.Item17
	.s tmp("Item3")=tmp("Item32")
	.//s tmp("Item13")="输液(血)时间："_Item13_"病人发生输液(血)反应，表现为："_Item14_"。护士通知值班医生,给予病人："_Item15_" 的对症处理，遵医嘱使用了"_Item16_"药物等治疗，病人转归："_Item17_"。"
	.s cmqk=a.Item21
	.s Item27=a.Item27
	.i (cmqk["病人自身原因")!(cmqk["其他")!(cmqk["输入液体引起")!(cmqk["输液(血)器引起") d
    ..s l=$l(tmp("Item21"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item21"),";",i)
    ...i tempstr="其他"  d
    ....s tempstr=tempstr_":"_Item27
    ...i i=1 s Item61str=i_". "_tempstr
    ...e  s Item61str=Item61str_" ；"_i_". "_tempstr
    ..s tmp("Item21")=Item61str
	.s cmqk=a.Item18 //科室处理措施
	.s Item19=a.Item19
	.s Item20=a.Item20
	.s Item26=a.Item26 //
    .i (cmqk["报告")!(cmqk["科内组织讨论")!(cmqk["其他") d
    ..s l=$l(tmp("Item18"),";")
    ..s Item61str=""
    ..f i=1:1:l d
    ...s tempstr=$p(tmp("Item18"),";",i)
    ...i tempstr="报告"  d
    ....s tempstr=tempstr_":"_Item19
    ....i Item20'="" s tempstr=tempstr_":"_Item20_";"
    ...i (tempstr="其他") s tempstr=tempstr_":"_Item26
    ...i i=1 s Item61str=i_". "_tempstr
    ...e  s Item61str=Item61str_" ；"_i_". "_tempstr
    ..s tmp("Item18")=Item61str
    .i tmp("Item10")'=""  d
    ..s val=$zdh(tmp("Item10"),3)
    ..s tmp("Item10")=##class(websys.Conversions).DateLogicalToHtml(val)
	s Status=a.Status
	i (Status="V") s tmp("Status")="未上报"
  i (Status="V2") s tmp("Status")="已退回" 
	i (Status="S1") s tmp("Status")="已上报"
	i (Status="S2") s tmp("Status")="评价中"
	i (Status="A") s tmp("Status")="已审核"
	i (Status="C") d
	.s RecCancelDate=a.RecCancelDate
	.s RecCancelTime=a.RecCancelTime
	.s RecCancelUser=a.RecCancelUser
	.i RecCancelUser'="" s RecCancelUser=$p(^SSU("SSUSR",RecCancelUser),"^",2)
	.i RecCancelDate'="" d
	..//s RecCancelDate=$zd(RecCancelDate,3)
	..s RecCancelDate=##class(websys.Conversions).DateLogicalToHtml(RecCancelDate)
	.i RecCancelTime'="" s RecCancelTime=$zt(RecCancelTime,3)
	.s tmp("Status")="已作废:"_RecCancelUser_","_RecCancelDate_","_RecCancelTime
	
	s user=a.RecAuditUser
	s Item41=a.Item41
	s Item44=a.Item44
	s Item46=a.Item46
	s Item53=a.Item53
	s Item49=a.Item49
	s Item21=a.Item21
	s Item22=a.Item22
	s Item23=a.Item23
	s Item25=a.Item25
	s Item28=a.Item28
	s Item29=a.Item29
	s Item37=a.Item37
	s tmp("value")=""
	i (Item41'="")!(Item44'="") d
	.s tmp("value")="B"
	i (Item46'="") d
	.i tmp("value")="" s tmp("value")="K"
	.e  s tmp("value")=tmp("value")_"-"_"K"
	i (Item53'="")!(Item49'="") d
	.i tmp("value")="" s tmp("value")="H"
	.e  s tmp("value")=tmp("value")_"-"_"H"
	i ((Item21'="")!(Item22'="")!(Item23'="")!(Item25'="")!(Item53'=""))&&((tmp("EmrCode")="DHCNURXHSB_dulou")) d
	.i tmp("value")="" s tmp("value")="H"
	.//e  s tmp("value")=tmp("value")_"-"_"H"
	i ((Item28'="")!(Item29'="")!(Item37'=""))&&((tmp("EmrCode")="DHCNURXHSB_ssfy")) d
	.i tmp("value")="" s tmp("value")="H"
	s EmrDate=a.EmrDate
	s tmp("date")=+$h-EmrDate
	s emccode=tmp("EmrCode")
	s tmp("code")=emccode
	s emccode=$zcvt(emccode,"U")
	s EventId=$o(^User.DHCNurblsjflwhI("CodeIndex"," "_emccode,""))
	s ccsjdesc=##class(web.DHCNurblsjflwh).getVal(EventId)
	s tmp("EmrCode")=$p($p(ccsjdesc,"^",2),"|",2)
	if user'="" d
	.s name=$p(^SSU("SSUSR",user),"^",2)
	.s tmp("RecAuditUser")=name
	s auditdd=a.RecAuditDate
	s audittt=a.RecAuditTime
    i auditdd'="" d
    .s tmp("RecAuditDate")=##class(websys.Conversions).DateLogicalToHtml(auditdd) //$zd(auditdd,3)
	i audittt'="" s tmp("RecAuditTime")=$zt(audittt,2)
	s k=""
	f {
	s k=$O(tmp(k))
	q:k=""
	s ret=ret_k_"|"_tmp(k)_"^"
	}
	}
	q ret
}

ClassMethod getsuser(recuserId) As %String
{
  q:recuserId="" ""
  s User=$p($g(^SSU("SSUSR",recuserId)),"^",2)
  q recuserId_"!"_User
}

// DHCNURXHFFDD^559854^70^2012-12-04^2012-12-05

ClassMethod MoudData2Execute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	s stdate=$P(parr,"^",4)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",5)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	s ii=0
 	for date=stdate:1:eddate
 	{
 	 	s p="" f  s p=$O(^Nur.DHCMoudDataI("emdate",date," "_code,p)) q:p=""  d
	 	.//s chl=""  f  s chl=$O(^Nur.DHCNurSBDataD(p,"ChildRec",chl)) q:chl=""  d
	    .s a=##class(Nur.DHCMoudData).%OpenId(p)
	    .s Epi=a.EpisodeId
	    .q:EpisodeId'=Epi
	 	.s ret=##class(Nur.DHCMoudData).getVal(p)
	 	.s ii=ii+1
	 	.s ret=ret_"^par|"_p_"^Seqno|"_ii
		.d outtyp2
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudData2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudData2Execute ]
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

Query MoudData2(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudData2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudData2Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","MoudDatayc","DHCNURykdPFYC^2407^^2012-07-26^2012-07-27^414^^^^true")

ClassMethod MoudDataycExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr=^TMP("parr")
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	//s EpisodeId=$P(parr,"^",2)
 	s Loc=$P(parr,"^",3)
 	//s stdate=$ZDH($P(parr,"^",4),3)
 	//s eddate=$ZDH($P(parr,"^",5),3)
 	s stdate=$P(parr,"^",4)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",5)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
 	s emrLoc=$P(parr,"^",6)
 	s fj=$P(parr,"^",9)
 	s laiyuan=$P(parr,"^",7)
 	s zgui=$P(parr,"^",8)
 	s pflag=$P(parr,"^",10)
 	s i=""
 	for date=stdate:1:eddate
 	{
 	 	s p="" f  s p=$O(^Nur.DHCNurSBDataI("emdate",date," "_code,p)) q:p=""  d
	 	.//s chl=""  f  s chl=$O(^Nur.DHCNurSBDataD(p,"ChildRec",chl)) q:chl=""  d
	    .s a=##class(Nur.DHCNurSBData).%OpenId(p)
	    .s EmrLoc=a.EmrLoc
	    .s ly=a.Item7
	    .s fjj=a.Item9
	    .s zg=a.Item37
	    .s EpisodeId=a.EpisodeId
	    .s status=a.Status
	    .b ;8
	    .s flag=0
	    .s pf=""
	    .q:status="V"
	    .q:((emrLoc'="")&(EmrLoc'=emrLoc))
	    .q:((zgui'="")&(zg'=zgui))
	    .q:((laiyuan'="")&(ly'=laiyuan))
	    .q:((fj'="")&(fjj'=fj))
	 	.s ret=##class(Nur.DHCNurSBData).getVal(p)
	 	.//b ;3
	 	.if p="RecAuditUser"  d
	 	..s ret=$P(^SSU("SSUSR",ret),"^")
	 	.s pf=..getpf(EpisodeId)
	 	.if pf'="" d 
	 	..i ((pflag="true")&(pf<25)) s flag=1
	    .q:flag=1
	 	.s i=i+1
	 	.s ret=ret_"^rw|"_p_"^id|"_i_"^pf|"_pf
		.d outtyp2
		.k pf
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDataycFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDataycExecute ]
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

Query MoudDatayc(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDataycClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDataycExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod FindAdmLinkloc(code) As %String
{
      i code="00506" q 120_"^"_130_"^"_112
      i code="nurse" q ""
}

// "^152^1^2012-04-07^2012-04-08"

// "^152^1^2012-04-08^2012-04-09"

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","MoudDatall","^116^1^2012-11-12^2012-11-13^00506")

// 按上报病区查询

ClassMethod MoudDatallbakeExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	s parr=^TMP("parr")
 	s ^objcyf24=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s patward=$P(parr,"^",2)
 	s EventId=$P(parr,"^",3)
 	s ccsjdesc=##class(web.DHCNurblsjflwh).getVal(EventId)
 	s code1=$p(ccsjdesc,"^")
 	s code2=$p(code1,"|",2)
 	i code=""  s code=code2
 	s desc=$p($p(ccsjdesc,"^",2),"|",2)
 	s stdate=$ZDH($P(parr,"^",4),3)
 	s eddate=$ZDH($P(parr,"^",5),3)
    s usercode=$P(parr,"^",6)
    s SJStatus=$P(parr,"^",7)
    s FindLocs=##class(Nur.DHCNURLocData).getloc(usercode)
    s usertype=##class(Nur.DHCNURLocData).gettype(usercode)
 	s i=""
 	for date=stdate:1:eddate
 	{
 	 	s p="" f  s p=$O(^Nur.DHCNurSBDataI("emdate",date,p)) q:p=""  d
 	 	.//s i=""
 	 	.s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",date,p,rw)) q:rw=""  d
	 	..s ret=##class(Nur.DHCNurSBData).getVal2(rw)
	    ..s aa=##class(web.DHCMGNurComm).setmoudtmp(ret,.tmp)
	    ..s emrcode=tmp("EmrCode")
 	    ..s ward=tmp("EmrLoc")
 	    ..s Status=tmp("Status")
 	    ..q:(SJStatus'="")&&(SJStatus'=Status)
 	    ..q:(Status="V")&&(usertype="护理部")
 	    ..b ;9
 	    ..q:(emrcode'=desc)&&(desc'="")
 	    ..q:(ward'=patward)&&(patward'="")&&(FindLocs="")
 	    ..q:(FindLocs'="")&&(patward'=ward)&&(patward'="")
 	    ..q:(FindLocs'="")&&(patward="")&&(FindLocs'[ward)
 	    ..b ;99
	 	..s Wardesc=$p($p(^CTLOC(ward),"^",2),"-",2)
	 	..if rw="RecAuditUser"  d
	 	...s ret=$P(^SSU("SSUSR",ret),"^")
	    ..s i=i+1
	 	..s ret=ret_"^par|"_rw_"^seqno|"_i_"^ward|"_Wardesc_"^code|"_tmp("code")
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

// 按病区查询

// d ##class(%ResultSet).RunQuery("web.DHCNurblsjflwh","MoudDatall",^objcyf2455)

ClassMethod MoudDatallExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr=^TMP("parr")
 	s ^objcyf2455=parr
 	s EmrCode=$P(parr,"^",1)
 	s code=$ZConvert(EmrCode,"U")
 	s patward=$P(parr,"^",2)
 	i patward=0 s patward=""
 	s EventId=$P(parr,"^",3)
 	s ccsjdesc=##class(web.DHCNurblsjflwh).getVal(EventId)
 	s code1=$p(ccsjdesc,"^")
 	s code2=$p(code1,"|",2)
 	i code=""  s code=code2
 	s desc=$p($p(ccsjdesc,"^",2),"|",2)
 	//s stdate=$ZDH($P(parr,"^",4),3)
 	//s eddate=$ZDH($P(parr,"^",5),3)
 	s stdate=$P(parr,"^",4)
 	s stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
 	s eddate=$P(parr,"^",5)
 	s eddate=##class(websys.Conversions).DateHtmlToLogical(eddate)
    s usercode=$P(parr,"^",6)
    s SJStatus=$P(parr,"^",7)
    s xsysh=$P(parr,"^",8) //是否显示审核
    s FindLocs=##class(Nur.DHCNURLocData).getloc(usercode)
    s usertype=##class(Nur.DHCNURLocData).gettype(usercode)
    s ll=$l(FindLocs,"^")
   // s ^objcyf44(usertype,stdate,eddate)=FindLocs
    s Wardesc=""
    f ii=2:1:ll
    {   s ward=$p(FindLocs,"^",ii)
        q:ward=""
	    s tempfindlocs(ward)=""
	}
 	s i=""
 	for date=stdate:1:eddate
 	{ 
 	    i usertype="护理部" d 
 	    .s p="" f  s p=$O(^Nur.DHCNurSBDataI("emdate",date,p)) q:p=""  d
 	 	..s rw="" f  s rw=$O(^Nur.DHCNurSBDataI("emdate",date,p,rw)) q:rw=""  d
	 	...s ret=..getVal2(rw)
	    ...s aa=##class(web.DHCMGNurComm).setmoudtmp(ret,.tmp)
	    ...s emrcode=tmp("EmrCode")
	    ...q:emrcode=""
 	    ...s ward=tmp("EmrLoc")
 	    ...s Status=tmp("Status")
 	    ...q:(SJStatus'="")&&(SJStatus'=Status)
 	    ...q:(Status="未上报")
 	    ...q:(Status["已作废")
 	    ...q:(Status="已退回")
 	    ...b ;33
 	    ...q:(xsysh="false")&&(Status="已审核")
 	    ...q:(xsysh="true")&&(Status'="已审核")
 	    ...q:(emrcode'=desc)&&(desc'="")
 	    ...q:(ward'=patward)&&(patward'="")&&(FindLocs="")
 	    ...q:(FindLocs'="")&&(patward'=ward)&&(patward'="")
 	    ...//q:(FindLocs'="")&&(patward="")&&(FindLocs'[ward)
    ...s Wardesc=$p(^CTLOC(ward),"^",2)
	 	...if rw="RecAuditUser"  d
	 	....s ret=$P(^SSU("SSUSR",ret),"^")
	    ...s i=i+1
	 	...s ret=ret_"^par|"_rw_"^Seqno|"_i_"^ward|"_Wardesc_"^usercode|"_tmp("usercode")_"^EpisodeID|"_tmp("EpisodeId")
		...d outtyp2
 	}
	i usertype="科护士长" d 
		.s ll=$l(FindLocs,"^")
		.s flagloc=""
		.b ;00
		.for date2=stdate:1:eddate d
 	    ..s p2="" f  s p2=$O(^Nur.DHCNurSBDataI("emdate",date2,p2)) q:p2=""  d
 	 	...s rws="" f  s rws=$O(^Nur.DHCNurSBDataI("emdate",date2,p2,rws)) q:rws=""  d
	 	....s ret=..getVal2(rws)
	    ....s aa=##class(web.DHCMGNurComm).setmoudtmp(ret,.tmp)
	    ....s emrcode=tmp("EmrCode")
	    ....q:emrcode=""
 	    ....s ward=tmp("EmrLoc")
 	    ....s flagex=""
 	    ....s rw="" f  s rw=$o(tempfindlocs(rw)) q:(rw="")!(flagex=1)  d
		.....q:rw=""
		.....i rw=ward s flagex=1
		....q:flagex=""
 	    ....b ;003
 	    ....s EpisodeId=tmp("EpisodeId")
 	    ....s Status=tmp("Status")
 	    ....q:(Status="未上报")
 	    ....q:(Status["已作废")
 	    ....q:(xsysh="false")&&(Status="已审核")
 	    ....q:(xsysh="true")&&(Status'="已审核")
 	    ....q:(emrcode'=desc)&&(desc'="")
 	    ....q:(SJStatus'="")&&(SJStatus'=Status)
 	    ....q:(ward'=patward)&&(patward'="")
	 	....s Wardesc=$p(^CTLOC(ward),"^",2)
	    ....s i=i+1
	 	....s ret=ret_"^par|"_rws_"^Seqno|"_i_"^ward|"_Wardesc_"^usercode|"_tmp("usercode")_"^EpisodeID|"_tmp("EpisodeId")
		....d outtyp2
 	   i (usertype="")!(usertype="护士长") d
 	    .s wardFlag=$P($g(^CTLOC(patward)),"^",13)
		.//i (wardFlag="W")!(wardFlag="EM") s Ward=..getlocward(patward)
		.s Ward=..getlocward(patward)
		.b ;009
		.i wardFlag="OP" s Ward=""
		.s room=""
		.b ;001
		.i Ward'="" d
 	    ..f  s room=$O(^PAADMi("CurrWard",Ward,room)) q:room=""  d
	    ...s RowId=""  f  s RowId=$O(^PAADMi("CurrWard",Ward,room,RowId)) q:RowId=""  d
	    ....s VistStatus=$P(^PAADM(RowId),"^",20)
	    ....q:VistStatus="D"
	    ....//w !,RowId
	    ....s p="" f  s p=$O(^Nur.DHCNurSBDataI("EpisodeId"," "_RowId,p)) q:p=""  d
	    .....b ;sb
	    .....s ret=..getVal2(p)
	    .....s aa=##class(web.DHCMGNurComm).setmoudtmp(ret,.tmp)
	    .....s emrcode=tmp("EmrCode")
 	    .....s ward=tmp("EmrLoc")
 	    .....s Status=tmp("Status")
 	    .....q:(Status["已作废")
 	    .....q:(xsysh="false")&&(Status="已审核")
 	    .....q:(xsysh="true")&&(Status'="已审核")
 	    .....//s EmrDate=$zdh(tmp("EmrDate"),3)
 	    .....s EmrDate=##class(websys.Conversions).DateHtmlToLogical(tmp("EmrDate"))
 	    .....q:emrcode=""
 	    .....//w !,emrcode
 	    .....q:(SJStatus'="")&&(SJStatus'=Status)
 	    .....//q:(Status="V")
 	    .....q:(EmrDate>eddate)!(EmrDate<stdate)
 	    .....q:(emrcode'=desc)&&(desc'="")
	 	.....i ward'="" s Wardesc=$p(^CTLOC(ward),"^",2)
	 	.....if p="RecAuditUser"  d
	 	......s ret=$P(^SSU("SSUSR",ret),"^")
	    .....s i=i+1
	    .....b ;888888899
	 	.....s ret=ret_"^par|"_p_"^Seqno|"_i_"^ward|"_Wardesc_"^usercode|"_tmp("usercode")_"^EpisodeID|"_tmp("EpisodeId")
		.....d outtyp2
 	    .i (Ward="")  d
 	    ..b ;002
 	    ..for date2=stdate:1:eddate d
 	    ...s p2="" f  s p2=$O(^Nur.DHCNurSBDataI("emdate",date2,p2)) q:p2=""  d
 	 	....s rws="" f  s rws=$O(^Nur.DHCNurSBDataI("emdate",date2,p2,rws)) q:rws=""  d
	 	.....s ret=..getVal2(rws)
	    .....s aa=##class(web.DHCMGNurComm).setmoudtmp(ret,.tmp)
	    .....s emrcode=tmp("EmrCode")
	    .....q:emrcode=""
 	    .....s ward=tmp("EmrLoc")
 	    .....s Status=tmp("Status")
 	    .....b ;005
 	    .....q:(Status="未上报")
 	    .....q:(Status["已作废")
 	    .....q:(SJStatus'="")&&(SJStatus'=Status)
 	    .....q:(emrcode'=desc)&&(desc'="")
 	    .....//q:(patward="")&&(ward'=patward)
 	    .....//w !,tmploc,ward
 	    .....q:(ward'=patward)&&(patward'="")
	 	.....s Wardesc=$p(^CTLOC(ward),"^",2)
	    .....s i=i+1
	    .....b ;8776666
	 	.....s ret=ret_"^par|"_rws_"^Seqno|"_i_"^ward|"_Wardesc_"^usercode|"_tmp("usercode")_"^EpisodeID|"_tmp("EpisodeId")
		.....d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod MoudDatallFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MoudDatallExecute ]
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

Query MoudDatall(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod MoudDatallClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MoudDatallExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// w ##class(web.DHCNurblsjflwh).getlocward("626")

ClassMethod getlocward(loc) As %String
{
 i loc="" q 
  s ward=$O(^PAWARD(0,"WARD_LocationDR",loc,"")) 
  q ward
}

ClassMethod GetCCEventExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
    s id="" f  s id=$O(^User.DHCNurblsjflwhD(id)) q:id=""  d
 	.s a=##class(User.DHCNurblsjflwh).%OpenId(id)
	.s rw=id
	.s ret=""
	.s ret=..getVal(rw)
	.s ret=ret_"^rw|"_a.Code
	.d outtyp2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outtyp2
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCCEventFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCCEventExecute ]
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

Query GetCCEvent(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod GetCCEventClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCCEventExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod getpatinfo(EpisodeId) As %String
{
       s patinfo=##class(web.DHCMGNurComm).GetPatInfo(EpisodeId)
       q ..getitminfo(patinfo)
}

ClassMethod getitminfo(info) As %String
{
  //Item1 loc//Item5姓名//Item6性别//Item7  age//Item8 bed//
  //Item9 medno//Item10 diag//Item13 admdate//Item17 dischgdate
   s tmp("LOC")="Item1"
   s tmp("Telephone")=""
   s tmp("BEDCODE")="Item8"
   s tmp("PATNAME")="Item5"
   s tmp("REGNO")=""
   s tmp("MedCareNo")="Item9"
   s tmp("SEX")="Item6"
   s tmp("AGE")="Item7"
   s tmp("AdmDate")="Item13"
   s tmp("DisChgDate")="Item17"
   s tmp("DIAG")="Item10"
  //s tmp("EpisodeId")="Item24"
   s l=$L(info,"^")
   s ret=""
   for i=1:1:l
   {
      s itm=$P(info,"^",i)
      if itm="" continue
      s code=$P(itm,"|")
      s val=$P(itm,"|",2)
      if $D(tmp(code)) 
      {
	    s code1=tmp(code)
	    s ret=ret_code1_"|"_val_"^"
	  }
   }
   q ret
}

}
