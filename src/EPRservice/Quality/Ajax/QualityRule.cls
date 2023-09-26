Class EPRservice.Quality.Ajax.QualityRule Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s ARuleDesc=$Get(%request.Data("ARuleDesc",1),"-1")
	s ARuleCodes=$Get(%request.Data("ARuleCodes",1),"-1")
	w ..GetRuleInfo(ARuleDesc,ARuleCodes)
	Quit $$$OK
}

/// w ##class(EPRservice.Quality.Ajax.QualityRule).GetRuleInfo(3)
ClassMethod GetRuleInfo(ARuleDesc As %String, ARuleCodes As %String = "") As %Status
{
	s result=##class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityRule:GetQualityRules")
	s sc = result.Execute(ARuleDesc,ARuleCodes)
	
	s jsons=##Class(%GlobalCharacterStream).%New()
	
	s count=0
	
	while(result.Next())
	{
		s json={}
		
		s json.RowID = result.Data("RowID")
		
		s json.RuleCode = result.Data("RuleCode")
		
		s json.RuleName = result.Data("RuleName")
		
		d jsons.Write(json.%ToJSON())
		
		d jsons.Write(",")
		
		s count = count+1	
		
	}
	
	s poolList=$e(jsons.Read(),1,*-1)
	
	s data = "["_poolList_"]"
	
	q data
}

}
