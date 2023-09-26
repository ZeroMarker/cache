Class DHCWL.DataQuery.ReportCfg Extends %Persistent
{

/// 编码
Property Code As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 报表描述
Property Descript As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 数据源类型
Property DataSrcType As %String(COLLATION = "EXACT", MAXLEN = 100);

/// 数据源名称
Property DataSrcName As %String(COLLATION = "EXACT");

/// 报表类型-行式或交叉
Property RptType As %String(COLLATION = "EXACT");

/// 创建者ID
Property UserID As %String(COLLATION = "EXACT");

/// 创建日期
Property CreatDate As %Date;

/// 业务类型的描述，与DHCWL.DataQuery.BusinessType无关
Property BusinessType As %String(COLLATION = "EXACT");

Index InxCode On Code;

/// Creator：      王峥
/// CreatDate：    2017-7
/// Description:：   插入新记录
/// Table：       	DHCWL.DataQuery.ReportCfg
/// Input：         inParam:包含要插入记录的字段数据
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.DataQuery.ReportCfg).%New()
	s newObj.Code=$g(inParam("RptCode"))
	s newObj.Descript=$g(inParam("Descript"))
	s newObj.DataSrcType=$g(inParam("DataSrcType"))
	s newObj.DataSrcName=$g(inParam("DataSrcName"))
	s newObj.RptType=$g(inParam("RptType"))
	s newObj.UserID=$g(inParam("UserID"))
	//s newObj.Remarks=$g(inParam("Remarks"))
	s newObj.BusinessType=$g(inParam("BusinessType"))
	s newObj.CreatDate=+$h
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
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
/// Table：       	DHCWL.DataQuery.ReportCfg
/// Input：         inParam:包含要更新记录的字段数据（不包括code字段）
/// Output：        无
/// Return：        正确：空；错误：错误描述
/// Others
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	
	//使用对象操作报错，原因不明
	/*
	s rowid=$o(^DHCWL.DataQuery.ReportCfgI("InxCode",inParam("RptCode"),0))
	s newObj=##class(DHCWL.DataQuery.ReportCfg).%OpenId(rowid)
	s newObj.Descript=$g(inParam("Descript"))
	s newObj.DataSrcType=$g(inParam("DataSrcType"))
	s newObj.DataSrcName=$g(inParam("DataSrcName"))
	s newObj.RptType=$g(inParam("RptType"))
	s newObj.UserID=$g(inParam("UserID"))
	s newObj.BusinessType=$g(inParam("BusinessType"))
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新对象失败:"_$System.Status.GetErrorText(sc)
		if $ISOBJECT(newObj) d newObj.%Close()
		q ret
 	}

	d newObj.%Close()
	q ret
	*/
	s Code=inParam("RptCode")
	s Descript=$g(inParam("Descript"))
	s DataSrcType=$g(inParam("DataSrcType"))
	s DataSrcName=$g(inParam("DataSrcName"))
	s RptType=$g(inParam("RptType"))
	s UserID=$g(inParam("UserID"))
	s BusinessType=$g(inParam("BusinessType"))
	
	&sql(UPDATE DHCWL_DataQuery.ReportCfg SET DataSrcType = :DataSrcType,DataSrcName=:DataSrcName,RptType=:RptType,UserID=:UserID,BusinessType=:BusinessType WHERE Code = :Code)
	if SQLCODE'=0 s ret="更新配置失败，SQLCODE:"_SQLCODE
	q ret
SQLErr
	if ret="" s ret="更新对象失败:未知错误!"
	q ret
}

/// 插入新记录后自动同步权限表
Trigger TrgSyncURMap [ Event = INSERT, Time = AFTER ]
{
	
	s rptCode={Code}
	s userID={UserID}
	&sql(INSERT INTO DHCWL_DataQuery.URMap (rptCode, userID) VALUES (:rptCode, :userID))
}

Method %OnAfterSave(Insert As %Boolean) As %Status [ Private ]
{
	if Insert=1 {
		s rptCode=..Code
		s userID=..UserID
		&sql(INSERT INTO DHCWL_DataQuery.URMap (rptCode, userID) VALUES (:rptCode, :userID))
		if SQLCODE=0 {
			QUIT $$$OK
		}else{
			QUIT 0
		}
	}
}

Storage Default
{
<Data name="ReportCfgDefaultData">
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
<Value>DataSrcType</Value>
</Value>
<Value name="5">
<Value>DataSrcName</Value>
</Value>
<Value name="6">
<Value>RptType</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>CreatDate</Value>
</Value>
<Value name="9">
<Value>BusinessType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DataQuery.ReportCfgD</DataLocation>
<DefaultData>ReportCfgDefaultData</DefaultData>
<IdLocation>^DHCWL.DataQuery.ReportCfgD</IdLocation>
<IndexLocation>^DHCWL.DataQuery.ReportCfgI</IndexLocation>
<StreamLocation>^DHCWL.DataQuery.ReportCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
