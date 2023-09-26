/// CodaExtract(2594)
Class User.PACodaExtract Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_CodaExtract, StorageStrategy = SQLStorage ]
{

/// Transaction
Property CODATransaction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CODA_Transaction ];

/// Des REf ServCat
Property CODAServCatDR As ARCServCat [ SqlColumnNumber = 3, SqlFieldName = CODA_ServCat_DR ];

/// Des Ref Hospital
Property CODAHospitalDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = CODA_Hospital_DR ];

/// ServiceCode
Property CODAServiceCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CODA_ServiceCode ];

/// DiscountCode
Property CODADiscountCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CODA_DiscountCode ];

/// WOReasonCode
Property CODAWOReasonCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CODA_WOReasonCode ];

/// PayorType
Property CODAPayorType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CODA_PayorType ];

/// LocationCode
Property CODALocationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CODA_LocationCode ];

/// Admlocation
Property CODAAdmLocation As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CODA_AdmLocation ];

/// EpisSubType
Property CODAEpisSubType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CODA_EpisSubType ];

/// ItemDesc
Property CODAItemDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CODA_ItemDesc ];

/// Episode
Property CODAEpisode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CODA_Episode ];

/// Des Ref EpisodeID
Property CODAEpisodeIDDR As PAAdm [ SqlColumnNumber = 14, SqlFieldName = CODA_EpisodeID_DR ];

/// Amount
Property CODAAmount As %Float [ SqlColumnNumber = 15, SqlFieldName = CODA_Amount ];

/// AmtDiff
Property CODAAmtDiff As %Float [ SqlColumnNumber = 16, SqlFieldName = CODA_AmtDiff ];

/// TaxAmt
Property CODATaxAmt As %Float [ SqlColumnNumber = 17, SqlFieldName = CODA_TaxAmt ];

/// CODA_GL2
Property CODAGL2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = CODA_GL2 ];

/// Qty
Property CODAQty As %Float [ SqlColumnNumber = 19, SqlFieldName = CODA_Qty ];

/// Ord SttDate
Property CODAOrdSttDate As %Date [ SqlColumnNumber = 20, SqlFieldName = CODA_OrdSttDate ];

/// DailyOrderDate
Property CODADailyOrderDate As %Date [ SqlColumnNumber = 21, SqlFieldName = CODA_DailyOrderDate ];

/// OrdDate
Property CODAOrdDate As %Date [ SqlColumnNumber = 22, SqlFieldName = CODA_OrdDate ];

/// UnitPrice
Property CODAUnitPrice As %Float [ SqlColumnNumber = 23, SqlFieldName = CODA_UnitPrice ];

/// DefinedPrice
Property CODADefinedPrice As %Float [ SqlColumnNumber = 24, SqlFieldName = CODA_DefinedPrice ];

/// InvoiceDate
Property CODAInvoiceDate As %Date [ SqlColumnNumber = 25, SqlFieldName = CODA_InvoiceDate ];

/// Des Ref OrdItem_DR
Property CODAOrdItemDR As OEOrdItem [ SqlColumnNumber = 26, SqlFieldName = CODA_OrdItem_DR ];

/// DebtorNumber
Property CODADebtorNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = CODA_DebtorNumber ];

/// Des Ref PatientID
Property CODAPatientIDDR As PAPatMas [ SqlColumnNumber = 28, SqlFieldName = CODA_PatientID_DR ];

/// Des Ref SundryDebtor
Property CODASundryDebtorDR As ARCSundryDebtor [ SqlColumnNumber = 29, SqlFieldName = CODA_SundryDebtor_DR ];

/// UnitPrice1
Property CODAUnitPrice1 As %Float [ SqlColumnNumber = 30, SqlFieldName = CODA_UnitPrice1 ];

/// Des Ref InsType
Property CODAInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 31, SqlFieldName = CODA_InsType_DR ];

/// BillNo
Property CODABillNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = CODA_BillNo ];

/// Des Ref ARPBL
Property CODAARPBLDR As ARPatientBill [ SqlColumnNumber = 33, SqlFieldName = CODA_ARPBL_DR ];

/// Des Ref BillCharges
Property CODABillChargesDR As ARPatBillGroupCharges [ SqlColumnNumber = 34, SqlFieldName = CODA_BillCharges_DR ];

/// Des Ref AccountPeriond
Property CODAAccountPeriondDR As BLCAccountingPeriod [ SqlColumnNumber = 35, SqlFieldName = CODA_AccountPeriond_DR ];

/// SeqNo
Property CODASeqNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = CODA_SeqNo ];

/// Des Ref ItemCat
Property CODAItemCatDR As ARCItemCat [ SqlColumnNumber = 37, SqlFieldName = CODA_ItemCat_DR ];

/// BillDateFrom
Property CODABillDateFrom As %Date [ SqlColumnNumber = 38, SqlFieldName = CODA_BillDateFrom ];

/// BillDateTo
Property CODABillDateTo As %Date [ SqlColumnNumber = 39, SqlFieldName = CODA_BillDateTo ];

/// Des Ref OrderServiceDatePerID
Property CODAOrderServiceDatePerID As BLCAccountingPeriod [ SqlColumnNumber = 40, SqlFieldName = CODA_OrderServiceDatePerID ];

/// OrdSttdatePerCode
Property CODAOrdSttdatePerCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 41, SqlFieldName = CODA_OrdSttdatePerCode ];

/// ReportAction
Property CODAReportAction As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 42, SqlFieldName = CODA_ReportAction ];

/// Text1
Property CODAText1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 43, SqlFieldName = CODA_Text1 ];

