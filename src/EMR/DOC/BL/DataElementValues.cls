/// 名称:	EMR.DOC.BL.DataElementValues
/// 描述:	通用文档管理模块 Document(Doc) 术语集数据元值域业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.DataElementValues Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取元值域集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令参数 {"action":"GET_DATAELEMENT_DEVVALUES","params":{"entifier":"DH01.00.001"，"current":1,"pageSize":10},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataElementDEVValues(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s entifier = argInJson.params.entifier
	s current = argInJson.params.current
    s pageSize = argInJson.params.pageSize
    ;s code = argInJson.params.code
    ;s name = argInJson.params.title
    /// OutPut:     成功 1 失败 -200 数据元标识符不能为空 -301 数据元数据不存在
    s strRes = ##Class(EMR.DOC.BL.DataElementValues).GetDataElementDEVValuesJson(entifier,current,pageSize,.argOutData)
    //-200 值域标识符不能为空
	
	if (strRes=1)
	{
		q argOutMessage.success = ..#OK
	}
	elseif(strRes = -200)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元标识符不能为空",2)	
	}
	elseif(strRes = -301)
	{
		q ..SetOutMessage(argOutMessage,"ERROR","数据元数据不存在",2)	
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       获取元素值域集
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aDevID  数据元值域标识符，
/// OutPut:     成功 1 失败 -200 数据元标识符不能为空 -301 数据元数据不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.DataElementValues).GetGlossaryBindVTypesJson(argOutData)
ClassMethod GetDataElementDEVValuesJson(aEntifier As %String, aCurrent As %String, aPageSize As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s strRes = 1
	q:(aEntifier="") "-1^数据元标识符不能为空"
	s jsonArr = ##class(%DynamicArray).%New()
	s DataElementID  = $O(^CF.EMR.DOC.DataElementI("IdxEntifier"," "_aEntifier,""))
	q:DataElementID="" "-1^数据元数据不存在"
	s ObjDataElement = ##class(CF.EMR.DOC.DataElement).%OpenId(DataElementID)
	q:ObjDataElement="" "-1^数据元数据不存在"
	s aDevID = ObjDataElement.DEVID
	s aDevID = $zcvt(aDevID,"U")
	s count = 0
	s:aCurrent="" aCurrent=1
	s:aPageSize="" aPageSize=10
	s start = (aCurrent-1)*aPageSize+1
	s end = start+aPageSize-1
	s ObjResult = ##class(%DynamicObject).%New()
	s rowID = ""
	for {
		s rowID = $o(^CF.EMR.DOC.DataElementValuesI("IdxDECVMID"," "_aDevID,rowID))
		q:(rowID = "")	
		s objItem = ##Class(CF.EMR.DOC.DataElementValues).%OpenId(rowID)
	    continue:(objItem="")
	    ;continue:((aCode'="")&&('(objItem.DEVID[aCode)))
	    ;continue:((aName'="")&&('(objItem.Meaning[aName)))
	    s count=count+1
	    continue:((count<start)||(count>end))
		s jsonItem  = ##class(%DynamicObject).%New()
		s jsonItem.id =rowID
	    s jsonItem.decvMID =objItem.DECVMID
	    s jsonItem.devID =objItem.DEVID
	    s jsonItem.meaning =objItem.Meaning
	    s jsonItem.description =objItem.Description
		d jsonArr.%Push(jsonItem)
	}
	s ObjResult.total = count
	s ObjResult.current = aCurrent
	s ObjResult.pageSize = aPageSize
	s ObjResult.list = jsonArr
	d ObjResult.%ToJSON(argOutData)

	q strRes
}

}
