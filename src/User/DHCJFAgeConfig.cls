Class User.DHCJFAgeConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_JFAgeConfig, StorageStrategy = SQLStorage ]
{

/// JAC_StartOperator
Property JACStartOperator As %String(MAXLEN = 2, VALUELIST = ",>,>=") [ SqlColumnNumber = 2, SqlFieldName = JAC_StartOperator ];

/// JAC_StartVal
Property JACStartVal As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JAC_StartVal ];

/// JAC_StartUom
Property JACStartUom As User.DHCJFUOMSET [ SqlColumnNumber = 4, SqlFieldName = JAC_StartUom ];

/// JAC_EndOperator
Property JACEndOperator As %String(MAXLEN = 2, VALUELIST = ",<,<=") [ SqlColumnNumber = 5, SqlFieldName = JAC_EndOperator ];

/// JAC_EndVal
Property JACEndVal As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JAC_EndVal ];

/// JAC_EndUom
Property JACEndUom As User.DHCJFUOMSET [ SqlColumnNumber = 7, SqlFieldName = JAC_EndUom ];

/// JAC_ActiveFlag
Property JACActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = JAC_ActiveFlag ];

/// JAC_DisPlayUom
Property JACDisPlayUom As User.DHCJFUOMSET [ SqlColumnNumber = 9, SqlFieldName = JAC_DisPlayUom ];

/// JAC_AddUser_Dr
Property JACAddUserDr As User.SSUser [ SqlColumnNumber = 10, SqlFieldName = JAC_AddUser_Dr ];

/// JAC_AddDate
Property JACAddDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = JAC_AddDate ];

/// JAC_AddTime
Property JACAddTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 12, SqlFieldName = JAC_AddTime ];

/// JAC_UpdateUser_Dr
Property JACUpdateUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = JAC_UpdateUser_Dr ];

/// JAC_UpdateDate
Property JACUpdateDate As %Date [ SqlColumnNumber = 14, SqlFieldName = JAC_UpdateDate ];

/// JAC_UpdateTime
Property JACUpdateTime As %Time [ SqlColumnNumber = 15, SqlFieldName = JAC_UpdateTime ];

/// JAC_Note1
Property JACNote1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = JAC_Note1 ];

/// JAC_Note2
Property JACNote2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = JAC_Note2 ];

/// JAC_Note3
Property JACNote3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = JAC_Note3 ];

/// JAC_Note4
Property JACNote4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = JAC_Note4 ];

/// JAC_Note5
Property JACNote5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = JAC_Note5 ];

/// JAC_Hosp_Dr
Property JACHospDr As User.CTHospital [ SqlColumnNumber = 21, SqlFieldName = JAC_Hosp_Dr ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCJFAGECONFIG)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="JAC_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="JAC_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JAC_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JAC_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JAC_DisPlayUom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JAC_EndOperator">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JAC_EndUom">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JAC_EndVal">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JAC_Hosp_Dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="JAC_Note1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JAC_Note2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JAC_Note3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JAC_Note4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JAC_Note5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="JAC_StartOperator">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JAC_StartUom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JAC_StartVal">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JAC_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JAC_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JAC_UpdateUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCJFAGECONFIG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JAC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{JAC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEndUom">
<Global>^DHCJFAGECONFIG</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EndUom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JAC_EndUom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStartUom">
<Global>^DHCJFAGECONFIG</Global>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"StartUom"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JAC_StartUom}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{JAC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>JAC_RowId</SqlRowIdName>
<StreamLocation>^User.DHCJFAgeConfigS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
