/// 名称: DHCMed.INFService.ICUGradeSrv
/// 描述: ICU病情等级人数
/// 编写者：liuyh
/// 编写日期: 2011-03-21
Class DHCMed.INFService.ICUGradeSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     lyh
/// CreatDate：   2011-03-21
/// Description:  查询ICU病情等级人数
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUGradeSrv","QueryICUGradeInfo","","","","","")
Query QueryICUGradeInfo(ctloc As %String, strYear As %String, strMonth As %String) As %Query(ROWSPEC = "rowid:%String,CtlocDr:%String,Year:%String,Month:%String,WeekOneA:%String,WeekTwoA:%String,WeekThreeA:%String,WeekFourA:%String,WeekOneB:%String,WeekTwoB:%String,WeekThreeB:%String,WeekFourB:%String,WeekOneC:%String,WeekTwoC:%String,WeekThreeC:%String,WeekFourC:%String,WeekOneD:%String,WeekTwoD:%String,WeekThreeD:%String,WeekFourD:%String,WeekOneE:%String,WeekTwoE:%String,WeekThreeE:%String,WeekFourE:%String,RepUser:%String,RepDate:%String,CtlocDesc:%String,YearStr:%String,MonthStr:%String")
{
}

ClassMethod QueryICUGradeInfoExecute(ByRef qHandle As %Binary, ctloc As %String, strYear As %String, strMonth As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.ICUGradeD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.ICUGrade).%OpenId(rowid)
	.s (CtlocDesc,YearStr,MonthStr)=""
	.s $li(data,1)=rowid
	.s $li(data,2)=obj.CtlocDr
	.s $li(data,3)=obj.Year
	.s $li(data,4)=obj.Month
	.q:((ctloc'="")&(ctloc'=obj.CtlocDr))
	.q:((strYear'="")&(strYear'=obj.Year))
	.q:((strMonth'="")&(strMonth'=obj.Month))
	.s $li(data,5)=obj.WeekOneA
	.s $li(data,6)=obj.WeekTwoA
	.s $li(data,7)=obj.WeekThreeA
	.s $li(data,8)=obj.WeekFourA
	.s $li(data,9)=obj.WeekOneB
	.s $li(data,10)=obj.WeekTwoB
	.s $li(data,11)=obj.WeekThreeB
	.s $li(data,12)=obj.WeekFourB
	.s $li(data,13)=obj.WeekOneC
	.s $li(data,14)=obj.WeekTwoC
	.s $li(data,15)=obj.WeekThreeC
	.s $li(data,16)=obj.WeekFourC
	.s $li(data,17)=obj.WeekOneD
	.s $li(data,18)=obj.WeekTwoD
	.s $li(data,19)=obj.WeekThreeD
	.s $li(data,20)=obj.WeekFourD
	.s $li(data,21)=obj.WeekOneE
	.s $li(data,22)=obj.WeekTwoE
	.s $li(data,23)=obj.WeekThreeE
	.s $li(data,24)=obj.WeekFourE
	.s $li(data,25)=obj.RepUser
	.s $li(data,26)=obj.RepDate
	.s:$d(^CTLOC(obj.CtlocDr)) CtlocDesc=$p($g(^CTLOC(obj.CtlocDr)),"^",2)
	.i obj.Year'="" d
	..s DicID=$o(^DHCMed.SS.DictionaryI("IdxofTypeCode"," "_obj.Year," YEAR",""))
	..q:DicID<1
	..s objDic=##class(DHCMed.SS.Dictionary).%OpenId(DicID)
	..q:'$IsObject(objDic)
	..s YearStr=objDic.Description
	..k objDic
	.i obj.Month'="" d
	..s DicID=$o(^DHCMed.SS.DictionaryI("IdxofTypeCode"," "_obj.Month," MONTH",""))
	..q:DicID<1
	..s objDic=##class(DHCMed.SS.Dictionary).%OpenId(DicID)
	..q:'$IsObject(objDic)
	..s MonthStr=objDic.Description
	..k objDic
	.s $li(data,27)=CtlocDesc
	.s $li(data,28)=YearStr
	.s $li(data,29)=MonthStr
    .s ^CacheTemp(repid,ind)=data
    .s ind=ind+1
    .do obj.%Close()
	q $$$OK
}

