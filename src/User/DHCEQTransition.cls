Class User.DHCEQTransition Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = T_RowID, SqlTableName = DHC_EQTransition, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property THold1 As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = T_Hold1 ];

Property THold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = T_Hold2 ];

Property THold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = T_Hold3 ];

Property THold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = T_Hold4 ];

Property THold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = T_Hold5 ];

Property THold6 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = T_Hold6 ];

Property THold7 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = T_Hold7 ];

Property THold8 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = T_Hold8 ];

Property THold9 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = T_Hold9 ];

Property THold10 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = T_Hold10 ];

Property THold11 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = T_Hold11 ];

Property THold12 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = T_Hold12 ];

Property THold13 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = T_Hold13 ];

Property THold14 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = T_Hold14 ];

Property THold15 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = T_Hold15 ];

Property THold16 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = T_Hold16 ];

Property THold17 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = T_Hold17 ];

Property THold18 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = T_Hold18 ];

Property THold19 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = T_Hold19 ];

Property THold20 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = T_Hold20 ];

Property THold21 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = T_Hold21 ];

Property THold22 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = T_Hold22 ];

Property THold23 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = T_Hold23 ];

Property THold24 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = T_Hold24 ];

Property THold25 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = T_Hold25 ];

Property THold26 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = T_Hold26 ];

Property THold27 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = T_Hold27 ];

Property THold28 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = T_Hold28 ];

Property THold29 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = T_Hold29 ];

Property THold30 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = T_Hold30 ];

Property THold31 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = T_Hold31 ];

Property THold32 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = T_Hold32 ];

Property THold33 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = T_Hold33 ];

Property THold34 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = T_Hold34 ];

Property THold35 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = T_Hold35 ];

Property THold36 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = T_Hold36 ];

Property THold37 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = T_Hold37 ];

Property THold38 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = T_Hold38 ];

Property THold39 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = T_Hold39 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQTransition(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="T_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="T_Hold10">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="T_Hold11">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="T_Hold12">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="T_Hold13">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="T_Hold14">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="T_Hold15">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="T_Hold16">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="T_Hold17">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="T_Hold18">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="T_Hold19">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="T_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="T_Hold20">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="T_Hold21">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="T_Hold22">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="T_Hold23">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="T_Hold24">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="T_Hold25">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="T_Hold26">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="T_Hold27">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="T_Hold28">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="T_Hold29">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="T_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="T_Hold30">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="T_Hold31">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="T_Hold32">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="T_Hold33">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="T_Hold34">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="T_Hold35">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="T_Hold36">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="T_Hold37">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="T_Hold38">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="T_Hold39">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="T_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="T_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="T_Hold6">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="T_Hold7">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="T_Hold8">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="T_Hold9">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^DHCEQTransition</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>T_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{T_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQTranstionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
