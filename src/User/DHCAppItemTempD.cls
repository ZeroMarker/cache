Class User.DHCAppItemTempD Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AIT_RowID, SqlTableName = DHC_AppItemTempD, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On AITChlidSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppItemTemp Parent Reference AIT_Temp_ParRef
Relationship AITTempParRef As User.DHCAppItemTemp [ Cardinality = parent, Inverse = ChildDHCAPPITEMTEMPD, Required, SqlFieldName = AIT_Temp_ParRef ];

/// AIT_ChlidSub
Property AITChlidSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AIT_ChlidSub ];

/// 注意事项  AIT_Text 
Property AITText As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AIT_Text ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AIT_Text">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPITMTE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppItemTemp.AIT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>AIT_ChlidSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppItemTemp.AIT_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AIT_ChlidSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAppItemTempDS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
