/// 人员档案扩展
Class web.INMPerSubComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:保存学术会议
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
/// Others: 
ClassMethod SaveAcad(parr As %String, type As %String, user As %String) As %String
{
	s ^TMP("SaveAcad")=parr
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgAcadMeeting).%New()
	e  s obj=##class(DHCINM.HR.MgAcadMeeting).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgAcadMeeting","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AcadPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgAcadMeeting","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AcadPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("AcadStatus")=type
	..s tmp("AcadUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

ClassMethod AuditAcadRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAcadMeeting).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AcadStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.AcadStatus="A")||(obj.AcadStatus="B"))) d
		.s AcadStatus=$case(obj.AcadStatus,"A":"审核","B":"驳回") ;状态描述
		.s AcadYear1=$lg($g(^DHCINM.HR.MgAcadMeetingD(id)),3)
		.s AcadYear2=""
		.s:AcadYear1'="" AcadYear2=$zd(AcadYear1,3)
		.s AcadYear=$p(AcadYear2,"-",1)
		.s AcadTitle=$lg($g(^DHCINM.HR.MgAcadMeetingD(id)),4)
		.s AcadDate=$lg($g(^DHCINM.HR.MgAcadMeetingD(id)),5)
		.s:AcadDate'="" AcadDate=$zd(AcadDate,3)
		.s perId=$lg($g(^DHCINM.HR.MgAcadMeetingD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/学术会议】"_AcadStatus_" "_AcadYear_" "_AcadTitle_" "_AcadDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgAcadMeeting",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询学术会议列表
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindAcadList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgAcadMeetingI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgAcadMeetingI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgAcadMeeting).%OpenId(rw)
	..i obj.AcadYear'="" s AcadYear=+$zd(obj.AcadYear,3)
	..e  s AcadYear=""
	..i obj.AcadDate'="" s AcadDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcadDate)
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
/// Table: DHCINM.HR.MgAcadMeeting
/// Input:
/// Output：
/// Return:
ClassMethod GetAcadItem(id As %String) As %String
{
	;s ^TMP("GetAcadItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAcadMeeting).%OpenId(id)
	i obj.AcadYear'="" s AcadYear=+$zd(obj.AcadYear,3)
	e  s AcadYear=""
	i obj.AcadDate'="" s AcadDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcadDate)
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
	s obj=##class(DHCINM.HR.MgAcadMeeting).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AcadStatus
	q status
}

/// Creator:guozj
/// Description:保存科研基金
/// Date:2018-07-16
/// Table: DHCINM.HR.MgResearch
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveResea(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgResearch).%New()
	e  s obj=##class(DHCINM.HR.MgResearch).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgResearch","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="ReseaPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgResearch","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="ReseaPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("ReseaStatus")=type
	..s tmp("ReseaUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询科研基金
/// Date:2018-07-16
/// Table: DHCINM.HR.MgResearch
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindReseaList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgResearchI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgResearchI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgResearch).%OpenId(rw)
	..s ReseaTitle=obj.ReseaTitle
	..s ReseaLevel=""
	..i obj.ReseaLevel'="" s ReseaLevel=##class(web.INMPersonComm).GetCommCode(obj.ReseaLevel)
	..i obj.ReseaDate'="" s ReseaDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ReseaDate)
	..e  s ReseaDate=""
	..s ReseaFee=obj.ReseaFee
	..s ReseaRank=""
	..i obj.ReseaRank'="" s ReseaRank=##class(web.INMPersonComm).GetCommCode(obj.ReseaRank)
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
/// Table: DHCINM.HR.MgResearch
/// Input:
/// Output：
/// Return:
ClassMethod GetReseaItem(id As %String) As %String
{
	;s ^TMP("GetReseaItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgResearch).%OpenId(id)
	s ReseaTitle=obj.ReseaTitle
	s ReseaLevel=obj.ReseaLevel
	i obj.ReseaDate'="" s ReseaDate=##class(web.INMHISComm).DateLogicalToHtml(obj.ReseaDate)
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
	s obj=##class(DHCINM.HR.MgResearch).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.ReseaStatus
	q status
}

ClassMethod AuditReseaRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgResearch).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.ReseaStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.ReseaStatus="A")||(obj.ReseaStatus="B"))) d
		.s ReseaStatus=$case(obj.ReseaStatus,"A":"审核","B":"驳回") ;状态描述
		.s ReseaTitle=$lg($g(^DHCINM.HR.MgResearchD(id)),3)
		.s ReseaLevel=##class(web.INMPersonComm).GetCommCode(obj.ReseaLevel)
		.s ReseaDate=$lg($g(^DHCINM.HR.MgResearchD(id)),5) 
		.s:ReseaDate'="" ReseaDate=$zd(ReseaDate,3)
		.s perId=$lg($g(^DHCINM.HR.MgResearchD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/科研基金】"_ReseaStatus_" "_ReseaTitle_" "_ReseaLevel_" "_ReseaDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgResearch",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存获奖科研
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAward
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveAward(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgAward).%New()
	e  s obj=##class(DHCINM.HR.MgAward).%OpenId(id)
	
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgAward","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AwardPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgAward","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AwardPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("AwardStatus")=type
	..s tmp("AwardUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询获奖科研
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAward
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindAwardList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgAwardI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgAwardI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgAward).%OpenId(rw)
	..s AwardResult=obj.AwardResult
	..s AwardTitle=obj.AwardTitle
	..s AwardScore=""
	..i obj.AwardScore'="" s AwardScore=##class(web.INMPersonComm).GetCommCode(obj.AwardScore)
	..i obj.AwardDate'="" s AwardDate=$zd(obj.AwardDate,3)
	..e  s AwardDate=""
	..s AwardRank=""
	..i obj.AwardRank'="" s AwardRank=##class(web.INMPersonComm).GetCommCode(obj.AwardRank)
	..s statuscode=obj.AwardStatus
	..s AwardStatus=""
	..i obj.AwardStatus="Y" s AwardStatus="提交"
	..e  i obj.AwardStatus="N" s AwardStatus="保存"
	..e  i obj.AwardStatus="A" s AwardStatus="审核"
	..e  i obj.AwardStatus="B" s AwardStatus="驳回"
	..s AwardPatent=obj.AwardPatent
	..s AwardPatType=""
	..i obj.AwardPatType'="" s AwardPatType=##class(web.INMPersonComm).GetCommCode(obj.AwardPatType)
	..s AwardThesis=obj.AwardThesis
	..s AwardPublic=""
	..s AwardPage=obj.AwardPage
	..i obj.AwardPublic'="" s AwardPublic=##class(web.INMPersonComm).GetCommCode(obj.AwardPublic)
	..s AwardType=""
	..i obj.AwardType'="" s AwardType=##class(web.INMPersonComm).GetCommCode(obj.AwardType)
	..s AwardName=obj.AwardName
	..s ret="awardResult|"_AwardResult_"^awardTitle|"_AwardTitle_"^awardScore|"_AwardScore_"^awardDate|"_AwardDate_"^awardRank|"_AwardRank_"^awardStatus|"_AwardStatus_"^statuscode|"_statuscode_"^awardRowID|"_rw_"^awardPatent|"_AwardPatent_"^awardPatType|"_AwardPatType_"^awardThesis|"_AwardThesis_"^awardPublic|"_AwardPublic_"^awardPage|"_AwardPage
	..s ret=ret_"^AwardType|"_AwardType_"^AwardName|"_AwardName
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
/// Table: DHCINM.HR.MgAward
/// Input:
/// Output：
/// Return:
ClassMethod GetAwardItem(id As %String) As %String
{
	;s ^TMP("GetAwardItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAward).%OpenId(id)
	s AwardResult=obj.AwardResult
	s AwardTitle=obj.AwardTitle
	s AwardScore=obj.AwardScore
	i obj.AwardDate'="" s AwardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AwardDate)
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
	s obj=##class(DHCINM.HR.MgAward).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AwardStatus
	q status
}

ClassMethod AuditAwardRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAward).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AwardStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.AwardStatus="A")||(obj.AwardStatus="B"))) d
		.s AwardStatus=$case(obj.AwardStatus,"A":"审核","B":"驳回") ;状态描述
		.s AwardResult=$lg($g(^DHCINM.HR.MgAwardD(id)),3)
		.s AwardTitle=$lg($g(^DHCINM.HR.MgAwardD(id)),4)
		.s AwardDate=$lg($g(^DHCINM.HR.MgAwardD(id)),6) 
		.s:AwardDate'="" AwardDate=$zd(AwardDate,3)
		.s AwardDate=$p(AwardDate,"-",1)
		.s perId=$lg($g(^DHCINM.HR.MgAwardD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/获奖科研】"_AwardStatus_" "_AwardResult_" "_AwardTitle_" "_AwardDate	
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgAward",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存推广技术
/// Date:2018-07-16
/// Table: DHCINM.HR.MgPromote
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SavePromote(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgPromote).%New()
	e  s obj=##class(DHCINM.HR.MgPromote).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgPromote","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="PromotePerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgPromote","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="PromotePerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("PromoteStatus")=type
	..s tmp("PromoteUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询推广技术
/// Date:2018-07-16
/// Table: DHCINM.HR.MgPromote
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindPromoteList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgPromoteI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgPromoteI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgPromote).%OpenId(rw)
	..s PromoteTitle=obj.PromoteTitle
	..i obj.PromoteStYear'="" s PromoteStYear=+$zd(obj.PromoteStYear,3)
	..e  s PromoteStYear=""
	..i obj.PromoteEndYear'="" s PromoteEndYear=+$zd(obj.PromoteEndYear,3)
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
/// Table: DHCINM.HR.MgPromote
/// Input:
/// Output：
/// Return:
ClassMethod GetPromoteItem(id As %String) As %String
{
	;s ^TMP("GetPromoteItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgPromote).%OpenId(id)
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
	s obj=##class(DHCINM.HR.MgPromote).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.PromoteStatus
	q status
}

ClassMethod AuditPromoteRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgPromote).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.PromoteStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.PromoteStatus="A")||(obj.PromoteStatus="B"))) d
		.s PromoteStatus=$case(obj.PromoteStatus,"A":"审核","B":"驳回") ;状态描述
		.s PromoteTitle=$lg($g(^DHCINM.HR.MgPromoteD(id)),3)
		.s perId=$lg($g(^DHCINM.HR.MgPromoteD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/推广技术】"_PromoteStatus_" "_PromoteTitle
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgPromote",id)
	}catch{
	}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存对口支援
/// Date:2018-07-16
/// Table: DHCINM.HR.MgSupport
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveSupport(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgSupport).%New()
	e  s obj=##class(DHCINM.HR.MgSupport).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgSupport","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="SupportPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgSupport","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="SupportPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("SupportStatus")=type
	..s tmp("SupportUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询对口支援
/// Date:2018-07-16
/// Table: DHCINM.HR.MgSupport
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindSupportList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgSupportI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgSupportI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgSupport).%OpenId(rw)
	..i obj.SupportYear'="" s SupportYear=+$zd(obj.SupportYear,3)
	..e  s SupportYear=""
	..s SupportAgency=obj.SupportAgency
	..i obj.SupportStDate'="" s SupportStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SupportStDate)
	..e  s SupportStDate=""
	..i obj.SupportEndDate'="" s SupportEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SupportEndDate)
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
/// Table: DHCINM.HR.MgSupport
/// Input:
/// Output：
/// Return:
ClassMethod GetSupportItem(id As %String) As %String
{
	;s ^TMP("GetSupportItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgSupport).%OpenId(id)
	i obj.SupportYear'="" s SupportYear=$zd(obj.SupportYear,3)
	e  s SupportYear=""
	i obj.SupportStDate'="" s SupportStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SupportStDate)
	e  s SupportStDate=""
	i obj.SupportEndDate'="" s SupportEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.SupportEndDate)
	e  s SupportEndDate=""
	s SupportAgency=obj.SupportAgency
	s ret="SupportYear|"_SupportYear_"^SupportStDate|"_SupportStDate_"^SupportEndDate|"_SupportEndDate_"^SupportAgency|"_SupportAgency_"^RowID|"_id
	q ret
}

ClassMethod GetSupportStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgSupport).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.SupportStatus
	q status
}

