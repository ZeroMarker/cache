/// Creator:gzj
/// Decription:学历学位公共类
Class web.NurMgDegreeComm Extends %RegisteredObject
{

/// Creator:
/// Description:查询人员的学历学位信息
/// Date:2018-07-06
/// Table:DHCNMG.HR.MgEducate
/// Input:
/// Output：
/// Return:
/// Others:
Query FindNurseDegree(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseDegreeExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindNurseDegree")=parr_"%"_role_"%"_nurseid //109^^N%0%0  //^^N%6^7^17%5
	s wardparam=$p(parr,"^",1)
	s nurseparam=$p(parr,"^",2)
	s typeparam=$p(parr,"^",3)
	i role="0"
	{
		s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
		.s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
		..q:((wardparam'="")&&(id'=wardparam))
		..s perrowid="" f  s perrowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,perrowid)) q:perrowid=""  d
		...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(perrowid)
		...q:PerObj.PerTypeDR'="N"
		...s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",perrowid,date)) q:date=""  d
		....s n=1,flag="false"
		....s rowid="" f  s rowid=$O(^DHCNMG.HR.MgEducateI("flag",perrowid,date,rowid)) q:rowid=""  d
		.....s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rowid)
		.....q:((typeparam'="")&&(obj.EduStatus'=typeparam))
		.....s status=obj.EduStatus
		.....s EduStatus=""
		.....i obj.EduStatus="A" s EduStatus="已审核"
		.....e  i obj.EduStatus="N" s EduStatus="未提交"
		.....e  i obj.EduStatus="Y" s EduStatus="已提交"
		.....s HiSNO=obj.EduPerDR.HISNO
		.....s NurseName=obj.EduPerDR.PerName
		.....s NurseID=obj.EduPerDR.PerID
		.....q:((nurseparam'="")&&((NurseName_NurseID)'[nurseparam))
		.....s NurseDepDR=obj.EduPerDR.PerDepDR
		.....s NurseDep=""
		.....s NurseDepObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.EduPerDR.PerDepDR)
		.....q:'$IsObject(NurseDepObj)
		.....s NurseDep=NurseDepObj.WardDesc
		.....i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
		.....e  s EduStDate=""
		.....i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
		.....e  s EduEndDate=""
		.....i obj.EduSchool'="" s EduSchool=##class(web.NurMgPersonComm).GetCommCode(obj.EduSchool)
		.....e  s EduSchool=""
		.....i obj.EduProfession'="" s EduProfession=##class(web.NurMgPersonComm).GetCommCode(obj.EduProfession)
		.....e  s EduProfession=""
		.....i obj.EduAcademic'="" s EduAcademic=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic) // 学历
		.....e  s EduAcademic=""
		.....i obj.EduDegree'="" s EduDegree=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic)
		.....e  s EduDegree=""
		.....s EduRadio=""
		.....i obj.EduRadio'="" d
		......s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
		......q:'$IsObject(eduobj)
		......s EduRadio=eduobj.SubDesc
		.....i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
		.....e  s EduDegreeDate=""
		.....s EduAcadeType=""
		.....i EduRadio="全日制" d
		......i flag="false" d
		.......s EduAcadeType="第一学历"
		.......s flag="true"
		.....s count=##class(web.NurMgPersonComm).GetCountAcade(nurseid)
		.....i ((n=count)&&(n>1)) d
		......s EduAcadeType="最高学历"
		.....s n=n+1
		.....s ret="EduStatus|"_EduStatus_"^NurseName|"_NurseName_"^NurseDep|"_NurseDep_"^HiSNO|"_HiSNO_"^EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_rowid_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^EduAcadeType|"_EduAcadeType_"^status|"_status_"^NurseDepDR|"_NurseDepDR_"^perrowid|"_perrowid
		.....do OutputDegree
	}
	else
	{
		//^^N%6^7^17%5
		s tmp=""
		f i=1:1:$l(role,"^")
		{
			s roleitm=$p(role,"^",i)
			s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(roleitm)
			i rolecode="nurse"
			{
				s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",nurseid,date)) q:date=""  d
				.s n=1,flag="false"
				.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgEducateI("flag",nurseid,date,rowid)) q:rowid=""  d
				..s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rowid)
				..q:((typeparam'="")&&(obj.EduStatus'=typeparam))
				..s status=obj.EduStatus
				..s EduStatus=""
				..i obj.EduStatus="A" s EduStatus="已审核"
				..e  i obj.EduStatus="N" s EduStatus="未提交"
				..e  i obj.EduStatus="Y" s EduStatus="已提交"
				..s HiSNO=obj.EduPerDR.HISNO
				..s NurseName=obj.EduPerDR.PerName
				..s NurseDepDR=obj.EduPerDR.PerDepDR
				..s NurseDep=""
				..s NurseDepObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.EduPerDR.PerDepDR)
				..q:'$IsObject(NurseDepObj)
				..s NurseDep=NurseDepObj.WardDesc
				..i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
				..e  s EduStDate=""
				..i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
				..e  s EduEndDate=""
				..i obj.EduSchool'="" s EduSchool=##class(web.NurMgPersonComm).GetCommCode(obj.EduSchool)
				..e  s EduSchool=""
				..i obj.EduProfession'="" s EduProfession=##class(web.NurMgPersonComm).GetCommCode(obj.EduProfession)
				..e  s EduProfession=""
				..i obj.EduAcademic'="" s EduAcademic=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic) // 学历
				..e  s EduAcademic=""
				..i obj.EduDegree'="" s EduDegree=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic)
				..e  s EduDegree=""
				..s EduRadio=""
				..i obj.EduRadio'="" d
				...s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
				...q:'$IsObject(eduobj)
				...s EduRadio=eduobj.SubDesc
				..i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
				..e  s EduDegreeDate=""
				..s EduAcadeType=""
				..i EduRadio="全日制" d
				...i flag="false" d
				....s EduAcadeType="第一学历"
				....s flag="true"
				..s count=##class(web.NurMgPersonComm).GetCountAcade(nurseid)
				..i ((n=count)&&(n>1)) d
				...s EduAcadeType="最高学历"
				..s n=n+1
				..;s ret="EduStatus|"_EduStatus_"^NurseName|"_NurseName_"^NurseDep|"_NurseDep_"^HiSNO|"_HiSNO_"EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_rowid_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^EduAcadeType|"_EduAcadeType_"^status|"_status_"^NurseDepDR|"_NurseDepDR_"^perrowid|"_nurseid
				..;do OutputDegree
				..s tmp(rowid)="EduStatus|"_EduStatus_"^NurseName|"_NurseName_"^NurseDep|"_NurseDep_"^HiSNO|"_HiSNO_"EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_rowid_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^EduAcadeType|"_EduAcadeType_"^status|"_status_"^NurseDepDR|"_NurseDepDR_"^perrowid|"_nurseid
			}
			else
			{
				
				s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,rolerw)) q:rolerw=""  d
				.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
				..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
				..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=roledepobj.SubWard)
				....q:((wardparam'="")&&(id'=wardparam))
				....s perrowid="" f  s perrowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,perrowid)) q:perrowid=""  d
				.....s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(perrowid)
				.....q:PerObj.PerTypeDR'="N"
				.....s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",perrowid,date)) q:date=""  d
				......s n=1,flag="false"
				......s rowid="" f  s rowid=$O(^DHCNMG.HR.MgEducateI("flag",perrowid,date,rowid)) q:rowid=""  d
				.......s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rowid)
				.......q:((typeparam'="")&&(obj.EduStatus'=typeparam))
				.......s status=obj.EduStatus
				.......s EduStatus=""
				.......i obj.EduStatus="A" s EduStatus="已审核"
				.......e  i obj.EduStatus="N" s EduStatus="未提交"
				.......e  i obj.EduStatus="Y" s EduStatus="已提交"
				.......s HiSNO=obj.EduPerDR.HISNO
				.......s NurseName=obj.EduPerDR.PerName
				.......s NurseID=obj.EduPerDR.PerID
				.......q:((nurseparam'="")&&((NurseName_NurseID)'[nurseparam))
				.......s NurseDepDR=obj.EduPerDR.PerDepDR
				.......s NurseDep=""
				.......s NurseDepObj=##class(DHCNMG.DB.MgWard).%OpenId(obj.EduPerDR.PerDepDR)
				.......q:'$IsObject(NurseDepObj)
				.......s NurseDep=NurseDepObj.WardDesc
				.......i obj.EduStDate'="" s EduStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduStDate)
				.......e  s EduStDate=""
				.......i obj.EduEndDate'="" s EduEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduEndDate)
				.......e  s EduEndDate=""
				.......i obj.EduSchool'="" s EduSchool=##class(web.NurMgPersonComm).GetCommCode(obj.EduSchool)
				.......e  s EduSchool=""
				.......i obj.EduProfession'="" s EduProfession=##class(web.NurMgPersonComm).GetCommCode(obj.EduProfession)
				.......e  s EduProfession=""
				.......i obj.EduAcademic'="" s EduAcademic=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic) // 学历
				.......e  s EduAcademic=""
				.......i obj.EduDegree'="" s EduDegree=##class(web.NurMgPersonComm).GetCommCode(obj.EduAcademic)
				.......e  s EduDegree=""
				.......s EduRadio=""
				.......i obj.EduRadio'="" d
				........s eduobj=##class(DHCNMG.DB.MgSetCodeSub).%OpenId(obj.EduRadio)
				........q:'$IsObject(eduobj)
				........s EduRadio=eduobj.SubDesc
				.......i obj.EduDegreeDate'="" s EduDegreeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.EduDegreeDate)
				.......e  s EduDegreeDate=""
				.......s EduAcadeType=""
				.......i EduRadio="全日制" d
				........i flag="false" d
				.........s EduAcadeType="第一学历"
				.........s flag="true"
				.......s count=##class(web.NurMgPersonComm).GetCountAcade(nurseid)
				.......i ((n=count)&&(n>1)) d
				........s EduAcadeType="最高学历"
				.......s n=n+1
				.......;s ret="EduStatus|"_EduStatus_"^NurseName|"_NurseName_"^NurseDep|"_NurseDep_"^HiSNO|"_HiSNO_"^EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_rowid_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^EduAcadeType|"_EduAcadeType_"^status|"_status_"^NurseDepDR|"_NurseDepDR_"^perrowid|"_perrowid
				.......;do OutputDegree
				.......s tmp(rowid)="EduStatus|"_EduStatus_"^NurseName|"_NurseName_"^NurseDep|"_NurseDep_"^HiSNO|"_HiSNO_"^EduStDate|"_EduStDate_"^EduEndDate|"_EduEndDate_"^EduSchool|"_EduSchool_"^EduAcademic|"_EduAcademic_"^EduDegree|"_EduDegree_"^RowID|"_rowid_"^EduProfession|"_EduProfession_"^EduRadio|"_EduRadio_"^EduDegreeDate|"_EduDegreeDate_"^EduAcadeType|"_EduAcadeType_"^status|"_status_"^NurseDepDR|"_NurseDepDR_"^perrowid|"_perrowid
			}
			
		}
		b ;03
		s rw="" f  s rw=$O(tmp(rw)) q:rw=""  d
		.s ret=tmp(rw)
		.d OutputDegree 
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDegree
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseDegreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseDegreeExecute ]
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

