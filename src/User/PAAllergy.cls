/// Allergy                  (ALG,6004)
Class User.PAAllergy Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Allergy, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1708;

Index RowIDBasedIDKeyIndex On ALGChildSub [ IdKey, PrimaryKey, Unique ];

/// PA_PatMas Parent Reference
Relationship ALGPAPMIParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAAllergy, Required, SqlFieldName = ALG_PAPMI_ParRef ];

/// Child Sub
Property ALGChildSub As %Float [ InitialExpression = {$i(^PAPER(+$s($d(initvalue):initvalue,1:%d(0)),"ALG",0))}, SqlColumnNumber = 2, SqlFieldName = ALG_ChildSub ];

/// CTCP DR
Property ALGCTPCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = ALG_CTPCP_DR ];

/// Reaction To Allergy
Property ALGReaction As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ALG_Reaction ];

/// PHCGE_DR
Property ALGPHCGEDR As PHCGeneric [ SqlColumnNumber = 5, SqlComputeCode = { i {ALG_Entered}="" s {ALG_PHCGE_DR}="" q
 s {ALG_PHCGE_DR}=$$CO5^at6004({ALG_Type_DR})
}, SqlComputed, SqlComputeOnChange = (ALGEntered, ALGTypeDR), SqlFieldName = ALG_PHCGE_DR ];

/// PHCSC DR
Property ALGPHCSCDR As PHCSubCat [ SqlColumnNumber = 6, SqlComputeCode = { i {ALG_Entered}="" s {ALG_PHCSC_DR}="" q
 s {ALG_PHCSC_DR}=$$CO6^at6004({ALG_Type_DR})
}, SqlComputed, SqlComputeOnChange = (ALGEntered, ALGTypeDR), SqlFieldName = ALG_PHCSC_DR ];

/// Other Allergy
Property ALGOthAllergy As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlComputeCode = { i {ALG_Entered}="" s {ALG_OthAllergy}="" q
 s {ALG_OthAllergy}=$$CO05^at6004({ALG_Type_DR},{ALG_Entered})
}, SqlComputed, SqlComputeOnChange = (ALGEntered, ALGTypeDR), SqlFieldName = ALG_OthAllergy ];

/// Allergy
Property ALGTypeDR As PACAllergy [ SqlColumnNumber = 8, SqlFieldName = ALG_Type_DR ];

/// Entered Allergy
Property ALGEntered As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ALG_Entered ];

/// Sort
Property ALGSort As %String(COLLATION = "Exact", MAXLEN = 48, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlComputeCode = { i {ALG_Type_DR}="" s {ALG_Sort}="" q
 i {ALG_PAPMI_ParRef}="" s {ALG_Sort}="" q
 s {ALG_Sort}={ALG_Type_DR}_{ALG_PAPMI_ParRef}
}, SqlComputed, SqlFieldName = ALG_Sort, Transient ];

/// Status
Property ALGStatus As %String(DISPLAYLIST = ",Active,Resolved,Inactive,ToBeConfirmed", MAXLEN = 13, TRUNCATE = 1, VALUELIST = ",A,R,I,C") [ SqlColumnNumber = 11, SqlFieldName = ALG_Status ];

/// Date
Property ALGDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 12, SqlFieldName = ALG_Date ];

/// Onset Date
Property ALGOnsetDate As %Date [ SqlColumnNumber = 13, SqlFieldName = ALG_OnsetDate ];

/// Duration in Days
Property ALGDuratDays As %Float [ SqlColumnNumber = 14, SqlFieldName = ALG_DuratDays ];

/// Duration in Month
Property ALGDuratMonth As %Float [ SqlColumnNumber = 15, SqlFieldName = ALG_DuratMonth ];

/// Duration in Year
Property ALGDuratYear As %Float [ SqlColumnNumber = 16, SqlFieldName = ALG_DuratYear ];

/// Description
Property ALGDesc As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 17, SqlFieldName = ALG_Desc, SqlListType = SUBNODE ];

/// Time
Property ALGTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = ALG_Time ];

/// Des Ref User
Property ALGUpdateUserDR As SSUser [ SqlColumnNumber = 19, SqlFieldName = ALG_UpdateUser_DR ];

/// RequireAssistanceMeal
Property ALGRequireAssistanceMeal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = ALG_RequireAssistanceMeal ];

/// RequireAssistanceMenu
Property ALGRequireAssistanceMenu As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = ALG_RequireAssistanceMenu ];

/// InActive
Property ALGInActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 22, SqlFieldName = ALG_InActive ];

/// Des Ref LastUpdateHospital
Property ALGLastUpdateHospitalDR As CTHospital [ SqlColumnNumber = 23, SqlFieldName = ALG_LastUpdateHospital_DR ];

/// Des Ref Severity
Property ALGSeverityDR As PACAllergySeverity [ SqlColumnNumber = 24, SqlFieldName = ALG_Severity_DR ];

/// OnsetDateFreeText
Property ALGOnsetDateFreeText As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = ALG_OnsetDateFreeText ];

/// Last Update Date
Property ALGLastUpdateDate As %Date [ SqlColumnNumber = 26, SqlFieldName = ALG_LastUpdateDate ];

/// Last Update Time
Property ALGLastUpdateTime As %Time [ SqlColumnNumber = 27, SqlFieldName = ALG_LastUpdateTime ];

/// Des Ref Category - Nature of Reaction
Property ALGCategoryDR As PACAllergyCategory [ SqlColumnNumber = 28, SqlFieldName = ALG_Category_DR ];

/// Des Ref PHCDRGForm
Property ALGPHCDRGFormDR As PHCDrgForm [ SqlColumnNumber = 29, SqlFieldName = ALG_PHCDRGForm_DR ];

