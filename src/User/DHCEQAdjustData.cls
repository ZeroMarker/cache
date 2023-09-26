Class User.DHCEQAdjustData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AD_RowID, SqlTableName = DHC_EQAdjustData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// AD_Content
Property ADContent As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AD_Content ];

/// AD_Date
Property ADDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = AD_Date ];

/// AD_DisplayFlag
Property ADDisplayFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = AD_DisplayFlag ];

/// AD_Hold1
Property ADHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AD_Hold1 ];

/// AD_Hold2
Property ADHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AD_Hold2 ];

/// AD_Hold3
Property ADHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AD_Hold3 ];

/// AD_Hold4
Property ADHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AD_Hold4 ];

/// AD_Hold5
Property ADHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AD_Hold5 ];

/// AD_InvalidDate
Property ADInvalidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = AD_InvalidDate ];

/// AD_InvalidReason
Property ADInvalidReason As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AD_InvalidReason ];

/// AD_InvalidTime
Property ADInvalidTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = AD_InvalidTime ];

/// AD_InvalidUser
Property ADInvalidUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = AD_InvalidUser ];

/// AD_Remark
Property ADRemark As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AD_Remark ];

/// AD_ReportFlag
Property ADReportFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = AD_ReportFlag ];

/// AD_RequestUser
Property ADRequestUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AD_RequestUser ];

/// AD_SQL
Property ADSQL As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AD_SQL ];

/// AD_SourceFile
Property ADSourceFile As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AD_SourceFile ];

/// AD_Status
Property ADStatus As %Library.String(DISPLAYLIST = ",新增,执行,作废", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 12, SqlFieldName = AD_Status ];

/// AD_Time
Property ADTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = AD_Time ];

/// AD_Type
Property ADType As %Library.String(DISPLAYLIST = ",调整数据,新增数据,删除数据,取消报废,设备合并,设备拆分,其他调整", MAXLEN = 4, SELECTIVITY = "12.5000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6,9") [ SqlColumnNumber = 2, SqlFieldName = AD_Type ];

/// AD_UpdateDate
Property ADUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = AD_UpdateDate ];

/// AD_UpdateTime
Property ADUpdateTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = AD_UpdateTime ];

/// AD_UpdateUserDR
Property ADUpdateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AD_UpdateUserDR ];

/// AD_User
Property ADUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AD_User ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAdjustData("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AD_Content">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AD_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AD_DisplayFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AD_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AD_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AD_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AD_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AD_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AD_InvalidDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AD_InvalidReason">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AD_InvalidTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AD_InvalidUser">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AD_ReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AD_RequestUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AD_SQL">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AD_SourceFile">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AD_Status">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AD_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AD_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AD_UpdateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AD_User">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQAdjustData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AD_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlagDate">
<Global>^DHCEQAdjustData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"FlagDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AD_ReportFlag}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AD_Type}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDate">
<Global>^DHCEQAdjustData</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AD_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{AD_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AD_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AD_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAdjustDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
