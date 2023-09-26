Class DHCEPRFS.BL.BLCreateServer Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCreateServer","GetAllTaskType")
Query GetAllTaskType() As %SQLQuery
{
	SELECT  Code, Name, Description, Color
	FROM DHCEPRFS_META.CTTaskType
}

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLCreateServer","GetServerInfoByIP","192.168.50.114")
Query GetServerInfoByIP(AIP As %String) As %SQLQuery
{
	SELECT A.IP,A.TaskType,B.Code,B.Name,B.Color
	FROM DHCEPRFS_META.CreateServer A
	LEFT JOIN DHCEPRFS_META.CTTaskType B ON A.TaskType=B.Code
	WHERE A.IP =:AIP
}

}
