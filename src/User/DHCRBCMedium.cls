Class User.DHCRBCMedium Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRM_RowID, SqlTableName = DHCRBC_Medium, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRM_Server_DR
Property DRMServerDR As User.DHCRBCServer [ SqlColumnNumber = 2, SqlFieldName = DRM_Server_DR ];

/// DRM_Name
Property DRMName As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRM_Name ];

/// DRM_Size
Property DRMSize As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = DRM_Size ];

/// DRM_Full
Property DRMFull As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DRM_Full ];

/// DRM_Offline
Property DRMOffline As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DRM_Offline ];

/// DRM_Backup
Property DRMBackup As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = DRM_Backup ];

/// DRM_RemainSize
Property DRMRemainSize As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DRM_RemainSize ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCServer("Medium"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DRM_Backup">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRM_Full">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRM_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRM_Offline">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRM_RemainSize">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRM_Server_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRM_Size">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCServer</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Medium"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexServerDR">
<Global>^DHCRBCServer</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRM_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ServerDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRM_Server_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCMediumS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
