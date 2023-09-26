Class User.DHCMRIPDay Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, StorageStrategy = SQLStorage ]
{

/// MRIP_yydm
Property MRIPyydm As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = MRIP_yydm ];

/// MRIP_date
Property MRIPdate As %Date [ SqlColumnNumber = 3, SqlFieldName = MRIP_date ];

/// MRIP_loc_dr
Property MRIPlocdr As CTLoc [ SqlColumnNumber = 4, SqlFieldName = MRIP_loc_dr ];

/// MRIP_bednum
Property MRIPbednum As %Float [ SqlColumnNumber = 5, SqlFieldName = MRIP_bednum ];

/// MRIP_zyrs
Property MRIPlyrs As %Float [ SqlColumnNumber = 6, SqlFieldName = MRIP_lyrs ];

/// MRIP_ryrs
Property MRIPryrs As %Float [ SqlColumnNumber = 7, SqlFieldName = MRIP_ryrs ];

/// MRIP_tkzrrs
Property MRIPtkzrrs As %Float [ SqlColumnNumber = 8, SqlFieldName = MRIP_tkzrrs ];

/// MRIP_zwtkrs
Property MRIPzwtkrs As %Float [ SqlColumnNumber = 9, SqlFieldName = MRIP_zwtkrs ];

/// MRIP_tyrs
Property MRIPtyrs As %Float [ SqlColumnNumber = 10, SqlFieldName = MRIP_tyrs ];

/// MRIP_crrs
Property MRIPcrrs As %Float [ SqlColumnNumber = 11, SqlFieldName = MRIP_crrs ];

/// MRIP_creatdate
Property MRIPcreatdate As %Date [ SqlColumnNumber = 12, SqlFieldName = MRIP_creatdate ];

/// MRIP_creattime
Property MRIPcreattime As %Time [ SqlColumnNumber = 13, SqlFieldName = MRIP_creattime ];

/// MRIP_creatuser
Property MRIPcreatuser As SSUser [ SqlColumnNumber = 14, SqlFieldName = MRIP_creatuser ];

/// MRIP_PHRS
Property MRIPPHRS As %Float [ SqlColumnNumber = 15, SqlFieldName = MRIP_PHRS ];

/// MRIP_BWRS
Property MRIPBWRS As %Float [ SqlColumnNumber = 16, SqlFieldName = MRIP_BWRS ];

/// MRIP_QJRS
Property MRIPQJRS As %Float [ SqlColumnNumber = 17, SqlFieldName = MRIP_QJRS ];

/// MRIP_SWRS
Property MRIPSWRS As %Float [ SqlColumnNumber = 18, SqlFieldName = MRIP_SWRS ];

/// MRIP_XYRS
Property MRIPXYRS As %Float [ SqlColumnNumber = 19, SqlFieldName = MRIP_XYRS ];

/// MRIP_WARD
Property MRIPWARD As PACWard [ SqlColumnNumber = 20, SqlFieldName = MRIP_WARD ];

/// MRIP_subloc_dr
Property MRIPsublocdr As %String [ SqlColumnNumber = 21, SqlFieldName = MRIP_subloc_dr ];

/// MRIP_knzc
Property MRIPknzc As %Float [ SqlColumnNumber = 22, SqlFieldName = MRIP_knzc ];

/// MRIP_knzr
Property MRIPknzr As %Float [ SqlColumnNumber = 23, SqlFieldName = MRIP_knzr ];

/// MRIP_gdbednum
Property MRIPgdbednum As %Float [ SqlColumnNumber = 24, SqlFieldName = MRIP_gdbednum ];

/// Empty bed
Property MRIPqnkc As %Float [ SqlColumnNumber = 25, SqlFieldName = MRIP_qnkc ];

/// add bed
Property MRIPqnjc As %Float [ SqlColumnNumber = 26, SqlFieldName = MRIP_qnjc ];

