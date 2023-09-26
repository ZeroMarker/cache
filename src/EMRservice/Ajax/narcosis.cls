/// 名称: EMRservice.Ajax.narcosis
/// 描述: 资源区麻醉单
/// 产品组：电子病历组
Class EMRservice.Ajax.narcosis Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeIds = $Get(%request.Data("EpisodeIDs",1),"")
	s interface = $Get(%request.Data("Interface",1),"")
	s json = ..NarListInfoByEpisodeId(episodeIds,interface)
	w json
	Quit $$$OK
}

/// Desc:       根据就诊IDs获取麻醉单信息
/// Creator:    liuyunfei
/// CreateDate: 2022-09-21
/// Input:      AEpisodeIDs 就诊号，多个以“,”分隔
/// OutPut:     
/// Debug:      w ##Class(EMRservice.Ajax.narcosis).NarListInfoByEpisodeId(4,"HIS")
ClassMethod NarListInfoByEpisodeId(AEpisodeIDs As %String, AInterface As %String) As %String
{
	s json = ""
	q:(AEpisodeIDs = "") "{""total"":0,""rows"":["_json_"]}"
	
	s count = 0
	for i=1:1:$l(AEpisodeIDs,",")
	{
		s episodeId = $p(AEpisodeIDs,",",i)
		s narListInfo = ##class(EMRservice.HISInterface.PatientInfoAssist).GetNarListInfo(AEpisodeIDs,AInterface)
		q:($p(narListInfo,"^",1) = "Error")
		continue:(narListInfo="")
		
		s:(count > 0) json = json_","
		s json = json_"{"
		s json = json_"""EpisodeID"":"""_episodeId_""","
		s json = json_"""OutAmount"":"""_$p(narListInfo,",",1)_""","
		s json = json_"""InAmount"":"""_$p(narListInfo,",",2)_""","
		s json = json_"""UrineAmount"":"""_$p(narListInfo,",",3)_""","
		s json = json_"""OutBloodAmount"":"""_$p(narListInfo,",",4)_""""
		s json = json_"}"
		s count = count + 1
	}
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
