/// 类名: web.eprajax.reference.reflistrecord
/// 描述: 取得病人某此就诊日常病程记录转化成JSON格式
/// 编写者: Kumon Xie
/// 编写日期: 2011-05-09
Class web.eprajax.reference.reflistrecord Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s episodeID = $g(%request.Data("EpisodeID",1),"-1")
	q:(episodeID = -1) $$$OK
	
	s idxStart = $g(%request.Data("start",1),"-1")
	s pageSize = $g(%request.Data("limit",1),"-1")
	s idxLast = idxStart + pageSize - 1	
	
	s prtTemplateDocID = $g(%request.Data("PrintTemplateDocID",1),"-1")
	q:(prtTemplateDocID = -1) $$$OK
	
	//s ^CacheTemp("EPRReference","web.eprajax.reference.reflistrecord","Parameters") = episodeID_"^"_idxStart_"^"_pageSize_"^"_idxLast 
	 	
	s result = ##Class(%ResultSet).%New("web.DHCEPRExt:MultipleReportList")
 	s sc = result.Execute(episodeID, prtTemplateDocID)
 	
 	s json = ""
 	s count = 0
 	s isFirstRecord = 1

	While (result.Next())
 	{
	 	s count = count + 1	

		if ( count-1 >= idxStart) && (count-1 <= idxLast)
		{
			if (isFirstRecord = 0) { s json = json_"," }
			
		 	s json = json_"{ID:'"_$g(result.Data("ID"))_"',"
		 	s json = json_"Title:'"_$g(result.Data("Title"))_"',"
		 	s json = json_"Remark:'"_$g(result.Data("Remark"))_"',"
		 	s json = json_"EPRNum:'"_$g(result.Data("EPRNum"))_"',"
		 	s json = json_"TemplateID:'"_$g(result.Data("TemplateID"))_"',"
		 	s json = json_"TemplateVersion:'"_$g(result.Data("TemplateVersion"))_"',"
		 	s json = json_"HappenDate:'"_$zd(result.Data("HappenDate"),3)_"',"
		 	s json = json_"HappenTime:'"_$zt(result.Data("HappenTime"))_"',"
		 	s json = json_"CreateUser:'"_$g(result.Data("CreateUser"))_"'}"
		 	
		 	s isFirstRecord = 0
		}
 	}
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	
	s ret = "{totalCount:"_count_",data:["_json_"]}"
	
	w ret
		
	q $$$OK
}

}
