Class web.DHCCM.EMRservice.Ajax.pathology Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s Id = $Get(%request.Data("ID",1),"")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	if (action = "GetPatholData")
	{
 		w ..GetPatholData(episodeId,idxStart,idxLast)
	}
	elseif (action = "GetSubPathol")
	{
		w ..GetSubPathol(Id)
	}
	Quit $$$OK
}

/// Desc:       取病理项
/// Creator:    Donglulu
/// Createdate: 2016-2-10
/// Input:      AEpisodeIDs:就诊号以","分隔
///             AIdxStart:返回分页开始页号
///             AIdxLast:返回分页结束页号
/// Output:     ClinicDiag:临床诊断,ClinicRecord:临床病历,AppDate:申请日期,AppTime:申请时间,
///             SpeInfo:标本信息,tmid:申请单号,ordername:医嘱项
/// 			w ##Class(EMRservice.Ajax.pathology).GetPatholData("230",1,10)
ClassMethod GetPatholData(AEpisodeIDs As %String, AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	s tempjson = ""
	s count = 0
	s episodeId = ""
	q:(AEpisodeIDs = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMRPatholData(key)
	s length = $l(AEpisodeIDs,",")
	d $zu(5,"PIS")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIDs,",",I)
		s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetAppInfoByAdm")
		d result.Execute(episodeId)
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			s tempjson = tempjson_"{"
			for k=1:1:columCount
			{
				s:(k '= 1) tempjson = tempjson_","
				s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_result.Data(result.GetColumnName(k))_""""
			}
			s tempjson = tempjson_"}"
			s ^TempEMRPatholData(key,##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(result.Data("AppDate")),$zth(result.Data("AppTime"),1),count) = tempjson
			s tempjson = ""
			s count = count + 1
		}
		d result.Close()
	}
	//倒序排序输出
	s AppDate="",j=0,i=1
	for
	{
		s AppDate = $o(^TempEMRPatholData(key,AppDate),-1)
		q:(AppDate="")
		s AppTime=""
		for
		{
			s AppTime = $o(^TempEMRPatholData(key,AppDate,AppTime),-1)
			q:(AppTime = "")
			s order = ""
			for {
				s order = $o(^TempEMRPatholData(key,AppDate,AppTime,order))
				q:(order = "")
				if ((AIdxStart <= i)&(i <= AIdxLast))
				{
					s:(j'=0) json = json_","
					s json = json_^TempEMRPatholData(key,AppDate,AppTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRPatholData(key)
	d $zu(5,"DHC-APP")
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取病理子项
/// Creator:    Donglulu
/// Createdate: 2016-2-10
/// Input:      Tmrowid:申请单号
/// OutPut:     Diagnosis:病理诊断,Seeing:检查所见,RptDate:发报告日期,RptTime:发报告时间,PathId:病理号
/// debug:      d ##Class(EMRservice.Ajax.pacsData).GetSubPacs("41||73")
ClassMethod GetSubPathol(Tmrowid As %String) As %String
{
	s json = ""
	s count = 0
	q:(Tmrowid = "") "{""total"":0,""rows"":["_json_"]}"
	d $zu(5,"PIS")
	s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetRptInfoByTmrowid")
	d result.Execute(Tmrowid)
	s columCount = result.GetColumnCount()
	while result.%Next()
	{
		s:(json'= "") json = json_","
		s json = json_"{"
		s json = json_"""Tmrowid"":"""_Tmrowid_""","
		for k=1:1:columCount
		{
			s:(k '= 1) json = json_","
			s json = json_""""_result.GetColumnName(k)_""":"""_result.Data(result.GetColumnName(k))_""""
		}
		s json = json_"}"
		s count = count + 1
	}
	d result.Close()
	d $zu(5,"DHC-APP")
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
