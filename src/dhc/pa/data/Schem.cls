/// Schem
Class dhc.pa.data.Schem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Schem_rowid, SqlTableName = Schem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SchemchildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildSchemDetail As dhc.pa.data.SchemDetail [ Cardinality = children, Inverse = SchemDetailparRef ];

/// Schem_parRef
Relationship SchemparRef As dhc.pa.data.Stratagem [ Cardinality = parent, Inverse = ChildSchem, Required, SqlFieldName = Schem_parRef ];

/// Schem_childSub
Property SchemchildSub As %Library.Float [ InitialExpression = {$i(^DHCCJXPASTRATAGEM($p(%d(0),$c(1),1),"Schem",0))}, SqlColumnNumber = 2, SqlFieldName = Schem_childSub ];

/// Schem_code
Property Schemcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Schem_code ];

/// Schem_name
Property Schemname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Schem_name ];

/// Schem_shortcut
Property Schemshortcut As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Schem_shortcut ];

/// Schem_appSysDr
Property SchemappSysDr As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = Schem_appSysDr ];

/// Schem_frequency
Property Schemfrequency As %Library.String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Schem_frequency ];

/// Schem_KPIDr
/// Property SchemKPIDr As dhc.pa.data.KPIIndex1 [ SqlColumnNumber = 8, SqlFieldName = Schem_KPIDr ];
Property SchemKPIDr As %Library.String [ SqlColumnNumber = 8, SqlFieldName = Schem_KPIDr ];

/// Schem_desc
Property Schemdesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Schem_desc ];

/// Schem_active
Property Schemactive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = Schem_active ];

/// Schem_level
Property Schemlevel As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = Schem_level ];

/// Schem_ComputeType 处理方式 1-现有处理方式  2-护理处理方式
Property SchemComputeType As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = Schem_ComputeType ];

/// Schem_UpSchemDr 上级方案
Property SchemUpSchemDr As %Library.String [ SqlColumnNumber = 15, SqlFieldName = Schem_UpSchemDr ];

/// Schem_flag 是否为调查问卷 2013年7月15日添加 
Property SchemFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = Schem_flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="Schem_ComputeType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="Schem_KPIDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Schem_UpSchemDr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="Schem_active">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="Schem_appSysDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="Schem_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="Schem_desc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="Schem_flag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="Schem_frequency">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="Schem_level">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="Schem_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Schem_shortcut">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCJXPASTRATAGEM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Schem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSchemAppSys">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemAppSys"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem_appSysDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemCode">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemFrequency">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemFrequency"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem_frequency}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemKPI">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemKPI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem_KPIDr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchemName">
<Global>^DHCCJXPASTRATAGEM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>Stratagem.Stratagem_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>Schem_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SchemName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Stratagem.Stratagem_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{Schem_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{Schem_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.pa.data.SchemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
