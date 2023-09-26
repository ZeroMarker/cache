Include webimport

IncludeGenerator webimport

Class web.ARCOrdSetDateItem Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 176;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "ITM_RowId";

Parameter SQLDESCRIPTION = "ITM_RowId";

Parameter SQLROWID = "ITM_RowId";

/// wanghc 
Query FindOSDateItems(SetDatItmid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN:%String,ItemNo:%String,arcimId:%String,Item:%String,Code:%String,qty:%String,visible:%String,BillItem:%String,DocItemNo:%String,Day:%String,PDNotes:%String,KJ:%String,Cal:%String,Prot:%String,TFat:%String,SFat:%String,Carb:%String,Sugar:%String,Sodium:%String,Fibre:%String,Other:%String")
{
}

ClassMethod FindOSDateItemsClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// wanghc
ClassMethod FindOSDateItemsExecute(ByRef QHandle As %Library.Binary, SetDateItmid As %String) As %Library.Status
{
	s (ID,ItemNo,arcimId,Item,Code,qty,visible,BillItem,DocItemNo,Day,PDNotes,KJ,Cal,Prot,TFat,SFat,Carb,Sugar,Sodium,Fibre,Other)=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	s setId=+SetDateItmid,dateId=$p(SetDateItmid,"||",2)
	s ID="" f  s ID=$o(^ARCOS(setId,"DATE",dateId,"ITM",ID)) q:ID=""  d
	.s obj=##class(User.ARCOrdSetDateItem).%OpenId(SetDateItmid_"||"_ID)
	.q:'$IsObject(obj)
	.s ItemNo=ID
	.s arcimId=obj.ITMARCIMDRGetObjectId()
	.s Item=obj.ITMARCIMDR.ARCIMDesc
	.s Code=obj.ITMARCIMDR.ARCIMCode
	.s qty=obj.ITMQty
	.s visible=obj.ITMVisible
	.;s BillItem=obj.		;不知道怎么取
	.;s DocItemNo=obj
	.;s Day=obj.
	.;s PDNotes=obj.
	.;KJ,Cal,Prot,TFat,SFat,Carb,Sugar,Sodium,Fibre,Other
	.s ^CacheTemp(repid,ind)=$lb(SetDateItmid_"||"_ID,ItemNo,arcimId,Item,Code,qty,visible,BillItem,DocItemNo,Day,PDNotes,KJ,Cal,Prot,TFat,SFat,Carb,Sugar,Sodium,Fibre,Other)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod FindOSDateItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
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

ClassMethod OSDateItemSave() As %Library.Status
{
}

/// wanghc 
ClassMethod OSEffDateSave() As %Library.Status
{
	s setId=%request.Get("DATEParRef")
	s dateId=%request.Get("DateID")
	s from=%request.Get("DATEDateFrom")
	s to=%request.Get("DATEDateTo")
	i +dateId'=0 s obj = ##class(User.ARCOrdSetDate).%OpenId(dateId)
	e  s obj = ##class(User.ARCOrdSetDate).%New(setId)
	d obj.DATEParRefSetObjectId(setId)
	s obj.DATEDateFrom=$zdh(from,4)
	s obj.DATEDateTo=$s(to'="":$zdh(to,4),1:"")
	s sc=obj.%Save(0)
	;s ^Temp("web.ARCOrdSetDateItem","OSEffDateSave")=$System.Status.GetErrorText(sc)
	s %response.ServerSideRedirect="websys.default.csp?WEBSYS.TCOMPONENT=ARCOrdSetDateItem.Find&Setid="_setId
	q
}

Query FindOSDateOS(SetDatItmid As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "HIDDEN,ItemSet")
{
}

ClassMethod FindOSDateOSClose(QHandle As %Library.Binary) As %Library.Status
{
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod FindOSDateOSExecute(ByRef QHandle As %Library.Binary, SetDateItmid As %String) As %Library.Status
{
	s (ID,ItemSet)=""
	s repid=$I(^CacheTemp)
	s ind=1
	s QHandle=$lb(0,repid,0)
	S setId=+SetDateItmid,dateId=$p(SetDateItmid,"||",2)
	s ID="" f  s ID=$o(^ARCOS(setId,"DATE",dateId,"OS",ID)) q:ID=""  d
	.s obj=##class(User.ARCOrdSetDateOS).%OpenId(SetDateItmid_"||"_ID)
	.q:'$IsObject(obj)
	.s ItemSet=obj.OSOrderSetDR_$c(1)_obj.OSOrderSetDR.ARCOSDesc	;第一位暂时写成id
	.s ^CacheTemp(repid,ind)=$lb(SetDateItmid_"||"_ID,ItemSet)
	.s ind=ind+1
	quit $$$OK
}

ClassMethod FindOSDateOSFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status
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

/// Log 61118 27-09-2006 Boc: get nutritional values
ClassMethod GetNutritionalValues(ArcItmID As %Library.String) As %Library.String
{
	;wanghc
	;ARCOrdSetDateItem.List.js-->ItemLookupHandler   
	;^EnergyKj^EnergyCal^ProteinG^TotalFatG^SaturatedFatsG^CarbohydratesG^SugarsG^SodiumMg^DietryFibreG^OtherG first piece is blank
	q "^^^^^^^^^^"		;先写死
}

}
