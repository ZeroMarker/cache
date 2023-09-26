/// 
/// 
/// 人员档案扩展
Class web.NurMgPerSubComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:保存学术会议
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveAcad(parr As %String, type As %String, user As %String) As %String
{
	s ^TMP("SaveAcad")=parr
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgAcadMeeting).%New()
	e  s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgAcadMeeting","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AcadPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgAcadMeeting","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AcadPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("AcadStatus")=type
	..s tmp("AcadUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod AuditAcadRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AcadStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询学术会议列表
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindAcadList","1")
Query FindAcadList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAcadListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindAcadList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgAcadMeetingI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAcadMeetingI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(rw)
	..i obj.AcadYear'="" s AcadYear=+$zd(obj.AcadYear,3)
	..e  s AcadYear=""
	..i obj.AcadDate'="" s AcadDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcadDate)
	..e  s AcadDate=""
	..s AcadTitle=obj.AcadTitle
	..s AcadUnit=obj.AcadUnit
	..s AcadPlace=obj.AcadPlace
	..s AcadNurNum=obj.AcadNurNum
	..s statuscode=obj.AcadStatus
	..s AcadStatus=""
	..i obj.AcadStatus="Y" s AcadStatus="提交"
	..e  i obj.AcadStatus="N" s AcadStatus="保存"
	..e  i obj.AcadStatus="A" s AcadStatus="审核"
	..e  i obj.AcadStatus="B" s AcadStatus="驳回"
	..s ret="acadYear|"_AcadYear_"^acadDate|"_AcadDate_"^acadTitle|"_AcadTitle_"^acadUnit|"_AcadUnit_"^acadPlace|"_AcadPlace_"^acadNurNum|"_AcadNurNum_"^acadStatus|"_AcadStatus_"^acadRowID|"_rw_"^statuscode|"_statuscode
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAcadListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAcadListExecute ]
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

ClassMethod FindAcadListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAcadListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取护士学术会议
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
ClassMethod GetAcadItem(id As %String) As %String
{
	;s ^TMP("GetAcadItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(id)
	i obj.AcadYear'="" s AcadYear=+$zd(obj.AcadYear,3)
	e  s AcadYear=""
	i obj.AcadDate'="" s AcadDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcadDate)
	e  s AcadDate=""
	s AcadTitle=obj.AcadTitle
	s AcadUnit=obj.AcadUnit
	s AcadPlace=obj.AcadPlace
	s AcadNurNum=obj.AcadNurNum
	s ret="AcadYear|"_AcadYear_"^AcadDate|"_AcadDate_"^AcadTitle|"_AcadTitle_"^AcadUnit|"_AcadUnit_"^AcadPlace|"_AcadPlace_"^AcadNurNum|"_AcadNurNum_"^RowID|"_id
	q ret
}

ClassMethod GetAcadStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgAcadMeeting).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AcadStatus
	q status
}

/// Creator:guozj
/// Description:保存科研基金
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgResearch
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveResea(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgResearch).%New()
	e  s obj=##class(DHCNMG.HR.MgResearch).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgResearch","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="ReseaPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgResearch","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="ReseaPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("ReseaStatus")=type
	..s tmp("ReseaUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询科研基金
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgResearch
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindReseaList","1")
Query FindReseaList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindReseaListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindReseaList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgResearchI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgResearchI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgResearch).%OpenId(rw)
	..s ReseaTitle=obj.ReseaTitle
	..s ReseaLevel=""
	..i obj.ReseaLevel'="" s ReseaLevel=##class(web.NurMgPersonComm).GetCommCode(obj.ReseaLevel)
	..i obj.ReseaDate'="" s ReseaDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ReseaDate)
	..e  s ReseaDate=""
	..s ReseaFee=obj.ReseaFee
	..s ReseaRank=""
	..i obj.ReseaRank'="" s ReseaRank=##class(web.NurMgPersonComm).GetCommCode(obj.ReseaRank)
	..
	..s statuscode=obj.ReseaStatus
	..s ReseaStatus=""
	..i obj.ReseaStatus="Y" s ReseaStatus="已提交"
	..e  i obj.ReseaStatus="N" s ReseaStatus="保存"
	..e  i obj.ReseaStatus="A" s ReseaStatus="已审核"
	..e  i obj.ReseaStatus="B" s ReseaStatus="驳回"
	..s ret="reseaTitle|"_ReseaTitle_"^reseaLevel|"_ReseaLevel_"^reseaDate|"_ReseaDate_"^reseaFee|"_ReseaFee_"^reseaRank|"_ReseaRank_"^reseaStatus|"_ReseaStatus_"^statuscode|"_statuscode_"^reseaRowID|"_rw
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindReseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReseaListExecute ]
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

