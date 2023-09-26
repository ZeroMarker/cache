/// Creator:
/// Descriptions:HIS公共方法类
/// Date:
Class web.INMHISComm Extends %RegisteredObject
{

/// 获取专业组名称
ClassMethod GetWardProGroup(id) As %String
{
	q:id="" ""
	s desc=""
	i $D(^oddCOM("CF.NUR.NIS.WardProGroup"))=0 d
	.s desc=$p($g(^DHCWardProGroup(id)),"^",2)
	e  d
	.s desc=$p($g(^CF.NUR.NIS.WardProGroup(id)),"^",2)	
	q desc
}

/// 获取患者年龄
ClassMethod GetPatAge(patAge) As %String
{
	q:patAge="" ""
	s patage=##class(web.INMVueComm).CalAge(patAge,+$h)
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
	q years
}

/// 获取诊断名称【产品部要求格式统一】
ClassMethod GetDiagnosDesc(mrAdm As %String = "", mrDiagnosId As %String = "") As %String
{
	q:((mrAdm="")||(mrDiagnosId="")) ""
	s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1) ;MRCICDDx
	q:icd="" ""
	s icdDesc=$p(^MRC("ID",icd),"^",2)
	s Prefix=$p($g(^MR(mrAdm,"DIA",mrDiagnosId,1)),"^",26)
	s Suffix=$g(^MR(mrAdm,"DIA",mrDiagnosId,"DES",1))
	s diagStat=$p($g(^MR(mrAdm,"DIA",mrDiagnosId)),"^",9)
	s:diagStat'="" diagStat=$p(^MRC("DSTAT",diagStat),"^",2)
	s diagnos=Prefix_icdDesc_Suffix_$select(diagStat'="":" "_diagStat,1:"")
	q diagnos
}

/// Creator:lulin
/// Createdate:2020-06-01
/// Description:根据工号获取ssuserid
/// Input:
/// Output:
/// Other:
ClassMethod GetUserIdByCode(userCode As %String) As %String
{
	s hisId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	q hisId
}

/// Creator:
/// Createdate:
/// Description:查询ctloc列表
/// Input:
/// Output:
/// Other:
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
	..s wardid=$O(^CF.DHCINM.DB.MgWardI("CTLoc",locid,""))
	..i wardid'="" s locflag="true"
	..e  s locflag="false"
	..i locflag'="true" d
	...s wardLocId=$O(^CF.DHCINM.DB.MgWardLocI("Loc",locid,""))
	...i wardLocId'="" s locflag="true"
	..s loccode=$replace($tr(loccode," ",""),"\","\\")
	..s locdesc=$replace($tr(locdesc," ",""),"\","\\")
	..s locContant=##class(web.INMVueComm).ToChineseSpell(locdesc)
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

ClassMethod GetHtmlDateFormat() As %String
{
	S format = ..DateFormat()
	s ret="yyyy-MM-dd^yyyy-MM^3"
	i format=1 s ret="MM/dd/yyyy^MM/yyyy^1"
	e  i format=4 s ret="dd/MM/yyyy^MM/yyyy^4"
	q ret
}

/// Creator:
/// Createdate:
/// Description:html日期格式转为m日期格式
/// Input:
/// Output:
/// Other:
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

/// Creator:
/// Createdate:
/// Description:获取m中his的日期格式代码
/// Input:
/// Output:
/// Other:
ClassMethod DateFormat()
{
	q 3 ;暂时不要动,如果需要根据HIS日期格式修改则注释掉即可
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 3
}

/// Creator:
/// Createdate:
/// Description:his日期格式转为html日期格式
/// Input:
/// Output:
/// Other:
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
	//Set format = ..DateFormat()
	s format=3  ;日期根据his显示完全放到前端处理，此方法不在使用，已使用的固定死用YYYY-MM-dd模式
	Set date = $zd(h,format)
	if (format=4){
		Set date = $zd(h,format)
		Set $p(date,"/",3)=+$zd(h,3)
	}
	quit date
Err
	Q "ERROR!"
}

/// Creator:
/// Createdate:
/// Description:his日期格式转为html日期格式
/// Input:
/// Output:
/// Other:
ClassMethod DateLogicalToHtmlNew(h As %String) As %String [ Final ]
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

/// -------公共方法分割线-------------
/// creator: llin
/// createdate: 2018-08-08
/// description: 获取科室床位分组列表
/// table:
/// input:
/// output:
/// return:
/// other:d ##class(%ResultSet).RunQuery("web.INMHISComm","FindBedList","1","")
Query FindBedGroupList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindBedGroupListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s ^TMP("FindBedList")=parr_"%"_input
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	i $D(^oddCOM("CF.NUR.NIS.WardProGroup"))=0 d
	.s subid=0 f  s subid=$O(^DHCWardProGroup(0,"WardDr",pacward,subid)) q:subid=""  d
	..s activeFlag=$p(^DHCWardProGroup(subid),"^",3)
	..q:activeFlag'="Y"
	..s groupDesc=$p(^DHCWardProGroup(subid),"^",2)
	..s ret="groupDesc|"_groupDesc_"^rw|"_subid
	..d OutBedGroupData
	e  d
	.s rowid=0 f  s rowid=$o(^CF.NUR.NIS.WardProGroup(0,"WardDr",pacward,rowid)) q:rowid=""  d
	..s gourpDataLB=$g(^CF.NUR.NIS.WardProGroup(rowid))
	..q:gourpDataLB=""
	..s activeFlag=$p(gourpDataLB,"^",3)
	..q:activeFlag'="Y"
    ..s desc=$p(gourpDataLB,"^",2)
    ..s ret="groupDesc|"_desc_"^rw|"_rowid
	..d OutBedGroupData
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

/// creator: xbl
/// createdate: 20171016
/// description: 获取科室床位列表
/// table:
/// input:
/// output:
/// return:
/// other: d ##class(%ResultSet).RunQuery("web.INMHISComm","FindBedList","1","")
Query FindBedList(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindBedListExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ward=$P(parr,"^",1)
	i ward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s wardobj=##class(CF.DHCINM.DB.MgWard).%OpenId(ward)
	i wardobj.CTLocDR="" Set qHandle=$lb(0,repid,0) Quit $$$OK 
	s loc=wardobj.CTLocDR.%Id()
	s pacward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	i pacward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s subid=0 f  s subid=$O(^PAWARD(pacward,"BED",subid)) q:subid=""  d
	.q:$p(^PAWARD(pacward,"BED",subid),"^",4)'="Y"
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
	i $D(^oddCOM("CF.NUR.NIS.WardProGroup"))=0 d 
	.s id="" f  s id=$O(^DHCWardProGroupBed(0,"GroupDr",parr,id)) q:id=""  d
	..q:+id=0
	..s bedid=$P(^DHCWardProGroupBed(id),"^",3)
	..q:bedid=""
	..;s bedcode=$P(^PAWARD(+bedid,"BED",$p(bedid,"||",2)),"^",1)
	..i ret="" s ret=bedid
	..e  s ret=ret_","_bedid
	e  d
	.s rowid=0 f  s rowid=$o(^CF.NUR.NIS.WardProGroupBed(0,"GroupDr",parr,rowid)) q:rowid=""  d
	..s dataLB=$g(^CF.NUR.NIS.WardProGroupBed(rowid))
	..q:dataLB=""
    ..s pacBed=$p(dataLB,"^",3)
    ..q:pacBed=""
    ..i ret="" s ret=pacBed
	..e  s ret=ret_","_pacBed
	q ret
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

/// Description：根据登记号获取住院患者最新一条就诊记录
/// Date:2020-07-03
/// Creator:wangpf
/// Table:User.PAAdm
/// Input: 登记号
/// Output:就诊记录
/// Other: w ##class(web.INMHISComm).GetLastAdm("0000000008")
ClassMethod GetLastAdm(regNo As %String = "") As %String
{
	s regNo=$zcvt(regNo,"U")
	s regId=$o(^PAPERi("PAPMI_PatNo",regNo,""))
	q:regId="" ""
	s admId=$o(^PAPERdr(regId,"ADM","I",""))
	q:admId="" ""
	
	s patientName=$p(^PAPER(regId,"ALL"),"^",1)
	s patientAge=$p(^PAPER(regId,"ALL"),"^",6)
	s patientAge=..GetPatAge(patientAge)
	s patientSex=$p(^PAPER(regId,"ALL"),"^",7)
	s:patientSex'="" patientSex=$p(^CT("SEX",patientSex),"^",2)
	s admCTLoc=$p(^PAADM(admId),"^",4)
	s admCTLocDesc=""
	s:admCTLoc'="" admCTLocDesc=$p(^CTLOC(admCTLoc),"^",2)
	s mrAdm=$p(^PAADM(admId),"^",61)
	s diagnos=""
	i mrAdm'="" d
	.s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	..s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1) ;MRCICDDx
	..q:icd=""
	..s icdDesc=..GetDiagnosDesc(mrAdm,mrDiagnosId)
	..q:icdDesc=""
	..s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc
	..s index=index+1
	s ret="PAPatMasId|"_regId_"^PatientName|"_patientName_"^PatientAge|"_patientAge_"^PatientSex|"_patientSex
	s ret=ret_"^CTLoc|"_admCTLoc_"^CTLocDesc|"_admCTLocDesc_"^PatientDiagnos|"_diagnos
	q ret
}

/// Description：根据登记号获取就诊记录
/// Date:2020-07-04
/// Creator:wangpf
/// Table:User.PAAdm
/// Input: 登记号
/// Output:就诊记录
/// Other:d ##class(%ResultSet).RunQuery("web.INMHISComm","FindAdmList","")
Query FindAdmList(regNo As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, regNo As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i regNo="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s regNo=$zcvt(regNo,"U")
	
	k tmp
	s regId="" f  s regId=$o(^PAPERi("PAPMI_PatNo",regNo,regId)) q:regId=""  d
	.s patientName=$p(^PAPER(regId,"ALL"),"^",1)
	.s patientAge=$p(^PAPER(regId,"ALL"),"^",6)
	.s patientSex=$p(^PAPER(regId,"ALL"),"^",7)
	.s:patientSex'="" patientSex=$p(^CT("SEX",patientSex),"^",2)
	.s patientAge=..GetPatAge(patientAge)
	.s admType="" f  s admType=$o(^PAPERdr(regId,"ADM",admType)) q:admType=""  d
	..s adTypeDesc=$case(admType,"I":"住院","O":"门诊","E":"急诊","N":"新生儿","H":"体检",:"")
	..s admId="" f  s admId=$o(^PAPERdr(regId,"ADM",admType,admId)) q:admId=""  d
	...s admDate=$p(^PAADM(admId),"^",6)
	...s admDateH=admDate
	...s:admDate'="" admDate=$zd(admDate,3)
	...s admTime=$p(^PAADM(admId),"^",7)
	...s:admTime'="" admTime=$zt(admTime,1)
	...s admCTLoc=$p(^PAADM(admId),"^",4)
	...s admCTLocDesc=""
	...s:admCTLoc'="" admCTLocDesc=$p(^CTLOC(admCTLoc),"^",2)
	...s mrAdm=$p(^PAADM(admId),"^",61)
	...s diagnos=""
	...i mrAdm'="" d
	....s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	.....s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1)
	.....q:icd=""
	.....s icdDesc=..GetDiagnosDesc(mrAdm,mrDiagnosId)
	.....q:icdDesc=""
	.....s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc
	.....s index=index+1
	...s ret="AdmId|"_admId_"^PAPatMasId|"_regId_"^AdmType|"_admType_"^AdmTypeDesc|"_adTypeDesc_"^AdmDate|"_admDate_"^AdmTime|"_admTime_"^PatientName|"_patientName
	...s ret=ret_"^PatientAge|"_patientAge_"^PatientSex|"_patientSex_"^CTLoc|"_admCTLoc_"^CTLocDesc|"_admCTLocDesc_"^PatientDiagnos|"_diagnos_"^RegNo|"_regNo
	...s tmp(admDateH,admId)=ret
	
	s date="" f  s date=$o(tmp(date),-1) q:date=""  d
	.s id="" f  s id=$O(tmp(date,id)) q:id=""  d
	..s ret=tmp(date,id)
	..d OutAdmList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutAdmList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdmListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmListExecute ]
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

/// Description：获取病区当前在院患者列表
/// Date:2020-07-11
/// Creator:wangpf
/// Table:PAADM
/// Input: 病区id
/// Output:病区当前在院患者列表
/// Other:d ##class(%ResultSet).RunQuery("web.INMHISComm","FindWardPatList","1")
Query FindWardPatList(ward As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindWardPatListExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	i (ward="")||('$d(^CF.DHCINM.DB.MgWardD(ward))) Set qHandle=$lb(0,repid,0) Quit $$$OK
	
	s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	s ctLoc=$lg(wardGlo,2)
	k retTmp
	s retTmp=""
	i ctLoc'="" d
	.s pacWard=$o(^PAWARD(0,"WARD_LocationDR",ctLoc,""))
	.q:pacWard=""
	.s room="" f  s room=$o(^PAADMi("CurrWard",pacWard,room)) q:room=""  d
	..s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacWard,room,episodeId)) q:episodeId=""  d
	...s admType=$p(^PAADM(episodeId),"^",2)
	...q:admType'="I"
	...s regId=$p(^PAADM(episodeId),"^",1)
	...;s regNo=$tr($justify(regId,10)," ","0")
	...s regNo=$P(^PAPER(regId,"PAT",1),"^",1)
	...s patName=$p(^PAPER(regId,"ALL"),"^",1)
	...s patAge=$p(^PAPER(regId,"ALL"),"^",6)
	...s patSex=$p(^PAPER(regId,"ALL"),"^",7)
	...s:patSex'="" patSex=$p(^CT("SEX",patSex),"^",2)
	...s patAge=..GetPatAge(patAge)
	...s bedCode="",bedSort=9999
	...s bedId=$p(^PAADM(episodeId),"^",73)
	...i bedId'="" d
	....s bedWardId=$p(bedId,"||")
	....s bedSubId=$p(bedId,"||",2)
	....s bedCode=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",1)
	....s bedSort=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",24)
	...s diagnos=""
	...s mrAdm=$p(^PAADM(episodeId),"^",61)
	...i mrAdm'="" d
	....s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	.....s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1)
	.....q:icd=""
	.....s icdDesc=..GetDiagnosDesc(mrAdm,mrDiagnosId)
	.....q:icdDesc=""
	.....s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc
	.....s index=index+1
	...s:bedCode'="" patName=patName_"("_bedCode_")"
	...s ret="AdmId|"_episodeId_"^PAPatMasId|"_regId_"^PatientName|"_patName_"^PatientAge|"_patAge_"^PatientSex|"_patSex_"^PatientDiagnos|"_diagnos
	...s ret=ret_"^BedCode|"_bedCode_"^RegNo|"_regNo
	...s:bedCode="" bedCode="ZZZZ"
	...s bedCode="+"_bedCode
	...s:bedSort'="" bedCode=bedSort
	...s retTmp(bedCode,episodeId)=ret
	s bedCode="" f  s bedCode=$O(retTmp(bedCode)) q:bedCode=""  d
	.s episodeId="" f  s episodeId=$O(retTmp(bedCode,episodeId)) q:episodeId=""  d
	..s ret=$g(retTmp(bedCode,episodeId))
	..d OuPatientList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OuPatientList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindWardPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardPatListExecute ]
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

