Class User.DHCItmConflict Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ITC_Rowid, SqlTableName = DHC_ItmConflict, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ITCChildsub [ IdKey, PrimaryKey, Unique ];

/// DHC_ItmMast Parent Reference
Relationship ITCParRef As User.DHCItmMast [ Cardinality = parent, Inverse = ChildDHCItmConflict, Required, SqlFieldName = ITC_ParRef ];

/// ITC_Childsub
Property ITCChildsub As %Library.Float [ InitialExpression = {$i(^DHCItmMast($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CF",0))}, SqlColumnNumber = 2, SqlFieldName = ITC_Childsub ];

/// ITC_ConflicItm_DR
Property ITCConflictItmDR As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITC_ConflictItm_DR ];

/// 草药互斥类型
Property ITCConflictType As %String(DISPLAYLIST = ",Reverse,Fear", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",R,F") [ SqlColumnNumber = 4, SqlFieldName = ITC_ConflictType ];

/// 临时互斥类型(提示,禁止)(VALUELIST 越靠后控制级别更高,新增控制类型时请注意顺序)
Property ITCShortConflictType As %String(DISPLAYLIST = ",Day Tip,Adm Tip,Day Forbid,Adm Forbid", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",DT,AT,DF,AF") [ SqlColumnNumber = 5, SqlFieldName = ITC_ShortConflictType ];

/// 长期互斥类型(提示,停止,禁止)(VALUELIST 越靠后控制级别更高,新增控制类型时请注意顺序)
Property ITCLongConflictType As %String(DISPLAYLIST = ",Day Tip,Adm Tip,Stop,Day Forbid,Adm Forbid", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",DT,AT,S,DF,AF") [ SqlColumnNumber = 6, SqlFieldName = ITC_LongConflictType ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ITC_ConflictItm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITC_ConflictType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ITC_LongConflictType">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ITC_ShortConflictType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCItmMast</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_ItmMast.DARCIM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ITC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_ItmMast.DARCIM_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CF"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITC_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexArcim">
<Global>^DHCItmMast</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_ItmMast.DARCIM_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ITC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CFARCIM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ITC_ConflictItm_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ITC_ParRef}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ITC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCItmConflictS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
