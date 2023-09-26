Class User.DHCMDTFolUpVis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MC_RowID, SqlTableName = DHC_MDTFolUpVis, StorageStrategy = SQLStorage ]
{

/// d ##class(User.DHCMDTFolUpVis).%BuildIndices()
/// 会诊记录ID   MC_ParRef_Dr
Property MCParRefDr As User.DHCMDTConsult [ SqlColumnNumber = 2, SqlFieldName = MC_ParRef_Dr ];

/// 要求随访日期  MC_NDate
Property MCNDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = MC_NDate ];

/// 要求随访时间  MC_NTime
Property MCNTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = MC_NTime ];

/// 随访(回复)科室  MC_Loc_Dr
Property MCLocDr As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = MC_Loc_Dr ];

/// 随访(回复)日期  MC_Date
Property MCDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = MC_Date ];

/// 随访(回复)时间  MC_Time
Property MCTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MC_Time ];

/// 随访医师/回复专家  MC_User_Dr
Property MCUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = MC_User_Dr ];

/// 随访内容/回复意见  MC_Content
Property MCContent As %Library.Text(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = MC_Content ];

/// 类型 F-随访，R-回复 MC_Type
Property MCType As %Library.String [ SqlColumnNumber = 10, SqlFieldName = MC_Type ];

/// 随访记录ID   MC_Parent_Dr
Property MCParentDr As User.DHCMDTFolUpVis [ SqlColumnNumber = 11, SqlFieldName = MC_Parent_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTFUV)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MC_Content">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MC_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_NDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MC_NTime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_ParRef_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MC_Parent_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MC_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MC_Type">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCMDTFUV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCst">
<Global>^DHCMDTFUV</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MdtCst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParef">
<Global>^DHCMDTFUV</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Paref"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_Parent_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCMDTFUV</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MCUser"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_ParRef_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTFolUpVisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
