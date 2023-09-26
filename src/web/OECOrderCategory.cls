Include webimport

IncludeGenerator webimport

Class web.OECOrderCategory Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 408;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ORCAT_Code";

Parameter SQLDESCRIPTION = "ORCAT_Desc";

Parameter SQLROWID = "ORCAT_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerBySSGroup(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SSGRP As %Library.String = "") As %Library.Boolean
{
	s txt=""
	s rs=##class(%ResultSet).%New("web.OECOrderCategory","LookUpBySSGroup")
	d rs.Execute(val,SSGRP)
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

ClassMethod LookUpBySSGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySSGroupFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Iimplementation of LookUp Query for category depending on the user security group ID (SSGroup).
/// Categories are ordered by description
ClassMethod LookUpBySSGroupExecute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SSGRP As %Library.String = "") As %Library.Status
{
	s (catDesc,ID,Code)=""
	;Category, SSGRP, FilterBy, EpisodeID, OrdCatGrp
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("OEC_OrderCategory",HospID)
	s ID="" f  s ID=$o(^OEC("ORCAT",ID)) q:ID=""  d
	.q:##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("OEC_OrderCategory",ID,DefHospId)="N"
	.s obj=##class(User.OECOrderCategory).%OpenId(ID)
	.q:'$IsObject(obj)
	.s Code=obj.ORCATCode
	.s catDesc=obj.ORCATDesc	
	.q:(Category'="")&&(Code'[Category)&&(catDesc'[Category)
	.&SQL(Select SSORD_RowId into :zid From SQLUser.SS_GroupOrderCategory Where SSORD_ParRef=:SSGRP and SSORD_OrdCat_DR=:ID)
	.Q:SQLCODE
	.s ^CacheTemp(repid,ind)=$lb(catDesc,ID,Code)
	.s ind=ind+1
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpBySSGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySSGroupExecute ]
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

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpCatBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", SSGRP As %Library.String = "", FilterBy As %Library.String = "", EpisodeID As %Library.String = "", OrdCatGrp As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpCatClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCatFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// wanghc
/// Iimplementation of LookUp Query for category depending on the groupID
ClassMethod LookUpCatExecute(ByRef QHandle As %Library.Binary, Category As %Library.String = "", SSGRP As %Library.String = "", FilterBy As %Library.String = "", EpisodeID As %Library.String = "", OrdCatGrp As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	s (catDesc,ID,Code)=""
	;Category, SSGRP, FilterBy, EpisodeID, OrdCatGrp
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ID="" f  s ID=$o(^OEC("ORCAT",ID)) q:ID=""  d
	.s obj=##class(User.OECOrderCategory).%OpenId(ID)
	.q:'$IsObject(obj)
	.s Code=obj.ORCATCode
	.s catDesc=obj.ORCATDesc	
	.q:(Category'="")&&(Code'[Category)&&(catDesc'[Category)
	.; SSGRP, FilterBy, EpisodeID -->这三个没用到  -->有需求再加
	.s OCGroup=obj.ORCATOCGroupDR.OCGRPDesc
	.q:(OrdCatGrp'="")&&(OCGroup'[OrdCatGrp)
	.s ^CacheTemp(repid,ind)=$lb(catDesc,ID,Code)
	.s ind=ind+1
	quit $$$OK
}

/// Default implementation of LookUp Query.
ClassMethod LookUpCatFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCatExecute ]
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

Query Find(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ORCATCode:%String,ORCATDesc:%String")
{
SELECT ORCAT_RowID, ORCAT_Code, ORCAT_Desc
FROM OEC_OrderCategory
WHERE (ORCAT_RowID = :ID)
}

Query FindByDesc(desc As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ORCATCode:%String,ORCATDesc:%String")
{
SELECT ORCAT_RowID, ORCAT_Code, ORCAT_Desc
FROM OEC_OrderCategory
WHERE (ORCAT_Desc = :desc)
}

Query List() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ORCATCode:%String,ORCATDesc:%String,ORCATOrderSeqNo:%Float,ORCATRepeatInOrder:%String")
{
SELECT ORCAT_RowID, ORCAT_Code, ORCAT_Desc, ORCAT_OrderSeqNo, ORCAT_RepeatInOrder
FROM OEC_OrderCategory
}

/// Iimplementation of LookUp Query for category depending on the user security group ID (SSGroup).
/// Categories are ordered by description
Query LookUpBySSGroup(Category As %Library.String, SSGRP As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

/// by wanghc
/// lookup site specific for RIE
/// done for log 21900 GR
Query LookUpCat(Category As %Library.String, SSGRP As %Library.String, FilterBy As %Library.String, EpisideID As %Library.String, OrdCatGrp As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "catDesc:%String,HIDDEN:%String,Code:%String")
{
}

/// Hardware,EnterealFeed,Thickened Fluid and Supplements for OEOrder.DietOrders
Query LookupDietCategories(val As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String,OrderType:%String")
{
SELECT OEC_OrderCategory.ORCAT_Desc,OEC_OrderCategory.ORCAT_RowId,OEC_OrderCategory.ORCAT_Code,ARC_ItemCat.ARCIC_OrderType
FROM OEC_OrderCategory, ARC_ItemCat
Where (ORCAT_Code='DEFS' OR ORCAT_CODE='HWS' OR ORCAT_Code='THK'
OR ORCAT_Code='SU') AND ((ORCAT_Code=:val) OR (ORCAT_DESC %STARTSWITH :val) OR (:val is null))
AND OEC_OrderCategory.ORCAT_Code=ARC_ItemCat.ARCIC_Code
ORDER BY ORCAT_Desc ASC
}

}