/// Creator:gzj
/// Date:2019-06-21
/// Description:根据类型获取系统参数描述
ClassMethod GetDescForSysType(type As %String, param As %String) As %String
{
	q:(type=""!param="") ""
	s ret=""
	s Par=$o(^CT.DHCINM.Set.MgSysParamI("Code"," "_$zcvt($tr(type," ",""),"U"),""))
	q:Par="" ""
	s rw=$o(^CT.DHCINM.Set.MgSysParamSubI("Code"," "_$zcvt($tr(param," ",""),"U"),Par,""))
	q:rw="" ""
	s obj=##class(CT.DHCINM.Set.MgSysParamSub).%OpenId(Par_"||"_rw)
	q:'$IsObject(obj) ""
	s ret=obj.SubDesc
	q ret
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

ClassMethod GetArcCode(Code) As %String
{
    s rw=$O(^Nur.ImageSetI("Code"," "_Code,""))
    s arccode=""
    if rw'=""
    {
       s a=##class(Nur.ImageSet).%OpenId(rw)
       s arccode=a.ArcimCodeS
       q arccode
    }
    q arccode
}

ClassMethod IfOrddailyExistByConfig(EpisodeID, Code, stDate) As %String
{
 s ret=0
 s rw="" f  s rw=$O(^Nur.ImageSetI("Code"," "_Code,rw)) q:((rw="")||(ret=1))  d
 .s a=##class(Nur.ImageSet).%OpenId(rw)
 .q:'$IsObject(a)
 .s arccode=a.ArcimCodeS
 .q:arccode=""
 .s ret=..IfOrddailyExist(EpisodeID,arccode,stDate)
 q ret
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

/// Creator:lulin
/// Description:获取根据日期获取某病区实际床位数
/// Date:2021-04-26
/// Table:
/// Input:
/// Output：
/// Others:w ##class(web.INMHISComm).GetWardBedData(+$H,6)
ClassMethod GetWardBedData(date As %String = "", selectWard As %String = "") As %String
{
	s ret=0
	q:selectWard="" ret
	s locId=$lg($g(^CF.DHCINM.DB.MgWardD(selectWard)),2)
	q:locId="" ret
	s selectpacward=$O(^PAWARD(0,"WARD_LocationDR",locId,""))
	q:selectpacward="" ret
	s pacward="" f  s pacward=$o(^PAWARD(0,"WardRoom",pacward)) q:pacward=""  d
	.q:selectpacward'=pacward
	.s roomid="" f  s roomid=$o(^PAWARD(0,"WardRoom",pacward,roomid)) q:roomid=""  d
	..s bedchlid="" f  s bedchlid=$o(^PAWARD(0,"WardRoom",pacward,roomid,bedchlid)) q:bedchlid=""  d
	...s pacBedLB=$g(^PAWARD(pacward,"BED",bedchlid))
	...q:pacBedLB=""
	...s BEDRcFlag=$P(pacBedLB,"^",4)
	...q:BEDRcFlag'="Y"
	...s CTLocId=$P($g(^PAWARD(pacward)),"^",5)
	...q:CTLocId=""
	...s BEDCode=$P(pacBedLB,"^",1)
	...q:((BEDCode["婴儿")||(BEDCode["BABY"))
	...;根据启停时间过滤
	...s BEDDateFrom=$P(pacBedLB,"^",21)
	...s BEDDateTo=$P(pacBedLB,"^",22)
	...q:((BEDDateFrom'="")&&(date'="")&&(BEDDateFrom>date))
	...q:((BEDDateTo'="")&&(date'="")&&(BEDDateTo<date))
	...s ret=ret+1
	q ret
}

/// Creator:lulin
/// Description:获取在院患者数
/// Date:2021-04-26
/// Table:
/// Input:
/// Output：
/// Others:
ClassMethod GetWardPatNum(ward As %String = "", bedFlag As %String = "") As %String
{
	q:ward="" 0
	s wardGlo=$g(^CF.DHCINM.DB.MgWardD(ward))
	q:wardGlo="" 0
	s ctLoc=$lg(wardGlo,2)
	q:ctLoc="" 0
	s pacWard=$o(^PAWARD(0,"WARD_LocationDR",ctLoc,""))
	q:pacWard="" 0
	s num=0
	s room="" f  s room=$o(^PAADMi("CurrWard",pacWard,room)) q:room=""  d
	.s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacWard,room,episodeId)) q:episodeId=""  d
	..s admType=$p(^PAADM(episodeId),"^",2)
	..q:admType'="I"
	..s bedId=$p(^PAADM(episodeId),"^",73)
	..q:((bedFlag=1)&&(bedId=""))
	..s BorrowBeds=..getBorrowBeds(episodeId,pacWard)
	..s bedNum=BorrowBeds+1
	..s num=num+bedNum
	s transPatNum=0  // 转出区患者数量
	s transPatBabyNum=0  // 转出区婴儿患者数量
    s sub=0 
    f  s sub=$o(^Nur.DHCNurTransAuditI("CurWardStatus"," "_pacWard," A",sub)) q:sub=""  d
    .s transAudit=$g(^Nur.DHCNurTransAuditD(sub))
    .s transEpisodeID=$listget(transAudit,2)
    .s visitStatus=$p(^PAADM(transEpisodeID),"^",20)
   	.q:visitStatus'="A"
    .s admWardID=$listget(transAudit,12)
    .q:($G(admWardID)'=pacWard)
    .s motherAdm=$p(^PAADM(transEpisodeID),"^",75)
	.i motherAdm'="" d
	..s transPatBabyNum=transPatBabyNum+1
	.e  s transPatNum=transPatNum+1
    s num=num-transPatNum
	q num
}

ClassMethod getBorrowBeds(EpisodeID, wardId) As %String
{
	s ret=""
	s bedSub=""
	f
	{
		s bedSub=$O(^PAWARDA(0,"SADM",EpisodeID,wardId,bedSub))
		q:bedSub=""
		s subId=""
		f
		{
			s subId=$O(^PAWARDA(0,"SADM",EpisodeID,wardId,bedSub,subId))
			q:subId=""
			s bedReasonId=$p($g(^PAWARDA(wardId,"BED",bedSub,"STAT",subId)),"^",7)
			q:bedReasonId=""
			s bedReason=$p($g(^PAC("RNAV",bedReasonId)),"^",2)
			q:bedReason'="包床"
			s ret=ret+1
		}
	}
	q ret
}

/// 判断医嘱属于哪个护士执行单据
/// oeordID：医嘱ID oeoriSub:医嘱ID-子ID wardID:PAC_Ward 病区ID
/// w ##class(Nur.Test.OrderTest).GetCodeResultByOrdId("1","168","3")
ClassMethod GetCodeResultByOrdId(oeordID, oeoriSub, wardID)
{
	s $zt="ErrResult21"
	s code = ""
	// 根据就诊获取医院ID
	s episodeID = +$g(^OEORD(oeordID))
	q:episodeID="" code
	s admLocId = $p($g(^PAADM(episodeID)),"^",4)
	s hostpitalDR = $p($g(^CTLOC(admLocId)),"^",22)
	s hostpitalID = 0
	// 判断当前医院是否存在单据配置 2022.4.21
	i $d(^Nur.NurseSheetSetI("CODE"," "_hostpitalDR)) s hostpitalID = hostpitalDR
	s tmpCode = ""
	for
	{
		s tmpCode = $O(^Nur.NurseSheetSetI("CODE"," "_hostpitalID,$zcvt(tmpCode,"U")))
		q:tmpCode=""
		s sheetCode = $replace(tmpCode," ","")
		// 跳过需处理
		continue:(sheetCode["DEFAULTSEE")
		s flag = ..GetOneCodeFlagByOrdId(oeordID, oeoriSub, wardID, sheetCode, hostpitalID)
		if (flag="Y") 
		{
			if (code="")
			{
				s code = sheetCode
			}else
			{
				s code = code_","_sheetCode
			}
		}
	}
	q code
ErrResult21
	w $ze ,!
	q code
}

/// 判断当前医嘱是否属于当前单据
/// oeordID：医嘱ID oeoriSub:医嘱ID-子ID wardID:PAC_Ward 病区ID sheetCode:护士执行单据Code
/// w ##class(Nur.Test.OrderTest).GetOneCodeFlagByOrdId("1","168","3","HLZLD","2")
ClassMethod GetOneCodeFlagByOrdId(oeordID, oeoriSub, wardID, sheetCode, hostpitalID)
{
	s $zt="ErrException0421"
	s ret="N"
	s episodeID=+$g(^OEORD(oeordID))
	q:episodeID="" ret
	s sheetSetting=##class(Nur.CommonInterface.OrderSheet).getSheetSetting(sheetCode,hostpitalID)
	q:(oeordID="")!(oeoriSub="") ret
	s seeType=$P($G(^OEORD(oeordID,"I",oeoriSub,"NUR")),"^",7)
	s ordSeqID=$p($g(^OEORD(oeordID,"I",oeoriSub,11)),"^",39)
	q:ordSeqID'="" ret
	s ordStatID=$p($G(^OEORD(oeordID,"I",oeoriSub,1)),"^",13) 
	q:ordStatID="" ret
	s ctcptType="DOCTOR"
	s locID=$p(^PAWARD(wardID),"^",5)
	i locID'="" s locType=$p(^CTLOC(locID),"^",13)
	//过滤非本科本病区下的医护人员医嘱
	i $g(curWardLinkDocFlag(oeordID,oeoriSub))="" d
	.s curWardLinkDocFlag=##Class(web.DHCNurCom).OrdWardLinkDoc(wardID,ctcptType,"",oeordID_"||"_oeoriSub)
	.s curWardLinkDocFlag(oeordID,oeoriSub)=curWardLinkDocFlag
	.s curLocLinkDocFlag=##class(Nur.IP.NurseExcute).OrdLocLinkWard(locID,ctcptType,oeordID_"||"_oeoriSub)
	.s curLocLinkDocFlag(oeordID,oeoriSub)=curLocLinkDocFlag
	//下医嘱科室
	s ordLocType=""
	s ordDep=$p($g(^OEORD(oeordID,"I",oeoriSub,7)),"^",2)
	i ordDep'="" s ordLocType=$p(^CTLOC(ordDep),"^",13)
	s stage=$p($g(^OEORD(oeordID,"I",oeoriSub,"DHC")),"^",8)	
	s admVisitStatus=$p(^PAADM(episodeID),"^",20)
	s deliveryRommID=##class(Nur.IP.Delivery).getDeliveryRoomID(episodeID)
	s ifDeliveryRoom=0
	//表示当前是产房
	s:deliveryRommID=locID ifDeliveryRoom=1			
	s ifConsultOrd=##class(Nur.IP.DrugAudit).IfConsultOrd(locID,oeordID,oeoriSub)  ///病区关联科室申请的会诊医嘱
	q:(wardID'="")&(curWardLinkDocFlag(oeordID,oeoriSub)'="Y")&(locType="OP")&&(admVisitStatus'="P")&(ifDeliveryRoom=0)&(ifConsultOrd="N") ret
	q:(curLocLinkDocFlag(oeordID,oeoriSub)'="Y")&(locType'="OP")&&(admVisitStatus'="P")&(ifDeliveryRoom=0)&(ifConsultOrd="N") ret
	//过滤掉非本科室医生所下的非产中医嘱
	q:(ifDeliveryRoom=1)&&((curLocLinkDocFlag(oeordID,oeoriSub)'="Y")!(stage'="CZ")) ret
	s oeoriSubInit=oeoriSub
	s oeoreSubInit=""
	d initSeeFilterInfo
	// 此处可能有问题 TODO
	/*
	//标准版功能,南方医院不用 start
	q:disposeStatCode="" ret
	q:((disposeStatCode="NeedToDeal")!(disposeStatCode="NeedToStop")) ret
	q:((disposeStatCode="AlreadyDeal")!(disposeStatCode="AlreadyStop")) ret
	//end
	q:((disposeStatCode="SpecmentReject")!(disposeStatCode="RefuseDispDrug")) ret //安贞新加医嘱状态处理
	*/
	k tmpVar
	d filterSee
	q:$g(tmpVar(oeordID,oeoriSub))=0 ret
	s ret="Y"
	q ret
initSeeFilterInfo //初始化过滤医嘱执行记录需要判断的信息	
	s arcimID=$p($g(^OEORD(oeordID,"I",oeoriSubInit,1)),"^",2)
	s arcicID=$p($g(^ARCIM(+arcimID,$p(arcimID,"||",2),1)),"^",10)
	s orcatID=""
	i arcicID'="" s arcicID=+arcicID,orcatID=$p($g(^ARC("IC",arcicID)),"^",8) 
	s oecprID=$p($g(^OEORD(oeordID,"I",oeoriSubInit,1)),"^",8)
	s phcinID=$p($g(^OEORD(oeordID,"I",oeoriSubInit,2)),"^",7) 
	s specCode=$p($g(^OEORD(oeordID,"I",oeoriSubInit,"SPEC",1)),"^")
	s reclocID=$p($g(^OEORD(oeordID,"I",oeoriSubInit,3)),"^",6)
	s stage=$p($g(^OEORD(oeordID,"I",oeoriSubInit,"DHC")),"^",8)
	s ordStatusID=$p($G(^OEORD(oeordID,"I",oeoriSubInit,1)),"^",13) 
	// s disposeStatCode=##class(Nur.NIS.Service.Base.Order).GetOrderDisposeStatCode(oeordID,oeoriSubInit)
	q
filterSee   //过滤执行记录 @tmpVar=0 表示不符合条件需要过滤
	s tmpVar(oeordID,oeoriSub)=1
	s:oecprID'="" priorDesc=$P(^OECPR(oecprID),"^",2) 
	s ifShortOrderPrior=##class(appcom.OEOrdItem).ISShortOrderPrior(oecprID)	//调用医生站接口判断是否是临时医嘱
	s:(locType="OP")&(ifShortOrderPrior=0) tmpVar(oeordID,oeoriSub)=0  //手术护士过滤长期($g(priorDesc)["长期")
	q:tmpVar(oeordID,oeoriSub)=0	
	//医嘱阶段
	s:(sheetSetting.GetAt("stage")'[("^"_stage_"^"))&(stage'="") tmpVar(oeordID,oeoriSub)=0 
	q:tmpVar(oeordID,oeoriSub)=0
	s:(sheetSetting.GetAt("StateStr")'[("^"_ordStatusID_"^"))&(ordStatusID'="") tmpVar(oeordID,oeoriSub)=0 
	q:tmpVar(oeordID,oeoriSub)=0
	//优先级
	s:(sheetSetting.GetAt("priorityStr")'[("^"_oecprID_"^"))&(oecprID'="") tmpVar(oeordID,oeoriSub)=0 
	q:tmpVar(oeordID,oeoriSub)=0
	//用法途径		          
	s:(sheetSetting.GetAt("phcinStr")'[("^"_phcinID_"^"))&(phcinID'="") tmpVar(oeordID,oeoriSub)=0  
	q:tmpVar(oeordID,oeoriSub)=0
	//医嘱子类	 
	s:(sheetSetting.GetAt("catgoryStr")'[("^"_arcicID_"^"))&(arcicID'="") tmpVar(oeordID,oeoriSub)=0	
	q:tmpVar(oeordID,oeoriSub)=0	     
	//标本类型	   
	s:(sheetSetting.GetAt("specCodeStr")'[("^"_specCode_"^"))&(specCode'="") tmpVar(oeordID,oeoriSub)=0
	q:tmpVar(oeordID,oeoriSub)=0		     
	//接受科室
	s:(sheetSetting.GetAt("reclocStr")'[("^"_reclocID_"^"))&(reclocID'="")&(sheetSetting.GetAt("reclocStr")'="^^") tmpVar(oeordID,oeoriSub)=0
	q
ErrException0421
	w $ze ,!
	q ret
}

/// Description: 获取排班看板统计
/// Date: 2022-03-01
/// Creator: wangpf
/// Table:
/// Input: nurseid
/// Output: 排班看板统计
/// Other: w ##class(web.INMHISComm).GetNurPatSta(0,0)
ClassMethod GetNurPatSta(nurseid As %String = "", appFlag As %String = "0") As %ArrayOfDataTypes
{
	k tmpWard
	s isAll=##class(web.INMLoginComm).SetLoginWard(nurseid,.tmpWard)
	
	s bed=0,pat=0,perInHos=0,perInPos=0
	s id="" f  s id=$o(^CF.DHCINM.DB.MgWardD(id)) q:id=""  d
	.q:(isAll'=1)&&('$d(tmpWard(id)))
	.s wardGlo=^CF.DHCINM.DB.MgWardD(id)
	.s stDate=$lg(wardGlo,11)
	.s endDate=$lg(wardGlo,12)
	.q:(stDate="")||(stDate>+$h)||((endDate'="")&&(endDate<+$h))
	.s bed=..GetWardBedData(+$h,id)
	.s pat=..GetWardPatNum(id,"")
	.s tId="" f  s tId=$o(^CF.DHCINM.HR.PersonsI("DepID"," "_id,tId)) q:tId=""  d
	..q:'$d(^CF.DHCINM.HR.PersonsD(tId))
	..s perGlo=^CF.DHCINM.HR.PersonsD(tId)
	..s perType=$lg(perGlo,25)
	..q:perType'="N"
	..s perStatus=$lg(perGlo,42)
	..q:perStatus'="17||1"
	..s perInHos=perInHos+1
	..s:$d(^DHCINM.Arg.MgArrangeSubI("PerDate",tId,+$h)) perInPos=perInPos+1
	
	s ret="Bed|"_bed_"^Pat|"_pat_"^PerInHos|"_perInHos_"^PerInPos|"_perInPos
	s appRet=##class(%ArrayOfDataTypes).%New()
	d appRet.SetAt(bed,"Bed")
	d appRet.SetAt(pat,"Pat")
	d appRet.SetAt(perInHos,"PerInHos")
	d appRet.SetAt(perInPos,"PerInPos")
	q:appFlag=1 appRet
	q ret
}

/// 按照手术日期获取手术的例数
ClassMethod GetOprationsCounts(stDate As %String, endDate As %String, ctLocId As %String) As %String
{
	s stDate=$zdh(stDate,3)
	s endDate=$zdh(endDate,3)
	s wardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(ctLocId)
	q:'$IsObject(wardObj) ""
	q:'$IsObject(wardObj.CTLocDR) ""
	s locId=wardObj.CTLocDR.%Id()
	q:locId="" ""
	s locObj=##class(User.CTLoc).%OpenId(locId)
	q:'$IsObject(locObj) ""
	s locCode=locObj.CTLOCCode
	;标版
	s departId=$O(^CTLOC(locId,"LINK",0,"Loc",""))
	;南方医院版
	;s departId=$o(^CTLOC(0,"Code",$E(locCode,2,$l(locCode)),""))
	q:departId="" ""
	s opcount=0
	f date=stDate:1:endDate
	{
		s opaId="" f  s opaId=$o(^DHCANOPArrange(0,"SDate",date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s status=$p(^DHCANOPArrange(opaId),"^",27)
		.q:((status="D")||(status="C"))
		.s adm=$p(^DHCANOPArrange(opaId),"^",1)
		.s CTLocID="",wardId=""
		.s:wardId="" wardId=$P(^DHCANOPArrange(opaId),"^",32)
		.s:wardId="" wardId=$p($g(^PAADM(adm)),"^",70)
		.s:wardId'="" CTLocID=$p($g(^PAWARD(wardId)),"^",5)   //ctloc病区id
		.;s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
		.;s admLocId=$p($g(^PAADM(adm)),"^",4)
		.;b ;001
		.q:CTLocID'=locId
		.s opcount=opcount+1
	}
	q opcount
}

/// Description:获取病区在院病人列表对质控
/// Date:2020-09-28
/// Creator:wangpf
/// Table:PAADM
/// Input:
/// Output:病区在院病人列表
/// Other:w ##class(DHCINM.WebService.INMMobileComm).FindWardPatList(1)
ClassMethod FindWardPatListForQual(ward As %String = "", padFlag As %String = "") As %String [ WebMethod ]
{
	s dataKey="rows"
	s:padFlag=1 dataKey="data"
	s ret="{"""_dataKey_""":[],""total"":""0""}"
	i ward="" {
		i padFlag=1{
			q ret	
		}else{
			w ret
			q ""
		}
	}
	k retTmp
	s retTmp="",retPat=""
	s wardGlo=^CF.DHCINM.DB.MgWardD(ward)
	s ret="{"""_dataKey_""":[",count=0
	s ctLoc=$lg(wardGlo,2)
	i ctLoc'="" d
	.s pacWard=$o(^PAWARD(0,"WARD_LocationDR",ctLoc,""))
	.q:pacWard=""
	.;在院
	.s room="" f  s room=$o(^PAADMi("CurrWard",pacWard,room)) q:room=""  d
	..s episodeId=0 f  s episodeId=$o(^PAADMi("CurrWard",pacWard,room,episodeId)) q:episodeId=""  d
	...s admType=$p(^PAADM(episodeId),"^",2)
	...q:admType'="I"
	...s bedCode=""
	...s tRet=""
	...d SetPatInfo
	...s retTmp(bedCode,episodeId)=tRet
	...s retPat(episodeId)=episodeId
	.;出院7天内
	.s outDay=7
	.s outHosDate=$H+1 f  s outHosDate=$o(^PAADMi("DischDate",outHosDate),-1) q:(outHosDate="")||(outHosDate<(+$H-outDay))  d
	..s episodeId="" f  s episodeId=$o(^PAADMi("DischDate",outHosDate,episodeId)) q:episodeId=""  d //就诊号
	...q:$d(retPat(episodeId))
	...s currentWardID=$p($g(^PAADM(episodeId)),"^",70) //获取出院前所在HIS病区
	...q:currentWardID'=pacWard
	...s bedCode="",tRet=""
	...d SetPatInfo
	...s retTmp(bedCode,episodeId)=tRet
	...s retPat(episodeId)=episodeId
	s bedCode="" f  s bedCode=$O(retTmp(bedCode)) q:bedCode=""  d
	.s episodeId="" f  s episodeId=$O(retTmp(bedCode,episodeId)) q:episodeId=""  d
	..s ret=ret_$case(count,0:"",:",")_$g(retTmp(bedCode,episodeId))
	..s count=count+1
	s ret=ret_"],""total"":"""_count_"""}"
	i padFlag=1{
		q ret	
	}else{
		w ret
		q ""
	}
SetPatInfo 
	s regId=$p(^PAADM(episodeId),"^",1)
	s regNo=$tr($justify(regId,10)," ","0")
	s patName=$p(^PAPER(regId,"ALL"),"^",1)
	s patAge=$p(^PAPER(regId,"ALL"),"^",6)
	s patSex=$p(^PAPER(regId,"ALL"),"^",7)
	s:patSex'="" patSex=$p(^CT("SEX",patSex),"^",2)
	s:patAge'="" patAge=$e($zd(+$h,3),1,4)-$e($zd(patAge,3),1,4)
	s bedSort=9999
	s bedId=$p(^PAADM(episodeId),"^",73)
	i bedId'="" d
	.s bedWardId=$p(bedId,"||")
	.s bedSubId=$p(bedId,"||",2)
	.s bedCode=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",1)
	.s bedSort=$p(^PAWARD(bedWardId,"BED",bedSubId),"^",24)
	s diagnos=""
	s mrAdm=$p(^PAADM(episodeId),"^",61)
	i mrAdm'="" d
	.s index=1,mrDiagnosId=0 f  s mrDiagnosId=$o(^MR(mrAdm,"DIA",mrDiagnosId)) q:mrDiagnosId=""  d
	..s icd=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",1)
	..q:icd=""
	..s icdDesc=$p(^MRC("ID",icd),"^",2)
	..s icdSuffix=$g(^MR(mrAdm,"DIA",mrDiagnosId,"DES",1))
	..s diagStat=$p(^MR(mrAdm,"DIA",mrDiagnosId),"^",9)
	..s:diagStat'="" diagStat=$p(^MRC("DSTAT",diagStat),"^",2)
	..s diagnos=diagnos_$case(index,1:"",:" ")_index_"."_icdDesc_$select(icdSuffix'="":"("_icdSuffix_")",1:"")_$select(diagStat'="":" "_diagStat,1:"")
	..s index=index+1
	s:bedCode'="" patName=patName_"("_bedCode_")"
	s tRet="{""AdmId"":"""_episodeId_""",""PAPatMasId"":"""_regId_""",""PatientName"":"""_patName_""",""PatientAge"":"""_patAge_""",""PatientSex"":"""_patSex_""",""PatientDiagnos"":"""_diagnos_""""
	s tRet=tRet_",""BedCode"":"""_bedCode_""",""RegNo"":"""_regNo_"""}"
	s:bedCode="" bedCode="ZZZZ"
	s bedCode="+"_bedCode
	s:bedSort'="" bedCode=bedSort
}

ClassMethod GetWardBedUsedNum(ward As %String = "") As %String
{
	s ret=0
	s date=+$h
	q:ward="" ret
	s locId=$lg($g(^CF.DHCINM.DB.MgWardD(ward)),2)
	q:locId="" ret
	s selectpacward=$O(^PAWARD(0,"WARD_LocationDR",locId,""))
	q:selectpacward="" ret
	s pacward="" f  s pacward=$o(^PAWARD(0,"WardRoom",pacward)) q:pacward=""  d
	.q:selectpacward'=pacward
	.s roomid="" f  s roomid=$o(^PAWARD(0,"WardRoom",pacward,roomid)) q:roomid=""  d
	..s bedchlid="" f  s bedchlid=$o(^PAWARD(0,"WardRoom",pacward,roomid,bedchlid)) q:bedchlid=""  d
	...s pacBedLB=$g(^PAWARD(pacward,"BED",bedchlid))
	...q:pacBedLB=""
	...s BEDRcFlag=$P(pacBedLB,"^",4)
	...q:BEDRcFlag'="Y"
	...s CTLocId=$P($g(^PAWARD(pacward)),"^",5)
	...q:CTLocId=""
	...s BEDCode=$P(pacBedLB,"^",1)
	...q:((BEDCode["婴儿")||(BEDCode["BABY"))
	...;根据启停时间过滤
	...s BEDDateFrom=$P(pacBedLB,"^",21)
	...s BEDDateTo=$P(pacBedLB,"^",22)
	...q:((BEDDateFrom'="")&&(date'="")&&(BEDDateFrom>date))
	...q:((BEDDateTo'="")&&(date'="")&&(BEDDateTo<date))
	...s isBedAvailable=##class(Nur.NIS.Service.Base.Bed).IfBedAvailable(pacward_"||"_bedchlid)
	...q:isBedAvailable'=0
	...s ret=ret+1
	
	q ret
}

}
