Import SQLUser

Class DHCOLB.Balancing Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod InsertOLBInfo(ServerDR As %String = "", ClientDR As %String = "", ServerIP As %String = "", ComputerIP As %String = "", ComputerMac As %String = "", ComputerName As %String = "", ConnUpdateUser As %String = "", Note As %String = "") As %String
{
	i ConnUpdateDate="" s ConnUpdateDate=+$H
	i ConnUpdateTime="" s ConnUpdateTime=$P($h,",",2)
	s (ServerDR,ClientDR,ServerIP,ComputerIP,ComputerMac,ComputerName,ConnUpdateUser,Note)=""
	&SQL(insert into DHC_OLBInfo (ServerDR,ClientDR,ServerIP,ComputerIP,ComputerMac,ComputerName,ConnUpdateUser,ConnUpdateDate,ConnUpdateTime,Note)
	            values (:ServerDR,:ClientDR,:ServerIP,:ComputerIP,:ComputerMac,:ComputerName,:ConnUpdateUser,:ConnUpdateDate,:ConnUpdateTime,:Note))
	q SQLCODE
}

ClassMethod UpdateOLBInfo(ID As %String, ServerDR As %String = "", ClientDR As %String = "", ServerIP As %String = "", ComputerIP As %String = "", ComputerMac As %String = "", ComputerName As %String = "", ConnUpdateUser As %String = "", Note As %String = "") As %String
{
	i ConnUpdateDate="" s ConnUpdateDate=+$H
	i ConnUpdateTime="" s ConnUpdateTime=$P($h,",",2)
	//s (ServerDR,ClientDR,ServerIP,ComputerIP,ComputerMac,ComputerName,ConnUpdateUser,Note)=""
	&SQL(UpDate DHC_OLBInfo set ServerDR=:ServerDR,ClientDR=:ClientDR,ServerIP=:ServerIP,ComputerIP=:ComputerIP,ComputerMac=:ComputerMac,ComputerName=:ComputerName,ConnUpdateUser=:ConnUpdateUser,ConnUpdateDate=:ConnUpdateDate,ConnUpdateTime=:ConnUpdateTime,Note=:Note where ID=:ID)
	q SQLCODE
}

ClassMethod DeleteOLBInfo(ID As %String = "", ServerIP As %String = "", ComputerIP As %String = "") As %String
{
	q:((ID="")&&(ServerIP="")&&(ComputerIP="")) 0
	i ID'="" &SQL(Delete from DHC_OLBInfo where ID=:ID)
	i ServerIP'="" &SQL(Delete from DHC_OLBInfo where ServerIP=:ServerIP)
	i ComputerIP'="" &SQL(Delete from DHC_OLBInfo where ComputerIP=:ComputerIP)
	q SQLCODE
}

Storage Default
{
<Data name="BalancingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCOLB.BalancingD</DataLocation>
<DefaultData>BalancingDefaultData</DefaultData>
<IdLocation>^DHCOLB.BalancingD</IdLocation>
<IndexLocation>^DHCOLB.BalancingI</IndexLocation>
<StreamLocation>^DHCOLB.BalancingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
