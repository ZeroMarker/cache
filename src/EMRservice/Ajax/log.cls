Class EMRservice.Ajax.log Extends %CSP.Page
{

/// w ##Class(EMRservice.Ajax.log).OnPage()
ClassMethod OnPage() As %Status
{
	s userId = $Get(%request.Data("UserID",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s emrAction = $Get(%request.Data("EMRAction",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s intanceId = $Get(%request.Data("IntanceID",1),"")
    s emrDocId = $Get(%request.Data("EMRDocID",1),"")
    s happenDate = $Get(%request.Data("HappenDate",1),"")
    s:(happenDate '= "") happenDate = $zdh(happenDate,3)
    s happenTime = $Get(%request.Data("HappenTime",1),"")
    s:(happenTime '= "") happenTime = $zth(happenTime,3)
    s ipAddress =  $Get(%request.Data("IPAddress",1),"")
    s docType = $Get(%request.Data("DocType",1),"")
    s emrNum = $p(intanceId,"||",2)
    

	if (action = "getDetialLog")  //日志明细
	{
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")	
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	
	    s result = ##Class(%ResultSet).%New("EMRservice.BL.BLEMRLogs:GetDetialLog")
	    s sc = result.Execute(episodeId,emrDocId,emrNum)
		s json = ""
		s count = 0
		While (result.Next())
		{
			if ( idxStart-1 <= count) && (idxLast > count )
			{
				s json = json_"{""OrderID"":"""_$g(result.Data("OrderID"))_""","
				s json = json_"""LoginUserName"":"""_$g(result.Data("LoginUser"))_""","
				s json = json_"""OperUserName"":"""_$g(result.Data("OperUser"))_""","
				s json = json_"""OperDate"":"""_$g(result.Data("OperDate"))_""","
				s json = json_"""OperTime"":"""_$g(result.Data("OperTime"))_""","
				s json = json_"""MachineIP"":"""_$g(result.Data("MachineIP"))_""","
				s json = json_"""Action"":"""_$g(result.Data("Action"))_""","
				s json = json_"""TplName"":"""_$g(result.Data("TplName"))_""","
				s json = json_"""TplCreateDate"":"""_$g(result.Data("TplCreateDate"))_""","
				s json = json_"""TplCreateTime"":"""_$g(result.Data("TplCreateTime"))_"""}"
				s json = json_","				
			}
			s count = count + 1
		}
		s json = $e(json,1,$l(json)-1)
		s ret = "{""total"":"_count_",""rows"":["_json_"]}"
		w ret
	}
	
	Quit $$$OK
}

}
