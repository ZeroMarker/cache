/// creator:xbl
/// createdate:2017-06-26
/// description:获取HIS公共数据
Class web.NurMgHISComm Extends %RegisteredObject
{

/// creator:xbl
/// createdate:2017-06-26
/// description:获取HIS科室
/// input:
/// output:
/// other: w ##class(web.NurMgHISComm).FindCTLoc()
ClassMethod FindCTLoc(typ As %String = "", input As %String = "") As %String
{
	s input=$zcvt(input,"U")
	s ret="",count=0
	w "["
	s desc="" f  s desc=$O(^CTLOC(0,"Desc",desc)) q:desc=""  d
	.s locid="" f  s locid=$O(^CTLOC(0,"Desc",desc,locid)) q:locid=""  d
	..s loccode=$replace($tr($P(^CTLOC(locid),"^",1)," ",""),"\","\\")
	..s locdesc=$replace($tr($P(^CTLOC(locid),"^",2)," ",""),"\","\\")
	..s loctyp=$P(^CTLOC(locid),"^",13)
	..q:(typ'="")&&(typ'=loctyp)
	..q:(locdesc["停用")!(+locdesc=locdesc)
	..q:((input'="")&&($zcvt(locdesc,"U")'[input))
	..s count=count+1
	..s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locid,""))
	..i wardid'="" s locflag="true"
	..e  s locflag="false"
	..;i ret'="" s ret=ret_","
	..;s ret=ret_"{""locid"":"""_locid_""",""loccode"":"""_loccode_""",""locdesc"":"""_locdesc_""",""locflag"":"""_locflag_"""}"
	..i count=1 w "{""locid"":"""_locid_""",""loccode"":"""_loccode_""",""locdesc"":"""_locdesc_""",""locflag"":"""_locflag_"""}"
	..e  w ",{""locid"":"""_locid_""",""loccode"":"""_loccode_""",""locdesc"":"""_locdesc_""",""locflag"":"""_locflag_"""}"
	;i ret'="" s ret="["_ret_"]"
	;s ret=$replace(ret,"\","\\")
	;s ret=$tr(ret," ","")
	w "]"
	q ""
}

/// Creator:gzj
/// Createdate:2018-02-03
/// Description:查询ctloc列表
/// Input:parr
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.NurMgSetComm","FindCTLocList","^^9")
Query FindCTLocList(typ As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindCTLocListExecute(ByRef qHandle As %Binary, typ As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s input=$zcvt(input,"U")
	s ret="",count=0
	s tmpRet=""
	s desc="" f  s desc=$O(^CTLOC(0,"Desc",desc)) q:desc=""  d
	.s locid="" f  s locid=$O(^CTLOC(0,"Desc",desc,locid)) q:locid=""  d
	..q:$g(tmpRet(locid))'=""
	..s loccode=$P(^CTLOC(locid),"^",1)
	..s locdesc=$P(^CTLOC(locid),"^",2)
	..s loctyp=$P(^CTLOC(locid),"^",13)
	..q:(typ'="")&&(typ'=loctyp)
	..q:(locdesc["停用")!(+locdesc=locdesc)
	..q:locdesc["作废"
	..s CTLOCDateActiveTo=$P(^CTLOC(locid),"^",25)
	..q:(CTLOCDateActiveTo'="")
	..s CTLOCDepDR=$P(^CTLOC(locid),"^",19)
	..q:CTLOCDepDR=""
	..s CTLOCDepCode=$P(^RBC("DEP",CTLOCDepDR),"^",1)
	..q:$zcvt(locdesc,"U")'[input
	..s hospitalId=$P(^CTLOC(locid),"^","22")
	..q:hospitalId=""
	..s hospitalDesc=$P(^CT("HOSP",hospitalId),"^",2)
	..s count=count+1
	..s wardid=$O(^DHCNMG.DB.MgWardI("CTLoc",locid,""))
	..i wardid'="" s locflag="true"
	..e  s locflag="false"
	..s loccode=$replace($tr(loccode," ",""),"\","\\")
	..s locdesc=$replace($tr(locdesc," ",""),"\","\\")
	..s locContant=##class(web.NurMgVueComm).ToChineseSpell(locdesc)
	..;i ret'="" s ret=ret_","
	..s ret="locid|"_locid_"^loccode|"_loccode_"^locdesc|"_locdesc_"^locflag|"_locflag_"^locContant|"_locContant
	..d OutCTLocList
	..s tmpRet(locid)=locid
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCTLocList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCTLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCTLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCTLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCTLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询HIS科室表
/// d ##class(%ResultSet).RunQuery("web.NurMgHISComm","QueryCTLoc","","")
Query QueryCTLoc(typ As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod QueryCTLocExecute(ByRef qHandle As %Binary, typ As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s desc="" f  s desc=$O(^CTLOC(0,"Desc",desc)) q:desc=""  d
	.s locid="" f  s locid=$O(^CTLOC(0,"Desc",desc,locid)) q:locid=""  d
	..s loccode=$P(^CTLOC(locid),"^",1)
	..s locdesc=$P(^CTLOC(locid),"^",2)
	..s loctyp=$P(^CTLOC(locid),"^",13)
	..q:(typ'="")&&(typ'=loctyp)
	..q:(locdesc["停用")!(+locdesc=locdesc)
	..q:$zcvt(locdesc,"U")'[input
	..s ret="locdesc|"_locdesc_"^loccode|"_loccode_"^locid|"_locid
	..d OutCTLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutCTLoc
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryCTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryCTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCTLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLoc(locid As %String) As %String
{
	q:locid="" ""
	s loccode=$P(^CTLOC(locid),"^",1)
	s locdesc=$P(^CTLOC(locid),"^",2)
	s:locdesc["-" locdesc=$P(locdesc,"-",2)
	s locspell=##class(web.NurMgVueComm).ToChineseSpell(locdesc)
	s loctype=$P(^CTLOC(locid),"^",13)
	s ret="locid|"_locid_"^loccode|"_loccode_"^locdesc|"_locdesc_"^loctype|"_loctype_"^locspell|"_locspell
	q ret
}

///  creator: xbl
///  createdate: 20171016
///  description: 获取科室病人列表
///  table:
///  input:
///  output:
///  return:
///  other: d ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindPatientList","1","")
Query FindPatientList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatientListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s wardFire=wardobj.WardFire
	s:wardFire="" wardFire=37.3
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s room="" f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.s adm="" f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d
	..;s papmidr=$P(^PAADM(adm),"^",1)
	..;q:papmidr=""
	..;s patname=$P(^PAPER(papmidr,"ALL"),"^",1)
	..;s patbed=$P(^PAADM(adm),"^",73)
	..;i patbed'="" s bedcode=$P(^PAWARD(+patbed,"BED",$P(patbed,"||",2)),"^",1)
	..;e  s bedcode=""
	..;s ret="EpisodeID|"_adm_"^PatName|"_patname_"^PatBed|"_$tr(patbed,"|","_")_"^BedCode|"_bedcode
	..s ret=..GetPatInfo(adm,"",wardFire)
	..d OutPatient
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPatient
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: xbl
/// createdate: 20171016
/// description: 获取科室床位列表
/// table:
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindBedList","1","")
Query FindBedList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindBedListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0 f  s subid=$O(^PAWARD(pacward,"BED",subid)) q:subid=""  d
	.s bedid=pacward_"||"_subid
	.s bedcode=$P(^PAWARD(pacward,"BED",subid),"^",1)
	.s ret="BedCode|"_bedcode_"^rw|"_pacward_"__"_subid
	.d OutBed
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutBed
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindBedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: llin
/// createdate: 2018-08-08
/// description: 获取科室床位分组列表
/// table:
/// input:
/// output:
/// return:
/// other: w ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindBedList","88","")
Query FindBedGroupList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindBedGroupListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0 f  s subid=$O(^DHCWardProGroup(0,"WardDr",pacward,subid)) q:subid=""  d
	.s activeFlag=$p(^DHCWardProGroup(subid),"^",3)
	.q:activeFlag'="Y"
	.s groupDesc=$p(^DHCWardProGroup(subid),"^",2)
	.s ret="groupDesc|"_groupDesc_"^rw|"_subid
	.d OutBedGroupData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutBedGroupData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindBedGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindBedGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator: llin
/// createdate: 2018-08-09
/// description: 获取病区分组获取床位
/// table:
/// input:
/// output:
/// return:
/// other:
ClassMethod GetBedByGroup(parr As %String = "") As %String
{
	q:parr="" ""
	s ret=""
	s tmp=""
	s id="" f  s id=$O(^DHCWardProGroupBed(0,"GroupDr",parr,id)) q:id=""  d
	.q:+id=0
	.s bedid=$P(^DHCWardProGroupBed(id),"^",3)
	.q:bedid=""
	.s bedcode=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
	.s tmp(bedcode)=bedcode
	s bedcode="" f  s bedcode=$O(tmp(bedcode)) q:bedcode=""  d
	.i ret="" s ret=bedcode
	.e  s ret=ret_","_bedcode
	q ret
}

/// creator: llin
/// createdate: 2018-08-09
/// description: 获取病区分组获取床位id
/// table:
/// input:
/// output:
/// return:
/// other:
ClassMethod GetBedIdByGroup(parr As %String = "") As %String
{
	q:parr="" ""
	s ret=""
	s id="" f  s id=$O(^DHCWardProGroupBed(0,"GroupDr",parr,id)) q:id=""  d
	.q:+id=0
	.s bedid=$P(^DHCWardProGroupBed(id),"^",3)
	.q:bedid=""
	.;s bedcode=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
	.i ret="" s ret=bedid
	.e  s ret=ret_","_bedid
	q ret
}

/// 根据就诊号获取当前就诊记录
/// w ##class(web.NurMgHISComm).GetCurrAdm("0000000071")
ClassMethod GetCurrAdm(patno As %String, type As %String = "I") As %String
{
	q:patno="" ""
	s papmidr=$O(^PAPERi("PAPMI_PatNo",$zcvt(patno,"U"),""))
	q:papmidr="" ""
	s curradm=""
	s adm="" f  s adm=$O(^PAPERdr(papmidr,"ADM",$zcvt(type,"U"),adm)) q:adm=""  d
	.q:+adm=0
	.s visitstatus=$P(^PAADM(adm),"^",20)
	.q:visitstatus'="A"
	.s curradm=adm
	q curradm
}

/// 根据就诊号及医嘱分类获取医嘱id
/// w ##class(web.NurMgHISComm).GetOrdItem("9","HL03")
ClassMethod GetOrdItem(adm As %String, catcode As %String) As %String
{
	q:(adm="")||(catcode="") ""
	s ids="",descs=""
	s ordid="" f  s ordid=$O(^OEORD(0,"Adm",adm,ordid)) q:ordid=""  d
	.q:+ordid=0
	.s orditmid="" f  s orditmid=$O(^OEORD(ordid,"I",orditmid)) q:orditmid=""  d
	..q:+orditmid=0
	..s ordstatdr=$P($g(^OEORD(ordid,"I",orditmid,1)),"^",13)
	..q:ordstatdr=""
	..s ordstatus=$P($g(^OEC("OSTAT",ordstatdr)),"^",1)
	..q:(ordstatus'="V")
	..s itmmastdr=$P($g(^OEORD(ordid,"I",orditmid,1)),"^",2)
	..q:itmmastdr=""
	..s itmmastdesc=$P($g(^ARCIM(+itmmastdr,$P(itmmastdr,"||",2),1)),"^",2)
	..s itmcatdr=$P($g(^ARCIM(+itmmastdr,$P(itmmastdr,"||",2),1)),"^",10)
	..q:itmcatdr=""
	..s itmcatcode=$P($g(^ARC("IC",itmcatdr)),"^",1)
	..q:itmcatcode'=catcode
	..s execflag=0
	..s execid="" f  s execid=$O(^OEORD(ordid,"I",orditmid,"X",execid)) q:execid=""  d
	...s orderexdate=$P($g(^OEORD(ordid,"I",orditmid,"X",execid)),"^",1)
	...q:orderexdate'=+$h
	...s execflag=1
	..q:execflag=0
	..i ids="" s ids=ordid_"||"_orditmid,descs=itmmastdesc
	..e  s ids=ids_","_ordid_"||"_orditmid,descs=descs_","_itmmastdesc
	s ret=ids_"^"_descs
	q ret
}

/// 获取病人诊断
/// w ##class(web.NurMgHISComm).GetPatDiag(50,"")
ClassMethod GetPatDiag(adm As %String, typ, ifnotICD = "true") As %String
{
	q:adm="" ""
	s mradm=$p(^PAADM(adm),"^",61)
	s i=0,diag=""
    f a2=1:1:$g(^MR(mradm,"DIA",0)) d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .q:icdr="" 
    .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    .i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",1)  ;诊断类型
    .e  s diatype=""
    .q:(diatype'=typ)&(typ'="")
    .s date=$ZD($p($g(^MR(mradm,"DIA",a2)),"^",7),3) ;日期
    .s statusdr=$p($g(^MR(mradm,"DIA",a2)),"^",9)
    .s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    .s mrdesc=""
    .f de=1:1:$g(^MR(mradm,"DIA",a2,"DES",0)) d
    ..s mrdesc=$g(mrdesc)_$g(^MR(mradm,"DIA",a2,"DES",de)) ;
    .s i=i+1
    .i diag="" s diag=icdcode_" "_$g(mrdesc)
    .e  s diag=diag_";"_icdcode_" "_$g(mrdesc)
    //---------- 取非标准ICD诊断，按诊断类型过滤
    s ret="",MRDIADesc=""
    s chl="" f  s chl=$o(^MR(mradm,"DIA",chl)) q:chl=""  d
    .q:chl=""
    .s typedr=$P($g(^MR(mradm,"DIA",chl,"TYP",1)),"^",1)
    .i $g(typedr)'="" s type=$P($g(^MRC("DTYP",typedr)),"^",1)  ;诊断类型
   	.e  s type=""
    .q:(type'=typ)&(typ'="")
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",chl,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .i ret="" s ret=MRDIADesc
    .e  s ret=ret_";"_MRDIADesc
    i ifnotICD="true" d
    .i ret'="" d
    ..i diag="" s diag=ret
    ..e  s diag=diag_";"_ret
    
    s DiagnosDr=$O(^Nur.DHCNurCopyDiagnosI("EpisodeId"," "_adm,""),-1)
	i DiagnosDr'="" s diag=$List(^Nur.DHCNurCopyDiagnosD(DiagnosDr),2)
	s diag=$tr(diag,";",",")
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
    q diag
}

/// 获取病人第一次诊断
/// w ##class(web.NurMgHISComm).GetPatFirstDiag(50,"")
ClassMethod GetPatFirstDiag(adm As %String) As %String
{
	q:adm="" ""
	s mradm=$p(^PAADM(adm),"^",61)
	s typ1="入院",typ2="初步"
    f a2=1:1:$g(^MR(mradm,"DIA",0))  d
    .s icdr=$p($g(^MR(mradm,"DIA",a2)),"^",1)
    .q:icdr="" 
    .s diatypedr=$P($g(^MR(mradm,"DIA",a2,"TYP",1)),"^",1)
    .s diatype=""
    .i $g(diatypedr)'="" s diatype=$P($g(^MRC("DTYP",diatypedr)),"^",2)  ;诊断类型
    .q:(diatype'[typ1)&&(diatype'[typ2)
    .s typ=typ1
    .s:diatype[typ2 typ=typ2
    .s icdcode=$P($g(^MRC("ID",icdr)),"^",2)   ;疾病描述
    .s:icdcode'="" tmp(typ,a2)=icdcode
    .q:icdcode'=""
    .s MRDIADesc=0 s MRDIADesc=$o(^MR(mradm,"DIA",a2,"DES",MRDIADesc))
    .q:MRDIADesc=""
    .s MRDIADesc=$p(^MR(mradm,"DIA",chl,"DES",MRDIADesc),"^",1)
    .s:MRDIADesc'="" tmp(typ,a2)=MRDIADesc
    s diag=""
    s:$d(tmp(typ1)) diag=tmp(typ1,$O(tmp(typ1,0)))
    s:(diag="")&&($d(tmp(typ2))) diag=tmp(typ2,$O(tmp(typ2,0)))
	s diag=$tr(diag," ","")
	s diag=$zcvt(diag,"O","JS")
    q diag
}

/// 获取过敏
/// w ##class(web.NurMgHISComm).GetAllergy("9")
ClassMethod GetAllergy(adm As %String) As %String
{
	q:adm="" ""
	s patid=$p(^PAADM(adm),"^",1)
	q:(patid="")||($d(^PAPER(patid))=0) ""
	s ret=""
	s algid="" f  s algid=$O(^PAPER(patid,"ALG",algid)) q:algid=""  d
	.s status=$P($g(^PAPER(patid,"ALG",algid)),"^",8)
	.q:status'="A"
	.s algret=""
	.s alltypdr=$P($g(^PAPER(patid,"ALG",algid)),"^",29)
	.i alltypdr'="" d
	..s alltypdesc=$P($g(^MRC("AT",alltypdr)),"^",2) ;过敏分类
	.e  s alltypdr="0"
	.s typdr=$P($g(^PAPER(patid,"ALG",algid)),"^",9) ;过敏源
	.i typdr'="" s typdesc=$P($g(^PAC("ALG",typdr)),"^",2)
	.e  s typdr="0",typdesc=""
	.s ItmMastdr=$P($G(^PAPER(patid,"ALG",algid)),"^",30) ;过敏项目
	.i ItmMastdr'="" d
	..i $P(ItmMastdr,"||",2)'="" d
	...s ItmMastName=$P($G(^ARCIM(+ItmMastdr,$P(ItmMastdr,"||",2),1)),"^",2)
	..e  s ItmMastName=ItmMastdr
	.e  s ItmMastdr=0,ItmMastName=""
	.s phcgedr=$P($G(^PAPER(patid,"ALG",algid)),"^",4) ;药物过敏
	.i phcgedr'="" s phcgename=$P($g(^PHCGE("GE",phcgedr)),"^",2) 
	.e  s phcgedr="0",phcgename=""
	.;s phccsdr=$P(^PAPER(patid,"ALG",algid),"^",5)
	.s comments=$g(^PAPER(patid,"ALG",algid,"CMT",1)) ;过敏情况补充
	.q:$g(tmp(alltypdr,typdr,ItmMastdr,phcgedr))'=""
	.s tmp(alltypdr,typdr,ItmMastdr,phcgedr)=1
	.i typdesc'="" s algret="过敏源:"_typdesc
	.i phcgename'="" d
	..i algret'="" s algret=algret_","
	..s algret=algret_"药物过敏:"_phcgename
	.i ItmMastName'="" d
	..i algret'="" s algret=algret_","
	..s algret=algret_"过敏项目:"_ItmMastName
	.i comments'="" d
	..i algret'="" s algret=algret_","
	..s algret=algret_"补充说明:"_comments
	.i algret'="" s ret=ret_algret_";"
	q ret
}

/// 获取主治医生
/// 
ClassMethod GetCareDoctor(adm As %String) As %String
{
	q:adm="" ""
	s docdr=$P($g(^PAADM(adm)),"^",9)
	q:docdr="" ""
	s docname=$P($g(^CTPCP(docdr,1)),"^",2)
	q docname
}

/// 获取责任护士
ClassMethod GetDutyNurse(adm As %String) As %String
{
	/*
	q:adm="" ""
	s dhcadmid=$o(^DHCPAAdm(0,"PAAdm",adm,""))
	q:dhcadmid="" ""
	s nurdr=$p(^DHCPAAdm(dhcadmid),"^",2)
	q:nurdr="" ""
	s nurname=$P($g(^CTPCP(nurdr,1)),"^",2)
	q nurname
	*/
	q:adm="" ""
	s mainNurses=""
	s admExtID=""
	s admExtID=$O(^DHCPAAdm(0,"PAAdm",adm,admExtID),-1)
	i admExtID'="" d
	.s mainNurseID=$P($G(^DHCPAAdm(admExtID)),"^",2)
	.i mainNurseID'="" d
	..s mainNurseName=$P($G(^CTPCP(mainNurseID,1)),"^",2)
	..s mainNurses=mainNurseName
	.s nurseID=$P($G(^DHCPAAdm(admExtID)),"^",20)
	.i nurseID'="" d
	..s nurseName=$P($G(^CTPCP(nurseID,1)),"^",2)
	..s mainNurses=mainNurses_" "_nurseName
	q mainNurses
}

///  creator:llin
///  createdate:2018-08-12
///  description: 获取患者责任护士护管中的ID
///  table:
///  input:
///  output:
///  return:
///  other:4183919
ClassMethod GetDutyNurseID(adm As %String, ward, date, tmpNurse) As %String
{
	q:(adm="")||(date="")||(ward="") ""
	q:$g(^PAWARD(ward))=""
	s CTLOC=$P(^PAWARD(ward),"^",5)
	q:+CTLOC=0 ""
	s wardId=$O(^DHCNMG.DB.MgWardI("CTLoc",CTLOC,""))
	q:wardId="" ""
	s mainNurses=""
	s admExtID=""
	s admExtID=$O(^DHCPAAdm(0,"PAAdm",adm,admExtID),-1)
	i admExtID'="" d
	.s mainNurseID=$P($G(^DHCPAAdm(admExtID)),"^",2)
	.i mainNurseID'="" d
	..s SSUserID=$O(^SSU("SSUSR",0,"CTPCP",mainNurseID,""))
	..i SSUserID'="" d
	...s SSUSerCode=$ZCVT($P($G(^SSU("SSUSR",SSUserID)),"^",1),"U")
	...s perID=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_SSUSerCode,""))
	...i perID'="" d
	....s curward=##class(web.NurMgHRComm).GetCurrentWard(perID,date)
	....s:curward=wardId tmpNurse(ward,perID)=perID
	..;s mainNurses=mainNurseName
	.s nurseID=$P($G(^DHCPAAdm(admExtID)),"^",20)
	.i nurseID'="" d
	..s SSUserID=$O(^SSU("SSUSR",0,"CTPCP",nurseID,""))
	..i SSUserID'="" d
	...s SSUSerCode=$ZCVT($P($G(^SSU("SSUSR",SSUserID)),"^",1),"U")
	...s perID=$O(^DHCNMG.HR.MgPersonsI("hisno"," "_SSUSerCode,""))
	...i perID'="" d
	....s curward=##class(web.NurMgHRComm).GetCurrentWard(perID,date)
	....s:curward=wardId tmpNurse(ward,perID)=perID
	q 1
}

/// 获取病人信息
/// 参考: web.DHCMGNurComm PatInfo
/// w ##class(web.NurMgHISComm).GetPatInfo("","0000000071")
/// input:就诊号，登记号，病区发烧指数
ClassMethod GetPatInfo(adm As %String = "", patno As %String = "", wardfire As %String = "") As %String
{
	q:(adm="")&&(patno="") ""
	i adm'="" s papmidr=$P(^PAADM(adm),"^",1)
	e  s papmidr=$O(^PAPERi("PAPMI_PatNo",$zcvt(patno,"U"),""))
	q:papmidr="" ""
	i adm="" s adm=..GetCurrAdm(patno)
	q:adm="" ""
	i patno="" s patno=$P($g(^PAPER(papmidr,"PAT",1)),"^",1)
	s patname=$P($g(^PAPER(papmidr,"ALL")),"^",1)
	s Medicare=$P($g(^PAPER(papmidr,"PAT",1)),"^",22) ;住院号
	s warddr=$P($g(^PAADM(adm)),"^",70)
	i warddr'="" d
	.s loc=$P($g(^PAWARD(warddr)),"^",5)
	.q:loc=""
	.s ward=$O(^DHCNMG.DB.MgWardI("CTLoc",loc,""))
	.q:ward=""
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	.s warddesc=wardobj.WardDesc
	s beddr=$P($g(^PAADM(adm)),"^",73)
	i beddr'="" s bedcode=$P(^PAWARD(+beddr,"BED",$P(beddr,"||",2)),"^",1)
	e  s bedcode=""
	s admdate=$P($g(^PAADM(adm)),"^",6)
	i admdate'="" s admdate=$zd(admdate,3)
	s homeAddres=$g(^PAPER(papmidr,"PER","ADD",1)) // 住址
    s homeTel=$p($g(^PAPER(papmidr,"PER",1)),"^",11)  //家庭电话
	s birthday=$P($g(^PAPER(papmidr,"ALL")),"^",6)
	s patage=##class(web.NurMgVueComm).CalAge(birthday,+$h)
	s years=""
	i +patage>6 s years=+patage_"岁"
	e  i +patage'=0 d
	.i +$P(patage," ")'=0 s years=years_+$P(patage," ")_"岁"
	.i +$P(patage," ",2)'=0 s years=years_+$P(patage," ",2)_"月"
	.s:years="" years="<1天"
	e  d
	.i +$P(patage," ",2)'=0 s years=years_+$P(patage," ",2)_"月"
	.i +$P(patage," ",3)'=0 s years=years_+$P(patage," ",3)_"天"
	.s:years="" years="<1天"
	s patage=years
	s sexdr=$P(^PAPER(papmidr,"ALL"),"^",7)
	i sexdr'="" s patsex=$P(^CT("SEX",sexdr),"^",2)
	e  s patsex=""
	s carelevel=..getPatCareLevel(adm,+$H)
	s:carelevel="" carelevel="无"
	s diag=..GetPatFirstDiag(adm) ;第一次诊断
	s sick="普通"
	s vsdata=..GetVSData(adm)
	s height=$p(vsdata,"^")
	s weight=$p(vsdata,"^",2)
	s tempper=$p(vsdata,"^",3)
	;s height=##class(Nur.CommonInterface.Temperature).getLastItemValue(adm,"height")
	;s weight=##class(Nur.CommonInterface.Temperature).getLastItemValue(adm,"weight")
	;s tempper=##class(Nur.CommonInterface.Temperature).getLastItemValue(adm,"temperature")
	s isTempper=..IfFeverInThreeDay(adm,wardfire)
	i (tempper'="")&&(wardfire'="")&&(tempper>wardfire) s sick="发烧"
	s:isTempper=1 sick="发烧"
	s sickflag=##class(web.DHCSETIMAGE).IfOrddailyExist(adm,"WFY000810")
	i sickflag="1" s sick="病危"
	s sickflag=##class(web.DHCSETIMAGE).IfOrddailyExist(adm,"WFY000811")
	i sickflag="1" s sick="病重"
	i ((sick="病危")||(sick="病重"))&&(isTempper=1) d
	.s sick=sick_","_"发烧"
	s doctor=..GetCareDoctor(adm)
	s nurse=..GetDutyNurse(adm)
	s allergy=..GetAllergy(adm)
	s foods=""
	s foodstr=..GetOrdItem(adm,"嘱托饮食")
	i foodstr'="^" s foods=$P(foodstr,"^",2) ;饮食
	//粤北人民多个饮食医嘱
#;	s foodstr=..GetOrdItem(adm,"YS002")
#;	i foodstr'="^" d
#;	.i fonds="" s foods=$P(foodstr,"^",2) ;饮食
#;	.e  s foods=fonds_","_$P(foodstr,"^",2) ;饮食
#;	s foodstr=..GetOrdItem(adm,"YS003")
#;	i foodstr'="^" d
#;	.i fonds="" s foods=$P(foodstr,"^",2) ;饮食
#;	.e  s foods=fonds_","_$P(foodstr,"^",2) ;饮食
	s ret="EpisodeID|"_adm_"^PatNo|"_patno_"^PatName|"_patname_"^PatBed|"_$tr(beddr,"||","__")_"^BedCode|"_bedcode_"^PatAge|"_patage_"^PatSex|"_patsex_"^PatCareLevel|"_carelevel_"^PatDiagnosis|"_diag_"^PatWard|"_$g(ward)_"^WardDesc|"_$g(warddesc)_"^PatSick|"_sick_"^PatDoctorName|"_doctor_"^PatNurseName|"_nurse_"^PatAllergy|"_allergy_"^PatFoods|"_foods
	s ret=ret_"^PatHomeAddress|"_homeAddres_"^PatHomeTel|"_homeTel_"^PatAdmDate|"_admdate_"^PatWeight|"_weight_"^PatHeight|"_height_"^Medicare|"_Medicare
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindWardPatient","1")
Query FindWardPatient(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPatientExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s wardfire=wardobj.WardFire
	s:wardfire="" wardfire="37.3"
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s roomid="" f  s roomid=$O(^PAADMi("CurrWard",pacward,roomid)) q:roomid=""  d
	.s admid="" f  s admid=$O(^PAADMi("CurrWard",pacward,roomid,admid)) q:admid=""  d
	..s patVisit=$p($g(^PAADM(admid)),"^",20)
    ..q:patVisit'="A"
    ..s bedSub=$p($p($g(^PAADM(admid)),"^",73),"||",2)
    ..q:bedSub=""
    ..s bedcode=$P($g(^PAWARD(pacward,"BED",bedSub)),"^",1)
    ..s tmp($a($char(bedcode)))=..GetPatInfo(admid,"",wardfire)
	s bc="" f  s bc=$O(tmp(bc)) q:bc=""  d
	.s ret=tmp(bc)
	.d OutWardPatient
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPatient
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPatientExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取病人医嘱信息
/// d ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindAdmOrder","9^2015-03-10^2015-03-10")
Query FindAdmOrder(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAdmOrderExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s admid=$P(parr,"^",1)
	i (+admid=0)||('$d(^PAADM(admid))) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s stdate=$P(parr,"^",2)
	s:stdate["-" stdate=$zdh(stdate,3)
	i stdate="" s stdate=+$h
	s enddate=$P(parr,"^",3)
	s:enddate["-" enddate=$zdh(enddate,3)
	i enddate="" s enddate=+$h
	s ordid="" f  s ordid=$O(^OEORD(0,"Adm",admid,ordid)) q:ordid=""  d
	.q:+ordid=0
	.s itmid="" f  s itmid=$O(^OEORD(ordid,"I",itmid)) q:itmid=""  d
	..q:+itmid=0
	..s exsttime="" f  s exsttime=$o(^OEORDi(0,"Date",ordid,stdate,exsttime))  q:exsttime=""  d
	...s extid=""  f  s extid=$o(^OEORDi(0,"Date",ordid,stdate,exsttime,itmid,extid)) q:extid=""  d
	....q:+extid=0
	....s ExecStatus=$p($g(^OEORD(ordid,"I",itmid,"X",extid)),"^",16) ;执行状态
	....s:ExecStatus'="" ExecStatus=$p($g(^OEC("STAT",ExecStatus)),"^",2)
	....s:ExecStatus="" ExecStatus="未执行"
	....s ordstdate=$P($g(^OEORD(ordid,"I",itmid,1)),"^",9) ;医嘱开始日期
	....;q:(ordstdate'="")&&(ordstdate'=stdate)
	....s:ordstdate'="" ordstdate=$zd(ordstdate,3)
	....;s statdr=$P($g(^OEORD(ordid,"I",itmid,1)),"^",13) ;医嘱状态：核实
	....;i statdr'=""  s statcode=$P(^OEC("OSTAT",statdr),"^",1)
	....;q:(statdr'="")&&(statcode'="V")
	....s itmmastdr=$P($g(^OEORD(ordid,"I",itmid,1)),"^",2) ;医嘱描述
	....q:itmmastdr=""
	....s itmmastdesc=$P($g(^ARCIM(+itmmastdr,$P(itmmastdr,"||",2),1)),"^",2)
	....s ItmCatDesc=$P($g(^OEORD(ordid,"I",itmid,1)),"^",8) ;医嘱优先级（类别）
	....s:ItmCatDesc'="" ItmCatDesc=$p($g(^OECPR(ItmCatDesc)),"^",2)
	....s OrdDoctor=$P($g(^OEORD(ordid,"I",itmid,1)),"^",11) ;开遗嘱医生
	....s:OrdDoctor'="" OrdDoctor=$p($g(^CTPCP(OrdDoctor,1)),"^",2)
	....s ordenddate=$P($g(^OEORD(ordid,"I",itmid,3)),"^",34) ;医嘱停止日期
	....s OrdDose=$p($g(^OEORD(ordid,"I",itmid,2)),"^",1) ;剂量
	....s OrdDoseUnit=$P($g(^OEORD(ordid,"I",itmid,2)),"^",3) ;剂量单位
	....s:OrdDoseUnit'="" OrdDoseUnit=$p($g(^CT("UOM",OrdDoseUnit)),"^",2)
	....s OrdPhQty=$P($g(^OEORD(ordid,"I",itmid,2)),"^",4) ;频率
	....s:OrdPhQty'="" OrdPhQty=$p($g(^PHCFR(OrdPhQty)),"^",3)
	....s OrdNurse=$p($g(^OEORD(ordid,"I",itmid,"NUR")),"^",4)
	....s:OrdNurse'="" OrdNurse=$p($g(^SSU("SSUSR",OrdNurse)),"^",2)
	....s ret="ItmMastDesc|"_itmmastdesc_"^OrdStDate|"_ordstdate_"^OrdDoseUnit|"_OrdDoseUnit_"^OrdDoctor|"_OrdDoctor
	....s ret=ret_"^ItmCatDesc|"_ItmCatDesc_"^OrdNurse|"_OrdNurse
	....s ret=ret_"^ExecStatus|"_ExecStatus_"^OrdDose|"_OrdDose_"^OrdPhQty|"_OrdPhQty_"^orditmid_"_ordid_"__"_itmid
	....d OutAdmOrder
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAdmOrder
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdmOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmOrderExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 【南方医院取医嘱备注】

ClassMethod note(oeordId, oeoriSub) As %String
{
	q:(oeordId="")||(oeoriSub="") ""
	s notes=""
	f rnum=1:1:$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))  d
	.s notes=notes_$G(^OEORD(oeordId,"I",oeoriSub,"DEP",rnum))
	q $G(notes)
}

/// CreatDate: 2018-09-21
/// 取处理医嘱时间
/// 
ClassMethod getSeeOrderUserDateTime(oeordId As %String, oeoriSub As %String) As %String
{
	q:(oeordId="")||(oeoriSub="") ""
	;s seeOrderDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",5)
	s seeOrderTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"NUR")),"^",6)
	;i (seeOrderDate'="")&(seeOrderTime'="") q $zd(seeOrderDate,3)_" "_$zt(seeOrderTime)
	i seeOrderTime'="" q $zt(seeOrderTime,2)
	e  q ""
}

/// Creator: lulin
/// CreatDate: 2018-09-25
/// 取用法
/// w ##class(web.NurMgHISComm).getPhcinDesc()
ClassMethod getPhcinDesc(oeordId As %String, oeoriSub As %String) As %String
{
	q:(oeordId="")||(oeoriSub="") ""
	s methDr=$P($G(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    i methDr'="" q $p(^PHCIN(methDr),"^",2)
    e  q ""
}

/// 获取病人某日医嘱，临时的当天医嘱，长期的未停止医嘱（结束日期为空）
/// d ##class(%ResultSet).RunQuery("web.NurMgHISComm","FindAdmOrder","9^2015-03-10")
Query FindAdmOrderByDate(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAdmOrderByDateExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s admid=$P(parr,"^",1)
	i (+admid=0)||('$d(^PAADM(admid))) Set qHandle=$lb(0,repid,0) Quit $$$OK
	s sdate=$P(parr,"^",2)
	s:sdate["-" sdate=$zdh(sdate,3)
	i sdate="" s sdate=+$h
	s longOrder=$p(parr,"^",4)
	s IterRimOrder=$p(parr,"^",5)
	s ordid="" f  s ordid=$O(^OEORD(0,"Adm",admid,ordid)) q:ordid=""  d
	.q:+ordid=0
	.s ordsub="" f  s ordsub=$O(^OEORD(ordid,"I",ordsub)) q:ordsub=""  d
	..q:+ordsub=0
	..q:$P($g(^OEORD(ordid,"I",ordsub,1)),"^",13)'=1 // 过滤掉非核实状态 1、核实 2、作废
	..s priorDr=$P($g(^OEORD(ordid,"I",ordsub,1)),"^",8) ;医嘱优先级（类别）
	..q:priorDr=""
	..s priorDesc=$p($g(^OECPR(priorDr)),"^",2)
	..q:(longOrder=0)&&(priorDesc["长期")
	..q:(IterRimOrder=0)&&((priorDesc["临时")||(priorDesc["取药"))
	..s isExist=0
	..s ordendDate=$P($g(^OEORD(ordid,"I",ordsub,3)),"^",34) ;医嘱结束日期
	..s ordstdate=$P($g(^OEORD(ordid,"I",ordsub,1)),"^",9) ;医嘱开始日期
	..;s ordstdate=$P($g(^OEORD(ordid,"I",ordsub,3)),"^",7) ;医嘱修改日期
	..i (priorDesc["长期") d
	...i (ordendDate'="")&&(ordendDate<sdate) s isExist=1
	...i (ordstdate'="")&&(ordstdate>sdate) s isExist=1
	..e  s:ordstdate'=sdate isExist=1
	..q:isExist=1
	..s:ordstdate'="" ordstdate=$zd(ordstdate,3)
	..s arcimDr=$P($g(^OEORD(ordid,"I",ordsub,1)),"^",2) ;医嘱id
	..s itemCatDr=$P($G(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1)),"^",10)
	..s itmCatDesc=$P($g(^ARC("IC",itemCatDr)),"^",2) 
 	..s ordCatDr=$P($g(^ARC("IC",itemCatDr)),"^",8)    
	..s ordCat=$P($g(^OEC("ORCAT",ordCatDr)),"^",1)    
	..s ordCatDrStr="^"_ordCatDr_"^"
	..;大类
	..q:(($G(^DHCOEOrdPrintSet("NotOrdCat"))[ordCatDrStr)&($G(^DHCOEOrdPrintSet("NotOrdCat"))'=""))
	..s ItemCatDrStr="^"_itemCatDr_"^"
	..;子类
	..q:(($G(^DHCOEOrdPrintSet("NotSordCat"))[ItemCatDrStr)&($G(^DHCOEOrdPrintSet("NotSordCat"))'=""))&(itemCatDr'=234)  //234转科医嘱
	..s arcimDesc=$P($g(^ARCIM(+arcimDr,$P(arcimDr,"||",2),1)),"^",2)
	..;s:arcimDesc["自定义" arcimDesc=..note(ordid,ordsub)
	..i (arcimDr="23038||1")||(arcimDr="23039||1") s arcimDesc=..note(ordid,ordsub)  //自定义医嘱取备注内容
	..i arcimDesc["手术申请" s arcimDesc=arcimDesc_..note(ordid,ordsub)
	..s OrdDoctor=$P($g(^OEORD(ordid,"I",ordsub,1)),"^",11) ;开遗嘱医生
	..s:OrdDoctor'="" OrdDoctor=$p($g(^CTPCP(OrdDoctor,1)),"^",2)
	..;s OrdDose=$p($g(^OEORD(ordid,"I",ordsub,2)),"^",1) ;剂量
	..s OrdDose=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(ordid_"||"_ordsub) ;剂量
	..s OrdDoseUnit=$P($g(^OEORD(ordid,"I",ordsub,2)),"^",3) ;剂量单位
	..s:OrdDoseUnit'="" OrdDoseUnit=$p($g(^CT("UOM",OrdDoseUnit)),"^",2)
	..s OrdPhQtyID=$P($g(^OEORD(ordid,"I",ordsub,2)),"^",4) ;频率
	..s weekFlag=""
	..i OrdPhQtyID'="" s weekFlag=$P(^PHCFR(OrdPhQtyID),"^",9)
	..s orderFreqWeek=""
	..i weekFlag="Y" d
	...s orderFreqWeek=$p($g(^OEORD(+ordid,"I",ordsub,"DHC")),"^",55)
	..//用法
 	..s PhcinDesc=..getPhcinDesc(ordid,ordsub)
 	..s OrdPhQty=""
	..s:OrdPhQtyID'="" OrdPhQty=$p($g(^PHCFR(OrdPhQtyID)),"^",3)
	..i orderFreqWeek'="" s OrdPhQty=OrdPhQty_" "_$TR(orderFreqWeek,"|","")
	..s OrdNurse=$p($g(^OEORD(ordid,"I",ordsub,"NUR")),"^",4)
	..s:OrdNurse'="" OrdNurse=$p($g(^SSU("SSUSR",OrdNurse)),"^",2)
	..s OrdExtTime="" ;执行时间：【南方医院长期取核对时间】
	..i (priorDesc["长期") d
	...s OrdExtTime=..getSeeOrderUserDateTime(ordid,ordsub)
	..e  d
	...s extid="" f  s extid=$O(^OEORD(ordid,"I",ordsub,"X",extid)) q:extid=""  d
	....q:+extid=0
	....s extdate=$p($g(^OEORD(ordid,"I",ordsub,"X",extid)),"^",19)
	....;q:extdate'=sdate
	....s exttime=$p($g(^OEORD(ordid,"I",ordsub,"X",extid)),"^",20)
	....q:exttime=""
	....s exttime=$zt(exttime,2)
	....i OrdExtTime=""  s OrdExtTime=exttime
	....e  s OrdExtTime=OrdExtTime_","_exttime
	..s arcimDesc=$P(arcimDesc,"[")
	..s ret="arcimDesc|"_arcimDesc_"^OrdStDate|"_ordstdate_"^OrdDoseUnit|"_OrdDoseUnit_"^OrdDoctor|"_OrdDoctor_"^PhcinDesc|"_PhcinDesc
	..s ret=ret_"^priorDesc|"_priorDesc_"^OrdNurse|"_OrdNurse_"^OrdExtTime|"_OrdExtTime_"^itmCatDesc|"_itmCatDesc
	..s ret=ret_"^OrdDose|"_OrdDose_"^OrdPhQty|"_OrdPhQty_"^orditmid|"_ordid_"__"_ordsub
	..d OutAdmOrderByDate
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAdmOrderByDate
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdmOrderByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmOrderByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmOrderByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmOrderByDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 获取体温单身高体重(生命体征信息)
/// wangpf 身高、体重、三天以内最近的体温记录
ClassMethod GetVSData(adm As %String = "") As %String
{
	q:adm="" "^^"
	s MRADMROWId=$P($g(^PAADM(adm)),"^",61)
	q:MRADMROWId="" "^^" 
	s flag=0,flag2=0,flag3=0 //是否获取到体温、体重、身高
	s height="",weight="",temper=""
	s testDate=""  f  s testDate=$O(^MR(MRADMROWId,"OBS",0,"DateTime",testDate),-1) q:(testDate="")||((flag=1)&&(flag2=1)&&(flag3=1))  d
	.s testTime=""  f  s testTime=$O(^MR(MRADMROWId,"OBS",0,"DateTime",testDate,testTime),-1) q:(testTime="")||((flag=1)&&(flag2=1)&&(flag3=1))  d
    ..s chl="" f  s chl=$O(^MR(MRADMROWId,"OBS",0,"DateTime",testDate,testTime,chl)) q:(chl="")||((flag=1)&&(flag2=1)&&(flag3=1))  d
    ...s itemId=$P(^MR(MRADMROWId,"OBS",chl),"^")
    ...s itemCode=$p($g(^MRC("OBITM",itemId)),"^")
    ...;获取三天内最近体温记录
    ...i (itemCode="temperature")&&(flag'=1)&&(testDate>(+$h-3)) d
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s flag=1
    ...;体重
    ...i (itemCode="weight")&&(flag2'=1) d
    ....s weight=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s flag2=1
    ...;身高
    ...i (itemCode="height")&&(flag3'=1) d
    ....s height=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s flag3=1
    q height_"^"_weight_"^"_temper
	/*
	q:adm="" "^^"
	s MRADMROWId=$P($g(^PAADM(adm)),"^",61)
	q:MRADMROWId="" "^^" 
	s flag=0,flag2=0,flag3=0 
	s nurTime="",nurTime2="",nurTime3="",GetTime=""
	s StrItemold=""
	s height="",weight="",temper=""
	s StrDate=""  f  s StrDate=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate)) q:(StrDate="")  d
	.s ObDate=StrDate
	.s StrItem=""  f  s StrItem=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem)) q:(StrItem="")  d
    ..s chl="" 
    ..f  s chl=$O(^MR(MRADMROWId,"OBS",0,"Date",StrDate,StrItem,chl)) q:(chl="")  d
    ...s GetTime=$P(^MR(MRADMROWId,"OBS",chl),"^",4)
    ...;体重第一个
    ...i (StrItem="35")&&(flag2'=1) d
    ....s weight=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=GetTime
    ....s flag=1
    ...;体温最新的
    ...i (StrItem="14")&&(flag'=1) d
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime3=GetTime
    ....s flag=1
    ...i (StrItem="14")&&(flag=1)&&(GetTime>nurTime3)&&(GetTime'="")&&(nurTime3'="") d
    ....s temper=$P(^MR(MRADMROWId,"OBS",chl),"^",2)
    ....s nurTime=GetTime
    q height_"^"_weight_"^"_temper
    */
}

/// 获取病区病人数量
ClassMethod getWardPatientNum(ward As %String = "") As %String
{
	q:ward="" 0
	s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	q:'$IsObject(wardobj) 0
	q:'$IsObject(wardobj.CTLocDR) 0
	s num=0
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	q:pacward="" 0
	s room="" f  s room=$O(^PAADMi("CurrWard",pacward,room)) q:room=""  d
	.q:room=0 ;去除等候区病人
	.s adm="" f  s adm=$O(^PAADMi("CurrWard",pacward,room,adm)) q:adm=""  d
	..s num=num+1
	q num
}

///  creator:lulin
///  createdate:2018.05.03
///  description: 获取病人时间段内的最高护理等级
///  table:
///  input:就诊号^开始日期^结束时期^结束时间
///  output:
///  return:
///  other:
ClassMethod getPatCareLevel(episodeID, stDate) As %String
{
	
	s tjhl=..IfOrddailyExistByConfig(episodeID,"CRITICALCARE",stDate)
	q:tjhl=1 "特级"
	s yjhl=..IfOrddailyExistByConfig(episodeID,"FIRSTCLSCARE",stDate)
	q:yjhl=1 "一级"
	s ejhl=..IfOrddailyExistByConfig(episodeID,"SECONDCLSCARE",stDate)
	q:ejhl=1 "二级"
	s sjhl=..IfOrddailyExistByConfig(episodeID,"THIRDCLSCARE",stDate)
	q:sjhl=1 "三级"	
	q ""
}

ClassMethod IfOrddailyExistByConfig(EpisodeID, Code, stDate) As %String
{
 s arcimCodes=##class(Nur.ImageSet).GetArcCode(Code)
 q:arcimCodes="" 0
 q ..IfOrddailyExist(EpisodeID,arcimCodes,stDate)
}

ClassMethod IfOrddailyExist(EpisodeID, ArcimCodes, stDate) As %String
{
 
 s num=$l(ArcimCodes,"^")
 s ret=0
 for i=1:1:num d
 .q:ret=1
 .s code=$p(ArcimCodes,"^",i)
 .q:code=""
 .s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
 .q:rowidm=""
 .s rowid=rowidm_"||"_"1"
 .;w !,rowid
 .s ret=..GetCareType(EpisodeID, rowid,stDate)
 q ret
}

/// StrArcRowIds　医嘱需要查的医嘱的rowid串，　如"130||1^132||1^567||1"
/// 
ClassMethod GetCareType(AdmNo, StrArcRowIds, stDate) As %String
{
 	s AdmNo=$g(AdmNo)
 	s StrArcRowIds=$g(StrArcRowIds) 
 	set retno=0
 	q:AdmNo="" 0
 	q:StrArcRowIds="" 0
 	set ord=$o(^OEORD(0,"Adm",AdmNo,""))
 	q:ord="" 0
 	s num=$l(StrArcRowIds,"^")
 	s flag=0
 	s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime)) q:(ordSttTime="")!(retno=1)  d
 	.s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub)) q:(OrdSub="")!(retno=1)  d
 	..s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,stDate,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(retno=1)  d
 	...;s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 	...s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",13)
 	...s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 	...q:(ordStat'="V")&(ordStat'="E")
 	...q:StrArcRowIds'=$p($g(^OEORD(ord,"I",OrdSub,1)),"^",2)
 	...s retno=1
 	q retno
}

ClassMethod GetHtmlDateFormat() As %String
{
	S format = ..DateFormat()
	s ret="yyyy-MM-dd^yyyy-MM^3"
	i format=1 s ret="MM/dd/yyyy^MM/yyyy^1"
	e  i format=4 s ret="dd/MM/yyyy^MM/yyyy^4"
	q ret
}

/// modify by wuqk 2011-06-22 websys.Conversions 根据config修改输出格式
/// w ##class(web.NurMgHISComm).DateHtmlToLogical("-12-1")
ClassMethod DateHtmlToLogical(d As %String) As %String [ Final ]
{
	;Q $$intdate^SSUTIL4(d)
	s $ZT="Err"
	Q:d="" ""	;ARCOrdSets.Edit->ARCOSEffDateTo
	Q:d?1n.n d
	S format = ..DateFormat()
	if d["-" Set format = 3
	if d["/" {
		if $p(d,"/")>1840{ //这种格式是win7和win10默认的日期格式  2017/9/27
			Set d = $p(d,"/",3)_"/"_$p(d,"/",2)_"/"_$p(d,"/",1)
		}
		Set format = 4
	}
	Q $zdh(d,format)
Err
	Q "ERROR!"
}

/// 获取系统日期格式配置websys.Conversions
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
ClassMethod DateFormat()
{
	q 3
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 3
}

/// modify by websys.Conversions 根据config修改输出格式
/// w ##class(web.NurMgHISComm).DateLogicalToHtml(64253) $h
ClassMethod DateLogicalToHtml(h As %String) As %String [ Final ]
{
	s $ZT="Err"
	;return month/day/year
	;w ##class(websys.Conversions).DateLogicalToHtml()
	s val=""
	Q:h="" ""
	; 不全是数字且不包含逗号,则返回
	Q:(h'?1n.n)&&(h'[",") h
	s $ZT="Err"
	Set format = ..DateFormat()
	Set date = $zd(h,format)
	if (format=4){
		Set date = $zd(h,format)
		Set $p(date,"/",3)=+$zd(h,3)
	}
	quit date
Err
	Q "ERROR!"
}

/// Creator:gzj
/// Date:2019-06-21
/// Description:根据类型获取系统参数描述
ClassMethod GetDescForSysType(type As %String, param As %String) As %String
{
	q:(type=""!param="") ""
	s ret=""
	s Par=$o(^DHCNMG.Set.MgSysParamI("Code"," "_$zcvt($tr(type," ",""),"U"),""))
	q:Par="" ""
	s rw=$o(^DHCNMG.Set.MgSysParamSubI("Code"," "_$zcvt($tr(param," ",""),"U"),Par,""))
	q:rw="" ""
	s obj=##class(DHCNMG.Set.MgSysParamSub).%OpenId(Par_"||"_rw)
	q:'$IsObject(obj) ""
	s ret=obj.SubDesc
	q ret
}

// 判定患者三天内是否曾经发过烧

ClassMethod IfFeverInThreeDay(EpisodeID As %String, wardfire) As %String
{
 s adm=EpisodeID
 s retValue=0
 s Mradm=""
 s Mradm=$P(^PAADM(adm),"^",61) 
 if $g(Mradm) ="" q $G(retValue)
 s temperatureDr=$o(^MRC("OBITM",0,"Code",$$ALPHAUP^SSUTIL4("temperature"),""))
 s Childsub=0  
 f  s Childsub=$o(^MR(Mradm,"OBS",Childsub)) q:$g(Childsub)=""  d
 .s OBSDate = $p(^MR(Mradm,"OBS",Childsub),"^",3)
 .i (+OBSDate > (+$h-3)) & (+OBSDate <= +$h) d 
 ..s itemdr = $p(^MR(Mradm,"OBS",Childsub),"^",1)
 ..s OBSvalue= $p(^MR(Mradm,"OBS",Childsub),"^",2)
 ..i (+itemdr =temperatureDr) &( +OBSvalue > wardfire) d
 ...s retValue =1
 
 q $G(retValue)
}

}
