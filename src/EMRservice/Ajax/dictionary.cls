/// 属性字典服务
Class EMRservice.Ajax.dictionary Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	if (action = "getStdDic")
	{
		w ..getStdDic()
	}
	Quit $$$OK
}

//Desc:       取字典维护表数据

//Creator:    Candy

//Createdate: 2014-5-26

//Debug: w ##Class(EMRservice.Ajax.dictionary).getStdDic()

ClassMethod getStdDic() As %String
{
	s json = ""
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLStdDictionary:SELECTALL")
	d result.Execute()
	s count = 0
	while result.%Next() 
	{
		s:(count '= 0) json = json_","
		s json = json_"{"
		s json = json_"""ID"":"""_result.Data("ID")_""","
		s json = json_"""Code"":"""_result.Data("Code")_""","
		s json = json_"""Name"":"""_result.Data("Name")_"""," 
		s json = json_"""Description"":"""_result.Data("Description")_"""" 
		s json = json_"}"
		s count = count +1
	}
	q "["_json_"]"
}

}
