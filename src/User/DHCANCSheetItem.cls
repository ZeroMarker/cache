/// DHC_ANC_SheetItem
Class User.DHCANCSheetItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ANCSHI_RowId, SqlTableName = DHC_ANC_SheetItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On ANCSHIChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_ANC_Sheet Parent Reference
Relationship ANCSHIParref As User.DHCANCSheet [ Cardinality = parent, Inverse = ChildDHCANCSheetItem, Required, SqlFieldName = ANCSHI_Parref ];

//  For P8

/// ANCSHI_ChildSub
Property ANCSHIChildSub As %Library.Float [ InitialExpression = {$i(^DHCANC("Sheet",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"I",0))}, SqlColumnNumber = 2, SqlFieldName = ANCSHI_ChildSub ];

/// ANCSHI_OpMon_Dr
Property ANCSHIMDataItemDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ANCSHI_MDataItem_Dr ];

/// ANCSHI_AnOrd_Dr
Property ANCSHIAnOrdDr As User.DHCANCCommonOrd [ SqlColumnNumber = 4, SqlFieldName = ANCSHI_AnOrd_Dr ];

/// ANCSHI_Arcim_Dr
Property ANCSHIArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ANCSHI_Arcim_Dr ];

/// ANCSHI_Source
Property ANCSHISource As %Library.String(DISPLAYLIST = ",Instrument,Manual", MAXLEN = 10, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",I,M") [ SqlColumnNumber = 6, SqlFieldName = ANCSHI_Source ];

/// ANCSHI_Icon_Dr
Property ANCSHIIconDr As User.DHCANCIcon [ SqlColumnNumber = 7, SqlFieldName = ANCSHI_Icon_Dr ];

/// ANCSHI_SeqNo
Property ANCSHISeqNo As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = ANCSHI_SeqNo ];

/// ANCSHI_ContinueFlag
Property ANCSHIContinueFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = ANCSHI_ContinueFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ANCSHI_AnOrd_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ANCSHI_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ANCSHI_ContinueFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ANCSHI_Icon_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ANCSHI_MDataItem_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANCSHI_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ANCSHI_Source">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCANC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DHC_ANC_Sheet.ANCSH_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ANCSHI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Sheet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DHC_ANC_Sheet.ANCSH_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ANCSHI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANCSheetItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
