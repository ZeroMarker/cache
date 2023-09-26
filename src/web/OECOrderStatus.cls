Include webimport

IncludeGenerator webimport

Class web.OECOrderStatus Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 165;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod DefGroupOrderStatus(Groupid As %String = "") As %String
{
}

Parameter SQLCODE = "OSTAT_Code";

Parameter SQLDESCRIPTION = "OSTAT_Desc";

Parameter SQLROWID = "OSTAT_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetCodeFromDescription(descr As %Library.String = "", RowID As %Library.String = "") As %Library.String
{
}

ClassMethod GetDescriptionFromCode(Code As %Library.String) As %Library.String
{
}

ClassMethod GetInitStatus(groupid As %String) As %String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpStatusBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", GroupID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpStatusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpStatusFetch ]
{
}

/// Iimplementation of LookUp Query for category depending on the groupID
ClassMethod LookUpStatusExecute(ByRef QHandle As %Library.Binary, Desc As %Library.String = "", GroupID As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpStatusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpStatusExecute ]
{
}

/// KM 14-Feb 2001: This is called from  the OEOrder.Edit.Profile.csp page and the epr.Chart.csp page.
/// It receives a listbuild item of Exclusive Status values and returns a delimited string of Inclusive Status Values,
/// Inclusive Status Text, All Status Values and All Status Text.
/// by wuqk 2011-06-05 
ClassMethod getStatus(stats As %Library.String, inclexcl As %Library.String = "Incl") As %Library.String
{
	;^OEC("OSTAT",{OSTAT_RowId}) 1,2
	;^OEC("OSTAT",0,"Code",$$ALPHAUP({OSTAT_Code}),{OSTAT_RowId})
	set matching=""
	if stats'=""{
		set stats=$zu(28,stats,6)
		if $d(^OEC("OSTAT",0,"Code",stats)){
			set ostid=$o(^OEC("OSTAT",0,"Code",stats,0))
			set matching=$p($g(^OEC("OSTAT",ostid)),"^",1,2)
		}
	}
	set:matching="" matching="^"
	set ostCode="",ostDesc=""
	set ostid=$o(^OEC("OSTAT",0))
	while ostid'=""{
		set ostCode=ostCode_$p($g(^OEC("OSTAT",ostid)),"^",1)_","
		set ostDesc=ostDesc_$p($g(^OEC("OSTAT",ostid)),"^",2)_","
		set ostid=$o(^OEC("OSTAT",ostid))
	}
	set:ostCode'="" ostCode=$e(ostCode,1,$l(ostCode)-1)
	set:ostDesc'="" ostDesc=$e(ostDesc,1,$l(ostDesc)-1)
	quit matching_"^"_ostCode_"^"_ostDesc
}

/// KM 6-Nov-2001: Calledfrom epr.CTProfileParams.Edit component
Query FindForListBox(stats) As %SQLQuery(CONTAINID = 0, ROWSPEC = "OSTATDesc:%String")
{
SELECT  OSTAT_Desc
FROM SQLUser.OEC_OrderStatus
WHERE (','_:stats_',') [ (','_(OSTAT_Code)_',')
}

Query FindUserGroupStatus(Desc As %Library.String, GroupID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "")
{
SELECT OSTAT_OrdStat_DR->OSTAT_Desc
FROM SQLUser.SS_GroupOrderStatus
WHERE OSTAT_ParRef = :GroupID
}

/// KM 6-Feb-2001: Called on the Order.Profile.csp page
Query List() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,OSTATCode:%String,OSTATDesc:%String,OSTATActivate:%String")
{
SELECT OSTAT_RowID, OSTAT_Code, OSTAT_Desc, OSTAT_Activate
FROM SQLUser.OEC_OrderStatus
}

Query LookUpStatus(Desc As %String, GroupID As %String) As %Library.Query(CONTAINID = 3, ROWSPEC = "OSTATDesc:%String,OSTATCode:%String,hidden:%String")
{
}

}
