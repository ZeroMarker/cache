/// 解析String字符串
Class DHCCPMWeb.CPMBL.Parse.DHCIPByString Extends (DHCCPMWeb.CPMBL.Parse.DHCInPara, %XML.Adaptor) [ ClassType = "", CompileAfter = DHCCPMWeb.CPMBL.Parse.DHCInPara, Inheritance = right, Not ProcedureBlock ]
{

Method InParaToTMP(IPData As %String) As %String
{
	s myrtn=0
	
	s myrtn=..XMLDeserialize(IPData)
	
	//s sc=##class(%XML.TextReader).ParseString(IPData,.myxml)
	//If ($$$ISOK(sc)) {
	//	s myrtn=..XMLDeserialize(myxml)
	//}
	
	q myrtn
}

}
