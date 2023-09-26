Class User.DHCEQCServiceItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SI_RowID, SqlTableName = DHC_EQCServiceItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SI_Desc
Property SIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SI_Desc ];

/// SI_Code
Property SICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SI_Code ];

/// SI_UnitDR
Property SIUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SI_UnitDR ];

/// SI_Price
Property SIPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SI_Price ];

/// SI_ExType
Property SIExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SI_ExType ];

/// SI_ExID
Property SIExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SI_ExID ];

/// SI_Remark
Property SIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SI_Remark ];

/// SI_ImportFlag
Property SIImportFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SI_ImportFlag ];

/// SI_MinMinutes
Property SIMinMinutes As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = SI_MinMinutes ];

/// SI_MinutesPerTimes
Property SIMinutesPerTimes As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SI_MinutesPerTimes ];

/// SI_MaxMinutes
Property SIMaxMinutes As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SI_MaxMinutes ];

/// SI_InvalidFlag
Property SIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SI_InvalidFlag ];

/// SI_UpdateDate
Property SIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = SI_UpdateDate ];

/// SI_ExDesc
Property SIExDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SI_ExDesc ];

/// SI_SingleFlag
Property SISingleFlag As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = SI_SingleFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCServiceItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SI_ExDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SI_ExID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SI_ExType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SI_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SI_MaxMinutes">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SI_MinMinutes">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SI_MinutesPerTimes">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SI_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SI_SingleFlag">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="SI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCServiceItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>SI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCServiceItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ExID"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SI_ExType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SI_ExID}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{SI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCServiceItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
