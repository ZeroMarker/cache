/// creator：郭荣勇
/// date：2019-04-10
/// desc：接口数据获取逻辑方法，存储过程方式
/// 示例存储过程:ProcExample
Class DHCDoc.Interface.Outside.ReportData.Example.ServiceProc Extends %RegisteredObject
{

Query ProcExample(ByRef qHandle As %Binary) As websys.Query(ROWSPEC = "ExampleProA,ExampleProB,ExampleProC") [ SqlName = ReportData_ProcExample, SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Outside.ReportData.Example.ServiceProc","ProcExample")
ClassMethod ProcExampleExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s n=0
	
	//todo
	//添加逻辑处理代码
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
