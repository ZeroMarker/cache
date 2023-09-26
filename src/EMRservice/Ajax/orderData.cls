Class EMRservice.Ajax.orderData Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 	s episodeId = $Get(%request.Data("EpisodeID",1),"")
 	s type = $Get(%request.Data("OrderType",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	if (action = "GetOrderData"){
		s catType = $Get(%request.Data("CatType",1),"")
		s searchInput = $Get(%request.Data("SearchInput",1),"")
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1
		s startDate = $Get(%request.Data("StartDate",1),"")
		s endDate = $Get(%request.Data("EndDate",1),"")
		w ..GetOrderData(interface,episodeId,type,catType,idxStart,idxLast,searchInput,startDate,endDate)
	}elseif (action = "GetSubOrderData"){
		s paroeitemId = $Get(%request.Data("OEItemID",1),"")
		w ..GetSubOrderData(interface,episodeId,type,paroeitemId)
	}	
	Quit $$$OK
}

/// Desc:       医嘱信息
/// Creator:    Candy
/// CreateDate: 2014-8-20
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10  
///             AEpisodeId 就诊号
///             AOrderType 医嘱类型
///             ACatType   医嘱类别筛选条件(由医生站提供接口返回医嘱类别,包括药品、检验、检查、材料、处置治疗、其他)
///             AIdxStart 记录开始码
///             AIdxLast  记录结束码
/// 			ASearchInput 医嘱名称
/// Output:     json
/// ##Class(EMRservice.Ajax.orderData).GetOrderData("HIS",76,"S",1,10)
ClassMethod GetOrderData(AInterFace As %String, AEpisodeIds As %String, AOrderType As %String, ACatType As %String, AIdxStart As %Integer, AIdxLast As %Integer, ASearchInput As %String = "", AStartDate As %String = "", AEndDate As %String = "")
{
	s json = ""
	s tempjson = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s key = $i(^CacheTemp)
	k ^TempEMROrderData(key)
	s:(AStartDate'="") AStartDate = $zdh(AStartDate,3)
	s:(AEndDate'="") AEndDate= $zdh(AEndDate,3)	
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		
		if (AInterFace = "HIS")
		{
			s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
			d result.Execute(episodeId,"","","","","","","",AOrderType,"",ACatType)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			s tempFlag = 0
			s tempjson = tempjson_"{"
			for k=1:1:columCount
			{
				s:(k '= 1) tempjson = tempjson_","
				if (result.GetColumnName(k) = "ArcimDesc")
				{
					s tempArcimDesc = ##Class(EMRservice.Tools.Tool).ReplaceWord(result.Data(result.GetColumnName(k)),"\","/")
					//s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_tempArcimDesc_""""
					if (ASearchInput = "")	//modify by liuyunfei  2021/6/7 通过医嘱名称进行查询，如果输入为空查询所有
					{
						s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_tempArcimDesc_""""
					}
					else
					{
						if (tempArcimDesc[ASearchInput)
						{
							s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_tempArcimDesc_""""
						}
						else
						{
							s tempFlag = 1	//给上层while循环传标志，让上层循环跳过本次循环
							q
						}
					}
				}
				elseif (result.GetColumnName(k) = "OrdCreateDate")
				{
					s AOrdCreateDate = result.Data(result.GetColumnName(k))
					s:(AOrdCreateDate'="") AOrdCreateDate = $zdh(AOrdCreateDate,3)
					if (AStartDate '= "")&&(AEndDate '= "")&&(AOrdCreateDate '="")
					{
						if ((AStartDate > AOrdCreateDate) || (AEndDate < AOrdCreateDate))
						{
							s tempFlag = 1	//给上层while循环传标志，让上层循环跳过本次循环
							q
							
						}
						else
						{
							s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
						}
						
					}
					else
					{
						s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
					}
				}
				elseif (result.GetColumnName(k) = "OrdCreateTime")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdStartDate")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdStartTime")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdXDate")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdXTime")
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				else
				{
					s tempjson = tempjson_""""_result.GetColumnName(k)_""":"""_result.Data(result.GetColumnName(k))_""""
				}
			}
			if (tempFlag=1)
			{
				s tempjson = ""
				continue
			}
			s tempjson = tempjson_"}"
			s tempDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",result.Data("OrdCreateDate"))
			s tempTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Time",result.Data("OrdCreateTime"))
			s ^TempEMROrderData(key,tempDate,tempTime,count) = tempjson
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
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10 
///             AEpisodeId 就诊号
///             AOrderType 医嘱类型
///             AParOEItemID 关联医嘱中的父医嘱OEItemID字段
/// Output:     json
/// ##Class(EMRservice.Ajax.orderData).GetSubOrderData("468","S","437||74")
ClassMethod GetSubOrderData(AInterFace As %String, AEpisodeIds As %String, AOrderType As %String, AParOEItemID As %String)
{
	s json = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":"_count_",""rows"":["_json_"]}"
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		
		if (AInterFace = "HIS")
		{
			s result = ##class(%ResultSet).%New("EMRservice.BL.BLOrderData:GetOrdByAdm")
			d result.Execute(episodeId,"","","","","","","",AOrderType,AParOEItemID)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
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
				}
				elseif (result.GetColumnName(k) = "OrdCreateDate")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdCreateTime")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdStartDate")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdStartTime")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdXDate")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data(result.GetColumnName(k)))_""""
				}
				elseif (result.GetColumnName(k) = "OrdXTime")
				{
					s json = json_""""_result.GetColumnName(k)_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data(result.GetColumnName(k)))_""""
				}
				else{
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
