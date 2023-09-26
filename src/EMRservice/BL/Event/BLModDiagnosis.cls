/// Desc:       诊断事件逻辑类
/// Creator:    yejian	
/// CreateDate: 2018-8-29 
Class EMRservice.BL.Event.BLModDiagnosis Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       诊断修正记录(数据推送接口)
/// Creator:    yejian
/// CreateDate: 2018-8-29
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AUserID 用户ID（修改诊断用户）
/// 				ADiagnosisDesc 修改诊断描述(默认为空)
///             ARescueDate (cache内部格式) 诊断日期
///             ARescueTime (cache内部格式) 诊断时间
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLModDiagnosis).SetData(48,76,"34","",63634,36676)
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AUserID As %String, ADiagnosisDesc As %String = "", ADiagnosisDate As %String, ADiagnosisTime As %String) As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||(AUserID = "") result
		s obj = ##Class(EMRinstance.Events.ModDiagnosis).%New()
		s obj.PatientID = APatientID
		s obj.EpisodeID = AEpisodeID
		s obj.UserID = AUserID
		s obj.DiagnosisDesc = $case(ADiagnosisDesc,"":"诊断修正",:ADiagnosisDesc)
		s obj.DiagnosisDate = ADiagnosisDate
		s obj.DiagnosisTime = ADiagnosisTime
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.IsActive = "Y"	
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取诊断记录
/// Creator:     yejian
/// CreateDate:  2018-8-29
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLModDiagnosis).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.ModDiagnosisI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.ModDiagnosis).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s textField = obj.DiagnosisDesc
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""UserID"":"""_obj.UserID_""""
			    	s result = result_",""DiagnosisDesc"":"""_obj.DiagnosisDesc_""""
			    	s result = result_",""DiagnosisDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(obj.DiagnosisDate,3))_""""
			    	s result = result_",""DiagnosisTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(obj.DiagnosisTime))_""""
			    	s result = result_",""TextField"":"""_textField_""""
			    	s result = result_",""IsActive"":"""_$case(obj.IsActive,"Y":"提示",:"不提示")_""""
			    	s result = result_"}"
			    	s count = count + 1
				}
		    }
		}			
	}
	q result
}

/// Desc:       更改已完成状态并关联病历
/// Creator:    yejian
/// CreateDate: 2018-8-29
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result 
ClassMethod SetFinish(AIDs As %String, AInstanceID As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AIDs)
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"ModDiagnosis",rowId)
        q:(result = "0")
	}
	q result
}

/// Desc:       设置条目不再提示
/// Creator:    yejian
/// CreateDate: 2018-8-29
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLModDiagnosis).SetUnActive(1)
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.ModDiagnosis).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-11-22
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLOperation).SetActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.ModDiagnosis).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
