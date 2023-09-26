Import SQLUser

Class web.DHCSTKUTIL Extends %RegisteredObject
{

/// w ##class(web.DHCSTKUTIL).GetDate("","","t-1")
ClassMethod GetDate(itmjs As %Library.String = "", itmjsex As %Library.String = "", dateExpress As %String) As %String
{
	s dateExpress=$tr(dateExpress,$c(13,10))
	s dateExpress=$tr(dateExpress," ")
	s dateExpress=$ZCVT(dateExpress,"u")
	s flag="T" ;
	i flag=dateExpress q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h)
	i $p(dateExpress,flag,1)'="" d
	.s dd=""
	e  d
	.s dateOffset=$p(dateExpress,flag,2)
	.q:dateOffset=""
	.s op=$e(dateOffset)  ; fhe first char
	.s cnt=$e(dateOffset,2,$l(dateOffset))
	.s dd=""
	.i op="+" d
	.. s dd=+$h+cnt
	.i op="-"  d
	.. s dd=+$h-cnt
	i $g(dd)>0 q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(dd)
	q ""
}

ClassMethod GetDatH(dateExpress) As %String
{
	s dateExpress=$tr(dateExpress,$c(13,10))
	s dateExpress=$tr(dateExpress," ")
	s dateExpress=$ZCVT(dateExpress,"u")
	s dd=""
	s flag="T"
	i flag=dateExpress q +$h
	i $p(dateExpress,flag,1)'="" d
	.s dd=""
	e  d
	.s dateOffset=$p(dateExpress,flag,2)
	.q:dateOffset=""
	.s op=$e(dateOffset)  ; fhe first char
	.s cnt=$e(dateOffset,2,$l(dateOffset))
	.s dd=""
	.i op="+" d
	..s dd=+$h+cnt
	.i op="-" d
	..s dd=+$h-cnt
	q dd
}

ClassMethod ValidateRegNo(regno As %String) As %String
{
	&sql(select papmi_rowid into :pa  from  pa_patmas where papmi_no =:regno )
	q $g(pa)
}

ClassMethod Inspp() As %String
{
	&sql(INSERT into IN_PurPlan (inpp_no,inpp_auditssusr_dr,inpp_ctloc_dr) values ('xxx',2,7))
	q SQLCODE
}

ClassMethod TodayNomi() As %String
{
	s rowid=$o(^CF("SM",""))
	q:rowid="" ""
	s TN=$p(^CF("SM",+rowid),"^",16)	
	q TN
}

ClassMethod HospName(itmjs As %Library.String = "", itmjsex As %Library.String = "") As %String
{
	s tmp=$g(tmp)
	;&sql(select stcus_id into :tmp From dhc_stcustomer    )
	 
	&sql(select STCUS_Desc into :tmp From dhc_stcustomer    )
	q $g(tmp)
}

ClassMethod GetCtlocByWardDR(warddr As %String) As %String
{
	&sql(select ward_locationdr into :LOC From pac_ward where ward_rowid=:warddr)
	q $g(LOC)
}

ClassMethod UCASE(ss As %String)
{
	s transtable=" !""#$%&'()*+-./:;<=>@[\]^_`{|}~"
	s ss=$tr(ss,transtable)
	s ss=$zcvt(ss,"u")
	q ss
}

ClassMethod PaRegNo(inregno As %String) As %String
{
	
	;根据系统设定将病人登记号补充到位
	s rowid=$o(^CF("PATCF","")) q:rowid="" inregno
	s NoLength=$p(^CF("PATCF",rowid,3),"^",5)
	i $l(inregno)>NoLength q $e(inregno,1,NoLength)
	s ll=NoLength-$l(inregno)
	s sur=""
	f i=1:1:ll d
	.s sur=sur_"0"
	q sur_inregno
}

ClassMethod TypeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TypeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TypeLocExecute(ByRef qHandle As %Binary, loctype As %String, inputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	if inputs'="全部" {
 	&sql(declare xxx cursor for SELECT ctloc_desc,ctloc_rowid into :desc,:rowid FROM ct_loc
	 where (%ALPHAUP(ctloc_type) %STARTSWITH %ALPHAUP (:loctype)) and (%ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:inputs))
	 )
	&sql(open xxx)
	f  &sql(fetch xxx into :desc,:rowid)  q:SQLCODE  d
	. ;s desc=$p(desc,"-",2)
	. s dateto=$p(^CTLOC(rowid),"^",25)
	. q:(dateto'="")&(dateto'>+$h)
	. d OutputDispStatItmtmp
	&sql(close xxx)
	}
 	s desc="全部"
 	s rowid="全部"
 	d OutputDispStatItmtmp
       
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputDispStatItmtmp
	s Data=$lb(desc,rowid)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod TypeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TypeLocExecute ]
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

Query TypeLoc(loctype As %String, inputs As %String) As %Query(ROWSPEC = "药房名称:%String,药房ID:%String") [ SqlProc ]
{
}

Query Wards(input As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT ward_desc,ward_rowid FROM  pac_ward where %ALPHAUP(ward_desc) %STARTSWITH %ALPHAUP(:input)
	or %ALPHAUP(WARD_LocationDR->CTLOC_ContactName) %STARTSWITH %ALPHAUP(:input)
}

Query RetReason() As %SQLQuery(CONTAINID = 1)
{
	select Rfr_desc,Rfr_rowid From BLC_ReasonForRefund
}

ClassMethod PhcCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhcCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PhcCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	s phcCatID=0
	f  s phcCatID=$o(^PHCC(phcCatID)) q:(+phcCatID)="0"  d
	.s phccDesc=$p(^PHCC(phcCatID),"^",2)
	.set Data=$lb(phccDesc,phcCatID)
	.Set ^CacheTemp(repid,ind)=Data	
	.Set ind=ind+1
	Quit $$$OK
}

ClassMethod PhcCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhcCatExecute ]
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

/// 2015-10-13 zhouyg 重写，从原来的SQL改过来
Query PhcCat() As %Query(ROWSPEC = "描述:%String,ID:%String")
{
}

