/// Desc:       打散数据-保存ScetionData
/// Creator:    Candyxu
/// CreateDate: 2014-6-27
Class web.DHCCM.EMRservice.BL.BLScatterData Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       解析打散的数据
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AScatterData 反序列化的打散Data
///             AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod BuildIndexData(AScatterData As EMRservice.Parser.NIScatterData, AInstanceID As %String, AKey As %String)
{
	s count = AScatterData.Sections.Count()
	for i=1:1:count
	{
		s sctionCode = $zcvt(AScatterData.Sections.GetAt(i).Code,"U")
		s ^tmpNewSection(AKey,AInstanceID,sctionCode)= AScatterData.Sections.GetAt(i).Text
		s ^tmpNewSection(AKey,AInstanceID,sctionCode,"StyleText")= AScatterData.Sections.GetAt(i).StyleText
		s ccount = AScatterData.Sections.GetAt(i).Composites.Count()
		for j=1:1:ccount
		{
			s compsiteCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).Code,"U")
			s ^tmpNewComposite(AKey,AInstanceID,sctionCode,compsiteCode) = AScatterData.Sections.GetAt(i).Composites.GetAt(j).Text 
			s ^tmpNewComposite(AKey,AInstanceID,sctionCode,compsiteCode,"StyleText") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).StyleText
			s scount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.Count()
			for k=1:1:scount
			{
				if (AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept '= "")
				{
					s conceptCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Code,"U")
					s ^tmpNewCompositeConcept(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode) = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.Text
					s ^tmpNewCompositeConcept(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,"StyleText") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.StyleText
					s ccscount = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.Count()
				    for l=1:1:ccscount
				    {
						s conceptSimpleCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Code,"U")
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"ValueCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).ValueCode
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"DataValue") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).DataValue
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"DataRef") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).DataRef
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"Separator") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Separator
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"Type") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).CompositeConcept.SubItems.GetAt(l).Type
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"BindKBCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).BindKBBaseID
						s ^tmpNewConceptSimple(AKey,AInstanceID,sctionCode,compsiteCode,conceptCode,conceptSimpleCode,"KBNodeID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).KBNodeID
					}						
				}
				else
				{
					s compositeSimpleCode = $zcvt(AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Code,"U")
					continue:(""=compositeSimpleCode)
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"ValueCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).ValueCode
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"DataValue") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).DataValue
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"DataRef") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).DataRef
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"Separator") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Separator
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"Type") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).SubItems.GetAt(k).Type
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"BindKBCode") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).BindKBBaseID
					s ^tmpNewSimple(AKey,AInstanceID,sctionCode,compsiteCode,compositeSimpleCode,"KBNodeID") = AScatterData.Sections.GetAt(i).Composites.GetAt(j).KBNodeID
				}

			}
		}
		if (AScatterData.Sections.GetAt(i).Sections.Count()>0)
		{
			s tmpScatterData = ##Class(EMRservice.Parser.NIScatterData).%New()
			s tmpScatterData.Sections = AScatterData.Sections.GetAt(i).Sections
			d ..BuildIndexData(tmpScatterData,AInstanceID,AKey)
		}
	}
}

/// Desc：      保存打散数据
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod Save(AInstanceID As %String, AKey As %String) As %String
{
	s $zt = "Error"
	s result = -1
	q:(AInstanceID="")||(AKey="") result
	Tstart
	s reSction = ##Class(web.DHCCM.EMRservice.BL.BLIScetionDesc).Save(AInstanceID,AKey)
	q:(reSction = -1) result
	s reComposite = ##Class(web.DHCCM.EMRservice.BL.BLICompositeDesc).Save(AInstanceID,AKey)
	if (reComposite = -1)
	{
		Trollback
		q result
	}
	s reConcept = ##Class(web.DHCCM.EMRservice.BL.BLICompositeConcept).Save(AInstanceID,AKey)
	if (reConcept = -1)
	{
		Trollback
		q result
	}
	s reConceptSimple = ##Class(web.DHCCM.EMRservice.BL.BLICompositeConceptSimple).Save(AInstanceID,AKey)
	if (reConceptSimple = -1)
	{
		Trollback
		q result
	}	
	s reCompositeSimple = ##Class(web.DHCCM.EMRservice.BL.BLICompositeSimple).Save(AInstanceID,AKey)
	if (reCompositeSimple = -1)
	{
		Trollback
		q result	
	}
	TCOMMIT
	d ..ClearSectionGlobal(AInstanceID,AKey)
    d ..ClearCompositeGlobal(AInstanceID,AKey)
    d ..ClearSimpleGlobal(AInstanceID,AKey)
    d ..ClearCompositeConcept(AInstanceID,AKey)
    d ..ClearCompositeConceptSimple(AInstanceID,AKey)
   	s result = 1 
	q result
Error
    Trollback
    q -1
}

/// Desc 清除章节临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearSectionGlobal(AInstanceID As %String, AKey As %String)
{
	k ^tmpNewSection(AKey,AInstanceID)
   	k ^tmpDeleteSection(AKey,AInstanceID)
   	k ^tmpUpdateSection(AKey,AInstanceID)
   	k ^tmpInsertSection(AKey,AInstanceID)
}

/// Desc 清除复合元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearCompositeGlobal(AInstanceID As %String, AKey As %String)
{
	k ^tmpNewComposite(AKey,AInstanceID)
    k ^tmpDeleteComposite(AKey,AInstanceID)
	k ^tmpUpdateComposite(AKey,AInstanceID)
	k ^tmpInsertComposite(AKey,AInstanceID)
}

/// Desc 清除简单元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearSimpleGlobal(AInstanceID As %String, AKey As %String)
{
    k ^tmpNewSimple(AKey,AInstanceID)
    k ^tmpDeleteSimple(AKey,AInstanceID)
	k ^tmpUpdateSimple(AKey,AInstanceID)
	k ^tmpInsertSimple(AKey,AInstanceID)
}

/// Desc 清除医学概念元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码 
ClassMethod ClearCompositeConcept(AInstanceID As %String, AKey As %String)
{
	k ^tmpNewCompositeConcept(AKey,AInstanceID)
	k ^tmpDeleteCompositeConcept(AKey,AInstanceID)
	k ^tmpUpdateCompositeConcept(AKey,AInstanceID)
	k ^tmpInsertCompositeConcept(AKey,AInstanceID)
}

