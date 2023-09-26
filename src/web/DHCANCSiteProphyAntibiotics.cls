Import SQLUser

Class web.DHCANCSiteProphyAntibiotics Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: Query 获取表DHCANCSiteProphyAntibiotics中的记录数据(并且转换成名称)
/// Table:       arc_itmmast,oec_bodysite
/// Input:       
/// Return:      身体部位名称、医嘱(SubID||VerID)、医嘱名称、是否激活
Query FindANCSPA(OecBodySiteDesc As %String = "") As %Query(ROWSPEC = "SPABodySite,SPAArcimID,SPAArcim,SPAActive,SPARowID,ANCSPABodySiteID,ANCSPAActiveDesc")
{
}

ClassMethod FindANCSPAExecute(ByRef qHandle As %Binary, OecBodySiteDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s ANCSPARowId=0
	f  s ANCSPARowId=$o(^DHCANC("SPA",ANCSPARowId)) q:ANCSPARowId=""  d 
	   .s ANCSPABodySiteID=$li(^DHCANC("SPA",ANCSPARowId),1)
	   .s ANCSPABodySite=..GetOecBSDDesc(ANCSPABodySiteID)    //获取身体部位名称
	   .q:(OecBodySiteDesc'="")&(ANCSPABodySite'[OecBodySiteDesc)
	   .s ANCSPAArcimID=$li(^DHCANC("SPA",ANCSPARowId),2)
	   .i (ANCSPAArcimID'="") d
	   		..s ANCSPAArcim=..GetSPAArcim(ANCSPAArcimID)           //获取医嘱名称
	   .s ANCSPAActive=$li(^DHCANC("SPA",ANCSPARowId),3)
	   .s ANCSPAActiveDesc=""
	   .i ANCSPAActive="Y" s ANCSPAActiveDesc="是"
	   .i ANCSPAActive="N" s ANCSPAActiveDesc="否"
	   .s RowID=ANCSPARowId	   	   
	   .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK    
OutputRow1
	s Data=$lb(ANCSPABodySite,ANCSPAArcimID,ANCSPAArcim,ANCSPAActive,RowID,ANCSPABodySiteID,ANCSPAActiveDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindANCSPAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCSPAExecute ]
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

ClassMethod FindANCSPAClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCSPAExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: Query 通过放大镜获取医嘱
/// Table:       arc_itmmast
/// Input:       ArcimDesc 医嘱代码简称
/// Return:      医嘱名称、医嘱(SubID||VerID)
Query GetMasterItem(needItemCatId As %String, ArcimDesc As %String) As %Query(ROWSPEC = "arcimDesc:%String,arcimId:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, needItemCatId As %String = "", needArcimDesc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i (needItemCatId="")&&(needArcimDesc="") Set qHandle=$lb(0,repid,0) Quit $$$OK
    i (needArcimDesc'="") s needArcimDesc=$$ALPHAUP^SSUTIL4(needArcimDesc)
 	s arcimSub=0 
 	f  s arcimSub=$o(^ARCIM(arcimSub)) q:arcimSub=""  d
	.s arcimVer=0 f  s arcimVer=$o(^ARCIM(arcimSub,arcimVer)) q:arcimVer=""  d
	..s arcimId=arcimSub_"||"_arcimVer
	..s aliasId="",aliasDesc=""
	..f  s aliasId=$O(^ARC("ALIAS",0,"ARCIM",arcimId,aliasId)) q:aliasId=""  d
	    ...i aliasDesc'="" s aliasDesc=aliasDesc_"^"
	    ...s aliasDesc=aliasDesc_$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..q:aliasDesc=""
	..//s aliasDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",aliasId),"^",6))
	..s arcimDesc=$p(^ARCIM(arcimSub,arcimVer,1),"^",2)
	..q:(needArcimDesc'="")&(("^"_aliasDesc_"^")'[("^"_needArcimDesc))&(arcimDesc'[needArcimDesc)
	..s itemcatDR=$p(^ARCIM(arcimSub,arcimVer,1),"^",10)
	..i (+needItemCatId=0)!(+needItemCatId=itemcatDR) d OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(arcimDesc,arcimId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: Query 通过放大镜获取身体部位
/// Table:       oec_bodysite
/// Input:       
/// Return:      身体部位名称、身体部位ID
Query FindBodySite() As %Query(ROWSPEC = "BodySiteDesc:%String,BodySiteRowId:%String")
{
}

ClassMethod FindBodySiteExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s BodySiteRowId=0
	f  s BodySiteRowId=$o(^OEC("BODS",BodySiteRowId))  q:BodySiteRowId=""  d
    .s BodySiteDesc=$p(^OEC("BODS",BodySiteRowId),"^",2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(BodySiteDesc,BodySiteRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBodySiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBodySiteExecute ]
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

ClassMethod FindBodySiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBodySiteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 执行添加按钮的事件
/// Table:       arc_itmmast
/// Input:       1、OecBodySite 身体部位ID
///              2、needArcim   医嘱(SubID、VerID)
///              3、ISDisplay   是否激活
/// Return:      0：执行成功
/// w ##class(web.DHCANCSiteProphyAntibiotics).AddSiteProphy(27,"868||1","Y")
ClassMethod AddSiteProphy(OecBodySite As %String, needArcim As %String, isActive As %String) As %String
{
 
 	s retcode=0
	s ANCOArcimDr=$p(needArcim,"^",1)
	
	s objClclog = ##class(User.DHCANCSiteProphyAntibiotics).%New()
	s objClclog.ANCSPABodySiteDr =OecBodySite
	s objClclog.ANCSPAArcimDr= needArcim
	s objClclog.ANCSPAActive=isActive
	s saveStatus=objClclog.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s cllogId=objClclog.%Id()
	d objClclog.%Close()

 q retcode
}

ClassMethod DeleteSiteProphy(siteProId As %String) As %String
{
    s retcode=0
    q:siteProId="" "RowId不能为空!"
	q:'##class(User.DHCANCSiteProphyAntibiotics).%ExistsId(siteProId) "手术部位码表指针无对应记录!"
	s deleteStatus=##class(User.DHCANCSiteProphyAntibiotics).%DeleteId(siteProId)
	q:(+deleteStatus=0) "数据删除失败!"
 	q retcode
}

ClassMethod UpdateSiteProphy(clclogId, ANCSPABodySite, ANCSPAArcim, ANCSPAActive As %String) As %String
{
	s retcode=0
	s ANCOArcimDr=$p(ANCSPAArcim,"^",1)
	q:'##class(User.DHCANCSiteProphyAntibiotics).%ExistsId(clclogId) "日志码表指针无对应记录!"
	s objClclog = ##class(User.DHCANCSiteProphyAntibiotics).%OpenId(clclogId)
	s objClclog.ANCSPABodySiteDr=ANCSPABodySite
	s objClclog.ANCSPAArcimDr=ANCSPAArcim
	s objClclog.ANCSPAActive=ANCSPAActive
	
	s updateStatus=objClclog.%Save()
	q:(+updateStatus=0) "数据修改失败!"
    s cllogId=objClclog.%Id()
	d objClclog.%Close()
	q retcode
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 获取医嘱名称
/// Table:       arc_itmmast
/// Input:       医嘱(SubID、VerID)
/// Return:      医嘱名称
ClassMethod GetComOrdInfo(SubID, VerID As %String) As %String
{
	
	s ANCOArcimDrName="",ComTypeID="",ComTypeIDStr=""	
	s ANCOArcimDrName=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
	q ANCOArcimDrName
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 根据身体部位名称获取身体部位ID
/// Table:       oec_bodysite
/// Input:       OecBSD 身体部位名称
/// Return:      身体部位ID
ClassMethod GetOecBSD(itmjs As %Library.String = "", itm As %Library.String = "", OecBSD As %String) As %String
{
	s BodySiteDesc=""
	//s BodySiteDesc=$p($g(^OEC("BODS",OecBSD)),"^",2)
	s BodySiteRowId=0
	s OecBSDID=""
	f  s BodySiteRowId=$o(^OEC("BODS",BodySiteRowId))  q:BodySiteRowId=""  d 
	.s BodySiteDesc=$P($g(^OEC("BODS",BodySiteRowId)),"^",2)
	.i (BodySiteDesc=OecBSD) d
		..s OecBSDID=BodySiteRowId //$P($g(^OEC("BODS",BodySiteRowId)),"^",1)	    
	q OecBSDID
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 根据身体部位ID获取身体部位名称
/// Table:       DHC_ANC_SiteProphyAntibiotics,oec_bodysite
/// Input:       OecBSDID 身体部位ID
/// Return:      身体部位名称
ClassMethod GetOecBSDDesc(OecBSDID As %String) As %String
{
	
	s BodySiteRowId=0
	s OecBSD=""
	f  s BodySiteRowId=$o(^OEC("BODS",BodySiteRowId))  q:BodySiteRowId=""  d
	.i (BodySiteRowId=OecBSDID) d
		..s OecBSD= $P($g(^OEC("BODS",BodySiteRowId)),"^",2)	    
	q OecBSD
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 根据身体部位ID循环获取医嘱(SubID||VerID);条件是激活为"Y"
/// Table:       DHC_ANC_SiteProphyAntibiotics
/// Input:       SPABodySiteID 身体部位ID
/// Return:      医嘱码表ID串(SubID||VerID)
ClassMethod GetArcimByBodySite(SPABodySiteID As %String) As %String
{
    s ArcimId=""
    s ANCSPARowId=0
	f  s ANCSPARowId=$o(^DHCANC("SPA",ANCSPARowId)) q:ANCSPARowId=""  d  
	   .s ANCSPABodySiteID=$li(^DHCANC("SPA",ANCSPARowId),1)
	   .i (ANCSPABodySiteID=SPABodySiteID)   d   
		   ..s ANCSPAArcimID=$li(^DHCANC("SPA",ANCSPARowId),2)
		   ..s ANCSPAISActive=$li(^DHCANC("SPA",ANCSPARowId),3)	 
		   ..i (ANCSPAISActive="Y") d 
		   ...f i=1:1:$l(ANCSPAArcimID,"~") d
			   ....i ArcimId'="" s ArcimId=ArcimId_"^"
			   ....s ArcimId = ArcimId_$p(ANCSPAArcimID,"~",i)	  
	 q ArcimId
}

/// Creatot:     MFC
/// CreateDate:  2012-5-28
/// Description: 根据医嘱(SubID||VerID)循环获取医嘱名称
/// Table:       arc_itmmast
/// Input:       ANCSPAArcimID 医嘱(SubID||VerID)
/// Return:      "医嘱名称"
ClassMethod GetSPAArcim(ANCSPAArcimID As %String) As %String
{
	s ComItm=""
	s SubStr=""	
	f j=1:1:$l(ANCSPAArcimID,"~")   d
	    .s SubIDStr=$p($p(ANCSPAArcimID,"~",j),"||",1)
		.s VerIDStr=$p($p(ANCSPAArcimID,"~",j),"||",2)
		.s SubID=SubIDStr
		.s VerID=VerIDStr	
		.s ComItm=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
		.i SubStr="" s SubStr=ComItm
		.e  s SubStr=SubStr_";"_ComItm
    q SubStr
}

/// w ##class(web.DHCANCSiteProphyAntibiotics).GetSPAArcimInfo("902||1~703||1~555||1")
ClassMethod GetSPAArcimInfo(ANCSPAArcimIDStr As %String) As %String
{
	s ComItm=""
	s SubStr=""	
	f j=1:1:$l(ANCSPAArcimIDStr,"~")   d
	    .s SubID=$p($p(ANCSPAArcimIDStr,"~",j),"||",1)
		.s VerID=$p($p(ANCSPAArcimIDStr,"~",j),"||",2)
		.s ComItm=$p($g(^ARCIM(SubID,VerID,1)),"^",2)
		.i SubStr="" s SubStr=SubID_"||"_VerID_"!"_ComItm
		.e  s SubStr=SubStr_","_SubID_"||"_VerID_"!"_ComItm
    q SubStr
}

}
