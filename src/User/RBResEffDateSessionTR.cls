Class User.RBResEffDateSessionTR Extends %Persistent [ SqlTableName = RB_ResEffDateSessionTR, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On STRChildsub [ IdKey, PrimaryKey, Unique ];

Relationship STRParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessionTR, Required, SqlFieldName = STR_ParRef ];

Relationship ChildRBResEffDateSessionTRAppMethod As RBResEffDateSessionTRAppMethod [ Cardinality = children, Inverse = STRAMParRef ];

Relationship ChildRBResEffDateSessionTRClinicGroup As RBResEffDateSessionTRClinicGroup [ Cardinality = children, Inverse = STRCGParRef ];

Property STRChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"TR",0))}, SqlColumnNumber = 2, SqlFieldName = STR_Childsub ];

Property STRSttTime As %Time [ SqlColumnNumber = 3, SqlFieldName = STR_SttTime ];

Property STREndTime As %Time [ SqlColumnNumber = 4, SqlFieldName = STR_EndTime ];

Property STRLoad As %Integer [ SqlColumnNumber = 5, SqlFieldName = STR_Load ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="STR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="STR_Load">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="STR_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>STR_Childsub</Field>
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
<Expression>{STR_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>STR_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessionTRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
