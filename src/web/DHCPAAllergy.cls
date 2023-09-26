Class web.DHCPAAllergy Extends DHCDoc.Util.RegisteredObject
{

// Query FindAllergy(AllergyDesc As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")

// {

// SELECT distinct(PHCD_Name),PHCD_Code,PHCD_RowId FROM 

// SQLUser.PHC_DrgMast ,SQLUser.PHC_DrgForm,SQLUser.ARC_ItmMast,SQLUser.ARC_Alias

// where SQLUser.PHC_DrgMast.PHCD_Rowid=SQLUser.PHC_DrgForm.PHCDF_PHCD_ParRef and

// SQLUser.ARC_ItmMast.ARCIM_PHCDF_DR=SQLUser.PHC_DrgForm.PHCDF_RowId    and 

// SQLUser.ARC_Alias.ALIAS_ARCIM_DR=SQLUser.ARC_ItmMast.ARCIM_RowId and

// (PHC_DrgMast.PHCD_Name %STARTSWITH %ALPHAUP :AllergyDesc or ARC_Alias.ALIAS_Text %STARTSWITH %ALPHAUP :AllergyDesc )

// }

/*
Query FindAllergy(AllergyDesc As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
 SELECT ALG_Desc,ALG_Code,ALG_RowId FROM SQLUser.PAC_Allergy where ALG_Desc %STARTSWITH %ALPHAUP :AllergyDesc
 SELECT PHCD_Name,PHCD_Code,PHCD_RowId FROM SQLUser.PHC_DrgMast where PHCD_Name %STARTSWITH %ALPHAUP :AllergyDesc
 
 SELECT distinct(PHCD_Name),PHCD_Code,PHCD_RowId FROM 
	SQLUser.PHC_DrgMast ,SQLUser.PHC_DrgForm,SQLUser.ARC_ItmMast,SQLUser.ARC_Alias
    where SQLUser.PHC_DrgMast.PHCD_Rowid=SQLUser.PHC_DrgForm.PHCDF_PHCD_ParRef and
     SQLUser.ARC_ItmMast.ARCIM_PHCDF_DR=SQLUser.PHC_DrgForm.PHCDF_RowId    and 
     SQLUser.ARC_Alias.ALIAS_ARCIM_DR=SQLUser.ARC_ItmMast.ARCIM_RowId and
    (PHC_DrgMast.PHCD_Name %STARTSWITH %ALPHAUP :AllergyDesc or ARC_Alias.ALIAS_Text %STARTSWITH %ALPHAUP :AllergyDesc )
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCPAAllergy","FindAllergy","","")
Query FindAllergy(AllergyDesc As %String, CategoryRowId As %String = "", TagCode As %String = "") As %Query(ROWSPEC = "Description:%String,Code:%String,MRCATDesc:%String,TagDescription:%String,TagCode:%String,HIDDEN:%String")
{
}

ClassMethod FindAllergyExecute(ByRef qHandle As %Binary, AllergyDesc As %String, CategoryRowId As %String = "", TagCode As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP("FindAllergy")=AllergyDesc_"^"_CategoryRowId
	if AllergyDesc'=""  s AllergyDesc=$zcvt(AllergyDesc,"U")
	s ALGDesc="" f  s ALGDesc=$o(^PAC("ALG",0,"Desc",ALGDesc)) q:ALGDesc=""  d
	.q:(AllergyDesc'="")&&(ALGDesc'[AllergyDesc)
	.s ALGRowId="" f  s ALGRowId=$o(^PAC("ALG",0,"Desc",ALGDesc,ALGRowId)) q:ALGRowId=""  d
	..q:'$d(^PAC("ALG",ALGRowId))
	..s ALGCode=$p(^PAC("ALG",ALGRowId),"^")
	..s MRCATDesc="",MRCATTagDescription="",MRCATTagCode=""
	..s ALGTypeDR=$p(^PAC("ALG",ALGRowId),"^",3)
	..s:ALGTypeDR'="" MRCATDesc=$p(^MRC("AT",ALGTypeDR),"^",2),MRCATTagCode=$p(^MRC("AT",ALGTypeDR),"^",6) 
	..q:(CategoryRowId'="")&&(CategoryRowId'=ALGTypeDR)
	..q:(TagCode'="")&&(TagCode'=MRCATTagCode)
	..s:MRCATTagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",MRCATTagCode)
	..s DateForm=$p(^PAC("ALG",ALGRowId),"^",4)
	..q:(DateForm'="")&&(+$h<DateForm)
	..s DateTo=$p(^PAC("ALG",ALGRowId),"^",5)
	..q:(DateTo'="")&&(+$h>DateTo)
	..Set ^CacheTemp(repid,ind)=$lb(ALGDesc,ALGCode,MRCATDesc,MRCATTagDescription,MRCATTagCode,ALGRowId)
	..Set ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindAllergyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllergyExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindAllergyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllergyExecute ]
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

Query FindAllergyItem(ALGItem As %String, TagCode As %String, GroupID As %String = "") As %Query(ROWSPEC = "Desc:%String,ID:%String,Tag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPAAllergy","FindAllergyItem","","")
ClassMethod FindAllergyItemExecute(ByRef qHandle As %Binary, ALGItem As %String, TagCode As %String, GroupID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP("FindAllergyItem")=ALGItem_"^"_TagCode
	s ALGItem=$zcvt(ALGItem,"U")
	if TagCode="P"
	{
		; Pharmacy Item
   		/*&sql(
 	  		DECLARE PhmItm CURSOR FOR
 	  		SELECT	PHCD_Name,PHCD_RowId
 	  		     into :PHCDName,:PHCDRowId
 	  		FROM	SQLUser.PHC_DrgMast
 	  		WHERE	((%ALPHAUP PHCD_Name %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY PHCD_Name ASC
  		 	)
   		&sql(OPEN PhmItm)
   		For  &SQL(FETCH PhmItm) QUIT:SQLCODE  do*/
   		s PHCDRowId=0 f  s PHCDRowId=$o(^PHCD(PHCDRowId)) q:PHCDRowId=""  d
   		.Q:+PHCDRowId=0
   		.Q:'$d(^PHCD(PHCDRowId,1))
   		.s PHCDName=$p(^PHCD(PHCDRowId,1),"^",2)
   		.s PHCDNameBM=##class(web.DHCINSUPort).GetCNCODE(PHCDName,4,"")
   		.i PHCDNameBM["?" s PHCDNameBM=$tr(PHCDNameBM,"?","") ;$tr替换
		.q:(PHCDNameBM'[ALGItem)&&(PHCDName'[ALGItem)
   		.s ArcimDr=##class(web.DHCSTCOMMARC).GetArcIDByPhcf(PHCDRowId_"||1")
   		.q:ArcimDr=""
	 	.s ItemCatDr=$P(^ARCIM(+ArcimDr,$p(ArcimDr,"||",2),1),"^",10) 
	 	.q:ItemCatDr=""
		.s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
		.q:OrderType'="R"
   		.q:(PHCDRowId="")||(PHCDName="")
        .s ^CacheTemp(repid,ind)=$lb(PHCDName,PHCDRowId,"P")
		.s ind=ind+1
		;&SQL(CLOSE PhmItm)
   		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	elseif TagCode="G"  
	{
		; Generic Drug
   		/*&sql(
 	  		DECLARE GenDrg CURSOR FOR
 	  		SELECT	PHCGE_Name,PHCGE_RowId
 	  		into :PHCGEName,:PHCGERowId
 	  		FROM	SQLUser.PHC_Generic
 	 		WHERE	((%ALPHAUP PHCGE_Name %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY PHCGE_Name ASC
   			)
   		&sql(OPEN GenDrg)
   		For  &SQL(FETCH GenDrg) QUIT:SQLCODE  do*/
   		s PHCGERowId=0 f  s PHCGERowId=$o(^PHCGE("GE",PHCGERowId)) q:PHCGERowId=""  d
   		.s quitflag=0
   		.s PHCGEName=$p(^PHCGE("GE",PHCGERowId),"^",2)
   		.s PHCGEDateFrom=$p(^PHCGE("GE",PHCGERowId),"^",5)
   		.Q:(PHCGEDateFrom'="")&&(PHCGEDateFrom>+$h)
   		.s PHCGEDateTo=$p(^PHCGE("GE",PHCGERowId),"^",6)
   		.Q:(PHCGEDateTo'="")&&(PHCGEDateTo'>+$h)
   		.s PHCDNameBM=##class(web.DHCINSUPort).GetCNCODE(PHCGEName,4,"")
   		.i PHCDNameBM["?" s PHCDNameBM=$tr(PHCDNameBM,"?","") ;$tr替换
		.q:(PHCDNameBM'[ALGItem)&&(PHCGEName'[ALGItem)
   		.q:(PHCGERowId="")||(PHCGEName="")
   		.s ARCIMMain=0 f  s ARCIMMain=$o(^ARCIM(0,"Gener",PHCGERowId,ARCIMMain)) q:ARCIMMain=""  d
   		..s ARCIMSub=0 f  s ARCIMSub=$o(^ARCIM(0,"Gener",PHCGERowId,ARCIMMain,ARCIMSub)) q:ARCIMSub=""  d
	 	...s ItemCatDr=$P(^ARCIM(ARCIMMain,ARCIMSub,1),"^",10) 
	 	...q:ItemCatDr=""
		...s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
		...i OrderType'="R" s quitflag=1
		.Q:quitflag=1
        .s ^CacheTemp(repid,ind)=$lb(PHCGEName,PHCGERowId,"G")
		.s ind=ind+1
		;&SQL(CLOSE GenDrg)
   		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	elseif TagCode="I"  //
	{
		; Ingradient
   		&sql(
 	  		DECLARE Ingrd CURSOR FOR
 	  		SELECT	INGR_Desc,INGR_RowId
 	  		into :INGRDesc,:INGRRowId
 	  		FROM	SQLUser.PHC_Ingredient
 	  		WHERE	((%ALPHAUP INGR_Desc %STARTSWITH %ALPHAUP :ALGItem) OR (:ALGItem IS NULL))
 	  		ORDER BY INGR_Desc ASC
   			)
   		&sql(OPEN Ingrd)
   		For  &SQL(FETCH Ingrd) QUIT:SQLCODE  do
   		.q:(PHCGERowId="")||(PHCGEName="")
        .s ^CacheTemp(repid,ind)=$lb(PHCGEName,PHCGERowId,"I")
		.s ind=ind+1
		&SQL(CLOSE Ingrd)
   		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}else
	{
		if ALGItem=""  { Set qHandle=$lb(0,repid,0)  Quit $$$OK }
		Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry.LookUpItem")
		d rset.Execute(ALGItem,GroupID,"","", "", "", "", "", "", "", "", "","", "","","")
	 	While (rset.Next()) {  
	            s ArcimDesc=rset.GetData(1)
	            s ArcimId=rset.GetData(2)
	            s OrderType=rset.GetData(6)
	            s ^CacheTemp(repid,ind)=$lb(ArcimDesc,ArcimId,"")
				s ind=ind+1
	 	}
	 	d rset.Close()	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
}

ClassMethod FindAllergyItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllergyItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindAllergyItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllergyItemExecute ]
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

Query Allergies(PatientID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "RowID,Category:%String,Allergen:%String,ALGItem:%String,NatureOfReaction:%String,Severity:%String,SeverityColour:%String,OnsetDate:%Date,OnsetDateFreeText:%String,CareProvider:%String,InActive:%Boolean,OnsetDateText:%String,RowHexColour:%String,LastUpdateDate:%Date,LastUpdateTime:%Time,LastUpdateUser:%String,LastUpdateHospital:%String,Status:%String,ExternalID:%String,LastUpdateUserRole:%String,LastUpdateUserId:%String,Comments:%String,ALGFreeTextAllergy:%String,DrugSpecific:%Boolean,tag:%String,ALGDSReportFlag:%Boolean,HiddenFields:%String")
{
}

ClassMethod AllergiesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = AllergiesFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询过敏记录
/// d ##class(%ResultSet).RunQuery("web.DHCPAAllergy","Allergies",142721)
ClassMethod AllergiesExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat){
		s count=objpat.ChildPAAllergy.Count()
		for i=1:1:count {
			s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,
				CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,
				LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,
				DrugSpecific,tag,ALGDSReportFlag,HiddenFields,ALGItem)=""
			
			s objAllergy=objpat.ChildPAAllergy.GetAt(i)
			s RowID=objAllergy.%Id()
			
			;自定义过敏分类
			if objAllergy.ALGTypeDRGetObjectId()'="" {
				s Allergen=objAllergy.ALGTypeDR.ALGDesc
				s tag=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
			}
			
			;通用项过敏源
			if objAllergy.ALGPHCGEDRGetObjectId()'="" {
				s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName
				s tag="G"
				;s tag="Generic Drug"
			}
			
			;药学过敏源
			if objAllergy.ALGPHCDMDRGetObjectId()'="" {
				s ALGItem=objAllergy.ALGPHCDMDR.PHCDName
				s tag="P"
				;s tag="Pharmacy Item"
			}
			
			if objAllergy.ALGIngredDRGetObjectId()'="" {
				s ALGItem=objAllergy.ALGIngredDR.INGRDesc
				s tag="I"
				;s tag="Ingredient"
			}
			if objAllergy.ALGIngredDRGetObjectId()'="" {
				s ALGItem=objAllergy.ALGIngredDR.INGRDesc
				s tag="I"
				;s tag="Ingredient"
			}
			;分类
			s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
 			i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
			
			;拮抗反应
			if objAllergy.ALGCategoryDRGetObjectId()'="" {
				s NatureOfReaction=objAllergy.ALGCategoryDR.ALRGCATDesc
			}
			
			;医嘱项ID
			if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") { 
			  s ALGItemID=objAllergy.ALGExternalID
			  s ALGItem=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
			}
			;严重
			if objAllergy.ALGSeverityDRGetObjectId()'="" {
				s Severity=ALGSeverityDR.ALGSeverityDR.ALRGSEVDesc
			}
			s OnsetDate=objAllergy.ALGOnsetDate
			s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
			;发作日期描述
			s OnsetDateText=..%ZD(OnsetDate)_OnsetDateFreeText
			
			;医护人员 组件里没有使用
			s CareProvider=objAllergy.ALGCTPCPDR
			
			;未激活标志
			s InActive=objAllergy.ALGInActive
			continue:InActive="Y"
			;使用不明
			s RowHexColour=""
			s SeverityColour=""
			s HiddenFields=""

			s LastUpdateDate=objAllergy.ALGLastUpdateDate
			i LastUpdateDate'="" s LastUpdateDate=..%ZD(LastUpdateDate)
			s LastUpdateTime=objAllergy.ALGLastUpdateTime
			if objAllergy.ALGUpdateUserDRGetObjectId()'="" {
				s LastUpdateUserId=objAllergy.ALGUpdateUserDR.SSUSRInitials
				s LastUpdateUser=objAllergy.ALGUpdateUserDR.SSUSRName
				s LastUpdateUserRole=objAllergy.ALGUpdateUserDR.SSUSRStaffTypeDR.STAFFDesc
			}
			if objAllergy.ALGLastUpdateHospitalDRGetObjectId()'="" {
				s LastUpdateHospital=objAllergy.ALGLastUpdateHospitalDR.HOSPDesc
			}
			
			;状态
			s Status=objAllergy.ALGStatus
			s ExternalID=objAllergy.ALGExternalID
			;注释
			s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
			s ALGFreeTextAllergy=objAllergy.ALGFreeTextAllergy
			s DrugSpecific=objAllergy.ALGDrugSpecific
			s ALGDSReportFlag=objAllergy.ALGDSReportFlag
			s data=$Lb(RowID,Category,Allergen,ALGItem,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,
						CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,
						LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,
						DrugSpecific,tag,ALGDSReportFlag,HiddenFields)
			set ^CacheTemp(repid,ind)=data
			set ind=ind+1
		}
	}
	quit $$$OK
}