/// Desc 清除医学概念简单元素临时global
/// Creator:    Candyxu
/// CreateDate: 2014-7-1
/// Input:      AInstanceID 实例数据ID
///             AKey 唯一识别码
ClassMethod ClearCompositeConceptSimple(AInstanceID As %String, AKey As %String)
{
	k ^tmpNewConceptSimple(AKey,AInstanceID)
	k ^tmpDeleteConceptSimple(AKey,AInstanceID)
	k ^tmpUpdateConceptSimple(AKey,AInstanceID)
	k ^tmpInsertConceptSimple(AKey,AInstanceID)
}

/// Desc:       取打散数据
/// Creator:    Candy
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///             AItem 单元路径 TYPE:ICompositeSample#TID:81#SCODE:S001|CCODE:VK1|CSCODE:L010#VTYPE:V
///             AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetScatterData(76,""BindCode":"入院记录.体 格 检 查..皮肤黏膜#TYPE:ICompositeSample#TID:2#SCODE:S009|CCODE:V001|CSCODE:M011#VTYPE:Mult","")           
ClassMethod GetScatterData(AEpisodeID As %String, AItem As %String, AInstanceID As %String) As %String
{
	s $ZT="ERROR"	
	s result = ""
	q:(AEpisodeID = "") result
	s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(AItem,"#")
	q:($ll(ItemList) '= 4) result
	s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
	s templateId = $p($lg(ItemList,2),":",2)
	s itemCode = $lg(ItemList,3)
	s valueType = $p($lg(ItemList,4),":",2)
	if (elementType = "ISECTIONDESC")
	{	
		s rowId = ..GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetSectionData(rowId,valueType)
	}
	elseif(elementType = "ICOMPOSITEDESC")
	{
		s rowId = ..GetCompositeID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetCompositeData(rowId,valueType)		
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		s rowId = ..GetCompositeSimpleID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ..GetCompositeSimpleData(rowId,valueType)
	}
	q result
ERROR
    q "ERROR"
}

/// Desc:       根据单元代码取所有病历打散数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///            AItem #TYPE:ICOMPOSITESAMPLE#SCODE:S010|CCODE:V001|CSCODE:L013#TID:88#VTYPE:V
/// Output:     result 数组 key:病历ID value:单元值
/// Debug:
ClassMethod GetScatterDatas(AEpisodeID As %String, AItem As %String, ATemplateID As %String, AValueType As %String) As %ArrayOfDataTypes
{
	s $ZT="ERROR"
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $Case(AValueType,"":"V",:AValueType)
	if (elementType = "ISECTIONDESC")
	{
		s code = $p($p(AItem,"#",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId,""))
			s value = ..GetSectionData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	} 
	elseif (elementType = "ICOMPOSITEDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId,""))
			s value = ..GetCompositeData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICOMPOSITESAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ..GetCompositeSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	q result
	
ERROR
    q "ERROR"
}

/// Desc:       取知识库打散数据集
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///            AItem #TYPE:ICOMPOSITESAMPLE#SCODE:CCODE:104|CSCODE:L001# 
ClassMethod GetKBScatterDatas(AEpisodeID As %String, APItem As %String, AItem As %String, ATemplateID As %String, AKBNodeID As %String, AValueType As %String) As %ArrayOfDataTypes
{
	s $ZT="ERROR"
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")||(AKBNodeID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $case(AValueType,"":"V",:AValueType)
	if (elementType = "ICOMPOSITEDESC")
	{
		q result
	}
	elseif (elementType = "ICOMPOSITESAMPLE")
	{
		s scode = $p($p($p(APItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",1),":",3)
		s cscode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCPHI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ..GetCompositeSimpleData(rowId,vtype)
			d result.SetAt(value,tmpInstanceId)
		}		
	}
	q result
	
ERROR
    q "ERROR"
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionID(76,2,"Code:S001","")
ClassMethod GetSectionID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p(ACode,":",2)
	s SCode = $zcvt(sCode,"U")
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""))
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeID(76,2,"SCode:S001|CCode:29","")
ClassMethod GetCompositeID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2)
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}	
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId,""))
	q result
}

/// Desc:       返回CompositeSimple的rowID
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleID(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetCompositeSimpleID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s cCode = $p($p(ACode,"|",2),":",2) 
	s csCode = $p($p(ACode,"|",3),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s cCode = $zcvt(cCode,"U")
	s csCode = $zcvt(csCode,"U")
	
	if (AInstanceID = "")
	{
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			q:($zcvt(objInstance.Status,"U") = "SAVE")
		}		
	}
	else
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""))
	q result
}

