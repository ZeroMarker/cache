Class web.DHCFArcimGet Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetArcimByAlia(repid As %Integer, Para As %String) As %String
{
	s del="^",RetNum=0
	s ArcAlia=$p(Para,del,1),ArcCat=$p(Para,del,2),StopFlag=$p(Para,del,3)
	;StopFlag=0说明不包括停止的医嘱
 S ArcAlia=$$ALPHAUP^SSUTIL4(ArcAlia),aliaval=ArcAlia
 s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" "),-1)
 f  s ArcAlia=$o(^ARC("ALIAS",0,"Desc",ArcAlia_" ")) q:(ArcAlia="")!(ArcAlia'[aliaval)  d
 .S desc=""
 .f  s desc=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc)) q:desc=""  d
 ..s aliaid=$o(^ARC("ALIAS",0,"Desc",ArcAlia,desc,""))
 ..if ArcCat'=""  d  ;判断是否传入医嘱项大类
 ...s SubCat=$p(^ARC("ALIAS",aliaid),del,4)
 ...s:SubCat'="" Cat=$p(^ARC("IC",aliaid),del,8)
 ..q:((ArcCat'="")&(ArcCat'=$g(Cat)))  ;医嘱大类与传入大类不一样退出
 ..s ArcId=$p($g(^ARC("ALIAS",aliaid)),del,1)
 ..Q:($g(ArcId)="")
 ..s ArcimId1=$p(ArcId,"||",1),ArcimId2=$p(ArcId,"||",2)
 ..q:'$d(^ARCIM(ArcimId1,ArcimId2))
 ..if StopFlag=0  d  ;判断是否包括已经停止的医嘱
 ...s EndDate=$p(^ARCIM(ArcimId1,ArcimId2,7),del,1)
 ...s:$g(EndDate)'="" EndDate=$zd(EndDate,3)
 ..q:(($g(StopFlag)=0)&($g(EndDate)<$zd($h,3)))
 ..s ArcInfo=##class(web.DHCFBArcimGet).GetArcimById(ArcId)
 ..q:ArcInfo=""
	 ..s ArcCode=$p(ArcInfo,del,2)
	 ..s ArcDesc=$p(ArcInfo,del,3)
	 ..s SubCat=$p(ArcInfo,del,4)
	 ..s drug=$p(ArcInfo,del,5)
	 ..s startdate=$p(ArcInfo,del,6)
	 ..s EndDate=$p(ArcInfo,del,7)
	 ..s Priority=$p(ArcInfo,del,8)
 ..s drug=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
 ..i $g(drug)'="" d
 ...s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
 ..s RetNum=RetNum+1
 ..s ^CacheTempFHQ(repid,RetNum)=ArcId_del_ArcDesc_del_ArcCode_del_SubCat_del_drug_del_startdate_del_EndDate_del_Priority
 ..
 Q RetNum
}

Query GetArcimByAlias(ArcimAlia As %String) As %Query(ROWSPEC = "ArcimDesc,ArcimId:%String")
{
}

ClassMethod GetArcimByAliasExecute(ByRef qHandle As %Binary, ArcimAlia As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 Q:ArcimAlia="" $$$OK
 s del="^"
 s RetNum=##class(web.DHCFArcimGet).GetArcimByAlia(repid,ArcimAlia)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .
 .s Data=^CacheTempFHQ(repid,i)
 .s ArcimId=$p(Data,del,1)
 .S ArcimCode=$p(Data,del,3)
 .S ArcimDesc=$p(Data,del,2)
 .s Data=$lb(ArcimDesc,ArcimId)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
 quit $$$OK
}

ClassMethod GetArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcimByAliaExecute ]
{
	if $g(qHandle)'="" 	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
	else  Quit $$$OK
}

ClassMethod GetArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcimByAliaExecute ]
{
	
	 q:$g(qHandle)="" $$$OK
	 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
	 Quit $$$OK
}

}
