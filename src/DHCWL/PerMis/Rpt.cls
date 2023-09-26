Class DHCWL.PerMis.Rpt Extends %Persistent
{

/// 报表标识符
Property RptID As %String(COLLATION = "EXACT");

/// 报表类型，如：收入配置
Property RptType As %String(COLLATION = "EXACT");

/// 组编码
Property GrpCode As %String(COLLATION = "EXACT");

Index InxGrpTypeId On (GrpCode, RptType, RptID);

ClassMethod Insert(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s grpCode=inParam("GrpCode")
	s rptType=inParam("RptType")
	s rptIDs=inParam("rptIDs")
	s len=$l(rptIDs,",")
	
	TSTART
	f i=1:1:len {
		q:ret'=""
		s rptID=$p(rptIDs,",",i)
		s newObj=##class(DHCWL.PerMis.Rpt).%New()
		s newObj.GrpCode=grpCode
		s newObj.RptID=rptID
		s newObj.RptType=rptType
		s sc=newObj.%Save()
		If $$$ISERR(sc) {
			s ret="Insert 'Rpt'对象失败:"_$System.Status.GetErrorText(sc)
			Trollback
	 	}		
	}
	
	if ret="" TCOMMIT
	q ret
	
SQLErr
	if ret="" s ret="Insert 'Rpt'对象失败:未知错误!"
	q ret
}

ClassMethod Delete(ByRef inParam, ByRef outParam) As %String
{
	//s $zt="SQLErr"
	s ret=""
	s id=inParam("ID")
	//1、删除用户
	&sql(DELETE FROM DHCWL_PerMis.Rpt WHERE ID=:id)
	if SQLCODE<0 {
		s ret="DELETE 'DHCWL_PerMis.Rpt'对象失败:SQLCODE="_SQLCODE
		q ret
	}	

	q ret
}

Storage Default
{
<Data name="RptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptID</Value>
</Value>
<Value name="3">
<Value>RptType</Value>
</Value>
<Value name="4">
<Value>GrpCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.PerMis.RptD</DataLocation>
<DefaultData>RptDefaultData</DefaultData>
<IdLocation>^DHCWL.PerMis.RptD</IdLocation>
<IndexLocation>^DHCWL.PerMis.RptI</IndexLocation>
<StreamLocation>^DHCWL.PerMis.RptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
