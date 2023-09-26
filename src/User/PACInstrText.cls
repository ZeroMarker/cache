/// PAC Instructional Text(2044)
Class User.PACInstrText Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_InstrText, StorageStrategy = SQLStorage ]
{

/// Code
Property INTXCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INTX_Code ];

/// Description
Property INTXDesc As list Of %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INTX_Desc, SqlListType = subnode ];

/// Des Ref Module
Property INTXModuleDR As PACModule [ SqlColumnNumber = 4, SqlFieldName = INTX_Module_DR ];

/// Paragraph
Property INTXParagraph As %Float [ SqlColumnNumber = 5, SqlFieldName = INTX_Paragraph ];

/// Des Ref Trust
Property INTXTrustDR As PACTrust [ SqlColumnNumber = 6, SqlFieldName = INTX_Trust_DR ];

/// Des Ref Hospital
Property INTXHospitalDR As CTHospital [ SqlColumnNumber = 7, SqlFieldName = INTX_Hospital_DR ];

/// Des Ref CTLOC
Property INTXModuleLocationDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = INTX_ModuleLocation_DR ];

/// Des Ref SpecialityLocation
Property INTXSpecialityLocationDR As CTLoc [ SqlColumnNumber = 9, SqlFieldName = INTX_SpecialityLocation_DR ];

/// Des Ref EpisodeSubtype
Property INTXEpisodeSubtypeDR As PACEpisodeSubType [ SqlColumnNumber = 10, SqlFieldName = INTX_EpisodeSubtype_DR ];

/// Des Ref ARCIM
Property INTXARCIMDR As ARCItmMast [ SqlColumnNumber = 11, SqlFieldName = INTX_ARCIM_DR ];

/// Health Care Provider des ref
Property INTXHCPDR As CTCareProv [ SqlColumnNumber = 12, SqlFieldName = INTX_HCP_DR ];

/// Letter Type Des Ref
Property INTXLetterTypeDR As PACLetterType [ SqlColumnNumber = 13, SqlFieldName = INTX_LetterTypeDR ];

/// Des REf StatePPP
Property INTXStatePPPDR As PACStatePPP [ SqlColumnNumber = 14, SqlFieldName = INTX_StatePPP_DR ];

/// Des Ref ItemCat
Property INTXItemCatDR As ARCItemCat [ SqlColumnNumber = 15, SqlFieldName = INTX_ItemCat_DR ];

/// Des Ref InsType
Property INTXInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 16, SqlFieldName = INTX_InsType_DR ];

/// Des Ref SundryDebtor
Property INTXSundryDebtorDR As ARCSundryDebtor [ SqlColumnNumber = 17, SqlFieldName = INTX_SundryDebtor_DR ];

/// Des Ref RefPrior
Property INTXRefPriorDR As PACReferralPriority [ SqlColumnNumber = 18, SqlFieldName = INTX_RefPrior_DR ];

/// Des Ref RefStatus
Property INTXRefStatusDR As PACReferralStatus [ SqlColumnNumber = 19, SqlFieldName = INTX_RefStatus_DR ];

/// Des Ref ReasonForRemoval
Property INTXReasonForRemovalDR As PACWLReasonNotAvail [ SqlColumnNumber = 20, SqlFieldName = INTX_ReasonForRemoval_DR ];

/// ReportCode
Property INTXReportCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = INTX_ReportCode ];

/// Des Ref WLTypeOfOffer
Property INTXWLTypeOfOfferDR As PACWLTypeOfOffers [ SqlColumnNumber = 22, SqlFieldName = INTX_WLTypeOfOffer_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACInstrText).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACInstrText).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACInstrText).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACInstrText).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACInstrText).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInstrText","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>13</ExtentSize>
<Property name="INTXARCIMDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTXDesc">
<Selectivity>16.6667%</Selectivity>
</Property>
<Property name="INTXEpisodeSubtypeDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXHCPDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTXHospitalDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTXInsTypeDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTXItemCatDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXLetterTypeDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INTXModuleDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTXModuleLocationDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTXParagraph">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTXReasonForRemovalDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTXRefPriorDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXRefStatusDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXReportCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="INTXSpecialityLocationDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INTXStatePPPDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="INTXSundryDebtorDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXTrustDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INTXWLTypeOfOfferDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("INTX",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="INTX_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTX_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTX_Desc">
<Node>"TXT"</Node>
</Data>
<Data name="INTX_EpisodeSubtype_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTX_HCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTX_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTX_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INTX_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INTX_LetterTypeDR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTX_ModuleLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTX_Module_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTX_Paragraph">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTX_ReasonForRemoval_DR">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INTX_RefPrior_DR">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INTX_RefStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INTX_ReportCode">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INTX_SpecialityLocation_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTX_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INTX_SundryDebtor_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INTX_Trust_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTX_WLTypeOfOffer_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{INTX_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCareProv">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CareProv"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_HCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INTX_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisSubType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"EpisSubType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_EpisodeSubtype_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Hospital_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexItemCat">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ItemCat"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_ItemCat_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLetterType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_LetterTypeDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModule">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Module"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Module_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>+{INTX_Paragraph}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModule1">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Mod1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Module_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModuleLetterType">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ModLT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Module_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_LetterTypeDR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexModuleLoc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ModLoc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_ModuleLocation_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexParagraph">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Parag"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Paragraph}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRepCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RepCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INTX_ReportCode})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSpecLoc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SpecLoc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_SpecialityLocation_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTrust">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTX_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INTX"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Trust"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTX_Trust_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTX_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INTX_RowId</SqlRowIdName>
<StreamLocation>^User.PACInstrTextS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
