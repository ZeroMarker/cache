/// 名称: DHCWL.DataQuery.RptSubFilterCfg
/// 描述: 继承自DHCWL.DataQuery.ReportSubCfg
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.RptSubFilterCfg Extends DHCWL.DataQuery.ReportSubCfg
{

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

		q:inParam("filterText")="" ret
		s newObj=##class(DHCWL.DataQuery.RptSubFilterCfg).%New()
		s newObj.RptCode=$g(inParam("RptCode"))
		s newObj.Code="filterText"
		s newObj.Descript="过滤规则"
		s newObj.Type="filter"
		s newObj.Express=inParam("filterText")
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
	 	}	
	 	d newObj.%Close()	


	
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
	&sql(DELETE FROM DHCWL_DataQuery.ReportSubCfg WHERE RptCode = :RptCode AND Type= 'filter' )
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
	if ret="" s ret="更新DHCWL.BaseDataQuery.ReportCfgSub对象失败:未知错误!"
	q ret
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
