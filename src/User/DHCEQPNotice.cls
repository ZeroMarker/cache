Class User.DHCEQPNotice Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = N_RowID, SqlTableName = DHC_EQPNotice, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// N_HospitalDR
Property NHospitalDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = N_HospitalDR ];

/// N_NoticeCat
Property NNoticeCat As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = N_NoticeCat ];

/// N_Title
Property NTitle As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = N_Title ];

/// N_SubTitle
Property NSubTitle As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = N_SubTitle ];

/// N_PublishDept
Property NPublishDept As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = N_PublishDept ];

/// N_PublishUser
Property NPublishUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = N_PublishUser ];

/// N_PublishDate
Property NPublishDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = N_PublishDate ];

/// N_PublishTime
Property NPublishTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = N_PublishTime ];

/// N_EffectiveDate
Property NEffectiveDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = N_EffectiveDate ];

/// N_Abstract
Property NAbstract As %Library.String(COLLATION = "Exact", MAXLEN = 120, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = N_Abstract ];

/// N_ContentType
Property NContentType As %Library.String(DISPLAYLIST = ",文本,图片,电子文件", MAXLEN = 2, SELECTIVITY = "25%", TRUNCATE = 1, VALUELIST = ",0,1,2") [ SqlColumnNumber = 12, SqlFieldName = N_ContentType ];

/// N_Content
Property NContent As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = N_Content ];

/// N_Standard
Property NStandard As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = N_Standard ];

/// N_Source
Property NSource As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = N_Source ];

/// N_ManageLocDR
Property NManageLocDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = N_ManageLocDR ];

/// N_Status
Property NStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 17, SqlFieldName = N_Status ];

/// N_Remark
Property NRemark As %Library.String(COLLATION = "Exact", MAXLEN = 150, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = N_Remark ];

/// N_InvalidFlag
Property NInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = N_InvalidFlag ];

/// N_Hold1
Property NHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = N_Hold1 ];

/// N_Hold2
Property NHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = N_Hold2 ];

/// N_Hold3
Property NHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = N_Hold3 ];

/// N_Hold4
Property NHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = N_Hold4 ];

/// N_Hold5
Property NHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = N_Hold5 ];

/// add by lmm 2020-04-20 增加查阅范围
/// N_SourceType
Property NSourceType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = N_SourceType ];

/// N_SourceID
Property NSourceID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = N_SourceID ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPNotice(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="N_Abstract">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="N_Content">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="N_ContentType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="N_EffectiveDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="N_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="N_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="N_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="N_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="N_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="N_HospitalDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="N_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="N_ManageLocDR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="N_NoticeCat">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="N_PublishDate">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="N_PublishDept">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="N_PublishTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="N_PublishUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="N_Remark">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="N_Source">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="N_SourceID">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="N_SourceType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="N_Standard">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="N_Status">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="N_SubTitle">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="N_Title">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQPNotice</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>N_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{N_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPNoticeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
