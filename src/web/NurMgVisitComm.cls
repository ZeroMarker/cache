/// 参观交流公共类
Class web.NurMgVisitComm Extends %RegisteredObject
{

ClassMethod SaveVisit(parr As %String, items As %String, type As %String, user As %String) As %String
{
	s flag=1
	s parr=$replace(parr,$c(10),"")
	d ##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=tmp("RowID")
	i id="" s obj=##class(DHCNMG.Visit.MgVisitInterflow).%New()
	e  s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(id)
	q:obj.VisitStatus="Y" "已提交"
	TS
	s obj.VisitStDate=$zdh(tmp("VisitStDate"),3)
	s obj.VisitEndDate=$zdh(tmp("VisitEndDate"),3)
	s obj.VisitContent=$tr($g(tmp("VisitContent"))," ","")
	d obj.VisitWard.Clear()
	s len=$l($g(tmp("VisitWard")),",")
	f i=1:1:len
	{
		s itm=$p($g(tmp("VisitWard")),",",i)
		i itm="" continue
		d obj.VisitWard.Insert(itm)
	}
	s obj.VisitProvince=$g(tmp("VisitProvince"))
	s obj.VisitStatus=type
	s obj.VisitUser=user
	s sc=obj.%Save()
	s flag=(flag&&$$$ISOK(sc))
	i flag=1 
	{
		s rw="" f  s rw=$O(^DHCNMG.Visit.MgVisitFlowSubD(obj.%Id(),rw)) q:rw=""  d
		.s subobj=##class(DHCNMG.Visit.MgVisitFlowSub).%OpenId(obj.%Id()_"||"_rw)
		.s subsc=subobj.%DeleteId(obj.%Id()_"||"_rw)
		.s flag=(flag&&$$$ISOK(subsc))
		s itmlen=$l(items,"「")
		f j=1:1:itmlen
		{
			s perlist=$p(items,"「",j)
			i perlist="" continue
			d ##class(web.NurMgVueComm).SplitStr(perlist,"^","|",.tmp1)
			s subObj=##class(DHCNMG.Visit.MgVisitFlowSub).%New()
			s subObj.Parref=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(obj.%Id())
			s subObj.VisitCall=$replace($tr($g(tmp1("visitCall"))," ",""),$c(10),"")
			s subObj.VisitJob=$g(tmp1("visitJob"))
			s subObj.VisitPerson=$g(tmp1("visitPerson"))
			s subObj.VisitPost=$g(tmp1("visitPost"))
			s subObj.VisitUnit=$replace($tr($g(tmp1("visitUnit"))," ",""),$c(10),"")
			s sc1=subObj.%Save()
			s flag=flag&&$$$ISOK(sc1)
		}
		i flag=1
		{
			Tc
		}
		else
		{
			Tro
		}
	}
	else
	{
		Tro
	}
	q flag
}

/// Creator:
/// Date:
/// Description:删除参观记录
/// Table:
/// Input:
/// Output:
/// Return
ClassMethod DelVisitRec(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(id)
	q:'$IsObject(obj) ""
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:gzj
/// Description:
/// Date:2018-07-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgVisitComm","FindVisitList")
Query FindVisitList(parr As %String, role As %String, nurseid As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindVisitListExecute(ByRef qHandle As %Binary, parr As %String, role As %String, nurseid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^",2)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",3)
	i endDate'="" s endDate=$zdh(endDate,3)
	s province=$p(parr,"^",4)
	
	s ret="",ret1=""
	i role=0
	{
		s date="" f  s date=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date)) q:date=""  d
		.s row="" f  s row=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date,row)) q:row=""  d
		..s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(row)
		..q:((stDate'="")&&(obj.VisitStDate<stDate))
		..q:((endDate'="")&&(obj.VisitEndDate>endDate))
		..q:((province'="")&&(obj.VisitProvince'=province))
		..s visitWard=""
		..i obj.VisitWard'="" d
		...s len=obj.VisitWard.Count()
		...f j=1:1:len d
		....s warditm=obj.VisitWard.GetAt(j)
		....q:warditm=""
		....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(warditm)
		....i visitWard="" s visitWard=WardObj.WardDesc
		....e  s visitWard=visitWard_","_WardObj.WardDesc
		..i obj.VisitStDate'="" s visitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitStDate)
		..e  s visitStDate=""
		..i obj.VisitEndDate'="" s visitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitEndDate)
		..e  s visitEndDate=""
		..s visitProvince=""
		..i obj.VisitProvince'="" s visitProvince=##class(web.NurMgPersonComm).GetCommCode(obj.VisitProvince)
		..i obj.VisitStatus="N" s visitStatus="保存"
		..e  i obj.VisitStatus="Y" s visitStatus="提交"
		..e  i obj.VisitStatus="A" s visitStatus="已审核"
		..s visitUser=""
		..i obj.VisitUser="0" s visitUser="管理员"
		..e  d
		...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.VisitUser)
		...s visitUser=PerObj.PerName
		..s visitContent=obj.VisitContent
		..s visitNurseNum=""
		..s num=0
		..s sub="" f  s sub=$o(^DHCNMG.Visit.MgVisitFlowSubD(row,sub)) q:sub=""  d
		...s num=num+1
		..i num>0 s visitNurseNum=num
		..s ret1="visitWard|"_visitWard_"^visitStDate|"_visitStDate_"^visitEndDate|"_visitEndDate_"^visitProvince|"_visitProvince_"^RowID|"_row_"^visitStatus|"_visitStatus_"^visitContent|"_visitContent_"^visitNurseNum|"_visitNurseNum
		..s tmp(row)=ret1
	}
	else
	{
		s rolelen=$l(role,"^")
		f j=1:1:rolelen
		{
			s roleitm=$p(role,"^",j)
			i roleitm="" continue
			s RoleObj=##class(DHCNMG.Set.MgRoles).%OpenId(roleitm)
			i '$IsObject(RoleObj) continue
			s rolecode=RoleObj.RoleCode
			i ((rolecode="manager")||(rolecode="hlbzr")||(rolecode="hlb")||(rolecode="znurhead")||(rolecode="nurhead")) 
			{
				s par="" f  s par=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,par)) q:par=""  d
				.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgDataLimitSubD(par,rowid)) q:rowid=""  d
				..s limitobj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(par_"||"_rowid)
				..q:'$IsObject(limitobj)
				..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
				...s SpellSort=$zcvt($tr(spell," ",""),"U")
				...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
				....q:(id'=limitobj.SubWard)
				....s date="" f  s date=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date)) q:date=""  d
				.....s row="" f  s row=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date,row)) q:row=""  d
				......s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(row)
				......q:'$IsObject(obj)
				......q:((stDate'="")&&(obj.VisitStDate<stDate))
				......q:((endDate'="")&&(obj.VisitEndDate>endDate))
				......q:((province'="")&&(obj.VisitProvince'=province))
				......s flag=0
				......s visitWard=""
				......i obj.VisitWard'="" d
				.......s len=obj.VisitWard.Count()
				.......f j=1:1:len d
				........s warditm=obj.VisitWard.GetAt(j)
				........i warditm="" continue
				........i warditm=id s flag=1
				........s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(warditm)
				........i '$IsObject(WardObj) continue
				........i visitWard="" s visitWard=WardObj.WardDesc
				........e  s visitWard=visitWard_","_WardObj.WardDesc
				......q:flag=0
				......i obj.VisitStDate'="" s visitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitStDate)
				......e  s visitStDate=""
				......i obj.VisitEndDate'="" s visitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitEndDate)
				......e  s visitEndDate=""
				......s visitProvince=""
				......i obj.VisitProvince'="" s visitProvince=##class(web.NurMgPersonComm).GetCommCode(obj.VisitProvince)
				......i obj.VisitStatus="N" s visitStatus="保存"
				......e  i obj.VisitStatus="Y" s visitStatus="提交"
				......e  i obj.VisitStatus="A" s visitStatus="已审核"
				......s visitUser=""
				......i obj.VisitUser="0" s visitUser="管理员"
				......e  d
				.......s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.VisitUser)
				.......s visitUser=PerObj.PerName
				......s visitContent=obj.VisitContent
				......s visitNurseNum=""
				......s num=0
				......s sub="" f  s sub=$o(^DHCNMG.Visit.MgVisitFlowSubD(row,sub)) q:sub=""  d
				.......s num=num+1
				.......i num>0 s visitNurseNum=num
				......s ret1="visitWard|"_visitWard_"^visitStDate|"_visitStDate_"^visitEndDate|"_visitEndDate_"^visitProvince|"_visitProvince_"^RowID|"_row_"^visitStatus|"_visitStatus_"^visitContent|"_visitContent_"^visitNurseNum|"_visitNurseNum
				......s tmp(row)=ret1
			}
			else
			{
				s partmp=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,""))
				i partmp'="" 
				{
					s par="" f  s par=$O(^DHCNMG.DB.MgDataLimitI("Role"," "_roleitm," "_nurseid,par)) q:par=""  d
					.s rowid="" f  s rowid=$O(^DHCNMG.DB.MgDataLimitSubD(par,rowid)) q:rowid=""  d
					..s obj=##class(DHCNMG.DB.MgDataLimitSub).%OpenId(par_"||"_rowid)
					..q:'$IsObject(obj)
					..s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
					...s id="" f  s id=$O(^DHCNMG.DB.MgWardI("Spell",spell,id)) q:id=""  d
					....q:(id'=obj.SubWard)
					....s SpellSort=$zcvt($tr(spell," ",""),"U")
					....s date="" f  s date=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date)) q:date=""  d
					.....s row="" f  s row=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date,row)) q:row=""  d
					......s obj1=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(row)
					......q:'$IsObject(obj1)
					......q:((stDate'="")&&(obj1.VisitStDate<stDate))
					......q:((endDate'="")&&(obj1.VisitEndDate>endDate))
					......q:((province'="")&&(obj1.VisitProvince'=province))
					......s flag=0
					......s visitWard=""
					......i obj1.VisitWard'="" d
					.......s len=obj1.VisitWard.Count()
					.......f k=1:1:len d
					........s warditm=obj1.VisitWard.GetAt(k)
					........q:warditm=""
					........i warditm=id s flag=1
					........s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(warditm)
					........i visitWard="" s visitWard=WardObj.WardDesc
					........e  s visitWard=visitWard_","_WardObj.WardDesc
					......q:flag=0
					......i obj1.VisitStDate'="" s visitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj1.VisitStDate)
					......e  s visitStDate=""
					......i obj1.VisitEndDate'="" s visitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj1.VisitEndDate)
					......e  s visitEndDate=""
					......s visitProvince=""
					......i obj1.VisitProvince'="" s visitProvince=##class(web.NurMgPersonComm).GetCommCode(obj1.VisitProvince)
					......i obj1.VisitStatus="N" s visitStatus="保存"
					......e  i obj1.VisitStatus="Y" s visitStatus="提交"
					......e  i obj1.VisitStatus="A" s visitStatus="已审核"
					......s visitUser=""
					......i obj1.VisitUser="0" s visitUser="管理员"
					......e  d
					.......s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj1.VisitUser)
					.......q:'$IsObject(PerObj)
					.......s visitUser=PerObj.PerName
					......s visitContent=obj1.VisitContent
					......s visitNurseNum=""
					......s num=0
					......s sub="" f  s sub=$o(^DHCNMG.Visit.MgVisitFlowSubD(row,sub)) q:sub=""  d
					.......s num=num+1
					.......i num>0 s visitNurseNum=num
					......s ret1="visitWard|"_visitWard_"^visitStDate|"_visitStDate_"^visitEndDate|"_visitEndDate_"^visitProvince|"_visitProvince_"^RowID|"_row_"^visitStatus|"_visitStatus_"^visitContent|"_visitContent_"^visitNurseNum|"_visitNurseNum
					......s tmp(row)=ret1
				}
				else
				{
					s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
					i '$IsObject(PerObj) continue
					s wardid=PerObj.PerDepDR
					s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(wardid)
					i '$IsObject(WardObj) continue
					s SpellSort=$zcvt($tr(WardObj.WardSpell," ",""),"U")
					s date="" f  s date=$O(^DHCNMG.Visit.MgVisitInterflowI("Date",date)) q:date=""  d
					.s row="" f  s row=$O(^DHCNMG.Visit.MgVisitInterflowI("Ward",date,row)) q:row=""  d
					..s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(row)
					..q:'$IsObject(obj)
					..q:((stDate'="")&&(obj.VisitStDate<stDate))
					..q:((endDate'="")&&(obj.VisitEndDate>endDate))
					..q:((province'="")&&(obj.VisitProvince'=province))
					..s flag=0
					..s visitWard=""
					..i obj.VisitWard'="" d
					...s len=obj.VisitWard.Count()
					...f j=1:1:len d
					....s warditm=obj.VisitWard.GetAt(j)
					....q:warditm=""
					....i warditm=wardid s flag=1
					....s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(warditm)
					....i visitWard="" s visitWard=WardObj.WardDesc
					....e  s visitWard=visitWard_","_WardObj.WardDesc
					..q:flag=0
					..i obj.VisitStDate'="" s visitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitStDate)
					..e  s visitStDate=""
					..i obj.VisitEndDate'="" s visitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitEndDate)
					..e  s visitEndDate=""
					..s visitProvince=""
					..i obj.VisitProvince'="" s visitProvince=##class(web.NurMgPersonComm).GetCommCode(obj.VisitProvince)
					..s visitPerson=obj.VisitPerson
					..s visitJob=obj.VisitJob
					..s visitPost=obj.VisitPost
					..s visitUnit=obj.VisitUnit
					..s visitCall=obj.VisitCall
					..i obj.VisitStatus="N" s visitStatus="保存"
					..e  i obj.VisitStatus="Y" s visitStatus="提交"
					..e  i obj.VisitStatus="A" s visitStatus="已审核"
					..s visitUser=""
					..i obj.VisitUser="0" s visitUser="管理员"
					..e  d
					...s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(obj.VisitUser)
					...s visitUser=PerObj.PerName
					..s visitContent=obj.VisitContent
					..s visitNurseNum=""
					..s num=0
					..s sub="" f  s sub=$o(^DHCNMG.Visit.MgVisitFlowSubD(row,sub)) q:sub=""  d
					...s num=num+1
					...i num>0 s visitNurseNum=num
					..s ret1="visitWard|"_visitWard_"^visitStDate|"_visitStDate_"^visitEndDate|"_visitEndDate_"^visitProvince|"_visitProvince_"^RowID|"_row_"^visitStatus|"_visitStatus_"^visitContent|"_visitContent_"^visitNurseNum|"_visitNurseNum
					..s tmp(SpellSort)=ret1
					
				}
			}
		}
	}
	
	s tmpret="" f  s tmpret=$O(tmp(tmpret)) q:tmpret=""  d
	.s ret=tmp(tmpret)
	.d OutputVisitList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputVisitList
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindVisitListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVisitListExecute ]
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

ClassMethod FindVisitListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVisitListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetVisitData(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(id)
	i obj.VisitStDate'="" s VisitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitStDate)
	e  s VisitStDate=""
	i obj.VisitEndDate'="" s VisitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitEndDate)
	e  s VisitEndDate=""
	s VisitWard=obj.VisitWard.%Id()
	s VisitProvince=obj.VisitProvince
	s VisitContent=obj.VisitContent
    s ret="VisitStDate|"_VisitStDate_"^VisitEndDate|"_VisitEndDate_"^VisitWard|"_VisitWard_"^VisitProvince|"_VisitProvince_"^RowID|"_id_"^VisitContent|"_VisitContent
	q ret
}

ClassMethod GetVisitDataJson(id As %String) As %String
{
	q:id="" "[]"
	s ret=""
	s obj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(id)
	q:'$IsObject(obj) "[]"
	w "["
	i obj.VisitStDate'="" s VisitStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitStDate)
	e  s VisitStDate=""
	i obj.VisitEndDate'="" s VisitEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.VisitEndDate)
	e  s VisitEndDate=""
	s len=obj.VisitWard.Count()
	s VisitWard=""
	f i=1:1:len
	{
		s itm=obj.VisitWard.GetAt(i)
		i itm="" continue
		i VisitWard="" s VisitWard=itm
		e  s VisitWard=VisitWard_"|"_itm
	}
	s VisitProvince=obj.VisitProvince
	s VisitContent=obj.VisitContent
	w "{""VisitStDate"":"""_VisitStDate_""",""VisitEndDate"":"""_VisitEndDate_""",""VisitProvince"":"""_VisitProvince_""",""VisitWard"":"""_VisitWard_""",""VisitContent"":"""_VisitContent_""",""RowID"":"""_id_""",""children"":["
	s n=0
	s row="" f  s row=$O(^DHCNMG.Visit.MgVisitFlowSubD(id,row)) q:row=""  d
	.s SubObj=##class(DHCNMG.Visit.MgVisitFlowSub).%OpenId(id_"||"_row)
	.s VisitPerson=SubObj.VisitPerson
	.s VisitJob=SubObj.VisitJob
	.s VisitPost=SubObj.VisitPost
	.s VisitUnit=SubObj.VisitUnit
	.s VisitCall=SubObj.VisitCall
	.s n=n+1
	.i n=1 w "{""visitPerson"":"""_VisitPerson_""",""visitJob"":"""_VisitJob_""",""visitPost"":"""_VisitPost_""",""visitUnit"":"""_VisitUnit_""",""visitCall"":"""_VisitCall_"""}"
	.e  w ",{""visitPerson"":"""_VisitPerson_""",""visitJob"":"""_VisitJob_""",""visitPost"":"""_VisitPost_""",""visitUnit"":"""_VisitUnit_""",""visitCall"":"""_VisitCall_"""}"
	w "]}"
	w "]"
	q ""
}

/// Creator:gzj
/// Description:
/// Date:2018-07-16
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgVisitComm","FindVisitStatic")
Query FindVisitStatic(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindVisitStaticExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s stDate=$p(parr,"^",1)
	i stDate'="" s stDate=$zdh(stDate,3)
	s endDate=$p(parr,"^",1)
	i endDate'="" s endDate=$zdh(endDate,3)
	s province=$p(parr,"^",3)
	s hireDuty=$p(parr,"^",4)
	;s hireDesc=##class(web.NurMgPersonComm).GetCommCode(hireDuty)
	f date=stDate:1:endDate
	{
		s rowID="" f  s rowID=$o(^DHCNMG.Visit.MgVisitInterflowI("Date",date,rowID)) q:rowID=""  d
		.s ParObj=##class(DHCNMG.Visit.MgVisitInterflow).%OpenId(rowID)
		.q:((province'="")&&(ParObj.VisitProvince'=province))
		.s Sub="" f  s Sub=$O(^DHCNMG.Visit.MgVisitFlowSubD(rowID,Sub)) q:Sub=""  d
		..s obj=##class(DHCNMG.Visit.MgVisitFlowSub).%OpenId(rowID_"||"_Sub)
		..q:((hireDuty'="")&&(obj.VisitJob'=hireDuty))
		..s visitName=obj.VisitPerson
		..s visitHire=obj.VisitJob
		..s visitPost=obj.VisitPost
		..s visitUnit=obj.VisitUnit
		..s visitProvince=##class(web.NurMgPersonComm).GetCommCode(ParObj.VisitProvince)
		..s ret="visitName|"_visitName_"^visitHire|"_ visitHire_"^visitPost|"_visitPost_"^visitUnit|"_visitUnit_"^visitProvince|"_visitProvince
		..d OutputVisitStatic
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputVisitStatic
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindVisitStaticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVisitStaticExecute ]
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

ClassMethod FindVisitStaticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVisitStaticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
