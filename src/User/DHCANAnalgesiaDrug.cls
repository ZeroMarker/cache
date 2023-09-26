/// DHC_AN_AnalgesiaDrug
Class User.DHCANAnalgesiaDrug Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAAD_RowId, SqlTableName = DHC_AN_AnalgesiaDrug, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PAADChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_AN_Analgesia Parent Reference
Relationship PAADParref As User.DHCANAnalgesia [ Cardinality = parent, Inverse = ChildDHCANAnalgesiaDrug, Required, SqlFieldName = PAAD_Parref ];

//  For P8

/// PAAD_ChildSub
Property PAADChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange(+$s($d(initvalue):initvalue,1:%d(0)),"PAA",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"||",2),"D",0))}, SqlColumnNumber = 2, SqlFieldName = PAAD_ChildSub ];

/// PAAD_Arcim_Dr
Property PAADArcimDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = PAAD_Arcim_Dr ];

/// PAAD_Density
Property PAADDensity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PAAD_Density ];

/// PAAD_Uom
Property PAADUom As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PAAD_Uom ];

/// PAAD_Dose
Property PAADDose As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PAAD_Dose ];

/// PAAD_StartDate
Property PAADStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = PAAD_StartDate ];

/// PAAD_StartTime
Property PAADStartTime As %Library.Time [ SqlColumnNumber = 8, SqlFieldName = PAAD_StartTime ];

/// PAAD_EndDate
Property PAADEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = PAAD_EndDate ];

/// PAAD_EndTime
Property PAADEndTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = PAAD_EndTime ];

/// 20141011new
Property PAADRecCtloc As %String [ SqlColumnNumber = 11, SqlFieldName = PAAD_RecCtloc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAAD_Arcim_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PAAD_Density">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAAD_Dose">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAAD_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAAD_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAAD_RecCtloc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAAD_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAAD_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAAD_Uom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DHC_AN_Analgesia.PAA_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>PAAD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHC_AN_Analgesia.PAA_ChildSub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"D"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PAAD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANAnalgesiaDrugS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
