Class DHCWL.BaseDataQuery.URMap Extends %Persistent
{

/// 用户ID
Property userID As %String(COLLATION = "EXACT");

/// 	报表名称
Property rptName As %String(COLLATION = "EXACT");

Index InxUserRpt On (userID, rptName);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.BaseDataQuery.URMap).%New()
	s newObj.userID=inParam("userID")
	s newObj.rptName=inParam("rptName")

	s sc=newObj.%Save()
	If $$$ISERR(sc) {
		s ret="Insert 'UserRightMap'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	d newObj.%Close()

	q ret
	
SQLErr
	if ret="" s ret="Insert 'UserRightMap'对象失败:未知错误!"
	q ret
}

ClassMethod InsertRpts(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	
	s userID=inParam("userID")
	s rptNames=inParam("rptName")
	s rptCnt=$l(rptNames,",")
	f i=1:1:rptCnt {
		s names=$p(rptNames,",",i)
		s newObj=##class(DHCWL.BaseDataQuery.URMap).%New()
		s newObj.rptName=names
		s newObj.userID=userID
		s sc=newObj.%Save()	
		d newObj.%Close()	
	}

	If $$$ISERR(sc) {
		s ret="Insert 'UserRightMap'对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
	

	q ret
	
SQLErr
	if ret="" s ret="Insert 'UserRightMap'对象失败:未知错误!"
	q ret
}

ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s userID=inParam("userID")
	s rptName=inParam("rptName")
	if $g(rptName)'="" {
		&sql(DELETE FROM DHCWL_BaseDataQuery.URMap WHERE rptName=:rptName  AND userID =:userID )
	}else{
		&sql(DELETE FROM DHCWL_BaseDataQuery.URMap WHERE userID =:userID )
	}
	q ret
	
SQLErr
	if ret="" s ret="Insert 'UserRightMap'对象失败:未知错误!"
	q ret
}

Storage Default
{
<Data name="URMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>userID</Value>
</Value>
<Value name="3">
<Value>rptName</Value>
</Value>
</Data>
<DataLocation>^DHCWL.BaseDataQuery.URMapD</DataLocation>
<DefaultData>URMapDefaultData</DefaultData>
<IdLocation>^DHCWL.BaseDataQuery.URMapD</IdLocation>
<IndexLocation>^DHCWL.BaseDataQuery.URMapI</IndexLocation>
<StreamLocation>^DHCWL.BaseDataQuery.URMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
