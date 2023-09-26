/// Desc:       事件配置逻辑类
/// Creator:    Candy
/// CreateDate: 2015-3-24 
Class EMRservice.BL.Event.BLEventConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:        设置事件配置信息
/// Creator:     Candy
/// CreateDate:  2013-3-24
/// Input:       AEventType 事件类型
///              ALinkDocID 关联DOCID
///              ALinkTitleCode 关联标题,多个用"^"分隔
///              ALocation 插入位置
///              APromptMessage 提示信息
///              显示引用内容及格式
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLEventConfig).SetEventConfig("Operation","","","","","")	
ClassMethod SetEventConfig(AEventType As %String, ALinkDocID As %String, ALinkTitleCode As %String, ALocation As %String, APromptMessage As %String, AScheme As %String) As %String
{
	s result = "0"
	q:(AEventType = "")||(ALinkDocID = "")||(APromptMessage = "") result
	s rowId = $o(^DHCEMRM.Events.EventConfigI("IdxEventType"," "_$zcvt(AEventType,"U"),""))
	if (rowId = "") 
	{
		s objEventConfig = ##Class(EMRmeta.Events.EventConfig).%New()
	}
	else
	{
		s objEventConfig = ##Class(EMRmeta.Events.EventConfig).%OpenId(rowId)
	}
	s objEventConfig.EventType = AEventType
	s objEventConfig.LinkDocID = ALinkDocID
	s objEventConfig.LinkTitleCode = ALinkTitleCode
	s objEventConfig.Location = ALocation
	s objEventConfig.PromptMessage =  APromptMessage
	s objEventConfig.Scheme = AScheme
	s:($$$ISOK(objEventConfig.%Save())) result = "1"
	q result
}

