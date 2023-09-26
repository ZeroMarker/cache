Class User.DHCPhaWorkLoad Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PHAWL_RowId, SqlTableName = DHC_PhaWorkLoad, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// PHAWL_User
Property PHAWLUserDr As User.SSUser [ SqlColumnNumber = 2, SqlFieldName = PHAWL_User_Dr ];

/// PHAWL_Loc_Dr
Property PHAWLLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = PHAWL_Loc_Dr ];

/// PHAWL_DispIncNum
Property PHAWLDispIncNum As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PHAWL_DispIncNum ];

/// PHAWL_DispAmt
Property PHAWLDispAmt As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = PHAWL_DispAmt ];

/// PHAWL_DispRpAmt
Property PHAWLDispRpAmt As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = PHAWL_DispRpAmt ];

/// PHAWL_DispPreNum
Property PHAWLDispPreNum As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = PHAWL_DispPreNum ];

/// PHAWL_DispDoseNum
Property PHAWLDispDoseNum As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = PHAWL_DispDoseNum ];

/// PHAWL_RetIncNum
Property PHAWLRetIncNum As %Library.Float [ SqlColumnNumber = 9, SqlFieldName = PHAWL_RetIncNum ];

/// PHAWL_DispCookPreNum
Property PHAWLDispCookPreNum As %Library.Float [ SqlColumnNumber = 10, SqlFieldName = PHAWL_DispCookPreNum ];

/// PHAWL_DispCookDoseNum
Property PHAWLDispCookDoseNum As %Library.Float [ SqlColumnNumber = 11, SqlFieldName = PHAWL_DispCookDoseNum ];

/// PHAWL_DispCookAmt
Property PHAWLDispCookAmt As %Library.Float [ SqlColumnNumber = 12, SqlFieldName = PHAWL_DispCookAmt ];

/// PHAWL_DispCookRpAmt
Property PHAWLDispCookRpAmt As %Library.Float [ SqlColumnNumber = 13, SqlFieldName = PHAWL_DispCookRpAmt ];

/// PHAWL_DispOutPreNum
Property PHAWLDispOutPreNum As %Library.Float [ SqlColumnNumber = 14, SqlFieldName = PHAWL_DispOutPreNum ];

/// PHAWL_DispOutDoseNum
Property PHAWLDispOutDoseNum As %Library.Float [ SqlColumnNumber = 15, SqlFieldName = PHAWL_DispOutDoseNum ];

/// PHAWL_DispOutAmt
Property PHAWLDispOutAmt As %Library.Float [ SqlColumnNumber = 16, SqlFieldName = PHAWL_DispOutAmt ];

/// PHAWL_DispOutRpAmt
Property PHAWLDispOutRpAmt As %Library.Float [ SqlColumnNumber = 17, SqlFieldName = PHAWL_DispOutRpAmt ];

/// PHAWL_RetAmt
Property PHAWLRetAmt As %Library.Float [ SqlColumnNumber = 18, SqlFieldName = PHAWL_RetAmt ];

/// PHAWL_RetRpAmt
Property PHAWLRetRpAmt As %Library.Float [ SqlColumnNumber = 19, SqlFieldName = PHAWL_RetRpAmt ];

/// PHAWL_RetPreNum
Property PHAWLRetPreNum As %Library.Float [ SqlColumnNumber = 20, SqlFieldName = PHAWL_RetPreNum ];

/// PHAWL_RetDoseNum
Property PHAWLRetDoseNum As %Library.Float [ SqlColumnNumber = 21, SqlFieldName = PHAWL_RetDoseNum ];

/// PHAWL_RetCookPreNum
Property PHAWLRetCookPreNum As %Library.Float [ SqlColumnNumber = 22, SqlFieldName = PHAWL_RetCookPreNum ];

/// PHAWL_RetCookDoseNum
Property PHAWLRetCookDoseNum As %Library.Float [ SqlColumnNumber = 23, SqlFieldName = PHAWL_RetCookDoseNum ];

/// PHAWL_RetCookAmt
Property PHAWLRetCookAmt As %Library.Float [ SqlColumnNumber = 24, SqlFieldName = PHAWL_RetCookAmt ];

/// PHAWL_RetCookRpAmt
Property PHAWLRetCookRpAmt As %Library.Float [ SqlColumnNumber = 25, SqlFieldName = PHAWL_RetCookRpAmt ];

/// PHAWL_Date
Property PHAWLDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = PHAWL_Date ];

/// PHAWL_DispNoNum
Property PHAWLDispNoNum As %Library.Float [ SqlColumnNumber = 27, SqlFieldName = PHAWL_DispNoNum ];

/// PHAWL_PyIncNum
Property PHAWLPyIncNum As %Library.Float [ SqlColumnNumber = 28, SqlFieldName = PHAWL_PyIncNum ];

/// PHAWL_PyRpAmt
Property PHAWLPyRpAmt As %Library.Float [ SqlColumnNumber = 29, SqlFieldName = PHAWL_PyRpAmt ];

/// PHAWL_PyAmt
Property PHAWLPyAmt As %Library.Float [ SqlColumnNumber = 30, SqlFieldName = PHAWL_PyAmt ];

/// PHAWL_PyNoNum
Property PHAWLPyNoNum As %Library.Float [ SqlColumnNumber = 31, SqlFieldName = PHAWL_PyNoNum ];

/// PHAWL_RetNoNum
Property PHAWLRetNoNum As %Library.Float [ SqlColumnNumber = 32, SqlFieldName = PHAWL_RetNoNum ];

/// PHAWL_DispPreIncNum
Property PHAWLDispPreIncNum As %Library.Float [ SqlColumnNumber = 33, SqlFieldName = PHAWL_DispPreIncNum ];

/// PHAWL_PyPreNum
Property PHAWLPyPreNum As %Library.Float [ SqlColumnNumber = 34, SqlFieldName = PHAWL_PyPreNum ];

/// PHAWL_PyDoseNum
Property PHAWLPyDoseNum As %Library.Float [ SqlColumnNumber = 35, SqlFieldName = PHAWL_PyDoseNum ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPHAWKL)</SqlIdExpression>
<SQLMap name="IndexDateLoc">
<Global>^DHCPHAWKL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>PHAWL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PHAWL_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PHAWL_Loc_Dr}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PHAWL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="PHAWL_Date">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="PHAWL_DispAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAWL_DispCookAmt">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PHAWL_DispCookDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PHAWL_DispCookPreNum">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PHAWL_DispCookRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PHAWL_DispDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PHAWL_DispIncNum">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PHAWL_DispNoNum">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="PHAWL_DispOutAmt">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="PHAWL_DispOutDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PHAWL_DispOutPreNum">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PHAWL_DispOutRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="PHAWL_DispPreIncNum">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="PHAWL_DispPreNum">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PHAWL_DispRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PHAWL_Loc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAWL_PyAmt">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="PHAWL_PyDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="PHAWL_PyIncNum">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="PHAWL_PyNoNum">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="PHAWL_PyPreNum">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="PHAWL_PyRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="PHAWL_RetAmt">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="PHAWL_RetCookAmt">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="PHAWL_RetCookDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="PHAWL_RetCookPreNum">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="PHAWL_RetCookRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="PHAWL_RetDoseNum">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="PHAWL_RetIncNum">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="PHAWL_RetNoNum">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="PHAWL_RetPreNum">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PHAWL_RetRpAmt">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="PHAWL_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCPHAWKL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAWL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PHAWL_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaWorkLoadS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
