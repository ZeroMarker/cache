Class EPRmeta.TemplateCategory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxParentId On ParentID;

Index IdxCategoryProperty On CategoryProperty;

Property CategoryProperty As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

ClassMethod DeleteTemplateCategory(ATpCategoryID As %String) As %String
{
 if (##class(EPRmeta.TemplateCategory).%ExistsId(ATpCategoryID))	
 {
	 
	 //set objTpCategory= ##class(EPRmeta.TemplateCategory).%OpenId(ATpCategoryID)
	 
	 &SQL(Delete from EPRmeta.TemplateVersion
 where eprmeta.templateversion.TemplateID in
 (select EPRmeta.Template.ID from EPRmeta.Template,EPRmeta.TemplateCategory
 where EPRmeta.Template.TemplateCategoryID = EPRmeta.TemplateCategory.ID and 
 EPRmeta.TemplateCategory.ID=:ATpCategoryID))

 &SQl(Delete from EPRmeta.Template 
 where EPRmeta.Template.TemplateCategoryID  in
 (select EPRmeta.Template.TemplateCategoryID from  EPRmeta.Template,EPRmeta.TemplateCategory
 where EPRmeta.Template.TemplateCategoryID= EPRmeta.TemplateCategory.ID and 
 EPRmeta.TemplateCategory.ID=:ATpCategoryID))                
	  do ##class(EPRmeta.TemplateCategory).%DeleteId(ATpCategoryID)
	  
	  Quit "OK"
	   
	  
	  }
 elseif ('##class(EPRmeta.TemplateCategory).%ExistsId(ATpCategoryID))	  
 {
	Quit "OK"
	}
}

ClassMethod GetGCIDByParentID(AParentGroupID As %String, ACategoryProperty As %String) As %String
{
 New Result	 
 New NumCount

 &sql(SELECT Count(ID)
 into :NumCount
 FROM EPRmeta.TemplateCategory
 WHERE ParentID = :AParentGroupID
 And CategoryProperty = :ACategoryProperty)

 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EPRmeta.TemplateCategory
 WHERE ParentID = :AParentGroupID
 And CategoryProperty = :ACategoryProperty) 
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }


 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer,CategoryType:%String, CategoryProperty:%String,", SELECTMODE = "RUNTIME") [ SqlName = SP_TemplateCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount,CategoryType,CategoryProperty
 FROM EPRmeta.TemplateCategory
 ORDER BY ID
}

Query SELECTCategoryBYID(AID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer,CategoryType:%String, CategoryProperty:%String,", SELECTMODE = "RUNTIME") [ SqlName = SP_TemplateCategory_SELECTCategoryBYID, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount,CategoryType,CategoryProperty
 FROM EPRmeta.TemplateCategory
 Where ParentID= :AID
 ORDER BY ID
}

Storage Default
{
<Data name="TemplateCategoryDefaultData">
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
<Value name="6">
<Value>CategoryProperty</Value>
</Value>
<Value name="7">
<Value>CategoryType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.TemplateCategoryD</DataLocation>
<DefaultData>TemplateCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.TemplateCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.TemplateCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.TemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
