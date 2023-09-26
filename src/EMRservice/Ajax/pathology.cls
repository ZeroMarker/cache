Class EMRservice.Ajax.pathology Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s episodeId = $Get(%request.Data("EpisodeID",1),"")
	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	if (action = "GetPatholData")
	{
        s appStDate = $Get(%request.Data("AppStDate",1),"")
        s appEndDate = $Get(%request.Data("AppEndDate",1),"")
        w ..GetPatholData(interface,episodeId,appStDate,appEndDate,idxStart,idxLast)
	}
	elseif (action = "GetSubPathol")
	{
        s Id = $Get(%request.Data("ID",1),"")
		w ..GetSubPathol(interface,Id,episodeId)
	}
	Quit $$$OK
}

/// Desc:       取病理项
/// Creator:    Donglulu
/// Createdate: 2016-2-10
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10 
///             AEpisodeIDs:就诊号以","分隔
///             AppStDate:申请开始日期
///             AppEndDate:申请结束日期
///             AIdxStart:返回分页开始页号
///             AIdxLast:返回分页结束页号
/// Output:     ClinicDiag:临床诊断,ClinicRecord:临床病历,AppDate:申请日期,AppTime:申请时间,
///             SpeInfo:标本信息,tmid:申请单号,ordername:医嘱项
///             w ##Class(EMRservice.Ajax.pathology).GetPatholData("HIS","230","","",1,10)
ClassMethod GetPatholData(AInterFace As %String, AEpisodeIDs As %String, AppStDate As %String = "", AppEndDate As %String = "", AIdxStart As %Integer, AIdxLast As %Integer) As %String
{
	s json = ""
	s count = 0
	s episodeId = ""
	q:(AEpisodeIDs = "") "{""total"":"_count_",""rows"":["_json_"]}"
	if (AInterFace = "HIS")
	{
		s PISNameSpace = ##Class(EMRservice.SystemParameter).getPathologyNameSpace()
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
    //申请日期查询条件的格式转换
    s:(AppStDate'="") AppStDate= $zdh(AppStDate,3)
    s:(AppEndDate'="") AppEndDate= $zdh(AppEndDate,3)
	for
	{
		s AppDate = $o(^TempEMRPatholData(key,AppDate),-1)
		q:(AppDate="")
        q:(AppStDate'="")&(AppDate<AppStDate)
        continue:(AppEndDate'="")&(AppDate>AppEndDate)
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
							s tempjson = tempjson_""""_column_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",columnresult)_""""
						}
						elseif (column = "AppTime")
						{
							s tempjson = tempjson_""""_column_""":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",columnresult)_""""
						}
						else
						{
							s tempjson = tempjson_""""_column_""":"""_columnresult_""""
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
	
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Desc:       取病理子项
/// Creator:    Donglulu
/// Createdate: 2016-2-10
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
///             Tmrowid:申请单号
/// OutPut:     Diagnosis:病理诊断,Seeing:检查所见,RptDate:发报告日期,RptTime:发报告时间,PathId:病理号
/// debug:      w ##Class(EMRservice.Ajax.pathology).GetSubPathol("HIS","41||73")
ClassMethod GetSubPathol(AInterFace As %String, Tmrowid As %String, AEpisodeID As %String) As %String
{
	s json = ""
	s PISNameSpace = ##Class(EMRservice.SystemParameter).getPathologyNameSpace()
	s count = 0
	q:(Tmrowid = "") "{""total"":0,""rows"":["_json_"]}"
	if (AInterFace = "HIS")
	{
		
		//检查命名空间是否有误，1正确，0错误
		s IsNameSpaceExists = ##class(%SYS.Namespace).Exists(PISNameSpace)
		if (IsNameSpaceExists=0) w "命名空间有误"
		q:IsNameSpaceExists=0
		d $zu(5,PISNameSpace) 
		s result = ##class(%ResultSet).%New("Src.DPIS3OutInterface:GetRptInfoByTmrowid")
		d result.Execute(Tmrowid)
	}
	elseif (AInterFace = "数据平台")
	{
		s result = ##Class(%Library.ResultSet).%New("EMRservice.BL.BLPathology:GetDataList")
		d result.Execute(AEpisodeID,"","",Tmrowid)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
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
