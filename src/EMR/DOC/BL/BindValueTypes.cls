/// 名称:	EMR.DOC.BL.BindValueTypes
/// 描述:	通用文档管理模块 Document(Doc) 数据集选项类型类型业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.DOC.BL.BindValueTypes Extends EMR.DOC.COM.ActionBase
{

/// Desc:       获取数据集选项类型
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      argArray  命令选项类型 {"action":"GET_DATA_BINDVALUETYPES","params":{"productCode":"OEP"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetDataBindValueTypes(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s ProductCode = argInJson.params.productCode
    s strRes = ##Class(EMR.DOC.BL.BindValueTypes).GetDataBindValueTypesJson(ProductCode,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes = "-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","请传入项目标识",2)
	}
	elseif(strRes = "-301")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","项目标识记录为空，检查参数",2)
	}
	else
	{  
		d argOutData.Write(..#NONE)
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR")
}

/// Desc:       获取数据集选项类型JSON
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Input:      aProductCode	项目标识
/// OutPut:     成功 1 失败 -200 项目标识Code未传
///                         -301 项目标识对象不存在
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.DOC.BL.BindValueTypes).GetDataBindValueTypesJson("DOC",.argOutData)
ClassMethod GetDataBindValueTypesJson(aProductCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aProductCode="") "-200"
	s ProductID = $o(^CT.EMR.DOC.ProductsI("IdxCode"," "_$zcvt(aProductCode,"U"),""))
	q:(ProductID="") "-301"
    s jsonArr = ##class(%DynamicArray).%New()
 	s strBTCode = ""
	for {
		s strBTCode = $o(^CF.EMR.DOC.BindValueTypesI("IdxProductCode",ProductID,strBTCode))
		q:(strBTCode = "")			
		s strBRowID = ""
		for {
			s strBRowID = $o(^CF.EMR.DOC.BindValueTypesI("IdxProductCode",ProductID,strBTCode,strBRowID))
			q:(strBRowID = "")			
			s objBindVType = ##Class(CF.EMR.DOC.BindValueTypes).%OpenId(strBRowID)
	        continue:(objBindVType="")
	       	s jsonBindVType  = ##class(%DynamicObject).%New()
		    s jsonBindVType.id =strBRowID
		    s jsonBindVType.productCode =aProductCode
		    s jsonBindVType.code =objBindVType.Code
		    s jsonBindVType.name =objBindVType.Name
			d jsonArr.%Push(jsonBindVType)
		}
	}
	
	d jsonArr.%ToJSON(argOutData)

	q "1"
}

}
