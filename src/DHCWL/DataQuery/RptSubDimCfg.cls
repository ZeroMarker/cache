/// 名称: DHCWL.DataQuery.RptSubDimCfg
/// 描述: 继承自DHCWL.DataQuery.ReportSubCfg
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.RptSubDimCfg Extends DHCWL.DataQuery.ReportSubCfg
{

/// /// 顺序
Property Order As %Integer;

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   插入新记录
/// Table：       	DHCWL.DataQuery.RptSubDimCfg
/// Input：         inParam:包含要插入记录的字段数据
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s recInx=0
	f {
		s recInx=$o(inParam("items",recInx))	
		q:$g(recInx)=""
		q:ret'=""
		continue:$g(inParam("items",recInx,"dimOrMeasure"))'="dim"
		s newObj=##class(DHCWL.DataQuery.RptSubDimCfg).%New()
		s newObj.RptCode=$g(inParam("RptCode"))
		s newObj.Code=$g(inParam("items",recInx,"Code"))
		s newObj.Descript=$g(inParam("items",recInx,"Descript"))
		s newObj.Type=$g(inParam("items",recInx,"Type"))
		s newObj.Express=$g(inParam("items",recInx,"Express"))
		//比父类多出的属性
		s newObj.Order=$g(inParam("items",recInx,"Order"))
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
/// Description:：   批量删除记录
/// Table：       	DHCWL.DataQuery.RptSubDimCfg
/// Input：         inParam:包含要删除记录的主表编码
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	
	s $zt="SQLErr"
	s ret=""
	
	s RptCode=inParam("RptCode")
	&sql(DELETE FROM DHCWL_DataQuery.RptSubDimCfg WHERE RptCode = :RptCode )
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
<Data name="RptSubDimCfgDefaultData">
<Subscript>"RptSubDimCfg"</Subscript>
<Value name="1">
<Value>Order</Value>
</Value>
</Data>
<DefaultData>RptSubDimCfgDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
