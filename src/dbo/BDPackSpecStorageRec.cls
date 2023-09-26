///     
Class dbo.BDPackSpecStorageRec Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackSpecStorageRec, StorageStrategy = Default ]
{

Index IndexDate On (AddDate, OperateType) [ SqlName = Index_Date, Type = index ];

Index IndexMaster On (PackSpecNo, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

Index IndexUser On (AddDate, AddUserDR) [ SqlName = Index_User, Type = index ];

/// DDL Primary Key Specification
Index PKBDPackSpecStorageRec On RowID [ PrimaryKey, SqlName = PK_BD_PackSpecStorageRec, Type = index, Unique ];

/// Foreign Key FKPackSpecStorageRecAddUser created via DDL
ForeignKey FKPackSpecStorageRecAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_PackSpecStorageRec_AddUser ];

/// Foreign Key FKPackSpecStorageRecSpecimenRack created via DDL
ForeignKey FKPackSpecStorageRecSpecimenRack(SpecimenRackDR) References dbo.BTSpecimenRack(PKBTSPECIMENRACK) [ SqlName = FK_PackSpecStorageRec_SpecimenRack ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackSpecNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

Property SpecimenRackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property PositionNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 6 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BDPackSpecStorageRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackSpecNo</Value>
</Value>
<Value name="3">
<Value>SpecimenRackDR</Value>
</Value>
<Value name="4">
<Value>PositionNo</Value>
</Value>
<Value name="5">
<Value>OperateType</Value>
</Value>
<Value name="6">
<Value>AddDate</Value>
</Value>
<Value name="7">
<Value>AddTime</Value>
</Value>
<Value name="8">
<Value>AddUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackSpecStorageRecD</DataLocation>
<DefaultData>BDPackSpecStorageRecDefaultData</DefaultData>
<IdLocation>^dbo.BDPackSpecStorageRecD</IdLocation>
<IndexLocation>^dbo.BDPackSpecStorageRecI</IndexLocation>
<StreamLocation>^dbo.BDPackSpecStorageRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
