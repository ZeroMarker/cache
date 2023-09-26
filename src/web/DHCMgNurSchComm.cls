/// Hospital：北京协和医院
/// ClassDescripition:新版护理管理部分公共查询方法
Class web.DHCMgNurSchComm Extends %RegisteredObject
{

Query FindWardLoc(HsDr, typ, ward = "", Par = "") As %Query(ROWSPEC = "LocDes,LocDr,SortPos")
{
}

ClassMethod FindWardLocExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	 //s ^TMP("a")=$LB(HsDr,typ)
 	 //d ##Class(%ResultSet).RunQuery("web.DHCMgNurSysComm","FindWardLoc",1,"","pw","")
 	 s ^TEMP("gWardLoc")=HsDr_"%"_typ_"%"_ward_"%"_Par
 	 s typ=$TR($ZConvert(typ,"U")," ","")
 	 s ward=$TR($ZConvert(ward,"U")," ","")
     s tmp=""
     if Par'=""
     {
	    s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseD(Par,"ChildSub",rw)) q:rw=""  d
	    .s a=##class(DHCMGNUR.MgNurseSub).%OpenId(Par_"||"_rw)
	    .s CtLocDr=a.WardLoc
	    .s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	    .q:(ctlocDesc'[ward)&&(ward'="")
	    .s p=rw
	    .d OutputRow8
       	Set qHandle=$lb(0,repid,0)
	    Quit $$$OK

	 }
     if (typ="")
     {
         s ty="" f  s ty=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty)) q:ty=""  d
         .s loc="" f  s loc=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty,loc)) q:loc=""  d
       	 ..s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr,ty,loc,rw)) q:rw=""  d
         ...s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
         ...s CtLocDr=a.WardLoc  
         ...s p=a.SortPos
         ...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
         ...q:(ctlocDesc'[ward)&&(ward'="")
         ...d OutputRow8
         s ty=""

	 }else{
		 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr)) q:CtLocDr=""  d
		 .s rw="" f  s rw=$O(^DHCMGNUR.MgNurWardI("Typ",HsDr," "_typ,CtLocDr,rw)) q:rw=""  d
	 	 ..s a=##class(DHCMGNUR.MgNurWard).%OpenId(rw)
	 	 ..s sort=a.SortPos
	 	 ..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	 ..q:(ctlocDesc'[ward)&&(ward'="")
	 	 ..if '$D(tmp(sort)) s tmp(sort)=ctlocDesc_"^"_CtLocDr
	 	 ..e  s tmp(sort+1)=ctlocDesc_"^"_CtLocDr
	 	 s p=""   f  s p=$O(tmp(p)) q:p=""  d
	 	 .s ctlocDesc=$P(tmp(p),"^"),CtLocDr=$P(tmp(p),"^",2)
	 	 .d OutputRow8
	 }
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr,p)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocExecute ]
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

