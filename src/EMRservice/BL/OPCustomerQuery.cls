/// 用户自定义查询界面对应后台查询方法
Class EMRservice.BL.OPCustomerQuery Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s patientId = $Get(%request.Data("PatientID",1),"")
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s flag = $Get(%request.Data("Flag",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	
	
	s obj = ..GetInfo(flag)
	s ^CacheTemp("flag")=flag
	if (obj="") 
	{
		w ""
	} 
	else 
	{
		s execCode = "result=##class("_obj.Clazz_")."_obj.Method_"("_patientId_","_episodeId_","_page_","_rows_")"
		s ^CacheTemp("execCode")=execCode
		s @execCode
		s result = @"result"
		w $ZSTRIP(result,"*C",,$c(1)_$c(2))
	}
	Quit $$$OK
	
	
	/*if ((page = -1)&&(rows = -1))
	{
		s idxStart = ""
		s idxLast = ""
	}
	else
	{
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1	
	}		
	if (action = "CustomerFirst")
	{
		s json = ..GetEpisodeList(patientId,idxStart,idxLast)
		w json
	}
	elseif(action = "GetCTLocList")
	{
		q ""
	}
	Quit $$$OK*/
}

/// d ##class(EMRservice.BL.OPCustomerQuery).%BuildIndices()
/// w ##class(EMRservice.BL.OPCustomerQuery).GetInfo("CustomerFirst")
ClassMethod GetInfo(Name) As EMRmeta.OPCustomerQuery
{
	s obj = ""
	s id=$O(^DHCEMRM.OPCustomerQueryI("IdxName"," "_$zcvt(Name,"U"),""))
	s:(""'=id) obj = ##Class(EMRmeta.OPCustomerQuery).%OpenId(id)

	q obj
}

/// Desc:       取患者就诊列表
/// Creator:    Candy
/// CreateDate: 2014-8-19
/// Input:      ApatientId 患者号
/// OutPut:     json 患者就诊信息
/// Debug:      w ##Class(EMRservice.BL.OPCustomerQuery).GetEpisodeList(6586,"",1,10)
ClassMethod GetEpisodeList(ApatientId, episodeId As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s AQueryItem="",AEpisodeType=""
	s json = ""
	s count = 0
	q:(ApatientId = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s ds = ##Class(%Library.ResultSet).%New("EMRservice.HISInterface.EpisodeInfo:GetEpisodeListByPID")
	d ds.Execute(ApatientId,AQueryItem,AEpisodeType)
	While (ds.Next())
	{
		if (((AIdxStart-1)<= count) && (AIdxLast > count))||((AIdxStart="")&&(AIdxLast=""))
		{
			s json = json_"{"
			s json = json_"""EpisodeID"":"""_ds.Data("EpisodeID")_""","
			//s json = json_"""MedicareNo"":"""_ds.Data("MedicareNo")_""","
			s json = json_"""EpisodeDate"":"""_ds.Data("EpisodeDate")_""","
			s json = json_"""EpisodeTime"":"""_ds.Data("EpisodeTime")_""","
			s json = json_"""Diagnosis"":"""_ds.Data("Diagnosis")_""","
			s json = json_"""EpisodeType"":"""_ds.Data("EpisodeType")_""","			
			s json = json_"""EpisodeDeptDesc"":"""_ds.Data("EpisodeDeptDesc")_"""," 
			s json = json_"""EpisodeDeptID"":"""_ds.Data("EpisodeDeptID")_""","
			s json = json_"""MainDocName"":"""_ds.Data("MainDocName")_"""," 
			s json = json_"""DischargeDate"":"""_ds.Data("DischargeDate")_""","
			s json = json_"""AdmSequence"":"""_"第"_ds.Data("AdmSequence")_"次"_""","
			s json = json_"""EpisodeReason"":"""_ds.Data("EpisodeReason")_""""			
			s json = json_"}"
			s json = json_","
		}
		s count = count + 1
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
