/// PA Mother(1319)
Class User.PAMother Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Mother, StorageStrategy = SQLStorage ]
{

Relationship ChildPAMotherPrenProblem As PAMotherPrenProblem [ Cardinality = children, Inverse = PREPParRef ];

/// Number of Artificial Abortions
Property MOTHArtifAbort As %Float [ SqlColumnNumber = 8, SqlFieldName = MOTH_ArtifAbort ];

/// BreastFeed
Property MOTHBreastFeed As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = MOTH_BreastFeed ];

/// Certainty Of Gestation based on LMP
Property MOTHCertOfGestationLMP As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = MOTH_CertOfGestationLMP ];

/// Des Ref PregnConsDegree
Property MOTHConsDegreeDR As PACPregnConsultDegree [ SqlColumnNumber = 13, SqlFieldName = MOTH_ConsDegree_DR ];

/// Date of last Menstr Period
Property MOTHDateLMP As %Date [ SqlColumnNumber = 2, SqlFieldName = MOTH_DateLMP ];

/// Expected Date of Confinement(EDC)
Property MOTHExpConfinDate As %Date [ SqlColumnNumber = 4, SqlFieldName = MOTH_ExpConfinDate ];

/// Expected Delivery Date
Property MOTHExpDelivDate As %Date [ SqlColumnNumber = 3, SqlComputeCode = { i {MOTH_DateLMP}="" s {MOTH_ExpDelivDate}="" q
 s {MOTH_ExpDelivDate}={MOTH_DateLMP}+280
}, SqlComputed, SqlFieldName = MOTH_ExpDelivDate, Transient ];

/// Des Ref Blood Type
Property MOTHFatherBldTypeDR As PACBloodType [ SqlColumnNumber = 15, SqlFieldName = MOTH_FatherBldType_DR ];

/// Number of Female Babies
Property MOTHFemaleBabies As %Float [ SqlColumnNumber = 10, SqlFieldName = MOTH_FemaleBabies ];

/// Final Weight
Property MOTHFinalWeight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = MOTH_FinalWeight ];

/// Number of Full Term Delivery
Property MOTHFullTermDel As %Float [ SqlColumnNumber = 5, SqlFieldName = MOTH_FullTermDel ];

/// Initial Weight
Property MOTHInitialWeight As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = MOTH_InitialWeight ];

/// Last Consultation Date
Property MOTHLastConsDate As %Date [ SqlColumnNumber = 14, SqlFieldName = MOTH_LastConsDate ];

/// Last Delivery Date
Property MOTHLastDelivDate As %Date [ SqlColumnNumber = 11, SqlFieldName = MOTH_LastDelivDate ];

/// Last Delivery METHOD(Des Ref )
Property MOTHLastDelivType As PACDeliveryMethod [ SqlColumnNumber = 12, SqlFieldName = MOTH_LastDelivType ];

/// Number of Male Babies
Property MOTHMaleBabies As %Float [ SqlColumnNumber = 9, SqlFieldName = MOTH_MaleBabies ];

/// Des Ref Blood Type
Property MOTHMotherBldTypeDR As PACBloodType [ SqlColumnNumber = 16, SqlFieldName = MOTH_MotherBldType_DR ];

/// No Of Prev Admissions
Property MOTHNoOfPrevAdmissions As %Float [ SqlColumnNumber = 23, SqlFieldName = MOTH_NoOfPrevAdmissions ];

/// Number of Pre Term Delivery
Property MOTHPreTermDeliv As %Float [ SqlColumnNumber = 6, SqlFieldName = MOTH_PreTermDeliv ];

/// Des Ref PregnancyType
Property MOTHPregnancyTypeDR As PACPregnancyType [ SqlColumnNumber = 22, SqlFieldName = MOTH_PregnancyType_DR ];

/// Prev Caesarean Sections
Property MOTHPrevCaesareanSections As %Float [ SqlColumnNumber = 26, SqlFieldName = MOTH_PrevCaesareanSections ];

/// Prev Neonatal Deaths
Property MOTHPrevNeonatalDeaths As %Float [ SqlColumnNumber = 28, SqlFieldName = MOTH_PrevNeonatalDeaths ];

/// Prev Still Births
Property MOTHPrevStillBirths As %Float [ SqlColumnNumber = 27, SqlFieldName = MOTH_PrevStillBirths ];

/// Remarks
Property MOTHRemarks As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = MOTH_Remarks, SqlListType = SUBNODE ];

/// Number of Spontaneous Abortions
Property MOTHSpontAbort As %Float [ SqlColumnNumber = 7, SqlFieldName = MOTH_SpontAbort ];

/// Steril After Delivery
Property MOTHSterilAfterDelivery As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 25, SqlFieldName = MOTH_SterilAfterDelivery ];

Parameter EXTENTSIZE = 40;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMother","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMother","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAMother).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMother","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAMother).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMother","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAMother).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAMother","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>40</ExtentSize>
<Property name="MOTHArtifAbort">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHBreastFeed">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOTHCertOfGestationLMP">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="MOTHConsDegreeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHDateLMP">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHExpConfinDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHExpDelivDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFatherBldTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFemaleBabies">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFinalWeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHFullTermDel">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHInitialWeight">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHLastConsDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHLastDelivDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHLastDelivType">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHMaleBabies">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHMotherBldTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHNoOfPrevAdmissions">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPreTermDeliv">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPregnancyTypeDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevCaesareanSections">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevNeonatalDeaths">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHPrevStillBirths">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHRemarks">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHSpontAbort">
<Selectivity>1</Selectivity>
</Property>
<Property name="MOTHSterilAfterDelivery">
<Selectivity>33.3333%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAMTH(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="MOTH_ArtifAbort">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="MOTH_BreastFeed">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="MOTH_CertOfGestationLMP">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="MOTH_ConsDegree_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="MOTH_DateLMP">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="MOTH_ExpConfinDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="MOTH_ExpDelivDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="MOTH_FatherBldType_DR">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="MOTH_FemaleBabies">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="MOTH_FinalWeight">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="MOTH_FullTermDel">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="MOTH_InitialWeight">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="MOTH_LastConsDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="MOTH_LastDelivDate">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="MOTH_LastDelivType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="MOTH_MaleBabies">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="MOTH_MotherBldType_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="MOTH_NoOfPrevAdmissions">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="MOTH_PreTermDeliv">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="MOTH_PregnancyType_DR">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MOTH_PrevCaesareanSections">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="MOTH_PrevNeonatalDeaths">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="MOTH_PrevStillBirths">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="MOTH_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="MOTH_SpontAbort">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="MOTH_SterilAfterDelivery">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Global>^PAMTH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MOTH_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MOTH_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MOTH_RowId</SqlRowIdName>
<StreamLocation>^User.PAMotherS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
