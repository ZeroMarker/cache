Class User.PMPProjectUser Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PMP_ProjectUser, StorageStrategy = SQLStorage ]
{

/// PJU_User_DR
Property PJUUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PJU_User_DR ];

/// PJU_Profession_DR
Property PJUProfessionDR As PMPDictionary3 [ SqlColumnNumber = 3, SqlFieldName = PJU_Profession_DR ];

/// PJU_Remark
Property PJURemark As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PJU_Remark ];

/// PJU_StDate
Property PJUStDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PJU_StDate ];

/// PJU_EnDate
Property PJUEnDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PJU_EnDate ];

/// PJU_Updateser_DR
Property PJUUpdateserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PJU_Updateser_DR ];

/// PJU_Tel
Property PJUTel As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PJU_Tel ];

/// PJU_StTime
Property PJUStTime As %Time [ SqlColumnNumber = 9, SqlFieldName = PJU_StTime ];

/// PJU_EnTime
Property PJUEnTime As %Time [ SqlColumnNumber = 10, SqlFieldName = PJU_EnTime ];

/// PJU_Date
Property PJUDate As %Date [ SqlColumnNumber = 11, SqlFieldName = PJU_Date ];

/// PJU_Time
Property PJUTime As %Time [ SqlColumnNumber = 12, SqlFieldName = PJU_Time ];

/// PJU_Project_DR
Property PJUProjectDR As PMPProject [ SqlColumnNumber = 13, SqlFieldName = PJU_Project_DR ];

/// PJU_Standby
Property PJUStandby As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PJU_Standby ];

/// PJU_Email
Property PJUEmail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PJU_Email ];

/// PJUStandby1
Property PJUStandby1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PJU_Standby1 ];

/// PJUStandby2
Property PJUStandby2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PJU_Standby2 ];

/// PJUStandby3
Property PJUStandby3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PJU_Standby3 ];

/// PJUStandby4
Property PJUStandby4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PJU_Standby4 ];

/// PJUStandby5
Property PJUStandby5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PJU_Standby5 ];

/// PJUStandby6
Property PJUStandby6 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PJU_Standby6 ];

/// PJUStandby7
Property PJUStandby7 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PJU_Standby7 ];

/// PJUNewUserName
Property PJUNewUserName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PJU_NewUserName ];

/// PJUNewUserNo
Property PJUNewUserNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PJU_NewUserNo ];

/// PJUNewPassWord
Property PJUNewPassWord As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PJU_NewPassWord ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMPProjectUser("0"))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="PJU_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PJU_Email">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PJU_EnDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PJU_EnTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PJU_NewPassWord">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PJU_NewUserName">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PJU_NewUserNo">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PJU_Profession_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PJU_Project_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PJU_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PJU_StDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PJU_StTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PJU_Standby">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PJU_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PJU_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PJU_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PJU_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PJU_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PJU_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PJU_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PJU_Tel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PJU_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PJU_Updateser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PJU_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PMPProjectUser</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PJU_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PJU_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="INDEXPJUProjectDR">
<Global>^PMPProjectUseri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PJU_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PJU_Project_DR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PJU_Project_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PJU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofNewUserName">
<Global>^PMPProjectUseri</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"NewUserName"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PJU_NewUserName}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofNewUserNo">
<Global>^PMPProjectUseri</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"NewUserNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PJU_NewUserNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSSUSER">
<Global>^PMPProjectUseri</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PJU_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"SSUSER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PJU_User_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PJU_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PJU_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPProjectUserS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
