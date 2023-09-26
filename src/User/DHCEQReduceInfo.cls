Class User.DHCEQReduceInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ERI_RowID, SqlTableName = DHC_EQReduceInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// ERI_OutTypeDR
Property ERIOutTypeDR As User.DHCEQCOutType [ SqlColumnNumber = 2, SqlFieldName = ERI_OutTypeDR ];

/// ERI_DealUserDR
Property ERIDealUserDR As User.DHCEQCUser [ SqlColumnNumber = 11, SqlFieldName = ERI_DealUserDR ];

/// ERI_ReduceDate
Property ERIReduceDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = ERI_ReduceDate ];

/// ERI_InvalidFlag
Property ERIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = ERI_InvalidFlag ];

/// ERI_DealDate
Property ERIDealDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = ERI_DealDate ];

/// ERI_ApproveDate
Property ERIApproveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = ERI_ApproveDate ];

/// ERI_ApproveNo
Property ERIApproveNo As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ERI_ApproveNo ];

/// ERI_Status
Property ERIStatus As %Library.String(DISPLAYLIST = ",未处置,处置中,处置完成", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 15, SqlFieldName = ERI_Status ];

/// ERI_LastDate
Property ERILastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = ERI_LastDate ];

/// ERI_Hold1
Property ERIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ERI_Hold1 ];

/// ERI_Hold2
Property ERIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = ERI_Hold2 ];

/// ERI_Hold3
Property ERIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = ERI_Hold3 ];

/// ERI_Hold4
Property ERIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = ERI_Hold4 ];

/// ERI_Hold5
Property ERIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = ERI_Hold5 ];

/// ERI_LastTime
Property ERILastTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = ERI_LastTime ];

/// ERI_EquipDR
Property ERIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = ERI_EquipDR ];

/// ERI_EntityFlag
Property ERIEntityFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = ERI_EntityFlag ];

/// ERI_ReduceUserDR
Property ERIReduceUserDR As User.DHCEQCUser [ SqlColumnNumber = 6, SqlFieldName = ERI_ReduceUserDR ];

/// ERI_DealType
Property ERIDealType As %Library.String(DISPLAYLIST = ",未处理,回收,出售", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 9, SqlFieldName = ERI_DealType ];

/// ERI_LastUserDR
Property ERILastUserDR As User.DHCEQCUser [ SqlColumnNumber = 18, SqlFieldName = ERI_LastUserDR ];

/// ERI_DealIncome
Property ERIDealIncome As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = ERI_DealIncome ];

/// ERI_DealFee
Property ERIDealFee As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = ERI_DealFee ];

/// ERI_ToDept
Property ERIToDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = ERI_ToDept ];

/// ERI_Remark
Property ERIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = ERI_Remark ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQReduceInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ERI_ApproveDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ERI_ApproveNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ERI_DealDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ERI_DealFee">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ERI_DealIncome">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ERI_DealType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ERI_DealUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ERI_EntityFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ERI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ERI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ERI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ERI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ERI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ERI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ERI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ERI_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ERI_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ERI_LastUserDR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ERI_OutTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ERI_ReduceDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ERI_ReduceUserDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ERI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ERI_Status">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ERI_ToDept">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQReduceInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ERI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ERI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQReduceInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ERI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutTypeDR">
<Global>^DHCEQReduceInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>ERI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutTypeDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERI_OutTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOutTypeEquip">
<Global>^DHCEQReduceInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ERI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OutTypeEquip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERI_OutTypeDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ERI_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ERI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQReduceInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
