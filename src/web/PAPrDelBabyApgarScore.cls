Class web.PAPrDelBabyApgarScore Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 48;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "PDBAS_RowId";

Parameter SQLDESCRIPTION = "PDBAS_RowId";

Parameter SQLROWID = "PDBAS_RowId";

//w ##class(web.PAPrDelBabyApgarScore).GetRowId

ClassMethod GetRowId(parref As %String, apgarNo As %String) As %String
{
    s ^TEMP("yl","PAPrDelBabyApgarScore")=parref_","_apgarNo
	s:parref="" parref=$g(%request.Data("PARREF",1))
	s:apgarNo="" apgarNO=$g(%request.Data("ApgarNo",1))

	q:($g(parref)=""||$g(apgarNo)="") ""
	&sql(select %id into:scoreID from SQLUser.PA_PrDelBabyApgarScore where PDBAS_ParRef=:parref and PDBAS_ApgarNo=:apgarNo)
	q $g(scoreID)
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
	set ^TEMP("PAPrDelBabyApgarScore","websysAfterSave")=id_","_new_","_$g(%request.Data("PARREF",1))
	set $zt="AfterSaveError"
	set scoreOBJ=##class(User.PAPrDelBabyApgarScore).%OpenId(id)
	set:%request.Get("PDBASHeartRate")'="" scoreOBJ.PDBASHeartRate=%request.Get("PDBASHeartRate")
	set:%request.Get("PDBASRespiration") scoreOBJ.PDBASRespiration=%request.Get("PDBASRespiration")
	set:%request.Get("PDBASTone") scoreOBJ.PDBASTone=%request.Get("PDBASTone")
	set:%request.Get("PDBASReflex") scoreOBJ.PDBASReflex=%request.Get("PDBASReflex")
	set:%request.Get("PDBASColour") scoreOBJ.PDBASColour=%request.Get("PDBASColour")
	set rs=scoreOBJ.%Save()
    /*
	s parref=$g(%request.Data("PARREF",1))
	if parref'="" {
	 set babyOBJ=##class(User.PAPregDelBaby).%OpenId(parref)
	do babyOBJ.BABYApgarScore4DRSetObjectId(?)
	 set babySave=babyOBJ.%Save()
	
	}
	*/
	q $$$OK
AfterSaveError
   set ^TEMP("yl","PAPrDelBabyApgarScore","Error",$h)=$ze
}

ClassMethod websysDeleteApgars(id As %String)
{
	d:id'="" ##class(User.PAPrDelBabyApgarScore).%DeleteId(id)
}

}
