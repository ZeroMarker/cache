/// Creator：guozj
/// Description：新人档案公共类
/// Date：2017-11-29
Class web.NurMgNewNurseComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:新人档案数据保存
/// Date:2017-06-26
/// Table:DHCNMG.HR.MgNurNewNurses
/// Input:
/// Output：
/// Return:
ClassMethod SaveNewNurse(parr As %String) As %String
{
	s ^TMP("savenewnurse")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s flag=..IsExistNewRec(parr)
	q:flag=-1 flag
	i id="" s obj=##class(DHCNMG.HR.MgNurNewNurses).%New()
	e  s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgNurNewNurses","a",p)) q:p=""  d
	.i $D(tmp(p)) d
	..s ptype=^oddCOM("DHCNMG.HR.MgNurNewNurses","a",p,"P","XSDTYPE")
	..i ((ptype="date")&&(tmp(p)'="")) d
	...s tmp(p)=$zdh(tmp(p),3)
	..i ((p="NewNurseID")||(p="NewCardId")) s tmp(p)=$zcvt($tr(tmp(p)," ",""),"U")
	..s $ZOBJPROPERTY(obj,p)=$tr(tmp(p)," ","")
	s sc=obj.%Save()
	q obj.%Id()
}

ClassMethod IsExistNewRec(parr As %String) As %String
{
	s flag=0
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	s rowid=$O(^DHCNMG.HR.MgNurNewNursesI("card"," "_tmp("NewCardId"),""))
	i rowid="" d
	.s flag=0
	i rowid'="" d
	.i ((id'="")&&(rowid'=id)) s flag=-1
	.i ((id'="")&&(rowid=id)) s flag=0
	.i ((id="")&&(rowid'="")) s flag=-1
	q flag
}

/// Creator:guozj
/// Description:查询新人档案列表
/// Date:2017-11-29
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNewNurseList")
Query FindNewNurseList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNewNurseListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	;s ^TMP("findNewNurselist")=parr_"%"_role_"%"_nurseid
	s tmpWard=""
	s isAll=0
	s isAll=##class(web.NurMgSetComm).setLoginWard(role,nurseid,1,.tmpWard)
	s card="" f  s card=$O(^DHCNMG.HR.MgNurNewNursesI("card",card)) q:card=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgNurNewNursesI("card",card,rw)) q:rw=""  d
	..s newobj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(rw)
	..q:(isAll=0)&&((newobj.NewDepDR="")||('$d(tmpWard(newobj.NewDepDR))))
	..do OutputNewNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewNurse
	
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(rw)
	s newSyncState=""
	i ((obj.NewSyncState="")||(obj.NewSyncState="N")) s newSyncState="未同步"
	e  i obj.NewSyncState="Y" s newSyncState="已同步"
	s newSyncCode=obj.NewSyncState
	s newNurseID=obj.NewNurseID
	s newNurseName=obj.NewNurseName
	s newCardId=obj.NewCardId
	s newDepDR=""
	i obj.NewDepDR'="" d
	.s newDepObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.NewDepDR)
	.q:'$IsObject(newDepObj)
	.s newDepDR=newDepObj.WardDesc
	s newSexDR=""
	i obj.NewSexDR'="" d
	.s sexObj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.NewSexDR)
	.q:'$IsObject(sexObj)
	.s newSexDR=sexObj.SubDesc
	s newPhone=obj.NewPhone
	i obj.NewSyncDate'="" s newSyncDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewSyncDate)
	e  s newSyncDate=""
	s newCreateUser=""
	i obj.NewCreateUser=0 s newCreateUser="超级管理员"
	e  d
	.s userObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.NewCreateUser)
	.q:'$IsObject(userObj)
	.s newCreateUser=userObj.PerName
	
	s ret="newSyncCode|"_newSyncCode_"^newSyncState|"_newSyncState_"^newNurseID|"_newNurseID_"^newNurseName|"_newNurseName_"^newCardId|"_newCardId_"^newDepDR|"_newDepDR_"^newSexDR|"_newSexDR_"^newPhone|"_newPhone_"^newSyncDate|"_newSyncDate_"^newCreateUser|"_newCreateUser_"^rw|"_rw
		
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNewNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNewNurseListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNewNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNewNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取新人档案记录
/// Date:2017-11-29
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod GetNewNurse(id As %String) As %String
{
	;s ^TMP("getnewnurse")=id
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(id)
	s NewNurseName=obj.NewNurseName
	s NewNurseID=obj.NewNurseID
	i obj.NewBirthday'="" s NewBirthday=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewBirthday)
	e  s NewBirthday=""
	s NewCardId=obj.NewCardId
	s NewSexDR=obj.NewSexDR
	s NewDepDR=obj.NewDepDR
	i obj.NewDepDate'="" s NewDepDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewDepDate)
	e  s NewDepDate=""
	i obj.NewComeDate'="" s NewComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewComeDate)
	e  s NewComeDate=""
	i obj.NewWorkDate'="" s NewWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.NewWorkDate)
	e  s NewWorkDate=""
	s NewMarriage=obj.NewMarriage
	s NewNativePlace=obj.NewNativePlace
	s NewPolitical=obj.NewPolitical
	s NewAddress=obj.NewAddress
	s NewContact=obj.NewContact
	s NewPhone=obj.NewPhone
	s NewLocDR=obj.NewLocDR
	s ret="NewNurseName|"_NewNurseName_"^NewNurseID|"_NewNurseID_"^NewBirthday|"_NewBirthday_"^NewCardId|"_NewCardId_"^NewSexDR|"_NewSexDR_"^NewDepDR|"_NewDepDR_"^NewDepDate|"_NewDepDate_"^NewComeDate|"_NewComeDate_"^NewWorkDate|"_NewWorkDate_"^NewMarriage|"_NewMarriage_"^NewNativePlace|"_NewNativePlace_"^NewAddress|"_NewAddress_"^NewContact|"_NewContact_"^NewPhone|"_NewPhone_"^RowID|"_id_"^NewPolitical|"_NewPolitical_"^NewLocDR|"_NewLocDR
	q ret
}

/// 
/// Creator:guozj
/// Description:保存新人教育信息
/// Date:2017-12-13
/// Table:
/// Input:
/// Output：
/// Return:
ClassMethod SaveNewNurseEdu(parr As %String) As %String
{
	;s ^TMP("neweduparr")=parr
	//EduStDate|2013-09-01^EduEndDate|2017-06-30^EduRadio|25||1^EduSchool|20||29^EduProfession|24||7
	//^EduAcademic|3||1^EduDegree|19||1^EduDegreeDate|2017-06-01^RowID|^EduPerDR|1
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgNewNurEducate).%New()
	e  s obj=##class(DHCNMG.HR.MgNewNurEducate).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgNewNurEducate","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p="EduPerDR" s tmp(p)=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(tmp(p))
	..e  d
	...s ptype=^oddCOM("DHCNMG.HR.MgNewNurEducate","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	...
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	d obj.%Save()
	q obj.%Id()
}

/// Creator:guozj
/// Description:查询新人档案教育经历
/// Date:2017-12-13
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindNewNurEduList")
Query FindNewNurEduList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNewNurEduListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s n=1
	s flag="false"
	s par="" f  s par=$O(^DHCNMG.HR.MgNewNurEducateI("flag",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s date="" f  s date=$O(^DHCNMG.HR.MgNewNurEducateI("flag",par,date)) q:date=""  d
	..s rw="" f  s rw=$O(^DHCNMG.HR.MgNewNurEducateI("flag",par,date,rw)) q:rw=""  d
	...s obj=##class(DHCNMG.HR.MgNewNurEducate).%OpenId(rw)
	...i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
	...e  s EduStDate=""
	...i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
	...e  s EduEndDate=""
	...i obj.EduSchool'="" s EduSchool=##class(web.NurMgPersonComm).GetCommCode(obj.EduSchool)
	...e  s EduSchool=""
	...i obj.EduAcademic'="" s EduAcademic=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic)
	...e  s EduAcademic=""
	...i obj.EduDegree'="" s EduDegree=##class(web.NurMgPersonComm).GetCommCode(obj.EduDegree)
	...e  s EduDegree=""
	...i obj.EduProfession'="" s EduProfession=##class(web.NurMgPersonComm).GetCommCode(obj.EduProfession)
	...e  s EduProfession=""
	...s EduRadio=""
	...i obj.EduRadio'="" d
	....s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
	....q:'$IsObject(eduobj)
	....s EduRadio=eduobj.SubDesc
	...i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
	...e  s EduDegreeDate=""
	...s eduAcadeType=""
	...i EduRadio="全日制" d
	....i flag="false" d
	.....s eduAcadeType="第一学历"
	.....s flag="true"
	...s count=..GetCountAcade(par)
	...i ((n=count)&&(n>1)) d
	....s eduAcadeType="最高学历"
	...s n=n+1
	...s ret="eduStDate|"_EduStDate_"^eduEndDate|"_EduEndDate_"^eduSchool|"_EduSchool_"^eduAcademic|"_EduAcademic_"^eduDegree|"_EduDegree_"^eduRowID|"_rw_"^eduProfession|"_EduProfession_"^eduRadio|"_EduRadio_"^eduDegreeDate|"_EduDegreeDate_"^eduAcadeType|"_eduAcadeType
	...do OutputNewEdu
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewEdu
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNewNurEduListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNewNurEduListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindNewNurEduListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNewNurEduListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取学历的数量
ClassMethod GetCountAcade(par) As %String
{
	s n=0
	s date="" f  s date=$O(^DHCNMG.HR.MgNewNurEducateI("flag",par,date)) q:date=""  d
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgNewNurEducateI("flag",par,date,rw)) q:rw=""  d
	..s n=n+1
	q n
}

ClassMethod GetNewNurEdu(rowid As %String) As %String
{
	q:rowid="" ""
	s ret=""
	s obj=##class(DHCNMG.HR.MgNewNurEducate).%OpenId(rowid)
	i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
	e  s EduStDate=""
	i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
	e  s EduEndDate=""
	s EduRadio=obj.EduRadio
    s EduSchool=obj.EduSchool
    s EduProfession=obj.EduProfession
    s EduAcademic=obj.EduAcademic
    s EduDegree=obj.EduDegree
    i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
    e  s EduDegreeDate=""
    s ret="^EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduRadio|"_EduRadio_"^EduSchool|"_EduSchool_"^EduProfession|"_EduProfession_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^EduDegreeDate|"_EduDegreeDate_"^RowID|"_rowid
    q ret
}

/// Creator:guozj
/// Description:同步新人档案数据
/// Date:2017-12-14
/// Table:DHCNMG.HR.MgNurNewNurses DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others
ClassMethod SynchNewNurseInfo(rowid As %String, synchuser As %String) As %String
{
	s ^TMP("synchinfo")=rowid
	q:rowid="" "-1"
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(rowid)
	q:((obj.NewCardId="")||(obj.NewDepDR="")||(obj.NewLocDR="")||(obj.NewNurseName="")||(obj.NewNurseID="")) "-2" //请先保存数据
	s cardid=obj.NewCardId
	s nurseno=obj.NewNurseID
	s flag=..IsExistCardID(cardid)
	q:flag="false" "-3" //身份证号已经存在
	s flag1=..IsExistNo(nurseno)
	q:flag="false" "-4" //工号已经存在
	s rw=$O(^DHCNMG.HR.MgPersonsI("card"," "_cardid,""))
	q:rw'="" "-5"
	s pobj=##class(DHCNMG.HR.MgPersons).%New()
	s pobj.PerName=obj.NewNurseName
	s pobj.PerID=obj.NewNurseID
	s pobj.PerBirthday=obj.NewBirthday
	s pobj.PerCardId=obj.NewCardId
	s pobj.PerSexDR=obj.NewSexDR
	s pobj.PerDepDR=obj.NewDepDR
	s pobj.PerDepDate=obj.NewDepDate //进入病区日期为当前
	s pobj.PerComeDate=obj.NewComeDate
	s pobj.PerWorkDate=obj.NewWorkDate
	s pobj.PerMarriage=obj.NewMarriage
	s pobj.PerNativePlace=obj.NewNativePlace
	s pobj.PerPolitical=obj.NewPolitical
	s pobj.PerHomeAddress=obj.NewAddress
	s pobj.PerContact=obj.NewContact
	s pobj.PerPhone=obj.NewPhone
	s pobj.PerTypeDR="N"
	s pobj.PerCareType="N"
	s pobj.PerAuditFlag="N"
	s pobj.RecUser=synchuser
	s pobj.PerLocDR=obj.NewLocDR
	s pobj.PerStatus="17||1"
	s sc=pobj.%Save()
	s obj.NewSyncDate=+$H
	s obj.NewNurseDR=pobj.%Id()
	s obj.NewSyncState="Y"
	s obj.NewSyncUser=synchuser
	d obj.%Save()
	i $$$ISOK(sc)
	{
		;s nrow=$O(^DHCNMG.HR.MgPersonsTmpI("PersonID"," "_pobj.%Id(),""))
		;i nrow="" d
		;.s npobj=##class(DHCNMG.HR.MgPersonsTmp).%New()
		;.s nobj=##class(DHCNMG.HR.MgPersons).%OpenId(pobj.%Id())
		;.s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPersons","a",p)) q:p=""  d
		;..q:p["%"
		;..q:$D(^oddCOM("DHCNMG.HR.MgPersonsTmp","a",p))=0
		;..s $ZOBJPROPERTY(npobj,p)=$ZOBJPROPERTY(nobj,p)
		;.s npobj.PersonID=pobj.%Id()
		;.s sc=npobj.%Save()
		
		s transRowID=$O(^DHCNMG.HR.MgTransDepI("Current"," Y"," "_pobj.%Id(),""))
		i transRowID="" d
		.i pobj.PerDepDate="" s perdepdate=$zd(+$h,3)
		.s ^TMP("savetransparr")="^"_pobj.%Id()_"^"_pobj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y^^^L"
		.s TransFlag=##class(web.NurMgPersonComm).SaveTransData("^"_pobj.%Id()_"^"_pobj.PerDepDR_"^"_perdepdate_"^"_$zt($P($H,",",2),1)_"^Y^^^L")	
	
		s edurw="" f  s edurw=$O(^DHCNMG.HR.MgNewNurEducateI("ssid",rowid,edurw)) q:edurw=""  d
		.s eduobj=##class(DHCNMG.HR.MgNewNurEducate).%OpenId(edurw)
		.;s pedurw=$O(^DHCNMG.HR.MgEducateI("ssid",pobj.%Id(),""))
		.s pedurw=$O(^DHCNMG.HR.MgEducateI("date",eduobj.EduStDate,""))
		.i pedurw="" d
		..s peduobj=##class(DHCNMG.HR.MgEducate).%New()
		..s peduobj.EduPerDR=##class(DHCNMG.HR.MgPersons).%OpenId(pobj.%Id())
		..s peduobj.EduAcademic=eduobj.EduAcademic
		..s peduobj.EduDegree=eduobj.EduDegree
		..s peduobj.EduDegreeDate=eduobj.EduDegreeDate
		..s peduobj.EduEndDate=eduobj.EduEndDate
		..s peduobj.EduProfession=eduobj.EduProfession
		..s peduobj.EduRadio=eduobj.EduRadio
		..s peduobj.EduSchool=eduobj.EduSchool
		..s peduobj.EduStDate=eduobj.EduStDate
		..s peduobj.CertPic=eduobj.CertPic
		..d peduobj.%Save()
	}
	q 0
}

ClassMethod IsExistNo(nurseno As %String) As %String
{
	q:nurseno="" "true"
	s rw=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_nurseno,""))
	i rw="" s flag="true"
	e  s flag="false"
	q flag
}

ClassMethod IsExistCardID(cardid) As %String
{
	q:cardid="" "true"
	;s rw=$O(^DHCNMG.HR.MgNurNewNursesI("card"," "_$zcvt(cardid,"U"),""))
	s rw1=$O(^DHCNMG.HR.MgPersonsI("card"," "_$zcvt(cardid,"U"),""))
	i rw1="" s flag="true"
	e  s flag="false"
	q flag
}

/// Creator:guozj
/// Description:生成新人工号
/// Date:2017-12-14
/// Table:DHCNMG.HR.MgNurNewNurses
/// Input:
/// Output：
/// Return:
/// Others
ClassMethod GenerateNo(namestr As %String) As %String
{
	;s ^TMP("namestr")=namestr
	s namespell=##class(web.NurMgVueComm).ToChineseSpell(namestr)
	s n=1
	s flag="true"
	while(flag="true")
	{
		b ;01
		s rw=$O(^DHCNMG.HR.MgNurNewNursesI("nurno"," "_(namespell_n),""))
		s rw1=$O(^DHCNMG.HR.MgPersonsI("PerID"," "_(namespell_n),""))
		i ((rw="")&&(rw1="")) s flag="false"
		e  s n=n+1
	}
	s ret=namespell_n
	q ret
}

/// 新人档案学习经历上传图片
ClassMethod InsertNewNurseCerd(parr As %String) As %String
{
	s ^TMP("InsertNewNurseCerd")=parr
	s id=$p(parr,"^")
	s Certs=$p(parr,"^",2)
	b ;01
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(id)
	q:'$IsObject(obj) ""
	d obj.CertPic.Insert(Certs)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod DeleteNewNurseCert(parr As %String) As %String
{
	s id=$p(parr,"|")
	s cert=$p(parr,"|",2)
	s tmp=""
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(id)
	s len=obj.CertPic.Count()
	f i=1:1:len
	{
		s itm=obj.CertPic.GetAt(i)
		i itm="" continue
		i itm'=cert s tmp(i)=itm
	}
	d obj.CertPic.Clear()
	s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
	.d obj.CertPic.Insert(tmp(rw))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod GetNewNurseCert(id As %String) As %String
{
	s ^TMP("GetNewNurseCert")=id
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgNurNewNurses).%OpenId(id)
	s len=obj.CertPic.Count()
	s ret=""
	f i=1:1:len d
	.s itm=obj.CertPic.GetAt(i)
	.i i=1 s ret=itm
	.e  s ret=ret_"^"_itm
	
	q id_"|"_ret
}

}
