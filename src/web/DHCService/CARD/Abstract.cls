Class web.DHCService.CARD.Abstract Extends %RegisteredObject [ Abstract, ClassType = "", ProcedureBlock ]
{

Parameter TestPara = "PV";

Method MTest() As %String
{
	w "Abstract"
}

Method MTest1() As %String
{
	d ..MTest()
	w "Abstract"
}

}