ClassMethod FindReseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReseaListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取护士科研基金
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgResearch
/// Input:
/// Output：
/// Return:
ClassMethod GetReseaItem(id As %String) As %String
{
	;s ^TMP("GetReseaItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgResearch).%OpenId(id)
	s ReseaTitle=obj.ReseaTitle
	s ReseaLevel=obj.ReseaLevel
	i obj.ReseaDate'="" s ReseaDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.ReseaDate)
	e  s ReseaDate=""
	s ReseaFee=obj.ReseaFee
	s ReseaRank=obj.ReseaRank
	
	s ret="ReseaTitle|"_ReseaTitle_"^ReseaLevel|"_ReseaLevel_"^ReseaDate|"_ReseaDate_"^ReseaFee|"_ReseaFee_"^ReseaRank|"_ReseaRank_"^RowID|"_id
	q ret
}

ClassMethod GetReseaStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgResearch).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.ReseaStatus
	q status
}

ClassMethod AuditReseaRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgResearch).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.ReseaStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存获奖科研
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAward
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveAward(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgAward).%New()
	e  s obj=##class(DHCNMG.HR.MgAward).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgAward","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AwardPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgAward","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AwardPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("AwardStatus")=type
	..s tmp("AwardUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询获奖科研
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAward
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindAwardList","1")
Query FindAwardList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAwardListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindAwardList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgAwardI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAwardI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgAward).%OpenId(rw)
	..s AwardResult=obj.AwardResult
	..s AwardTitle=obj.AwardTitle
	..s AwardScore=""
	..i obj.AwardScore'="" s AwardScore=##class(web.NurMgPersonComm).GetCommCode(obj.AwardScore)
	..i obj.AwardDate'="" s AwardDate=+$zd(obj.AwardDate,3)
	..e  s AwardDate=""
	..s AwardRank=""
	..i obj.AwardRank'="" s AwardRank=##class(web.NurMgPersonComm).GetCommCode(obj.AwardRank)
	..s statuscode=obj.AwardStatus
	..s AwardStatus=""
	..i obj.AwardStatus="Y" s AwardStatus="提交"
	..e  i obj.AwardStatus="N" s AwardStatus="保存"
	..e  i obj.AwardStatus="A" s AwardStatus="审核"
	..e  i obj.AwardStatus="B" s AwardStatus="驳回"
	..s AwardPatent=obj.AwardPatent
	..s AwardPatType=""
	..i obj.AwardPatType'="" s AwardPatType=##class(web.NurMgPersonComm).GetCommCode(obj.AwardPatType)
	..s AwardThesis=obj.AwardThesis
	..s AwardPublic=""
	..s AwardPage=obj.AwardPage
	..i obj.AwardPublic'="" s AwardPublic=##class(web.NurMgPersonComm).GetCommCode(obj.AwardPublic)
	..s ret="awardResult|"_AwardResult_"^awardTitle|"_AwardTitle_"^awardScore|"_AwardScore_"^awardDate|"_AwardDate_"^awardRank|"_AwardRank_"^awardStatus|"_AwardStatus_"^statuscode|"_statuscode_"^awardRowID|"_rw_"^awardPatent|"_AwardPatent_"^awardPatType|"_AwardPatType_"^awardThesis|"_AwardThesis_"^awardPublic|"_AwardPublic_"^awardPage|"_AwardPage
	..do OutputEduData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputEduData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAwardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAwardListExecute ]
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

