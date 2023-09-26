Import SQLUser

/// 刘阳
/// 查询，添加，更新，删除功能
/// DHCBPCBloodPurificationMode
Class web.DHCBPCBloodPurificationMode Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(web.DHCBPCBloodPurificationMode).AddDHCBPCBloodPurificationMode("1","我")  ///增加数据语句	
ClassMethod Add(BPCBPMCode, BPCBPMDesc, BPCBPMIsSpecial, ctloc) As %String
{
	q:BPCBPMCode="" "代码不能为空!"
	;q:TSCDesc="" "描述不能为空!"
	s objDHCBPCBloodPurificationMode = ##class(User.DHCBPCBloodPurificationMode).%New()
	s objDHCBPCBloodPurificationMode.BPCBPMCode=BPCBPMCode
	s objDHCBPCBloodPurificationMode.BPCBPMDesc=BPCBPMDesc
	i BPCBPMIsSpecial'="" s objDHCBPCBloodPurificationMode.BPCBPMIsSpecial=BPCBPMIsSpecial
	e  d  s objDHCBPCBloodPurificationMode.BPCBPMIsSpecial="N"
	s objDHCBPCBloodPurificationMode.BPCBPMLocationDr=ctloc
	s saveStatus=objDHCBPCBloodPurificationMode.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s BPCBPMRowId=objDHCBPCBloodPurificationMode.%Id()
	d objDHCBPCBloodPurificationMode.%Close()
	q 0
}

/// 更新功能维护
/// d ##class(web.DHCBPCBloodPurificationMode).UpdateDHCBPCBloodPurificationMode(2,"2","我")
ClassMethod Update(BPCBPMRowId, BPCBPMCode, BPCBPMDesc, BPCBPMIsSpecial, ctloc) As %String
{
	q:BPCBPMRowId="" "RowId不能为空!"
	q:BPCBPMCode="" "代码不能为空!"
	;q:TSCDesc="" "描述不能为空!"
	S ^Tempwq("0824")=BPCBPMRowId_"^"_BPCBPMCode_"^"_BPCBPMDesc_"^"_ctloc
	s objDHCBPCBloodPurificationMode = ##class(User.DHCBPCBloodPurificationMode).%OpenId(BPCBPMRowId)
	s objDHCBPCBloodPurificationMode.BPCBPMCode=BPCBPMCode
	s objDHCBPCBloodPurificationMode.BPCBPMDesc=BPCBPMDesc
	i BPCBPMIsSpecial'="" s objDHCBPCBloodPurificationMode.BPCBPMIsSpecial=BPCBPMIsSpecial
	e  d  s objDHCBPCBloodPurificationMode.BPCBPMIsSpecial="N"
	s objDHCBPCBloodPurificationMode.BPCBPMLocationDr=ctloc
	s updateStatus=objDHCBPCBloodPurificationMode.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	///BPCBPMBPMId ???????????
	s BPCBPMBPMId=objDHCBPCBloodPurificationMode.%Id()
	d objDHCBPCBloodPurificationMode.%Close()
	q 0
}

