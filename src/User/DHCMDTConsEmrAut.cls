Class User.DHCMDTConsEmrAut Extends %Persistent [ SqlRowIdName = MC_RowID, SqlTableName = DHC_MDTConsEmrAut, StorageStrategy = SQLStorage ]
{

/// MC_Cst_Ref	项目id
Property MCCstRef As User.DHCMDTConsultItm [ SqlColumnNumber = 2, SqlFieldName = MC_Cst_Ref ];

/// MC_User_Dr	授权人
Property MCUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = MC_User_Dr ];

/// MC_Loc_Dr	科室ID
Property MCLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = MC_Loc_Dr ];

/// MC_Doc_Dr   医生
Property MCDocDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = MC_Doc_Dr ];

/// MC_StartDate 开始日期
Property MCStartDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = MC_StartDate ];

/// MC_StartTime 开始时间
Property MCStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = MC_StartTime ];

/// MC_EndDate   结束日期
Property MCEndDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = MC_EndDate ];

/// MC_EndTime   结束时间
Property MCEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = MC_EndTime ];

/// MC_TakTime  授权时限
Property MCTakTime As %Library.String [ SqlColumnNumber = 10, SqlFieldName = MC_TakTime ];

/// MC_TakOrd  授权类型1：病历，2：医嘱
Property MCTakOrd As %Library.String [ SqlColumnNumber = 11, SqlFieldName = MC_TakOrd ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCMDTCEA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MC_Cst_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MC_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MC_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MC_TakOrd">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MC_TakTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTCEA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCstParef">
<Global>^DHCMDTCEA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MC_Cst_Ref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTConsEmrAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
