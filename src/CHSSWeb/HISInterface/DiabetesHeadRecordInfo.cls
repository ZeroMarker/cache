Class CHSSWeb.HISInterface.DiabetesHeadRecordInfo Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Property PersonRowId As CHSS.PersonHealthRecordMain [ Required ];

Property DiseaseType As %String(TRUNCATE = 1);

Property DiagnoseDate As %Date;

Property BloodSurgeLimosis As %String(TRUNCATE = 1);

Property BloodAfterDiningOfTwo As %String(TRUNCATE = 1);

Property BloodAfterDining As %String(TRUNCATE = 1);

Property CaseSource As %String(TRUNCATE = 1);

Property DiseaseHistory As %Integer;

Property CheckDoctor As %String(TRUNCATE = 1);

Property DateCheck As %Date;

Property CheckType As %Integer;

Property StaffInput As %Integer;

Property DateOfInput As %Date;

Property DateOfUpdate As %Date;

Property UniteIll As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DiabetesHeadRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BloodAfterDining</Value>
</Value>
<Value name="3">
<Value>BloodAfterDiningOfTwo</Value>
</Value>
<Value name="4">
<Value>BloodSurgeLimosis</Value>
</Value>
<Value name="5">
<Value>CaseSource</Value>
</Value>
<Value name="6">
<Value>CheckAdd</Value>
</Value>
<Value name="7">
<Value>CheckDoctor</Value>
</Value>
<Value name="8">
<Value>CheckType</Value>
</Value>
<Value name="9">
<Value>DateCheck</Value>
</Value>
<Value name="10">
<Value>DateOfInput</Value>
</Value>
<Value name="11">
<Value>DateOfUpdate</Value>
</Value>
<Value name="12">
<Value>DiagnoseDate</Value>
</Value>
<Value name="13">
<Value>DiseaseHistory</Value>
</Value>
<Value name="14">
<Value>DiseaseType</Value>
</Value>
<Value name="15">
<Value>PersonRowId</Value>
</Value>
<Value name="16">
<Value>StaffInput</Value>
</Value>
<Value name="17">
<Value>UniteIll</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.DiabetesHead87ED</DataLocation>
<DefaultData>DiabetesHeadRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.DiabetesHead87ED</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.DiabetesHead87EI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.DiabetesHead87ES</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
