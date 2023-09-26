Class DHCWL.BaseDataQuery.QryObj Extends %Persistent
{

/// 编码
Property Code As %String(COLLATION = "EXACT") [ Required ];

Index CodeIndex On Code;

/// 名称
Property Name As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(COLLATION = "EXACT");

/// 索引
Index InxDSAndCode On (DataSrcDr, Code);

/// 数据源引用，数据源包括：主题，基础表，数据集等等。报表的统计项及统计结果，归根结底都是对数据源的操作
Property DataSrcDr As DS [ Required ];

/// Creator：      王峥
/// CreatDate：    2018-7-24
/// Description:：   插入
/// Table：       qryObj
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(Config.WLBDQ.QryObj)Insert(,)
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	//s exist=..GetIdByDSAndCode(inParam("qryObjDSID"),inParam("qryObjCode"))
	//if exist'="" {
	if $d(^DHCWL.BaseDataQuery.QryObjI("CodeIndex",inParam("qryObjCode"))) {	
		s ret="该编码已存在。编码不能重复，请修改编码后再试！"
		q ret
	}
	
	s DS=##class(DS).GetById(inParam("qryObjDSID"))

	s newObj=##class(DHCWL.BaseDataQuery.QryObj).%New()
	s newObj.Code=inParam("qryObjCode")
	s newObj.Name=inParam("qryObjName")
	s newObj.Descript=inParam("qryObjDesc")
	s newObj.DataSrcDr=DS
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建查询对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=newObj.%Id() 
	If inParam("ROWID")="" {
		s ret="新建查询对象失败:ROWID为空"
		q ret
 	}	
 	d newObj.%Close()

	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

/// Creator：      王峥
/// CreatDate：    2018-7-24
/// Description:：   插入
/// Table：       qryObj
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(Config.WLBDQ.QryObj)Insert(,)
ClassMethod GetIdByDSAndCode(DSID As %String, Code As %String) As %String
{
	s $zt="SQLErr"
	
	s ret=""
	//^Config.WLBDQ.QryObjI("InxDSAndCode",1,"code1",1)
	if $d(^DHCWL.BaseDataQuery.QryObjI("InxDSAndCode",DSID,Code)) {
		s ret=$o(^DHCWL.BaseDataQuery.QryObjI("InxDSAndCode",DSID,Code,""))
	}
	
	q ret

SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

/// s obj=##class(DHCWL.BaseDataQuery.QryObj).GetById(1)
ClassMethod GetById(ID As %String) As QryObj
{
	q ##class(QryObj).%OpenId(ID)
}

Method GetItems(type As %String) As %ListOfObjects
{
	q ##class(QryItem).GetItems(..%Id(),type)
}

Storage Default
{
<Data name="QryObjDefaultData">
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
<Value>DataSrcDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.QryObjD</DataLocation>
<DefaultData>QryObjDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.QryObjD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.QryObjI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.QryObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
