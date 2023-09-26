///     
Class dbo.BDCOVForm Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_COVForm, StorageStrategy = Default ]
{

/// Foreign Key FKCOVForm created via DDL
ForeignKey FKCOVForm(ReqFormDR) References dbo.BDReqForm(PKBDREQFORM) [ SqlName = FK_COVForm ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexMaster On ReqFormDR [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBDCOVFORM On RowID [ PrimaryKey, SqlName = PK_BD_COVFORM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property ReqFormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property COVConDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property COVLastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property AdmDays As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property DocPhoneNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property IsAllergicHistory As %Library.Boolean [ SqlColumnNumber = 10 ];

Property AllergicRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="BDCOVFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RowID</Value>
</Value>
<Value name="3">
<Value>ReqFormDR</Value>
</Value>
<Value name="4">
<Value>COVConDate</Value>
</Value>
<Value name="5">
<Value>COVLastDate</Value>
</Value>
<Value name="6">
<Value>AdmDays</Value>
</Value>
<Value name="7">
<Value>DocPhoneNo</Value>
</Value>
<Value name="8">
<Value>AddDate</Value>
</Value>
<Value name="9">
<Value>AddTime</Value>
</Value>
<Value name="10">
<Value>IsAllergicHistory</Value>
</Value>
<Value name="11">
<Value>AllergicRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BDCOVFormD</DataLocation>
<DefaultData>BDCOVFormDefaultData</DefaultData>
<IdLocation>^dbo.BDCOVFormD</IdLocation>
<IndexLocation>^dbo.BDCOVFormI</IndexLocation>
<StreamLocation>^dbo.BDCOVFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
