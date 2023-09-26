/// Desc:       操作事件逻辑类
/// Creator:    董璐璐
/// CreateDate: 2017-9-12 
Class EMRservice.BL.Event.BLManipulate Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       操作记录
/// Creator:    Donglulu
/// CreateDate: 2017-9-12
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             AOEordItemID 操作医嘱ID
///             AOEordItemDesc 操作医嘱描述
///             AOEordItemCreator 操作医嘱创建人
///             AOEordItemDate 开医嘱日期(cache内部格式)
///             AOEordItemTime 开医嘱时间(cache内部格式)
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLManipulate).SetData(170,230,"1||1","身体检查",359,"孙凤霞",63634,36676)
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, AOEordItemID As %String, AOEordItemDesc As %String, AOEordItemCreatorID As %String, AOEordItemCreatorName As %String, AOEordItemDate As %String, AOEordItemTime As %String) As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||(AOEordItemID = "") result
		s obj = ##Class(EMRinstance.Events.Manipulate).%New()
		s obj.PatientID = APatientID
		s obj.EpisodeID = AEpisodeID
		s obj.OEordItemID = AOEordItemID
		s obj.OEordItemDesc = AOEordItemDesc
		s obj.OEordItemCreatorID = AOEordItemCreatorID
		s obj.OEordItemCreatorName = AOEordItemCreatorName
		s obj.OEordItemDate = AOEordItemDate
		s obj.OEordItemTime = AOEordItemTime
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.IsActive = "Y"	
		s sc = obj.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取操作记录
/// Creator:     董璐璐
/// CreateDate:  2017-9-12 
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLManipulate).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.ManipulateI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s obj = ##Class(EMRinstance.Events.Manipulate).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s textField = obj.OEordItemDesc
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""OEordItemID"":"""_obj.OEordItemID_""""
			    	s result = result_",""OEordItemDesc"":"""_obj.OEordItemDesc_""""
			    	s result = result_",""OEordItemCreatorID"":"""_obj.OEordItemCreatorID_""""
			    	s result = result_",""OEordItemCreatorName"":"""_obj.OEordItemCreatorName_""""
			    	s result = result_",""OEordItemDate"":"""_$zd(obj.OEordItemDate,3)_""""
			    	s result = result_",""OEordItemTime"":"""_$zt(obj.OEordItemTime)_""""
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
/// Creator:    董璐璐
/// CreateDate: 2017-9-12 
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
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"Manipulate",rowId)
        q:(result = "0")
	}
	q result
}

/// Desc:       设置条目不再提示
/// Creator:    董璐璐
/// CreateDate: 2017-9-12 
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.Manipulate).%OpenId(id)
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
		s obj = ##Class(EMRinstance.Events.Operation).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
