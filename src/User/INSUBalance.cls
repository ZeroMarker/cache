Class User.INSUBalance Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INBAL_Rowid, SqlTableName = INSU_Balance, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// Relationship ChildINSUBalanceSub As User.INSUBalanceSub [ Cardinality = children, Inverse = INBASParRef ];
/// INBAL_tradeno
Property INBALtradeno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INBAL_tradeno ];

/// INBAL_cardno
Property INBALcardno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INBAL_cardno ];

/// INBAL_icno
Property INBALicno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INBAL_icno ];

/// INBAL_personname
Property INBALpersonname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INBAL_personname ];

/// INBAL_feeno
Property INBALfeeno As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INBAL_feeno ];

/// INBAL_tradedate
Property INBALtradedate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INBAL_tradedate ];

/// INBAL_curetype
Property INBALcuretype As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INBAL_curetype ];

/// INBAL_feeall
Property INBALfeeall As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INBAL_feeall ];

/// INBAL_fund
Property INBALfund As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INBAL_fund ];

/// INBAL_cash
Property INBALcash As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INBAL_cash ];

/// INBAL_countpay
Property INBALcountpay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INBAL_countpay ];

/// INBAL_personcount
Property INBALpersoncount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INBAL_personcount ];

/// INBAL_mzfeein
Property INBALmzfeein As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INBAL_mzfeein ];

/// INBAL_mzfeeout
Property INBALmzfeeout As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INBAL_mzfeeout ];

/// INBAL_mzpayfirst
Property INBALmzpayfirst As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INBAL_mzpayfirst ];

/// INBAL_mzselfpay2
Property INBALmzselfpay2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INBAL_mzselfpay2 ];

/// INBAL_mzbigpay
Property INBALmzbigpay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INBAL_mzbigpay ];

/// INBAL_mzbigself
Property INBALmzbigself As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INBAL_mzbigself ];

/// INBAL_mzoutofbig
Property INBALmzoutofbig As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INBAL_mzoutofbig ];

/// INBAL_bcpay
Property INBALbcpay As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INBAL_bcpay ];

/// INBAL_jcbz
Property INBALjcbz As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INBAL_jcbz ];

/// INBAL_medicine
Property INBALmedicine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INBAL_medicine ];

/// INBAL_tmedicine
Property INBALtmedicine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INBAL_tmedicine ];

/// INBAL_therb
Property INBALtherb As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INBAL_therb ];

/// INBAL_labexam
Property INBALlabexam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INBAL_labexam ];

/// INBAL_xray
Property INBALxray As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INBAL_xray ];

/// INBAL_ultrasonic
Property INBALultrasonic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INBAL_ultrasonic ];

/// INBAL_ct
Property INBALct As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INBAL_ct ];

/// INBAL_mri
Property INBALmri As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INBAL_mri ];

/// INBAL_examine
Property INBALexamine As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INBAL_examine ];

/// INBAL_treatment
Property INBALtreatment As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INBAL_treatment ];

/// INBAL_material
Property INBALmaterial As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INBAL_material ];

/// INBAL_operation
Property INBALoperation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INBAL_operation ];

/// INBAL_oxygen
Property INBALoxygen As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INBAL_oxygen ];

/// INBAL_bloodt
Property INBALbloodt As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INBAL_bloodt ];

/// INBAL_orthodontics
Property INBALorthodontics As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INBAL_orthodontics ];

/// INBAL_prosthesis
Property INBALprosthesis As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INBAL_prosthesis ];

/// INBAL_forensic
Property INBALforensic As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INBAL_forensic ];

/// INBAL_other
Property INBALother As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INBAL_other ];

/// INBAL_Zstr01
Property INBALZstr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INBAL_Zstr01 ];

/// INBAL_Zstr02
Property INBALZstr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INBAL_Zstr02 ];

/// INBAL_Zstr03
Property INBALZstr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INBAL_Zstr03 ];

/// INBAL_Zstr04
Property INBALZstr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INBAL_Zstr04 ];

/// INBAL_Zstr05
Property INBALZstr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INBAL_Zstr05 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINBAL)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INBAL_Zstr01">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INBAL_Zstr02">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INBAL_Zstr03">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INBAL_Zstr04">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INBAL_Zstr05">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INBAL_bcpay">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INBAL_bloodt">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INBAL_cardno">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INBAL_cash">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INBAL_countpay">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INBAL_ct">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INBAL_curetype">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INBAL_examine">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INBAL_feeall">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INBAL_feeno">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INBAL_forensic">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INBAL_fund">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INBAL_icno">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INBAL_jcbz">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INBAL_labexam">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INBAL_material">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INBAL_medicine">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INBAL_mri">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INBAL_mzbigpay">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INBAL_mzbigself">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INBAL_mzfeein">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INBAL_mzfeeout">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INBAL_mzoutofbig">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INBAL_mzpayfirst">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INBAL_mzselfpay2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INBAL_operation">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INBAL_orthodontics">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INBAL_other">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INBAL_oxygen">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INBAL_personcount">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INBAL_personname">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INBAL_prosthesis">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INBAL_therb">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INBAL_tmedicine">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INBAL_tradedate">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INBAL_tradeno">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INBAL_treatment">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INBAL_ultrasonic">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INBAL_xray">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Global>^DHCINBAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INBAL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INBAL_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="Indexoftradeno">
<Global>^DHCINBAL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INBAL_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"tradeno"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INBAL_tradeno}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INBAL_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUBalanceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
