Class dhc.ca.cache.data.OutDepts Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OutDepts_rowid, SqlTableName = OutDepts, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On OutDeptschildSub [ IdKey, PrimaryKey, Unique ];

/// InDepts Parent Reference
Relationship OutDeptsparRef As dhc.ca.cache.data.InDepts [ Cardinality = parent, Inverse = ChildOutDepts, Required, SqlFieldName = OutDepts_parRef ];

/// OutDepts_childSub
Property OutDeptschildSub As %Library.Float [ InitialExpression = {$i(^DHCCAINDEPTSETS($p(%d(0),"||"),"In",$p(%d(0),"||",2),"Out",0))}, SqlColumnNumber = 2, SqlFieldName = OutDepts_childSub ];

/// OutDepts_order
Property OutDeptsorder As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = OutDepts_order ];

/// OutDepts_code
Property OutDeptscode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = OutDepts_code ];

/// OutDepts_name
Property OutDeptsname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = OutDepts_name ];

/// OutDepts_remark
Property OutDeptsremark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = OutDepts_remark ];

/// OutDepts_patType
Property OutDeptspatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = OutDepts_patType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMast">
<Data name="OutDepts_code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OutDepts_name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OutDepts_order">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OutDepts_patType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OutDepts_remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCCAINDEPTSETS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>InDepts.InDepts_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OutDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"In"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDepts.InDepts_childSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Out"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutDepts_childSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOutCode">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDepts.InDepts_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OutDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Outcode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutDepts_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDepts.InDepts_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutCodePattype">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDepts.InDepts_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>OutDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutCodePattype"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutDepts_code}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDepts.InDepts_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutDepts_patType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{OutDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutName">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>InDepts.InDepts_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OutDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutName"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OutDepts_name}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{InDepts.InDepts_childSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutOrder">
<Global>^DHCCAINDEPTSETS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>InDeptSets.InDeptSets_rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>InDepts.InDepts_childSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>OutDepts_childSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutOrder"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{InDeptSets.InDeptSets_rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{InDepts.InDepts_childSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OutDepts_order}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OutDepts_childSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^dhc.ca.c.OutDeptsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
