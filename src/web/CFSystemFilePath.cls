Class web.CFSystemFilePath Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 130;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetFilePath(extn As %Library.String, type As %Library.String) As %Library.String
{
}

/// SA: About May-2001: Method creates the %request.Get("SaveFilePath") variable for use in 
/// saving word documents.
/// KM 7-Aug-2001: This Method called from MRPictures.GetDataFromIdAndType() and uses the vdir variable.
ClassMethod GetPathFromFileExt(FileExt As %Library.String)
{
}

Parameter SQLCODE = "PATH_RowId";

Parameter SQLDESCRIPTION = "PATH_RowId";

Parameter SQLROWID = "PATH_RowId";

Query FindByFileExtension(FileExt As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Path:%Library.String")
{
SELECT PATH_Path
FROM SQLUser.CF_SystemFilePath
WHERE PATH_ParRef->FILE_FileExtension=:FileExt
}

/// Routine especially for the palm pilot
/// - do not change (and preferably do not use) unless for the palm pilot
/// 
Query FindPathByFileId(RowId As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,PATHPath:%String")
{
SELECT PATH_RowId,PATH_Path
FROM SQLUser.CF_SystemFilePath
WHERE PATH_ParRef=:RowId
}

}
