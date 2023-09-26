Class User.DHCStkSysCounter Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SSC_RowID, SqlTableName = DHC_StkSysCounter, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On SSCChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_StkSysApp Parent Reference
Relationship SSCSSAParref As User.DHCStkSysApp [ Cardinality = parent, Inverse = ChildDHCStkSysCounter, Required, SqlFieldName = SSC_SSA_Parref ];

Relationship ChildDHCStkSysCounterLoc As DHCStkSysCounterLoc [ Cardinality = children, Inverse = SSCLOCSSCParRef ];

/// SSC_ChildSub
Property SSCChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = SSC_ChildSub ];

/// SSC_Hosp
Property SSCHosp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = SSC_Hosp ];

/// SSC_Loc
Property SSCLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SSC_Loc ];

/// SSC_CatGrp
Property SSCCatGrp As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = SSC_CatGrp ];

/// SSC_Prefix
Property SSCPrefix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SSC_Prefix ];

/// SSC_Year
Property SSCYear As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = SSC_Year ];

/// SSC_Month
Property SSCMonth As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = SSC_Month ];

/// SSC_Day
Property SSCDay As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SSC_Day ];

/// SSC_NoLength
Property SSCNoLength As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SSC_NoLength ];

/// SSC_Desc
Property SSCDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = SSC_Desc ];

/// SSC_Suffix
Property SSCSuffix As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = SSC_Suffix ];

/// SSC_CurrentYear
Property SSCCurrentYear As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = SSC_CurrentYear ];

/// SSC_CurrentMonth
Property SSCCurrentMonth As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = SSC_CurrentMonth ];

/// SSC_CurrentDay
Property SSCCurrentDay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SSC_CurrentDay ];

/// SSC_CurrentNo
Property SSCCurrentNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SSC_CurrentNo ];

/// SSC_CountByLoc
Property SSCCountByLoc As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 17, SqlFieldName = SSC_CountByLoc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="MasterSysCounter">
<Data name="SSC_CatGrp">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SSC_CountByLoc">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SSC_CurrentDay">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SSC_CurrentMonth">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SSC_CurrentNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SSC_CurrentYear">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SSC_Day">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SSC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SSC_Hosp">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SSC_Loc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SSC_Month">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SSC_NoLength">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SSC_Prefix">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SSC_Suffix">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SSC_Year">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCSSA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_StkSysApp.SSA_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>SSC_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DHC_StkSysApp.SSA_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SSC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SSC_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCStkSysCounterS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
