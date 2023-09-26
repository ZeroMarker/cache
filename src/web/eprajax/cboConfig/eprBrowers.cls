Class web.eprajax.cboConfig.eprBrowers Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	set docId = ""
	set categoryName = ""
	set eprType = "["
	
	&sql(DECLARE MyCursor CURSOR FOR
 		SELECT ID,CategoryName INTO :docId, :categoryName 
 		FROM EPRmeta.EPRTemplateCategory WHERE ParentCategoryID = 0)
	
		&sql(OPEN MyCursor)
		for {
			&SQL(FETCH MyCursor) 
 			Q:SQLCODE 			
 			set eprType = eprType_"['"_docId_"','"_categoryName_"']," 
 			
		}
		&sql(close MyCursor)
	
	set eprType = $E(eprType, 1, $Length(eprType) - 1)
	set eprType = eprType _ "]"
	w eprType
	
	Quit $$$OK
}

}
