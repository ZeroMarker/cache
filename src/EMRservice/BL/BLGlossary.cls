/// Desc:        术语集操作服务
/// Creator:     Candy
/// CreateDate:  2016-3-30
Class EMRservice.BL.BLGlossary Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       根据取术语项ID取病历数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///             AGlossaryID 术语代码rowID
/// Output:     ##Class(EMRservice.BL.BLGlossary).GetDataByGlossary(76,1029)	
ClassMethod GetDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AGlossaryID = "")) result
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") result
	if ($zcvt(objGlossary.GlossaryType,"U") = "TG")    //模板
	{
		s rowid = ""
		for 
		{
			s rowid = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowid))
			q:(rowid = "")
			s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowid)
			continue:(objGlossaryItem = "")
			if ($zcvt(objGlossaryItem.TemType,"U") = "NEW")
			{
				//新版
				s result = ##Class(EMRservice.BL.BLScatterData).GetScatterDatas(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryItem.ValueType)
			}
			elseif($zcvt(objGlossaryItem.TemType,"U") = "EMRINSTANCE")
			{
				//扩展的instanceData属性字段
				s result = ..GetInstanceDataProperty(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.ValueType,objGlossaryItem.TemplateID)
			}
			else
			{
				//老版
				s result = ##Class(EMRservice.BL.BLEPRScatterData).GetScatterDatas(AEpisodeID,objGlossaryItem.TemplateID,objGlossaryItem.ItemCode,objGlossaryItem.ValueType)
			}
			q:(result.Count()>0)
		}	
	}
	else //知识库
	{
		s parGlassaryId = objGlossary.ParentID
		q:(parGlassaryId = "") result
		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlassaryId)
		q:(objParGlossary = "") result
		s itemRowId = ""
		for
		{
			s itemRowId = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlassaryId,itemRowId))
			q:(itemRowId = "")
			s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(itemRowId)
			continue:(objGlossaryItem = "")
			s rowid = ""
			for
			{
				s rowid = $o(^DHCEPRM.GlossaryKBItemI("IdxKBType",AGlossaryID," "_$zcvt(objGlossaryItem.TemType,"U"),rowid))
				q:(rowid = "")
				s objGlossaryKBItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(rowid)
				continue:(objGlossaryKBItem = "")
				if ($zcvt(objGlossaryItem.TemType,"U") = "NEW")
				{
					//新版
					s result = ##Class(EMRservice.BL.BLScatterData).GetKBScatterDatas(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryKBItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryKBItem.KBNodeID,objGlossaryKBItem.ValueType)
				}
				else
				{
					//老版
					s result = ##Class(EMRservice.BL.BLEPRScatterData).GetKBScatterDatas(AEpisodeID,objGlossaryItem.TemplateID,objGlossaryItem.ItemCode,objGlossaryKBItem.ItemCode,objGlossaryKBItem.KBNodeID,objGlossaryKBItem.KBPartNo,objGlossaryKBItem.ValueType)
				}
				q:(result.Count()>0)
			}
			q:(result.Count()>0)	
		}	
	}		
	q result
}

/// Desc:       根据术语项代码取电子病历数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///             AGlossaryInternalID 术语项代码
/// Output:     ##Class(EMRservice.BL.BLGlossary).GetDataByGlossary(76,"S.01.01")
ClassMethod GetDataByGlossary(AEpisodeID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:((AEpisodeID = "")||(AGlossaryInternalID = "")) result
	s glossaryId = ""
	for
	{
		s glossaryId = $o(^DHCEPRM.GlossaryI("IdxGlossaryID"," "_AGlossaryInternalID,glossaryId))
		q:(glossaryId = "")
		s result = ..GetDataByGlossaryID(AEpisodeID,glossaryId)
		q:(result.Count()>0)	
	}
	q result
}

