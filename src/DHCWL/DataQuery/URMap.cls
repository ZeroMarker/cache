/// 权限表
Class DHCWL.DataQuery.URMap Extends %Persistent
{

Property userID As %String(COLLATION = "EXACT");

Property rptCode As %String(COLLATION = "EXACT");

Index InxUserRpt On (userID, rptCode);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s newObj=##class(DHCWL.DataQuery.URMap).%New()
	s newObj.userID=inParam("userID")
	s newObj.rptCode=inParam("rptCode")

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
	s rptCodes=inParam("rptCode")
	s rptCnt=$l(rptCodes,",")
	f i=1:1:rptCnt {
		s codes=$p(rptCodes,",",i)
		s newObj=##class(DHCWL.DataQuery.URMap).%New()
		s newObj.rptCode=codes
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
	s rptCode=inParam("rptCode")
	if $g(rptCode)'="" {
		&sql(DELETE FROM DHCWL_DataQuery.URMap WHERE rptCode=:rptCode  AND userID =:userID )
	}else{
		&sql(DELETE FROM DHCWL_DataQuery.URMap WHERE userID =:userID )
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
<Value>rptCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DataQuery.URMapD</DataLocation>
<DefaultData>URMapDefaultData</DefaultData>
<IdLocation>^DHCWL.DataQuery.URMapD</IdLocation>
<IndexLocation>^DHCWL.DataQuery.URMapI</IndexLocation>
<StreamLocation>^DHCWL.DataQuery.URMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
