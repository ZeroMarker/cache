Class User.DHCAppPartItm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = API_RowID, SqlTableName = DHC_AppPartItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On APIChildSub [ IdKey, PrimaryKey, Unique ];

Relationship APIParRefDr As User.DHCAppPart [ Cardinality = parent, Inverse = ChildDHCAPPPARTITM, Required, SqlFieldName = API_ParRef_Dr ];

Property APIChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = API_ChildSub ];

Property APIPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = API_Part_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="API_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPPART</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppPart.AP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>API_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppPart.AP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{API_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppPartItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