ClassMethod FindAwardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAwardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取护士获奖科研
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAward
/// Input:
/// Output：
/// Return:
ClassMethod GetAwardItem(id As %String) As %String
{
	;s ^TMP("GetAwardItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAward).%OpenId(id)
	s AwardResult=obj.AwardResult
	s AwardTitle=obj.AwardTitle
	s AwardScore=obj.AwardScore
	i obj.AwardDate'="" s AwardDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AwardDate)
	e  s AwardDate=""
	s AwardRank=obj.AwardRank
	s AwardPatent=obj.AwardPatent
	s AwardPatType=obj.AwardPatType
	s AwardThesis=obj.AwardThesis
	s AwardPublic=obj.AwardPublic
	s AwardPage=obj.AwardPage
	s ret="AwardResult|"_AwardResult_"^AwardTitle|"_AwardTitle_"^AwardScore|"_AwardScore_"^AwardDate|"_AwardDate_"^AwardRank|"_AwardRank_"^RowID|"_id_"^AwardPatent|"_AwardPatent_"^AwardPatType|"_AwardPatType_"^AwardThesis|"_AwardThesis_"^AwardPublic|"_AwardPublic_"^AwardPage|"_AwardPage
	q ret
}

ClassMethod GetAwardStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgAward).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AwardStatus
	q status
}

ClassMethod AuditAwardRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAward).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AwardStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存推广技术
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgPromote
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SavePromote(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgPromote).%New()
	e  s obj=##class(DHCNMG.HR.MgPromote).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgPromote","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="PromotePerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgPromote","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="PromotePerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("PromoteStatus")=type
	..s tmp("PromoteUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询推广技术
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgPromote
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindPromoteList","1")
Query FindPromoteList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPromoteListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindPromoteList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgPromoteI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgPromoteI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgPromote).%OpenId(rw)
	..s PromoteTitle=obj.PromoteTitle
	..i obj.PromoteStYear'="" s PromoteStYear=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PromoteStYear)
	..e  s PromoteStYear=""
	..i obj.PromoteEndYear'="" s PromoteEndYear=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PromoteEndYear)
	..e  s PromoteEndYear=""
	..s PromoteNum=obj.PromoteNum
	..s PromoteNurse=obj.PromoteNurse
	..s statuscode=obj.PromoteStatus
	..s PromoteStatus=""
	..i obj.PromoteStatus="Y" s PromoteStatus="提交"
	..e  i obj.PromoteStatus="N" s PromoteStatus="保存"
	..e  i obj.PromoteStatus="A" s PromoteStatus="审核"
	..e  i obj.PromoteStatus="B" s PromoteStatus="驳回"
	..s ret="promoteTitle|"_PromoteTitle_"^promoteYear|"_PromoteStYear_"--"_PromoteEndYear_"^promoteNum|"_PromoteNum_"^promoteNurse|"_PromoteNurse_"^promoteStatus|"_PromoteStatus_"^statuscode|"_statuscode_"^promoteRowID|"_rw
	..do OutputPromoteData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPromoteData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPromoteListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPromoteListExecute ]
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

ClassMethod FindPromoteListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPromoteListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取护士推广技术
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgPromote
/// Input:
/// Output：
/// Return:
ClassMethod GetPromoteItem(id As %String) As %String
{
	;s ^TMP("GetPromoteItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPromote).%OpenId(id)
	s PromoteTitle=obj.PromoteTitle
	i obj.PromoteStYear'="" s PromoteStYear=$zd(obj.PromoteStYear,3)
	e  s PromoteStYear=""
	i obj.PromoteEndYear'="" s PromoteEndYear=$zd(obj.PromoteEndYear,3)
	e  s PromoteEndYear=""
	s PromoteNum=obj.PromoteNum
	s PromoteNurse=obj.PromoteNurse
	s ret="PromoteTitle|"_PromoteTitle_"^PromoteStYear|"_PromoteStYear_"^PromoteEndYear|"_PromoteEndYear_"^PromoteNum|"_PromoteNum_"^PromoteNurse|"_PromoteNurse_"^RowID|"_id
	q ret
}

ClassMethod GetPromoteStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgPromote).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.PromoteStatus
	q status
}

