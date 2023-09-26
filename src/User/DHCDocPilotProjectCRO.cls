/// CTOR: QP
/// DATE: 2022-06-25
/// DESC: CRO
Class User.DHCDocPilotProjectCRO Extends (%Persistent, User.Abstract)
{

/// 项目	
Property CROParef As User.DHCDocPilotProject [ SqlColumnNumber = 2, SqlFieldName = CRO_Paref ];

/// CRO公司
Property CROCompany As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CRO_Company ];

/// CRO联系人	
Property CROContact As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CRO_Contact ];

/// CRO联系人电话	
Property CROContactTel As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CRO_ContactTel ];

Index CROParef On CROParef As Exact;

Storage Default
{
<Data name="DHCDocPilotProjectCRODefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CROParef</Value>
</Value>
<Value name="3">
<Value>CROCompany</Value>
</Value>
<Value name="4">
<Value>CROContact</Value>
</Value>
<Value name="5">
<Value>CROContactTel</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocPilotProjectCROD</DataLocation>
<DefaultData>DHCDocPilotProjectCRODefaultData</DefaultData>
<IdLocation>^User.DHCDocPilotProjectCROD</IdLocation>
<IndexLocation>^User.DHCDocPilotProjectCROI</IndexLocation>
<StreamLocation>^User.DHCDocPilotProjectCROS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
