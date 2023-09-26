/// 名称:EMRservice.BOToothPosition
/// 名称: 牙位图BO层
/// 描述: 牙位图
/// 编写者：yejian
/// 编写日期: 2018-1-31
Class EMRservice.BOToothPosition Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ToothPositionInfo";

/// 查询所有牙位表示法
ClassMethod SelectToothRepresentation() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLToothPosition:SelectToothRepresentation")
	d result.SetArgs()
	q result
}

/// 获取当前使用的牙位表示法
ClassMethod GetCurToothRepresentation() As EMRservice.entity.EToothRepresentation [ WebMethod ]
{
 q ##Class(EMRservice.BL.BLToothPosition).GetCurToothRepresentation()
}

/// 设置当前使用的牙位表示法
ClassMethod UpdateToothRepresentation(aToothCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLToothPosition).UpdateToothRepresentation(aToothCode)
}

/// 查询所有牙位数据
ClassMethod SelectTPosition() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLToothPosition:SelectTPosition")
	d result.SetArgs()
	q result
}

/// 更新一个牙位信息
ClassMethod UpdateToothPos(aEToothPos As EMRservice.entity.EToothPosition) As %String [ WebMethod ]
{
 q ##Class(EMRservice.BL.BLToothPosition).UpdateToothPos(aEToothPos)
}

/// 更新所有牙位描述
ClassMethod UpdateAllToothPos(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLToothPosition).UpdateAllToothPos(argStr)
}

/// 查询所有牙面数据
ClassMethod SelectTSurfaceItem() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLToothPosition:SelectTSurfaceItem")
	d result.SetArgs()
	q result
}

/// 更新一个牙面信息
ClassMethod UpdateToothSItem(aEToothSItem As EMRservice.entity.EToothSurfaceItem) As %String [ WebMethod ]
{
 q ##Class(EMRservice.BL.BLToothPosition).UpdateToothSItem(aEToothSItem)
}

/// 更新所有牙面描述
ClassMethod UpdateAllToothSItem(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLToothPosition).UpdateAllToothSItem(argStr)
}

}
