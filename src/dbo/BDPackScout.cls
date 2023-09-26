///     
Class dbo.BDPackScout Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackScout, StorageStrategy = Default ]
{

/// Foreign Key FKBDPScoutPack created via DDL
ForeignKey FKBDPScoutPack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PScout_Pack ];

/// Foreign Key FKBDPScoutScoutUser created via DDL
ForeignKey FKBDPScoutScoutUser(ScoutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PScout_ScoutUser ];

Index IndexPack On PackDR [ SqlName = Index_Pack, Type = index ];

Index IndexScoutDate On ScoutDate [ SqlName = Index_ScoutDate, Type = index ];

Index IndexScoutType On ScoutType [ SqlName = Index_ScoutType, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKSCOUT On RowID [ PrimaryKey, SqlName = PK_BD_PACKSCOUT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ScoutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ScoutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ScoutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ScoutType As %Library.SmallInt [ Required, SqlColumnNumber = 7 ];

Property BodyTemp As %Library.Float [ SqlColumnNumber = 8 ];

Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property DripSpeed As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SystolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property DiastolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property IsReaction As %Library.Boolean [ SqlColumnNumber = 13 ];

Property ReactionNote As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 14 ];

Property ExtraParam As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property HeartRate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property Breathing As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Property Height As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 19 ];

Property Weight As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BDPackScoutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>ScoutDate</Value>
</Value>
<Value name="4">
<Value>ScoutTime</Value>
</Value>
<Value name="5">
<Value>ScoutUserDR</Value>
</Value>
<Value name="6">
<Value>ScoutType</Value>
</Value>
<Value name="7">
<Value>BodyTemp</Value>
</Value>
<Value name="8">
<Value>Pulse</Value>
</Value>
<Value name="9">
<Value>DripSpeed</Value>
</Value>
<Value name="10">
<Value>SystolicPressure</Value>
</Value>
<Value name="11">
<Value>DiastolicPressure</Value>
</Value>
<Value name="12">
<Value>IsReaction</Value>
</Value>
<Value name="13">
<Value>ReactionNote</Value>
</Value>
<Value name="14">
<Value>ExtraParam</Value>
</Value>
<Value name="15">
<Value>Remark</Value>
</Value>
<Value name="16">
<Value>HeartRate</Value>
</Value>
<Value name="17">
<Value>Breathing</Value>
</Value>
<Value name="18">
<Value>Height</Value>
</Value>
<Value name="19">
<Value>Weight</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackScoutD</DataLocation>
<DefaultData>BDPackScoutDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BDPackScoutD</IdLocation>
<IndexLocation>^dbo.BDPackScoutI</IndexLocation>
<StreamLocation>^dbo.BDPackScoutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
