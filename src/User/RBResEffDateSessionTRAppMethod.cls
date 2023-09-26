Class User.RBResEffDateSessionTRAppMethod Extends %Persistent [ SqlTableName = RB_ResEffDateSessionTRAppMethod, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STRAMChildSub [ IdKey, PrimaryKey, Unique ];

Relationship STRAMParRef As RBResEffDateSessionTR [ Cardinality = parent, Inverse = ChildRBResEffDateSessionTRAppMethod, Required, SqlFieldName = STRAM_ParRef ];

Property STRAMChildSub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"TR",$p($s($d(initvalue):initvalue,1:%d(0)),"||",4),"TRAM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = STRAM_ChildSub ];

Property STRAMMethodDR As RBCAppointMethod [ SqlColumnNumber = 3, SqlFieldName = STRAM_Method_DR ];

Property STRAMMaxQty As %Integer [ SqlColumnNumber = 4, SqlFieldName = STRAM_MaxQty ];

Property STRAMReserveQty As %Integer [ SqlColumnNumber = 5, SqlFieldName = STRAM_ReserveQty ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="STRAM_MaxQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STRAM_Method_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STRAM_ReserveQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>RB_ResEffDateSessionTR.STR_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="5">
<Expression>{L10}</Expression>
<Field>STRAM_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"TR"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RB_ResEffDateSessionTR.STR_Childsub}</Expression>
</Subscript>
<Subscript name="9">
<Expression>"TRAM"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{STRAM_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>STRAM_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessionTRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