ClassMethod FindNurseDegreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseDegreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetWardStore(parr As %String) As %String
{
	s ret=""
	w "["
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgWardI("Spell",spell,rowid)) q:rowid=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(rowid)
	..q:'$IsObject(obj)
	..q:(parr'="")&&((obj.WardSpell_obj.WardDesc)'[$zcvt($tr(parr," ",""),"U"))
	..s warddesc=obj.WardDesc
	..w "{""warddesc"":"""_warddesc_""",""wardid"":"""_rowid_"""},"
	w "]"
	q ""
}

/// Creator:
/// Description:查询病区信息
/// Date:2018-07-06
/// Table:DHCNMG.DB.MgWard
/// Input:
/// Output：
/// Return:
/// Others:
Query FindWardList(parr As %String = "", role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardListExecute(ByRef qHandle As %Binary, parr As %String = "", role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindWardList")=parr_"%"_role_"%"_nurseid //109^^N%0%0
	s wardparam=$p(parr,"^",1)
	s nurseparam=$p(parr,"^",2)
	s typeparam=$p(parr,"^",3)
	i role="0"
	{
		do OutputDegree
	}
	else
	{
		s rolecode=##class(web.NurMgLoginComm).GetLoginRoleCode(role)
		i rolecode="nurse"
		{
			s date="" f  s date=$O(^DHCNMG.HR.MgEducateI("flag",nurseid,date)) q:date=""  d
			do OutputDegree		
		}
		else
		{
			s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurseid,rolerw)) q:rolerw=""  d
			.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
			..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
			..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
			...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
			do OutputDegree	
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputDegree
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardListExecute ]
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

ClassMethod FindWardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurseStore(parr As %String, role As %String, nurseid As %String) As %String
{
	s ret=""
	w "["
	i role=0
	{
		s dep="" f  s dep=$O(^DHCNMG.HR.MgPersonsI("DepID",dep)) q:dep=""  d
		.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID",dep,rowid)) q:rowid=""  d
		..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		..q:((parr'="")&&(obj.PerDepDR'=parr))
		..q:obj.PerTypeDR'="N"
		..s nursename=obj.PerName
		..s nurseno=obj.PerID
		..w "{""nursename"":"""_nursename_""",""nurserow"":"""_rowid_"""},"
		..;i ret="" s ret="{""nursename:"""_nursename_""",""nurserow"":"""_rowid_""""
		..;e  s ret=ret_",""nursename"":"""_nursename_""",nurserow"":"""_rowid_""""
		;w "["_ret_"]"
		w "]"
		q ""
	}
}

/// Creator:guozj
/// Description:按照病区取护士信息
/// Date:2018-07-09
/// Table: DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgDegreeComm","FindNurseList","1")
Query FindNurseList(parr As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindNurseListExecute(ByRef qHandle As %Binary, parr As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s ^TMP("FindNurseList")=parr_"%"_role_"%"_nurseid
	s ward=$p(parr,"^",1)
	s post=$p(parr,"^",2)
	s nurse=$p(parr,"^",3)
	i role=0
	{
		s dep="" f  s dep=$O(^DHCNMG.HR.MgPersonsI("DepID",dep)) q:dep=""  d
		.s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID",dep,rowid)) q:rowid=""  d
		..s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		..
		..q:obj.PerTypeDR'="N"
		..s nursename=obj.PerName
		..s nurseno=obj.PerID
		..q:((ward'="")&&(obj.PerDepDR'=ward))
		..q:((nurse'="")&&(nursename'[nurse))
		..s nurseward=""
		..i obj.PerDepDR'="" d
		...s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
		...s nurseward=wardobj.WardDesc
		...s nursepost="",postcode=""
		..s stdate="" f  s stdate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate)) q:stdate=""  d
		...s postrow="" f  s postrow=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate,postrow)) q:postrow=""  d
		....s postobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(postrow)
		....q:postobj.PostEndDate'=""
		....s postcode=postobj.PostDuty
		....s nursepost=##class(web.NurMgPersonComm).GetCommCode(postobj.PostDuty)
		..q:((post'="")&&(postcode'=post))
		..s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^nurserow|"_rowid_"^nursedep|"_obj.PerDepDR_"^nurseward|"_nurseward_"^nursepost|"_nursepost
		..do OutputNurData
	}
	else
	{
		s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(role)
		s rolecode=RoleObj.RoleCode
		
		i rolecode="nurse"
		{
			s obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
			s nursename=obj.PerName
			s nurseno=obj.PerID
			s nurseward=""
			i obj.PerDepDR'="" d
			.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
			.s nurseward=wardobj.WardDesc
			q:((ward'="")&&(obj.PerDepDR'=ward))
			q:((nurse'="")&&(nursename'[nurse))
			s nursepost="",postcode=""
			s stdate="" f  s stdate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate)) q:rowid=""  d
			.s postrow="" f  s postrow=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate,postrow)) q:postrow=""  d
			.s postobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(postrow)
			.q:postobj.PostEndDate'=""
			.s postcode=postobj.PostDuty
			.s nursepost=##class(web.NurMgPersonComm).GetCommCode(postobj.PostDuty)
			q:((post'="")&&(postcode'=post))
			s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^nurserow|"_nurseid_"^nursedep|"_obj.PerDepDR_"^nurseward|"_nurseward_"^nursepost|"_nursepost
			do OutputNurData
		}
		else
		{
			s rolerw="" f  s rolerw=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_role," "_nurseid,rolerw)) q:rolerw=""  d
			.s roledeprw="" f  s roledeprw=$O(^DHCNMG.DB.MgDataLimitSubD(rolerw,roledeprw)) q:roledeprw=""  d
			..s roledepobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(rolerw_"||"_roledeprw)
			..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
			...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
			....q:(id'=roledepobj.SubWard)
			....s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_id,rowid)) q:rowid=""  d
			.....s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
			.....q:obj.PerTypeDR'="N"
			.....s nursename=obj.PerName
			.....s nurseno=obj.PerID
			.....q:((ward'="")&&(obj.PerDepDR'=ward))
			.....q:((nurse'="")&&(nursename'[nurse))
			.....s nurseward=""
			.....i obj.PerDepDR'="" d
			......s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
			......s nurseward=wardobj.WardDesc
			.....s nursepost="",postcode=""
			.....s stdate="" f  s stdate=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate)) q:rowid=""  d
			......s postrow="" f  s postrow=$O(^DHCNMG.HR.MgPostDutyI("PostDate",rowid,stdate,postrow)) q:postrow=""  d
			.......s postobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(postrow)
			.......q:postobj.PostEndDate'=""
			.......s postcode=postobj.PostDuty
			.......s nursepost=##class(web.NurMgPersonComm).GetCommCode(postobj.PostDuty)
			.....q:((post'="")&&(postcode'=post))
			.....s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^nurserow|"_rowid_"^nursedep|"_obj.PerDepDR_"^nurseward|"_nurseward_"^nursepost|"_nursepost
			.....do OutputNurData
		}
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNurData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindNurseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurseListExecute ]
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

ClassMethod FindNurseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-07-10
/// Description:提交
ClassMethod SubmitEduRec(id As %String, type As %String) As %String
{
	s ^TMP("SubmitEduRec")=id
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgEducate).%OpenId(id)
	q:'$IsObject(obj) ""
	s obj.EduStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

}
