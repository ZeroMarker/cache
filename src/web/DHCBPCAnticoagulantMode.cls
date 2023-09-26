Import SQLUser

Class web.DHCBPCAnticoagulantMode Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCAnticoagulantMode","FindAntMode")
Query FindAntMode() As %Query(ROWSPEC = "tBPCAMRowId:%String,tBPCAMCode:%String,tBPCAMDesc:%String,ifSelectDrug:%String,ifSelectDrugDesc:%String,ifActive:%String,ifActiveDesc:%String,tBPCAMSubType:%String,tBPCAMSubTypeDesc:%String")
{
}

ClassMethod FindAntModeExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCAMRowId=0
	f  s tBPCAMRowId=$o(^DHCBPC("AnticoagulantMode",tBPCAMRowId)) q:tBPCAMRowId=""  d
	    .s tBPCAMCode=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),1)
	    .q:tBPCAMCode=""
	    .s tBPCAMDesc=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),2)
	    .q:tBPCAMDesc=""
	    .s ifSelectDrugDesc="否",ifActiveDesc="否"
	    .s ifSelectDrug=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),3)
	    .i ifSelectDrug="Y" s ifSelectDrugDesc="是"
	    .s ifActive= $lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),4)
	    .i ifActive="Y" s ifActiveDesc="是"
	    .s tBPCAMSubType=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),5)
	    .i tBPCAMSubType="H" s tBPCAMSubTypeDesc="血透"
	    .i tBPCAMSubType="P" s tBPCAMSubTypeDesc="腹透"
	    .i tBPCAMSubType="" s tBPCAMSubTypeDesc=""
	    .;s tBPCAMIfStoreAmount=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),3)
	    .;s tBPCAMIfStoreFirstAmount=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),4)
	    .;s tBPCAMIfStoreDose=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),5)
	    .;s tBPCAMIfStoreFrequency=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),6)
	    .;s tBPCAMIfStoreNote=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),7)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCAMRowId,tBPCAMCode,tBPCAMDesc,ifSelectDrug,ifSelectDrugDesc,ifActive,ifActiveDesc,tBPCAMSubType,tBPCAMSubTypeDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAntModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAntModeExecute ]
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

