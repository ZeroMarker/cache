/// 名称:	EMR.IP.BL.BLTemplateCollect
/// 描述:	住院病历 常用模板
/// 编写者：lifengbo
/// 编写日期: 2023-03-20
/// 产品组：电子病历产品组
Class EMR.IP.BL.BLCollectTemplate Extends EMR.IP.COM.ActionBase
{

/// Desc:       常用模板
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod AddCollectTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"

	s dtoItem = ##class(EMR.DOC.DTO.CollectTemplate).%New()
	

	s userID = argInJson.params.userID
	s dtoItem.UserID = userID
	
	s dtoItem.TemplateType = argInJson.params.templateType
	s dtoItem.NodeID = argInJson.params.id
	
	
    s strRes = ##Class(EMR.IP.BL.BLCollectTemplate).AddCollectTemplateJson(dtoItem,.argOutData)
	if (strRes >0)
	{ 
		q "1"
	}
	elseif(strRes="-200")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","检查必填项",2)
	}
	elseif(strRes="-102")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","操作数据失败",2)
	}
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// /////////////////////////////////
/// JSON 组合代码
/// ////////////////////////////////
/// Desc:       添加常用模板
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Input:      aDTOItem  患者类型对象
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 						-200 项目缺失
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLCollectTemplate).AddCollectTemplateJson()
ClassMethod AddCollectTemplateJson(aDTOItem As EMR.DOC.DTO.CollectTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s strRes = "-102"
	q:((aDTOItem = "")) "-200"
	
	s objId=""
	
	s obj = ##class(CF.EMR.DOC.CollectTemplate).%New()

	s obj.NodeID = aDTOItem.NodeID
	s obj.TemplateType = aDTOItem.TemplateType
	s obj.UserID = ##class(User.SSUser).%OpenId(aDTOItem.UserID)
	
	
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		d argOutData.Write("0")
		q strRes
	}
	s strRes = obj.%Id()
	d argOutData.Write("1")
	q strRes
}

/// Desc:       常用模板
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Input:      argArray  命令参数  {"action":"GET_PATDISEASE","params":{episodeID},"product":"IP"}-----------------------------8eb5b37251gef文档数据
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData    返回数据
ClassMethod RemoveCollectTemplate(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s episodeId="",diseaseCode="",userID=""
	s episodeId=argInJson.params.episodeID


	s dtoItem = ##class(EMR.DOC.DTO.CollectTemplate).%New()
	

	s userID = argInJson.params.userID
	s dtoItem.UserID = userID
	
	s dtoItem.TemplateType = argInJson.params.templateType
	s dtoItem.NodeID = argInJson.params.id
	
	
    s strRes = ##Class(EMR.IP.BL.BLCollectTemplate).RemoveCollectTemplateJson(dtoItem,.argOutData)
	if (strRes =1 )
	{ 
		q "1"
	}
	elseif(strRes["-1^")
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$ze,2)
	}
	else
	{  
	    q ..SetOutMessage(argOutMessage,"ERROR","未识别返回值",2)
	}
Error
	q ..SetOutMessage(argOutMessage,"ERROR","代码异常："_$zerror,2)
}

/// Desc:       删除常用模板
/// Creator:    lifengbo
/// CreateDate: 2023-03-21
/// Input:      aDTOItem  患者类型对象
/// OutPut:     成功 1 失败 -102 操作数据失败
/// 						-200 项目缺失
/// Debug:      s argOutData = ##Class(%GlobalBinaryStream).%New() 
///             w ##class(EMR.IP.BL.BLCollectTemplate).RemoveCollectTemplateJson()
ClassMethod RemoveCollectTemplateJson(aDTOItem As EMR.DOC.DTO.CollectTemplate, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	s strRes = "-1^"
	q:((aDTOItem = "")) "-1^入参缺失"
	
	s isExit = $d(^CF.EMR.DOC.CollectTemplateI("IdxMain",aDTOItem.UserID, " "_$zcvt(aDTOItem.TemplateType,"U"), " "_$zcvt(aDTOItem.NodeID,"U")))
	
	if (isExit'=10)
	{
		q "-1^未找到待删除的数据"
	}
	
	s deleteId=""
	s deleteId = $o(^CF.EMR.DOC.CollectTemplateI("IdxMain",aDTOItem.UserID, " "_$zcvt(aDTOItem.TemplateType,"U"), " "_$zcvt(aDTOItem.NodeID,"U"), deleteId))
	
	
	s sc = ##class(CF.EMR.DOC.CollectTemplate).%DeleteId(deleteId)
	
	if ('$$$ISOK(sc))
	{
		q strRes_"删除失败"
	}
	d argOutData.Write(1)
	q 1
}

/// /////////////////////////////////
/// 服务代码
/// ////////////////////////////////
/// 
/// Desc:       验证是否为常用模板
/// Creator:    lifengbo
/// CreateDate: 2023-03-22
/// Input:      argTemplateType: Template 科室模板:LocTemplate 个人模板:PerTemplate
/// OutPut:     1 常用模板 0 非常用模板
/// Debug:      w ##class(EMR.IP.BL.BLCollectTemplate).CheckCollectTemplate()
ClassMethod CheckCollectTemplate(argUserID As %String, argTemplateType As %String, argNodeID As %String) As %String
{

	s ret=0
	q:((argUserID="")||(argTemplateType="")||(argNodeID="")) ret
	s isExist=$d(^CF.EMR.DOC.CollectTemplateI("IdxMain",argUserID, " "_$zcvt(argTemplateType,"U"), " "_$zcvt(argNodeID,"U")))
	
	s ret=$case(isExist,"10":"1",:"0")
	q ret
}

}
