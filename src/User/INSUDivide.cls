Class User.INSUDivide Extends (%Library.Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INPAY_Rowid, SqlTableName = INSU_Divide, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INPAY_AdmDr
Property INPAYAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = INPAY_AdmDr ];

/// INPAY_AdmInfoDr
Property INPAYAdmInfoDr As User.INSUAdmInfo [ SqlColumnNumber = 3, SqlFieldName = INPAY_AdmInfoDr ];

/// INPAY_DHCpblDr
Property INPAYDHCpblDr As User.DHCPatientBill [ SqlColumnNumber = 4, SqlFieldName = INPAY_DHCpblDr ];

// Property INPAYDhcInvPrtDr As User.DHCINVPRT [ SqlColumnNumber = 5, SqlFieldName = INPAY_DhcInvPrtDr ];

/// 考虑到集中打印发票存的是一个发票Dr字符串和体检接口存的是体检发票表的rowid DingSH 20180509
/// INPAY_DhcInvPrtDr
Property INPAYDhcInvPrtDr As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INPAY_DhcInvPrtDr ];

/// INPAY_Flag
Property INPAYFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "16.6667%", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INPAY_Flag ];

/// INPAY_INSUDivideDr
Property INPAYINSUDivideDr As User.INSUDivide [ SqlColumnNumber = 7, SqlFieldName = INPAY_INSUDivideDr ];

/// INPAY_bcbxf0
Property INPAYbcbxf0 As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = INPAY_bcbxf0 ];

/// INPAY_djlsh0
Property INPAYdjlsh0 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INPAY_djlsh0 ];

/// INPAY_bckbcs
Property INPAYbckbcs As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = INPAY_bckbcs ];

/// INPAY_bqbm00
Property INPAYbqbm00 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INPAY_bqbm00 ];

/// INPAY_brnl00
Property INPAYbrnl00 As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = INPAY_brnl00 ];

/// INPAY_cardno
Property INPAYcardno As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INPAY_cardno ];

/// INPAY_cfxms0
Property INPAYcfxms0 As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = INPAY_cfxms0 ];

/// INPAY_crbcts
Property INPAYcrbcts As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = INPAY_crbcts ];

/// INPAY_grzfe0
Property INPAYgrzfe0 As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = INPAY_grzfe0 ];

/// INPAY_iDate
Property INPAYiDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INPAY_iDate ];

/// INPAY_iTime
Property INPAYiTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = INPAY_iTime ];

/// INPAY_id0000
Property INPAYid0000 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INPAY_id0000 ];

/// INPAY_jjzfe0
Property INPAYjjzfe0 As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = INPAY_jjzfe0 ];

/// INPAY_ptbcts
Property INPAYptbcts As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = INPAY_ptbcts ];

/// INPAY_sUserDr
Property INPAYsUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INPAY_sUserDr ];

/// INPAY_sfrq00
Property INPAYsfrq00 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INPAY_sfrq00 ];

/// INPAY_sfrxm0
Property INPAYsfrxm0 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INPAY_sfrxm0 ];

/// INPAY_sfsj00
Property INPAYsfsj00 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INPAY_sfsj00 ];

/// INPAY_sftsbz
Property INPAYsftsbz As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INPAY_sftsbz ];

/// INPAY_xbie00
Property INPAYxbie00 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INPAY_xbie00 ];

/// INPAY_xming0
Property INPAYxming0 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INPAY_xming0 ];

/// INPAY_zhzfe0
Property INPAYzhzfe0 As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = INPAY_zhzfe0 ];

/// INPAY_zyksmc
Property INPAYzyksmc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INPAY_zyksmc ];

/// INPAY_zylsh0
Property INPAYzylsh0 As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INPAY_zylsh0 ];

/// INPAY_InsuPay1
Property INPAYInsuPay1 As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = INPAY_InsuPay1 ];

/// INPAY_InsuPay2
Property INPAYInsuPay2 As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = INPAY_InsuPay2 ];

/// INPAY_InsuPay3
Property INPAYInsuPay3 As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = INPAY_InsuPay3 ];

/// INPAY_InsuPay4
Property INPAYInsuPay4 As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = INPAY_InsuPay4 ];

/// INPAY_InsuPay5
Property INPAYInsuPay5 As %Library.Float [ SqlColumnNumber = 36, SqlFieldName = INPAY_InsuPay5 ];

