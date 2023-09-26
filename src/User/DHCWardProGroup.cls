/// Ward Professional Group 
Class User.DHCWardProGroup Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = WPG_RowId, SqlTableName = DHC_WardProGroup, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// WPG_WardId
Property WPGWardDr As User.PACWard [ SqlColumnNumber = 2, SqlFieldName = WPG_WardDr ];

/// WPG_GroupDesc
Property WPGGroupDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = WPG_GroupDesc ];

/// WPG_GroupCode
Property WPGGroupCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = WPG_GroupCode ];

/// WPG_ActivFlag
Property WPGActivFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = WPG_ActivFlag ];

/// WPG_UpdateUser
Property WPGUpdateUser As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = WPG_UpdateUser ];

/// WPG_UpdateDate
Property WPGUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = WPG_UpdateDate ];

/// WPG_UpdateTime
Property WPGUpdateTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = WPG_UpdateTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCWardProGroup)</SqlIdExpression>
<SQLMap name="IndexWardDr">
<Global>^DHCWardProGroup</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>WPG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WardDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{WPG_WardDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WPG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDHCWardProGroup">
<Data name="WPG_ActivFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WPG_GroupCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WPG_GroupDesc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WPG_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WPG_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WPG_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WPG_WardDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCWardProGroup</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>WPG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{WPG_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCWardProGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
