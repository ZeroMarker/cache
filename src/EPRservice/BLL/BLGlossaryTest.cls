/// 名称: EPRservice.BOGloassaryTest
/// 描述: 术语测试BO层
/// 编写者：yejian
/// 编写日期: 2017-6-23
Class EPRservice.BLL.BLGlossaryTest Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BLL.BLGlossaryTest).GetInstanceIDByTInterID("112","55^38","")
ClassMethod GetInstanceIDByTInterID(AEpisodeID As %String, ATemplateCategoryIDs As %String, ACategoryInternalID As %String = "") As %List
{
	s reslut = ""
	s ATemplateID = ""
	s intTC = $L(ATemplateCategoryIDs,"^")
	for i=1:1:intTC
	{
		s ATemplateCategoryID = $p(ATemplateCategoryIDs,"^",i)
		q:(ATemplateCategoryID="")
		s strTitleCode = ""
		if (ACategoryInternalID'="")
		{
			s strTitleCode = ..GetTitleBYGlossaryIntaID(ACategoryInternalID)
		}
		if (i=1)
		{
			for {
				s ATemplateID = $o(^DHCEMRM.TemplateI("IndexCategoryId"," "_ATemplateCategoryID,ATemplateID))
				q:(ATemplateID="")
				s reslutID = ..GetInstanceBTInterIDTemID(AEpisodeID,ATemplateID,strTitleCode,.reslut)
			}
		}else
		{
			s reslutID = ..GetInstanceBTInterIDTemID(AEpisodeID,ATemplateCategoryID,strTitleCode,.reslut)
		}
	}
	q reslut
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceBTInterIDTemID(AEpisodeID As %String, ATemplateID As %String, strTitleCode As %String = "", ByRef reslut As %List) As %String
{
	s emrTemRowID = ""
	for {
		s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
		q:(emrTemRowID = "")
		s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
		continue:(objEMRTem="")
		s strChartItemID = objEMRTem.CategoryID
		s strECRowID = ""
		s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
		continue:(strECRowID = "")
		s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)
		s strInstancID = ""
		S key = ""
		s key = objECRecord.Instances.Count()+1		
		do
		{ 			
	    	s objInstanceData = objECRecord.Instances.GetPrevious(.key)
		    if (objInstanceData '= "")
	     	{ 
		     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete")||(ATemplateID'=objInstanceData.TemplateID))
		     	 if (strTitleCode ="")
		     	 {
			     	  s strInstancID = objInstanceData.%Id()_"^"_objInstanceData.Title
		     	 }
		     	 else
		     	 {
			     	 if (objInstanceData.TitleCode =strTitleCode)
			     	 {
			     	 	s strInstancID = objInstanceData.%Id()_"^"_objInstanceData.Title
			     	 }
		     	 }
		     	 q:(strInstancID '="")
		  	} 
 		 } 
 		 while (key '="")
	 
 		 if (strInstancID '="")
 		 {
	 		s reslut = $lb(strInstancID)_reslut
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
	
	s InstanceIDS = ##CLASS(EMRservice.BL.BLScatterData).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID)
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
		s templateID = ""
		s glossaryID = ""
		for {
			s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
			q:(glossaryID="")
	
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
			continue:(objGlossary="")
		
			s strDataValues = ""
			//通过注册号，术语rowId获取业务数据
			s strDataValues =##CLASS(EMRservice.BL.BLScatterData).GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstanceID, .arowid)
			//continue:(strDataValues = "")
		 	s strDataValue=strDataValues
	 	
			s deName = objGlossary.Name
			s deName = $p(deName," ",2)
			s strInternalID = objGlossary.InternalID
			//关联标准数据元标识符
			S strMetaID = objGlossary.MetaID
			s strDescription = objGlossary.Description
		
			//如果没有关联数据元标示符，直接返回业务值
			if ((strMetaID = "") || (strMetaID=$char(0))||(strDataValue = ""))
			{
				
				if (strDataValue="")
				{
					s strDataValue = " "
				}
				d ret.SetAt(strDataValue, strInternalID_"^"_deName)
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
			
			if (strDataValues="")
			{
				s strDataValues = " "
			}
			
			//w strInternalID _"^"_strDataValues,!
			d ret.SetAt(strDataValues, strInternalID_"^"_deName)
		}
	}
	q ret
}

/// Desc:	获取指定术语集范畴下的所有术语值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	术语值数组
/// Debug:	w ##Class(EPRservice.BOScatterData).GetDataByGlossaryCategory("1","1")
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, ACategoryInternalID As %String) As %ArrayOfDataTypes
{
	//判断是旧版还是新版
	
	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ""

	//s objGlossaryCategory = ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	//q:(glossaryCategoryID="") ""

	s retArray = ##Class(%ArrayOfDataTypes).%New()

	s glossaryID = ""
	for {
		s glossaryID = $O(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryID,glossaryID))
		q:(glossaryID="")
	
		s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryID)
		continue:(objGlossary="")
		s deName = objGlossary.Name
		s deName = $p(deName," ",2)
		
		s internalID = objGlossary.InternalID
		s value = ##class(EPRservice.BOScatterData).GetScatterDataByGlossaryID(AEpisodeID,glossaryID)
		if (value="")
		{
			s value = " "
		}
		d retArray.SetAt(value, internalID_"^"_deName)
	}
	
	q retArray
}

}
