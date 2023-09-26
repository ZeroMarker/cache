Include webimport

IncludeGenerator webimport

Class web.CFSystemFileDefinition Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 140;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetFileName(type As %Library.String = "") As %Library.String
{
}

/// Log 54998 YC - Gets Unix Virtual Directory from File Format (file extension)
/// CT->System Management->File Path Definition->Unix Path for Selected File Types
ClassMethod GetUnixVirtualDir(FileFormat As %String = "")
{
}

ClassMethod GetWindowsVirtualDir(FileFormat As %String = "")
{
}

/// returns an array of virtual directoriies by file extension.
/// 
/// KM 22-Feb-2001: Called From web.MRAdm:ResultsExecute
/// 
ClassMethod GetVirtualDirectories(ByRef vdir As %Library.String) As %Library.String
{
}

Parameter SQLCODE = "FILE_RowId";

Parameter SQLDESCRIPTION = "FILE_Desc";

Parameter SQLROWID = "FILE_RowId";

/// KM 18-Apr-2001: Called From GetVirtualDirectories method
/// This method is called from web.MRAdm.ResultsExecute
Query Find() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,FILEFileExtension:%String,FILEVirtualDirectory:%String,FILEType:%String,FILEDesc:%String")
{
SELECT FILE_RowID, FILE_FileExtension, FILE_VirtualDirectory, FILE_Type, FILE_Desc
FROM SQLUser.CF_SystemFileDefinition
WHERE (FILE_Type = 'RW')
}

}
