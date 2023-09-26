Class EPRservice.Quality.Ajax.GetPoolInfo Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s ruleId=$Get(%request.Data("ruleId",1),"-1")
	s structId=$Get(%request.Data("structId",1),"-1")
	
	d ..GetPoolInfo(ruleId,structId)
	
	Quit $$$OK
}

/// w ##class(EPRservice.Quality.Ajax.GetPoolInfo).GetPoolInfo(3)
ClassMethod GetPoolInfo(rule = "", struct = "")
{
	s result=##class(%ResultSet).%New("EPRservice.Quality.DataAccess.BOQualityPool:GetQualityPools")
	s sc = result.Execute(rule,struct)
	
	s jsons=##Class(%GlobalCharacterStream).%New()
	
	s count=0
	
	while(result.Next())
	{
		s json={}
		
		s json.rowId = result.Data("rowId")
		
		s json.title = result.Data("title")
		
		s json.structDesc = result.Data("structDesc")
		
		s json.active = result.Data("active")
		
		s json.score = result.Data("score")
		
		s vetograde=result.Data("vetoGrade")
		
		s:(result.Data("vetoGrade")=$c(0)) vetograde=""
		
		s json.vetoGrade = result.Data("vetoGrade")
		
		d:(count'=0) jsons.Write(",")
		
		d jsons.Write(json.%ToJSON())
		
		s count = count+1	
		
	}
	
	w "{""total"":"_count_",""rows"":["
	
	d jsons.Rewind()
	
	while(jsons.AtEnd=0){
		w jsons.Read()
	}
	
	w "]}"
}

}
