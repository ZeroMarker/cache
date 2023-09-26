Class User.DHCEQResearch Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQResearch, StorageStrategy = SQLStorage ]
{

/// R_BussType
Property RBussType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = R_BussType ];

/// R_SourceType
Property RSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = R_SourceType ];

/// R_SourceID
Property RSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = R_SourceID ];

/// R_Code
Property RCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = R_Code ];

/// R_Desc
Property RDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = R_Desc ];

/// R_Type
Property RType As %Library.String(DISPLAYLIST = ",科研项目,论文,功能分类", MAXLEN = 3, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 7, SqlFieldName = R_Type ];

/// R_UserDR
Property RUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = R_UserDR ];

/// R_Participant
Property RParticipant As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = R_Participant ];

/// R_Level
Property RLevel As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = R_Level ];

/// R_BeginDate
Property RBeginDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = R_BeginDate ];

/// R_EndDate
Property REndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = R_EndDate ];

/// R_UsedFlag
Property RUsedFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = R_UsedFlag ];

/// R_DevelopStatus
Property RDevelopStatus As %Library.String(DISPLAYLIST = ",原有功能,可开发功能,已开发功能", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 14, SqlFieldName = R_DevelopStatus ];

/// R_InvalidFlag
Property RInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = R_InvalidFlag ];

/// R_UpdateUserDR
Property RUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = R_UpdateUserDR ];

/// R_UpdateDate
Property RUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = R_UpdateDate ];

/// R_UpdateTime
Property RUpdateTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = R_UpdateTime ];

/// R_Remark
Property RRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = R_Remark ];

/// R_Hold1
Property RHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = R_Hold1 ];

/// R_Hold2
Property RHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = R_Hold2 ];

/// R_Hold3
Property RHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = R_Hold3 ];

/// R_Hold4
Property RHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = R_Hold4 ];

/// R_Hold5
Property RHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = R_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQResearch("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="R_BeginDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="R_BussType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="R_Code">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="R_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="R_DevelopStatus">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="R_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="R_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="R_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="R_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="R_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="R_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="R_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="R_Level">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="R_Participant">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="R_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="R_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="R_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="R_Type">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="R_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="R_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="R_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="R_UsedFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="R_UserDR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^DHCEQResearch</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{R_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSource">
<Global>^DHCEQResearch</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>R_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{R_BussType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{R_SourceType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{R_SourceID}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{R_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>R_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQResearchS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