ClassMethod FindWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// Method Description:保存临时人员信息
/// Date:2015-04-03
ClassMethod SaveInformal(parr As %String) As %String
{
	s ret=""
	s ^TEMP("g20150403001")=parr
	//[P实习]PersonType2|P^rw|^PersonName|name^PersonSexDR|1^PersonDepDR|348^PersonBirthDay|1984-04-01
	//^PersonAdmHosDate|2015-04-01^PersonTelHand|phone^PersonInternAddress|address
	//^PersonInternStDate|2015-04-01^PersonInternEndDate|2015-04-30
	//^PersonInternSchool|school^PersonInternProf|profe^PersonInternClass|class
	//[S进修]PersonType2|S^rw|^PersonName|name^PersonSexDR|1^PersonDepDR|348^PersonBirthDay|1981-01-01
	//^PersonAdmHosDate|2015-04-01^PersonTelHand|phone^PersonInternAddress|address
	//^PersonInternStDate|2015-04-01^PersonInternEndDate|2015-04-30
	//^PersonStudyPref|profe^PersonWorkUnit|unit^PersonWorkDateTime|2015-04-01
	//[W工人]PersonType2|W^rw|^PersonName|name3^PersonSexDR|2^PersonDepDR|351^PersonBirthDay|1988-01-02
	//^PersonAdmHosDate|2015-03-29^PersonTelHand|phone3^PersonInternAddress|address3
	//^PersonInternStDate|2015-03-29^PersonInternEndDate|2015-04-29
	//^PersonWorkDateTime|2015-03-29^PersonGRType|1
	s type2=$P($P(parr,"^",1),"|",2)
	s rw=$P($P(parr,"^",2),"|",2)
	s personid=$ZConvert($P($P(parr,"^",3),"|",2),"U")
	s name=$ZConvert($P($P(parr,"^",4),"|",2),"U")
	s sex=$P($P(parr,"^",5),"|",2)
	s dep=$P($P(parr,"^",6),"|",2)
	s birth=$P($P(parr,"^",7),"|",2)
	s admHosDate=$P($P(parr,"^",8),"|",2)
	s phone=$P($P(parr,"^",9),"|",2)
	s address=$P($P(parr,"^",10),"|",2)
	s stdate=$P($P(parr,"^",11),"|",2)
	s enddate=$P($P(parr,"^",12),"|",2)
	
	i rw="" s obj=##class(DHCMGNUR.MgPersons).%New()
	e  s obj=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	s obj.PersonType2=type2
	s obj.PersonID=personid
	s obj.PersonName=name
	s obj.PersonSexDR=sex
	s obj.PersonDepDR=dep
	i birth'="" s obj.PersonBirthDay=$ZDH(birth,3)
	e  s obj.PersonBirthDay=""
	i admHosDate'="" s obj.PersonAdmHosDate=$ZDH(admHosDate,3)
	e  s obj.PersonAdmHosDate=""
	s obj.PersonTelHand=phone
	s obj.PersonInternAddress=address
	i stdate'="" s obj.PersonInternStDate=$ZDH(stdate,3)
	e  s obj.PersonInternStDate=""
	i enddate'="" s obj.PersonInternEndDate=$ZDH(enddate,3)
	e  s obj.PersonInternEndDate=""
	i type2="P"
	{
		s school=$P($P(parr,"^",13),"|",2)
		s Prof=$P($P(parr,"^",14),"|",2)
		s class=$P($P(parr,"^",15),"|",2)
		s Identity=$P($P(parr,"^",16),"|",2)
		s obj.PersonInternSchool=school
		s obj.PersonInternProf=Prof
		s obj.PersonInternClass=class
		s obj.PersonIdentity=Identity
		
	}
	elseif(type2="S")
	{
		s StudyPref=$P($P(parr,"^",13),"|",2)
		s WorkUnit=$P($P(parr,"^",14),"|",2)
		s WorkDateTime=$P($P(parr,"^",15),"|",2)
		s Identity=$P($P(parr,"^",16),"|",2)
		s obj.PersonStudyPref=StudyPref
		s obj.PersonWorkUnit=WorkUnit
		i WorkDateTime'="" s obj.PersonWorkDateTime=$ZDH(WorkDateTime,3)
		e  s obj.PersonWorkDateTime=""
		s obj.PersonIdentity=Identity
		
	}
	elseif(type2="W")
	{
		s WorkDateTime=$P($P(parr,"^",13),"|",2)
		s GRType=$P($P(parr,"^",14),"|",2)
		s Identity=$P($P(parr,"^",15),"|",2)
		i WorkDateTime'="" s obj.PersonWorkDateTime=$ZDH(WorkDateTime,3)
		e  s obj.PersonWorkDateTime=""
		s obj.PersonGRType=GRType
		s obj.PersonIdentity=Identity
		
	}elseif(type2="T")
	{
	}
	d obj.%Save()
	s ret=obj.%Id()
	
	i rw="" d
	.s parm=name_"^"_personid_"^^"_obj.%Id()_"^"_dep_"^"_stdate_"^^Y"_"^0"
	.d ##class(DHCMGNUR.MgNurTmpTransDep).Save(parm)
	e  i rw'="" d
	.s parm=name_"^"_personid_"^^"_obj.%Id()_"^"_dep_"^"_stdate_"^^"_"^0"
	.s transId=$O(^DHCMGNUR.MgNurTmpTransDepI("PerID"," "_personid,""))
	.i transId'="" d
	..s aaObj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(transId)
	..s aaObj.PerName=name
	..s aaObj.PerID=personid
	..s aaObj.PerTranStDate=$ZDH(stdate,3)
	..s aaObj.PerDepart=dep
	..d aaObj.%Save()
	q ret
}

