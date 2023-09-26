/// 名称:		EMR.DOC.BL.GlossaryAchieveValue
/// 描述:		术语集取值
/// 编写者:		huhao
/// 编写日期: 	2022/11/29
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.GlossaryAchieveValue Extends EMR.DOC.COM.ActionBase [ Not ProcedureBlock ]
{

/// Desc:       术语集取值
/// Creator:    huhao
/// CreateDate: 2022/11/29
/// Table:		
/// Input:      AEpisodeID：就诊号
/// 				ACategoryInternalID：术语标识符 
/// 				AState:判断签名打印状态标识符	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:d ##class(EMR.DOC.BL.GlossaryAchieveValue).GetNewScatterDataByGlossaryID(1176,"HDSD00.02.0203")
ClassMethod GetGlossaryValue(AEpisodeID As %String, ACategoryInternalID As %String, IP As %String, userCode As %String, Product As %String, AState As %String = "") As %ArrayOfDataTypes
{

	q:(IP="") "IP不能为空"
	q:(userCode="") "用户名不能为空"
	q:(Product="") "产品组不能为空"
	//添加查询日志
	d ##class(EMR.DOC.BL.GlossaryAchieveValue).GetValueLog(IP,userCode,Product)
	
	s ret=##class(%ArrayOfDataTypes).%New()
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") "就诊号有误"
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") "术语集标识符有误"
	
	//取标识符关联术语id
	s glossaryCategoryID = $O(^CF.EMR.DOC.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") "没有关联术语"
	
	//获取模板id字符串（175^715）
	s templateCategoryID=..GetGlossaryTemplateIDS(ACategoryInternalID)
	q:(templateCategoryID="") "模板id不存在"
	
	//获取实例id集合
	s InstanceIDS=..GetInstanceIDByTInterID(AEpisodeID,templateCategoryID,ACategoryInternalID,AState)
	s initCount=$l(InstanceIDS,"^")
	q:initCount=0 "没有实例信息"
	for i=1:1:initCount
	{
		s AInstancID=$p(InstanceIDS,"^",i)
		continue:AInstancID=""
		s retArray=##class(%ArrayOfDataTypes).%New()
		s tempalteID=""
		s glossaryID=""
		for
		{
			s glossaryID=$o(^CF.EMR.DOC.GlossaryI("IdxCategory",glossaryCategoryID,glossaryID))
			q:glossaryID=""
			s objGlossary=##class(CF.EMR.DOC.Glossary).%OpenId(glossaryID)
			continue:objGlossary=""
			
			s strDataValues=""
			s strDataValues=..GetNewScatterDataByGlossaryID(AEpisodeID,glossaryID,AInstancID)
			s strDataValue=strDataValues
			
			s deName=objGlossary.Name
			s deName=$p(deName," ",2)
			s strInternalID=objGlossary.InternalID
			
			
			//关联标准数据源标识符
			s strMetaID=objGlossary.MetaID
			s strDescription=objGlossary.Description
			
			if ((strMetaID="")||(strMetaID=$char(0)))
			{
				d ret.SetAt(strDataValue,strInternalID)
				continue
			}
			s derowID=""
			s derowID=$o(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_strMetaID,derowID))
			s strDataType=""
			s strDEVID=""
			s strFormat=""
			if (derowID'="")
			{
				s objCurDataE=##class(CF.EMR.DOC.DataElement).%OpenId(derowID)
				S strDataType=objCurDataE.DataType
				s strFormat=objCurDataE.Format
				s strDEVID=objCurDataE.DEVID
			}
			//通过术语子集取数据类型
			s itemRowID=""
			s strValueType=""
			s itemCode=""
			s tempalteID=""
			s itemRowID=$o(^CF.EMR.DOC.GlossaryItemI("IdxGlossaryID",glossaryID,itemRowID))
			if (itemRowID'="")
			{
				s objGlossaryItem=##class(CF.EMR.DOC.GlossaryItem).%OpenId(itemRowID)
				s strValueType=objGlossaryItem.ValueType
				//当前为ICOMPOSITESAMPLE,旧版为#TYPE:ICOMPOSITESAMPLE#SCODE:HEADER|CCODE:V001|CSCODE:D001
				s itemCode=objGlossaryItem.ItemType.Code 
				s tempalteID=objGlossaryItem.DataID
			}
			
			//判断是否有数据元映射关系
			s devCategoryID=""
			s sysCode=""
			s categoryName=""
			s MaprowID=""
			//通过数据元允许值标识符取映射关系
			if ($d(strDEVID)&(strDEVID'="")&($L(strDEVID)>1))
			{
				//通过数据元允许值去允许值范畴名字
				s devCategoryID=$o(^CF.EMR.DOC.DEVCategoryI("IdxDECVMID"," "_strDEVID,devCategoryID))
				if (devCategoryID'="")
				{
					s objdevCategory=##class(CF.EMR.DOC.DataElementValuesCategory).%OpenId(devCategoryID)
					s categoryName=objdevCategory.Name
				}
				s:categoryName="" categoryName=strDEVID
				
				//如果术语集业务数据不为空，则通过新索引处理
				if (strDataValue'="")
				{
					if (strValueType="C")
					{
						s IndexMaprowID=MaprowID
						s MaprowID=$o(^CF.EMR.DOC.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID=$o(^CF.EMR.DOC.GlossaryItemMapI("IdxDECVMIDTempID"," "_strDEVID," "_$zcvt(strDataValue,"U"),IndexMaprowID))
					}
					if (strValueType="V")
					{
						s IndexMaprowID=MaprowID
						s MaprowID=$o(^CF.EMR.DOC.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_strDataValue,MaprowID))
						s:(MaprowID="") MaprowID=$o(^CF.EMR.DOC.GlossaryItemMapI("IdxDECVMIDTempDes"," "_strDEVID," "_$zcvt(strDataValue,"U"),IndexMaprowID))
					}
					if (MaprowID'="")
					{
						s objMap=##class(CF.EMR.DOC.GlossaryItemMap).%OpenId(MaprowID)
						s strDataValue=objMap.DEVDes
						s sysCode=objMap.DEVID
					}
				}
				
			}
			//判断数据类型
			if ((strDataType'="")&(strDataValue'=""))
			{
				s strDataValue =..GetDataByType(strDataValue,strDataType)

			}
			//判断数据元数据格式
			if ((strFormat'="")&(strDataValue'=""))
			{
				if (sysCode'="")
				{
					s sysCode = ..GetDataByFormat(sysCode,strFormat,"1")
				}
				else
				{
					s strDataValue = ..GetDataByFormat(strDataValue,strFormat,"1")
				}

			}
			
			if ((sysCode="")&(strDataValue'="")&(strValueType="C"))
			{
				s sysCode=strDataValue
				s strDataValue=""
			}
			
			s strDataValues = $s(strValueType="VANDC":strDataValue,strValueType="V":strDataValue,strValueType="":strDataValue,strValueType="T":strDataValue,strValueType="C":sysCode,strValueType="YMD":sysCode,1:strDataValue)
			d ret.SetAt(strDataValues, strInternalID)

		}
	}
	;zw ret
	q ret
}

/// Desc:       通过术语集标识符获取模板id集合
/// Creator:    huhao
/// CreateDate: 2022/11/29
/// Table:		CF.EMR.DOC.GlossarysTemplate
/// Input:      aInetrnalID:术语集内部标识符  	 
/// OutPut:     TemplateCategroyID 关联模板id集合
/// Debug:		w  ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetGlossaryTemplateIDS("HDSD00.02.01")
ClassMethod GetGlossaryTemplateIDS(aInetrnalID As %String) As %String
{
	s templateCategoryID=""
	q:(aInetrnalID="") "标识符不能为空"
	s sub=""
	for
	{
		//绑术语目录id
		s sub=$o(^CF.EMR.DOC.GlossarysTemplateI("IdxInternalID"," "_aInetrnalID,sub))
		q:sub=""
		s objGlossaryTem=##class(CF.EMR.DOC.GlossarysTemplate).%OpenId(sub)
		q:objGlossaryTem="" 
		if (templateCategoryID="")
		{
			s templateCategoryID=objGlossaryTem.TemplateID
		}
		else
		{
			s templateCategoryID=templateCategoryID_"^"_objGlossaryTem.TemplateID
		}
	}
	q templateCategoryID
}

/// Desc:       通过就诊号，模板id，术语集标识符，病历状态获取实例id集合
/// Creator:    huhao
/// CreateDate: 2022/11/29
/// Table:
/// Input:      AEpisodeID:就诊号
/// 			ATemplateCategoryIDs:关联模板id构成的字符串	  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetInstanceIDByTInterID(AEpisodeID As %String, ATemplateCategoryIDs As %String, ACategoryInternalID As %String = "", AState As %String = "") As %String
{
	s result=""
	s ATemplateID=""
	s intTC=$l(ATemplateCategoryIDs,"^")
	for i=1:1:intTC
	{
		s ATmplateCategoryID=$p(ATemplateCategoryIDs,"^",i)
		q:ATmplateCategoryID=""
		s strTitleCode=""
		if (ACategoryInternalID'="")
		{
			s strTitleCode=..GetTitleBYGlossaryIntaID(ACategoryInternalID)
		}
		s resultID=..GetInstanceBTInterIDTemID(AEpisodeID,ATmplateCategoryID,strTitleCode,.result,AState)
	}
	q result
}

// 获取系统参数code值

ClassMethod GetTitleBYGlossaryIntaID(AGlossaryCategoryID As %String) As %String
{
	q:AGlossaryCategoryID="" ""
	s InterCodeValues=##class(EMR.DOC.BL.SysOption).GetOptionValueByName("InternalIDTitleCode")
	q:InterCodeValues="" ""
	s strTitleCode=""
	if (InterCodeValues[AGlossaryCategoryID)
	{
		s intCount=$l(InterCodeValues,"|")
		for i=1:1:intCount
		{
			s strValue=$p(InterCodeValues,"|",i)
			s strInterID=$p(strValue,"^",i)
			if (strInterID=AGlossaryCategoryID)
			{
				s strTitleCode=$p(strValue,"^",2)
				q
			}
		}
	}
	q strTitleCode
}

/// Desc:       获取实例id集合
/// Creator:    huhao
/// CreateDate: 2022/11/30
/// Table:		EMR.DAO.DocumentData
/// Input:      AEpisodeID：就诊号
/// 				AtemplateID：模板id集
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetInstanceBTInterIDTemID(AEpisodeID As %String, AtemplateID As %String, strTitleCode As %String = "", ByRef result As %String = "", AState As %String = "") As %String
{
	
	s status=""
	for
	{
		s InsantanceID=""
		//取实例id
		s truthIndex=##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
		s status=$o(@truthIndex@("IdxEpisodeTemplateStatus",AEpisodeID,AtemplateID,status))
		q:status=""
		continue:((status=" UNSAVE")||(status=" DELETE"))
		s InsantanceID=$o(@truthIndex@("IdxEpisodeTemplateStatus",AEpisodeID,AtemplateID,status,""))
		q:InsantanceID=""
		s InsantanceObj=##class(EMR.DAO.DocumentData).doOpenByID(InsantanceID)
		s resState="1"
		//签名是否有效
		s:(AState="SIGN") resState=##class(EMR.DOC.BL.PrivAssist).HasValidSign(InsantanceID)
		//是否完成打印操作
		s:(AState="PRINT") resState=##class(EMR.DOC.BL.PrivAssist).IsRecordActioned(AEpisodeID,InsantanceID,"Print")
		continue:resState=0
		if (result="") {s result=InsantanceID}
		else{s result=result_"^"_InsantanceID}
	}
	q result
}

/// Desc:       使用术语集取打散数据
/// Creator:    huhao
/// CreateDate: 
/// Table:		CF.EMR.DOC.Glossary，CF.EMR.DOC.GlossaryItem，CF.EMR.DOC.GlossaryKBItem
/// Input:      AEpisodeID：就诊号
/// 				AGlossaryID：术语id
/// 				AInstanceID：实例id
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetNewScatterDataByGlossaryID(AEpisodeID As %String, AGlossaryID As %String, AInstanceID As %String, Output aRowID As %String = "") As %String
{
	s res=""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") res
	q:($d(AGlossaryID) = 0)||(AGlossaryID = "") res
	q:($d(AInstanceID) = 0)||(AInstanceID = "") res
	s objGlossary=##class(CF.EMR.DOC.Glossary).%OpenId(AGlossaryID)
	q:objGlossary="" res
	
	s name=objGlossary.Name
	s type=objGlossary.GlossaryType
	s strInstanceID=AInstanceID
	if ($ZCVT(type,"U")="TG")
	{
		s rowId=""
		for
		{
			s rowId=$o(^CF.EMR.DOC.GlossaryItemI("IdxGlossaryIDType",AGlossaryID,"EMRDOC",rowId))
			q:rowId=""
			s objItem=##class(CF.EMR.DOC.GlossaryItem).%OpenId(rowId)
			s aRowID=rowId
			s templateID=..GetIDByKey(objItem.DataID)
			s valueType=objItem.ValueType
			continue:objItem.ItemType=""
			s elementType=objItem.ItemType.Code
			;s strInstanceID=..GetInstanceByEpisodeTemID(AEpisodeID,templateID)
			s strTemType=objItem.TemType
			if (($zcvt(strTemType,"U") ="EMRDOC")||($zcvt(strTemType,"U") ="BDM"))
			{
				;s Scode=objItem.SCode
				;s CScode=objItem.CSCode
				s itemCode="SCode:"_objItem.SCode_"|"_"CSCode:"_objItem.CSCode
				s res=..GetTGScatterData(AEpisodeID,templateID,strInstanceID,itemCode,valueType,elementType)
			}
			elseif ($zcvt(strTemType,"U")="EMRINSTANCE")
			{
				s itemCode=objItem.CodePath
				s res=..GetInstanceDataProperty(AEpisodeID,itemCode,valueType,AInstanceID)
			}
			q:(res'="")&&(res'="NULL")
		}
	}
	else
	{
		s kbRowID=""
		for
		{
			s kbRowID=$o(^CF.EMR.DOC.GlossaryItemI("IdxGlossaryIDType",AGlossaryID,"KB",kbRowID))
			q:kbRowID=""
			s objParItem=##class(CF.EMR.DOC.GlossaryItem).%OpenId(kbRowID)
			s curItemCodes=objParItem.ItemCode
			s curItemCodes="#TYPE:"_objParItem.ItemType.Code_"#SCODE:"_objParItem.SCode_"#CSCODE:"_objParItem.CSCode
			s curValueType=objParItem.ValueType
			s kbNodeID=objParItem.DataID
			s strKBType=objParItem.TemType
			if ($zcvt(strKBType,"U")="KB")
			{
				s kbScatterObj=##class(%DynamicObject).%New()
				s kbScatterObj.curValueType=curValueType 
				s kbScatterObj.kbNodeID=kbNodeID
				s kbScatterObj.itemCode=curItemCodes
				s res = ""
				s res = ..GetKBScatterData(AEpisodeID,AInstanceID,kbScatterObj)
			}
		}
	}
	s:(res="NULL") res=""
	q res
}

/*
ClassMethod GetInstanceByEpisodeTemID(AEpisodeID As %String, ATemplateID As %String) As %String
{
	s res=""
	s rowId=""
	s truthGlobal=##Class(EMR.DAO.DocumentData).GetTureIndexLocation(AEpisodeID)
	for
	{
		s rowId=$o(@truthGlobal@("IdxEpisodeTemp",AEpisodeID,ATemplateID,rowId))
		q:rowId=""
		s InsantanceObj=##class(EMR.DAO.DocumentData).doOpenByID(rowId)
		q:InsantanceObj=""
		continue:((InsantanceObj.Status="UnSave")||(InsantanceObj.Status="Delete"))
		s res=rowId
	}
	q res
}
*/
/// Desc:       取模板打散数据
/// Creator:    huhao
/// CreateDate: 2022/12/6
/// Table:		
/// Input:      AEpisodeID：就诊号  
/// 				templateId：模板id
/// 				AInstanceID：实例id
/// 				SCode：章节编码，CSCode：段落编码，valuetype：取值类型，elementType：取打散类型	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetTGScatterData(AEpisodeID As %String, templateId As %String, AInstanceID As %String, itemCode As %String, valueType As %String, elementType As %String) As %String
{
	s result=""
	q:AEpisodeID="" result
	q:AInstanceID="" result
	
	s SCode=$p($p(itemCode,"|",1),":",2)
	s CSCode=$p($p(itemCode,"|",2),":",2)
	
	s rowId=""
	if (elementType="ISECTIONDESC")
	{
		IF (templateId'="-1")
		{
			s rowId=..GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		}
		ELSE
		{
			s rowId=..GetSectionIDBySecCode(AEpisodeID,SCode,AInstanceID)
		}
		q:rowId="" result
		s result=..GetSectionData(AEpisodeID,rowId)
	}
	elseif(elementType="ICOMPOSITESAMPLE")
	{
		if (templateId'="-1")
		{
			s truThIndexLocation=##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
			s rowId =$o(@truThIndexLocation@("IdxForLink",AEpisodeID,templateId," "_$zcvt(SCode,"U")," "_$zcvt(CSCode,"U"),AInstanceID,rowId))
		}
		else
		{
			s rowId = ..GetComSimIDBySecSimCode(AEpisodeID,SCode,CSCode,AInstanceID)
	
		}
		q:(rowId = "") result
		s result = ..GetCompositeSimpleData(rowId,valueType,AEpisodeID)

	}
	q result
}

/// Desc:       取章节打散数据id
/// Creator:    huhao
/// CreateDate: 2022/12/6
/// Table:		EMR_DB.IStructSection
/// Input:      AEpisodeID：就诊号，ATemplateID：模板id， ACode：章节编码，AInstanceID：实例id
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetSectionID(AEpisodeID As %String, ATemplateID As %String, itemCode As %String, AInstanceID As %String)
{
	s res=""
	s ACode=$p($p(itemCode,"|",1),":",2)
	if (AInstanceID="")
	{
		s instanceId=""
		for
		{
			s truThIndexLocation=##Class(EMR.DAO.IStructSection).GetTureIndexLocation(AEpisodeID)
			s instanceId=$o(@truThIndexLocation@("IdxForLink",AEpisodeID,ATemplateID," "_$zcvt(ACode,"U"),instanceId))
			q:instanceId=""
			s instanceObj=##class(EMR.DAO.DocumentData).doOpenByID(instanceId)
			continue:((instanceObj.Status="UnSave")||(instanceObj.Status="Delete"))
			s res=$o(@truThIndexLocation@("IdxForLink",AEpisodeID,ATemplateID," "_$zcvt(ACode,"U"),instanceId,""))
		}
	}
	else
	{	
		s rowId=""
		for
		{
			s truThIndexLocation=##Class(EMR.DAO.IStructSection).GetTureIndexLocation(AEpisodeID)
			s rowId=$o(@truThIndexLocation@("IdxForLink",AEpisodeID,ATemplateID," "_$zcvt(ACode,"U"),AInstanceID,rowId))
			q:rowId=""
			s sectionObj=##class(EMR.DAO.IStructSection).doOpenByID(AEpisodeID,rowId)
			s instanceObj=##class(EMR.DAO.DocumentData).doOpenByID(sectionObj.DocumentID.%Id())
			continue:((instanceObj.Status="UnSave")||(instanceObj.Status="Delete"))
			s res=rowId
		}
	
	}
	q res
}

/// Desc:       取章节打散数据id
/// Creator:    huhao
/// CreateDate: 
/// Table:		EMR_DB.IStructSection
/// Input:      AEpisodeID：就诊号，SCode：章节编码， AInstanceID：实例id 	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetSectionIDBySecCode(AEpisodeID As %String, SCode As %String, AInstanceID As %String) As %String
{
	s result=""
	q:AEpisodeID="" result
	q:SCode="" result
	s instanceId=""
	if (AInstanceID'=""){s instanceId=" "_AInstanceID}
	q:instanceId=""
	s truThIndexLocation=##Class(EMR.DAO.IStructSection).GetTureIndexLocation(AEpisodeID)
	s result=$o(@truThIndexLocation@("IdxForUpdate",instanceId," "_$zcvt(SCode,"U"),""))
	q result
}

/// Desc:       取section内容
/// Creator:    huhao
/// CreateDate: 2022/12/6
/// Table:		EMR_DB.IStructSection
/// Input:       AEpisodeID：就诊号，rowId：章节打散数据id	 
/// OutPut:      res:section内容
/// Debug:
ClassMethod GetSectionData(AEpisodeID As %String, rowId As %String) As %String
{
	s res=""
	q:rowId="" "id不能为空"
	s objSection=##class(EMR.DAO.IStructSection).doOpenByID(AEpisodeID,rowId)
	q:objSection="" "没有章节打散数据"
	
	do objSection.Text.Rewind()
	while (objSection.Text.AtEnd=0)
	{
		s len=1024
		s tmpStr=objSection.Text.Read(len)
		s res=res_tmpStr
	}
	q res
}

/// Desc:       获取元素打散数据id
/// Creator:    huhao
/// CreateDate: 2022/12/6
/// Table:		
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetComSimIDBySecSimCode(AEpisodeID As %String, SCode As %String, CSCode As %String, AInstanceID As %String) As %String
{
	s result=""
	q:AEpisodeID="" "就诊号不能为空"
	q:SCode="" "SCode不能为空"
	q:CSCode="" "CSCode不能为空"
	
	s CCode="",instanceId=""
	if (AInstanceID'="")
	{
		s instanceId=" "_AInstanceID
	}
	q:instanceId="" 
	s truThIndexLocation=##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
	s CCode=$o(@truThIndexLocation@("IdxForUpdate",instanceId," "_SCode,CCode))
	q:CCode=""
	s result=$o(@truThIndexLocation@("IdxForUpdate",instanceId," "_SCode," "_CCode,""))
	q result
}

/// Desc:       取元素打散数据
/// Creator:    huhao
/// CreateDate: 
/// Table:
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetCompositeSimpleData(rowId As %String, AVType As %String, AEpisodeID As %String) As %String
{
	s result=""
	q:rowId=""
	s objCompositeSimple=##class(EMR.DAO.IStructSimple).doOpenByID(AEpisodeID,rowId)
	q:objCompositeSimple="" "不存在简单元素打散数据"
	s truThIndexLocation=##Class(EMR.DAO.EMRSign).GetTureIndexLocation(AEpisodeID)
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
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",1)
	}
	elseif (AVType = "MONTH")
	{
		//MM
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",2)	
	}
	elseif (AVType = "DAY")
	{
		//DD
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s result = $p(tempData,"-",3)	
	}
	elseif (AVType = "HOUR")
	{
		//HH
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",1)	
	}
	elseif (AVType = "MINUTE")
	{
		//MM
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",2)	
	}
	elseif (AVType = "SECOND")
	{
		//SS
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zt(objCompositeSimple.DataValue)
		s result = $p(tempData,":",3)		
	}
	elseif (AVType = "YMDHM")
	{
		//YYYY-MM-DD HH:MM
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "MDHM")
	{
		//MM-DD HH:MM
		q:(objCompositeSimple.Type'="dateTime") result
		s tempData = $zd(objCompositeSimple.DataValue,3)
		s tempData = $e(tempData,6,$l(tempData))
		s tempTime = $zt(objCompositeSimple.DataValue,2)
		s result = tempData_" "_tempTime
	}
	elseif (AVType = "YMD")
	{
		//YYYY-MM-DD
		q:(objCompositeSimple.Type'="dateTime") result
		s result = $zd(objCompositeSimple.DataValue,3)
	}
	elseif (AVType = "HMS")
	{
		//HH:MM:SS
		q:(objCompositeSimple.Type'="dateTime") result
		s result = $zt(objCompositeSimple.DataValue)
	}
	elseif (AVType = "HM")
	{
		//HH:MM
		q:(objCompositeSimple.Type'="dateTime") result
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
	elseif(AVType = "U") //获取签名数据用户ID
	{
		s result = ""
		s documentID = objCompositeSimple.DocumentID
		s objInstance = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
		q:(objInstance ="") result

		s sRowID =""
		for {
			s sRowID =$o(@truThIndexLocation@("IdxDocument"," "_documentID,sRowID))
			q:(sRowID="")
			s objSign =##class(EMR.DAO.EMRSign).doOpenByID(AEpisodeID,sRowID)
			if (objSign.isSignValid = 1)
			{
				if (result="")
				{
					s result = objSign.UsrID
				}
				else
				{
					s result = result_"|"_objSign.UsrID
				}
			}
		}
	}
	elseif(AVType = "UV") //获取签名数据用户ID^用户名
	{
		s result = ""
		s documentID = objCompositeSimple.DocumentID
		s objInstance = ##class(EMR.DAO.DocumentData).doOpenByID(documentID)
		q:(objInstance ="") result

		s sRowID =""
		for {
			
			s sRowID =$o(@truThIndexLocation@("IdxDocument"," "_documentID,sRowID))
			q:(sRowID="")
			s objSign =##class(EMR.DAO.EMRSign).doOpenByID(AEpisodeID,sRowID)
			if (objSign.isSignValid = 1)
			{
				if (result="")
				{
					s uName = $p($g(^SSU("SSUSR",objSign.UsrID)),"^",2)
					s result = objSign.UsrID_"^"_uName
				}
				else
				{
					s uName = $p($g(^SSU("SSUSR",objSign.UsrID)),"^",2)
					s result = result_"|"_objSign.UsrID_"^"_uName
				}
			}
		}
	}

	q result
}

/// Desc:       取知识库打散数据
/// Creator:    huhao
/// CreateDate: 2022/12/13
/// Table:		EMR.DB.IStructSimple
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetKBScatterData(AEpisodeID As %String, AInstanceID As %String, kbScatterObj As %DynamicObject) As %String
{
	s result=""
	q:AEpisodeID="" "就诊号不能为空"
	q:AInstanceID="" "实例id不能为空"
	s elementType=kbScatterObj.elementType
	s itemCode=kbScatterObj.itemCode
	s valueType=kbScatterObj.curValueType
	
	//复合单元打散表
	if (kbScatterObj.elementType="ICOMPOSITEDES")
	{		
	}
	//简单单元打散表
	elseif(kbScatterObj.elementType="ICOMPOSITESAMPLE")
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
		for
		{
			s truThIndexLocation=##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
			s curSectionCode=$o(@truThIndexLocation@("IdxForGetSection",AInstanceID,curSectionCode))
			q:curSectionCode=""
			s curRowID=""
			for
			{
				s curRowID=$o(@truThIndexLocation@("IdxForGetSection",AInstanceID,curSectionCode,curRowID))
				q:curRowID=""
				s curRes=..GetCompositeSimpleData(curRowID,valueType,AEpisodeID)
				s:(curRes'="") result=$case(result,"":curRes,:result_"^"_curRes)
			}
		}
		
		s curSectionCode=""
		for
		{
			s truThIndexLocation=##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
			s curSectionCode=$o(@truThIndexLocation@("IdxForGetSection",AInstanceID,curSectionCode))
			q:curSectionCode=""
			s curSourceCode=""
			for
			{
				s curSourceCode=$o(@truThIndexLocation@("IdxForSource",AInstanceID,curSectionCode," "_kbScatterObj.kbNodeID,curSourceCode))
				q:curSourceCode=""
				s curRowID=""
				s curRowID=$o(@truThIndexLocation@("IdxForSource",AInstanceID," "_curSectionCode," "_kbScatterObj.kbNodeID,curSourceCode,curRowID))
				s curRes=..GetCompositeSimpleData(curRowID,valueType,AEpisodeID)
				s:(curRes'="") result=$case(result,"":curRes,:result_"^"_curRes)
			}
		}
		
	}
	//医学元素打散表
	elseif(kbScatterObj.elementType="ICONCEPTDESC")
	{
	}
	//医学元素简单单元打散表
	elseif(kbScatterObj.elementType="ICONCEPTSAMPLE")
	{
	}
	q result
}

/// Desc:根据数据类型进行标准转换
/// strDataValue 1，数据值，2:strDataType，数据类型
/// w ##Class(EPRservice.BOScatterData).GetDataByType("G63","N")
ClassMethod GetDataByType(strDataValue As %String, strDataType As %String) As %String
{
	//为数字类型时，转换为数字
	if (strDataType = "N")
	{
		s strDataValue = +strDataValue
	}
	q strDataValue
}

/// Desc:根据数据格式进行标准转换
///  1:strDataValue业务数据值，2:strFormat为schemas样式转换格式，3strMark为标示：1为转换为包含T的时间格式，2为转换为不包含T的时间格式
/// w ##Class(EPRservice.BOScatterData).GetDataByFormat("1823-1-2 12:2:23","D8","1")
ClassMethod GetDataByFormat(strDataValue As %String, strFormat As %String, strMark As %String) As %String
{
	//将包含年月日日期格式转换为yyyy-mm-dd
	if ((strDataValue [ "年") &(strDataValue [ "月") &(strDataValue [ "日"))
	{
		if $L(strDataValue," ") = 2
		{
			s strdatat = $p(strDataValue," ",1)
			s strdatats = $p(strDataValue," ",2)
			s year = $p(strdatat,"年",1)
			s moth = $p($p(strdatat,"年",2),"月",1)
			s date = $p($p($p(strdatat,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date_" "_strdatats
		}
		else
		{
			s year = $p(strDataValue,"年",1)
			s moth = $p($p(strDataValue,"年",2),"月",1)
			s date = $p($p($p(strDataValue,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date
		}
	}
	//对D8，T8的数据进行标准转换
	if (strFormat [ "D8" ) || (strFormat [ "T8") 
	{
		if $L(strDataValue," ") = 2
		{
			//s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
			s strDataValue = $p(strDataValue," ",1)
		}
		if ((strDataValue [ "年") &(strDataValue [ "月") &(strDataValue [ "日"))
		{
			s year = $p(strDataValue,"年",1)
			s moth = $p($p(strDataValue,"年",2),"月",1)
			s date = $p($p($p(strDataValue,"年",2),"月",2),"日",1)
			s strDataValue = year_"-"_moth_"-"_date
		}
		s datev = $ZDATEH(strDataValue,8)
		s strDataValue =$ZDATE(datev,8)
	}
	//对d6，t6的数据进行标准转换
	elseif (strFormat [ "T6") ||  (strFormat [ "D6") 
	{
		if (strDataValue [ " ")
		{
			//s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
			s strDataValue = $p(strDataValue," ",2)
		}
		
		if (strDataValue [ ":") & ($l(strDataValue,":") = 3)
		{
			s strDataValue = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
		}else
		{
			s strDataValue = " "
		}
		
	}
	//对dt15，t15的数据进行标准转换
	elseif (strFormat [ "DT15") || (strFormat [ "T15") 
	{
		if (strDataValue [ " ")
		{
			s strDataValue = $p(strDataValue," ",1)_" "_$ZTime($ZTimeH($p(strDataValue," ",2)))
		}
		//转换为包含T的时间格式(schemas样式需要)
		if (strMark = "1") 
		{
			
		if (strDataValue [ " ")
		{
			s strdate = $ZDATEH($P(strDataValue," ",1),8)
			s DataV =$ZDATE(strdate,8)
			s strtime = $p(strDataValue," ",2)
			s timev = "000000"
			if (strtime [ ":") & ($l(strtime,":") = 3)
			{
			s timev = $p(strtime,":",1)_$p(strtime,":",2)_$p(strtime,":",3)
			}
			s strDataValue = DataV_ "T" _timev
			
		}
		else
		{
			if (strDataValue [ ":") & ($l(strDataValue,":") = 3)
			{
				s timev = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
				s strDataValue = 0_ "T" _timev
			}
			else
			{
				s strdate = $ZDateH($P(strDataValue," ",1),8)
				s DataV =$ZDATE(strdate,8)
				s strDataValue = DataV_ "T" _"000000"
			}
		}
		}
		//转换为不包含T的时间格式
		elseif(strMark = "2")
		{
			if (strDataValue [ " ")
			{
				s strdate = $ZDATEH($P(strDataValue," ",1),8)
				s DataV =$ZDATE(strdate,8)
				s strtime = $p(strDataValue," ",2)
				s timev = "000000"
				if (strtime [ ":") & ($l(strtime,":") = 3)
				{
					s timev = $p(strtime,":",1)_$p(strtime,":",2)_$p(strtime,":",3)
				}
				s strDataValue = DataV_ "" _timev
			}
			else
			{
				if (strDataValue [ ":") & ($l(strDataValue,":") = 3)
				{
					s timev = $p(strDataValue,":",1)_$p(strDataValue,":",2)_$p(strDataValue,":",3)
					s strDataValue = 0_ "" _timev
				}
				else
				{
					s strdate = $ZDateH($P(strDataValue," ",1),8)
					s DataV =$ZDATE(strdate,8)
					s strDataValue = DataV_ "" _"000000"
				}
			}
		}
	}
	//对AN类型的数据转换
	elseif (strFormat [ "AN") 
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"AN")
		
	}
	//对A类型的数据转换
	elseif (strFormat [ "A")
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"A")
	}
	//对N类型的数据转换
	elseif (strFormat [ "N")
	{
		S strDataValue = ..GetDataByAN(strDataValue,strFormat,"N")
	}
	q strDataValue
}

/// Desc:?ݱ?ת?byAN
///  w ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetDataByAN("2134233443","AN4..8","AN")
ClassMethod GetDataByAN(strDataValue As %String, strFormat As %String, strMake As %String) As %String
{

	//?̶??
	s length = 0
	//?ɱ䳤???ֵ
	s chageS = 0
	//?ɱ䳤???ֵ
	s chageE = 0
	//??ֵ
	s strXE = 0
	//С???ֵ
	s strPE = 0
	//N??̶?????
	s strFixL = ""
	//???".."??
	if (strFormat [ "..") 
	{
		s strvs = $p(strFormat,strMake,2)
		s chageS = $p(strvs,"..",1)
		s strvs = $p(strvs,"..",2)
		//???"X",".."??
		if (strvs [ "X")
		{ 
			s strXE = $p(strvs,"X",2)
			s chageE = $P(strvs,"X",1)
		} 
		//???",",".."??
		elseif (strvs [ ",")
		{
			s strPE = $p(strvs,",",2)
			s chageE = $P(strvs,",",1)
		}
		//ֻ??".."??
		else
		{
			s chageE = strvs
		}
	}
	//???","??".."??
	elseif (strFormat [ ",") 
	{
		s strvs = $p(strFormat,",",1)
		s length = $p(strvs,strMake,2)
		s strPE = $p(strFormat,",",2)
		
	}
	//???"X"??".."??
	elseif (strFormat [ "X") 
	{ 
		s strvs = $p(strFormat,"X",1)
		s length = $p(strvs,strMake,2)
		s strXE = $p(strFormat,"X",2)
	}
	//?̶???
	else
	{
		s length = $p(strFormat,strMake,2)
	}

	s strpvalue = "."
	if (strPE'=0)
	{
		for int=1:1:strPE
		{
			S strpvalue = strpvalue_"0"
		}
	}
	
	//???".."??
	if (length '= 0) 
	{
		if (strXE '=0)
		{
			if $l(strDataValue) > (strXE * length)
			{
				s strDataValue = $e(strDataValue,0,strXE * length)
			}
		}
		elseif (strPE '=0)
		{
			if (strDataValue '[ ".")
			{
				s strDataValue = strDataValue_strpvalue
			}
			else
			{
				s nowPe = $L($p(strDataValue,".",2))
				if (strPE>nowPe)
				{
					S strpvalue = ""
					for int=1:1:(strPE-nowPe)
					{
						S strpvalue = strpvalue_"0"
					}
					s strDataValue = strDataValue_strpvalue
				}
				else
				{
					s strPbef = $p(strDataValue,".",1)
					if ($L(strPbef)=0)
					{
					s strPbef = 0
					}
					s strPaft = $p(strDataValue,".",2)
					s strPaft =  $e(strPaft,0,strPE)
					s strDataValue = strPbef_"."_strPaft
				}
			}
			if ($l(strDataValue) >= length)
			{
				s strDataValue = $e(strDataValue,0,length)
			}
			
		}
		else{
			if ($l(strDataValue) >= length)
			{
				s strDataValue = $e(strDataValue,0,length)
			}
			else
			{
				/*
				if (strMake = "N")
				{
					s strFixL = ""
				
					for int=1:1:(length-$l(strDataValue))
					{
						S strFixL = strFixL_"0"
					}
					s strDataValue = strFixL_strDataValue
				}
				*/
			}
		}
	}
	//???".."??
	else  
	{
		if (strXE '=0)
		{
			if ($l(strDataValue) > (chageE*strXE))
			{
				s strDataValue = $e(strDataValue,0,chageE*strXE)
			}
		}
		elseif (strPE '=0)
		{
			if (strDataValue '[ ".")
			{
				s strDataValue = strDataValue_strpvalue
			}
			else
			{
				s nowPe = $L($p(strDataValue,".",2))
				if (strPE>nowPe)
				{
					S strpvalue = ""
					for int=1:1:(strPE-nowPe)
					{
						S strpvalue = strpvalue_"0"
					}
					s strDataValue = strDataValue_strpvalue
				}
				else
				{
					s strPbef = $p(strDataValue,".",1)
					if ($L(strPbef)=0)
					{
					s strPbef = 0
					}
					s strPaft = $p(strDataValue,".",2)
					s strPaft =  $e(strPaft,0,strPE)
					s strDataValue = strPbef_"."_strPaft
				}
			}
			if ($l(strDataValue) >= chageE)
			{
				s strDataValue = $e(strDataValue,0,chageE)
			}
			
		}
		else{
			if ($l(strDataValue) >= (chageE))
			{
				s strDataValue = $e(strDataValue,0,chageE)
			}
		}
	}
	q strDataValue
}

/// Desc:       术语集取值日志
/// Creator:    huhao
/// CreateDate: 2022/12/26
/// Table:		CF.EMR.DOC.GlossaryGetValueMLog
/// Input:      IP:操作ip
/// 				usercode：用户编码
/// 				product：产品组  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetValueLog(IP As %String, usrCode As %String, Product As %String) As %String
{
	s strRes=""
	s obj=##class(CF.EMR.DOC.GlossaryGetValueMLog).%New()
	S obj.IP=IP
	S obj.LogType="GET"
	S obj.OptionDate=$P($h,",",1)
	S obj.OptionTime=$P($h,",",2)
	S obj.Product=Product
	S obj.userCode=usrCode
	d obj.%Save()
	q "1"
}

/// Desc:       取打散数据
/// Creator:    huhao
/// CreateDate: 2022-12-30
/// Input:      AEpisodeID 就诊号
///             AItem 单元路径 TYPE:ICompositeSample#TID:81#SCODE:S001|CCODE:VK1|CSCODE:L010#VTYPE:V
///             AInstanceID 实例数据ID
/// Return:     result 实例数据单元值
/// Debug:      w ##Class(EMR.DOC.BL.GlossaryAchieveValue).GetScatterData(1175,"#TYPE:IMACRODESC#TID:96#SCODE:S008|CSCODE:MA0001|Name:menarche#VTYPE:T","")           
ClassMethod GetScatterData(AEpisodeID As %String, AItem As %String, AInstanceID As %String) As %String
{
	s $zt="ERROR"
	s result=""
	q:AEpisodeID="" result
	s ItemList=##class(EMR.DOC.BL.BindDataSelect).GetListFromString(AItem,"#")
	q:($ll(ItemList)'=4) result
	s elementType=$zcvt($p($lg(ItemList,1),":",2),"U")
	s templateId=$p($lg(ItemList,2),":",2)
	s itemCode=$lg(ItemList,3)
	s valueType=$p($lg(ItemList,4),":",2)
	if (elementType="ISECTIONDESC")
	{
		s rowId=..GetSectionID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:rowId="" result
		s result=..GetSectionData(AEpisodeID,rowId)
	}
	elseif (elementType="ICOMPOSITESAMPLE")
	{
		s rowId=..GetCompositeSimpleID(AEpisodeID,templateId,itemCode,AInstanceID)
		q:rowId="" result
		s result=..GetCompositeSimpleData(rowId,valueType,AEpisodeID)
	}
	q result
ERROR
	q "ERROR"
}

/// Desc:       取简单元素打散数据id
/// Creator:    huhao
/// CreateDate: 2023/01/03
/// Table:		EMR.DAO.ICompositeSimple
/// Input:      ACode:"TYPE:ICompositeSample#TID:81#SCODE:S001|CCODE:VK1|CSCODE:L010#VTYPE:V"  	 
/// 				AEpisodeID:就诊号
/// 				ATemplateID：模板id
/// 				AInstanceID：实例id
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetCompositeSimpleID(AEpisodeID As %String, ATemplateID As %String, ACode As %String, AInstanceID As %String) As %String
{
	s result=""
	q:((AEpisodeID = "")||(ACode = "")||(ATemplateID = "")) result
	
	s SCode=$zcvt($p($p(ACode,"|",1),":",2),"U")
	s CSCode=$zcvt($p($p(ACode,"|",2),":",2),"U")
	
	if (AInstanceID="")
	{
		s instanceId=""
		for
		{
			s truThIndexLocal=##Class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
			s instanceId=$o(@truThIndexLocal@("IdxForLink",AEpisodeID,ATemplateID," "_SCode," "_CSCode,instanceId))
			q:instanceId=""
			s objInstance=##class(EMR.DAO.DocumentData).doOpenByID(instanceId)
			continue:((objInstance.Status="UnSave")||(objInstance.Status="Delete"))
			s result=$o(@truThIndexLocal@("IdxForLink",AEpisodeID,ATemplateID," "_SCode," "_CSCode,instanceId,""))

		}
	}
	else
	{
		s truThIndexLocation=##class(EMR.DAO.IStructSimple).GetTureIndexLocation(AEpisodeID)
		s rowId =$o(@truThIndexLocation@("IdxForLink",AEpisodeID,templateId," "_$zcvt(SCode,"U")," "_$zcvt(CSCode,"U"),AInstanceID,rowId))
		s result=rowId
	}
	q result
}

/// Desc:       取牙位打散数据
/// Creator:    huhao
/// CreateDate: 2023/04/23
/// Table:		
/// Input:      AEpisodeID：就诊号  
/// 								itemCodes：表+取值类型
/// valueType：取值类型
/// 				AInstanceID：实例id	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetInstanceDataProperty(AEpisodeID As %String, itemCodes As %String, valueType As %String, AInstanceID As %String) As %String
{
	s result=""
	if ($p(itemCodes,"#",1)="Tooth")
	{
		s toothInCode=$zcvt($p($p(itemCodes,"#",2),"|",2),"U")
		s toothDataStream=..getToothScatterData(AEpisodeID,toothInCode,valueType,AInstanceID)
		while (toothDataStream.AtEnd=0)
		{
			s result=result_$ZSTRIP(toothDataStream.Read(3200),"*C",,$c(1)_$c(2))
		}
		q result
	}
	//取实例信息
	s DAOClassName = $p(itemCodes,"#",1)
	s getTruthClassNamecode="s strClassName=##Class("_DAOClassName_").GetTureClassName("_AEpisodeID_")"
	x getTruthClassNamecode
	s strPropertys = $p(itemCodes,"#",2)
	s strPropertyO = $p(strPropertys,"|",1)
	s strPropertyT = $p(strPropertys,"|",2)
	s strValueO = ""
	s strValueT = ""
	s cmdCreateCls=""
	s cmdCreateCls="objData=##class("_strClassName_").%OpenId("""_AInstanceID_""")"
	s @cmdCreateCls
	if (strPropertyO'="")
	{
		s ^TempGetDataProperty(strPropertyO) = ""
		s cmdSetValue ="^TempGetDataProperty("""_strPropertyO_""")=objData."_strPropertyO_""
		s @cmdSetValue
		s strValueO =^TempGetDataProperty(strPropertyO)
		k ^TempGetDataProperty(strPropertyO)
	}
	if (strPropertyT'="")
	{
		s ^TempGetDataProperty(strPropertyT) = ""
		s cmdSetValue ="^TempGetDataProperty("""_strPropertyT_""")=objData."_strPropertyT_""
		s @cmdSetValue
		s strValueT =^TempGetDataProperty(strPropertyT)
		k ^TempGetDataProperty(strPropertyT)
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
		s reslut = strValueO_" "_strValueT
	}
	else
	{
		s reslut = strValueO
	}
	q reslut
}

ClassMethod getToothScatterData(AEpisodeID As %String, AToothInCode As %String, AValueType As %String, AInstanceID As %String) As %GlobalCharacterStream
{
	s ToothRes = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "")||(AToothInCode = "") ToothRes
	
	s:(AValueType = "") AValueType = "V"
	
	if (AToothInCode = "ALL")
	{
		s count = 0
		s ToothInCode = ""
		s codeRes=##class(%ResultSet).%New("EMR.DOC.BL.GlossaryAchieveValue:SelectToothCode")
		d codeRes.%Execute()
		while(codeRes.%Next())
		{
			s TInCode=$p(codeRes.Data("propertys"),"|",2)
			q:TInCode=""
			s ToothData = ..getToothItemData(AEpisodeID,TInCode,AValueType,AInstanceID)
			continue:(ToothData.Size = 0)
			if (count > 0)
			{
				d ToothRes.Write("#")
				d ToothRes.CopyFrom(ToothData)
			}
			else
			{
				d ToothRes.CopyFrom(ToothData)
			}
			s count = count + 1
		}
	}
	else
	{
		s ToothData = ..getToothItemData(AEpisodeID,AToothInCode,AValueType,AInstanceID)
		d ToothRes.CopyFrom(ToothData)
	}
	q ToothRes
}

ClassMethod getToothItemData(AEpisodeID As %String, AToothInCode As %String, AValueType As %String, AInstanceID As %String) As %GlobalCharacterStream
{
	s truThIndexLocal=##Class(EMR.DAO.IStructToothPosition).GetTureIndexLocation(AEpisodeID)
	s truThClassName=##Class(EMR.DAO.IStructToothPosition).GetTureClassName(AEpisodeID)
	s ToothStream = ##Class(%GlobalCharacterStream).%New()
	q:(AEpisodeID = "")||(AToothInCode = "") ToothStream
	
	s count = 0
	s SectionCode = ""
	for
	{
		s SectionCode = $O(@truThIndexLocal@("IdxForUpdate",AInstanceID,SectionCode))
		q:(SectionCode = "")
		s ToothImageCode=""
		for
		{
			s ToothImageCode = $o(@truThIndexLocal@("IdxForUpdate",AInstanceID,SectionCode,ToothImageCode))
			q:(ToothImageCode="")
			s ToothItemRowID = $o(@truThIndexLocal@("IdxForUpdate",AInstanceID,SectionCode,ToothImageCode," "_AToothInCode,""))
			q:(ToothItemRowID="")
			s getobjcode="s ToothItemObj = ##class("_truThClassName_").%OpenId("_ToothItemRowID_")"
			x getobjcode			
			;s ToothItemObj = ##class(EMR.DB1.IStructToothPosition).%OpenId(ToothItemRowID)
			continue:((AInstanceID '= "")&&(ToothItemObj.DocumentID.%Id() '= AInstanceID))
			
			if (count > 0)
			{
				d ToothStream.Write("&")
			}
			if (AValueType = "V")
			{
				d ToothStream.Write(ToothItemObj.ToothName_":"_ToothItemObj.Text)
				s count = count + 1
			}
			
		}
		
	}
	q ToothStream
}

Query SelectToothCode() As %SQLQuery
{
	SELECT DISTINCT propertys FROM CF_EMR_DOC.GlossaryClassProperty WHERE ParentID=6
}

}