ClassMethod AuditSupportRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgSupport).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.SupportStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.SupportStatus="A")||(obj.SupportStatus="B"))) d
		.s SupportStatus=$case(obj.SupportStatus,"A":"审核","B":"驳回") ;状态描述
		.s SupportYear1=$lg($g(^DHCINM.HR.MgSupportD(id)),3) 
		.s SupportYear2=""
		.s:SupportYear1'="" SupportYear2=$zd(SupportYear1,3)
		.s SupportYear=$p(SupportYear2,"-",1)
		.s perId=$lg($g(^DHCINM.HR.MgSupportD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/对口支援】"_SupportStatus_" "_SupportYear
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgSupport",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存专科发展
/// Date:2018-07-16
/// Table: DHCINM.HR.MgSpecialDevelop
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveSpecial(parr As %String, type As %String, user As %String) As %String
{
	s ^TMP("SaveSpecial")=parr_"%"_type_"%"_user
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgSpecialDevelop).%New()
	e  s obj=##class(DHCINM.HR.MgSpecialDevelop).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgSpecialDevelop","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="SpecialPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgSpecialDevelop","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..;i p="SpecialEvent" s tmp(p)=$replace(tmp(p),$c(10),"")
	..i p="SpecialPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..i (p="SpecialBook")||(p="SpecialDepart") s tmp(p)=$replace(tmp(p),"|","_")
	..s tmp("SpecialStatus")=type
	..s tmp("SpecialUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询专科发展
/// Date:2020-03-09
/// Table: DHCINM.HR.MgSpecialDevelop
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindSpecialList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgSpecialDevelopI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgSpecialDevelopI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgSpecialDevelop).%OpenId(rw)
	..s SpecialDepart=##class(web.INMPersonComm).GetCommCode($tr(obj.SpecialDepart,"_","|"))
	..s SpecialBook=##class(web.INMPersonComm).GetCommCode($tr(obj.SpecialBook,"_","|"))
	..s statuscode=obj.SpecialStatus
	..s specialGetDate=$zd(obj.SpecialGetDate,3)
	..s SpecialStatus=""
	..i obj.SpecialStatus="Y" s SpecialStatus="提交"
	..e  i obj.SpecialStatus="N" s SpecialStatus="保存"
	..e  i obj.SpecialStatus="A" s SpecialStatus="审核"
	..e  i obj.SpecialStatus="B" s SpecialStatus="驳回"
	..s ret="specialDepart|"_SpecialDepart_"^specialGetDate|"_specialGetDate_"^specialStatus|"_SpecialStatus_"^specialBook|"_SpecialBook_"^specialRowID|"_rw
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
/// Table: DHCINM.HR.MgSpecialDevelop
/// Input:
/// Output：
/// Return:
ClassMethod GetSpecialItem(id As %String) As %String
{
	s ^TMP("GetSpecialItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgSpecialDevelop).%OpenId(id)
	s SpecialDepart=($tr(obj.SpecialDepart,"_","|"))
	s SpecialBook=($tr(obj.SpecialBook,"_","|"))
	s statuscode=obj.SpecialStatus
	s specialGetDate=$zd(obj.SpecialGetDate,3)
	s SpecialStatus=""
	i obj.SpecialStatus="Y" s SpecialStatus="提交"
	e  i obj.SpecialStatus="N" s SpecialStatus="保存"
	e  i obj.SpecialStatus="A" s SpecialStatus="审核"
	e  i obj.SpecialStatus="B" s SpecialStatus="驳回"
	s ret="SpecialDepart|"_SpecialDepart_"^SpecialGetDate|"_specialGetDate_"^SpecialStatus|"_SpecialStatus_"^SpecialBook|"_SpecialBook_"^RowID|"_id
	q ret
}

ClassMethod GetSpecialStatus(id As %String) As %String
{
	s ^TMP("GetSpecialStatus")=id
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgSpecialDevelop).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.SpecialStatus
	q status
}

ClassMethod AuditSpecialRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgSpecialDevelop).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.SpecialStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:保存教材编辑
/// Date:2018-07-16
/// Table: DHCINM.HR.MgTeach
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveTeach(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgTeach).%New()
	e  s obj=##class(DHCINM.HR.MgTeach).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgTeach","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="TeachPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgTeach","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="TeachPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("TeachStatus")=type
	..s tmp("TeachUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取教材编辑
/// Date:2018-07-16
/// Table: DHCINM.HR.MgTeach
/// Input:
/// Output：
/// Return:
ClassMethod GetTeachItem(id As %String) As %String
{
	;s ^TMP("GetSupportItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgTeach).%OpenId(id)
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
	s obj=##class(DHCINM.HR.MgTeach).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.TeachStatus
	q status
}

ClassMethod AuditTeachRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgTeach).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.TeachStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.TeachStatus="A")||(obj.TeachStatus="B"))) d
		.s TeachStatus=$case(obj.TeachStatus,"A":"审核","B":"驳回") ;状态描述
		.s TeachTitle=$lg($g(^DHCINM.HR.MgTeachD(id)),3)
		.s TeachPublic=##class(web.INMPersonComm).GetCommCode(obj.TeachPublic)
		.s TeachPubNo=$lg($g(^DHCINM.HR.MgTeachD(id)),5)
		.s TeachType=##class(web.INMPersonComm).GetCommCode(obj.TeachType)
		.s perId=$lg($g(^DHCINM.HR.MgTeachD(id)),2) 
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perId,""))
		.s ret="【护士档案/教材编辑】"_TeachStatus_" "_TeachTitle_" "_TeachPublic_" "_TeachPubNo_" "_TeachType
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgTeach",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询教材编辑
/// Date:2018-07-16
/// Table: DHCINM.HR.MgTeach
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindTeachList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgTeachI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgTeachI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgTeach).%OpenId(rw)
	..s TeachTitle=obj.TeachTitle
	..s TeachPublic=""
	..i obj.TeachPublic'="" s TeachPublic=##class(web.INMPersonComm).GetCommCode(obj.TeachPublic)
	..s TeachPubNo=obj.TeachPubNo
	..s TeachType=""
	..i obj.TeachType'="" s TeachType=##class(web.INMPersonComm).GetCommCode(obj.TeachType)
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
/// Table: DHCINM.HR.MgGuide
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveGuide(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgGuide).%New()
	e  s obj=##class(DHCINM.HR.MgGuide).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgGuide","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="GuidePerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgGuide","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="GuidePerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("GuideStatus")=type
	..s tmp("GuideUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取指导研究生毕业
/// Date:2018-07-16
/// Table: DHCINM.HR.MgGuide
/// Input:
/// Output：
/// Return:
ClassMethod GetGuideItem(id As %String) As %String
{
	;s ^TMP("GetGuideItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgGuide).%OpenId(id)
	s GuideName=obj.GuideName
	s GuideSchool=obj.GuideSchool
	s GuideProfession=obj.GuideProfession
	i obj.GuideStDate'="" s GuideStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GuideStDate)
	e  s GuideStDate=""
	i obj.GuideEndDate'="" s GuideEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GuideEndDate)
	e  s GuideEndDate=""
	s GuideType=obj.GuideType
	s ret="GuideName|"_GuideName_"^GuideSchool|"_GuideSchool_"^GuideProfession|"_GuideProfession_"^GuideStDate|"_GuideStDate_"^GuideEndDate|"_GuideEndDate_"^GuideType|"_GuideType_"^RowID|"_id
	q ret
}

ClassMethod GetGuideStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgGuide).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.GuideStatus
	q status
}

