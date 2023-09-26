Class DHCWL.MKPIIO.MKPIDataSevice Extends DHCWL.MKPIIO.Service [ Not ProcedureBlock ]
{

/// s list=##class(DHCWL.MKPIIO.MKPIDataSevice).FindObjectById(22)
ClassMethod FindObjectById(mkpiId) As %List
{
	n (mkpiId)
	q:mkpiId="" ""
	s list=##Class(%Library.ListOfObjects).%New() ;.ListOfPersistentChildObjects).%New()
	s mkpiDataId=""  f  s mkpiDataId=$o(^DHCWL.MKPI.MKPIDataI("MKDKPIdr",mkpiId,mkpiDataId)) q:mkpiDataId=""  d
	.s mkpiData=##class(DHCWL.MKPI.MKPIData).%OpenId(mkpiDataId)
	.d list.Insert(mkpiData)
	q list
}

}
