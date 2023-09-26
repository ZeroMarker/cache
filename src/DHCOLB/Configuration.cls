Import SQLUser

Class DHCOLB.Configuration Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##Class(DHCOLB.Configuration).GetProfileApplication()
ClassMethod GetProfileApplication(Profile As %String = "") As %String
{
		s ProfileID=""
		i Profile'="" s ProfileID=$O(^DHCOLBProfilei(0,"OLBName",Profile,""))
		i ProfileID="" s ProfileID=$O(^DHCOLBProfile(""),-1)
		q:ProfileID="" ""
		s Application=$P($G(^DHCOLBProfile(ProfileID)),"^",5)
		q Application
}

/// w ##Class(DHCOLB.Configuration).GetProfileServer()
ClassMethod GetProfileServer(Application As %String = "") As %String
{
		s ServerIPStr=""
		s ProfileID=""
		i Application'="" s ProfileID=$O(^DHCOLBProfilei(0,"Application",Application,""))
		i ProfileID="" s ProfileID=$O(^DHCOLBProfile(""),-1)
		q:ProfileID="" ServerIPStr
		s ServerID=""
		f  s ServerID=$O(^DHCOLBServeri(0,"Profile",ProfileID,ServerID)) q:ServerID=""  d
		.s ServerStr=$G(^DHCOLBServer(ServerID))
		.s ActiveFlag=$P(ServerStr,"^",3)
		.q:ActiveFlag'="Y"
		.s ServerIP=$P(ServerStr,"^",2)
		.i ServerIPStr="" s ServerIPStr=ServerIP
		.e  s ServerIPStr=ServerIPStr_"^"_ServerIP
		q ServerIPStr
}

/// w ##Class(DHCOLB.Configuration).KeepLoadInfo()
ClassMethod KeepLoadInfo(ServerIP As %String = "") As %String
{
	s $zt="Error"
	s (ServerDR,ClientDR,ServerIP,ComputerIP,ComputerMac,ComputerName,ConnUpdateUser,ConnLoc,ConnGroup,ConnUpdateDate,ConnUpdateTime,ProcessId,Note)=""
	s hostname=$ZU(54,0)
	s ServerIP=$P($ZU(54,13,hostname),",")
	s ServerDR=$O(^DHCOLBServeri(0,"ServerIP",ServerIP,""))
	s ComputerIP=$G(%session.Data("REMOTE_ADDR"))
	i ComputerIP="" s ComputerIP=$ZUTIL(67,15,$JOB)
	s ConnUpdateUserID=$G(%session.Data("LOGON.USERID"))
	i ConnUpdateUserID'="" s ConnUpdateUser=$P($G(^SSU("SSUSR",ConnUpdateUserID)),"^",1)
	s ConnLocID=$G(%session.Data("LOGON.CTLOCID"))
	i ConnLocID'="" s ConnLoc=$P($G(^CTLOC(ConnLocID)),"^",2)
	s ConnGroupID=$G(%session.Data("LOGON.GROUPID"))
	i ConnGroupID'="" s ConnGroup=$P($G(^SSU("SSGRP",ConnGroupID)),"^",1)
	s ConnUpdateDate=+$H
	s ConnUpdateTime=$P($H,",",2)
	s ProcessId=$JOB
	s ID=$O(^DHCOLBInfoi(0,"ServerClientUser",ServerIP,ComputerIP,ConnUpdateUser,""))
	i ID="" d
	.&SQL(insert into DHC_OLBInfo (ServerDR,ClientDR,ServerIP,ComputerIP,ComputerMac,ComputerName,ConnUpdateUser,ConnLoc,ConnGroup,ConnUpdateDate,ConnUpdateTime,ProcessId,Note)
		values (:ServerDR,:ClientDR,:ServerIP,:ComputerIP,:ComputerMac,:ComputerName,:ConnUpdateUser,:ConnLoc,:ConnGroup,:ConnUpdateDate,:ConnUpdateTime,:ProcessId,:Note))
	e  d
	.&SQL(update DHC_OLBInfo set ServerDR=:ServerDR,ClientDR=:ClientDR,ServerIP=:ServerIP,ComputerIP=:ComputerIP,ComputerMac=:ComputerMac,ComputerName=:ComputerName,ConnUpdateUser=:ConnUpdateUser,ConnLoc=:ConnLoc,ConnGroup=:ConnGroup,ConnUpdateDate=:ConnUpdateDate,ConnUpdateTime=:ConnUpdateTime,ProcessId=:ProcessId,Note=:Note where ID=:ID)
	q "OK"
Error
	q "OK"
}

/// w ##Class(DHCOLB.Configuration).UpdateServerActive()
ClassMethod UpdateServerActive(ServerIP As %String = "", ActiveFlag As %String = "") As %String
{
	s $zt="Error"
	s hostname=$ZU(54,0)
	i ServerIP="" s ServerIP=$P($ZU(54,13,hostname),",")
	i ActiveFlag="" s ActiveFlag="N"
	&SQL(update DHC_OLBServer set ActiveFlag=:ActiveFlag where ServerIP=:ServerIP)
	q "OK"
Error
	q "OK"
}

}
