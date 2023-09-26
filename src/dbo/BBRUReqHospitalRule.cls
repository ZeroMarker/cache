Class dbo.BBRUReqHospitalRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BBRU_ReqHospitalRule ]
{

Index IndexMaster On (HospitalDR, ReqRuleDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKBBBPorductHospital created via DDL
ForeignKey FKBBRULEHOSHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BBRU_REHOS_Hospital ];

/// Foreign Key FKBBRURERuleRule created via DDL
ForeignKey FKBBRULEHOSRule(ReqRuleDR) References dbo.BBRUReqRule(PKBBRUREQRULE) [ SqlName = FK_BBRU_REHOS_Rule ];

/// DDL Primary Key Specification
Index PKBBRULEQHOSPITALRULE On RowID [ PrimaryKey, SqlName = PK_BBRU_REQHOSPITALRULE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ReqRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BBRUReqHospitalRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>ReqRuleDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBRUReqHospitalRuleD</DataLocation>
<DefaultData>BBRUReqHospitalRuleDefaultData</DefaultData>
<IdLocation>^dbo.BBRUReqHospitalRuleD</IdLocation>
<IndexLocation>^dbo.BBRUReqHospitalRuleI</IndexLocation>
<StreamLocation>^dbo.BBRUReqHospitalRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
