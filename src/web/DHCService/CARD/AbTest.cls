Class web.DHCService.CARD.AbTest Extends (%RegisteredObject, web.DHCService.CARD.Abstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Method MTest() As %String
{
	;d ##class(web.DHCService.CARD.AbTest).MTest()
	;Do ##super()
	
	w ..#TestPara
	w !,!
}

ClassMethod DD()
{
	;d ##class(web.DHCService.CARD.AbTest).DD()
	s myobj=##class(web.DHCEntity.PCA.PamodeTest).%New()
}

}
