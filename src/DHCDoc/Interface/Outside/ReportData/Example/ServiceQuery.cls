/// creator：郭荣勇
/// date：2019-04-10
/// desc：接口数据获取逻辑方法，提供Query方式
/// 示例Query:QueryExample
Class DHCDoc.Interface.Outside.ReportData.Example.ServiceQuery Extends %RegisteredObject
{

Query QueryExample(ByRef qHandle As %Binary, p1 = "") As websys.Query(ROWSPEC = "ExampleQryA,ExampleQryB,ExampleQryC")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Outside.ReportData.Example.ServiceQuery","QueryExample")
ClassMethod QueryExampleExecute(ByRef qHandle As %Binary, p1 = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s n=0
	
	//todo
	//添加逻辑处理代码
	//以下为测试数据
	for i=1:1:10 {
		s Data=$lb("行"_i_"列1","行"_i_"列2","行"_i_"列3")
 		s ^CacheTemp(repid,ind)=Data
 		s ind=ind+1
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

}
