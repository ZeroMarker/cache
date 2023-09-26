/// web.eprajax.episodeListGrid
/// 描述:取得病人就诊列表信息转化成前台需要的Json格式
/// 编写者:loo
/// 编写日期:2010-06-01
Class web.eprajax.episodeListGrid Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s PatientID = $Get(%request.Data("patientID",1))
	s admType = $Get(%request.Data("admType",1),"")
	
	s start = $g(%request.Data("start",1),"0")
	s limit = $g(%request.Data("limit",1),"0")
	s idxLast = start + limit - 1	
	
	s intCount = 0
	//对就诊内容输入的中文进行解码
	s argDiagnosDesc = ##Class(EPRservice.Util.CharacterEncoding).UnEscape($Get(%request.Data("argDiagnosDesc",1)))
	
	//数据格式：AdmType, AdmDate, AdmTime, CurDept, MainDoc, Diagnosis, DisDate, DisTime,EpisodeID
	//w "["
	s result = ##Class(%ResultSet).%New("EPRservice.browser.BOEpisodeInfo:GetPatientList")
	d result.Execute(PatientID,admType,argDiagnosDesc)
	
	s json =""
	while result.Next()
	{
	//	s intCount=(intCount+1)
		if ((intCount<=idxLast)&(intCount>=start))
		{
	 		s json = json_"{AdmDate:'"_$zd(result.Data("AdmDate"),3)_"',"
	 		s json = json_"AdmTime:'"_$zt(result.Data("AdmTime"),1)_"',"
	  		s json = json_"AdmType:'"_result.Data("AdmType")_"',"
	  		s json = json_"Diagnosis:'"_result.Data("Diagnosis")_"',"
	  		s json = json_"CurDept:'"_result.Data("CurDept")_"',"
	  		s json = json_"MainDoc:'"_result.Data("MainDoc")_"',"
	  
	  	    //排除出院日期为空，转换后默认显示为1840-12-31
	  		if (result.Data("DisDate") = "")
	  		{
	  			s json = json_"DisDate:'"_result.Data("DisDate")_"',"
	  		}
	  		else
	  		{
	  			s json = json_"DisDate:'"_$zd(result.Data("DisDate"),3)_"',"
	  		}
	  		//s json = json_"EpisodeID: '"_result.Data("EpisodeID")_"'},"
	  		s json = json_"EpisodeID: '"_result.Data("EpisodeID")_"',"
	  		//变色标志
	  		//s colorFlag=""
	  		s colorFlag=..getColorFlag(result.Data("EpisodeID"))
			s json = json_"ColorFlag: '"_colorFlag_"'},"
		}
		s intCount = intCount+1
	}	
	s json = $e(json, 1, $L(json)-1)
	//s json = json_"]"
	
	//替换掉json串中的回车换行符号
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	//w json
	s ret = "{TotalCount:"_intCount_",data:["_json_"]}"
	
	w ret
	
	q $$$OK
}

/// w ##Class(web.eprajax.episodeListGrid).getColorFlag(446)
/// insert into EPRmeta.CustomDictionary
/// (CtmDictType, CtmDictID, CtmDictCode, CtmDictDesc, CtmDictComment) 
/// Values('episodeListBrowserColorFlag', '1752', 'GlossaryMZXJ', '门诊小结模板ID', '');
ClassMethod getColorFlag(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="") ""

    s id=""
	s type = $zcvt("episodeListBrowserColorFlag","U")	//索引中数据均为大写
	s code = $zcvt("GlossaryMZXJ","U")
	s id=$O(^DHCEPRM.CustomDictionaryI("IdxCtmTypeCode", " "_type, " "_code, id))
	q:(id="") ""
	
	s obj=##Class(EPRmeta.CustomDictionary).%OpenId(id)
	q:(obj="") ""
	
	q:(obj.CtmDictID="") ""
	s value=##class(EPRservice.Privilege.BOPrivAssist).IsRecordFinishedNew(AEpisodeID, obj.CtmDictID, "1")
	q:(value="1") "#00ff00"
	
	//s AGlossaryInternalID=obj.CtmDictCode
	//q:(AGlossaryInternalID="") ""

	//s value=##Class(EPRservice.BOScatterData).GetDataByGlossary(AEpisodeID, AGlossaryInternalID)
	//q:(value'="") "#00ff00"
	
	q ""
}

}