Query IncCat() As %SQLQuery(CONTAINID = 1)
{
	select incsc_desc,incsc_rowid From inc_stkcat
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTKUTIL","GroupLoc",38,"zxyf-中心药房","")
ClassMethod GroupLocExecute(ByRef qHandle As %Binary, group As %String, input As %String, hospid As %String = "") As %Status
{
	s input=$zcvt(input,"U")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:group="" $$$OK
	i (hospid="")&&($d(%session)) s hospid=$g(%session.Data("LOGON.HOSPID"))
	s stsub=0
	f  s stsub=$o(^SSU("SSGRP",group,"ST",stsub)) q:stsub=""  d
	.s stobj=##class(User.SSGroupStockLocations).%OpenId(group_"||"_stsub)
	.s ctlocobj=stobj.STCTLOCDR
	.q:ctlocobj=""
	.s ctlocdr=ctlocobj.%Id()
	.s ctlocdesc=ctlocobj.CTLOCDesc
	.q:ctlocdesc=""
	.s ctlocconname=$zcvt(ctlocobj.CTLOCContactName,"U")
	.q:(input'="")&&($zcvt(ctlocdesc,"U")'[input)&&(ctlocconname'[input)
	.s ctlochosp=$p($g(^CTLOC(ctlocdr)),"^",22)
	.q:(hospid'="")&&(hospid'=ctlochosp)
	.d outputrowGrpLoc
	q $$$OK
outputrowGrpLoc
	s Data=$lb(ctlocdesc,ctlocdr)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GroupLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupLocExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod GroupLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GroupLocExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query GroupLoc(group As %String, input As %String, hospid As %String = "") As %Query(ROWSPEC = "ctloc_desc,st_ctloc_dr")
{
}

Query GetPoison() As %SQLQuery(CONTAINID = 1)
{
	select phcpo_desc,phcpo_rowid From phc_poison
}

ClassMethod IncAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IncAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod IncAliasExecute(ByRef qHandle As %Binary, InciAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;s ^zdm("IncAliasExecute")=InciAlias
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	q:InciAlias="" $$$OK 
	s cnt=##class(web.DHCSTITMDESC).FindItmByStkGrp(InciAlias,"","")
	q:cnt<1 ""
	f i=1:1:cnt  d 
	. s INCI=##class(web.DHCSTITMDESC).ListItms(i)
	. d OutPutRow
	d ##class(web.DHCSTITMDESC).kTmpOutPut()
	Quit $$$OK
	
OutPutRow
	s incirowid=$p(INCI,"^",1)
	s incicode=$p(INCI,"^",2)
	s incidesc=$p(INCI,"^",3)
	set Data=$lb(incidesc,incicode,incirowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod IncAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IncAliasExecute ]
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

Query IncAlias(InciAlias As %String) As %Query(ROWSPEC = "InciDesc:%String,InciCode:%String,InciRowid:%String")
{
}

ClassMethod GetDefaultLoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", userid As %String) As %String
{
	s (dept,deptdesc)="" 
	&sql(select ssusr_defaultdept_dr,ssusr_defaultdept_dr->ctloc_desc into :dept,:deptdesc from ss_user 
	   where ssusr_rowid=:userid)
	q:SQLCODE ""
	s group=+$p(^SSU("SSUSR",userid),"^",5)
	;check if the default loc is in the group stock locations list
	 &sql(select st_ctloc_dr->ctloc_desc,st_ctloc_dr From ss_groupstocklocations
	  where st_parref=:group and st_ctloc_dr=:dept	  )
	q:SQLCODE ""
	s result= +dept_"^"_deptdesc
	s retval=itmjs_"('"_$ZCVT(result,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(result,"O","JS")_"');"
	&javascript<#(retval)#>
    q $g(result)
}

ClassMethod TypeLoc2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TypeLoc2Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TypeLoc2Execute(ByRef qHandle As %Binary, loctype As %String, inputs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	s inputstr=inputs
 	;
	&sql(declare xx cursor for select ctloc_desc,ctloc_rowid from ct_loc
	 where ctloc_type=:loctype and %ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:inputstr))
	&sql(open xx)
	f  &sql(fetch xx into :desc,:rowid)  q:SQLCODE  d
	. s desc=$p(desc,"-",2)
	. 
	. 
	. d OutputDispStatItm
	&sql(close xx)
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputDispStatItm
	s Data=$lb(desc,rowid)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod TypeLoc2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TypeLoc2Execute ]
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

Query TypeLoc2(loctype As %String, inputs As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

Query DoctorLoc(phaloc As %String, inputs As %String) As %SQLQuery(CONTAINID = 1)
{
	select link_ctloc_dr->ctloc_desc,link_ctloc_dr from CT_LocLinkLocation
	where link_parref=:phaloc and %ALPHAUP(link_ctloc_dr->ctloc_desc) %STARTSWITH %ALPHAUP(:inputs)
}

Query DoctorLoc1(inputs As %String) As %SQLQuery(CONTAINID = 1)
{
	select ctloc_desc,ctloc_rowid from CT_Loc
	where  (CTLOC_Type= 'E' or CTLOC_Type= 'OP') and %ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:inputs)
}

ClassMethod GetManfNameByInci(itmid)
{
	&sql(select inci_arcim_dr->arcim_phcdf_dr->phcdf_phcd_parref->phcd_phmnf_dr->phmnf_name
	into :manfdesc from inc_itm where inci_RowID = :itmid)
	i manfdesc'="" d
	.i manfdesc["-" s manfdesc=$p(manfdesc,"-",2)
	.s manfdesc=$e(manfdesc,1,4)
	q $g(manfdesc)
}

Query DispOperUser(grp As %String) As %SQLQuery(CONTAINID = 1)
{
	select ssusr_name,ssusr_rowid  from ss_user where ssusr_group=:grp
}

Query LocUser(Locid As %String) As %SQLQuery(CONTAINID = 1)
{
	select RES_Desc,RES_Code  from RB_Resource  where  RES_CTLOC_DR =:Locid
}

ClassMethod ItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTKUTIL","Itm","lhnzsy","","G")
ClassMethod ItmExecute(ByRef qHandle As %Binary, InciAlias As %String, StkCode As %String, StkType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	q:InciAlias="" $$$OK 
	;s cnt=##class(web.DHCSTITMDESC).FindItmByStkGrp(InciAlias,StkCode,StkType)
	s cnt=##class(web.DHCSTITMDESC).FindItmByStkGrp(InciAlias,StkCode,"G")
	q:cnt<1 $$$OK
	f i=1:1:cnt  d 
	. s INCI=##class(web.DHCSTITMDESC).ListItms(i)
	. d OutPutRowx
	d ##class(web.DHCSTITMDESC).kTmpOutPut()
	Quit $$$OK
	
OutPutRowx
	s incirowid=$p(INCI,"^",1)
	s incicode=$p(INCI,"^",2)
	s incidesc=$p(INCI,"^",3)
	set Data=$lb(incidesc,incicode,incirowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod ItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItmExecute ]
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

Query Itm(InciAlias As %String, StkCode As %String, StkType As %String) As %Query(ROWSPEC = "InciDesc:%String,InciCode:%String,InciRowid:%String")
{
}

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	q ##class(PHA.COM.Order).MrDiagnose(MRAdmRowid,DelimStr,Type)
}

/// ADD wyx 当有润乾调用时使用此方法，防止与润乾冲突
/// w ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(790,",","")
ClassMethod GetMRDiagnosDescForRunQian(MRAdmRowid As %String, DelimStr As %String, Type As %String = "") As %String
{
	q ##class(PHA.COM.Order).GetMrDiagnoseForRQ(MRAdmRowid,DelimStr,Type)
}

ClassMethod NN(a As %String) As %String
{
	q:a="" ""
	q:a<0 a
	q:a'<1 +a
	i a<1 d
	.s a=+a
	.s sub=$p(a,".",2)
	.s int="0"
	q $g(int)_"."_$g(sub)
}

ClassMethod GetRegNobyEpisodeID(EpisodeID)
{
	q:$g(EpisodeID)="" ""
	q:'$d(^PAADM(EpisodeID)) ""
	s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	;q ..GetRegNo(PaitentID)
	q:PaitentID="" ""
	q:'$D(^PAPER(PaitentID,"PAT",1)) ""
	s IP=$p(^PAPER(PaitentID,"PAT",1),"^",1)
	s OP=$p(^PAPER(PaitentID,"PAT",1),"^",2)
	s PAPMINo=$S($G(XFUNC("CLASS"))="OP":OP,1:IP)
	q PAPMINo
}

Query PhcSubCat(phccat As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT phcsc_desc,phcsc_rowid FROM phc_subcat where phcsc_phcc_parref=:phccat
}

Query PhcMinorSubCat(phcsubcat As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT min_desc,min_rowid FROM phc_minorsubcat where min_parref=:phcsubcat
}

Query PhcForm() As %SQLQuery(CONTAINID = 1)
{
	SELECT phcf_desc,phcf_rowid FROM phc_form
}

ClassMethod ValidateUser(usercode As %String, userpass As %String) As %String
{
	s ret=0
	s password=$$ENCR^SSUTIL2(userpass)
	&sql(select ssusr_rowid into :id from ss_user where ssusr_initials=:usercode and ssusr_password=:password)
	i SQLCODE s ret=-1
	e  s ret=+id
	q ret
}

ClassMethod SetSession(Name As %Library.String, Value As %Library.String)
{
	
	s %session.Data(Name)=Value
	q %session.Get(Name)
}

ClassMethod GetSession(Name As %Library.String)
{
	q %session.Get(Name)
}

ClassMethod GetPanoByName(itmjs As %Library.String = "", itmjsex As %Library.String = "", name As %String) As %String
{
	&sql(select papmi_no into :pano from pa_patmas
           where papmi_name %STARTSWITH :name)
	q:SQLCODE ""
	q pano
}

/// Update :20150129 zhouyg 添加参数Adm，并改为调用计费接口
ClassMethod GetAge(papmidr As %String, Adm As %String = "") As %String
{
	q "" //年龄为空，请调用计费组统一获取年龄方法
}

ClassMethod OrdItmInci(orditem As %String) As %String
{
	s ord=$P(orditem,"||",1) q:ord="" ""
	s chl=$P(orditem,"||",2) q:chl="" ""
	s arcim=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	q:arcim="" ""
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	q inci
}

ClassMethod GetDODIS(oeori As %String) As %String
{
	q:oeori="" ""
	s ret=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))  ; 找最前的
	q ret
}

ClassMethod StkBin(oeori As %String) As %String
{
	s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
	q:ord="" ""
	q:chl="" ""
	s reclocdr=$p(^OEORD(ord,"I",chl,3),"^",6)	q:reclocdr="" ""
	s arcim=$p($g(^OEORD(ord,"I",chl,1)),"^",2)	q:arcim="" ""
	s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),"")) q:inci="" ""
	s incilch=$o(^INCI("IL_LOC",reclocdr,inci,"")) q:incilch="" ""
	q ##class(web.DHCSTCOMMONSRV).getIncStk(inci_"||"_incilch)
}

ClassMethod Getprice2(pri As %String) As %String
{
	;返回二位小数
	;lq 2007-10-19
	q:pri=""
	s price=$fn(pri,"",2)
	q $g(price)
}

ClassMethod Getprice4(pri As %String) As %String
{
	;返回四位小数
	;lq 2007-10-19
	q:pri=""
	s price=$fn(pri,"",4)
	q $g(price)
}

ClassMethod GetSpec(inci As %String) As %String
{
 	;取规格,2007-07-23,zdm
	q:inci="" ""
	s inci=+inci
	q ##Class(web.DHCSTCOMMONSRV).getBarcode(inci)
}

/// Description : 根据医嘱项目取"规格"
/// Arguments : arcim - 医嘱项rowid
/// ReturnValue : 医嘱项目(药品或者材料)规格
/// Created by : zhaowh
/// Created at : 2008-08-15 
ClassMethod GetArcimSpec(arcim As %String) As %String
{
	s arcim=+arcim	q:arcim<1 ""
	s inci=$o(^INCI(0,"ARCIM_DR",arcim,""))
	q:inci="" ""
	q ..GetSpec(inci)
}

/// Description  : 手工生成发药子表(DHC_PhaCollectitm)中的索引 -  ^DHCPHAC(0,"PHADSP",{PHACI_OEDIS_DR}
ClassMethod CreateOeoriIndex(phaloc As %String) As %String
{
 s WardId=""
	f  s WardId=$o(^PAWARD(WardId)) q:WardId=""  d
	. s room=0
	. f  s room=$o(^PAADMi("CurrWard",WardId,room)) q:room=""  d
	. . s adm=""
	. . f  s adm=$o(^PAADMi("CurrWard",WardId,room,adm)) q:adm=""  d
	. . . s oeord="" 
	. . . f  s oeord=$o(^OEORD(0,"Adm",adm,oeord)) q:oeord=""  d
	. . . . 
	. . . . s ch=0
	. . . . f  s ch=$o(^OEORD(oeord,"I",ch)) q:ch=""  d
	. . . . .
	. . . . .s pr=$p(^OEORD(oeord,"I",ch,1),"^",8) q:pr=""  
	. . . . .s priority=$p(^OECPR(pr),"^",1)  
	. . . . .q:priority="OM"
	. . . . .q:priority="OMST"
	. . . . .
	. . . . .s recloc=$p(^OEORD(oeord,"I",ch,3),"^",6)
	. . . . .q:recloc'=phaloc
	. . . . .
	. . . . .s dspRowids=$$Disp(oeord,ch) q:dspRowids=""
	. . . . .
	. . . . . s cnt=$l(dspRowids,"&")
	. . . . . f n=1:1:cnt d
	. . . . . . s dsprowid=$p(dspRowids,"&",n)
	. . . . . . s phac=""
	. . . . . . f  s phac=$o(^DHCPHAC(0,"PHADSP",dsprowid,phac)) q:phac=""  d
	. . . . . . . s phacich=0
	. . . . . . . f  s phacich=$o(^DHCPHAC(0,"PHADSP",dsprowid,phac,phacich)) q:phacich=""  d
	. . . . . . . .s oeori=oeord_"||"_ch
	. . . . . . . .s ^DHCPHAC(0,"PHADSP",oeori,phac,phacich)=""
	. . . . . . . .w oeori,!
	q 0
DispStatus(dsp)
 s ord=$p(dsp,"||",1) q:ord="" ""
 s itm=$p(dsp,"||",2) q:itm="" ""
 s exe=$p(dsp,"||",3) q:exe="" ""
 s dsp=$p(dsp,"||",4) q:dsp="" ""
 q $p($g(^OEORD(ord,"I",itm,"X",exe,"D",dsp)),"^",6)
	
Disp(ord,itm)
 s exe=0
 s ret=""
 f  s exe=$o(^OEORD(ord,"I",itm,"X",exe) ) q:exe=""  d
 .s dsp=0
 .
 .f  s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",dsp) ) q:dsp=""  d
 ..q:$p($g(^OEORD(ord,"I",itm,"X",exe,"D",dsp)),"^",6)'="C"
 ..s dsprowid=ord_"||"_itm_"||"_exe_"||"_dsp
 ..
 ..i ret="" s ret=dsprowid
 ..e  s ret=ret_"&"_dsprowid
 ..
 q ret
}

ClassMethod SelClbQty(incil, dspqty) As %String
{
 ///description:1.判断库存是否大于发药总量
 ///            2.按照发药数选择批次,PDELIM="!"
 ///return: 1---大于  0---小于
 ///creator:lq
 q:dspqty=0 1
 ;l +^DHCINCIL(incil):10  e  q 0
 s cnum=$$GetClbQtyObExp(incil)
 ;i cnum=0  l -^DHCINCIL(incil) q 0 
 i cnum=0  q 0  
 s k=0
 s sumdqty=0
 s clbqty=dspqty
 k xINCLB,xQTY
 f i=1:1:cnum q:clbqty'>0   d
 . i Eqty(i)'<clbqty d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=clbqty
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 . e  d
 . .s k=k+1
 . .s xINCLB(k)=CLB(i)
 . .s xQTY(k)=Eqty(i) ;发药量
 . .s clbqty=clbqty-xQTY(k)
 . .s sumdqty=$g(sumdqty)+xQTY(k)
 i sumdqty<dspqty q 0  //当所查到的可发批次库存之和<发药总数量,不予发药 2008-07-16
 q k
GetClbQtyObExp(incil) 
 ;INCLB按效期排序
 k CLB,Eqty 
 &sql(DECLARE CurrExp CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp)
 s num=0
 f  &sql(fetch CurrExp INTO :tclb,:tqty) q:SQLCODE  d                                                                            
 .;s tqty=$$CurQtyINCLB^DHCSTSTKQTY(tclb)
 .;s tqty=$$CuyInclbAvaQty^DHCSTSTKQTY(tclb,"")
 .i tqty>0 d
 ..s num=num+1
 ..s CLB(num)=tclb
 ..s Eqty(num)=tqty
 &sql(close CurrExp)
 q num
}

ClassMethod GetClbQtyObExp(incil) As %String
{
 ///Description: INCLB按效期排序 ,获取库存是否大于0
 ///Creator: lq 08-11-13
 ///Input:INC_ITMLCBT Rowid
 ///Return:0 --- 库存为0 , >0 --- 库存大于0 
 &sql(DECLARE CurrExp1 CURSOR FOR
 SELECT INCLB_ROWID,INCLB_PHYQTY-nvl(INCLB_DirtyQty,0) FROM INC_ITMLCBT 
 WHERE INCLB_INCIL_PARREF=:incil order by INCLB_INCIB_DR->INCIB_EXPDATE )
 &sql(open CurrExp1)
 s num=0
 f  &sql(fetch CurrExp1 INTO :tclb,:tqty) q:SQLCODE  d                                                                            
 .i tqty>0 d
 ..s num=num+1
 &sql(close CurrExp1)
 q num
}

ClassMethod DoctorLocRefuse(phaloc, doctorloc)
{
 ;1:拒绝的医生科室 0:非拒绝的医生科室
 &sql(select * from CT_LocLinkLocation where link_parref=:phaloc and link_ctloc_dr=:doctorloc)
 q:'SQLCODE 1
 q 0
}

ClassMethod GetPhaConfig(item As %String) As %String
{
 ///Description:获取住院药房设置
 ///Creator：LQ   2009-01-19
 
 s config=0
 i item'="" d 
 .i $d(^DHCSTPHACONFIG("dhcpha",item)) d
 ..s str=^DHCSTPHACONFIG("dhcpha",item)
 ..s config=$p(str,"^",2)
 i config="Y" s config=1
 i config="N" s config=0
 q config
}

/// w ##class(web.DHCSTKUTIL).GetPrnTypeConfig("KF")
ClassMethod GetPrnTypeConfig(type As %String) As %String
{
 s config=""
 s rowid=0 
 f  s rowid=$o(^DHCSTDRUGGRP(rowid)) q:rowid=""  d
 .s configString=^DHCSTPHACONFIG("PrintType",rowid)
 .s code=$p(^DHCSTDRUGGRP(rowid),"^",1)
 .q:type'=code
 .s config=configString_"^"_$g(^DHCSTDRUGGRP(rowid))
 q config
}

ClassMethod UserDept(oeori As %String) As %String
{
 //取得userDepartmentLoc - 医生科室
 s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 q:ord="" ""
 q:chl="" ""
 s userdept=$p($g(^OEORD(ord,"I",chl,7)),"^",2)
 q $g(userdept)
}

ClassMethod Linked(oeori As %String) As %String
{
 //判断医嘱是否是医生科室医嘱
 // 1- 是 0 - 不是
 // 
 s ord=$p(oeori,"||",1),chl=$p(oeori,"||",2)
 q:ord="" 0
 q:chl="" 0
 s userdept=$p($g(^OEORD(ord,"I",chl,7)),"^",2)  //医嘱科室
 q:userdept="" 0
 s recloc=$p($g(^OEORD(ord,"I",chl,3)),"^",6)  //医嘱接收科室
 q:recloc="" 0
 s childsub=$O(^CTLOC(recloc,"LINK",0,"Loc",userdept,""))
 q:+childsub=0 0
 q 1
}

/// Description:转换成整包装数量 
/// Input: inci:inc_itmRowid   qty:基本单位数量
/// Output: result:XX合xx片
/// Creator:LQ  09-01-04
ClassMethod getPackQty(inci, qty) As %String
{
	q:inci="" ""
	;s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	s result=""
	s buom=+$p(^INCI(inci,1),"^",10)  ; basic uom
	s puom=+$p(^INCI(inci,3),"^",6)  ; 
	i puom="" s puom=buom
	s buomdesc=$p(^CT("UOM",buom),"^",2)
	s puomdesc=$p(^CT("UOM",puom),"^",2)
	;i $f(puomdesc,"(") s puomdesc=$p(puomdesc,"(",1)
	;
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(puom,buom)
	s packqty=qty\fac
	s restqty=qty-(packqty*fac)
	
	i packqty>0 d
	. s result=packqty_""_puomdesc
	
	i restqty>0 d
	. i result'="" d
	. . s result=result_""_restqty_""_buomdesc
	. e  d
	. . s result=restqty_""_buomdesc
	
	q result
}

/// Creator:Liang Qiang
/// CreatDate:2009-04-13
/// Description:取关联医嘱主医嘱的Rowid
/// Input:oe_orditmRowid
/// Ouput:关联医嘱主医嘱的Rowid
/// Return:关联医嘱主医嘱的Rowid
/// Others:
ClassMethod GetMainOeori(oeori As %String) As %String
{
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// Creator:Liang Qiang
/// CreatDate:2009-05-12
/// Description:根据科室Rowid取病区Rowid
/// Table:PAC_Ward
/// Input:科室Rowid
/// Ouput:病区Rowid
/// Return:病区Rowid
/// Others:
ClassMethod GetWardDrByCtlocDr(ctlocdr As %String)
{
	q:ctlocdr="" ""
	s warddr=$o(^PAWARD(0,"WARD_LocationDR",ctlocdr,""))
	q $g(warddr)
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTKUTIL","GetRegNoFromWard","",31)
ClassMethod GetRegNoFromWardExecute(ByRef qHandle As %Binary, displocrowid As %String, userlocid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    ;s val=##class(web.DHCSTKUTIL).GetRegNobyEpisodeID(%request.Get("AdmNo")) i val="" s val=%request.Get("RegNo")
    k ^TMP("dhcpha","GetRegno",$j)
    s locdr=$g(%session.Data("LOGON.CTLOCID"))
    q:locdr="" $$$OK
    q:'$d(^PAWARD(0,"WARD_LocationDR",locdr)) $$$OK
    s warddr=$O(^PAWARD(0,"WARD_LocationDR",locdr,""),-1)
    s roomdr=""
    f  s roomdr=$o(^PAADMi("CurrWard",warddr,roomdr)) q:roomdr=""  d
    .s adm=""
    .f  s adm=$o(^PAADMi("CurrWard",warddr,roomdr,adm)) q:adm=""  d
    ..s patid=$p(^PAADM(adm),"^",1)
    ..q:$P(^PAADM(adm),"^",17)'=""
    ..s stopret=..IfHaveStopOrd(adm,displocrowid,userlocid)
    ..q:stopret'=1
    ..s name=$p(^PAPER(patid,"ALL"),"^",1) 
    ..s regno=$p(^PAPER(patid,"PAT",1),"^",1)
    ..s bedid=$p(^PAADM(adm),"^",73) 
    ..i bedid="" d
    ...s bed="等候区"
    ..e  d
    ...s bed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    ..s ^TMP("dhcpha","GetRegno",$j,bed_"||"_adm)=regno_"^"_bed_"^"_name
    s rowflag=""
    f  s rowflag=$o(^TMP("dhcpha","GetRegno",$j,rowflag)) q:rowflag=""  d
    .s str=^TMP("dhcpha","GetRegno",$j,rowflag)
    .s regno=$p(str,"^",1)
    .s bed=$p(str,"^",2)
    .s name=$p(str,"^",3)
    .d OutRowRegNo
    k ^TMP("dhcpha","GetRegno",$j)
	Quit $$$OK
OutRowRegNo
	set Data=$lb(regno,bed,name)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetRegNoFromWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRegNoFromWardExecute ]
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

Query GetRegNoFromWard(displocrowid As %String, userlocid As %String) As %Query(ROWSPEC = "Tregno:%String,Tbed:%String,Tname:%String")
{
}

ClassMethod GetRegNoFromWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRegNoFromWardExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:Liang Qiang
/// CreatDate:2009-08-10
/// Description:退药申请时根据安全组ID获取默认的发药科室
/// Input:安全组ID
/// Ouput:默认的发药科室ID_"^"_科室描述
ClassMethod GetDefaultPhaLoc(grpid As %String) As %String
{
	i $d(^DHCSTPHACONFIG("DefaultPhaLoc","dhcpha",grpid)) d
	.s locid=^DHCSTPHACONFIG("DefaultPhaLoc","dhcpha",grpid)
	i $g(locid)'="" d
	.s locdesc=$p(^CTLOC(locid),"^",2)
	q $g(locid)_"^"_$g(locdesc)
}

ClassMethod ArcAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ArcAliasExecute(ByRef qHandle As %Binary, ArcAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//实现；
	q:InciAlias="" $$$OK 
	s cnt=##class(web.DHCSTITMDESC).FindItmByStkGrp(InciAlias,"","")
	q:cnt<1 ""
	f i=1:1:cnt  d 
	. s INCI=##class(web.DHCSTITMDESC).ListItms(i)
	. d OutPutRowArcAlias
	d ##class(web.DHCSTITMDESC).kTmpOutPut()
	Quit $$$OK
	
OutPutRowArcAlias
	s incirowid=$p(INCI,"^",1)
	s incicode=$p(INCI,"^",2)
	s incidesc=$p(INCI,"^",3)
	set Data=$lb(incidesc,incicode,incirowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod ArcAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcAliasExecute ]
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

Query ArcAlias(ArcAlias As %String) As %Query(ROWSPEC = "ArcDesc:%String,ArcCode:%String,ArcRowid:%String")
{
}

ClassMethod ArcItmAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArcItmAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ArcItmAliasExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//
	q:Desc="" $$$OK 
	s num=1
	&sql(declare calias cursor for select alias_arcim_dr->arcim_code,alias_arcim_dr->ARCIM_Desc, alias_arcim_dr from arc_alias where %ALPHAUP(alias_text) %STARTSWITH %ALPHAUP(:Desc))
	&sql(open calias)
	f   &sql(fetch calias into :arccode(num),:arcdesc(num),:arcrowid(num))  q:SQLCODE  d
	. d OutPutRowArcItmAlias
	. s num=num+1
	&sql(close calias)
	Quit $$$OK
	
OutPutRowArcItmAlias
	s adesc=arcdesc(num)
	s code=arccode(num)
	s rowid=arcrowid(num)
	set Data=$lb(adesc,code,rowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

ClassMethod ArcItmAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArcItmAliasExecute ]
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

Query ArcItmAlias(Desc As %String) As %Query(ROWSPEC = "ArcDesc:%String,ArcCode:%String,ArcRowid:%String")
{
}

/// Description:获取发药人
/// Input:安全组ID
/// Output:发药人串,以"!!"间隔
/// Creator:Liang Qiang
/// CreatDate:2010-05-05
/// 20160302,yunhaibao,增加科室参数,当科室不为空时按科室获取
/// w ##class(web.DHCSTKUTIL).GetDispUser(38)
ClassMethod GetDispUser(grp As %String, locrowid As %String = "") As %String
{
	s str=""
	i grp'="" d
	.s ssusr=""
	.f  s ssusr=$o(^SSU("SSUSR",0,"Group",grp,ssusr)) q:ssusr=""  d
	..s name=$p(^SSU("SSUSR",ssusr),"^",2)
	..i str="" d
	...s str= name_"^"_ ssusr
	..e  d
	...s str= str_"!!"_name_"^"_ ssusr
	i locrowid'="" d
	.s str=""
	.s result=##class(%Library.ResultSet).%New("web.DHCSTKUTIL:LocUser2") 
    .s sc=result.Execute(locrowid)
    .d getlocuser2
    q str
getlocuser2
	While(result.Next())
	{ 
		s usercode=result.%GetData(2)
		s username=result.%GetData(1)
		s userid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usercode),""))
		i str="" s str=username_"^"_userid
		e  s str=str_"!!"_username_"^"_userid
	 }
}

/// 
/// Create by :zhwh 
/// Date : 2010.12.07 
/// Description:
///  去掉字符串前的拼音: 若字符串中出现"-",则判断"-"之前的字符串是否全由字母(拼音)组成,若"是"则予以剔除
/// note:此功能并非十分完善,请小心使用:比如字符串中的确包含"-",而"-"前并非拼音的情况
ClassMethod noPrefix(desc, chars)
{
 s desc1=$P(desc,chars,1)
 q:desc1="" desc
 s len=$l(desc1)
 //判断desc1是否全为alpha
 s rest=desc
 i $tr(desc1,"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")="" d
 .s rest=$e(desc,len+2,$l(desc))
 q $g(rest)
}

/// Description:验证用户
/// Arguments :
/// rowid - SS_User
/// userpass - 密码
/// Create By :zhwh
/// Create Date:2010-12-02
ClassMethod ValidateUser2(rowid As %String, userpass As %String) As %String
{
	q:rowid="" -10
	s usercode=$P(^SSU("SSUSR",rowid),"^",1)
	q:usercode="" -91
	q ..ValidateUser(usercode,userpass)
}

/// Description:取一个安全组的用户
///     Creater:zhwh		 
///  CreateDate:20101201
///       Input:安全组- Grp	 
///      Return:用户集(rowid,UserId,UserName)	 
Query GrpUser(GrpId As %String) As %Query(ROWSPEC = "rowid:%String,UserId:%String,UserName:%String")
{
}

ClassMethod GrpUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GrpUserExecute ]
{
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

ClassMethod GrpUserExecute(ByRef qHandle As %Binary, GrpId As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    
    &sql(declare groupUserList cursor for 
    	select ssusr_rowid,ssusr_initials,ssusr_name From ss_user where ssusr_group= :GrpId 
    		union
		select distinct othll_parref,othll_parref->ssusr_initials,othll_parref->ssusr_name from SS_UserOtherLogonLoc
			where othll_usergroup_dr=:GrpId order by  ssusr_initials)
	&sql(open groupUserList)
	f  &sql(fetch groupUserList into :rowid,:UserId,:UserName) q:SQLCODE  d
	.
	.//i $ZCVT(UserId,"U")["BM" q
	.
	.d OutPutRowGrpUserList
    &sql(close groupUserList)
    Set qHandle=$lb(0,repid,0)
    q $$$OK
OutPutRowGrpUserList
	set Data=$lb(rowid,UserId,UserName)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GrpUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GrpUserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 根据登陆安全组设置：药房组只取登陆安全组，非药房组取全部发药科室

Query GroupLocAnyWay(group As %String, input As %String) As %Query(ROWSPEC = "Tward:%String,TwardID:%String")
{
}

ClassMethod GroupLocAnyWayExecute(ByRef qHandle As %Binary, group As %String, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1    
    k ^TMP($j,"Locdispldr")
    s locd=$p(^CTLOC(%session.Data("LOGON.CTLOCID")),"^",13)
    i locd="D" d
    .&sql(declare curb cursor for  select st_ctloc_dr->ctloc_desc,st_ctloc_dr  From ss_groupstocklocations 
    where st_parref=:group and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH %ALPHAUP(:input) order by st_ctloc_dr->ctloc_desc )
    .&sql(open curb) 
    .f   &sql(fetch curb into :locdesc,:locdr) q:SQLCODE  d
    ..s ^TMP($j,"Locdispldr",locdr)=locdr_"^"_locdesc
    .&sql(close curb)
    e  d
    .&sql(declare curb1 cursor for  select st_ctloc_dr->ctloc_desc,st_ctloc_dr  From ss_groupstocklocations 
    where st_ctloc_dr->CTLOC_Type='D' and %ALPHAUP(st_ctloc_dr->ctloc_desc) %STARTSWITH %ALPHAUP(:input) order by st_ctloc_dr->ctloc_desc )
    .&sql(open curb1) 
    .f   &sql(fetch curb1 into :locdesc,:locdr) q:SQLCODE  d
    ..s ^TMP($j,"Locdispldr",locdr)=locdr_"^"_locdesc
    .&sql(close curb1)
    s locdrsub=""
    s locdesc="",locdr=""
    f  s locdrsub=$o(^TMP($j,"Locdispldr",locdr)) q:locdrsub=""  d
    .s locdesc=$P(^TMP($j,"Locdispldr",locdrsub),"^",2)
    .s locdr=$P(^TMP($j,"Locdispldr",locdrsub),"^",1)
    .d Build
    k ^TMP($j,"Locdispldr")
  	Quit $$$OK

Build
	set Data=$lb(locdesc,locdr)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GroupLocAnyWayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupLocAnyWayExecute ]
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

ClassMethod GroupLocAnyWayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupLocAnyWayExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 根据登陆科室获取病区

Query GroupWardAnyWay(input As %String) As %Query(ROWSPEC = "Tward:%String,TwardID:%String")
{
}

ClassMethod GroupWardAnyWayExecute(ByRef qHandle As %Binary, input As %String) As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1    
    k ^TMP($j,"Warddispldr")
    s locdrr=%session.Data("LOGON.CTLOCID")
    s locd=$p(^CTLOC(%session.Data("LOGON.CTLOCID")),"^",13)
    i locd="D" d
    .&sql(declare curbward cursor for SELECT ward_desc,ward_rowid FROM  pac_ward where %ALPHAUP(ward_desc) %STARTSWITH %ALPHAUP(:input))
    .&sql(open curbward) 
    .f   &sql(fetch curbward into :locdesc,:locdr) q:SQLCODE  d
    ..s ^TMP($j,"Warddispldr",locdr)=locdr_"^"_locdesc
    .&sql(close curbward)
    e  d
    .&sql(declare curbward1 cursor for  SELECT ward_desc,ward_rowid FROM  pac_ward where %ALPHAUP(ward_desc) %STARTSWITH %ALPHAUP(:input) and WARD_LocationDR->ctloc_rowid=:locdrr)
    .&sql(open curbward1) 
    .f   &sql(fetch curbward1 into :locdesc,:locdr) q:SQLCODE  d
    ..s ^TMP($j,"Warddispldr",locdr)=locdr_"^"_locdesc
    .&sql(close curbward1)
    s locdrsub=""
    s locdesc="",locdr=""
    f  s locdrsub=$o(^TMP($j,"Warddispldr",locdr)) q:locdrsub=""  d
    .s locdesc=$P(^TMP($j,"Warddispldr",locdrsub),"^",2)
    .s locdr=$P(^TMP($j,"Warddispldr",locdrsub),"^",1)
    .d BuildWard
    k ^TMP($j,"Warddispldr")
  	Quit $$$OK

BuildWard
	set Data=$lb(locdesc,locdr)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GroupWardAnyWayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GroupWardAnyWayExecute ]
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

ClassMethod GroupWardAnyWayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GroupWardAnyWayExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// liang qiang 2010-11-22
ClassMethod GetWardForUser(loc)
{
 ///如果登录科室到是病区则返回空，如果病区返回用户病区
  s loctype=$p(^CTLOC(loc),"^",13)
  i loctype="D" q ""
  s wardString=..GetUserWardId(loc)
  q wardString
}

/// liang qiang 2010-11-22
ClassMethod GetUserWardId(loc)
{
 ///获得用户病区
  q:'$d(^PAWARD(0,"WARD_LocationDR",loc)) ""
  s wardid=$O(^PAWARD(0,"WARD_LocationDR",loc,""),-1)
  s warddesc=$p(^PAWARD(wardid),"^",2)
  q warddesc_"^"_wardid
}

ClassMethod QueryManGroupClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = QueryManGroupExecute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod QueryManGroupExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "") As %Status
{
  	Set repid=$I(^CacheTemp)
	s ind=1
	s mangrp="0"
	f  s mangrp=$o(^DHCLMG(0,"LOC",ctloc,mangrp)) q:(mangrp="")!(mangrp="0")  d
	  .s phcatdesc=""
	  .s phcatdesc=$p(^DHCLMG(mangrp),"^",3)
	  .set Data=$lb(phcatdesc,mangrp)
	  .Set ^CacheTemp(repid,ind)=Data
	  .Set ind=ind+1
 	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryManGroupFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryManGroupExecute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query QueryManGroup(ctloc As %String) As %Query(ROWSPEC = "ManGroupDesc:%String,ManGroupId:%String")
{
}

/// Description:取支配科室串
/// Creator:LiangQiang
ClassMethod GetLeadLocString(locdr As %String) As %String
{
 s lstring=locdr
 s sublocdr=""
 f  s sublocdr=$O(^DHCDLOC(0,"LEAD",locdr,sublocdr)) q:sublocdr=""  d
 .s subdr=$p(^DHCDLOC(sublocdr),"^",2)
 .i lstring="" d
 ..s lstring=subdr 
 .e  d
 ..s lstring=lstring_"^"_subdr
 q:lstring="" locdr
 q lstring
}

/// 获取发药取批次库存的计数器
ClassMethod GetInclbCounter() As %String
{
	q $I(^DHCSTPHARMACY("INCLB"))
}

ClassMethod GetOutDispCounter() As %String
{
    q $I(^DHCSTPHARMACY("OUTDISP"))
}

ClassMethod GetOutStatCounter() As %String
{
    q $I(^DHCSTPHARMACY("OUTSTAT"))
}

ClassMethod GetOutWinNoCounter() As %String
{
    q $I(^DHCSTPHARMACY("OUTSTAT"))
}

Query GetDispLocGroup(inputs As %String) As %SQLQuery(CONTAINID = 1)
{
     SELECT ctloc_desc,ctloc_rowid FROM ct_loc
	 where ctloc_type in ('D') and ((%ALPHAUP(ctloc_desc) %STARTSWITH %ALPHAUP(:inputs)) or (%ALPHAUP(ctloc_ContactName) %STARTSWITH %ALPHAUP(:inputs)))
}

Query GetPriority(inputs As %String) As %SQLQuery(CONTAINID = 1)
{
     SELECT OECPR_Desc,OECPR_Code,OECPR_RowId FROM OEC_Priority
	 where   (%ALPHAUP(OECPR_Desc) %STARTSWITH %ALPHAUP(:inputs))
}

ClassMethod PhaLocDispTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PhaLocDispTypeExecute ]
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

