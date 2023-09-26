/// desc 数据元管理统一逻辑处理
/// creator duan
/// createDate 2021-06-19
/// 产品组：	电子病历产品组
Class EMR.DOC.BL.DataElementManage Extends EMR.DOC.COM.ActionBase
{

/// Desc:       数据元管理模块统一更新接口
/// Creator:    duan
/// CreateDate: 2021-04-22
/// Input:      argArray  	命令参数 {"action":"UPDATE_DATAELEMENT_MANAGE","params":{"id":173,"type":"CG"},"product":"GlobalEMR"}
/// OutPut:     argOutMessage 返回消息json格式
///            	argOutData 	返回数据 成功：添加数据的rowID,失败：-1
ClassMethod Update(argInJson As %DynamicAbstractObject, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream)
{
	s $zt = "Error"
	s type = ..GetTypeByKey(argInJson.params.id)
	s argInJson.params.id = ..GetIDByKey(argInJson.params.id)
	if (type="CG"){
		/*更新数据元目录*/
		d ##Class(EMR.DOC.BL.DataElementCategory).UpDataElementCategory(argInJson,argInData,argOutMessage,argOutData)
	}
	elseif(type="IT")
	{
		/*更新数据元*/
		d ##Class(EMR.DOC.BL.DataElement).UpDataElement(argInJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		q ..SetOutMessage(argOutMessage,"ERROR","类型不存在,检查参数id",2)
	}
	q "1"
Error
	d argOutData.Clear()
	q ..SetOutMessage(argOutMessage,"ERROR","服务器错误0000",2)
}

}
