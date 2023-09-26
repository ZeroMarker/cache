/// 
/// 科研成果奖管理公共查询类
Class web.DHCMgNurResearchPrizeComm Extends %RegisteredObject
{

/// 查询科研成果数据列表
Query FindReseaAwardLst(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindReseaAwardLstExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("g20150928001001")=parr
 	s dateFlag=##class(websys.Conversions).DateFormat()
 	s stdate=$P(parr,"^",1)
 	i stdate'="" s stdate=$ZDH(stdate,3)
 	e  s stdate=""
 	s enddate=$P(parr,"^",2)
 	i enddate'="" s enddate=$ZDH(enddate,3)
 	e  s enddate=""
 	s schAwardDate=$P(parr,"^",3)
 	i schAwardDate'="" s schAwardDate=$ZDH(schAwardDate,3)
 	e  s schAwardDate=""
 	s friPerson=$ZConvert($P(parr,"^",4),"U")
 	s schAwardName=$ZConvert($P(parr,"^",5),"U")
 	s ret=""
 	s title="" f  s title=$O(^DHCMGNUR.MgNurResearchAwardI("flag",title)) q:title=""  d
 	.s date="" f  s date=$O(^DHCMGNUR.MgNurResearchAwardI("flag",title,date)) q:date=""  d
 	..q:((stdate'="")&&(date<stdate))
 	..q:((enddate'="")&&(date>enddate))
 	..s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurResearchAwardI("flag",title,date,nurseno)) q:nurseno=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurResearchAwardI("flag",title,date,nurseno,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurResearchAward).%OpenId(rw)
 	....i obj.ScienSource'="" d
 	.....s sourceObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienSource)
 	.....s ScienSource=sourceObj.Code
 	....e  s ScienSource=""
 	....s ScienName=obj.ScienName
 	....q:((schAwardName'="")&&(obj.ScienName'[schAwardName))
 	....i obj.ScienGrade'="" d
 	.....s gradeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienGrade)
 	.....s ScienGrade=gradeObj.Code
 	....e  s ScienGrade=""
 	....i obj.ScienDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s ScienDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScienDate)
 	.....e  s ScienDate=""
 	....e  s ScienDate=""
 	....q:((schAwardDate'="")&&(obj.ScienDate'=schAwardDate))
 	....s ScienBonuses=obj.ScienBonuses
 	....i obj.ScienType'="" d
 	.....s typObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienType)
 	.....s ScienType=typObj.Code
 	....e  s ScienType=""
 	....i obj.ScienFirPer'="" d
 	.....s firPerRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScienFirPer,"U"),""))
 	.....i firPerRw'="" d
 	......s firPerObj=##class(DHCMGNUR.MgPersons).%OpenId(firPerRw)
 	......s ScienFirPer=firPerObj.PersonID_"!"_firPerObj.PersonName
 	....e  s ScienFirPer=""
 	....q:((friPerson'="")&&(obj.ScienFirPer'=friPerson))
 	....i obj.ScienFirHead'="" d
 	.....s firHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienFirHead)
 	.....s ScienFirHead=firHeadObj.Code
 	....e  s ScienFirHead=""
 	....i obj.ScienFirDuty'="" d
 	.....s firDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienFirDuty)
 	.....s ScienFirDuty=firDutyObj.Code
 	....e  s ScienFirDuty=""
 	....i obj.ScienFirLev'="" d
 	.....s firLevObj=##Class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienFirLev)
 	.....s ScienFirLev=firLevObj.Code
 	....e  s ScienFirLev=""
 	....i obj.ScienFirBig'="" d
 	.....s firBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.ScienFirBig,"U"),""))
 	.....i firBigRw'="" d
 	......s firBigObj=##Class(DHCMGNUR.MgNurLargeLoc).%OpenId(firBigRw)
 	......s ScienFirBig=firBigObj.LocDes
 	.....e  s ScienFirBig=""
 	....e  s ScienFirBig=""
 	....i obj.ScienFirLoc'="" d
 	.....i $G(^CTLOC(obj.ScienFirLoc))'="" s ScienFirLoc=$P(^CTLOC(obj.ScienFirLoc),"^",2)
 	....e  s ScienFirLoc=""
 	....i obj.ScienSecPer'="" d
 	.....s secPerRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScienSecPer,"U"),""))
 	.....i secPerRw'="" d
 	......s secPerObj=##class(DHCMGNUR.MgPersons).%OpenId(secPerRw)
 	......s ScienSecPer=secPerObj.PersonID_"!"_secPerObj.PersonName
 	....e  s ScienSecPer=""
 	....i obj.ScienSecHead'="" d
 	.....s secHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienSecHead)
 	.....s ScienSecHead=secHeadObj.Code
 	....e  s ScienSecHead=""
 	....i obj.ScienSecDuty'="" d
 	.....s secDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienSecDuty)
 	.....s ScienSecDuty=secDutyObj.Code
 	....e  s ScienSecDuty=""
 	....i obj.ScienSecLev'="" d
 	.....s secLevObj=##Class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienSecLev)
 	.....s ScienSecLev=secLevObj.Code
 	....e  s ScienSecLev=""
 	....i obj.ScienSecBig'="" d
 	.....s secBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.ScienSecBig,"U"),""))
 	.....i secBigRw'="" d
 	......s secBigObj=##Class(DHCMGNUR.MgNurLargeLoc).%OpenId(secBigRw)
 	......s ScienSecBig=secBigObj.LocDes
 	.....e  s ScienSecBig=""
 	....e  s ScienSecBig=""
 	....i obj.ScienSecLoc'="" d
 	.....i $G(^CTLOC(obj.ScienSecLoc))'="" s ScienSecLoc=$P(^CTLOC(obj.ScienSecLoc),"^",2)
 	....e  s ScienSecLoc=""
 	....i obj.ScienThirdPer'="" d
 	.....s thirdPerRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScienThirdPer,"U"),""))
 	.....i thirdPerRw'="" d
 	......s thirdPerObj=##class(DHCMGNUR.MgPersons).%OpenId(thirdPerRw)
 	......s ScienThirdPer=thirdPerObj.PersonID_"!"_thirdPerObj.PersonName
 	....e  s ScienThirdPer=""
 	....i obj.ScienThirdHead'="" d
 	.....s thirdHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienThirdHead)
 	.....s ScienThirdHead=thirdHeadObj.Code
 	....e  s ScienThirdHead=""
 	....i obj.ScienThirdDuty'="" d
 	.....s thirdDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienThirdDuty)
 	.....s ScienThirdDuty=thirdDutyObj.Code
 	....e  s ScienThirdDuty=""
 	....i obj.ScienThirdLev'="" d
 	.....s thirdLevObj=##Class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScienThirdLev)
 	.....s ScienThirdLev=thirdLevObj.Code
 	....e  s ScienThirdLev=""
 	....i obj.ScienThirdBig'="" d
 	.....s thirdBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.ScienThirdBig,"U"),""))
 	.....i thirdBigRw'="" d
 	......s thirdBigObj=##Class(DHCMGNUR.MgNurLargeLoc).%OpenId(thirdBigRw)
 	......s ScienThirdBig=thirdBigObj.LocDes
 	.....e  s ScienThirdBig=""
 	....e  s ScienThirdBig=""
 	....i obj.ScienThirdLoc'="" d
 	.....i $G(^CTLOC(obj.ScienThirdLoc))'="" s ScienThirdLoc=$P(^CTLOC(obj.ScienThirdLoc),"^",2)
 	....e  s ScienThirdLoc=""
 	....i obj.ScienOtPer'="" d
 	.....s otPerRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ScienOtPer,"U"),""))
 	.....i otPerRw'="" d
 	......s otPerObj=##class(DHCMGNUR.MgPersons).%OpenId(otPerRw)
 	......s ScienOtPer=otPerObj.PersonID_"!"_otPerObj.PersonName
 	....e  s ScienOtPer=""
	....s ret="ScienSource|"_ScienSource_"^ScienName|"_ScienName_"^ScienGrade|"_ScienGrade_"^ScienDate|"_ScienDate_"^ScienBonuses|"_ScienBonuses_"^ScienType|"_ScienType_"^ScienFirPer|"_ScienFirPer_"^ScienFirHead|"_ScienFirHead_"^ScienFirDuty|"_ScienFirDuty_"^ScienFirLev|"_ScienFirLev_"^ScienFirBig|"_ScienFirBig_"^ScienFirLoc|"_ScienFirLoc_"^ScienSecPer|"_ScienSecPer_"^ScienSecHead|"_ScienSecHead_"^ScienSecDuty|"_ScienSecDuty_"^ScienSecLev|"_ScienSecLev_"^ScienSecBig|"_ScienSecBig_"^ScienSecLoc|"_ScienSecLoc_"^ScienThirdPer|"_ScienThirdPer_"^ScienThirdHead|"_ScienThirdHead_"^ScienThirdDuty|"_ScienThirdDuty_"^ScienThirdLev|"_ScienThirdLev_"^ScienThirdBig|"_ScienThirdBig_"^ScienThirdLoc|"_ScienThirdLoc_"^ScienOtPer|"_ScienOtPer_"^rw|"_rw
	....d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindReseaAwardLstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindReseaAwardLstExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindReseaAwardLstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindReseaAwardLstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 
