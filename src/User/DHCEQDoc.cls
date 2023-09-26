Class User.DHCEQDoc Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DOC_RowID, SqlTableName = DHC_EQDoc, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DOC_DocOriginalDR
Property DOCDocOriginalDR As User.DHCEQCDocOriginal [ SqlColumnNumber = 2, SqlFieldName = DOC_DocOriginalDR ];

/// DOC_DocName
Property DOCDocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DOC_DocName ];

/// DOC_LocDR
Property DOCLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DOC_LocDR ];

/// DOC_ManagerDR
Property DOCManagerDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DOC_ManagerDR ];

/// DOC_ShareNum
Property DOCShareNum As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DOC_ShareNum ];

/// DOC_PagesNum
Property DOCPagesNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DOC_PagesNum ];

/// DOC_Remark
Property DOCRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DOC_Remark ];

/// DOC_AddUserDR
Property DOCAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DOC_AddUserDR ];

/// DOC_AddDate
Property DOCAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = DOC_AddDate ];

/// DOC_AddTime
Property DOCAddTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = DOC_AddTime ];

/// DOC_UpdateUserDR
Property DOCUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DOC_UpdateUserDR ];

/// DOC_UpdateDate
Property DOCUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DOC_UpdateDate ];

/// DOC_UpdateTime
Property DOCUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = DOC_UpdateTime ];

/// DOC_EquipDR
Property DOCEquipDR As User.DHCEQEquip [ SqlColumnNumber = 15, SqlFieldName = DOC_EquipDR ];

/// DOC_DocTypeDR
Property DOCDocTypeDR As User.DHCEQCDocType [ SqlColumnNumber = 16, SqlFieldName = DOC_DocTypeDR ];

/// DOC_CheckListDR
Property DOCCheckListDR As User.DHCEQOpenCheckList [ SqlColumnNumber = 17, SqlFieldName = DOC_CheckListDR ];

/// DOC_OldRowID
Property DOCOldRowID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DOC_OldRowID ];

/// DOC_OperFlag
Property DOCOperFlag As %Library.String(DISPLAYLIST = ",新增,修改,删除", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 19, SqlFieldName = DOC_OperFlag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQDoc("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DOC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DOC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DOC_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DOC_CheckListDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DOC_DocName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DOC_DocOriginalDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DOC_DocTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DOC_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DOC_LocDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DOC_ManagerDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DOC_OldRowID">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DOC_OperFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DOC_PagesNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DOC_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DOC_ShareNum">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DOC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DOC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DOC_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQDoc</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DOC_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCheckList">
<Global>^DHCEQDoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CheckListDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOC_CheckListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQDoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOldRowID">
<Global>^DHCEQDoc</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DOC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OldRowID"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DOC_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DOC_OldRowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DOC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQDocS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