/// Comments
Property ALGComments As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 30, SqlFieldName = ALG_Comments, SqlListType = SUBNODE ];

/// Des Ref PHCDM
Property ALGPHCDMDR As PHCDrgMast [ SqlColumnNumber = 31, SqlFieldName = ALG_PHCDM_DR ];

/// Des Ref ReasForChange
Property ALGReasForChangeDR As PACAllergyReasonForChang [ SqlColumnNumber = 32, SqlFieldName = ALG_ReasForChange_DR ];

/// Des Ref to MRC_AllType - Allergy Category
Property ALGMRCAllTypeDR As MRCAllType [ SqlColumnNumber = 33, SqlFieldName = ALG_MRCAllType_DR ];

/// ExternalID
Property ALGExternalID As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 34, SqlFieldName = ALG_ExternalID ];

/// FreeTextAllergy
Property ALGFreeTextAllergy As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 35, SqlFieldName = ALG_FreeTextAllergy ];

/// Des Ref Ingred
Property ALGIngredDR As PHCIngredient [ SqlColumnNumber = 36, SqlFieldName = ALG_Ingred_DR ];

/// DrugSpecific
Property ALGDrugSpecific As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = ALG_DrugSpecific ];

/// DSReportFlag
Property ALGDSReportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 38, SqlFieldName = ALG_DSReportFlag ];

/// ALGSkinTestFlag护士置阳性记录
Property ALGSkinTestFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = ALG_SkinTestFlag ];

/// ALGSkinTestOEORIDR护士置阳性对应的医嘱ID
Property ALGSkinTestOEORIDR As User.OEOrdItem [ SqlColumnNumber = 40, SqlFieldName = ALG_SkinTestOEORI_DR ];

/// 过敏原补充
Property ALGDescAdd As %String [ SqlColumnNumber = 41, SqlFieldName = ALG_DescAdd ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAAllergy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAllergy","OnAfterDelete")
 d Table^HL7Outbound("PAAllergy",%old(1),"Delete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAAllergy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAllergy","OnAfterInsert")
 d Table^HL7Outbound("PAAllergy",%d(1),"Insert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAAllergy).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAllergy","OnAfterUpdate")
 d Table^HL7Outbound("PAAllergy",%d(1),"Update")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAAllergy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAllergy","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAAllergy).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAAllergy","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1708</ExtentSize>
<Property name="ALGCTPCPDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGCategoryDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGChildSub">
<Selectivity>2.5964%</Selectivity>
</Property>
<Property name="ALGComments">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGDSReportFlag">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGDate">
<Selectivity>0.9424%</Selectivity>
</Property>
<Property name="ALGDesc">
<Selectivity>49.9998%</Selectivity>
</Property>
<Property name="ALGDrugSpecific">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGDuratDays">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGDuratMonth">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGDuratYear">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGEntered">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGExternalID">
<Selectivity>6.6653%</Selectivity>
</Property>
<Property name="ALGFreeTextAllergy">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGInActive">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGIngredDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGLastUpdateDate">
<Selectivity>7.6919%</Selectivity>
</Property>
<Property name="ALGLastUpdateHospitalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGLastUpdateTime">
<Selectivity>7.1421%</Selectivity>
</Property>
<Property name="ALGMRCAllTypeDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ALGOnsetDate">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGOnsetDateFreeText">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGOthAllergy">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGPAPMIParRef">
<Selectivity>0.5009%</Selectivity>
</Property>
<Property name="ALGPHCDMDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGPHCDRGFormDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGPHCGEDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="ALGPHCSCDR">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGReaction">
<Selectivity>99.9993%</Selectivity>
</Property>
<Property name="ALGReasForChangeDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGRequireAssistanceMeal">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGRequireAssistanceMenu">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGSeverityDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="ALGSort">
<Selectivity>2.4415%</Selectivity>
</Property>
<Property name="ALGStatus">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ALGTime">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALGTypeDR">
<Selectivity>4.3290%</Selectivity>
</Property>
<Property name="ALGUpdateUserDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<SQLMap name="DataMasterMap">
<Data name="ALG_CTPCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALG_Category_DR">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="ALG_Comments">
<Node>"CMT"</Node>
</Data>
<Data name="ALG_DSReportFlag">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="ALG_Date">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="ALG_Desc">
<Node>"REM"</Node>
</Data>
<Data name="ALG_DescAdd">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="ALG_DrugSpecific">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="ALG_DuratDays">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ALG_DuratMonth">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ALG_DuratYear">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ALG_Entered">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ALG_ExternalID">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="ALG_FreeTextAllergy">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="ALG_InActive">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="ALG_Ingred_DR">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="ALG_LastUpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="ALG_LastUpdateHospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="ALG_LastUpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="ALG_MRCAllType_DR">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ALG_OnsetDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ALG_OnsetDateFreeText">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="ALG_OthAllergy">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ALG_PHCDM_DR">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="ALG_PHCDRGForm_DR">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ALG_PHCGE_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ALG_PHCSC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ALG_Reaction">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ALG_ReasForChange_DR">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="ALG_RequireAssistanceMeal">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ALG_RequireAssistanceMenu">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="ALG_Severity_DR">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="ALG_SkinTestFlag">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="ALG_SkinTestOEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="ALG_Sort">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ALG_Status">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ALG_Time">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ALG_Type_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ALG_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ALG_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALG"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALG_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
<Condition>{ALG_SkinTestOEORI_DR}'=""</Condition>
<ConditionFields>ALG_SkinTestOEORI_DR</ConditionFields>
<Global>^PAPER</Global>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ALG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ALGOEORI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ALG_SkinTestOEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALG_RowID</SqlRowIdName>
<StreamLocation>^User.PAAllergyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
