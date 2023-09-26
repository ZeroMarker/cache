/// 错误数据修复类
Class DHCCPMWeb.CPMBL.DHCBLDataRepair Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod RepCompNameRepair()
{
	;d ##class(DHCCPMWeb.CPMBL.DHCBLDataRepair).RepCompNameRepair()
	
	s myRepRowID=0
	f  s myRepRowID=$o(^DHCCPM.DHCReportsD(myRepRowID))  q:(myRepRowID="")  d
	.s myobj=##class(DHCCPM.DHCReports).%OpenId(myRepRowID)
	.s myCompDR=myobj.ComponentDR
	.s myCompobj=##class(websys.Component).%OpenId(myCompDR)
	.q:'($IsObject(myCompobj))
	.b		;CompDR
	.s myCompName=myCompobj.Name
	.d myCompobj.%Close()
	.s myobj.ComponentName =myCompName
	.d myobj.%Save()
	.d myobj.%Close()
	.;w ##class(DHCCPMWeb.CPMBL.DHCBLReports).GetCompNameByCompDR("udhcOPAdmFindCSPTEST")
	.
	
	q 0
}

}
