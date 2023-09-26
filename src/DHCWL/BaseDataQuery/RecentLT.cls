/// d ##class(DHCWL.BaseDataQuery.RecentLT).%BuildIndices()
Class DHCWL.BaseDataQuery.RecentLT Extends %Persistent
{

/// 报表工具，包括：基础数据查询，通用简单数据查询等等
Property RptTool As %String(COLLATION = "EXACT");

/// 用户
Property UserDr As User.SSUser;

/// 报表ID
Property RptID As %String(COLLATION = "EXACT");

/// 访问日期
Property VisitDate As %Date;

/// 访问时间
Property VisitTime As %Time;

Index InxMain On (RptTool, UserDr, RptID);

Index InxDateTime On (UserDr, VisitDate, VisitTime);

/// Creator：      王峥
/// CreatDate：    2018-7-24
/// Description:：   插入
/// Table：       RecentLT
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(DHCWL.BaseDataQuery.Rpt)Insert(,)
ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s newObj=##class(RecentLT).%New()
	s newObj.RptTool=inParam("RptTool")
	s usrObj=##class(User.SSUser).%OpenId(inParam("UserID"))
	s newObj.UserDr=usrObj
	s newObj.RptID=inParam("RptID")
	s newObj.VisitDate=$P($H,",",1)
	s newObj.VisitTime=$P($H,",",2)

	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="新建对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
 	d newObj.%Close()

	q ret
SQLErr
	if ret="" s ret="新建对象失败:"_$ZERROR
	q ret
}

/// Creator：      王峥
/// CreatDate：    2018-10
/// Description:：   更新
/// Table：       RecentLT
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(DHCWL.BaseDataQuery.Rpt)Insert(,)
ClassMethod Update(ByRef inParam, ByRef outParam) As %String
{
	s $zt="SQLErr"
	s ret=""
	
	s rptTool=inParam("RptTool")
	s userID=inParam("UserID")
	s rptID=inParam("RptID")
	
	s ID=$O(^DHCWL.BaseDataQuery.RecentLTI("InxMain",rptTool,userID,rptID,0))
	s updateObj=##class(RecentLT).%OpenId(ID)
	
	s updateObj.VisitDate=$P($H,",",1)
	s updateObj.VisitTime=$P($H,",",2)

	s sc=updateObj.%Save()
	If $$$ISERR(sc) {
		s ret="更新对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}

	q ret
SQLErr
	if ret="" s ret="更新对象失败:"_$ZERROR
	q ret
}

Storage Default
{
<Data name="RecentLTDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusinessType</Value>
</Value>
<Value name="3">
<Value>UserDr</Value>
</Value>
<Value name="4">
<Value>RptID</Value>
</Value>
<Value name="5">
<Value>VisitDate</Value>
</Value>
<Value name="6">
<Value>VisitTime</Value>
</Value>
<Value name="7">
<Value>RptTool</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.RecentLTD</DataLocation>
<DefaultData>RecentLTDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.RecentLTD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.RecentLTI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.RecentLTS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
