/// 名称：		EMRservice.BOEMRNavigationSchemeItemSeqSeq
/// 描述：		方案明细科室排序BO层
/// 编写者：	yejian
/// 编写时间：	2019-11-4
Class EMRservice.BOEMRNavigationSchemeItemSeq Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRNavSchemeItemSeqInfo";

/// w ##Class(EMRservice.BOEMRNavigationSchemeItemSeq).SelectCtLoc()
ClassMethod SelectCtLoc() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRNavigationSchemeItemSeq:SelectCtLoc")
	d result.SetArgs()
	q result
}

/// w ##Class(EMRservice.BOEMRNavigationSchemeItemSeq).SelectAllDetails("12||1")
ClassMethod SelectAllItemByLoc(CtLoc As %String, aSchemeCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRNavigationSchemeItemSeq:SelectAllItemByLoc")
	d result.SetArgs(CtLoc,aSchemeCode)
	q result
}

/// 按科室新建科室项目
ClassMethod CreateSchemeItemsByLoc(CTLocGroupID As %String, CTLocGroupName As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).CreateSchemeItemsByLoc(CTLocGroupID,CTLocGroupName)
}

/// 增加一个项目
ClassMethod CreateSchemeItemSeq(itemrid As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).CreateSchemeItemSeq(itemrid)
}

/// 根据ItemID删除项目
ClassMethod DeleteSchemeItemSeqByID(aItemID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).DeleteSchemeItemSeqByID(aItemID)
}

/// 根据科室删除项目
ClassMethod DeleteSchemeItemSeqByLoc(aCTLocGroupID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).DeleteSchemeItemSeqByLoc(aCTLocGroupID)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).GetMaxCode()
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定方案项下的所有科室ID
/// Input: aSchemeCode,
/// Return: locid|name^locid|name^locid|name
ClassMethod GetItemLoc(CTLocGroupID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).GetItemLoc(CTLocGroupID)
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的科室
/// Input: docID--docID, sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(CTLocGroupID As %String, sltLocs As %String, unSltLocs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItemSeq).ModifyLoc(CTLocGroupID,sltLocs,unSltLocs)
}

}