/// Desc:       根据术语集代码取电子病历数据
/// Creator:    Candyxu
/// CreateDate: 2016-4-1
/// Input:      AEpisodeID 就诊号
///            AGlossaryInternalID 术语目录
/// Output      术语集电子病历内容
///                类型为数组[{"术语代码1":[{"实例ID","值"},{"实例ID","值"},...]},{"术语代码2":[{"实例ID","值"},...]}]
/// Debug:
ClassMethod GetDataByGlossaryCategory(AEpisodeID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID = "")||(AGlossaryInternalID = "") result
	s glossaryCategoryId = ""
	for
	{
		s glossaryCategoryId = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_AGlossaryInternalID,glossaryCategoryId))
		q:(glossaryCategoryId = "")
		s glossaryId = ""
		for
		{
			s glossaryId = $o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryId,glossaryId))
			q:(glossaryId = "")
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryId)
			continue:(objGlossary = "")
			s values = ..GetDataByGlossaryID(AEpisodeID,glossaryId)
			d result.SetAt(values,objGlossary.InternalID)
			
			//获取知识库节点数据
			s glossarySubID = ""
			for
			{
				s glossarySubID = $o(^DHCEPRM.GlossaryI("IdxParentID"," "_glossaryId,glossarySubID))
				q:(glossarySubID = "")
				s objsubGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossarySubID)
				continue:(objsubGlossary = "")
				s subvalues = ..GetDataByGlossaryID(AEpisodeID,glossarySubID)
				d result.SetAt(subvalues,objsubGlossary.InternalID)
			}
		}
	}
	q result
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       yejian
/// CreateDate:    2016-7-14        
/// Input：        AEpisodeID:就诊号 
///                ATemplateID:模板ID
/// 				   AGlossaryInternalID:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组  xuefl 返回值去了“实例ID”，把： $tr(strValue,"|","^")
///                格式：[{"术语代码1":"实例ID[]值&实例ID[]值&实例ID[]值"},{"术语代码2":"实例ID[]值&实例ID[]值&实例ID[]值"},...}]
/// debug	d ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryTemplateID("112","5","HDSD00.14.02")
ClassMethod GetDatasByGlossaryTemplateID(AEpisodeID As %String, ATemplateID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	//b "S"
	s InstanceIDS =##Class(EMRservice.BL.BLGlossary).GetInstancesByEpisodeTemID(AEpisodeID,ATemplateID)
	s rset = ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryCategory(AEpisodeID,AGlossaryInternalID)
	q:(rset = "") result
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) result
	s key = ""
	while(1)
	{
		s key = rset.Next(key)
		q:(key = "")
		s strRelut = ""
		s retArr = rset.GetAt(key)
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			//s strValue = AInstanceID_"[]"_retArr.GetAt(AInstanceID)
			s strValue = "[]"_retArr.GetAt(AInstanceID)
			if (strRelut = "")
			{
				s strRelut = $tr(strValue,"|","^")
			}
			else
			{
				s strRelut = strRelut_"&"_$tr(strValue,"|","^")
			}
		}
		d result.SetAt(strRelut,key)
	}
	q result
}

