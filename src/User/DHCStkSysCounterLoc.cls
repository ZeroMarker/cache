Class User.DHCStkSysCounterLoc Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = SSCLOC_RowId, SqlTableName = DHC_StkSysCounterLoc, StorageStrategy = SqlStorage ]
{

Index RowIDBasedIDKeyIndex On SSCLOCChildSub [ IdKey, PrimaryKey, Unique ];

/// SSCLOC_SSC_ParRef
Relationship SSCLOCSSCParRef As User.DHCStkSysCounter [ Cardinality = parent, Inverse = ChildDHCStkSysCounterLoc, Required, SqlFieldName = SSCLOC_SSC_ParRef ];

/// SSCLOC_ChildSub
Property SSCLOCChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^DHCSSA($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"SSC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = SSCLOC_ChildSub ];

/// SSCLOC_CTLOC_DR
Property SSCLOCCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = SSCLOC_CTLOC_DR ];

/// SSCLOC_CurrentYear
Property SSCLOCCurrentYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SSCLOC_CurrentYear ];

/// SSCLOC_CurrentMonth
Property SSCLOCCurrentMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = SSCLOC_CurrentMonth ];

/// SSCLOC_CurrentDay
Property SSCLOCCurrentDay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SSCLOC_CurrentDay ];

/// SSCLOC_CurrentNo
Property SSCLOCCurrentNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SSCLOC_CurrentNo ];

/// SSCLOC_CurrentInfo
Property SSCLOCCurrentInfo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SSCLOC_CurrentInfo ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SSCLOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSCLOC_CurrentDay">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSCLOC_CurrentInfo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSCLOC_CurrentMonth">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSCLOC_CurrentNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SSCLOC_CurrentYear">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_StkSysCounter.SSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>DHC_StkSysCounterLoc.SSCLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SSC"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{DHC_StkSysCounter.SSC_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{SSCLOC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInfo">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_StkSysCounter.SSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SSCLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Info"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSCLOC_CurrentInfo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_StkSysCounter.SSC_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SSCLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCSSA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DHC_StkSysCounter.SSC_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SSCLOC_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSCLOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHC_StkSysCounter.SSC_ChildSub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SSCLOC_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SSCLOC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStkSysCounterLocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
