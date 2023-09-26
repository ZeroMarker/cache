/// 质控员程序入口
Class EPRservice.Quality.Ajax.spotCheckPatInfoList Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s UserID = $Get(%request.Data("userID",1),"")
	s QualityFlag=$Get(%request.Data("QualityFlag",1),"")
	
	s Method=$Get(%request.Data("Method",1),"")
	
	s DateGap=$Get(%request.Data("DateGap",1),"")
	
	if (Method="GetOutPatAssignInfo")
	{
		w ..GetOutPatAssignInfo(UserID,QualityFlag)
		Quit $$$OK
	}
	
	if (Method="GetHistoryAssignInfo")
	{
		w ..GetHistoryAssignInfo(DateGap)
		Quit $$$OK
	}
	
	Quit $$$OK
}

/// w ##class(EPRservice.Quality.Ajax.spotCheckPatInfoList).GetHistoryAssignInfo(10223)
ClassMethod GetHistoryAssignInfo(DateGap As %String)
{
		s json = ""
		//s ^temp("test")=DateGap
		// 查询该分配日期段的所有抽查患者
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetSpotCheckOutPatInfo:GetOutPatAssignInfoByDateGap")
	 	d result.Execute(DateGap)
	 	
	 	s count = 0
		While (result.Next())
	 	{
			s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""AssignName"":"""_$g(result.Data("AssignName"))_""","
		 	//PAADMRowID
		 	s json = json_"""PAADMRowID"":"""_$g(result.Data("PAADMRowID"))_""","
		 	s json = json_"""MedName"":"""_$g(result.Data("MedName"))_""","
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""","
		 	s json = json_"""DateGap"":"""_$g(result.Data("DateGap"))_""","
		 	//CheckedFlag
		 	s json = json_"""CheckedFlag"":"""_$g(result.Data("CheckedFlag"))_""","
		 	s json = json_"""MainDiagnos"":"""_$g(result.Data("MainDiagnos"))_""""
		 	s json = json_"}"
		 	//s json = $tr(json,$c(10),"")
			//s json = $tr(json,$c(13),"")
			s count = count + 1		
		}
	
		s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
		q json
}

/// w ##class(EPRservice.Quality.Ajax.spotCheckPatInfoList).GetOutPatAssignInfo(10223)
ClassMethod GetOutPatAssignInfo(UserID As %String, IsChecked As %String = "")
{
		s json = ""
	
		// 查询该质控医师名下所有抽查患者
		s result = ##Class(%ResultSet).%New("EPRservice.Quality.GetSpotCheckOutPatInfo:GetOutPatAssignInfo")
	 	d result.Execute(UserID,IsChecked)
	 	
	 	s count = 0
		While (result.Next())
	 	{
			s:(count '=0) json =json_","
			s json = json_"{"
		 	s json = json_"""AssignName"":"""_$g(result.Data("AssignName"))_""","
		 	s json = json_"""MedName"":"""_$g(result.Data("MedName"))_""","
		 	s json = json_"""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""","
		 	//CheckedFlag,PAPMISex,Age,MainDiagnos,FinishRecord
		 	s json = json_"""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""","
		 	s json = json_"""FinishRecord"":"""_$g(result.Data("FinishRecord"))_""","
		 	s json = json_"""Age"":"""_$g(result.Data("Age"))_""","
		 	s json = json_"""MainDiagnos"":"""_$g(result.Data("MainDiagnos"))_""","
		 	s json = json_"""CheckedFlag"":"""_$g(result.Data("CheckedFlag"))_""","
		 	s json = json_"""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""""
		 	s json = json_"}"
		 	//s json = $tr(json,$c(10),"")
			//s json = $tr(json,$c(13),"")
			s count = count + 1		
		}
	
		s json = "{""total"":"_count_",""rows"":["_json_"]}"
	
		q json
}

/*/// d ##class(EPRservice.Quality.Ajax.spotCheckPatInfoList).Killer()
ClassMethod Killer()
{
	k ^DHCEPRQ.OutPatSpotCheckDateD
	k ^DHCEPRQ.OutPatSpotCheckDateI
	k ^DHCEPRQ.OutPatSpotCheckDateS
	k ^DHCEPRQ.QualityOutPatAssignInfoD
	k ^DHCEPRQ.QualityOutPatAssignInfoI
	k ^DHCEPRQ.QualityOutPatAssignInfoS
	
	k ^DHCEPRQ.OutPatDiscussInfoD
	k ^DHCEPRQ.OutPatDiscussInfoI
	k ^DHCEPRQ.OutPatDiscussInfoS
}*/
}
