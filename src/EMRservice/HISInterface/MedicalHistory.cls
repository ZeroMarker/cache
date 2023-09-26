/// 病史管理调用其他组接口类
Class EMRservice.HISInterface.MedicalHistory Extends %RegisteredObject
{

/// 通过患者ID获取手术史信息
///  Debug:      w ##Class(EMRservice.HISInterface.MedicalHistory).GetOperHistory("14",131)
ClassMethod GetOperHistory(APatientID As %String, AQuestID As %String) As %String
{
	s result = ""
	q:(APatientID = "")||(AQuestID = "") "[]"
	
	s key = $i(^CacheTemp)
	k ^TempEMRMedHistory(key)
	s count = 1
	
	s ds = ##Class(%Library.ResultSet).%New("CIS.AN.SRV.OperService:GetOperInfoByPAPMIDR")
	d ds.Execute(APatientID)
	While (ds.Next())
	{
		
		continue:(ds.Data("OperDesc") = "")
		d setJson
	}
	
	
	s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_APatientID,AQuestID,""))
	if (rowid '= "")
	{
		s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
		q:(obj = "") result
		s value = obj.Value
		if (value '= "")
		{
			s array = ##Class(EMRservice.Util.Json).FromJson(value)
			
			s arrcount = array.Count()
			for i=1:1:arrcount
			{  
			    s date = array.GetAt(i).GetAt("field0")
			    s name = array.GetAt(i).GetAt("field1")
			    s isSave = "1"
			    
			    s json = "{"
				s json = json_"""field0"":"""_date_"""," 
				s json = json_"""field1"":"""_name_"""," 
				s json = json_"""isSave"":"""_isSave_""""
				s json = json_"}"
				if (date = "")
				{
					s date = $p($h,",",1)
				}
				else
				{
					s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",date)
				}
				s ^TempEMRMedHistory(key,date,count) = json
				s count = count + 1
			} 
		}
	}

	//倒序排序输出
	s tmpdate="",j=0
	for
	{
		s tmpdate = $o(^TempEMRMedHistory(key,tmpdate),-1)
		q:(tmpdate="")

		s order = ""
		for {
			s order = $o(^TempEMRMedHistory(key,tmpdate,order))
			q:(order = "")
			s:(j'=0) result = result_","
			s result = result_^TempEMRMedHistory(key,tmpdate,order)
			s j = j + 1
		}
	}
	
	k ^TempEMRMedHistory(key)
	s result = "["_result_"]"
	s result = $ZSTRIP(result,"*C")
	q result
	q
setJson
	s json = "{"
	s json = json_"""field0"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("OperDate"))_"""," 
	s json = json_"""field1"":"""_ds.Data("OperDesc")_"""," 
	s json = json_"""isSave"":""0"""
	s json = json_"}"
	if (ds.Data("OperDate") = "")
	{
		s date = $p($h,",",1)
	}
	else
	{
		s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("OperDate"))
	}
	s ^TempEMRMedHistory(key,date,count) = json
	s json = ""
	s count = count + 1
	q
}

/// 通过患者ID获取住院史信息
///  Debug:      w ##Class(EMRservice.HISInterface.MedicalHistory).GetInpatientHistory("14",132)
ClassMethod GetInpatientHistory(APatientID As %String, AQuestID As %String) As %String
{
	s result = ""
	q:(APatientID = "")||(AQuestID = "") "[]"
	
	s key = $i(^CacheTemp)
	k ^TempEMRMedHistory(key)
	s count = 1
	
	s ds = ##Class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.Service:GetAdmByPatId")
	d ds.Execute(APatientID)
	While (ds.Next())
	{
		d setJson
	}
	
	
	s rowid = $o(^DHCEMRI.MedicalHistoryI("IdxPatientIDQuestID"," "_APatientID,AQuestID,""))
	if (rowid '= "")
	{
		s obj = ##Class(EMRinstance.MedicalHistory).%OpenId(rowid)
		q:(obj = "") result
		s value = obj.Value
		if (value '= "")
		{
			s array = ##Class(EMRservice.Util.Json).FromJson(value)
			
			s arrcount = array.Count()
			for i=1:1:arrcount
			{  
			    s date = array.GetAt(i).GetAt("field0")
			    s reason = array.GetAt(i).GetAt("field1")
			    s long = array.GetAt(i).GetAt("field2")
			    s isSave = "1"
			    
			    s json = "{"
				s json = json_"""field0"":"""_date_"""," 
				s json = json_"""field1"":"""_reason_"""," 
				s json = json_"""field2"":"""_long_""","
				s json = json_"""isSave"":"""_isSave_""""
				s json = json_"}"
				if (date = "")
				{
					s date = $p($h,",",1)
				}
				else
				{
					s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",date)
				}
				s ^TempEMRMedHistory(key,date,count) = json
				s count = count + 1
			} 
		}
	}

	//倒序排序输出
	s tmpdate="",j=0
	for
	{
		s tmpdate = $o(^TempEMRMedHistory(key,tmpdate),-1)
		q:(tmpdate="")

		s order = ""
		for {
			s order = $o(^TempEMRMedHistory(key,tmpdate,order))
			q:(order = "")
			s:(j'=0) result = result_","
			s result = result_^TempEMRMedHistory(key,tmpdate,order)
			s j = j + 1
		}
	}
	
	k ^TempEMRMedHistory(key)
	s result = "["_result_"]"
	s result = $ZSTRIP(result,"*C")
	q result
	q
setJson
	s json = "{"
	s json = json_"""field0"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ds.Data("admdate"))_"""," 
	s json = json_"""field1"":"""_ds.Data("diagstr")_"""," 
	s json = json_"""field2"":"""_ds.Data("days")_""","
	s json = json_"""isSave"":""0"""
	s json = json_"}"
	if (ds.Data("admdate") = "")
	{
		s date = $p($h,",",1)
	}
	else
	{
		s date = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToSysFormat","Date",ds.Data("admdate"))
	}
	s ^TempEMRMedHistory(key,date,count) = json
	s json = ""
	s count = count + 1
	q
}

}
