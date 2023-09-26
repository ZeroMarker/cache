/// 名称:	EMR.OP.BL.KBCategory
/// 描述:	门诊病历 Document(Doc) 文档片段目录业务类
/// 编写者：yejian
/// 编写日期: 2021-1-12
/// 产品组：电子病历产品组
Class EMR.OP.BL.KBCategory Extends EMR.OP.COM.ActionBase
{

/// Desc:       获取文档片段目录树
/// Creator:    yejian
/// CreateDate: 2020-12-7
/// Table:		CF_EMR_DOC.KBCategory 文本片段目录表,CF_EMR_DOC.KBNode 文本片段表
/// Input:      argInJson  命令参数 {"action":"GET_BINDKBNODES","params":{"kbbaseId":"6","ctlocId":"28","episodeID":"660","userID":"10209","titleCode":"","diseaseID":""},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod GetKBNodeBySectionID(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s sectionID = argInJson.params.kbbaseId
	s sectionID = $case(sectionID,"":"1401",:sectionID)
	s DataTypes = "KB"
    s strRes = ##Class(EMR.OP.BL.KBCategory).GetKBTreeJson(sectionID,.argOutData)
	if (strRes = "1")
	{ 
	    q argOutMessage.success = ..#OK
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","kbbaseId参数有误",2)
	}
	elseif(strRes="-201")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","根据kbbaseId未查到数据",2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未知错误0000",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       获取文档片段目录tree
/// Creator:    yejian
/// CreateDate: 2021-05-06
/// Input:      argUserCode 用户Code
/// Output:     成功：1 失败  -200 aSectionID参数未传 -201 根据kbbaseId未查到数据
/// debug:  q ##Class(EMR.OP.BL.KBCategory).GetKBTreeJson("YS01")
ClassMethod GetKBTreeJson(aSectionID As %String, ByRef argOutData As %GlobalBinaryStream) As %String
{
	q:(aSectionID="") "-200"
	s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(aSectionID)
    q:(objCat="") "-201"
	s jsonArr = ##class(%DynamicArray).%New()
	s strRes = "1"
    s jsonCat  = ##class(%DynamicObject).%New()
    s type = ..FormatType(objCat.KBCategoryTypes.Code)
    s jsonCat.key = aSectionID_"||"_type
    s jsonCat.title = objCat.Name
    s jsonCat.type = type
    s jsonCat.description = objCat.Description
	s jsonCategory = ##class(%DynamicArray).%New()
	d ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByPID(aSectionID,.jsonCategory)
	s:(jsonCategory.%Size()>0) jsonCat.children = jsonCategory
	d jsonArr.%Push(jsonCat)
	d jsonArr.%ToJSON(argOutData)
	q strRes
}

/// Desc:       递归获取业务模型目录数据
/// Creator:    yejian
/// CreateDate: 2021-03-22
/// Input:      aParentId 目录ID
///             jsonCategory 目录json对象
/// Output:     
/// Debug:	q ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByID(0,1,1,)
ClassMethod GetJsonCategroyByPID(aParentId As %String, ByRef jsonCategory As %DynamicArray)
{
	s res = "1"
	s rowCID = ""
	for {
		s rowCID = $o(^CF.EMR.DOC.KBCategoryI("IdxParentId"," "_aParentId,rowCID))
		q:(rowCID = "")				
		s objCat = ##Class(CF.EMR.DOC.KBCategory).%OpenId(rowCID)
	    continue:(objCat="")
	    s type = ..FormatType(objCat.KBCategoryTypes.Code)
	    s jsonCat  = ##class(%DynamicObject).%New()
	    s jsonCat.key = rowCID_"||"_type
	    s jsonCat.title = objCat.Name
	    s jsonCat.type = type
	    s jsonCat.description = objCat.Description
		s jsonCateNew = ##class(%DynamicArray).%New()
		
		if (($ZCVT(objCat.KBCategoryTypes.Code,"U")="KBTREE")&&(objCat.ResChildCount'=0))
		{
			// 通过KBTRee获取node节点
			s result = ##Class(EMR.OP.BL.KBNode).GetKBNodeJsonByPID(rowCID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew
		}
		else
		{
			s result = ##Class(EMR.OP.BL.KBCategory).GetJsonCategroyByPID(rowCID,.jsonCateNew)
			s:(jsonCateNew.%Size()>0) jsonCat.children = jsonCateNew	
		}
		d jsonCategory.%Push(jsonCat)	
	}
	q res
}

}
