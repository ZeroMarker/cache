/// Desc:       检验结果危急值事件逻辑类
/// Creator:    Candy
/// CreateDate: 2015-3-23 
Class EMRservice.BL.Event.BLCriticalValue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写入危机值事件数据
/// Creator:    Candy
/// CreateDate: 2015-3-23
/// Input:      APatientID 病人ID
///             AEpisodeID 就诊号
///             ALabNo 标本号
///             AValue  危机值
///             ADesc 危机值描述
///             AValueDate(cache内部格式) 报告日期
///             AValueTime(cache内部格式) 报告时间
///             AOEordItemID 医嘱ID
///             AOEordItemDesc 医嘱描述
///             AItemRanges 值范围
///             AItemUnit 单位
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLCriticalValue).SetData(48,76,"5||1",100,"w",63634,36676,"1||1","qq","1-2","a")
ClassMethod SetData(APatientID As %String, AEpisodeID As %String, ALabNo As %String, AValue As %String, ADesc As %String, AValueDate As %String, AValueTime As %String, AOEordItemID As %String, AOEordItemDesc As %String, AItemRanges As %String, AItemUnit As %String, AFromCode As %String = "", AContent As %String = "") As %String
{
		s result = "0"
		q:(APatientID = "")||(AEpisodeID = "")||((ALabNo = "")&&(AFromCode = "")) result
		s objCriticalValue = ##Class(EMRinstance.Events.CriticalValue).%New()
		s objCriticalValue.FromCode = AFromCode
		s objCriticalValue.Content = AContent
		s objCriticalValue.PatientID = APatientID
		s objCriticalValue.EpisodeID = AEpisodeID
		s objCriticalValue.LabNo = ALabNo
		s objCriticalValue.CriticalValue = AValue
		s objCriticalValue.CriticalValueDesc = ADesc
		s objCriticalValue.CriticalValueDate = AValueDate
		s objCriticalValue.CriticalValueTime = AValueTime
		s objCriticalValue.OEordItemRowID = AOEordItemID
		s objCriticalValue.OEordItemDesc = AOEordItemDesc
		s objCriticalValue.ItemRanges =  AItemRanges
		s objCriticalValue.ItemUnit = AItemUnit
		s objCriticalValue.CreateDate = $p($h,",",1)
		s objCriticalValue.CreateTime = $p($h,",",2)
		s objCriticalValue.IsActive = "Y"	
		s sc = objCriticalValue.%Save()
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取危机值信息
/// Creator:     Candy
/// CreateDate:  2013-3-23
/// Modified:    Lina--倒序排列,添加病历名称TextDesc字段
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLCriticalValue).GetData(76)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID,flag),-1)
		q:(flag = "")	
		s date = ""
		for
		{
		    s date = $o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(^DHCEMRI.Events.CriticalValueI("IdxEpisodeIsActive"," "_AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s text = ""
			    	s InstanceId = ""
			    	for
			    	{
			    		s InstanceId = $o(^DHCEMRI.Events.LinkDocumnentsI("IdxMain"," "_AEpisodeID," "_$zcvt("CriticalValue","U")," "_rowId,InstanceId))
			    		q:(InstanceId = "")
			    		s tempInstanceId = $tr(InstanceId," ","")
			    		s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tempInstanceId)
			    		continue:(objInstance.Status '= "Save")
			    		s text = objInstance.Title
			    	}
			    	s obj = ##Class(EMRinstance.Events.CriticalValue).%OpenId(rowId)
			    	continue:(obj = "")
			    	
			    	s isLink = "未关联"
			    	s linkInstanceID = ##Class(EMRservice.BL.Event.BLLinkDocument).GetLinkInstanceID(AEpisodeID,"CriticalValue",rowId)
			    	s:(linkInstanceID '= "") isLink = "已关联"
			    	
			    	s textField = obj.OEordItemDesc
			    	
			    	s:(count '= 0) result = result_","
			    	s result = result_"{"
			    	s result = result_"""ID"":"""_rowId_""""
			    	s result = result_",""LabNo"":"""_obj.LabNo_""""
			    	s result = result_",""FromCode"":"""_obj.FromCode_""""
			    	s result = result_",""Content"":"""_obj.Content_""""
			    	s result = result_",""CriticalValue"":"""_obj.CriticalValue_""""
			    	s result = result_",""CriticalValueDesc"":"""_obj.CriticalValueDesc_""""
			    	s result = result_",""ItemUnit"":"""_obj.ItemUnit_""""
			    	s result = result_",""ItemRanges"":"""_obj.ItemRanges_""""
			    	s result = result_",""CriticalValueDate"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(obj.CriticalValueDate,3))_""""
			    	s result = result_",""CriticalValueTime"":"""_##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(obj.CriticalValueTime))_""""
			    	s result = result_",""OEordItemRowID"":"""_obj.OEordItemRowID_""""
			    	s result = result_",""OEordItemDesc"":"""_obj.OEordItemDesc_""""
			    	s result = result_",""LinkInstanceID"":"""_linkInstanceID_""""
			    	s result = result_",""IsLink"":"""_isLink_""""
			    	s result = result_",""TextField"":"""_textField_""""
			    	s result = result_",""IsActive"":"""_$case(obj.IsActive,"Y":"提示",:"不提示")_""""
			    	s result = result_",""TextDesc"":"""_text_""""
			    	s result = result_"}"
			    	s count = count + 1
				}
		    }
		}
	}
	q result
}

/// Desc:       更改危机值已完成状态
/// Creator:    Candy
/// CreateDate: 2015-3-25
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result 
ClassMethod SetFinish(AIDs As %String, AInstanceID As %String, AUserID As %String = "") As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AIDs)
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		
		s obj = ##Class(EMRinstance.Events.CriticalValue).%OpenId(rowId)
		continue:(obj = "")
		s fromCode = obj.FromCode
			    	
		s result = ##Class(EMRservice.BL.Event.BLLinkDocument).SaveLinkDocumnet(AInstanceID,"CriticalValue",rowId,fromCode,AUserID)
        q:(result = "0")
        
		d ##Class(EMRservice.BL.Event.BLCriticalValue).InvokInterface(fromCode,AInstanceID,AUserID)
	}
	q result
}

/// Desc:调用接口，将病历ID传回
/// Creator:Donglulu
/// CreateDate:2021-4-12
/// Input: AFromType 产品来源类型
///        AFromCode 关联产品ID
///        AInstanceID 关联病历ID
ClassMethod InvokInterface(AFromCode As %String, AInstanceID As %String, AUserID As %String) As %String
{
	q:(##class(%Dictionary.CompiledClass).%ExistsId("web.DHCAntCVReportLink") = "0")
	q:(##class(%Dictionary.CompiledMethod).%ExistsId("web.DHCAntCVReportLink||SaveTransEMR") = "0")
	d ##class(web.DHCAntCVReportLink).SaveTransEMR(AFromCode,AInstanceID,AUserID)
}

/// Desc:       设置条目不再提示
/// Creator:    Candy
/// CreateDate: 2015-4-8
/// Input:      AIDs 表的rowID 多个以"^"分隔
/// Output:     result 1成功 0失败
ClassMethod SetUnActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.CriticalValue).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "N"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

/// Desc:       根据FromCode获取eventID
/// Creator:    Donglulu
/// CreateDate: 2021-4-12
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLCriticalValue).GetEventIDByFromCode(1)
ClassMethod GetEventIDByFromCode(AFromCode As %String) As %String
{
	s result = ""
	q:(AFromCode = "") result	
	s result = $o(^DHCEMRI.Events.CriticalValueI("IdxFromCode"," "_AFromCode,""))
	q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-09-07
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLCriticalValue).SetActive(1)
ClassMethod SetActive(AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMRinstance.Events.CriticalValue).%OpenId(id)
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
