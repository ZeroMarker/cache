Class DHCWL.PerMis.Member Extends %Persistent
{

Property GrpCode As %String(COLLATION = "EXACT");

Property UserID As %String(COLLATION = "EXACT");

Index InxGrpUser On (GrpCode, UserID);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s grpCode=inParam("GrpCode")
	s userIDs=inParam("userIDs")
	s len=$l(userIDs,",")
	
	TSTART
	f i=1:1:len {
		q:ret'=""
		s userID=$p(userIDs,",",i)
		s newObj=##class(DHCWL.PerMis.Member).%New()
		s newObj.GrpCode=grpCode
		s newObj.UserID=userID
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="Insert 'Group'对象失败:"_$System.Status.GetErrorText(sc)
			Trollback
	 	}		
		
	}
	
	if ret="" TCOMMIT
	q ret
	
SQLErr
	if ret="" s ret="Insert 'Member'对象失败:未知错误!"
	q ret
}

ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s id=inParam("ID")
	//1、删除用户
	&sql(DELETE FROM DHCWL_PerMis.Member WHERE ID=:id)
	if SQLCODE<0 {
		s ret="DELETE 'DHCWL_PerMis.Member'对象失败:SQLCODE="_SQLCODE
		q ret
	}	

	q ret
}

Storage Default
{
<Data name="MemberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GrpCode</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.MemberD</DataLocation>
<DefaultData>MemberDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.MemberD</IdLocation>
<IndexLocation>^DHCWL.PerMis.MemberI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.MemberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
