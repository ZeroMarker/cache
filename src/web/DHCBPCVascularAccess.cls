Import SQLUser

Class web.DHCBPCVascularAccess Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","FindVasAccess")
Query FindVasAccess() As %Query(ROWSPEC = "tBPCVARowId:%String,tBPCVACode:%String,tBPCVADesc:%String,tBPCVADeptDr:%String,tBPCVADept:%String")
{
}

ClassMethod FindVasAccessExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCVARowId=0
	f  s tBPCVARowId=$o(^DHCBPC("VascularAccess",tBPCVARowId)) q:tBPCVARowId=""  d
	    .s tBPCVACode=$lg(^DHCBPC("VascularAccess",tBPCVARowId),1)
	    .q:tBPCVACode=""
	    .s tBPCVADesc=$lg(^DHCBPC("VascularAccess",tBPCVARowId),2)
	    .s tBPCVADeptDr=$lg(^DHCBPC("VascularAccess",tBPCVARowId),3)
	    .i tBPCVADeptDr'="" s tBPCVADept=$p($g(^CTLOC(tBPCVADeptDr)),"^",2)
	    .e  s tBPCVADept=""
	    .q:tBPCVADesc=""
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCVARowId,tBPCVACode,tBPCVADesc,tBPCVADeptDr,tBPCVADept)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindVasAccessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVasAccessExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindVasAccessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVasAccessExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCVascularAccess).InsertVasAccess("2","模式2")
ClassMethod InsertVasAccess(bpsVACode, bpcVADesc, ctloc) As %String
{
	q:bpsVACode="" "代码不能为空!"
	q:bpcVADesc="" "描述不能为空!"
	s objVasAccess = ##class(User.DHCBPCVascularAccess).%New()
	s objVasAccess.BPCVACode=bpsVACode
	s objVasAccess.BPCVADesc=bpcVADesc
	s objVasAccess.BPCVALocationDr=ctloc
	s saveStatus=objVasAccess.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s bpcVAId=objVasAccess.%Id()
	d objVasAccess.%Close()
	q 0
}

/// d ##class(web.DHCBPCVascularAccess).UpdateVasAccess(1,"1","模式")
ClassMethod UpdateVasAccess(bpcVAId, bpsVACode, bpcVADesc, ctloc) As %String
{
	q:bpcVAId="" "ID不能为空!"
	q:bpsVACode="" "代码不能为空!"
	q:bpcVADesc="" "描述不能为空!"
	q:'##class(User.DHCBPCVascularAccess).%ExistsId(bpcVAId) "日志码表指针无对应记录!"
	s objVasAccess = ##class(User.DHCBPCVascularAccess).%OpenId(bpcVAId)
	s objVasAccess.BPCVACode=bpsVACode
	s objVasAccess.BPCVADesc=bpcVADesc
	s objVasAccess.BPCVALocationDr=ctloc
	s updateStatus=objVasAccess.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s bpcVAId=objVasAccess.%Id()
	d objVasAccess.%Close()
	q 0
}

/// d ##class(web.DHCBPCVascularAccess).DeleteVasAccess(1)
ClassMethod DeleteVasAccess(bpcVAId) As %String
{
	q:bpcVAId="" "ID不能为空!"
	q:'##class(User.DHCBPCVascularAccess).%ExistsId(bpcVAId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBPCVascularAccess).%DeleteId(bpcVAId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/*Query GetVascularAccessList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCVA_Code As Code,
	   BPCVA_Desc As Description
	   FROM DHC_BPC_VascularAccess
}*/
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","GetVascularAccessListOld")
Query GetVascularAccessListOld(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,LocationDr:%String")
{
}

ClassMethod GetVascularAccessListOldExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tBPCVARowId=0
	f  s tBPCVARowId=$o(^DHCBPC("VascularAccess",tBPCVARowId)) q:tBPCVARowId=""  d
	    .s Code=$lg(^DHCBPC("VascularAccess",tBPCVARowId),1)
	    .q:Code=""
	    .s Description=$lg(^DHCBPC("VascularAccess",tBPCVARowId),2)
	    .q:Description=""
	    .s LocationDr=$lg(^DHCBPC("VascularAccess",tBPCVARowId),3)
	    .q:(LocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_LocationDr_"^"))	   
	    .s Id=tBPCVARowId
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,LocationDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetVascularAccessListOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetVascularAccessListOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVascularAccessListOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// mfc 20180629
/// 库8.2以后，血透版本3.1.0以后，使用；之前的版本使用Old
/// 获取血管通路集合，先从配置数据切入
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","GetVascularAccessList")
Query GetVascularAccessList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String")
{
}

