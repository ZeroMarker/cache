Class User.DHCEQCTree Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = T_RowID, SqlTableName = DHC_EQCTree, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// T_Type
Property TType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = T_Type ];

/// T_Code
Property TCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = T_Code ];

/// T_Desc
Property TDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = T_Desc ];

/// T_ParTreeDR
Property TParTreeDR As User.DHCEQCTree [ SqlColumnNumber = 5, SqlFieldName = T_ParTreeDR ];

/// T_ExCode
Property TExCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = T_ExCode ];

/// T_Remark
Property TRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = T_Remark ];

/// T_Hold1
Property THold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = T_Hold1 ];

/// T_Hold2
Property THold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = T_Hold2 ];

/// T_Hold3
Property THold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = T_Hold3 ];

/// T_Hold4
Property THold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = T_Hold4 ];

/// T_Hold5
Property THold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = T_Hold5 ];

/// T_Hold6
Property THold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = T_Hold6 ];

/// T_Hold7
Property THold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = T_Hold7 ];

/// T_Hold8
Property THold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = T_Hold8 ];

/// T_Hold9
Property THold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = T_Hold9 ];

/// T_Hold10
Property THold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = T_Hold10 ];

/// T_InvalidFlag
Property TInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = T_InvalidFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCTree",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="T_Code">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="T_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="T_ExCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="T_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="T_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="T_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="T_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="T_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="T_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="T_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="T_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="T_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="T_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="T_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="T_ParTreeDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="T_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="T_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTree"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{T_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParTree">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTree"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ParTree"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{T_ParTreeDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTree"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{T_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({T_Code})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDesc">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTree"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{T_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({T_Desc})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeExCode">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCTree"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"TypeExCode"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{T_Type}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({T_ExCode})</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{T_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCTreeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
