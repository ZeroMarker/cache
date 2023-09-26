Include webimport

IncludeGenerator webimport

Class web.ARCItemCat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 918;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Query LookUpSubCatByDesc(Desc As %String = "") As %SQLQuery(CONTAINID = "", ROWSPEC = "ARCICDesc:%String,HIDDEN:%String,ARCICCode:%String")
{
SELECT ARCIC_Desc,ARCIC_RowID,ARCIC_Code
FROM ARC_ItemCat
WHERE (ARCIC_Desc %STARTSWITH :Desc)
ORDER BY ARCIC_Desc
}

Parameter SQLCODE = "ARCIC_Code";

Parameter SQLDESCRIPTION = "ARCIC_Desc";

Parameter SQLROWID = "ARCIC_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod FindDietOrdersBroker(itmjs As %String = "", itmjsex As %String = "", DietType As %String = "", GroupID As %String = "", TYPE As %String = "", OrderType As %String = "") As %Library.Boolean
{
}

ClassMethod FindDietOrdersClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietOrdersFetch ]
{
}

ClassMethod FindDietOrdersExecute(ByRef QHandle As %Library.Binary, DietType As %Library.String = "", GroupID As %Library.String = "", TYPE As %Library.String = "", OrderType As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietOrdersFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietOrdersExecute ]
{
}

