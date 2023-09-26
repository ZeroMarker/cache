Class User.DHCEQAppendFile Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AF_RowID, SqlTableName = DHC_EQAppendFile, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

// 0：无 11:开箱验收 12:安装调试验收 21:入库、22:转移 23:减少 31:维修、32保养、33检查、34报废、35折旧、41使用记录、51设备调帐,52 设备 61工程管理 62科研课题 91采购申请 92采购计划 93采购招标 94采购合同

/// AF_OriginalType
/// Property AFOriginalType As %Library.String(DISPLAYLIST = ",论证,合同,采购申请,设备,维修,报废,计划,检查,验收", MAXLEN = 4, SELECTIVITY = "10.0000%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6,7,8,9") [ SqlColumnNumber = 2, SqlFieldName = AF_OriginalType ];
Property AFSourceType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = AF_SourceType ];

/// AF_OriginalID
/// Property AFOriginalID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AF_OriginalID ];
Property AFSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = AF_SourceID ];

/// AF_AppendFileTypeDR
Property AFAppendFileTypeDR As User.DHCEQCAppendFileType [ SqlColumnNumber = 4, SqlFieldName = AF_AppendFileTypeDR ];

/// AF_DocName
Property AFDocName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = AF_DocName ];

/// AF_FileName
Property AFFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = AF_FileName ];

/// AF_FilePath
Property AFFilePath As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = AF_FilePath ];

/// AF_FileType
Property AFFileType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = AF_FileType ];

/// AF_Remark
Property AFRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = AF_Remark ];

/// AF_AddUserDR
Property AFAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = AF_AddUserDR ];

/// AF_AddDate
Property AFAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = AF_AddDate ];

/// AF_AddTime
Property AFAddTime As %Library.Time [ SqlColumnNumber = 12, SqlFieldName = AF_AddTime ];

/// AF_SubmitUserDR
Property AFSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AF_SubmitUserDR ];

/// AF_SubmitDate
Property AFSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = AF_SubmitDate ];

/// AF_SubmitTime
Property AFSubmitTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = AF_SubmitTime ];

/// AF_AuditUserDR
Property AFAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AF_AuditUserDR ];

/// AF_AuditDate
Property AFAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = AF_AuditDate ];

/// AF_AuditTime
Property AFAuditTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = AF_AuditTime ];

/// AF_Stauts
Property AFStauts As %String(DISPLAYLIST = ",新增,提交,审核", MAXLEN = 2, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 19, SqlFieldName = AF_Stauts ];

/// AF_InvalidFlag
Property AFInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = AF_InvalidFlag ];

/// AF_ToSwfFlag
Property AFToSwfFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = AF_ToSwfFlag ];

/// AF_Hold2
Property AFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = AF_Hold2 ];

/// AF_Hold3
Property AFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AF_Hold3 ];

/// AF_Hold4
Property AFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AF_Hold4 ];

/// AF_Hold5
Property AFHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AF_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQAppendFile("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AF_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AF_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AF_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AF_AppendFileTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AF_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AF_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AF_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AF_DocName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AF_FileName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AF_FilePath">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AF_FileType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AF_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AF_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AF_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AF_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AF_Stauts">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AF_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AF_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AF_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AF_ToSwfFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^DHCEQAppendFile</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{AF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOriginal">
<Global>^DHCEQAppendFile</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"SourceType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{AF_SourceType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{AF_SourceID}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{AF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQAppendFileS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