/// Text2
Property CODAText2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 44, SqlFieldName = CODA_Text2 ];

/// Text3
Property CODAText3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 45, SqlFieldName = CODA_Text3 ];

/// Num1
Property CODANum1 As %Float [ SqlColumnNumber = 46, SqlFieldName = CODA_Num1 ];

/// Num2
Property CODANum2 As %Float [ SqlColumnNumber = 47, SqlFieldName = CODA_Num2 ];

/// Des Ref CODA ExtractBuild
Property CODAExtractBuildDR As PACodaExtractBuild [ SqlColumnNumber = 48, SqlFieldName = CODA_ExtractBuild_DR ];

/// AmountDefined
Property CODAAmountDefined As %Float [ SqlColumnNumber = 49, SqlFieldName = CODA_AmountDefined ];

/// ItemCategCode
Property CODAItemCategCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 50, SqlFieldName = CODA_ItemCategCode ];

/// AccountPeriodCode
Property CODAAccountPeriodCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 51, SqlFieldName = CODA_AccountPeriodCode ];

/// Des Ref ARReceipt
Property CODAARReceiptDR As ARReceipts [ SqlColumnNumber = 52, SqlFieldName = CODA_ARReceipt_DR ];

/// Des Ref ARRecAlloc
Property CODAARRecAllocDR As ARRcptAlloc [ SqlColumnNumber = 53, SqlFieldName = CODA_ARRecAlloc_DR ];

/// ReceiptNumber
Property CODAReceiptNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 54, SqlFieldName = CODA_ReceiptNumber ];

/// Key1
Property CODAKey1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 55, SqlFieldName = CODA_Key1 ];

/// Key2
Property CODAKey2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 56, SqlFieldName = CODA_Key2 ];

/// ADV Amt
Property CODAADVAmt As %Float [ SqlColumnNumber = 57, SqlFieldName = CODA_ADVAmt ];

/// ADV Amt Defined
Property CODAADVAmtDefined As %Float [ SqlColumnNumber = 58, SqlFieldName = CODA_ADVAmtDefined ];

/// ADV Amt Diff
Property CODAADVAmtDiff As %Float [ SqlColumnNumber = 59, SqlFieldName = CODA_ADVAmtDiff ];

/// Key3
Property CODAKey3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 60, SqlFieldName = CODA_Key3 ];

/// ADVTaxAmt
Property CODAADVTaxAmt As %Float [ SqlColumnNumber = 61, SqlFieldName = CODA_ADVTaxAmt ];

/// ADVQty
Property CODAADVQty As %Float [ SqlColumnNumber = 62, SqlFieldName = CODA_ADVQty ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACodaExtract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACodaExtract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACodaExtract).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACodaExtract).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACodaExtract).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACodaExtract","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("CODA",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="CODA_ADVAmt">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="CODA_ADVAmtDefined">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="CODA_ADVAmtDiff">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="CODA_ADVQty">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="CODA_ADVTaxAmt">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="CODA_ARPBL_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CODA_ARRecAlloc_DR">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="CODA_ARReceipt_DR">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="CODA_AccountPeriodCode">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="CODA_AccountPeriond_DR">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CODA_AdmLocation">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CODA_Amount">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CODA_AmountDefined">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="CODA_AmtDiff">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CODA_BillCharges_DR">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CODA_BillDateFrom">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CODA_BillDateTo">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CODA_BillNo">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CODA_DailyOrderDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CODA_DebtorNumber">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CODA_DefinedPrice">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CODA_DiscountCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CODA_EpisSubType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CODA_Episode">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CODA_EpisodeID_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CODA_ExtractBuild_DR">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="CODA_GL2">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CODA_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CODA_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CODA_InvoiceDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CODA_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CODA_ItemCategCode">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="CODA_ItemDesc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CODA_Key1">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="CODA_Key2">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="CODA_Key3">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="CODA_LocationCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CODA_Num1">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CODA_Num2">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="CODA_OrdDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CODA_OrdItem_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CODA_OrdSttDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CODA_OrdSttdatePerCode">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CODA_OrderServiceDatePerID">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="CODA_PatientID_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CODA_PayorType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CODA_Qty">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CODA_ReceiptNumber">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="CODA_ReportAction">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CODA_SeqNo">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CODA_ServCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CODA_ServiceCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CODA_SundryDebtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CODA_TaxAmt">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CODA_Text1">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CODA_Text2">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CODA_Text3">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CODA_Transaction">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CODA_UnitPrice">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CODA_UnitPrice1">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CODA_WOReasonCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CODA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBillCharges">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"BillCharges"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_BillCharges_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpis">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Epis"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_EpisodeID_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpis1">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Epis1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_EpisodeID_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODA_OrdSttDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CODA_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpis2">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Epis2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_EpisodeID_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_ItemCategCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODA_OrdSttDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CODA_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpis3">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Epis3"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_EpisodeID_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_SeqNo}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODA_DailyOrderDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CODA_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpis4">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Epis4"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_EpisodeID_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_ItemCategCode}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODA_DailyOrderDate}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CODA_InsType_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexExtrBuild">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ExtrBuild"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_AccountPeriond_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKey1">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Key1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_Key1}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKey2">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Key2"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_Key2}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexKey3">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Key3"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_Key3}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOrderItem">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OrdItem"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_OrdItem_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSunDeb">
<Global>^PA</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CODA_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CODA"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SunDeb"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODA_SundryDebtor_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CODA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CODA_RowId</SqlRowIdName>
<StreamLocation>^User.PACodaExtractS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
