Class web.DHCCM.EMRservice.Ajax.orderData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 	s episodeId = $Get(%request.Data("EpisodeID",1),"")
 	s type = $Get(%request.Data("OrderType",1),"")
	s action = $Get(%request.Data("Action",1),"")
	if (action = "GetOrderData"){
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1
		w ..GetOrderData(episodeId,type,idxStart,idxLast)
	}elseif (action = "GetSubOrderData"){
		s paroeitemId = $Get(%request.Data("OEItemID",1),"")
		w ..GetSubOrderData(episodeId,type,paroeitemId)
	}	
	Quit $$$OK
}

/// Desc:       医嘱信息
/// Creator:    Candy
/// CreateDate: 2014-8-20
/// Input:      AEpisodeId 就诊号
///             AOrderType 医嘱类型
///             AIdxStart 记录开始码
///             AIdxLast  记录结束码
/// Output:     json
/// ##Class(web.DHCCM.EMRservice.Ajax.orderData).GetOrderData(76,"S",1,10)
ClassMethod GetOrderData(AEpisodeIds As %String, AOrderType As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s json = ""
	s tempjson = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMROrderData(key)
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLOrderData:GetOrdByAdm")
		d result.Execute(episodeId,"","","","","","","",AOrderType)
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			s tempjson = tempjson_"{"
			for k=1:1:columCount
			{
				s:(k '= 1) tempjson = tempjson_","
				if (result.GetColumnName(k) = "ArcimDesc")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##Class(EMRservice.Tools.Tool).ReplaceWord(result.Data(result.GetColumnName(k)),"\","/")_""""
				}
				else
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_result.Data(result.GetColumnName(k))_""""
				}
			}
			s tempjson = tempjson_"}"
			s ^TempEMROrderData(key,$zdh(result.Data("OrdCreateDate"),3),$zth(result.Data("OrdCreateTime"),1),count) = tempjson
			s tempjson = ""
			s count = count + 1
		}
	}
	//倒序排序输出
	s OrdCreateDate="",j=0,i=1
	for
	{
		s OrdCreateDate = $o(^TempEMROrderData(key,OrdCreateDate),-1)
		q:(OrdCreateDate="")
		s OrdCreateTime=""
		for
		{
			s OrdCreateTime = $o(^TempEMROrderData(key,OrdCreateDate,OrdCreateTime),-1)
			q:(OrdCreateTime = "")
			s order = ""
			for {
				s order = $o(^TempEMROrderData(key,OrdCreateDate,OrdCreateTime,order))
				q:(order = "")
				if ((AIdxStart <= i)&(i <= AIdxLast))
				{
					s:(j'=0) json = json_","
					s json = json_^TempEMROrderData(key,OrdCreateDate,OrdCreateTime,order)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMROrderData(key)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       关联医嘱信息
/// Creator:    Lina
/// CreateDate: 2016-3-31
/// Input:      AEpisodeId 就诊号
///             AOrderType 医嘱类型
///             AParOEItemID 关联医嘱中的父医嘱OEItemID字段
/// Output:     json
/// ##Class(web.DHCCM.EMRservice.Ajax.orderData).GetSubOrderData("468","S","437||74")
ClassMethod GetSubOrderData(AEpisodeIds As %String, AOrderType As %String, AParOEItemID As %String)
{
	s json = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		s result = ##class(%ResultSet).%New("web.DHCCM.EMRservice.BL.BLOrderData:GetOrdByAdm")
		d result.Execute(episodeId,"","","","","","","",AOrderType,AParOEItemID)
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			s json = json_"{"
			for k=1:1:columCount
			{
				s:(k '= 1) json = json_","
				if (result.GetColumnName(k) = "ArcimDesc")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##Class(EMRservice.Tools.Tool).ReplaceWord(result.Data(result.GetColumnName(k)),"\","/")_""""
				}else{
					s json = json_""""_result.GetColumnName(k)_""":"""_result.Data(result.GetColumnName(k))_""""
				}
			}
			s json = json_"}"
			s json = json_","
			s count = count + 1
		}
	}
	s json = $e(json,1,$l(json)-1)
	s json = $ZSTRIP(json,"*C")
	q "["_json_"]"
}

}
