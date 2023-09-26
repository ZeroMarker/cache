Class EMRservice.BOKBDataMap Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBDataMapInfo";

ClassMethod SelectAllKBMAP() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDataMap:SelectAllKBMAP")
	d result.SetArgs()
	q result
}

ClassMethod SelectKBCategory() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDataMap:SelectKBCategory")
	d result.SetArgs()
	q result
}

ClassMethod SelectKBBase() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDataMap:SelectKBBase")
	d result.SetArgs()
	q result
}

ClassMethod SelectKBTreeNode() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDataMap:SelectKBTreeNode")
	d result.SetArgs()
	q result
}

ClassMethod SelectKBNode() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLKBDataMap:SelectKBNode")
	d result.SetArgs()
	q result
}

/// 增加一个章节
ClassMethod CreateKBMap(aEKBDataMap As EMRservice.entity.EKBDataMap) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBDataMap).CreateKBMap(aEKBDataMap)
}

/// 删除一个标题
ClassMethod DeleteKBDataMapByID(aEKBDataMapID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBDataMap).DeleteKBDataMapByID(aEKBDataMapID)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLKBDataMap).GetMaxCode()
}

}