/// 
/// ClassMethodDescription:通过Id获取人员信息
/// Date:2015-04-07
ClassMethod getInfornalVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	s obj=##class(DHCMGNUR.MgPersons).%OpenId(id)
	s PersonID=obj.PersonID
	s PersonName=obj.PersonName
	s PersonSexDR=obj.PersonSexDR
	i obj.PersonBirthDay'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonBirthDay=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonBirthDay)
	.e  s PersonBirthDay=""
	e  s PersonBirthDay=""
	s PersonDepDR=obj.PersonDepDR
	i obj.PersonAdmHosDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonAdmHosDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonAdmHosDate)
	.e  s PersonAdmHosDate=""
	e  s PersonAdmHosDate=""
	i obj.PersonInternStDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonInternStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonInternStDate)
	.e  s PersonInternStDate=""
	e  s PersonInternStDate=""
	i obj.PersonInternEndDate'="" d
	.i ((dateFlag=3)!(dateFlag=4)) s PersonInternEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonInternEndDate)
	.e  s PersonInternEndDate=""
	e  s PersonInternEndDate=""
	s PersonTelHand=obj.PersonTelHand
	s PersonInternAddress=obj.PersonInternAddress
	s PersonType2=obj.PersonType2
	s PersonIdentity=obj.PersonIdentity
	i PersonType2="P"
	{
		s PersonInternSchool=obj.PersonInternSchool
		s PersonInternProf=obj.PersonInternProf
		s PersonInternClass=obj.PersonInternClass
		s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonAdmHosDate|"_PersonAdmHosDate_"^PersonInternStDate|"_PersonInternStDate_"^PersonInternEndDate|"_PersonInternEndDate_"^PersonTelHand|"_PersonTelHand_"^PersonInternAddress|"_PersonInternAddress_"^PersonType2|"_PersonType2_"^PersonInternSchool|"_PersonInternSchool_"^PersonInternProf|"_PersonInternProf_"^PersonInternClass|"_PersonInternClass_"^PersonIdentity|"_PersonIdentity
	}
	elseif (PersonType2="S")
	{
		s PersonStudyPref=obj.PersonStudyPref
		s PersonWorkUnit=obj.PersonWorkUnit
		i obj.PersonWorkDateTime'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonWorkDateTime=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonWorkDateTime)
		.e  s PersonWorkDateTime=""
		e  s PersonWorkDateTime=""
		s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonAdmHosDate|"_PersonAdmHosDate_"^PersonInternStDate|"_PersonInternStDate_"^PersonInternEndDate|"_PersonInternEndDate_"^PersonTelHand|"_PersonTelHand_"^PersonInternAddress|"_PersonInternAddress_"^PersonType2|"_PersonType2_"^PersonStudyPref|"_PersonStudyPref_"^PersonWorkUnit|"_PersonWorkUnit_"^PersonWorkDateTime|"_PersonWorkDateTime_"^PersonIdentity|"_PersonIdentity
	}elseif (PersonType2="W")
	{
		s PersonGRType=obj.PersonGRType
		i obj.PersonWorkDateTime'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s PersonWorkDateTime=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonWorkDateTime)
		.e  s PersonWorkDateTime=""
		e  s PersonWorkDateTime=""
		s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonAdmHosDate|"_PersonAdmHosDate_"^PersonInternStDate|"_PersonInternStDate_"^PersonInternEndDate|"_PersonInternEndDate_"^PersonTelHand|"_PersonTelHand_"^PersonInternAddress|"_PersonInternAddress_"^PersonType2|"_PersonType2_"^PersonGRType|"_PersonGRType_"^PersonWorkDateTime|"_PersonWorkDateTime_"^PersonIdentity|"_PersonIdentity
	}elseif(PersonType2="T")
	{
		s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonSexDR|"_PersonSexDR_"^PersonDepDR|"_PersonDepDR_"^PersonAdmHosDate|"_PersonAdmHosDate_"^PersonInternStDate|"_PersonInternStDate_"^PersonInternEndDate|"_PersonInternEndDate_"^PersonTelHand|"_PersonTelHand_"^PersonType2|"_PersonType2
	}
	
	q ret
}

