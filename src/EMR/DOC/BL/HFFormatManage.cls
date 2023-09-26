/// 名称:	EMR.DOC.BL.HFFormatManage
/// 描述:	通用文档管理模块  文档版式统一操作接口管理
/// 编写者:	duan
/// 编写日期: 	2021-03-22
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.HFFormatManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       文档版式管理模块统一添加接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"ADD_HFF_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Add(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	;s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	s childType = argInJson.params.childType
	if ((type="RT")||((type="CG")&&(childType="CG")))
	{
		//添加目录
		d ##Class(EMR.DOC.BL.HFFormat).AddCategory(argInJson,argInData,argOutMessage,argOutData)	
	}
	elseif ((type="CG")&&(childType="LF"))
	{
		/*添加版式*/
		d ##Class(EMR.DOC.BL.HFFormat).AddHFFormat(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="LF")
	{
		/*添加版本*/
		d ##Class(EMR.DOC.BL.HFFormatVersion).AddHFVersion(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000"_$zerror,2)
}

/// Desc:       文档版式管理模块统一更新接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"UPDATE_HFF_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Update(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG")||(type="RT"){
		d ##Class(EMR.DOC.BL.HFFormat).UpdateCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="LF")
	{
		/*更新版式*/
		d ##Class(EMR.DOC.BL.HFFormat).UpdateHFFormat(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

/// Desc:       文档版式管理模块统一删除接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"DELETE_HFF_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Delete(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG")
	{
		//删除目录
		d ##Class(EMR.DOC.BL.HFFormat).DeleteCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif (type="LF")
	{
		/*删除版式*/
		d ##Class(EMR.DOC.BL.HFFormat).DeleteHFFormat(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="IT")
	{
		/*删除版本*/
		d ##Class(EMR.DOC.BL.HFFormatVersion).DeleteHFVersion(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不正确,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Write(..#NONE)
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

}