/// Desc:	获取InstanceID集合通过AEpisodeID和TemplateID
/// Input：	AEpisodeID : 就诊指针
/// 		ATemplateID : 指定术语集范畴内部标识符
/// Output:	获取instanceID集合
///         类型：数组 
/// Debug:	w ##Class(EMRservice.BL.BLGlossary).GetInstancesByEpisodeTemID("40","5")
ClassMethod GetInstancesByEpisodeTemID(AEpisodeID As %String, ATemplateID As %String) As %List
{
	s reslut = ""
	s emrTemRowID = ""
	for {
		s emrTemRowID = $o(^DHCEMRM.EMRTemplateI("IdxBindTemplateID"," "_ATemplateID,emrTemRowID))
		q:(emrTemRowID = "")
		s objEMRTem = ##Class(EMRmeta.EMRTemplate).%OpenId(emrTemRowID)
		continue:(objEMRTem="")
		s strChartItemID = objEMRTem.CategoryID
		s strTemplateCategoryID = objEMRTem.BindTemplateCategoryID
		s strECRowID = ""
		s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,strChartItemID,strECRowID))
		if (strECRowID = "")
		{
			s strECRowID = ""
			for {
			s strECRowID = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDCategoryID",AEpisodeID,strTemplateCategoryID,strECRowID))
			q:(strECRowID = "")
			s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)

			Set key = ""
			do
			{ 
		    	S objInstanceData = objECRecord.Instances.GetNext(.key)
			    if (objInstanceData '= "")
		     	{ 
		     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     continue:(objInstanceData.TemplateID '= ATemplateID)
			     continue:(reslut [ objInstanceData.%Id())
			     s reslut = reslut_$lb(objInstanceData.%Id())
			  	} 
	 		 } 
	 		 while (key '="" )
			}
		}
		else
		{
			continue:(strECRowID = "")
			s objECRecord = ##Class(EMRinstance.ECRecord).%OpenId(strECRowID)

			Set key = ""
			do
			{ 
		    	S objInstanceData = objECRecord.Instances.GetNext(.key)
			    if (objInstanceData '= "")
		     	{ 
		     	 continue:((objInstanceData.Status="UnSave")||(objInstanceData.Status="Delete"))
			     continue:(objInstanceData.TemplateID '= ATemplateID)
			     continue:(reslut [ objInstanceData.%Id())
			     s reslut = reslut_$lb(objInstanceData.%Id())
			  	} 
	 		 } 
	 		 while (key '="" )
 		 }
	 }
	q reslut
}

/// Desc:	通过就诊号，获取instanceData表中其他属性字段值
/// Input：	AEpisodeID : 就诊指针
/// 		ACategoryInternalID : 指定术语集范畴内部标识符
/// Output:	获取instanceID，重复模板获取最新的保存状态的instanceID。
/// Debug:	w ##Class(EMRservice.BL.BLScatterData).GetInstanceIDSByTemID("35","73")
ClassMethod GetInstanceDataProperty(AEpisodeID As %String, itemCodes As %String, valueType As %String, ATemplateID As %String) As %String
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	//EMRinstance.InstanceData#CreateDate|CreateTime
	s strClassName = $p(itemCodes,"#",1)
	s strPropertys = $p(itemCodes,"#",2)
	s strPropertyO = $p(strPropertys,"|",1)
	s strPropertyT = $p(strPropertys,"|",2)
	s strValueO = ""
	s strValueT = ""
	s AInstanceID = ""
	s InstanceIDS =##Class(EMRservice.BL.BLGlossary).GetInstancesByEpisodeTemID(AEpisodeID,ATemplateID)
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) result
	for i = 1:1:intInsCount
	{
		s AInstanceID = $lg(InstanceIDS,i)
		continue:(AInstanceID="")
		s value =""
		s cmdCreateCls="objData=##class("_strClassName_").%OpenId("""_AInstanceID_""")"
		s @cmdCreateCls
		if (strPropertyO'="")
		{
			s ^GetNewScatterDataIDGLOBE(strPropertyO) = ""
			s cmdSetValue ="^GetNewScatterDataIDGLOBE("""_strPropertyO_""")=objData."_strPropertyO_""
			s @cmdSetValue
			s strValueO =^GetNewScatterDataIDGLOBE(strPropertyO)
			k ^GetNewScatterDataIDGLOBE(strPropertyO)
		}
		if (strPropertyT'="")
		{
			s ^GetNewScatterDataIDGLOBE(strPropertyT) = ""
			s cmdSetValue ="^GetNewScatterDataIDGLOBE("""_strPropertyT_""")=objData."_strPropertyT_""
			s @cmdSetValue
			s strValueT =^GetNewScatterDataIDGLOBE(strPropertyT)
			k ^GetNewScatterDataIDGLOBE(strPropertyT)
		}
		if ((strPropertyO="CreateUser")||("ModifyUser"=strPropertyO))
		{
			s userName = ""
			&SQL(select ssusr_name into :userName  from SQLUser.SS_User where ssusr_rowid = :strValueO)
			s strValueO = strValueO _"^"_userName
		}
		//日期类型转换
		if ((strPropertyO="CreateDate")||("HappenDate"=strPropertyO)||("ModifyDate"=strPropertyO))
		{
			//YYYY-MM-DD HH:MM
			if (strValueO'="")
			{
				s strValueO = $zd(strValueO,3)
			}
		}
		elseif((strPropertyO="CreateTime")||("HappenTime"=strPropertyO)||("ModifyTime"=strPropertyO))
		{
			if (strValueT'="")
			{
				s strValueO = $zt(strValueO,1)
			}
		
		}
		if ((strPropertyT="CreateTime")||("HappenTime"=strPropertyT)||("ModifyTime"=strPropertyT))
		{
			if (strValueT'="")
			{
				s strValueT = $zt(strValueT,1)
			}
		
		}
		if (strValueT'="")
		{
			s value = strValueO_" "_strValueT
		}
		else
		{
			s value = strValueO
		}
		d result.SetAt(value,AInstanceID)
	}
	q result
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       yejian
/// CreateDate:    2016-7-14        
/// Input：        AEpisodeID:就诊号 
///                ATemplateID:模板ID
/// 				   AGlossaryInternalID:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组  xuefl 返回值去了“实例ID”，把： $tr(strValue,"|","^")
///                格式：[{"术语代码1":"实例ID[]值&实例ID[]值&实例ID[]值"},{"术语代码2":"实例ID[]值&实例ID[]值&实例ID[]值"},...}]
/// debug	d ##Class(EMRservice.BL.BLGlossary).GetDataByGlossaryTemplateID("112","5","HDSD00.14.02")
ClassMethod GetNewDatasByGlossaryTemplateID(AEpisodeID As %String, ATemplateID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	//b "S"
	s InstanceIDS =##Class(EMRservice.BL.BLGlossary).GetInstancesByEpisodeTemID(AEpisodeID,ATemplateID)
	s rset = ##Class(EMRservice.BL.BLGlossary).GetNewDataByGlossaryCategory(AEpisodeID,AGlossaryInternalID)
	q:(rset = "") result
	s intInsCount = $ll(InstanceIDS)
	q:(intInsCount = 0) result
	s key = ""
	while(1)
	{
		s key = rset.Next(key)
		q:(key = "")
		s strRelut = ""
		s retArr = rset.GetAt(key)
		s retArr = "##"_retArr
		if (key ="HDSD00.11.110")
		{
			S str = ""
		}
		for i = 1:1:intInsCount
		{
			s AInstanceID = $lg(InstanceIDS,i)
			continue:(AInstanceID="")
			s strID = "##"_AInstanceID_"[]"
			if (retArr [ strID)
			{
			    s strValue = $P($p(retArr,strID,2),"##",1)
			}
			else
			{
				continue	
			}
			if (strRelut = "")
			{
				s strRelut = $tr(strValue,"|","^")
			}
			else
			{
				s strRelut = strRelut_"&"_$tr(strValue,"|","^")
			}
		}
		d result.SetAt(strRelut,key)
	}
	q result
}

/// Description:   根据术语集代码取电子病历数据接口
/// Creator:       yejian
/// CreateDate:    2016-7-14        
/// Input：        AEpisodeID:就诊号 
///                ATemplateID:模板ID
/// 				   AGlossaryInternalID:术语集标识符
/// Output         术语集对应该电子病历单元值
///                类型：数组  xuefl 返回值去了“实例ID”，把： $tr(strValue,"|","^")
///                格式：[{"术语代码1":"实例ID[]值&实例ID[]值&实例ID[]值##实例ID[]值&实例ID[]值&实例ID[]值"},{"术语代码2":"实例ID[]值&实例ID[]值&实例ID[]值##实例ID[]值&实例ID[]值&实例ID[]值"},...}]/// Debug:
ClassMethod GetNewDataByGlossaryCategory(AEpisodeID As %String, AGlossaryInternalID As %String) As %ArrayOfDataTypes
{
	s result = ##Class(%ArrayOfDataTypes).%New()
	q:(AEpisodeID = "")||(AGlossaryInternalID = "") result
	s glossaryCategoryId = ""
	for
	{
		s glossaryCategoryId = $o(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_AGlossaryInternalID,glossaryCategoryId))
		q:(glossaryCategoryId = "")
		s glossaryId = ""
		for
		{
			s glossaryId = $o(^DHCEPRM.GlossaryI("IdxCategoryID"," "_glossaryCategoryId,glossaryId))
			q:(glossaryId = "")
			s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryId)
			continue:(objGlossary = "")
			if (objGlossary.InternalID = "HDSD00.11.110")
			{
				s str = ""
			}
			s values = ..GetNewDataByGlossaryID(AEpisodeID,glossaryId)
			d result.SetAt(values,objGlossary.InternalID)
			
			//获取知识库节点数据
			s glossarySubID = ""
			for
			{
				s glossarySubID = $o(^DHCEPRM.GlossaryI("IdxParentID"," "_glossaryId,glossarySubID))
				q:(glossarySubID = "")
				s objsubGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossarySubID)
				continue:(objsubGlossary = "")
				s subvalues = ..GetNewDataByGlossaryID(AEpisodeID,glossarySubID)
				d result.SetAt(subvalues,objsubGlossary.InternalID)
			}
		}
	}
	q result
}

/// Desc:       根据取术语项ID取病历数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///             AGlossaryID 术语代码rowID
/// Output:     ##Class(EMRservice.BL.BLGlossary).GetDataByGlossary(76,1029)	
ClassMethod GetNewDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String) As %String
{
	s strResult = ""
	q:((AEpisodeID = "")||(AGlossaryID = "")) result
	s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(AGlossaryID)
	q:(objGlossary = "") result
	if ($zcvt(objGlossary.GlossaryType,"U") = "TG")    //模板
	{
		s rowid = ""
		for 
		{
			s rowid = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",AGlossaryID,rowid))
			q:(rowid = "")
			s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(rowid)
			continue:(objGlossaryItem = "")
			if ($zcvt(objGlossaryItem.TemType,"U") = "NEW")
			{
				//新版
				s result = ..GetNewScatterDatas(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryItem.ValueType)
			}
			elseif($zcvt(objGlossaryItem.TemType,"U") = "EMRINSTANCE")
			{
				//扩展的instanceData属性字段
				s result = ..GetInstanceDataProperty(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryItem.ValueType,objGlossaryItem.TemplateID)
			}
			else
			{
				//老版
				s result = ..GetNewScatterDatas(AEpisodeID,objGlossaryItem.TemplateID,objGlossaryItem.ItemCode,objGlossaryItem.ValueType)
			}
			if (result'="")
			{
				if (strResult = "")
				{
					s strResult = result
				}
				else
				{
					s strResult = strResult _"##"_result
				}
			}
		}	
	}
	else //知识库
	{
		s parGlassaryId = objGlossary.ParentID
		q:(parGlassaryId = "") result
		s objParGlossary = ##Class(EPRmeta.Glossary).%OpenId(parGlassaryId)
		q:(objParGlossary = "") result
		s itemRowId = ""
		for
		{
			s itemRowId = $o(^DHCEPRM.GlossaryItemI("IdxGlossaryID",parGlassaryId,itemRowId))
			q:(itemRowId = "")
			s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(itemRowId)
			continue:(objGlossaryItem = "")
			s rowid = ""
			for
			{
				s rowid = $o(^DHCEPRM.GlossaryKBItemI("IdxKBType",AGlossaryID," "_$zcvt(objGlossaryItem.TemType,"U"),rowid))
				q:(rowid = "")
				s objGlossaryKBItem = ##Class(EPRmeta.GlossaryKBItem).%OpenId(rowid)
				continue:(objGlossaryKBItem = "")
				if ($zcvt(objGlossaryItem.TemType,"U") = "NEW")
				{
					//新版
					s result =..GetNewKBScatterDatas(AEpisodeID,objGlossaryItem.ItemCode,objGlossaryKBItem.ItemCode,objGlossaryItem.TemplateID,objGlossaryKBItem.KBNodeID,objGlossaryKBItem.ValueType)
				}
				else
				{
					//老版
					s result = ..GetNewKBScatterDatas(AEpisodeID,objGlossaryItem.TemplateID,objGlossaryItem.ItemCode,objGlossaryKBItem.ItemCode,objGlossaryKBItem.KBNodeID,objGlossaryKBItem.KBPartNo,objGlossaryKBItem.ValueType)
				}
				if (result'="")
				{
					if (strResult = "")
					{
						s strResult = result
					}
					else
					{
						s strResult = strResult _"##"_result
					}
				}
			}
			q:(strResult'="")	
		}	
	}		
	q strResult
}

/// Desc:       根据单元代码取所有病历打散数据
/// Creator:    Candy
/// CreateDate: 2016-3-30
/// Input:      AEpisodeID 就诊号
///            AItem #TYPE:ICOMPOSITESAMPLE#SCODE:S010|CCODE:V001|CSCODE:L013#TID:88#VTYPE:V
/// Output:     result 数组 key:病历ID value:单元值
/// Debug:
ClassMethod GetNewScatterDatas(AEpisodeID As %String, AItem As %String, ATemplateID As %String, AValueType As %String) As %String
{
	s $ZT="ERROR"
	s result = ""
	q:((AEpisodeID = "")||(AItem = "")||(ATemplateID = "")) result
	s elementType = $p($p(AItem,"#",2),":",2)
	s vtype = $Case(AValueType,"":"V",:AValueType)
	if (elementType = "ISECTIONDESC")
	{
		s code = $p($p(AItem,"#",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ISectionDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_code,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetSectionData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
		}
	} 
	elseif (elementType = "ICOMPOSITEDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeDescI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
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
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif (elementType = "ICONCEPTDESC")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetConceptData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
		}
	}
	elseif (elementType = "ICONCEPTSAMPLE")
	{
		s scode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s cocode = $p($p($p(AItem,"#",3),"|",3),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",4),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.IConceptSimpleI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_cocode," "_cscode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
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
ClassMethod GetNewKBScatterDatas(AEpisodeID As %String, APItem As %String, AItem As %String, ATemplateID As %String, AKBNodeID As %String, AValueType As %String) As %String
{
	s $ZT="ERROR"
	s result = ""
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
		s ccode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s cscode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeSimpleI("IdxForKBNode"," "_AEpisodeID," "_ATemplateID," "_AKBNodeID," "_scode," "_ccode," "_cscode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetCompositeSimpleData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
		}		
	}
	elseif(elementType = "ICONCEPTDESC")
	{
		s scode = $p($p($p(APItem,"#",3),"|",1),":",2)
		s ccode = $p($p($p(AItem,"#",3),"|",1),":",2)
		s coCode = $p($p($p(AItem,"#",3),"|",2),":",2)
		s instanceId = ""		
		for
		{
			s instanceId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_coCode,instanceId))
			q:(instanceId = "")
			s tmpInstanceId = $tr(instanceId," ","")
			s objInstance = ##Class(EMRinstance.InstanceData).%OpenId(tmpInstanceId)
			continue:(objInstance = "")
			continue:($zcvt(objInstance.Status,"U") '= "SAVE")
			s rowId = $o(^DHCEMRI.ICompositeConceptI("IdxForLink"," "_AEpisodeID," "_ATemplateID," "_scode," "_ccode," "_coCode,instanceId,""))
			s value = ##Class(EMRservice.BL.BLScatterData).GetConceptData(rowId,vtype)
			s strValue =tmpInstanceId_"[]"_value
			if (result = "")
			{
				s result = strValue
			}
			else
			{
				s result = result_"&"_strValue
			}
			;d result.SetAt(value,tmpInstanceId)
		}
		s result = ##Class(EMRservice.BL.BLScatterData).GetConceptData(curRowID,valueType)
		
	}
	elseif(elementType = "ICONCEPTSAMPLE")
	{
		s CompositeCode = ""
		s coCode = ""
		s SimpleItemCode = ""
		
		if ($l(itemCode,"|")=2)
		{
			s CompositeCode = $p($p(itemCode,"|",1),":",2) 
			s coCode = $p($p(itemCode,"|",2),":",2)
			s SimpleItemCode = $p($p(itemCode,"|",3),":",2)
		}
		q:(CompositeCode="") ""
		q:(coCode="") ""
		q:(SimpleItemCode="") ""
		s curSectionCode = ""
		for {
			s curSectionCode = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode))
			q:(curSectionCode = "")
			s curRowID= ""
			s curRowID = $o(^DHCEMRI.IConceptSimpleI("IdxForGetSection"," "_AInstanceID," "_CompositeCode," "_coCode," "_SimpleItemCode,curSectionCode,curRowID))
			continue:(curRowID = "")
			s result = ##Class(EMRservice.BL.BLScatterData).GetConceptSimpleData(curRowID,valueType)
			q:(result'="")
		}
	}
	q result
	
ERROR
    q "ERROR"
}

}
