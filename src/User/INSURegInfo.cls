Class User.INSURegInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INRIF_Rowid, SqlTableName = INSU_RegInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INRIF_PatRegNO
Property INRIFPatRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INRIF_PatRegNo ];

/// INRIF_PatName
Property INRIFPatName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INRIF_PatName ];

/// INRIF_PatID
Property INRIFPatID As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INRIF_PatID ];

/// INRIF_Diagnose
Property INRIFDiagnose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INRIF_Diagnose ];

/// INRIF_Flag
Property INRIFFlag As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INRIF_Flag ];

/// INRIF_InsuId
Property INRIFInsuId As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INRIF_InsuId ];

/// INRIF_PatType
Property INRIFPatType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INRIF_PatType ];

/// INRIF_PAADM
Property INRIFPAADM As %Library.Numeric(SCALE = 0) [ SqlColumnNumber = 9, SqlFieldName = INRIF_PAADM ];

/// INRIF_RegSerNo
Property INRIFInsuRegNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INRIF_InsuRegNo ];

/// INRIF_Type
Property INRIFType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INRIF_Type ];

/// INRIF_RegType
Property INRIFRegType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INRIF_RegType ];

/// INRIF_UserDr
Property INRIFUserDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INRIF_UserDr ];

/// INRIF_InsuCenter
Property INRIFInsuCenter As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INRIF_InsuCenter ];

/// INRIF_ActFlag
Property INRIFActFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INRIF_ActFlag ];

/// INRIF_DocDr
Property INRIFDocDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INRIF_DocDr ];

/// INRIF_Str16
Property INRIFStr16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = INRIF_Str16 ];

/// INRIF_Str17
Property INRIFStr17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = INRIF_Str17 ];

/// INRIF_Str18
Property INRIFStr18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INRIF_Str18 ];

/// INRIF_Str19
Property INRIFStr19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INRIF_Str19 ];

/// INRIF_Str20
Property INRIFStr20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = INRIF_Str20 ];

/// INRIF_Str21
Property INRIFStr21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = INRIF_Str21 ];

/// INRIF_Str22
Property INRIFStr22 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = INRIF_Str22 ];

/// INRIF_Str23
Property INRIFStr23 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = INRIF_Str23 ];

/// INRIF_Str24
Property INRIFStr24 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = INRIF_Str24 ];

/// INRIF_Str25
Property INRIFStr25 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = INRIF_Str25 ];

/// INRIF_Str26
Property INRIFStr26 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = INRIF_Str26 ];

/// INRIF_Str27
Property INRIFStr27 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = INRIF_Str27 ];

/// INRIF_Str28
Property INRIFStr28 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = INRIF_Str28 ];

/// INRIF_Str29
Property INRIFStr29 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = INRIF_Str29 ];

/// INRIF_Str30
Property INRIFStr30 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = INRIF_Str30 ];

/// INRIF_Str31
Property INRIFStr31 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = INRIF_Str31 ];

/// INRIF_Str32
Property INRIFStr32 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = INRIF_Str32 ];

/// INRIF_Str33
Property INRIFStr33 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = INRIF_Str33 ];

/// INRIF_Str34
Property INRIFStr34 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = INRIF_Str34 ];

/// INRIF_Str35
Property INRIFStr35 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = INRIF_Str35 ];

/// INRIF_Str36
Property INRIFStr36 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = INRIF_Str36 ];

/// INRIF_Str37
Property INRIFStr37 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = INRIF_Str37 ];

/// INRIF_Str38
Property INRIFStr38 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = INRIF_Str38 ];

/// INRIF_Str39
Property INRIFStr39 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = INRIF_Str39 ];

/// INRIF_Str40
Property INRIFStr40 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = INRIF_Str40 ];

/// INRIF_Str41
Property INRIFStr41 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = INRIF_Str41 ];

/// INRIF_Str42
Property INRIFStr42 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = INRIF_Str42 ];

/// INRIF_Str43
Property INRIFStr43 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = INRIF_Str43 ];

/// INRIF_Str44
Property INRIFStr44 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = INRIF_Str44 ];

/// INRIF_Str45
Property INRIFStr45 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = INRIF_Str45 ];

/// INRIF_Str46
Property INRIFStr46 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = INRIF_Str46 ];

