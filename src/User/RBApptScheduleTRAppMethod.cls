Class User.RBApptScheduleTRAppMethod Extends %Persistent [ SqlTableName = RB_ApptScheduleTRAppMethod, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASTRAMChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ASTRAMParRef As RBApptScheduleTR [ Cardinality = parent, Inverse = ChildRBApptScheduleTRAppMethod, Required, SqlFieldName = ASTRAM_ParRef ];

Property ASTRAMChildSub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ASTR",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"TRAM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASTRAM_ChildSub ];

Property ASTRAMMethodDR As RBCAppointMethod [ SqlColumnNumber = 3, SqlFieldName = ASTRAM_Method_DR ];

Property ASTRAMMaxQty As %Integer [ SqlColumnNumber = 4, SqlFieldName = ASTRAM_MaxQty ];

Property ASTRAMReserveQty As %Integer [ SqlColumnNumber = 5, SqlFieldName = ASTRAM_ReserveQty ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ASTRAM_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASTRAM_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASTRAM_ReserveQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RBAS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>RB_ApptSchedule.AS_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>RB_ApptScheduleTR.ASTR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L6}</Expression>
<Field>ASTRAM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_ApptSchedule.AS_ChildSub}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ASTR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ApptScheduleTR.ASTR_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"TRAM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ASTRAM_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASTRAM_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptSched6857S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
