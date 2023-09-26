///     
Class dbo.RPDeliveryInfo Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_DeliveryInfo ]
{

Index IndexAddDate On (AddDate, AddUserDR) [ SqlName = Index_AddDate, Type = index ];

/// Foreign Key FKRPDeliveryInfoSpeciesDR created via DDL
ForeignKey FKRPDeliveryInfoSpeciesDR(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_RPDeliveryInfoSpeciesDR ];

/// Foreign Key FKRPDeliveryInfoAgeUnitDR created via DDL
ForeignKey FKRPDeliveryInfoAgeUnitDR(AgeUnitDR) References dbo.BTAgeUnit(PKBTAGEUNIT) [ SqlName = FK_RPDeliveryInfoAgeUnitDR ];

/// Foreign Key FKRPDeliveryInfoHospitalDR created via DDL
ForeignKey FKRPDeliveryInfoHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RPDeliveryInfoHospitalDR ];

/// Foreign Key FKRPDeliveryInfoAddUserDR created via DDL
ForeignKey FKRPDeliveryInfoAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPDeliveryInfoAddUserDR ];

/// DDL Primary Key Specification
Index PKRPDELIVERYINFO On RowID [ PrimaryKey, SqlName = PK_RP_DELIVERYINFO, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumber As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 3 ];

Property RegNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 4 ];

Property TestSetCodes As %Library.String(COLLATION = "Exact", MAXLEN = 400) [ SqlColumnNumber = 5 ];

Property IDNumber As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

Property SurName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 7 ];

Property GivenName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 8 ];

Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property BirthDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property BirthTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property Age As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property AgeUnitDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property RequestDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property RequestTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Property Doctor As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 17 ];

Property HosName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 18 ];

Property MobileNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 19 ];

Property Address As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 20 ];

Property ReqNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 21 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="RPDeliveryInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumber</Value>
</Value>
<Value name="3">
<Value>RegNo</Value>
</Value>
<Value name="4">
<Value>TestSetCodes</Value>
</Value>
<Value name="5">
<Value>IDNumber</Value>
</Value>
<Value name="6">
<Value>SurName</Value>
</Value>
<Value name="7">
<Value>GivenName</Value>
</Value>
<Value name="8">
<Value>SpeciesDR</Value>
</Value>
<Value name="9">
<Value>BirthDate</Value>
</Value>
<Value name="10">
<Value>BirthTime</Value>
</Value>
<Value name="11">
<Value>Age</Value>
</Value>
<Value name="12">
<Value>AgeUnitDR</Value>
</Value>
<Value name="13">
<Value>HospitalDR</Value>
</Value>
<Value name="14">
<Value>RequestDate</Value>
</Value>
<Value name="15">
<Value>RequestTime</Value>
</Value>
<Value name="16">
<Value>Doctor</Value>
</Value>
<Value name="17">
<Value>HosName</Value>
</Value>
<Value name="18">
<Value>MobileNo</Value>
</Value>
<Value name="19">
<Value>Address</Value>
</Value>
<Value name="20">
<Value>ReqNotes</Value>
</Value>
<Value name="21">
<Value>AddDate</Value>
</Value>
<Value name="22">
<Value>AddTime</Value>
</Value>
<Value name="23">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPDeliveryInfoD</DataLocation>
<DefaultData>RPDeliveryInfoDefaultData</DefaultData>
<IdLocation>^dbo.RPDeliveryInfoD</IdLocation>
<IndexLocation>^dbo.RPDeliveryInfoI</IndexLocation>
<StreamLocation>^dbo.RPDeliveryInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