/// 科研立项数据列表
Query SchResProManageLst(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SchResProManageLstExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("gpromanage20151008001")=parr
 	s dateFlag=##class(websys.Conversions).DateFormat()
 	//parr="2015-10-01^2015-10-31^2015-10-01^04428^测试"
 	s stdate=$P(parr,"^",1)
 	q:stdate=""
 	i stdate'="" s stdate=$ZDH(stdate,3)
 	s enddate=$P(parr,"^",2)
 	q:enddate=""
 	i enddate'="" s enddate=$ZDH(enddate,3)
 	s prodate=$P(parr,"^",3)
 	i prodate'="" s prodate=$ZDH(prodate,3)
 	s nurseId=$zcvt($P(parr,"^",4),"U")
 	s proname=$zcvt($P(parr,"^",5),"U")
 	s ret=""
 	s date="" f  s date=$O(^DHCMGNUR.MgNurResProManI("flag",date)) q:date=""  d
 	.q:((date<stdate)!(date>enddate))
 	.s title="" f  s title=$O(^DHCMGNUR.MgNurResProManI("flag",date,title)) q:title=""  d
 	..s nurseno="" f  s nurseno=$O(^DHCMGNUR.MgNurResProManI("flag",date,title,nurseno)) q:nurseno=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurResProManI("flag",date,title,nurseno,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurResearchProManage).%OpenId(rw)
 	....i obj.ProjectGrade'="" d
 	.....s gradeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ProjectGrade) 
 	.....s ProjectGrade=gradeObj.Code
 	....e  s ProjectGrade=""
 	....s ProjectName=obj.ProjectName
 	....q:((ProjectName'[proname)&&(proname'=""))
 	....i obj.ProjectType'="" d
 	.....s typeObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ProjectType) 
 	.....s ProjectType=typeObj.Code
 	....i obj.ProjectDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s ProjectDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ProjectDate)
 	.....e  s ProjectDate=""
 	....e  s ProjectDate=""
 	....i obj.FinishDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s FinishDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.FinishDate)
 	.....e  s FinishDate=""
 	....e  s FinishDate=""
 	....i obj.FirstResponser'="" d
 	.....s firResRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.FirstResponser,"U"),""))
 	.....i firResRw'="" d
 	......s firResObj=##class(DHCMGNUR.MgPersons).%OpenId(firResRw)
 	......s FirstResponser=firResObj.PersonID_"!"_firResObj.PersonName
 	....e  s FirstResponser=""
 	....q:((FirstResponser'[nurseId)&&(nurseId'=""))
 	....i obj.FirResponerHead'="" d
 	.....s firHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.FirResponerHead)
 	.....s FirResponerHead=firHeadObj.Code
 	....e  s FirResponerHead=""
 	....i obj.FirResponerDuty'="" d
 	.....s firDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.FirResponerDuty)
 	.....s FirResponerDuty=firDutyObj.Code
 	....e  s FirResponerDuty=""
 	....i obj.FirResponerLev'="" d
 	.....s firLevObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.FirResponerLev)
 	.....s FirResponerLev=firLevObj.Code
 	....e  s FirResponerLev=""
 	....i obj.FirResponerBig'="" d
 	.....;s FirResponerBig=obj.FirResponerBig
 	.....s firBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.FirResponerBig,"U"),""))
 	.....i firBigRw'="" d
 	......s firBigObj=##Class(DHCMGNUR.MgNurLargeLoc).%OpenId(firBigRw)
 	......s FirResponerBig=firBigObj.LocDes
 	....e  s FirResponerBig=""
 	....e  s FirResponerBig=""
 	....i obj.FirResponerLoc'="" d
 	.....i $G(^CTLOC(obj.FirResponerLoc))'="" d
 	......s FirResponerLoc=$P(^CTLOC(obj.FirResponerLoc),"^",2)
 	....e  s FirResponerLoc=""
 	....i obj.SecondResponser'="" d
 	.....s secResRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.SecondResponser,"U"),""))
 	.....i secResRw'="" d
 	......s secResObj=##class(DHCMGNUR.MgPersons).%OpenId(secResRw)
 	......s SecondResponser=secResObj.PersonID_"!"_secResObj.PersonName
 	....e  s SecondResponser=""
 	....i obj.SecResponerHead'="" d
 	.....s secHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.SecResponerHead)
 	.....s SecResponerHead=secHeadObj.Code
 	....e  s SecResponerHead=""
 	....i obj.SecResponerDuty'="" d
 	.....s secDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.SecResponerDuty)
 	.....s SecResponerDuty=secDutyObj.Code
 	....e  s SecResponerDuty=""
 	....i obj.SecResponerLev'="" d
 	.....s secLevObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.SecResponerLev)
 	.....s SecResponerLev=secLevObj.Code
 	....e  s SecResponerLev=""
 	....;s SecResponerBig=obj.SecResponerBig
 	....i obj.SecResponerBig'="" d
 	.....s secBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.SecResponerBig,"U"),""))
 	.....i secBigRw'="" d
 	......s secBigObj=##Class(DHCMGNUR.MgNurLargeLoc).%OpenId(secBigRw)
 	......s SecResponerBig=secBigObj.LocDes
 	....e  s SecResponerBig=""
 	....i obj.SecResponerLoc'="" d
 	.....i $G(^CTLOC(obj.SecResponerLoc))'="" d
 	......s SecResponerLoc=$P(^CTLOC(obj.SecResponerLoc),"^",2)
 	....e  s SecResponerLoc=""
 	....i obj.ThirdResponser'="" d
 	.....s thirdResRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.ThirdResponser,"U"),""))
 	.....i thirdResRw'="" d
 	......s thirResObj=##class(DHCMGNUR.MgPersons).%OpenId(thirdResRw)
 	......s ThirdResponser=thirResObj.PersonID_"!"_thirResObj.PersonName
 	....e  s ThirdResponser=""
 	....i obj.OtherResponser'="" d
 	.....s othResRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$ZConvert(obj.OtherResponser,"U"),""))
 	.....i othResRw'="" d
 	......s othResObj=##class(DHCMGNUR.MgPersons).%OpenId(othResRw)
 	......s OtherResponser=othResObj.PersonID_"!"_othResObj.PersonName
 	....e  s OtherResponser=""
 	....s ProjectSpotExpense=obj.ProjectSpotExpense
 	....i obj.ConcludeDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s ConcludeDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ConcludeDate)
 	.....e  s ConcludeDate=""
 	....e  s ConcludeDate=""
 	....s ProjectRemark=obj.ProjectRemark
 	....s ret="rw|"_rw_"^ProjectGrade|"_ProjectGrade_"^ProjectName|"_ProjectName_"^ProjectType|"_ProjectType_"^ProjectDate|"_ProjectDate_"^FinishDate|"_FinishDate_"^FirstResponser|"_FirstResponser_"^FirResponerHead|"_FirResponerHead_"^FirResponerDuty|"_FirResponerDuty_"^FirResponerLev|"_FirResponerLev_"^FirResponerBig|"_FirResponerBig_"^FirResponerLoc|"_FirResponerLoc_"^SecondResponser|"_SecondResponser_"^SecResponerHead|"_SecResponerHead_"^SecResponerDuty|"_SecResponerDuty_"^SecResponerLev|"_SecResponerLev_"^SecResponerBig|"_SecResponerBig_"^SecResponerLoc|"_SecResponerLoc_"^ThirdResponser|"_ThirdResponser_"^OtherResponser|"_OtherResponser_"^ProjectSpotExpense|"_ProjectSpotExpense_"^ConcludeDate|"_ConcludeDate_"^ProjectRemark|"_ProjectRemark
 	....d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SchResProManageLstFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchResProManageLstExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchResProManageLstClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchResProManageLstExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
