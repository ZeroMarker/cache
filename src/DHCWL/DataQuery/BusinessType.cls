/// 名称: DHCWL.DataQuery.BusinessType
/// 描述: 业务类型主表
/// 编写者：王峥
/// 编写日期: 2017-7
/// d ##class(DHCWL.DataQuery.BusinessType).%BuildIndices()
Class DHCWL.DataQuery.BusinessType Extends %Persistent
{

/// 业务类型编码
Property Code As %String(COLLATION = "EXACT");

/// 业务类型描述
Property Descript As %String(COLLATION = "EXACT");

/// 业务类型备注
Property Remarks As %String(COLLATION = "EXACT");

Index InxCode On Code [ Unique ];

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   插入新记录
/// Table：       	DHCWL.DataQuery.BusinessType
/// Input：         inParam:包含编码，描述，备注的数组
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	if $d(^DHCWL.DataQuery.BusinessTypeI("InxCode",inParam("Code"))) {
		s ret="新建业务类型失败:业务类型编码重复！"
		q ret
	}
	s newObj=##class(DHCWL.DataQuery.BusinessType).%New()
	s newObj.Code=$g(inParam("Code"))
	s newObj.Descript=$g(inParam("Descript"))
	s newObj.Remarks=$g(inParam("Remarks"))
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建业务类型失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=newObj.%Id() 
	d newObj.%Close()
	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   更新记录
/// Table：       	DHCWL.DataQuery.BusinessType
/// Input：         inParam:包含ID，描述，备注的数组
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.DataQuery.BusinessType).%OpenId(inParam("rowid"))

	//s newObj.Code=$g(inParam("Code"))
	s newObj.Descript=$g(inParam("Descript"))
	s newObj.Remarks=$g(inParam("Remarks"))
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新业务类型失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	d newObj.%Close()
	q ret
SQLErr
	if ret="" s ret="更新业务类型失败:未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:： 删除记录。删除业务类型描述时，会将业务类型子表的数据一起删除
/// Table：       	DHCWL.DataQuery.BusinessType，DHCWL.DataQuery.BTSub
/// Input：         inParam:包含ID，描述，备注的数组
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s BTCode=inParam("BTCode")
	NEW SQLCODE
	&sql(DELETE FROM DHCWL_DataQuery.BTSub WHERE BusinessTypeCode=:BTCode)
 
	IF SQLCODE'=0 && (SQLCODE'=100) {
		s ret="删除BTSub失败:"_$SYSTEM.SQL.SQLCODE(SQLCODE)
		q ret
   	}

	NEW SQLCODE
	&sql(DELETE FROM DHCWL_DataQuery.BusinessType WHERE Code=:BTCode)
 
	IF SQLCODE'=0 && (SQLCODE'=100) {
		s ret="删除BusinessType失败:"_$SYSTEM.SQL.SQLCODE(SQLCODE)
		q ret
   	}	
	

	q ret
SQLErr
	if ret="" s ret="删除BTSub失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="BusinessTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Descript</Value>
</Value>
<Value name="4">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DataQuery.BusinessTypeD</DataLocation>
<DefaultData>BusinessTypeDefaultData</DefaultData>
<IdLocation>^DHCWL.DataQuery.BusinessTypeD</IdLocation>
<IndexLocation>^DHCWL.DataQuery.BusinessTypeI</IndexLocation>
<StreamLocation>^DHCWL.DataQuery.BusinessTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