/// 
/// MethodDescription:没有工号的自动生成工号；生成规则为：类型+年+4为数字
ClassMethod generateId(type As %String) As %String
{
	s n=0
	i type="P" s pertyp="SX"
	i type="S" s pertyp="JX"
	i type="W" s pertyp="HLY"
	s year=$P($ZD(+$H,3),"-",1)
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SType"," "_type,personid)) q:personid=""  d
	.;b ;002
	.q:personid'[(pertyp_year)
	.s n=n+1
	s n=n+1
	i $L(n)=1 s n="000"_n
	e  i $L(n)=2 s n="00"_n
	e  i $L(n)=3 s n="0"_n
	e  s n=n
	s perid=$O(^DHCMGNUR.MgPersonsI("SSID"," "_pertyp_year_n,""))
	i perid'="" d
	.b ;001
	.s n=n+1
	.i $L(n)=1 s n="000"_n
	.e  i $L(n)=2 s n="00"_n
	.e  i $L(n)=3 s n="0"_n
	.e  s n=n
	s perNo=pertyp_year_n
	q perNo
}

/// 
/// MethodDescription:判断此身份证号码是否存在
/// Date:2015-04-15
ClassMethod IsExistIdenty(parr As %String) As %String
{
	//P^37083019841309523X
	s typ=$P(parr,"^",1)
	s identy=$P(parr,"^",2)
	s n=0
	s personid="" f  s personid=$O(^DHCMGNUR.MgPersonsI("SType"," "_typ,personid)) q:personid=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgPersonsI("SType"," "_typ,personid,rw)) q:rw=""  d
	..s obj=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	..q:$ZConvert(obj.PersonIdentity,"U")'=$ZConvert(identy,"U")
	..s n=n+1
	q n
}

/// MethodDescription:判断工号是否存在 返回Id
/// 
ClassMethod IsExist(str As %String) As %String
{
	s ret=""
	s type=$P(str,"^",1)
	s perid=$P(str,"^",2)
	s rw=$O(^DHCMGNUR.MgPersonsI("SType"," "_type," "_perid,""))
	s ret=rw
	q ret
}

