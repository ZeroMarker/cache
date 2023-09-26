/// Creator:Candyxu
/// CreateDate:2013-04-26
/// Desc:打印方案
Class DHCEPRFS.Srv.SrvPrintScheme Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvPrintScheme";

/// Desc:修改方案名称和描述
ClassMethod SetSchemeName(ASchemeID As %String, ASchemeName As %String, ASchemeDesc As %String, AModifyUserID As %String, ASchemeType As %String = "") As %String [ WebMethod ]
{
	s result = "0"
	q:(ASchemeID = "")||(ASchemeID = $C(0)) result
	q:(ASchemeName = "")||(ASchemeName = $c(0)) result
	
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetSchemeName(ASchemeID, ASchemeName, ASchemeDesc, AModifyUserID,ASchemeType)
	q result
}

/// Desc:增加扫描分类方案
/// Creator:LiuShuang
/// CreateDate:2016-06-03
ClassMethod AddScanScheme(AFuncName As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(AFuncName = "")||(AFuncName = $C(0)) result
	
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).AddScanScheme(AFuncName)
	q result
}

/// Desc:增加高拍分类方案
/// Creator:LiuShuang
/// CreateDate:2017-05-18
ClassMethod AddPhotoScheme(AFuncName As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(AFuncName = "")||(AFuncName = $C(0)) result
	
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).AddPhotoScheme(AFuncName)
	q result
}

/// Desc:增加或修改方案
/// Creator:Candyxu
/// CreateDate:2013-05-04
ClassMethod SetScheme(ParaScheme As DHCEPRFS.Entity.EPrintScheme) As %String [ WebMethod ]
{
	s result = "0"
	q:(ParaScheme = "") result
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetScheme(ParaScheme)
	q result
}

/*
/// Desc:	删除方案
ClassMethod DeleScheme(ASchemeID As %String) As %String [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).DeleScheme(ASchemeID)
	q result
}*/
/// Desc:	作废方案
ClassMethod DeleteScheme(ASchemeID As %String) As %String [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).DeleteScheme(ASchemeID)
	q result
}

/// Desc:设置打印默认方案
/// Creator:Candyxu
/// CreateDate:2013-05-04
ClassMethod SetDefault(rowId As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(rowId = "") result
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetfaultScheme(rowId)
	q result
}

/// Desc:设置生成默认方案
ClassMethod SetDefaultCreateScheme(rowId As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(rowId = "") result
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetDefaultCreateScheme(rowId)
	q result
}

/// Desc:设置默认方案
ClassMethod SetDefaultScheme(rowId As %String, ASchemeType As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(rowId = "") result
	q:(ASchemeType = "") result
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetDefault(rowId,ASchemeType)
	q result
}

/// Desc:设置非默认方案
ClassMethod SetNonDefaultScheme(rowId As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(rowId = "") result
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetNonDefault(rowId)
	q result
}

/// Desc:获得方案列表
/// Creator:Candyxu 
/// CreateDate:2013-05-04
ClassMethod GetAllSchemeList(ASchemeType As %String = "") As DHCEPRFS.DataSet.PrintSchemeDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.PrintSchemeDS).%New()
	d result.SetArgs(ASchemeType)
	q result
}

/// Creator:Candy
/// CreateDate:2013-05-06
/// Desc:增加方案项目
ClassMethod SetSchemeItem(rowId As %String, Items As %String, CheckedItems As %String = "") [ WebMethod ]
{
	s:(CheckedItems = $c(0)) CheckedItems = ""
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetSchemeItems(rowId,Items,CheckedItems)
	q result
}

/// Creator:Candy
/// CreateDate:2013-05-06
/// Desc:获得方案项目
ClassMethod GetSchemeItem(rowId As %String) As DHCEPRFS.DataSet.SchemeItemDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.SchemeItemDS).%New()
	d result.SetArgs(rowId)
	q result
}

