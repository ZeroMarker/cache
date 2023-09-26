Class User.PMPProject Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PMP_Project, StorageStrategy = SQLStorage ]
{

/// PJT_Code
Property PJTCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PJT_Code ];

/// PJT_Desc
Property PJTDesc As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PJT_Desc ];

/// PJT_Hospital_DR
Property PJTHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = PJT_Hospital_DR ];

/// PJT_Remark
Property PJTRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PJT_Remark ];

/// PJT_Date
Property PJTDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PJT_Date ];

/// PJT_Time
Property PJTTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PJT_Time ];

/// PJT_Status
Property PJTStatus As %String(DISPLAYLIST = ",有效,无效", MAXLEN = 30, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PJT_Status ];

/// PJT_User_DR
Property PJTUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PJT_User_DR ];

/// PJT_Manager_DR
Property PJTManagerDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PJT_Manager_DR ];

/// PJT_Assistant_DR
Property PJTAssistantDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PJT_Assistant_DR ];

/// PJT_UpdateDate
Property PJTUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PJT_UpdateDate ];

/// PJT_UpdateTime
Property PJTUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PJT_UpdateTime ];

/// PJT_UpdateUser_DR
Property PJTUpdateUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PJT_UpdateUser_DR ];

/// PJT_Standby1
Property PJTStandby1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PJT_Standby1 ];

/// PJT_Standby2
Property PJTStandby2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PJT_Standby2 ];

/// PJT_Standby3
Property PJTStandby3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PJT_Standby3 ];

/// PJT_Standby4
Property PJTStandby4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PJT_Standby4 ];

/// PJT_Standby5
Property PJTStandby5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PJT_Standby5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMPProject("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PJT_Assistant_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PJT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PJT_Date">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PJT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PJT_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PJT_Manager_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PJT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PJT_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PJT_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PJT_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PJT_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PJT_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PJT_Status">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PJT_Time">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PJT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PJT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PJT_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PJT_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PMPProject</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PJT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PJT_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXCTHospital">
<Global>^PMPProjecti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PJT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CT_Hospital"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PJT_Hospital_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PJT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PJT_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
