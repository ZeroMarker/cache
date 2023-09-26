/// PAC Care Type(1798)
Class User.PACCareType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_CareType, StorageStrategy = SQLStorage ]
{

Relationship ChildPACCareTypeDet As PACCareTypeDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property CARETYPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CARETYP_Code ];

/// Description
Property CARETYPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CARETYP_Desc ];

/// Date From
Property CARETYPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CARETYP_DateFrom ];

/// Date To
Property CARETYPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CARETYP_DateTo ];

/// Default
Property CARETYPDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = CARETYP_Default ];

/// National Code
Property CARETYPNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CARETYP_NationCode ];

/// CarerAvail
Property CARETYPCarerAvail As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = CARETYP_CarerAvail ];

/// FundingSource
Property CARETYPFundingSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CARETYP_FundingSource ];

/// AdmSource
Property CARETYPAdmSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CARETYP_AdmSource ];

/// InsType
Property CARETYPInsType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CARETYP_InsType ];

/// MedicareSuffix
Property CARETYPMedicareSuffix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CARETYP_MedicareSuffix ];

/// Age From
Property CARETYPAgeFrom As %Float [ SqlColumnNumber = 13, SqlFieldName = CARETYP_AgeFrom ];

/// Age To
Property CARETYPAgeTo As %Float [ SqlColumnNumber = 14, SqlFieldName = CARETYP_AgeTo ];

/// Age Type
Property CARETYPAgeType As %String(DISPLAYLIST = ",Month,Day,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",M,D,Y") [ SqlColumnNumber = 15, SqlFieldName = CARETYP_AgeType ];

/// Discharge Type codes
Property CARETYPDischargeType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = CARETYP_DischargeType ];

/// ICD Edit
Property CARETYPICDEdit As %String(DISPLAYLIST = ",Rehabilitation,Palliative Care,Boarder", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",R,P,B") [ SqlColumnNumber = 17, SqlFieldName = CARETYP_ICDEdit ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCareType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCareType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACCareType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCareType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCareType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACCareType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACCareType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("CARETYP",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CARETYP_AdmSource">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CARETYP_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CARETYP_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CARETYP_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CARETYP_CarerAvail">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CARETYP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CARETYP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CARETYP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CARETYP_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CARETYP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CARETYP_DischargeType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CARETYP_FundingSource">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CARETYP_ICDEdit">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CARETYP_InsType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CARETYP_MedicareSuffix">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CARETYP_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CARETYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARETYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CARETYP_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CARETYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARETYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CARETYP_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CARETYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CARETYP_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CARETYP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CARETYP_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CARETYP_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CARETYP_RowId</SqlRowIdName>
<StreamLocation>^User.PACCareTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
