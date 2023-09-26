/// for Prepay Footing
Class User.DHCAccPDFootLog Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = AccPDF_RowID, SqlTableName = DHC_AccPDFootLog, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Date for Foot Prepay
Property AccPDFDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = AccPDF_Date ];

/// AccPDF_Time
Property AccPDFTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = AccPDF_Time ];

/// AccPDF_User_DR
Property AccPDFUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = AccPDF_User_DR ];

/// AccPDF_LastDate
Property AccPDFLastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = AccPDF_LastDate ];

/// AccPDF_LastTime
Property AccPDFLastTime As %Library.Time [ SqlColumnNumber = 6, SqlFieldName = AccPDF_LastTime ];

/// AccPDF_OperUser_DR
Property AccPDFOperUserDR As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = AccPDF_OperUser_DR ];

/// AccPDF_INSFootUser
Property AccPDFINSFootUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = AccPDF_INSFootUser ];

/// AccPDF_INSFootDate
Property AccPDFINSFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = AccPDF_INSFootDate ];

/// AccPDF_INSFootTime
Property AccPDFINSFootTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = AccPDF_INSFootTime ];

/// AccPDF_Note4
Property AccPDFNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = AccPDF_Note4 ];

/// AccPDF_Note5
Property AccPDFNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = AccPDF_Note5 ];

/// AccPDF_Note6
Property AccPDFNote6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = AccPDF_Note6 ];

/// AccPDF_Note7
Property AccPDFNote7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = AccPDF_Note7 ];

/// AccPDF_footnum
Property AccPDFfootnum As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = AccPDF_footnum ];

/// AccPDF_refundnum
Property AccPDFrefundnum As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = AccPDF_refundnum ];

/// AccPDF_footsum
Property AccPDFfootsum As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = AccPDF_footsum ];

/// AccPDF_pdsum
Property AccPDFpdsum As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = AccPDF_pdsum ];

/// AccPDF_refundsum
Property AccPDFrefundsum As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = AccPDF_refundsum ];

/// AccPDF_cashsum
Property AccPDFcashsum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = AccPDF_cashsum ];

/// AccPDF_chequesum
Property AccPDFchequesum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = AccPDF_chequesum ];

/// AccPDF_othersum
Property AccPDFothersum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = AccPDF_othersum ];

/// AccPDF_rcptstr
Property AccPDFrcptstr As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = AccPDF_rcptstr ];

/// AccPDF_Other1
Property AccPDFOther1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = AccPDF_Other1 ];

/// AccPDF_Other2
Property AccPDFOther2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = AccPDF_Other2 ];

/// AccPDF_Other3
Property AccPDFOther3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = AccPDF_Other3 ];

/// AccPDF_Other4
Property AccPDFOther4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = AccPDF_Other4 ];

/// AccPDF_Other5
Property AccPDFOther5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = AccPDF_Other5 ];

/// AccPDF_Other6
Property AccPDFOther6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = AccPDF_Other6 ];

/// AccPDF_Other7
Property AccPDFOther7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = AccPDF_Other7 ];

/// AccPDF_Other8
Property AccPDFOther8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = AccPDF_Other8 ];

/// AccPDF_Other9
Property AccPDFOther9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = AccPDF_Other9 ];

/// AccPDF_Other10
Property AccPDFOther10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = AccPDF_Other10 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCACD("AccPDFL"))</SqlIdExpression>
<SQLMap name="IndexPFDate">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AccPDF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPDFL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"FootDT"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPDF_Date}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPDF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^DHCACDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>AccPDF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPDFL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"OperUser"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{AccPDF_OperUser_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{AccPDF_Date}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{AccPDF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMapPDF">
<Data name="AccPDF_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AccPDF_INSFootDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AccPDF_INSFootTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AccPDF_INSFootUser">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AccPDF_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AccPDF_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AccPDF_Note4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AccPDF_Note5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AccPDF_Note6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="AccPDF_Note7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="AccPDF_OperUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AccPDF_Other1">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="AccPDF_Other10">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="AccPDF_Other2">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="AccPDF_Other3">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="AccPDF_Other4">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="AccPDF_Other5">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="AccPDF_Other6">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="AccPDF_Other7">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="AccPDF_Other8">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="AccPDF_Other9">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="AccPDF_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="AccPDF_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AccPDF_cashsum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="AccPDF_chequesum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="AccPDF_footnum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="AccPDF_footsum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="AccPDF_othersum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="AccPDF_pdsum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="AccPDF_rcptstr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="AccPDF_refundnum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="AccPDF_refundsum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Global>^DHCACD</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AccPDF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"AccPDFL"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{AccPDF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPDFootLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
