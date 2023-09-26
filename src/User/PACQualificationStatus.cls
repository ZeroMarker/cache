/// QualificationStatus(2205)
Class User.PACQualificationStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_QualificationStatus, StorageStrategy = SQLStorage ]
{

Relationship ChildPACQualificationStatusDet As PACQualificationStatusDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property QUALCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = QUAL_Code ];

/// Description
Property QUALDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = QUAL_Desc ];

/// DateFrom
Property QUALDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = QUAL_DateFrom ];

/// DateTo
Property QUALDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = QUAL_DateTo ];

/// NationalCode
Property QUALNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = QUAL_NationalCode ];

/// AdmReason
Property QUALAdmReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = QUAL_AdmReason ];

/// Age From
Property QUALAgeFrom As %Float [ SqlColumnNumber = 8, SqlFieldName = QUAL_AgeFrom ];

/// Age To
Property QUALAgeTo As %Float [ SqlColumnNumber = 9, SqlFieldName = QUAL_AgeTo ];

/// Age Type
Property QUALAgeType As %String(DISPLAYLIST = ",Day,Month,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 10, SqlFieldName = QUAL_AgeType ];

/// Source of Admission codes
Property QUALSourceOfAdmission As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = QUAL_SourceOfAdmission ];

/// InPat Admission Type codes
Property QUALInPatAdmType As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = QUAL_InPatAdmType ];

/// Criteria for Admission codes
Property QUALCriteriaForAdm As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = QUAL_CriteriaForAdm ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACQualificationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQualificationStatus","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACQualificationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQualificationStatus","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACQualificationStatus).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQualificationStatus","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACQualificationStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQualificationStatus","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACQualificationStatus).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQualificationStatus","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("QUAL",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="QUAL_AdmReason">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QUAL_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QUAL_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QUAL_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="QUAL_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QUAL_CriteriaForAdm">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="QUAL_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUAL_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUAL_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUAL_InPatAdmType">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="QUAL_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QUAL_SourceOfAdmission">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QUAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QUAL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QUAL_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUAL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUAL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QUAL_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUAL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QUAL_RowId</SqlRowIdName>
<StreamLocation>^User.PACQualificationStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
