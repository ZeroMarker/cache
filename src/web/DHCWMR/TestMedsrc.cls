Class web.DHCWMR.TestMedsrc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

/// w ##Class(web.DHCWMR.TestMedsrc).Test()
ClassMethod Test()
{
 set i=$$GetTestRoutine
 w i

GetTestRoutine
   w "111"
}

/// w ##Class(web.DHCWMR.TestMedsrc).Test2()
ClassMethod Test2()
{
	d GetTestRoutine
}

}
