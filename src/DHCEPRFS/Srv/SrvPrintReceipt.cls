Class DHCEPRFS.Srv.SrvPrintReceipt Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvPrintReceipt";

ClassMethod SetDefault(AID As %String, AType As %String = "CHARGE") As %String [ WebMethod ]
{
    s result = ##Class(DHCEPRFS.BL.BLPrintReceipt).SetDefault(AID,AType)
    q result
}

ClassMethod Update(AID As %String, AMRUserID As %String, AText As %String) As %String [ WebMethod ]
{
    s result = ##Class(DHCEPRFS.BL.BLPrintReceipt).Update(AID,AMRUserID,AText)
    q result
}

ClassMethod UpdateIncludeImage(Apara As DHCEPRFS.Entity.EPrintReceipt) As %String [ WebMethod ]
{
    s result = ##Class(DHCEPRFS.BL.BLPrintReceipt).UpdateIncludeImage(Apara)
    q result
}

ClassMethod GetBackGroundImage(APrintReceiptID As %String) As DHCEPRFS.Entity.EPrintReceipt [ WebMethod ]
{
	s entity = ##class(DHCEPRFS.BL.BLPrintReceipt).GetBackGroundImage(APrintReceiptID)
	q entity
}

ClassMethod Add(AMRUserID As %String, AText As %String, AType As %String = "CHARGE") As %String [ WebMethod ]
{
    s result = ##Class(DHCEPRFS.BL.BLPrintReceipt).Add(AMRUserID,AText,AType)
    q result
}

ClassMethod GetPrintReceiptList() As DHCEPRFS.DataSet.EPrintReceiptDS [ WebMethod ]
{
	s dataset = ##class(DHCEPRFS.DataSet.EPrintReceiptDS).%New()
	d dataset.SetArgs()
	q dataset
}

}
