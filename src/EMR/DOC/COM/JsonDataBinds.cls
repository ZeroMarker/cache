/// 名称:	EMR.DOC.COM.JsonDataBinds
/// 描述:	json数据绑定
/// 编写者：yejian
/// 编写日期: 2021-8-10
/// 产品组：电子病历产品组
Class EMR.DOC.COM.JsonDataBinds Extends %RegisteredObject
{

/// Desc:		文档设置数据绑定
/// Creator:	yejian 
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
ClassMethod SetDataBind(jsonData As %DynamicAbstractObject, argParams As %DynamicAbstractObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s result = ""
	
	//解析传入的绑定数据
	s listParam = ##Class(%ArrayOfDataTypes).%New()
	//解析参数，存入数组中
	s bindIterator =argParams.%GetIterator()
	while bindIterator.%GetNext(.key , .value) {
		s strKey =$zcvt(key,"U")
	    d listParam.SetAt(value,strKey)
	} 
	
	s itemIterator =jsonData.%GetIterator()
    while itemIterator.%GetNext(.index , .jItem)
    {
		if (index="value")
		{
		   	d ##class(EMR.DOC.TOOL.JsonDataBinds).GetJsonData(listParam,.jItem)
		}
	}
	d jsonData.%ToJSON(argOutData)
	q result
}

/// Desc:		递归解析JSON并获取结构化元素
/// Creator:	yejian 
/// CreateDate:	2021-8-11
/// Input:      jsonData 文档json数据
///             argOutData 转换后的流数据
/// Output:    	成功1、失败-1
ClassMethod GetJsonData(listParams As %ArrayOfDataTypes, ByRef jsonData As %DynamicAbstractObject) As %String
{
	s result = ""
	//解析传入的绑定数据
	s itemIterator =jsonData.%GetIterator()
    while itemIterator.%GetNext(.index , .jItem)
    {
	    //结构化元素绑定处理
	    if ((index="type")&&((jItem="string")||(jItem="number")||(jItem="dateTime")||(jItem="select")||(jItem="dictionary")||(jItem="radioGroup")||(jItem="checkboxGroup")))
		{
			s strCode = jsonData.attrs.code
		   	s dataBinding = jsonData.attrs.dataBinding
		   	s count = $l(dataBinding,"#")
		   	if (dataBinding'="")&&(count>=5)
		   	{
			   	d ##class(EMR.DOC.TOOL.JsonDataBinds).SetItemBindData(jItem,strCode,dataBinding,listParams,.jsonData)
		   	}
		}
		s strType = jsonData.%GetTypeOf(index)
		if (strType="object")||(strType="array")
		{
			d ##class(EMR.DOC.TOOL.JsonDataBinds).GetJsonData(listParams,.jItem)
		}
	}
	q result
}

/// Desc:		设置字符元素绑定值
/// Creator:	yejian 
/// CreateDate:	2021-8-11
/// Input:      aType 元素类型(string,number,dateTime,select,dictionary,radioGroup,checkboxGroup)
/// 			ACode 元素编码
/// 			dataBinding 数据绑定规则
///             jsonData 文档json对象
/// Output:    	成功1、失败-1
ClassMethod SetItemBindData(aType As %String, aCode As %String, dataBinding As %String, listParams As %ArrayOfDataTypes, ByRef jsonData As %DynamicAbstractObject) As %String
{
	s result = "1"
   	if (dataBinding'="")
   	{
	   	s jsonBind = ##class(%DynamicObject).%New()
	   	s strRes = ##class(EMR.DOC.BL.BindDataSelect).GetHISBindDataValue(aCode,dataBinding,listParams,.jsonBind)
	   	s strType = jsonBind.%GetTypeOf("Values")
	   	if (strRes="1")&&((strType="object")||(strType="array"))
	   	{
		   	s arrJson = jsonBind.Values
		   	s dataArr = ##class(%DynamicArray).%New()
		   	s itemIterator =arrJson.%GetIterator()
		    while itemIterator.%GetNext(.index , .jItem)
		    {
			    s strType = arrJson.%GetTypeOf(index)
			    if ((strType="object")||(strType="array"))
	   			{
		   			s itemJson = ##class(%DynamicObject).%New()
		   			s strValue = jItem.BindDesc
		   			s strValue = $zcvt(jItem.BindDesc,"O","UTF8")
		   			//下拉、单选、多选
		   			if (aType = "select")||("radioGroup"=aType)||("checkboxGroup"=aType)
		   			{
					   	s itemJson.value = jItem.BindCode
					   	s itemJson.text = strValue
					   	d dataArr.%Push(itemJson)
		   			}
		   			elseif (aType = "dictionary") //字典
		   			{
			   			s itemJson.id = jItem.BindRowID
					   	s itemJson.value = jItem.BindCode
					   	s itemJson.text = strValue
					   	d dataArr.%Push(itemJson)
		   			}
		   			else //字符、日期、数值
		   			{
					   	s itemJson.text = strValue
					   	d dataArr.%Push(itemJson)
		   			}
	   			}
		    }
		   	s jsonData.children =dataArr
	   	}
  	}	
	q result
}

}
