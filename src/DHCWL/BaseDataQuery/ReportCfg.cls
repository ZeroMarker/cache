Class DHCWL.BaseDataQuery.ReportCfg Extends %Persistent
{

/// 查询对象名称
Property BaseObjName As %String;

/// 报表名称
Property Name As %String(COLLATION = "EXACT");

/// 日期统计项
Property DateItemName As %String(COLLATION = "EXACT", MAXLEN = 50);

/// 类型：grpRpt:网格/分组;crossRpt:交叉
Property Type As %String(COLLATION = "EXACT", MAXLEN = 50);

/// 是否聚合
Property IsAggregat As %String;

/// 作者的ID
Property userID As %String(COLLATION = "EXACT");

/// 创建日期
Property CreatDate As %Date;

/// 备注
Property Remarks As %String(MAXLEN = 150);

Index InxName On Name [ Unique ];

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.BaseDataQuery.ReportCfg).%New()
	s newObj.BaseObjName=inParam("qryObjName")
	s newObj.Name=inParam("rptName")
	s newObj.DateItemName=inParam("daterangeItem")
	s newObj.Type=inParam("rptType")
	//s newObj.IsAggregat=inParam("IsAggregat")
	s newObj.Remarks=inParam("Remarks")
	//s newObj.CreatDate=inParam("CreatDate")
	s newObj.CreatDate=+$h
	s newObj.userID=inParam("userID")
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert 'ReportCfg'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("RptID")=newObj.%Id() 
	d newObj.%Close()

	q ret
	/*
SQLErr
	if ret="" s ret="Insert 'ReportCfg'对象失败:未知错误!"
	q ret
	*/
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s id=inParam("RptID")
	s newObj=##class(DHCWL.BaseDataQuery.ReportCfg).%OpenId(id)
	s newObj.BaseObjName=inParam("qryObjName")
	s newObj.Name=inParam("rptName")
	s newObj.DateItemName=inParam("daterangeItem")
	s newObj.Type=inParam("rptType")
	//s newObj.IsAggregat=inParam("IsAggregat")
	//s newObj.userID=inParam("userID")
	s newObj.Remarks=inParam("Remarks")
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert ""ReportCfg""对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("RptID")=newObj.%Id() 
	d newObj.%Close()

	q ret
	
SQLErr
	if ret="" s ret="Insert ""ReportCfg""对象失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="ReportCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BaseObjName</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>DateItemName</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>IsAggregat</Value>
</Value>
<Value name="7">
<Value>userID</Value>
</Value>
<Value name="8">
<Value>CreatDate</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.ReportCfgD</DataLocation>
<DefaultData>ReportCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.ReportCfgD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.ReportCfgI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.ReportCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