/// INRIF_Str47
Property INRIFStr47 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = INRIF_Str47 ];

/// INRIF_Str48
Property INRIFStr48 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = INRIF_Str48 ];

/// INRIF_Str49
Property INRIFStr49 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = INRIF_Str49 ];

/// INRIF_Str50
Property INRIFStr50 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = INRIF_Str50 ];

/// INRIF_Date1
Property INRIFDate1 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 52, SqlFieldName = INRIF_Date1 ];

/// INRIF_Time1
Property INRIFTime1 As %Library.Time [ SqlColumnNumber = 53, SqlFieldName = INRIF_Time1 ];

/// INRIF_Date2
Property INRIFDate2 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 54, SqlFieldName = INRIF_Date2 ];

/// INRIF_Time2
Property INRIFTime2 As %Library.Time [ SqlColumnNumber = 55, SqlFieldName = INRIF_Time2 ];

/// INRIF_Date3
Property INRIFDate3 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 56, SqlFieldName = INRIF_Date3 ];

/// INRIF_Time3
Property INRIFTime3 As %Library.Time [ SqlColumnNumber = 57, SqlFieldName = INRIF_Time3 ];

/// INRIF_Date4
Property INRIFDate4 As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 58, SqlFieldName = INRIF_Date4 ];

/// INRIF_Time4
Property INRIFTime4 As %Library.Time [ SqlColumnNumber = 59, SqlFieldName = INRIF_Time4 ];

/// INRIF_OptDate
Property INRIFOptDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 60, SqlFieldName = INRIF_OptDate ];

/// INRIF_OptTime
Property INRIFOptTime As %Library.Time [ SqlColumnNumber = 61, SqlFieldName = INRIF_OptTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINSUREGINFO)</SqlIdExpression>
<SQLMap name="DatemasterMap">
<Data name="INRIF_ActFlag">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INRIF_Date1">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="INRIF_Date2">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="INRIF_Date3">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="INRIF_Date4">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="INRIF_Diagnose">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INRIF_DocDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INRIF_Flag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INRIF_InsuCenter">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INRIF_InsuId">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INRIF_InsuRegNo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INRIF_OptDate">
<Delimiter>"^"</Delimiter>
<Piece>59</Piece>
</Data>
<Data name="INRIF_OptTime">
<Delimiter>"^"</Delimiter>
<Piece>60</Piece>
</Data>
<Data name="INRIF_PAADM">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INRIF_PatID">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INRIF_PatName">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INRIF_PatRegNo">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INRIF_PatType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INRIF_RegType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INRIF_Str16">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INRIF_Str17">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INRIF_Str18">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INRIF_Str19">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INRIF_Str20">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INRIF_Str21">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INRIF_Str22">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INRIF_Str23">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INRIF_Str24">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INRIF_Str25">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INRIF_Str26">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INRIF_Str27">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INRIF_Str28">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INRIF_Str29">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INRIF_Str30">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INRIF_Str31">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="INRIF_Str32">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="INRIF_Str33">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="INRIF_Str34">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="INRIF_Str35">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="INRIF_Str36">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="INRIF_Str37">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="INRIF_Str38">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="INRIF_Str39">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="INRIF_Str40">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="INRIF_Str41">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="INRIF_Str42">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="INRIF_Str43">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="INRIF_Str44">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="INRIF_Str45">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="INRIF_Str46">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="INRIF_Str47">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="INRIF_Str48">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="INRIF_Str49">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="INRIF_Str50">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="INRIF_Time1">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="INRIF_Time2">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="INRIF_Time3">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="INRIF_Time4">
<Delimiter>"^"</Delimiter>
<Piece>58</Piece>
</Data>
<Data name="INRIF_Type">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INRIF_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^DHCINSUREGINFO</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsuRegNo">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsuRegNo"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_InsuRegNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate1">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date1"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_Date1}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate2">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date2"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_Date2}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate3">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date3"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_Date3}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDate4">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date4"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_Date4}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofInsuId">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"InsuId"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_InsuId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofOptDate">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"OptDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_OptDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPAADM">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_PAADM}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPatID">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PatID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_PatID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofPatRegNO">
<Global>^DHCINSUREGINFO</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INRIF_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"PatRegNO"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INRIF_PatRegNo}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INRIF_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSURegInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
