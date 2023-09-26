Class web.PAMother Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 172;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MOTH_RowId";

Parameter SQLDESCRIPTION = "MOTH_RowId";

Parameter SQLROWID = "MOTH_RowId";

Property dummy As %String(TRUNCATE = 1);

/// KM 24-Jul-2001
ClassMethod ExpDelivDateGet(id As %Library.String, DateLMP As %Library.String)
{
}

/// ab 19.03.03 32480 - returns string of babies patient id's & episode id's given a mother
/// zhouzq 2011.11.15 w ##class(web.PAMother).GetBabies(1692)
ClassMethod GetBabies(MotherID As %Library.String = "", PARAMS As %Library.String = "") As %Library.String
{
	n CurrHosp,MotherHosp,babies,episodes,count,per,preg
	s babies="",episodes="",count=0
	s adm=""
	f {
		s adm=$O(^PAADMi("Mother",MotherID,adm))
		if adm="" Quit
		s per=$P(^PAADM(adm),"^",1)
		i episodes="" s episodes=adm
		e  s episodes=episodes_"^"_adm
		
		if babies="" s babies=per
		e  s babies=babies_"^"_per
		s count=count+1
	}
	Q babies_"*"_episodes_"*"_count
}

ClassMethod GetMothDR(PatientId As %Library.String) As %Library.String
{
}

/// copies mother's temp addresses to baby
ClassMethod addr(id As %Library.String, mid As %Library.String)
{
}

/// defaulting fields from mother paperson record to baby fields
ClassMethod default(id As %Library.String)
{
}

/// saves mother as NOK for baby
ClassMethod nok(id As %Library.String, mid As %Library.String)
{
}

/// KM 23-Jul-2001: 
ClassMethod websysSave(compref As %String, id As %String, EpisodeID As %Library.String, PatientID As %Library.String)
{
}

}
