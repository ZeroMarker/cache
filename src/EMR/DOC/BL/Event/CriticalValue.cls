/// Desc:       检验结果危急值事件逻辑类
/// Creator:    lifengbo
/// CreateDate: 2023-04-28
Class EMR.DOC.BL.Event.CriticalValue Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       写入危机值事件数据
/// Creator:    lifengbo
/// CreateDate: 2023-04-28
/// Input:      
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
/// Debug:      w ##Class(EMR.DOC.BL.Event.CriticalValue).SetData(1224,"","","","66596","57115","","血常规","","","1||0000000801||1","1、项目名称：单核细胞比率结果：34(%)    参考范围：4.2-15.2")
/// 			w ##Class(EMR.DOC.BL.Event.CriticalValue).SetData(1224,"","","","66600","57315","","血常规五分类","","","1||0000000312||1","1、项目名称：血红蛋白结果：2.00(g/dl)    参考范围：30-70；2、项目名称：血小板结果：20.00(*10^9/L)    参考范围：100-300")
ClassMethod SetData(AEpisodeID As %String, ALabNo As %String, AValue As %String, ADesc As %String, AValueDate As %String, AValueTime As %String, AOEordItemID As %String, AOEordItemDesc As %String, AItemRanges As %String, AItemUnit As %String, AFromCode As %String = "", AContent As %String = "") As %String
{
		s result = "0"
		q:(AEpisodeID = "")||((ALabNo = "")&&(AFromCode = "")) result
		
		s objCriticalValue = ##Class(EMR.DAO.Events.CriticalValue).doCreateInstance(AEpisodeID)
		s objCriticalValue.FromCode = AFromCode
		s objCriticalValue.Content = AContent
		s objCriticalValue.EpisodeID = ##class(User.PAAdm).%OpenId(AEpisodeID)
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
		b ;1
		s:($$$ISOK(sc)) result = "1"
		q result
}

