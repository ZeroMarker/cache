Class User.DHCAppArcTempDisp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATD_RowID, SqlTableName = DHC_AppArcTempDisp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ATDChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppArcTemp Parent Reference ATD_ParRef_Dr
Relationship ATDParRefDr As User.DHCAppArcTemp [ Cardinality = parent, Inverse = ChildDHCAPPARCTEMPDISP, Required, SqlFieldName = ATD_ParRef_Dr ];

/// ATD_ChildSub
Property ATDChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = ATD_ChildSub ];

/// 检查部位id  ATD_Disp_Dr 
Property ATDDispDr As User.DHCAppPart [ SqlColumnNumber = 3, SqlFieldName = ATD_Disp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ATD_Disp_Dr">
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
<Field>ATD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppArcTemp.ATE_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATD_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDisp">
<Global>^DHCAPATE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppArcTemp.ATE_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ATD_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Disp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATD_Disp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppArcTemp.ATE_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ATD_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcTempDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
