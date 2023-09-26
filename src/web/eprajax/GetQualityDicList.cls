Class web.eprajax.GetQualityDicList Extends %CSP.Page
{

/// YHY
/// 2018-01-05
/// 质控查询科室列表
ClassMethod OnPage() As %Status
{
	s DicQuery = $Get(%request.Data("DicQuery",1),"")
	s AdmStatus = $Get(%request.Data("AdmStatus",1),"")
	s Action = $Get(%request.Data("Action",1),"")
	s LocId = $Get(%request.Data("LocId",1),"")
	//s ^tempyhy("AdmStatus")=AdmStatus_","_DicQuery_","_Action
    if ((AdmStatus="O")&&(Action="GetCTLocID")){
	    d ..GetOPCTLocID("E",DicQuery)
    }
    elseif ((AdmStatus="O")&&(Action="GetUserID")){
	    d ..GetDocID(LocId)
    }
    elseif (AdmStatus'="O") {
	    d ..GetCTLocID("E",DicQuery)
    }
    Quit $$$OK
}

/// Desc:获取科室ID、科室Name
/// d ##Class(web.eprajax.GetQualityDicList).GetCTLocID("E","")
ClassMethod GetCTLocID(AType As %String, ADicQuery As %String)
{
	s json = "["
	s TotalRowCount=0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetLocationList")
	d ds.Execute(AType,"",ADicQuery)
	While (ds.Next())
	{
		s json = json_"{ID:'"_$g(ds.Data("ID"))_"',"
		s json = json_"Name:'"_$g(ds.Data("Name"))_"'},"
		s TotalRowCount = TotalRowCount+1	
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	w "{"
    w "TotalCount:'"_TotalRowCount_"'"
    w ",data:"_json_"}"
}

/// Desc:获取科室ID、科室Name
/// d ##Class(web.eprajax.GetQualityDicList).GetOPCTLocID("E","")
ClassMethod GetOPCTLocID(AType As %String, ADicQuery As %String)
{
	s json = "["
	s TotalRowCount=0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.Location:GetOPLocationList")
	d ds.Execute(AType,"",ADicQuery)
	While (ds.Next())
	{
		s json = json_"{ID:'"_$g(ds.Data("ID"))_"',"
		s json = json_"Name:'"_$g(ds.Data("Name"))_"'},"
		s TotalRowCount = TotalRowCount+1	
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	w "{"
    w "TotalCount:'"_TotalRowCount_"'"
    w ",data:"_json_"}"
}

/// Desc:获取科室ID、科室Name
/// d ##Class(web.eprajax.GetQualityDicList).GetDocID("")
ClassMethod GetDocID(ALocID As %String)
{
	s json = "["
	s TotalRowCount=0
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataGather.SSUser:GetUserDataList")
	d ds.Execute("",ALocID)
	While (ds.Next())
	{
		if (ds.Data("UserID")'="") {
		s json = json_"{UserID:'"_$g(ds.Data("UserID"))_"',"
		s json = json_"UserDesc:'"_$g(ds.Data("UserDesc"))_"'},"
		s TotalRowCount = TotalRowCount+1
		}	
	}
    s json = $e(json, 1, $l(json)-1)
	s json = json_"]"
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	w "{"
    w "TotalCount:'"_TotalRowCount_"'"
    w ",data:"_json_"}"
}

}