ClassMethod AuditPromoteRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgPromote).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.PromoteStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存对口支援
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSupport
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveSupport(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgSupport).%New()
	e  s obj=##class(DHCNMG.HR.MgSupport).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgSupport","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="SupportPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgSupport","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="SupportPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("SupportStatus")=type
	..s tmp("SupportUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询对口支援
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSupport
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindSupportList","1")
Query FindSupportList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSupportListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindSupportList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgSupportI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgSupportI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgSupport).%OpenId(rw)
	..i obj.SupportYear'="" s SupportYear=$p($zd(obj.SupportYear,3),"-",1)
	..e  s SupportYear=""
	..s SupportAgency=obj.SupportAgency
	..i obj.SupportStDate'="" s SupportStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportStDate)
	..e  s SupportStDate=""
	..i obj.SupportEndDate'="" s SupportEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportEndDate)
	..e  s SupportEndDate=""
	..s statuscode=obj.SupportStatus
	..s SupportStatus=""
	..i obj.SupportStatus="Y" s SupportStatus="提交"
	..e  i obj.SupportStatus="N" s SupportStatus="保存"
	..e  i obj.SupportStatus="A" s SupportStatus="审核"
	..e  i obj.SupportStatus="B" s SupportStatus="驳回"
	..s ret="supportYear|"_SupportYear_"^supportAgency|"_SupportAgency_"^supportStDate|"_SupportStDate_"^supportEndDate|"_SupportEndDate_"^supportStatus|"_SupportStatus_"^statuscode|"_statuscode_"^supportRowID|"_rw
	..do OutputSupportData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSupportData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSupportListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSupportListExecute ]
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

ClassMethod FindSupportListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSupportListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取对口支援
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSupport
/// Input:
/// Output：
/// Return:
ClassMethod GetSupportItem(id As %String) As %String
{
	;s ^TMP("GetSupportItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgSupport).%OpenId(id)
	i obj.SupportYear'="" s SupportYear=+$zd(obj.SupportYear,3)
	e  s SupportYear=""
	i obj.SupportStDate'="" s SupportStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportStDate)
	e  s SupportStDate=""
	i obj.SupportEndDate'="" s SupportEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.SupportEndDate)
	e  s SupportEndDate=""
	s SupportAgency=obj.SupportAgency
	s ret="SupportYear|"_SupportYear_"^SupportStDate|"_SupportStDate_"^SupportEndDate|"_SupportEndDate_"^SupportAgency|"_SupportAgency_"^RowID|"_id
	q ret
}

ClassMethod GetSupportStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgSupport).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.SupportStatus
	q status
}

ClassMethod AuditSupportRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgSupport).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.SupportStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存专科发展
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSepcialDevelop
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveSpecial(parr As %String, type As %String, user As %String) As %String
{
	s ^TMP("SaveSpecial")=parr_"%"_type_"%"_user
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgSepcialDevelop).%New()
	e  s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgSepcialDevelop","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="SpecialPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgSepcialDevelop","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="SpecialEvent" s tmp(p)=$replace(tmp(p),$c(10),"")
	..i p="SpecialPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("SpecialStatus")=type
	..s tmp("SpecialUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询专科发展
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSepcialDevelop
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindSpecialList","1")
Query FindSpecialList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSpecialListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindSpecialList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgSepcialDevelopI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgSepcialDevelopI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(rw)
	..s SpecialEvent=obj.SpecialEvent
	..s statuscode=obj.SpecialStatus
	..s SpecialStatus=""
	..i obj.SpecialStatus="Y" s SpecialStatus="提交"
	..e  i obj.SpecialStatus="N" s SpecialStatus="保存"
	..e  i obj.SpecialStatus="A" s SpecialStatus="审核"
	..e  i obj.SpecialStatus="B" s SpecialStatus="驳回"
	..s ret="specialEvent|"_SpecialEvent_"^specialStatus|"_SpecialStatus_"^statuscode|"_statuscode_"^specialRowID|"_rw
	..do OutputSpecialData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSpecialData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSpecialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecialListExecute ]
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

