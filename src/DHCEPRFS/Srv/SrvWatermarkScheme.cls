Class DHCEPRFS.Srv.SrvWatermarkScheme Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvWatermarkScheme";

/// Desc: 新增水印方案
ClassMethod AddWatermarkScheme(AUserID As %String, AWatermarkSchemeName As %String, AWatermarkSchemeDesc As %String, AWatermarkLocation As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLWatermarkScheme).AddWatermarkScheme(AUserID,AWatermarkSchemeName,AWatermarkSchemeDesc,AWatermarkLocation)
	q ret
}

/// Desc: 作废水印方案
ClassMethod DisableWatermarkScheme(AUserID As %String, AWatermarkLocation As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLWatermarkScheme).DisableWatermarkScheme(AUserID,AWatermarkLocation)
	q ret
}

/// Desc: 查询水印方案列表
ClassMethod QueryWatermarkList(AUserID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLWatermarkScheme:QueryWatermarkList")
	d ds.SetArgs(AUserID)
	q ds
}

/// Desc: 获取水印方案配置
ClassMethod GetWatermarkScheme(AUserID As %String, AWatermarkLocation As %String, AMRUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLWatermarkScheme).GetWatermarkScheme(AUserID,AWatermarkLocation,AMRUserID)
	s ret = $ZSTRIP(ret,"*C")
	q ret
}

/// Desc: 保存水印方案配置
ClassMethod SaveWatermarkScheme(AID As %String, AUserID As %String, AWatermarkText As %String, ACustom As %String, AFontColor As %String, ADuplicateTimes As %String, ALineHeight As %String, ARotation As %String, AFontSize As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLWatermarkScheme).SaveWatermarkScheme(AID,AUserID,AWatermarkText,ACustom,AFontColor,ADuplicateTimes,ALineHeight,ARotation,AFontSize)
	q ret
}

/// Desc: 获取水印文本内容
ClassMethod GetWatermarkText(AInput As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLWatermarkScheme).GetWatermarkText(AInput,AUserID)
	q ret
}

}
