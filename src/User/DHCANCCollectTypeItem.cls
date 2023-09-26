Class User.DHCANCCollectTypeItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = ANCCTI_RowId, SqlTableName = DHC_ANC_CollectTypeItem, StorageStrategy = CacheSQLStorage ]
{

Relationship ANCCTIParref As User.DHCANCCollectType [ Cardinality = parent, Inverse = ChildDHCANCCollectTypeItem, SqlFieldName = ANCCTI_Parref ];

Index RowIDBasedIDKeyIndex On ANCCTIChildSub [ IdKey, Unique ];

/// For P5 ///Property ANCCTIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANC("CType",$p($s($d(p1):p1,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANCCTI_ChildSub ];
Property ANCCTIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANC("CType",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANCCTI_ChildSub ];

Property ANCCTIComOrdDr As %String [ SqlColumnNumber = 3, SqlFieldName = ANCCTI_ComOrd_Dr ];

Property ANCCTIChannelNo As %String [ SqlColumnNumber = 4, SqlFieldName = ANCCTI_ChannelNo ];

Property ANCCTIActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = ANCCTI_Active ];

Storage CacheSQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANCCTI_Active">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCCTI_ChannelNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCCTI_ComOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_ANC_CollectType.ANCCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ANCCTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_ANC_CollectType.ANCCT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCCTI_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChannelNo">
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DHC_ANC_CollectType.ANCCT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>ANCCTI_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"CType"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ChannelNo"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCCTI_ChannelNo}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_ANC_CollectType.ANCCT_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ANCCTI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCANCCollectTypeItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

Storage CacheStorage
{
}

}