ClassMethod FindSpecialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecialListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:获取专科发展
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgSepcialDevelop
/// Input:
/// Output：
/// Return:
ClassMethod GetSpecialItem(id As %String) As %String
{
	;s ^TMP("GetSpecialItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(id)
	s SpecialEvent=obj.SpecialEvent
	s ret="SpecialEvent|"_SpecialEvent_"^RowID|"_id
	q ret
}

ClassMethod GetSpecialStatus(id As %String) As %String
{
	s ^TMP("GetSpecialStatus")=id
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.SpecialStatus
	q status
}

ClassMethod AuditSpecialRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgSepcialDevelop).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.SpecialStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存教材编辑
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgTeach
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveTeach(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgTeach).%New()
	e  s obj=##class(DHCNMG.HR.MgTeach).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgTeach","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="TeachPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgTeach","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="TeachPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("TeachStatus")=type
	..s tmp("TeachUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取教材编辑
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgTeach
/// Input:
/// Output：
/// Return:
ClassMethod GetTeachItem(id As %String) As %String
{
	;s ^TMP("GetSupportItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgTeach).%OpenId(id)
	s TeachTitle=obj.TeachTitle
	s TeachPublic=obj.TeachPublic
	s TeachPubNo=obj.TeachPubNo
	s TeachType=obj.TeachType
	s ret="TeachTitle|"_TeachTitle_"^TeachPublic|"_TeachPublic_"^TeachPubNo|"_TeachPubNo_"^TeachType|"_TeachType_"^RowID|"_id
	q ret
}

ClassMethod GetTeachStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgTeach).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.TeachStatus
	q status
}

ClassMethod AuditTeachRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgTeach).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.TeachStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询教材编辑
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgTeach
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindTeachList","1")
Query FindTeachList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTeachListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindTeachList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgTeachI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgTeachI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgTeach).%OpenId(rw)
	..s TeachTitle=obj.TeachTitle
	..s TeachPublic=""
	..i obj.TeachPublic'="" s TeachPublic=##class(web.NurMgPersonComm).GetCommCode(obj.TeachPublic)
	..s TeachPubNo=obj.TeachPubNo
	..s TeachType=""
	..i obj.TeachType'="" s TeachType=##class(web.NurMgPersonComm).GetCommCode(obj.TeachType)
	..s statuscode=obj.TeachStatus
	..s TeachStatus=""
	..i obj.TeachStatus="Y" s TeachStatus="提交"
	..e  i obj.TeachStatus="N" s TeachStatus="保存"
	..e  i obj.TeachStatus="A" s TeachStatus="审核"
	..e  i obj.TeachStatus="B" s TeachStatus="驳回"
	..s ret="teachTitle|"_TeachTitle_"^teachPublic|"_TeachPublic_"^teachPubNo|"_TeachPubNo_"^teachType|"_TeachType_"^teachStatus|"_TeachStatus_"^statuscode|"_statuscode_"^teachRowID|"_rw
	..do OutputTeachData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTeachData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTeachListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTeachListExecute ]
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

ClassMethod FindTeachListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTeachListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:保存指导研究生数据
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgGuide
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveGuide(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgGuide).%New()
	e  s obj=##class(DHCNMG.HR.MgGuide).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgGuide","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="GuidePerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgGuide","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="GuidePerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("GuideStatus")=type
	..s tmp("GuideUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取指导研究生毕业
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgGuide
/// Input:
/// Output：
/// Return:
ClassMethod GetGuideItem(id As %String) As %String
{
	;s ^TMP("GetGuideItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgGuide).%OpenId(id)
	s GuideName=obj.GuideName
	s GuideSchool=obj.GuideSchool
	s GuideProfession=obj.GuideProfession
	i obj.GuideStDate'="" s GuideStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideStDate)
	e  s GuideStDate=""
	i obj.GuideEndDate'="" s GuideEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideEndDate)
	e  s GuideEndDate=""
	s GuideType=obj.GuideType
	s ret="GuideName|"_GuideName_"^GuideSchool|"_GuideSchool_"^GuideProfession|"_GuideProfession_"^GuideStDate|"_GuideStDate_"^GuideEndDate|"_GuideEndDate_"^GuideType|"_GuideType_"^RowID|"_id
	q ret
}

ClassMethod GetGuideStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgGuide).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.GuideStatus
	q status
}

