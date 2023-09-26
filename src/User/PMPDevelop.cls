Class User.PMPDevelop Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DL_Rowid, SqlTableName = PMP_Develop, StorageStrategy = SQLStorage ]
{

Relationship ChildPMPDevelopAppraisal As PMPDevelopAppraisal [ Cardinality = children, Inverse = PMPDevelopAppraisalParRef ];

Relationship ChildPMPDevelopImprovement As PMPDevelopImprovement [ Cardinality = children, Inverse = PMPDevelopImprovementParRef ];

/// DLInDate
Property DLInDate As %Date [ SqlColumnNumber = 2, SqlFieldName = DL_InDate ];

/// DLOutDate
Property DLOutDate As %Date [ SqlColumnNumber = 3, SqlFieldName = DL_OutDate ];

/// DLUser
Property DLUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DL_User ];

/// DLStatus
Property DLStatus As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DL_Status ];

/// DLName
Property DLName As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DL_Name ];

/// DLProductDR
Property DLProductDR As PMPDictionary3 [ SqlColumnNumber = 7, SqlFieldName = DL_Product_DR ];

/// DLRecordDate
Property DLRecordDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DL_RecordDate ];

/// DLRecordTime
Property DLRecordTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DL_RecordTime ];

/// DLInTime
Property DLInTime As %Time [ SqlColumnNumber = 10, SqlFieldName = DL_InTime ];

/// DLOutTime
Property DLOutTime As %Time [ SqlColumnNumber = 11, SqlFieldName = DL_OutTime ];

/// DLTel
Property DLTel As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DL_Tel ];

/// DLEmail
Property DLEmail As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DL_Email ];

/// DLNameSimplicty
Property DLNameSimplicty As %String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DL_NameSimplicty ];

/// DLBusinessReason
Property DLBusinessReason As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DL_BusinessReason ];

/// DLStaisFaction
Property DLStaisFaction As PMPDictionary3 [ SqlColumnNumber = 16, SqlFieldName = DL_StaisFaction ];

/// DLAttendance
Property DLAttendance As PMPDictionary3 [ SqlColumnNumber = 17, SqlFieldName = DL_Attendance ];

/// DLWorkEfficiency
Property DLWorkEfficiency As PMPDictionary3 [ SqlColumnNumber = 18, SqlFieldName = DL_WorkEfficiency ];

/// DLWorkAttitude
Property DLWorkAttitude As PMPDictionary3 [ SqlColumnNumber = 19, SqlFieldName = DL_WorkAttitude ];

/// DLOtherStais
Property DLOtherStais As PMPDictionary3 [ SqlColumnNumber = 20, SqlFieldName = DL_OtherStais ];

/// DLBY1
Property DLBY1 As PMPDictionary3 [ SqlColumnNumber = 21, SqlFieldName = DL_BY1 ];

/// DLBY2
Property DLBY2 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DL_BY2 ];

/// DLBY3
Property DLBY3 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = DL_BY3 ];

/// DLBY4
Property DLBY4 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = DL_BY4 ];

/// DLBY5
Property DLBY5 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = DL_BY5 ];

/// DLBY6
Property DLBY6 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = DL_BY6 ];

/// DLBY7
Property DLBY7 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = DL_BY7 ];

/// DLBY8
Property DLBY8 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = DL_BY8 ];

/// DLBY9
Property DLBY9 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = DL_BY9 ];

/// DLBY10
Property DLBY10 As %String(COLLATION = "Exact", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = DL_BY10 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$I(^User.PMPDevelop(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="DL_Attendance">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DL_BY1">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DL_BY10">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DL_BY2">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DL_BY3">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DL_BY4">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DL_BY5">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DL_BY6">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DL_BY7">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DL_BY8">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DL_BY9">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DL_BusinessReason">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DL_Email">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DL_InDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DL_InTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DL_Name">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DL_NameSimplicty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DL_OtherStais">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DL_OutDate">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DL_OutTime">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DL_Product_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DL_RecordDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DL_RecordTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DL_StaisFaction">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DL_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DL_Tel">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DL_User">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DL_WorkAttitude">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DL_WorkEfficiency">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Global>^PMPDevelop</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DL_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofInDate">
<Global>^PMPDevelop</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"InDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DL_InDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofNameSimplicty">
<Global>^PMPDevelop</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"NameSimplicty"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DL_NameSimplicty}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofOutDate">
<Global>^PMPDevelop</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"OutDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DL_OutDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofProductDR">
<Global>^PMPDevelop</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ProductDR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DL_Product_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DL_Rowid</SqlRowIdName>
<StreamLocation>^User.PMPDevelopS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
