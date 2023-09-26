Class User.DHCRBNumberCreateRule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DNC_Rowid, SqlTableName = DHCRB_Number_CreateRule, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DNC_ReLoc_DR
Property DNCRecLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DNC_RecLoc_DR ];

/// DNC_UseMethod_DR
Property DNCUseMethodDR As User.DHCRBCUseMethod [ SqlColumnNumber = 3, SqlFieldName = DNC_UseMethod_DR ];

/// DNC_AppType
Property DNCAppType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DNC_AppType ];

/// DNC_Operation_DR
Property DNCOperationDR As User.DHCRBCPatientStatus [ SqlColumnNumber = 5, SqlFieldName = DNC_Operation_DR ];

/// DNC_SaveIndex
Property DNCSaveIndex As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DNC_SaveIndex ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBSerialNumber("SerialCreateRule"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DNC_AppType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DNC_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DNC_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DNC_SaveIndex">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DNC_UseMethod_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBSerialNumber</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DNC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SerialCreateRule"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DNC_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCRBSerialNumberi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DNC_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RecLoc-Number"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DNC_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DNC_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBNumberCreateRuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
