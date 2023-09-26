Class User.DHCAdvReportCat Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ARC_RowID, SqlTableName = DHC_AdvReportCat, StorageStrategy = SQLStorage ]
{

/// 报告类别 ARC_Type_Dr
Property ARCTypeDr As User.DHCMedAdrRepType [ SqlColumnNumber = 2, SqlFieldName = ARC_Type_Dr ];

/// 报告id ARC_Pointer 
Property ARCPointer As %String [ SqlColumnNumber = 3, SqlFieldName = ARC_Pointer ];

/// 分类 ARC_Cat_Dr
Property ARCCatDr As User.DHCAdvMedRepCat [ SqlColumnNumber = 4, SqlFieldName = ARC_Cat_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCADVREPC)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ARC_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ARC_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ARC_Type_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCADVREPC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ARC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="TypePointerIndex">
<Global>^DHCADVREPC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ARC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ARC_Type_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ARC_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ARC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAdvReportCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
