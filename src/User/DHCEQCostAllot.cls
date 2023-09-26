Class User.DHCEQCostAllot Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CA_RowID, SqlTableName = DHC_EQCostAllot, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CA_Remark
Property CARemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CA_Remark ];

/// CA_InvalidFlag
Property CAInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CA_InvalidFlag ];

/// CA_Status
Property CAStatus As %Library.String(DISPLAYLIST = ",新增,提交", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 7, SqlFieldName = CA_Status ];

/// CA_AddUserDR
Property CAAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CA_AddUserDR ];

/// CA_AddDate
Property CAAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = CA_AddDate ];

/// CA_AddTime
Property CAAddTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = CA_AddTime ];

/// CA_UpdateUserDR
Property CAUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CA_UpdateUserDR ];

/// CA_UpdateDate
Property CAUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = CA_UpdateDate ];

/// CA_UpdateTime
Property CAUpdateTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = CA_UpdateTime ];

/// CA_AuditUserDR
Property CAAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CA_AuditUserDR ];

/// CA_AuditDate
Property CAAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = CA_AuditDate ];

/// CA_AuditTime
Property CAAuditTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = CA_AuditTime ];

/// CA_EquipDR
Property CAEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = CA_EquipDR ];

/// CA_AllotType
Property CAAllotType As %Library.String(DISPLAYLIST = ",比例,工作量,面积,人数,床位,收入,固定值", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5,6") [ SqlColumnNumber = 3, SqlFieldName = CA_AllotType ];

/// CA_Types
Property CATypes As %Library.String(DISPLAYLIST = ",全部,折旧,维修,保养,检查,其它", MAXLEN = 2, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ SqlColumnNumber = 4, SqlFieldName = CA_Types ];

/// CA_Hold1
Property CAHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CA_Hold1 ];

/// CA_Hold2
Property CAHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CA_Hold2 ];

/// CA_Hold3
Property CAHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CA_Hold3 ];

/// CA_Hold4
Property CAHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CA_Hold4 ];

/// CA_Hold5
Property CAHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CA_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCostAllot("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CA_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CA_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CA_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CA_AllotType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CA_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CA_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CA_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CA_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CA_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CA_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CA_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CA_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CA_Status">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CA_Types">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CA_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CA_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CA_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCEQCostAllot</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{CA_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipType">
<Global>^DHCEQCostAllot</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_Types}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSourceType">
<Global>^DHCEQCostAllot</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_Types}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_Hold2}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatusSourceType">
<Global>^DHCEQCostAllot</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StatusSourceType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CA_InvalidFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CA_Types}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CA_Hold2}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCostAllotS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
