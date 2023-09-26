/// Message Recipient
Class User.DHCMessageRecipient Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MESSREC_RowId, SqlTableName = DHC_MessageRecipient, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Des Ref Message
Property MESSRECMessageDR As User.DHCMessage [ SqlColumnNumber = 2, SqlFieldName = MESSREC_Message_DR ];

/// Object Of Message Recipient
Property MESSRECObject As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MESSREC_Object ];

/// Date Read
Property MESSRECDateRead As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MESSREC_DateRead ];

/// Time Read
Property MESSRECTimeRead As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = MESSREC_TimeRead ];

/// Des Ref User
Property MESSRECUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = MESSREC_User_DR ];

/// Message State
Property MESSRECState As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = MESSREC_State ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMESS("MESSREC"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MESSREC_DateRead">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MESSREC_Message_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MESSREC_Object">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MESSREC_State">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MESSREC_TimeRead">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MESSREC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCMESS</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateRead">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DateRead"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_DateRead}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMessageObject">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MessageObject"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_Message_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_Object}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexMessageState">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MessageState"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_Message_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_State}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexState">
<Global>^DHCMESS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MESSREC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MESSREC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"State"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MESSREC_State}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MESSREC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMessageRecipientS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
