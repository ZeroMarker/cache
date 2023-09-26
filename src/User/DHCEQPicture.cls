Class User.DHCEQPicture Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PT_RowID, SqlTableName = DHC_EQPicture, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PT_PicTypeDR
Property PTPicTypeDR As User.DHCEQCPicType [ SqlColumnNumber = 6, SqlFieldName = PT_PicTypeDR ];

/// PT_EquipDR
Property PTEquipDR As User.DHCEQEquip [ SqlColumnNumber = 2, SqlFieldName = PT_EquipDR ];

/// PT_PicName 编译之后只能MAXLEN增加无法减少
Property PTPicName As %Library.String(MAXLEN = 300) [ SqlColumnNumber = 14, SqlFieldName = PT_PicName ];

/// PT_DutyUserDR
Property PTDutyUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PT_DutyUserDR ];

/// PT_AddUserDR
Property PTAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PT_AddUserDR ];

/// PT_AddDate
Property PTAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = PT_AddDate ];

/// PT_AddTime
Property PTAddTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = PT_AddTime ];

/// PT_Hold6
Property PTHold6 As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PT_Hold6 ];

/// PT_InvalidFlag
Property PTInvalidFlag As %Library.String(DISPLAYLIST = ",新增,修改,删除", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 8, SqlFieldName = PT_InvalidFlag ];

/// PT_Path
Property PTPath As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PT_Path ];

/// PT_PictureNo
Property PTPictureNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PT_PictureNo ];

/// PT_Remark
Property PTRemark As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PT_Remark ];

/// PT_SourceID
Property PTSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PT_SourceID ];

/// PT_SourceType
Property PTSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PT_SourceType ];

/// PT_UpdateDate
Property PTUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = PT_UpdateDate ];

/// PT_UpdateTime
Property PTUpdateTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = PT_UpdateTime ];

/// PT_UpdateUser
Property PTUpdateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PT_UpdateUser ];

Property PTLocation As %String [ SqlColumnNumber = 19, SqlFieldName = PT_Location ];

Property PTStauts As %String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 20, SqlFieldName = PT_Stauts ];

Property PTSubmitUserDR As %String [ SqlColumnNumber = 21, SqlFieldName = PT_SubmitUserDR ];

Property PTSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = PT_SubmitDate ];

Property PTSubmitTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = PT_SubmitTime ];

Property PTAuditUserDR As %String [ SqlColumnNumber = 24, SqlFieldName = PT_AuditUserDR ];

Property PTAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = PT_AuditDate ];

Property PTAuditTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = PT_AuditTime ];

Property PTHold1 As %String [ SqlColumnNumber = 27, SqlFieldName = PT_Hold1 ];

Property PTHold2 As %String [ SqlColumnNumber = 28, SqlFieldName = PT_Hold2 ];

Property PTHold3 As %String [ SqlColumnNumber = 29, SqlFieldName = PT_Hold3 ];

Property PTHold4 As %String [ SqlColumnNumber = 30, SqlFieldName = PT_Hold4 ];

Property PTHold5 As %String [ SqlColumnNumber = 31, SqlFieldName = PT_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPicture("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PT_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PT_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PT_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PT_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PT_DutyUserDR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PT_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PT_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PT_Location">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PT_Path">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PT_PicName">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PT_PicTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PT_PictureNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PT_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PT_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PT_Stauts">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PT_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PT_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PT_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PT_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PT_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PT_UpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCEQPicture</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquip">
<Global>^DHCEQPicture</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Equip"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PT_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQPicture</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Source"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PT_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PT_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PT_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPictureS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