Query SearchInformalList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchInformalListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s dateFlag=##class(websys.Conversions).DateFormat()
 	s type=$P(parr,"^",1)
 	s comDep=$P(parr,"^",2)
 	s stDate=$P(parr,"^",3)
 	s endDate=$P(parr,"^",4)
 	s nurseid=$ZConvert($P(parr,"^",5),"U")
	s ret=""
	s typ="" f  s typ=$O(^DHCMGNUR.MgPersonsI("SType",typ)) q:typ=""  d
	.q:$Tr(typ," ","")="N"
	.q:($Tr(typ," ","")'=type)&(type'="")
	.s perid="" f  s perid=$O(^DHCMGNUR.MgPersonsI("SType",typ,perid)) q:perid=""  d
	..s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SType",typ,perid,id)) q:id=""  d
	...s obj=##class(DHCMGNUR.MgPersons).%OpenId(id)
	...q:(obj.PersonDepDR'=comDep)&(comDep'="")
	...q:(obj.PersonInternStDate>$ZDH(endDate,3))&(obj.PersonInternStDate'="")
	...q:(obj.PersonInternEndDate<$ZDH(stDate,3))&(obj.PersonInternEndDate'="")
	...q:($ZConvert(obj.PersonName,"U")'[$ZConvert(nurseid,"U"))&(nurseid'="")
	...i type="R" s PersonID=$E(obj.PersonID,3,$L(obj.PersonID))
	...e  s PersonID=obj.PersonID
	...s PersonName=obj.PersonName
	...i obj.PersonSexDR="1" s PersonSexDR="女"
	...e  i obj.PersonSexDR="2" s PersonSexDR="男"
	...e  s PersonSexDR=""
	...i obj.PersonBirthDay'="" d
	....i ((dateFlag=3)!(dateFlag=4)) s PersonBirthDay=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonBirthDay)
	....e  s PersonBirthDay=""
	...e  s PersonBirthDay=""
	...i (obj.PersonDepDR'="")&(obj.PersonDepDR'="9999")&(obj.PersonDepDR'="9998")&(obj.PersonDepDR'="9997") s PersonDepDR=$p(^CTLOC(obj.PersonDepDR),"^",2)
 	...e  i obj.PersonDepDR="9999" s PersonDepDR="待分区"
 	...e  i obj.PersonDepDR="9998" s PersonDepDR="退休区"
 	...e  i obj.PersonDepDR="9997" s PersonDepDR="离职区"
 	...e  s PersonDepDR=""
 	...i obj.PersonAdmHosDate'="" d
 	....i ((dateFlag=3)!(dateFlag=4)) s PersonAdmHosDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonAdmHosDate)
 	....e  s PersonAdmHosDate=""
 	...e  s PersonAdmHosDate=""
 	...i obj.PersonInternStDate'="" d
 	....i ((dateFlag=3)!(dateFlag=4)) s PersonInternStDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonInternStDate)
 	....e  s PersonInternStDate=""
 	...e  s PersonInternStDate=""
 	...i obj.PersonInternEndDate'="" d
 	....i ((dateFlag=3)!(dateFlag=4)) s PersonInternEndDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.PersonInternEndDate)
 	....e  s PersonInternEndDate=""
 	...e  s PersonInternEndDate=""
 	...s PersonTelHand=obj.PersonTelHand
 	...s PersonInternAddress=obj.PersonInternAddress
 	...s PersonType2=obj.PersonType2
 	...s PersonIdentity=obj.PersonIdentity
 	...s ret="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonSexDR|"_PersonSexDR_"^PersonBirthDay|"_PersonBirthDay_"^PersonDepDR|"_PersonDepDR_"^PersonAdmHosDate|"_PersonAdmHosDate_"^PersonInternStDate|"_PersonInternStDate_"^PersonInternEndDate|"_PersonInternEndDate_"^PersonTelHand|"_PersonTelHand_"^PersonInternAddress|"_PersonInternAddress_"^PersonType2|"_PersonType2_"^rw|"_id_"^PersonIdentity|"_PersonIdentity
	...d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchInformalListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchInformalListExecute ]
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

ClassMethod SearchInformalListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchInformalListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// MethodDescription:获取科室描述
/// 
ClassMethod getDepDesc(id As %String) As %String
{
	s ret=""
	i id'=""
	{
		i $d(^CTLOC(id)) s desc=$P(^CTLOC(id),"^",2)
		e  d
		.s pwdr=$O(^DHCMGNUR.MgNurPerWardI("WardLoc",id,""))
		.i pwdr="" s desc=""
		.e  d
		.s pwobj=##class(DHCMGNUR.MgNurPerWard).%OpenId(pwdr)
		.s desc=pwobj.WardDesc
		s ret=desc
	}
	q ret
}

ClassMethod tmpTransDep(parr As %String) As %String
{
	s ^tmp("g20150413002")=parr
	//parr="test111^SX5555^^100^47^2015-04-14^^Y^0"
	s curDate=+$H
	s transDate=$ZDH($P(parr,"^",6),3)
	i transDate>curDate d
	.d ##class(DHCMGNUR.MgNurTmpTransDep).Save(parr)
	e  d
	.d ##class(DHCMGNUR.MgNurTmpTransDep).Save(parr)
	.s a=##class(DHCMGNUR.MgPersons).%OpenId($P(parr,"^",4))
	.s a.PersonDepDR=$P(parr,"^",5)
	.d a.%Save()
	q 0
}

