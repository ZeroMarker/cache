/// 名称:	EMR.DOC.BL.BDMManage
/// 描述:	业务数据模型管理统一逻辑类
/// 编写者:	duan
/// 编写日期: 	2021-04-28
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.BDMManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       业务数据模型统一添加接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"ADD_BDM_MANAGE","params":{"id":"173||CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
ClassMethod Add(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	;s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s childType = $ZCVT(argInJson.params.childType,"U")
	if ((type="RT")||((type="CG")&&(childType="CG")))
	{
		//添加医疗活动记录分类（目录）
		d ##Class(EMR.DOC.BL.BDMCategory).AddBDMCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="CG")&&(childType="DT"))
	{
		//添加医疗活动记录（添加文档）
		d ##Class(EMR.DOC.BL.BDMCategory).AddBDMTemplate(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="DT") ||((type="ST")&&(childType="ST")) )
	{
		//添加章节
		s res= ##Class(EMR.DOC.BL.BDMCategory).AddBDMSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="ET"))
	{	//添加简单元素
		d ##Class(EMR.DOC.BL.BDMSimpleElements).AddBDMSimElements(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="CT"))
	{	//添加复合元素
		d ##Class(EMR.DOC.BL.BDMCompositeElements).AddBDMComElements(argInJson,argInData,argOutMessage,argOutData)
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
	if (type="CG")||(type="RT")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="DT")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMTemplate(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="ST")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).UpBDMSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="ET")
	{
		d ##Class(EMR.DOC.BL.BDMSimpleElements).UpBDMSimElements(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="CT")
	{
		d ##Class(EMR.DOC.BL.BDMCompositeElements).UpBDMComElements(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	q "1"
Error
	d argOutData.Write(..#NONE)
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
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="DT")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMTemplate(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="ST")
	{
		d ##Class(EMR.DOC.BL.BDMCategory).DelBDMSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="ET")
	{
		d ##Class(EMR.DOC.BL.BDMSimpleElements).DelBDMSimElements(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="CT")
	{
		d ##Class(EMR.DOC.BL.BDMCompositeElements).DelBDMComElements(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在",2)
	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       术语集管理-业务数据模型-元素添加术语集关联
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"ADD_GLOSSARY_BDM","params":{"id":"173||CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
ClassMethod AddGlossary(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="ST")
	{
		//章节关联术语集
		d ##Class(EMR.DOC.BL.BDMCategory).AddSectionGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="ET")
	{
		//简单元素关联术语集
		d ##Class(EMR.DOC.BL.BDMSimpleElements).AddGlossary(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="DT") ||((type="ST")&&(childType="ST")) )
	{
		//添加章节
		s res= ##Class(EMR.DOC.BL.BDMCategory).AddBDMSection(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="ET"))
	{	//添加简单元素
		d ##Class(EMR.DOC.BL.BDMSimpleElements).AddBDMSimElements(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif((type="ST")&&(childType="CT"))
	{	//添加复合元素
		d ##Class(EMR.DOC.BL.BDMCompositeElements).AddBDMComElements(argInJson,argInData,argOutMessage,argOutData)
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

}
