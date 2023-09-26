Class User.DHCInManuOrder Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INMAN_RowID, SqlTableName = DHC_InManuOrder, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCInManuOrderBatch As User.DHCInManuOrderBatch [ Cardinality = children, Inverse = MOBATParRef ];

/// INMAN_No
Property INMANNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INMAN_No ];

/// INMAN_Date
Property INMANDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = INMAN_Date ];

///  Loc DR
Property INMANCtlocDr As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = INMAN_Ctloc_Dr ];

/// INMAN_Inci_Dr
Property INMANInciDr As User.INCItm [ SqlColumnNumber = 5, SqlFieldName = INMAN_Inci_Dr ];

/// INMAN_Batch_No
Property INMANBatchNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INMAN_Batch_No ];

Property INMANExpireDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 7, SqlFieldName = INMAN_Expire_Date ];

/// INMAN_Inclb_Dr
Property INMANInclbDr As User.INCItmLcBt [ SqlColumnNumber = 8, SqlFieldName = INMAN_Inclb_Dr ];

/// INMAN_Uom_Dr
Property INMANUomDr As User.CTUOM [ SqlColumnNumber = 9, SqlFieldName = INMAN_Uom_Dr ];

/// INMAN_Theory_Qty
Property INMANTheoryQty As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INMAN_Theory_Qty ];

/// INMAN_Fact_Qty
Property INMANFactQty As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = INMAN_Fact_Qty ];

/// INMAN_CostPrice  进价
Property INMANCostPrice As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INMAN_CostPrice ];

/// INMAN_ElseAmount1 //附加费用
Property INMANElseAmount1 As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INMAN_ElseAmount1 ];

/// INMAN_ElseAmount2
Property INMANElseAmount2 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INMAN_ElseAmount2 ];

/// INMAN_ElseAmount3
Property INMANElseAmount3 As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INMAN_ElseAmount3 ];

/// INMAN_CostAmount  进价金额
Property INMANCostAmount As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INMAN_CostAmount ];

/// INMAN_Start_Date
Property INMANStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INMAN_Start_Date ];

/// INMAN_Start_Time
Property INMANStartTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INMAN_Start_Time ];

/// INMAN_End_Date
Property INMANEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 19, SqlFieldName = INMAN_End_Date ];

/// INMAN_End_Time
Property INMANEndTime As %Library.Time [ SqlColumnNumber = 20, SqlFieldName = INMAN_End_Time ];

/// INMAN_Sterile
Property INMANSterile As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = INMAN_Sterile ];

/// INMAN_Status
Property INMANStatus As %String(DISPLAYLIST = ",Pending,InProgress,Completed,Aborted", MAXLEN = 10, SELECTIVITY = "20.0000%", VALUELIST = ",P,I,C,A") [ SqlColumnNumber = 22, SqlFieldName = INMAN_Status ];

/// INMAN_RecNumber
Property INMANRecNumber As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = INMAN_RecNumber ];

/// INMAN_ManuUser_Dr
Property INMANManuUserDr As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = INMAN_ManuUser_Dr ];

/// INMAN_Chk_User_Dr
Property INMANChkUserDr As User.SSUser [ SqlColumnNumber = 25, SqlFieldName = INMAN_Chk_User_Dr ];

/// INMAN_OperUser_Dr 建单人
Property INMANOperUserDr As User.SSUser [ SqlColumnNumber = 26, SqlFieldName = INMAN_OperUser_Dr ];

/// INMAN_UserCompleted
Property INMANUserCompleted As %Library.String(DISPLAYLIST = ",Ye s,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = INMAN_UserCompleted ];

/// INMAN_CompStatus
Property INMANCompStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INMAN_CompStatus ];

/// INMAN_Remarks
Property INMANRemarks As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INMAN_Remarks ];

/// INMAN_InRec_Dr
Property INMANInRecDr As User.INCItmRcp [ SqlColumnNumber = 30, SqlFieldName = INMAN_InRec_Dr ];

/// INMAN_ChkDate
Property INMANChkDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = INMAN_ChkDate ];

/// INMAN_Sp
Property INMANSp As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INMAN_Sp ];

/// INMAN_SpAmt
Property INMANSpAmt As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INMAN_SpAmt ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINMAN(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INMAN_Batch_No">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INMAN_ChkDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INMAN_Chk_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INMAN_CompStatus">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INMAN_CostAmount">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INMAN_CostPrice">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INMAN_Ctloc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INMAN_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INMAN_ElseAmount1">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INMAN_ElseAmount2">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INMAN_ElseAmount3">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INMAN_End_Date">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INMAN_End_Time">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INMAN_Expire_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INMAN_Fact_Qty">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INMAN_InRec_Dr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INMAN_Inci_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INMAN_Inclb_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INMAN_ManuUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INMAN_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INMAN_OperUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INMAN_RecNumber">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INMAN_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INMAN_Sp">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INMAN_SpAmt">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INMAN_Start_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INMAN_Start_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INMAN_Status">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INMAN_Sterile">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INMAN_Theory_Qty">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INMAN_Uom_Dr">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INMAN_UserCompleted">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateLocInci">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DLOCINCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INMAN_Inci_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCI">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Inci_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIB">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCIB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$CIBrow^at299({INMAN_Inclb_Dr})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCLB">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCLB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Inclb_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLOC">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_Ctloc_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexNO">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_No}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUSER">
<Global>^DHCINMAN</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INMAN_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INMAN_ManuUser_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INMAN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INMAN_RowID</SqlRowIdName>
<StreamLocation>^User.DHCInManuOrderS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
