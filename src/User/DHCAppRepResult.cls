Class User.DHCAppRepResult Extends %Persistent [ SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepResult, StorageStrategy = SQLStorage ]
{

/// AR_Pointer	项目id
Property ARPointer As %Library.String [ SqlColumnNumber = 2, SqlFieldName = AR_Pointer ];

/// AR_Type	"A"-检查申请,"P"-病理申请
Property ARType As %Library.String(DISPLAYLIST = ",A,P", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",A,P") [ SqlColumnNumber = 3, SqlFieldName = AR_Type ];

/// AR_Oeori_Dr	医嘱id
Property AROeoriDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = AR_Oeori_Dr ];

/// AR_PisStuNo	病理号
Property ARPisStuNo As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AR_PisStuNo ];

/// AR_BaseDocCode	取材医生代码
Property ARBaseDocCode As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AR_BaseDocCode ];

/// AR_BaseDoc	取材医生
Property ARBaseDoc As %Library.String [ SqlColumnNumber = 7, SqlFieldName = AR_BaseDoc ];

/// AR_RUserCode	报告医生代码
Property ARRUserCode As %Library.String [ SqlColumnNumber = 8, SqlFieldName = AR_RUserCode ];

/// AR_RUser	报告医生
Property ARRUser As %Library.String [ SqlColumnNumber = 9, SqlFieldName = AR_RUser ];

/// AR_RDate	报告日期
Property ARRDate As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AR_RDate ];

/// AR_RTime	报告时间
Property ARRTime As %Library.String [ SqlColumnNumber = 11, SqlFieldName = AR_RTime ];

/// AR_AUserCode	审核医生代码
Property ARAUserCode As %Library.String [ SqlColumnNumber = 12, SqlFieldName = AR_AUserCode ];

/// AR_AUser	审核医生
Property ARAUser As %Library.String [ SqlColumnNumber = 13, SqlFieldName = AR_AUser ];

/// AR_ADate	审核日期
Property ARADate As %Library.String [ SqlColumnNumber = 14, SqlFieldName = AR_ADate ];

/// AR_ATime	审核时间
Property ARATime As %Library.String [ SqlColumnNumber = 15, SqlFieldName = AR_ATime ];

/// AR_Notes	备注
Property ARNotes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = AR_Notes ];

/// AR_ImgPath	图像的路径（多幅图使用@分割）
Property ARImgPath As %Library.String [ SqlColumnNumber = 17, SqlFieldName = AR_ImgPath ];

/// AR_SeeRes	肉眼所见(用于病理取材)
Property ARSeeRes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = AR_SeeRes ];

/// AR_ExaRes	检查所见
Property ARExaRes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = AR_ExaRes ];

/// AR_ResDiag	诊断结果
Property ARResDiag As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = AR_ResDiag ];

/// AR_ResFlag	检查结果
Property ARResFlag As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = AR_ResFlag ];

/// AR_ResAbnormal	结果异常
Property ARResAbnormal As %Library.String [ SqlColumnNumber = 22, SqlFieldName = AR_ResAbnormal ];

/// AR_Pis_Dr	PIS报告ID
Property ARPisDr As %Library.String [ SqlColumnNumber = 23, SqlFieldName = AR_Pis_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPRR)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_ADate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AR_ATime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AR_AUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AR_AUserCode">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_BaseDoc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_BaseDocCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_ExaRes">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="AR_ImgPath">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AR_Notes">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AR_Oeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_PisStuNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_Pis_Dr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_RDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_RTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_RUser">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_RUserCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_ResAbnormal">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AR_ResDiag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AR_ResFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AR_SeeRes">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AR_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPRR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrdItem">
<Global>^DHCAPPRR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Oeori_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCAPPRR</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepResultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
