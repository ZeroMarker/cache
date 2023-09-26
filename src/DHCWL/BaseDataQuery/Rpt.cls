/// d ##class(DHCWL.BaseDataQuery.Rpt).%BuildIndices()
Class DHCWL.BaseDataQuery.Rpt Extends %Persistent
{

/// 编码
Property Code As %String(COLLATION = "EXACT") [ Required ];

/// 名称
Property Name As %String(COLLATION = "EXACT");

/// 描述
Property Descript As %String(COLLATION = "EXACT");

/// 查询对象引用
Property QryObjDr As QryObj;

/// 显示类型，包括：grid-网格报表和cross-交叉报表
Property ShowType As %String(COLLATION = "EXACT");

/// 创建者
Property Creator As %String(COLLATION = "EXACT");

/// 是否激活。用户在前台删除的报表配置，程序在后台会将这个字段置为0
Property IsActive As %String(COLLATION = "EXACT");

/// 业务类型，包括：收入，挂号，手术等等
Property BusinessType As %String(COLLATION = "EXACT");

// Property DateItemCode As %String(COLLATION = "EXACT");

/// 统计的日期口径
Property DateItemDr As QryItem;

/// 版本，配置程序的版本
Property Version As %String(COLLATION = "EXACT");

Index InxCode On Code;

Index InxQry On QryObjDr;

/// Creator：      王峥
/// CreatDate：    2018-7-24
/// Description:：   插入
/// Table：       qryObj
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(DHCWL.BaseDataQuery.Rpt)Insert(,)
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s exist=..GetByCode(inParam("rptCode"))
	if $ISOBJECT(exist) {
		s ret="该编码已存在。编码不能重复，请修改编码后再试！"
		q ret
	}
	
	s newObj=##class(Rpt).%New()
	s newObj.Code=inParam("rptCode")
	s newObj.Name=inParam("rptName")
	s newObj.Descript=inParam("rptDesc")
	s qryID=inParam("QryObjID")
	s QryObjDr=##class(QryObj).GetById(qryID)
	s newObj.QryObjDr=QryObjDr
	s newObj.ShowType=inParam("showType")
	s newObj.Creator=inParam("creator")
	s newObj.IsActive=1
	s newObj.BusinessType=inParam("businessType")
	if QryObjDr.DataSrcDr.Type="指标" {
		s newObj.DateItemDr=""
	}elseif QryObjDr.DataSrcDr.Type="主题" {
		s newObj.DateItemDr=##class(QryItem).GetByCode(qryID,inParam("dateItemCode"))
	}
	s newObj.Version="2.x"
	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建报表对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=newObj.%Id() 
 	d newObj.%Close()

	q ret
SQLErr
	if ret="" s ret="新建查询对象失败:"_$ZERROR
	q ret
}

ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s updateObj=..GetByCode(inParam("rptCode"))
	if '$ISOBJECT(updateObj) {
		s ret="该编码不存在。！"
		q ret
	}
	
	s qryID=inParam("QryObjID")
	s QryObjDr=##class(QryObj).GetById(qryID)
	s updateObj.QryObjDr=QryObjDr
	s updateObj.Creator=inParam("creator")

	if QryObjDr.DataSrcDr.Type="指标" {
		s updateObj.DateItemDr=""
	}elseif QryObjDr.DataSrcDr.Type="主题" {
		s updateObj.DateItemDr=##class(QryItem).GetByCode(qryID,inParam("dateItemCode"))
	}
	//s updateObj.DateItemDr=##class(QryItem).GetByCode(qryID,inParam("dateItemCode"))
	
	s sc=updateObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新报表对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	s inParam("ROWID")=updateObj.%Id() 
 	d updateObj.%Close()

	q ret
SQLErr
	if ret="" s ret="更新查询对象失败:"_$ZERROR
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
/// s ret=##class(DHCWL.BaseDataQuery.Rpt)Insert(,)
ClassMethod GetByCode(code As %String) As Rpt
{
	      
	if $d(^DHCWL.BaseDataQuery.RptI("InxCode",code)) {
		s ID=$o(^DHCWL.BaseDataQuery.RptI("InxCode",code,""))
		q ##class(Rpt).%OpenId(ID)	
	}
	
	q ""
}

ClassMethod GetIdByCode(code As %String) As %String
{
	      
	if $d(^DHCWL.BaseDataQuery.RptI("InxCode",code)) {
		s ID=$o(^DHCWL.BaseDataQuery.RptI("InxCode",code,""))
		q ID
	}
	
	q ""
}

/// s obj=##class(DHCWL.BaseDataQuery.Rpt).GetById(1)
ClassMethod GetById(ID As %String) As Rpt
{
	q ##class(Rpt).%OpenId(ID)
}

Method GetItemsByType(type As %String) As %ListOfObjects
{
	q ##class(RptItem).GetItemsByType(..%Id(),type)
}

Method GetItems() As %ListOfObjects
{
	q ##class(RptItem).GetItems(..%Id())
}

ClassMethod GetRpts() As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	
	s ID=""
	f{
	  s ID=$o(^DHCWL.BaseDataQuery.RptD(ID))
	  q:ID=""
	  s obj=##class(Rpt).%OpenId(ID)
	  continue:($ISOBJECT(obj)=-1)
	  d list.Insert(obj)
	}	
	q list
}

ClassMethod DelRpt(ID As %String) As %String
{
	s $zt="SQLErr"
	s ret=""	

	&sql(DELETE FROM DHCWL_BaseDataQuery.Rpt WHERE ID=:ID)
	
	if SQLCODE'=0 && (SQLCODE'=100) s ret="删除报表失败，SQLCODE DESC="_$SYSTEM.SQL.SQLCODE(SQLCODE)
	q ret

SQLErr
	if ret="" s ret="新建报表项失败:"_$ZERROR
	q ret
}

Storage Default
{
<Data name="RptDefaultData">
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
<Value>QryObjDr</Value>
</Value>
<Value name="6">
<Value>ShowType</Value>
</Value>
<Value name="7">
<Value>Creator</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
<Value name="9">
<Value>BusinessType</Value>
</Value>
<Value name="10">
<Value>DateItemCode</Value>
</Value>
<Value name="11">
<Value>Version</Value>
</Value>
<Value name="12">
<Value>DateItemDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.RptD</DataLocation>
<DefaultData>RptDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.RptD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.RptI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.RptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