ClassMethod AuditGuideRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgGuide).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.GuideStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询指导研究生毕业
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgGuide
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindGuideList","1")
Query FindGuideList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindGuideListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindGuideList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgGuideI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgGuideI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgGuide).%OpenId(rw)
	..s GuideName=obj.GuideName
	..s GuideSchool=obj.GuideSchool
	..s GuideProfession=obj.GuideProfession
	..i obj.GuideStDate'="" s GuideStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideStDate)
	..e  s GuideStDate=""
	..i obj.GuideEndDate'="" s GuideEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.GuideEndDate)
	..e  s GuideEndDate=""
	..s GuideType=""
	..i obj.GuideType'="" s GuideType=##class(web.NurMgPersonComm).GetCommCode(obj.GuideType)
	..
	..s statuscode=obj.GuideStatus
	..s GuideStatus=""
	..i obj.GuideStatus="Y" s GuideStatus="提交"
	..e  i obj.GuideStatus="N" s GuideStatus="保存"
	..e  i obj.GuideStatus="A" s GuideStatus="审核"
	..e  i obj.GuideStatus="B" s GuideStatus="驳回"
	..s ret="guideName|"_GuideName_"^guideSchool|"_GuideSchool_"^guideProfession|"_GuideProfession_"^guideStDate|"_GuideStDate_"^guideEndDate|"_GuideEndDate_"^guideType|"_GuideType_"^statuscode|"_statuscode_"^guideRowID|"_rw_"^guideStatus|"_GuideStatus
	..do OutputGuideData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputGuideData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGuideListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGuideListExecute ]
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

