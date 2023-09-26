Class EPRmeta.FPInterface.TestUnit Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// d ##class(EPRmeta.FPInterface.TestUnit).InitCategoryIDToChartItemID()

ClassMethod InitCategoryIDToChartItemID()
{
	 Set rset = ##class(%ResultSet).%New("EPRmeta.FPInterface.TestUnit:SelectCTIconProfile")
	 Set sc = rset.Execute()
	 
	 While (rset.Next()) {
	    s curPPParameters = rset.GetData(2)
	    w curPPParameters,"=",rset.GetData(1),!
	    if ($d(curPPParameters) = 0){s curPPParameters = ""}
	    if ($l(curPPParameters,",") = 3)
	    {
		 	s ^EPRCatIDToChartID($p(curPPParameters, ",", 2)) =  rset.GetData(1)  
		}   
	 }
	 Do rset.Close()
}

Query SelectCTIconProfile() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,PPParameters:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_SelectCTIconProfile_SELECTALL, SqlProc ]
{
 SELECT ID, PPParameters
 FROM epr.CTProfileParams
}

}
