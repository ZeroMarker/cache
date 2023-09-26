Class web.NRCScheduleCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 200;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetCurrentShifts() As %Library.Stream
{
	;wanghc 20130319---->床位图床位统计 pacward.wardsummary.csp
	s curDate = +$h
	s %request.Data("prevShift",1) = "("_$zd(curDate-1)_")"
	s %request.Data("curShift",1) = "("_$zd(curDate)_")"
	s %request.Data("nextShift1",1) = "("_$zd(curDate+1)_")"
	s %request.Data("nextShift2",1) = "("_$zd(curDate+2)_")"
	s %request.Data("nextShift3",1) = "("_$zd(curDate+3)_")"
	s rtn = "|"_(curDate-1)_"^|"_curDate_"^|"_(curDate+1)_"^|"_(curDate+2)_"^|"_(curDate+3)_"^"
	quit rtn
}

Parameter SQLCODE = "SCHED_Code";

Parameter SQLDESCRIPTION = "SCHED_Desc";

Parameter SQLROWID = "SCHED_RowId";

}
