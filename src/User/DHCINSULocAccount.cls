Class User.DHCINSULocAccount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INSULA_RowId, SqlTableName = DHC_INSULocAccount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On INSULAChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_INSULocInfo Parent Reference
Relationship INSULAINLOCParRef As User.DHCINSULocInfo [ Cardinality = parent, Inverse = ChildDHCINSULocAccount, Required, SqlFieldName = INSULA_INLOC_ParRef ];

/// INSULA_ChildSub
Property INSULAChildSub As %Library.Float [ InitialExpression = {$i(^DHCINLOC($p(%d(0),$c(1),1),"A",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INSULA_ChildSub ];

/// INSULA_Amount
Property INSULAAmount As %Library.Float [ SqlColumnNumber = 3, SqlFieldName = INSULA_Amount ];

/// INSULA_iDate
Property INSULAiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = INSULA_iDate ];

/// INSULA_iTime
Property INSULAiTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = INSULA_iTime ];

/// INSULA_UserId
Property INSULAUserId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INSULA_UserId ];

/// INSULA_AccType
Property INSULAAccType As %Library.String(DISPLAYLIST = ",Recharge,Consume,IcCard", MAXLEN = 8, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",R,C,I") [ SqlColumnNumber = 7, SqlFieldName = INSULA_AccType ];

/// INSULA_Demo1
Property INSULADemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INSULA_Demo1 ];

/// INSULA_Demo2
Property INSULADemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INSULA_Demo2 ];

/// INSULA_Demo3
Property INSULADemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INSULA_Demo3 ];

/// INSULA_Demo4
Property INSULADemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INSULA_Demo4 ];

/// INSULA_Demo5
Property INSULADemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INSULA_Demo5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="INSULA_AccType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INSULA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INSULA_ChildSub">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INSULA_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INSULA_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INSULA_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INSULA_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INSULA_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INSULA_INLOC_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INSULA_UserId">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INSULA_iDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INSULA_iTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCINLOC</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_INSULocInfo.INLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INSULA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHC_INSULocInfo.INLOC_RowID}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSULA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAccUserDr">
<Global>^DHCINLOC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_INSULocInfo.INLOC_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INSULA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AccUserDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INSULA_UserId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DHC_INSULocInfo.INLOC_RowID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INSULA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCINSULocAccountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
