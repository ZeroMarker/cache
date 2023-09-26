Class User.DHCEQTemplateList Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TL_RowID, SqlTableName = DHC_EQTemplateList, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// TL_TemplateDR
Property TLTemplateDR As User.DHCEQTemplate [ SqlColumnNumber = 2, SqlFieldName = TL_TemplateDR ];

/// TL_ElementDR
Property TLElementDR As User.DHCEQCElement [ SqlColumnNumber = 3, SqlFieldName = TL_ElementDR ];

/// TL_SettingValue
Property TLSettingValue As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = TL_SettingValue ];

/// TL_Key
Property TLKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TL_Key ];

/// TL_Times
Property TLTimes As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = TL_Times ];

/// TL_Result
Property TLResult As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TL_Result ];

/// TL_Note
Property TLNote As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TL_Note ];

/// TL_NormalFlag
Property TLNormalFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TL_NormalFlag ];

/// TL_Remark
Property TLRemark As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = TL_Remark ];

/// TL_Sort
Property TLSort As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = TL_Sort ];

/// TL_UpdateUserDR
Property TLUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TL_UpdateUserDR ];

/// TL_UpdateDate
Property TLUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = TL_UpdateDate ];

/// TL_UpdateTime
Property TLUpdateTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = TL_UpdateTime ];

/// TL_Hold1
Property TLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TL_Hold1 ];

/// TL_Hold2
Property TLHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = TL_Hold2 ];

/// TL_Hold3
Property TLHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TL_Hold3 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTemplateList("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="TL_ElementDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="TL_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="TL_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="TL_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="TL_Key">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="TL_NormalFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="TL_Note">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="TL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="TL_Result">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="TL_SettingValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="TL_Sort">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="TL_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="TL_Times">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="TL_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TL_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="TL_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQTemplateList</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{TL_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexElementDR">
<Global>^DHCEQTemplateList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TemplateElement"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TL_TemplateDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TL_ElementDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{TL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexTemplateDR">
<Global>^DHCEQTemplateList</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>TL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TemplateDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{TL_TemplateDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{TL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTemplateListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
