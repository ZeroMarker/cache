Class User.DHCEQConsumableItemInfo Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQConsumableItemInfo, StorageStrategy = SQLStorage ]
{

/// CII_SourceType
Property CIISourceType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CII_SourceType ];

/// CII_ScourceID
Property CIIScourceID As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CII_ScourceID ];

/// CII_Code
Property CIICode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CII_Code ];

/// CII_Desc
Property CIIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CII_Desc ];

/// CII_Model
Property CIIModel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CII_Model ];

/// CII_RegistrationNo
Property CIIRegistrationNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CII_RegistrationNo ];

/// CII_Price
Property CIIPrice As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CII_Price ];

/// CII_DisposableFlag
Property CIIDisposableFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = CII_DisposableFlag ];

/// CII_ChargeType
Property CIIChargeType As %Library.String(DISPLAYLIST = ",可单独收费,在诊疗项目中打包收费,纯消耗不可收费", MAXLEN = 5, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 10, SqlFieldName = CII_ChargeType ];

/// CII_BillItemNo
Property CIIBillItemNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CII_BillItemNo ];

/// CII_ExpenseType
Property CIIExpenseType As %Library.String(DISPLAYLIST = ",医保报销,医保不报销,医保部分报销", MAXLEN = 5, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 12, SqlFieldName = CII_ExpenseType ];

/// CII_ExpenseRate
Property CIIExpenseRate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CII_ExpenseRate ];

/// CII_PreWorkload
Property CIIPreWorkload As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CII_PreWorkload ];

/// CII_AdditionRate
Property CIIAdditionRate As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CII_AdditionRate ];

/// CII_Remark
Property CIIRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CII_Remark ];

/// CII_Hold1
Property CIIHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CII_Hold1 ];

/// CII_Hold2
Property CIIHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CII_Hold2 ];

/// CII_Hold3
Property CIIHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CII_Hold3 ];

/// CII_Hold4
Property CIIHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CII_Hold4 ];

/// CII_Hold5
Property CIIHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CII_Hold5 ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEQConsumableItemInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CII_AdditionRate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CII_BillItemNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CII_ChargeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CII_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CII_Desc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CII_DisposableFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CII_ExpenseRate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CII_ExpenseType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CII_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CII_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CII_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CII_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CII_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CII_Model">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CII_PreWorkload">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CII_Price">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CII_RegistrationNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CII_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CII_ScourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CII_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQConsumableItemInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CII_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{CII_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexScource">
<Global>^DHCEQConsumableItemInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CII_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"Scource"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{CII_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CII_ScourceID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CII_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CII_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQConsumableItemInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
