/// DHCC OE_OrdExec Extend
Class User.DHCOEOrdExec Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DHCORE_RowId, SqlTableName = DHC_OE_OrdExec, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 500000;

/// DHCORE_OEORE_Dr
Property DHCOREOEOREDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DHCORE_OEORE_Dr ];

/// DHCORE_OEORE_Date
Property DHCOREOEOREDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DHCORE_OEORE_Date ];

/// DHCORE_Printed
Property DHCOREPrinted As %Library.String(COLLATION = "Exact", MAXLEN = 30, SELECTIVITY = "33.3333%", TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DHCORE_Printed ];

/// DHCORE_CTLOC_Dr
Property DHCORECTLOCDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DHCORE_CTLOC_Dr ];

/// DHCORE_Ward_Dr
Property DHCOREWardDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DHCORE_Ward_Dr ];

/// DHCORE_QueryCode
Property DHCOREQueryCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DHCORE_QueryCode ];

/// DHCORE_Group
Property DHCOREGroup As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DHCORE_Group ];

/// DHCORE_SeatNo
Property DHCORESeatNo As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DHCORE_SeatNo ];

/// DHCORE_OEORE_Time
Property DHCOREOEORETime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = DHCORE_OEORE_Time ];

/// DHCORE_Ssuser_Dr
Property DHCORESsuserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = DHCORE_Ssuser_Dr ];

/// DHCORE_OEORI_Dr
Property DHCOREOEORIDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DHCORE_OEORI_Dr ];

/// DHCORE_SpecCollUser
Property DHCORESpecCollUser As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DHCORE_SpecCollUser ];

/// DHCORE_SpecCollDate
Property DHCORESpecCollDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = DHCORE_SpecCollDate ];

/// DHCORE_SpecCollTime
Property DHCORESpecCollTime As %Library.Time [ SqlColumnNumber = 15, SqlFieldName = DHCORE_SpecCollTime ];

/// DHCORE_PrintUser_Dr
Property DHCOREPrintUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = DHCORE_PrintUser_Dr ];

/// DHCORE_PrintDate
Property DHCOREPrintDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DHCORE_PrintDate ];

/// DHCORE_PrintTime
Property DHCOREPrintTime As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DHCORE_PrintTime ];

/// DHCORE_AuditUser_Dr
Property DHCOREAuditUserDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = DHCORE_AuditUser_Dr ];

/// DHCORE_AuditDate
Property DHCOREAuditDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DHCORE_AuditDate ];

/// DHCORE_AuditTime
Property DHCOREAuditTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DHCORE_AuditTime ];

/// DHCORE_MedUnitCareProv_Dr
Property DHCOREMedUnitCareProvDr As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = DHCORE_MedUnitCareProv_Dr ];

/// DHCORE_PeiMedical    是否配药标识
Property DHCORIPeiMedical As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DHCORE_PeiMedical ];

/// DHCORE_PeiMedicalUser_dr   配药用户ID
Property DHCORIPeiMedicalUserdr As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = DHCORE_PeiMedicalUser_dr ];

/// DHCORE_PeiMedicalDate     配药日期
Property DHCORIPeiMedicalDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 25, SqlFieldName = DHCORE_PeiMedicalDate ];

/// DHCORE_PeiMedicalTime     配药时间
Property DHCORIPeiMedicalTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = DHCORE_PeiMedicalTime ];

/// DHCORE_HeSMedical    是否核药标识
Property DHCORIHeSMedical As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 27, SqlFieldName = DHCORE_HeSMedical ];

/// DHCORE_HeSMedicalUser_dr   核药用户ID
Property DHCORIHeSMedicalUserdr As User.SSUser [ SqlColumnNumber = 28, SqlFieldName = DHCORE_HeSMedicalUser_dr ];

/// DHCORE_HeSMedicallDate     核药日期
Property DHCORIHeSMedicallDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 29, SqlFieldName = DHCORE_HeSMedicallDate ];

/// DHCORE_HeSMedicallTime     核药时间
Property DHCORIHeSMedicallTime As %Library.Time [ SqlColumnNumber = 30, SqlFieldName = DHCORE_HeSMedicallTime ];

/// 撤销核药人
Property DHCORECelHeMedicalUserdr As %Library.Time [ SqlColumnNumber = 31, SqlFieldName = DHCORE_CelHeMedicalUser_dr ];