/// Desc:        取危机值信息
/// Creator:    lifengbo
/// CreateDate: 2023-04-28
/// Input:       AEpisodeID 就诊ID
/// Output:      result 
/// Debug:       w ##Class(EMR.DOC.BL.Event.CriticalValue).GetData(1224)
ClassMethod GetData(AEpisodeID As %String) As %String
{
	s result = ""
	s count = 0
	s TILCriticalValue = ##Class(EMR.DAO.Events.CriticalValue).GetTureIndexLocation(AEpisodeID)	
	s TILLinkDocument = ##Class(EMR.DAO.Events.LinkDocument).GetTureIndexLocation(AEpisodeID)	
	s jsonArr=[]
	q:(AEpisodeID = "") result
	s flag = ""
	for
	{
		s flag = $o(@TILCriticalValue@("IdxEpisodeIsActive",AEpisodeID,flag),-1)
		q:(flag = "")	
		s date = ""
		for
		{
		    s date = $o(@TILCriticalValue@("IdxEpisodeIsActive",AEpisodeID,flag,date),-1)
		    q:(date = "")
		    s time = ""
		    for
		    {
		    	s time = $o(@TILCriticalValue@("IdxEpisodeIsActive",AEpisodeID,flag,date,time),-1)
		    	q:(time = "")
		    	s rowId = "" 
			    for
			    {
			    	s rowId = $o(@TILCriticalValue@("IdxEpisodeIsActive",AEpisodeID,flag,date,time,rowId))
			    	q:(rowId = "")
			    	s text = ""
			    	s documentId = ""
			    	for
			    	{
			    		s documentId = $o(@TILLinkDocument@("IdxMain",AEpisodeID," "_$zcvt("CriticalValue","U"),rowId,documentId))
			    		q:(documentId = "")
			    		
			    		s objDocument = ##Class(EMR.DAO.DocumentData).doOpenByID(AEpisodeID,documentId)
			    		continue:(objDocument.Status '= "Save")
			    		s text = objDocument.TemplateCategoryID.EMRName
			    	}
			    	s obj = ##Class(EMR.DAO.Events.CriticalValue).doOpenByID(AEpisodeID,rowId)
			    	continue:(obj = "")
			    	
			    	s isLink = "未关联"
			    	s linkInstanceID = ##Class(EMR.DOC.BL.Event.LinkDocument).GetLinkDocumentID(AEpisodeID,"CriticalValue",rowId)
			    	s:(linkInstanceID '= "") isLink = "已关联"
			    	
			    	s textField = obj.OEordItemDesc
			    	s jsonSub={}
			    	
			    	
			    	s jsonSub.ID = rowId
			    	s jsonSub.LabNo=obj.LabNo
			    	s jsonSub.FromCode=obj.FromCode
			    	s jsonSub.Content=obj.Content
			    	s jsonSub.CriticalValue=obj.CriticalValue
			    	s jsonSub.CriticalValueDesc=obj.CriticalValueDesc
			    	s jsonSub.ItemUnit=obj.ItemUnit
			    	s jsonSub.ItemRanges=obj.ItemRanges
			    	s jsonSub.CriticalValueDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",$zd(obj.CriticalValueDate,3))
			    	s jsonSub.CriticalValueTime=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Time",$zt(obj.CriticalValueTime))
			    	s jsonSub.OEordItemRowID=obj.OEordItemRowID
			    	s jsonSub.OEordItemDesc=obj.OEordItemDesc
			    	s jsonSub.LinkInstanceID=linkInstanceID
			    	s jsonSub.IsLink=isLink
			    	s jsonSub.TextField=textField
			    	s jsonSub.IsActive=$case(obj.IsActive,"Y":"提示",:"不提示")
			    	s jsonSub.TextDesc=text
			    	
			    	d jsonArr.%Push(jsonSub)
				}
		    }
		}
	}
	s result=jsonArr.%ToJSON()
	q result
}

/// Desc:       更改危机值已完成状态
/// Creator:    Candy
/// CreateDate: 2015-3-25
/// Input:      AIDs 以","分隔
///             AEpisodeID 就诊号
/// OutPut:     result 
ClassMethod SetFinish(AEpisodeID As %String, AIDs As %String, ADocumentID As %String, AUserID As %String = "") As %String
{
	s result = "0"
	q:(AIDs = "") result
	d ..SetUnActive(AEpisodeID, AIDs)
	
	for i=1:1:$l(AIDs,"@")
	{
		s rowId = $p(AIDs,"@",i)
		continue:(rowId = "")
		
		s obj = ##Class(EMR.DAO.Events.CriticalValue).doOpenByID(AEpisodeID,rowId)
		continue:(obj = "")
		s fromCode = obj.FromCode
		
			
		s result = ##Class(EMR.DOC.BL.Event.LinkDocument).SaveLinkDocumnet(AEpisodeID, ADocumentID,"CriticalValue",rowId,fromCode,AUserID)
        q:(result = "0")
        
		d ##Class(EMR.DOC.BL.Event.CriticalValue).InvokInterface(fromCode,ADocumentID,AUserID)
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
ClassMethod SetUnActive(AEpisodeID As %String, AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMR.DAO.Events.CriticalValue).doOpenByID(AEpisodeID,id) 
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
	
	s TILCriticalValue = ##Class(EMR.DAO.Events.CriticalValue).GetTureIndexLocation(AEpisodeID)	
	s result = $o(@TILCriticalValue@("IdxFromCode"," "_AFromCode,""))
	q result
}

/// Desc:       设置条目再次提示
/// Creator:    王煜
/// CreateDate: 2021-09-07
/// Input:      AID 表的rowID
/// Output:     result 1成功 0失败
/// Debug:      w ##Class(EMRservice.BL.Event.BLCriticalValue).SetActive(1)
ClassMethod SetActive(AEpisodeID As %String, AIDs As %String) As %String
{
	s result = "0"
	q:(AIDs = "") result
	for i=1:1:$l(AIDs,"@")
	{
		s id = $p(AIDs,"@",i)
		s obj = ##Class(EMR.DAO.Events.CriticalValue).doOpenByID(AEpisodeID,id) 
		continue:(obj = "")
		s obj.IsActive = "Y"
		s:($$$ISOK(obj.%Save())) result = "1"
		q:(result = "0")
	}
	q result
}

}