/// Creator:Candy
/// CreateDate:2013-05-06
/// Desc:获取默认方案
ClassMethod GetDefaultScheme() As %String [ WebMethod ]
{
	s result = ""
	s result = $o(^DHCEPRFS.META.PrintSchemeI("IdxIsDefault"," Y",""))
	q result
}

ClassMethod GetVerItemBySchemeID(ASchemeID As %String, AVersionID As %String) As DHCEPRFS.DataSet.SchemeVerItemDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.SchemeVerItemDS).%New()
	d ds.SetArgs(ASchemeID,AVersionID)
	q ds
}

ClassMethod GetVerItemBySchemeIDString(ASchemeID As %String, AVersionID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeIDString(ASchemeID,AVersionID)
	q ret
}

ClassMethod GetVerItemBySchemeIDCor(ASchemeID As %String, AVersionID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeIDString(ASchemeID,AVersionID,"Y")
	q ret
}

/// Desc:根据目录条目ID查询打印浏览项目
/// 
ClassMethod GetVerItemByMrItemID(AMrItemID As %String, AVerSionID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLPrintScheme:GetVerItemByItemID")
	d ds.SetArgs(AMrItemID,AVerSionID)
	q ds
}

/// Debug:	w ##Class(DHCEPRFS.Srv.SrvPrintScheme).GetDefaultSchemeID("CREATELIS")
ClassMethod GetDefaultSchemeID(ASchemeType As %String) As %String [ WebMethod ]
{
	s schemeID = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDBySchemeType(ASchemeType)
	q schemeID
}

/// Debug:	w ##Class(DHCEPRFS.Srv.SrvPrintScheme).GetDefaultBySchemeType("VIEW")
ClassMethod GetDefaultBySchemeType(ASchemeType As %String) As %String [ WebMethod ]
{
	s result = "0"
	q:(ASchemeType = "") result
	s schemeID = ##class(DHCEPRFS.BL.BLPrintScheme).GetSchemeIDByDefault(ASchemeType)
	q schemeID
}

/// Debug:	w ##Class(DHCEPRFS.Srv.SrvPrintScheme).GetDefaultSchemeID("CREATELIS")
ClassMethod GetLateToCreateItems(ASchemeType As %String) As %String [ WebMethod ]
{
	s MRItems = ##class(DHCEPRFS.BL.BLPrintScheme).GetLateToCreateItems(ASchemeType)
	q MRItems
}

/// Creator:liushuang
/// CreateDate:2018-05-14
/// Desc:增加方案辅助项目
ClassMethod SetSchemeSubItems(rowId As %String, SubItems As %String, CheckedSubItems As %String = "") [ WebMethod ]
{
	s:(CheckedSubItems = $c(0)) CheckedSubItems = ""
	s result = ##Class(DHCEPRFS.BL.BLPrintScheme).SetSchemeSubItems(rowId,SubItems,CheckedSubItems)
	q result
}

/// Desc:  获取待分类病历
ClassMethod GetSchemeSubItemByID(ASchemeID As %String) As %XML.DataSet [ WebMethod ]
{
	s:(ASchemeID = $c(0)) ASchemeID = ""
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLPrintScheme:GetSchemeSubItemByID")
	d ds.SetArgs(ASchemeID)
	q ds
}

/// Desc:  记录方案内容修改日志
ClassMethod SetSchemeLog(AActUserID As %String, ASchemeID As %String, ASchemeItem As %String, AIP As %String) [ WebMethod ]
{
	s result = ##class(DHCEPRFS.BL.BLPrintScheme).SetSchemeLog(AActUserID,ASchemeID,ASchemeItem,AIP)
	q result
}

/// Desc:保存科室方案
ClassMethod UpdateLocScheme(ASchemeID As %String, ALocID As %String, AExSchemeItems As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLPrintScheme).UpdateLocScheme(ASchemeID,ALocID,AExSchemeItems)
}

/// Desc:获取科室方案
ClassMethod GetLocScheme(ASchemeID As %String, ALocID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLPrintScheme).GetLocScheme(ASchemeID,ALocID)
}

}
