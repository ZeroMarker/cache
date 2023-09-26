/// Operation              (ORCOP,1004)
Class User.ORCOperation Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = ORC_Operation, StorageStrategy = SQLStorage ]
{

Relationship ChildORCOperationKeywords As ORCOperationKeywords [ Cardinality = children, Inverse = KEYWParRef ];

Relationship ChildORCOperationAlias As ORCOperationAlias [ Cardinality = children, Inverse = ALIASParRef ];

Relationship ChildORCOperationItemLink As ORCOperationItemLink [ Cardinality = children, Inverse = LINKParRef ];

Relationship ChildORCOperationEdition As ORCOperationEdition [ Cardinality = children, Inverse = EDParRef ];

/// ICD Code
Property OPERCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = OPER_Code ];

/// Operation Description
Property OPERDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = OPER_Desc ];

/// Des Ref to ARCIM
Property OPERARCIMDR As ARCItmMast [ SqlColumnNumber = 5, SqlFieldName = OPER_ARCIM_DR ];

/// Date Active From
Property OPERDateActiveFrom As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 6, SqlFieldName = OPER_DateActiveFrom ];

/// Active Date To
Property OPERActiveDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = OPER_ActiveDateTo ];

/// Des Ref  Oper Category
Property OPERDefaultCategoryDR As ORCOperationCategory [ SqlColumnNumber = 8, SqlFieldName = OPER_DefaultCategory_DR ];

/// Default Estimated Time
Property OPERDefaultEstimTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = OPER_DefaultEstimTime ];

/// Day Surgery
Property OPERDaySurgery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = OPER_DaySurgery ];

/// Age From
Property OPERAgeFrom As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = OPER_AgeFrom ];

/// Age To
Property OPERAgeTo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = OPER_AgeTo ];

/// Des Ref Sex
Property OPERSexDR As CTSex [ SqlColumnNumber = 13, SqlFieldName = OPER_Sex_DR ];

/// Length Of Stay
Property OPERLengthOfStay As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = OPER_LengthOfStay ];

/// ICD10
Property OPERICD10 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = OPER_ICD10 ];

/// Days in Advance to Admit
Property OPERDaysAdvance As %Float [ SqlColumnNumber = 16, SqlFieldName = OPER_DaysAdvance ];

/// External Cause
Property OPERExternalCause As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = OPER_ExternalCause ];

/// Unacceptable PDx
Property OPERUnacceptablePDx As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = OPER_UnacceptablePDx ];

/// 国家标准编码（临床版） 节点位置18
Property OPERNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = OPER_NationalCode ];

/// Mechanical Ventilation Code
Property OPERMechVentilCode As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = OPER_MechVentilCode ];

/// First ICD10 Mapping
Property OPERICD10Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = OPER_ICD10Map ];

/// ICD9 Mapping
Property OPERICD9Map As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 22, SqlFieldName = OPER_ICD9Map ];

/// Valid
Property OPERValid As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = OPER_Valid ];

/// Des Ref Age Check Type1
Property OPERAgeCheckTypeDR As MRCAgeCheckType [ SqlColumnNumber = 24, SqlFieldName = OPER_AgeCheckType_DR ];

/// Age From1
Property OPERAgeFrom1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = OPER_AgeFrom1 ];

/// Age To1
Property OPERAgeTo1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = OPER_AgeTo1 ];

/// Des Ref Age2 Check Type
Property OPERAge2CheckTypeDR As MRCAgeCheckType [ SqlColumnNumber = 27, SqlFieldName = OPER_Age2CheckType_DR ];

/// Age2From
Property OPERAge2From As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = OPER_Age2From ];

/// Des Ref Sex Check Type
Property OPERSexCheckTypeDR As MRCSexCheckType [ SqlColumnNumber = 29, SqlFieldName = OPER_SexCheckType_DR ];

/// Des Ref Area Code Restraints
Property OPERAreaCodeRestraintsDR As MRCAreaCodeRestraint [ SqlColumnNumber = 30, SqlFieldName = OPER_AreaCodeRestraints_DR ];

