Class DHCEPRFS.Srv.SrvQRCode Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvQRCode";

ClassMethod GetQRCodeInfo() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLQRCodeInfo:GetQRCodeInfo")
	d obj.SetArgs()
	q obj
}

ClassMethod GetContent(AEpisodeID As %String, AMRItemID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).GetContent(AEpisodeID, AMRItemID)
}

ClassMethod AddRow(AName As %String, ADescription As %String, AClassName As %String, AClassProperty As %String, AClassPropertyType As %String, ACustemNoteInfo As %String = "") As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).AddRow(AName, ADescription, AClassName, AClassProperty,AClassPropertyType,ACustemNoteInfo)
}

ClassMethod UpdateRow(AID As %String, AName As %String, ADescription As %String, AClassName As %String, AClassProperty As %String, AClassPropertyType As %String, ACustemNoteInfo As %String = "") As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).UpdateRow(AID, AName, ADescription, AClassName, AClassProperty,AClassPropertyType,ACustemNoteInfo)
}

ClassMethod DeleteRow(AID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).DeleteRow(AID)
}

ClassMethod EnableRow(AID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).EnableRow(AID)
}

ClassMethod DisableRow(AID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).DisableRow(AID)
}

ClassMethod MoveDownRow(AID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).MoveDownRow(AID)
}

ClassMethod MoveUpRow(AID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRFS.BL.BLQRCodeInfo).MoveUpRow(AID)
}

}
