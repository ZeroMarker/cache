/// DHC_AN_OPCount
Class User.DHCANOPCount Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANOPC_RowId, SqlTableName = DHC_AN_OPCount, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANOPCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_OPArrange Parent Reference
Relationship ANOPCParref As User.DHCANOPArrange [ Cardinality = parent, Inverse = ChildDHCANOPCount, Required, SqlFieldName = ANOPC_Parref ];

//Property ANOPCChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"OPCount",0))}, SqlColumnNumber = 2, SqlFieldName = ANOPC_ChildSub ];

//  For P8

/// ANOPC_ChildSub
Property ANOPCChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"OPCount",0))}, SqlColumnNumber = 2, SqlFieldName = ANOPC_ChildSub ];

/// ANOPC_OPCount_Dr
Property ANOPCOPCountDr As User.DHCANCOPCount [ SqlColumnNumber = 3, SqlFieldName = ANOPC_OPCount_Dr ];

/// ANOPC_PreOperNum
Property ANOPCPreOperNum As %String [ SqlColumnNumber = 4, SqlFieldName = ANOPC_PreOperNum ];

/// ANOPC_AddNum
Property ANOPCAddNum As %String [ SqlColumnNumber = 5, SqlFieldName = ANOPC_AddNum ];

/// ANOPC_UnSewNum
Property ANOPCUnSewNum As %String [ SqlColumnNumber = 6, SqlFieldName = ANOPC_UnSewNum ];

/// ANOPC_SewedNum
Property ANOPCSewedNum As %String [ SqlColumnNumber = 7, SqlFieldName = ANOPC_SewedNum ];

Property ANOPCNote As %String [ SqlColumnNumber = 8, SqlFieldName = ANOPC_Note ];

/// 20141011new
Property ANOPCPackageNo As %String [ SqlColumnNumber = 9, SqlFieldName = ANOPC_PackageNo ];

Property ANOPCINCIDr As %String [ SqlColumnNumber = 10, SqlFieldName = ANOPC_INCI_Dr ];

Property ANOPCOPCountTypeDr As DHCANCOPCountType [ SqlColumnNumber = 11, SqlFieldName = ANOPC_OPCountType_Dr ];

/// ANOPC_OriginalNum
Property ANOPCOriginalNum As %String [ SqlColumnNumber = 12, SqlFieldName = ANOPC_OriginalNum ];

/// ANOPC_Conditon
Property ANOPCConditon As %String [ SqlColumnNumber = 13, SqlFieldName = ANOPC_Conditon ];

/// ANOPC_SkinSewedNum
Property ANOPCSkinSewedNum As %String [ SqlColumnNumber = 14, SqlFieldName = ANOPC_SkinSewedNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANOPC_AddNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANOPC_Conditon">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ANOPC_INCI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ANOPC_Note">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANOPC_OPCountType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ANOPC_OPCount_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANOPC_OriginalNum">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ANOPC_PackageNo">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANOPC_PreOperNum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANOPC_SewedNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANOPC_SkinSewedNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ANOPC_UnSewNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ANOPC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OPCount"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ANOPC_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANOPCountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
