/// PAC Separation Referral(1794)
Class User.PACSeparationReferral Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_SeparationReferral, StorageStrategy = SQLStorage ]
{

Relationship ChildPACSeparationReferralDet As PACSeparationReferralDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property SEPREFCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SEPREF_Code ];

/// Description
Property SEPREFDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SEPREF_Desc ];

/// Date From
Property SEPREFDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = SEPREF_DateFrom ];

/// Date To
Property SEPREFDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = SEPREF_DateTo ];

/// Default
Property SEPREFDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = SEPREF_Default ];

/// National Code
Property SEPREFNationCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = SEPREF_NationCode ];

/// Discharge Type codes
Property SEPREFDischargeType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = SEPREF_DischargeType ];

/// Care Type Codes
Property SEPREFCareType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = SEPREF_CareType ];

/// ACAS Status codes
Property SEPREFACASStatus As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = SEPREF_ACASStatus ];

/// Sex codes
Property SEPREFSex As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = SEPREF_Sex ];

/// Age From
Property SEPREFAgeFrom As %Float [ SqlColumnNumber = 12, SqlFieldName = SEPREF_AgeFrom ];

/// Age To
Property SEPREFAgeTo As %Float [ SqlColumnNumber = 13, SqlFieldName = SEPREF_AgeTo ];

/// Age Type
Property SEPREFAgeType As %String(DISPLAYLIST = ",Month,Day,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",M,D,Y") [ SqlColumnNumber = 14, SqlFieldName = SEPREF_AgeType ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACSeparationReferral).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSeparationReferral","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACSeparationReferral).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSeparationReferral","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACSeparationReferral).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSeparationReferral","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACSeparationReferral).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSeparationReferral","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACSeparationReferral).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACSeparationReferral","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("SEPREF",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SEPREF_ACASStatus">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="SEPREF_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="SEPREF_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="SEPREF_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="SEPREF_CareType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="SEPREF_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SEPREF_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SEPREF_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SEPREF_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="SEPREF_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SEPREF_DischargeType">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="SEPREF_NationCode">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="SEPREF_Sex">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SEPREF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SEPREF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SEPREF_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SEPREF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SEPREF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SEPREF_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SEPREF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>SEPREF_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SEPREF"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({SEPREF_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{SEPREF_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SEPREF_RowId</SqlRowIdName>
<StreamLocation>^User.PACSeparationReferralS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
