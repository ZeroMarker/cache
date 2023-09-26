Class User.PMPJobLogging Extends %Library.Persistent [ ClassType = persistent, Inheritance = right, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JLG_Rowid, SqlTableName = PMP_JobLogging, StorageStrategy = SQLStorage ]
{

Property JLGDate As %Date [ SqlColumnNumber = 2, SqlFieldName = JLG_Date ];

Property JLGTime As %Time [ SqlColumnNumber = 3, SqlFieldName = JLG_Time ];

Property JLGUser As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JLG_User ];

Property JLGContent As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = JLG_Content ];

Property JLGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = JLG_Desc ];

Property JLGSolution As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = JLG_Solution ];

Property JLGDR As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = JLG_DR ];

Property JLGFinishDate As %Date [ SqlColumnNumber = 9, SqlFieldName = JLG_FinishDate ];

Property JLGFinishTime As %Time [ SqlColumnNumber = 10, SqlFieldName = JLG_FinishTime ];

Property JLGStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = JLG_Standby1 ];

Property JLGStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = JLG_Standby2 ];

Property JLGStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = JLG_Standby3 ];

Property JLGStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = JLG_Standby4 ];

Property JLGStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = JLG_Standby5 ];

Property JLGStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = JLG_Standby6 ];

Property JLGStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = JLG_Standby7 ];

Property JLGStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = JLG_Standby8 ];

Property JLGStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = JLG_Standby9 ];

Property JLGStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = JLG_Standby10 ];

Property JLGStandby11 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = JLG_Standby11 ];

Property JLGImprovmentDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = JLG_Improvment_DR ];

Property JLGJobLoggDR As PMPJobLogging [ SqlColumnNumber = 23, SqlFieldName = JLG_JobLogg_DR ];

Property JLGModuleDR As PMPModule [ SqlColumnNumber = 24, SqlFieldName = JLG_Module_DR ];

Property JLGContractAgingDR As PMPContractAging [ SqlColumnNumber = 25, SqlFieldName = JLG_ContractAging_DR ];

Property JLGContractDR As PMPContract [ SqlColumnNumber = 26, SqlFieldName = JLG_Contract_DR ];

Property JLGLOCDR As CTLoc [ SqlColumnNumber = 27, SqlFieldName = JLG_LCO_DR ];

Property JLGUserDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = JLG_User_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPJobLogging(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="JLG_Content">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="JLG_ContractAging_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="JLG_Contract_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="JLG_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="JLG_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="JLG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="JLG_FinishDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="JLG_FinishTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="JLG_Improvment_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="JLG_JobLogg_DR">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="JLG_LCO_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="JLG_Module_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="JLG_Solution">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="JLG_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="JLG_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="JLG_Standby11">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="JLG_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="JLG_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="JLG_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="JLG_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="JLG_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="JLG_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="JLG_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="JLG_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="JLG_Time">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="JLG_User">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="JLG_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Global>^PMPJobLogging</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>JLG_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofContract">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_Contract_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofContractAging">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ContarctAging"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_ContractAging_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofImprovment">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Improvment"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_Improvment_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofJLGDate">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"JLG_Date"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_Date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofJLGUser">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"JLG_User"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_User}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofJobLogg">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"JobLogg"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_JobLogg_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofModule">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_Module_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofStandby4">
<Global>^PMPJobLogi</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Standby4"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{JLG_Standby4}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{JLG_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPJobLoggingS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
