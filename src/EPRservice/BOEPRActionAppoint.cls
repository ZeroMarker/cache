Class EPRservice.BOEPRActionAppoint Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRService.BOEPRActionAppoint";

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EpisodeID:%String,AppointDate:%Date,AppointTime:%Time,AppointEndDate:%Date,AppointEndTime:%Time,RequestCateCharpter:%String,AppointCateCharpter:%String,AppointUserID:%String,RequestUserID:%String,RequestDept:%String,RequestDate:%Date,RequestTime:%Time,EPRAction:%String,AppointType:%String")
{
	SELECT ID,EpisodeID,AppointDate,AppointTime,AppointEndDate,AppointEndTime,RequestCateCharpter,AppointCateCharpter,AppointUserID,RequestUserID,RequestDept,RequestDate,RequestTime,EPRAction,AppointType
	FROM EPRinstance.EPRActionAppoint
	ORDER BY ID
}

Query SelectAppointByEpisodeID(EpisodeID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EpisodeID:%String,AppointDate:%Date,AppointTime:%Time,AppointEndDate:%Date,AppointEndTime:%Time,RequestCateCharpter:%String,AppointCateCharpter:%String,AppointUserID:%String,RequestUserID:%String,RequestDept:%String,RequestDate:%Date,RequestTime:%Time,EPRAction:%String,AppointType:%String")
{
	SELECT ID,EpisodeID,AppointDate,AppointTime,AppointEndDate,AppointEndTime,RequestCateCharpter,AppointCateCharpter,AppointUserID,RequestUserID,RequestDept,RequestDate,RequestTime,EPRAction,AppointType
	FROM EPRinstance.EPRActionAppoint
	WHERE EpisodeID = :EpisodeID
	ORDER BY ID
}

Query SelectAppointByEPRAction(EPRAction As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EpisodeID:%String,AppointDate:%Date,AppointTime:%Time,AppointEndDate:%Date,AppointEndTime:%Time,RequestCateCharpter:%String,AppointCateCharpter:%String,AppointUserID:%String,RequestUserID:%String,RequestDept:%String,RequestDate:%Date,RequestTime:%Time,EPRAction:%String,AppointType:%String")
{
	SELECT ID,EpisodeID,AppointDate,AppointTime,AppointEndDate,AppointEndTime,RequestCateCharpter,AppointCateCharpter,AppointUserID,RequestUserID,RequestDept,RequestDate,RequestTime,EPRAction,AppointType
	FROM EPRinstance.EPRActionAppoint
	WHERE EPRAction = :EPRAction
	ORDER BY ID
}

}
