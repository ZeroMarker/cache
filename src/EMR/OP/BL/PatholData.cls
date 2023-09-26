/// 名称：EMR.OP.BL.PatholData
/// 描述：门急诊病理功能相关业务
/// 编写者：huhao
/// 编写日期：2021-7-23
/// 产品组：电子病历产品组
Class EMR.OP.BL.PatholData Extends EMR.OP.COM.ActionBase [ Not ProcedureBlock ]
{

/// Desc:       获取病理主数据
/// Creator:    huhao
/// CreateDate: 2021-07-23
/// Input:      argInJson  	命令参数{"action":"GET_PATHOLDATA","params":{"interface":"HIS","episodeIDs":"4","current":1,"pageSize":10},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetPatholList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s interface=argInJson.params.interface
	s interface = $CASE(interface,"":"HIS",:interface)
	s episodeId=argInJson.params.episodeIDs
	s episodeId = $CASE(episodeId,"":4,:episodeId)
	s pagesize=argInJson.params.pageSize
	s pagesize = $CASE(pagesize,"":20,:pagesize)
	s current=argInJson.params.current
	s current = $CASE(current,"":1,:current)
	s idxStart=pagesize * (current - 1)+1
	s idxLast= idxStart +pagesize -1

    s strRes = ..GetPatholData(interface,episodeId,idxStart,idxLast,current,pagesize)
	if (strRes '= "")
	{ 	
		d strRes.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到用户数据",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取病理项
/// Creator:    huhao
/// Createdate: 2021-07-23
/// Input:      AInterFace 调用接口标识(默认HIS)
///             AEpisodeIDs:就诊号
///             AIdxStart:返回分页开始页号
///             AIdxLast:返回分页结束页号
/// Output:     ClinicDiag:临床诊断,ClinicRecord:临床病历,AppDate:申请日期,AppTime:申请时间,
///             SpeInfo:标本信息,tmid:申请单号,ordername:医嘱项
/// 			w ##Class(EMR.OP.BL.PatholData).GetPatholData("HIS","230",1,10)
ClassMethod GetPatholData(AInterFace As %String, AEpisodeIDs As %String, AIdxStart As %Integer, AIdxLast As %Integer, Current As %Integer, PageSize As %Integer) As %String
{
	s json = ""
	s count = 0
	s episodeId = ""
	q:(AEpisodeIDs = "") "{""total"":"_count_",""rows"":["_json_"]}"
	if (AInterFace = "HIS")
	{
		s PISNameSpace = ##class(EMR.OP.BL.PatholData).getPathologyNameSpace()
		//检查命名空间是否有误，1正确，0错误
		s IsNameSpaceExists = ##class(%SYS.Namespace).Exists(PISNameSpace)
		if (IsNameSpaceExists=0) w "命名空间有误,请在EMRservice.SystemParameter维护参数"
		q:IsNameSpaceExists=0 "{""total"":"_count_",""rows"":["_json_"]}"
		d $zu(5,PISNameSpace)	
	}
	s key = $i(^CacheTemp)
	k ^TempEMRPatholData(key)
	s length = $l(AEpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIDs,",",I)
		if (AInterFace = "HIS")
		{ 
			s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetAppInfoByAdm")
			d result.Execute(episodeId)
		}
		elseif (AInterFace = "数据平台")
		{
			s result =  ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPathology:GetDataList")
			d result.Execute(episodeId)
		}
		//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
		
		s columCount = result.GetColumnCount()
		while result.%Next()
		{
			//排序
			for k=1:1:columCount
			{
				s appDate = "0",appTime = "0"
				//取病理申请日期
				s:(result.Data("AppDate") '= "") appDate = $zdh(result.Data("AppDate"),3)
				//平台未返回病理申请日期，此处取病理取样日期
				s:((appDate = "0")&&($g(result.Data("SamplingDate")))) appDate = $zdh(result.Data("SamplingDate"),3)
				//取病理申请时间
				s:(result.Data("AppTime") '= "") appTime = $zth(result.Data("AppTime"),1)
				//平台未返回病理申请时间，此处取病理送检日期
				s:((appTime = "0")&&($g(result.Data("InspectionDate")))) appTime = $zdh(result.Data("InspectionDate"),3)
				s ^TempEMRPatholData(key,appDate,appTime,count,result.GetColumnName(k)) = result.Data(result.GetColumnName(k))
			}
			s count = count + 1
		}
		d result.Close()
	}
	d $zu(5,"DHC-APP")
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
					s tempjson = "{"
					s tempcount = 0
					s column = ""
					for 
					{
						s column = $o(^TempEMRPatholData(key,AppDate,AppTime,order,column))
						q:(column = "")
						s columnresult = ^TempEMRPatholData(key,AppDate,AppTime,order,column)
						s:(tempcount '= 0) tempjson = tempjson_","
						if (column = "AppDate")
						{
							s tempjson = tempjson_""""_"appDate"_""":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",columnresult)_""""
						}
						elseif (column = "AppTime")
						{
							s tempjson = tempjson_""""_"appTime"_""":"""_##Class(EMR.DOC.COM.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",columnresult)_""""
						}
						elseif (column = "ClinicDiag")
						{
							s tempjson = tempjson_""""_"clinicDiag"_""":"""_columnresult_""""
						}
						elseif (column = "ClinicRecord")
						{
							s tempjson = tempjson_""""_"clinicRecord"_""":"""_columnresult_""""
						}
						elseif (column = "SpeInfo")
						{
							s tempjson = tempjson_""""_"speInfo"_""":"""_columnresult_""""
						}
						elseif (column = "ordername")
						{
							s tempjson = tempjson_""""_"ordername"_""":"""_columnresult_""""
						}
						else
						{
							s tempjson = tempjson_""""_"tmid"_""":"""_columnresult_""""
						}
						s tempcount = tempcount + 1
					}		
					s tempjson = tempjson_"}"
					
					s:(j'=0) json = json_","
					s json = json_tempjson
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRPatholData(key)
	
	s json = "{""list"":["_json_"],""total"":"_count_","_"""current"":"_Current_",""pageSize"":"_PageSize_"}"
	s json = $ZSTRIP(json,"*C")
	s finalJson = ##class(%DynamicObject).%FromJSON(json)
	;d finalJson.%ToJSON(argOutData)

	q finalJson
}

/// Desc:  		读取配置中病理的命名空间
/// Creator:    王煜
/// CreateDate: 20200111
/// Input:      无
/// Output:     Y/N
/// Debug:      d ##class(EMR.OP.BL.PatholData).getPathologyNameSpace()
ClassMethod getPathologyNameSpace() As %String
{
	q "PIS"
}

/// Desc:       获取病理子数据
/// Creator:    
/// CreateDate: 2021-07-23
/// Input:      argArray  	命令参数 {"action":"GET_SUBPATHOL","params":{"tmrowid":"22","interface":"HIS","episodeID":"4","current":1,"pageSize":10},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod GetSubPatholList(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "ErrorPath"
	s interface=argInJson.params.interface
	s interface = $CASE(interface,"":"HIS",:interface)
	s episodeId=argInJson.params.episodeID
	s episodeId = $CASE(episodeId,"":4,:episodeId)
	s tmrowid=argInJson.params.tmrowid
	s current= argInJson.params.current
	s current = $CASE(current,"":1,:current)
	s pagesize=argInJson.params.pageSize
	s pagesize = $CASE(pagesize,"":20,:pagesize)
	s idxStart=pagesize * (current - 1)+1
	s idxLast= idxStart +pagesize -1

    s strRes = ##class(EMR.OP.BL.PatholData).GetSubPathol(interface,episodeId,tmrowid,current,pagesize)
	if (strRes '= "")
	{ 
	    d strRes.%ToJSON(argOutData)
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","接口错误,未获取到用户数据",2)
	}
ErrorPath
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       取病理子项
/// Creator:    huhao
/// Createdate: 2021-07-23
/// Input:      AInterFace 调用接口标识(默认HIS)
///             Tmrowid:申请单号
/// OutPut:     Diagnosis:病理诊断,Seeing:检查所见,RptDate:发报告日期,RptTime:发报告时间,PathId:病理号
/// debug:      w ##Class(EMR.OP.BL.PatholData).GetSubPathol("HIS","22")
ClassMethod GetSubPathol(AInterFace As %String, AEpisodeID As %String, Tmrowid As %String, Current As %String, PageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s json = ""
	s PISNameSpace = ##class(EMR.OP.BL.PatholData).getPathologyNameSpace()
	s count = 0
	q:(Tmrowid = "") "{""total"":0,""rows"":["_json_"]}"
	s resultSub = ##class(%Library.ResultSet).%New()
	if (AInterFace = "HIS")
	{
		//检查命名空间是否有误，1正确，0错误
		s IsNameSpaceExists = ##class(%SYS.Namespace).Exists(PISNameSpace)
		if (IsNameSpaceExists=0) w "命名空间有误"
		q:IsNameSpaceExists=0
		d $zu(5,PISNameSpace) 
		s resultSub = ##class(%Library.ResultSet).%New("Src.DPIS3OutInterface:GetRptInfoByTmrowid")
		d resultSub.Execute(Tmrowid)
	}
	elseif (AInterFace = "数据平台")
	{
		s resultSub = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPathology:GetDataList")
		d resultSub.Execute(AEpisodeID,"","",Tmrowid)
	}
	s columCount = resultSub.GetColumnCount()
	while (resultSub.%Next()){
		s:(json'= "") json = json_","
		s json = json_"{"
		s json = json_"""tmrowid"":"""_Tmrowid_""","
		for k=1:1:columCount
		{
			s:(k '= 1) json = json_","
			if (k=1)
			{
				s json = json_""""_"diagnosis"_""":"""_resultSub.Data(resultSub.GetColumnName(k))_""""
			}
			elseif (k=2)
			{
				s json = json_""""_"seeing"_""":"""_resultSub.Data(resultSub.GetColumnName(k))_""""
			}
			elseif (k=3)
			{
				s json = json_""""_"rptDate"_""":"""_resultSub.Data(resultSub.GetColumnName(k))_""""
			}
			elseif (k=4)
			{
				s json = json_""""_"rptTime"_""":"""_resultSub.Data(resultSub.GetColumnName(k))_""""
			}
			else
			{
				s json = json_""""_"pathId"_""":"""_resultSub.Data(resultSub.GetColumnName(k))_""""
			}
		}
		s json = json_"}"
		s count = count + 1
	}
	d resultSub.Close()
	d $zu(5,"DHC-APP")
	s json = "{""list"":["_json_"],""total"":"_count_","_"""current"":"_Current_",""pageSize"":"_PageSize_"}"
	s json = $ZSTRIP(json,"*C")
	s finalJson = ##class(%DynamicObject).%FromJSON(json)
	q finalJson
}

}
