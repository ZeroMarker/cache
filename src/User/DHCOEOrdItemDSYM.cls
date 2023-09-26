Class User.DHCOEOrdItemDSYM Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = OEORDS_RowId, SqlTableName = DHC_OE_OrdItemDSYM, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On (OEORDSOEORIParRef, OEORDSOEORIChildsub, OEORDSChildsub) [ IdKey, PrimaryKey, Unique ];

Property OEORDSChildsub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^OEORD($s($d(p1):p1,1:%d(2)),"I",$s($d(p2):p2,1:%d(3)),"DSYM",0))}, Required, SqlColumnNumber = 4, SqlFieldName = OEORDS_Childsub ];

Property OEORDSDSYMCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = OEORDS_DSYMCode ];

/// 适应症RowId  MRC_DiagnosSignSymptom 
Property OEORDSDSYMDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = OEORDS_DSYM_DR ];

Property OEORDSOEORIChildsub As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = OEORDS_OEORI_Childsub ];

Property OEORDSOEORIParRef As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = OEORDS_OEORI_ParRef ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="indexSignSymptom">
<Global>^OEORDi</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DSYMCode"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORDS_OEORI_ParRef}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OEORDS_DSYMCode}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORDS_OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OEORDS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="master">
<Data name="OEORDS_DSYMCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OEORDS_DSYM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OEORDS_OEORI_ParRef</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OEORDS_OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>OEORDS_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{OEORDS_OEORI_ParRef}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OEORDS_OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DSYM"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OEORDS_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>OEORDS_RowId</SqlRowIdName>
<StreamLocation>^User.DHCOEOrdItemDSYMS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
