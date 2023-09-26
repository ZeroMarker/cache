/// 解析Stream
Class DHCCPMWeb.CPMBL.Parse.DHCIPByStream Extends (DHCCPMWeb.CPMBL.Parse.DHCInPara, %XML.Adaptor) [ ClassType = "", CompileAfter = DHCCPMWeb.CPMBL.Parse.DHCInPara, Inheritance = right, Not ProcedureBlock ]
{

Method InParaToTMP(IPData) As %String
{
	n (IPData)
	s myrtn=0
	
	s myrtn=..XMLDeserialize(IPData)
	
	//s sc=##class(%XML.TextReader).ParseStream(IPData,.myxml)
	//If ($$$ISOK(sc)) {
	//	s myrtn=..XMLDeserialize(myxml)
	//}
	
	q myrtn
}

}