/// Desc:        事件配置信息
/// Creator:     Candy
/// CreateDate:  2013-3-24
/// Input:       AEpisodeID 就诊ID
///              AEventType 事件类型
/// Output:      result 
/// Debug:       w ##Class(EMRservice.BL.Event.BLEventConfig).GetEventConfig(76,"CriticalValue")
ClassMethod GetEventConfig(AEpisodeID As %String, AEventType As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "")||(AEventType = "") result
	s configId = $o(^DHCEMRM.Events.EventConfigI("IdxEventType"," "_$zcvt(AEventType,"U"),""))
	q:(configId = "") result
	s objEventConfig = ##Class(EMRmeta.Events.EventConfig).%OpenId(configId)
	q:(objEventConfig = "") result
    s objEmrCategoryDoc = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEventConfig.LinkDocID)
    q:(objEmrCategoryDoc = "") result
    s objEmrCategoryChapter = ##Class(EMRmeta.EMRTemplateCategory).%OpenId(objEmrCategoryDoc.ParentCategoryID)
    q:(objEmrCategoryChapter = "") result
    s categoryId = objEmrCategoryChapter.ParentCategoryID
    s isLeadframe = objEmrCategoryDoc.IsLeadframe
    s isMutex = objEmrCategoryChapter.IsMutex
    s objTemplate = ##Class(EMRservice.BL.BLTemplate).GetTemplateByEMRTmpCateID(objEventConfig.LinkDocID)
    s templateId = objTemplate.ID
    s pluginType = objTemplate.DocumentType
    s chartItemType = objTemplate.ChartItemType
    k objEmrCategoryDoc,objEmrCategoryChapter,objTemplate
	s result = "{"
	s result = result_"""EventType"":"""_objEventConfig.EventType_""""
	s result = result_",""DocID"":"""_objEventConfig.LinkDocID_""""
	s result = result_",""CategoryID"":"""_categoryId_""""
	s result = result_",""IsLeadframe"":"""_isLeadframe_""""
	s result = result_",""IsMutex"":"""_isMutex_""""
	s result = result_",""TemplateId"":"""_templateId_""""
	s result = result_",""PluginType"":"""_pluginType_""""
	s result = result_",""ChartItemType"":"""_chartItemType_""""
	s result = result_",""Location"":"""_objEventConfig.Location_""""
	s result = result_",""TitleCodes"":["
	if ($p(objEventConfig.LinkTitleCode,"^",1) = "")
	{
		s objEMRTemplate=##class(EMRmeta.EMRTemplateCategory).%OpenId(objEventConfig.LinkDocID)
		s titleDesc= objEMRTemplate.CategoryName
		s result = result_"{""TitleCode"":"""_""_""",""TitleDesc"":"""_titleDesc_"""}"
	}
	else
	{
		for i=1:1:$l(objEventConfig.LinkTitleCode,"^")
		{
			s titleCode = $p(objEventConfig.LinkTitleCode,"^",i)
			s titleId = $o(^DHCEMRM.TitlesI("IdxCode"," "_titleCode,""))
			continue:(titleId = "")
			s objTitle = ##Class(EMRmeta.Titles).%OpenId(titleId)
			continue:(objTitle = "")
			s:(i '= 1 ) result = result_","			
			s result = result_"{""TitleCode"":"""_titleCode_""",""TitleDesc"":"""_objTitle.Description_"""}"	
		}
	}
	s result = result_"]}"
	q result
}

/// Desc:        事件提示信息
/// Creator:     Candy
/// CreateDate:  2013-3-24
/// Input:       AEpisodeID 就诊ID
///              AEventType 事件类型
/// Output:      result 
/// Deubg:       w ##Class(EMRservice.BL.Event.BLEventConfig).GetEventPromptMessage("CriticalValue")
ClassMethod GetEventPromptMessage(AEventType As %String) As %String
{
	s result = ""
	q:(AEventType = "") result
	s configId = $o(^DHCEMRM.Events.EventConfigI("IdxEventType"," "_$zcvt(AEventType,"U"),""))
	q:(configId = "") result
	s objEventConfig = ##Class(EMRmeta.Events.EventConfig).%OpenId(configId)
	q:(objEventConfig = "") result
	s result = "{"
	s result = result_"""EventType"":"""_objEventConfig.EventType_""""
	s result = result_",""PromptMessage"":"""_objEventConfig.PromptMessage_""""
	s result = result_"}"	
	q result
}

/// Desc:        取事件显示引用Scheme
/// Creator:     Candy
/// CreateDate:  2013-4-2
/// Input:       AEpisodeID 就诊ID
///              AEventType 事件类型
/// Output:      result 
/// Deubg:       w ##Class(EMRservice.BL.Event.BLEventConfig).GetEventScheme("CriticalValue")
ClassMethod GetEventScheme(AEventType As %String) As %String
{
	s result = ""
	q:(AEventType = "") result
	s configId = $o(^DHCEMRM.Events.EventConfigI("IdxEventType"," "_$zcvt(AEventType,"U"),""))
	q:(configId = "") result
	s objEventConfig = ##Class(EMRmeta.Events.EventConfig).%OpenId(configId)
	q:(objEventConfig = "") result
	s result = objEventConfig.Scheme	
	q result
}

/// Desc:       事件配置数据
/// Creator:    Candy
/// CreateDate: 2015-4-2
Query GetEventConfigData() As %SQLQuery(CONTAINID = 1, ROWSPEC = "EventType,TypeDesc,LinkDocID,LinkTitleCode,PromptMessage,Location,Scheme", SELECTMODE = "RUNTIME") [ SqlName = GetEventConfigData, SqlProc ]
{
	select EventType,TypeDesc,LinkDocID,LinkTitleCode,PromptMessage,Location,Scheme from EMRmeta_Events.EventConfig,EMRmeta_Events.EventType where EventType=TypeCode
}

/// Desc:       事件类型
/// Creator:    Candy
/// CreateDate: 2015-4-2
Query GetEventType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "TypeCode,TypeDesc", SELECTMODE = "RUNTIME") [ SqlName = GetEventType, SqlProc ]
{
	select TypeCode,TypeDesc from EMRmeta_Events.EventType
}

/// Desc:       添加事件类型
/// Creator:    Candy
/// CreateDate: 2015-4-3
/// Input:      ACode 事件代码
///            ADesc 事件描述
/// Output:     result 1成功 0失败
ClassMethod SetEventType(ACode As %String, ADesc As %String) As %String
{
	s result = "0"
	s rowId = $o(^DHCEMRM.Events.EventTypeI("IdxTypeCode"," "_$zcvt(ACode,"U"),""))
	if (rowId = "")
	{
		s obj = ##Class(EMRmeta.Events.EventType).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.Events.EventType).%OpenId(rowId)
	}
	s obj.TypeCode = ACode
	s obj.TypeDesc = ADesc
	s:($$$ISOK(obj.%Save())) result = "1"	
	d obj.%Close()
	s obj = ""
	q result
}

/// Desc:        初始化事件类型
/// Creator:     Candy
/// CreateDate:  2015-4-3
/// Deubg:       d ##Class(EMRservice.BL.Event.BLEventConfig).InitEventType()
ClassMethod InitEventType()
{
	s types = "CriticalValue:危机值^BloodTransfusion:输血^Operation:手术^Rescue:抢救^Manipulate:操作^ModDiagnosis:修正诊断^Consult:会诊^MDTConsult:MDT会诊^DischargeRecord:出院记录^InformedConsent:特殊治疗知情同意书"
	for i=1:1:$l(types,"^")
	{
		s type = $p(types,"^",i)
		s result = ..SetEventType($p(type,":",1),$p(type,":",2))
		q:(result = 0)
	}
}

/// Desc:       初始化事件配置
/// Creator:    Candy
/// CreateDate: 2015-4-9
/// Debug:      d ##Class(EMRservice.BL.Event.BLEventConfig).InitEventConfig() 
ClassMethod InitEventConfig()
{
	s scheme = "<scheme><show><item><code>CriticalValueDate</code><desc>审核日期</desc><hidden>N</hidden></item><item><code>CriticalValueTime</code><desc>审核时间</desc><hidden>N</hidden></item><item><code>LabNo</code><desc>危机值标识</desc><hidden>Y</hidden></item><item><code>CriticalValueDesc</code><desc>危机值描述</desc><hidden>N</hidden></item><item><code>CriticalValue</code><desc>危机值</desc><hidden>N</hidden></item><item><code>ItemRanges</code><desc>值范围</desc><hidden>N</hidden></item><item><code>OEordItemRowID</code><desc>OEordID</desc><hidden>Y</hidden></item><item><code>OEordItemDesc</code><desc>医嘱名称</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item><item><code>IsLink</code><desc>是否关联</desc><hidden>N</hidden></item></show><reference><item><code>CriticalValueDesc</code><desc/><separate>enter</separate></item></reference></scheme>"
	d ..SetEventConfig("CriticalValue","66","","S001","请写危机值记录",scheme)
	s scheme = "<scheme><show><item><code>TransDate</code><desc>输血日期</desc><hidden>N</hidden></item><item><code>TransTime</code><desc>输血时间</desc><hidden>N</hidden></item><item><code>BloodTypeabo</code><desc>ABO血型</desc><hidden>N</hidden></item><item><code>BloodTyperh</code><desc>RH血型</desc><hidden>N</hidden></item><item><code>Content</code><desc>内容</desc><hidden>Y</hidden></item><item><code>Description</code><desc>描述</desc><hidden>N</hidden></item><item><code>OEordItemID</code><desc>医嘱号</desc><hidden>N</hidden></item><item><code>OEordItemDesc</code><desc>医嘱描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show><reference><item><code>BloodTypeabo</code><desc>abo血型:</desc><separate>,</separate></item><item><code>BloodTyperh</code><desc>rh血型:</desc><separate>,</separate></item><item><code>Content</code><desc>内容:</desc><separate>,</separate></item></reference></scheme>"
	d ..SetEventConfig("BloodTransfusion","82","","S001","请写输血病历",scheme)
	s scheme = "<scheme><show><item><code>RescueDate</code><desc>抢救日期</desc><hidden>N</hidden></item><item><code>RescueTime</code><desc>抢救时间</desc><hidden>N</hidden></item><item><code>OEordItemID</code><desc>医嘱ID</desc><hidden>Y</hidden></item><item><code>OEordItemDesc</code><desc>医嘱描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show></scheme>"
	d ..SetEventConfig("Rescue","66","","S001","请写抢救记录病历",scheme)
	s scheme = "<scheme><show><item><code>OperDate</code><desc>手术日期</desc><hidden>N</hidden></item><item><code>OperTime</code><desc>手术时间</desc><hidden>N</hidden></item><item><code>OperID</code><desc>手术ID</desc><hidden>Y</hidden></item><item><code>OperCode</code><desc>手术代码</desc><hidden>N</hidden></item><item><code>OperDesc</code><desc>手术名称</desc><hidden>N</hidden></item><item><code>OperDocID</code><desc>术者ID</desc><hidden>Y</hidden></item><item><code>OperDocName</code><desc>术者</desc><hidden>N</hidden></item><item><code>OperLevel</code><desc>手术级别</desc><hidden>N</hidden></item><item><code>OperAssistFirstID</code><desc>一助ID</desc><hidden>Y</hidden></item><item><code>OperAssistFirstDesc</code><desc>一助</desc><hidden>N</hidden></item><item><code>OperAssistSecondID</code><desc>二助ID</desc><hidden>Y</hidden></item><item><code>OperAssistSecondDesc</code><desc>二助</desc><hidden>N</hidden></item><item><code>OperAssistThirdID</code><desc>三助ID</desc><hidden>Y</hidden></item><item><code>OperAssistThirdDesc</code><desc>三助</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show></scheme>"
	d ..SetEventConfig("Operation","68","","S001","请写手术记录",scheme)
	s scheme = "<scheme><show><item><code>OEordItemDate</code><desc>操作日期</desc><hidden>N</hidden></item><item><code>OEordItemTime</code><desc>操作时间</desc><hidden>N</hidden></item><item><code>OEordItemCreatorName</code><desc>操作医师</desc><hidden>N</hidden></item><item><code>OEordItemID</code><desc>医嘱号</desc><hidden>N</hidden></item><item><code>OEordItemDesc</code><desc>医嘱描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show><reference><item><code>OEordItemDate</code><desc>操作日期:</desc><separate>,</separate></item><item><code>OEordItemTime</code><desc>操作时间:</desc><separate>,</separate></item><item><code>OEordItemDesc</code><desc>医嘱描述:</desc><separate>,</separate></item></reference></scheme>"
	d ..SetEventConfig("Manipulate","66","","S001","请写操作记录",scheme)
	s scheme = "<scheme><show><item><code>DiagnosisDate</code><desc>诊断日期</desc><hidden>N</hidden></item><item><code>DiagnosisTime</code><desc>诊断时间</desc><hidden>N</hidden></item><item><code>UserID</code><desc>用户ID</desc><hidden>Y</hidden></item><item><code>DiagnosisDesc</code><desc>诊断描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show></scheme>"
	d ..SetEventConfig("ModDiagnosis","66","","S001","请写诊断相关记录",scheme)
	s scheme = "<scheme><show><item><code>ConsultID</code><desc>会诊ID</desc><hidden>Y</hidden></item><item><code>ApplyDateTime</code><desc>申请日期时间</desc><hidden>N</hidden></item><item><code>ConsultLoc</code><desc>会诊科室</desc><hidden>N</hidden></item><item><code>ConsultDoctor</code><desc>会诊医生</desc><hidden>N</hidden></item><item><code>FinishDateTime</code><desc>完成日期时间</desc><hidden>N</hidden></item><item><code>ApplyDoctor</code><desc>申请医生</desc><hidden>N</hidden></item><item><code>ConsultType</code><desc>会诊类型</desc><hidden>N</hidden></item><item><code>ConsultStatus</code><desc>会诊状态</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item><item><code>IsLink</code><desc>是否关联</desc><hidden>N</hidden></item><item><code>LinkInstanceID</code><desc>关联病历ID</desc><hidden>N</hidden></item></show><reference><item><code>ConsultType</code><desc/><separate>enter</separate></item><item><code>ConsultLoc</code><desc/><separate>enter</separate></item></reference></scheme>"
	d ..SetEventConfig("Consult","66","EMR100009","S001","请写会诊记录",scheme)
	s scheme = "<scheme><show><item><code>ConsultID</code><desc>会诊ID</desc><hidden>Y</hidden></item><item><code>ApplyDateTime</code><desc>申请日期时间</desc><hidden>N</hidden></item><item><code>ConsultLoc</code><desc>会诊科室</desc><hidden>N</hidden></item><item><code>ConsultDoctor</code><desc>会诊医生</desc><hidden>N</hidden></item><item><code>FinishDateTime</code><desc>完成日期时间</desc><hidden>N</hidden></item><item><code>ApplyDoctor</code><desc>申请医生</desc><hidden>N</hidden></item><item><code>ConsultType</code><desc>会诊类型</desc><hidden>N</hidden></item><item><code>ConsultStatus</code><desc>会诊状态</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item><item><code>IsLink</code><desc>是否关联</desc><hidden>N</hidden></item><item><code>LinkInstanceID</code><desc>关联病历ID</desc><hidden>N</hidden></item></show><reference><item><code>ConsultType</code><desc/><separate>enter</separate></item><item><code>ConsultLoc</code><desc/><separate>enter</separate></item></reference></scheme>"
	d ..SetEventConfig("MDTConsult","66","EMR10000901","S001","请写MDT会诊记录",scheme)
	s scheme = "<scheme><show><item><code>DischargeDate</code><desc>出院日期</desc><hidden>N</hidden></item><item><code>DischargeTime</code><desc>出院时间</desc><hidden>N</hidden></item><item><code>OEordItemID</code><desc>医嘱ID</desc><hidden>Y</hidden></item><item><code>OEordItemDesc</code><desc>医嘱描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show></scheme>"
	d ..SetEventConfig("DischargeRecord","54","","S001","请写出院记录病历",scheme)
	s scheme = "<scheme><show><item><code>OEordItemDate</code><desc>操作日期</desc><hidden>N</hidden></item><item><code>OEordItemTime</code><desc>操作时间</desc><hidden>N</hidden></item><item><code>OEordItemCreatorName</code><desc>操作医师</desc><hidden>N</hidden></item><item><code>OEordItemID</code><desc>医嘱号</desc><hidden>N</hidden></item><item><code>OEordItemDesc</code><desc>医嘱描述</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item></show></scheme>"
	d ..SetEventConfig("InformedConsent","90","","S001","请写特殊治疗知情同意书",scheme)
}

/// Desc:       危急值目录
/// Creator:    Lina
/// DateTime:   2016-6-21
/// Input:      ACTLocId 登录用户科室ID
///             AEpisodeId 就诊号
/// OutPut:     result             
/// w ##Class(EMRservice.BL.Event.BLEventConfig).GetEventCategory(174,"CriticalValue")
ClassMethod GetEventCategory(AEpisodeID As %String, AEventType As %String) As %String
{
	s result = ""
	s count = 0
	q:(AEpisodeID = "")||(AEventType = "") result
	s rowId = ""
	for
	{
		s rowId = $o(^DHCEMRM.Events.EventCategoryI("IdxEventType"," "_$zcvt(AEventType,"U"),rowId))
		q:(rowId = "")
		s obj = ##Class(EMRmeta.Events.EventCategory).%OpenId(rowId)
    	continue:(obj = "")
    	s:(count '= 0) result = result_","
    	s result = result_"{"
    	s result = result_"""ID"":"""_rowId_""""
    	s result = result_",""EventCode"":"""_obj.EventCode_""""
    	s result = result_",""EventDesc"":"""_obj.EventDesc_""""
    	s result = result_",""EventType"":"""_obj.EventType_""""
    	s result = result_"}"
		s count = count + 1
	}
    k obj
	q result
}

/// Desc:       初始化会诊基础数据
/// Creator:    Donglulu
/// DateTime:   2021-6-8
/// Input:      
/// OutPut:               
/// d ##Class(EMRservice.BL.Event.BLEventConfig).InitConsultConfig()
ClassMethod InitConsultConfig()
{
	s scheme = "<scheme><show><item><code>ConsultID</code><desc>会诊ID</desc><hidden>Y</hidden></item><item><code>ApplyDateTime</code><desc>申请日期时间</desc><hidden>N</hidden></item><item><code>ConsultLoc</code><desc>会诊科室</desc><hidden>N</hidden></item><item><code>ConsultDoctor</code><desc>会诊医生</desc><hidden>N</hidden></item><item><code>FinishDateTime</code><desc>完成日期时间</desc><hidden>N</hidden></item><item><code>ApplyDoctor</code><desc>申请医生</desc><hidden>N</hidden></item><item><code>ConsultType</code><desc>会诊类型</desc><hidden>N</hidden></item><item><code>ConsultStatus</code><desc>会诊状态</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item><item><code>IsLink</code><desc>是否关联</desc><hidden>N</hidden></item><item><code>LinkInstanceID</code><desc>关联病历ID</desc><hidden>N</hidden></item></show><reference><item><code>ConsultType</code><desc/><separate>enter</separate></item><item><code>ConsultLoc</code><desc/><separate>enter</separate></item></reference></scheme>"
	d ..SetEventConfig("Consult","66","EMR100009","S001","请写会诊记录",scheme)
}

/// Desc:       初始化MDT会诊基础数据
/// Creator:    Donglulu
/// DateTime:   2021-7-21
/// Input:      
/// OutPut:               
/// d ##Class(EMRservice.BL.Event.BLEventConfig).InitMDTConsultConfig()
ClassMethod InitMDTConsultConfig()
{
	s scheme = "<scheme><show><item><code>ConsultID</code><desc>会诊ID</desc><hidden>Y</hidden></item><item><code>ApplyDateTime</code><desc>申请日期时间</desc><hidden>N</hidden></item><item><code>ConsultLoc</code><desc>会诊科室</desc><hidden>N</hidden></item><item><code>ConsultDoctor</code><desc>会诊医生</desc><hidden>N</hidden></item><item><code>FinishDateTime</code><desc>完成日期时间</desc><hidden>N</hidden></item><item><code>ApplyDoctor</code><desc>申请医生</desc><hidden>N</hidden></item><item><code>ConsultType</code><desc>会诊类型</desc><hidden>N</hidden></item><item><code>ConsultStatus</code><desc>会诊状态</desc><hidden>N</hidden></item><item><code>IsActive</code><desc>是否提示</desc><hidden>N</hidden></item><item><code>IsLink</code><desc>是否关联</desc><hidden>N</hidden></item><item><code>LinkInstanceID</code><desc>关联病历ID</desc><hidden>N</hidden></item></show><reference><item><code>ConsultType</code><desc/><separate>enter</separate></item><item><code>ConsultLoc</code><desc/><separate>enter</separate></item></reference></scheme>"
	d ..SetEventConfig("MDTConsult","66","EMR10000901","S001","请写MDT会诊记录",scheme)
}

}
