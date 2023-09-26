Class User.DHCDocPilotProQCZYZ Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPQCZYZ_RowId, SqlTableName = DHC_DocPilotProQCZYZ, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On PPQCZYZChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_DocPilotProject Parent Reference
Relationship PPQCZYZPPParRef As User.DHCDocPilotProject [ Cardinality = parent, Inverse = ChildDHCDocPilotProQCZYZ, Required, SqlFieldName = PPQCZYZ_PP_ParRef ];

/// PPQCZYZ_ChildSub
Property PPQCZYZChildSub As %Library.Float [ InitialExpression = {$i(^DHCDocPPSAE(+$s($d(initvalue):initvalue,1:%d(0)),0))}, Required, SqlColumnNumber = 2, SqlFieldName = PPQCZYZ_ChildSub ];

/// PPQCZYZ_Date：打印日期
Property PPQCZYZDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PPQCZYZ_Date ];

Property QualityControlor As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Quality_Controlor ];

Property QualitycontrolDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = Quality_controlDate ];

Property QualityControlResult As %Library.String(COLLATION = "Exact", MAXLEN = 50000, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Quality_Control_Result ];

Property A1 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PP_A1 ];

/// Property A1Result As %Library.String(COLLATION = "Exact", MAXLEN = 5000, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = A1Result ];
Property A1Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PP_A1Q ];

Property A2 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = PP_A2 ];

Property A2Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PP_A2Q ];

Property A3 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = PP_A3 ];

Property A3Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = PP_A3Q ];

Property A4 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PP_A4 ];

Property A4Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = PP_A4Q ];

Property A5 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = PP_A5 ];

Property A5Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = PP_A5Q ];

Property A6 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = PP_A6 ];

Property A6Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = PP_A6Q ];

Property A7 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = PP_A7 ];

Property A7Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = PP_A7Q ];

Property A8 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = PP_A8 ];

Property A8Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = PP_A8Q ];

Property A9 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = PP_A9 ];

Property A9Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PP_A9Q ];

Property A10 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = PP_A10 ];

Property A10Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = PP_A10Q ];

Property A11 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = PP_A11 ];

Property A11Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = PP_A11Q ];

Property A12 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = PP_A12 ];

Property A12Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = PP_A12Q ];

Property A13 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = PP_A13 ];

Property A13Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = PP_A13Q ];

Property A14 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = PP_A14 ];

Property A14Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = PP_A14Q ];

Property A15 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = PP_A15 ];

Property A15Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = PP_A15Q ];

Property A16 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = PP_A16 ];

Property A16Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = PP_A16Q ];

Property B1 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = PP_B1 ];

Property B1Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PP_B1Q ];

Property B2 As %Library.String(COLLATION = "Exact", MAXLEN = 5, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = PP_B2 ];

Property B2Q As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = PP_B2Q ];

Property QCZYZFlag As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = PP_QCZYZ_Flag ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterIndex">
<Data name="PPQCZYZ_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PP_A1">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PP_A10">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PP_A10Q">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PP_A11">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PP_A11Q">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PP_A12">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PP_A12Q">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PP_A13">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PP_A13Q">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PP_A14">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PP_A14Q">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PP_A15">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PP_A15Q">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PP_A16">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PP_A16Q">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PP_A1Q">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PP_A2">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PP_A2Q">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PP_A3">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PP_A3Q">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PP_A4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PP_A4Q">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PP_A5">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PP_A5Q">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PP_A6">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PP_A6Q">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PP_A7">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PP_A7Q">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PP_A8">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PP_A8Q">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PP_A9">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PP_A9Q">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PP_B1">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PP_B1Q">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="PP_B2">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="PP_B2Q">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="PP_QCZYZ_Flag">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="Quality_Control_Result">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="Quality_Controlor">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="Quality_controlDate">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Global>^DHCDocPPQCZYZ</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>PPQCZYZ_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{PPQCZYZ_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="PPQCZYZDateIndex">
<Global>^DHCDocPPQCZYZ</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_DocPilotProject.PP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>PPQCZYZ_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PPQCZYZ_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_DocPilotProject.PP_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{PPQCZYZ_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProQCZYZS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
