Class User.DHCEQPMReport Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PMR_RowID, SqlTableName = DHC_EQPMReport, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PMR_TemplateDR
Property PMRTemplateDR As User.DHCEQCPMTemplate [ SqlColumnNumber = 2, SqlFieldName = PMR_TemplateDR ];

/// PMR_MaintDR
Property PMRMaintDR As User.DHCEQCMaintItem [ SqlColumnNumber = 3, SqlFieldName = PMR_MaintDR ];

/// PMR_Caption
Property PMRCaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PMR_Caption ];

/// PMR_Note
Property PMRNote As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PMR_Note ];

/// PMR_PreState
Property PMRPreState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PMR_PreState ];

/// PMR_State
Property PMRState As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PMR_State ];

/// PMR_Remark
Property PMRRemark As %Library.String(COLLATION = "Exact", MAXLEN = 160, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = PMR_Remark ];

/// PMR_Status
Property PMRStatus As %Library.String(DISPLAYLIST = ",新增,提交,审核,作废", MAXLEN = 2, SELECTIVITY = "20.0000%", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlColumnNumber = 9, SqlFieldName = PMR_Status ];

/// PMR_InvalidFlag
Property PMRInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = PMR_InvalidFlag ];

/// PMR_AddUserDR
Property PMRAddUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PMR_AddUserDR ];

/// PMR_AddDate
Property PMRAddDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = PMR_AddDate ];

/// PMR_AddTime
Property PMRAddTime As %Library.Time [ SqlColumnNumber = 13, SqlFieldName = PMR_AddTime ];

/// PMR_SubmitUserDR
Property PMRSubmitUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PMR_SubmitUserDR ];

/// PMR_SubmitDate
Property PMRSubmitDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 15, SqlFieldName = PMR_SubmitDate ];

/// PMR_SubmitTime
Property PMRSubmitTime As %Library.Time [ SqlColumnNumber = 16, SqlFieldName = PMR_SubmitTime ];

/// PMR_AuditUserDR
Property PMRAuditUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PMR_AuditUserDR ];

/// PMR_AuditDate
Property PMRAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = PMR_AuditDate ];

/// PMR_AuditTime
Property PMRAuditTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = PMR_AuditTime ];

/// PMR_DropUserDR
Property PMRDropUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PMR_DropUserDR ];

/// PMR_DropDate
Property PMRDropDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = PMR_DropDate ];

/// PMR_DropTime
Property PMRDropTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = PMR_DropTime ];

/// PMR_Hold1
Property PMRHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PMR_Hold1 ];

/// PMR_Hold2
Property PMRHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PMR_Hold2 ];

/// PMR_Hold3
Property PMRHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PMR_Hold3 ];

/// PMR_Hold4
Property PMRHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PMR_Hold4 ];

/// PMR_Hold5
Property PMRHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PMR_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQPMReport("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PMR_AddDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PMR_AddTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PMR_AddUserDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PMR_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PMR_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PMR_AuditUserDR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PMR_Caption">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMR_DropDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PMR_DropTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PMR_DropUserDR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PMR_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PMR_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PMR_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PMR_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PMR_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PMR_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PMR_MaintDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMR_Note">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMR_PreState">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMR_Remark">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PMR_State">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PMR_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PMR_SubmitDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PMR_SubmitTime">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PMR_SubmitUserDR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PMR_TemplateDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQPMReport</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{PMR_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMaintDR">
<Global>^DHCEQPMReport</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PMR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"MaintDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMR_MaintDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQPMReportS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
