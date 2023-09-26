Class EPRservice.TPrivLogic.CategoryActLogic Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetTempByCacAndAct(parPatInfo As %Library.List, parCategoryId As %String, parAction As %String) As %String
{
	q:(($d(parCategoryId)=0) || (parCategoryId = "")) ""
	q:(($d(parAction)=0) || (parAction = "")) ""
	 
	 //依次取出parCategoryId下的模板,取得第一个具有权限的模板后返回
	 //Global方式实现
	 s resultTemplateId = ""
	 s curCategoryId = " "_parCategoryId
	 s curTemplateId = 0
	 s curTemplateId = $o(^DHCEPRM.TemplateI("IndexCategoryId",curCategoryId,curTemplateId))
	 WHILE (curTemplateId '= "") 
	 {
		s curResult = ##Class(EPRservice.TPrivLogic.TempActLogic).CanTempAct(curTemplateId, parAction, parPatInfo)
		 
		if (curResult = 1)
		{
			s resultTemplateId = curTemplateId
			quit
		}
		
  		s curTemplateId = $o(^DHCEPRM.TemplateI("IndexCategoryId",curCategoryId,curTemplateId))
	 }
	 
	 /*
	 // SQL方式实现
	 s resultTemplateId = ""
	 S result = ##class(%Library.ResultSet).%New()
     S sql = "SELECT ID FROM EPRmeta.Template WHERE TemplateCategoryID = ?"
     d result.Prepare(sql)
     d result.Execute(parCategoryId)
     
     While (result.Next()'=0)
	 {
        s curTemplateId = result.Data("ID")
        
        s curResult = ##Class(EPRservice.TPrivLogic.TempActLogic).CanTempAct(curTemplateId, parAction, parPatInfo)

		if (curResult = 1)
		{
			s resultTemplateId = curTemplateId
			quit
		}
	 }
	 */ 
	
	 q resultTemplateId
}

}
