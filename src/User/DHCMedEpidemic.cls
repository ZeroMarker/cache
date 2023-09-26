Class User.DHCMedEpidemic Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MEPD_Rowid, SqlTableName = DHC_MedEpidemic, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCMedEpidemicSub As User.DHCMedEpidemicSub [ Cardinality = children, Inverse = MEPDSParRef ];

/// dMEPD_Papmi_DR
Property MEPDPapmiDR As User.PAPatMas [ SqlColumnNumber = 2, SqlFieldName = MEPD_Papmi_DR ];

/// MEPD_Area
Property MEPDArea As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = MEPD_Area ];

/// MEPD_Occupation
Property MEPDOccupation As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = MEPD_Occupation ];

/// MEPD_FamName
Property MEPDFamName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = MEPD_FamName ];

/// MEPD_ICD_DR
Property MEPDICDDR As User.DHCMedInfection [ SqlColumnNumber = 6, SqlFieldName = MEPD_ICD_DR ];

/// MEPD_IntimateCode
Property MEPDIntimateCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = MEPD_IntimateCode ];

/// MEPD_DiagnoseType
Property MEPDDiagnoseType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = MEPD_DiagnoseType ];

/// MEPD_SickDate
Property MEPDSickDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = MEPD_SickDate ];

/// MEPD_DiagDegree
Property MEPDDiagDegree As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = MEPD_DiagDegree ];

/// MEPD_DiagDate
Property MEPDDiagDate As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = MEPD_DiagDate ];

/// MEPD_SickKind
Property MEPDSickKind As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = MEPD_SickKind ];

/// MEPD_DeathDate
Property MEPDDeathDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = MEPD_DeathDate ];

/// MEPD_Loc_DR
Property MEPDLocDR As User.CTLoc [ SqlColumnNumber = 14, SqlFieldName = MEPD_Loc_DR ];

/// MEPD_RepPlace
Property MEPDRepPlace As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = MEPD_RepPlace ];

/// MEPD_Status
Property MEPDStatus As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = MEPD_Status ];

/// MEPD_RepUsr_DR
Property MEPDRepUsrDR As User.SSUser [ SqlColumnNumber = 17, SqlFieldName = MEPD_RepUsr_DR ];

/// MEPD_RepDate
Property MEPDRepDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = MEPD_RepDate ];

/// MEPD_RepTime
Property MEPDRepTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = MEPD_RepTime ];

/// MEPD_CheckUsr_DR
Property MEPDCheckUsrDR As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = MEPD_CheckUsr_DR ];

/// MEPD_CheckDate
Property MEPDCheckDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = MEPD_CheckDate ];

/// MEPD_CheckTime
Property MEPDCheckTime As %Library.Time [ SqlColumnNumber = 22, SqlFieldName = MEPD_CheckTime ];

/// MEPD_Demo
Property MEPDDemo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = MEPD_Demo ];

/// MEPD_DelReason
Property MEPDDelReason As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = MEPD_DelReason ];

/// MEPD_Mepd_DR
Property MEPDMepdDR As User.DHCMedEpidemic [ SqlColumnNumber = 25, SqlFieldName = MEPD_Mepd_DR ];

/// MEPD_TelPhone
Property MEPDTelPhone As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = MEPD_TelPhone ];

/// MEPD_Address
Property MEPDAddress As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = MEPD_Address ];

/// MEPD_Company
Property MEPDCompany As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = MEPD_Company ];

/// MEPD_IDAddress
Property MEPDIDAddress As %Library.String(COLLATION = "Exact", MAXLEN = 80, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = MEPD_IDAddress ];

/// MEPD_TEXT1
Property MEPDTEXT1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = MEPD_TEXT1 ];

/// MEPD_TEXT2
Property MEPDTEXT2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = MEPD_TEXT2 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMEPD)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="MEPD_Address">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MEPD_Area">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MEPD_CheckDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MEPD_CheckTime">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MEPD_CheckUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MEPD_Company">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="MEPD_DeathDate">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MEPD_DelReason">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="MEPD_Demo">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MEPD_DiagDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MEPD_DiagDegree">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MEPD_DiagnoseType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MEPD_FamName">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MEPD_ICD_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MEPD_IDAddress">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="MEPD_IntimateCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MEPD_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MEPD_Mepd_DR">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MEPD_Occupation">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MEPD_Papmi_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MEPD_RepDate">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MEPD_RepPlace">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MEPD_RepTime">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MEPD_RepUsr_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="MEPD_SickDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MEPD_SickKind">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MEPD_Status">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MEPD_TEXT1">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="MEPD_TEXT2">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="MEPD_TelPhone">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Global>^DHCMEPD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateLoc">
<Global>^DHCMEPD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DateLoc"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEPD_RepDate}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEPD_Loc_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPAPMIICD">
<Global>^DHCMEPD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>MEPD_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"PAPMIICD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{MEPD_Papmi_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{MEPD_ICD_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{MEPD_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMedEpidemicS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