ClassMethod PhaLocDispTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PhaLocDispTypeExecute ]
{
	
   Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod PhaLocDispTypeExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
	 
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:loc="" $$$OK
	s ret=""
	s plid=$o(^DHCPL(0,"Loc",loc,"")) q:plid="" ""
	s chl=""
	f  s chl=$o(^DHCPL(plid,"DIS",chl)) q:chl=""  d
	.s disptype=$p(^DHCPL(plid,"DIS",chl),"^",1)
	.s defaultflag=$p(^DHCPL(plid,"DIS",chl),"^",5)
	.s typecode=$p(^DHCSTDRUGGRP(disptype),"^",1)
	.s typedesc=$p(^DHCSTDRUGGRP(disptype),"^",2)
	. 
	.d outputrow2
	q $$$OK
outputrow2
 s Data=$lb(typedesc,typecode,disptype)
 s ^CacheTemp(repid,ind)=Data	
 s ind=ind+1
 q
}

Query PhaLocDispType(Parref As %String) As %Query(ROWSPEC = "Ttypedesc:%String,Ttypecode:%String,Tdisptype:%String")
{
}

/// 获取医嘱优先级串
/// Creator:LiangQiang
/// CreatDate:2011-03-18
ClassMethod GetPriorityString() As %String
{
    //OEC_Priority
    s oecstring=""
    s oec=""
    f  s oec=$o(^OECPR(oec)) q:oec=""  d
    .s oecdPri=$p(^OECPR(oec),"^",2)
    .q:oecdPri=""
    .i oecstring="" d
    ..s oecstring=oecdPri_"@"_oec
    .e  d
    ..s oecstring=oecstring_"^"_oecdPri_"@"_oec
    q oecstring
}

