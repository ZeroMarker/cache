Class User.DHCEQCSysMenus Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = M_RowID, SqlTableName = DHC_EQCSysMenus, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// M_ModuleType
Property MModuleType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = M_ModuleType ];

/// M_BussTypeDR
Property MBussTypeDR As User.DHCEQCBussType [ SqlColumnNumber = 3, SqlFieldName = M_BussTypeDR ];

/// M_Name
Property MName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = M_Name ];

/// M_Caption
Property MCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = M_Caption ];

/// M_MenuType
Property MMenuType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = M_MenuType ];

/// M_ClientType
Property MClientType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = M_ClientType ];

/// M_ParentMenuDR
Property MParentMenuDR As User.DHCEQCSysMenus [ SqlColumnNumber = 8, SqlFieldName = M_ParentMenuDR ];

/// M_Image
Property MImage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = M_Image ];

/// M_LinkUrl
Property MLinkUrl As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = M_LinkUrl ];

/// M_Sequence
Property MSequence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = M_Sequence ];

/// M_ShortcutKey
Property MShortcutKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = M_ShortcutKey ];

/// M_ShowInNewWindow
Property MShowInNewWindow As %Library.String(DISPLAYLIST = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = M_ShowInNewWindow ];

/// M_Remark
Property MRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = M_Remark ];

/// M_UpdateDate
Property MUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = M_UpdateDate ];

/// M_UpdateTime
Property MUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = M_UpdateTime ];

/// M_UpdateUserDR
Property MUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = M_UpdateUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCSysMenus",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="M_BussTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="M_Caption">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="M_ClientType">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="M_Image">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="M_LinkUrl">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="M_MenuType">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="M_ModuleType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="M_Name">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="M_ParentMenuDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="M_Remark">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="M_Sequence">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="M_ShortcutKey">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="M_ShowInNewWindow">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="M_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="M_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="M_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>M_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCSysMenus"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{M_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexParentMenuDr">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>M_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"DHCEQCSysMenus"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MParentMenuDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{M_ParentMenuDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{M_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCSysMenusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
