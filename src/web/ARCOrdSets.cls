Class web.ARCOrdSets Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 273;

Parameter SQLDATEFROM = "ARCOS_EffDateFrom";

Parameter SQLDATETO = "ARCOS_EffDateTo";

Parameter SQLCODE = "ARCOS_Code";

Parameter SQLDESCRIPTION = "ARCOS_Desc";

Parameter SQLROWID = "ARCOS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindItemsInSetClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindItemsInSetFetch ]
{
}

/// from $$getall^MVBARCOI
/// each PLIST(i) is an item in the set
/// as standing 17/10/01...
/// PLIST(i) is a $c(2) delimited string where each piece is.....
/// 1=		ARC_ItmMast rowid
/// 2=		ARC_OrdSetDateItem visible
/// 3=		ARC_ItmMast desc
/// 4=		ARC_ItmMast qty
/// 5=	always blank
/// 6=		ARC_OrdSets rowid
/// 7=		ARC_OrdSets desc
/// 8=		ARC_OrdSets labtrak testset
/// 9=		ARC_OrdSetDateItem childsub
/// 10=	??some sort of count
/// 11=		ARC_OrdSetDateItem linkdoctor
/// 	... below pieces belong to table ARC_OrdSetDateItem....
/// 12=		ITM_Durat_DR
/// 13=		ITM_Durat_DR->PHCDU_Code,
/// 14=		ITM_Freq_DR
/// 15=		ITM_Freq_DR->PHCFR_Code
/// 16=		ITM_Instruc_DR
/// 17=		ITM_Instruc_DR->PHCIN_Code
/// 18=		ITM_UOM_DR
/// 19=		ITM_UOM_DR->CTUOM_Code
/// 20=		ITM_DoseQty
/// 21=		ITM_NeedleGauge_DR
/// 22=		ITM_NeedleGauge_DR->NEDG_Desc
/// 23=		ITM_NeedleType_DR
/// 24=		ITM_NeedleType_DR->NEDT_Desc
/// 25=		ITM_Conditional
/// 26=	always blank
/// 27=		ITM_Durat_DR->PHCDU_Factor
/// 28=		ARC_OrdSetDateItem rowid
/// 29=		ITM_DayIncrement
/// 30=		notes
/// 31=		ITM_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_OrderType
/// 32=		ITM_ARCIM_DR->ARCIM_ItemCat_DR->ARCIC_OrdCat_DR
ClassMethod FindItemsInSetExecute(ByRef QHandle As %Library.Binary, ID As %Library.String) As %Library.Status
{
}

/// Default implementation of LookUp Query.
ClassMethod FindItemsInSetFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindItemsInSetExecute ]
{
}

Query FindItemsInSet(ID) As %Library.Query(CONTAINID = 0, ROWSPEC = "ARCItmMastID,ARCItmMastDesc,OEMessage")
{
}