/// 是否按医院取售价
/// Creator:LiangQiang
/// CreatDate:2011-08-01
/// Output: 0 -否  1 - 是
ClassMethod GetConfigHospPrice() As %String
{
  	Q 0
  	Q 1
}

/// Descript:	对t+1,t-1等类型的格式化为$H格式
/// Creater:	zhouyg
/// CreateDate:	20101201
/// Input:		dateExpress
/// Return:		+$h格式
ClassMethod GetDah(dateExpress As %String) As %String
{
	q:dateExpress="" ""
	s dateExpress=$tr(dateExpress,$c(13,10))
	s dateExpress=$tr(dateExpress," ")
	s dateExpress=$ZCVT(dateExpress,"u")
	s flag="T" ;
	i flag=dateExpress q +$h
	i $p(dateExpress,flag,1)'="" d
	.s dd=""
	e  d
	.s dateOffset=$p(dateExpress,flag,2)
	.q:dateOffset=""
	.s op=$e(dateOffset)  ; fhe first char
	.s cnt=$e(dateOffset,2,$l(dateOffset))
	.s dd=""
	.i op="+" d
	.. s dd=+$h+cnt
	.i op="-"  d
	.. s dd=+$h-cnt
	i $g(dd)>0 q dd
	q ""
}

/// Descript:	根据医嘱项ID取得药品发药类别
/// Creater:	LiangQiang
/// CreateDate:	20111014
/// Input:		医嘱项目ID
/// Return:     药品发药类别ID
ClassMethod GetDispCatByArc(Arc) As %String
{
    s catcode=$p(^ARC("IC",Arc),"^",1)  
    s CATCODE=$$ALPHAUP^SSUTIL4(catcode)
    s ordcatdr=$o(^ARC("IC",0,"Code",CATCODE,"")) q:ordcatdr="" ""
    s SDG=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,"")) q:SDG="" ""
    q SDG
}

