Class DHCEPRFS.Srv.SrvSysOption Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvSysOption";

ClassMethod GetValueByName(AName As %String) As %String [ WebMethod ]
{
 s Result=""
 k SQLCODE
 &sql(SELECT OptionValue
 into :Result 
 FROM DHCEPRFS_Meta.SysOption
 WHERE OptionName = :AName)
 q:(SQLCODE=0) Result
 q $c(0)
}

ClassMethod GetValuesByType(AType As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLSysOption:GetValueByType")
	d obj.SetArgs(AType)
	q obj
}

ClassMethod UpdateValueByName(AName As %String, ANewValue As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLSysOption).UpdateValueByName(AName,ANewValue)
}

ClassMethod GetAllSysOption() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLSysOption:GetAllSysOption")
	q obj
}

}
