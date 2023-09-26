Import SQLUser

/// zhaocz -- 2013-0812
/// , User.Abstract
Class web.DHCReportSConfig Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod UpdateRepServerConfig(rowid As %String, appname As %String, healthwebsite As %String, serverip As %String, servername As %String, serverport As %String) As %String
{
 i rowid="" d
 .&sql(insert into DHC_RepServerConfig(RSC_AppName,RSC_HealthWebSite,RSC_ServerIP,RSC_ServerName,RSC_ServerPort) values (:appname,:healthwebsite,:serverip,:servername,:serverport) )
 e  d
 .&sql(update DHC_RepServerConfig set RSC_AppName=:appname,RSC_HealthWebSite=:healthwebsite,RSC_ServerIP=:serverip,RSC_ServerName=:servername,RSC_ServerPort=:serverport where ID=:rowid)
 q:SQLCODE -1
 q %ROWID
}

ClassMethod DeleteRepServerConfig(rowid As %String) As %String
{
 q:rowid="" 0
 &sql(delete from DHC_RepServerConfig where ID=:rowid)
 q:SQLCODE -1
 q 0
}

Query GetRepServerConfig() As %SQLQuery(ROWSPEC = "AppName:%String,HealthWebSite:%String,ServerIP:%String,ServerName:%String,ServerPort:%String,Rrowid:%String")
{
	
	select RSC_AppName,RSC_HealthWebSite,RSC_ServerIP,RSC_ServerName,RSC_ServerPort,ID from DHC_RepServerConfig
}

}