/// Creator:Liang Qiang
/// CreatDate:2010-09-27
/// 剂量的单位转换成基本单位 
/// Input:医嘱rowid
/// Output:基本单位剂量
ClassMethod GetBuomDosage(oeori As %String) As %String
{
	S ord=$p(oeori,"||",1) Q:ord="" ""
	S itm=$p(oeori,"||",2) Q:itm="" ""
	Q:'$D(^OEORD(ord,"I",itm,1)) ""
	S dosqty=$P(^OEORD(ord,"I",itm,2),"^",1) //剂量
	S DosUnit=$p(^OEORD(ord,"I",itm,2),"^",3)
	q:DosUnit="" ""
	S DosUom=""
	I $D(^CT("UOM",DosUnit)) S DosUom=$P(^CT("UOM",DosUnit),"^",2)
	Q:DosUom="" ""
	//Q:DosUom="ml" ""
	;Q dosqty_"^"_DosUom
	S arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
	S arcimm=$P(arcim,"||",1)
	Q:arcimm="" ""
	S arcims=$P(arcim,"||",2)
	Q:arcims="" ""
	S incidr=$O(^INCI(0,"ARCIM_DR",arcimm,""))
	Q:incidr="" ""
	Q:'$D(^INCI(incidr,1)) ""
	Q:'$D(^INCI(incidr,3)) ""
	S buom=$P(^INCI(incidr,1),"^",10)
	S puom=$P(^INCI(incidr,3),"^",6)
	;Q:DosUnit=buom 1
	;Q:DosUnit=puom 1
	Q:'$D(^ARCIM(arcimm,arcims,1)) ""
	S phcdf=$P(^ARCIM(arcimm,arcims,1),"^",12)
	S phc=$P(phcdf,"||",1)
	Q:phc="" 0
	S formsub=$P(phcdf,"||",2)
	Q:formsub="" ""
	s otherqty=0
	s eqsub="0"
	f  s eqsub=$O(^PHCD(phc,"DF",formsub,"EQ",eqsub)) q:eqsub=""  d
	.S equomdr=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",1)
	.s equom=$P(^CT("UOM",equomdr),"^",2)
	.s eqqty=$P(^PHCD(phc,"DF",formsub,"EQ",eqsub),"^",2) //等效数量
	.//i equom="ml"  d
	.//.s mlqty=eqqty
	.i equom=DosUom d
	..s otherqty=eqqty
	..
	q otherqty
}

