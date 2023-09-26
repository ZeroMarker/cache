Class User.DHCStkCatSubGrp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCSG_RowId, SqlTableName = DHC_StkCatSubGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SCSGChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkCatGroup Parent Reference
Relationship SCSGSCGParRef As User.DHCStkCatGroup [ Cardinality = parent, Inverse = ChildDHCStkCatSubGrp, Required, SqlFieldName = SCSG_SCG_ParRef ];

/// SCSG_ChildSub
Property SCSGChildSub As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = SCSG_ChildSub ];

/// SCSG_Code
Property SCSGCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SCSG_Code ];

/// SCSG_Desc
Property SCSGDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SCSG_Desc ];

/// SCSG_BackUp
Property SCSGBackUp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SCSG_BackUp ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterMap">
<Data name="SCSG_BackUp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCSG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCSG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSCG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkCatGroup.SCG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SCSG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_StkCatGroup.SCG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"S"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SCSG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkCatSubGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
