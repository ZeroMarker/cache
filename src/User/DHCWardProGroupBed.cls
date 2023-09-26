/// Ward Professional Group Bed
Class User.DHCWardProGroupBed Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WPGB_RowId, SqlTableName = DHC_WardProGroupBed, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WPGB_GroupDr
Property WPGBGroupDr As User.DHCWardProGroup [ SqlColumnNumber = 2, SqlFieldName = WPGB_GroupDr ];

/// WPGB_WardDr
Property WPGBWardDr As User.PACWard [ SqlColumnNumber = 3, SqlFieldName = WPGB_WardDr ];

/// WPGB_PacBedDr
Property WPGBPacBedDr As User.PACBed [ SqlColumnNumber = 4, SqlFieldName = WPGB_PacBedDr ];

/// WPGB_UpdateUser
Property WPGBUpdateUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = WPGB_UpdateUser ];

/// WPGB_UpdateDate
Property WPGBUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = WPGB_UpdateDate ];

/// WPGB_UpdateTime
Property WPGBUpdateTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = WPGB_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWardProGroupBed)</SqlIdExpression>
<SQLMap name="IndexGroupDr">
<Global>^DHCWardProGroupBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WPGB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WPGB_GroupDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WPGB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPacBedDr">
<Global>^DHCWardProGroupBed</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WPGB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PacBedDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WPGB_PacBedDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WPGB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCWardProGroup">
<Data name="WPGB_GroupDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WPGB_PacBedDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WPGB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WPGB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WPGB_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WPGB_WardDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCWardProGroupBed</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WPGB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{WPGB_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWardProGroupBedS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
