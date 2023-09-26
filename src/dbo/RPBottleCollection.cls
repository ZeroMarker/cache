///     
Class dbo.RPBottleCollection Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_BottleCollection ]
{

/// Foreign Key FKRPBottleCollectionHospitalDR created via DDL
ForeignKey FKRPBottleCollectionHospitalDR(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RPBottleCollectionHospitalDR ];

/// Foreign Key FKRPBottleCollectionAddUserDR created via DDL
ForeignKey FKRPBottleCollectionAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPBottleCollectionAddUserDR ];

/// Foreign Key FKRPBottleCollectionPrintUserDR created via DDL
ForeignKey FKRPBottleCollectionPrintUserDR(PrintUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPBottleCollectionPrintUserDR ];

/// Foreign Key FKRPBottleCollectionLocationDR created via DDL
ForeignKey FKRPBottleCollectionLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_RPBottleCollectionLocationDR ];

/// Foreign Key FKRPBottleCollectionCollectionUserDR created via DDL
ForeignKey FKRPBottleCollectionCollectionUserDR(CollectionUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPBottleCollectionCollectionUserDR ];

/// Foreign Key FKRPBottleCollectionWorkGroupDR created via DDL
ForeignKey FKRPBottleCollectionWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_RPBottleCollectionWorkGroupDR ];

/// DDL Primary Key Specification
Index PKRPBOTTLECOLLECTION On RowID [ PrimaryKey, SqlName = PK_RP_BOTTLECOLLECTION, Type = index, Unique ];

Index IndexCollectionNo On CollectionNo [ SqlName = Index_CollectionNo, Type = index, Unique ];

Index IndexAddDate On (AddDate, AddTime, CollectionType) [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate, AddTime, CollectionType) [ SqlName = Index_AddUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property CollectionNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property CollectionUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CollectionName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 10 ];

Property CollectionType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 11 ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 12 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property PrintDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Property PrintTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Property PrintUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="RPBottleCollectionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CollectionNo</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>LocationDR</Value>
</Value>
<Value name="8">
<Value>CollectionUserDR</Value>
</Value>
<Value name="9">
<Value>CollectionName</Value>
</Value>
<Value name="10">
<Value>CollectionType</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>WorkGroupDR</Value>
</Value>
<Value name="13">
<Value>PrintDate</Value>
</Value>
<Value name="14">
<Value>PrintTime</Value>
</Value>
<Value name="15">
<Value>PrintUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPBottleCollectionD</DataLocation>
<DefaultData>RPBottleCollectionDefaultData</DefaultData>
<IdLocation>^dbo.RPBottleCollectionD</IdLocation>
<IndexLocation>^dbo.RPBottleCollectionI</IndexLocation>
<StreamLocation>^dbo.RPBottleCollectionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