/// Creator:Liang Qiang
/// CreatDate:2011-11-16
/// Description:获取出院带药药房医嘱审核标志,出院带药大输液默认为已审  计费站用，勿动
/// Input:医嘱rowid
/// Output:是否审核 0 - 否  1 - 是
ClassMethod GetDrugAuditFlag(oeori As %String) As %String
{
	q:oeori="" 0
	s ord=$p(oeori,"||",1)
	s chl=$p(oeori,"||",2)
	s priority=$p(^OEORD(ord,"I",chl,1),"^",8)
	q:priority="" 1
	s priority=$p(^OECPR(priority),"^",1)
	q:priority'="OUT" 1
	s arcimid=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
    s arccatid=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",10)        ;医嘱子类RowId
    s catcode=$p(^ARC("IC",arccatid),"^",1)                        ;医嘱子类代码
    s cat=##class(web.DHCSTPCHCOLLS).GetCat(catcode)
    q:cat="DSY" 1
	s flag=$p(^OEORD(ord,"I",chl,7),"^",3)
	q:flag="" 0
	q 1
}

/// 根据医嘱ID获取就诊ID
ClassMethod GetAdmByOeori(oeori As %String) As %String
{
	s ord=+oeori
	q:ord'>0 ""
	s adm=$p( ^OEORD(ord),"^",1)
	q adm
}

/// 非安全组关联的第一个科室
ClassMethod GetFristLocationLoc(loc, grp As %String) As %String
{
	s loctype=$p(^CTLOC(loc),"^",13)
    i loctype="D" q ""
	s stchl=0
	s stchl=$o(^SSU("SSGRP",grp,"ST",0)) 
	q:stchl=0 ""
	q:stchl="" ""
	s locdr=$p(^SSU("SSGRP",grp,"ST",stchl),"^",1)
	s locdesc=$p(^CTLOC(locdr),"^",2)
	q locdesc_"^"_locdr
}

/// 获取药品类别是否口服  0 不是 1 是  医生站用，勿动
ClassMethod GetDrugCat(orditm As %String) As %String
{
  s ret=##class(web.DHCSTINTERFACE).GetDrugCatByOrd(orditm,"KFBY")
  q ret
}

/// 获取年龄数字
/// Update:20150129 添加参数Adm
ClassMethod GetAgeNum(papmidr As %String, Adm As %String = "") As %String
{
	 //s age=##class(web.DHCBillInterface).GetPapmiAge(papmidr,Adm)
	 
	 s ageYears=0
	 s argBirthday=$p(^PAPER(papmidr,"ALL"),"^",6)
	 q:(+argBirthday=0) 0
	 q:(+papmidr=0) 0
	 s argAdmDate=0
	 i Adm'="" s argAdmDate=+$p($g(^PAADM(Adm)),"^",6)
	 i argAdmDate=0 s argAdmDate=$p($h,",",1)
	 s tmpAge="",ageYears=0,ageMonths=0,ageDays=0,age=""
	 s tmpAge=$$CalAge^at182(argBirthday,argAdmDate)
	 i (tmpAge'="")&&($l(tmpAge,"|")'<14) d
	 .s ageYears=$p(tmpAge,"|",12)
	 .s ageMonths=$p(tmpAge,"|",13)
	 .s ageDays=$p(tmpAge,"|",14)
	 q ageYears
}

/// Description：	中途结算是否发药
/// CreateDate：	2012-12-27	
/// Creater：		zhouyg
/// Retrun：		1-可以发药,0-不能发药
ClassMethod IfDspForPaid(oeori As %String) As %String
{
	s RetFlag=0
	Q:oeori="" RetFlag
	S ord=$p(oeori,"||",1) Q:ord="" RetFlag
	S itm=$p(oeori,"||",2) Q:itm="" RetFlag
	Q:'$D(^OEORD(ord,"I",itm,1)) RetFlag
	s ArcimId=$p(^OEORD(ord,"I",itm,1),"^",2)
	q:ArcimId="" RetFlag
	s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)
	i ##class(websys.Conversions).IsValidMethodName("web.DHCSTCOMMONSRV","GetFeePoint")=1 d
	.s feepoint=##Class(web.DHCSTCOMMONSRV).GetFeePoint(ArcCatId)
	e  d
	.s feepoint=##Class(web.DHCSTPCHCOLLS2).GetFeePoint(ArcCatId)
	S Billed=$P(^OEORD(ord,"I",itm,3),"^",5)
	i Billed="P" d
	.i feepoint=1 d
	..s RetFlag=0
	.e  d
	..s RetFlag=1
	e  d
	.s RetFlag=1
	q RetFlag
}

/// Description：	中途结算是否退药
/// CreateDate：	2013-01-29	
/// Creater：		zhouyg
/// Retrun：		1-可以退药,0-不能退药
ClassMethod IfRetForPaid(oeori As %String) As %String
{
	s RetFlag=0
	Q:oeori="" RetFlag
	S ord=$p(oeori,"||",1) Q:ord="" RetFlag
	S itm=$p(oeori,"||",2) Q:itm="" RetFlag
	Q:'$D(^OEORD(ord,"I",itm,1)) RetFlag	
	S Billed=$P(^OEORD(ord,"I",itm,3),"^",5)
	i Billed="P" d
	.s RetFlag=0
	e  d
	.s RetFlag=1
	q RetFlag
}