/// 删除功能维护
/// d ##class(web.DHCBPCBloodPurificationMode).DeleteDHCBPCBloodPurificationMode()
ClassMethod Delete(BPCBPMRowId) As %String
{
	q:BPCBPMRowId="" "RowId不能为空!"
	s deleteStatus=##class(User.DHCBPCBloodPurificationMode).%DeleteId(BPCBPMRowId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// 查询功能维护
/// d ##class(%ResultSet).RunQuery("web.DHCBPCBloodPurificationMode","FindDHCBPCBPMode")
Query FindDHCBPCBPMode(ctlocId As %String = "") As %Query(ROWSPEC = "tBPCBPMRowId:%String,tBPCBPMCode:%String,tBPCBPMDesc:%String,tBPCBPMIsSpecial:%String,tBPCBPMIsSpecialDesc:%String,tBPCBPMDeptDr:%String,tBPCBPMDept:%String")
{
}

ClassMethod FindDHCBPCBPModeExecute(ByRef qHandle As %Binary, ctlocId As %String = "") As %Status
{
 	//new repid,index,rowid
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	////^DHCBPC("BloodPurificationMode")
 	
 	s tBPCBPMRowId=0,tBPCBPMDeptDr=""
 	f  s tBPCBPMRowId=$O(^DHCBPC("BloodPurificationMode",tBPCBPMRowId)) q:tBPCBPMRowId=""  d
 	.
	.d SetBPCBPMInfo
	
	Quit $$$OK
OutputRowFindDHCBPCBloodPurificationMode
	set Data=$lb(tBPCBPMRowId,tBPCBPMCode,tBPCBPMDesc,tBPCBPMIsSpecial,tBPCBPMIsSpecialDesc,tBPCBPMDeptDr,tBPCBPMDept)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
SetBPCBPMInfo
  	s RowId=tBPCBPMRowId
 	s tBPCBPMCode=$lg(^DHCBPC("BloodPurificationMode",RowId),1)
 	s tBPCBPMDesc=$lg(^DHCBPC("BloodPurificationMode",RowId),2)
 	s tBPCBPMIsSpecial=$lg(^DHCBPC("BloodPurificationMode",RowId),3)
 	i tBPCBPMIsSpecial="Y" s tBPCBPMIsSpecialDesc="是"
 	e  d  s tBPCBPMIsSpecialDesc="否"
 	s tBPCBPMDeptDr=$lg(^DHCBPC("BloodPurificationMode",RowId),4)
 	q:(ctlocId'="")&&(tBPCBPMDeptDr'=ctlocId)
 	i tBPCBPMDeptDr'="" s tBPCBPMDept=$p($g(^CTLOC(tBPCBPMDeptDr)),"^",2)
 	e  s tBPCBPMDept=""
 	d OutputRowFindDHCBPCBloodPurificationMode
 	
 	quit
}

ClassMethod FindDHCBPCBPModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCBPCBPModeExecute ]
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

ClassMethod FindDHCBPCBPModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDHCBPCBPModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*
Query GetBloodPurificationModeList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCBPM_Code As Code,
	   BPCBPM_Desc As Description,
	   BPCBPM_IsSpecial As IsSpecial
	   FROM DHC_BPC_BloodPurificationMode
}*/
/// d ##class(%ResultSet).RunQuery("web.DHCBPCBloodPurificationMode","FindBloodPurifModeOld")
Query FindBloodPurifModeOld(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IsSpecial:%String,LocationDr:%String")
{
}

ClassMethod FindBloodPurifModeOldExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s BPCBPMRowId=0
	f  s BPCBPMRowId=$o(^DHCBPC("BloodPurificationMode",BPCBPMRowId)) q:BPCBPMRowId=""  d
	    .s Code=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),1)	    
	    .s Description=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),2)
	    .s IsSpecial=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),3)	
	    .s LocationDr=$lg(^DHCBPC("BloodPurificationMode",BPCBPMRowId),4)
	    .q:(LocationDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_LocationDr_"^"))
	    .s Id=BPCBPMRowId
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,IsSpecial,LocationDr)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBloodPurifModeOldFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodPurifModeOldExecute ]
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

ClassMethod FindBloodPurifModeOldClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodPurifModeOldExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// mfc 20180629
/// 库8.2以后，血透版本3.1.0以后，使用；之前的版本使用Old
/// 获取透析方式集合，先从配置数据切入，IsSpecial是N常规透析，Y特殊透析
/// d ##class(%ResultSet).RunQuery("web.DHCBPCBloodPurificationMode","FindBloodPurificationMode")
Query FindBloodPurifMode(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IsSpecial:%String")
{
}

ClassMethod FindBloodPurifModeExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联 	
	s tlocId=0
	f  s tlocId=$o(^DHCBP.Config.BPModeLocationI("Ctloc",tlocId)) q:tlocId=""  d
		.q:(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocId_"^"))
		.s mlRowId=0
		.f  s mlRowId=$o(^DHCBP.Config.BPModeLocationI("Ctloc",tlocId,mlRowId)) q:mlRowId=""  d
			..s BPCModeRowId=$lg(^DHCBP.Config.BPModeLocationD(mlRowId),1)
			..s MLAliasDesc=$lg(^DHCBP.Config.BPModeLocationD(mlRowId),3)				
	    	..s Code=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),1)	    	
	    	..;i MLAliasDesc'="" s Description=MLAliasDesc	    
	    	..;e  s Description=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),2)
	    	..s Description=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),2)
	    	..s IsSpecial=$lg(^DHCBPC("BloodPurificationMode",BPCModeRowId),3)	
	    	..s Id=BPCModeRowId
	    	..d OutputRow1
	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,IsSpecial)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBloodPurifModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBloodPurifModeExecute ]
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