ClassMethod AuditGuideRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgGuide).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.GuideStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询指导研究生毕业
/// Date:2018-07-16
/// Table: DHCINM.HR.MgGuide
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindGuideList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgGuideI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgGuideI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgGuide).%OpenId(rw)
	..s GuideName=obj.GuideName
	..s GuideSchool=obj.GuideSchool
	..s GuideProfession=obj.GuideProfession
	..i obj.GuideStDate'="" s GuideStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GuideStDate)
	..e  s GuideStDate=""
	..i obj.GuideEndDate'="" s GuideEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.GuideEndDate)
	..e  s GuideEndDate=""
	..s GuideType=""
	..i obj.GuideType'="" s GuideType=##class(web.INMPersonComm).GetCommCode(obj.GuideType)
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
/// Table: DHCINM.HR.MgAcapos
/// Input:
/// Output：
/// Return:
/// Others:
ClassMethod SaveAcapos(parr As %String, type As %String, user As %String) As %String
{
	s tmp=""
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	s id=$g(tmp("RowID"))
	i id="" s obj=##class(DHCINM.HR.MgAcapos).%New()
	e  s obj=##class(DHCINM.HR.MgAcapos).%OpenId(id)
	s p="" f  s p=$O(^oddCOM("DHCINM.HR.MgAcapos","a",p)) q:p=""  d
	.q:p["%"
	.i $D(tmp(p)) d
	..i p'="AcaposPerDR" d
	...s ptype=^oddCOM("DHCINM.HR.MgAcapos","a",p,"P","XSDTYPE")
	...i ((ptype="date")&&(tmp(p)'="")) d
	....s tmp(p)=$zdh(tmp(p),3)
	..i p="AcaposPerDR" s tmp(p)=##class(CF.DHCINM.HR.Persons).%OpenId(tmp(p))
	..s tmp("AcaposStatus")=type
	..s tmp("AcaposUser")=user
	..s $ZOBJPROPERTY(obj,p)=tmp(p)
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:获取学术任职
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAcapos
/// Input:
/// Output：
/// Return:
ClassMethod GetAcaposItem(id As %String) As %String
{
	;s ^TMP("GetAcaposItem")=id
	s ret=""
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAcapos).%OpenId(id)
	s AcaposUnit=obj.AcaposUnit
	i obj.AcaposStDate'="" s AcaposStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcaposStDate)
	e  s AcaposStDate=""
	i obj.AcaposEndDate'="" s AcaposEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcaposEndDate)
	e  s AcaposEndDate=""
	s AcaposPost=obj.AcaposPost
	s ret="AcaposUnit|"_AcaposUnit_"^AcaposStDate|"_AcaposStDate_"^AcaposEndDate|"_AcaposEndDate_"^AcaposPost|"_AcaposPost_"^RowID|"_id
	q ret
}

ClassMethod GetAcaposStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgAcapos).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.AcaposStatus
	q status
}

ClassMethod AuditAcaposRec(id As %String, type As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCINM.HR.MgAcapos).%OpenId(id)
	q:'$IsObject(obj) ""
 	s obj.AcaposStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:guozj
/// Description:查询学术任职
/// Date:2018-07-16
/// Table: DHCINM.HR.MgAcapos
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindAcaposList","1")
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
	s par="" f  s par=$O(^DHCINM.HR.MgAcaposI("ssid",par)) q:par=""  d
	.q:((parr'="")&&(par'=parr))
	.s rw="" f  s rw=$O(^DHCINM.HR.MgAcaposI("ssid",par,rw)) q:rw=""  d
	..s obj=##class(DHCINM.HR.MgAcapos).%OpenId(rw)
	..s AcaposUnit=obj.AcaposUnit
	..i obj.AcaposStDate'="" s AcaposStDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcaposStDate)
	..e  s AcaposStDate=""
	..i obj.AcaposEndDate'="" s AcaposEndDate=##class(web.INMHISComm).DateLogicalToHtml(obj.AcaposEndDate)
	..e  s AcaposEndDate=""
	..s AcaposPost=""
	..i obj.AcaposPost'="" s AcaposPost=##class(web.INMPersonComm).GetCommCode(obj.AcaposPost)
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
/// Table:CF.DHCINM.HR.Persons
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindPersonStatic","1")
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
	
	s spell="" f  s spell=$O(^CF.DHCINM.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s depid="" f  s depid=$O(^CF.DHCINM.DB.MgWardI("Spell",spell,depid)) q:depid=""  d
	..q:((ward'="")&&(depid'=ward))
	..s row="" f  s row=$O(^CF.DHCINM.HR.PersonsI("DepID"," "_depid,row)) q:row=""  d
	...s obj=##class(CF.DHCINM.HR.Persons).%OpenId(row)
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
	...i obj.PerComeDate'="" s nurseComeDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerComeDate)
	...s nurseComeYear=""
	...i obj.PerComeDate'="" d
	....s Year=##class(web.INMVueComm).CalAge($zd(obj.PerComeDate,3),$zd(+$H,3))
	....s nurseComeYear=$p(Year,"Y",1)
	...s nurseAge=""
	...i obj.PerBirthday'="" d
	....s age=##class(web.INMVueComm).CalAge($zd(obj.PerBirthday,3),$zd(+$H,3))
	....s nurseAge=$p(age,"Y",1)
	...s nurseWorkDate=""
	...i obj.PerWorkDate'="" s nurseWorkDate=##class(web.INMHISComm).DateLogicalToHtml(obj.PerWorkDate)
	...s nursePost=""
	...s postStr=..GetNurPost(row)
	...i postStr'="" s nursePost=##class(web.INMPersonComm).GetCommCode(postStr)
	...s nurseDuty=""
	...s dutyStr=..GetNurDuty(row)
	...i dutyStr'="" s nurseDuty=##class(web.INMPersonComm).GetCommCode(dutyStr)
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
	s row="" f  s row=$O(^CF.DHCINM.HR.HireDutyI("ssid",id,row)) q:row=""  d
	.s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(row)
	.q:obj.HireEndDate'=""
	.s ret=obj.HireDuty
	q ret
}

ClassMethod GetNurPost(id As %String) As %String
{
	q:id="" ""
	s ret=""
	s row="" f  s row=$O(^CF.DHCINM.HR.PostDutyI("ssid",id,row)) q:row=""  d
	.s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(row)
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
		s date=$O(^CF.DHCINM.HR.EducateI("flag",id,""),-1)
		i date'="" 
		{
			s rw=$O(^CF.DHCINM.HR.EducateI("flag",id,date,""))
			q:rw=""
			s obj=##class(CF.DHCINM.HR.Educate).%OpenId(rw)
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
		s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
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
		s obj=##class(CF.DHCINM.HR.Persons).%OpenId(id)
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
	s rowid="" f  s rowid=$O(^CF.DHCINM.HR.MgLevelI("ssid",id,rowid)) q:rowid=""  d
	.s obj=##class(CF.DHCINM.HR.MgLevel).%OpenId(rowid)
	.i obj.LevelDate>date s date=obj.LevelDate 
	i date>0
	{
		f i=1:1:$l(str,",")
		{
			s itm=$p(str,",",i)
			i itm="" continue
			s row=$O(^DHCNGM.HR.MgLevelI("date",date,id,""))
			s lobj=##class(CF.DHCINM.HR.MgLevel).%OpenId(row)
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
		s rowid="" f  s rowid=$O(^DHCINM.HR.MgNurRoleI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(DHCINM.HR.MgNurRole).%OpenId(rowid)
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
		s rowid="" f  s rowid=$O(^CF.DHCINM.HR.HireDutyI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(CF.DHCINM.HR.HireDuty).%OpenId(rowid)
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
		s rowid="" f  s rowid=$O(^CF.DHCINM.HR.PostDutyI("ssid",id,rowid)) q:rowid=""  d
		.s obj=##class(CF.DHCINM.HR.PostDuty).%OpenId(rowid)
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
	s obj=##class(CF.DHCINM.DB.MgWard).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.WardDesc
	q ret
}

ClassMethod GetLocDesc(id As %String) As %String
{
	s ret=""
	q:id="" ""
	s obj=##class(CF.DHCINM.DB.MgWardLoc).%OpenId(id)
	q:'$IsObject(obj) ""
	s ret=obj.LocDesc
	q ret
}

/// Creator:guozj
/// Description:查询角色
/// Date:2017-06-26
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPersonComm","FindRoles","1")
Query FindRoles(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRolesExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s sort="" f  s sort=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort)) q:sort=""  d
	.s row="" f  s row=$O(^CT.DHCINM.Set.MgRolesI("Sort",sort,row)) q:row=""  d
	..s obj=##class(CT.DHCINM.Set.MgRoles).%OpenId(row)
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

/// Creator:wangcc
/// Description:查询资格注册
/// Date:2020-03-09
/// Table: DHCINM.HR.MgQualRegisted
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindRegistedList","1")
Query FindRegistedList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRegistedListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgQualRegistedI("ssid"," "_parr,rw)) q:rw=""  d
	.s ret=..GetRegistedItem(rw)
	.do OutputRegistedData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRegistedData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindRegistedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRegistedListExecute ]
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

ClassMethod FindRegistedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRegistedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:保存资格注册
/// Date:2020-03-26
ClassMethod SaveRegisted(parr)
{
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("id"))="" s obj=##class(DHCINM.HR.MgQualRegisted).%New()
	e  s obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(tmp("id"))
	s obj.RegistedDate=$zdh(tmp("date"),3)
	s:$g(tmp("validDate"))'="" obj.RegistedValidDate=$zdh(tmp("validDate"),3)
	s obj.RegistedPerson=tmp("PerDR")
	s obj.RegistedStatus=tmp("flag")
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:获取资格注册单条记录
/// Date:2020-03-26
ClassMethod GetRegistedItem(id)
{
	s obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	q:'$IsObject(obj)
	s date=$zd(obj.RegistedDate,3)
	s RegistedValidDate=obj.RegistedValidDate
	i (RegistedValidDate="")&&(date'="") d
	.s RegistedValidDate=##class(web.INMCommon).GetAfterNYearDate(obj.RegistedDate,5)
	s:RegistedValidDate'="" RegistedValidDate=$zd(RegistedValidDate,3)
	s RegistedStatus=""
	i obj.RegistedStatus="Y" s RegistedStatus="提交"
	e  i obj.RegistedStatus="N" s RegistedStatus="保存"
	e  i obj.RegistedStatus="A" s RegistedStatus="审核"
	e  i obj.RegistedStatus="B" s RegistedStatus="驳回"
	s ret="RegistedDate|"_date_"^RegistedValidDate|"_RegistedValidDate_"^RegistedStatus|"_RegistedStatus_"^RowID|"_id
	q ret
}

/// Creator:wangcc
/// Description:删除资格注册
/// Date:2020-03-26
ClassMethod DeleteRegistedItem(id)
{
	s obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	q:'$IsObject(obj)
	s sc=obj.%DeleteId(id)
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:审核资格注册
/// Date:2020-03-26
ClassMethod AuditRegistedRec(id, type)
{
	s obj=##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	q:'$IsObject(obj)
	s obj.RegistedStatus=type
	s sc=obj.%Save()
	try{
		i ($$$ISOK(sc)&&((obj.RegistedStatus="A")||(obj.RegistedStatus="B"))) d
		.s RegistedStatusDesc=$case(obj.RegistedStatus,"A":"审核","B":"驳回")
		.s registedDate1=$LG($g(^DHCINM.HR.MgQualRegistedD(id)),3)
		.s registedDate=""
		.s:registedDate1'="" registedDate=$zd(registedDate1,3)
		.s perID=$LG($g(^DHCINM.HR.MgQualRegistedD(id)),5)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_perID,""))
		.s ret="【护士档案/资格注册】 "_RegistedStatusDesc_" "_registedDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgQualRegisted",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询社会兼职
/// Date:2020-03-22
/// Table: DHCINM.HR.MgNurSocialWork
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindSocialWorkList","1")
Query FindSocialWorkList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindSocialWorkListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindSocialWorkList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurSocialWorkI("ssid"," "_parr,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(rw)
	.q:'$IsObject(obj)
	.s workStDate=$zd(obj.WorkStDate,3)
	.s workEndDate=""
	.s:obj.WorkEndDate'="" workEndDate=$zd(obj.WorkEndDate,3)
	.s workUnit=obj.WorkUnit
	.s workRemark=obj.WorkRemark
	.s workPost=obj.WorkPost
	.s workType=##class(web.INMPersonComm).GetCommCode($tr(obj.WorkType,"_","|"))
	.i workType="院内兼职"  d
	..s partTimeLocData=$g(^DHCINM.HR.MgPartTimeLocD(workUnit))
	..q:partTimeLocData=""
	..s loc=$lg(partTimeLocData,2)
	..s workUnit=$lg(^CF.DHCINM.DB.MgWardLocD(loc),3)
	.s Status=$case(obj.WorkStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	.s ret="workStatus|"_Status_"^workType|"_workType_"^workStDate|"_workStDate_"^workEndDate|"_workEndDate_"^workUnit|"_workUnit_"^workPost|"_workPost_"^workRemark|"_workRemark_"^RowID|"_rw
	.do OutputSocialWorkData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSocialWorkData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindSocialWorkListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSocialWorkListExecute ]
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

ClassMethod FindSocialWorkListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSocialWorkListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:保存社会兼职
/// Date:2020-03-26
ClassMethod SaveSocialWork(parr, type)
{
	s ^TMP("SaveSocialWork")=parr
	s aa=##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	i $g(tmp("RowID"))="" s obj=##class(DHCINM.HR.MgNurSocialWork).%New()
	e  s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(tmp("RowID"))
	q:'$IsObject(obj) -1
	s obj.WorkStDate=$zdh(tmp("workStDate"),3)
	s:$g(tmp("workEndDate"))'="" obj.WorkEndDate=$zdh(tmp("workEndDate"),3)
	s obj.WorkPost=$g(tmp("workPost"))
	s obj.WorkUnit=$g(tmp("workUnit"))
	s obj.WorkType=$g(tmp("workType"))
	s obj.WorkRemark=$g(tmp("workRemark"))
	s obj.WorkStatus=$g(type)
	s obj.WorkPerDR=$g(tmp("PerDR"))
	s obj.WorkLevel=$g(tmp("workLevel"))
	s obj.WorkLevelRemark=$g(tmp("workLevelRemark"))
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:获取社会兼职单条记录
/// Date:2020-03-26
ClassMethod GetSocialWorkItem(id)
{
	s ^TMP("GetSocialWorkItem")=id
	s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(id)
	q:'$IsObject(obj)
	s workStDate=$zd(obj.WorkStDate,3)
	s workEndDate=""
	s:obj.WorkEndDate'="" workEndDate=$zd(obj.WorkEndDate,3)
	s workUnit=obj.WorkUnit
	s workRemark=obj.WorkRemark
	s workPost=obj.WorkPost
	s workType=$tr(obj.WorkType,"_","|")
	s Status=$case(obj.WorkStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	s ret="workStatus|"_Status_"^workType|"_workType_"^workStDate|"_workStDate_"^workEndDate|"_workEndDate
	_"^workUnit|"_workUnit_"^workPost|"_workPost_"^workRemark|"_workRemark_"^RowID|"_id
	_"^workLevel|"_obj.WorkLevel_"^workLevelRemark|"_obj.WorkLevelRemark
	q ret
}

/// Creator:wangcc
/// Description:审核社会兼职
/// Date:2020-03-26
ClassMethod AuditSocialWorkRec(id, type)
{
	s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(id)
	q:'$IsObject(obj)
	s obj.WorkStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.WorkStatus="A")||(obj.WorkStatus="B"))) d
		.s WorkStatus=$case(obj.WorkStatus,"A":"审核","B":"驳回")
		.s WorkTypeId=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),9)
		.s WorkType=##class(web.INMPersonComm).GetCommCode(WorkTypeId)
		.s WorkUnit=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),5)
		.s WorkPost=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),6)
		.s WorkStDate=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),3)
		.s:WorkStDate'="" WorkStDate=$zd(WorkStDate,3)
		.s WorkEndDate=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),4)
		.s:WorkEndDate'="" WorkEndDate=$zd(WorkEndDate,3)
		.s WorkPerDR=$lg($g(^DHCINM.HR.MgNurSocialWorkD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_WorkPerDR,""))
		.s ret="【护士档案/社会兼职】"_WorkStatus_" "_WorkType_" "_WorkUnit_" "_WorkPost_" "_WorkStDate_"->"_WorkEndDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurSocialWork",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询培训信息