ClassMethod LocUser2Execute(ByRef qHandle As %Binary, Locid As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s ret=""
 set myrowid=0
 for  s myrowid=$o(^SSU("SSUSR",myrowid)) q:myrowid=""  d
 .s ctloctype="",usecode="",usename="",useid=""
 .s tr=0,loc=""
 .s loc=+$p(^SSU("SSUSR",myrowid),"^",4)
 .i Locid=loc s tr=tr+1
 .i tr=0  d
 ..	s othusr="0",th=0
 ..f  s othusr=$o(^SSU("SSUSR",myrowid,"OTHLL",othusr)) q:(othusr="")!(othusr="0")  d
   ...s othloc="",CTDesc=""
   ...s othloc=+$p(^SSU("SSUSR",myrowid,"OTHLL",othusr),"^",1)
   ...s ctloctype=""
   ...s ctloctype=$p(^CTLOC(othloc),"^",13)
   ...q:ctloctype'["D"
   ...q:othloc'=Locid
   ...s tr=tr+1
 .q:tr=0
 .s usecode=$p(^SSU("SSUSR",myrowid),"^",1)
 .s usename=$p(^SSU("SSUSR",myrowid),"^",2)
 .s useid=myrowid
 .d outputrow3
 q $$$OK
outputrow3
 s Data=$lb(usename,usecode)
 s ^CacheTemp(repid,ind)=Data	
 s ind=ind+1
 q
}