ClassMethod FindBloodPurifModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBloodPurifModeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBloodPurificationMode","FindBPModeLoc")
Query FindBPModeLoc(hospId As %String = "") As %Query(ROWSPEC = "tModeRowId:%String,tBPMLRowId:%String,tBPMLDesc:%String,tBPMLLocId:%String,tBPMLLocDesc:%String,tBPMLAliasDesc:%String")
{
}

ClassMethod FindBPModeLocExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s modeRowId=0
	f  s modeRowId=$o(^DHCBP.Config.BPModeLocationD(modeRowId)) q:modeRowId=""  d
		.s hospitalId=""
		.s DataAttributionDr=$lg(^DHCBP.Config.BPModeLocationD(modeRowId),4)
		.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		.q:((hospitalId'="")&(hospId'=hospitalId))
		.s tBPMLRowId=$lg(^DHCBP.Config.BPModeLocationD(modeRowId),1)
		.i tBPMLRowId'="" s tBPMLDesc=$lg(^DHCBPC("BloodPurificationMode",tBPMLRowId),2)
		.e  s tBPMLDesc=""
		.s tBPMLLocId=$lg(^DHCBP.Config.BPModeLocationD(modeRowId),2)
		.i tBPMLLocId'="" s tBPMLLocDesc=$p($g(^CTLOC(tBPMLLocId)),"^",2)
	    .e  s tBPMLLocDesc=""
		.s tBPMLAliasDesc=$lg(^DHCBP.Config.BPModeLocationD(modeRowId),3)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(modeRowId,tBPMLRowId,tBPMLDesc,tBPMLLocId,tBPMLLocDesc,tBPMLAliasDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPModeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPModeLocExecute ]
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

ClassMethod FindBPModeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPModeLocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCBloodPurificationMode).InsertBPModeLoc("1","15")
ClassMethod InsertBPModeLoc(bpcModeDr, ctloc, bpcModeAliasDesc = "", hospId As %String = "") As %String
{
	q:bpcModeDr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	s objModeLoc= ##class(User.DHCBP.Config.BPModeLocation).%New()
	s objModeLoc.BPMLBPCModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(bpcModeDr)
	s objModeLoc.BPMLCtlocDr=ctloc
	s objModeLoc.BPMLModeAliasDesc =bpcModeAliasDesc
	s saveStatus=objModeLoc.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s DataRowId=objModeLoc.%Id()
	d objModeLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPModeLocation",DataRowId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCBloodPurificationMode).UpdateBPModeLoc(1,"1","模式")
ClassMethod UpdateBPModeLoc(bpMLId, bpcModeDr, ctloc, bpcModeAliasDesc = "", hospId As %String = "") As %String
{
	q:bpMLId="" "ID不能为空!"
	q:bpcModeDr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	q:'##class(User.DHCBP.Config.BPModeLocation).%ExistsId(bpMLId) "日志码表指针无对应记录!"
	s objModeLoc = ##class(User.DHCBP.Config.BPModeLocation).%OpenId(bpMLId)
	s objModeLoc.BPMLBPCModeDr=##class(User.DHCBPCBloodPurificationMode).%OpenId(bpcModeDr)
	s objModeLoc.BPMLCtlocDr=ctloc
	s objModeLoc.BPMLModeAliasDesc=bpcModeAliasDesc
	s updateStatus=objModeLoc.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s DataRowId=objModeLoc.%Id()
	d objModeLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPModeLocation",DataRowId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCBloodPurificationMode).DeleteBPModeLoc(1)
ClassMethod DeleteBPModeLoc(bpMLId) As %String
{
	q:bpMLId="" "ID不能为空!"
	q:'##class(User.DHCBP.Config.BPModeLocation).%ExistsId(bpMLId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBP.Config.BPModeLocation).%DeleteId(bpMLId)
	q:(+deleteStatus=0) "数据删除失败!"
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBP.Config.BPModeLocation",bpMLId)
    }
	q 0
}

}
