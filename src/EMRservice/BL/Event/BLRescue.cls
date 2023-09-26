/// Desc:       抢救事件逻辑类
/// Creator:    Candy
/// CreateDate: 2015-4-1 
Class EMRservice.BL.Event.BLRescue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       抢救记录(数据推送接口)
/// Creator:    Candy
/// CreateDate: 2015-3-23
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 抢救医嘱
///             ARescueDate (cache内部格式) 抢救日期
///             ARescueTime (cache内部格式) 抢救时间
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLRescue).SetData(48,76,"1||1","身体检查",63634,36676)
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, ARescueDate As %String, ARescueTime As %String) As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||(AOEordItemID = "") result
		s obj = ##Class(EMRinstance.Events.Rescue).%New()
		s obj.PatientID = APatientID
		s obj.EpisodeID = AEpisodeID
		s obj.OEordItemID = AOEordItemID
		s obj.OEordItemDesc = AOEordItemDesc
		s obj.RescueDate = ARescueDate
		s obj.RescueTime = ARescueTime
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.IsActive = "Y"	
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取抢救记录
/// Creator:     Candy
/// CreateDate:  2013-3-23
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLRescue).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.RescueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Rescue).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s textField = obj.OEordItemDesc
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""OEordItemID"":"""_obj.OEordItemID_""""
			    	s result = result_",""OEordItemDesc"":"""_obj.OEordItemDesc_""""
			    	s result = result_",""RescueDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(obj.RescueDate,3))_""""
			    	s result = result_",""RescueTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(obj.RescueTime))_""""
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
/// Creator:    Candy
/// CreateDate: 2015-3-25
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
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"Rescue",rowId)
        q:(result = "0")
	}
	q result
}

/// Desc:       设置条目不再提示
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLRescue).SetUnActive(1)
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Rescue).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-09-07
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLRescue).SetActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Rescue).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
