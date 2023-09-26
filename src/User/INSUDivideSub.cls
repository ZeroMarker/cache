Class User.INSUDivideSub Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDIS_Rowid, SqlTableName = INSU_DivideSub, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDIS_DivideDr
Property INDISDivideDr As User.INSUDivide [ SqlColumnNumber = 2, SqlFieldName = INDIS_DivideDr ];

/// INDIS_ArcimDr
Property INDISArcimDr As User.ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = INDIS_ArcimDr ];

/// INDIS_TarItmDr
Property INDISTarItmDr As User.DHCTarItem [ SqlColumnNumber = 4, SqlFieldName = INDIS_TarItmDr ];

/// INDIS_INSUItmDr
Property INDISINSUItmDr As User.INSUTarItems [ SqlColumnNumber = 5, SqlFieldName = INDIS_INSUItmDr ];

/// INDIS_OEORI_Dr
Property INDISOEORIDr As User.OEOrdItem [ SqlColumnNumber = 6, SqlFieldName = INDIS_OEORI_Dr ];

/// INDIS_PB_Dr
Property INDISPBDr As User.DHCPatientBill [ SqlColumnNumber = 7, SqlFieldName = INDIS_PB_Dr ];

/// INDIS_PBD_Dr
Property INDISPBDDr As User.DHCPatBillDetails [ SqlColumnNumber = 8, SqlFieldName = INDIS_PBD_Dr ];

/// INDIS_INSUCode
Property INDISINSUCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDIS_INSUCode ];

/// INDIS_INSUDesc
Property INDISINSUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INDIS_INSUDesc ];

/// INDIS_INSUXMLB
Property INDISINSUXMLB As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INDIS_INSUXMLB ];

/// INDIS_Qty
Property INDISQty As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INDIS_Qty ];

/// INDIS_Price
Property INDISPrice As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = INDIS_Price ];

/// INDIS_Amount
Property INDISAmount As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INDIS_Amount ];

/// INDIS_TarCate
Property INDISTarCate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INDIS_TarCate ];

/// INDIS_Scale
Property INDISScale As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INDIS_Scale ];

/// INDIS_Fund
Property INDISFund As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = INDIS_Fund ];

/// INDIS_Self
Property INDISSelf As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = INDIS_Self ];

/// INDIS_Flag
Property INDISFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INDIS_Flag ];

/// INDIS_Sequence1
Property INDISSequence1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INDIS_Sequence1 ];

/// INDIS_Sequence2
Property INDISSequence2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INDIS_Sequence2 ];

/// INDIS_Date
Property INDISDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = INDIS_Date ];

/// INDIS_Time
Property INDISTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = INDIS_Time ];

/// INDIS_UserDr
Property INDISUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INDIS_UserDr ];

/// INDIS_INSUFlag
Property INDISINSUFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INDIS_INSUFlag ];

/// INDIS_INSUMaxPrice
Property INDISINSUMaxPrice As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INDIS_INSUMaxPrice ];

/// INDIS_Demo1
Property INDISDemo1 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INDIS_Demo1 ];

/// INDIS_Demo2
Property INDISDemo2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INDIS_Demo2 ];

/// INDIS_Demo3
Property INDISDemo3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INDIS_Demo3 ];

/// INDIS_Demo4
Property INDISDemo4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INDIS_Demo4 ];

/// INDIS_Demo5
Property INDISDemo5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INDIS_Demo5 ];

/// INDIS_ExecDr 执行记录DR
Property INDISExecDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INDIS_ExecDr ];

/// INDIS_UpQty 实际上传数量（医保
Property INDISUpQty As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INDIS_UpQty ];

/// INDIS_ReQty 退费数量
Property INDISReQty As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = INDIS_ReQty ];

/// INDIS_InsuRetSeqNo 医保中心返回交易流水号
Property INDISInsuRetSeqNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INDIS_InsuRetSeqNo ];

/// INDIS_PlusLinkNeg 正记录dr$数量！正记录dr$数量
Property INDISPlusLinkNeg As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INDIS_PlusLinkNeg ];

/// INDIS_InsuPrice 单价（医保）
Property INDISInsuPrice As %Library.Float [ SqlColumnNumber = 37, SqlFieldName = INDIS_InsuPrice ];

/// INDIS_InsuQty	数量（医保）
Property INDISInsuQty As %Library.Float [ SqlColumnNumber = 38, SqlFieldName = INDIS_InsuQty ];

/// INDIS_InsuAmount	金额（医保）
Property INDISInsuAmount As %Library.Float [ SqlColumnNumber = 39, SqlFieldName = INDIS_InsuAmount ];

/// INDIS_InsuRetStr	医保返回所有字段
Property INDISInsuRetStr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INDIS_InsuRetStr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDIS)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INDIS_Amount">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDIS_ArcimDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDIS_Date">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INDIS_Demo1">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INDIS_Demo2">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INDIS_Demo3">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INDIS_Demo4">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INDIS_Demo5">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INDIS_DivideDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDIS_ExecDr">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INDIS_Flag">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INDIS_Fund">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INDIS_INSUCode">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDIS_INSUDesc">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDIS_INSUFlag">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INDIS_INSUItmDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDIS_INSUMaxPrice">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INDIS_INSUXMLB">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDIS_InsuAmount">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INDIS_InsuPrice">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INDIS_InsuQty">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INDIS_InsuRetSeqNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INDIS_InsuRetStr">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INDIS_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDIS_PBD_Dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDIS_PB_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDIS_PlusLinkNeg">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INDIS_Price">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDIS_Qty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDIS_ReQty">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INDIS_Scale">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INDIS_Self">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INDIS_Sequence1">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INDIS_Sequence2">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INDIS_TarCate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDIS_TarItmDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDIS_Time">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INDIS_UpQty">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INDIS_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^DHCINDIS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofArcimDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ArcimDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_ArcimDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDivideDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DivideDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_DivideDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofExecDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ExecDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_ExecDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofOEORIDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OEORIDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PBDDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_PBD_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPBDr">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PBDr"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_PB_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSequence">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Sequence"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDIS_Sequence1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDIS_Sequence2}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofSequence2">
<Global>^DHCINDIS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDIS_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Seqn2"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDIS_Sequence2}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDIS_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDivideSubS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
