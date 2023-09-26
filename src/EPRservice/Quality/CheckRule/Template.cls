/// Class Name:	 	EPRservice.Quality.CheckRule.Template
/// Description: 	与界面模板单元相关的逻辑处理类
/// Author:		 	Zuoxiang Xie
/// Create Date: 	2010-06-30
/// Version:		
Class EPRservice.Quality.CheckRule.Template Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	判断患者当前就诊病历中的某个模板单元是否填写;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;
/// 		AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret=-1没填写; ret=1已填写; ret=0参数错误或无效;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).IsSaveElement("65","103","96||1")
ClassMethod IsSaveElement(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElementID = "") ret
	q:($d(AEpisodeID) = 0)||($d(AElementID) = 0) ret
	
	// Check whether the <AElementID> of <AEpisodeID> is valid
	s flag = ..IsRightElement(AEpisodeID,AElementID)
	q:(flag < 1) ret
	
	// Get template ID by element
	s templateID = $list($g(^DHCEPRM.QualityTemplateD(AElementID)),1)
	q:(templateID = "") ret
	
	// Get template object
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") ret
	
	// Template type
	s chartItemType = objTemplate.ChartItemType
	q:(chartItemType = "") ret
	q:(chartItemType = "Multiple")&&(AInstanceID = "") ret
	
	// Get the <AElementID> data of <AEpisodeID>
	s ret = 1
	s tmpElementData = ..GetElementData(AEpisodeID,AElementID,AInstanceID)
	s:(tmpElementData = "") ret = -1
	s tmpElementData = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(tmpElementData,"\")
	s:($listfind(tmpElementData,"") > 0) ret = -1
	
	q ret
}

/// Desc:	判断模板单元是否符合检查条件
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;	
/// Output:	ret=0 不符合检查条件，ret=1符合检查条件
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).IsRightElement("49","13")
ClassMethod IsRightElement(AEpisodeID As %String, AElementID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "")||(AElementID = "") ret
	
	s objElement = $g(^DHCEPRM.QualityTemplateD(AElementID))
	q:(objElement = "") ret
	
	//模板单元所属模板的RowId
	s templateID = $list(objElement,1)				
	q:(templateID = "") ret
	
	//单元Code
	s elementCode = $list(objElement,2)			
	q:(elementCode = "") ret
	
	//isNull'="N"表示不允许为空
	s isNull = $list(objElement,5)
	q:($zcvt(isNull,"U") = "Y") ret	
	
	//isActive'="Y"表示单元无效							
	s isActive = $list(objElement,6)
	q:($zcvt(isActive,"U") '= "Y") ret							
	
	//模板对象
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") ret
	
	//模板对应目录
	s catalogID = objTemplate.TemplateCategoryID	
	q:(catalogID = "") ret
	
	s ret = 1
	q ret
}

