Class User.DHCDocItemDefault Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DID_Rowid, SqlTableName = DHC_Doc_ItemDefault, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DID_ARCIM_DR
Property DIDARCIMDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = DID_ARCIM_DR ];

/// DID_ContralType
Property DIDContralType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DID_ContralType ];

/// DID_ContralKey
Property DIDContralKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DID_ContralKey ];

/// DID_ActiveFlag
Property DIDActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = DID_ActiveFlag ];

/// DID_Priority_DR
Property DIDPriorityDR As User.OECPriority [ SqlColumnNumber = 6, SqlFieldName = DID_Priority_DR ];

/// DID_Dose
Property DIDDose As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DID_Dose ];

/// DID_DoseUom_DR
Property DIDDoseUomDR As User.CTUOM [ SqlColumnNumber = 8, SqlFieldName = DID_DoseUom_DR ];

/// DID_Instr_DR
Property DIDInstrDR As User.PHCInstruc [ SqlColumnNumber = 9, SqlFieldName = DID_Instr_DR ];

/// DID_PHFreq_DR
Property DIDPHFreqDR As User.PHCFreq [ SqlColumnNumber = 10, SqlFieldName = DID_PHFreq_DR ];

/// DID_Durat_DR
Property DIDDuratDR As User.PHCDuration [ SqlColumnNumber = 11, SqlFieldName = DID_Durat_DR ];

/// DID_PackQty
Property DIDPackQty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = DID_PackQty ];

/// DID_SkinTest
Property DIDSkinTest As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = DID_SkinTest ];

/// DID_SkinAction
Property DIDSkinAction As User.OECAction [ SqlColumnNumber = 14, SqlFieldName = DID_SkinAction ];

/// DID_RelevanceNo
Property DIDRelevanceNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = DID_RelevanceNo ];

/// DID_UserAdd_DR
Property DIDUserAddDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = DID_UserAdd_DR ];

/// DID_DateAdd
Property DIDDateAdd As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = DID_DateAdd ];

/// DID_TimeAdd
Property DIDTimeAdd As %Library.Time [ SqlColumnNumber = 18, SqlFieldName = DID_TimeAdd ];

/// DID_LastUpdateUser
Property DIDLastUpdateUser As User.SSUser [ SqlColumnNumber = 19, SqlFieldName = DID_LastUpdateUser ];

/// DID_LastUpdateDate
Property DIDLastUpdateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = DID_LastUpdateDate ];

/// DID_LastUpdateTime
Property DIDLastUpdateTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = DID_LastUpdateTime ];

/// DID_Notes
Property DIDNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DID_Notes ];

/// DID_Notes1
Property DIDNotes1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = DID_Notes1 ];

/// DID_AdmType
Property DIDAdmType As %Library.String [ SqlColumnNumber = 24, SqlFieldName = DID_AdmType ];

/// DID_SpeedFlowRate
Property DIDSpeedFlowRate As %Library.String [ SqlColumnNumber = 25, SqlFieldName = DID_SpeedFlowRate ];

/// DID_FlowRateUnit
Property DIDFlowRateUnit As User.OECSpeedFlowRate [ SqlColumnNumber = 26, SqlFieldName = DID_FlowRateUnit ];

Property DIDExceedReasonDR As User.DHCDocExceedReason [ SqlColumnNumber = 27, SqlFieldName = DID_ExceedReasonDR ];

Property DIDRecLocDr As User.CTLoc [ SqlColumnNumber = 28, SqlFieldName = DID_RecLocDr ];

/// 同频次不同剂量
Property DIDOrderFreqTimeDoseStr As %String [ SqlColumnNumber = 29, SqlFieldName = DID_OrderFreqTimeDoseStr ];

/// 周频次星期
Property DIDOrderFreqWeekStr As %Library.String(COLLATION = "Exact", MAXLEN = 30000, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = DID_OrderFreqWeekStr ];

/// 整包装单位
Property DIDPackUomDR As User.CTUOM [ SqlColumnNumber = 31, SqlFieldName = DID_PackUom_DR ];

/// 使用院区
Property DIDUserHospDR As User.CTHospital [ SqlColumnNumber = 32, SqlFieldName = DID_UserHosp_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCDID)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DID_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DID_ActiveFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DID_AdmType">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DID_ContralKey">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DID_ContralType">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DID_DateAdd">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DID_Dose">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DID_DoseUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DID_Durat_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DID_ExceedReasonDR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DID_FlowRateUnit">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DID_Instr_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DID_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DID_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DID_LastUpdateUser">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DID_Notes">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DID_Notes1">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DID_OrderFreqTimeDoseStr">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DID_OrderFreqWeekStr">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DID_PHFreq_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DID_PackQty">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DID_PackUom_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DID_Priority_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DID_RecLocDr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DID_RelevanceNo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DID_SkinAction">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DID_SkinTest">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DID_SpeedFlowRate">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DID_TimeAdd">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DID_UserAdd_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DID_UserHosp_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Global>^DHCDID</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexContral">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Contral"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_ContralType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_ContralKey}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDateAdd">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateAdd"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_DateAdd}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastDate">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LastDate"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_LastUpdateDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLastUpdateUser">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LastUser"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_LastUpdateUser}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserAdd">
<Global>^DHCDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"UserAdd"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DID_UserAdd_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDocItemDefaultS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
