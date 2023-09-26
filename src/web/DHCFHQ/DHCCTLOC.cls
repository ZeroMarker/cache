/// 取科室信息
Class web.DHCFHQ.DHCCTLOC Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod CtLoc(Rid As %String) As %String
{
	s RetStr=""
	s del="^"
	q:Rid="" ""
	q:'$d(^CTLOC(Rid)) ""
	s CtLocCode=$p(^CTLOC(Rid),del,1)
	q CtLocCode
}

}