/// wanghc 
Query FindOSEffDates(Setid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN:%String,EffectiveDates:%String,DATEDateFrom:%String,DATEDateTo:%String")
{
}

ClassMethod FindOSEffDatesClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// wanghc
ClassMethod FindOSEffDatesExecute(ByRef QHandle As %Library.Binary, Setid As %String) As %Library.Status
{
	s (ID,EffectiveDates,DATEDateFrom,DATEDateTo)=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ID="" f  s ID=$o(^ARCOS(Setid,"DATE",ID)) q:ID=""  d
	.s obj=##class(User.ARCOrdSetDate).%OpenId(Setid_"||"_ID)
	.q:'$IsObject(obj)
	.s DATEDateFrom=$s(obj.DATEDateFrom'="":$ZD(obj.DATEDateFrom,4),1:"")
	.s DATEDateTo=$s(obj.DATEDateTo'="":$ZD(obj.DATEDateTo,4),1:"")
	.s ^CacheTemp(repid,ind)=$lb(Setid_"||"_ID,DATEDateFrom_"-"_DATEDateTo,DATEDateFrom,DATEDateTo)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod FindOSEffDatesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
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

/// wanghc
Query FindOrderSet(Code As %String, Desc As %String, Subcat As %String, OrdCat As %String, ServGrp As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN:%String,OSCode:%String,OSDesc:%String,Category:%String,Subcategory:%String,ActiveDateFrom:%String,ActiveDateTo:%String,LTTestSetCode:%String,ServiceGroup:%String,Days:%String,Minutes:%String,Priority:%String,BillingGroup:%String,BillingSubGroup:%String,Duration:%String,Frequency:%String")
{
}

ClassMethod FindOrderSetClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 医嘱套查询
/// wanghc 
ClassMethod FindOrderSetExecute(ByRef QHandle As %Library.Binary, Code As %String, Desc As %String, Subcat As %String, OrdCat As %String, ServGrp As %String) As %Library.Status
{
	s (ID,OSCode ,OSDesc ,Category ,Subcategory ,ActiveDateFrom ,ActiveDateTo ,LTTestSetCode ,ServiceGroup ,Days ,Minutes ,Priority ,BillingGroup ,BillingSubGroup ,Duration ,Frequency )=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ID="" f  s ID=$o(^ARCOS(ID)) q:ID=""  d
	.s obj=##class(User.ARCOrdSets).%OpenId(ID)
	.q:'$IsObject(obj)
	.s OSCode=obj.ARCOSCode
	.q:(Code'="")&&(OSCode'[Code)
	.s OSDesc=obj.ARCOSDesc	
	.q:(Desc'="")&&(OSDesc'[Desc)
	.s Category= obj.ARCOSOrdCatDR.ORCATDesc
	.q:(OrdCat'="")&&(Category'=OrdCat)
	.s Subcategory=obj.ARCOSOrdSubCatDR.ARCICDesc
	.q:(Subcat'="")&&(Subcategory'=Subcat)
	.s ActiveDateFrom=obj.ARCOSEffDateFrom
	.s ActiveDateTo=obj.ARCOSEffDateTo
	.s LTTestSetCode=obj.ARCOSLabTrakTestSet
	.s ServiceGroup=obj.ARCOSServiceGroupDR.SGDesc
	.q:(ServGrp'="")&&(ServGrp'=ServiceGroup)
	.s Days=obj.ARCOSDays
	.s Minutes=obj.ARCOSMinutes 
	.s Priority=obj.ARCOSDefPriorityDR.OECPRDesc 
	.s BillingGroup=obj.ARCOSBillGroupDR.ARCBGDesc 
	.s BillingSubGroup=obj.ARCOSBillSubDR.ARCSGDesc
	.s Duration=obj.ARCOSDurationDR.PHCDUDesc1
	.s Frequency =obj.ARCOSFrequencyDR.PHCFRDesc1
	.s ^CacheTemp(repid,ind)=$lb(ID,OSCode ,OSDesc ,Category ,Subcategory ,ActiveDateFrom ,ActiveDateTo ,LTTestSetCode ,ServiceGroup ,Days ,Minutes ,Priority ,BillingGroup ,BillingSubGroup ,Duration ,Frequency )
	.s ind=ind+1
	quit $$$OK
}

ClassMethod FindOrderSetFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
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

ClassMethod RetainValues()
{
}

ClassMethod OrderSetLookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = OrderSetLookUpFetch ]
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// wanghc 
ClassMethod OrderSetLookUpExecute(ByRef QHandle As %Library.Binary, desc As %Library.String, cat As %String, subcat As %String) As %Library.Status
{
	s (Description,Code,HIDDEN)=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s ID="" f  s ID=$o(^ARCOS(ID)) q:ID=""  d
	.s obj=##class(User.ARCOrdSets).%OpenId(ID)
	.q:'$IsObject(obj)
	.s Code=obj.ARCOSCode
	.s Description=obj.ARCOSDesc	
	.q:(desc'="")&&(Description'[desc)
	.s Category= obj.ARCOSOrdCatDR.ORCATDesc
	.q:(cat'="")&&(Category'=cat)
	.s Subcategory=obj.ARCOSOrdSubCatDR.ARCICDesc
	.q:(subcat'="")&&(Subcategory'=subcat)
	.s ^CacheTemp(repid,ind)=$lb(Description,Code,ID)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod OrderSetLookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = OrderSetLookUpExecute ]
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

/// wanghc 
Query OrderSetLookUp(desc As %String, cat As %String, subcat As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
}

/// Log 61587
ClassMethod FindDietOrdersBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", GroupID As %Library.String = "", TYPE As %Library.String = "", OrderType As %Library.String = "") As %Library.Boolean
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

Query FindDietOrders(DietType As %Library.String, GroupID As %Library.String, TYPE As %String, OrderType As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "ARCIMDesc:%String,HIDDEN:%String,ARCIMCode:%String")
{
}

/// wanghc 通过子类拿分类
/// Log 61112 28-09-2006 BoC: get order category
ClassMethod GetCategory(SubcatID As %Library.String = "") As %Library.String
{
	n (SubcatID)
	q:+SubcatID=0 ""
	s obj=##class(User.ARCItemCat).%OpenId(SubcatID)
	q obj.ARCICOrdCatDR.ORCATDesc
	q $$$OK
}

/// wanghc 
/// log 62689 BoC 19-02-2007 check if desc and code exists before saving
ClassMethod SaveOrderSet(compref As %Library.String = "", ID As %Library.String = "")
{
	set compid=$e($p(compref,"i",1),2,999)
	Set ARCOSCode = $$ALPHAUP^SSUTIL4($g(%request.Data("ARCOSCode",1)))	
	Set ARCOSId = $o(^ARCOS(0,"Code",ARCOSCode,""))
	If (+ARCOSId>0){
		if (+ARCOSId'=ID){
			d msg.AddItem("E",$g(t("ARCOSCode"),"代码"), ARCOSCode_"已存在",compid,"ARCOSCode")
		}
	}else{
		d ..websysSave(compref,ID)
	}
	q 1
}

}