/// Date:2020-03-26
/// Table: DHCINM.HR.MgNurTrain
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindTrainList","1")
Query FindTrainList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindTrainListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindTrainList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurTrainI("ssid"," "_parr,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurTrain).%OpenId(rw)
	.q:'$IsObject(obj)
	.s trainStDate=$zd(obj.TrainStDate,3)
	.s trainEndDate=$zd(obj.TrainEndDate,3)
	.s trainProject=obj.TrainProject
	.s trainLength=obj.TrainLength
	.s Status=$case(obj.TrainStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	.s ret="trainStatus|"_Status_"^trainStDate|"_trainStDate_"^trainEndDate|"_trainEndDate_"^trainProject|"_trainProject_"^trainLength|"_trainLength_"^trainRowID|"_rw
	.do OutputTrainData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputTrainData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindTrainListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindTrainListExecute ]
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

ClassMethod FindTrainListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindTrainListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:获取培训单条记录
/// Date:2020-03-26
ClassMethod GetTrainItem(id)
{
	s ^TMP("GetTrainItem")=id
	s obj=##class(DHCINM.HR.MgNurTrain).%OpenId(id)
	q:'$IsObject(obj)
	s trainStDate=$zd(obj.TrainStDate,3)
	s trainEndDate=$zd(obj.TrainEndDate,3)
	s trainProject=obj.TrainProject
	s trainLength=obj.TrainLength
	s Status=$case(obj.TrainStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	s ret="TrainStatus|"_Status_"^TrainStDate|"_trainStDate_"^TrainEndDate|"_trainEndDate_"^TrainProject|"_trainProject_"^TrainLength|"_trainLength_"^RowID|"_id
	q ret
}

/// Creator:wangcc
/// Description:保存培训
/// Date:2020-03-26
ClassMethod SaveTrain(parr, type)
{
	s ^TMP("SaveTrain")=parr
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	if ($g(tmp("RowID"))="") s obj=##class(DHCINM.HR.MgNurTrain).%New()
	else  s obj=##class(DHCINM.HR.MgNurTrain).%OpenId(tmp("RowID"))
	s obj.PerDR=tmp("PerDR")
	s obj.TrainStDate=$zdh(tmp("TrainStDate"),3)
	s obj.TrainEndDate=$zdh(tmp("TrainEndDate"),3)
	s obj.TrainLength=$g(tmp("TrainLength"))
	s obj.TrainProject=tmp("TrainProject")
	s obj.TrainStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:审核培训
/// Date:2020-03-26
ClassMethod AuditTrain(id, type)
{
	s ^TMP("AuditTrain")=id_"##"_type
	s obj=##class(DHCINM.HR.MgNurTrain).%OpenId(id)
	q:'$IsObject(obj)
	s obj.TrainStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.TrainStatus="A")||(obj.TrainStatus="B"))) d
		.s TrainStatus=$case(obj.TrainStatus,"A":"审核","B":"驳回") ;状态描述
		.s TrainProject=$lg($g(^DHCINM.HR.MgNurTrainD(id)),3) 
		.s TrainStDate=$lg($g(^DHCINM.HR.MgNurTrainD(id)),4) 
		.s:TrainStDate'="" TrainStDate=$zd(TrainStDate,3)
		.s TrainEndDate=$lg($g(^DHCINM.HR.MgNurTrainD(id)),5)
		.s:TrainEndDate'="" TrainEndDate=$zd(TrainEndDate,3)
		.s PerDR=$lg($g(^DHCINM.HR.MgNurTrainD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_PerDR,""))
		.s ret="【护士档案/培训信息】"_TrainStatus_" "_TrainProject_" "_TrainStDate_"->"_TrainEndDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurTrain",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询进修信息
/// Date:2020-03-29
/// Table: DHCINM.HR.MgNurStudy
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindstudyList","1")
Query FindStudyList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindStudyListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindStudyList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurStudyI("ssid"," "_parr,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurStudy).%OpenId(rw)
	.q:'$IsObject(obj)
	.s studyStDate=$zd(obj.StudyStDate,3)
	.s studyEndDate=$zd(obj.StudyEndDate,3)
	.s studyProfession=obj.StudyProfession
	.s studyHospital=obj.StudyHospital
	.s studyLength=obj.StudyLength
	.s Status=$case(obj.StudyStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	.s ret="studyStatus|"_Status_"^studyStDate|"_studyStDate_"^studyEndDate|"_studyEndDate_"^studyProfession|"_studyProfession_"^studyHospital|"_studyHospital_"^studyLength|"_studyLength_"^studyRowID|"_rw
	.do OutputStudyData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputStudyData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindStudyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindStudyListExecute ]
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

