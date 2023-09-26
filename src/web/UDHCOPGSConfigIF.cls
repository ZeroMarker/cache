Class web.UDHCOPGSConfigIF Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod ReadGSPMListBroker(JSFunName As %String, ListName As %String, GPRowID As %String = "", InsType As %String = "", ExpStr As %String = "") As %String
{
	n (JSFunName, ListName, GPRowID, InsType, ExpStr)
	
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=3){
		////大同非常特殊
		d ##class(web.UDHCOPGSConfig).ReadGSINSPMListTypeBroker(JSFunName,ListName,GPRowID,InsType)
	}else{
		s TypeFlag=$p(ExpStr,"^",1)
		d ##class(web.UDHCOPGSConfig).ReadGSINSPMListTypeBroker(JSFunName,ListName,GPRowID,InsType,TypeFlag)
	}
	q 0
}

ClassMethod ReadGSPMListBroker2(JSFunName As %String, ListName As %String, GPRowID As %String = "", InsType As %String = "", ExpStr As %String = "") As %String
{
	n (JSFunName, ListName, GPRowID, InsType, ExpStr)
	;w ##class(web.UDHCOPGSConfigIF).ReadGSPMListBroker2("","",92,"","")

	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=3){
		////大同非常特殊
		d ##class(web.UDHCOPGSConfig).ReadGSPMListBroker(JSFunName,ListName,GPRowID)
	}else{
		d ##class(web.UDHCOPGSConfig).ReadGSINSPMListTypeBroker2(JSFunName,ListName,GPRowID, InsType)
	}
	q 0
}

}
