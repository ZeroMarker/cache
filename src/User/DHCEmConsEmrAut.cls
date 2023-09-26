Class User.DHCEmConsEmrAut Extends %Persistent [ SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsEmrAut, StorageStrategy = SQLStorage ]
{

/// EC_Cst_Ref	项目id
Property ECCstRef As User.DHCEmConsultItm [ SqlColumnNumber = 2, SqlFieldName = EC_Cst_Ref ];

/// EC_User_Dr	授权人
Property ECUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = EC_User_Dr ];

/// EC_Loc_Dr	科室ID
Property ECLocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = EC_Loc_Dr ];

/// EC_Doc_Dr   医生
Property ECDocDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = EC_Doc_Dr ];

/// EC_StartDate 开始日期
Property ECStartDate As %Library.Date [ SqlColumnNumber = 6, SqlFieldName = EC_StartDate ];

/// EC_StartTime 开始时间
Property ECStartTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = EC_StartTime ];

/// EC_EndDate   结束日期
Property ECEndDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = EC_EndDate ];

/// EC_EndTime   结束时间
Property ECEndTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = EC_EndTime ];

/// EC_TakTime  授权时限
Property ECTakTime As %Library.String [ SqlColumnNumber = 10, SqlFieldName = EC_TakTime ];

/// EC_TakOrd  授权类型1：病历，2：医嘱
Property ECTakOrd As %Library.String [ SqlColumnNumber = 11, SqlFieldName = EC_TakOrd ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMCEA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EC_Cst_Ref">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EC_Doc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EC_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EC_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EC_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EC_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EC_TakOrd">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EC_TakTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EC_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMCEA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCstParef">
<Global>^DHCEMCEA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Cst"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Cst_Ref}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsEmrAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