/// 撤销核药日期
Property DHCORECelHeMedicallDate As %Library.Time [ SqlColumnNumber = 32, SqlFieldName = DHCORE_CelHeMedicallDate ];

/// 撤销核药时间
Property DHCORECelHeMedicallTime As %Library.Time [ SqlColumnNumber = 33, SqlFieldName = DHCORE_CelHeMedicallTime ];

/// 撤销配药人
Property DHCORECelPeiMedicalUserdr As %Library.Time [ SqlColumnNumber = 34, SqlFieldName = DHCORE_CelPeiMedicalUser_dr ];

/// 撤销配药日期
Property DHCORECelPeiMedicallDate As %Library.Time [ SqlColumnNumber = 35, SqlFieldName = DHCORE_CelPeiMedicallDate ];

/// 撤销配药时间
Property DHCORECelPeiMedicallTime As %Library.Time [ SqlColumnNumber = 36, SqlFieldName = DHCORE_CelPeiMedicallTime ];

/// DHCORE_BaiMedical    是否摆药标识
Property DHCORIBaiMedical As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = DHCORE_BaiMedical ];

/// DHCORE_BaiMedicalUser_dr   摆药用户ID
Property DHCORIBaiMedicalUserdr As User.SSUser [ SqlColumnNumber = 38, SqlFieldName = DHCORE_BaiMedicalUser_dr ];

/// DHCORE_BaiMedicalDate     摆药日期
Property DHCORIBaiMedicalDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 39, SqlFieldName = DHCORE_BaiMedicalDate ];

/// DHCORE_BaiMedicalTime     摆药时间
Property DHCORIBaiMedicalTime As %Library.Time [ SqlColumnNumber = 40, SqlFieldName = DHCORE_BaiMedicalTime ];

/// 撤销摆药人
Property DHCORECelBaiMedicalUserdr As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = DHCORE_CelBaiMedicalUser_dr ];

/// 撤销摆药日期
Property DHCORECelBaiMedicallDate As %Library.Time [ SqlColumnNumber = 42, SqlFieldName = DHCORE_CelBaiMedicallDate ];

/// 撤销摆药时间
Property DHCORECelBaiMedicallTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = DHCORE_CelBaiMedicallTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCOrdExec(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DHCORE_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DHCORE_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DHCORE_AuditUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DHCORE_BaiMedical">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="DHCORE_BaiMedicalDate">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="DHCORE_BaiMedicalTime">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="DHCORE_BaiMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="DHCORE_CTLOC_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DHCORE_CelBaiMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="DHCORE_CelBaiMedicallDate">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="DHCORE_CelBaiMedicallTime">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="DHCORE_CelHeMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DHCORE_CelHeMedicallDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DHCORE_CelHeMedicallTime">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DHCORE_CelPeiMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="DHCORE_CelPeiMedicallDate">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="DHCORE_CelPeiMedicallTime">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="DHCORE_Group">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DHCORE_HeSMedical">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DHCORE_HeSMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DHCORE_HeSMedicallDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DHCORE_HeSMedicallTime">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DHCORE_MedUnitCareProv_Dr">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DHCORE_OEORE_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DHCORE_OEORE_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DHCORE_OEORE_Time">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DHCORE_OEORI_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DHCORE_PeiMedical">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DHCORE_PeiMedicalDate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DHCORE_PeiMedicalTime">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DHCORE_PeiMedicalUser_dr">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DHCORE_PrintDate">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DHCORE_PrintTime">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DHCORE_PrintUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DHCORE_Printed">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DHCORE_QueryCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DHCORE_SeatNo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DHCORE_SpecCollDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DHCORE_SpecCollTime">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DHCORE_SpecCollUser">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DHCORE_Ssuser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DHCORE_Ward_Dr">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCOrdExec</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DHCORE_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDate">
<Global>^DHCOrdExec</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORE_OEORE_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOeoreDr">
<Global>^DHCOrdExec</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"OEOREDR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORE_OEORE_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrintDate">
<Global>^DHCOrdExec</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PrnDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORE_Ward_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORE_PrintDate}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DHCORE_PrintTime}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DHCORE_QueryCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{DHCORE_PrintUser_Dr}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{DHCORE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecCollDate">
<Global>^DHCOrdExec</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SCollDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORE_SpecCollDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexoeori">
<Global>^DHCOrdExec</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCORE_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DHCOEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCORE_OEORI_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCORE_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCOEOrdExecS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