ClassMethod FindStudyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindStudyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:获取进修单条记录
/// Date:2020-03-26
ClassMethod GetStudyItem(id)
{
	s ^TMP("GetStudyItem")=id
	s obj=##class(DHCINM.HR.MgNurStudy).%OpenId(id)
	q:'$IsObject(obj)
	s studyStDate=$zd(obj.StudyStDate,3)
	s studyEndDate=$zd(obj.StudyEndDate,3)
	s studyProfession=obj.StudyProfession
	s studyHospital=obj.StudyHospital
	s studyLength=obj.StudyLength
	s Status=$case(obj.StudyStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	s ret="studyStatus|"_Status_"^studyStDate|"_studyStDate_"^studyEndDate|"_studyEndDate_"^studyProfession|"_studyProfession_"^studyHospital|"_studyHospital_"^studyLength|"_studyLength_"^RowID|"_id
	q ret
}

/// Creator:wangcc
/// Description:保存进修
/// Date:2020-03-26
ClassMethod SaveStudy(parr, type)
{
	s ^TMP("SaveStudy")=parr
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	if ($g(tmp("RowID"))="") s obj=##class(DHCINM.HR.MgNurStudy).%New()
	else  s obj=##class(DHCINM.HR.MgNurStudy).%OpenId(tmp("RowID"))
	s obj.PerDR=tmp("PerDR")
	s obj.StudyStDate=$zdh(tmp("studyStDate"),3)
	s obj.StudyEndDate=$zdh(tmp("studyEndDate"),3)
	s obj.StudyLength=$g(tmp("studyLength"))
	s obj.StudyProfession=tmp("studyProfession")
	s obj.StudyHospital=tmp("studyHospital")
	s obj.StudyStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:审核进修
/// Date:2020-03-26
ClassMethod AuditStudy(id, type)
{
	s ^TMP("AuditStudy")=id_"##"_type
	s obj=##class(DHCINM.HR.MgNurStudy).%OpenId(id)
	q:'$IsObject(obj)
	s obj.StudyStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.StudyStatus="A")||(obj.StudyStatus="B"))) d
		.s StudyStatus=$case(obj.StudyStatus,"A":"审核","B":"驳回") ;状态描述
		.s StudyProfession=$lg($g(^DHCINM.HR.MgNurStudyD(id)),3) ;专业描述
		.s StudyHospital=$lg($g(^DHCINM.HR.MgNurStudyD(id)),8) ;医院描述
		.s StudyStDate=$lg($g(^DHCINM.HR.MgNurStudyD(id)),4) 
		.s:StudyStDate'="" StudyStDate=$zd(StudyStDate,3)
		.s StudyEndDate=$lg($g(^DHCINM.HR.MgNurStudyD(id)),5)
		.s:StudyEndDate'="" StudyEndDate=$zd(StudyEndDate,3)
		.s PerDR=$lg($g(^DHCINM.HR.MgNurStudyD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_PerDR,""))
		.s ret="【护士档案/进修信息】"_StudyStatus_" "_StudyProfession_" "_StudyHospital_" "_StudyStDate_"->"_StudyEndDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurStudy",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询表扬信息
/// Date:2020-04-03
/// Table: DHCINM.HR.MgNurPraise
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindPraiseList","1")
Query FindPraiseList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindPraiseListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindPraiseList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurPraiseI("ssid"," "_parr,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(rw)
	.q:'$IsObject(obj)
	.s praiseDate=$zd(obj.PraiseDate,3)
	.s praiseFrom=$tr(obj.PraiseFrom,"_","|")
	.s praiseFromDesc=##class(web.INMPersonComm).GetCommCode(praiseFrom)
	.s Status=$case(obj.PraiseStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	.s ret="praiseStatus|"_Status_"^praiseDate|"_praiseDate_"^praiseFrom|"_praiseFrom_"^praiseFromDesc|"_praiseFromDesc_"^praiseRowID|"_rw
	.do OutputPraiseData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPraiseData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPraiseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPraiseListExecute ]
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

ClassMethod FindPraiseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPraiseListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:获取表扬单条记录
/// Date:2020-03-26
ClassMethod GetPraiseItem(id)
{
	s ^TMP("GetPraiseItem")=id
	s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
	q:'$IsObject(obj)
	s praiseDate=$zd(obj.PraiseDate,3)
	s praiseFrom=$tr(obj.PraiseFrom,"_","|")
	s praiseRecorder=obj.PraiseRecorder
	s praiseDesc=obj.PraiseDesc
	s praiseRecordDate=$zd(obj.PraiseRecordDate,3)
	s Status=$case(obj.PraiseStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	s ret="praiseStatus|"_Status_"^praiseDesc|"_praiseDesc_"^praiseRecorder|"_praiseRecorder_"^praiseRecordDate|"_praiseRecordDate_"^praiseDate|"_praiseDate_"^praiseFrom|"_praiseFrom_"^RowID|"_id
	q ret
}

/// Creator:wangcc
/// Description:保存表扬
/// Date:2020-03-26
ClassMethod SavePraise(parr, type)
{
	s ^TMP("SavePraise")=parr
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	if ($g(tmp("RowID"))="") s obj=##class(DHCINM.HR.MgNurPraise).%New()
	else  s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(tmp("RowID"))
	s obj.PerDR=tmp("PerDR")
	s obj.PraiseDate=$zdh(tmp("praiseDate"),3)
	s obj.PraiseRecordDate=$zdh(tmp("praiseRecordDate"),3)
	s obj.PraiseFrom=$g(tmp("praiseFrom"))
	s obj.PraiseDesc=tmp("praiseDesc")
	s obj.PraiseRecorder=tmp("praiseRecorder")
	s obj.PraiseStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:审核表扬
/// Date:2020-03-26
ClassMethod AuditPraise(id, type)
{
	s ^TMP("AuditPraise")=id_"##"_type
	s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
	q:'$IsObject(obj)
	s obj.PraiseStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.PraiseStatus="A")||(obj.PraiseStatus="B"))) d
		.s PraiseStatus=$case(obj.PraiseStatus,"A":"审核","B":"驳回") ;状态描述
		.s PraiseFrom=##class(web.INMPersonComm).GetCommCode(obj.PraiseFrom)
		.s PraiseDate=$lg($g(^DHCINM.HR.MgNurPraiseD(id)),4)
		.s:PraiseDate'="" PraiseDate=$zd(PraiseDate,3)
		.s PerDR=$lg($g(^DHCINM.HR.MgNurPraiseD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_PerDR,""))
		.s ret="【护士档案/表扬信息】"_PraiseStatus_" "_PraiseFrom_" "_PraiseDate
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurPraise",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询投诉批评信息
/// Date:2020-04-03
/// Table: DHCINM.HR.MgNurCritic
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindCriticList","1")
Query FindCriticList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindCriticListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s ^TMP("FindCriticList")=parr
	s repid=$I(^CacheTemp)
	s ind=1
	i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s ret=""
	s rw="" f  s rw=$O(^DHCINM.HR.MgNurCriticI("ssid"," "_parr,rw)) q:rw=""  d
	.s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(rw)
	.q:'$IsObject(obj)
	.s criticDate=$zd(obj.CriticDate,3)
	.s criticFrom=##class(web.INMPersonComm).GetCommCode(obj.CriticFrom)
	.s criticDeal=obj.CriticDeal
	.s criticRectifEffect=obj.CriticRectifEffect
	.s Status=$case(obj.CriticStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	.s ret="criticStatus|"_Status_"^criticDeal|"_criticDeal_"^criticRectifEffect|"_criticRectifEffect_"^criticDate|"_criticDate_"^criticFrom|"_criticFrom_"^criticRowID|"_rw
	.do OutputCriticData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCriticData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCriticListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCriticListExecute ]
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

ClassMethod FindCriticListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCriticListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:wangcc
/// Description:获取投诉单条记录
/// Date:2020-03-26
ClassMethod GetCriticItem(id)
{
	s ^TMP("GetCriticItem")=id
	s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
	q:'$IsObject(obj)
	s criticDate=$zd(obj.CriticDate,3)
	s criticFrom=obj.CriticFrom
	s criticRecorder1=obj.CriticRecorder1
	s criticDesc=obj.CriticDesc
	s criticRecordDate1=$zd(obj.CriticRecordDate1,3)
	s criticRecorder2=obj.CriticRecorder2
	s criticRecordDate2=$zd(obj.CriticRecordDate2,3)
	s criticDeal=obj.CriticDeal
	s criticBack=obj.CriticBack
	s criticRectifEffect=obj.CriticRectifEffect
	s criticRectifAction=obj.CriticRectifAction
	s Status=$case(obj.CriticStatus,"Y":"提交","N":"保存","A":"审核","B":"驳回")
	s ret="criticStatus|"_Status_"^criticDesc|"_criticDesc_"^criticRecorder1|"_criticRecorder1_"^criticRecordDate1|"_criticRecordDate1_"^criticDate|"_criticDate_"^criticFrom|"_criticFrom_"^RowID|"_id
	s ret=ret_"^criticBack|"_criticBack_"^criticDeal|"_criticDeal_"^criticRectifAction|"_criticRectifAction_"^criticRectifEffect|"_criticRectifEffect_"^criticRecorder2|"_criticRecorder2_"^criticRecordDate2|"_criticRecordDate2
	q ret
}

/// Creator:wangcc
/// Description:保存投诉
/// Date:2020-03-26
ClassMethod SaveCritic(parr, type)
{
	s ^TMP("SaveCritic")=parr
	s tmp=""
	d ##class(web.INMVueComm).SplitStr(parr,"^","|",.tmp)
	if ($g(tmp("RowID"))="") s obj=##class(DHCINM.HR.MgNurCritic).%New()
	else  s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(tmp("RowID"))
	s obj.PerDR=tmp("PerDR")
	s obj.CriticDate=$zdh(tmp("criticDate"),3)
	s obj.CriticRecordDate1=$zdh(tmp("criticRecordDate1"),3)
	s obj.CriticFrom=tmp("criticFrom")
	s obj.CriticDesc=tmp("criticDesc")
	s obj.CriticBack=tmp("criticBack")
	s obj.CriticDeal=tmp("criticDeal")
	s obj.CriticRectifAction=tmp("criticRectifAction")
	s obj.CriticRectifEffect=tmp("criticRectifEffect")
	; issue:2792725:这个判断干掉了，不然前端编辑已有数据的记录时间会显示1840-12-31，同时记录人是空的
	; if (tmp("criticRectifAction")="")  d
	s obj.CriticRecordDate2=$zdh(tmp("criticRecordDate2"),3)
	s obj.CriticRecorder2=tmp("criticRecorder2")
	s obj.CriticRecorder1=tmp("criticRecorder1")
	s obj.CriticStatus=type
	s sc=obj.%Save()
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:审核投诉
/// Date:2020-03-26
ClassMethod AuditCritic(id, type)
{
	s ^TMP("AuditCritic")=id_"##"_type
	s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
	q:'$IsObject(obj)
	s obj.CriticStatus=type
	s sc=obj.%Save()
	try{
		i (($$$ISOK(sc))&&((obj.CriticStatus="A")||(obj.CriticStatus="B"))) d
		.s CriticStatus=$case(obj.CriticStatus,"A":"审核","B":"驳回") ;状态描述
		.s CriticFrom=##class(web.INMPersonComm).GetCommCode(obj.CriticFrom)
		.s CriticDate=$lg($g(^DHCINM.HR.MgNurCriticD(id)),4) 
		.s:CriticDate'="" CriticDate=$zd(CriticDate,3)
		.s CriticBack=$lg($g(^DHCINM.HR.MgNurCriticD(id)),14)
		.s CriticDesc=$lg($g(^DHCINM.HR.MgNurCriticD(id)),5)
		.s PerDR=$lg($g(^DHCINM.HR.MgNurCriticD(id)),2)
		.s userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_PerDR,""))
		.s ret="【护士档案/投诉批评】"_CriticStatus_" "_CriticFrom_" "_CriticDate_" "_CriticBack_" "_CriticDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,ret,"","DHCINM.HR.MgNurCritic",id)
	}catch{
		}
	q $$$ISOK(sc)
}