ClassMethod GetVascularAccessListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tlocId=0
	f  s tlocId=$o(^DHCBP.Config.BPVALocationI("Ctloc",tlocId)) q:tlocId=""  d
		.q:(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocId_"^"))
		.s valRowId=0
		.f  s valRowId=$o(^DHCBP.Config.BPVALocationI("Ctloc",tlocId,valRowId)) q:valRowId=""  d
			..s BPCVARowId=$lg(^DHCBP.Config.BPVALocationD(valRowId),1)
			..s VALAliasDesc=$lg(^DHCBP.Config.BPVALocationD(valRowId),3)	
			..s Code=$lg(^DHCBPC("VascularAccess",BPCVARowId),1)
	    	..s Description=$lg(^DHCBPC("VascularAccess",BPCVARowId),2)
	    	..;i VALAliasDesc'="" s Description=VALAliasDesc 	    
	    	..;e  s Description=$lg(^DHCBPC("VascularAccess",BPCVARowId),2)
	    	..s Id=BPCVARowId
	    	..d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetVascularAccessListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVascularAccessListExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetVascularAccessListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVascularAccessListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 获取最新血管通路
ClassMethod GetVascularAccessDesc(bpprId As %String, needNote As %String = "") As %String
{
	
	q:bpprId=""
	s cavDr="",retStr=""		
	f  s cavDr=$o(^DHCBPVascularAccess(0,"Register",bpprId,cavDr)) q:cavDr=""  d
	.s bpcvaRowId=$lg(^DHCBPVascularAccess(cavDr),2)
	.q:bpcvaRowId=""
	.q:$lg(^DHCBPVascularAccess(cavDr),11)="D"
	.s bpcvaDesc=$lg(^DHCBPC("VascularAccess",bpcvaRowId),2)
	.q:(bpcvaDesc'="")&&(needNote'="")&&(("^"_needNote_"^")'[("^"_bpcvaDesc_"^"))
	.s retStr=bpcvaDesc
	q retStr
}

/// 获取血管通路部位
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","FindCLCBodySite")
Query FindCLCBodySite(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,LocationDr:%String")
{
}

ClassMethod FindCLCBodySiteExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联	
	s tRowId=0
	f  s tRowId=$o(^DHCCLC("BodySite",tRowId)) q:tRowId=""  d		
		.s tCode=$lg(^DHCCLC("BodySite",tRowId),1)
		.s tDesc=$lg(^DHCCLC("BodySite",tRowId),2)
		.s tlocDr=$lg(^DHCCLC("BodySite",tRowId),3)
		.q:(tlocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocDr_"^"))
		.d OutputRow2
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutputRow2
	s Data=$lb(tRowId,tCode,tDesc,tlocDr)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCLCBodySiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCLCBodySiteExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	//
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
	s AtEnd=1
	s Row=""
	}
	else      {				// fetch row
	s Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCLCBodySiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCLCBodySiteExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","FindVasAccessLoc")
Query FindVasAccessLoc(hospId As %String = "") As %Query(ROWSPEC = "tValRowId:%String,tBPVALCVARowId:%String,tBPVALCVADesc:%String,tBPVALCVALocId:%String,tBPVALCVALocDesc:%String,tBPVALCVAAliasDesc:%String")
{
}

ClassMethod FindVasAccessLocExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s valRowId=0
	f  s valRowId=$o(^DHCBP.Config.BPVALocationD(valRowId)) q:valRowId=""  d
		.s hospitalId=""
		.s DataAttributionDr=$lg(^DHCBP.Config.BPVALocationD(valRowId),4)
		.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		.q:((hospitalId'="")&(hospId'=hospitalId))
		.s tBPVALCVARowId=$lg(^DHCBP.Config.BPVALocationD(valRowId),1)
		.i tBPVALCVARowId'="" s tBPVALCVADesc=$lg(^DHCBPC("VascularAccess",tBPVALCVARowId),2)
		.e  s tBPVALCVADesc=""
		.s tBPVALCVALocId=$lg(^DHCBP.Config.BPVALocationD(valRowId),2)
		.i tBPVALCVALocId'="" s tBPVALCVALocDesc=$p($g(^CTLOC(tBPVALCVALocId)),"^",2)
	    .e  s tBPVALCVALocDesc=""
		.s tBPVALCVAAliasDesc=$lg(^DHCBP.Config.BPVALocationD(valRowId),3)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(valRowId,tBPVALCVARowId,tBPVALCVADesc,tBPVALCVALocId,tBPVALCVALocDesc,tBPVALCVAAliasDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindVasAccessLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindVasAccessLocExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindVasAccessLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindVasAccessLocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCVascularAccess).InsertVasAccessLoc("1","15")
ClassMethod InsertVasAccessLoc(bpcVADr, ctloc, bpcVAAliasDesc = "", hospId As %String = "") As %String
{
	q:bpcVADr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	s objVasAccessLoc= ##class(User.DHCBP.Config.BPVascularAccessLocation).%New()
	s objVasAccessLoc.BPVALBPCVADr=##class(User.DHCBPCVascularAccess).%OpenId(bpcVADr)
	s objVasAccessLoc.BPVALCtlocDr=ctloc
	s objVasAccessLoc.BPVALVAAliasDesc =bpcVAAliasDesc
	s saveStatus=objVasAccessLoc.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s DataRowId=objVasAccessLoc.%Id()
	d objVasAccessLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPVascularAccessLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPVascularAccessLocation",DataRowId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCVascularAccess).UpdateVasAccessLoc(1,"1","模式")
ClassMethod UpdateVasAccessLoc(bpVALId, BPVALBPCVADr, ctloc, bpcVAAliasDesc = "", hospId As %String = "") As %String
{
	q:bpVALId="" "ID不能为空!"
	q:BPVALBPCVADr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	q:'##class(User.DHCBP.Config.BPVascularAccessLocation).%ExistsId(bpVALId) "日志码表指针无对应记录!"
	s objVasAccessLoc = ##class(User.DHCBP.Config.BPVascularAccessLocation).%OpenId(bpVALId)
	s objVasAccessLoc.BPVALBPCVADr=##class(User.DHCBPCVascularAccess).%OpenId(BPVALBPCVADr)
	s objVasAccessLoc.BPVALCtlocDr=ctloc
	s objVasAccessLoc.BPVALVAAliasDesc=bpcVAAliasDesc
	s updateStatus=objVasAccessLoc.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s DataRowId=objVasAccessLoc.%Id()
	d objVasAccessLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPVascularAccessLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPVascularAccessLocation",DataRowId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCVascularAccess).DeleteVasAccessLoc(1)
ClassMethod DeleteVasAccessLoc(bpVALId) As %String
{
	q:bpVALId="" "ID不能为空!"
	q:'##class(User.DHCBP.Config.BPVascularAccessLocation).%ExistsId(bpVALId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBP.Config.BPVascularAccessLocation).%DeleteId(bpVALId)
	q:(+deleteStatus=0) "数据删除失败!"
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPVascularAccessLocation")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBP.Config.BPVascularAccessLocation",bpVALId)
    }
	q 0
}

}
