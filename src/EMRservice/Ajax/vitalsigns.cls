Class EMRservice.Ajax.vitalsigns Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s item =  $Get(%request.Data("Item",1),"")
 	s Id = $Get(%request.Data("EpisodeID",1),"")
 	s startDateTime = $Get(%request.Data("StartDateTime",1),"")
 	s endDateTime = $Get(%request.Data("EndDateTime",1),"")
 	s page = $g(%request.Data("page",1),"-1")
	s rows = $g(%request.Data("rows",1),"-1")
	s idxStart = rows * (page -1) + 1
	s idxLast = idxStart + rows -1	
	s interface = $Get(%request.Data("InterFace",1),"")
	s interface = $zcvt($zcvt(interface,"I","URL"),"I","UTF8")
	/*s json = ..GetVitalsigns(interface,Id,item,startDateTime,endDateTime,idxStart,idxLast)
	w json*/
	s ResultStream = ..GetVitalsignsStream(interface,Id,item,startDateTime,endDateTime,idxStart,idxLast)
	//w ResultStream
	//输出流数据
	while (ResultStream.AtEnd = 0)
	{
		w $ZSTRIP(ResultStream.Read(32000),"*C",,$c(1)_$c(2))
	}
		
	Quit $$$OK
}

/// Desc:       生命体征信息 流信息
/// Creaotr：   duanlijun
/// Createdate: 2019-03-05
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
/// D ##Class(EMRservice.Ajax.vitalsigns).GetVitalsignsStream("HIS",2290509,"ITEM1^ITEM7^ITEM4^ITEM5^ITEM6","2019-01-02","2019-02-01",1,10)
ClassMethod GetVitalsignsStream(AInterFace As %String, AEpisodeID As %String, AItem As %String, AStDate As %String, AEdDate As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s stream = ##Class(%GlobalBinaryStream).%New()
	q:((AEpisodeID = "")||(AItem = "")) stream.Write("{""total"":0,""rows"":[""""]}]")
	s AStDate = $Case(AStDate,"":"",:$zdh(AStDate,3))
	s AEdDate = $Case(AEdDate,"":"",:$zdh(AEdDate,3))
	s episodeDate = $ZD($p($g(^PAADM(AEpisodeID)),"^",6),3)
	
	if (AInterFace = "HIS")
	{
		s ret=##class(EMRservice.BL.BLVitalsigns).GetVitalsignsInfo(AEpisodeID,AItem,AStDate,AEdDate)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	d stream.Write("{""total"":"_ret.Count()_",""rows"":[")
	s count = 0
	for
	{
		s objItm = ret.GetNext(.date)
		q:(date = "")
		s count = count+1
		
        if ((AIdxStart <= count) && (AIdxLast >= count)) {
			if (count > AIdxStart){
				d stream.Write(",{")
			}
			else{
				d stream.Write("{")	
			} 
			d stream.Write("""WriteDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",date)_"""")
			for
			{
				s value = objItm.GetNext(.key)
				q:(key = "")
				d stream.Write(",")
				d stream.Write(""""_key_""":"""_value_"""")		
			}
			d stream.Write(",""EpisodeDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_"""")		
			d stream.Write("}")
        }
        
	}
	d stream.Write("]}")
	q stream
}

/// Desc:       生命体征信息
/// Creaotr：   Candy
/// Createdate: 2014-8-14
/// Input:      AInterFace 调用接口标识(默认HIS)  add by Lina 2016-11-10
/// w ##Class(EMRservice.Ajax.vitalsigns).GetVitalsigns("HIS",315,"WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc","2019-07-25","2019-07-25",1,10)
ClassMethod GetVitalsigns(AInterFace As %String, AEpisodeID As %String, AItem As %String, AStDate As %String, AEdDate As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s json = ""
	s count = 0
	q:((AEpisodeID = "")||(AItem = "")) "{""total"":0,""rows"":["_json_"]}"
	s AStDate = $Case(AStDate,"":"",:$zdh(AStDate,3))
	s AEdDate = $Case(AEdDate,"":"",:$zdh(AEdDate,3))
	s episodeDate = $ZD($p($g(^PAADM(AEpisodeID)),"^",6),3)
	s vital = $i(^CacheTemp)
	k ^TempEMRVitalsigns(vital)

	if (AInterFace = "HIS")
	{
		
		s ret=##class(EMRservice.BL.BLVitalsigns).GetVitalsignsInfo(AEpisodeID,AItem,AStDate,AEdDate)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
	for
	{
		
		s objItm = ret.GetNext(.date)
		q:(date = "")
		s json = "{"
		
		s json = json_"""WriteDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",date)_""""

		for
		{
			s value = objItm.GetNext(.key)
			q:(key = "")
			s json = json_","
			s json = json_""""_key_""":"""_value_"""" 		
		}
		
		s json = json_","
		s json = json_"""EpisodeDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""""
		s json = json_"}"
		
	    s WriteDate = $p(date," ",1),WriteTime = $p(date," ",2)
	   	s WriteDate = $Case(WriteDate,"":"",:$zdh(WriteDate,3))
    	s WriteTime = $Case(WriteTime,"":"",:$zth(WriteTime))    
		s ^TempEMRVitalsigns(vital,WriteDate,WriteTime,count) = json
		s json = ""
		s count = count + 1
		
	}
		
	
    s j=0,i=0,WriteDate=""
	for
	{
		
		s WriteDate = $o(^TempEMRVitalsigns(vital,WriteDate),-1)
		q:(WriteDate="")
		s WriteTime=""
		for
		{
			s WriteTime = $o(^TempEMRVitalsigns(vital,WriteDate,WriteTime),-1)
			q:(WriteTime = "")
			s count = ""
			for
			{
				s count = $o(^TempEMRVitalsigns(vital,WriteDate,WriteTime,count))
				q:(count = "")
				if ((AIdxStart <= i)&(i<= AIdxLast))
				{
					s:(j'=0) json = json_","
					s json = json_^TempEMRVitalsigns(vital,WriteDate,WriteTime,count)
					s j = j + 1
				}
				s i = i + 1
			}
		}
	}
	k ^TempEMRVitalsigns(vital) 
	s json = "{""total"":"_ret.Count()_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

}
