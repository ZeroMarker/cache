Class DHCCPMWeb.CPMBL.Parse.DHCIPByFile Extends (DHCCPMWeb.CPMBL.Parse.DHCInPara, %XML.Adaptor) [ ClassType = "", CompileAfter = DHCCPMWeb.CPMBL.Parse.DHCInPara, Inheritance = right, ProcedureBlock ]
{

Method InParaToTMP(IPData As %String) As %String
{
	s myrtn=0
	
	s myrtn=..XMLDeserialize(IPData)
	
	//s sc = ##class(%XML.TextReader).ParseFile(IPData,.myxml)
	//If ($$$ISOK(sc)) {
	//	s myrtn=..XMLDeserialize(myxml)
	//}
	
	q myrtn
}

}
