Class User.DHCEQBillItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQBillItem, StorageStrategy = SQLStorage ]
{

/// BI_SourceType
Property BISourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = BI_SourceType ];

/// BI_ScourceID
Property BIScourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BI_ScourceID ];

/// BI_Code
Property BICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = BI_Code ];

/// BI_Desc
Property BIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BI_Desc ];

/// BI_Price
Property BIPrice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = BI_Price ];

/// BI_Cost
Property BICost As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = BI_Cost ];

/// BI_WorkLoadNum
Property BIWorkLoadNum As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BI_WorkLoadNum ];

/// BI_ExType
Property BIExType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BI_ExType ];

/// BI_ExID
Property BIExID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BI_ExID ];

/// BI_UsedFlag
Property BIUsedFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = BI_UsedFlag ];

/// BI_DevelopStatus
Property BIDevelopStatus As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BI_DevelopStatus ];

/// BI_InvalidFlag
Property BIInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = BI_InvalidFlag ];

/// BI_Hold1
Property BIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = BI_Hold1 ];

/// BI_Hold2
Property BIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = BI_Hold2 ];

/// BI_Hold3
Property BIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = BI_Hold3 ];

/// BI_Hold4
Property BIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = BI_Hold4 ];

/// BI_Hold5
Property BIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = BI_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQBillItem("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BI_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BI_Cost">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BI_DevelopStatus">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BI_ExID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BI_ExType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="BI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="BI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="BI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="BI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="BI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="BI_Price">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BI_ScourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BI_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BI_UsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BI_WorkLoadNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQBillItem</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExType">
<Global>^DHCEQBillItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BI_ExType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BI_ExID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQBillItem</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BI_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BI_ScourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BI_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQBillItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
