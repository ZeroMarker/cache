Class User.DHCEQEquipGuaranteeInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = EGI_RowID, SqlTableName = DHC_EQEquipGuaranteeInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// EGI_Type
Property EGIType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EGI_Type ];

/// EGI_ContractListDR
Property EGIContractListDR As User.DHCEQContractList [ SqlColumnNumber = 11, SqlFieldName = EGI_ContractListDR ];

/// EGI_ServiceHandler
Property EGIServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = EGI_ServiceHandler ];

/// EGI_MaintAmount
Property EGIMaintAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = EGI_MaintAmount ];

/// EGI_ContractDR
Property EGIContractDR As User.DHCEQContract [ SqlColumnNumber = 12, SqlFieldName = EGI_ContractDR ];

/// EGI_StartDate
Property EGIStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = EGI_StartDate ];

/// EGI_EndDate
Property EGIEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = EGI_EndDate ];

/// EGI_SelfAmount
Property EGISelfAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = EGI_SelfAmount ];

/// EGI_Remark
Property EGIRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = EGI_Remark ];

/// EGI_Hold1
Property EGIHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = EGI_Hold1 ];

/// EGI_Hold2
Property EGIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = EGI_Hold2 ];

/// EGI_Hold3
Property EGIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = EGI_Hold3 ];

/// EGI_Hold4
Property EGIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = EGI_Hold4 ];

/// EGI_Hold5
Property EGIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = EGI_Hold5 ];

/// EGI_LastFlag
Property EGILastFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = EGI_LastFlag ];

/// EGI_EquipDR
Property EGIEquipDR As User.DHCEQEquip [ SqlColumnNumber = 3, SqlFieldName = EGI_EquipDR ];

/// EGI_ServiceTel
Property EGIServiceTel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = EGI_ServiceTel ];

/// EGI_ServicrDR
Property EGIServicrDR As User.DHCEQCService [ SqlColumnNumber = 6, SqlFieldName = EGI_ServicrDR ];

/// EGI_SalesManager
Property EGISalesManager As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = EGI_SalesManager ];

/// EGI_Status
Property EGIStatus As %Library.String(DISPLAYLIST = ",正常,过期", MAXLEN = 2, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 18, SqlFieldName = EGI_Status ];

/// EGI_LastDate
Property EGILastDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = EGI_LastDate ];

/// EGI_MaintTime
Property EGIMaintTime As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = EGI_MaintTime ];

/// EGI_LastTime
Property EGILastTime As %Library.Time(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = EGI_LastTime ];

/// EGI_ContractAmount
Property EGIContractAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = EGI_ContractAmount ];

/// EGI_SalesManagerTel
Property EGISalesManagerTel As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = EGI_SalesManagerTel ];

/// EGI_InvalidFlag
Property EGIInvalidFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = EGI_InvalidFlag ];

/// EGI_GuaranteeAmount
Property EGIGuaranteeAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = EGI_GuaranteeAmount ];

/// EGI_LastUserDR
Property EGILastUserDR As User.DHCEQCUser [ SqlColumnNumber = 22, SqlFieldName = EGI_LastUserDR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQEquipGuaranteeInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EGI_ContractAmount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="EGI_ContractDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="EGI_ContractListDR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="EGI_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EGI_EquipDR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EGI_GuaranteeAmount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="EGI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="EGI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="EGI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="EGI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="EGI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="EGI_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="EGI_LastDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="EGI_LastFlag">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="EGI_LastTime">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="EGI_LastUserDR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="EGI_MaintAmount">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="EGI_MaintTime">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="EGI_Remark">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="EGI_SalesManager">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="EGI_SalesManagerTel">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="EGI_SelfAmount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="EGI_ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EGI_ServiceTel">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="EGI_ServicrDR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EGI_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EGI_Status">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="EGI_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEQEquipGuaranteeInfo</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EGI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{EGI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexEquipDR">
<Global>^DHCEQEquipGuaranteeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EGI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"EquipDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EGI_EquipDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EGI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastFlag">
<Global>^DHCEQEquipGuaranteeInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EGI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LastFlag"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EGI_LastFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EGI_EquipDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EGI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQEquipGuaranteeInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