/// INPAY_Zstr01
Property INPAYZstr01 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INPAY_Zstr01 ];

/// INPAY_Zstr02
Property INPAYZstr02 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INPAY_Zstr02 ];

/// INPAY_Zstr03
Property INPAYZstr03 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INPAY_Zstr03 ];

/// INPAY_Zstr04
Property INPAYZstr04 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INPAY_Zstr04 ];

/// INPAY_Zstr05
Property INPAYZstr05 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INPAY_Zstr05 ];

/// INPAY_Zstr06
Property INPAYZstr06 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INPAY_Zstr06 ];

/// INPAY_Zstr07
Property INPAYZstr07 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INPAY_Zstr07 ];

/// INPAY_Zstr08
Property INPAYZstr08 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INPAY_Zstr08 ];

/// INPAY_Zstr09
Property INPAYZstr09 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INPAY_Zstr09 ];

/// INPAY_Zstr10
Property INPAYZstr10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INPAY_Zstr10 ];

/// INPAY_InsuPay6
Property INPAYInsuPay6 As %Library.Float [ SqlColumnNumber = 47, SqlFieldName = INPAY_InsuPay6 ];

/// INPAY_InsuPay7
Property INPAYInsuPay7 As %Library.Float [ SqlColumnNumber = 48, SqlFieldName = INPAY_InsuPay7 ];

/// INPAY_InsuPay8
Property INPAYInsuPay8 As %Library.Float [ SqlColumnNumber = 49, SqlFieldName = INPAY_InsuPay8 ];

/// INPAY_InsuPay9
Property INPAYInsuPay9 As %Library.Float [ SqlColumnNumber = 50, SqlFieldName = INPAY_InsuPay9 ];

/// INPAY_InsuPay10
Property INPAYInsuPay10 As %Library.Float [ SqlColumnNumber = 51, SqlFieldName = INPAY_InsuPay10 ];

/// INPAY_Zstr11
Property INPAYZstr11 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = INPAY_Zstr11 ];

/// INPAY_Zstr12
Property INPAYZstr12 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = INPAY_Zstr12 ];

/// INPAY_Zstr13
Property INPAYZstr13 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = INPAY_Zstr13 ];

/// INPAY_Zstr14
Property INPAYZstr14 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = INPAY_Zstr14 ];

/// INPAY_Zstr15
Property INPAYZstr15 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = INPAY_Zstr15 ];

/// INPAY_Zstr16
Property INPAYZstr16 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = INPAY_Zstr16 ];

/// INPAY_Zstr17
Property INPAYZstr17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = INPAY_Zstr17 ];

/// INPAY_Zstr18
Property INPAYZstr18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 59, SqlFieldName = INPAY_Zstr18 ];

/// INPAY_Zstr19
Property INPAYZstr19 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 60, SqlFieldName = INPAY_Zstr19 ];

/// INPAY_Zstr20
Property INPAYZstr20 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 61, SqlFieldName = INPAY_Zstr20 ];

/// INPAY_Zstr21
Property INPAYZstr21 As %Library.String(COLLATION = "Exact", MAXLEN = 400, TRUNCATE = 0) [ SqlColumnNumber = 62, SqlFieldName = INPAY_Zstr21 ];

/// INPAY_Zstr22
Property INPAYZstr22 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 63, SqlFieldName = INPAY_Zstr22 ];

/// INPAY_Zstr23
Property INPAYZstr23 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 64, SqlFieldName = INPAY_Zstr23 ];

/// INPAY_Zstr24
Property INPAYZstr24 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 65, SqlFieldName = INPAY_Zstr24 ];

/// INPAY_Zstr25
Property INPAYZstr25 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 66, SqlFieldName = INPAY_Zstr25 ];

/// INPAY_Zstr26
Property INPAYZstr26 As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 67, SqlFieldName = INPAY_Zstr26 ];

/// INPAY_Zstr27
Property INPAYZstr27 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 68, SqlFieldName = INPAY_Zstr27 ];

/// INPAY_Zstr28
Property INPAYZstr28 As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 69, SqlFieldName = INPAY_Zstr28 ];

/// INPAY_Zstr29 -有索引
Property INPAYZstr29 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 70, SqlFieldName = INPAY_Zstr29 ];

