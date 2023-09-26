Class EMRservice.Ajax.diagnos Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 	s episodeIds = $Get(%request.Data("EpisodeIDs",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	s json = ..GetDiagns(interface,episodeIds,idxStart,idxLast)
	w json
	Quit $$$OK
}

/// Desc:		诊断列表
/// Creator:		Candy
/// CreateDate: 	2014-8-19
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
///      		AEpisodeId 就诊ID
/// Output:  	json
/// Debug:		w ##Class(EMRservice.Ajax.diagnos).GetDiagns("HIS",76,1,10)
ClassMethod GetDiagns(AInterFace As %String, AEpisodeIds As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	q:(AEpisodeIds = "") "{""total"":0,""rows"":["_json_"]}"
	s count = 0
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		if (AInterFace = "HIS")
		{
			s ds = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLDiagnos:GetMRDiagnosListNew")
			d ds.Execute(episodeId,"")
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		While (ds.Next())
		{
			s count = count + 1
			d:(((AIdxStart-1)<=(count-1))&&(AIdxLast >= count)) setJson
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	q json
setJson
	s json = json_"{"
	s json = json_"""ARowID"":"""_ds.Data("ARowID")_""","
	s json = json_"""ADiagnosType"":"""_ds.Data("ADiagnosType")_""","
	s json = json_"""ADiagnosName"":"""_ds.Data("ADiagnosName")_"""," 
	s json = json_"""ADemo"":"""_ds.Data("ADemo")_"""," 
	s json = json_"""AEvaluationDesc"":"""_ds.Data("AEvaluationDesc")_""","
	s json = json_"""AICDCode"":"""_ds.Data("AICDCode")_""","
	s json = json_"""AEffectsDesc"":"""_ds.Data("AEffectsDesc")_""","
	s json = json_"""ALevel"":"""_ds.Data("ALevel")_""","
	s json = json_"""AUserName"":"""_ds.Data("AUserName")_""","
	s json = json_"""ADateTime"":"""_ds.Data("ADateTime")_""""
	s json = json_"}"	
	s json =json_","
}

}