/// Creator:wangcc
/// Description:查询奖惩情况信息
/// Date:2020-04-08
/// Table:DHCINM.HR.MgNurReward
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.INMPerSubComm","FindRewardList","91")
Query FindRewardList(parr As %String = "", param As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindRewardListExecute(ByRef qHandle As %Binary, parr As %String = "", param As %String) As %Status
{
	 s ^TMP("FindRewardList")=parr
    s repid=$I(^CacheTemp)
    s ind=1
    ;i parr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s ret="", gParam=""
    s nFlag=##class(web.INMVueComm).SplitStr(param,"^","|",.gParam)
    s pPerDepDR=$g(gParam("PerDepDR"))
    s pPerInfo=$g(gParam("PerInfo"))
    s pStDate=##class(web.INMHISComm).DateHtmlToLogical($g(gParam("StDate")))
    s pEndDate=##class(web.INMHISComm).DateHtmlToLogical($g(gParam("EndDate")))
    
    s perIdx="" f  s perIdx=$o(^DHCINM.HR.MgNurRewardI("perid",perIdx)) q:perIdx=""  d
    .q:((parr'="")&&(parr'=perIdx))
    .s lbPerson=$g(^CF.DHCINM.HR.PersonsD(perIdx))
    .s sPerName=$lg(lbPerson,2)
    .s sPerID=$lg(lbPerson,3)
    .s iWardId=$lg(lbPerson,10)
    .s sPerDepDesc=$lg($g(^CF.DHCINM.DB.MgWardD(iWardId)),4)
    .s suPerInfo=$zcvt(sPerName_sPerID,"U")
    .s suInput=$zcvt(pPerInfo,"U")
    .q:((pPerDepDR'="")&&(pPerDepDR'=iWardId))
    .q:((suInput'="")&&(suPerInfo'[suInput))
    .s rw="" f  s rw=$O(^DHCINM.HR.MgNurRewardI("perid",perIdx,rw)) q:rw=""  d
    ..s obj=##class(DHCINM.HR.MgNurReward).%OpenId(rw)
    ..q:'$IsObject(obj)
    ..q:(pStDate'="")&&(pStDate>obj.RewardDate)
    ..q:(pEndDate'="")&&(pEndDate<obj.RewardDate)
    ..s nurseID=obj.RewardNurse.PerID
    ..s nurseName=obj.RewardNurse.PerName
    ..s rewardWard=""
    ..s:obj.RewardWard'="" rewardWard=$lg($g(^CF.DHCINM.DB.MgWardD(obj.RewardWard)),4)
    ..s rewardContent=obj.RewardContent
    ..s rewardResult=obj.RewardResult
    ..s rewardLevel=##class(web.INMPersonComm).GetCommCode(obj.RewardLevel)
    ..s rewardDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardDate)
    ..s rewardRecorder=obj.RewardRecorder
    ..s rewardRecordDate=##class(web.INMHISComm).DateLogicalToHtml(obj.RewardRecordDate)
    ..s Status=..GetOpTypeDesc(obj.RewardStatus)
    ..s rowid=obj.%Id()
    ..s ret="^nurseID|"_nurseID_"^rewardStatus|"_Status_"^nurseName|"_nurseName_"^rewardWard|"_rewardWard_"^rewardContent|"_rewardContent_"^rewardResult|"_rewardResult
    ..s ret=ret_"^rewardLevel|"_rewardLevel_"^rewardDate|"_rewardDate_"^rowid|"_rw_"^rewardRecorder|"_rewardRecorder_"^rewardRecordDate|"_rewardRecordDate
    ..s ret=ret_"^PerName|"_sPerName_"^PerID|"_sPerID_"^PerDepDR|"_sPerDepDesc_"^rowid|"_rowid
    ..d OutputRewardData
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRewardData
    set Data=$lb(ret)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindRewardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRewardListExecute ]
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

ClassMethod FindRewardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRewardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator: ChenPeng
/// CreateDate: 2022-07-29
/// Description: 根据操作类型代码获取描述
/// Input: {code:操作类型代码}
/// Output:返回描述文本
ClassMethod GetOpTypeDesc(type As %String = "") As %String
{
    q:type="" ""
    s desc=$case(type,"N":"保存","Y":"提交","A":"审核","B":"驳回",:"")
    q desc
}

/// Creator: ChenPeng
/// CreateDate: 2021-11-25
/// Description: 根据主键Id查询资格注册数据状态
/// Table: DHCINM.HR.MgQualRegisted
/// Input: 资格注册记录Id
/// Output: 资格注册记录状态status
/// Returns: 无
/// Others: Write ##class(web.INMPerSubComm).GetRegistedStatus("2")
ClassMethod GetRegistedStatus(id As %String) As %String
{
	/// 或者直接调用 Quit ..GetCommStatus("DHCINM.HR.MgQualRegisted", "RegistedStatus", id)
	Quit:id="" ""
	Set status = ""
	Set obj = ##class(DHCINM.HR.MgQualRegisted).%OpenId(id)
	Quit:'$IsObject(obj) ""
	Set status = obj.RegistedStatus
	Quit status
}

/// Creator: 	ChenPeng
/// CreateDate: 2021-11-25
/// Description:通用方法根据主键Id查询对象的状态
/// Table: 		*
/// Input: 		className-实体类名/statusName-状态字段名/id-记录Id
/// Output: 	记录状态status
/// Returns: 	无
/// Others: 	w ##class(web.INMPerSubComm).GetCommStatus("DHCINM.HR.MgQualRegisted", "RegistedStatus", "2")
ClassMethod GetCommStatus(className As %String, statusName As %String, id As %String) As %String
{
	Quit:className="" ""
	Quit:statusName="" ""
	Quit:id="" ""
	/// 判断表是否存在
	Set exist = ##class(%Dictionary.ClassDefinition).%OpenId(className, 0)
	Quit:exist="" ""
	/// $ClassMethod $Property自2010.1开始支持
	Set obj = $ClassMethod(className, "%OpenId", id)
	Quit:'$IsObject(obj) ""
	Set status = $Property(obj, statusName)
	Quit status
}

/// 社会兼职
ClassMethod GetSWorkStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgNurSocialWork).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.WorkStatus
	q status
}

/// 教育信息
ClassMethod GetEduStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(CF.DHCINM.HR.Educate).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.EduStatus
	q status
}

/// 进修信息
ClassMethod GetStudyStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgNurStudy).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.StudyStatus
	q status
}

/// 培训信息
ClassMethod GetTrainStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgNurTrain).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.TrainStatus
	q status
}

/// 投诉批评
ClassMethod GetCriticStatus(id As %String) As %String
{
	q:id="" ""
	s status="" 
	s obj=##class(DHCINM.HR.MgNurCritic).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.CriticStatus
	q status
}

/// 表扬信息
ClassMethod GetPraiseStatus(id As %String) As %String
{
	q:id="" ""
	s status=""
	s obj=##class(DHCINM.HR.MgNurPraise).%OpenId(id)
	q:'$IsObject(obj) ""
	s status=obj.PraiseStatus
	q status
}

/// 获奖情况
ClassMethod GetRewardStstus(id As %String) As %String
{
	 q:id="" ""
	 s status=""
	 s obj=##class(DHCINM.HR.MgNurReward).%OpenId(id)
	 q:'$IsObject(obj) ""
	 s status=obj.RewardStatus
	 q status
}

/// Creator: lcy
/// CreateDate: 20200915
/// Description: 根据类名和id删除数据
/// Input: className,id
/// Output:
/// Other: d ##class(web.INMPerSubComm).DeleteWorkItem("DHCINM.HR.MgSpecialDevelop","1")
ClassMethod DeleteItem(className, rowId) As %String
{
	q:(className="")||(rowId="") 0
	s exist = ##class(%Dictionary.ClassDefinition).%OpenId(className,0)
	q:exist="" -1
	//表不存在
    s obj=""
	x ("s obj = ##class("_className_").%DeleteId("_rowId_")")
	/// 如下这样使用也是可以的--ChenPeng--20211125
	/// s obj = $ClassMethod(className, "%DeleteId", rowId)
	q $$$ISOK(obj) //返回1删除成功，0失败
}

