///     
Class dbo.RPBottleColDetails Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_BottleColDetails ]
{

/// Foreign Key FKRPBottleColDetailsCollectionDR created via DDL
ForeignKey FKRPBottleColDetailsCollectionDR(CollectionDR) References dbo.RPBottleCollection(PKRPBOTTLECOLLECTION) [ SqlName = FK_RPBottleColDetailsCollectionDR ];

/// Foreign Key FKRPBottleColDetailsMCCultureBottleDR created via DDL
ForeignKey FKRPBottleColDetailsMCCultureBottle(MCCultureBottleDR) References dbo.MCCultureBottle(PKMCCULTUREBOTTLE) [ SqlName = FK_RPBottleColDetailsMCCultureBottle ];

/// Foreign Key FKRPBottleColDetailsAddUserDR created via DDL
ForeignKey FKRPBottleColDetailsAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPBottleColDetailsAddUserDR ];

/// DDL Primary Key Specification
Index PKRPBOTTLECOLDETAILS On RowID [ PrimaryKey, SqlName = PK_RP_BOTTLECOLDETAILS, Type = index, Unique ];

Index IndexCollectionDR On (CollectionDR, MCCultureBottleDR) [ SqlName = Index_CollectionDR, Type = index, Unique ];

Index IndexMCCultureBottle On (MCCultureBottleDR, CollectionDR) [ SqlName = Index_MCCultureBottle, Type = index, Unique ];

Index IndexSequence On (CollectionDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property CollectionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property MCCultureBottleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="RPBottleColDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CollectionDR</Value>
</Value>
<Value name="3">
<Value>MCCultureBottleDR</Value>
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
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^dbo.RPBottleColDetailsD</DataLocation>
<DefaultData>RPBottleColDetailsDefaultData</DefaultData>
<IdLocation>^dbo.RPBottleColDetailsD</IdLocation>
<IndexLocation>^dbo.RPBottleColDetailsI</IndexLocation>
<StreamLocation>^dbo.RPBottleColDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
