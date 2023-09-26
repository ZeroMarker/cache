Class User.PMPPermisBusiness Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PERBus_rowid, SqlTableName = PMP_PermisBusiness, StorageStrategy = NewStorage1 ]
{

Index RowIDBasedIDKeyIndex On PERBusChildsub [ IdKey, PrimaryKey, Unique ];

/// DataLevelSets Parent Reference
Relationship PMPPermissionParRef As User.PMPPermission [ Cardinality = parent, Inverse = ChildPMPPermisBusiness, Required, SqlFieldName = PMP_Permission_ParRef ];

/// LevelItems_childSub
Property PERBusChildsub As %Library.Float [ InitialExpression = {$i(^PMPPermisBusiness($p(%d(0),$c(1),1),"E",0))}, SqlColumnNumber = 2, SqlFieldName = PERBus_Childsub ];

/// PERBusUserDR
Property PERBusUserDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PERBus_User_DR ];

/// PERBusIsEffect
Property PERBusIsEffect As %Library.String(DISPLAYLIST = ",有效,无效", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PERBus_IsEffect ];

/// PERBusDate
Property PERBusDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PERBus_Date ];

/// PERBusTime
Property PERBusTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PERBus_Time ];

/// PERBusSpare1
Property PERBusSpare1 As RBCDepartmentGroup [ SqlColumnNumber = 7, SqlFieldName = PERBus_Spare1 ];

/// PERBusSpare2
Property PERBusSpare2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PERBus_Spare2 ];

/// PERBusSpare3
Property PERBusSpare3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PERBus_Spare3 ];

/// PERBusSpare4
Property PERBusSpare4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PERBus_Spare4 ];

/// PERBusSpare5
Property PERBusSpare5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PERBus_Spare5 ];

/// PERBusSpare6
Property PERBusSpare6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PERBus_Spare6 ];

/// PERBusSpare7
Property PERBusSpare7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = PERBus_Spare7 ];

/// PERBusSpare8
Property PERBusSpare8 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PERBus_Spare8 ];

/// PERBusSpare9
Property PERBusSpare9 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PERBus_Spare9 ];

/// PERBusSpare10
Property PERBusSpare10 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = PERBus_Spare10 ];

/// PERBusSpare11
Property PERBusSpare11 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = PERBus_Spare11 ];

/// PERBusSpare12
Property PERBusSpare12 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = PERBus_Spare12 ];

Storage NewStorage1
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPPermisBusiness(0))</SqlIdExpression>
<SQLMap name="IndexofLocType">
<Global>^PMPPermisBusinessi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"LocType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Permission.PER_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PERBus_Spare1}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PERBus_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPERDate">
<Global>^PMPPermisBusinessi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"PERBusDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Permission.PER_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PERBus_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PERBus_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPERUserDr">
<Global>^PMPPermisBusinessi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"PERBusUserDr"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_Permission.PER_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PERBus_User_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PERBus_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUserid">
<Global>^PMPPermisBusinessi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PERBus_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_Permission.PER_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PERBus_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapDast">
<Data name="PERBus_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PERBus_IsEffect">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PERBus_Spare1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PERBus_Spare10">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PERBus_Spare11">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PERBus_Spare12">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PERBus_Spare2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PERBus_Spare3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PERBus_Spare4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PERBus_Spare5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PERBus_Spare6">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PERBus_Spare7">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PERBus_Spare8">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PERBus_Spare9">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PERBus_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PERBus_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PMPPermisBusiness</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_Permission.PER_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PERBus_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_Permission.PER_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"E"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PERBus_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.PMPPermisBusinessS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
