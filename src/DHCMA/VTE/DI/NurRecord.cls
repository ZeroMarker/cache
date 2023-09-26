Class DHCMA.VTE.DI.NurRecord Extends %RegisteredObject
{

/// Creator：     mazhaoyan
/// CreatDate：   2019-09-27
/// Description:  通过就诊号获取护理记录单
/// Input：       aEpisodeID:就诊号 
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.NurRecord","QueryNurRecord","37992014","2018-01-01","2020-01-01")
Query QueryNurRecord(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "EpisodeID:%String,NurRecId:%String,CaseMeasure:%String,CareDate:%String,CareTime:%String,RecUser:%String") [ SqlProc ]
{
}

ClassMethod QueryNurRecordExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Quit:(aEpisodeID="") $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	//通过索引获取 护理病历主键
 	s nurRecId=""
 	s nurRecId=$O(^Nur.DHCNurseRecParentI("Episode"," "_aEpisodeID,nurRecId))
 	Quit:nurRecId="" $$$OK
 	//循环获取 护理病历数据
	Set nurRecSubId=""
	For {
		Set nurRecSubId=$o(^Nur.DHCNurseRecSubI("OeoreId"," ",nurRecId,nurRecSubId))
		Quit:nurRecSubId=""
		Set nurRecSubData = $g(^Nur.DHCNurseRecSubD(nurRecId,nurRecSubId))
		Set date = $lg(nurRecSubData,3) ;护理记录填写日期
		Continue:date=""
		Continue:((aDateFrom'="")&&(date<aDateFrom))
		Continue:((aDateTo'="")&&(date>aDateTo))
		Set time = $lg(nurRecSubData,4) ;护理记录填写时间
		Set CaseMeasure = $lg(nurRecSubData,5) ;护理记录内容
		Set Recuser = $lg(nurRecSubData,59) ;护理记录填写人代码
		Continue:CaseMeasure=""
		set Data=$lb(aEpisodeID,nurRecId_"||"_nurRecSubId,CaseMeasure,date,time,Recuser)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryNurRecordFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNurRecordExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryNurRecordClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNurRecordExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
