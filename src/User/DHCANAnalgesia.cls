///  DHC_AN_Analgesia
Class User.DHCANAnalgesia Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PAA_RowId, SqlTableName = DHC_AN_Analgesia, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PAAChildSub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCANAnalgesiaDrug As User.DHCANAnalgesiaDrug [ Cardinality = children, Inverse = PAADParref ];

/// DHC_AN_OPArrange Parent Reference
Relationship PAAParref As User.DHCANOPArrange [ Cardinality = parent, Inverse = ChildDHCANAnalgesia, Required, SqlFieldName = PAA_Parref ];

//Property PAAChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(p1):p1,1:%d(0)),$c(1),1),"PAA",0))}, SqlColumnNumber = 2, SqlFieldName = PAA_ChildSub ];

//  For P8

/// PAA_ChildSub
Property PAAChildSub As %Library.Float [ InitialExpression = {$i(^DHCANOPArrange($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"PAA",0))}, SqlColumnNumber = 2, SqlFieldName = PAA_ChildSub ];

/// PAA_Type
Property PAAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PAA_Type ];

/// PAA_PumpSpec
Property PAAPumpSpec As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PAA_PumpSpec ];

/// PAA_BodySite
Property PAABodySite As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PAA_BodySite ];

/// PAA_StartDate
Property PAAStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = PAA_StartDate ];

/// PAA_StartTime
Property PAAStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PAA_StartTime ];

/// PAA_EndDate
Property PAAEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PAA_EndDate ];

/// PAA_EndTime
Property PAAEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PAA_EndTime ];

/// PAA_LockTime
Property PAALockTime As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PAA_LockTime ];

/// PAA_BackgroundDose
Property PAABackgroundDose As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PAA_BackgroundDose ];

/// PAA_PCADose
Property PAAPCADose As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PAA_PCADose ];

/// PAA_TotalAmount
Property PAATotalAmount As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PAA_TotalAmount ];

/// PAA_DispenseCtcp_Dr
Property PAADispenseCtcpDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PAA_DispenseCtcp_Dr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PAA_BackgroundDose">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PAA_BodySite">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PAA_DispenseCtcp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PAA_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PAA_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PAA_LockTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PAA_PCADose">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PAA_PumpSpec">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PAA_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PAA_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PAA_TotalAmount">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PAA_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCANOPArrange</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_AN_OPArrange.OPA_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAA_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_AN_OPArrange.OPA_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAA"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAA_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCANAnalgesiaS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
