Class User.DHCAppArcTempPart Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATP_RowID, SqlTableName = DHC_AppArcTempPart, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ATPChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppArcTemp Parent Reference ATP_ParRef_Dr
Relationship ATPParRefDr As User.DHCAppArcTemp [ Cardinality = parent, Inverse = ChildDHCAPPARCTEMPPART, Required, SqlFieldName = ATP_ParRef_Dr ];

/// ATP_ChildSub
Property ATPChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ATP_ChildSub ];

/// 检查部位id  ATP_Part_Dr 
Property ATPPartDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = ATP_Part_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ATP_Part_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPATE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppArcTemp.ATE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ATP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppArcTemp.ATE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"P"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATP_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexPart">
<Global>^DHCAPATE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppArcTemp.ATE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ATP_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Part"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATP_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppArcTemp.ATE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATP_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcTempPartS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
