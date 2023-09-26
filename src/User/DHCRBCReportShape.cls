Class User.DHCRBCReportShape Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRS_RowID, SqlTableName = DHCRBC_ReportShape, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DRS_TemplateFile
Property DRSTemplateFile As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DRS_TemplateFile ];

/// DRS_TableFile
Property DRSTableFile As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DRS_TableFile ];

/// DRS_HeadHeight
Property DRSHeadHeight As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DRS_HeadHeight ];

/// DRS_FootHeight
Property DRSFootHeight As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DRS_FootHeight ];

/// DRS_LeftWidth
Property DRSLeftWidth As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = DRS_LeftWidth ];

/// DRS_RightWidth
Property DRSRightWidth As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = DRS_RightWidth ];

/// DRS_ImageWidth
Property DRSImageWidth As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = DRS_ImageWidth ];

/// DRS_ImageHeight
Property DRSImageHeight As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = DRS_ImageHeight ];

/// DRS_Medium_DR
Property DRSMediumDR As User.DHCRBCMedium [ SqlColumnNumber = 11, SqlFieldName = DRS_Medium_DR ];

/// DRS_SeeHeight
Property DRSSeeHeight As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = DRS_SeeHeight ];

/// DRS_SeeWidth
Property DRSSeeWidth As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = DRS_SeeWidth ];

/// DRS_ResultHeight
Property DRSResultHeight As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = DRS_ResultHeight ];

/// DRS_ReportDocHeight
Property DRSReportDocHeight As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = DRS_ReportDocHeight ];

/// DRS_ReportDocWidth
Property DRSReportDocWidth As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = DRS_ReportDocWidth ];

/// DRS_ImageTimes
Property DRSImageTimes As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DRS_ImageTimes ];

/// DRS_ResultWidth
Property DRSResultWidth As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = DRS_ResultWidth ];

/// DRS_Desc
Property DRSDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DRS_Desc ];

/// DRS_Type
Property DRSType As %Library.String(DISPLAYLIST = ",Application,Report", MAXLEN = 11, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",A,R") [ SqlColumnNumber = 20, SqlFieldName = DRS_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("ReportShape"))</SqlIdExpression>
<SQLMap name="MasterDataIndex">
<Data name="DRS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRS_FootHeight">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRS_HeadHeight">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRS_ImageHeight">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRS_ImageTimes">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRS_ImageWidth">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRS_LeftWidth">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRS_Medium_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRS_ReportDocHeight">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRS_ReportDocWidth">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRS_ResultHeight">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRS_ResultWidth">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRS_RightWidth">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRS_SeeHeight">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DRS_SeeWidth">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRS_TableFile">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRS_TemplateFile">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRS_Type">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ReportShape"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCReportShapeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
