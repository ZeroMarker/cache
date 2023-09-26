Class User.RBApptScheduleTRClinicGroup Extends %Persistent [ SqlTableName = RB_ApptScheduleTRClinicGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ASTRCGChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ASTRCGParRef As RBApptScheduleTR [ Cardinality = parent, Inverse = ChildRBApptScheduleTRClinicGroup, Required, SqlFieldName = ASTRCG_ParRef ];

Property ASTRCGChildSub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ASTR",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"TRCG",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASTRCG_ChildSub ];

Property ASTRCGClinicGroupDR As RBCClinicGroup [ SqlColumnNumber = 3, SqlFieldName = ASTRCG_ClinicGroup_DR ];

Property ASTRCGQty As %Integer [ SqlColumnNumber = 4, SqlFieldName = ASTRCG_Qty ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ASTRCG_ClinicGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ASTRCG_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
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
<Field>ASTRCG_ChildSub</Field>
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
<Expression>"TRCG"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ASTRCG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.RBApptSched6A5AS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
