/// /// 名称:	EMR.DOC.BL.TouthPropertys
/// /// 描述:	牙位术语集扩展
/// /// 编写者：huhao
/// /// 编写日期: 2023/4/18
/// /// 产品组：电子病历产品组
Class EMR.DOC.BL.TouthPropertys Extends EMR.DOC.COM.ActionBase
{

/// Desc:       
/// Creator:    huhao
/// CreateDate: 
/// Table:
/// Input:      argArray  	 
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
/// Debug:
ClassMethod GetTouthJsonData(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s strRes = ##class(EMR.DOC.BL.TouthPropertys).GetJsonTree(.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif (strRes["-1^")
	{
		s strErr = $p(strRes,"^",2)
	    q ..SetOutMessage(argOutMessage,"ERROR",strErr,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","失败",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误00000", 2)
}

ClassMethod GetJsonTree(ByRef argOutData As %GlobalBinaryStream) As %String
{
	s resJsonArr=##class(%DynamicArray).%New()
	s strRes="",seq=""
	for
	{
		s seq=$o(^CF.EMR.DOC.GlossaryCla7961I("IdxParentIDSeq",0,seq))
		q:seq=""
		s rowId=$o(^CF.EMR.DOC.GlossaryCla7961I("IdxParentIDSeq",0,seq,""))
		s obj=##class(CF.EMR.DOC.GlossaryClassProperty).%OpenId(rowId)
		
		s jsonItem=##class(%DynamicObject).%New()
		s jsonItem.id=rowId
		s jsonItem.className=obj.ClassName
		s jsonItem.propertyName=obj.PropertyName
		s jsonItem.propertys=obj.Propertys
		s jsonItem.valueType=obj.ValueType
		s jsonItem.type=obj.Type
		s jsonItem.parentId=obj.ParentID
		s jsonItem.sequnece=obj.Sequence
		
		s childItem=##class(%DynamicArray).%New()
		s childRes=##class(EMR.DOC.BL.TouthPropertys).GetTouthData(rowId,childItem)
		if (childRes.%Size>0)
		{
			s jsonItem.children=childItem
		}
		s strRes=1
		d resJsonArr.%Push(jsonItem)
	}
	
	d resJsonArr.%ToJSON(argOutData)
	q strRes
}

ClassMethod GetTouthData(ParentId As %String, ByRef jsonArr As %DynamicArray) As %String
{
	s seq=""
	for
	{
		s seq=$o(^CF.EMR.DOC.GlossaryCla7961I("IdxParentIDSeq",ParentId,seq))
		q:seq=""
		s rowId=""
		for
		{
			s rowId=$o(^CF.EMR.DOC.GlossaryCla7961I("IdxParentIDSeq",ParentId,seq,rowId))
			q:rowId=""
			s obj=##class(CF.EMR.DOC.GlossaryClassProperty).%OpenId(rowId)
			
			s jsonItem=##class(%DynamicObject).%New()
			s jsonItem.id=rowId
			s jsonItem.className=obj.ClassName
			s jsonItem.propertyName=obj.PropertyName
			s jsonItem.propertys=obj.Propertys
			s jsonItem.valueType=obj.ValueType
			s jsonItem.type=obj.Type
			s jsonItem.parentID=obj.ParentID
			s jsonItem.sequnece=obj.Sequence
			
			s childItem=##class(%DynamicArray).%New()
			s childRes=##class(EMR.DOC.BL.TouthPropertys).GetTouthData(rowId,childItem)
			if (childRes.%Size>0)
			{
				s jsonItem.children=childItem
			}
			d jsonArr.%Push(jsonItem)
		}
	}
	q jsonArr
}

}
