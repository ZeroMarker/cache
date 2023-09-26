Class User.DHCAppRepDisp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepDisp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ARChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AppRepArc Parent Reference AR_ParRef_Dr
Relationship ARParRefDr As User.DHCAppRepArc [ Cardinality = parent, Inverse = ChildDHCAPPREPDISP, Required, SqlFieldName = AR_ParRef_Dr ];

/// AR_ChildSub
Property ARChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = AR_ChildSub ];

/// 后处理  AR_Disp_Dr 
Property ARDispDr As User.DHCAppDispMedthod [ SqlColumnNumber = 3, SqlFieldName = AR_Disp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="AR_Disp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_AppRepArc.AR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"AR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AppRepArc.AR_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DI"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDisp">
<Global>^DHCAPREP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_AppReport.AR_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_AppRepArc.AR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>AR_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Disp"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Disp_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_AppReport.AR_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_AppRepArc.AR_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{AR_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
