Class User.DHCRBApplicationBill Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DRA_Rowid, SqlTableName = DHCRB_ApplicationBill, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCRBApplicationBillOrdIt As User.DHCRBApplicationBillOrdIt [ Cardinality = children, Inverse = DAOParRef ];

/// DRA_Date
Property DRADate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = DRA_Date ];

/// DRA_IllNess_DR
Property DRAIllNessDR As User.DHCRBCIllStatus [ SqlColumnNumber = 3, SqlFieldName = DRA_IllNess_DR ];

/// DRA_USER_DR
Property DRAUSERDR As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DRA_USER_DR ];

/// DRA_Goal_DR
Property DRAGoalDR As User.DHCRBCGoal [ SqlColumnNumber = 5, SqlFieldName = DRA_Goal_DR ];

/// DRA_LocID_DR
Property DRALocIDDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = DRA_LocID_DR ];

/// DRA_MainDiagnose_
Property DRAMainDiagnose As %Library.String(COLLATION = "Exact", MAXLEN = 900, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DRA_MainDiagnose ];

/// DRA_OeItemID_DR
Property DRAOeItemIDDR As User.OEOrdItem [ SqlColumnNumber = 8, SqlFieldName = DRA_OeItemID_DR ];

/// DRA_Print
Property DRAPrint As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DRA_Print ];

/// DRA_Time
Property DRATime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DRA_Time ];

/// DRA_Xdate
Property DRAXdate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = DRA_Xdate ];

/// DRA_Medium_DR
Property DRAMediumDR As User.DHCRBCMedium [ SqlColumnNumber = 12, SqlFieldName = DRA_Medium_DR ];

/// DRA_FullFileName
Property DRAFullFileName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DRA_FullFileName ];

/// DRA_MPrint
Property DRAMPrint As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DRA_MPrint ];

/// DRA_XMLContent
Property DRAXMLContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DRA_XMLContent ];

/// DRA_HtmlContent
Property DRAHtmlContent As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DRA_HtmlContent ];

/// DRA_TotalFee
Property DRATotalFee As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = DRA_TotalFee ];

/// DRA_APPNO
Property DRAAPPNO As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DRA_APPNO ];

/// DRA_CLASS
Property DRACLASS As %Library.String(COLLATION = "Exact", MAXLEN = 64, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = DRA_CLASS ];

/// DRA_SUBCLASS
Property DRASUBCLASS As %Library.String(COLLATION = "Exact", MAXLEN = 64, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DRA_SUBCLASS ];

/// DRA_CTDesc
Property DRACTDesc As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = DRA_CTDesc ];

/// DRA_XDesc
Property DRAXDesc As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DRA_XDesc ];

/// DRA_SMOKEHISTORY
Property DRASMOKEHISTORY As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DRA_SMOKEHISTORY ];

/// DRA_CLINSYMP
Property DRACLINSYMP As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = DRA_CLINSYMP ];

/// DRA_STUDYAIM
Property DRASTUDYAIM As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DRA_STUDYAIM ];

/// DRA_Remark
Property DRARemark As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = DRA_Remark ];

/// DRA_Remark1
Property DRARemark1 As %Library.String(COLLATION = "Exact", MAXLEN = 512, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DRA_Remark1 ];

/// DRA_DoctorId
Property DRADoctorId As User.CTCareProv [ SqlColumnNumber = 28, SqlFieldName = DRA_DoctorId ];

/// DRA_URGENCY
Property DRAURGENCY As %Library.String(COLLATION = "Exact", MAXLEN = 2, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = DRA_URGENCY ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBApp("Bill"))</SqlIdExpression>
<SQLMap name="IndexAppNo">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AppNo"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_APPNO}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AppDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DRA_APPNO">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DRA_CLASS">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DRA_CLINSYMP">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DRA_CTDesc">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DRA_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRA_DoctorId">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DRA_FullFileName">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DRA_Goal_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRA_HtmlContent">
<Node>"html"</Node>
</Data>
<Data name="DRA_IllNess_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DRA_LocID_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRA_MPrint">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DRA_MainDiagnose">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRA_Medium_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DRA_OeItemID_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRA_Print">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRA_Remark">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DRA_Remark1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DRA_SMOKEHISTORY">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DRA_STUDYAIM">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DRA_SUBCLASS">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DRA_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRA_TotalFee">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DRA_URGENCY">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DRA_USER_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DRA_XDesc">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DRA_XMLContent">
<Node>"XMLContent"</Node>
</Data>
<Data name="DRA_Xdate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^DHCRBApp</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Bill"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexorder">
<Global>^DHCRBAppi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRA_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OrdRowid"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRA_OeItemID_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRA_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBApplicationBillS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