ClassMethod FindGuideListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGuideListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:保存学术任职生数据
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcapos
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveAcapos(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCNMG.HR.MgAcapos).%New()
	e  s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCNMG.HR.MgAcapos","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AcaposPerDR" d
	...s ptype=^oddCOM("DHCNMG.HR.MgAcapos","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AcaposPerDR" s tmp(p)=##class(DHCNMG.HR.MgPersons).%OpenId(tmp(p))
	..s tmp("AcaposStatus")=type
	..s tmp("AcaposUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取学术任职
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcapos
/// Input:
/// Output：
/// Return:
ClassMethod GetAcaposItem(id As %String) As %String
{
	;s ^TMP("GetAcaposItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(id)
	s AcaposUnit=obj.AcaposUnit
	i obj.AcaposStDate'="" s AcaposStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposStDate)
	e  s AcaposStDate=""
	i obj.AcaposEndDate'="" s AcaposEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposEndDate)
	e  s AcaposEndDate=""
	s AcaposPost=obj.AcaposPost
	s ret="AcaposUnit|"_AcaposUnit_"^AcaposStDate|"_AcaposStDate_"^AcaposEndDate|"_AcaposEndDate_"^AcaposPost|"_AcaposPost_"^RowID|"_id
	q ret
}

ClassMethod GetAcaposStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AcaposStatus
	q status
}

ClassMethod AuditAcaposRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AcaposStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询学术任职
/// Date:2018-07-16
/// Table: DHCNMG.HR.MgAcapos
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindAcaposList","1")
Query FindAcaposList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAcaposListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindAcaposList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s par="" f  s par=$O(^DHCNMG.HR.MgAcaposI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCNMG.HR.MgAcaposI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCNMG.HR.MgAcapos).%OpenId(rw)
	..s AcaposUnit=obj.AcaposUnit
	..i obj.AcaposStDate'="" s AcaposStDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposStDate)
	..e  s AcaposStDate=""
	..i obj.AcaposEndDate'="" s AcaposEndDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.AcaposEndDate)
	..e  s AcaposEndDate=""
	..s AcaposPost=""
	..i obj.AcaposPost'="" s AcaposPost=##class(web.NurMgPersonComm).GetCommCode(obj.AcaposPost)
	..
	..s statuscode=obj.AcaposStatus
	..s AcaposStatus=""
	..i obj.AcaposStatus="Y" s AcaposStatus="提交"
	..e  i obj.AcaposStatus="N" s AcaposStatus="保存"
	..e  i obj.AcaposStatus="A" s AcaposStatus="审核"
	..e  i obj.AcaposStatus="B" s AcaposStatus="驳回"
	..s ret="acaposUnit|"_AcaposUnit_"^acaposStDate|"_AcaposStDate_"^acaposEndDate|"_AcaposEndDate_"^acaposPost|"_AcaposPost_"^statuscode|"_statuscode_"^acaposRowID|"_rw_"^acaposStatus|"_AcaposStatus
	..do OutputAcaposData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputAcaposData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAcaposListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAcaposListExecute ]
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

ClassMethod FindAcaposListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAcaposListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:统计人员列表
/// Date:2018-07-25
/// Table:DHCNMG.HR.MgPersons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPerSubComm","FindPersonStatic","1")
Query FindPersonStatic(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPersonStaticExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindPersonStatic")=parr
	//109^16||1,16||2^14||1,14||2^^21||2,21||3^7||2,7||3^2||4,2||5^3||2,3||1
	s ward=$p(parr,"^",1)
	s post=$p(parr,"^",2) //职务
	s duty=$p(parr,"^",3) //职称
	s role=$p(parr,"^",4) //角色
	s level=$p(parr,"^",5) //层级
	s source=$p(parr,"^",6) //职工性质
	s police=$p(parr,"^",7) //政治面貌
	s educate=$p(parr,"^",8) //最高学历
	s ret=""
	
	s spell="" f  s spell=$O(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s depid="" f  s depid=$O(^DHCNMG.DB.MgWardI("Spell",spell,depid)) q:depid=""  d
	..q:((ward'="")&&(depid'=ward))
	..s row="" f  s row=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_depid,row)) q:row=""  d
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(row)
	...q:obj.PerTypeDR'="N"
	...q:obj.PerStatus'="17||1"
	...q:((post'="")&&(..CheckPost(row,post)'=1))
	...q:((duty'="")&&(..CheckDuty(row,duty)'=1))
	...q:((role'="")&&(..CheckRoles(row,role)'=1))
	...q:((level'="")&&(..CheckLevel(row,level)'=1))
	...q:((source'="")&&(..CheckSource(row,source)'=1))
	...q:((police'="")&&(..CheckPolice(row,police)'=1))
	...q:((educate'="")&&(..CheckEducate(row,educate)'=1))
	...
	...s nurseName=obj.PerName
	...s nurseHisNo=obj.HISNO
	...s nurseNo=obj.PerID
	...s nurseWard=..GetWardDesc(obj.PerDepDR)
	...s nurseLoc=..GetLocDesc(obj.PerLocDR)
	...
	...s nurseComeDate=""
	...i obj.PerComeDate'="" s nurseComeDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerComeDate)
	...s nurseComeYear=""
	...i obj.PerComeDate'="" d
	....s Year=##class(web.NurMgVueComm).CalAge($zd(obj.PerComeDate,3),$zd(+$H,3))
	....s nurseComeYear=$p(Year,"Y",1)
	...s nurseAge=""
	...i obj.PerBirthday'="" d
	....s age=##class(web.NurMgVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	....s nurseAge=$p(age,"Y",1)
	...s nurseWorkDate=""
	...i obj.PerWorkDate'="" s nurseWorkDate=##class(web.NurMgHISComm).DateLogicalToHtml(obj.PerWorkDate)
	...s nursePost=""
	...s postStr=..GetNurPost(row)
	...i postStr'="" s nursePost=##class(web.NurMgPersonComm).GetCommCode(postStr)
	...s nurseDuty=""
	...s dutyStr=..GetNurDuty(row)
	...i dutyStr'="" s nurseDuty=##class(web.NurMgPersonComm).GetCommCode(dutyStr)
	...s ret="nurseName|"_nurseName_"^nurseHisNo|"_nurseHisNo_"^nurseNo|"_nurseNo_"^nurseLoc|"_nurseLoc_"^nurseWard|"_nurseWard_"^nurseComeDate|"_nurseComeDate_"^nurseComeYear|"_nurseComeYear_"^nurseAge|"_nurseAge_"^nurseWorkDate|"_nurseWorkDate_"^nursePost|"_nursePost_"^nurseDuty|"_nurseDuty_"^RowID|"_row
	...d OutputStaticData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputStaticData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonStaticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonStaticExecute ]
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

ClassMethod FindPersonStaticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonStaticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNurDuty(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s row="" f  s row=$O(^DHCNMG.HR.MgHireDutyI("ssid",id,row)) q:row=""  d
	.s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(row)
	.q:obj.HireEndDate'=""
	.s ret=obj.HireDuty
	q ret
}

