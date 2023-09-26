Class web.DHCFOrdConfirm Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetAdmExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", PatNo As %String = "", AdmType As %String = "") As %Status
{
	;s ^fhqtemp=StartDate_"^"_EndDate_"^"_PatNo_"^"_AdmType
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 s RetNum=##class(web.DHCFBPat).GetPatAdm(repid,StartDate,EndDate,PatNo,AdmType)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s StrLen=$l(Data,del)
 .s Data=$tr(Data,del,"*")
 .s Data=$lb($p(Data,"*",2,StrLen),$p(Data,"*"))
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod GetAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmExecute ]
{
	S Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetArcimByAliaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetArcimByAliaExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetArcimByAliaExecute(ByRef qHandle As %Binary, OrdItm As %String = "", ArcimCatSub As %String = "", StopFlag As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCFOrdConfirm","GetArcimByAlia","ghf","","")
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
	s Para=OrdItm_del_ArcimCatSub_del_StopFlag
 s RetNum=##class(web.DHCFArcimGet).GetArcimByAlia(repid,Para)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s Data=$lb($p(Data,del,2),$p(Data,del,1))
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod GetArcimByAliaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetArcimByAliaExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetOrdByRecAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByRecAdmExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetOrdByRecAdmExecute(ByRef qHandle As %Binary, AdmNoh As %String = "", RecLocId As %String = "", OrdItmh As %String = "", StDate As %Date = "", PatNo As %String = "") As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCFOrdConfirm","GetOrdByRecAdm","","","","2007-08-08","1500")
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 ;s RecLocId=%session.Data("LOGON.CTLOCID")
 ;s RecLocId=2
 ;s StDate=$zdh(StDate,3)
 if AdmNoh'="" d   ;按就诊记录来查找
 .s Para=AdmNoh_del_RecLocId
 .s RetNum=##class(web.DHCFOrdGet).GetOrdByRecLoc(repid,Para)
 else  if OrdItmh'="" d ; 按医嘱项ID查找
 .s Para=OrdItmh_del_StDate_del_RecLocId
 .s:OrdItmh'="" RetNum=##class(web.DHCFOrdGet).GetOrdByArcimId(repid,Para)
 if ((AdmNoh="")&(OrdItmh="")) d  ;按病人登记号来查找
 .s Para=PatNo_del_StDate_del_RecLocId
 .s:PatNo'="" RetNum=##class(web.DHCFOrdGet).GetOrdByPatNo(repid,Para)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s Data=##class(web.DHCFBCM).StrToList(Data,del)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod GetOrdByRecAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByRecAdmExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod GetPatAdm(Para As %String) As %String
{
	s del="^"
	s StartDate=$p(Para,del,1)
	s EndDate=$p(Para,del,2)
	s PatNo=$p(Para,del,3)
	s AdmType=$p(Para,del,4)
	s RetStr=""
	Set repid=$I(^CacheTemp1)
 If $g(ind)="" Set ind=1
 s del="^"
 s RetNum=##class(web.DHCFBPat).GetPatAdm(repid,StartDate,EndDate,PatNo,AdmType)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s Data=$tr(Data,"&","-")
 .s $e(Data,$find(Data,"-")-1,$find(Data,"-")-1)="&"
 .if RetStr="" s RetStr=Data
 .if RetStr'="" s RetStr=RetStr_"^"_Data
	k ^CacheTempFHQ(repid)
	;s RetStr="1"_"&"_"2"_"^"_"1"_"&"_"2"_"^"
	q RetStr
}

ClassMethod RunGetPatAdmQurey()
{
	d ##class(%ResultSet).RunQuery("web.DHCFOrdConfirm","GetOrdByRecAdm","165","2")
}

Query GetAdm(StartDate As %String = "", EndDate As %String = "", PatNo As %String = "", AdmType As %String = "") As %Query(ROWSPEC = "AdmInfo,AdmId:%String")
{
}

Query GetArcimByAlia(OrdItm As %String = "", ArcimCatSub As %String = "", StopFlag As %String = "") As %Query(ROWSPEC = "ArcimName:%String:医嘱名称,ArcimId:%String:医嘱项ID")
{
}

Query GetOrdByRecAdm(AdmNoh As %String, RecLocId As %String, OrdItmh As %String = "", StDate As %Date = "", PatNo As %String = "") As %Query(ROWSPEC = "OrdId,aa,PatName,PatNo,OrdData,OrdDesc,OrdStatus,OrdQty,OrdUnit,AdmLoc,Doctor,OrdLoc,Bed:%String")
{
}

}