/// Des Ref Dagger and Asterisk Edit
Property OPERDaggerAsterEditDR As MRCDaggerAnAsteriskEdit [ SqlColumnNumber = 31, SqlFieldName = OPER_DaggerAsterEdit_DR ];

/// Des Ref Additional Code Requirement
Property OPERAddCodReqDR As MRCAdditCodeReq [ SqlColumnNumber = 32, SqlFieldName = OPER_AddCodReq_DR ];

/// Des Ref Coding Practices
Property OPERCodPracticesDR As MRCCodingPractices [ SqlColumnNumber = 33, SqlFieldName = OPER_CodPractices_DR ];

/// Age2 To
Property OPERAge2To As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = OPER_Age2To ];

/// Block Number
Property OPERBlockNumber As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = OPER_BlockNumber ];

/// Long Description
Property OPERLongDescription As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = OPER_LongDescription ];

/// Procedure Date Mandatory Flag
Property OPERProcDateMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = OPER_ProcDateMandatory ];

/// 国家标准名称（临床版） 节点位置37
Property OPERNationalDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 38, SqlFieldName = OPER_NationalDesc ];

/// 国家医保编码 节点位置38
Property OPERInsuCode As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 39, SqlFieldName = OPER_InsuCode ];

/// 国家医保名称 节点位置39
Property OPERInsuDesc As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 40, SqlFieldName = OPER_InsuDesc ];

/// 是否医保灰码 ^40
Property OPERGrayCodeFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 41, SqlFieldName = OPER_GrayCodeFlag ];

/// 版本号 ^41 add@2022-12-27
Property OPERVersionDictDR As CT.BDP.CT.BDVersionDict [ SqlColumnNumber = 42, SqlFieldName = OPER_VersionDict_DR ];

/// 国家标准分级 ^42 2023-3-2
Property OPERStandardClassDR As ORCOperationCategory [ SqlColumnNumber = 43, SqlFieldName = OPER_StandardClass_DR ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ORCOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnAfterInsert")
 d PREFINS^at1004({OPER_RowId})
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ORCOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnAfterUpdate")
 d PREFINS^at1004({OPER_RowId})
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ORCOperation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ORCOperation).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnBeforeUpdate")
 d PREFUPD^at1004({OPER_RowId})
 d VALUPD^atgen
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnBeforeInsert")
 d VALINS^atgen
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ORCOperation).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperation","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ORC("OPER",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="OPER_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="OPER_ActiveDateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="OPER_AddCodReq_DR">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="OPER_Age2CheckType_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="OPER_Age2From">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="OPER_Age2To">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="OPER_AgeCheckType_DR">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="OPER_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="OPER_AgeFrom1">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="OPER_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="OPER_AgeTo1">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OPER_AreaCodeRestraints_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="OPER_BlockNumber">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="OPER_CodPractices_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="OPER_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="OPER_DaggerAsterEdit_DR">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="OPER_DateActiveFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="OPER_DaySurgery">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="OPER_DaysAdvance">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="OPER_DefaultCategory_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OPER_DefaultEstimTime">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="OPER_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="OPER_ExternalCause">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="OPER_GrayCodeFlag">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="OPER_ICD10">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="OPER_ICD10Map">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="OPER_ICD9Map">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="OPER_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="OPER_InsuDesc">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="OPER_LengthOfStay">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="OPER_LongDescription">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OPER_MechVentilCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="OPER_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="OPER_NationalDesc">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="OPER_ProcDateMandatory">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="OPER_SexCheckType_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="OPER_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="OPER_StandardClass_DR">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="OPER_UnacceptablePDx">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="OPER_Valid">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="OPER_VersionDict_DR">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OPER_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPER_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPER_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({OPER_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexICD10">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ICD10"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPER_ICD10}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexVersionDictDR">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>OPER_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"VersionDictDR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{OPER_VersionDict_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{OPER_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>OPER_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