ClassMethod FindPatientReqMealAssistance(PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod FindPatientReqMenuAssistance(PatientID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod GetDietComments(EpisodeID As %Library.String) As %Library.String
{
}

/// Receive specimen flag from the order subcatory.
ClassMethod GetOverRidePriceFlag(ItmMast As %Library.String = "") As %Library.String
{
}

/// Receive specimen flag from the order subcatory.
ClassMethod GetPriCodeFromDesc(code As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpBrokerByCategory(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", Category As %Library.String = "", SSGroupID As %Library.String = "") As %Library.Boolean
{
	s txt=""
	s rs=##class(%ResultSet).%New("web.ARCItemCat","LookUpByCategory")
	d rs.Execute(val,Category,SSGroupID)
	While (rs.Next()) {
		s desc=rs.Data(1)
		s rowid=rs.Data(2)
		s code=rs.Data(3)
		s txt=desc_"^"_rowid_"^"_code
		Quit
	}
	i txt="" Quit 1
	s retval=itmjs_"('"_$ZCVT(txt,"O","JS")_"');"
	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(txt,"O","JS")_"');"
	&javascript<#(retval)#>
	q 1
}

ClassMethod LookUpBrokerSubCategory(itmjs As %Library.String = "", itmjsex As %Library.String = "", Desc As %String = "", catcodes As %String = "") As %Library.Boolean
{
}

/// ab 28.06.05 - 53545 - broker to match FindSubCat query
ClassMethod FindSubCatBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Category As %String = "", SubcatDesc As %String = "", catcodes As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpByCategoryClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByCategoryFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Iimplementation of LookUp Query restricting by the Category desc (OECOrderCategory) and 
/// the User's Security Group id (SSGroup) ordered by the Subcategory Description
/// Category Desc must be a match.
ClassMethod LookUpByCategoryExecute(ByRef QHandle As %Library.Binary, SubCategory As %String = "", Category As %Library.String = "", SSGroupID As %Library.String = "", CMFlag As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	s (subCatDesc,subCatRowID,subCatCode)=""
	;Category, SubCategory, EpisodeID, OrdCatGrp
	s repid=$I(^CacheTemp)
	s ind=0
	s QHandle=$lb(0,repid,0)
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItemCat",HospID)
	if (CMFlag'=""){
		s CNMedItemCatStr=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
		i CNMedItemCatStr'="" s CNMedItemCatStr="^"_CNMedItemCatStr_"^"
	}
	s subCatRowID="" f  s subCatRowID=$o(^ARC("IC",subCatRowID)) q:subCatRowID=""  d
	.q:##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",subCatRowID,DefHospId)="N"
	.Q:(CMFlag="CM")&&(CNMedItemCatStr'[("^"_subCatRowID_"^"))
	.Q:(CMFlag="XY")&&(CNMedItemCatStr[("^"_subCatRowID_"^"))
	.s obj=##class(User.ARCItemCat).%OpenId(subCatRowID)
	.q:'$IsObject(obj)
	.s cate=obj.ARCICOrdCatDR.ORCATDesc
	.q:(Category'="")&&(cate'=Category)
	.s subCatDesc=obj.ARCICDesc
	.s subCatCode=obj.ARCICCode	
	.q:(SubCategory'="")&&(subCatDesc'[SubCategory)&&(subCatCode'[SubCategory)
	.s CategoryID=obj.ARCICOrdCatDRGetObjectId()
	.&SQL(Select SSORD_RowId into :zid 
		From SQLUser.SS_GroupOrderCategory 
		Where SSORD_ParRef=:SSGroupID and 
		((SSORD_OrdCat_DR=:CategoryID and SSORD_OrdSubCategory is Null) or 
		(SSORD_OrdCat_DR=:CategoryID and SSORD_OrdSubCategory=:subCatRowID)))
	.Quit:SQLCODE
	.s ind=ind+1
	.s ^CacheTemp(repid,ind)=$lb(subCatDesc,subCatRowID,subCatCode)
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByCategoryFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByCategoryExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpSubCatBroker(itmjs As %String = "", itmjsex As %String = "", Category As %String = "", SubCategory As %String = "", EpisodeID As %String = "", OrdCatGrp As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpSubCatClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSubCatFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Iimplementation of LookUp Query for category depending on the groupID
/// d ##class(%ResultSet).RunQuery("web.ARCItemCat","LookUpSubCat","","jc","","")
ClassMethod LookUpSubCatExecute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SubCategory As %String = "", EpisodeID As %Library.String = "", OrdCatGrp As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	s (subCatDesc,subCatRowID,subCatCode)=""
	;Category, SubCategory, EpisodeID, OrdCatGrp
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s subCatRowID="" f  s subCatRowID=$o(^ARC("IC",subCatRowID)) q:subCatRowID=""  d
	.s obj=##class(User.ARCItemCat).%OpenId(subCatRowID)
	.q:'$IsObject(obj)
	.s cate=obj.ARCICOrdCatDR.ORCATDesc
	.q:(Category'="")&&(cate'=Category)
	.s subCatDesc=obj.ARCICDesc
	.s subCatCode=obj.ARCICCode	
	.b ;subCatCode subCatRowID
	.q:(SubCategory'="")&&(subCatDesc'[SubCategory)&&(subCatCode'[SubCategory)
	.;EpisodeID -->这三个没用到  -->有需求再加
	.s OCGroup=obj.ARCICOrdCatDR.ORCATOCGroupDR.OCGRPDesc
	.q:(OrdCatGrp'="")&&(OCGroup'[OrdCatGrp)
	.s ^CacheTemp(repid,ind)=$lb(subCatDesc,subCatRowID,subCatCode)
	.s ind=ind+1
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpSubCatFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSubCatExecute ]
{
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}Else{				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Receive specimen flag from the order subcatory.
ClassMethod SpecReceiveFlag(arcim As %Library.String = "")
{
}

ClassMethod UpdateMealMenuAssist(PatientID As %Library.String = "", ALGRequireAssistanceMeal As %Library.String = "", ALGRequireAssistanceMenu As %Library.String = "")
{
}

Query Find(Code As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCICOrderType:%String,ARCICCode:%String,ARCICDesc:%String")
{
SELECT ARCIC_ROWID, ARCIC_OrderType, ARCIC_Code, ARCIC_Desc
FROM ARC_ItemCat
WHERE (ARCIC_Code %STARTSWITH :Code)
ORDER BY ARCIC_Code
}

Query FindByCategory(catid As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCICDesc:%String")
{
SELECT ARCIC_Rowid, ARCIC_Desc
FROM ARC_ItemCat
WHERE (ARCIC_OrdCat_DR = :catid)
ORDER BY ARCIC_Desc
}

Query FindByDesc(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ARCIMCode:%String")
{
SELECT ARCIM_Code
FROM ARC_ItmMast
WHERE (ARCIM_Desc = :desc)
}

Query FindDietOrders(DietType As %Library.String, GroupID As %Library.String, TYPE As %String, OrderType As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query FindDietSubCateory(OrderType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ARCICRowId:%String")
{
SELECT ARCIC_RowId 
FROM SQLUser.ARC_ItemCat
WHERE (ARCIC_OrderType=:OrderType)
}

Query FindSubCat(Category As %String, SubCategory As %String, catcodes As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SubCatDesc,SubCatRowID,SubCatCode")
{
SELECT ARCIC_Desc,ARCIC_RowId,ARCIC_Code
FROM SQLUser.ARC_ItemCat
WHERE ((ARCIC_OrdCat_DR->ORCAT_RowId =:Category) OR (:Category IS NULL))
AND (({fn CONCAT( '^', {fn CONCAT((:catcodes),'^')})} [ {fn CONCAT( '^', {fn CONCAT((ARCIC_OrdCat_DR->ORCAT_Code),'^')})}) OR (:catcodes IS NULL))
AND ((ARCIC_Desc %STARTSWITH :SubCategory) OR (ARCIC_Code = :SubCategory) OR(:SubCategory IS NULL))
}

/// Restriction based on groupid.
Query FindSubCatRestriction(GroupID As %Library.String, Category As %Library.String, SubCategory As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SubCatDesc,SubCatRowID,SubCatCode")
{
SELECT SSORD_OrdSubCategory->ARCIC_Desc,SSORD_OrdSubCategory->ARCIC_RowId,SSORD_OrdSubCategory->ARCIC_Code
FROM SQLUser.SS_GroupOrderCategory
WHERE (SSORD_ParRef=:GroupID)
AND ((SSORD_OrdCat_DR->ORCAT_RowId=:Category) OR (:Category IS NULL))
AND ((SSORD_OrdSubCategory->ARCIC_Desc %STARTSWITH :SubCategory) OR (SSORD_OrdSubCategory->ARCIC_Code=:SubCategory)OR (:SubCategory IS NULL))
}

Query List() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARCICDesc:%String")
{
SELECT ARCIC_Rowid, ARCIC_Desc
FROM ARC_ItemCat
}

/// Iimplementation of LookUp Query restricting by the Category desc (OECOrderCategory) and 
/// the User's Security Group id (SSGroup) ordered by the Subcategory Description
/// Category Desc must be a match.
Query LookUpByCategory(SubCategory As %Library.String, Category As %Library.String, SSGroupID As %Library.String, CMFlag As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "desc:%String,HIDDEN:%String,code:%String")
{
}

Query LookUpEnteralItems(EnteralDesc As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ARCICDesc:%String,HIDDEN:%String,ARCICCode:%String")
{
SELECT DISTINCT OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItmMast_DR->ARCIM_RowID,OEORI_ItmMast_DR->ARCIM_Code
FROM SQLUser.OE_OrdItem
WHERE (OEORI_ItmMast_DR->ARCIM_ItemCat_DR->ARCIC_OrderType='E')
ORDER BY OEORI_ItmMast_DR->ARCIM_Desc
}

Query LookUpSubCatRes(Category As %String, SubCategory As %String, EpisodeID As %String, OrdCatGrp As %String, GroupID As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "subcatDesc:%String,HIDDEN:%String,Code:%String")
{
}

ClassMethod LookUpSubCatResBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", Category As %String = "", val As %String = "", EpisodeID As %String = "", OrdCatGrp As %String = "", GroupID As %String = "") As %Library.Boolean
{
}

ClassMethod LookUpSubCatResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSubCatResFetch ]
{
}

/// Iimplementation of LookUp Query for category depending on the groupID
ClassMethod LookUpSubCatResExecute(ByRef QHandle As %Library.Binary, Category As %String = "", SubCategory As %String = "", EpisodeID As %String = "", OrdCatGrp As %String = "", GroupID As %String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpSubCatResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpSubCatResExecute ]
{
}

/// by wanghc
/// lookup site specific for RIE
/// done for log 21900 GR
Query LookUpSubCat(Category As %Library.String, SubCategory As %Library.String, EpisodeID As %Library.String, OrdCatGrp As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "subCatDesc:%String,subCatRowID:%String,subCatCode:%String")
{
}

Query LookUpSubCategory(Desc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "ARCICDesc:%String,HIDDEN:%String,ARCICCode:%String")
{
SELECT ARCIC_Desc,ARCIC_RowID,ARCIC_Code
FROM ARC_ItemCat
WHERE (ARCIC_Desc %STARTSWITH :Desc) AND (ARCIC_OrderType='D')
ORDER BY ARCIC_Desc
}

Query FindOSEffDates(Setid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN:%String,EffectiveDates:%String")
{
}

ClassMethod FindOSEffDatesClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindOSEffDatesExecute(ByRef QHandle As %Library.Binary, Setid As %String) As %Library.Status
{
}

ClassMethod FindOSEffDatesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

Query FindOSDateItems(SetDateItmid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN:%String,ItemNo:%String,arcimId:%String,Item:%String,Code:%String,qty:%String,visible:%String,BillItem:%String,DocItemNo:%String,Day:%String,PDNotes:%String")
{
}

ClassMethod FindOSDateItemsClose(QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindOSDateItemsExecute(ByRef QHandle As %Library.Binary, SetDateItmid As %String) As %Library.Status
{
}

ClassMethod FindOSDateItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
{
}

Query DSubCategory(Category As %String, SubCategory As %String, EpisodeID As %String, OrdCatGrp As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "ARCICDesc:%String,HIDDEN:%String,ARCICCode:%String")
{
	SELECT ARCIC_Desc,ARCIC_RowId,ARCIC_Code
	FROM SQLUser.ARC_ItemCat	
	WHERE ((ARCIC_OrdCat_DR->ORCAT_Desc=:Category) OR (:Category IS NULL))	
	AND ((ARCIC_Desc %STARTSWITH :SubCategory))
	AND ((ARCIC_OrdCat_DR->ORCAT_OCGroup_DR->OCGRP_Desc=:OrdCatGrp) OR (:OrdCatGrp IS NULL))		
	ORDER BY ARCIC_Desc
}

}
