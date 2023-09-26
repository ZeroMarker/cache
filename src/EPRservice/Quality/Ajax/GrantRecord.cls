Class EPRservice.Quality.Ajax.GrantRecord Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s EpisodeID = $Get(%request.Data("EpisodeID",1),"")
	w ..GetGrantRecordJson(EpisodeID)
	Quit $$$OK
}

/// ##class(EPRservice.Quality.Ajax.GrantRecord).GetGrantRecordJson(1)
ClassMethod GetGrantRecordJson(EpisodeID As %String) As %String
{
	s RecordCategoryJson=##Class(EMRservice.BIEMRService).GetRecordCategory(EpisodeID)	
	s json = ""
 	s count = 0
	s JsonObj = {}.%FromJSON(RecordCategoryJson)
	//病历层
   	for iInstance=0:1:(JsonObj.%Size()-1)
	{
		s InstanceObj = JsonObj.%Get(iInstance)
		if ('InstanceObj.%IsDefined("children"))
		{
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""id"":"""_$replace(InstanceObj.%Get("id"),"||","-")_""","
			s json = json_"""creator"":"""_InstanceObj.%Get("creator")_""","
			s json = json_"""happendatetime"":"""_InstanceObj.%Get("happendate")_" "_InstanceObj.%Get("happentime")_""","
			s json = json_"""text"":"""_InstanceObj.%Get("text")_""""
			s json = json_"}"
			s count = count + 1		
		}else
		{
			s:(count '=0) json =json_","
			s json = json_"{"
			s json = json_"""id"":"""_$replace(InstanceObj.%Get("id"),"||","-")_""","
			s json = json_"""creator"":"""_InstanceObj.%Get("creator")_""","
			s json = json_"""happendatetime"":"""_InstanceObj.%Get("happendate")_" "_InstanceObj.%Get("happentime")_""","
			s json = json_"""text"":"""_InstanceObj.%Get("name")_""""
			s json = json_"}"
			s count = count + 1	
			s childrenObj=InstanceObj.%Get("children")
			for ichildren=0:1:(childrenObj.%Size()-1)
			{
				s children = childrenObj.%Get(ichildren)
				s:(count '=0) json =json_","
				s json = json_"{"
				s json = json_"""id"":"""_$replace(children.%Get("id"),"||","-")_""","
				s json = json_"""text"":"""_children.%Get("text")_""","
				s json = json_"""creator"":"""_children.%Get("creator")_""","
				s json = json_"""happendatetime"":"""_children.%Get("happendate")_" "_children.%Get("happentime")_""","
				s json = json_"""_parentId"":"""_InstanceObj.%Get("id")_""""
				s json = json_"}"
				s count = count + 1	
			}
		}   		
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
}

}
