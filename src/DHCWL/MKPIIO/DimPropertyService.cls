Class DHCWL.MKPIIO.DimPropertyService Extends DHCWL.MKPIIO.Service [ Not ProcedureBlock ]
{

/// d ##class(DHCWL.MKPIIO.DimPropertyService).FindObjectById(218)
ClassMethod FindObjectById(id) As %List
{
	n (id)
	q:id="" ""
	s list=##Class(%Library.ListOfObjects).%New() ;.ListOfPersistentChildObjects).%New()
	s code="" f  s code=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,code)) q:code=""  d
	.s dimProId=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",id,code,""))
	.d list.Insert(##class(DHCWL.MKPI.DimProperty).%OpenId(dimProId))
	q list
}

}
