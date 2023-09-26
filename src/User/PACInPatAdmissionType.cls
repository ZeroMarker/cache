/// InPatAdmissionType(2060)
Class User.PACInPatAdmissionType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_InPatAdmissionType, StorageStrategy = SQLStorage ]
{

Relationship ChildPACInPatAdmTypePayor As PACInPatAdmTypePayor [ Cardinality = children, Inverse = INSParRef ];

Relationship ChildPACInPatAdmTypeSNAPCare As PACInPatAdmTypeSNAPCare [ Cardinality = children, Inverse = SNAPParRef ];

Relationship ChildPACInPatAdmTypeDet As PACInPatAdmTypeDet [ Cardinality = children, Inverse = DETParRef ];

/// Code
Property IPATCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = IPAT_Code ];

/// Description
Property IPATDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = IPAT_Desc ];

/// Date From
Property IPATDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = IPAT_DateFrom ];

/// Date To
Property IPATDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = IPAT_DateTo ];

/// National Code
Property IPATNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = IPAT_NationalCode ];

/// AdmSource
Property IPATAdmSource As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = IPAT_AdmSource ];

/// AdmReason
Property IPATAdmReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = IPAT_AdmReason ];

/// Age From
Property IPATAgeFrom As %Float [ SqlColumnNumber = 9, SqlFieldName = IPAT_AgeFrom ];

/// Age To
Property IPATAgeTo As %Float [ SqlColumnNumber = 10, SqlFieldName = IPAT_AgeTo ];

/// AgeType
Property IPATAgeType As %String(DISPLAYLIST = ",Month,Day,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",M,D,Y") [ SqlColumnNumber = 11, SqlFieldName = IPAT_AgeType ];

/// Sex
Property IPATSex As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = IPAT_Sex ];

/// Age1From
Property IPATAge1From As %Float [ SqlColumnNumber = 13, SqlFieldName = IPAT_Age1From ];

/// Age1To
Property IPATAge1To As %Float [ SqlColumnNumber = 14, SqlFieldName = IPAT_Age1To ];

/// Age1 Type
Property IPATAge1Type As %String(DISPLAYLIST = ",Days,Month,Year", MAXLEN = 5, TRUNCATE = 1, VALUELIST = ",D,M,Y") [ SqlColumnNumber = 15, SqlFieldName = IPAT_Age1Type ];

/// Des Ref CategType
Property IPATCategTypeDR As PACAdmTypeCategory [ SqlColumnNumber = 16, SqlFieldName = IPAT_CategType_DR ];

/// Qualification Status codes
Property IPATQualificationStatus As %String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = IPAT_QualificationStatus ];

/// ICD Edit
Property IPATICDEdit As %String(DISPLAYLIST = ",Rehabilitation,Palliative Care,Boarder", MAXLEN = 15, TRUNCATE = 1, VALUELIST = ",R,P,B") [ SqlColumnNumber = 19, SqlFieldName = IPAT_ICD_Edit ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmissionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmissionType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmissionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmissionType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACInPatAdmissionType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmissionType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACInPatAdmissionType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmissionType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACInPatAdmissionType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACInPatAdmissionType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("IPAT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="IPAT_AdmReason">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="IPAT_AdmSource">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="IPAT_Age1From">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="IPAT_Age1To">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="IPAT_Age1Type">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="IPAT_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="IPAT_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="IPAT_AgeType">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="IPAT_CategType_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="IPAT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="IPAT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="IPAT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="IPAT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="IPAT_ICD_Edit">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="IPAT_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="IPAT_QualificationStatus">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="IPAT_Sex">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>IPAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{IPAT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IPAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({IPAT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IPAT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IPAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({IPAT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IPAT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>IPAT_RowId</SqlRowIdName>
<StreamLocation>^User.PACInPatAdmissionTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