ClassMethod FindAntModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAntModeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCBPCAnticoagulantMode).InsertAntMode("cc","描述3",400,0.5,7,10)
ClassMethod InsertAntMode(bpcAMCode As %String, bpcAMDesc As %String, ifSelectDrug As %String, ifActive As %String, bpcAMSubType As %String = "")
{
	q:bpcAMCode="" "代码不能为空"
	q:bpcAMDesc="" "描述不能为空"
	TSTART
    s PLIST(2)=bpcAMCode
	s PLIST(3)=bpcAMDesc
	s PLIST(4)=ifSelectDrug
	s PLIST(5)=ifActive
	s PLIST(6)=bpcAMSubType
	&SQL(insert into DHC_BPC_AnticoagulantMode values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCBPCAnticoagulantMode).UpdateAntMode(3,"cc","描述3",400,0.5,7,20)
ClassMethod UpdateAntMode(bpcAMId As %String, bpcAMCode As %String, bpcAMDesc As %String, ifSelectDrug As %String, ifActive As %String, bpcAMSubType As %String = "")
{
	q:bpcAMId="" "ID不能为空"
	q:bpcAMCode="" "代码不能为空"
	q:bpcAMDesc="" "描述不能为空"
	
	K PLIST
	TSTART	
    s PLIST(1)=bpcAMId
	s PLIST(2)=bpcAMCode
	s PLIST(3)=bpcAMDesc
	s PLIST(4)=ifSelectDrug
	s PLIST(5)=ifActive
	s PLIST(6)=bpcAMSubType
	&SQL(update DHC_BPC_AnticoagulantMode values:PLIST() where BPCAM_RowId=:bpcAMId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
    TCOMMIT
	q SQLCODE
}

/// d ##class(web.DHCBPCAnticoagulantMode).DeleteAntMode(1)
ClassMethod DeleteAntMode(bpcAMId) As %String
{
	q:bpcAMId="" "ID不能为空!"
	i bpcAMId'=""  d
	.&SQL(delete from DHC_BPC_AnticoagulantMode where %ID=:bpcAMId)
	q SQLCODE
}

/*Query GetAnticoagulantModeList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCAM_Code As Code,
	   BPCAM_Desc As Description,
	   BPCAM_IfSelectDrug As IfSelectDrug
	   FROM DHC_BPC_AnticoagulantMode where BPCAM_IfActive='Y'
}*/

/*
/// d ##class(%ResultSet).RunQuery("web.DHCBPCAnticoagulantMode","GetAnticoagulantModeList")
Query GetAnticoagulantModeList(TypeCode As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IfSelectDrug:%String")
{
}

ClassMethod GetAnticoagulantModeListExecute(ByRef qHandle As %Binary, TypeCode As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCAMRowId=0
	f  s tBPCAMRowId=$o(^DHCBPC("AnticoagulantMode",tBPCAMRowId)) q:tBPCAMRowId=""  d
		.s Id=tBPCAMRowId
	    .s Code=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),1)
	    .s Description=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),2)
	    .s IfSelectDrug=$lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),3)
	    .s IfActive= $lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),4)
	    .q:IfActive'="Y"
	    .s SubType= $lg(^DHCBPC("AnticoagulantMode",tBPCAMRowId),5)
	    .q:(SubType'="")&&(TypeCode'="")&&(SubType'=TypeCode)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,IfSelectDrug)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAnticoagulantModeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnticoagulantModeListExecute ]
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

ClassMethod GetAnticoagulantModeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnticoagulantModeListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCBPCVascularAccess","GetAnticoagulantModeList")
Query GetAnticoagulantModeList(TypeCode As %String = "", locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,IfSelectDrug:%String")
{
}

ClassMethod GetAnticoagulantModeListExecute(ByRef qHandle As %Binary, TypeCode As %String = "", locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tlocId=0
	f  s tlocId=$o(^DHCBP.Config.BPAMLocationI("Ctloc",tlocId)) q:tlocId=""  d
		.q:(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tlocId_"^"))
		.s amlRowId=0
		.f  s amlRowId=$o(^DHCBP.Config.BPAMLocationI("Ctloc",tlocId,amlRowId)) q:amlRowId=""  d
			..s BPCAMRowId=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),1)
			..s AMLAliasDesc=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),3)	    	
	    	..s Code=$lg(^DHCBPC("AnticoagulantMode",BPCAMRowId),1)
	    	..s Description=$lg(^DHCBPC("AnticoagulantMode",BPCAMRowId),2)
	    	..s IfSelectDrug=$lg(^DHCBPC("AnticoagulantMode",BPCAMRowId),3)
	    	..s IfActive= $lg(^DHCBPC("AnticoagulantMode",BPCAMRowId),4)
	    	..q:IfActive'="Y"
	    	..s SubType= $lg(^DHCBPC("AnticoagulantMode",BPCAMRowId),5)
	    	..q:(SubType'="")&&(TypeCode'="")&&(SubType'=TypeCode)
	    	..s Id=BPCAMRowId
	    	..d OutputRow1	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,IfSelectDrug)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAnticoagulantModeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnticoagulantModeListExecute ]
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

ClassMethod GetAnticoagulantModeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnticoagulantModeListExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query GetAnticoagulantDrugList(anticoagulantModeId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT %ID As Id,
	   BPCAD_Code As Code,
	   BPCAD_Desc As Description,
	   BPCAD_Amount As Amount,
	   BPCAD_Concentration As Concentration,
	   BPCAD_UomDr As UomId,
	   (select CTUOM_Desc from CT_UOM where CTUOM_RowId=BPCAD_UomDr) As UomDesc,
	   BPCAD_FirstAmount As FirstAmount,
	   BPCAD_Dose As Dose,
	   BPCAD_Frequency As Frequency,
	   BPCAD_Note As Note,
	   BPCAD_BPCSU_Dr As SpeedUnitId,
	   BPCAD_BPCSU_Dr->BPCSU_Desc As SpeedUnitDesc,
	   BPCAD_Duration As Duration,
	   BPCAD_IntervalMinute As IntervalMinute,
	   BPCAD_CatDr As CatId
	   FROM DHC_BPC_AnticoagulantDrug where %ID in(select BPCAMD_BPCAD_Dr 
	   from DHC_BPC_AnticoagulantModeDrug where BPCAMD_BPCAM_Dr=:anticoagulantModeId)
}

/// d ##class(web.DHCBPCAnticoagulantMode).InsertAntModeLoc("1","15")
ClassMethod InsertAntModeLoc(bpcAMDr, ctloc, bpcAMAliasDesc = "", hospId = "") As %String
{
	q:bpcAMDr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	s objAntModeLoc= ##class(User.DHCBP.Config.BPAnticoagulantModeLocation).%New()
	s objAntModeLoc.BPAMLBPCAMDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(bpcAMDr)
	s objAntModeLoc.BPAMLCtlocDr=ctloc
	s objAntModeLoc.BPAMLAMAliasDesc =bpcAMAliasDesc
	s saveStatus=objAntModeLoc.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s DataRowId=objAntModeLoc.%Id()
	d objAntModeLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPAnticoagulantModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPAnticoagulantModeLocation",DataRowId,hospId)
    }
    
	q 0
}

/// d ##class(web.DHCBPCAnticoagulantMode).UpdateAntModeLoc(1,"1","模式")
ClassMethod UpdateAntModeLoc(bpAMLId, BPAMLBPCAMDr, ctloc, bpcAMAliasDesc = "", hospId = "") As %String
{
	q:bpAMLId="" "ID不能为空!"
	q:BPAMLBPCAMDr="" "血管通路不能为空!"
	q:ctloc="" "科室不能为空!"
	q:'##class(User.DHCBP.Config.BPAnticoagulantModeLocation).%ExistsId(bpAMLId) "日志码表指针无对应记录!"
	s objAntModeLoc = ##class(User.DHCBP.Config.BPAnticoagulantModeLocation).%OpenId(bpAMLId)
	s objAntModeLoc.BPAMLBPCAMDr=##class(User.DHCBPCAnticoagulantMode).%OpenId(BPAMLBPCAMDr)
	s objAntModeLoc.BPAMLCtlocDr=ctloc
	s objAntModeLoc.BPAMLAMAliasDesc=bpcAMAliasDesc
	s updateStatus=objAntModeLoc.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s DataRowId=objAntModeLoc.%Id()
	d objAntModeLoc.%Close()
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPAnticoagulantModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBP.Config.BPAnticoagulantModeLocation",DataRowId,hospId)
    }
	q 0
}

/// d ##class(web.DHCBPCAnticoagulantMode).DeleteVasAccessLoc(1)
ClassMethod DeleteAntModeLoc(bpAMLId) As %String
{
	q:bpAMLId="" "ID不能为空!"
	q:'##class(User.DHCBP.Config.BPAnticoagulantModeLocation).%ExistsId(bpAMLId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCBP.Config.BPAnticoagulantModeLocation).%DeleteId(bpAMLId)
	q:(+deleteStatus=0) "数据删除失败!"
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBP.Config.BPAnticoagulantModeLocation")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBP.Config.BPAnticoagulantModeLocation",bpAMLId)
    }
	q 0
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCAnticoagulantMode","FindAntModeLoc")
Query FindAntModeLoc(hospId As %String = "") As %Query(ROWSPEC = "tAmlRowId:%String,tBPAMLCAMRowId:%String,tBPAMLCAMDesc:%String,tBPAMLCAMLocId:%String,tBPAMLCAMLocDesc:%String,tBPAMLCAMAliasDesc:%String")
{
}

ClassMethod FindAntModeLocExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s amlRowId=0
	f  s amlRowId=$o(^DHCBP.Config.BPAMLocationD(amlRowId)) q:amlRowId=""  d
		.s hospitalId=""
		.s DataAttributionDr=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),4)
		.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
		.q:((hospitalId'="")&(hospId'=hospitalId))		
		.s tBPAMLCAMRowId=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),1)
		.i tBPAMLCAMRowId'="" s tBPAMLCAMDesc=$lg(^DHCBPC("AnticoagulantMode",tBPAMLCAMRowId),2)
		.e  s tBPAMLCAMDesc=""
		.s tBPAMLCAMLocId=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),2)
		.i tBPAMLCAMLocId'="" s tBPAMLCAMLocDesc=$p($g(^CTLOC(tBPAMLCAMLocId)),"^",2)
	    .e  s tBPAMLCAMLocDesc=""
		.s tBPAMLCAMAliasDesc=$lg(^DHCBP.Config.BPAMLocationD(amlRowId),3)
	    .d OutputRow1
	    
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(amlRowId,tBPAMLCAMRowId,tBPAMLCAMDesc,tBPAMLCAMLocId,tBPAMLCAMLocDesc,tBPAMLCAMAliasDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAntModeLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAntModeLocExecute ]
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

ClassMethod FindAntModeLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAntModeLocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
