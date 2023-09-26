/// 名称: DHCWL.DataQuery.RptSubMeasureCfg
/// 描述: 继承自DHCWL.DataQuery.ReportSubCfg
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.RptSubMeasureCfg Extends DHCWL.DataQuery.ReportSubCfg
{

/// 是否汇总
Property IsAggregate As %String(COLLATION = "EXACT");

/// 顺序
Property Order As %Integer;

/// 	显示格式，包括：#.00，#.000，#.0000，#
Property ShowFormat As %String(COLLATION = "EXACT");

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：  与父类功能一样
/// Table：       	
/// Input：         
/// Output：       
/// Return：        
/// Others
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s recInx=0
	f {
		s recInx=$o(inParam("items",recInx))	
		q:$g(recInx)=""
		q:ret'=""
		continue:$g(inParam("items",recInx,"dimOrMeasure"))'="measure"
		s newObj=##class(DHCWL.DataQuery.RptSubMeasureCfg).%New()
		s newObj.RptCode=$g(inParam("RptCode"))
		s newObj.Code=$g(inParam("items",recInx,"Code"))
		s newObj.Descript=$g(inParam("items",recInx,"Descript"))
		s newObj.Type=$g(inParam("items",recInx,"Type"))
		s newObj.Express=$g(inParam("items",recInx,"Express"))
		//比父类多出的属性
		s newObj.Order=$g(inParam("items",recInx,"Order"))
		s newObj.IsAggregate=$g(inParam("items",recInx,"IsAggregate"))
		s newObj.ShowFormat=$g(inParam("items",recInx,"ShowFormat"))
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
	 	}	
	 	d newObj.%Close()	
	}

	
	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：  与父类功能一样
/// Table：       	
/// Input：         
/// Output：       
/// Return：        
/// Others
ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	
	s $zt="SQLErr"
	s ret=""
	
	s RptCode=inParam("RptCode")
	&sql(DELETE FROM DHCWL_DataQuery.RptSubMeasureCfg WHERE RptCode = :RptCode )
	if SQLCODE'=0 && (SQLCODE'=100) {
		s ret="删除DHCWL_DataQuery.ReportSubCfg对象失败:SQLCODE="_SQLCODE
		q ret
	}

	q ret
	
SQLErr
	if ret="" s ret="删除DHCWL_DataQuery.ReportSubCfg对象失败:未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：  与父类功能一样
/// Table：       	
/// Input：         
/// Output：       
/// Return：        
/// Others
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s ret=..Delete(.inParam,.outParam)
	q:ret'="" ret
	s ret=..Insert(.inParam,.outParam)

	q ret
	
SQLErr
	if ret="" s ret="更新DHCWL.DataQuery.RptSubDimCfg对象失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="RptSubMeasureCfgDefaultData">
<Subscript>"RptSubMeasureCfg"</Subscript>
<Value name="1">
<Value>IsAggregate</Value>
</Value>
<Value name="2">
<Value>Order</Value>
</Value>
<Value name="3">
<Value>ShowFormat</Value>
</Value>
</Data>
<DefaultData>RptSubMeasureCfgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