ClassMethod GetNurPost(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s row="" f  s row=$O(^DHCNMG.HR.MgPostDutyI("ssid",id,row)) q:row=""  d
	.s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(row)
	.q:obj.PostEndDate'=""
	.s ret=obj.PostDuty
	q ret
}

ClassMethod CheckEducate(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s date=$O(^DHCNMG.HR.MgEducateI("flag",id,""),-1)
		i date'="" 
		{
			s rw=$O(^DHCNMG.HR.MgEducateI("flag",id,date,""))
			q:rw=""
			s obj=##class(DHCNMG.HR.MgEducate).%OpenId(rw)
			q:'$IsObject(obj)
			q:((obj.EduAcademic'="")&&(obj.EduAcademic'=itm))
			s flag=1
		}
	}
	q flag
}

ClassMethod CheckPolice(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
		q:'$IsObject(obj)
		q:((obj.PerPolitical'="")&&(obj.PerPolitical'=itm))
		s flag=1
	}
	q flag
}

ClassMethod CheckSource(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s obj=##class(DHCNMG.HR.MgPersons).%OpenId(id)
		q:'$IsObject(obj)
		q:((obj.PerSource'="")&&(obj.PerSource'=itm))
		s flag=1
	}
	q flag
}

ClassMethod CheckLevel(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	s date=0
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgLevelI("ssid",id,rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgLevel).%OpenId(rowid)
	.i obj.LevelDate>date s date=obj.LevelDate 
	i date>0
	{
		f i=1:1:$l(str,",")
		{
			s itm=$p(str,",",i)
			i itm="" continue
			s row=$O(^DHCNGM.HR.MgLevelI("date",date,id,""))
			s lobj=##class(DHCNMG.HR.MgLevel).%OpenId(row)
			q:'$IsObject(lobj)
			q:(lobj.NurLevel'=itm)
			s flag=1
		}
	}	
	q flag
}

ClassMethod CheckRoles(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s rowid="" f  s rowid=$O(^DHCNMG.HR.MgNurRoleI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.HR.MgNurRole).%OpenId(rowid)
		.q:((obj.RoleEndDate'="")&&(obj.RoleEndDate<+$h))
		.q:((obj.RoleID'="")&&(obj.RoleID'=itm))
		.s flag=1
	}
	q flag
}

ClassMethod CheckDuty(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s rowid="" f  s rowid=$O(^DHCNMG.HR.MgHireDutyI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.HR.MgHireDuty).%OpenId(rowid)
		.q:((obj.HireEndDate'="")&&(obj.HireEndDate<+$h))
		.q:((obj.HireDuty'="")&&(obj.HireDuty'=itm))
		.s flag=1
	}
	q flag
}

ClassMethod CheckPost(id As %String, str As %String) As %String
{
	q:id="" ""
	s flag=0
	f i=1:1:$l(str,",")
	{
		s itm=$p(str,",",i)
		i itm="" continue
		s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPostDutyI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(DHCNMG.HR.MgPostDuty).%OpenId(rowid)
		.q:((obj.PostEndDate'="")&&(obj.PostEndDate<+$h))
		.q:((obj.PostDuty'="")&&(obj.PostDuty'=itm))
		.s flag=1
	}
	q flag
}

ClassMethod GetWardDesc(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWard).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.WardDesc
	q ret
}

ClassMethod GetLocDesc(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(DHCNMG.DB.MgWardLoc).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.LocDesc
	q ret
}

/// Creator:guozj
/// Description:查询角色
/// Date:2017-06-26
/// Table:DHCNMG.Set.MgRoles
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgPersonComm","FindRoles","1")
Query FindRoles(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRolesExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^DHCNMG.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s row="" f  s row=$O(^DHCNMG.Set.MgRolesI("Sort",sort,row)) q:row=""  d
	..s obj=##class(DHCNMG.Set.MgRoles).%OpenId(row)
	..s roledesc=obj.RoleDesc
	..
	..s ret="roledesc|"_roledesc_"^row|"_row
	..d OutputRoleData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRoleData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRolesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRolesExecute ]
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

ClassMethod FindRolesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRolesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
