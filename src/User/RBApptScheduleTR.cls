Class User.RBApptScheduleTR Extends %Persistent [ SqlTableName = RB_ApptScheduleTR, StorageStrategy = SQLStorage ]
{

Relationship ChildRBApptScheduleTRAppMethod As RBApptScheduleTRAppMethod [ Cardinality = children, Inverse = ASTRAMParRef ];

Relationship ChildRBApptScheduleTRClinicGroup As RBApptScheduleTRClinicGroup [ Cardinality = children, Inverse = ASTRCGParRef ];

Index RowIDBasedIDKeyIndex On ASTRChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ASTRParRef As RBApptSchedule [ Cardinality = parent, Inverse = ChildRBApptScheduleTR, Required, SqlFieldName = ASTR_ParRef ];

Property ASTRChildSub As %Float [ InitialExpression = {$i(^RBAS($p($s($d(initvalue):initvalue,1:%d(0)),"||"),$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ASTR",0))}, Required, SqlColumnNumber = 2, SqlFieldName = ASTR_ChildSub ];

Property ASTRSttTime As %Time [ SqlColumnNumber = 3, SqlFieldName = ASTR_SttTime ];

Property ASTREndTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ASTR_EndTime ];

Property ASTRLoad As %Integer [ SqlColumnNumber = 5, SqlFieldName = ASTR_Load ];

Property ASTRQueueNo As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = ASTR_QueueNo ];

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="ASTR_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ASTR_Load">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ASTR_QueueNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ASTR_SttTime">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>ASTR_ChildSub</Field>
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
<Expression>{ASTR_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ASTR_RowId</SqlRowIdName>
<StreamLocation>^User.RBApptScheduleTRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
