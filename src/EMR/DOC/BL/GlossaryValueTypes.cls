/// 名称:EMR.DOC.BL.GlossaryValueTypes
/// 描述:通用文档管理模块 Document(Doc) 元素值选项类型业务类
/// 编写者：yejian
/// 编写日期: 2021-1-20
/// 产品组：电子病历产品组
Class EMR.DOC.BL.GlossaryValueTypes Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"params":{"Action":"GET_GLOSSARY_BINDVTYPES","args":"","product":"GlobalEMR"},
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetGlossaryBindVTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
    s strRes = ##Class(EMR.DOC.BL.GlossaryValueTypes).GetGlossaryBindVTypesJson(.argOutData)
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

/// Desc:       获取元素值类型集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argUserID  用户编码，
/// OutPut:     argOutData 返回数据
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.GlossaryValueTypes).GetGlossaryBindVTypesJson(argOutData)
ClassMethod GetGlossaryBindVTypesJson(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = "1"
	s jsonArr = ##class(%DynamicArray).%New()
	
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.GlossaryValueTypesD(rowID))
		q:(rowID = "")				
		s obj = ##Class(CF.EMR.DOC.GlossaryValueTypes).%OpenId(rowID)
        continue:(obj="")
        s jsonVTypes  = ##class(%DynamicObject).%New()
        s jsonVTypes.MiType =obj.MiType
        s jsonVTypes.TypeName =obj.TypeName
        s jsonVTypes.TypeValue = obj.TypeValue
       	s jsonVTypes.TemName = obj.TemName
	    s jsonVTypes.SetionName = obj.SetionName
	    s jsonVTypes.SampleName = obj.SampleName
	    s jsonVTypes.DocType = obj.DocType
	    s jsonVTypes.DocValue = obj.DocValue
		s jsonVTypes.VTypeName =obj.VTypeName
		if (obj.VTypeItem'="")
        {
	        s strItem = ##class(%DynamicAbstractObject).%FromJSON(obj.VTypeItem)
	        s jsonVTypes.VTypeItem = strItem
        }
        else
        {
        	s jsonVTypes.VTypeItem =""
        }
		d jsonArr.%Push(jsonVTypes)
	}
	d jsonArr.%ToJSON(argOutData)

	q strRes
}

}
