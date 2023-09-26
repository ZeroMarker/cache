Class User.PMPModule Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MODE_Rowid, SqlTableName = PMP_Module, StorageStrategy = SQLStorage ]
{

Relationship ChildPMPModule As PMPModuleDetail [ Cardinality = children, Inverse = PMPModuleParRef ];

/// MODECode
Property MODECode As %String(COLLATION = "AlphaUp", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = MODE_Code ];

/// MODEDesc
Property MODEDesc As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MODE_Desc ];

/// MODEProject1DR
Property MODEProject1DR As PMPProject [ SqlColumnNumber = 4, SqlFieldName = MODE_Project1_DR ];

/// MODERemark
Property MODERemark As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = MODE_Remark ];

/// MODEDate
Property MODEDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MODE_Date ];

/// MODETime
Property MODETime As %Time [ SqlColumnNumber = 7, SqlFieldName = MODE_Time ];

/// MODEPlanDate
Property MODEPlanDate As %Date [ SqlColumnNumber = 8, SqlFieldName = MODE_PlanDate ];

/// MODEActuclDate
Property MODEActuclDate As %Date [ SqlColumnNumber = 9, SqlFieldName = MODE_ActuclDate ];

/// MODEStatusDR
Property MODEStatusDR As PMPDictionary3 [ SqlColumnNumber = 10, SqlFieldName = MODE_Status_DR ];

/// MODEUserDR
Property MODEUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MODE_User_DR ];

/// MODEUpdateDate
Property MODEUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = MODE_UpdateDate ];

/// MODEUpdateTime
Property MODEUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = MODE_UpdateTime ];

/// MODEUpdateUserDR
Property MODEUpdateUserDR As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = MODE_UpdateUser_DR ];

/// MODEProductDR
Property MODEProductDR As PMPDictionary3 [ SqlColumnNumber = 15, SqlFieldName = MODE_Product_DR ];

/// MODEDevelopUser
Property MODEDevelopUser As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = MODE_DevelopUser ];

/// MODEStandby1
Property MODEStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = MODE_Standby1 ];

/// MODEStandby2
Property MODEStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = MODE_Standby2 ];

/// MODEStandby3
Property MODEStandby3 As PMPProduct [ SqlColumnNumber = 19, SqlFieldName = MODE_Standby3 ];

/// MODEStandby4
Property MODEStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = MODE_Standby4 ];

/// MODEStandby5
Property MODEStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = MODE_Standby5 ];

/// MODEStandby6
Property MODEStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = MODE_Standby6 ];

/// MODEStandby7
Property MODEStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 23, SqlFieldName = MODE_Standby7 ];

/// MODEStandby8
Property MODEStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = MODE_Standby8 ];

/// MODEStandby9
Property MODEStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 256, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = MODE_Standby9 ];

/// MODE_Contract
Property MODEContract As PMPContract [ SqlColumnNumber = 26, SqlFieldName = MODE_Contract ];

/// MODE_Group
Property MODEGroup As PMPDictionary3 [ SqlColumnNumber = 27, SqlFieldName = MODE_Group ];

/// MODE_PlanTime
Property MODEPlanTime As %Time [ SqlColumnNumber = 28, SqlFieldName = MODE_PlanTime ];

/// MODE_ActuclTime
Property MODEActuclTime As %Time [ SqlColumnNumber = 29, SqlFieldName = MODE_ActuclTime ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPModule(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MODE_ActuclDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MODE_ActuclTime">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MODE_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MODE_Contract">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MODE_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MODE_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MODE_DevelopUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MODE_Group">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MODE_PlanDate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MODE_PlanTime">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MODE_Product_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MODE_Project1_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MODE_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MODE_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MODE_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MODE_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MODE_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MODE_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MODE_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MODE_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MODE_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MODE_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MODE_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MODE_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MODE_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MODE_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MODE_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MODE_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^PMPModule</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MODE_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofActuclDate">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"ActuclDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_ActuclDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofCode">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Code}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofContract">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Contract"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Contract}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDesc">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofGROUP">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"GROUP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Group}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofProduct">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Product"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Product_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofProject1">
<Global>^PMPModulei</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Project1"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MODE_Project1_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MODE_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPModuleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
