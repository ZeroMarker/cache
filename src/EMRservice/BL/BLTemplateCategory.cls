Class EMRservice.BL.BLTemplateCategory Extends %RegisteredObject
{

ClassMethod DeleteTemplateCategory(ATpCategoryID As %String) As %String
{
 if (##class(EMRmeta.TemplateCategory).%ExistsId(ATpCategoryID))	
 {
	 
	 //set objTpCategory= ##class(EMRmeta.TemplateCategory).%OpenId(ATpCategoryID)
	 
	 &SQL(Delete from EMRmeta.TemplateVersion
 where EMRmeta.templateversion.TemplateID in
 (select EMRmeta.Template.ID from EMRmeta.Template,EMRmeta.TemplateCategory
 where EMRmeta.Template.TemplateCategoryID = EMRmeta.TemplateCategory.ID and 
 EMRmeta.TemplateCategory.ID=:ATpCategoryID))

 &SQl(Delete from EMRmeta.Template 
 where EMRmeta.Template.TemplateCategoryID  in
 (select EMRmeta.Template.TemplateCategoryID from  EMRmeta.Template,EMRmeta.TemplateCategory
 where EMRmeta.Template.TemplateCategoryID= EMRmeta.TemplateCategory.ID and 
 EMRmeta.TemplateCategory.ID=:ATpCategoryID))                
	  do ##class(EMRmeta.TemplateCategory).%DeleteId(ATpCategoryID)
	  
	  Quit "OK"
	   
	  
	  }
 elseif ('##class(EMRmeta.TemplateCategory).%ExistsId(ATpCategoryID))	  
 {
	Quit "OK"
	}
}

ClassMethod GetGCIDByParentID(AParentGroupID As %String, APropertyCode As %String) As %String
{

 &sql(SELECT Count(ID)
 into :NumCount
 FROM EMRmeta.TemplateCategory
 WHERE ParentID = :AParentGroupID
 And PropertyCode = :APropertyCode)

 if ('NumCount=0)
 {
 &sql(SELECT ID
 into :Result
 FROM EMRmeta.TemplateCategory
 WHERE ParentID = :AParentGroupID
 And PropertyCode = :APropertyCode) 
	  }
 elseif (NumCount=0)
 {
	Quit "" 	 }


 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer,PropertyName:%String, PropertyCode:%String,", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount,PropertyName,PropertyCode
 FROM EMRmeta.TemplateCategory
 ORDER BY ID
}

Query SELECTCategoryBYID(AID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer,PropertyName:%String, PropertyCode:%String,", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_TemplateCategory_SELECTCategoryBYID, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount,PropertyName,PropertyCode
 FROM EMRmeta.TemplateCategory
 Where ParentID= :AID
 ORDER BY ID
}

}