/// Creator:liwenzhen
/// CreateDate: 2022-08-29
/// Description: 护士档案页签通用审核
/// Input: className：类名,id：行id,type：类型
/// Output:
/// Other: w ##class(web.INMPerSubComm).AuditData("CF.DHCINM.HR.HireDuty","1","A")
ClassMethod AuditData(className As %String = "", id As %String = "", type As %String = "")
{
	s ^TMP("AuditRegistedItem")=id_"##"_type
	s sc=0
	q:(className="")||(id="") sc
	q:##class(%Dictionary.ClassDefinition).%OpenId(className,0)="" sc
	x ("(obj) s obj = ##class("_className_").%OpenId("""_id_""")",.obj)
	q:'$IsObject(obj) sc
	//获取Status字段
	s statusName=""
	s propName="" f  s propName=$o(^oddCOM(className,"a",propName)) q:(propName="")||(statusName'="")  d
	.s:$zcvt(propName,"U")["STATUS" statusName=propName
	q:statusName="" sc
	s $ZOBJPROPERTY(obj,statusName)=type
	s sc=obj.%Save()
	try{
		//进展通知
		i ($$$ISOK(sc)&&((type="A")||(type="B"))) d
		.s approvalSetId=$o(^CT.DHCINM.Set.ApprovalSetI("ClassName"," "_$zcvt(className,"U"),"")) //根据类名获取审批配置id
		.s approvalSetGlo=$g(^CT.DHCINM.Set.ApprovalSetD(approvalSetId))
		.s noticeType=$lg(approvalSetGlo,15) //人员类型 U:用户/P:人员档案
		.s noticeNum=$lg(approvalSetGlo,14)
		.q:(noticeNum="")||(noticeType="")
		.x ("(global) s global = $g(^"_className_"D("_id_"))",.global)
		.s approvalName=$lg(approvalSetGlo,2)
		.s userID=$lg(global,noticeNum)
		.s:noticeType="P" userID=$O(^CF.DHCINM.DB.MgUserI("PerDR"," "_userID,""))
		.s statusDesc=$case(type,"A":"护理部审核","B":"驳回")
		.s title="【护士档案/"_approvalName_"】 " _statusDesc
		.s showSort="" f  s showSort=$O(^CT.DHCINM.Set.ApprovalSetShowI("sort",approvalSetId,showSort)) q:showSort=""  d
		..s showID="" f  s showID=$O(^CT.DHCINM.Set.ApprovalSetShowI("sort",approvalSetId,showSort,showID)) q:showID=""  d
		...s showObj=$g(^CT.DHCINM.Set.ApprovalSetShowD(approvalSetId,showID))
		...q:showObj=""
		...s globalNum=$lg(showObj,3)
		...s globalName=$lg(showObj,2)
		...s showType=$lg(showObj,6)
		...q:((globalNum="")||(showType=""))
		...s showDesc=$lg(global,globalNum)
		...s:((showType'="S")&&(showDesc'="")) showDesc=##class(web.INMPlatform).GetClsDescByType($lg(showObj,7), showDesc,showType,$lg(showObj,10))
		...s title=title_" "_showDesc
		.d ##class(web.INMPlatform).SaveTrackMessage(userID,+$H,title,"",className,id)
		//推送至人事OA
		i $$$ISOK(sc)&&(type="A") d
		.s isPostToHR=$lg($g(^CT.DHCINM.Set.MgArgParamSetD(1)),41) //判断是否推送至HR
		.q:isPostToHR'="Y"
		.d ##class(web.INMPerSubComm).SendHRDataToOA(className,id)
	}catch{
		
	}
	q $$$ISOK(sc)
}

/// Creator: liwenzhen
/// CreateDate: 2023-02-06
/// Description: 配置档案子页签与OA表字段对应
/// Input: table：护管表名
/// Output:
/// Other: d ##class(web.INMPerSubComm).SetOAField("CF.DHCINM.HR.Educate",.tmp)
ClassMethod SetOAField(className, tmp) As %String
{
	k tmp
	// 聘任职称
	i className="CF.DHCINM.HR.HireDuty" d
    .s tmp("HirePerDR")="EMP_ID" //职工ID
    .s tmp("HirePerDR","IsPerDR")=1 //是否是PerDR
    .s tmp("HireDuty_Desc")="TITLE_CODE" //职称名称
    .s tmp("HirePerDR")="HOS_SCH" //职称等级
    .s tmp("HireStDate")="GET_DATE" //取得职称时间
#; s tmp("")="BEG_DATE" //聘任职称时间
#; s tmp("")="TEC_TITLE_CODE" //聘任职称
#; s tmp("")="TITLE_LEVEL" //职称类别
#; s tmp("")="IS_MAX_TITLE" //是否当前职称
#; s tmp("")="EMP_PROFESSION_LEVEL" //专业技术级别
#; s tmp("")="EMP_PROFESSION_TIME" //专技晋级时间
#; s tmp("")="NOTE" //备注
	
	//职务信息 
	i className="CF.DHCINM.HR.PostDuty" d
	.s tmp("PostPerDR")="EMP_ID" //职工ID
	.s tmp("PostPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("PostDuty_Desc")="DUTY_NAME" //职务名称
    .s tmp("PostStDate")="START_DATE" //任命开始日期
    .s tmp("PostEndDate")="END_DATE" //任命截止日期
    .s tmp("PostRemark")="NOTE" //备注
    
    //教育信息
	i className="CF.DHCINM.HR.Educate" d
    .s tmp("EduPerDR")="EMP_ID" //职工ID
    .s tmp("EduPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("EduAcademic_Desc")="EDUCATION_CODE" //学历
    .s tmp("EduStDate")="GRADUATION_START_DATE" //入学时间
    .s tmp("EduEndDate")="GRADUATION_END_DATE" //毕业(肄业)时间
#; .s tmp("")="IS_MAX_EDUCATION" //是否当前学历
    .s tmp("EduSchool_Desc")="SCHOOL_NAME" //学校名称
#; .s tmp("")="SCHOOL_DEPT" //所在院系
#; .s tmp("")="DEGREE_DEPT" //学位授予机构
    .s tmp("EduProfession_Desc")="PROFESSION_CODE" //所学专业
    .s tmp("EduRadio_Desc")="EDUCATION_SYSTEM" //学习方式
#; .s tmp("")="EMP_SUBJECT_CATEGORG" //学科分类
#; .s tmp("")="EDUCATION_NO" //学历证书编号
    .s tmp("EduDegree_Desc")="DEGREE_CODE" //学位
#; .s tmp("")="ENGLISH_LEVEL" //英语等级
#; .s tmp("")="DEGREE_NO" //学位证书编码
    .s tmp("EduDegreeDate")="DEGREE_DATE" //学位授予时间
#; .s tmp("")="GRADUATION_SCHOOL" //学校地址
#; .s tmp("")="YEAR_SYSTEM" //学制
#; .s tmp("")="DEGREE_COUNTRY" //学位授予国家
#; .s tmp("")="STUDIES" //研究方向
#; .s tmp("")="NOTE" //备注

    //注册资格
	i className="DHCINM.HR.MgQualRegisted" d
    .s tmp("RegistedPerson")="EMP_ID" //职工ID
    .s tmp("RegistedPerson","IsPerDR")=1 //是否是PerDR 
    .s tmp("RegistedDate")="REGISTER_DATE" //注册日期
    
    //社会兼职
	i className="DHCINM.HR.MgNurSocialWork" d
    .s tmp("WorkPerDR")="EMP_ID" //职工ID
    .s tmp("WorkPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("WorkType_Desc")="ADJU_TYPE" //兼职类型
    .s tmp("WorkUnit")="ADJU_UNIT" //兼职机构
    .s tmp("WorkPost")="ADJU_DUTY" //担任职务
    .s tmp("WorkStDate")="BEG_DATE" //开始日期
    .s tmp("WorkEndDate")="END_DATE" //结束日期
    .s tmp("WorkLevel_Desc")="ADJU_LEVEL" //兼职级别
    .s tmp("WorkLevelRemark")="ADJU_ITEMS" //级别明细
    
    //专科发展
	i className="DHCINM.Special.SpecialNurse" d
    .s tmp("SpecialPerDR")="EMP_ID" //职工ID
    .s tmp("SpecialPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("SpecialType_Desc")="SPE_CER" //专科证书
    .s tmp("SpecialAuth_Desc")="CER_UNIT" //认证单位
    .s tmp("SpecialNurType_Desc")="SPE_NURSE" //专科护士
    .s tmp("SpecialAuthDate")="GET_DATE" //取得日期
    
    //进修信息
	i className="DHCINM.HR.MgNurStudy" d
    .s tmp("PerDR")="EMP_ID" //职工ID
    .s tmp("PerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("StudyStDate")="ENGAGE_DATE" //进修开始日期
    .s tmp("StudyHospital")="ENGAGE_HOS" //进修医院
    .s tmp("StudyProfession")="ENGAGE_SUBJ" //进修学科
    .s tmp("StudyLength")="ENGAGE_LENGTH" //进修时长
    .s tmp("StudyEndDate")="STOP_DATE" //进修结束日期
#; .s tmp("")="ENGAGE_LIST_COUNTRY" //进修医院排名（全国）
#; .s tmp("")="ENGAGE_LIST" //进修医院排名
#; .s tmp("")="ENGAGE_SUBL_COUNTRY" //进修专业排名（全国）
#; .s tmp("")="ENGAGE_SUBL" //进修专业排名（片区）
#; .s tmp("")="ENGAGE_EVALUATE" //进修结果
#; .s tmp("")="NOTE" //备注 

	//培训信息
	i className="DHCINM.HR.MgNurTrain" d
	.s tmp("PerDR")="EMP_ID" //职工ID
	.s tmp("PerDR","IsPerDR")=1 //是否是PerDR 
#; .s tmp("")="TRAIN_TYPE" //培训类型
#; .s tmp("")="TRAIN_LEVEL" //培训级别
#; .s tmp("")="TRAIN_CONTENT" //培训课程
    .s tmp("TrainStDate")="TRAIN_BEG_DATE" //培训起始时间
    .s tmp("TrainEndDate")="TRAIN_END_DATE" //培训结束时间
#; .s tmp("")="TRAIN_PLACE" //培训机构
#; .s tmp("")="TRAIN_HOURS" //培训成果
#; .s tmp("")="NOTE" //备注
	
	//投诉批评
	i className="DHCINM.HR.MgNurCritic" d
	.s tmp("PerDR")="EMP_ID" //职工ID
	.s tmp("PerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("CriticFrom_Desc")="SOURCE" //来源
    .s tmp("CriticDate")="HAPPEN_DATE" //发生时间
    .s tmp("CriticBack")="COMPLAINANT" //反馈人
    .s tmp("CriticDeal_Desc")="DE_RESULT" //处理结果
    .s tmp("CriticDesc")="DESCRIPTION" //事件描述
    .s tmp("CriticRecorder1")="RECORDMAN" //记录人
    .s tmp("CriticRecordDate1")="RECORD_DATE" //记录时间
    .s tmp("CriticRectifAction")="WAY" //整改措施
    .s tmp("CriticRectifEffect_Desc")="RE_ RESULT" //整改结果
	
	//表扬信息
	i className="DHCINM.HR.MgNurPraise" d
	.s tmp("PerDR")="EMP_ID" //职工ID
	.s tmp("PerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("PraiseFrom_Desc")="SOURCE" //表扬来源
    .s tmp("PraiseDate")="HAPPEN_DATE" //发生时间
    .s tmp("PraiseDesc")="DESCRIPTION" //事件描述
    .s tmp("PraiseRecorder")="RECORDMAN" //记录人
    .s tmp("PraiseRecordDate")="RECORD_DATE" //记录时间
	
	//获奖情况
	i className="DHCINM.HR.MgNurReward" d
	.s tmp("RewardNurse")="EMP_ID" //职工ID
	.s tmp("RewardNurse","IsPerDR")=1 //是否是PerDR 
#; .s tmp("")="YEAR" //年度
    .s tmp("RewardContent")="AWARD_NAME" //奖项名称
    .s tmp("RewardDate")="NOTE2" //颁发时间
    .s tmp("RewardUnit")="HOS_NAME" //颁奖单位
#; .s tmp("")="ACCESSORY" //附件
    .s tmp("RewardLevel_Desc")="NOTE1" //颁奖级别
#; .s tmp("")="NOTE" //备注 
	
	//工作经历
	i className="DHCINM.HR.MgWork" d
	.s tmp("WorkPerDR")="EMP_ID" //职工ID
	.s tmp("WorkPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("WorkUnit")="PLACE" //单位名称
#; .s tmp("")="DEPT_NAME" //部门名称
    .s tmp("WorkPost_Desc")="TITLE" //职位名称
    .s tmp("WorkStDate")="BEG_DATE" //起始日期
    .s tmp("WorkEndDate")="END_DATE" //结束日期
#; .s tmp("")="WITNESS" //证明人
#; .s tmp("")="NOTE" //备注
	
	//护理层级
	i className="CF.DHCINM.HR.MgLevel" d
	.s tmp("LevelPerDR")="EMP_ID" //职工ID
	.s tmp("LevelPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("NurLevel_Desc")="NUR_LEVEL" //层级
    .s tmp("LevelDate")="PRO_DATE" //晋升日期
    .s tmp("LevelFactor")="FACTOR" //层级系数
#; .s tmp("")="NOTE" //备注
	
	//科研基金
	i className="DHCINM.HR.MgResearch" d
	.s tmp("ReseaPerDR")="EMP_ID" //职工ID
	.s tmp("ReseaPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("ReseaTitle")="PROJ_NAME" //科研课题
    .s tmp("ReseaLevel_Desc")="PROJ_TYPE" //科研类型
    .s tmp("ReseaDate")="PROJ_DATE" //立项日期
    .s tmp("ReseaFee")="PROJ_FEE" //经费
    .s tmp("ReseaRank_Desc")="PROJ_NO" //科研排序
	
	//获奖科研
	i className="DHCINM.HR.MgAward" d
	.s tmp("AwardPerDR")="EMP_ID" //职工ID
	.s tmp("AwardPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("AwardResult")="SCI_RESEARCH" //科研结果
    .s tmp("AwardTitle")="AWARD_NAME" //获奖名称
    .s tmp("AwardPatent")="PATENT_NAME" //专利名称
    .s tmp("AwardPatType_Desc")="PATENT_TYPE" //专利类型
    .s tmp("AwardThesis")="PUBLISH" //发表论文
    .s tmp("AwardPublic_Desc")="PRESS" //出版社
    .s tmp("AwardPage")="PAGE" //版号页码
    .s tmp("AwardScore_Desc")="ACHIEVEMENT" //获奖成绩
    .s tmp("AwardDate")="GET_DATE" //获奖日期
    .s tmp("AwardRank_Desc")="RANK" //获奖排序
	
	
	//对口支援
	i className="DHCINM.HR.MgSupport" d
    .s tmp("SupportPerDR")="EMP_ID" //职工ID
    .s tmp("SupportPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("SupportYear")="YEAR" //年度
    .s tmp("SupportAgency")="ASSIS_UNIT" //帮扶机构
    .s tmp("SupportStDate")="MAKE_DATE" //开始时间
    .s tmp("SupportEndDate")="STOP_DATE" //结束时间

    //教材编辑
    i className="DHCINM.HR.MgTeach" d
    .s tmp("TeachPerDR")="EMP_ID" //职工ID
    .s tmp("TeachPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("TeachTitle")="BOOK_NAME" //教材名称
    .s tmp("TeachPublic_Desc")="PRESS" //出版社
    .s tmp("TeachPubNo")="ISBN" //刊号
    .s tmp("TeachType_Desc")="PER_TYPE" //人员类别

    //学术会议
    i className="DHCINM.HR.MgAcadMeeting" d
    .s tmp("AcadPerDR")="EMP_ID" //职工ID
    .s tmp("AcadPerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("AcadYear")="YEAR" //年度
    .s tmp("AcadTitle")="CON_NAME" //会议名称
    .s tmp("AcadDate")="HOST_DATE" //举办日期
    .s tmp("AcadUnit")="HOST_HOS" //举办单位
    .s tmp("AcadPlace")="HOST_ADDRESS" //举办地点
    .s tmp("AcadNurNum")="NUMBERS" //参会人数
    
    //推广技术
    i className="DHCINM.HR.MgPromote" d
    .s tmp("PromotePerDR")="EMP_ID" //职工ID
    .s tmp("PromotePerDR","IsPerDR")=1 //是否是PerDR 
    .s tmp("PromoteTitle")="PROJ_NAME" //项目名称
    .s tmp("PromoteStYear")="HOST_DATE" //举办年度
    .s tmp("PromoteEndYear")="END_DATE" //结束年度
    .s tmp("PromoteNum")="TIMES" //培训次数
    .s tmp("PromoteNurse")="NUMBERS" //受训人数

    //科研立项备案
    i className="DHCINM.SM.RegScience" d
    .s tmp("")="EMP_ID" //职工ID
    .s tmp("RegSciAppDate")="APPLY_DATE" //申请日期
    .s tmp("RegSciItemDate")="PROJ_DATE" //立项日期
    .s tmp("RegSciType")="PROJ_TYPE" //科研类型
    .s tmp("RegSciName")="PROJ_NAME" //项目名称
    .s tmp("RegSciLead")="HEAD" //负责人
    .s tmp("RegSciPart")="PARTICIPANT" //参与人
    .s tmp("RegSciSituation")="COMPLETION" //完成情况

    //专利备案
    i className="DHCINM.SM.Patent" d
    .s tmp("PatentPer")="EMP_ID" //职工ID
    .s tmp("PatentType")="PROJ_LEVEL" //专利类别
    .s tmp("PatentName")="PROJ_NAME" //专利名称
    .s tmp("PatentDate")="GRADUATION_END_DATE" //毕业(肄业)时间
    .s tmp("PatentMechanism")="PROJ_DEPT" //专利批准机构
#; .s tmp("")="GET_DATE" //获取时间
#; .s tmp("")="NOTE" //备注

	q 1
}

/// Creator: liwenzhen
/// CreateDate: 2023-02-06
/// Description: 获取护士档案子页签数据（按OA的字段名）
/// Input: className：护管类名,id：行id
/// Output:
/// Other: zw ##class(web.INMPerSubComm).GetHRDataToOA("CF.DHCINM.HR.Educate",1)
ClassMethod GetHRDataToOA(className, id) As %String
{
	d ..SetOAField(className,.fieldTmp)
	s hgArray=##class(web.INMLCDPComm).GetData(className,id)
	s OAArray=##class(%ArrayOfDataTypes).%New()
	s key="" f  s key=hgArray.Next(key) q:key=""  d
    .s value=hgArray.GetAt(key)
    .s OAField=$g(fieldTmp(key))
    .i $g(fieldTmp(key,"IsPerDR")) d
    ..s perID=$lg($g(^CF.DHCINM.HR.PersonsD(value)),3) //使用工号关联OA人员
    ..;s PerCardId=$lg($g(^CF.DHCINM.HR.PersonsD(value)),7) //身份证号
    ..s value=perID
    .i value["||" d
    ..s value=##class(web.INMPersonComm).GetCommCode(value)
    ..s OAField=$g(fieldTmp(key_"_Desc"))
    .q:OAField=""
    .d OAArray.SetAt(value,OAField)
    q OAArray
}

/// Creator: liwenzhen
/// CreateDate: 2023-02-06
/// Description: 推送护管护士信息给OA
/// Input: className：护管类名,id：行id
/// Output:
/// Other: d ##class(web.INMPerSubComm).SendHRDataToOA("CF.DHCINM.HR.Educate",1)
ClassMethod SendHRDataToOA(className, id) As %String
{
	s OAArray=..GetHRDataToOA(className,id)
	s param=##class(%ArrayOfDataTypes).%New()
	d param.SetAt("add","oprType")
	d param.SetAt(className,"Table")
	s dataList=##class(%ListOfDataTypes).%New()
	d dataList.Insert(OAArray)
	d param.SetAt(dataList,"Data")
	s paramJson=##class(web.INMCommon).Encode(param)
	s sysParamObj=##class(CT.DHCINM.Set.MgArgParamSet).%New(1)
	s server=sysParamObj.HRSever
	s port=sysParamObj.HRPort
	s url=sysParamObj.HRUrl
	;w "http://"_server_":"_port_url,!
	;w paramJson,!
	d ##class(web.NurSensThirdInter).ExcetePost(server,port,url,20,paramJson)
	q 1
}

}
