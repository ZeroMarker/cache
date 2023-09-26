/// Creator:ll
/// Date:2020-11-24
/// Description:对外接口类
Class web.INMOutInterface Extends %RegisteredObject
{

/// Creator: LCY
/// CreateDate: 2020-11-24
/// Description: 根据工号获取身份证号(pda用)
/// Table: CF.DHCINM.HR.Persons
/// Input:nurseNo:护士工号
/// Output:身份证号码^姓名
/// Other:
ClassMethod GetNurseCardId(nurseNo As %String) As %String
{
	q:nurseNo="" ""
	s ret=""
	s RowID="" f  s RowID=$o(^CF.DHCINM.HR.PersonsI("PerID"," "_$zcvt($tr(nurseNo," ",""),"U"),RowID)) q:RowID=""  d
	.s obj=##class(CF.DHCINM.HR.Persons).%OpenId(RowID)
	.q:'$IsObject(obj)
	.q:obj.PerTypeDR'="N" //只取正式护士的身份证号码
	.s ret=obj.PerCardId_"^"_obj.PerName
	q ret
}

/// Creator: lulin
/// CreateDate: 2021-03-29
/// Description: 护理白板周计划接口
/// Table: DHCINM.HB.MgPlanKey
/// Input:ctlocId:病区id，日期：格式yyyy-MM-dd
/// Output:
/// Other:w ##class(web.INMOutInterface).GetNurheadWeekPlan(837,"2021-03-01")
ClassMethod GetNurheadWeekPlan(ctlocId As %String = "", date As %String = "") As %String
{
	s:date'["-" date=""
	q:((ctlocId="")||(date="")) ""
	s wardId=$O(^CF.DHCINM.DB.MgWardI("CTLoc",ctlocId,""))
	q:wardId="" ""
	s date=$zdh(date,3)
	s week=$zd(date,10)
	s:week=0 week=7
	s keyDate=date-week+1
	s rtn=##class(%ArrayOfDataTypes).%New()
	s ret=""
	s id=$O(^DHCINM.HB.MgPlanKeyI("WardDate"," W",wardId,keyDate,""))
	q:id="" ""
	s ret=$lg($g(^DHCINM.HB.MgPlanKeyD(id)),5)
	d rtn.SetAt(ret,"data")
	q ##class(Nur.JSON).Encode(rtn)
}

/// Creator:gzj
/// Description：查询患者满意度调查列表
/// Date:2021-09-02
/// Table:DHCINM.Survey.MgSurveyRelease
/// Input: ward:CTLoc表ID 
/// Output:Title:调查标题,StDate:调查开始日期,EndDate:调查截止日期,RowID:调查记录ID
/// Other:d ##class(%ResultSet).RunQuery("web.INMOutInterface","FindPatSurveyList","237",630)
Query FindPatSurveyList(ward As %String, EpisodeID As %String = "") As %Query(ROWSPEC = "aa:%String")
{
}

ClassMethod FindPatSurveyListExecute(ByRef qHandle As %Binary, ward As %String, EpisodeID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	i ((ward="")||(EpisodeID="")){
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK
	} 
	s WardID=$o(^CF.DHCINM.DB.MgWardI("CTLoc",ward,"")) //取得护理管理病区ID
	i WardID="" {
		Set qHandle=$lb(0,repid,0) 
		Quit $$$OK	
	}
	s ReleaseDR="" f  s ReleaseDR=$o(^DHCINM.Survey.MgSurveyReleaseI("type"," P"," Y",ReleaseDR)) q:ReleaseDR=""  d
	.s obj=##class(DHCINM.Survey.MgSurveyRelease).%OpenId(ReleaseDR)
	.q:'$IsObject(obj)
	.q:(((obj.EndDate'="")&&(+$h>obj.EndDate))!(+$h<obj.StDate)) //小于开始日期或者大于截止日期过滤掉
	.s Title=obj.SurveyTitle //调查标题
	.s StDate="",EndDate=""
	.i obj.StDate'="" s StDate=$zd(obj.StDate,3) //调查开始日期
	.i obj.EndDate'="" s EndDate=$zd(obj.EndDate,3) //调查截止日期
	.s flag=0
	.f i=1:1:obj.SurveyWard.Count() d
	..s item=obj.SurveyWard.GetAt(i)
	..q:item=""
	..i item=WardID s flag=1
	.q:flag=0
	.s WardObj=##class(CF.DHCINM.DB.MgWard).%OpenId(WardID)
	.q:'$IsObject(WardObj)
	.s WardDesc=WardObj.WardDesc
	.s SurveyDR=obj.SurveyContent
	.s RowId=$O(^DHCINM.Survey.MgFormI("per"," "_ReleaseDR," "_EpisodeID,""))
	.s Explain=""
	.i SurveyDR'="" d
	..s Explain=$lg($g(^CF.DHCINM.DB.SurveyFormD(SurveyDR)),8)
	.s TotalScore="",BedNumber="",Status="A",StatusDesc=""
	.i RowId'=""  d
	..s surveyObjLB=$g(^DHCINM.Survey.MgFormD(RowId))
	..i surveyObjLB'="" d
	...s TotalScore=$lg(surveyObjLB,11)
	...s Explain=$lg(surveyObjLB,17)
	...s Status=$lg(surveyObjLB,12)
	...s BedNumber=$lg(surveyObjLB,14)
	.s StatusDesc=$case(Status,"Y":"已提交","N":"已保存","A":"未填写",:"未填写")
	.s ret="Title|"_Title_"^StDate|"_StDate_"^EndDate|"_EndDate_"^WardDesc|"_WardDesc_"^WardID|"_WardID
	.s ret=ret_"^ReleaseDR|"_ReleaseDR_"^SurveyDR|"_SurveyDR_"^BedNumber|"_BedNumber_"^TotalScore|"_TotalScore
	.s ret=ret_"^RowId|"_RowId_"^Status|"_Status_"^StatusDesc|"_StatusDesc_"^Explain|"_Explain
	.d OutSurveyList
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSurveyList
 	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPatSurveyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPatSurveyListExecute ]
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

ClassMethod FindPatSurveyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPatSurveyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
