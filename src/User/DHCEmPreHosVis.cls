Class User.DHCEmPreHosVis Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EM_RowID, SqlTableName = DHC_EmPreHosVis, StorageStrategy = SQLStorage ]
{

/// 呼救者姓名   EM_Name
Property EMName As %Library.String [ SqlColumnNumber = 2, SqlFieldName = EM_Name ];

/// 联系电话  EM_Phone
Property EMPhone As %Library.String [ SqlColumnNumber = 3, SqlFieldName = EM_Phone ];

/// 病人姓名  EM_PatName
Property EMPatName As %Library.String [ SqlColumnNumber = 4, SqlFieldName = EM_PatName ];

/// 性别  EM_PatSex
Property EMPatSex As %Library.String [ SqlColumnNumber = 5, SqlFieldName = EM_PatSex ];

/// 年龄  EM_PatAge
Property EMPatAge As %Library.String [ SqlColumnNumber = 6, SqlFieldName = EM_PatAge ];

/// 出诊地点  EM_VisPlace
Property EMVisPlace As %Library.String [ SqlColumnNumber = 7, SqlFieldName = EM_VisPlace ];

/// 出诊事由  EM_VisRea
Property EMVisRea As %Library.String [ SqlColumnNumber = 8, SqlFieldName = EM_VisRea ];

/// 出诊日期  EM_VisDate
Property EMVisDate As %Library.Date [ SqlColumnNumber = 9, SqlFieldName = EM_VisDate ];

/// 出诊时间  EM_VisTime
Property EMVisTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = EM_VisTime ];

/// 信息来源  EM_Source
Property EMSource As %Library.String [ SqlColumnNumber = 11, SqlFieldName = EM_Source ];

/// 接通知者  EM_RecUser_Dr
Property EMRecUserDr As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = EM_RecUser_Dr ];

/// 登记日期  EM_RDate
Property EMRDate As %Library.Date [ SqlColumnNumber = 13, SqlFieldName = EM_RDate ];

/// 登记时间  EM_RTime
Property EMRTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = EM_RTime ];

/// 登记人  EM_RUser_Dr
Property EMRUserDr As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = EM_RUser_Dr ];

/// 医院    EM_Hosp_Dr
Property EMHospDr As User.CTHospital [ SqlColumnNumber = 16, SqlFieldName = EM_Hosp_Dr ];

/// d ##class(User.DHCEmPreHosVis).%BuildIndices()
Storage SQLStorage
{
<Description>
<![CDATA[d ##class(User.DHCEmPreHosVis).%BuildIndices()]]></Description>
<SqlIdExpression>$i(^DHCEMPHV)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EM_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EM_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EM_PatAge">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EM_PatName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EM_PatSex">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EM_Phone">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EM_RDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EM_RTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EM_RUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EM_RecUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EM_Source">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EM_VisDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EM_VisPlace">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EM_VisRea">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EM_VisTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEMPHV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCEMPHV</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EM_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"CreateDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EM_RDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EM_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmPreHosVisS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