/// 
/// MethodDescription:临时人员调科任务执行方法
/// Date:2015-04-14
ClassMethod ExcuteTmpPerTrans()
{
	s curDate=+$H
	s perid="" f  s perid=$O(^DHCMGNUR.MgNurTmpTransDepI("PerID",perid)) q:perid=""  d
	.s rw="" f  s rw=$O(^DHCMGNUR.MgNurTmpTransDepI("PerID",perid,rw)) q:rw=""  d
	..s obj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(rw)
	..q:obj.PerTranStDate'=curDate
	..s personid=obj.PerID
	..i personid'="" d
	...s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_personid,""))
	...i id'="" d
	....s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
	....s a.PersonDepDR=obj.PerDepart
	....d a.%Save()
}

/// 
/// MethodDescription:临时人员数据导入
/// Date:2015-04-16
ClassMethod ImportLSRYData()
{
	//parr="RH0879^王威^门诊^口腔门诊^MIC西药库^助理人员"
	s id="" f  s id=$O(^LSRY(id)) q:id=""  d
	.q:+id=0
	.s parr=^LSRY(id)
	.;b ;01
	.s personid=$P(parr,"^",1)
	.s name=$P(parr,"^",2)
	.s dep=$P(parr,"^",5)
	.s depid=""
	.s ctid="" f  s ctid=$O(^CTLOC(ctid)) q:ctid=""  d
	..q:+ctid=0
	..s ctDesc=$P($P(^CTLOC(ctid),"^",2),"-",2)
	..q:ctDesc'=dep
	..s dep=ctDesc
	..s depid=ctid
	.i personid'="" d
	..s rw=$O(^DHCMGNUR.MgPersonsI("SType"," "_"W"," "_personid,""))
	..i rw="" d
	...s obj=##class(DHCMGNUR.MgPersons).%New()
	..e  d
	...s obj=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	..s obj.PersonID=personid
	..s obj.PersonName=name
	..s obj.PersonDepDR=depid
	..s obj.PersonType2="W"
	..d obj.%Save()
	..s stdate=$ZD(+$H,3)
	..i rw="" d
	...s parm=name_"^"_personid_"^^"_obj.%Id()_"^"_depid_"^"_stdate_"^^Y"_"^0"
	...d ##class(DHCMGNUR.MgNurTmpTransDep).Save(parm)
	..e  i rw'="" d
	...s transId=$O(^DHCMGNUR.MgNurTmpTransDepI("PerID"," "_personid,""))
	...i transId'="" d
	....s aaObj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(transId)
	....s aaObj.PerName=name
	....s aaObj.PerID=personid
	....s aaObj.PerDepart=depid
	....d aaObj.%Save()
	...e  d
	....s aaObj=##class(DHCMGNUR.MgNurTmpTransDep).%New()
	....s aaObj.PerName=name
	....s aaObj.PerID=personid
	....s aaObj.PerDepart=depid
	....s aaObj.PerDr=##class(DHCMGNUR.MgPersons).%OpenId(rw)
	....s aaObj.PerTranStDate=+$H
	....s aaObj.PerTranCurrent="Y"
	....s aaObj.PerFlag=0
	....d aaObj.%Save()
}

