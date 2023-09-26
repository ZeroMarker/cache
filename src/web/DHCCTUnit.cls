Class web.DHCCTUnit Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// select Code,Name,Sequence from lab.DHCCTUnit
Query QUnit() As %SQLQuery(CONTAINID = 1)
{
select Id,Code,Name,Sequence,Visible from lab.DHCCTUnit
}

ClassMethod GetName(code As %String) As %String
{
	s RetValue=""
	s Id=$o(^lab.DHCCTUnitI("CodeIndex",$c(32)_code,""))
	i $d(Id){
		s RetValue=$li(^lab.DHCCTUnitD(Id),3)
	}
	q RetValue
}

}
