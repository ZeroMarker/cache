Class User.PMPImprovementDetail Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = IPMD_Rowid, SqlTableName = PMP_ImprovementDetail, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On IPMDChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildDHCPMComRecord As User.DHCPMComRecord [ Cardinality = children, Inverse = PMDeParRef ];

/// DataLevelSets Parent Reference
Relationship PMPImprovementListParRef As PMPImprovementList [ Cardinality = parent, Inverse = ChildPMPImprovementList, Required, SqlFieldName = PMP_ImprovementList_ParRef ];

/// IPMDChildsub
Property IPMDChildsub As %Library.Numeric(SCALE = 0) [ InitialExpression = {$i(^PMPImprovementDetail($p(%d(0),$c(1),1),0))}, Required, SqlColumnNumber = 2, SqlFieldName = IPMD_Childsub ];

/// IPMDFlag
Property IPMDFlag As PMPDictionary3 [ SqlColumnNumber = 3, SqlFieldName = IPMD_Flag ];

/// IPMDStatusDR
Property IPMDStatusDR As PMPDictionary3 [ SqlColumnNumber = 4, SqlFieldName = IPMD_Status_DR ];

/// IPMDRemark
Property IPMDRemark As %String(COLLATION = "AlphaUp", MAXLEN = 2048, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = IPMD_Remark ];

/// IPMDCommunicationDate
Property IPMDCommunicationDate As %Date [ SqlColumnNumber = 6, SqlFieldName = IPMD_CommunicationDate ];

/// IPMDUpdateDate
Property IPMDUpdateDate As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IPMD_UpdateDate ];

/// IPMDUpdateTime
Property IPMDUpdateTime As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPMD_UpdateTime ];

/// IPMDUpdateUserDR
Property IPMDUpdateUserDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = IPMD_UpdateUser_DR ];

/// IPMDCommunicationDR
Property IPMDCommunicationDR As PMPDictionary3 [ SqlColumnNumber = 10, SqlFieldName = IPMD_Communication_DR ];

/// IPMDCommunicationUserDR
Property IPMDCommunicationUserDR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = IPMD_CommunicationUser_DR ];

/// IPMDCommunicationUser1DR
Property IPMDCommunicationUser1DR As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IPMD_CommunicationUser1_DR ];

/// IPMDCommunicationMatter
Property IPMDCommunicationMatter As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = IPMD_CommunicationMatter ];

/// IPMDAccessory
Property IPMDAccessory As %String(DISPLAYLIST = ",无,有", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",No,Yes") [ SqlColumnNumber = 14, SqlFieldName = IPMD_Accessory ];

/// IPMDStandby1
Property IPMDStandby1 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = IPMD_Standby1 ];

/// IPMDStandby2
Property IPMDStandby2 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = IPMD_Standby2 ];

/// IPMDStandby3
Property IPMDStandby3 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = IPMD_Standby3 ];

/// IPMDStandby4
Property IPMDStandby4 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPMD_Standby4 ];

/// IPMDStandby5
Property IPMDStandby5 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = IPMD_Standby5 ];

/// IPMDCommunicationTime
Property IPMDCommunicationTime As %Time [ SqlColumnNumber = 20, SqlFieldName = IPMD_CommunicationTime ];

/// IPMDLocid
Property IPMDLocid As CTLoc [ SqlColumnNumber = 21, SqlFieldName = IPMD_Locid ];

/// IPMDDhccDate
Property IPMDDhccDate As %Date [ SqlColumnNumber = 22, SqlFieldName = IPMD_DhccDate ];

/// IPMDDhccTime
Property IPMDDhccTime As %Time [ SqlColumnNumber = 23, SqlFieldName = IPMD_DhccTime ];

/// IPMDDhccUser
Property IPMDDhccUser As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 24, SqlFieldName = IPMD_DhccUser ];

/// IPMDDhccStatus
Property IPMDDhccStatus As PMPDictionary3 [ SqlColumnNumber = 25, SqlFieldName = IPMD_DhccStatus ];

/// IPMDStandby6
Property IPMDStandby6 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = IPMD_Standby6 ];

/// IPMDStandby7
Property IPMDStandby7 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 27, SqlFieldName = IPMD_Standby7 ];

/// IPMDStandby8
Property IPMDStandby8 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = IPMD_Standby8 ];

/// IPMDStandby9
Property IPMDStandby9 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = IPMD_Standby9 ];

/// IPMDStandby10
Property IPMDStandby10 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = IPMD_Standby10 ];

/// IPMDStandby11
Property IPMDStandby11 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 31, SqlFieldName = IPMD_Standby11 ];

/// IPMDStandby12
Property IPMDStandby12 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 32, SqlFieldName = IPMD_Standby12 ];

/// IPMDStandby13
Property IPMDStandby13 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 33, SqlFieldName = IPMD_Standby13 ];

/// IPMDStandby14
Property IPMDStandby14 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = IPMD_Standby14 ];

/// IPMDStandby15
Property IPMDStandby15 As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = IPMD_Standby15 ];

/// IPMD_DhccFlag
Property IPMDDhccFlag As %String(DISPLAYLIST = ",No,Yes", MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 36, SqlFieldName = IPMD_DhccFlag ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^User.PMPImprovementDetail(0))</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="IPMD_Accessory">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPMD_CommunicationDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPMD_CommunicationMatter">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPMD_CommunicationTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPMD_CommunicationUser1_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPMD_CommunicationUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPMD_Communication_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPMD_DhccDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="IPMD_DhccFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="IPMD_DhccStatus">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="IPMD_DhccTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="IPMD_DhccUser">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="IPMD_Flag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPMD_Locid">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="IPMD_Remark">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPMD_Standby1">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPMD_Standby10">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="IPMD_Standby11">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="IPMD_Standby12">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="IPMD_Standby13">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="IPMD_Standby14">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="IPMD_Standby15">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="IPMD_Standby2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPMD_Standby3">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IPMD_Standby4">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="IPMD_Standby5">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="IPMD_Standby6">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="IPMD_Standby7">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="IPMD_Standby8">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="IPMD_Standby9">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="IPMD_Status_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPMD_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="IPMD_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPMD_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PMP_ImprovementList_ParRef">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^PMPImprovementDetail</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMP_ImprovementList.IPML_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>IPMD_Childsub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOftoAuditLoc">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"toAudiLocId"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_Standby2}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCCDATE">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCCDATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPMD_DhccDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofDHCCFLAG">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"DHCCFLAG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPMD_DhccFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofFlagUser">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"FlagUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPMD_Flag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofIPMDFlag">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Flag"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_Flag}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofUpdateUser">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"UpdateUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indeofToAuditUser">
<Global>^PMPImprovementDetaili</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"toAudiUser"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPMD_UpdateUser_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexofStatus">
<Global>^PMPImprovementDetail</Global>
<PopulationType>nonnull</PopulationType>
<Subscript name="1">
<Expression>"Status"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PMP_ImprovementList.IPML_Rowid}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{IPMD_Status_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IPMD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.PMPImprovementDetailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