ClassMethod LocUser2Fetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocUser2Execute ]
{

 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

ClassMethod LocUser2Close(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LocUser2Execute ]
{
 // Clean up by purging the temporary node in ^CacheTemp global
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

Query LocUser2(Locid As %String) As %Query(ROWSPEC = "TFyName:%String,TFyCode:%String")
{
}

ClassMethod IfHaveStopOrd(adm, disploc, userlocdr) As %String
{
	s ret=0
	s userid=$g(%session.Data("LOGON.USERID"))
	//s visitstatus=$p(^PAADM(adm),"^",20)
	//q:visitstatus="D" 0    //已经出院结算
	s visitstatus=##Class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)	//20160310 标准版开发
	q:visitstatus=0 0
	s ord=$o(^OEORD(0,"Adm",adm,"")) q:ord="" 0
	s itm=0 
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d 
	. q:'$d(^OEORD(ord,"I",itm,2))
	. s recdepdr=$p(^OEORD(ord,"I",itm,3),"^",6)
	. s prescno=$p(^OEORD(ord,"I",itm,1),"^",14)
	. q:(disploc'="")&&(recdepdr'=disploc)
	. s orditemrowid=ord_"||"_itm
	. s dspid=""
	. f  s dspid=$o(^DHCOEDISQTY(0,"OEORI",orditemrowid,dspid)) q:dspid=""  d
	. .s status=$p(^DHCOEDISQTY(dspid),"^",7)   		;配药记录状态
	. .q:status'="C"                          		;未发药不需要退药
	. .s phaci=$p(^DHCOEDISQTY(dspid),"^",14)   		;发药子表id
	. .q:phaci="" 
	. .s ordexerowid=$p(^DHCOEDISQTY(dspid),"^",3) 
	. .s ore=$p(ordexerowid,"||",3)
	. .q:ore=""
	. .s OreStatusDr=$p(^OEORD(ord,"I",itm,"X",ore),"^",16)  ;护士执行状态
	. .q:OreStatusDr=""      						;停止执行记录可申请退药
	. .s AdminStatus=$p(^OEC("STAT",OreStatusDr),"^",1)  
	. .q:(AdminStatus'="D")
	. .s dspqty1=$p(^DHCOEDISQTY(dspid),"^",11) 
	. .s returnedqty=##class(web.DHCSTPHARETURN).ReturnedQtyByDodis(dspid)   ;已退数量
	. .s reqedqty=##Class(web.DHCSTRETREQUEST).GetReqQtyByDodis(dspid)       ;已申请未退数量
	. .q:(dspqty1-returnedqty-reqedqty)'>0   //发药已全退
	. .s CpType=##Class(web.DHCSTRETREQUEST).GetSSUserType(userid)
	. .i CpType["DOC" s locrowid=##Class(web.DHCSTKUTIL).UserDept(orditemrowid)
	. .s config=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_ReqWard") //获取设置
	. .q:($g(locrowid)'="")&(userlocdr'="")&($g(locrowid)'=userlocdr)&(config=1)   ;不是在当前病区领的药，不允许在此病区申请退药  
	. .S ret=1
	q ret
}

Query LocUser3(Locid As %String) As %SQLQuery(CONTAINID = 1)
{
	select DISTINCT OTHLL_ParRef->SSUSR_Name,OTHLL_ParRef->SSUSR_Initials from SS_UserOtherLogonLoc where OTHLL_CTLOC_DR=:Locid or OTHLL_ParRef->SSUSR_DefaultDept_DR =:Locid
}

/// Description：	中途结算是否退药
/// CreateDate：	2014-01-06	
/// Creater：		zhouxin
/// Retrun：		1-可以退药,0-不能退药
ClassMethod IfRetForPaidNew(exec As %String) As %String
{
	s RetFlag=0
	Q:exec="" RetFlag
	S ord=$p(exec,"||",1) Q:ord="" RetFlag
	S itm=$p(exec,"||",2) Q:itm="" RetFlag
	S exc=$p(exec,"||",3) Q:exc="" RetFlag
	Q:'$D(^OEORD(ord,"I",itm,"X",exc)) RetFlag	
	S Billed=$P(^OEORD(ord,"I",itm,"X",exc),"^",6)
	i Billed="P" d
	.s RetFlag=0
	e  d
	.s RetFlag=1
	q RetFlag
}

/// Description：	医嘱禁忌审核结果
/// CreateDate：	2014-02-13	
/// Creater：		LiangQiang
/// Retrun：		空-未审核,N-审核不通过,Y-审核通过
/// Update;			入参oeori 改为dspID(dhc_oedispensing的ID),zhouyg 20150108
ClassMethod GetOrdAuditResult(dspID As %String, chkAdmType = "") As %String
{
	q:dspID="" ""
	q:##class(web.DHCSTKUTIL).GetOrdAuditFlag(dspID, chkAdmType)'="Y" "Y"
	s dspData=$g(^DHCOEDISQTY(dspID))
	s oeori=$p(dspData,"^",1)
	s adm=$p(dspData,"^",26)
	s admType=$p(^PAADM(adm),"^",2)
	i admType="E" s oeori = ##class(PHA.COM.Order).GetVirtualLongOeori(oeori) // 虚拟长期医嘱特殊处理
	s ord=$p(oeori,"||",1)
	s itm=$p(oeori,"||",2)
	s result=$p(^OEORD(ord,"I",itm,7),"^",3)
	s result=$p(result,",",4) 
	q:result="" ""
	i result'="SHTG" q "N"
	q "Y"
}

/// Description：	医嘱禁忌审核标志
/// CreateDate：	2014-02-13	
/// Creater：		LiangQiang
/// Retrun：		N-不需审核,Y-需审核
/// Update;			入参oeori 改为dspID(dhc_oedispensing的ID),zhouyg 20150108
/// 如果为首日医嘱且次日医嘱与首日接收科室不同时,首日医嘱不需审核
/// w ##class(web.DHCSTKUTIL).GetOrdAuditFlag(6665)
ClassMethod GetOrdAuditFlag(dspID As %String, chkAdmType = "") As %String
{
	q:(dspID = "") ""
	s dspData = $g(^DHCOEDISQTY(dspID))
    s reclocdr = $p(dspData, "^", 24)
    q:reclocdr="" ""
	s oeori=$p(dspData,"^",1)
	s userdeptdr=+$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),7)),"^",2) 
    s dspOeori=$p(dspData,"^",1)
    s firstdsp=$o(^DHCOEDISQTY(0,"OEORI",dspOeori,""))
    s firstDspData=$g(^DHCOEDISQTY(firstdsp))
    s firstrecdep=$p(firstDspData,"^",24)
    s firstcat=$p(firstDspData,"^",27)
    s lastdspid="",lastdsp=""
    f  s lastdspid=$o(^DHCOEDISQTY(0,"OEORI",dspOeori,lastdspid),-1) q:(lastdspid="")||(lastdsp'="")  d
    .s laststatus=$p($g(^DHCOEDISQTY(lastdspid)),"^",7)
    .q:laststatus="R"
    .s lastdsp=lastdspid
    s lastDspData=$g(^DHCOEDISQTY(lastdsp))
    s lastrecdep=$p(lastDspData,"^",24)
    s lastcat=$p(lastDspData,"^",27)
    q:(firstcat'=0)&&(lastcat=0)&&(firstrecdep'=lastrecdep)&&(reclocdr'=lastrecdep) "N"
    i chkAdmType = "" s chkAdmType = $p(^PAADM($p(dspData,"^",26)), "^",2)
    s dispWay = $lg(##class(PHA.IP.COM.Method).GetOrderDispWay(oeori), 1)
    if (dispWay = "BASEDISP"){
	    s hosp = $p(^CTLOC(reclocdr), "^", 22)
		s psBaseMedNeedPhaAudit = ##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTCOMMON", "BaseMedNeedPhaAudit", "^^^" _ hosp)
		q:(psBaseMedNeedPhaAudit '= "Y") "N"
		q:(psBaseMedNeedPhaAudit = "Y") "Y"
	}
    s needAuditFlag = ##class(PHA.PRA.Com.Method).IsLocNeedAudit(chkAdmType, reclocdr, userdeptdr)
    q:(needAuditFlag = $$$YES) "Y"
    q "N"
}

/// Creator : MYQ
/// CreatDate : 20140527
/// Function : 根据用药频次Id取用药时间，同仁医院需求
/// w ##class(web.DHCSTKUTIL).GetFreqTimeByFreq("2") 
ClassMethod GetFreqTimeByFreq(freqRowid As %String) As %String
{
 q:freqRowid="" ""
 s FreqTime=""
 s Phcdtch=0
 f  s Phcdtch=$o(^PHCFR(freqRowid,"DT",Phcdtch)) q:Phcdtch=""  d
 .s PhcdTime=""
 .s PhcdTime=$p(^PHCFR(freqRowid,"DT",Phcdtch),"^",1)
 .s:PhcdTime'="" PhcdTime=$zt(PhcdTime,1)
 .s PhcdTimeH=$p(PhcdTime,":",1)
 .;s PhcdTimeM=$p(PhcdTime,":",2)
 .;s PhcdTimeS=$p(PhcdTime,":",3)
 .s:(PhcdTimeH'="")&&(PhcdTimeH'["00")&&(FreqTime'="") FreqTime=FreqTime_"-"_(+PhcdTimeH)
 .s:(PhcdTimeH'="")&&(PhcdTimeH'["00")&&(FreqTime="") FreqTime=(+PhcdTimeH)
 q FreqTime
}

// Query GetDrugGroup() As %SQLQuery(CONTAINID = 1) [ SqlProc ]

// {

// select SDG_Desc,SDG_RowId,SDG_Code from DHCStkDrugGroup

// }

ClassMethod GetDrugGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDrugGroupExecute(ByRef qHandle As %Binary, HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
 	;
 	&sql(declare xxxx cursor for select SDG_Desc,SDG_RowId,SDG_Code into :Desc,:Rowid,:Code from DHCStkDrugGroup
	 )
	&sql(open xxxx)
	f  &sql(fetch xxxx into :Desc,:Rowid,:Code)  q:SQLCODE  d 
	.q:(HOSPID'="")&&(##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HOSPID)="N")
	. d OutputDispStatItmtmp2
	&sql(close xxxx)
 	s Desc="全部"
 	s Rowid="全部"
 	s Code="全部"
 	d OutputDispStatItmtmp2
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputDispStatItmtmp2
	s Data=$lb(Desc,Rowid,Code)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetDrugGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugGroupExecute ]
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

Query GetDrugGroup(HOSPID As %String = "") As %Query(ROWSPEC = "发药类别描述:%String,发药类别ID:%String,发药类别代码:%String") [ SqlProc ]
{
}

/// creator:wyx
/// date:2014-12-08
/// description: 科室组
/// input:  科室组类型,科室组名称
/// others:
Query GetLocGroupQuery(Type As %String, LocGrpDesc As %String, DispLocID As %String = "") As %SQLQuery(CONTAINID = 1)
{
 
  select SLG_Desc as Description,SLG_RowId as Rowid from DHC_StkLocGroup where %ALPHAUP(SLG_Type) = %ALPHAUP(:Type) and SLG_Loc_DR=:DispLocID and %ALPHAUP(SLG_Desc) %STARTSWITH %ALPHAUP(:LocGrpDesc)
}

/// 临床科室(CTLOC_Type:"W","OP","E")
/// d ##class(%ResultSet).RunQuery("web.DHCSTKUTIL","ClinicLoc","fs")
Query ClinicLoc(inputs As %String) As %SQLQuery(CONTAINID = 1)
{
     SELECT ctloc_desc,ctloc_rowid FROM ct_loc
	 where ctloc_type in ('W','OP','E') and (%ALPHAUP(CTLOC_ContactName) %STARTSWITH %ALPHAUP(:inputs))
}

/// Description:根据库存项ID取基本单位规格,最小发药单位的规格
/// Creater:		zhouyg
/// CreateDate:	20101124
/// Input:		inci-Inc_itm的ID
/// Return:		规格描述
ClassMethod GetInciSpecB(inci As %String) As %String
{
	S phcdf=##Class(web.DHCSTCOMINC).GetPhcdf(inci)
	Q:phcdf="" ""
	S RetSpec=..GetSpecB(phcdf)
	Q RetSpec
}

/// Description:根据药学项ID取基本单位规格,最小发药单位的规格
/// Creater:		zhouyg
/// CreateDate:	20101124
/// Input:		phc-PHC_DrgForm的ID
/// Return:		规格描述
ClassMethod GetSpecB(phcdf As %String) As %String
{
	S bUomDesc="",eqUomDesc=""
	S phcd=$P(phcdf,"||",1)
	S formsub=$P(phcdf,"||",2)
	Q:(phcd="")!(formsub="") ""
	S UomDr=$p(^PHCD(phcd,"DF",formsub,2),"^",4)
	I UomDr'="" D
	.S bUomDesc=$P($G(^CT("UOM",UomDr)),"^",2)
	S bQty=+$p(^PHCD(phcd,"DF",formsub,2),"^",5)
	S eqsub=$O(^PHCD(phcd,"DF",formsub,"EQ","0"))
	Q:eqsub="" ""
	S equomdr=$P(^PHCD(phcd,"DF",formsub,"EQ",eqsub),"^",1)
	I equomdr'="" D
	.S eqUomDesc=$P($G(^CT("UOM",equomdr)),"^",2)
	S eqqty=$P(^PHCD(phcd,"DF",formsub,"EQ",eqsub),"^",2)
	I $P(eqqty,".",1)="" S eqqty="0"_eqqty
	I bQty=1 S bQty=""
	I eqUomDesc=bUomDesc D
	.S RetSpec=bUomDesc
	E  D
	.S RetSpec=eqqty_eqUomDesc_"/"_bQty_bUomDesc
	Q RetSpec
}

ClassMethod GetHospName(hopid As %Library.String = "") As %String
{
	s ret=$p($g(^CT("HOSP",+hopid)),"^",2)
	q $g(ret)
}

/// creator:    yunhaibao
/// createdate: 20170223
/// description:返回公共规则的pid,应用于查询统计
/// 			因异常关闭等情况,通常导致一些临时global不得清除,故pid前拼日期
/// input:		classname:类名(exp:web.DHCSTKUTIL)
/// 			classtype:产品类型(OP-门诊药房,IP-住院药房,ST:药库,PIVA:静配,CNT:处方点评)
/// 			w ##class(web.DHCSTKUTIL).NewPid("web.DHCSTKUTIL","OP")
ClassMethod NewPid(classname As %String, classtype As %String) As %String
{
	s newpid=""
	i classtype="OP" s newpid=$i(^DHCSTOUTPH(classname))
	e  i classtype="IP" s newpid=$i(^DHCSTPHARMACY(classname))
	e  i classtype="PIVA" s newpid=$i(^DHCSTPIVA(classname))
	e  i classtype="ST" s newpid=$i(^DHCST(classname))
	e  i classtype="CNT" s newpid=$i(^DHCSTCOMMENTS(classname))
	e  s newpid=$j
	q "D"_$zd(+$h,8)_"P"_newpid
}

/// 判断IE版本,用于加载不同界面,非IE算IE11
ClassMethod GetIEVersion()
{
	;Mozilla/4.0 (compatible; MSIE 6.0;
	;Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64;Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET4.0C; .NET4.0E; .NET CLR 3.5.30729;.NET CLR 3.0.30729)"
	;Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0)like Gecko
	Set UserAgent = $G(%request.CgiEnvs("HTTP_USER_AGENT"))
	;s UserAgent1=$G(%request.Application) //这个不好用
	Set IEVersion="11"
	if UserAgent["Mozilla/4.0 (compatible; MSIE 6.0;" {
		Set IEVersion = "6"
	}elseif UserAgent["Mozilla/4.0 (compatible; MSIE 8.0;" {
		Set IEVersion = "8"
	}elseif UserAgent["Mozilla/4.0 (compatible; MSIE 9.0;" {
		Set IEVersion = "9"
	}
	Quit IEVersion
}

/// Descript:	根据id获取科室信息
/// Creator:    yunhaibao
/// CreateDate: 2017-05-15
/// w ##class(web.DHCSTKUTIL).GetLocInfoByRowId(100)
ClassMethod GetLocInfoByRowId(locrowid)
{
   q:+locrowid=0 ""
   s locdesc=$p($g(^CTLOC(locrowid)),"^",2)
   s loccode=$p($g(^CTLOC(locrowid)),"^",1)
   i locdesc["-" s locdesc=$p(locdesc,"-",2,$l(locdesc,"-"))
   q loccode_"^"_locdesc
}

/// creator:	yunhaibao
/// createdate: 2017-12-14
/// description:截取字符串长度,中文占2,英文占1
/// input:		inputStr-字符串,length-截取长度,start-开始位置
/// w ##class(web.DHCSTKUTIL).SubString("氯化钠(科伦)%123",6)
ClassMethod SubString(inputStr, length, start = 0)
{
	q:inputStr="" ""
	s inputLen=$l(inputStr)
	q:inputLen=0 ""
	s retStr=""
	s retLen=0
	s inputI=""
	f inputI=1:1:inputLen q:retLen>length  d
	.s iStr=$e(inputStr,inputI)
	.s iStrAsc=$ASCII(iStr)
	.s iStrLen=$s(iStrAsc>250:2,1:1)
	.s retLen=retLen+iStrLen
	.q:retLen>length
	.s retStr=$s(retStr="":iStr,1:retStr_iStr)
	q retStr
}

}
