/// 名称:	EMR.DOC.BL.TemplateDesign
/// 描述:	通用文档管理模块 Document(Doc) 通用文档设计逻辑类
/// 编写者:	yejian
/// 编写日期: 	2020-12-16
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.TemplateDesign Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取工具栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"Action":"GET_TEMTOOLBUTTONS","args":{"DocTypes":"DOC"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetTemToolButtons(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DocTypes = argInJson.params.args.DocTypes
    s strRes = ##Class(EMR.DOC.BL.TemplateDesign).GetTemToolButtonsJson(DocTypes,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取元素工具栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"Action":"GET_ELEMENTTOOLS","args":{"DocTypes":"DOC"}},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetElementTools(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s DocTypes = argInJson.params.args.DocTypes
    s strRes = ##Class(EMR.DOC.BL.TemplateDesign).GetElementToolsJson(DocTypes,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取元素属性栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"Action":"GET_ELEMENTPROPERTYS","args":"","product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetElementPropertys(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

    s strRes = ##Class(EMR.DOC.BL.TemplateDesign).GetElementPropertysJson(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR")
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取工具栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateDesign).GetTemToolButtonsJson("DOC",argOutData)
ClassMethod GetTemToolButtonsJson(argDocTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	
	s strSeq = ""
	for {
		s strSeq = $o(^CT.EMR.DOC.TemToolButtonsI("IdxDocTypesSeq"," "_$zcvt(argDocTypes,"U"),strSeq))
		q:(strSeq = "")				
		s rowID = ""
		for {
			s rowID = $o(^CT.EMR.DOC.TemToolButtonsI("IdxDocTypesSeq"," "_$zcvt(argDocTypes,"U"),strSeq,rowID))
			q:(rowID = "")				
			s obj = ##Class(CT.EMR.DOC.TemToolButtons).%OpenId(rowID)
	        continue:(obj="")
	        s jsonToolBtn  = ##class(%DynamicObject).%New()
	        s jsonToolBtn.Code =obj.Code
	        s jsonToolBtn.Name =obj.Name
	        s jsonToolBtn.ToolTip = obj.ToolTip
	        s jsonToolBtn.DocTypes = obj.DocTypes
	        s jsonToolBtn.Sequence = obj.Sequence
	        s jsonToolBtn.ImageName = obj.ImageName
			d jsonArr.%Push(jsonToolBtn)
		}
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

/// Desc:       获取元素工具栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateDesign).GetElementToolsJson("DOC",argOutData)
ClassMethod GetElementToolsJson(argDocTypes As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	
	s strSeq = ""
	for {
		s strSeq = $o(^CT.EMR.DOC.TemElementToolsI("IdxTypeTSeq"," "_$zcvt(argDocTypes,"U")," GROUP",strSeq))
		q:(strSeq = "")				
		s rowID = ""
		for {
			s rowID = $o(^CT.EMR.DOC.TemElementToolsI("IdxTypeTSeq"," "_$zcvt(argDocTypes,"U")," GROUP",strSeq,rowID))
			q:(rowID = "")				
			s obj = ##Class(CT.EMR.DOC.TemElementTools).%OpenId(rowID)
	        continue:(obj="")
	        s jsonGroup  = ##class(%DynamicObject).%New()
	        s jsonGroup.Code =obj.Code
	        s jsonGroup.Name =obj.Name
	        s jsonGroup.ToolTip = obj.ToolTip
	        s jsonGroup.Types = obj.Types
	        s jsonGroup.DocTypes = obj.DocTypes
	        s jsonGroup.ParentID = obj.ParentID
	        s jsonGroup.Sequence = obj.Sequence
	        s jsonSArr = ##class(%DynamicArray).%New()
	        s rowSSeq = ""
			for {
				s rowSSeq = $o(^CT.EMR.DOC.TemElementToolsI("IdxParentIDSeq",rowID,rowSSeq))
				q:(rowSSeq = "")
				 s rowSID = ""
				for {
					s rowSID = $o(^CT.EMR.DOC.TemElementToolsI("IdxParentIDSeq",rowID,rowSSeq,rowSID))
					q:(rowSID = "")				
					s obj = ##Class(CT.EMR.DOC.TemElementTools).%OpenId(rowSID)
			        continue:(obj="")
			        s jsonItem  = ##class(%DynamicObject).%New()
			        s jsonItem.Code =obj.Code
			        s jsonItem.Name =obj.Name
			        s jsonItem.ToolTip = obj.ToolTip
			        s jsonItem.Types = obj.Types
			        s jsonItem.DocTypes = obj.DocTypes
			        s jsonItem.ParentID = obj.ParentID
			        s jsonItem.Sequence = obj.Sequence
					d jsonSArr.%Push(jsonItem)
				}
			}
			s jsonGroup.Item = $case(jsonSArr.%Size(),0:"",:jsonSArr)	
			d jsonArr.%Push(jsonGroup)
		}
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

/// Desc:       获取元素属性栏数据
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.TemplateDesign).GetElementPropertysJson(argOutData)
ClassMethod GetElementPropertysJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s json = ##Class(%GlobalBinaryStream).%New()
	s jsonArr = ##class(%DynamicArray).%New()
	
	s strTypeID = ""
	for {
		s strTypeID = $o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCSeq",strTypeID))
		q:(strTypeID = "")
		s objElementType = ##Class(CT.EMR.DOC.TemElementTypes).%OpenId(strTypeID)
		continue:(objElementType="")
		s jsonType  = ##class(%DynamicObject).%New()
		s jsonType.Type =objElementType.Code
		s arrGroup = ##class(%DynamicArray).%New()
		s strSeq = ""
		for {
			s strSeq = $o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCSeq",strTypeID," GROUP",strSeq))
			q:(strSeq = "")				
			s rowID = ""
			for {
				s rowID = $o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCSeq",strTypeID," GROUP",strSeq,rowID))
				q:(rowID = "")				
				s obj = ##Class(CT.EMR.DOC.TemElementDatas).%OpenId(rowID)
		        continue:(obj="")
		        s jsonGroup  = ##class(%DynamicObject).%New()
		        s jsonGroup.Code =obj.Code
		        s jsonGroup.Name =obj.Name
		        s jsonGroup.Sequence = obj.Sequence
		        s jsonSArr = ##class(%DynamicArray).%New()
		        s rowSSeq = ""
				for {
					s rowSSeq = $o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCSeq",strTypeID," "_$zcvt(jsonGroup.Code,"U"),rowSSeq))
					q:(rowSSeq = "")
					 s rowSID = ""
					for {
						s rowSID = $o(^CT.EMR.DOC.TemElementDatasI("IdxTypePCSeq",strTypeID," "_$zcvt(jsonGroup.Code,"U"),rowSSeq,rowSID))
						q:(rowSID = "")				
						s obj = ##Class(CT.EMR.DOC.TemElementDatas).%OpenId(rowSID)
				        continue:(obj="")
				        s jsonItem  = ##class(%DynamicObject).%New()
				        s jsonItem.Code =obj.Code
				        s jsonItem.Name =obj.Name
				        s jsonItem.Value = obj.Value
				        s jsonItem.Sequence = obj.Sequence
				        if (obj.Choices'="")
				        {
					        s arrChoices = ##class(%DynamicAbstractObject).%FromJSON(obj.Choices)
					        s jsonItem.Choices = arrChoices
				        }
				        else
				        {
				        	s jsonItem.Choices =""
				        }
						d jsonSArr.%Push(jsonItem)
					}
				}
				s jsonGroup.Item = $case(jsonSArr.%Size(),0:"",:jsonSArr)	
				d arrGroup.%Push(jsonGroup)
			}
		}
		s jsonType.Group =arrGroup
		d jsonArr.%Push(jsonType)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

}
