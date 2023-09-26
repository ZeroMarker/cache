Class User.PMPPermission Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PER_Rowid, SqlTableName = PMP_Permission, StorageStrategy = SQLStorage ]
{

Relationship ChildPMPPermisBusiness As PMPPermisBusiness [ Cardinality = children, Inverse = PMPPermissionParRef ];

/// PERDesc
Property PERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PER_Desc ];

/// PERLevel
Property PERLevel As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PER_Level ];

/// PERProjectDR
Property PERProjectDR As PMPProject [ SqlColumnNumber = 4, SqlFieldName = PER_Project_DR ];

/// PERTime
Property PERTime As %Time [ SqlColumnNumber = 5, SqlFieldName = PER_Time ];

/// PERDate
Property PERDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PER_Date ];

/// PERSpare2
Property PERSpare2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PER_Spare2 ];

/// PERSpare3
Property PERSpare3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PER_Spare3 ];

/// PERSpare4
Property PERSpare4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PER_Spare4 ];

/// PERSpare5
Property PERSpare5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PER_Spare5 ];

/// PERType
Property PERType As PMPDictionary3 [ SqlColumnNumber = 11, SqlFieldName = PER_Type ];

/// PERBY1
Property PERBY1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PER_BY1 ];

/// PERBY2
Property PERBY2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PER_BY2 ];

/// PERBY3
Property PERBY3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PER_BY3 ];

/// PERBY4
Property PERBY4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PER_BY4 ];

/// PERBY5
Property PERBY5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PER_BY5 ];

/// PERBY6
Property PERBY6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PER_BY6 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPPermission(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PER_BY1">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PER_BY2">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PER_BY3">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PER_BY4">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PER_BY5">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PER_BY6">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PER_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PER_Level">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PER_Project_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PER_Spare2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PER_Spare3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PER_Spare4">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PER_Spare5">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PER_Time">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PER_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PMPPermission</Global>
<Subscript name="1">
<Expression>{PER_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofPERDate">
<Global>^PMPPermissioni</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PER_Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PER_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PER_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPERLevel">
<Global>^PMPPermissioni</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PER_Level"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PER_Level}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PER_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofType">
<Global>^PMPPermissioni</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PER_Type}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PER_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPPermissionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
