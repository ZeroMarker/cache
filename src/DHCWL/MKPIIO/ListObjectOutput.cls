Class DHCWL.MKPIIO.ListObjectOutput Extends %RegisteredObject [ Not ProcedureBlock ]
{

Property mkpi As DHCWL.MKPI.MKPI;

Property mkpiDimList As list Of DHCWL.MKPI.MKPIDimensions;

Property taskList As list Of DHCWL.MKPI.CreatDataTask;

Property dimProList As list Of DHCWL.MKPI.DimProperty;

//Property mkpiData As list Of DHCWL.MKPI.MKPIData;

/// s listObj=##class(DHCWL.MKPIIO.ListObjectOutput).Inite(16)
ClassMethod Inite(mkpiId) As DHCWL.MKPIIO.ListObjectOutput
{
	n (mkpiId)
	q:mkpiId="" ""
	s verNode=$o(^DHCWL.MKPI.Version(""),-1)
  	s version=1.0
  	s:verNode'="" version=^DHCWL.MKPI.Version(verNode)
	s mkpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIByName(mkpiId)
	q:mkpiId="" ""
	s obj=##class(DHCWL.MKPIIO.ListObjectOutput).%New()
	s obj.mkpi=##class(DHCWL.MKPI.MKPI).%OpenId(mkpiId)
	i +version<3.0 s obj.mkpiDimList=##Class(%Library.ListOfObjects).%New()
	e  s obj.mkpiDimList=##class(DHCWL.MKPIIO.MKPIDimensionsService).FindObjectById(mkpiId)
	s obj.taskList=##class(DHCWL.MKPIIO.CreatDataTaskSevice).FindObjectById(mkpiId)
	;s obj.mkpiData=##class(DHCWL.MKPIIO.MKPIDataSevice).FindObjectById(mkpiId)
	q obj
}

}
