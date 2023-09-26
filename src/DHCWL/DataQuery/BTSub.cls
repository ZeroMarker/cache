/// 名称: DHCWL.DataQuery.BTSub
/// 描述: 业务类型子表
/// 编写者：王峥
/// 编写日期: 2017-7
Class DHCWL.DataQuery.BTSub Extends %Persistent
{

/// 业务类型主表编码
Property BusinessTypeCode As %String(COLLATION = "EXACT");

/// 关联的指标编码
Property KPICode As %String(COLLATION = "EXACT");

Index BTCodeKPICode On (BusinessTypeCode, KPICode) [ Unique ];

Index KPICodeBTCode On (KPICode, BusinessTypeCode);

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:： 批量插入
/// Table：       	DHCWL.DataQuery.BTSub
/// Input：         inParam:要插入的业务类型编码和指标编码
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod InsertBat(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s kpiCodes=inParam("kpiCodes")
	s BTCode=inParam("BTCode")
	s len=$l(kpiCodes,",")
	f i=1:1:len {
		s kCode=$p(kpiCodes,",",i)
		
		if $d(^DHCWL.DataQuery.BTSubI("KPICodeBTCode",kCode)) {
			s ret="新建BusinessTypeSub失败:业务类型编码重复！"
			break
		}
		s newObj=##class(DHCWL.DataQuery.BTSub).%New()
		s newObj.BusinessTypeCode=BTCode
		s newObj.KPICode=kCode
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="新建BusinessTypeSub失败:"_$System.Status.GetErrorText(sc)
			break
 	}

	d newObj.%Close()		
		
	}
	

	q ret
SQLErr
	if ret="" s ret="新建BusinessTypeSub失败:未知错误!"
	q ret
}

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:： 删除记录
/// Table：       	DHCWL.DataQuery.BTSub
/// Input：         inParam:要删除的业务类型编码和指标编码
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s kpiCode=inParam("kpiCode")
	s BTCode=inParam("BTCode")

	if '$d(^DHCWL.DataQuery.BTSubI("KPICodeBTCode",kpiCode,BTCode)) {
		s ret=""
		q ret
	}
	s BTSubID=$o(^DHCWL.DataQuery.BTSubI("KPICodeBTCode",kpiCode,BTCode,""))
	
	Set sc = ##class(DHCWL.DataQuery.BTSub).%DeleteId(BTSubID)
	If $$$ISERR(sc) {
		s ret="删除BTSub失败:"_$System.Status.GetErrorText(sc)
		q ret
	}

	q ret
SQLErr
	if ret="" s ret="删除BTSub失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="BTSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusinessTypeCode</Value>
</Value>
<Value name="3">
<Value>KPICode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DataQuery.BTSubD</DataLocation>
<DefaultData>BTSubDefaultData</DefaultData>
<IdLocation>^DHCWL.DataQuery.BTSubD</IdLocation>
<IndexLocation>^DHCWL.DataQuery.BTSubI</IndexLocation>
<StreamLocation>^DHCWL.DataQuery.BTSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