/// MRIP_PatAtBed
Property MRIPPatAtBed As %Float [ SqlColumnNumber = 27, SqlFieldName = MRIP_PatAtBed ];

/// MRIP_MRDisNum
Property MRIPMRDisNum As %Float [ SqlColumnNumber = 28, SqlFieldName = MRIP_MRDisNum ];

/// MRIP_MRXYRS
Property MRIPMRXYRS As %Float [ SqlColumnNumber = 29, SqlFieldName = MRIP_MRXYRS ];

/// MRIP_MRYYRS
Property MRIPMRYYRS As %Float [ SqlColumnNumber = 30, SqlFieldName = MRIP_MRYYRS ];

/// MRIP_DepWardFlag
Property MRIPDepWardFlag As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MRIP_DepWardFlag ];

/// MRIP_ZYRS
Property MRIPZYRS As %Float [ SqlColumnNumber = 32, SqlFieldName = MRIP_ZYRS ];

/// MRIP_HZRS
Property MRIPHZRS As %Float [ SqlColumnNumber = 33, SqlFieldName = MRIP_HZRS ];

/// MRIP_WYRS
Property MRIPWYRS As %Float [ SqlColumnNumber = 34, SqlFieldName = MRIP_WYRS ];

/// MRIP_QTRS
Property MRIPQTRS As %Float [ SqlColumnNumber = 35, SqlFieldName = MRIP_QTRS ];

/// MRIP_CYZCZRS
Property MRIPCYZCZRS As %Float [ SqlColumnNumber = 36, SqlFieldName = MRIP_CYZCZRS ];

/// MRIP_ZYZCZRS
Property MRIPZYZCZRS As %Float [ SqlColumnNumber = 37, SqlFieldName = MRIP_ZYZCZRS ];

/// MRIP_ZKTS
Property MRIPZKTS As %Float [ SqlColumnNumber = 38, SqlFieldName = MRIP_ZKTS ];

/// MRIP_PJCYRS
Property MRIPPJCYRS As %Float [ SqlColumnNumber = 39, SqlFieldName = MRIP_PJCYRS ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRIPdaily(0))</SqlIdExpression>
<SQLMap name="INDESXWARD">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIPWARD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_WARD}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRIPDATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXMRIPDATELOC">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIPloc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_loc_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRIPdate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXMRIPSUBLOC">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIPSubLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_subloc_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRIPDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="INDEXTypeDate">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_DepWardFlag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MASTERMRIPdaily">
<Data name="MRIP_BWRS">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MRIP_CYZCZRS">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="MRIP_DepWardFlag">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MRIP_HZRS">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="MRIP_MRDisNum">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MRIP_MRXYRS">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MRIP_MRYYRS">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MRIP_PHRS">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MRIP_PJCYRS">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="MRIP_PatAtBed">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MRIP_QJRS">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MRIP_QTRS">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="MRIP_SWRS">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MRIP_WARD">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MRIP_WYRS">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="MRIP_XYRS">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MRIP_ZKTS">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="MRIP_ZYRS">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="MRIP_ZYZCZRS">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="MRIP_bednum">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MRIP_creatdate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MRIP_creattime">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MRIP_creatuser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MRIP_crrs">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MRIP_date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MRIP_gdbednum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MRIP_knzc">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MRIP_knzr">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MRIP_loc_dr">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MRIP_lyrs">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MRIP_qnjc">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MRIP_qnkc">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MRIP_ryrs">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MRIP_subloc_dr">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MRIP_tkzrrs">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MRIP_tyrs">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MRIP_yydm">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MRIP_zwtkrs">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Global>^MRIPdaily</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="indexmripdate">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIP_DATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexsubloc">
<Global>^MRIPdaily</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>MRIP_rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"MRIPLoc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRIP_loc_dr}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"MRIPDate"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MRIP_date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"MRIPSubLoc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MRIP_subloc_dr}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{MRIP_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>MRIP_rowid</SqlRowIdName>
<StreamLocation>^User.DHCMRIPDayS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
