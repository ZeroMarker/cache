Class User.DHCEQCServDetItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SDI_RowID, SqlTableName = DHC_EQCServDetItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// SDI_Code
Property SDICode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SDI_Code ];

/// SDI_Desc
Property SDIDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SDI_Desc ];

/// SDI_ExDesc
Property SDIExDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = SDI_ExDesc ];

/// SDI_ExID
Property SDIExID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = SDI_ExID ];

/// SDI_ExType
Property SDIExType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = SDI_ExType ];

/// SDI_ImportFlag
Property SDIImportFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = SDI_ImportFlag ];

/// SDI_InvalidFlag
Property SDIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = SDI_InvalidFlag ];

/// SDI_MaxMinutes
Property SDIMaxMinutes As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = SDI_MaxMinutes ];

/// SDI_InvalidFlag
Property SDIMinMinutes As %Library.Float(SELECTIVITY = "33.3333%") [ SqlColumnNumber = 10, SqlFieldName = SDI_MinMinutes ];

/// SDI_MinutesPerTimes
Property SDIMinutesPerTimes As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = SDI_MinutesPerTimes ];

/// SDI_Price
Property SDIPrice As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = SDI_Price ];

/// SDI_Remark
Property SDIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = SDI_Remark ];

/// SDI_UnitDR
Property SDIUnitDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = SDI_UnitDR ];

/// SDI_UpdateDate
Property SDIUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = SDI_UpdateDate ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCServDetItem","0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SDI_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SDI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SDI_ExDesc">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="SDI_ExID">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SDI_ExType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SDI_ImportFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SDI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SDI_MaxMinutes">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SDI_MinMinutes">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SDI_MinutesPerTimes">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="SDI_Price">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SDI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SDI_UnitDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SDI_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SDI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCServDetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{SDI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExID">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SDI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCServDetItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{SDI_ExType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{SDI_ExID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{SDI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCServDetItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