/// INPAY_Zstr30
Property INPAYZstr30 As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 71, SqlFieldName = INPAY_Zstr30 ];

/// INPAY_HospDr DingSH 20200617
Property INPAYHospDr As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 72, SqlFieldName = INPAY_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDIV)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INPAY_AdmDr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INPAY_AdmInfoDr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INPAY_DHCpblDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INPAY_DhcInvPrtDr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INPAY_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INPAY_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>71</Piece>
</Data>
<Data name="INPAY_INSUDivideDr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INPAY_InsuPay1">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INPAY_InsuPay10">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INPAY_InsuPay2">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INPAY_InsuPay3">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INPAY_InsuPay4">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INPAY_InsuPay5">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INPAY_InsuPay6">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INPAY_InsuPay7">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INPAY_InsuPay8">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INPAY_InsuPay9">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INPAY_Zstr01">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INPAY_Zstr02">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INPAY_Zstr03">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INPAY_Zstr04">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INPAY_Zstr05">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INPAY_Zstr06">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INPAY_Zstr07">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INPAY_Zstr08">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INPAY_Zstr09">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INPAY_Zstr10">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INPAY_Zstr11">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INPAY_Zstr12">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INPAY_Zstr13">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INPAY_Zstr14">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INPAY_Zstr15">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INPAY_Zstr16">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INPAY_Zstr17">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="INPAY_Zstr18">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="INPAY_Zstr19">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="INPAY_Zstr20">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="INPAY_Zstr21">
<Delimiter>"^"</Delimiter>
<Piece>61</Piece>
</Data>
<Data name="INPAY_Zstr22">
<Delimiter>"^"</Delimiter>
<Piece>62</Piece>
</Data>
<Data name="INPAY_Zstr23">
<Delimiter>"^"</Delimiter>
<Piece>63</Piece>
</Data>
<Data name="INPAY_Zstr24">
<Delimiter>"^"</Delimiter>
<Piece>64</Piece>
</Data>
<Data name="INPAY_Zstr25">
<Delimiter>"^"</Delimiter>
<Piece>65</Piece>
</Data>
<Data name="INPAY_Zstr26">
<Delimiter>"^"</Delimiter>
<Piece>66</Piece>
</Data>
<Data name="INPAY_Zstr27">
<Delimiter>"^"</Delimiter>
<Piece>67</Piece>
</Data>
<Data name="INPAY_Zstr28">
<Delimiter>"^"</Delimiter>
<Piece>68</Piece>
</Data>
<Data name="INPAY_Zstr29">
<Delimiter>"^"</Delimiter>
<Piece>69</Piece>
</Data>
<Data name="INPAY_Zstr30">
<Delimiter>"^"</Delimiter>
<Piece>70</Piece>
</Data>
<Data name="INPAY_bcbxf0">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INPAY_bckbcs">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INPAY_bqbm00">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INPAY_brnl00">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INPAY_cardno">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INPAY_cfxms0">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INPAY_crbcts">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INPAY_djlsh0">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INPAY_grzfe0">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INPAY_iDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INPAY_iTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INPAY_id0000">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INPAY_jjzfe0">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INPAY_ptbcts">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INPAY_sUserDr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INPAY_sfrq00">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INPAY_sfrxm0">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INPAY_sfsj00">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INPAY_sftsbz">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INPAY_xbie00">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INPAY_xming0">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INPAY_zhzfe0">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INPAY_zyksmc">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INPAY_zylsh0">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Global>^DHCINDIV</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexofAdm">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Paadm"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_AdmDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofAdmInfo">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADMINFO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_AdmInfoDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofBussiNo">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BussiNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPAY_Zstr29}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCInvprt">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DHCInvPrt"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_DhcInvPrtDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCPB">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DHCPB"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_DHCpblDr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDjlsh0">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Djlsh0"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_djlsh0}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofID0000">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ID0000"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_id0000}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIDate">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_iDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofINSUDivideDr">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INSUDivideDr"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPAY_INSUDivideDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofZylsh0">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Zylsh0"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INPAY_zylsh0}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexofsfrq00">
<Global>^DHCINDIV</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INPAY_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"sfrq00"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INPAY_sfrq00}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INPAY_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDivideS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
