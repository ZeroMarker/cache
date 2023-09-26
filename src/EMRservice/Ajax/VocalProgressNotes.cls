Class EMRservice.Ajax.VocalProgressNotes Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
 	s episodeId = $Get(%request.Data("EpisodeIDS",1),"")
	s action = $Get(%request.Data("Action",1),"")
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	
	s startDate = $Get(%request.Data("StartDateTime",1),"")
	s endDate = $Get(%request.Data("EndDateTime",1),"")
	
	s SourceID = $Get(%request.Data("SourceID",1),"")
	
	if (action = "GetPostResult"){
		s page = $g(%request.Data("page",1),"-1")
		s rows = $g(%request.Data("rows",1),"-1")
		s idxStart = rows * (page -1) + 1
		s idxLast = idxStart + rows -1
		w ..PostResult(interface,episodeId,startDate,endDate,idxStart,idxLast)
	}elseif (action = "GetPostResultDetailed"){
		
		w ..PostResultDetailed(interface,SourceID)
	}	

	Quit $$$OK
}

/// w ##class(EMRservice.Ajax.VocalProgressNotes).PostResult("HOS","403","","","1","10")
ClassMethod PostResult(AInterFace As %String, AEpisodeIds As %String, AStartDate As %String, AEndDate As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s json = ""
	s count = 0
	q:(AEpisodeIds = "") "{""total"":"_count_",""rows"":["_json_"]}"
	
	if (AInterFace = "JKL")
	{
		s scheme = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("NotesScheme","")
		s Server = $P($P(scheme,"<server>",2),"</server>",1)
		s Port = $P($P(scheme,"<port>",2),"</port>",1)
		s PostUrl = $P($P(scheme,"<posturl>",2),"</posturl>",1)
        s IsZCVT = $P($P(scheme,"<iszcvt>",2),"</iszcvt>",1)
		q:(PostUrl = "")||(Server="") "{""total"":"_count_",""rows"":["_json_"]}"
	}
	
	s length = $l(AEpisodeIds,",")
	for I=1:1:length
	{
		s episodeId = $p(AEpisodeIds,",",I)
		
		if (AInterFace = "HIS") 
		{
			s result = ##class(%ResultSet).%New("DWR.BL.MedicalRecords:FindMedicalFile")
			d result.Execute(episodeId,"","")
			s key = $i(^CacheTemp)
			k ^TempEMRVocalNoteData(key)
			
			while result.%Next()
			{
				s id = result.Data("dcId")
				s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",result.Data("recDate"))
				s time = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",result.Data("recTime"))
				s docName = result.Data("doctorName")
				s tempjson = "{""SourceID"":"""_id_""",""Date"":"""_date_""",""Time"":"""_time_""",""Doctor"":"""_docName_"""}"
				s tempDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",result.Data("recDate"))	
				
				s ^TempEMRVocalNoteData(key,tempDate,count) = tempjson
				s tempjson = ""
				s count = count + 1
			}
		}
		elseif (AInterFace = "JKL")
		{
			s httprequest=##class(%Net.HttpRequest).%New()
			s httprequest.Server=Server
			s httprequest.Port=Port
			s httprequest.Timeout=10
			d httprequest.SetHeader("source","externalCall")
			s url=PostUrl_episodeId
			d httprequest.Get(url) 
		
		 	s statusCode=httprequest.HttpResponse.StatusCode
		 	q:(statusCode'="200")
			s dataStream=httprequest.HttpResponse.Data
			d httprequest.HttpResponse.Data.Rewind()
			s retStr=httprequest.HttpResponse.Data.Read()
			if ($zcvt(IsZCVT,"U") = "Y") {
				s retStr=$ZCVT(retStr,"I","UTF8")
			}
		
			s Stream= ##Class(%GlobalCharacterStream).%New()
			d Stream.Write(retStr)
			s objJson = ##Class(EMRservice.Parser.Json).%New()  
			s tmpobj = objJson.Deserialize(Stream)

			s Status = tmpobj.GetAt("status")
			q:(Status'="200")


			s key = $i(^CacheTemp)
			k ^TempEMRVocalNoteData(key)
		
			s tmpcount = tmpobj.GetAt("data").Count()
			for i = 1:1:tmpcount
			{
				s tmpdata = tmpobj.GetAt("data").GetAt(i)
				s id = tmpobj.GetAt("data").GetAt(i).GetAt("dcId")
				s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",tmpobj.GetAt("data").GetAt(i).GetAt("dcCreateDate"))
				s docName = tmpobj.GetAt("data").GetAt(i).GetAt("docName")
				s tempjson = "{""SourceID"":"""_id_""",""Date"":"""_date_""",""Doctor"":"""_docName_"""}"
				s tempDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",tmpobj.GetAt("data").GetAt(i).GetAt("dcCreateDate"))

				s ^TempEMRVocalNoteData(key,tempDate,count) = tempjson
				s tempjson = ""
				s count = count + 1
			}
		}
		elseif(AInterFace = "HOS")
		{
			s key = $i(^CacheTemp)
			s returnJson=""
			s:(AStartDate="") AStartDate = $zd(+##class(EMRservice.HISInterface.PatientInfoAssist).AdmDateTime(episodeId),3)
			s:(AEndDate="") AEndDate=$zd(+$h,3) 
			
			//优化为自动获取分类为医生的相关类型。
			s votrowId=0,vottypelist="",vottypes=""
			for
			{
				s votrowId = $o(^CT("HCCSVDT",votrowId))
				q:(votrowId="")
				continue:($p($g(^CT("HCCSVDT",votrowId)),"^",4)'="DOCTOR")
				s vottype = $p($g(^CT("HCCSVDT",votrowId)),"^",1)
				s vottypelist = vottypelist_$lb(vottype)
				
			}	
			s vottypes=$lts(vottypelist,"^")
			s returnJson = ##class(CAL.InterFace).getSoundDataByAdm(episodeId,AStartDate,AEndDate,vottypes)
			
				
			
			s rowData = {}.%FromJSON(returnJson).soundList
			s rowCount = rowData.%Size()
			
			//医呼通返回值样例
			/*{"msg":"","msgcode":"999999",
				"soundList":[
					{"SoundAddress":"http://111.230.139.145:3330/mp3/2/d1d318cfc45e6925e7f03dd0843c8acb.mp3",
					 "SoundDate":"2021-03-30",
					 "SoundId":"353",
					 "SoundStr":"2021年3月30号，院秉承备忘措施,。,",
					 "SoundTime":"16:07:41",
					 "SoundType":"入院备忘",
					 "SoundUser":"徐向"}
				],"status":"0"}
			*/
			//字段对照关系
			/*
				SourceID = SoundId
				Date = SoundDate
				Time = SoundTime
				Type = SoundType
				Doctor = SoundUser
				
			*/
			
			set iter = rowData.%GetIterator()
			
			while iter.%GetNext(.objNum, .sourseObj) 
			{ 
				s tempjson = "{""SourceID"":"""_sourseObj.SoundId_""","
				s tempjson = tempjson_"""Date"":"""_sourseObj.SoundDate_""","
				s tempjson = tempjson_"""Time"":"""_sourseObj.SoundTime_""","
				s tempjson = tempjson_"""Doctor"":"""_sourseObj.SoundUser_""","
				s tempjson = tempjson_"""Type"":"""_sourseObj.SoundType_"""}"
				
				s tempDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",sourseObj.SoundDate)
				
				s ^TempEMRVocalNoteData(key,tempDate,count) = tempjson
				s tempjson = ""
				s count = count + 1
			
			}		

		}
	}
	
	//倒序排序输出
	s NoteCreateDate="",j=0,i=1
	for
	{
		s NoteCreateDate = $o(^TempEMRVocalNoteData(key,NoteCreateDate),-1)
		q:(NoteCreateDate="")
		s order = ""
		for {
			s order = $o(^TempEMRVocalNoteData(key,NoteCreateDate,order))
			q:(order = "")
			if ((AIdxStart <= i)&(i <= AIdxLast))
			{
				s:(j'=0) json = json_","
				s json = json_^TempEMRVocalNoteData(key,NoteCreateDate,order)
				s j = j + 1
			}
			s i = i + 1
		}
	}
	k ^TempEMRVocalNoteData(key)
	s json = "{""total"":"_count_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// w ##class(EMRservice.Ajax.VocalProgressNotes).PostResultDetailed("JKL","ff80808168f675df0169089c11fb3f01")
ClassMethod PostResultDetailed(AInterFace As %String, ASourceID As %String)
{
	s json = ""
	s count = 0
	q:(ASourceID = "") "{""total"":"_count_",""rows"":["_json_"]}"	
	
	if (AInterFace = "JKL") 
	{
		s scheme = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName2("NotesScheme","")
		s Server = $P($P(scheme,"<server>",2),"</server>",1)
		s Port = $P($P(scheme,"<port>",2),"</port>",1)
		s PostDetailUrl = $P($P(scheme,"<postdetailurl>",2),"</postdetailurl>",1)
        s IsZCVT = $P($P(scheme,"<iszcvt>",2),"</iszcvt>",1)
		q:(Server = "")||(PostDetailUrl = "") "{""total"":"_count_",""rows"":["_json_"]}"
	}
	
	if (AInterFace = "HIS") 
	{
		s contentAll = ##Class(DWR.BL.MedicalRecords).GetMedicalInformation(ASourceID)
		s content = $P(contentAll,"^",5)
		s content = "{"_"""SourceID"":"""_ASourceID_""",""NoteDetail"":"""_content_"""}"
	}
	elseif (AInterFace = "JKL")
	{
		s httprequest=##class(%Net.HttpRequest).%New()
		s httprequest.Server=Server
		s httprequest.Port=Port
		s httprequest.Timeout=10
		d httprequest.SetHeader("source","externalCall")
		s url=PostDetailUrl_ASourceID
		d httprequest.Get(url) 
		
		s statusCode=httprequest.HttpResponse.StatusCode
		q:(statusCode'="200") "{""total"":"_count_",""rows"":["_json_"]}"
		s dataStream=httprequest.HttpResponse.Data
		d httprequest.HttpResponse.Data.Rewind()
		s retStr=httprequest.HttpResponse.Data.Read()
		if ($zcvt(IsZCVT,"U") = "Y") {
			s retStr=$ZCVT(retStr,"I","UTF8")
		}
		
		s Stream= ##Class(%GlobalCharacterStream).%New()
		d Stream.Write(retStr)
		s objJson = ##Class(EMRservice.Parser.Json).%New()  
		s tmpobj = objJson.Deserialize(Stream)

		s Status = tmpobj.GetAt("status")
		q:(Status'="200") "{""total"":"_count_",""rows"":["_json_"]}"
		
        s content = ""
		s content = content_"{"
		s content = content_"""SourceID"":"""_ASourceID_""","	
		s content = content_"""DocName"":"""_tmpobj.GetAt("data").GetAt("name")_""","
		s content = content_"""NoteDetail"":"""_tmpobj.GetAt("data").GetAt("content")_""","
		s content = content_"""MainSuit"":"""_tmpobj.GetAt("data").GetAt("zhuSu")_""","
		s content = content_"""Symptoms"":"""_tmpobj.GetAt("data").GetAt("symptoms")_""","
		s content = content_"""Vitalsigns"":"""_tmpobj.GetAt("data").GetAt("signs")_""""
		s content = content_"}"
		
	}
	elseif (AInterFace = "HOS")
	{
		s result = ""
		s json = ""
		s result = ##class(CAL.InterFace).getSoundDataById(ASourceID)

		s rowsDetailJson = {}.%FromJSON(result)
		
		//医呼通返回值样例
		//{"SoundAddress":"","SoundId":"119","SoundStr":"，","msg":"","msgcode":"999999","status":"0"}
		//字段对照关系
		//NoteDetail = SoundStr
		//SourceAddr = SoundAddress
		
		s content = "{""SourceID"":"""_ASourceID_""",""NoteDetail"":"""_rowsDetailJson.SoundStr_""",""SourceAddr"":"""_rowsDetailJson.SoundAddress_"""}"

	}
	s json = "{""total"":""1"",""rows"":["_content_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
