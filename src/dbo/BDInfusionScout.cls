/// 血液输注记录单关联巡视记录
Class dbo.BDInfusionScout Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_InfusionScout ]
{

/// Foreign Key FKBDInfusionScoutInfusionDR created via DDL
ForeignKey FKBDInfusionScoutInfusionDR(InfusionDR) References dbo.BDInfusion(PKBDINFUSION) [ SqlName = FK_BDInfusionScoutInfusionDR ];

/// Foreign Key FKBDInfusionScoutScoutUserDR created via DDL
ForeignKey FKBDInfusionScoutScoutUserDR(ScoutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BDInfusionScoutScoutUserDR ];

/// DDL Primary Key Specification
Index PKBDINFUSIONSCOUT On RowID [ PrimaryKey, SqlName = PK_BD_INFUSIONSCOUT, Type = index, Unique ];

Index IndexMaster On (InfusionDR, ScoutType, ScoutDate, ScoutTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexScoutDate On ScoutDate [ SqlName = Index_ScoutDate, Type = index ];

Index IndexScoutUser On (ScoutUserDR, ScoutDate) [ SqlName = Index_ScoutUser, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property InfusionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

Property ScoutType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ScoutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property ScoutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property ScoutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property BodyTemp As %Library.Float [ SqlColumnNumber = 8 ];

Property Pulse As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property DripSpeed As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property SystolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property DiastolicPressure As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property ExtraParam As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

Property IsReaction As %Library.Boolean [ SqlColumnNumber = 14 ];

Property ReactionNote As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Property HeartRate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

Property Breathing As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="BDInfusionScoutDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InfusionDR</Value>
</Value>
<Value name="3">
<Value>ScoutType</Value>
</Value>
<Value name="4">
<Value>ScoutDate</Value>
</Value>
<Value name="5">
<Value>ScoutTime</Value>
</Value>
<Value name="6">
<Value>ScoutUserDR</Value>
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
<Value>ExtraParam</Value>
</Value>
<Value name="13">
<Value>IsReaction</Value>
</Value>
<Value name="14">
<Value>ReactionNote</Value>
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
</Data>
<DataLocation>^dbo.BDInfusionScoutD</DataLocation>
<DefaultData>BDInfusionScoutDefaultData</DefaultData>
<IdLocation>^dbo.BDInfusionScoutD</IdLocation>
<IndexLocation>^dbo.BDInfusionScoutI</IndexLocation>
<StreamLocation>^dbo.BDInfusionScoutS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
