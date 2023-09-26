Class User.DHCAppArcTemp Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ATE_RowID, SqlTableName = DHC_AppArcTemp, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCAPPARCTEMPPART As User.DHCAppArcTempPart [ Cardinality = children, Inverse = ATPParRefDr ];

Relationship ChildDHCAPPARCTEMPDISP As User.DHCAppArcTempDisp [ Cardinality = children, Inverse = ATDParRefDr ];

/// 保存模式  ATE_SaveFor
Property ATESaveFor As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ATE_SaveFor ];

/// 指针  ATE_Pointer
Property ATEPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ATE_Pointer ];

/// 检查分类id  ATE_Cat_Dr
Property ATECatDr As User.DHCAppArcCat [ SqlColumnNumber = 4, SqlFieldName = ATE_Cat_Dr ];

/// 医嘱项id  ATE_Arc_Dr
Property ATEArcDr As User.ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = ATE_Arc_Dr ];

/// 体位id  ATE_Pos_Dr
Property ATEPosDr As User.DHCAppPosition [ SqlColumnNumber = 6, SqlFieldName = ATE_Pos_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCAPATE)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ATE_Arc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ATE_Cat_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ATE_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ATE_Pos_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ATE_SaveFor">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCAPATE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ATE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{ATE_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexArc">
<Global>^DHCAPATE</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ATE_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Arc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ATE_Arc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ATE_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppArcTempS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
