/// d ##class(DHCWL.BaseDataQuery.DS).%BuildIndices()
Class DHCWL.BaseDataQuery.DS Extends %Persistent
{

/// 编码-唯一标识
Property Code As %String(COLLATION = "EXACT");

/// 名称
Property Name As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(COLLATION = "EXACT", MAXLEN = 200);

/// 类型。包括：主题，数据集，基础表等等
Property Type As %String(COLLATION = "EXACT");

// Index InxCode On Code;

Index InxCodeType On (Code, Type);

/// 得到所有维度
Method GetDims() As %ListOfObjects
{
}

/// 得到所有度量
Method GetMetrics() As %ListOfObjects
{
}

/// s obj=##class(DHCWL.BaseDataQuery.DS).GetById(1)
ClassMethod GetById(ID As %String) As DS
{
	q ##class(DS).%OpenId(ID)
}

/// s obj=##class(DHCWL.BaseDataQuery.DS).GetById(1)
ClassMethod GetByCode(Code As %String) As DS
{
	if '$d(^DHCWL.BaseDataQuery.DSI("InxCode",Code))
	q ""
	s ID=$o(^DHCWL.BaseDataQuery.DSI("InxCode",Code,""))
	q ##class(DS).%OpenId(ID)
}

Method GetPropertys(dimCode As %String) As %ListOfObjects
{
}

Method GetDataTypeCodeByDesc(desc As %String) As %String
{
}

Method QryPrepare(ByRef aryCfgData) As %Status
{
}

Method QryExecute(ByRef aryCfgData) As %Status
{
}

Method QryNext() As %Integer
{
}

/*
Method QryGetColumnHeader(n As %Integer) As %String
{
}

Method QryGetAt(n As %Integer) As %String
{
}
Method QryGetColumnCount() As %Integer
{
}
*/
ClassMethod ParseItemExp(exp As %String, ByRef aryExp) As %String
{
	k aryExp
	if exp="" q ""
	s cnt=$l(exp,"^")
	f i=1:1:cnt {
		s k=$p($p(exp,"^",i),":",1)	
		s v=$p($p(exp,"^",i),":",2)
		s aryExp(k)=v	
	}
	q ""
}

Method CheckFilterStr(filterStr As %String) As %String
{
}

Method Outputs(rowNO, repid, ByRef ind, ByRef aryCfgData)
{
}

Storage Default
{
<Data name="DSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Descript</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.DSD</DataLocation>
<DefaultData>DSDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.DSD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.DSI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.DSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
