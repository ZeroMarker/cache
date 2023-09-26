Class User.DHCEQCEquipeCat Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EC_RowID, SqlTableName = DHC_EQCEquipeCat, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EC_Code
Property ECCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EC_Code ];

/// EC_Desc
Property ECDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = EC_Desc ];

/// EC_Remark
Property ECRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EC_Remark ];

/// EC_ParCatDR
Property ECParCatDR As User.DHCEQCEquipeCat [ SqlColumnNumber = 5, SqlFieldName = EC_ParCatDR ];

/// EC_SpecialTypeDR
Property ECSpecialTypeDR As User.DHCEQCSpecialType [ SqlColumnNumber = 6, SqlFieldName = EC_SpecialTypeDR ];

/// EC_YearsNum
Property ECYearsNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = EC_YearsNum ];

/// EC_InvalidFlag
Property ECInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = EC_InvalidFlag ];

/// EC_EquipNoFlag
Property ECEquipNoFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = EC_EquipNoFlag ];

/// EC_Hold1
Property ECHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EC_Hold1 ];

/// EC_Hold2
Property ECHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = EC_Hold2 ];

/// EC_Hold3
Property ECHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = EC_Hold3 ];

/// EC_Hold4
Property ECHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EC_Hold4 ];

/// EC_Hold5
Property ECHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EC_Hold5 ];

/// EC_Hold6
Property ECHold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EC_Hold6 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCEquipeCat",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_EquipNoFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EC_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EC_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EC_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EC_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EC_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_ParCatDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_SpecialTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EC_YearsNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEquipeCat"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{EC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCEquipeCat"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{EC_Code}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexECParCatDR">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCEquipeCat"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ECParCatDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_ParCatDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCEquipeCatS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