/// Desc:	判断模板单元是否在检查范围内(一致性检查时用到);
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;	
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).IsCheckElement("8706","2")
ClassMethod IsCheckElement(AEpisodeID As %String, AElementID As %String) As %String
{
	s ret = -1
	q:(AEpisodeID = "")||(AElementID = "") ret
	
	s objElement = $g(^DHCEPRM.QualityTemplateD(AElementID))
	q:(objElement = "") ret
	
	//模板单元所属模板的RowId
	s templateID = $list(objElement,1)				
	q:(templateID = "") ret
	
	//单元Code
	s elementCode = $list(objElement,2)			
	q:(elementCode = "") ret
	
	//isActive'="Y"表示单元无效							
	s isActive = $list(objElement,6)
	q:($zcvt(isActive,"U") '= "Y") ret	
							
	//单元模板
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(templateID)
	q:(objTemplate = "") ret
	
	//模板对应目录
	s catalogID = objTemplate.TemplateCategoryID	
	q:(catalogID = "") ret
	
	s structID = $o(^DHCEPRM.QualityStructI("IdxCategoryId"," "_catalogID,""))
	q:(structID = "") ret
	
	s objStruct = $g(^DHCEPRM.QualityStructD(+structID))
	s isActive = $list(objStruct,8)
	q:($zcvt(isActive,"U") '= "Y") ret
	s chkConditionDR = $list(objStruct,7)
	if (chkConditionDR '= "")&&(chkConditionDR '= $C(0))
	{
		s flag = ##Class(EPRservice.Quality.ExpExplain.BOExplainVal).GetQualityQueryValue(AEpisodeID,+chkConditionDR,structID)
		q:(flag '= "1") ret  //不符合检查条件退出
	}
	s ret = 1
	q ret
}

/// Desc:	获取患者某次就诊中某个模板单元的实例数据;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;
/// 		AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret = 模板单元对应的数据
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).GetElementData("65","1","")
ClassMethod GetElementData(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	s ret = "", ElementData = ""
	q:($d(AEpisodeID) = 0)||($d(AElementID) = 0) ret
	q:(AEpisodeID = "")||(AElementID = "") ret
	
	//模板单元对象
	s ElementInfo = $g(^DHCEPRM.QualityTemplateD(AElementID))
	q:(ElementInfo = "") ret
	
	s TemplateID = $list(ElementInfo,1)		
	q:(TemplateID = "") ret
	
	s ElementCode = $list(ElementInfo,2)		
	q:(ElementCode = "") ret
	
	s objTemplate = ##Class(EPRmeta.Template).%OpenId(TemplateID)
	q:(objTemplate = "") ret
	
	s ChartItemType = objTemplate.ChartItemType   
	q:(ChartItemType = "") ret
	
	if (ChartItemType = "Single") 		
	{
		// Single template
		s tmpData = ##Class(EPRservice.BOScatterData).GetEPRData(AEpisodeID,ElementCode)
		s tmpData = $tr(tmpData,"\","/")
		s tmpData = $tr(tmpData,"{","[")
		s tmpData = $tr(tmpData,"}","]")
		s tmpData = $tr(tmpData,";",",")
		s ElementData = ElementData_$lb(tmpData)
	}
	if (ChartItemType = "Multiple")
	{
		// Multiple template
		s InstanceIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AInstanceID,"\")
		for Ind = 1:1:$listlength(InstanceIDs) 
		{
			s InstanceID = $listget(InstanceIDs,Ind)
			continue:(InstanceID = "")
			
			s tmpData = ##Class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,ElementCode,InstanceID)
			s tmpData = $tr(tmpData,"\","/")
			s tmpData = $tr(tmpData,"{","[")
			s tmpData = $tr(tmpData,"}","]")
			s tmpData = $tr(tmpData,";",",")
			s ElementData = ElementData_$lb(tmpData)
		}
	}
	
	s ret = ##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"\")
	q ret
}

/// Desc:	获取患者某次就诊中某个模板单元的实例数据和代码;
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementID为模板单元RowID;
/// 		AInstanceID为实例数据RowID(可重复模板单元时用);
/// Output:	ret = 模板单元对应的数据
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).GetElementDataCode("","","")
ClassMethod GetElementDataCode(AEpisodeID As %String, AElementID As %String, AInstanceID As %String) As %String
{
	s ret = "", ElementData = ""
	q:(AEpisodeID = "")||(AElementID = "") ret
	
	s ElementInfo = $g(^DHCEPRM.QualityTemplateD(AElementID))
	q:(ElementInfo = "") ret
	
	s TemplateID = $list(ElementInfo,1)				//单元对应模板ID
	q:(TemplateID = "") ret
	
	s ElementCode = $list(ElementInfo,2)			//单元Code
	q:(ElementCode = "") ret
	
	s objTemplate = ##class(EPRmeta.Template).%OpenId(TemplateID)
	q:(objTemplate = "") ret
	
	s ChartItemType = objTemplate.ChartItemType     //模板类型
	q:(ChartItemType = "") ret
	
	//取部分单元对应的单元隐藏的CODE值，需要对代码进行转换
	s ElementCode = $P(ElementCode,"#VTYPE:V",1)_"#VTYPE:C"
	
	if (ChartItemType = "Single")   //唯一模板
	{
		s tmpData = ##Class(EPRservice.BOScatterData).GetEPRData(AEpisodeID,ElementCode)
		s tmpData = $tr(tmpData,"\","/")
		s tmpData = $tr(tmpData,"{","[")
		s tmpData = $tr(tmpData,"}","]")
		s tmpData = $tr(tmpData,";",",")
		s ElementData = ElementData_$lb(tmpData)
	}
	if (ChartItemType = "Multiple")    //可重复模板
	{
		s InstanceIDls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AInstanceID,"\")
		for Ind=1:1:$LL(InstanceIDls) 
		{
			s InstanceID = $listget(InstanceIDls,Ind)
			continue:(InstanceID = "")
			
			s tmpData = ##class(EPRservice.BOScatterData).GetEPRMultipleData(AEpisodeID,ElementCode,InstanceID)
			s tmpData = $tr(tmpData,"\","/")
			s tmpData = $tr(tmpData,"{","[")
			s tmpData = $tr(tmpData,"}","]")
			s tmpData = $tr(tmpData,";",",")
			s ElementData = ElementData_$lb(tmpData)
		}
	}
	
	s ret = ##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"\")
	q ret
}

/// Desc:	取唯一模板同一模板的多个模板单元的值，最终得到一组值
/// 	 	如果某一个模板单元无效，直接返回无效标记
/// Input:	AEpisodeID为患者就诊号;
/// 		AElementIDs为一组模板单元的RowId字符串, 多个ElementID以反斜杠"\"分隔;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).GetSingleValues("65","E148")
ClassMethod GetSingleValues(AEpisodeID As %String, AElementIDs As %String, AInstanceID As %String = "") As %String
{
	s ret = "0^", ElementData = ""
	q:(AEpisodeID = "")||(AElementIDs = "") ret

	s flag = 1
	s ElementIDls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AElementIDs,"\")
	for Ind = 1:1:$listlength(ElementIDls) 
	{
		s ElementID = $listget(ElementIDls,Ind)
		if ($e(ElementID,1,2) = "EC") 
		{    
			//取隐藏CODE的值
			s tmpType = "EC"
			s ElementID = +$e(ElementID,3,$l(ElementID))
		} 
		elseif ($e(ElementID,1,1) = "E") 
		{   
			//取显示单元的值
			s tmpType = "E"
			s ElementID = +$e(ElementID,2,$l(ElementID))
		} 
		else 
		{	 
			//取显示单元的值
			s tmpType = "E"
			s ElementID = +ElementID
		}
		continue:(ElementID < 1)
		
		s flag = ..IsCheckElement(AEpisodeID,ElementID)
		continue:(flag < 0)
		
		s:(tmpType = "E") tmpData = ..GetElementData(AEpisodeID,ElementID,AInstanceID)
		s:(tmpType = "EC") tmpData=..GetElementDataCode(AEpisodeID,ElementID,AInstanceID)
		s ElementData = ElementData_$lb(tmpData)
	}
	
	q:(flag < 0) ret
	
	s ret = "1^"_##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"\","N","Y")
	q ret
}

/// Desc:	取可重复模板同一模板的多个模板单元的值, 最终得到N组值
/// 	  	如果某一个模板单元无效, 直接返回无效标记;
/// Input:	AEpisodeID为患者就诊号;
/// 	  	AElementIDs一组模板单元的RowId字符串, 多个ElementID以反斜杠"\"分隔;
/// 	  	AInstanceID实例数据ID集合;
/// Debug:	w ##Class(EPRservice.Quality.CheckRule.Template).GetMultipleValues(2462001,"E1064","150||1")
ClassMethod GetMultipleValues(AEpisodeID As %String, AElementIDs As %String, AInstanceID As %String) As %String
{
	s ret = "0^", ElementData = ""
	q:(AEpisodeID = "")||(AElementIDs = "") ret

	s flag = 1	
	s ElementIDls = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AElementIDs,"\")
	for Ind = 1:1:$listlength(ElementIDls) 
	{
		s ElementID = $listget(ElementIDls,Ind)
		if ($e(ElementID,1,2) = "EC")    //取隐藏CODE的值
		{
			s tmpType = "EC"
			s ElementID = +$e(ElementID,3,$l(ElementID))
		}
		elseif ($e(ElementID,1,1) = "E")  //取显示单元的值
		{
			s tmpType = "E"
			s ElementID = +$e(ElementID,2,$l(ElementID))
		}
		else                          //取显示单元的值
		{
			s tmpType = "E"
			s ElementID = +ElementID
		}
		continue:(ElementID < 1)
		
		s flag = ..IsCheckElement(AEpisodeID,ElementID)
		continue:(flag < 0)
		
		s:(tmpType = "E") tmpData = ..GetElementData(AEpisodeID,ElementID,AInstanceID)
		s:(tmpType = "EC") tmpData = ..GetElementDataCode(AEpisodeID,ElementID,AInstanceID)
		s ElementData = ElementData_$lb(tmpData)
	}
	
	q:(flag < 0) ret
	//s ret = "1^"_##Class(EPRservice.Quality.CommonHelper).GetListToString(ElementData,"\")
	s ret = "1^"_ElementData
	q ret
}

}
