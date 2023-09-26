/// Created by SongDeBo 2006/6/13
/// description: The factory to create CRMGateway
Class web.DHCPE.CRM.Factory Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

Parameter objGateway;

/// test: s gatewayCRM=##class(web.DHCPE.CRM.Factory).GetGateway()
ClassMethod GetGateway() As web.DHCPE.CRM.IGateway
{
	
	//q:$g(..objGateway)'="" ..#objGateway
	s className=$g(^DHCPESetting("DHCPE","ClassName of CRMGateWay"))
	q:(className="") "ERROR: the ^DHCPESetting'DHCPE','ClassName of CRMGateWay') is null"
	s retGateway=$zobjclassmethod(className,"%New")
	q retGateway
	
	//todo:  return ..#objGateway instead retGateway.
}

}
