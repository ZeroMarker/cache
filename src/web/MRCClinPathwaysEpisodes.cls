Class web.MRCClinPathwaysEpisodes Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 94;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "EP_RowId";

Parameter SQLDESCRIPTION = "EP_Desc";

Parameter SQLROWID = "EP_RowId";

/// log 56894
ClassMethod SaveCycle(compref As %Library.String, EPRowId As %Library.String)
{
}

Query FindEpisodes(episdesc As %String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "EPDesc:%String")
{
SELECT EP_Desc
FROM SQLUser.MRC_ClinPathwaysEpisodes
WHERE 	EP_Desc  %STARTSWITH  :episdesc
ORDER BY EP_Desc
}

Query FindEpisodesByPathwayID(PathwayID As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "PathwayEpisodeID:%String,PathwayEpisodeDesc:%String,EPEpisode")
{
SELECT EP_RowId, EP_Desc, EP_Episode
FROM SQLUser.MRC_ClinPathwaysEpisodes
WHERE   EP_ParRef =:PathwayID
ORDER BY EP_RowId
}

}