ClassMethod AllergiesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = AllergiesExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query LookUpByTag(desc As %String, tag As %String, date As %Date = "") As %Query(ROWSPEC = "MRCATDesc:%String,MRCATCode:%String,MRCATTagDescription:%String,HIDDEN:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCPAAllergy","LookUpByTag","","G")
ClassMethod LookUpByTagExecute(ByRef qHandle As %Binary, desc As %String, tag As %String, date As %Date = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP("LookUpByTag")=desc_"^"_tag
	if desc'=""  s desc=$zcvt(desc,"U")
	
	s MRCATRowId=0 f  s MRCATRowId=$o(^MRC("AT",MRCATRowId)) q:MRCATRowId=""  d
	.s MRCATCode=$p(^MRC("AT",MRCATRowId),"^")
	.s MRCATDesc=$p(^MRC("AT",MRCATRowId),"^",2)
	.q:(desc'="")&&(MRCATDesc'[desc)
	.s MRCATTagDescription=$p(^MRC("AT",MRCATRowId),"^",6)
	.q:(tag'="")&&(MRCATTagDescription'=tag)
	.s DateForm=$p(^MRC("AT",MRCATRowId),"^",9)
	.q:(DateForm'="")&&(+$h<DateForm)
	.s DateTo=$p(^MRC("AT",MRCATRowId),"^",10)
	.q:(DateTo'="")&&(+$h>DateTo)
	.Set ^CacheTemp(repid,ind)=$lb(MRCATDesc,MRCATCode,MRCATTagDescription,MRCATRowId)
	.Set ind=ind+1
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod LookUpByTagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpByTagExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod LookUpByTagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpByTagExecute ]
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

Query FindPat() As %SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,Code:%String")
{
	
	select SS_Desc,SS_Code from SQLUser.CT_SocialStatus
}

/*
Query LookUpByTag(desc As %String, tag As %String, date As %Date = "") As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{
	SELECT MRCAT_Desc, MRCAT_RowId, MRCAT_Code, MRCAT_TagDescription
	FROM SQLUser.MRC_AllType
}
*/
ClassMethod websysSave(compref As %String, id As %String) [ ProcedureBlock = 0 ]
{
 
 s $ZT="saveerr"
 n compid,status,new,j,oktosave,save,value,parref,oldval
 s new=id=""
 m ^Temp("Upgrade","web.DHCPAAllergy.websysSave","%req")=%request.Data
 
 s:id'="" obj=##Class(User.PAAllergy).%OpenId(id)
 if id="" d
 . s parref=$g(%request.Data("PARREF",1))
 . i parref="" s obj=##Class(User.PAAllergy).%New()
 . i parref'="" s obj=##Class(User.PAAllergy).%New(parref)
 
 i $d(%request.Data("PARREF",1)) d
 . s (val,oldval)=$g(%request.Data("PARREF",1)) i %request.Get("PARREF")'="" d obj.ALGPAPMIParRefSetObjectId(%request.Get("PARREF"))
 
 i $d(%request.Data("CategoryRowId",1)) d
 . s (val,oldval)=$g(%request.Data("CategoryRowId",1)) d:$g(val)'="" obj.ALGMRCAllTypeDRSetObjectId(%request.Data("CategoryRowId",1))
 ;过敏源
 i $d(%request.Data("AllergenRowId",1)) d
 . //s (val,oldval)=$g(%request.Data("AllergenRowId",1)) d:$g(val)'="" obj.ALGTypeDRSetObjectId($g(val))
 .   s (val,oldval)=$g(%request.Data("AllergenRowId",1)) d obj.ALGTypeDRSetObjectId($g(val))
 ;过敏项目
 
 if $d(%request.Data("ALGItemRowId",1)) 
 {
 	if $g(%request.Data("TagCode",1))="G"
 	{   //通用名
	 //s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d:$g(val)'="" obj.ALGPHCGEDRSetObjectId($g(val))
	 s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d obj.ALGPHCGEDRSetObjectId($g(val)) 
	 d obj.ALGPHCDMDRSetObjectId("")
	 d obj.ALGIngredDRSetObjectId("")
	 s obj.ALGExternalID=""
 	}elseif $g(%request.Data("TagCode",1))="P"
 	{   //药学项
	 //s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d:$g(val)'="" obj.ALGPHCDMDRSetObjectId($g(val))
	 s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d obj.ALGPHCDMDRSetObjectId($g(val))
	 d obj.ALGPHCGEDRSetObjectId("")
	 d obj.ALGIngredDRSetObjectId("")
	 s obj.ALGExternalID=""
 	}elseif $g(%request.Data("TagCode",1))="I"
 	{   //自定义
	  //s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d:$g(val)'="" obj.ALGIngredDRSetObjectId($g(val))
	  s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) d obj.ALGIngredDRSetObjectId($g(val))
	  d obj.ALGPHCGEDRSetObjectId("")
	  d obj.ALGPHCDMDRSetObjectId("")
	  s obj.ALGExternalID=""
 	}else
 	{   //医嘱项
	 //s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) s:$g(val)'="" obj.ALGExternalID=%request.Data("ALGItemRowId",1)
	   s (val,oldval)=$g(%request.Data("ALGItemRowId",1)) s obj.ALGExternalID=%request.Data("ALGItemRowId",1)
	    d obj.ALGPHCGEDRSetObjectId("")
	    d obj.ALGPHCDMDRSetObjectId("")
	    d obj.ALGIngredDRSetObjectId("")
	  
 	}
 }
 
 /*
 i $d(%request.Data("AllergenRowId",1)) 
 {
	 //. s (val,oldval)=$g(%request.Data("AllergenRowId",1)) d obj.ALGTypeDRSetObjectId(%request.Data("AllergenRowId",1))
	 s (val,oldval)=$g(%request.Data("AllergenRowId",1))
	 d:val'="" obj.ALGPHCDMDRSetObjectId($g(val))
 }
 */
 i $d(%request.Data("ALGComments",1)) d
 . s (val,oldval)=$g(%request.Data("ALGComments",1)) d ##Class(websys.Conversions).LongTextHtmlToLogical(obj.ALGComments,$g(val),$c(13,10))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("ALGComments"),"注释"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"ALGComments") s oktosave=0

 i $d(%request.Data("UserID",1)) d
 . s (val,oldval)=$g(%request.Data("UserID",1)) d obj.ALGUpdateUserDRSetObjectId(%request.Data("UserID",1))
 . i oldval'="",val="" d msg.AddItem("E",$g(t("UserName"),"用户名称"),oldval_" "_$g(t("XINVALID")," is invalid"),compid,"UserName") s oktosave=0
 
 i $d(%request.Data("ALGOnsetDate",1)) d
 . s val=%request.Data("ALGOnsetDate",1)
 . s obj.ALGOnsetDate=..%ZDH($g(val))

 
 s obj.ALGStatus="A"
 s obj.ALGLastUpdateDate=..%SysDate()
 s obj.ALGLastUpdateTime=..%SysTime()
 ;s obj.ALGExternalID=obj.ALGPAPMIParRefGetObjectId()_"ALG"_obj.ALGChildSub

 s save=obj.%Save(0)

 s ^Temp("Upgrade","websysSave1","web.DHCPAAllergy")=$ZE
 s newFalg=0
 i id="" s newFalg=1
 
 s:save id=obj.%Id()
 d obj.%Close()  s obj=""

 i ($d(%request.Data("ALGDescCT",1))&&(id'=""))
 {
	 s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",1)=%request.Data("ALGDescCT",1)
	 
 }
 
 

 i ($d(%request.Data("ALGCheckConflict",1))&&(id'="")) 
 {
	  s Conflictval=$g(%request.Data("ALGCheckConflict",1))
      s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",3)=##Class(websys.Conversions).YesNoHtmlToLogical($g(Conflictval))     
 }
 else
 {
	  s $P(^PAPER(+id,"ALG",$P(id,"||",2),"DHC"),"^",3)=##Class(websys.Conversions).YesNoHtmlToLogical("")
 }
 s idnew=id
 i newFalg=1 d
 .s EpisodeID=$g(%request.Data("EpisodeID",1))
 .s rtn=##class(web.DOC.PortalService).DHCHisInterface("S00000013",id,1,EpisodeID)
 q save
saveerr
 s ^Temp("Upgrade","websysSave","web.DHCPAAllergy")=$ZE
 q 1
}

/// 2012.12.14 dhcc
ClassMethod websysDeleteAllergen(compref As %Library.String, id As %String = "") As %Boolean
{
	;不知是否要处理User.PAAlertMsg
	//d ..websysDelete(id)
	if (##class(User.PAAllergy).%ExistsId(id))
	set PAAllergyObj=##class(User.PAAllergy).%DeleteId(id)
	s EpisodeID=$g(%request.Data("EpisodeID",1))
	s rtn=##class(web.DOC.PortalService).DHCHisInterface("S00000013",id,2,EpisodeID)
	Q $$$OK
}

/// 2012.12.14 dhcc
/// w ##class(web.DHCPAAllergy).GetAllergenDetails("142721||15")
ClassMethod GetAllergenDetails(ID As %String) As %String
{
	if ID'="" {
		s ALGItem=""
		s objAllergy=##class(User.PAAllergy).%OpenId(ID)
		if $IsObject(objAllergy){
			s TagCode="",ALGDescCT="",table="",MRCATTagDescription="",TagCode="",ALGItemRowId="",ALGItem=""
			///过敏子分类(过敏源)
			s AllergenRowId=objAllergy.ALGTypeDRGetObjectId()
			if AllergenRowId'="" {
				s ALGDescCT=objAllergy.ALGTypeDR.ALGDesc
			    s TagCode=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
				//s table="PACAllergy"
			}  //else{
			
				s ALGPHCGEDR=objAllergy.ALGPHCGEDRGetObjectId()
				if ALGPHCGEDR'="" {
					s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName
					s ALGItemRowId=ALGPHCGEDR
					s TagCode="G"
					//s table="PHCGeneric"
				}else{
					s ALGPHCDMDR=objAllergy.ALGPHCDMDRGetObjectId()
					if ALGPHCDMDR'="" {
						s ALGItem=objAllergy.ALGPHCDMDR.PHCDName
						s ALGItemRowId=ALGPHCDMDR
						s TagCode="P"
						//s table="PHCDrgMast"
						
					}else{
						s ALGIngredDR=objAllergy.ALGIngredDRGetObjectId()
						if ALGIngredDR'="" {
							s ALGItem=objAllergy.ALGIngredDR.INGRDesc
							s ALGItemRowId=ALGIngredDR
							s TagCode="I"
							//s table="PHCIngredient"
						}
					}
				}

			//}
			;医嘱项ID
			if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") { 
			  s ALGItemRowId=objAllergy.ALGExternalID
			  s ALGItem=$p($g(^ARCIM(+ALGItemRowId,$p(ALGItemRowId,"||",2),1)),"^",2)
			}
			
		
			
			s MRCATDesc=objAllergy.ALGMRCAllTypeDR.MRCATDesc
			S CategoryRowId=objAllergy.ALGMRCAllTypeDRGetObjectId()
			s:TagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",TagCode)
			s ALGDate=objAllergy.ALGOnsetDate
			s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
			s ALGCheckConflict=$P($g(^PAPER(+ID,"ALG",$P(ID,"||",2),"DHC")),"^",3)
			s ALGCheckConflict=##Class(websys.Conversions).YesNoLogicalToHtml(ALGCheckConflict)
			
			s %request.Data("ALGMRCCat",1)=MRCATDesc
			s %request.Data("CategoryRowId",1)=CategoryRowId
			s %request.Data("TagCode",1)=TagCode
			s %request.Data("ALGDescCT",1)=ALGDescCT
			s %request.Data("AllergenRowId",1)=AllergenRowId
			s %request.Data("ALGItem",1)=ALGItem
			s %request.Data("ALGItemRowId",1)=ALGItemRowId
			s %request.Data("MRCATTagDescription",1)=MRCATTagDescription //过敏源标志
			//s %request.Data("table",1)=table
			s %request.Data("ALGOnsetDate",1)=ALGDate
			s %request.Data("ALGComments",1)=Comments
			s %request.Data("ALGCheckConflict",1)=$g(ALGCheckConflict)
		    m ^Temp("Upgrade","web.DHCPAAllergy.GetAllergenDetails","%req")=%request.Data
			
		}
	}
	Q ""
}

ClassMethod GetALGStr(ARCIMRowid As %String, CategoryRowId As %String, TagCode As %String) As %String
{
	q:(ARCIMRowid="")||(ARCIMRowid'["||") ""
	s str=""
	;2020-06-28原医嘱项维护-过敏原维护配置已去掉
	/*s Rowid=0
	f  s Rowid=$o(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"ALG",Rowid)) q:(Rowid="")||(str'="")  d
	.s ALGRowId=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),"ALG",Rowid)),"^",3)
	.d GetALGInfo
	
	Q:(str'="") str*/
	///获取医嘱项关联的过敏源
	s AlgStr=##class(PHA.FACE.OUT.Com).GetAlgStrByArcim(ARCIMRowid,+$H)
	for i=1:1:$L(AlgStr,"^"){
		s ALGRowId=$P(AlgStr,"^",i)
		d GetALGInfo
		q:(str'="")
	}
	
	q str
GetALGInfo
	q:'$d(^PAC("ALG",ALGRowId))
	s DateForm=$p(^PAC("ALG",ALGRowId),"^",4)
	q:(DateForm'="")&&(+$h<DateForm)
	s DateTo=$p(^PAC("ALG",ALGRowId),"^",5)
	q:(DateTo'="")&&(+$h>DateTo)
	s ALGCode=$p(^PAC("ALG",ALGRowId),"^")
	s ALGDesc=$p(^PAC("ALG",ALGRowId),"^",2)
	s MRCATDesc="",MRCATTagDescription="",MRCATTagCode=""
	s ALGTypeDR=$p(^PAC("ALG",ALGRowId),"^",3)
	s:ALGTypeDR'="" MRCATDesc=$p(^MRC("AT",ALGTypeDR),"^",2),MRCATTagCode=$p(^MRC("AT",ALGTypeDR),"^",6) 
	q:(CategoryRowId'="")&&(CategoryRowId'=ALGTypeDR)
	q:(TagCode'="")&&(TagCode'=MRCATTagCode)
	s:MRCATTagCode'="" MRCATTagDescription=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",MRCATTagCode)
	s str=ALGDesc_"^"_ALGCode_"^"_MRCATDesc_"^"_MRCATTagDescription_"^"_MRCATTagCode_"^"_ALGRowId_"^"_ALGTypeDR
	q
}

}