/// Desc:       取Section内容
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ISectionDesc 的 rowID
///            AVType 取值类型
/// Output:     单元值
/// Debug w ##Class(EMRservice.BL.BLScatterData).GetSectionData("1","")
ClassMethod GetSectionData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objSection = ##Class(User.DHCPHISectionDesc).%OpenId(AID)
	q:(objSection = "") result
	
	if (AVType = "T")
	{ 
		do objSection.Text.Rewind()
		while (objSection.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objSection.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif (AVType = "S")
	{
		do objSection.StyleText.Rewind()
		while (objSection.StyleText.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objSection.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	q result
}

/// Desc:       取Composite内容
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ICompositeDesc 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetCompositeData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objComposite = ##Class(User.DHCPHICompositeDesc).%OpenId(AID)
	q:(objComposite = "") result
	
	if (AVType = "T")
	{
		do objComposite.Text.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.Text.Read(len)
	    	s result = result_tmpStr  
	   	}
	}
	elseif( AVType = "S")
	{
		do objComposite.StyleText.Rewind()
		while (objComposite.Text.AtEnd = 0) 
	  	{ 	s len = 1024
	    	s tmpStr = objComposite.StyleText.Read(len)
	    	s result = result_tmpStr  
	   	}	
	}
	q result
}

/// Desc: 	   取CompositeSimple数据
/// Creator:    Candy
/// CreateDate: 2014-7-24
/// Input:      AID EMRinstance.ICompositeSimple 的 rowID
///            AVType 取值类型
/// Output:     单元值
ClassMethod GetCompositeSimpleData(AID As %String, AVType As %String) As %String
{
	s result = ""
	q:(AID = "") result
	s objCompositeSimple = ##Class(User.DHCPHICompositeSimple).%OpenId(AID)
	q:(objCompositeSimple = "") result
	if ((AVType = "")||(AVType = "V"))
	{
		s result = objCompositeSimple.DataValue
	}
	elseif(AVType = "C")
	{
		s result = objCompositeSimple.ValueCode
	}
	elseif(AVType = "I")
	{
		s result = objCompositeSimple.DataRef
	}
	elseif (AVType = "VC")
	{
		s result = objCompositeSimple.ValueCode_objCompositeSimple.DataValue
	}
	elseif (AVType = "CV")
	{
		s result = objCompositeSimple.DataValue_objCompositeSimple.ValueCode
	}
	elseif (AVType = "VANDC")
	{
		s result = objCompositeSimple.DataValue_"^"_objCompositeSimple.ValueCode
	}
	elseif (AVType = "CANDV")
	{
		s result = objCompositeSimple.ValueCode_"^"_objCompositeSimple.DataValue
	}
	elseif (AVType = "YEAR")
	{
		//YYYY
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",1)
	}
	elseif (AVType = "MONTH")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",2)	
	}
	elseif (AVType = "DAY")
	{
		//DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",3)	
	}
	elseif (AVType = "HOUR")
	{
		//HH
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",1)	
	}
	elseif (AVType = "MINUTE")
	{
		//MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",2)	
	}
	elseif (AVType = "SECOND")
	{
		//SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",3)		
	}
	elseif (AVType = "YMDHM")
	{
		//YYYY-MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "MDHM")
	{
		//MM-DD HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempData = $e(tempData,6,$l(tempData))
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "YMD")
	{
		//YYYY-MM-DD
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zd(objCompositeSimple.DataValue,3)
	}
	elseif (AVType = "HMS")
	{
		//HH:MM:SS
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue)
	}
	elseif (AVType = "HM")
	{
		//HH:MM
		q:(objCompositeSimple.Type'="MIDateTime") result
		s result = $zt(objCompositeSimple.DataValue,2)
	}
	elseif(AVType = "Dict")
	{
		s rowID = objCompositeSimple.DataRef
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = rowID_"|"_code_"|"_desc
	}
	elseif(AVType = "Mono")
	{
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s result = code_"|"_desc
	}
	elseif(AVType = "Mult")
	{
		s result = ""
		s code = objCompositeSimple.ValueCode
		s desc = objCompositeSimple.DataValue
		s separator = objCompositeSimple.Separator
		s count = $l(code,separator)
		for I=1:1:count
		{
			s:(I '= 1) result = result_"#"
			s result = result_$p(code,separator,I)_"|"_$p(desc,separator,I)
		}
	}
	q result
}

/// Desc:       取模板打散数据
/// Creator:    yejian
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///            AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///            AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetTGScatterData(76,"TYPE:ICompositeSample#TID:2#SCODE:S005|CCODE:32|CSCODE:L001#VTYPE:V","")           
ClassMethod GetTGScatterData(AEpisodeID As %String, templateId As %String, AInstanceID As %String, itemCode As %String, valueType As %String, elementType As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	q:(AInstanceID ="") result
	s rowId =""
	if (elementType = "ISECTIONDESC")
	{	
		if (templateId'="-1")
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		else
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetSectionIDBySecCode(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetSectionData(rowId,valueType)
	}
	elseif(elementType = "ICOMPOSITEDESC")
	{
		s rowId = ##Class(EMRservice.BL.BLScatterData).GetCompositeID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(rowId,valueType)		
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		if (templateId'="-1")
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleID(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		else
		{
			s rowId = ##Class(EMRservice.BL.BLScatterData).GetComSimIDBySecSimCode(AEpisodeID,templateId,itemCode,AInstanceID)
	
		}
		q:(rowId = "") result
		s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(rowId,valueType)
	}
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    yejian
/// CreateDate: 2016-3-22
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionIDBySecCode(76,2,"Code:S001","")
ClassMethod GetSectionIDBySecCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
	s sCode = $p(ACode,":",2)
	s SCode = $zcvt(sCode,"U")
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s result = $o(^DHCPHI.ISectionDescI("IdxForUpdate",instanceId," "_SCode,""))
	q result
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    yejian
/// CreateDate: 2016-3-22
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetComSimIDBySecSimCode(76,81,"SCODE:S001|CCODE:29|CSCODE:I001","")
ClassMethod GetComSimIDBySecSimCode(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result = ""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	s sCode = $p($p(ACode,"|",1),":",2)
	s csCode = $p($p(ACode,"|",2),":",2)
	
	s sCode = $zcvt(sCode,"U")
	s csCode = $zcvt(csCode,"U")
	s cCode = ""
	s instanceId= ""
	if (AInstanceID '= "")
	{
		s instanceId = " "_AInstanceID
	}
	q:(instanceId = "") result
	s cCode = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate",instanceId," "_sCode,cCode))
	q:(cCode = "") result
	s result = $o(^DHCPHI.ICompositeSimpleI("IdxForUpdate",instanceId," "_sCode,cCode," "_csCode,""))
	q result
}

/// Desc:       取知识库打散数据
/// Creator:    yejian
/// CreateDate: 2014-07-24
/// Input:      AEpisodeID 就诊号
///            AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///            AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetTGScatterData(76,"TYPE:ICompositeSample#TID:2#SCODE:S005|CCODE:32|CSCODE:L001#VTYPE:V","")           
ClassMethod GetKBScatterData(AEpisodeID As %String, AInstanceID As %String, itemCode As %String, valueType As %String, elementType As %String) As %String
{
	s result = ""
	q:(AEpisodeID = "") result
	q:(AInstanceID ="") result
	
	if (elementType = "ICOMPOSITEDESC")
	{
		s CompositeCode = ""
		if ($l(itemCode,"|")=1)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2)
		}
		q:(CompositeCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCPHI.ICompositeDescI("IdxForGetSection"," "_AInstanceID," "_CompositeCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCPHI.ICompositeDescI("IdxForGetSection"," "_AInstanceID," "_CompositeCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(curRowID,valueType)
			q:(result'="")
		}
	}
	elseif(elementType = "ICOMPOSITESAMPLE")
	{
		s CompositeCode = ""
		s SimpleItemCode = ""
		if ($l(itemCode,"|")=2)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2) 
			s SimpleItemCode = $p($p(itemCode,"|",2),":",2)
		}
		q:(CompositeCode="") ""
		q:(SimpleItemCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCPHI.ICompositeSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_SimpleItemCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCPHI.ICompositeSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_SimpleItemCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(curRowID,valueType)
			q:(result'="")
		}
	}
	q result
}

/// Desc: 	使用术语集取电子病历打散数据
/// Return:	metaItemInfo$|value&|metaItemInfo$|value
/// Debug: 	w ##class(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID("503","861","")
ClassMethod GetNewScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, AInstanceID As %String, Output aRowID As %String = "") As %String
{
	s ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") ret
	q:($d(AInstanceID) = 0)||(AInstanceID = "") ret
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") ret
	//b
	s name = objGlossary.Name
	s type = objGlossary.GlossaryType
	s strInstanceID = AInstanceID
	if ($zcvt(type,"U") = "TG")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowID))
			q:(rowID = "")
			
			s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
			s aRowID =rowID
			s itemCodes = objItem.ItemCode
			s valueType = objItem.ValueType
			s templateID = objItem.TemplateID
			s strInstanceID = AInstanceID
			s objIn = ##Class(User.DHCPHInstanceData).%OpenId(AInstanceID)
			s tempID = objIn.TemplateID
			if (templateID '= tempID)
			{
			    s strInstanceID = ..GetInstanceByEpisodeTemID(AEpisodeID,templateID)
			}
			s strTemType = objItem.TemType
			if (($zcvt(strTemType,"U") ="NEW")||($zcvt(strTemType,"U") ="BASE"))
			{
				s itemCode	= ""
				s elementType = ""
				q:('itemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(itemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				s ret = ""
				s ret = ..GetTGScatterData(AEpisodeID,templateID,strInstanceID,itemCode,valueType,elementType)
			}
			
			q:(ret '= "")&&(ret '= "Null")
		}	
	}
	else
	{
		s kbRowID = ""
		for {
			s kbRowID = $o(^DHCEPRM.GlossaryKBItemI("IdxGlossaryID",AGlossaryID,kbRowID))
			q:(kbRowID = "")
			s aRowID =kbRowID
			s objParItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(kbRowID)
			s curItemCodes = objParItem.ItemCode
			s curValueType = objParItem.ValueType
			s kbPartNo = objParItem.KBPartNo
			S KBNodeID = objParItem.KBNodeID
			
			s strKBType = objParItem.KBType
			if ($zcvt(strKBType,"U") ="NEW")
			{
				s itemCode	= ""
				s elementType = ""
				q:('curItemCodes [ "#")
				s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(curItemCodes,"#")
				q:($ll(ItemList) '= 2)
				s elementType = $zcvt($p($lg(ItemList,1),":",2),"U")
				s itemCode = $lg(ItemList,2)
				//去掉"SCODE:"+前面的一个特殊符号
				s itemCode = $e(itemCode,7,$l(itemCode))
				s ret = ""
				s ret = ..GetKBScatterData(AEpisodeID,AInstanceID,itemCode,curValueType,elementType)
			}
		}	
	}
	s:(ret="Null") ret = ""
	q ret
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceIDSByTemID(AEpisodeID As %String, ATemplateCategoryID As %String) As %List
{
	s reslut = ""
	s ATemplateID = ""
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(User.DHCPHECRecord).%OpenId(strECRowID)

			Set key = ""
			do
			{ 
		    	S objInstanceData = objECRecord.Instances.GetNext(.key)
			    if (objInstanceData '= "")
		     	{ 
		     	  continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     s reslut = reslut_$lb(objInstanceData.%Id())
			  	} 
	 		 } 
	 		 while (key '="" )
		 }
	}
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceByEpisodeTemID(AEpisodeID As %String, ATemplateID As %String) As %String
{
	s reslut = ""
	s emrTemRowID = ""
	for {
		s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
		q:(emrTemRowID = "")
		s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
		continue:(objEMRTem="")
		s strChartItemID = objEMRTem.CategoryID
		s strECRowID = ""
		s strECRowID = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_strChartItemID,strECRowID))
		continue:(strECRowID = "")
		s objECRecord = ##Class(User.DHCPHECRecord).%OpenId(strECRowID)

		Set key = ""
		do
		{ 
	    	S objInstanceData = objECRecord.Instances.GetNext(.key)
		    if (objInstanceData '= "")
	     	{ 
	     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
		     s reslut = objInstanceData.%Id()
		  	} 
 		 } 
 		 while (key '="" )
	 }
	q reslut
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewDataByGlossaryCategory("356","HDSD00.13.03")
ClassMethod GetNewDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	
	//判断是旧版还是新版
	s count = ..GetOldRecCount(AEpisodeID)
	if (count>0)
	{
		s ret = ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ret
		//通过术语集目录获取关联的模板ID
		s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		q:(objGlossaryCategory="") ret
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
		q:(templateCategoryID="") ret
		//获取InstanceID集合
		s InstanceIDS = ..GetInstanceIDSByTemID(AEpisodeID,templateCategoryID)
		s intInsCount = $ll(InstanceIDS)
		q:(intInsCount = 0) ret
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			s retArray = ##Class(%ArrayOfDataTypes).%New()
			s templateID = ""
			s glossaryID = ""
			for {
				s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
				q:(glossaryID="")
		
				s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
				continue:(objGlossary="")
			
				s strDataValue = ""
				//通过注册号，术语rowId获取业务数据
				s strDataValue =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
			 	d retArray.SetAt(strDataValue, objGlossary.InternalID)
			 }
			d ret.SetAt(retArray, AInstanceID)
		 }
	 }
	 q ret
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory("4065907","HDSD00.11")
ClassMethod GetNewStdDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
 
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	//判断是旧版还是新版
	s count = ..GetOldRecCount(AEpisodeID)
	if (count>0)
	{
		s ret = ##Class(EPRservice.BOScatterData).GetStandByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
		q:(glossaryCategoryID="") ret
		//通过术语集目录获取关联的模板ID
		s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
		q:(objGlossaryCategory="") ret
		s templateCategoryID = objGlossaryCategory.TemplateCategroyID
		q:(templateCategoryID="") ret
		//获取InstanceID集合
		s InstanceIDS = ..GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
		s intInsCount = $ll(InstanceIDS)
		q:(intInsCount = 0) ret
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			s retArray = ##Class(%ArrayOfDataTypes).%New()
			s templateID = ""
			s glossaryID = ""
			for {
				s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
				q:(glossaryID="")
				//w glossaryID
				s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
				continue:(objGlossary="")
				//w objGlossary.Description,!
				s strDataValues = ""
				
				//通过注册号，术语rowId获取业务数据
				s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
				;continue:(strDataValues = "")
			 	s strDataValue=strDataValues
		 	
				s deName = objGlossary.Name
				s deName = $p(deName," ",2)
				s strInternalID = objGlossary.InternalID
				//关联标准数据元标识符
				S strMetaID = objGlossary.MetaID
				s strDescription = objGlossary.Description
				
				/* test 
				if ("HDSD00.03.057"=strInternalID)
				{
					//b "s" //s strtest = ""
				}*/
				
				//如果没有关联数据元标示符，直接返回业务值
				if ((strMetaID = "") || (strMetaID=$char(0)))
				{
					//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
					d ret.SetAt(strDataValue, strInternalID)
					continue
				}
				//通过数据元标识符取数据元
				s derowID = ""
				s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
				if (derowID = "")
				{
					s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
				}
				s strDataType =""
				s strDEVID = ""
				s strFormat = ""
				if (derowID '= "")
				{
					s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
					s strDataType = objCurDataE.DataType
					s strFormat = objCurDataE.Format
					//数据元允许值标识符
					s strDEVID = objCurDataE.DEVID
				}
				//通过术语子集取数据类型
				s itemRowID = ""
				s strValueType = ""
				s itemCode = ""
				s templateID = ""
				s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
				if (itemRowID '= "")
				{
					s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
					s strValueType = objGlossaryItem.ValueType
					s itemCode = objGlossaryItem.ItemCode
					s templateID = objGlossaryItem.TemplateID
				}
		
				//判断是否有数据元映射关系
				//strDataValue="" 的时候也需要去取对应关联
				s devCategoryID = ""
				s sysCode = ""
				s categroyName = ""
				s MaprowID= ""
				//通过数据元允许值标识符取映射关系
				if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
				{
					//通过数据元允许值取允许值范畴名字
					s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
					if (devCategoryID '="")
					{
					s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
					s categroyName = objdevCategory.Name
					}
					//如果允许值范畴名字为空，则名字等于数据元允许值标识符
					if (categroyName="")
					{
						s categroyName = strDEVID
					}
			
					//如果术语集业务数据不为空,则通新索引处理!
					if (strDataValue'="")
					{
						if (strValueType="C")
						{
							s IndexMaprowID = MaprowID
							s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
							s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
						}
						if (strValueType="V")
						{
							s IndexMaprowID = MaprowID
							s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
							s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
						}
				
						if (MaprowID '= "")
						{		
							s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
							s strDataValue = objMap.DEVDes
							s sysCode = objMap.DEVID
						}
					}
				}
				
				//判断数据类型
				if ((strDataType'="")&(strDataValue'=""))
				{
					s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
				}

				//判断数据元数据格式
				if ((strFormat'="")&(strDataValue'=""))
				{
					if (sysCode'=""){
					s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
					}
					else
					{
						s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
					}
				}
		
		
				//处理日期数据类型
				/*
				if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
				{
					if ($e(itemCode,1,1)="D")
					{
						s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
						s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
					}
				}
				*/
				if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
				{
					s sysCode = strDataValue
					s strDataValue = " "
				}
				//处理按ValueType返回结果
				s strDataValues = $s(strValueType="VANDC":strDataValue,strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:"")
				
				//w strInternalID _"^"_deName_"^"_strDataValues,!
				d ret.SetAt(strDataValues, strInternalID)
			}
			;d ret.SetAt(retArray, AInstanceID)
		}
	}
	q ret
}

/// Desc:	获取指定术语集范畴下的所有标准术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary("35","HDSD00.11")
ClassMethod GetNewStdDataByGlossary(AEpisodeID As %String, ACategoryInternalID As %String, AInstanceID As %String = "") As %ArrayOfDataTypes
{
	s ret = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret

	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	q:(templateCategoryID="") ret
	//获取InstanceID集合
	
	s InstanceIDS = ..GetInstanceIDSByTemID(AEpisodeID,templateCategoryID)
	if (AInstanceID '="")
	{
		s InstanceIDS = $lb(AInstanceID)
	}
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) ret
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s retArray = ##Class(%ArrayOfDataTypes).%New()
		s templateID = ""
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
	
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
		
			s strDataValues = ""
			//通过注册号，术语rowId获取业务数据
			s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID, .arowid)
			continue:(strDataValues = "")
		 	s strDataValue=strDataValues
	 	
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strInternalID = objGlossary.InternalID
			//关联标准数据元标识符
			S strMetaID = objGlossary.MetaID
			s strDescription = objGlossary.Description
		
			//如果没有关联数据元标示符，直接返回业务值
			if ((strMetaID = "") || (strMetaID=$char(0)))
			{
				d retArray.SetAt(strDataValue, strInternalID)
				continue
			}
			//通过数据元标识符取数据元
			s derowID = ""
			s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
			if (derowID = "")
			{
				s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
			}
			s strDataType =""
			s strDEVID = ""
			s strFormat = ""
			if (derowID '= "")
			{
				s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
				s strDataType = objCurDataE.DataType
				s strFormat = objCurDataE.Format
				//数据元允许值标识符
				s strDEVID = objCurDataE.DEVID
			}
			//通过术语子集取数据类型
			s itemRowID = ""
			s strValueType = ""
			s itemCode = ""
			s templateID = ""
			if (arowid'="")
			{
				s itemRowID = arowid
			}
			else
			{	
				s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,arowid))
			}
			if (itemRowID '= "")
			{
				s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
				s strValueType = objGlossaryItem.ValueType
				s itemCode = objGlossaryItem.ItemCode
				s templateID = objGlossaryItem.TemplateID
			}
	
			//判断是否有数据元映射关系
			//strDataValue="" 的时候也需要去取对应关联
			s devCategoryID = ""
			s sysCode = ""
			s categroyName = ""
			s MaprowID= ""
			//通过数据元允许值标识符取映射关系
			if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
			{
				//通过数据元允许值取允许值范畴名字
				s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
				if (devCategoryID '="")
				{
				s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
				s categroyName = objdevCategory.Name
				}
				//如果允许值范畴名字为空，则名字等于数据元允许值标识符
				if (categroyName="")
				{
					s categroyName = strDEVID
				}
		
				//如果术语集业务数据不为空,则通新索引处理!
				if (strDataValue'="")
				{
					if (strValueType="C")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
					if (strValueType="V")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
			
					if (MaprowID '= "")
					{		
						s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
						s strDataValue = objMap.DEVDes
						s sysCode = objMap.DEVID
					}
				}
			}
			
			//判断数据类型
			if ((strDataType'="")&(strDataValue'=""))
			{
				s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
			}

			//判断数据元数据格式
			if ((strFormat'="")&(strDataValue'=""))
			{
				if (sysCode'=""){
				s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
				}
				else
				{
					s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
				}
			}
	
	
			//处理日期数据类型
			if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
			{
				if ($e(itemCode,1,1)="D")
				{
					s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
					s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
				}
			}
	
			//处理按ValueType返回结果
			s strDataValues = $s(strValueType="V":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,strValueType="T":strDataValue,1:"")

			//w strInternalID _"^"_strDataValues,!
			d ret.SetAt(strDataValues, strInternalID)
		}
	}
	q ret
}

ClassMethod GetOldRecCount(parEpisodeID As %String) As %Integer
{
	s $zt="errhandler"
	k SLQCODE
	s count=-1
	&sql(select count(*) into :count from EPRinstance.ECRecord where EpisodeID = :parEpisodeID)	
	q count
errhandler
	q -1
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID("35","73")
ClassMethod GetInstanceIDByTInterID(AEpisodeID As %String, ATemplateCategoryID As %String, ACategoryInternalID As %String) As %List
{
	s reslut = ""
	s ATemplateID = ""
	s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(User.DHCPHECRecord).%OpenId(strECRowID)
			s strInstancID = ""
			S key = ""
			s key = objECRecord.Instances.Count()+1		
			do
			{ 			
		    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
			    if (objInstanceData '= "")
		     	{ 
			     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     	 if (strTitleCode ="")
			     	 {
				     	  s strInstancID = objInstanceData.%Id()
			     	 }
			     	 else
			     	 {
				     	 if (objInstanceData.TitleCode =strTitleCode)
				     	 {
				     	 	s strInstancID = objInstanceData.%Id()
				     	 }
			     	 }
			     	 q:(strInstancID '="")
			     	 //s:(strInstancID '="") reslut = reslut _ $lb(strInstancID)
			  	} 
	 		 } 
	 		 while (key '="")
	 		 
	 		 if (strInstancID '="")
	 		 {
		 		 s reslut = reslut _ $lb(strInstancID)
	 		 }
		 }
	}
	q reslut
}

ClassMethod GetTitleBYGlossaryIntaID(AGlossaryCategoryID As %String) As %String
{
	q:(AGlossaryCategoryID="") ""
	s InterCodeValues = ##class(EMRservice.BOSysOption).GetValueByName("InternalIDTitleCode")
	q:(InterCodeValues="") ""
	s strTitleCode = ""
	if (InterCodeValues [ AGlossaryCategoryID)
	{
		s intCount = $l(InterCodeValues,"|")
		for i=1:1:intCount
		{
			s strValue = $p(InterCodeValues,"|",i)
			s strInterID = $p(strValue,"^",1)
			if (strInterID = AGlossaryCategoryID)
			{
				s strTitleCode = $p(strValue,"^",2)
				q
			}
		}
	}
	q strTitleCode
}

/// //////////
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDsByTInterID("35","73")
ClassMethod GetInstanceIDsByTInterID(AEpisodeID, ATemplateCategoryID, ACategoryInternalID As %String) As %List
{
	s result = ""
	s ATemplateID = ""
	s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
	for {
		s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
		q:(ATemplateID="")
		s emrTemRowID = ""
		for {
			s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
			q:(emrTemRowID = "")
			s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
			continue:(objEMRTem="")
			s strChartItemID = objEMRTem.CategoryID
			s strECRowID = ""
			s strECRowID = $o(^DHCPHI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_strChartItemID,strECRowID))
			continue:(strECRowID = "")
			s objECRecord = ##Class(User.DHCPHECRecord).%OpenId(strECRowID)
			s strInstancID = ""
			S key = ""
			s key = objECRecord.Instances.Count()+1		
			do
			{ 			
		    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
			    if (objInstanceData '= "")
		     	{ 
			     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     	 if (strTitleCode ="")
			     	 {
				     	  s strInstancID = objInstanceData.%Id()
			     	 }
			     	 else
			     	 {
				     	 if (objInstanceData.TitleCode =strTitleCode)
				     	 {
				     	 	s strInstancID = objInstanceData.%Id()
				     	 }
			     	 }
			     	 s:(strInstancID '="") result = $lb(strInstancID)_result
			  	} 
	 		 } 
	 		 while (key '="")
		 }
	}
	q result
}

/// Desc:	获取指定术语集范畴下的所有标准术语值 仅仅支持第三版
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值二维数组
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetAllStdDataByGlossaryCategory("69","HDSD00.06")
ClassMethod GetAllStdDataByGlossaryCategory(AEpisodeID, ACategoryInternalID, templateCategoryID As %String) As %ArrayOfDataTypes
{
	s retArray = ##Class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret
	q:($d(templateCategoryID) = 0)||(templateCategoryID = "") ret
	
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	/*//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	w "glossaryCategoryID:"_glossaryCategoryID,!
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	w "templateCategoryID:"_templateCategoryID,!
	q:(templateCategoryID="") ret*/
	//获取InstanceID集合
	s InstanceIDS = ..GetInstanceIDsByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) retArray
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s ret = ##Class(%ArrayOfDataTypes).%New()
		
		s templateID = ""
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
			s strDataValues = ""
			
			//通过注册号，术语rowId获取业务数据
			s strDataValues =..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID)
			;continue:(strDataValues = "")
		 	s strDataValue=strDataValues
	 	
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strInternalID = objGlossary.InternalID
			//关联标准数据元标识符
			S strMetaID = objGlossary.MetaID
			s strDescription = objGlossary.Description
			
			//如果没有关联数据元标示符，直接返回业务值
			if ((strMetaID = "") || (strMetaID=$char(0)))
			{
				//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
				d ret.SetAt(strDataValue, strInternalID)
				continue
			}
			//通过数据元标识符取数据元
			s derowID = ""
			s derowID = $o(^DHCEPRM.DataElementI("IdxEntifier"," "_strMetaID,derowID))
			if (derowID = "")
			{
				s derowID = ##Class(EPRmeta.DataElement).SelectByEntifier(strMetaID)
			}
			s strDataType =""
			s strDEVID = ""
			s strFormat = ""
			if (derowID '= "")
			{
				s objCurDataE = ##class(EPRmeta.DataElement).%OpenId(derowID)
				s strDataType = objCurDataE.DataType
				s strFormat = objCurDataE.Format
				//数据元允许值标识符
				s strDEVID = objCurDataE.DEVID
			}
			//通过术语子集取数据类型
			s itemRowID = ""
			s strValueType = ""
			s itemCode = ""
			s templateID = ""
			s itemRowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
			if (itemRowID '= "")
			{
				s objGlossaryItem = ##class(EPRmeta.GlossaryItem).%OpenId(itemRowID)
				s strValueType = objGlossaryItem.ValueType
				s itemCode = objGlossaryItem.ItemCode
				s templateID = objGlossaryItem.TemplateID
			}
	
			//判断是否有数据元映射关系
			//strDataValue="" 的时候也需要去取对应关联
			s devCategoryID = ""
			s sysCode = ""
			s categroyName = ""
			s MaprowID= ""
			//通过数据元允许值标识符取映射关系
			if ($d(strDEVID) & (strDEVID'="") & ($L(strDEVID) > 1))
			{
				//通过数据元允许值取允许值范畴名字
				s devCategoryID = $o(^DHCEPRM.DEValuesCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
				if (devCategoryID '="")
				{
				s objdevCategory = ##class(EPRmeta.DataElementValuesCategory).%OpenId(devCategoryID)
				s categroyName = objdevCategory.Name
				}
				//如果允许值范畴名字为空，则名字等于数据元允许值标识符
				if (categroyName="")
				{
					s categroyName = strDEVID
				}
		
				//如果术语集业务数据不为空,则通新索引处理!
				if (strDataValue'="")
				{
					if (strValueType="C")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
					if (strValueType="V")
					{
						s IndexMaprowID = MaprowID
						s MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID = $o(^DHCEPRM.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$ZCVT(strDataValue,"U"),IndexMaprowID))
					}
			
					if (MaprowID '= "")
					{		
						s objMap = ##Class(EPRmeta.GlossaryItemMap).%OpenId(MaprowID)
						s strDataValue = objMap.DEVDes
						s sysCode = objMap.DEVID
					}
				}
			}
			if (MaprowID '= "")
			{	
				d ret.SetAt(strDataValue, strInternalID)
				continue
			}
			//判断数据类型
			if ((strDataType'="")&(strDataValue'=""))
			{
				s strDataValue =##class(EPRservice.BOScatterData).GetDataByType(strDataValue,strDataType)
			}

			//判断数据元数据格式
			if ((strFormat'="")&(strDataValue'=""))
			{
				if (sysCode'=""){
				s sysCode = ##class(EPRservice.BOScatterData).GetDataByFormat(sysCode,strFormat,"1")
				}
				else
				{
					s strDataValue = ##class(EPRservice.BOScatterData).GetDataByFormat(strDataValue,strFormat,"1")
				}
			}
	
			//处理日期数据类型
			/*
			if ((strValueType'="")&(itemCode'="")&(strDataValue'=""))
			{
				if ($e(itemCode,1,1)="D")
				{
					s:(strValueType="C") sysCode= $zdt($zdth(strDataValue,3,1),3,1)
					s:(strValueType="YMD") sysCode= $zd($zdh(strDataValue,3),3)
				}
			}
			*/
			if ((sysCode = "")&(strDataValue'="")&(strValueType = "C"))
			{
				s sysCode = strDataValue
				s strDataValue = " "
			}
			//处理按ValueType返回结果
			s strDataValues = $s(strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:"")
			
			//if (""'=strDataValues) w strInternalID _"^"_deName_"^"_strDataValues,!
			d ret.SetAt(strDataValues, strInternalID)
		}
		d retArray.SetAt(ret, i)
	}
	
	q retArray
}

/// Desc:        获取指定术语值
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input：        AEpisodeID : 就诊指针
///             AGlossaryInternalID : 指定术语内部标识符
///             Flag:取值结果设定
///             Flag=1，输出格式为：模板id.标题#数据源值
///             Flag=0，输出格式为：单元值
/// Output:        术语值
/// Debug:        w ##Class(EMRservice.BL.BLScatterData).GetDataByGlossary("110852","HDSD00.13.114","0")
ClassMethod GetDataByGlossary(AEpisodeID As %String, AGlossaryInternalID As %String = "", Flag As %String = "") As %String
{
    s:(Flag="") Flag=0
    q:(AEpisodeID="")||(AGlossaryInternalID="") ""
    s parentID = $O(^DHCEPRM.GlossaryI("IdxInternalID"," "_AGlossaryInternalID,""),-1)
    Q:parentID=""
    s glossaryID = $O(^DHCEPRM.GlossaryI("IdxInternalID"," "_AGlossaryInternalID,parentID,""))
    //w glossaryID
    q:(glossaryID="") ""
    s rowID = "",value="",valuestring=""
    for 
    {
        s rowID = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",glossaryID,rowID))
        q:(rowID = "")
        //w rowID
        s objItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowID)
        s AitemCode = objItem.ItemCode
        s valueType = objItem.ValueType
        s templateID = objItem.TemplateID
        s itemCodeEYPE = $P($p(AitemCode,"#",2),":",2)
        s InstanceID=""
        IF itemCodeEYPE = "ICOMPOSITESAMPLE" 
            {
                s itemCode = "TYPE:ICompositeSample#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }
        ELSEIF itemCodeEYPE = "ISECTIONDESC" 
            {
                s itemCode = "TYPE:ISectionDesc#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }    
        ELSEIF itemCodeEYPE = "ICOMPOSITEDESC"
            { 
                s itemCode = "TYPE:ICompositeDesc#TID:"_templateID_"#"_$p(AitemCode,"#",3)_"#VTYPE:"_valueType
            }
            s value = ..GetScatterDataSNew(AEpisodeID,itemCode,InstanceID,Flag)

            //W AEpisodeID_"*"_itemCode_"*"_InstanceID
            continue:(value="")
            s valuestring=valuestring_value
    }
    q $e(valuestring,1,$l(valuestring)-1)
}

/// Desc:       取打散数据
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             AItem 单元路径(TYPE:ICompositeSample#TID:81#SCODE:S001#VTYPE:S|CCODE:VK1#VTYPE:S|CSCODE:L010#VTYPE:V
///             AInstanceID 实例数据ID
///             Flag:取值结果设定
///             Flag=1，输出格式为：模板id.标题#数据源值
///             Flag=0，输出格式为：单元值
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetScatterDataS(110852,"TYPE:ISectionDesc#TID:1367#SCODE:S002#VTYPE:T","","0")           
ClassMethod GetScatterDataSNew(AEpisodeID As %String, AItem As %String, AInstanceID As %String, Flag As %String = 0) As %String
{
    s $ZT="ERROR"    
    s result = "",ret=""
    q:(AEpisodeID = "") result
    s ItemList = ##Class(EMRservice.Tools.Tool).GetListFromString(AItem,"#")
    q:($ll(ItemList) '= 4) result
    s elementType = $p($lg(ItemList,1),":",2)
    s templateId = $p($lg(ItemList,2),":",2)
    s itemCode = $lg(ItemList,3)
    s valueType = $p($lg(ItemList,4),":",2)
    //W elementType
    if (elementType = "ISectionDesc")
    {    
        //w templateId_"**"_itemCode
        s rowIdS = ..GetSectionIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s valueType = "T"
            //w rowId_"&"
            s result = ..GetSectionData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }
    }
    elseif(elementType = "ICompositeDesc")
    {

        s rowIdS = ..GetCompositeIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s result = ..GetCompositeData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }    
    }
    elseif(elementType = "ICompositeSample")
    {

        s rowIdS = ..GetCompositeSimpleIDS(AEpisodeID,templateId,itemCode,AInstanceID)
        q:(rowIdS="") result
        S Lenth=$l(rowIdS,"||")
        for i=1:1:(Lenth-1)
        {
            s rowId=$p($p(rowIdS,"||",i),"*",2)
            s Title=$p($p(rowIdS,"||",i),"*",1)
            s result = ..GetCompositeSimpleData(rowId,valueType)
            //continue:(result="")
            s:(Flag=0) ret=ret_result_"^"
            s:(Flag=1) ret=ret_templateId_"#"_Title_"#"_result_"^"
        }    
    }
    q ret
ERROR
    q "ERROR"
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ISectionDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetSectionIDS(110852,1413,"SCODE:S001","")
ClassMethod GetSectionIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
    s sCode = $p(ACode,":",2)
    s SCode = $zcvt(sCode,"U")
    s instanceId = "",ret = ""
    if (AInstanceID = "")
    {

        for
        {
            //w AEpisodeID_"**"_ATemplateID_"**"_SCode
            s instanceId = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId))
            q:(instanceId = "")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""))
            s ret=ret_Title_"*"_result_"||"
        }
    }

    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCPHI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_SCode,instanceId,""))
        s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }
    q ret
}

/// Desc:       返回GetSectionDesc的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeDesc 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeIDS(76,2,"SCode:S001|CCode:29","")
ClassMethod GetCompositeIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ATemplateID = "")||(ACode = "")) result
    s sCode = $p($p(ACode,"|",1),":",2)
    s cCode = $p($p(ACode,"|",2),":",2)
    s sCode = $zcvt(sCode,"U")
    s cCode = $zcvt(cCode,"U")
    s instanceId = "",ret=""
    if (AInstanceID = "")
    {

        for
        {
            s instanceId = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId))
            q:(instanceId = "")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId))
            s ret=ret_Title_"*"_result_"||"
        }    
    }
    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCPHI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode,instanceId,""))
        s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }

    q ret
}

/// Desc:       返回CompositeSimple的rowID
/// Creator:    LiXJ
/// CreateDate: 2016-06-12
/// Input:      AEpisodeID 就诊号
///             ATemplateID 模板ID
///             ACode 单元代码(路径)
///             AInstanceID 就诊号
/// Return:     EMRinstance.ICompositeSimple 的 rowID
/// Debug:      w ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleIDS(110852,1414,"SCODE:HEADER|CCODE:VK1|CSCODE:L018","")
ClassMethod GetCompositeSimpleIDS(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
    s result = ""
    q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
    s sCode = $p($p(ACode,"|",1),":",2)
    s cCode = $p($p(ACode,"|",2),":",2) 
    s csCode = $p($p(ACode,"|",3),":",2)

    s sCode = $zcvt(sCode,"U")
    s cCode = $zcvt(cCode,"U")
    s csCode = $zcvt(csCode,"U")
    s instanceId = "",ret="",EcRecordId=""
    if (AInstanceID = "")
    {
        s instanceId = ""
        for
        {
            s instanceId = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId))
            q:(instanceId="")
            s tmpInstanceId = $tr(instanceId," ","")
            s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
            CONTINUE:(objInstance.Status'="Save")
            s Title=objInstance.Title
            s result = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""))
            s ret=ret_Title_"*"_result_"||"
        }        
    }
    else
    {
        s instanceId = " "_AInstanceID
        s result = $o(^DHCPHI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_sCode," "_cCode," "_csCode,instanceId,""))
        s objInstance = ##Class(User.DHCPHInstanceData).%OpenId(tmpInstanceId)
        s Title=objInstance.Title
        s ret=Title_"*"_result
    }
    q ret
}

}
