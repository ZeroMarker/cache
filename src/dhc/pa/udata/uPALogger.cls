Class dhc.pa.udata.uPALogger Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uPALogger).Insert(1,2,3,4)
ClassMethod Insert(ELCode, ELPar, ELResult, ELDesc) As %String
{
	n (ELCode,ELPar,ELResult,ELDesc)
	
	s ELDesc = $zdt($h,3)		
	&SQL(INSERT INTO dhc_pa_inter.PALogger (PL_Code,PL_Par,PL_Result,PL_Desc) VALUES (:ELCode,:ELPar,:ELResult,:ELDesc))
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uPALoggerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
