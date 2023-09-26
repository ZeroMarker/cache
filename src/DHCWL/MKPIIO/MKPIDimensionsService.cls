Class DHCWL.MKPIIO.MKPIDimensionsService Extends DHCWL.MKPIIO.Service [ Not ProcedureBlock ]
{

/// d ##class(DHCWL.MKPIIO.CreatDataTaskSevice).FindObjectById(16)
ClassMethod FindObjectById(id) As %List
{
	n (id)
	q:id="" ""
	s list=##Class(%Library.ListOfObjects).%New() ;.ListOfPersistentChildObjects).%New()
	s code="" f  s code=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",id,code)) q:code=""  d
	.s mkpiDimId=$o(^DHCWL.MKPI.MKPIDimensionsI("MKPIDimCodeI",id,code,""))
	.d list.Insert(##class(DHCWL.MKPI.MKPIDimensions).%OpenId(mkpiDimId))
	q list
}

}
