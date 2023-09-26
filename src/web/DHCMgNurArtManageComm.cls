/// 
/// 文章管理查询类
Class web.DHCMgNurArtManageComm Extends %RegisteredObject
{

// Query SearchNurArtList(parr As %String) As %Query(ROWSPEC = "ArtCategory,ArtMagazine,ArtTitle,ArtDate,ArtVolume,ArtTerm,ArtPage,ArtHeading,ArtType,ArtFirAuthor,ArtWriter,ArtSecAuthor,ArtThirdAuthor,ArtOtAuthor,ArtWriterLev,ArtWriterHead,ArtWriterDuty,ArtWriterBig,ArtWriterLoc,ArtFirAuthorLev,ArtFirAuthorHead,ArtFirAuthorDuty,ArtFirAuthorBig,ArtFirAuthorLoc,rw")

/// 
/// 
/// 查询文章列表
Query SearchNurArtList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchNurArtListExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEMP("1703021109001")=parr
 	//parr="2015-08-01^2015-09-30^^^"
	s ret="" 
	i $P(parr,"^",1)'="" s stdate=$ZDH($P(parr,"^",1),3)
	e  s stdate=""
	i $P(parr,"^",2)'="" s enddate=$ZDH($P(parr,"^",2),3)
	e  s enddate=""
	s nurseno=$ZConvert($P(parr,"^",3),"U")
	s writerno=$ZConvert($P(parr,"^",4),"U")
	i $P(parr,"^",5)'="" s artpubdate=$ZDH($P(parr,"^",5),3)
	e  s artpubdate=""
 	s date="" f  s date=$O(^DHCMGNUR.MgNurArticleManageI("flag",date)) q:date=""  d
 	.q:((stdate'="")&&(date<stdate))
 	.q:((enddate'="")&&(date>enddate))
 	.s title="" f  s title=$O(^DHCMGNUR.MgNurArticleManageI("flag",date,title)) q:title=""  d
 	..s nurse="" f  s nurse=$O(^DHCMGNUR.MgNurArticleManageI("flag",date,title,nurse)) q:nurse=""  d
 	...s rw="" f  s rw=$O(^DHCMGNUR.MgNurArticleManageI("flag",date,title,nurse,rw)) q:rw=""  d
 	....s obj=##class(DHCMGNUR.MgNurArticleManage).%OpenId(rw)
 	....i obj.ArtCategory'="" d
 	.....s catObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtCategory)
 	.....s ArtCategory=catObj.Code
 	....e  s ArtCategory=""
 	....i obj.ArtMagazine'="" d
 	.....s magObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtMagazine)
 	.....s ArtMagazine=magObj.Code
 	....e  s ArtMagazine=""
 	....s ArtTitle=obj.ArtTitle
 	....i obj.ArtDate'="" d
 	.....i ((dateFlag=3)!(dateFlag=4)) s ArtDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ArtDate)
 	.....e  s ArtDate=""
 	....e  s ArtDate=""
 	....q:((ArtDate'="")&&(##class(websys.Conversions).DateHtmlToLogical(ArtDate)'=artpubdate)&&(artpubdate'=""))
 	....s ArtVolume=obj.ArtVolume
 	....s ArtTerm=obj.ArtTerm
 	....s ArtPage=obj.ArtPage
 	....i obj.ArtHeading'="" d
 	.....s headObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtHeading)
 	.....s ArtHeading=headObj.Code
 	....e  s ArtHeading=""
 	....i obj.ArtType'="" d
 	.....s typObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtType)
 	.....s ArtType=typObj.Code
 	....e  s ArtType=""
 	....i obj.ArtFirAuthor'="" d
 	.....s perRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_obj.ArtFirAuthor,""))
 	.....i perRw'="" d
 	......s perObj=##class(DHCMGNUR.MgPersons).%OpenId(perRw)
 	......s ArtFirAuthor=perObj.PersonID_"!"_perObj.PersonName
 	....e  s ArtFirAuthor=""
 	....q:(($ZConvert($P(ArtFirAuthor,"!",1),"U")'=nurseno)&&(nurseno'=""))
 	....i obj.ArtWriter'="" d
 	.....s writeRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_obj.ArtWriter,""))
 	.....i writeRw'="" d
 	......s writeObj=##class(DHCMGNUR.MgPersons).%OpenId(writeRw)
 	......s ArtWriter=writeObj.PersonID_"!"_writeObj.PersonName
 	....e  s ArtWriter=""
 	....q:(($ZConvert($P(ArtWriter,"!",1),"U")'=writerno)&&(writerno'=""))
 	....i obj.ArtSecAuthor'="" d
 	.....s secAuRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_obj.ArtSecAuthor,""))
 	.....i secAuRw'="" d
 	......s secAuObj=##class(DHCMGNUR.MgPersons).%OpenId(secAuRw)
 	......s ArtSecAuthor=secAuObj.PersonID_"!"_secAuObj.PersonName
 	....e  s ArtSecAuthor=""
 	....i obj.ArtThirdAuthor'="" d
 	.....s thirdAuRw=$O(^DHCMGNUR.MgPersonsI("SSID"," "_obj.ArtThirdAuthor,""))
 	.....i thirdAuRw'="" d
 	......s thirdAuObj=##class(DHCMGNUR.MgPersons).%OpenId(thirdAuRw)
 	......s ArtThirdAuthor=thirdAuObj.PersonID_"!"_thirdAuObj.PersonName
 	....e  s ArtThirdAuthor=""
 	....s ArtOtAuthor=obj.ArtOtAuthor
 	....i obj.ArtWriterLev'="" d
 	.....s writeLevObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtWriterLev)
 	.....s ArtWriterLev=writeLevObj.Code
 	....e  s ArtWriterLev=""
 	....i obj.ArtWriterHead'="" d
 	.....s writeHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtWriterHead)
 	.....s ArtWriterHead=writeHeadObj.Code
 	....e  s ArtWriterHead=""
 	....i obj.ArtWriterDuty'="" d
 	.....s writeDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtWriterDuty)
 	.....s ArtWriterDuty=writeDutyObj.Code
 	....e  s ArtWriterDuty=""
 	....i obj.ArtWriterBig'="" d
 	.....s writBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.ArtWriterBig,"U"),""))
 	.....i writBigRw'="" d
 	......s writeBigObj=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(writBigRw)
 	......s ArtWriterBig=writeBigObj.LocDes
 	....e  s ArtWriterBig=""
 	....i obj.ArtWriterLoc'="" d
 	.....i $G(^CTLOC(obj.ArtWriterLoc))'="" s ArtWriterLoc=$P(^CTLOC(obj.ArtWriterLoc),"^",2)
 	....e  s ArtWriterLoc=""
 	....i obj.ArtFirAuthorLev'="" d
 	.....s firstLevObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtFirAuthorLev)
 	.....s ArtFirAuthorLev=firstLevObj.Code
 	....e  s ArtFirAuthorLev=""
 	....i obj.ArtFirAuthorHead'="" d
 	.....s firAuHeadObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtFirAuthorHead)
 	.....s ArtFirAuthorHead=firAuHeadObj.Code
 	....e  s ArtFirAuthorHead=""
 	....i obj.ArtFirAuthorDuty'="" d
 	.....s firAuDutyObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ArtFirAuthorDuty)
 	.....s ArtFirAuthorDuty=firAuDutyObj.Code
 	....e  s ArtFirAuthorDuty=""
 	....i obj.ArtFirAuthorBig'="" d
 	.....s firAuBigRw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_$ZConvert(obj.ArtFirAuthorBig,"U"),""))
 	.....i firAuBigRw'="" d
 	......s writeBigObj=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(firAuBigRw)
 	......s ArtFirAuthorBig=writeBigObj.LocDes
 	....e  s ArtFirAuthorBig=""
 	....i obj.ArtFirAuthorLoc'="" d
 	.....i $G(^CTLOC(obj.ArtFirAuthorLoc))'="" s ArtFirAuthorLoc=$P(^CTLOC(obj.ArtFirAuthorLoc),"^",2)
 	....e  s ArtFirAuthorLoc=""
	....s ret="ArtCategory|"_ArtCategory_"^ArtMagazine|"_ArtMagazine_"^ArtTitle|"_ArtTitle_"^ArtDate|"_ArtDate_"^ArtVolume|"_ArtVolume_"^ArtTerm|"_ArtTerm_"^ArtPage|"_ArtPage_"^ArtHeading|"_ArtHeading_"^ArtType|"_ArtType_"^ArtFirAuthor|"_ArtFirAuthor_"^ArtWriter|"_ArtWriter_"^ArtSecAuthor|"_ArtSecAuthor_"^ArtThirdAuthor|"_ArtThirdAuthor_"^ArtOtAuthor|"_ArtOtAuthor_"^ArtWriterLev|"_ArtWriterLev_"^ArtWriterHead|"_ArtWriterHead_"^ArtWriterDuty|"_ArtWriterDuty_"^ArtWriterBig|"_ArtWriterBig_"^ArtWriterLoc|"_ArtWriterLoc_"^ArtFirAuthorLev|"_ArtFirAuthorLev_"^ArtFirAuthorHead|"_ArtFirAuthorHead_"^ArtFirAuthorDuty|"_ArtFirAuthorDuty_"^ArtFirAuthorBig|"_ArtFirAuthorBig_"^ArtFirAuthorLoc|"_ArtFirAuthorLoc_"^rw|"_rw
 	....d OutRowtyp
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	//set Data=$lb(ArtCategory,ArtMagazine,ArtTitle,ArtDate,ArtVolume,ArtTerm,ArtPage,ArtHeading,ArtType,ArtFirAuthor,ArtWriter,ArtSecAuthor,ArtThirdAuthor,ArtOtAuthor,ArtWriterLev,ArtWriterHead,ArtWriterDuty,ArtWriterBig,ArtWriterLoc,ArtFirAuthorLev,ArtFirAuthorHead,ArtFirAuthorDuty,ArtFirAuthorBig,ArtFirAuthorLoc,rw)
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchNurArtListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchNurArtListExecute ]
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

ClassMethod SearchNurArtListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchNurArtListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
