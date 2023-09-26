Class EMRservice.Ajax.databind Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("ACTION",1),"")

	if (action = "DataBaseCatalog")
	{
  		d ..DataBaseCatalog()
	}
	elseif(action = "dataBaseDeital")
	{
		s pId =  $Get(%request.Data("pId",1),"")
		d ..dataBaseDeital(pId)
	}
	elseif(action = "DataEMRCategory")
	{
		s result = ""
		s result = ##Class(EMRservice.BL.BLBindQuery).GetRecordCategoryJson()
		while (result.AtEnd = 0)
		{
			w $ZSTRIP(result.Read(32000),"*C")
		}
	}

	Quit $$$OK
}

/// Desc:       取绑定数据分类
/// Creator:	   candyxu
/// CreateDate: 2014-5-30
ClassMethod DataBaseCatalog()
{
	s json = ""
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLBindQuery:SelectAllQuery")
	d result.Execute()
	s count = 0
    while result.%Next()
    {
    	s json = json_"{"
		s json = json_"""ID"":"""_result.Data("ID")_""","
		s json = json_"""Name"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.BindQuery","Name",result.Data("Name"))_""","
		s json = json_"""ClassName"":"""_result.Data("ClassName")_"""," 
		s json = json_"""QueryName"":"""_result.Data("QueryName")_"""," 
		s json = json_"""Description"":"""_result.Data("Description")_""","
		s json = json_"""SingleResult"":"""_result.Data("SingleResult")_""""
		s json = json_"}"
		s json =json_","
		s count = count + 1
    }
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	w json
}

/// Desc:       取绑定数据字典明细
/// Creator:	   candyxu
/// CreateDate: 2014-5-30
ClassMethod dataBaseDeital(ApId As %String)
{
	s json = ""
	s result = ##class(%ResultSet).%New("EMRservice.BL.BLBindQuery:SelectFieldByQID")
	d result.Execute(ApId)
	s count = 0
    while result.%Next()
    {
    	s json = json_"{"
		s json = json_"""ID"":"""_result.Data("ID")_""","
		s json = json_"""Name"":"""_##class(EMRservice.HISInterface.Translation).GetTranByDesc("EMRmeta.BindField","Name",result.Data("Name"))_""","
		s json = json_"""FieldName"":"""_result.Data("FieldName")_"""," 
		s json = json_"""FieldType"":"""_result.Data("FieldType")_"""," 
		s json = json_"""Description"":"""_result.Data("Description")_""","
		s json = json_"""DicID"":"""_result.Data("DicID")_""","
		s json = json_"""ValueType"":"""_result.Data("ValueType")_""""
		s json = json_"}"
		s json =json_","
		s count = count + 1
    }
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	w json
}

}