ClassMethod QueryICUGradeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICUGradeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryICUGradeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICUGradeInfoExecute ]
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

/// Creator：     lyh
/// CreatDate：   2011-03-25
/// Description:  根据时间、科室查询ICU等级
/// Input：      
/// d ##class(%ResultSet).RunQuery("DHCMed.INFService.ICUGradeSrv","QueryICUGradeByDate","2011","1","2013","1","")
Query QueryICUGradeByDate(strYear As %String, strMonth As %String, toYear As %String, toMonth As %String, ctloc As %String) As %Query(ROWSPEC = "ctloc:%String,grade:%String")
{
}

ClassMethod QueryICUGradeByDateExecute(ByRef qHandle As %Binary, strYear As %String, strMonth As %String, toYear As %String, toMonth As %String, ctloc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s rowid=""
	
	q:strYear="" $$$OK
	q:strMonth="" $$$OK
	q:toYear="" $$$OK
	q:toMonth="" $$$OK
	s sDate=$zdh(strYear_"-"_strMonth_"-"_28,3)
	s eDate=$zdh(toYear_"-"_toMonth_"-"_28,3)
	
	s rowid=""

	f  s rowid=$o(^DHCMed.INF.ICUGradeD(rowid)) q:rowid=""  d
	.s obj=##class(DHCMed.INF.ICUGrade).%OpenId(rowid)
	.s (CtlocDesc,YearStr,MonthStr)=""
	.q:((ctloc'="")&(ctloc'=obj.CtlocDr))
	.q:sDate>$zdh(obj.Year_"-"_obj.Month_"-"_28,3)
	.q:eDate<$zdh(obj.Year_"-"_obj.Month_"-"_28,3)
	.s ^TMP("DHCMedICU",obj.CtlocDr,rowid)=""
	
	s TotalScore=""
	s TotalNum=""
	s AvgGrade=""
	s ctlocID=""
	f  s ctlocID=$o(^TMP("DHCMedICU",ctlocID)) q:ctlocID=""  d
	.s (rowid,grade,gradeA,gradeB,gradeC,gradeD,gradeE,CtlocDesc)=""
	.f  s rowid=$o(^TMP("DHCMedICU",ctlocID,rowid)) q:rowid=""  d
	..s obj=##class(DHCMed.INF.ICUGrade).%OpenId(rowid)
	..q:'$IsObject(obj)
	..s gradeA=gradeA+(obj.WeekOneA+obj.WeekTwoA+obj.WeekThreeA+obj.WeekFourA)
	..s gradeB=gradeB+(obj.WeekOneB+obj.WeekTwoB+obj.WeekThreeB+obj.WeekFourB)
	..s gradeC=gradeC+(obj.WeekOneC+obj.WeekTwoC+obj.WeekThreeC+obj.WeekFourC)
	..s gradeD=gradeD+(obj.WeekOneD+obj.WeekTwoD+obj.WeekThreeD+obj.WeekFourD)
	..s gradeE=gradeE+(obj.WeekOneE+obj.WeekTwoE+obj.WeekThreeE+obj.WeekFourE)
	.s:(gradeA+gradeB+gradeC+gradeD+gradeE)>0 grade=(gradeA + (2*gradeB) + (3*gradeC) + (4*gradeD) + (5*gradeE))/(gradeA+gradeB+gradeC+gradeD+gradeE)
	.s TotalScore=TotalScore+(gradeA + (2*gradeB) + (3*gradeC) + (4*gradeD) + (5*gradeE))
	.s TotalNum=TotalNum+(gradeA+gradeB+gradeC+gradeD+gradeE)
	.s:$d(^CTLOC(ctlocID)) CtlocDesc=$p($g(^CTLOC(ctlocID)),"^",2)
	.s $li(data,1)=CtlocDesc
	.s $li(data,2)=$e(grade,1,4)
	.s ^CacheTemp(repid,ind)=data
	.s ind=ind+1
	
	s:TotalNum>0 AvgGrade=TotalScore/TotalNum
	s $li(data,1)="全院"
	s $li(data,2)=$e(AvgGrade,1,4)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	k ^TMP("DHCMedICU")
	q $$$OK
}

ClassMethod QueryICUGradeByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryICUGradeByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryICUGradeByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryICUGradeByDateExecute ]
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

}
