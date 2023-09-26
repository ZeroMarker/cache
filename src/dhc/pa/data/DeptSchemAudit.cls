Class dhc.pa.data.DeptSchemAudit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSA_rowid, SqlTableName = DeptSchemAudit ]
{

/// SAudit_SchemDr
Property DSchemDr As dhc.pa.data.DeptSchem [ SqlColumnNumber = 2, SqlFieldName = DSA_DSchemDr ];

/// SAudit_userDr
Property DuserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = DSA_userDr ];

/// SAudit_isRead
Property DisRead As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SAudit_isRead ];

/// SAudit_isWrite
Property DisWrite As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SAudit_isWrite ];

Index DSchemUser On (DSchemDr, DuserDr);

Storage Default
{
<Data name="DeptSchemAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSchemDr</Value>
</Value>
<Value name="3">
<Value>DuserDr</Value>
</Value>
<Value name="4">
<Value>DisRead</Value>
</Value>
<Value name="5">
<Value>DisWrite</Value>
</Value>
</Data>
<DataLocation>^DHCCJXPADeptSchemAuditD</DataLocation>
<DefaultData>DeptSchemAuditDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPADeptSchemAuditD</IdLocation>
<IndexLocation>^DHCCJXPADeptSchemAuditI</IndexLocation>
<StreamLocation>^DHCCJXPADeptSchemAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
