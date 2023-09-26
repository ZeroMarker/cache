/// 名称:	EMR.DOC.BL.GlossaryManage
/// 描述:	术语集管理统一逻辑类
/// 编写者:	duan
/// 编写日期: 	2021-06-15
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.GlossaryManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       术语集管理统一添加接口
/// Creator:    duan
/// CreateDate: 2021-06-15
/// Input:      argArray  	命令参数 {"action":"ADD_GLOSSARY_MANAGE","params":{"id":"173||CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
ClassMethod Add(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s childType = $ZCVT(argInJson.params.childType,"U")
	if ((type="RT")||((type="CG")&&(childType="CG")))
	{
		//添加医疗活动记录分类（目录）
		d ##Class(EMR.DOC.BL.GlossaryCategory).AddGlossaryCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="CG")&&(childType="LF"))
	{
		//添加新项
		d ##Class(EMR.DOC.BL.Glossary).AddGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="LF")&&(childType="LF"))
	{
		//添加新项
		d ##Class(EMR.DOC.BL.Glossary).AddGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	q "1"
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档目录管理模块统一更新接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"UPDATE_BDM_MANAGE","params":{"id":"173||CG"...},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Update(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s childType = argInJson.params.childType
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG")
	{
		d ##Class(EMR.DOC.BL.GlossaryCategory).UpGlossaryCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="LF")
	{
		d ##Class(EMR.DOC.BL.Glossary).UpGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	q "1"
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档目录管理模块统一删除接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"DEL_TEMPLATE_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Delete(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	
	if (type="CG")
	{
		d ##Class(EMR.DOC.BL.GlossaryCategory).DelGlossaryCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="LF")
	{
		d ##Class(EMR.DOC.BL.Glossary).DelGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="KG")
	{
		d ##Class(EMR.DOC.BL.Glossary).DelGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	q "1"
Error
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

}