/// 排班人员查询测试方法
/// 未用
ClassMethod getDeptNurse(parr As %String, tmp As %String) As %String
{
	s WardId=$P(parr,"^",1) q:WardId=""
	s StDate=$zdh($P(parr,"^",2),3)
	s EndDate=$zdh($P(parr,"^",3),3)
	s tmp=""
	s ID="" f  s ID=$O(^DHCMGNUR.MgPersonsI("Dep"," "_WardId,ID)) q:ID=""  do
	.s PerObj = ##class(DHCMGNUR.MgPersons).%OpenId(ID)
	.s PersonID=PerObj.PersonID
	.s flag=##class(web.DHCNurArgJobNurInfo).CheckNurDept(PersonID_"^"_parr)
	.q:(flag=0)&(PerObj.PersonType2="N")
	.s flag=##class(web.DHCNurArgJobNurInfo).CheckTmpNurDept(PersonID_"^"_parr)
	.q:(flag=0)&(PerObj.PersonType2'="N")
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=PerObj.PersonType2
	.i $d(tmp(PersonID))=0 s tmp(PersonID)="PersonID|"_PersonID_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s gperid="" f  s gperid=$O(^DHCMGNUR.MgPersonsI("SSID",gperid)) q:gperid=""  d
	.;b ;00
	.s gid="" f  s gid=$O(^DHCMGNUR.MgPersonsI("SSID",gperid,gid)) q:gid=""  d
	..s gObj=##class(DHCMGNUR.MgPersons).%OpenId(gid)
	..q:gObj.PersonType2'="N"
	..s gTmpDate=gObj.PersonTmpDate
	..s gTmpDep=gObj.PersonTmpDep
	..i gObj.PersonID="04628" b ;0005
	..q:((gTmpDep'="")&&(gTmpDep'=WardId))!(gTmpDep="")
	..i gObj.PersonID="04628" b ;0004
	..s gname=gObj.PersonName
	..s gtyp=gObj.PersonType2
	..s gbty=gObj.PersonBattery.Code
	..s gnurseid=gObj.PersonID
	..i $d(tmp(gnurseid))=0 s tmp(gnurseid)="PersonID|"_gnurseid_"^PersonName|"_gname_"^PersonType|"_gtyp_"^PersonBty|"_gbty_"^PersonOrder|"
	..b ;002
	b ;001
	s TransId="" f  s TransId=$O(^DHCMGNUR.MgNurTransDepI("Dep"," "_WardId,TransId)) q:TransId=""  d
	.s TransObj=##class(DHCMGNUR.MgNurTransDep).%OpenId(TransId)
	.s TransPerID=TransObj.PerID
	.s MgPerID=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(TransPerID,"U"),""))
	.q:MgPerID=""
	.s MgPerObj=##class(DHCMGNUR.MgPersons).%OpenId(MgPerID)
	.s PersonName=MgPerObj.PersonName
	.s PersonBty=MgPerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=MgPerObj.PersonType2
	.s TransCurrent=TransObj.PerTranCurrent
	.s TransStDate=TransObj.PerTranStDate
	.s TransEndDate=TransObj.PerTranEndDate
	.q:((TransEndDate'="")&&(TransEndDate<StDate))||(TransStDate>EndDate)
	.i $d(tmp(TransPerID))=0 s tmp(TransPerID)="PersonID|"_TransPerID_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	s tmptrsid="" f  s tmptrsid=$O(^DHCMGNUR.MgNurTmpTransDepI("Dep"," "_WardId,tmptrsid)) q:tmptrsid=""  d
	.s tmptrsobj=##class(DHCMGNUR.MgNurTmpTransDep).%OpenId(tmptrsid)
	.s tmptrsperid=tmptrsobj.PerID
	.s perid=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZCvt(tmptrsperid,"U"),""))
	.s PerObj=##class(DHCMGNUR.MgPersons).%OpenId(perid)
	.s PersonName=PerObj.PersonName
	.s PersonBty=PerObj.PersonBattery
	.i PersonBty'="" s PersonBtyCode=PersonBty.Code
	.else  s PersonBtyCode=""
	.s PersonType2=PerObj.PersonType2
	.s TransCurrent=tmptrsobj.PerTranCurrent
	.s TransStDate=tmptrsobj.PerTranStDate
	.s TransEndDate=tmptrsobj.PerTranEndDate
	.q:((TransEndDate'="")&&(TransEndDate<StDate))||(TransStDate>EndDate)
	.i $d(tmp(tmptrsperid))=0 s tmp(tmptrsid)="PersonID|"_tmptrsperid_"^PersonName|"_PersonName_"^PersonType|"_PersonType2_"^PersonBty|"_PersonBtyCode_"^PersonOrder|"
	
	q 0
}

ClassMethod GetNurWard1(NurDr As %String, excuteDate As %String, excuteTime As %String) As %String
{
	q:NurDr="" ""
	s ssdr="" s ssdr=$O(^SSU("SSUSR",0,"CTPCP",NurDr,ssdr))
	q:ssdr="" ""
	s obj=##class(User.SSUser).%OpenId(ssdr)
	s nurseid=obj.SSUSRInitials
	s flag=0
	s rw="" f  s rw=$O(^DHCMGNUR.MgNurTransDepI("PerID"," "_nurseid,rw)) q:rw=""  d
	.s obj1=##class(DHCMGNUR.MgNurTransDep).%OpenId(rw)
	.s stdate=obj1.PerTranStDate
	.s sttime=obj1.PerTranStTime
	.s endtime=obj1.PerTranEndTime
	.s enddate=obj1.PerTranEndDate
	.q:(stdate'="")&(enddate'="")&(stdate>enddate)
	.q:(stdate'="")&(excuteDate'="")&(excuteDate<stdate) //s flag=0
	.q:(stdate'="")&(excuteDate'="")&(enddate'="")&((excuteDate>stdate)&(excuteDate>enddate)) //s flag=0
	.i (stdate'="")&(excuteDate'="")&(enddate'="")&(excuteDate>stdate)&(excuteDate<enddate) d 
	..s flag=1
	..s dep=obj1.PerDepart
	.i (stdate'="")&(excuteDate'="")&(enddate'="")&(excuteDate>stdate)&(excuteDate=enddate)&(excuteTime<endtime) d
	..s flag=1
	..s dep=obj1.PerDepart
	.q:(stdate'="")&(excuteDate'="")&(enddate'="")&(excuteDate>stdate)&(excuteDate=enddate)&(excuteTime>endtime) //s flag=0
	.i (stdate'="")&(excuteDate'="")&(enddate="")&(excuteDate>stdate) d
	..s flag=1
	..s dep=obj1.PerDepart
	.q:(stdate'="")&(excuteDate'="")&(enddate="")&(excuteDate=stdate)&(excuteTime<sttime) //s flag=0
	.i (stdate'="")&(excuteDate'="")&(enddate="")&(excuteDate=stdate)&(excuteTime>sttime) d
	..s flag=1
	..s dep=obj1.PerDepart 
	.q:(stdate'="")&(enddate'="")&(excuteDate'="")&(excuteTime'="")&(excuteDate=stdate)&(excuteTime<sttime) //s flag=0
	.i (stdate'="")&(enddate'="")&(excuteDate'="")&(excuteTime'="")&(excuteDate=stdate)&(excuteTime>sttime)&(excuteDate<enddate) d
	..s flag=1
	..s dep=obj1.PerDepart
	.i (stdate'="")&(enddate'="")&(excuteDate'="")&(excuteTime'="")&(excuteDate=stdate)&(excuteTime>sttime)&(excuteDate=enddate)&(excuteTime<endtime) d
	..s flag=1
	..s dep=obj1.PerDepart
	.q:(stdate'="")&(enddate'="")&(excuteDate'="")&(excuteTime'="")&(excuteDate=stdate)&(excuteTime>sttime)&(excuteDate=enddate)&(excuteTime>endtime) //s flag=0
	.q:(stdate'="")&(enddate'="")&(excuteDate'="")&(excuteTime'="")&(excuteDate=stdate)&(excuteTime>sttime)&(excuteDate>enddate) //s flag=0
	.;b ;001
	;b ;002
	i flag=0 s dep=""
	s perid="" s perid=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurseid,perid))
	q:perid="" "" 
	q dep_"^"_ssdr_"^"_perid
}

/// 
/// 查询大科信息
/// Date:2015-09-11
Query SearchLargeLoc(parr As %String) As %Query(ROWSPEC = "loccode,locdesc")
{
}

ClassMethod SearchLargeLocExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s rw="" f  s rw=$O(^DHCMGNUR.MgNurLargeLocD(rw)) q:rw=""  d
 	.s list=^DHCMGNUR.MgNurLargeLocD(rw)
 	.s loccode=$List(list,2)
 	.s locdesc=$list(list,3)
 	.q:((parr'="")&&(locdesc'[parr))
 	.d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(loccode,locdesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchLargeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchLargeLocExecute ]
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

ClassMethod SearchLargeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchLargeLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

ClassMethod getPersonAdmHosDate(id) As %String
{
	q:id="" ""
	s obj=##class(DHCMGNUR.MgPersons).%OpenId(id)
	s PersonAdmHosDate=obj.PersonAdmHosDate
	q PersonAdmHosDate
}

}
