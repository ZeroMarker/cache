Class web.CTBBBloodProduct Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// AI 22 Oct 2002: This is called from the OEOrder.Edit.Profile.csp page and the epr.Chart.csp page.
/// It receives no values as input but returns a delimited string of All Blood Product Values and All Blood Product Text.
/// by wuqk 2011-06-05
ClassMethod getBloodProduct() As %Library.String
{
	//^TTAB("BB-BP")
	set bloodCode="",bloodDesc=""
	set tmpCode=$o(^TTAB("BB-BP",""))
	while tmpCode'=""{
		set tmpDesc=$p($g(^TTAB("BB-BP",tmpCode)),"\",1)
		set bloodCode=bloodCode_tmpCode_","
		set bloodDesc=bloodDesc_tmpDesc_","
		set tmpCode=$o(^TTAB("BB-BP",tmpCode))
	}
	set:bloodCode'="" bloodCode=$e(bloodCode,1,$l(bloodCode)-1)
	set:bloodDesc'="" bloodDesc=$e(bloodDesc,1,$l(bloodDesc)-1)
	quit bloodCode_"^"_bloodDesc
}

}
