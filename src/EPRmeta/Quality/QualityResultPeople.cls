/// ************************************************************
/// * Class Name:	EPRmeta.Quality.QualityResultPeople
/// * Description:	The model of quality result people
/// * Author:		Zuoxiang Xie
/// * Create Date:	2010-07-21
/// ************************************************************/
Class EPRmeta.Quality.QualityResultPeople Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Employee reference
Property EmployeeDr As %String(TRUNCATE = 1);

/// Department reference of Employee
Property CtLocDr As %String(TRUNCATE = 1);

/// Whether active or not
Property IsActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// Notes
Property ResumeText As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0);

Storage Default
{
<Data name="QualityResultPeopleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtLocDr</Value>
</Value>
<Value name="3">
<Value>EmployeeDr</Value>
</Value>
<Value name="4">
<Value>IsActive</Value>
</Value>
<Value name="5">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QualityResultPeopleD</DataLocation>
<DefaultData>QualityResultPeopleDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QualityResultPeopleD</IdLocation>
<IndexLocation>^DHCEPRM.QualityResultPeopleI</IndexLocation>
<StreamLocation>^DHCEPRM.QualityResultPeopleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
