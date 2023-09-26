Class User.DHCEQWash Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = W_RowID, SqlTableName = DHC_EQWash, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// W_WashNo
Property WWashNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = W_WashNo ];

/// W_WashDate
Property WWashDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = W_WashDate ];

/// W_WashTime
Property WWashTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = W_WashTime ];

/// W_WasherDR
Property WWasherDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = W_WasherDR ];

/// W_WashEquipDR
Property WWashEquipDR As User.DHCEQEquip [ SqlColumnNumber = 6, SqlFieldName = W_WashEquipDR ];

/// W_WashType
Property WWashType As %Library.String(DISPLAYLIST = ",工作服洗涤,普通被服,传染性被服,被血液痰液等污染被服", MAXLEN = 10, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4") [ SqlColumnNumber = 7, SqlFieldName = W_WashType ];

/// W_WashLocDR
Property WWashLocDR As User.CTLoc [ SqlColumnNumber = 8, SqlFieldName = W_WashLocDR ];

/// W_Status
Property WStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 9, SqlFieldName = W_Status ];

/// W_UpdateUserDR
Property WUpdateUserDR As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = W_UpdateUserDR ];

/// W_UpdateDate
Property WUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = W_UpdateDate ];

/// W_UpdateTime
Property WUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = W_UpdateTime ];

/// W_SubmitUserDR
Property WSubmitUserDR As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = W_SubmitUserDR ];

/// W_SubmitDate
Property WSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = W_SubmitDate ];

/// W_SubmitTime
Property WSubmitTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = W_SubmitTime ];

/// W_AuditUserDR
Property WAuditUserDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = W_AuditUserDR ];

/// W_AuditDate
Property WAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = W_AuditDate ];

/// W_AuditTime
Property WAuditTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = W_AuditTime ];

/// W_Hold1
Property WHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = W_Hold1 ];

/// W_Hold2
Property WHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = W_Hold2 ];

/// W_Hold3
Property WHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = W_Hold3 ];

/// W_Hold4
Property WHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = W_Hold4 ];

/// W_Hold5
Property WHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = W_Hold5 ];

/// W_InvalidFlag
Property WInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = W_InvalidFlag ];

Index WWashNoUnqIdx1 On WWashNo [ Unique ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQWash("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="W_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="W_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="W_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="W_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="W_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="W_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="W_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="W_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="W_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="W_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="W_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="W_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="W_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="W_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="W_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="W_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="W_WashDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="W_WashEquipDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="W_WashLocDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="W_WashNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="W_WashTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="W_WashType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="W_WasherDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQWash</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>W_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{W_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAuditDate">
<Global>^DHCEQWash</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"AuditDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{W_AuditDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{W_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQWash</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{W_WashEquipDR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{W_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNo">
<Global>^DHCEQWash</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{W_WashNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{W_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexType">
<Global>^DHCEQWash</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>W_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{W_WashType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{W_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQWashS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
