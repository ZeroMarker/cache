Class web.DHCARCOrdSetsAuthorize Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2019-10-12
/// desc:获取医嘱套授权科室列表
Query FindDep(ARCOSRowId As %String, LogonHospDr As %String = "") As %Query(ROWSPEC = "CTLOCRowID:%String,CTLOCDesc:%String,selected:%Boolean")
{
}

ClassMethod FindDepExecute(ByRef qHandle As %Binary, ARCOSRowId As %String, LogonHospDr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCARCOrdSetsAuthorize","FindDep",70)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set langid=..%LanguageID()
    s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
    K ^TMP($J,"FindDepLookup")
 	s CTLOCRowID=0
 	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d
 	.s str=$g(^CTLOC(CTLOCRowID))
 	.s LocHospDr=$p(str,"^",22)
 	.Q:LocHospDr'=LogonHospDr
 	.s CTLOCType=$p(str,"^",13)
 	.q:(CTLOCType'="E")&&(CTLOCType'="W")&&(CTLOCType'="EM")
 	.s DateActiveFrom=$p(str,"^",24)
 	.Q:(DateActiveFrom'="")&&(DateActiveFrom>+$h)
 	.s DateActiveTo=$p(str,"^",25)
 	.Q:(DateActiveTo'="")&&(DateActiveTo<=..%SysDate())
	.q:($P(^CTLOC(CTLOCRowID),"^",14)'="Y")
 	.s selected=0
 	.s CTLOCDesc=$p(str,"^",2)
 	.if $d(^User.ARCOrdSetsAuthorizeI("AuthLocDr",ARCOSRowId,CTLOCRowID)) s selected=1
 	.s CTLOCDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLOCDesc,langid)
 	.s CTLOCMarkNO=$p(str,"^",43)
 	.if (CTLOCMarkNO="") s CTLOCMarkNO=CTLOCDesc
 	.e  s CTLOCDesc=CTLOCDesc_"-"_CTLOCMarkNO
 	.s ^TMP($J,"FindDepLookup",CTLOCMarkNO,CTLOCRowID)=$lb($g(CTLOCRowID),$g(CTLOCDesc),$g(selected))
	.//Do OutputRowFindDep
	s seq="" for {
		s seq=$O(^TMP($j,"FindDepLookup",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"FindDepLookup",seq,seq1))
			Quit:seq1=""
			s Data=^TMP($j,"FindDepLookup",seq,seq1)
			d OutputRowFindDep		
		}
	}
	K ^TMP($J,"FindDepLookup")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindDep
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2019-10-12
/// desc:医嘱套科室授权保存
ClassMethod SaveARCLocAuthorize(ARCOSRowIds As %String, LocStr As %String, LogonHospDr = "") As %String
{
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	s SQLCODE=0
	TS
	for i=1:1:$L(ARCOSRowIds,"^"){
		s ARCOSRowId=$P(ARCOSRowIds,"^",i)
		continue:ARCOSRowId=""
		&SQL(Delete From SQLUSER.ARC_OrdSetsAuthorize Where AuthARCOSDR=:ARCOSRowId AND AuthLocDr->CTLOC_Hospital_DR=:LogonHospDr)
		for j=1:1:$l(LocStr,"^") {
			s LocId=$p(LocStr,"^",j)
			continue:LocId=""
			&SQL(insert into SQLUSER.ARC_OrdSetsAuthorize set AuthARCOSDR=:ARCOSRowId,AuthLocDr=:LocId)
			Q:SQLCODE
		}
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

/// creator:宋春莉
/// date:2019-10-12
/// desc:获取已授权至本科室的医嘱套列表
Query QueryARCOSList(LocID As %String) As %Query(ROWSPEC = "ARCOSRowid:%String,ARCOSCode:%String,ARCOSDesc:%String,ARCOSOrdCat:%String,ARCOSOrdSubCat:%String,ARCOSEffDateFrom:%String,ARCOSOrdCatDR:%String,ARCOSOrdSubCatDR:%String,FavRowid:%String,ARCOSAlias:%String,FavUserDesc:%String,FavDepDesc:%String,FavUserDr:%String,FavDepDr:%String,MedUnit:%String,MedUnitDesc:%String,OrdSetPrice:%String,PrescTypeCode:%String,DuratId:%String,FreqId:%String,InstrId:%String,DosageId:%String,Notes:%String,CelerType:%String")
{
}

ClassMethod QueryARCOSListExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCARCOrdSetsAuthorize","QueryARCOSList",1)
	Set repid=$I(^CacheTemp)
    Set ind=1
    Set langid=..%LanguageID()
 	s ARCOSRowId=0
 	for {
	 	s ARCOSRowId=$o(^User.ARCOrdSetsAuthorizeI("AuthLocARCOSDr",LocID,ARCOSRowId)) Q:ARCOSRowId=""	
		  &SQL(DECLARE EmpCursor CURSOR FOR
		 Select ARCOS_Rowid,ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR->ORCAT_Desc,
		 ARCOS_OrdSubCat_DR->ARCIC_Desc,ARCOS_EffDateFrom,ARCOS_OrdCat_DR,
		 ARCOS_OrdSubCat_DR,Fav_Rowid ,SQLUser.DHC_UserFavItems.Fav_User_Dr,SQLUser.DHC_UserFavItems.Fav_ItemRowid,
		 SQLUser.DHC_UserFavItems.Fav_Dep_Dr,SQLUser.DHC_UserFavItems.Fav_MedUnit_Dr,
		 ARCOS_PrescTypeCode,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_Instr_DR,ARCOS_InstrLinkDosage_DR,
		 ARCOS_Notes,SQLUser.DHC_UserFavItems.Fav_CelerType
		 into :ARCOSRowid,:ARCOSCode,:ARCOSDesc,:ARCOSOrdCat,:ARCOSOrdSubCat,
			  :ARCOSEffDateFrom,:ARCOSOrdCatDR,:ARCOSOrdSubCatDR,:FavRowid,:FavUserDr,:FavItemRowid,
			  :FavDepDr,:FavMedUnitDr,
			  :PrescTypeCode,:DuratId,:FreqId,:InstrId,:DosageId,:Notes,:CelerType
		 From SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems 
		 Where 
		 SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid
		 and ARCOS_Rowid=:ARCOSRowId
		 order by ARCOS_Rowid desc) 
		 &SQL(OPEN EmpCursor)
		 for  &SQL(FETCH EmpCursor) QUIT:SQLCODE  do
		 .s MedUnitDesc=""
		 .if (FavMedUnitDr'="")  s MedUnitDesc=##class(web.DHCUserFavItems).GetMedUnitDesc(FavMedUnitDr) //组描述
		 .s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",ARCOSRowid,0))
		 .if ARCOSAliasRowid'="" d 
		 ..s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
		 ..s FavRowidOut=FavRowid
		 .s FavUserDesc="",FavDepDesc=""
		 .IF FavUserDr'="" s FavUserDesc=$p($g(^SSU("SSUSR",FavUserDr)),"^",2)
		 .s FavUserDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",FavUserDesc,langid)
		 .if FavDepDr'="" d
		 ..s FavDepDesc=$p($g(^CTLOC(FavDepDr)),"^",2) 
		 ..s FavDepDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",FavDepDesc,langid)
		 ..s FavDepDesc=##class(web.DHCOPAdmReg).LocDescFormate(FavDepDesc)
		 .s OrdSetPrice="包装价格"
		 .s ARCOSOrdCat=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",ARCOSOrdCat,langid)
		 .Set ARCOSOrdSubCat= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ARCOSOrdSubCat,langid)
		 .Do OutputRow2
		 &SQL(Close EmpCursor)
	 }
	 Set qHandle=$lb(0,repid,0)
	 Quit $$$OK
OutputRow2
	set Data=$lb(ARCOSRowid,ARCOSCode,ARCOSDesc,ARCOSOrdCat,ARCOSOrdSubCat,ARCOSEffDateFrom,ARCOSOrdCatDR,ARCOSOrdSubCatDR,FavRowid,ARCOSAlias,FavUserDesc,FavDepDesc,FavUserDr,FavDepDr,MedUnit,MedUnitDesc,OrdSetPrice,PrescTypeCode,DuratId,FreqId,InstrId,DosageId,Notes,CelerType)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QueryARCOSListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryARCOSListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryARCOSListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryARCOSListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// creator:宋春莉
/// date:2019-10-12
/// desc:医嘱套引用
ClassMethod ARCOSCopy(FromARCOSIdStr As %String, UserRowid As %String, InUser As %String, FavDepList As %String, LogonHospDr As %String = "") As %String
{
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
	for i=1:1:$l(FromARCOSIdStr,"^") {
		s FromARCOSRowid=$p(FromARCOSIdStr,"^",i)
		s ARCOSCode=""
		s ARCOSDesc=$P(^ARCOS(FromARCOSRowid),"^",2)
		s ARCOSCatID=$P(^ARCOS(FromARCOSRowid),"^",8)
		s ARCOSSubCatID=$P(^ARCOS(FromARCOSRowid),"^",9)
		s ARCOSEffectDate=""
		s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",FromARCOSRowid,0))
		if ARCOSAliasRowid'="" {
		  	s ARCOSAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
		}else{
			s ARCOSAlias=""
		}
		s DocMedUnit="",HospID="",CelerType="N"
		s FavRowId=$o(^DHCFavItems(0,"ItemRowid",FromARCOSRowid,""))
		if (FavRowId'="") {
			s CelerType=$p(^DHCFavItems(FavRowId),"^",10)
		}
		s rtn=##class(web.DHCUserFavItems).SaveAsUser(FromARCOSRowid, InUser, ARCOSCode,ARCOSDesc, ARCOSCatID, ARCOSSubCatID, "", ARCOSAlias, UserRowid, FavDepList, DocMedUnit, HospID, CelerType,LogonHospDr)
	}
	Q rtn
}

}
