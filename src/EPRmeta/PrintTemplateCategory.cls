Class EPRmeta.PrintTemplateCategory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

ClassMethod DeletePrintTemplateCategory(APTpCategoryID As %String) As %String
{
 if (##class(EPRmeta.PrintTemplateCategory).%ExistsId(APTpCategoryID))	
 {
	 
	 //set objTpCategory= ##class(EPRmeta.TemplateCategory).%OpenId(ATpCategoryID)
	 
	 &SQL(Delete from EPRmeta.PrintTemplateVersion
 where eprmeta.PrintTemplateVersion.PrintTemplateID in
 (select EPRmeta.PrintTemplate.ID from EPRmeta.PrintTemplate,EPRmeta.PrintTemplateCategory
 where EPRmeta.PrintTemplate.PrintTemplateCategoryID = EPRmeta.PrintTemplateCategory.ID and 
 EPRmeta.PrintTemplateCategory.ID=:APTpCategoryID))

 &SQl(Delete from EPRmeta.PrintTemplate 
 where EPRmeta.PrintTemplate.PrintTemplateCategoryID  in
 (select EPRmeta.PrintTemplate.PrintTemplateCategoryID from  EPRmeta.PrintTemplate,EPRmeta.PrintTemplateCategory
 where EPRmeta.PrintTemplate.PrintTemplateCategoryID= EPRmeta.PrintTemplateCategory.ID and 
 EPRmeta.PrintTemplateCategory.ID=:APTpCategoryID))                
	  do ##class(EPRmeta.PrintTemplateCategory).%DeleteId(APTpCategoryID)
	  
	  Quit "OK"
	   
	  
	  }
 elseif ('##class(EPRmeta.PrintTemplateCategory).%ExistsId(APTpCategoryID))	  
 {
	Quit "OK"
	}
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_PrintTemplateCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount
 FROM EPRmeta.PrintTemplateCategory
 ORDER BY ID
}

Storage Default
{
<Data name="PrintTemplateCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.PrintTemplateCategoryD</DataLocation>
<DefaultData>PrintTemplateCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.PrintTemplateCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.PrintTemplateCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.PrintTemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
