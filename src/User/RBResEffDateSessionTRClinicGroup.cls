Class User.RBResEffDateSessionTRClinicGroup Extends %Persistent [ SqlTableName = RB_ResEffDateSessionTRClinicGroup, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STRCGChildSub [ IdKey, PrimaryKey, Unique ];

Relationship STRCGParRef As RBResEffDateSessionTR [ Cardinality = parent, Inverse = ChildRBResEffDateSessionTRClinicGroup, Required, SqlFieldName = STRCG_ParRef ];

Property STRCGChildSub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"TR",$p($s($d(initvalue):initvalue,1:%d(0)),"||",4),"TRCG",0))}, Required, SqlColumnNumber = 2, SqlFieldName = STRCG_ChildSub ];

Property STRCGClinicGroupDR As RBCClinicGroup [ SqlColumnNumber = 3, SqlFieldName = STRCG_ClinicGroup_DR ];

Property STRCGQty As %Integer [ SqlColumnNumber = 4, SqlFieldName = STRCG_Qty ];

Storage SQLStorage
{
<SQLMap name="MasterMap">
<Data name="STRCG_ClinicGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="STRCG_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RB</Global>
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
<Field>STRCG_ChildSub</Field>
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
<Expression>"TRCG"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{STRCG_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.RBResEffDat92FBS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
