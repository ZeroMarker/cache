/// User.DHCICUShiftItem
Class User.DHCICUShiftItem Extends %Library.Persistent [ ProcedureBlock, SqlRowIdName = ICUSI_RowId, SqlTableName = DHC_ICU_ShiftItem, StorageStrategy = CacheSQLStorage ]
{

Relationship ICUSIParref As User.DHCICUShift [ Cardinality = parent, Inverse = ChildDHCICUShiftItem, Required, SqlFieldName = ICUSI_Parref ];

Index ICUSIChildSub On ICUSIChildSub [ IdKey, PrimaryKey, Unique ];

/// For P5 ///Property ICUSIChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange(+$s($d(p1):p1,1:%d(0)),"Shift",$p($p($s($d(p1):p1,1:%d(0)),$c(1)),"||",2),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUSI_ChildSub ];
Property ICUSIChildSub As %Numeric [ InitialExpression = {$i(^DHCICUArrange(+$s($d(initvalue):initvalue,1:%d(0)),"Shift",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"I",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ICUSI_ChildSub ];

Property ICUSIICUCSIDr As User.DHCICUCShiftItem [ SqlColumnNumber = 3, SqlFieldName = ICUSI_ICUCSI_Dr ];

Property ICUSIQty As %Float [ SqlColumnNumber = 4, SqlFieldName = ICUSI_Qty ];

Property ICUSINote As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = ICUSI_Note ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ICUSI_ICUCSI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ICUSI_Note">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ICUSI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCICUArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ICU_Arrange.ICUA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_ICU_Shift.ICUS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ICUSI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DHC_ICU_Arrange.ICUA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Shift"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_ICU_Shift.ICUS_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ICUSI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ICUSI_RowId</SqlRowIdName>
<StreamLocation>^User.DHCICUShiftItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
