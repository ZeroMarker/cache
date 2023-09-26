Class User.DHCOPRegInvReports Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = OPHIS_Rowid, SqlTableName = DHC_OPRegInvReports, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// OPHIS_Amount     费用总额
Property OPHISAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = OPHIS_Amount ];

/// OPHIS_CardCashParkSum
Property OPHISCardCashParkSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = OPHIS_CardCashParkSum ];

/// OPHIS_CardCashRefSum
Property OPHISCardCashRefSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = OPHIS_CardCashRefSum ];

/// OPHIS_CardNum
Property OPHISCardNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = OPHIS_CardNum ];

/// OPHIS_CardParkINVInfo
Property OPHISCardParkINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = OPHIS_CardParkINVInfo ];

/// OPHIS_CardParkNum
Property OPHISCardParkNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = OPHIS_CardParkNum ];

/// OPHIS_CardParkSum
Property OPHISCardParkSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = OPHIS_CardParkSum ];

/// OPHIS_CardRefNum
Property OPHISCardRefNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = OPHIS_CardRefNum ];

/// OPHIS_CardRefSum
Property OPHISCardRefSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = OPHIS_CardRefSum ];

/// OPHIS_CardRefundINVInfo
Property OPHISCardRefundINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = OPHIS_CardRefundINVInfo ];

/// OPHIS_CardSum
Property OPHISCardSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = OPHIS_CardSum ];

/// OPHIS_CardYBParkSum
Property OPHISCardYBParkSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = OPHIS_CardYBParkSum ];

/// OPHIS_CardYBRefSum
Property OPHISCardYBRefSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = OPHIS_CardYBRefSum ];

/// OPHIS_CardYBSum
Property OPHISCardYBSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = OPHIS_CardYBSum ];

/// OPHIS_CashNum
Property OPHISCashNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = OPHIS_CashNum ];

/// OPHIS_CashSum
Property OPHISCashSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = OPHIS_CashSum ];

/// OPHIS_CheckNum
Property OPHISCheckNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = OPHIS_CheckNum ];

/// OPHIS_CheckSum     
Property OPHISCheckSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = OPHIS_CheckSum ];

/// OPHIS_Confirm
Property OPHISConfirm As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = OPHIS_Confirm ];

/// OPHIS_Date  结帐日期
Property OPHISDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 2, SqlFieldName = OPHIS_Date ];

/// OPHIS_EndDate    截止日期
Property OPHISEndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = OPHIS_EndDate ];

/// OPHIS_EndTime    截止时间
Property OPHISEndTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = OPHIS_EndTime ];

/// OPHIS_INSFootDate
Property OPHISINSFootDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = OPHIS_INSFootDate ];

/// OPHIS_INSFootTime
Property OPHISINSFootTime As %Library.Time [ SqlColumnNumber = 14, SqlFieldName = OPHIS_INSFootTime ];

/// OPHIS_INSFootUser
Property OPHISINSFootUser As User.SSUser [ SqlColumnNumber = 15, SqlFieldName = OPHIS_INSFootUser ];

/// OPHIS_INVPrtNote
Property OPHISINVPrtNote As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = OPHIS_INVPrtNote ];

/// OPHIS_INVRep_DR   关联计费报表
Property OPHISINVRepDR As User.DHCOPRegInvReports [ SqlColumnNumber = 49, SqlFieldName = OPHIS_INVRep_DR ];

/// OPHIS_Note1
Property OPHISNote1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = OPHIS_Note1 ];

/// OPHIS_Note2
Property OPHISNote2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = OPHIS_Note2 ];

/// OPHIS_Note3
Property OPHISNote3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = OPHIS_Note3 ];

/// OPHIS_Note4
Property OPHISNote4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = OPHIS_Note4 ];

/// OPHIS_Note5
Property OPHISNote5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = OPHIS_Note5 ];

/// OPHIS_Num        挂号数
Property OPHISNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = OPHIS_Num ];

/// OPHIS_OterPayNum
Property OPHISOterPayNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = OPHIS_OterPayNum ];

/// OPHIS_OterPaySum
Property OPHISOterPaySum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = OPHIS_OterPaySum ];

/// OPHIS_ParkINVInfo
Property OPHISParkINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = OPHIS_ParkINVInfo ];

/// OPHIS_ParkNum
Property OPHISParkNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = OPHIS_ParkNum ];

/// OPHIS_ParkSum
Property OPHISParkSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = OPHIS_ParkSum ];

/// OPHIS_PatSum
Property OPHISPatSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = OPHIS_PatSum ];

/// OPHIS_RcptNO
Property OPHISRcptNO As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OPHIS_RcptNO ];

/// OPHIS_RefundINVInfo
Property OPHISRefundINVInfo As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = OPHIS_RefundINVInfo ];

/// OPHIS_RefundNum   退号数
Property OPHISRefundNum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = OPHIS_RefundNum ];

/// OPHIS_RefundSum   退号金额
Property OPHISRefundSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = OPHIS_RefundSum ];

/// OPHIS_StartDate  开始日期
Property OPHISStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = OPHIS_StartDate ];

/// OPHIS_StartTime  开始时间
Property OPHISStartTime As %Library.Time [ SqlColumnNumber = 5, SqlFieldName = OPHIS_StartTime ];

/// OPHIS_Time  结帐时间
Property OPHISTime As %Library.Time [ SqlColumnNumber = 3, SqlFieldName = OPHIS_Time ];

/// OPHIS_User       结帐人
Property OPHISUser As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = OPHIS_User ];

/// OPHIS_YBSum
Property OPHISYBSum As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = OPHIS_YBSum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOPRegInvReports)</SqlIdExpression>
<SQLMap name="DHCOPRegInvReports">
<Data name="OPHIS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPHIS_CardCashParkSum">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPHIS_CardCashRefSum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="OPHIS_CardNum">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPHIS_CardParkINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPHIS_CardParkNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPHIS_CardParkSum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPHIS_CardRefNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPHIS_CardRefSum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPHIS_CardRefundINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPHIS_CardSum">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPHIS_CardYBParkSum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPHIS_CardYBRefSum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPHIS_CardYBSum">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPHIS_CashNum">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OPHIS_CashSum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPHIS_CheckNum">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OPHIS_CheckSum">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OPHIS_Confirm">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OPHIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OPHIS_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OPHIS_EndTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OPHIS_INSFootDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OPHIS_INSFootTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OPHIS_INSFootUser">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OPHIS_INVPrtNote">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OPHIS_INVRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="OPHIS_Note1">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OPHIS_Note2">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OPHIS_Note3">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OPHIS_Note4">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OPHIS_Note5">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="OPHIS_Num">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OPHIS_OterPayNum">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OPHIS_OterPaySum">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OPHIS_ParkINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OPHIS_ParkNum">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OPHIS_ParkSum">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OPHIS_PatSum">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OPHIS_RcptNO">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OPHIS_RefundINVInfo">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OPHIS_RefundNum">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OPHIS_RefundSum">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="OPHIS_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OPHIS_StartTime">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="OPHIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="OPHIS_User">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="OPHIS_YBSum">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Global>^DHCOPRegInvReports</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OPHIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{OPHIS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexDate">
<Global>^DHCOPRegInvReports</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPHIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPHIS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPHIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexuser">
<Global>^DHCOPRegInvReports</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>OPHIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{OPHIS_User}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{OPHIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOPRegInvReportsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
