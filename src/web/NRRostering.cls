Class web.NRRostering Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 126;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetNurseRoster(WardID As %Library.String, ShiftIds As %Library.String)
{
	;wanghc pacward.wardsummary.csp
	s rtn="",ShiftIdsLen=$l(ShiftIds,"^")
	f i=(ShiftIdsLen-1):-1:1 d
	.s ShiftId = $p(ShiftIds,"^",i)
	.s item = "|"_WardID_"||"_$p(ShiftId,"|",2)_"||||||" 	;|13||62898||||||
	.s rtn = item_"^"_rtn
	s %request.Data("Params",1)=rtn
	q ""
}

ClassMethod websysSaveNRRostering(compref As %Library.String, Params As %Library.String, WardID As %Library.String, WSComments As %Library.String)
{
}

Parameter SQLCODE = "NR_RowId";

Parameter SQLDESCRIPTION = "NR_RowId";

Parameter SQLROWID = "NR_RowId";

}
