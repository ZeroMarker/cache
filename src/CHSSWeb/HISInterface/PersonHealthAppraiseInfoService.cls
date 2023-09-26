Class CHSSWeb.HISInterface.PersonHealthAppraiseInfoService Extends %Persistent
{

/// Creator:jinming
/// CreateDate:2011-05-23
/// Description:健康评价与指导
ClassMethod PersonHealthAppraiseInfo(personRowId As %String, checkRowId As %String) As %String
{
 	s personRowId = $g(personRowId)
	Set count = 0
	Set checkRowId = $g(checkRowId)
	s HealthAppraiseRowId = 0
	&SQL(select HealthAppraiseRowId into :HealthAppraiseRowId from CHSS.PersonHealthAppraise where YearCheckRowId=:checkRowId)
    Set tempPersonCheck = ##class(CHSS.PersonHealthAppraise).%OpenId(HealthAppraiseRowId)
    s reportData = ##class(CHSSWeb.HISInterface.PersonHealthAppraiseInfo).%New()
	i $IsObject(tempPersonCheck) d
	.Set reportData.CheckResult = tempPersonCheck.CheckResult
	.Set reportData.HealthSuggest = tempPersonCheck.HealthSuggest
	.Set reportData.DangerInfo = tempPersonCheck.DangerInfo
	.set reportData.CheckResultInfo = tempPersonCheck.CheckResultInfo
	.Set reportData.AppraiseOther = tempPersonCheck.DangerControl
	
	.s cdef = ##class(%Dictionary.ClassDefinition).%OpenId("CHSSWeb.HISInterface.PersonHealthAppraiseInfo") 	
	.s count = cdef.Properties.Count()
	.s returnData = "<PersonHealthAppraise>"
	.f i = 1:1:count d
    ..s returnData = returnData_"<"_cdef.Properties.GetAt(i).Name_">"_$ZOBJPROPERTY(reportData,cdef.Properties.GetAt(i).Name)_"</"_cdef.Properties.GetAt(i).Name_">"
 	.s returnData = returnData_"</PersonHealthAppraise>"
	q returnData
}

Storage Default
{
<Data name="PersonHealthAppraiseInfoServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.PersonHealthC5FD</DataLocation>
<DefaultData>PersonHealthAppraiseInfoServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.PersonHealthC5FD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.PersonHealthC5FI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.PersonHealthC5FS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
