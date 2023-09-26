/// Message
Class User.DHCMessage Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MESS_RowId, SqlTableName = DHC_Message, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Date Created
Property MESSDateCreated As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = MESS_DateCreated ];

/// Time Create
Property MESSTimeCreated As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = MESS_TimeCreated ];

/// Date Effective
Property MESSDateEffective As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = MESS_DateEffective ];

/// Time Effective
Property MESSTimeEffective As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = MESS_TimeEffective ];

/// Des Ref UserCreated
Property MESSUserCreatedDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = MESS_UserCreated_DR ];

/// Message
Property MESSMessage As %Library.String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MESS_Message ];

/// Message Categories
Property MESSCategDR As User.DHCMessCateg [ SqlColumnNumber = 8, SqlFieldName = MESS_Categ_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMESS("MESS"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MESS_Categ_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MESS_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESS_DateEffective">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MESS_Message">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MESS_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MESS_TimeEffective">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MESS_UserCreated_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMESS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCategDateCreated">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CategDateCreated"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_Categ_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESS_DateCreated}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCategDateEffective">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CategDateEffective"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_Categ_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESS_DateEffective}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateCreatedCateg">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateCreatedCateg"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_DateCreated}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESS_Categ_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateEffectiveCateg">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateEffective"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESS_DateEffective}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESS_Categ_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMessageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
