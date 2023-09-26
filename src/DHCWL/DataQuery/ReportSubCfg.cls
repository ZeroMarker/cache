/// 名称: DHCWL.DataQuery.ReportSubCfg
/// 描述: 报表配置信息子表
/// 编写者：王峥
/// 编写日期: 2017-6
Class DHCWL.DataQuery.ReportSubCfg Extends %Persistent
{

/// 主表编码
Property RptCode As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 编码
Property Code As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 描述
Property Descript As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 类型，包括几个值：
/// row：行，col：列，measure：度量，filter：过滤项，searchitem：查询项
Property Type As %String(COLLATION = "EXACT", MAXLEN = 20);

/// 表达式
Property Express As %String(COLLATION = "EXACT", MAXLEN = 1000);

Index InxRptCodeAndSubCode On (RptCode, Code);

Index InxType On Type;

Index InxRptCode On RptCode;

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   插入新记录
/// Table：       	DHCWL.DataQuery.ReportSubCfg
/// Input：         inParam:包含要插入记录的字段数据
/// Output：        无
/// Return：        正确：空；错误：错误描述
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
		//continue:$g(inParam("items",recInx,"dimOrMeasure"))="dim"
		s newObj=##class(DHCWL.DataQuery.ReportSubCfg).%New()
		s newObj.RptCode=$g(inParam("RptCode"))
		s newObj.Code=$g(inParam("items",recInx,"Code"))
		s newObj.Descript=$g(inParam("items",recInx,"Descript"))
		s newObj.Type=$g(inParam("items",recInx,"Type"))
		s newObj.Express=$g(inParam("items",recInx,"Express"))
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
/// Table：       	DHCWL.DataQuery.ReportSubCfg
/// Input：         inParam:包含要删除记录的主表编码
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	
	s $zt="SQLErr"
	s ret=""
	s RptCode=inParam("RptCode")
	
	s RptCode=inParam("RptCode")
	&sql(DELETE FROM DHCWL_DataQuery.ReportSubCfg WHERE RptCode = :RptCode)
	if SQLCODE'=0 && (SQLCODE'=100) {
		s ret="删除DHCWL_DataQuery.ReportSubCfg对象失败:SQLCODE="_SQLCODE
		q ret
	}

	q ret
	
	
	
SQLErr
	if ret="" s ret="删除DHCWL_DataQuery.ReportSubCfg对象失败:"_$ZERROR
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   更新记录
/// Table：       	DHCWL.DataQuery.ReportSubCfg
/// Input：         inParam:包含要更新记录的数据
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	//1、先删除
	s ret=..Delete(.inParam,.outParam)
	q:ret'="" ret
	//2、后插入
	s ret=..Insert(.inParam,.outParam)

	q ret
	
SQLErr
	if ret="" s ret="更新DHCWL.BaseDataQuery.ReportCfgSub对象失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="ReportSubCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCode</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Descript</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>Express</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DataQuery.ReportSubCfgD</DataLocation>
<DefaultData>ReportSubCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.DataQuery.ReportSubCfgD</IdLocation>
<IndexLocation>^DHCWL.DataQuery.ReportSubCfgI</IndexLocation>
<StreamLocation>^DHCWL.DataQuery.ReportSubCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
