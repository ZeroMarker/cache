/// Admission Source          (ADSOU,5)
Class User.PACAdmSource Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_AdmSource, StorageStrategy = SQLStorage ]
{

Relationship ChildPACAdmSourceDet As PACAdmSourceDet [ Cardinality = children, Inverse = DETParRef ];

/// Admission Source Code
Property ADSOUCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ADSOU_Code ];

/// Admission Source Description
Property ADSOUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ADSOU_Desc ];

/// Archived Flag
Property ADSOURcFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ADSOU_RcFlag ];

/// Date From
Property ADSOUDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = ADSOU_DateFrom ];

/// Date To
Property ADSOUDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = ADSOU_DateTo ];

/// National Code
Property ADSOUNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = ADSOU_NationalCode ];

/// Episode Type
Property ADSOUEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ADSOU_EpisodeType ];

/// Reason For Crit Care Transfer
Property ADSOUReasonForCritCareTransfer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = ADSOU_ReasonForCritCareTransfer ];

/// InpatAdmType
Property ADSOUInpatAdmType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ADSOU_InpatAdmType ];

/// Transfer Source
Property ADSOUTransferSource As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = ADSOU_TransferSource ];

/// AdmReason
Property ADSOUAdmReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ADSOU_AdmReason ];

/// CareType
Property ADSOUCareType As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = ADSOU_CareType ];

/// Age From
Property ADSOUAgeFrom As %Float [ SqlColumnNumber = 14, SqlFieldName = ADSOU_AgeFrom ];

/// Age To
Property ADSOUAgeTo As %Float [ SqlColumnNumber = 15, SqlFieldName = ADSOU_AgeTo ];

/// IntentReadmit
Property ADSOUIntentReadmit As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = ADSOU_IntentReadmit ];

/// AgeType
Property ADSOUAgeType As %String(DISPLAYLIST = ",Month,Day,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",M,D,Y") [ SqlColumnNumber = 17, SqlFieldName = ADSOU_AgeType ];

/// Qualification Status CT codes
Property ADSOUQualificationStatus As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = ADSOU_QualificationStatus ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACAdmSource).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmSource","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACAdmSource).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmSource","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACAdmSource).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmSource","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACAdmSource).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmSource","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACAdmSource).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACAdmSource","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("ADSOU",0))</SqlIdExpression>
<SQLMap name="DataMasterMapADSOU">
<Data name="ADSOU_AdmReason">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="ADSOU_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="ADSOU_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="ADSOU_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="ADSOU_CareType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="ADSOU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADSOU_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADSOU_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADSOU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADSOU_EpisodeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ADSOU_InpatAdmType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="ADSOU_IntentReadmit">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="ADSOU_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADSOU_QualificationStatus">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="ADSOU_RcFlag">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADSOU_ReasonForCritCareTransfer">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADSOU_TransferSource">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ADSOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADSOU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{ADSOU_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADSOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADSOU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ADSOU_Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ADSOU_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ADSOU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ADSOU_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADSOU"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"ADSOU_Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({ADSOU_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{ADSOU_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADSOU_RowId</SqlRowIdName>
<StreamLocation>^User.PACAdmSourceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
