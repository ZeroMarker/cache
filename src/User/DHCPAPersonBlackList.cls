Class User.DHCPAPersonBlackList Extends %Persistent [ ClassType = persistent, ProcedureBlock, SqlRowIdName = PB_RowId, SqlTableName = DHC_PapersonBlackList, StorageStrategy = SQLStorage ]
{

Property PBDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PB_Date ];

Property PBPAPMIDR As PAPatMas [ SqlColumnNumber = 3, SqlFieldName = PB_PAPMI_DR ];

Property PBStatus As %Time [ SqlColumnNumber = 4, SqlFieldName = PB_Status ];

Property PBTime As %Time [ SqlColumnNumber = 6, SqlFieldName = PB_Time ];

Property PBType As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PB_Type ];

// 新增字段，日期和时间 有效标志 1 有效 0 无效

Property PBLastUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = PB_LastUpdateDate ];

Property PBLastUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = PB_LastUpdateTime ];

Property PBActiveFlag As %String(TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PB_ActiveFlag ];

Property PBIDCardNo As %String(TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PB_IDCardNo ];

Property PBIDName As %String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = PB_Name ];

Property PBAddUserDr As SSUser [ SqlColumnNumber = 12, SqlFieldName = PB_AddUser_Dr ];

Property PBBlackTypeDr As DHCBlackListType [ SqlColumnNumber = 13, SqlFieldName = PB_BlackType ];

Property PBNote As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PB_Note ];

Property PBActiveStartDate As %Date [ SqlColumnNumber = 15, SqlFieldName = PB_ActiveStartDate ];

Property PBActiveEndDate As %Date [ SqlColumnNumber = 16, SqlFieldName = PB_ActiveEndDate ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCPABL(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PB_ActiveEndDate">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PB_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PB_ActiveStartDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PB_AddUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PB_BlackType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PB_Date">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PB_IDCardNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PB_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PB_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PB_Name">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PB_Note">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PB_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PB_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PB_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PB_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PB_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexIDCardNo">
<Global>^DHCPBL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"IDCardNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PB_IDCardNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIDR">
<Global>^DHCPBL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>{PB_RowId}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAPMI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PB_PAPMI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PB_RowId</SqlRowIdName>
<StreamLocation>^User.DHCPAPersonBlackListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
