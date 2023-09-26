Class EMRservice.Ajax.getDictionaryData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s DicCode = $Get(%request.Data("DicCode",1),"")
	s Alias = $Get(%request.Data("Alias",1),"")
	s Code = $Get(%request.Data("Code",1),"")
	s Desc = $Get(%request.Data("Desc",1),"")
	
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s:(page = 1) idxStart = page,idxLast = idxStart + rows -1	
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	
	w ..getDictionaryDataByDicCode(DicCode,Alias,Code,Desc,idxStart,idxLast)
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.getDictionaryData).getDictionaryDataByDicCode("S11","","","","1","100")
ClassMethod getDictionaryDataByDicCode(ADicCode As %String, Alias As %String, Code As %String, Desc As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:GetStdDicListByOr")
	s sc = result.Execute(ADicCode,Alias,Code,Desc,"1","100000")
 	
 	s json = ""
 	s count = 0
	While (result.Next())
 	{
	 	if ( AIdxStart-1 <= count) && (AIdxLast > count )
		{
		 	s json = json_"{""ID"":"""_$g(result.Data("ID"))_""","
		 	s json = json_"""Alias"":"""_$g(result.Data("Alias"))_""","
		 	s json = json_"""Code"":"""_$g(result.Data("Code"))_""","
		 	s json = json_"""DicDesc"":"""_$g(result.Data("DicDesc"))_"""}"
		 	s json = json_"," 
	 	}
		s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	
	s ret = "{""total"":"_count_",""rows"":["_json_"]}"
	q ret
}

}
